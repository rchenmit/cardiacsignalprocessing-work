function [deviation] = getDeviationFromDevMtx(devMtx,winLen)
%GETDEVIATIONFROMDEVMTX Summary of this function goes here
%   Detailed explanation goes here
N = size(devMtx,1);
devLength = N-winLen+1;

deviation = zeros(devLength,1);

for i = 1:(N-winLen+1)
    
    endIdx = winLen + i - 1;
    
    devMtxNbrhd = devMtx(i:endIdx,i:endIdx);
    deviation(i) = mean(devMtxNbrhd(:));

end

end

