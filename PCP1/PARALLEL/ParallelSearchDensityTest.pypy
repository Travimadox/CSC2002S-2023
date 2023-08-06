import subprocess
import re
import csv

# Commands to run
commands = [
    'make run ARGS="10000 10000 -100 100 -100 100 0.1"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.15"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.2"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.25"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.3"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.35"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.4"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.45"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.5"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.55"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.6"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.65"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.7"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.75"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.8"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.85"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.9"',
    'make run ARGS="10000 10000 -100 100 -100 100 0.95"',
    'make run ARGS="10000 10000 -100 100 -100 100 1"',
]


output_file = 'parallel_search_density_test.csv'
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
