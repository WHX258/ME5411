function task_7    
    
    I = imread("Photos/Laplacian.bmp");
    O = imread("Photos/charact2.bmp");
    I = bwareaopen(I,800);
    CC = bwconncomp(I,8);   % connected component detection
    stats = regionprops(CC, 'BoundingBox');  % Edge for CC

    width_threshold = 100;
    
    figure;
    subplot_idx = 1; 
    
    total_subplots = 0;
    
    % compute how many charac.
    for k = 1:length(stats)
        bbox = stats(k).BoundingBox;
        width = bbox(3);
        
        if width > width_threshold
            total_subplots = total_subplots + 2;  % if cut then count it to 2 charac,
        else
            total_subplots = total_subplots + 1;  % else count to 1
        end
    end
    
    rows = ceil(total_subplots / 4);
    output_folder = 'Photos\task7';
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end

    for k = 1:length(stats)
        bbox = stats(k).BoundingBox;
        width = bbox(3);
        height = bbox(4);
        
        if width > width_threshold
            % Cut evenly if it's too wide
            mid_x = bbox(1) + width / 2;  
    
            bbox1 = [bbox(1), bbox(2), width / 2, height];
            bbox2 = [mid_x, bbox(2), width / 2, height];
            
            % first edge frame
            cropped1 = imcrop(O, bbox1);
            subplot(rows, 4, subplot_idx);
            imshow(cropped1);
            title(sprintf('Region %d - Part 1', k));
            subplot_idx = subplot_idx + 1;

            save_path1 = fullfile(output_folder, sprintf('region_%d_part1.bmp', k));
            imwrite(cropped1, save_path1);
    
            % 2nd edge frame
            cropped2 = imcrop(O, bbox2);
            subplot(rows, 4, subplot_idx);
            imshow(cropped2);
            title(sprintf('Region %d - Part 2', k));
            subplot_idx = subplot_idx + 1;

            save_path2 = fullfile(output_folder, sprintf('region_%d_part2.bmp', k));
            imwrite(cropped2, save_path2);
            
        else
            % Not so wide then not cut
            cropped = imcrop(O, bbox);
            subplot(rows, 4, subplot_idx);
            imshow(cropped);
            title(sprintf('Region %d', k));
            subplot_idx = subplot_idx + 1;

            save_path = fullfile(output_folder, sprintf('region_%d.bmp', k));
            imwrite(cropped, save_path);
            
        end
    end

end