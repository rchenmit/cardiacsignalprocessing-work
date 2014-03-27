%% 3/25/2014
%REMEMBER TO ADD PATH FIRST!!!
%hardware data
ecgHW = readDeviceData('scgData/ecgExam.txt');
scgSt = readDeviceData('scgData/scg1Exam.txt');
scgPmi = readDeviceData('scgData/scg2Exam.txt');

%echo data
[echo headerEcho] = readEchoData('14-09-19.b8');
[ecgEcho headerECG_Echo] = readEchoData('14-09-19.ecg');

%play Bmode; terminate by ctrl-c
playBmode(echo, 50);
[stIdx enIdx] = synchDeviceWithEcho(ecgHW, ecgEcho); %start and stop index

%plot echo, etc
figure
plot(double(ecgEcho)*50, 'r')
hold on
plot(ecgHW(stIdx:6:enIdx))

%cycles
cycles_ecgHW = getCyclesFromEcg(ecgHW);
figure
plot(ecgHW);
hold on;
scatter(cycles_ecgHW(:,1), ecgHW(cycles_ecgHW(:,1)), 'r*');

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

for i = 1:length(cycles_start_indexes)
    this_ecg_700 = ecgHW(cycles_start_indexes(i):cycles_start_indexes(i)+700);
    this_scgSt_700 = scgSt(cycles_start_indexes(i):cycles_start_indexes(i)+700);
    this_scgPmi_700 = scgPmi(cycles_start_indexes(i):cycles_start_indexes(i)+700);
    ecgHW_beatarray = [ecgHW_beatarray, this_ecg_700];
    scgSt_beatarray = [scgSt_beatarray, this_scgSt_700];
    scgPmi_beatarray = [scgPmi_beatarray, this_scgPmi_700];
end
ecgHW_EA = mean(ecgHW_beatarray,2);
scgSt_EA = mean(scgSt_beatarray, 2);
scgPmi_EA = mean(scgPmi_beatarray, 2);

% find the velocity from the acceleration (SCG)
kalm_scgSt = kalm(scgSt_EA);
kalm_scgPmi = kalm(scgPmi_EA);
scgSt_position = kalm_scgSt(1,:);
scgSt_velocity = kalm_scgSt(2,:);
scgPmi_position = kalm_scgPmi(1,:);
scgPmi_velocity = kalm_scgPmi(2,:);

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



