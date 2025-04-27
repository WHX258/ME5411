# ME5411_CA_GUI

This MATLAB-based GUI was developed as part of the ME5411 course assignment. 
The GUI facilitates the execution of multiple tasks, with each task unlocking sequentially as users progress.

## Authors

- Goh Jian Wei Nigel (A0304764A)
- Li Hongyi (A0285183X)
- Wang Hexian (A0304376E)

---

## Prerequisites

- Ensure that all required MATLAB functions (`task_1`, `task_2`, ..., `task_8_9_testimage`, etc.) are available in the same directory as the GUI script.
- Required files:
  - `AlexNet.mat`
  - Subfolder `Photos/` containing necessary images.

---

## How to Run the GUI

1. **Locate the Script**: Ensure the `ME5411_CA_GUI.m` script is in the same directory as the required MATLAB task scripts.
2. **Start the GUI**:
   - Open MATLAB.
   - Set the current directory to the folder containing the `ME5411_CA_GUI.m` file.
   - Run the following command in the MATLAB Command Window:
     ```matlab
     ME5411_CA_GUI
     ```
3. **Navigate Through Tasks**:
   - The GUI consists of 8 tasks arranged as buttons.
   - Initially, only Task 1 is enabled. Complete each task to unlock the next.
   - Tasks 1–4 are displayed in the left column, and Tasks 5–8 are in the right column.

---

## Instructions for Each Task

1. **Task 1**: Click the **Task 1** button to execute the corresponding function (`task_1`). This enables the **Task 2** button.
2. **Task 2**: Execute by clicking the **Task 2** button, which runs the `task_2` function. This enables the **Task 3** button.
3. **Task 3**: Follow the same process for Tasks 3 through 8, completing each to unlock the next.
4. **Task 8 and 9**: The final task runs `task_8_9_testimage` to test the CNN on the segmented characters from charact2.bmp and saves results.

---

## Quit Button

To close the GUI, press the **Quit** button at any time.

---

## Troubleshooting

- **Missing Files**: Ensure all dependent files (e.g., `AlexNet.mat`, `Photos/` folder) are present in the same directory.
- **Window Resize Issues**: The GUI dynamically adjusts button positions to accommodate different window sizes. If elements are misaligned, resize the window to refresh the layout.

---

## Notes

- In the folder, there will be other files that are not called by the GUI. These are to train the neural networks for task 8.
- task_8_subtask_1 is for task 8 subtask 1 and trains the CNN to produce the AlexNet.mat file
- task_8_sub2_MLP_from_scach and task_8_sub2_MLP_with_toolbox trains the MLP without and with MATLAB deep learning toolbox functions to produce the trainedMLPModel.mat file

## Credits

Developed as part of the CA project for ME5411 Coursework.
