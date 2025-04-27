% Loading the dataset
folderPath = 'Photos/p_dataset_26/p_dataset_26/dataset/train';
imds = imageDatastore(folderPath, ...
    'IncludeSubfolders', true, ...                   
    'LabelSource', 'foldernames');                   

% Shuffle the dataset
imds = shuffle(imds);

% Acquire the basic parameters of the NN
numImages = numel(imds.Files);
disp(['Number of images: ', num2str(numImages)]);

% Loading the validation set
testFfolderPath = 'Photos/p_dataset_26/p_dataset_26/dataset/test';
imdsTest = imageDatastore(testFfolderPath, ...
    'IncludeSubfolders', true, ...                   
    'LabelSource', 'foldernames');   
numImagesTest = numel(imdsTest.Files);

img = readimage(imds, 1);
imgSize = size(img);
disp(['Image size: ', num2str(imgSize)]);

uniqueLabels = unique(imds.Labels);
numLabels = numel(uniqueLabels); 
disp(['Number of unique labels: ', num2str(numLabels)]);

% Get the one-hot encoding of the labels:
% Convert the labels to categorical integers
[labels, originalGroups] = grp2idx(imds.Labels);  % Convert categorical labels to numeric indices
labelsTest = arrayfun(@(x) find(originalGroups == x, 1), imdsTest.Labels);  % Map test labels to training groups

% Initialize a one-hot encoded matrix
oneHotLabels = zeros(numLabels, length(labels));

% Convert labels to one-hot encoding
for i = 1:length(labels)
    oneHotLabels(labels(i), i) = 1;
end

% Convert the images to a nx1 vector
inputDims = inputSize(1) * inputSize(2);
imagesMatrix = zeros(inputDims, numImages);   % Initialize the matrix
for i = 1:numImages
    img = readimage(imds, i);         % Read the image
    imgVector = img(:);               % Flatten the image into a column vector
    imagesMatrix(:, i) = imgVector;   % Place the vector into the matrix
end

% Convert test set to nx1 vector
imagesMatrixTest = zeros(inputDims, numImagesTest);   % Initialize the matrix
for i = 1:numImagesTest
    img = readimage(imdsTest, i);         % Read the image
    imgVector = img(:);               % Flatten the image into a column vector
    imagesMatrixTest(:, i) = imgVector;   % Place the vector into the matrix
end
%% 
% Defination of the MLP
inputDims = imgSize(1) * imgSize(2);


nnLayers = [inputDims 256 128 numLabels];
nnLayerNum = size(nnLayers);

batchSize = 64;
epoch = 5;
lr = 0.00001;

% Forward Prop
% Initialize the parameters
W = cell(1, nnLayerNum(2) - 1);
b = cell(1, nnLayerNum(2) - 1);
for i = 1:nnLayerNum(2)-1
    W{i} = randn(nnLayers(i), nnLayers(i+1)) * 0.01;
    b{i} = randn(nnLayers(i+1), 1) * 0.01;
end

% Record the training process
lossRec = zeros(epoch * int32(numImages / batchSize), 1);
AccRec = zeros(epoch * int32(numImages / batchSize), 1);
count = 0;

% Learning process
for e = 1:epoch
    % Learning rate decay
    lr = lr; 
    % Divide into batch
    for a = 1:int32(numImages / batchSize)
        count = count + 1;
        batchStart = (a - 1) * batchSize + 1;
        batchEnd = min(a * batchSize, numImages);

        % Initialize middle parameters
        n = nnLayerNum(2) - 1;
        A = cell(1, n + 1);
        Z = cell(1, n + 1);
        % Gradient Descent Forward Propagation
        A{1} = imagesMatrix(:, batchStart:batchEnd);
        for i = 1:n
            Z{i+1} = W{i}' * A{i} + b{i};
            if i < n
                % ReLU activation
                A{i+1} = max(Z{i+1}, 0);
            else
                A{i+1} = softmax(Z{i+1});
            end
        end

        % Calculate the loss
        trueValue = oneHotLabels(:, batchStart:batchEnd);
        loss = -mean(sum(trueValue .* log(A{n+1}), 1));
        
        % Display the loss
        lossRec(count) = mean(loss);
        disp(['Loss: ', num2str(mean(loss))]);
        
        % Validate the data
        [~, trueClassLabels] = max(trueValue, [], 1);
        [~, predictedLabels] = max(A{n+1}, [], 1);
        accuracy = mean(predictedLabels == trueClassLabels) * 100;
        % disp(['Accuracy: ', num2str(accuracy), '%']);
        AccRec(count) = accuracy;

        % Back propagation
        dA = cell(1, n + 1);
        dW = cell(1, n);
        db = cell(1, n);
        dA{n+1} = A{n+1} - trueValue;
        for i = n:-1:1
            if i == n
                dZ{i+1} = dA{i+1};
            else
                dZ{i+1} = dA{i+1};
                dZ{i+1}(Z{i+1} <= 0) = 0;
            end
            dA{i} = W{i} * dZ{i+1};

            dW{i} = A{i} * dZ{i+1}';
            db{i} = sum(dZ{i+1}, 2);
            W{i} = W{i} - lr * dW{i};
            b{i} = b{i} - lr * db{i};
        end

    end

end

%% Validate the training results via test set
n = nnLayerNum(2) - 1;
A = cell(1, n + 1);
Z = cell(1, n + 1);
% Gradient Descent Forward Propagation
A{1} = imagesMatrixTest;
for i = 1:n
    Z{i+1} = W{i}' * A{i} + b{i};
    if i < n
        % ReLU activation
        A{i+1} = max(Z{i+1}, 0);
    else
        A{i+1} = softmax(Z{i+1});
    end
end

% Validate the data
[g, predictedLabels] = max(A{n+1}, [], 1);
accuracy = mean(predictedLabels == labelsTest') * 100;
disp(['Accuracy: ', num2str(accuracy), '%']);
plot(lossRec)

%% Validate using the segmented data
% Loading the validation set
testFfolderPath = 'Photos/test';
imdsVal = imageDatastore(testFfolderPath, ...
    'IncludeSubfolders', true, ...                   
    'LabelSource', 'foldernames');   
% imdsVal.ReadFcn = @(filename) im2gray(imread(filename));
numImagesVal = numel(imdsVal.Files);

imagesMatrixVal = zeros(inputDims, numImagesVal);   % Initialize the matrix
for i = 1:numImagesVal
    img = readimage(imds, i);         % Read the image
    imgVector = img(:);               % Flatten the image into a column vector
    imagesMatrixVal(:, i) = imgVector;   % Place the vector into the matrix
end

% Forward pass
n = nnLayerNum(2) - 1;
A = cell(1, n + 1);
Z = cell(1, n + 1);
% Gradient Descent Forward Propagation
A{1} = imagesMatrixVal;
for i = 1:n
    Z{i+1} = W{i}' * A{i} + b{i};
    if i < n
        % ReLU activation
        A{i+1} = max(Z{i+1}, 0);
    else
        A{i+1} = softmax(Z{i+1});
    end
end

% Predict
[g, predictedIndices] = max(A{n+1}, [], 1);

predictedLabels = originalGroups(predictedIndices);

% Display images with their predicted labels
numImages = 10; 
figure;
for i = 1:numImages
    subplot(2, 5, i);
    img = readimage(imdsVal, i);
    predictedLabel = predictedLabels(i);
    imshow(img);
    title(['Predicted: ', char(predictedLabel)]);
end
