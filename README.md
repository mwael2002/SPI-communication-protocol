# SPI-communication-protocol
## Implementation of SPI communication protocol between one master and one slave

### Master-Slave Architecture:
SPI typically operates in a master-slave architecture where one device (the master) controls the communication and initiates data transfers, while one or more devices (the slaves) respond to the commands from the master.

### Communication Lines: SPI uses four main communication lines:
SCLK (Serial Clock): The clock signal generated by the master to synchronize data transmission.
MOSI (Master Out Slave In): The data line from the master to the slave(s), used to send data.
MISO (Master In Slave Out): The data line from the slave(s) to the master, used to receive data.
SS/CS (Slave Select/Chip Select): This line is used by the master to select the slave with which it wants to communicate. Each slave typically has its own SS/CS line.
### Full Duplex Communication:
SPI supports full-duplex communication, meaning data can be sent and received simultaneously. This is achieved by having separate data lines for sending and receiving data.

## Modes:
### Mode 0:
Clock Polarity (CPOL): 0 (idle state low)
Clock Phase (CPHA): 0 (data captured on the leading edge of clock)
In Mode 0, the clock is in its low state (0) when idle, and data is sampled on the leading (rising) edge of the clock signal. Data is typically transmitted and received on MOSI and MISO lines, respectively.

### Mode 1:
CPOL: 0,
CPHA: 1 (data captured on the trailing edge of clock)
Similar to Mode 0, the clock is in its low state when idle. However, data is sampled on the trailing (falling) edge of the clock signal.

### Mode 2:
CPOL: 1 (idle state high),
CPHA: 0
In Mode 2, the clock is in its high state (1) when idle, and data is sampled on the leading edge of the clock signal.

### Mode 3:
CPOL: 1,
CPHA: 1,
Similar to Mode 2, the clock is in its high state when idle. Data is sampled on the trailing edge of the clock signal.

### The implementation covers the 4 modes by parametrizing CPOL and CPHA. 
