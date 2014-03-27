function [yy] = windowedRms(xx,N)
%WINDOWEDRMS Summary of this function goes here
%   Detailed explanation goes here
xxSq = xx.^2;
xxMeanSq = conv(xxSq,ones(N,1)/N,'same');
yy = xxMeanSq.^.5;

end

