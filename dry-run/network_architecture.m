% https://www.mathworks.com/help/vision/examples/semantic-segmentation-using-deep-learning.html
% https://www.mathworks.com/help/vision/ug/semantic-segmentation-examples.html

%% Load
load('pxds.mat')
load('imds.mat')

%% Split into trian and test
[imdsTrain, imdsVal, imdsTest, pxdsTrain, pxdsVal, pxdsTest] = partitionData(imds,pxds);


%% Either label background what it is or don't force a label on everything

%% Layers
numFilters = 64;
filterSize = 3;
numClasses = 2;


layers = [
    imageInputLayer([512 512 1])
    convolution2dLayer(filterSize,numFilters,'Padding',1)
    reluLayer()
    maxPooling2dLayer(2,'Stride',2)
    convolution2dLayer(filterSize,numFilters,'Padding',1)
    reluLayer()
    transposedConv2dLayer(4,numFilters,'Stride',2,'Cropping',1);
    convolution2dLayer(1,numClasses);
    softmaxLayer()
    pixelClassificationLayer()
    ];

%% options
opts = trainingOptions('sgdm', ...
    'InitialLearnRate', 1e-3, ...
    'MaxEpochs', 20, ...
    'MiniBatchSize',64);

%% train network
trainingData = pixelLabelImageDatastore(imdsTrain, pxdsTrain);

net = trainNetwork(trainingData, layers, opts);

%% Train/Test split function
function [imdsTrain, imdsVal, imdsTest, pxdsTrain, pxdsVal, pxdsTest] = partitionData(imds,pxds)
% copied verbatim form https://www.mathworks.com/help/vision/examples/semantic-segmentation-using-deep-learning.html
% set seed
rng(919)
numFiles = numel(imds.Files);
shuffledIndices = randperm(numFiles);

% 60 - 20 - 20 (train, validate, test)
numTrain = round(.6 * numFiles);
trainingIdx = shuffledIndices(1:numTrain);

% Use 20% of the images for validation
numVal = round(0.20 * numFiles);
valIdx = shuffledIndices(numTrain+1:numTrain+numVal);

% Use the rest for testing.
testIdx = shuffledIndices(numTrain+numVal+1:end);

% Create image datastores for training and test.
trainingImages = imds.Files(trainingIdx);
valImages = imds.Files(valIdx);
testImages = imds.Files(testIdx);

imdsTrain = imageDatastore(trainingImages);
imdsVal = imageDatastore(valImages);
imdsTest = imageDatastore(testImages);

% Extract class and label IDs info.
classes = pxds.ClassNames;
labelIDs = [1, 2];

% Create pixel label datastores for training and test.
trainingLabels = pxds.Files(trainingIdx);
valLabels = pxds.Files(valIdx);
testLabels = pxds.Files(testIdx);

pxdsTrain = pixelLabelDatastore(trainingLabels, classes, labelIDs);
pxdsVal = pixelLabelDatastore(valLabels, classes, labelIDs);
pxdsTest = pixelLabelDatastore(testLabels, classes, labelIDs);

end