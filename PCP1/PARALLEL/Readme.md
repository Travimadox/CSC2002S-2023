# Parallel Program Execution Guide

Welcome to our project! This README provides step-by-step instructions on how to compile and run our parallel program.

## Prerequisites

Please ensure you have `make` installed on your machine. You can verify this by typing the following command in your terminal:

```c
make --version

```

If you don't have `make` installed, please refer to the installation guide based on your operating system [here](https://linuxhint.com/install-make-ubuntu/).

## Step 1: Navigate to the Project Directory

First, open your terminal. Navigate to the project directory using the `cd` command followed by the path to the 'parallel' directory:
```c
cd <path_to_parallel_directory>

```


Replace `<path_to_parallel_directory>` with the actual path where your 'parallel' directory is located.

## Step 2: Compile the Files

After navigating to the 'parallel' directory, use the `make` command to compile the necessary files:

```c
make
```

This command will automatically locate the Makefile in the directory and compile the files as specified.

## Step 3: Run the Program

Now, you are ready to run the program. Use the following `make` command:
```c
make run ARGS="<gridsize> <gridsize> <xmin> <xmax> <ymin> <ymax> <search_density>"

```
Replace `<gridsize>`, `<xmin>`, `<xmax>`, `<ymin>`, `<ymax>`, and `<search_density>` with your desired values. Here's an example:
```c
make run ARGS="1000 1000 -10 10 -10 10 0.1"
```

In this example, the grid size is 1000x1000, x ranges from -10 to 10, y ranges from -10 to 10, and the search density is 0.1.


