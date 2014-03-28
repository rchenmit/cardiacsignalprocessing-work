%% calculate signals for all of the scenarios recorded

%% change the path and load the data
load_data_path; 

%% processed data

struct_this_subject_data_processed = {};
struct_this_subject_data_processed.scenario_names = {};

%loop thru loaded data
for i = 1:length(struct_this_subject_data.scenario_names)
    this_scenario_name = struct_this_subject_data.scenario_names{i};
    ecgEcho = struct_this_subject_data.echo_ecg.data{i};
    bmodeEcho = struct_this_subject_data.echo_ecg.data{i};
    [stIdx enIdx] = synchDeviceWithEcho(ecgHW_exam, ecgEcho); %sync device and find start and stop index
    cycles_ecgHW = getCyclesFromEcg(ecgHW_exam); %cycles
    corrMtx = getDevMtxFromBmode(bmodeEcho);
    deviation = getDeviationFromDevMtx(corrMtx, 4);
    ecgHW_EA = ensemble_average(ecgHW_exam);
    scgSt_EA = ensemble_average(scgSt_exam);
    scgPmi_EA = ensemble_average(scgPmi_exam);
end

