# Club Simulation Program Execution Guide

Welcome to our project! This README provides step-by-step instructions on how to compile and run our the club simulation program.

## Prerequisites

Please ensure you have `make` installed on your machine. You can verify this by typing the following command in your terminal:

```c
make --version

```

If you don't have `make` installed, please refer to the installation guide based on your operating system [here](https://linuxhint.com/install-make-ubuntu/).

## Step 1: Navigate to the Project Directory

First, open your terminal. Navigate to the project directory using the `cd` command followed by the path to the 'club simulation' directory:
```c
cd <path_to_clubsimulation_directory>

```


Replace `<path_to_clubsimulation_directory>` with the actual path where your 'parallel' directory is located.

## Step 2: Compile the Files

After navigating to the 'parallel' directory, use the `make` command to compile the necessary files:

```c
make
```

This command will automatically locate the Makefile in the directory and compile the files as specified.

## Step 3: Run the Program

Now, you are ready to run the program. Use the following `make` command:
```c
make run ARGS="<noClubgoers> <gridX> <gridY> <max>"

```
Replace `<noClubgoers> <gridX> <gridY> <max>` with your desired values. Here's an example:
```c
make run ARGS="20 10 10 5"
```

In this example, this will run the simulation with:
- 20 total people to enter the room.
- 10 X grid cells.
- 10 Y grid cells.
- A maximum of 5 people allowed in the club at once.



