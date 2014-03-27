function corrMtx = getDevMtxFromBmode(imgSeq)
imgSeq = double(imgSeq);
numFrames = size(imgSeq,3);
figure(1)
colormap(gray);
for i = 1:min(numFrames,100)
    imagesc(imgSeq(:,:,i));
    drawnow
end
hold
[X, Y] = ginput(2);
X = round(X);
Y = round(Y);
x = min(X);
y = min(Y);
w = abs(X(1)-X(2))+1;
h = abs(Y(1)-Y(2))+1;
rectangle('position',[x y w h],'EdgeColor','w');
drawnow
hold

mRange = min(Y):max(Y);
nRange = min(X):max(X);
numPix = w*h;
vecFrames = reshape(imgSeq(mRange,nRange,:),numPix,numFrames);
corrMtx = 1-corr(vecFrames);
close

