function normalized_signal = signalMinusMean(signal)
%SIGNALMINUSMEAN center a signal around 0
%   INPUT:
%       signal: the signal you want
%   OUTPUT:
%        normalized_signal: signal centered around 0
%
    mean_of_signal = mean(signal);
    normalized_signal = signal - mean_of_signal;
    
end

