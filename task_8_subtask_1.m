% Task 7.1: Train a CNN to classify each character using Deep Learning Toolbox
% Run this program to train the CNN. It will output trainedNet.mat as the
% trained model

clear all;
close all;

% Create a log directory with a timestamp
date_prefix = string(datetime('now', 'Format', 'MM-dd_HH-mm-ss'));
log_path = "../logs/" + date_prefix + "/";
mkdir(log_path);

%% Load Dataset
dataset_option.img_dim = 128;

% Define paths for train and test datasets
base_dir = pwd;  % Get the current working directory
train_data_path = fullfile(base_dir, 'Photos', 'p_dataset_26', 'p_dataset_26', 'dataset', 'train');
test_data_path = fullfile(base_dir, 'Photos', 'p_dataset_26', 'p_dataset_26', 'dataset', 'test');

% Load training and testing datasets using imageDatastore
imdsTrain = imageDatastore(train_data_path, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
imdsTest = imageDatastore(test_data_path, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

% Define preprocessing function
imdsTrain.ReadFcn = @(filename) preprocess_image(filename, dataset_option.img_dim);
imdsTest.ReadFcn = @(filename) preprocess_image(filename, dataset_option.img_dim);

% Data Augmentation for training dataset
augmenter = imageDataAugmenter( ...
    'RandRotation', [-25, 25], ...
    'RandXTranslation', [-dataset_option.img_dim * 0.01, dataset_option.img_dim * 0.01], ...
    'RandYTranslation', [-dataset_option.img_dim * 0.01, dataset_option.img_dim * 0.01], ...
    'RandXScale', [1, 1], ...
    'RandYScale', [1, 1]);

augimdsTrain = augmentedImageDatastore([dataset_option.img_dim dataset_option.img_dim], imdsTrain, 'DataAugmentation', augmenter);
augimdsTest = augmentedImageDatastore([dataset_option.img_dim dataset_option.img_dim], imdsTest);

%% Define AlexNet-like Network Structure with LRN Layers

layers = [
    % Input Layer
    imageInputLayer([dataset_option.img_dim dataset_option.img_dim 1], 'Normalization', 'zerocenter')

    % 1st Convolutional Block
    convolution2dLayer(11, 96, 'Stride', 4, 'Padding', 'same')
    reluLayer
    crossChannelNormalizationLayer(5, 'K', 2)  % LRN Layer
    maxPooling2dLayer(3, 'Stride', 2)

    % 2nd Convolutional Block
    convolution2dLayer(5, 256, 'Padding', 'same')
    reluLayer
    crossChannelNormalizationLayer(5, 'K', 2)  % LRN Layer
    maxPooling2dLayer(3, 'Stride', 2)

    % 3rd Convolutional Block
    convolution2dLayer(3, 384, 'Padding', 'same')
    reluLayer

    % 4th Convolutional Block
    convolution2dLayer(3, 384, 'Padding', 'same')
    reluLayer

    % 5th Convolutional Block
    convolution2dLayer(3, 256, 'Padding', 'same')
    reluLayer
    maxPooling2dLayer(3, 'Stride', 2)

    % Fully Connected Layers
    fullyConnectedLayer(4096)
    reluLayer
    dropoutLayer(0.5)

    fullyConnectedLayer(4096)
    reluLayer
    dropoutLayer(0.5)

    % Output Layer with classes based on the number of unique labels
    fullyConnectedLayer(numel(unique(imdsTrain.Labels)))
    softmaxLayer
    classificationLayer];

%% Define Training Options

% Set training options for SGDM with a reduced learning rate
opts = trainingOptions('sgdm', ...
    'Momentum', 0.9, ...
    'InitialLearnRate', 0.01, ...
    'MaxEpochs', 30, ...
    'MiniBatchSize', 128, ...
    'L2Regularization', 0.0005, ...
    'Shuffle', 'every-epoch', ...
    'Verbose', true, ...
    'Plots', 'training-progress');

%% Train the CNN model

trainedNet = trainNetwork(augimdsTrain, layers, opts);

%% Test the Network

% Classify the test data
YPred = classify(trainedNet, augimdsTest);
YValidation = imdsTest.Labels;

% Calculate accuracy
accuracy = sum(YPred == YValidation) / numel(YValidation);
fprintf('Test accuracy: %.2f%%\n', accuracy * 100);

% Display confusion matrix
figure;
confusionchart(YValidation, YPred);
title('Confusion Matrix for Test Set');

%% Save Model and Results

% Save the trained model and test results
save(log_path + "trainedNet.mat", 'trainedNet');
save(log_path + "results_on_test.mat", 'YPred', 'YValidation');

% Log hyperparameters and dataset options
options = struct('epochs', 30, 'minibatch_size', 128, 'initial_lr', 0.01, ...
                 'momentum', 0.9, 'l2_penalty', 0.0005);
dataset_options = struct('img_dim', dataset_option.img_dim, 'apply_rand_tf', dataset_option.apply_rand_tf);

% Save hyperparameters and dataset options to JSON
json_options = jsonencode(options);
json_dataset_options = jsonencode(dataset_options);
fid_options = fopen(log_path + "hyper_params.json", 'w');
fprintf(fid_options, json_options);
fclose(fid_options);
fid_dataset_options = fopen(log_path + "dataset_option.json", 'w');
fprintf(fid_dataset_options, json_dataset_options);
fclose(fid_dataset_options);

%% Helper Functions

% Preprocess image
function img = preprocess_image(filename, img_dim)
    img = imread(filename);
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    img = imresize(img, [img_dim img_dim]);
    img = single(img) / 255;
end
