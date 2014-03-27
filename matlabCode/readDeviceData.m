 function [data, tt, ttDateNum] = readDeviceData(dataTextFile, fs)
%SCGREAD Summary of this function goes here
%   tt is output as a datenum (unit days), use datevec to interpret if nec
if nargin < 2
    fs = 1200;
end
dt = 1/fs;
dtInDays = dt/86400;

% read in file to cell array
fid = fopen(dataTextFile,'r');
dataText = textscan(fid,'%s');
dataText = dataText{:};
fclose(fid);

dataLen = size(dataText,1);

% identify time stamps
idxsOfTimeStamps = find(strcmp('AM',dataText)|strcmp('PM',dataText));
idxsOfTimeStamps = sort(idxsOfTimeStamps,'ascend');
idxsOfTimeStamps = [idxsOfTimeStamps-2,idxsOfTimeStamps-1,idxsOfTimeStamps];

numTimeStamps = size(idxsOfTimeStamps,1);

idxsToRemove = [];
for i = 2:numTimeStamps     % remove end timestamps
    if idxsOfTimeStamps(i,1)-idxsOfTimeStamps(i-1,1) == 3
        idxsToRemove = [idxsToRemove; idxsOfTimeStamps(i-1,:)];
        idxsOfTimeStamps(i-1,1) = 0;
    end
    if idxsOfTimeStamps(i,3) == length(dataText)
        idxsToRemove = [idxsToRemove; idxsOfTimeStamps(i,:)];
        idxsOfTimeStamps(i,1) = 0;
    end
end
%dataText(idxsToRemove) = [];
idxsOfTimeStamps(idxsOfTimeStamps(:,1)==0,:) = [];

numTimeStamps = size(idxsOfTimeStamps,1);
timeStampVectors = zeros(numTimeStamps,6);
timeStampDateNums = zeros(numTimeStamps,1);
for i = 1:numTimeStamps
    currTimeStamp= [dataText{idxsOfTimeStamps(i,1)},' ',...
                    dataText{idxsOfTimeStamps(i,2)},' ',...
                    dataText{idxsOfTimeStamps(i,3)}];
                
    year = str2double(currTimeStamp(7:10));
    month = str2double(currTimeStamp(1:2));
    day = str2double(currTimeStamp(4:5));
    hour = str2double(currTimeStamp(12:13));
    if strcmp('PM',currTimeStamp(end-1:end))
        hour = hour + 12;
    end
    minute = str2double(currTimeStamp(15:16));
    sec = str2double(currTimeStamp(18:23));
    timeStampVectors(i,:) = [year,month,day,hour,minute,sec];
    timeStampDateNums(i) = datenum(timeStampVectors(i,:));
end

% generate tt and scg
ttDateNum = zeros(dataLen,1);
for i = 1:numTimeStamps
    currTimeStamp = timeStampDateNums(i);
    ttTemp = (0:(dataLen-1-idxsOfTimeStamps(i,3)))'*dtInDays;
    ttDateNum(idxsOfTimeStamps(i,3)+1:end) = ttTemp + currTimeStamp;
end
ttDateNum([idxsOfTimeStamps(:);idxsToRemove(:)]) = [];
ttDateNum = ttDateNum';
tt = (ttDateNum-min(ttDateNum))*86400; % convert datenums (unit days) to raw secs
dataText([idxsOfTimeStamps(:);idxsToRemove(:)]) = [];
ttLen = length(tt);
dataChar = char(dataText);
spaces = repmat(' ',ttLen,1);
dataChar = [spaces,dataChar];
dataString = reshape(dataChar',1,numel(dataChar))';
data = sscanf(dataString,'%d');
end

