%% 3/27/2014
% Robert chen
%
%
%% load
load('play_20140325.mat');
%%
%note: the echo form hardware needs ot be DOWNSAMPLED by 6x (compared with
%Echo)
%since ecgHW is at 1200Hz, then ecgEcho is at 200Hz
deviation_sample_rate = 200; %200 Hz
deviation_peaks = getCyclesFromEcg(deviation, deviation_sample_rate, .15);
mean_cycle_length =  mean(deviation_peaks(:,3));
dev_peak_startIndexes = deviation_peaks(:,1);
cycle_length_corresponding_700ms = floor(50*.7);
deviation_matrix = [];
for i=1:length(dev_peak_startIndexes)
    %sample 700 ms
    this_cycle = deviation(dev_peak_startIndexes(i):dev_peak_startIndexes(i)+cycle_length_corresponding_700ms);
    deviation_matrix = [deviation_matrix, this_cycle];
end

deviation_EA = mean(deviation_matrix,2);

figure
hold on
downsample_factor = ceil(length(scgSt_velocity) / length(deviation_EA));
scale = 4e4;%% change scale if need be
shift_deviationEA = mean(scgSt_velocity)/scale;%% how much to shift deviation on the figure; change if need be
plot(deviation_EA + shift_deviationEA, '-b')
plot(scgSt_velocity(1:downsample_factor:end)/scale, '-*r')
plot(scgPmi_velocity(1:downsample_factor:end)/scale, '-*b')
title('deviation EA, scgSt\_velocity EA, scgPmi\_velocity')
legend('deviation\_EA', 'scgSt\_velocity', 'scgPmi\_velocity')

%% SAVE!
save('code_20140327.mat');


