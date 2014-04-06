%% isolate the interval for a heart sound
savedir = './output_figures_isolate_heart_sound/';
if ~exist(savedir, 'dir')
  mkdir(savedir);
end


%start with normal breathing
scenario_labels = {'AFC_NormBreath', 'AFC_BreathOutHold', 'AFC_Valsalva', 'AFC_Valsalva', 'PSLAX_NormBreath', 'PSLAX_BreathOutHold', 'AFC_Valsalva', 'AFC_Valsalva'};
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
abs_scgSt_position = abs(scgSt_position)';
abs_scgPmi_position = abs(scgPmi_position)';
cutoff = 4e4;
%SMA
tsmovavg_simple_50_abs_scgSt_position = tsmovavg(abs_scgSt_position, 's', 50, 1);
tsmovavg_simple_50_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 's', 50, 1);
tsmovavg_simple_100_abs_scgSt_position = tsmovavg(abs_scgSt_position, 's', 100, 1);
tsmovavg_simple_100_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 's', 100, 1);
tsmovavg_simple_200_abs_scgSt_position = tsmovavg(abs_scgSt_position, 's', 200, 1);
tsmovavg_simple_200_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 's', 200, 1);
tsmovavg_simple_300_abs_scgSt_position = tsmovavg(abs_scgSt_position, 's', 300, 1);
tsmovavg_simple_300_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 's', 300, 1);
tsmovavg_simple_50_abs_scgSt_position_quiescent = tsmovavg_simple_50_abs_scgSt_position<cutoff;
tsmovavg_simple_50_abs_scgPmi_position_quiescent = tsmovavg_simple_50_abs_scgPmi_position<cutoff;
tsmovavg_simple_100_abs_scgSt_position_quiescent = tsmovavg_simple_100_abs_scgSt_position<cutoff;
tsmovavg_simple_100_abs_scgPmi_position_quiescent = tsmovavg_simple_100_abs_scgPmi_position<cutoff;
tsmovavg_simple_200_abs_scgSt_position_quiescent = tsmovavg_simple_200_abs_scgSt_position<cutoff;
tsmovavg_simple_200_abs_scgPmi_position_quiescent = tsmovavg_simple_200_abs_scgPmi_position<cutoff;
tsmovavg_simple_300_abs_scgSt_position_quiescent = tsmovavg_simple_300_abs_scgSt_position<cutoff;
tsmovavg_simple_300_abs_scgPmi_position_quiescent = tsmovavg_simple_300_abs_scgPmi_position<cutoff;
%Exponential MA
tsmovavg_exp_50_abs_scgSt_position = tsmovavg(abs_scgSt_position, 'e', 50, 1);
tsmovavg_exp_50_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 'e', 50, 1);
tsmovavg_exp_100_abs_scgSt_position = tsmovavg(abs_scgSt_position, 'e', 100, 1);
tsmovavg_exp_100_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 'e', 100, 1);
tsmovavg_exp_200_abs_scgSt_position = tsmovavg(abs_scgSt_position, 'e', 200, 1);
tsmovavg_exp_200_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 'e', 200, 1);
tsmovavg_exp_300_abs_scgSt_position = tsmovavg(abs_scgSt_position, 'e', 300, 1);
tsmovavg_exp_300_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 'e', 300, 1);
tsmovavg_exp_50_abs_scgSt_position_quiescent = tsmovavg_exp_50_abs_scgSt_position<cutoff;
tsmovavg_exp_50_abs_scgPmi_position_quiescent = tsmovavg_exp_50_abs_scgPmi_position<cutoff;
tsmovavg_exp_100_abs_scgSt_position_quiescent = tsmovavg_exp_100_abs_scgSt_position<cutoff;
tsmovavg_exp_100_abs_scgPmi_position_quiescent = tsmovavg_exp_100_abs_scgPmi_position<cutoff;
tsmovavg_exp_200_abs_scgSt_position_quiescent = tsmovavg_exp_200_abs_scgSt_position<cutoff;
tsmovavg_exp_200_abs_scgPmi_position_quiescent = tsmovavg_exp_200_abs_scgPmi_position<cutoff;
tsmovavg_exp_300_abs_scgSt_position_quiescent = tsmovavg_exp_300_abs_scgSt_position<cutoff;
tsmovavg_exp_300_abs_scgPmi_position_quiescent = tsmovavg_exp_300_abs_scgPmi_position<cutoff;
%Triangular MA
tsmovavg_tri_50_abs_scgSt_position = tsmovavg(abs_scgSt_position, 't', 50, 1);
tsmovavg_tri_50_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 't', 50, 1);
tsmovavg_tri_100_abs_scgSt_position = tsmovavg(abs_scgSt_position, 't', 100, 1);
tsmovavg_tri_100_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 't', 100, 1);
tsmovavg_tri_200_abs_scgSt_position = tsmovavg(abs_scgSt_position, 't', 200, 1);
tsmovavg_tri_200_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 't', 200, 1);
tsmovavg_tri_300_abs_scgSt_position = tsmovavg(abs_scgSt_position, 't', 300, 1);
tsmovavg_tri_300_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 't', 300, 1);
tsmovavg_tri_50_abs_scgSt_position_quiescent = tsmovavg_tri_50_abs_scgSt_position<cutoff;
tsmovavg_tri_50_abs_scgPmi_position_quiescent = tsmovavg_tri_50_abs_scgPmi_position<cutoff;
tsmovavg_tri_100_abs_scgSt_position_quiescent = tsmovavg_tri_100_abs_scgSt_position<cutoff;
tsmovavg_tri_100_abs_scgPmi_position_quiescent = tsmovavg_tri_100_abs_scgPmi_position<cutoff;
tsmovavg_tri_200_abs_scgSt_position_quiescent = tsmovavg_tri_200_abs_scgSt_position<cutoff;
tsmovavg_tri_200_abs_scgPmi_position_quiescent = tsmovavg_tri_200_abs_scgPmi_position<cutoff;
tsmovavg_tri_300_abs_scgSt_position_quiescent = tsmovavg_tri_300_abs_scgSt_position<cutoff;
tsmovavg_tri_300_abs_scgPmi_position_quiescent = tsmovavg_tri_300_abs_scgPmi_position<cutoff;
%weighted MA - Gaussian
% gauss50 = -4:8/50:4;
% gauss100 = -4:8/100:4;
% gauss200 = -4:8/200:4;
% gauss300 = -4:8/300:4;
% tsmovavg_gauss_50_abs_scgSt_position = tsmovavg(abs_scgSt_position, 'w', gauss50, 1);
% tsmovavg_gauss_50_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 'w', gauss50, 1);
% tsmovavg_gauss_100_abs_scgSt_position = tsmovavg(abs_scgSt_position, 'w', gauss100, 1);
% tsmovavg_gauss_100_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 'w', gauss100, 1);
% tsmovavg_gauss_200_abs_scgSt_position = tsmovavg(abs_scgSt_position, 'w', gauss200, 1);
% tsmovavg_gauss_200_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 'w', gauss200, 1);
% tsmovavg_gauss_300_abs_scgSt_position = tsmovavg(abs_scgSt_position, 'w', gauss300, 1);
% tsmovavg_gauss_300_abs_scgPmi_position = tsmovavg(abs_scgPmi_position, 'w', gauss300, 1);


%plot window size 50
figure
hold on
plot(abs_scgSt_position, '-r')
plot(tsmovavg_simple_50_abs_scgSt_position, '-g*')
plot(tsmovavg_exp_50_abs_scgSt_position, '-k*')
plot(tsmovavg_tri_50_abs_scgSt_position, '-m*')
plot(tsmovavg_simple_50_abs_scgSt_position_quiescent*cutoff, '-g*')
plot(tsmovavg_exp_50_abs_scgSt_position_quiescent*cutoff/2, '-k*')
plot(tsmovavg_tri_50_abs_scgSt_position_quiescent*cutoff/3, '-m*')
title(strcat(scenario_labels{i}, ': ABS(scgSt\_position EA), with moving avg; window = ', '50 frames @1200Hz'))
legend('ABS(scgSt\_position EA)', 'SMA50(ABS(scgSt\_position EA))','EXP50(ABS(scgSt\_position EA))','TRI50(ABS(scgSt\_position EA))');
savestr = strcat(savedir, 'plot_', this_scenario_name, '_',  scenario_labels{i},'_absOfScgPosition_EA', '_SMA_EXP_TRI_50_absOf', '_ScgSt');
saveas(gcf, savestr, 'png');

figure
hold on
plot(abs_scgPmi_position, '-b')
plot(tsmovavg_simple_50_abs_scgPmi_position, '-g*')
plot(tsmovavg_exp_50_abs_scgPmi_position, '-k*')
plot(tsmovavg_tri_50_abs_scgPmi_position, '-m*')
plot(tsmovavg_simple_50_abs_scgPmi_position_quiescent*cutoff, '-g*')
plot(tsmovavg_exp_50_abs_scgPmi_position_quiescent*cutoff/2, '-k*')
plot(tsmovavg_tri_50_abs_scgPmi_position_quiescent*cutoff/3, '-m*')
title(strcat(scenario_labels{i}, ': ABS(scgPmi\_position EA), with moving avg; window = ', '50 frames @1200Hz'))
legend('ABS(scgPmi\_position EA)', 'SMA50(ABS(scgPmi\_position EA))','EXP50(ABS(scgPmi\_position EA))','TRI50(ABS(scgPmi\_position EA))');
savestr = strcat(savedir, 'plot_', this_scenario_name, '_',  scenario_labels{i},'_absOfScgPosition_EA', '_SMA_EXP_TRI_50_absOf', '_ScgPmi');
saveas(gcf, savestr, 'png');

%plot window size 100
figure
hold on
plot(abs_scgSt_position, '-r')
plot(tsmovavg_simple_100_abs_scgSt_position, '-g*')
plot(tsmovavg_exp_100_abs_scgSt_position, '-k*')
plot(tsmovavg_tri_100_abs_scgSt_position, '-m*')
plot(tsmovavg_simple_100_abs_scgSt_position_quiescent*cutoff, '-g*')
plot(tsmovavg_exp_100_abs_scgSt_position_quiescent*cutoff/2, '-k*')
plot(tsmovavg_tri_100_abs_scgSt_position_quiescent*cutoff/3, '-m*')
title(strcat(scenario_labels{i}, ': ABS(scgSt\_position EA), with moving avg; window = ', '100 frames @1200Hz'))
legend('ABS(scgSt\_position EA)', 'SMA100(ABS(scgSt\_position EA))','EXP100(ABS(scgSt\_position EA))','TRI100(ABS(scgSt\_position EA))');
savestr = strcat(savedir, 'plot_', this_scenario_name, '_',  scenario_labels{i},'_absOfScgPosition_EA', '_SMA_EXP_TRI_100_absOf', '_ScgSt');
saveas(gcf, savestr, 'png');

figure
hold on
plot(abs_scgPmi_position, '-b')
plot(tsmovavg_simple_100_abs_scgPmi_position, '-g*')
plot(tsmovavg_exp_100_abs_scgPmi_position, '-k*')
plot(tsmovavg_tri_100_abs_scgPmi_position, '-m*')
plot(tsmovavg_simple_100_abs_scgPmi_position_quiescent*cutoff, '-g*')
plot(tsmovavg_exp_100_abs_scgPmi_position_quiescent*cutoff/2, '-k*')
plot(tsmovavg_tri_100_abs_scgPmi_position_quiescent*cutoff/3, '-m*')
title(strcat(scenario_labels{i}, ': ABS(scgPmi\_position EA), with moving avg; window = ', '100 frames @1200Hz'))
legend('ABS(scgPmi\_position EA)', 'SMA100(ABS(scgPmi\_position EA))','EXP100(ABS(scgPmi\_position EA))','TRI100(ABS(scgPmi\_position EA))');
savestr = strcat(savedir, 'plot_', this_scenario_name, '_',  scenario_labels{i},'_absOfScgPosition_EA', '_SMA_EXP_TRI_100_absOf', '_ScgPmi');
saveas(gcf, savestr, 'png');

%plot window size 200
figure
hold on
plot(abs_scgSt_position, '-r')
plot(tsmovavg_simple_200_abs_scgSt_position, '-g*')
plot(tsmovavg_exp_200_abs_scgSt_position, '-k*')
plot(tsmovavg_tri_200_abs_scgSt_position, '-m*')
plot(tsmovavg_simple_200_abs_scgSt_position_quiescent*cutoff, '-g*')
plot(tsmovavg_exp_200_abs_scgSt_position_quiescent*cutoff/2, '-k*')
plot(tsmovavg_tri_200_abs_scgSt_position_quiescent*cutoff/3, '-m*')
title(strcat(scenario_labels{i}, ': ABS(scgSt\_position EA), with moving avg; window = ', '200 frames @1200Hz'))
legend('ABS(scgSt\_position EA)', 'SMA200(ABS(scgSt\_position EA))','EXP200(ABS(scgSt\_position EA))','TRI200(ABS(scgSt\_position EA))');
savestr = strcat(savedir, 'plot_', this_scenario_name, '_',  scenario_labels{i},'_absOfScgPosition_EA', '_SMA_EXP_TRI_200_absOf', '_ScgSt');
saveas(gcf, savestr, 'png');

figure
hold on
plot(abs_scgPmi_position, '-b')
plot(tsmovavg_simple_200_abs_scgPmi_position, '-g*')
plot(tsmovavg_exp_200_abs_scgPmi_position, '-k*')
plot(tsmovavg_tri_200_abs_scgPmi_position, '-m*')
plot(tsmovavg_simple_200_abs_scgPmi_position_quiescent*cutoff, '-g*')
plot(tsmovavg_exp_200_abs_scgPmi_position_quiescent*cutoff/2, '-k*')
plot(tsmovavg_tri_200_abs_scgPmi_position_quiescent*cutoff/3, '-m*')
title(strcat(scenario_labels{i}, ': ABS(scgPmi\_position EA), with moving avg; window = ', '200 frames @1200Hz'))
legend('ABS(scgPmi\_position EA)', 'SMA200(ABS(scgPmi\_position EA))','EXP200(ABS(scgPmi\_position EA))','TRI200(ABS(scgPmi\_position EA))');
savestr = strcat(savedir, 'plot_', this_scenario_name, '_',  scenario_labels{i},'_absOfScgPosition_EA', '_SMA_EXP_TRI_200_absOf', '_ScgPmi');
saveas(gcf, savestr, 'png');



%% take square of position and do a windowed average