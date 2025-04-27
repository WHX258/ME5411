function task_4_origin

    img = imread('Photos\charact2.bmp');

    figure;
    rect = [60,206,945-60,127];
    cropped_img = imcrop(img,rect);
    imshow(cropped_img);title('sub-image that includes the middle line – HD44780A00')

    imwrite(cropped_img,"Photos\original\HD44780A00.bmp")
    [~, width, ~] = size(cropped_img);
    segmentWidth = width / 10;

    for i = 1:10

        x_start = round((i-1) * segmentWidth) + 1;
        x_end = round(i * segmentWidth);
        
        % make a avg. cutting for x-axis of picture
        slice_img = cropped_img(:, x_start:x_end, :);

        % Save as sub_i.bmp in Photos folder
        figure, imshow(slice_img);
        base_name = 'sub';
        extention = '.bmp';
        imwrite(slice_img,sprintf('%s%s_%d%s','Photos\original\', base_name, i, extention))
        
    end
    
    subfolder = 'Photos/original/';
    imageFiles = dir([subfolder 'sub_*.bmp']);
    
    for k = 1:length(imageFiles)
    
        Ipath = fullfile(subfolder, imageFiles(k).name);
        I = imread(Ipath);

        currentWidth = size(I, 2);
        targetWidth = 128;
        paddingWidth = targetWidth - currentWidth;
        leftPadding = floor(paddingWidth / 2);  
        rightPadding = ceil(paddingWidth / 2);  
    
        I_padded = padarray(I, [0, leftPadding], 255, 'pre'); 
        I_padded = padarray(I_padded, [0, rightPadding], 255, 'post');
    
        [~, name, ext] = fileparts(imageFiles(k).name);
        newFileName = fullfile(subfolder, ['origin_pad_' name ext]);
        imwrite(I_padded, newFileName);
    end

end
