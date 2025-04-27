% task_6.m

function task_6
    img_raw = imread("Photos/charact2.bmp");
    img_grey = rgb2gray(img_raw);
    
    
    img_grey = imadjust(img_grey, [0.3 0.6], [0 1]);
    % Erosion
    se = strel('disk', 3);
    img_grey = imerode(img_grey, se);
%     imshow(img_grey);
    
    % Preprocessing (Gaussian Blurring)
    gaussian_kernel = fspecial('gaussian', 11, 15); 
    img_grey = conv2(img_grey, gaussian_kernel);
    img_grey = uint8(img_grey);
%     imshow(img_grey);
    
    img_grey1 = imadjust(img_grey, [0.25 1.0], [0 1]);
%     imshow(img_grey1);
    
%     Laplacian edge detection
    laplacian_kernel = -[0 -1 0; -1 4 -1; 0 -1 0];
    img_grey1 = conv2(double(img_grey1), laplacian_kernel);
    
    figure;
    imshow(img_grey1);title('Laplacian Edge Detection');
    imwrite(img_grey1, 'Photos\Laplacian.bmp');
   


    % Sobel edge detection
    sobel_x = [-1 -2 -1; 0 0 0; 1 2 1];  % Sobel filter in y direction
    sobel_y = [-1 0 1; -2 0 2; -1 0 1];  % Sobel filter in x direction
    
    Gx = conv2(double(img_grey), sobel_x);  % Gradient in x direction
    Gy = conv2(double(img_grey), sobel_y);  % Gradient in y direction
    
    img_grey = sqrt(Gx.^2 + Gy.^2);    % Total magnitude of gradient
    
    
    % Plot the results
    img_grey = uint8(255 * mat2gray(img_grey));  % Uniform the intensities
    edge = img_grey > 90;
    figure;
    imshow(edge);  % Plot the results
    title('Sobel Edge Detection');
    imwrite(edge, 'Photos\Soble.bmp');
end

% Segmentation
