from pyftdi.spi import SpiController
import time
import board
import digitalio

def add_leading_zeros(data, num_zeros=8):
    prefix = [0x00] * num_zeros
    return prefix + data


def add_trailing_zeros(data, num_zeros=8):
    suffix = [0x00] * num_zeros
    return data + suffix


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

        # Test data to send
        zeros = [0x00]
        cases = [
            [0xFF,     0x11, 0x11, 0x11   ],  # case1
            [0xFF,     0x22, 0x22, 0x22   ],  # case2
            [0xFF,     0x33, 0x33, 0x33   ],  # case3
            [0xFF,     0x44, 0x44, 0x44   ],  # case4
            [0xFF,     0x55, 0x55, 0x55   ],  # case5
            [0xFF,     0x66, 0x66, 0x66   ],  # case6
            [0xFF,     0x77, 0x77, 0x77   ],  # case7
            [0xFF,     0x88, 0x88, 0x88   ],  # case8
            [0xFF,     0x99, 0x99, 0x99   ],  # case9
            [0xFF,     0xAA, 0xAA, 0xAA   ],  # case10
            [0xFF,     0xBB, 0xBB, 0xBB   ],  # case11
            [0xFF,     0xCC, 0xCC, 0xCC   ],  # case12
            [0xFF,     0xDD, 0xDD, 0xDD   ],  # case13
            [0xFF,     0xEE, 0xEE, 0xEE   ],  # case14
            [0xFF,     0xFF, 0xFF, 0xFF   ],  # case15
        ]

        case_count = 0

        while True:
            while (cs_pin.value == True): # stay in a loop until active low
                pass
            case_to_send = cases[case_count]
            byte_string = add_leading_zeros(case_to_send, num_zeros=2) 
            byte_string = add_trailing_zeros(byte_string, num_zeros=1) 
            received_data = slave.write(byte_string)
            # print (f"sent {byte_string} : case {case_count+1}")
            print (f"sent case {case_count+1}")
            case_count = (case_count + 1) % len(cases)  # Move to the next case, looping back to 0 if end reached
            while (cs_pin.value == False): # after data sent, stay in this mode until cs pin is high again
                pass
              

    finally:
        # Clean up and close the SPI connection
        spi.terminate()

if __name__ == "__main__":
    test_pyftdi_spi()
