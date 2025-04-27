% Loading the dataset
folderPath = 'Photos/p_dataset_26/p_dataset_26/dataset/train';
imds = imageDatastore(folderPath, ...
    'IncludeSubfolders', true, ...                   
    'LabelSource', 'foldernames');                   

% Loading the validation set
testFfolderPath = 'Photos/p_dataset_26/p_dataset_26/dataset/test';
imdsTest = imageDatastore(testFfolderPath, ...
    'IncludeSubfolders', true, ...                   
    'LabelSource', 'foldernames');   

% Test if the dataset works
% imgLabel = imds.Labels(1);
% imgSample = readimage(imds, 1);
% imshow(imgSample);
% title(['Label: ', char(imgLabel)]);

% Acquire the basic parameters of the NN
numImages = numel(imds.Files);
disp(['Number of images: ', num2str(numImages)]);

img = readimage(imds, 1);
imgSize = size(img);
disp(['Image size: ', num2str(imgSize)]);

uniqueLabels = unique(imds.Labels);
numLabels = numel(uniqueLabels); 
disp(['Number of unique labels: ', num2str(numLabels)]);

layers = [
    imageInputLayer([imgSize 1])                % Input layer for grayscale images
    fullyConnectedLayer(256)                      % Hidden layer with 100 neurons
    reluLayer                                     % ReLU activation function
    fullyConnectedLayer(128)                       % Second hidden layer with 50 neurons
    reluLayer
    fullyConnectedLayer(numel(unique(imds.Labels))) % Output layer with neurons equal to the number of classes
    softmaxLayer                                  % Softmax for output probabilities
    classificationLayer                           % Classification layer
];


options = trainingOptions('sgdm', ...          % Stochastic gradient descent with momentum
    'InitialLearnRate', 0.0001, ...
    'MaxEpochs', 5, ...                       % Number of epochs
    'MiniBatchSize', 64, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', imdsTest, ...
    'ValidationFrequency', 30, ...
    'Verbose', false, ...
    'Plots', 'training-progress');             % Display training progress

net = trainNetwork(imds, layers, options);

YPred = classify(net, imdsTest);
YValidation = imdsTest.Labels;
accuracy = sum(YPred == YValidation) / numel(YValidation);
disp(['Validation accuracy: ', num2str(accuracy)]);

confusionchart(YValidation, YPred);
title('Confusion Matrix');


%% Validate the data
% Define the path to the folder containing unlabeled images
unlabeledFolder = 'Photos/test';

% Create an imageDatastore for the unlabeled images
unlabeledImds = imageDatastore(unlabeledFolder);
% unlabeledImds.ReadFcn = @(filename) im2gray(imread(filename));

% Use the trained network to classify the images
YPredUnlabeled = classify(net, unlabeledImds);

% Display images with their predicted labels
numImages = 10; 
figure;
for i = 1:numImages
    subplot(2, 5, i);
    img = readimage(unlabeledImds, i);
    predictedLabel = YPredUnlabeled(i);
    imshow(img);
    title(['Predicted: ', char(predictedLabel)]);
end
