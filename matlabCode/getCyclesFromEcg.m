function [cycles] = getCyclesFromEcg(ecg,fs,minCycleLength)
%GETCYCLESFROMECG Summary of this function goes here
%   minCycleLength is in seconds
%
%   cycles = [cycleStarts, cycleEnds, cycleLengths]
if nargin<2; fs = 1200; end
if nargin<3; minCycleLength = 0.6; end

if fs == 200
    ecg = conditionEchoEcg(ecg);
elseif fs == 1200
    ecg = conditionDeviceEcg(ecg);
else
    error('Unknown Sampling Rate');
end

% first pass at identifying the peaks (omitting first and last cycles)
[peakVals, peakLocs] = findpeaks(ecg,'minpeakdistance',round(minCycleLength*fs));
peakVals = peakVals(2:end-1);
peakLocs = peakLocs(2:end-1);

% segment cycles including possibly innaccurate cycles
cycleStarts = peakLocs(1:end-1);
cycleEnds = peakLocs(2:end)-1;
cycleLengths = cycleEnds - cycleStarts + 1;

cycles = [cycleStarts, cycleEnds, cycleLengths];

% prune bad cycles
medianCycleLength = median(cycleLengths);   % get median cycle length in samples
meanPeakVal = mean(peakVals);
dPeakVals = peakVals(2:end)-peakVals(1:end-1); % get first diff of peakVals

tooLong = cycleLengths > 1.5*medianCycleLength;

tooShort = cycleLengths < 0.6*medianCycleLength;

tooBig = peakVals > 2*meanPeakVal;
tooBig = tooBig|circshift(tooBig,-1);
tooBig = tooBig(1:end-1);

tooSmall = peakVals < 0.5*meanPeakVal;
tooSmall = tooSmall|circshift(tooSmall,-1);
tooSmall = tooSmall(1:end-1);

tooNoisy = abs(dPeakVals) > 5*mean(abs(dPeakVals));
tooNoisy = tooNoisy|circshift(tooNoisy,-1);

cycles(tooLong|tooShort|tooBig|tooSmall|tooNoisy,:) = [];
figure(1),plot(ecg);hold,scatter(cycles(:,1),ecg(cycles(:,1)),'r')
scatter(cycles(:,2)+1,ecg(cycles(:,2)+1),'r'),hold
end

