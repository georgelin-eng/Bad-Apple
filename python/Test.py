import time
import os
from pyftdi.spi import SpiController

spi = SpiController()
spi.configure('ftdi://ftdi:232h/1')
slave = spi.get_port(cs=0, freq=1E6, mode = 0)

def read_bits_from_file(file_path):
    with open(file_path, 'r') as file:
        bits_string = file.read().strip()  # Read all bits and remove any surrounding whitespace
        bits_list = [int(bit) for bit in bits_string if bit.strip() in ('0', '1')]  # Convert each character to an integer (0 or 1)
    return bits_list

def bits_to_bytes(bits):
    # Ensure the length of bits is a multiple of 8 (assuming complete bytes)
    if len(bits) % 8 != 0:
        raise ValueError("Length of bits must be a multiple of 8 for byte conversion")

    bytes_list = []
    for i in range(0, len(bits), 8):
        byte = 0
        for j in range(8):
            byte = (byte << 1) | bits[i + j]
        bytes_list.append(byte)
    
    return bytes_list

directory_path = os.getcwd()
directory_path = os.path.join(directory_path, 'rtl\\frames')
file_path = os.path.join(directory_path, "frame_1.mem")
prefix = 'frame'
start_frame = 1
end_frame = 1

# Simulating the cs_pin.value check
class Pin:
    def __init__(self, initial_state=True):
        self.value = initial_state

# Create a simulated pin
cs_pin = Pin(initial_state=True)

# Measure the time for a large number of iterations
iterations = 15 * 10
iteration_times = []

video_bytes = 56250 + 1 + 250
audio_bytes = 32000 + 1 + 250
num_bytes = video_bytes + audio_bytes

#################################################

bit_stream = read_bits_from_file(file_path)
bytes_list = bits_to_bytes(bit_stream) 

for _ in range(iterations):
    iteration_start_time = time.time()  # Start time for this iteration

    while cs_pin.value:
        break  # Immediately break to measure loop overhead
    slave.write(bytes_list)

    iteration_end_time = time.time()  # Start time for this iteration
    
    iteration_time = iteration_end_time - iteration_start_time
    iteration_times.append(iteration_time)
    print(f"Done loop : iteration time = {iteration_time}")

bytes_list = len(bit_stream) * iterations

# print (bit_stream)

# Calculate the total time, average time, and maximum time per iteration
total_time = sum(iteration_times)
time_per_iteration = (total_time / iterations) 
max_time_per_iteration = max(iteration_times) 

print(f"Total time for {iterations} iterations: {total_time:.6f} seconds")
print(f"Average time per iteration: {time_per_iteration:.6f} seconds")
print(f"Maximum time for a single iteration: {max_time_per_iteration:.6f} seconds")