%% calculate signals for all of the scenarios recorded

%% processed data

struct_this_subject_data_processed = {};
struct_this_subject_data_processed.scenario_names = struct_this_subject_data.scenario_names;
struct_this_subject_data_processed.deviation = {};
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
%loop thru loaded data
for i = 1:length(struct_this_subject_data.scenario_names)
    bmodeEcho = struct_this_subject_data.echo_bmode.data{i};
    corrMtx = getDevMtxFromBmode(bmodeEcho);
    deviation = getDeviationFromDevMtx(corrMtx, 4);
    struct_this_subject_data_processed.deviation{i} = deviation;
end

for i =  1:length(struct_this_subject_data.scenario_names)
    deviation =  struct_this_subject_data_processed.deviation{i};
    deviation_sample_rate = 200; %200 Hz
    deviation_peaks = getCyclesFromEcg(deviation, deviation_sample_rate, .15);
    dev_peak_startIndexes = deviation_peaks(:,1);
    deviation_EA = ensemble_average(deviation, dev_peak_startIndexes, 50, 0.7);
    struct_this_subject_data_processed.deviation_EA{i} = deviation_EA;
end

for i = 1:length(struct_this_subject_data.scenario_names)
    this_scenario_name = struct_this_subject_data.scenario_names{i};
    ecgEcho = struct_this_subject_data.echo_ecg.data{i};
    [stIdx enIdx] = synchDeviceWithEcho(ecgHW_exam, ecgEcho); %sync device and find start and stop index
    cycles_ecgHW = getCyclesFromEcg(ecgHW_exam); %cycles
    cycles_start_indexes = cycles_ecgHW(:,1);
    ecgHW_EA = ensemble_average(ecgHW_exam, cycles_start_indexes, 1200, 0.7);%sample 700ms at 1200Hz
    scgSt_EA = ensemble_average(scgSt_exam, cycles_start_indexes, 1200, 0.7);
    scgPmi_EA = ensemble_average(scgPmi_exam, cycles_start_indexes, 1200, 0.7);
    %condition signals
    %%%do this on ecgEcho as well!
    cond_ecgHW_EA = conditionDeviceEcg(ecgHW_EA);
    cond_scgSt_EA = conditionDeviceScg(scgSt_EA);
    cond_scgPmi_EA = conditionDeviceScg(scgPmi_EA);
    % find the velocity from the acceleration (SCG)
    kalm_scgSt = kalm(cond_scgSt_EA);
    kalm_scgPmi = kalm(cond_scgPmi_EA);
    scgSt_position = kalm_scgSt(1,:);
    scgSt_velocity = kalm_scgSt(2,:);
    scgPmi_position = kalm_scgPmi(1,:);
    scgPmi_velocity = kalm_scgPmi(2,:);   
    %add to struct
    struct_this_subject_data_processed.ecgHW_EA{i} = ecgHW_EA;
    struct_this_subject_data_processed.scgSt_EA{i}=scgSt_EA;
    struct_this_subject_data_processed.scgPmi_EA{i}=scgPmi_EA;
    struct_this_subject_data_processed.cond_ecgHW_EA{i}=cond_ecgHW_EA;
    struct_this_subject_data_processed.cond_scgSt_EA{i}=cond_scgSt_EA;
    struct_this_subject_data_processed.cond_scgPmi_EA{i}=cond_scgPmi_EA;
    struct_this_subject_data_processed.kalm_scgSt{i}=kalm_scgSt;
    struct_this_subject_data_processed.kalm_scgPmi{i}=kalm_scgPmi;
    struct_this_subject_data_processed.scgSt_position{i}=scgSt_position;
    struct_this_subject_data_processed.scgSt_velocity{i}=scgSt_velocity;
    struct_this_subject_data_processed.scgPmi_position{i}=scgPmi_position;
    struct_this_subject_data_processed.scgPmi_velocity{i}=scgPmi_velocity;
end
