%% 3/25/2014
%% Robert Chen

%REMEMBER TO ADD PATH FIRST!!!
addpath('./')

%directories for data - specify!
hardwareDataDir = '../scgData/';
echoDataDir = '../echoData/03-05-2014-Cardiac/';

%read in the hardware data
ecgHWfile_exam = strcat(hardwareDataDir, 'ecgExam.txt')
scgStFile_exam = strcat(hardwareDataDir, 'scg1Exam.txt')
scgPmiFile_exam = strcat(hardwareDataDir, 'scg2Exam.txt')
ecgHW_exam = readDeviceData(ecgHWfile_exam);
scgSt_exam = readDeviceData(scgStFile_exam);
scgPmi_exam = readDeviceData(scgPmiFile_exam);

%echo data
echoFile = strcat(echoDataDir, '14-09-19.b8')
ecgEchoFile = strcat(echoDataDir, '14-09-19.ecg')
[echo headerEcho] = readEchoData(echoFile);
[ecgEcho headerECG_Echo] = readEchoData(ecgEchoFile);

%play Bmode; terminate by ctrl-c
playBmode(echo, 50);
[stIdx enIdx] = synchDeviceWithEcho(ecgHW_exam, ecgEcho); %start and stop index

%plot echo, etc
figure
plot(double(ecgEcho)*50, 'r')
hold on
plot(ecgHW_exam(stIdx:6:enIdx))

%cycles
cycles_ecgHW = getCyclesFromEcg(ecgHW_exam);
figure
plot(ecgHW_exam(stIdx:enIdx));
hold on;
scatter(cycles_ecgHW(:,1), ecgHW_exam(cycles_ecgHW(:,1)), 'r*');

%corrMtx
corrMtx = getDevMtxFromBmode(echo);
deviation = getDeviationFromDevMtx(corrMtx, 4);
figure
hold on;
plot(deviation)

%plot ecgEcho and deviation
figure
hold on;
plot(double(ecgEcho(end-1999:4:end))-mean(double(ecgEcho))  , 'r');
scale = double(max(ecgEcho)-min(ecgEcho)) / double(max(deviation)-min(deviation));
shift_up_2nd_plot = double(max(ecgEcho)-min(ecgEcho));
plot([(deviation-mean(deviation))*scale] + shift_up_2nd_plot );

%generate ensemble average%%%%%%%%%%%%%%
%start by take 700ms signals:
cycles_start_indexes = cycles_ecgHW(:,1);
ecgHW_beatarray = [];
scgSt_beatarray = [];
scgPmi_beatarray = [];
num_samples_700ms = floor(1200*.7);
num_samples_avgCycle = mean(cycles_ecgHW(:,3));
for i = 1:length(cycles_start_indexes)
    this_ecg_700 = ecgHW_exam(cycles_start_indexes(i):cycles_start_indexes(i)+num_samples_700ms);
    this_scgSt_700 = scgSt_exam(cycles_start_indexes(i):cycles_start_indexes(i)+num_samples_700ms);
    this_scgPmi_700 = scgPmi_exam(cycles_start_indexes(i):cycles_start_indexes(i)+num_samples_700ms);
    ecgHW_beatarray = [ecgHW_beatarray, this_ecg_700];
    scgSt_beatarray = [scgSt_beatarray, this_scgSt_700];
    scgPmi_beatarray = [scgPmi_beatarray, this_scgPmi_700];
end
ecgHW_EA = mean(ecgHW_beatarray,2);
scgSt_EA = mean(scgSt_beatarray, 2);
scgPmi_EA = mean(scgPmi_beatarray, 2);

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

figure
hold on
plot(cond_ecgHW_EA, '-b')
plot(cond_scgSt_EA, '-r')
plot(cond_scgPmi_EA, '-g')
legend('ecgHW\_EA', 'scgSt\_EA', 'scgPmi\_EA')

figure
hold on
plot(scgSt_position, '-r')
plot(scgPmi_position, '-b')
title('position ensemble average over time')
legend('scgSt\_position', 'scgPmi\_position')

figure 
hold on
plot(scgSt_velocity, '*r')
plot(scgPmi_velocity, '*b')
title('velocity ensemble average over time')
legend('scgSt\_velocity', 'scgPmi\_velocity')


%% save
save('play_20140325.mat')

