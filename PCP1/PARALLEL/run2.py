import subprocess
import re
import csv

# Commands to run
commands = [
    '"C:\\Program Files\\Java\\jdk-20\\bin\\java.exe" "-XX:+ShowCodeDetailsInExceptionMessages" "-cp" "C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\CSC2002S\\CSC2002S-2023\\PCP1\\PARALLEL\\bin" "MonteCarloMini.MonteCarloMinimization" 2500 2500 -5 5 -5 5 1',
    '"C:\\Program Files\\Java\\jdk-20\\bin\\java.exe" "-XX:+ShowCodeDetailsInExceptionMessages" "-cp" "C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\CSC2002S\\CSC2002S-2023\\PCP1\\PARALLEL\\bin" "MonteCarloMini.MonteCarloMinimization" 3000 3000 -5 5 -5 5 1',
    '"C:\\Program Files\\Java\\jdk-20\\bin\\java.exe" "-XX:+ShowCodeDetailsInExceptionMessages" "-cp" "C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\CSC2002S\\CSC2002S-2023\\PCP1\\PARALLEL\\bin" "MonteCarloMini.MonteCarloMinimization" 3500 3500 -5 5 -5 5 1',
    '"C:\\Program Files\\Java\\jdk-20\\bin\\java.exe" "-XX:+ShowCodeDetailsInExceptionMessages" "-cp" "C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\CSC2002S\\CSC2002S-2023\\PCP1\\PARALLEL\\bin" "MonteCarloMini.MonteCarloMinimization" 4000 4000 -5 5 -5 5 1',
    '"C:\\Program Files\\Java\\jdk-20\\bin\\java.exe" "-XX:+ShowCodeDetailsInExceptionMessages" "-cp" "C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\CSC2002S\\CSC2002S-2023\\PCP1\\PARALLEL\\bin" "MonteCarloMini.MonteCarloMinimization" 4500 4500 -5 5 -5 5 1',
    '"C:\\Program Files\\Java\\jdk-20\\bin\\java.exe" "-XX:+ShowCodeDetailsInExceptionMessages" "-cp" "C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\CSC2002S\\CSC2002S-2023\\PCP1\\PARALLEL\\bin" "MonteCarloMini.MonteCarloMinimization" 5000 5000 -5 5 -5 5 1',
    '"C:\\Program Files\\Java\\jdk-20\\bin\\java.exe" "-XX:+ShowCodeDetailsInExceptionMessages" "-cp" "C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\CSC2002S\\CSC2002S-2023\\PCP1\\PARALLEL\\bin" "MonteCarloMini.MonteCarloMinimization" 5500 5500 -5 5 -5 5 1',
    '"C:\\Program Files\\Java\\jdk-20\\bin\\java.exe" "-XX:+ShowCodeDetailsInExceptionMessages" "-cp" "C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\CSC2002S\\CSC2002S-2023\\PCP1\\PARALLEL\\bin" "MonteCarloMini.MonteCarloMinimization" 6000 6000 -5 5 -5 5 1',
    '"C:\\Program Files\\Java\\jdk-20\\bin\\java.exe" "-XX:+ShowCodeDetailsInExceptionMessages" "-cp" "C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\CSC2002S\\CSC2002S-2023\\PCP1\\PARALLEL\\bin" "MonteCarloMini.MonteCarloMinimization" 6500 6500 -5 5 -5 5 1',
    '"C:\\Program Files\\Java\\jdk-20\\bin\\java.exe" "-XX:+ShowCodeDetailsInExceptionMessages" "-cp" "C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\CSC2002S\\CSC2002S-2023\\PCP1\\PARALLEL\\bin" "MonteCarloMini.MonteCarloMinimization" 7000 7000 -5 5 -5 5 1',
    '"C:\\Program Files\\Java\\jdk-20\\bin\\java.exe" "-XX:+ShowCodeDetailsInExceptionMessages" "-cp" "C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\CSC2002S\\CSC2002S-2023\\PCP1\\PARALLEL\\bin" "MonteCarloMini.MonteCarloMinimization" 7500 7500 -5 5 -5 5 1',
    '"C:\\Program Files\\Java\\jdk-20\\bin\\java.exe" "-XX:+ShowCodeDetailsInExceptionMessages" "-cp" "C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\CSC2002S\\CSC2002S-2023\\PCP1\\PARALLEL\\bin" "MonteCarloMini.MonteCarloMinimization" 8000 8000 -5 5 -5 5 1',
    '"C:\\Program Files\\Java\\jdk-20\\bin\\java.exe" "-XX:+ShowCodeDetailsInExceptionMessages" "-cp" "C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\CSC2002S\\CSC2002S-2023\\PCP1\\PARALLEL\\bin" "MonteCarloMini.MonteCarloMinimization" 8500 8500 -5 5 -5 5 1',
    '"C:\\Program Files\\Java\\jdk-20\\bin\\java.exe" "-XX:+ShowCodeDetailsInExceptionMessages" "-cp" "C:\\Users\\User\\OneDrive - University of Cape Town\\Desktop\\CSC2002S\\CSC2002S-2023\\PCP1\\PARALLEL\\bin" "MonteCarloMini.MonteCarloMinimization" 9000 9000 -5 5 -5 5 1',

]

output_file = 'output.csv'
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
            xmin, xmax = re.findall(r"x: \[(-?\d+,\d+), (-?\d+,\d+)\]", output)[0]
            ymin, ymax = re.findall(r"y: \[(-?\d+,\d+), (-?\d+,\d+)\]", output)[0]
            density = re.findall(r"Search density: (\d+,\d+)", output)[0]
            time = re.findall(r"Time: (\d+) ms", output)[0]

            # appending to times list for calculating average later
            times.append(int(time))

        avg_time = sum(times)/len(times)  # calculate average time

        writer.writerow([idx+1, rows, columns, xmin, xmax, ymin, ymax, density] + times + [avg_time])
