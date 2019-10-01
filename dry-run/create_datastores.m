
%% pixel labels
load('gTruth.mat')

% expand the table of pixel labels
T = gTruth.LabelDefinitions(1, :);
T{end, 1} = {'Background'}; % call the new label background
T{end, 3} = {0}; % link it to pixels that are zero

% Goal: resturcture to incorporate zero pixels
% https://www.mathworks.com/help/vision/ref/groundtruth.html#bvipaok-1-LabelDefs

%%
gTruth.LabelDefinitions = [gTruth.LabelDefinitions; T];

%% Alternative method

dataSource = gTruth.DataSource;
ldc = labelDefinitionCreator();
% addlabel(ldc, )

%%
pxds = pixelLabelDatastore(gTruth);
save('pxds.mat', 'pxds')

% images
imds = imageDatastore('images');
save('imds.mat', 'imds')

clear
clc