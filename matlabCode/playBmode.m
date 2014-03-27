function [] = playBmode(BmodeData,dataRate)
% function [] = playBmode(BmodeData,dataRate)
% inputs:
% BmodeData(:,:,i)  = i'th frame
% dataRate          = frames per second

colormap gray
for i = 1:size(BmodeData,3)
    currImg = squeeze(BmodeData(:,:,i));
    imagesc(currImg);%imagesc(currImg,[0 .25].*double(max(currImg(:))));
    drawnow;
    pause(1/dataRate);
end