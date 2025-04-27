function task_3
    %% high-pass filter
    microchip = imread('Photos\5x5_filtered_image.bmp');
    [M, N] = size(microchip);
    
    % Algorithm: Filtering in Frequency Domain - from Lecture chapter 4
    % slide 65
    % Step 1: padding parameters of the image
    P = 2 * M;
    Q = 2 * N;

    % Step 2: form padded image
    microchip_p = zeros(P, Q);
    microchip_p(1:M, 1:N) = microchip;
    
    % Step 3: centre the transform by multiplying padded image microchip_p by (-1)^(x+y)
    [x, y] = meshgrid(0:Q-1, 0:P-1);
    microchip_p = microchip_p .* ((-1).^(x + y));

    % Step 4: Compute the DFT
    Fmicrochip_p = fft2(microchip_p);

    % Step 5: Create a real, symmetric filter function H(u, v) for all
    % three types of high pass filter
    HI = createFilterIdeal (P,Q);
    HB = createFilterButterworth (P,Q);
    HG = createFilterGuassian(P, Q); 

    % Step 6: Form the product G(u, v) = H(u, v) * F(u, v) using array
    % multiplication
    GI = HI .* Fmicrochip_p;
    GB = HB .* Fmicrochip_p;
    GG = HG .* Fmicrochip_p;

    % Step 7: Obtain the processed images
    gpI = real(ifft2(GI));
    gpB = real(ifft2(GB));
    gpG = real(ifft2(GG));

    % undo centering images
    gpI = gpI .* ((-1).^(x + y));
    gpB = gpB .* ((-1).^(x + y));
    gpG = gpG .* ((-1).^(x + y)); 

    % Step 8: Extract the M x N region from the top left quadrant, obtain
    % final processed result
    gI = gpI(1:M, 1:N);
    gB = gpB(1:M, 1:N);
    gG = gpG(1:M, 1:N);

    % display results
    figure;
    subplot (3,1,1);
    imshow(uint8(gI));
    title('Ideal High-Pass Filter');

    subplot (3,1,2);
    imshow(uint8(gB));
    title('Butterworth High-Pass Filter');
    
    subplot (3,1,3);
    imshow(uint8(gG)); 
    title('Gaussian High-Pass Filter');

    % Save the processed image
    imwrite(uint8(gI), 'Photos\highpass.bmp'); % Save as BMP

end

function H = createFilterIdeal (P,Q)
    % Create an Ideal High--pass filter
    [u, v] = meshgrid(-Q/2:Q/2-1, -P/2:P/2-1);
    D0 = 3; % Cut-off frequency
    D = sqrt(u.^2 + v.^2);
    H = double(D > D0); % 1 for high frequencies, 0 for low frequencies
end

function H = createFilterButterworth (P,Q)
    % Create a High-pass Butterworth filter
    [u, v] = meshgrid(-Q/2:Q/2-1, -P/2:P/2-1);
    D0 = 3; % Cut-off frequency
    D = sqrt(u.^2 + v.^2);
    n = 4; % Order of filter
    H = 1- 1 ./ (1 +((D ./ D0).^(2*n)));
    H(D == 0) = 0; % Handle the zero distance case to avoid division by zero
end

function H = createFilterGuassian(P, Q)
    % Create a Gaussian High-pass filter
    [u, v] = meshgrid(-Q/2:Q/2-1, -P/2:P/2-1);
    D0 = 3; % Cut-off frequency
    D = sqrt(u.^2 + v.^2);
    H = 1 - exp(-(D.^2) ./ (2 * (D0^2))); % Gaussian High-pass filter
end