function task_5_compare
    subfolder = 'Photos/';
    imageFiles = dir([subfolder 'sub_*.bmp']);
    numImages = length(imageFiles);
    
    % 4*5 compact figure for compare, col 1&3 for ostu other 2 for iter. 
    figure;
    tiledlayout(5, 4, 'TileSpacing', 'compact', 'Padding', 'compact');
    
    for k = 1:numImages
        
        Ipath = fullfile(subfolder, imageFiles(k).name);
        I = im2double(imread(Ipath));
    
        % Otsu Method
        T_otsu = graythresh(I);              
        I_bw = im2bw(I, T_otsu);
    
        % Iterative Thresholding Method
        T0 = 0.01;
        T1 = (min(I(:)) + max(I(:))) / 2;
        r1 = find(I > T1);
        r2 = find(I <= T1);
        T2 = (mean(I(r1)) + mean(I(r2))) / 2;
    
        if abs(T2 - T1) >= T0
            while abs(T2 - T1) >= T0
                T1 = T2;
                r1 = find(I > T1);
                r2 = find(I <= T1);
                T2 = (mean(I(r1)) + mean(I(r2))) / 2;
            end
        end
        J = imbinarize(I, T2);
        
        I_bw = bwareaopen(I_bw,1000);
        se1 = strel('diamond', 2);
        process = imdilate(I_bw, se1);
        process = imdilate(process, se1);
        process = imerode(process,se1);
        process = imdilate(process,se1);
        process = imdilate(process,se1);
        I_bw = imerode(process,se1);
        
        J = bwareaopen(J,1000);
        process = imdilate(J, se1);
        process = imdilate(process, se1);
        process = imerode(process,se1);
        process = imdilate(process, se1);
        process = imdilate(process, se1);
        J = imerode(process,se1);
    
        % k=0,1 row=1, k=2,3, row=2 ...
        row = ceil(k / 2);
        
        if mod(k, 2) == 1
            % 1st col. is I_bw (ostu)
            nexttile((row - 1) * 4 + 1);
            imshow(I_bw);
            if row == 1
                title('Otsu Method'); 
            end
            % 2nd col. is J (Iterative)
            nexttile((row - 1) * 4 + 2);  
            imshow(J);
            if row == 1
                title('Iterative Thresholding Method'); 
            end
        else
            %3rd col. is I_bw
            nexttile((row - 1) * 4 + 3); 
            imshow(I_bw);
            if row == 1
                title('Otsu Method');
            end
            % 4th col. is J (Iterative)
            nexttile((row - 1) * 4 + 4);  
            imshow(J);
            if row == 1
                title('Iterative Thresholding Method'); 
            end
        end
    end
end