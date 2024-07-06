from pyftdi.spi import SpiController
import time

def test_pyftdi_spi():
    # Create an SPI controller instance
    spi = SpiController()

    try:
        # Configure the first interface (IF/1) of the FT232H as an SPI master
        spi.configure('ftdi://ftdi:232h/1')

        # Get a port to a SPI slave (CS line is 0)
        slave = spi.get_port(cs=0)

        # Set SPI frequency to 1MHz
        slave.set_frequency(1E6)

        # Configure the SPI mode (mode 0)
        slave.set_mode(0)

        # Test data to send
        test_data = [0xBB]
        while True:
            # print(f"Sending data: {test_data}")
            received_data = slave.exchange(test_data)

        # Send and receive data
        print(f"Sending data: {test_data}")
        received_data = slave.exchange(test_data)
        print(f"Received data: {received_data}")

    finally:
        # Clean up and close the SPI connection
        spi.terminate()

if __name__ == "__main__":
    test_pyftdi_spi()
