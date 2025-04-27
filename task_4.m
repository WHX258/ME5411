function task_4

    img = imread('Photos\highpass.bmp');
    
    figure;
    rect = [60,206,945-60,127];
    cropped_img = imcrop(img,rect);
    imshow(cropped_img);title('sub-image that includes the middle line – HD44780A00')
%     imwrite(cropped_img,"HD44780A00.bmp")
    % for showing as the question required
    hold on; 
    [height, width, ~] = size(cropped_img);
    segmentWidth = width / 10;
    
    for i = 1:9  
        x = i * segmentWidth;  
        line([x, x], [1, height], 'Color', 'r', 'LineWidth', 2); 
    end
    hold off; 
    
    for i = 1:10

        x_start = round((i-1) * segmentWidth) + 1;
        x_end = round(i * segmentWidth);
        
        % make a avg. cutting for x-axis of picture
        slice_img = cropped_img(:, x_start:x_end, :);

        % Save as sub_i.bmp in Photos folder
%         figure, imshow(slice_img);
        base_name = 'sub';
        extention = '.bmp';
        imwrite(slice_img,sprintf('%s%s_%d%s','Photos\', base_name, i, extention))
        
    end


end
