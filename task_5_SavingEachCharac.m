function task_5_SavingEachCharac

    subfolder = 'Photos/';
    imageFiles = dir([subfolder 'sub_*.bmp']);
    
    for k = 1:length(imageFiles)
    
        Ipath = fullfile(subfolder,imageFiles(k).name);
        I = imread(Ipath);
        
        % Otsu Method
        T = graythresh(I);              
        I_bw = im2bw(I,T);                 
    
        I_bw = bwareaopen(I_bw,1000);
        
        se1 = strel('diamond', 2);
        
        process = imdilate(I_bw, se1);
        process = imdilate(process, se1);
        process = imerode(process,se1);
        process = imdilate(process,se1);
        process = imdilate(process,se1);
        I_bw = imerode(process,se1);
        
        [~, name, ~] = fileparts(imageFiles(k).name); 
        newFileName = fullfile(subfolder, sprintf('bw_%s.bmp', name));
        
        imwrite(I_bw, newFileName);
        
        
    end
end
