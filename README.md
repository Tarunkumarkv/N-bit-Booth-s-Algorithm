# N-Bit Booth's Algorithm Multiplier

## 📌 Overview
This repository contains a fully parameterizable implementation of Booth's Multiplication Algorithm in Verilog HDL. The design enables the efficient multiplication of signed binary numbers in two's complement notation. By designing it to be parameterized for arbitrary bit-widths (N-bits), it serves as a flexible, scalable arithmetic logic building block for complex datapath designs.

## 📁 Repository Structure
*   `booth_nxn.v`: The core parameterized Verilog RTL module containing the shift-and-add control logic.
*   `booth_nxn_tb.v`: The testbench used to verify the multiplier logic across various positive, negative, and edge-case operands.

## 🚀 How to Run the Simulation
To compile and simulate the design, you can use the Icarus Verilog open-source toolchain:

```bash
# Compile the RTL and testbench
iverilog -o booth_sim booth_nxn.v booth_nxn_tb.v

# Run the simulation
vvp booth_sim

# View the waveform (if $dumpvars is included in the tb)
gtkwave dump.vcd
