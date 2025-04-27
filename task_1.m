% task_1_notoolbox.m
function task_1_notoolbox
    %% Contrast Stretching
    % Read the image
    mp = imread('Photos/charact2.bmp');  
    disp(size(mp))
    
    if size(mp, 3) == 3
        % Manually convert to grayscale using the luminosity method
        microchip = 0.2989 * double(mp(:, :, 1)) + ...
                    0.5870 * double(mp(:, :, 2)) + ...
                    0.1140 * double(mp(:, :, 3));
        microchip = uint8(microchip);
    else
        microchip = mp; % Already grayscale
    end

    % Display the original image
    figure;
    imshow(microchip, []);
    title('Original Microchip Image');
    
    % Contrast stretching function
    function stretched = contrast_stretch(image, low, high)
        stretched = double(image);
        stretched = (stretched - 255 * low) / (255 * (high - low));
        stretched = max(0, min(1, stretched)); % Clip values to [0, 1]
        stretched = uint8(stretched * 255);
    end

    % Contrast stretching @ upper 10% and lower 10%
    ten_p = contrast_stretch(microchip, 0.10, 0.90);
    figure;
    subplot(2, 2, 1);
    imshow(ten_p, []);
    title('10% upper & lower limit');

    % Contrast stretching @ upper 20% and lower 20%
    twenty_p = contrast_stretch(microchip, 0.20, 0.80);
    subplot(2, 2, 2);
    imshow(twenty_p, []);
    title('20% upper & lower limit');

    % Contrast stretching @ upper 30% and lower 30%
    thirty_p = contrast_stretch(microchip, 0.30, 0.70);
    subplot(2, 2, 3);
    imshow(thirty_p, []);
    title('30% upper & lower limit');

    % Contrast stretching @ upper 40% and lower 40%
    forty_p = contrast_stretch(microchip, 0.40, 0.60);
    subplot(2, 2, 4);
    imshow(forty_p, []);
    title('40% upper & lower limit');

    sgtitle('Contrast Stretching');

    % Save the processed image with contrast stretching @upper and lower 10% 
    imwrite(ten_p, 'Photos/contrast_stretched_image.bmp'); 

    %% Brightness Thresholding 
    %Brightness Thresholding at 50%
    a = size(microchip, 1);
    b = size(microchip, 2);
    microchip_thres = zeros(a, b);
    for i=1:size(microchip_thres,1) 
        for j=1:size(microchip_thres,2)
            if microchip(i,j)<128
                microchip_thres(i,j) = 0;
            else 
                microchip_thres(i,j) = 255;
            end
        end
    end

    figure;
    subplot(2,2,1);
    imshow(microchip);
    title('Orginal Microchip Image');

    subplot(2,2,2);
    imshow(microchip_thres);
    title('50% Brightness Thresholding');

    % Brightness Thresholding at 25%
    c = size(microchip, 1);
    d = size(microchip, 2);
    microchip_thres1 = zeros(c, d);
    for i=1:size(microchip_thres1,1) 
        for j=1:size(microchip_thres1,2)
            if microchip(i,j)<64
                microchip_thres1(i,j) = 0;
            else 
                microchip_thres1(i,j) = 255;
            end
        end
    end

    subplot(2,2,3);
    imshow(microchip_thres1);
    title('25% Brightness Thresholding')


    % Brightness Thresholding at 75%
    c = size(microchip, 1);
    d = size(microchip, 2);
    microchip_thres1 = zeros(c, d);
    for i=1:size(microchip_thres1,1) 
        for j=1:size(microchip_thres1,2)
            if microchip(i,j)<191
                microchip_thres1(i,j) = 0;
            else 
                microchip_thres1(i,j) = 255;
            end
        end
    end

    subplot(2,2,4);
    imshow(microchip_thres1);
    title('75% Brightness Thresholding');

    sgtitle('Brightness Thresholding');

    %% Gray Level Slicing
    i = microchip;
    j=double(i);
    k=double(i);
    [row,col]=size(j);
    T1= 120; 
    T2=200; 
    for x=1:row            
        for y=1:col        
            if((j(x,y)>T1) && (j(x,y)<T2))
                j(x,y)=255;
                k(x,y)=255;
            else
                j(x,y)=i(x,y);
                k(x,y)=0;
            end
        end
    end

    figure;
    subplot(3,1,1), imshow(i), title('Original image')  ; 
    subplot(3,1,2), imshow(uint8(j)), title('Graylevel slicing with background');
    subplot(3,1,3), imshow(uint8(k)), title('Graylevel slicing without background');
    sgtitle ("Gray Level Slicing");


    %% Histogram Equalization
    function [equalized_image] = histogram_equalization(image, nbins)
        % Histogram counts
        hist_counts = histcounts(image(:), 0:256); % Histogram with 256 bins
        cdf = cumsum(hist_counts) / numel(image); % Cumulative distribution function
    
        % Map the original intensity values to equalized values
        equalized_image = uint8(cdf(double(image) + 1) * 255); % Map to 0-255 range
    end
    
    % Main section for display and verification
    figure;
    
    % Original microchip image and histogram
    subplot(2, 2, 1);
    imshow(microchip, []);
    title('Original Microchip Image');
    
    subplot(2, 2, 3);
    imhist(microchip);
    title('Original Microchip Image Histogram');
    
    % Perform histogram equalization
    equalized_image = histogram_equalization(microchip, 256);
    
    % Equalized image and histogram
    subplot(2, 2, 2);
    imshow(equalized_image, []);
    title('Equalized Image');
    
    subplot(2, 2, 4);
    imhist(equalized_image);
    title('Equalized Image Histogram');
    
    sgtitle('Histogram Equalization');

end