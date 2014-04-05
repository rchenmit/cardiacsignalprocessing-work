%% isolate the interval for a heart sound
savedir = './output_figures_isolate_heart_sound/';
if ~exist(savedir, 'dir')
  mkdir(savedir);
end


%start with normal breathing
i=1;
this_scenario_name = struct_this_subject_data.scenario_names{i};
deviation_EA = struct_this_subject_data_processed.deviation_EA{i};
scgSt_velocity = struct_this_subject_data_processed.scgSt_velocity{i};
scgPmi_velocity = struct_this_subject_data_processed.scgPmi_velocity{i};
scgSt_position = struct_this_subject_data_processed.scgSt_position_cumtrapz_of_kalm{i};
scgPmi_position = struct_this_subject_data_processed.scgPmi_position_cumtrapz_of_kalm{i};
cond_ecgHW_EA = struct_this_subject_data_processed.cond_ecgHW_EA{i};
cond_scgSt_EA = struct_this_subject_data_processed.cond_scgSt_EA{i};
cond_scgPmi_EA = struct_this_subject_data_processed.cond_scgPmi_EA{i};

%% take abs of position and do a windowed average

%% take square of position and do a windowed average