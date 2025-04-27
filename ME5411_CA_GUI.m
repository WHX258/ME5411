% Filename: ME5411_CA_GUI.m
% Done by:
% Goh Jian Wei Nigel    A0304764A
% Li Hongyi              A0285183X
% Wang Hexian            A0304376E

function ME5411_CA_GUI
    %% Create the main figure
    fig = figure('Name', 'ME5411 CA GUI', ...
                 'Resize', 'on', ...
                 'SizeChangedFcn', @resizeCallback, ...
                 'Position', [100, 100, 600, 400]); % Adjusted width for two columns
    
    %% Define the subfolder variable
    subfolder = 'Photos/';

    %% Create a struct to hold all button handles
    btns = struct();
    
    %% Create buttons for tasks (two columns)
    % Left column: Tasks 1-4
    btns.Task1 = uicontrol('Parent', fig, ...
                           'Style', 'pushbutton', ...
                           'String', 'Task 1', ...
                           'Units', 'normalized', ...
                           'Position', [0.1, 0.75, 0.35, 0.1], ...
                           'Enable', 'on', ...
                           'Callback', @Task1ButtonPushed);

    btns.Task2 = uicontrol('Parent', fig, ...
                           'Style', 'pushbutton', ...
                           'String', 'Task 2', ...
                           'Units', 'normalized', ...
                           'Position', [0.1, 0.6, 0.35, 0.1], ...
                           'Enable', 'off', ...
                           'Callback', @Task2ButtonPushed);

    btns.Task3 = uicontrol('Parent', fig, ...
                           'Style', 'pushbutton', ...
                           'String', 'Task 3', ...
                           'Units', 'normalized', ...
                           'Position', [0.1, 0.45, 0.35, 0.1], ...
                           'Enable', 'off', ...
                           'Callback', @Task3ButtonPushed);

    btns.Task4 = uicontrol('Parent', fig, ...
                           'Style', 'pushbutton', ...
                           'String', 'Task 4', ...
                           'Units', 'normalized', ...
                           'Position', [0.1, 0.3, 0.35, 0.1], ...
                           'Enable', 'off', ...
                           'Callback', @Task4ButtonPushed);

    % Right column: Tasks 5-8
    btns.Task5 = uicontrol('Parent', fig, ...
                           'Style', 'pushbutton', ...
                           'String', 'Task 5', ...
                           'Units', 'normalized', ...
                           'Position', [0.55, 0.75, 0.35, 0.1], ...
                           'Enable', 'off', ...
                           'Callback', @Task5ButtonPushed);

    btns.Task6 = uicontrol('Parent', fig, ...
                           'Style', 'pushbutton', ...
                           'String', 'Task 6', ...
                           'Units', 'normalized', ...
                           'Position', [0.55, 0.6, 0.35, 0.1], ...
                           'Enable', 'off', ...
                           'Callback', @Task6ButtonPushed);

    btns.Task7 = uicontrol('Parent', fig, ...
                           'Style', 'pushbutton', ...
                           'String', 'Task 7', ...
                           'Units', 'normalized', ...
                           'Position', [0.55, 0.45, 0.35, 0.1], ...
                           'Enable', 'off', ...
                           'Callback', @Task7ButtonPushed);

    btns.Task8 = uicontrol('Parent', fig, ...
                           'Style', 'pushbutton', ...
                           'String', 'Task 8 & 9', ...
                           'Units', 'normalized', ...
                           'Position', [0.55, 0.3, 0.35, 0.1], ...
                           'Enable', 'off', ...
                           'Callback', @Task8ButtonPushed);

    %% Add a Quit button
    btns.Quit = uicontrol('Parent', fig, ...
                          'Style', 'pushbutton', ...
                          'String', 'Quit', ...
                          'Units', 'normalized', ...
                          'Position', [0.35, 0.1, 0.3, 0.1], ...
                          'Enable', 'on', ...
                          'Callback', @(~, ~) close(fig));

    %% Callback Functions for Tasks
    function Task1ButtonPushed(~, ~)
        % Run Task 1
        task_1();
        % Enable Task 2 button
        btns.Task2.Enable = 'on';
    end

    function Task2ButtonPushed(~, ~)
        % Run Task 2
        task_2();
        % Enable Task 3 button
        btns.Task3.Enable = 'on';
    end

    function Task3ButtonPushed(~, ~)
        % Run Task 3
        task_3();
        % Enable Task 4 button
        btns.Task4.Enable = 'on';
    end

    function Task4ButtonPushed(~, ~)
        % Run Task 4
        task_4();
        task_4_origin();
        % Enable Task 5 button
        btns.Task5.Enable = 'on';
    end

    function Task5ButtonPushed(~, ~)
        % Run Task 5
        task_5_compare();
        task_5_SavingEachCharac();
        % Enable Task 6 button
        btns.Task6.Enable = 'on';
    end

    function Task6ButtonPushed(~, ~)
        % Run Task 6
        task_6();
        % Enable Task 7 button
        btns.Task7.Enable = 'on';
    end

    function Task7ButtonPushed(~, ~)
        % Run Task 7
        task_7();
        % Enable Task 8 button
        btns.Task8.Enable = 'on';
    end

     function Task8ButtonPushed(~, ~)
        try
            % Save the current working directory
            originalFolder = pwd;
    
            % Change to the GUI's folder (where task_8_testimage expects to work)
            currentFolder = fileparts(mfilename('fullpath'));
            cd(currentFolder);
    
            % Ensure that all required variables are defined in the base workspace
            assignin('base', 'currentFolder', currentFolder); % Define currentFolder in the base workspace
            assignin('base', 'modelPath', fullfile(currentFolder, 'AlexNet.mat')); % Define modelPath
    
            % Call task_8_testimage in the base workspace
            evalin('base', 'task_8_9__testimage();');
    
            % Restore the original working directory
            cd(originalFolder);
    
            % Show a success message
            msgbox('Task 8 & 9 completed successfully!', 'Success');
        catch ME
            % Restore the original working directory in case of error
            cd(originalFolder);
    
            % Display an error message
            msgbox(['Error in Task 8 & 9: ', ME.message], 'Error', 'error');
        end
    end





    %% Resize Callback Function
    function resizeCallback(~, ~)
        % Dynamically adjust button positions based on figure size
        btns.Task1.Position = [0.1, 0.75, 0.35, 0.1];
        btns.Task2.Position = [0.1, 0.6, 0.35, 0.1];
        btns.Task3.Position = [0.1, 0.45, 0.35, 0.1];
        btns.Task4.Position = [0.1, 0.3, 0.35, 0.1];
        
        btns.Task5.Position = [0.55, 0.75, 0.35, 0.1];
        btns.Task6.Position = [0.55, 0.6, 0.35, 0.1];
        btns.Task7.Position = [0.55, 0.45, 0.35, 0.1];
        btns.Task8.Position = [0.55, 0.3, 0.35, 0.1];
        
        btns.Quit.Position = [0.35, 0.1, 0.3, 0.1];
    end
end
