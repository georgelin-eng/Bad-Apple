import difflib
import os


def compare_files(file1, file2):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        f1_lines = f1.readlines()
        f2_lines = f2.readlines()

    # Initialize a flag to indicate whether the files are identical
    files_identical = True

    # Find the length of the shorter file to avoid index errors
    min_length = min(len(f1_lines), len(f2_lines))

    # Compare line by line
    for i in range(min_length):
        if f1_lines[i] != f2_lines[i]:
            print(f"Difference at line {i + 1}: {file1} has '{f1_lines[i].strip()}', {file2} has '{f2_lines[i].strip()}'")
            files_identical = False

    # Check if the files have different numbers of lines
    if len(f1_lines) != len(f2_lines):
        files_identical = False
        print(f"The files have different numbers of lines: {file1} has {len(f1_lines)} lines, {file2} has {len(f2_lines)} lines")

    if files_identical:
        print("The files are identical.")

# Change to the testbench directory
testbench_dir = 'testbench'
os.chdir(testbench_dir)

# Example usage
file1 = 'MISO_CDC_data.txt'
file2 = 'sampled_data.txt'
compare_files(file1, file2)
