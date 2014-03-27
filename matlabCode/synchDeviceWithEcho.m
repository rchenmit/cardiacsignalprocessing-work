function [startIdx, endIdx] = synchDeviceWithEcho(ecgDevice,ecgEcho)
%MATCHECG Summary of this function goes here
%   Detailed explanation goes here

% condition ecg from echo
ecgEcho = conditionEchoEcg(ecgEcho);
ecgEcho = resample(ecgEcho,6,1); % upsample from 200 Hz to 1200 Hz to match scg device
ecgEcho = ecgEcho/max(ecgEcho);

% condition ecg from custom device
ecgDevice = conditionDeviceEcg(ecgDevice); % gets rid of DC and LPF with 50 Hz cutoff
ecgDevice = ecgDevice/max(ecgDevice);

% find the peak
M = length(ecgDevice);
N = length(ecgEcho);
matchSignal = xcorr(ecgDevice,ecgEcho);
[~,idx] = max(matchSignal);
startIdx = idx-M+1;
endIdx = startIdx + N - 1;
figure,plot(matchSignal)
end

