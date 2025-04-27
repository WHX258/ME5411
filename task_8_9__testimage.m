% % Get the current working directory
currentFolder = pwd;

% Load trained network from the .mat file
modelPath = fullfile(currentFolder, 'AlexNet.mat');
if isfile(modelPath)
    load(modelPath, 'trainedNet'); % Load the correct variable
else
    error('AlexNet.mat file not found. Check the file location.');
end

% Define the relative path to the subfolder
subfolder = fullfile(currentFolder, 'Photos', 'Original');

% Find image files in the specified subfolder
imageFiles = dir(fullfile(subfolder, 'sub_*.bmp'));
numImages = length(imageFiles);
numRows = ceil(sqrt(numImages));
numCols = ceil(numImages / numRows);

% Create a single figure for all images
figure;

for k = 1:numImages
    Ipath = fullfile(subfolder, imageFiles(k).name);
    I = imread(Ipath);
    
    % Preprocess image for the network
    % Convert to grayscale if the image is RGB
    if size(I, 3) == 3
        I = rgb2gray(I);
    end
    
    % Resize to 128x128
    I = imresize(I, [128, 128]);
    
    % Ensure the image has the required dimensions (128x128x1)
    I = reshape(I, [128, 128, 1]);
    
    % Classify the image
    predictedLabel = classify(trainedNet, I);
    
    % Display image and predicted label in a single figure
    subplot(numRows, numCols, k);
    imshow(I, []);
    title(['Predicted Label: ', char(predictedLabel)], 'Interpreter', 'none');
end

% Add a single title for the entire figure
sgtitle('Predicted Labels for Original Images (CNN)');
%% pre-Processing


subfolder = 'Photos/';
imageFiles = dir([subfolder 'bw_sub_*.bmp']);
% 
for k = 1:length(imageFiles)
    Ipath = fullfile(subfolder, imageFiles(k).name);
    I = imread(Ipath);
    currentWidth = size(I, 2);
    currentHight = size(I, 1);
    targetWidth = 128;
    targetHight = 128;

    paddingWidth = targetWidth - currentWidth;
    paddingHight = targetHight - currentHight;

    leftPadding = floor(paddingWidth / 2);  % Width to be filled on the left
    rightPadding = ceil(paddingWidth / 2);  % Width to be filled on the right
    upPadding = floor(paddingHight / 2);
    downPadding = ceil(paddingHight / 2);

    I_inverted = imcomplement(I);
    I_padded = padarray(I_inverted, [0, leftPadding], 255, 'pre');
    I_padded = padarray(I_padded, [0, rightPadding], 255, 'post');
    I_padded = padarray(I_padded, [upPadding, 0], 255, 'pre'); 
    I_padded = padarray(I_padded, [downPadding, 0], 255, 'post'); 

    I_padded = padarray(I_padded, [13, 13],255, 'both');  % every direction
    I_padded = imresize(I_padded, [128, 128], "bicubic"); % try not distortion

    [~, name, ext] = fileparts(imageFiles(k).name);
    newFileName = fullfile('Photos/test', ['resize_padding_inverted_' name ext]);
    imwrite(I_padded, newFileName);
end
%% 

% Find image files in the specified subfolder
subfolder = fullfile(currentFolder, 'Photos', 'test');
imageFiles = dir(fullfile(subfolder, 'resize_*.bmp'));
numImages = length(imageFiles);
numRows = ceil(sqrt(numImages));
numCols = ceil(numImages / numRows);

% Create a single figure for all images
figure;

for k = 1:numImages
    Ipath = fullfile(subfolder, imageFiles(k).name);
    I = imread(Ipath);
    
    % Preprocess image for the network
    % Convert to grayscale if the image is RGB
    if size(I, 3) == 3
        I = rgb2gray(I);
    end
    
    % Resize to 128x128
    I = imresize(I, [128, 128]);
    
    % Ensure the image has the required dimensions (128x128x1)
    I = reshape(I, [128, 128, 1]);
    
    % Classify the image
    predictedLabel = classify(trainedNet, I);
    
    % Display image and predicted label in a single figure
    subplot(numRows, numCols, k);
    imshow(I, []);
    title(['Predicted Label: ', char(predictedLabel)], 'Interpreter', 'none');
end

% Add a single title for the entire figure
sgtitle('Predicted Labels for Prepocessing Images (CNN)');
%% test MLP

modelPath = fullfile(currentFolder, 'trainedMLPModel.mat');
if isfile(modelPath)
    load(modelPath, 'net'); % Load the correct variable
else
    error('trainedMLPModel.mat file not found. Check the file location.');
end

% Define the relative path to the subfolder
subfolder = fullfile(currentFolder, 'Photos', 'Original');

% Find image files in the specified subfolder
imageFiles = dir(fullfile(subfolder, 'sub_*.bmp'));
numImages = length(imageFiles);
numRows = ceil(sqrt(numImages));
numCols = ceil(numImages / numRows);

% Create a single figure for all images
figure;

for k = 1:numImages
    Ipath = fullfile(subfolder, imageFiles(k).name);
    I = imread(Ipath);
    
    % Preprocess image for the network
    % Convert to grayscale if the image is RGB
    if size(I, 3) == 3
        I = rgb2gray(I);
    end
    
    % Resize to 128x128
    I = imresize(I, [128, 128]);
    
    % Ensure the image has the required dimensions (128x128x1)
    I = reshape(I, [128, 128, 1]);
    
    % Classify the image
    predictedLabel = classify(net, I);
    
    % Display image and predicted label in a single figure
    subplot(numRows, numCols, k);
    imshow(I, []);
    title(['Predicted Label: ', char(predictedLabel)], 'Interpreter', 'none');
end

% Add a single title for the entire figure
sgtitle('Predicted Labels for Original Images (MLP)');
%% 

subfolder = fullfile(currentFolder, 'Photos', 'test');
imageFiles = dir(fullfile(subfolder, 'resize_*.bmp'));
numImages = length(imageFiles);
numRows = ceil(sqrt(numImages));
numCols = ceil(numImages / numRows);

% Create a single figure for all images
figure;

for k = 1:numImages
    Ipath = fullfile(subfolder, imageFiles(k).name);
    I = imread(Ipath);
    
    % Preprocess image for the network
    % Convert to grayscale if the image is RGB
    if size(I, 3) == 3
        I = rgb2gray(I);
    end
    
    % Resize to 128x128
    I = imresize(I, [128, 128]);
    
    % Ensure the image has the required dimensions (128x128x1)
    I = reshape(I, [128, 128, 1]);
    
    % Classify the image
    predictedLabel = classify(net, I);
    
    % Display image and predicted label in a single figure
    subplot(numRows, numCols, k);
    imshow(I, []);
    title(['Predicted Label: ', char(predictedLabel)], 'Interpreter', 'none');
end

% Add a single title for the entire figure
sgtitle('Predicted Labels for Prepocessing Images (MLP)');

