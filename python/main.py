from pyftdi.spi import SpiController
import time
import board
import digitalio
import os

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

def test_pyftdi_spi():
    # Create an SPI controller instance
    spi = SpiController()


    # GPIO pin configuration
    cs_pin = digitalio.DigitalInOut(board.C0)
    cs_pin.direction = digitalio.Direction.INPUT

    try:
        # Configure the first interface (IF/0) of the FT232H as an SPI master
        spi.configure('ftdi://ftdi:232h/1')


        # Get a port to a SPI slave (CS line is 0)
        slave = spi.get_port(cs=0, freq=1E6, mode = 0)

        while True:
            while (cs_pin.value == True): # stay in a loop until active low
                pass

            print ("Processing payload")
            image = read_image_file(file_path)
            bit_string = serialize_image(image)
            byte_array = bits_to_bytes(bit_string) * 15
            # byte_array = bytearray             ([0x80, 0xAA, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00,0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])
            # byte_array = byte_array + bytearray([0x0F])
            # byte_array = byte_array + bytearray([0x40, 0xAA, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00,0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])
            # byte_array = byte_array + bytearray([0xAA, 0xAA, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00,0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])

            print ("sending video payload...")
            print((len(byte_array) * 8))
            byte_array = add_leading_zeros(byte_array, num_zeros=0) 
            byte_array = add_trailing_zeros(byte_array, num_zeros=1) 
            byte_array = bytearray([0xFF]) + byte_array

            slave.write(byte_array)
            print ("sent")

            while (cs_pin.value == False): # after data sent, stay in this mode until cs pin is high again
                pass
              

    finally:
        # Clean up and close the SPI connection
        spi.terminate()
       
directory_path = os.getcwd()
directory_path = os.path.join(directory_path, 'python\\output_bitmaps') 
# directory_path = os.path.join(directory_path, 'python\\simple_test') 
# file_path = os.path.join(directory_path, "HEX_bits.txt")
file_path = os.path.join(directory_path, "frame_0044.txt")
if __name__ == "__main__":
    test_pyftdi_spi()
