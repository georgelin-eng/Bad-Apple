import numpy as np
import matplotlib.pyplot as plt

# Define parameters
frequency = 1e6  # 1 MHz clock
period = 1 / frequency  # period of the clock
t = np.linspace(0, 5 * period, 1000)  # time vector for 5 periods

# Generate clock signals with phase shifts (square waves)
phases = np.arange(-180, 181, 45)
clocks = {phase: 0.5 * (1 + np.sign(np.sin(2 * np.pi * frequency * t + np.deg2rad(phase)))) for phase in phases}

# Generate data output signal with double the frequency, aligned to the falling edge of the 0-degree clock
dataout_frequency = 0.5 * frequency  # 2 MHz dataout
dataout = 0.5 * (1 + np.sign(np.sin(2 * np.pi * dataout_frequency * t)))

# Plotting
fig, axes = plt.subplots(3, 4, figsize=(15, 10), sharex=True, sharey=True)

# Plot each clock signal in a subplot
for ax, (phase, clock) in zip(axes.flatten(), clocks.items()):
    ax.plot(t, clock, label=f'{phase}°')
    ax.plot(t, dataout - 2, label='Dataout (2 MHz)', color='black', linewidth=2)
    ax.set_title(f'Phase: {phase}°')
    ax.grid(True)
    ax.set_ylim(-3, 3)
    ax.legend()

# Configure global plot settings
fig.suptitle('50% Duty Cycle Square Clock Signals with Various Phase Shifts', fontsize=16)
fig.text(0.5, 0.04, 'Time (s)', ha='center', fontsize=14)
fig.text(0.04, 0.5, 'Amplitude', va='center', rotation='vertical', fontsize=14)
plt.tight_layout(rect=[0.03, 0.03, 1, 0.95])

# Show plot
plt.show()
