
# How to Run and Execute MIPS Assembly Codes for Image Processing

## Requirements

- **QtSPIM Simulator**: It's recommended to use QtSPIM as the code has been tested on this platform. Other SPIM simulators may work but have not been tested.
- **Text Editor**: Required for editing filenames for the input and output image files.

## Platform Compatibility Note

- **Tested on Windows OS**: The code has been specifically tested on a Windows operating system. While it may also function on Linux or Mac OS, this has not been verified. Therefore, optimal results are more likely to be achieved when running the code on a Windows platform.

## Setup and Configuration

### Step 1: Locate or Create Output File

- Create a new output file manually and ensure it has the `.ppm` extension.


### Step 2: Update File Paths in Code

Open your text editor and locate the following lines in the assembly code:

```assembly
filename_in:  .asciiz "Your absolute path to input file"
filename_out: .asciiz "Your absolute path to output file"
```

Change these lines to match the paths to your input and output files.

### Step 3: Load the Code in QtSPIM

- Open QtSPIM.
- Load the `.asm` file that you want to run.

## Execution

### For `increase_brightness.asm`:

1. Run the code in QtSPIM.
2. The console should display the average pixel value for both the original and new images.

   **Example Output**:

   ```
   Average pixel value of the original image:
   0.72084067350898684
   Average pixel value of the new image:
   0.76005635978349673
   ```

### For `greyscale.asm`:

1. Run the code in QtSPIM.
2. The console should display "File processed successfully" upon completion.

## Viewing Processed Images

- **Using GIMP**: You can use GIMP to view the processed images and assess the algorithm's robustness.
- **File Conversion**: Convert the `.ppm` files to `.png` for easier viewing if GIMP is not available.

## Additional Notes

- A complementary Python script `Q1test.py` is provided to validate the average pixel values calculated by `increase_brightness.asm`.

## Areas for Improvement

### Hardcoding of Input and Output Files

Currently, the file paths for input and output are hardcoded into the assembly files. This could be made more user-friendly but time constraints did not allow for that to be implemented in due time.


By following these steps, you should be able to run and evaluate the MIPS Assembly codes for image processing.