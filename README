# Bad Apple on FPGA

## Specifications

These are the current compatiable / currently planned specs that this project will run at on the De1-Soc

### Video Spec

| Property                  | Value  |
|---------------------------|--------|
| Resolution                | 800x600|
| Refresh Rate (Hz)         | 60     |
| Pixel Clock (MHz)         | 40     |
| Horizontal (pixel clocks) | 800    |
| Front Porch (Horizontal)  | 40     |
| Sync Pulse (Horizontal)   | 128    |
| Back Porch (Horizontal)   | 88     |
| Vertical (rows)           | 600    |
| Front Porch (Vertical)    | 1      |
| Sync Pulse (Vertical)     | 4      |
| Back Porch (Vertical)     | 23     |
| Hsync Polarity            | p      |
| Vsync Polarity            | p      |

Note: the video is stored in memoroy as a 200 x 150 array and will be displayed at 15fps

### Audio Spec

16 bit 2 channel PCM audio at 8kHz
This is intended to run on the FPGA side using the built in Wolfson WM8731

### Data Transfer Requirements

Cables for SPI clock must have good enough signal integraity to run at 1MHz minimum.
Software scripts must be able to fetch data and begin initiating data transfer within 147ms.

These transfer requirements come from:

- 200 x 150 1 bit color video at 15fps -> 450kb/s
- 16 bit 2 channel PCM audio at 8kHz -> 256kb/s

### FPGA Memory Usage

The computer software timing tolerance requires a 1s video and audio buffer which uses 1100 kb of memory.

Video buffering is done using 2 video banks that store 15 frames of video (1s) which allow simultaenous read and write into video at different rates.

Audio will be implemented as a simple 280kb FIFO buffer and will be pre-initialized with 200kb of audio.
The 200kb audio size accounts for the worst possible case delay for the delay on MISO data (~300ms)
and 280kb is the upper size of needed to store all incoming data in the best case of 0ms delay.

Total on-chip memory usage for buffering corresponds with 118 10kB units on Cyclon-V FPGAs

### IP Block Usage

This project utilizes the built in fractional divider PLL IP provided by Alterra in order to generate the 40MHz pixel clock required to VGA video at the desired resolution.

## Data Aquisition Control Scheme

<!-- There is a data aquisition FSM which acts as a wrapper for another SPI FSM which will drive the logic behind the SPI communication protocol used. -->

<!-- ### Video Buffering Scheme -->

### Audio Buffering Scheme

The main data aquisition FSM will enter into an IDLE state after 256kB of audio has been received.
This is to synchronize audio data transfer with the video frame transfer cycle which is initiated every 1s.
