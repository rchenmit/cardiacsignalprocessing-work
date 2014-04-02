%% calculate signals for all of the scenarios recorded

%%
ecg_samp_seconds_forward = 0.7;
ecg_samp_seconds_backward = 0.3;
dev_samp_seconds_forward = ecg_samp_seconds_forward;
dev_samp_seconds_backward = ecg_samp_seconds_forward + ecg_samp_seconds_backward;

%% processed data

struct_this_subject_data_processed = {};
struct_this_subject_data_processed.scenario_names = struct_this_subject_data.scenario_names;
struct_this_subject_data_processed.deviation = {};
struct_this_subject_data_processed.deviation_peak_startIndexes = {};
struct_this_subject_data_processed.deviation_EA = {};
struct_this_subject_data_processed.ecgHW_EA = {};
struct_this_subject_data_processed.cond_ecgEcho = {};
struct_this_subject_data_processed.scgSt_EA = {};
struct_this_subject_data_processed.scgPmi_EA = {};
struct_this_subject_data_processed.cond_ecgHW_EA = {};
struct_this_subject_data_processed.cond_scgSt_EA = {};
struct_this_subject_data_processed.cond_scgPmi_EA = {};
struct_this_subject_data_processed.kalm_scgSt = {};
struct_this_subject_data_processed.kalm_scgPmi = {};
struct_this_subject_data_processed.scgSt_position = {};
struct_this_subject_data_processed.scgSt_velocity = {};
struct_this_subject_data_processed.scgPmi_position = {};
struct_this_subject_data_processed.scgPmi_velocity = {};

%loop thru loaded data, get Dev matrix
for j = 1:length(struct_this_subject_data.scenario_names)
    bmodeEcho = struct_this_subject_data.echo_bmode.data{j};
    corrMtx = getDevMtxFromBmode(bmodeEcho);
    deviation = getDeviationFromDevMtx(corrMtx, 4);
    struct_this_subject_data_processed.deviation{j} = deviation;
end

%% calculate cycles from dev matrix
for j =  1:length(struct_this_subject_data.scenario_names)
    deviation =  struct_this_subject_data_processed.deviation{j};
    deviation_sample_rate = 200; %200 Hz
    deviation_peaks = getCyclesFromEcg(deviation, deviation_sample_rate, .15);
    dev_peak_startIndexes = deviation_peaks(:,2);
    struct_this_subject_data_processed.deviation_peak_startIndexes{j} = dev_peak_startIndexes;
    deviation_EA = ensemble_average(deviation, dev_peak_startIndexes, 50, dev_samp_seconds_backward, dev_samp_seconds_forward);%sample at .5 seconds before to .7 after the peak
    struct_this_subject_data_processed.deviation_EA{j} = deviation_EA;
end

%% loop thru scenarios and process data for calculating ecgHW peaks, integrations to find velocity/position
for j = 1:length(struct_this_subject_data.scenario_names)
    this_scenario_name = struct_this_subject_data.scenario_names{j};
    ecgEcho = struct_this_subject_data.echo_ecg.data{j};
    %sync device
    [stIdx enIdx] = synchDeviceWithEcho(ecgHW_exam, ecgEcho); %sync device and find start and stop index
    hwSampleLength = 12000;%echo is 10 seconds @200Hz; for HW we need 10 seconds at 1200Hz, which is 12000 frames
    cycles_ecgHW = getCyclesFromEcg(ecgHW_exam(enIdx-hwSampleLength+1:enIdx)); %cycles
    cycles_ecgHW_start_indexes = cycles_ecgHW(:,2);  
    ecgHW_EA = ensemble_average(signalMinusMean(ecgHW_exam(enIdx-hwSampleLength+1:enIdx)), cycles_ecgHW_start_indexes, 1200, ecg_samp_seconds_backward, ecg_samp_seconds_forward);%sample from 100ms before to 700ms after the peak, at 1200Hz
    scgSt_EA = ensemble_average(signalMinusMean(scgSt_exam(enIdx-hwSampleLength+1:enIdx)), cycles_ecgHW_start_indexes, 1200, ecg_samp_seconds_backward, ecg_samp_seconds_forward);
    scgPmi_EA = ensemble_average(signalMinusMean(scgPmi_exam(enIdx-hwSampleLength+1:enIdx)), cycles_ecgHW_start_indexes, 1200, ecg_samp_seconds_backward, ecg_samp_seconds_forward);
   
    %loop thru the peaks in deviation, and find the delay between THAT
    %DEVIATION PEAK and the ecgHW PEAK that comes right BEFORE IT
    cycles_echoDev_startIndexes = struct_this_subject_data_processed.deviation_peak_startIndexes{j};
    length_echoDeviation = length(struct_this_subject_data_processed.deviation{j});
    length_ecgEW = length(ecgHW_exam(enIdx-hwSampleLength+1:enIdx));
    shifts = [];
    for k = 1:length(cycles_echoDev_startIndexes)
        ind_this_echoDev_peak = cycles_echoDev_startIndexes(length(cycles_echoDev_startIndexes)+1-k );%start with the LAST entry in cycles_ecgEcho_startIndexes
        echoSampRate = 50; %echo sampling rate is 50 Hz
        echoDev_time_from_end = (length_echoDeviation-ind_this_echoDev_peak)/echoSampRate;%seconds = num frames/ sample_rtae
        
        if length(cycles_ecgHW_start_indexes)+1-k > 0
            ind_ecgHW_peak_before_this_ecgEcho_peak = cycles_ecgHW_start_indexes(length(cycles_ecgHW_start_indexes)+1-k );
            ecgHWsampRate = 1200;
            ecgHW_time_from_end = (length_ecgEW-ind_ecgHW_peak_before_this_ecgEcho_peak) / ecgHWsampRate; %seconds = num frames / sample_rate
            this_shift = ecgHW_time_from_end-echoDev_time_from_end;

            if this_shift > 0 
                shifts = [shifts, this_shift];
            elseif length(cycles_ecgHW_start_indexes)+1-k -1 > 0 %then consider the ecgHW peak before this one
                ind_ecgHW_peak_before_this_ecgEcho_peak = cycles_ecgHW_start_indexes(length(cycles_ecgHW_start_indexes)+1-k -1);
                ecgHW_time_from_end = (length_ecgEW-ind_ecgHW_peak_before_this_ecgEcho_peak) / ecgHWsampRate; %seconds = num frames / sample_rate
                this_shift = ecgHW_time_from_end-echoDev_time_from_end;
                shifts = [shifts, this_shift];
            end
        end
    end
    avg_shift_echoDev = mean(shifts);
    
    numSec_before_echoDev_peak_to_start_sample = avg_shift_echoDev + ecg_samp_seconds_backward;
    numFrames_before_echoDev_peak_to_start_sample = ceil(numSec_before_echoDev_peak_to_start_sample * echoSampRate);
    frame_deviation_EA_peak = ceil(dev_samp_seconds_backward*echoSampRate);
    numSec_after_echoDev_peak_to_sample = .7-avg_shift_echoDev; %in order to sample 700 ms after the ecgHW peak
    numFrames_after_echoDev_peak_to_sample = ceil(numSec_after_echoDev_peak_to_sample * echoSampRate);
    echoDev_samp_start = frame_deviation_EA_peak-numFrames_before_echoDev_peak_to_start_sample;
    echoDev_samp_end = frame_deviation_EA_peak+numFrames_after_echoDev_peak_to_sample; 
    echoDev_linedup = struct_this_subject_data_processed.deviation_EA{j}(echoDev_samp_start:echoDev_samp_end);
    %condition signals
    %%%do this on ecgEcho as well!
    cond_ecgHW_EA = conditionDeviceEcg(ecgHW_EA);
    cond_scgSt_EA = conditionDeviceScg(scgSt_EA);
    cond_scgPmi_EA = conditionDeviceScg(scgPmi_EA);
    
    %%INTEGRATE: find the velocity from the acceleration (SCG)
    kalm_scgSt = kalm(cond_scgSt_EA);
    kalm_scgPmi = kalm(cond_scgPmi_EA);
    scgSt_position = kalm_scgSt(1,:)-mean( kalm_scgSt(1,:));
    scgSt_velocity = kalm_scgSt(2,:)-mean(kalm_scgSt(2,:));
    scgPmi_position = kalm_scgPmi(1,:)-mean(kalm_scgPmi(1,:));
    scgPmi_velocity = kalm_scgPmi(2,:)-mean(kalm_scgPmi(2,:));
    scgSt_position_cumtrapz_of_kalm = cumtrapz(scgSt_velocity);
    scgPmi_position_cumtrapz_of_kalm = cumtrapz(scgPmi_velocity);
    %add to struct
    struct_this_subject_data_processed.ecgHW_EA{j} = ecgHW_EA;
    struct_this_subject_data_processed.scgSt_EA{j}=scgSt_EA;
    struct_this_subject_data_processed.scgPmi_EA{j}=scgPmi_EA;
    struct_this_subject_data_processed.cond_ecgHW_EA{j}=cond_ecgHW_EA;
    struct_this_subject_data_processed.cond_scgSt_EA{j}=cond_scgSt_EA;
    struct_this_subject_data_processed.cond_scgPmi_EA{j}=cond_scgPmi_EA;
    struct_this_subject_data_processed.kalm_scgSt{j}=kalm_scgSt;
    struct_this_subject_data_processed.kalm_scgPmi{j}=kalm_scgPmi;
    struct_this_subject_data_processed.scgSt_position{j}=scgSt_position;
    struct_this_subject_data_processed.scgSt_velocity{j}=scgSt_velocity;
    struct_this_subject_data_processed.scgPmi_position{j}=scgPmi_position;
    struct_this_subject_data_processed.scgPmi_velocity{j}=scgPmi_velocity;
    struct_this_subject_data_processed.scgSt_position_cumtrapz_of_kalm{j} = scgSt_position_cumtrapz_of_kalm;
    struct_this_subject_data_processed.scgPmi_position_cumtrapz_of_kalm{j} = scgPmi_position_cumtrapz_of_kalm;
end

