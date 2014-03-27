function ecg = conditionEchoEcg(ecgIn)
%CONDITIONSCG Summary of this function goes here
%   Detailed explanation goes here

ecgIn = ecgIn-min(ecgIn);
ecgIn = ecgIn/max(ecgIn);

% low pass filter
%   30Hz pass, 40Hz stop -10dB
lpf = [0.0984181083700948,-0.0587639211031260,-0.0884476642897075,...
    -0.0137688656605552,0.115945089263936,0.294828755127382,...
    0.350048951915979,0.294828755127382,0.115945089263936,...
    -0.0137688656605552,-0.0884476642897075,-0.0587639211031260,...
    0.0984181083700948];

ecgLpf = conv(ecgIn,lpf,'same');

% notch filter
a = [1 -0.90];
b = [1 -1];
ecgNotch = filtfilt(b,a,ecgLpf);

ecg = ecgNotch;

end

