
% pixel labels
load('gTruth.mat')
pxds = pixelLabelDatastore(gTruth);
save('pxds.mat', 'pxds')

% images
imds = imageDatastore('images');
save('imds.mat', 'imds')

clear
clc