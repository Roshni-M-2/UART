# UART

## Overview

Implemented a UART transmitter and receiver in Verilog on the Digilent Basys3 FPGA, enabling serial communication between the FPGA and a PC running Tera Term at 9600 baud.

## Features

- UART 8N1 communication at 9600 baud
- Verilog RTL implementation
- FPGA to PC transmission using 8-bit switch input
- PC to FPGA reception with ASCII output on onboard LEDs
- Button debouncing for reliable transmission
- UART receiver with oversampling

## Operation

### UART Transmitter

```text
Basys3 Switches → UART Transmitter → Tera Term
  8-bit data       9600 baud
```

The 8-bit value set using the Basys3 switches is transmitted serially to Tera Term when the transmit button is pressed.

### UART Receiver

```text
Tera Term → UART Receiver → Basys3 LEDs
             9600 baud       8-bit ASCII
```

When an alphabet is typed in keyboard, its ASCII value is received by the FPGA and displayed on the eight LEDs.

Example:

```text
A → ASCII 65 → 01000001 → LEDs
```

## UART Configuration

| Parameter | Value |
|---|---|
| Baud Rate | 9600 bps |
| Data Bits | 8 |
| Parity | None |
| Stop Bits | 1 |
| FPGA Board | Digilent Basys3 |

## Repository Structure

```text
uart-transmitter-receiver-basys3/
├── Transmitter/
│   ├── transmitter.v
│   ├── debounce.v
│   ├── top.v
|   └──Basys3_transmitter.xdc
├── Receiver/
│   ├── receiver.v
│   └── Basys3_receiver.xdc
├── Schematic/
|   ├── txn.png
│   └── rcv.png 
└── README.md
```

## Tools

**Xilinx Vivado | Digilent Basys3 | Tera Term**

