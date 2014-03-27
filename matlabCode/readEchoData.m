function [data,header] = readEchoData(filename, framesRead)

fid = fopen(filename, 'r');

if( fid == -1)
      error('Cannot open file');
end

% read the header info
[hinfo,count] = fread(fid, 19, 'int32');

% load the header information into a structure and save under a separate file
header = struct('filetype', 0, 'nframes', 0, 'w', 0, 'h', 0, 'ss', 0, 'ul', [0,0], 'ur', [0,0], 'br', [0,0], 'bl', [0,0], 'probe',0, 'txf', 0, 'sf', 0, 'dr', 0, 'ld', 0, 'extra', 0);
header.filetype = hinfo(1);
header.nframes = hinfo(2);
header.w = hinfo(3);
header.h = hinfo(4);
header.ss = hinfo(5);
header.ul = [hinfo(6), hinfo(7)];
header.ur = [hinfo(8), hinfo(9)];
header.br = [hinfo(10), hinfo(11)];
header.bl = [hinfo(12), hinfo(13)];
header.probe = hinfo(14);
header.txf = hinfo(15);
header.sf = hinfo(16);
header.dr = hinfo(17);
header.ld = hinfo(18);
header.extra = hinfo(19);

if nargin==2
      header.nframes=min([framesRead, header.nframes]);
end

switch header.filetype
    case 1
        disp('Data Type: AVI')
        disp('WARNING: Not implemented yet')
    case 2
        disp('Data Type: B Pre Scan Converted')
        disp('WARNING: Not implemented yet')
    case 4
        disp('Data Type: B Post Scan Converted 8-bit')
        data = uint8(zeros(header.h, header.w, header.nframes));
        for frame = 1:header.nframes
            %tag = fread(fid,1,'int32');
            [v,count] = fread(fid,[header.w header.h],'uint8');
            data(:,:,frame) = rot90(v, 3);
        end
        %Im = circshift(Im,[0 -4 0]);
    case 8
        disp('Data Type: B Post Scan Converted 32-bit')
        data=uint32(zeros(header.h, header.w, header.nframes));
        for frame = 1:header.nframes
            [v,count] = fread(fid,header.w*header.h,'uint32');
            data(:,:,frame) = uint32(rot90(reshape(v,header.w,header.h),3));
        end
    case 16
        disp('Data Type: RF')
        data=zeros(header.h, header.w, header.nframes);
        for frame_count = 1:header.nframes
            tag = fread(fid,1,'int32');
            [v,count] = fread(fid,header.w*header.h,'int16');
            data(:,:,frame_count) = int16(reshape(v,header.h,header.w));
        end
    case 32
        disp('Data Type: M Pre Scan Converted')
        datalength = header.h - 4;
        data=zeros(datalength, header.nframes);
        for frame_count = 1:header.nframes
            tag = fread(fid,1,'int32');
            [v,count] = fread(datalength,'uint8');
            data(:,frame_count) = uint8(v);
        end
    case 64
        disp('Data Type: M Post Scan Converted Spectrum')
        data = uint8(zeros(header.h, header.w));
        [v,count] = fread(fid,header.w*header.h,'uint8');
        data = uint8(rot90(reshape(v,header.w,header.h),1));
    case 128
        disp('Data Type: PW RF')
        disp('WARNING: Not implemented yet')
    case 256
        disp('Data Type: PW Spectrum')
        disp('WARNING: Not implemented yet')
    case 512
        disp('Data Type: Color RF')
        disp('WARNING: Not implemented yet')
    case 1024
        disp('Data Type: Color B')
        data = uint8(zeros(header.h, header.w, header.nframes, 4));
        for frame = 1:header.nframes
            for i = 1:4
                [v,count] = fread(fid,[header.w header.h],'uint8');
                data(:,:,frame,i) = rot90(v, 3);
            end
        end
    case 2048
        disp('Data Type: Color Velocity/Variance')
        data = int8(zeros(header.h, header.w, header.nframes, 2));
        for frame = 1:header.nframes
            for i = 1:2
                [v,count] = fread(fid,[header.w header.h],'int8');
                data(:,:,frame,i) = rot90(v, 3);
            end
        end
    case 8192
        disp('Data Type: Elastography Data')
        disp('WARNING: Not implemented yet')
    case 16384
        disp('Data Type: Elastography Overlay')
        disp('WARNING: Not implemented yet')
    case 32768
        disp('Data Type: Elastogrphay Pre Scan Converted')
        disp('WARNING: Not implemented yet')
    case 65536
        disp('Data Type: ECG')
        data=uint8(zeros(header.nframes,1));
        [v,count] = fread(fid,header.nframes,'uint8');
        data = uint8(v);
    case 131072
        disp('Data Type: GPS')
        disp('WARNING: Not implemented yet')
    otherwise
        disp('Unknown Method.')
end
    
fclose(fid);

