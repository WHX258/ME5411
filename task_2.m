function task_2
    %% 5x5 averaging filter
    microchip = imread('Photos\contrast_stretched_image.bmp');
    
    figure;
    subplot(2,2,1);
    imshow(microchip);
    title('Image after contrast enhancement in task 1');

    % Define kernel (5x5 averaging filter)
    windowSize1 = 5;
    kernel1 = ones(windowSize1, windowSize1) / windowSize1 ^ 2;

    % Apply convolution using conv2
    blurred_microchip5x5 = uint8(conv2(double(microchip), kernel1, 'same'));
    subplot(2,2,2);
    imshow(blurred_microchip5x5);
    title('5x5 averaging mask');

    
    %% 3x3 Averaging filter and 9x9 Averaging filter

    % Define kernel (3x3 averaging filter)
    windowSize2 = 3;
    kernel2 = ones(windowSize2, windowSize2) / windowSize2 ^ 2;

    % Apply convolution using conv2
    blurred_microchip3x3 = uint8(conv2(double(microchip), kernel2, 'same')); 
    
    subplot(2,2,3);
    imshow(blurred_microchip3x3);
    title('3x3 averaging mask');
    
    % Define kernel (9x9 averaging filter)
    windowSize3 = 9;
    kernel3 = ones(windowSize3, windowSize3) / windowSize3 ^ 2;

    % Apply convolution using conv2
    blurred_microchip9x9 = uint8(conv2(double(microchip), kernel3, 'same')); 

    subplot(2,2,4);
    imshow(blurred_microchip9x9);
    title('9x9 averaging mask');

     % Save the processed image
    imwrite(blurred_microchip5x5, 'Photos\5x5_filtered_image.bmp'); 
    
end