import subprocess
import re
import csv

# Commands to run
commands = [
    'make run ARGS="1000 1000 -100 100 -100 100 0.1"',
    'make run ARGS="2000 2000 -100 100 -100 100 0.1"',
    'make run ARGS="3000 3000 -100 100 -100 100 0.1"',
    'make run ARGS="4000 4000 -100 100 -100 100 0.1"',
    'make run ARGS="5000 5000 -100 100 -100 100 0.1"',
    'make run ARGS="6000 6000 -100 100 -100 100 0.1"',
    'make run ARGS="7000 7000 -100 100 -100 100 0.1"',
    'make run ARGS="8000 8000 -100 100 -100 100 0.1"',
    'make run ARGS="9000 9000 -100 100 -100 100 0.1"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.1"',
    'make run ARGS="11000 11000 -100 100 -100 100 0.1"',
    'make run ARGS="12000 12000 -100 100 -100 100 0.1"',
    'make run ARGS="13000 13000 -100 100 -100 100 0.1"',
    'make run ARGS="14000 14000 -100 100 -100 100 0.1"',
    'make run ARGS="15000 15000 -100 100 -100 100 0.1"',
    'make run ARGS="16000 16000 -100 100 -100 100 0.1"',
    'make run ARGS="17000 17000 -100 100 -100 100 0.1"',
    'make run ARGS="18000 18000 -100 100 -100 100 0.1"',
    'make run ARGS="19000 19000 -100 100 -100 100 0.1"',
    'make run ARGS="20000 20000 -100 100 -100 100 0.1"',
]


output_file = 'parallel_grid_size_test.csv'
with open(output_file, 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['Test Case', 'Rows', 'Columns', 'Xmin', 'Xmax', 'Ymin', 'Ymax', 'Search Density', 'Time1', 'Time2', 'Time3', 'Time4', 'Time5', 'AvgTime'])

    for idx, cmd in enumerate(commands):
        times = []
        for i in range(5):  # run each command 5 times
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            output = result.stdout

            # Extracting relevant information from output
            rows, columns = re.findall(r"Rows: (\d+), Columns: (\d+)", output)[0]
            xmin, xmax = re.findall(r"x: \[(-?\d+\.\d+), (-?\d+\.\d+)\]", output)[0]
            ymin, ymax = re.findall(r"y: \[(-?\d+\.\d+), (-?\d+\.\d+)\]", output)[0]
            density = re.findall(r"Search density: (-?\d+\.\d+) \(", output)[0]
            time = re.findall(r"Time: (\d+) ms", output)[0]

            # appending to times list for calculating average later
            times.append(int(time))

        avg_time = sum(times)/len(times)  # calculate average time

        writer.writerow([idx+1, rows, columns, xmin, xmax, ymin, ymax, density] + times + [avg_time])
