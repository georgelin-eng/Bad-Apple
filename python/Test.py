import time
import os
from pyftdi.spi import SpiController

spi = SpiController()
spi.configure('ftdi://ftdi:232h/1')
slave = spi.get_port(cs=0, freq=1E6, mode = 0)

def add_leading_zeros(data, num_zeros=8):
    prefix = bytearray([0x00] * num_zeros)
    return prefix + data

def add_trailing_zeros(data, num_zeros=8):
    suffix = bytearray([0x00] * num_zeros)
    return data + suffix

def read_image_file(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    image = [line.strip().split() for line in lines]
    return image


def serialize_image(image):
    serialized_data = ''.join(''.join(row) for row in image)
    return serialized_data

def bits_to_bytes(bit_string):
    byte_array = bytearray()
    for i in range(0, len(bit_string), 8):
        byte = bit_string[i:i+8]
        byte_array.append(int(byte, 2))
    return byte_array

# Simulating the cs_pin.value check
class Pin:
    def __init__(self, initial_state=True):
        self.value = initial_state

# Create a simulated pin
cs_pin = Pin(initial_state=True)

# Measure the time for a large number of iterations
iterations = 15 * 10
iteration_times = []


#################################################

for _ in range(iterations):
    iteration_start_time = time.time()  # Start time for this iteration

    while cs_pin.value:
        break  # Immediately break to measure loop overhead


        byte_array = bytearray()
        for i in range (15):
            file_path = os.path.join(directory_path, f"frame_{frame:04d}.txt")
            image = read_image_file(file_path)
            bit_string = serialize_image(image)
            byte_array = byte_array + bits_to_bytes(bit_string)
            frame = frame + 1

            if (frame == 6566):
                frame = 0





    iteration_end_time = time.time()  # Start time for this iteration
    iteration_time = iteration_end_time - iteration_start_time
    iteration_times.append(iteration_time)
    print(f"Done loop : iteration time = {iteration_time}")


# print (bit_stream)

# Calculate the total time, average time, and maximum time per iteration
total_time = sum(iteration_times)
time_per_iteration = (total_time / iterations) 
max_time_per_iteration = max(iteration_times) 

print(f"Total time for {iterations} iterations: {total_time:.6f} seconds")
print(f"Average time per iteration: {time_per_iteration:.6f} seconds")
print(f"Maximum time for a single iteration: {max_time_per_iteration:.6f} seconds")




directory_path = os.getcwd()
directory_path = os.path.join(directory_path, 'python\\output_bitmaps') 
if __name__ == "__main__":
    test_pyftdi_spi()
