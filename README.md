# Parameterized N-Bit Booth's Algorithm Multiplier (`booth_nxn`)

**Scalable Signed Two's-Complement Radix-2 Booth Multiplier in Verilog-2001 HDL**

[![Interactive Datapath Stepper](https://img.shields.io/badge/Interactive_Datapath_Stepper-Step_Through_Radix--2_Booth_Registers-0F172A?style=flat-square&logo=googlechrome&logoColor=38BDF8)](https://tarunkumarkv.github.io/#datapath)
[![Language](https://img.shields.io/badge/HDL-Verilog--2001-1E293B?style=flat-square)]()
[![Verification](https://img.shields.io/badge/Verification-Self--Checking_Testbench_(iverilog_%2B_GTKWave)-059669?style=flat-square)]()

---

## Overview

This repository implements a **fully parameterizable `#(.n(N))` signed Radix-2 Booth's Algorithm Multiplier** in Verilog-2001 HDL (`booth_nxn.v`), paired with a **self-checking signed verification testbench** (`booth_nxn_tb.v`) that validates arbitrary two's-complement operand widths across positive, negative, zero, unity, and full-scale boundary vectors.

By encoding contiguous strings of `1`s in the signed multiplier operand via overlapping bit-pairs `{Q[0], Q_-1}`, the architecture executes signed multiplication directly in two's-complement form without separate sign-magnitude conversion logic.

> **Interactive Datapath Explorer:** Step cycle-by-cycle through the `{A, Q, Q_-1}` register transformations and bit-pair recoding live at **[tarunkumarkv.github.io/#datapath](https://tarunkumarkv.github.io/#datapath)**.

---

## Datapath Architecture & Radix-2 Recoding

```text
  2N+1 Bit Combined Shift Register:  partial_product[2n : 0]
 +-----------------------------------+-----------------------------------+----------+
 |          Accumulator (A)          |           Multiplier (Q)          |   Q_-1   |
 |        partial_product[2n:n+1]    |        partial_product[n:1]       |  [0] (1b)|
 +-----------------------------------+-----------------------------------+----------+
                  |                                                          |  |
                  +---< Add (+M) / Sub (-M) / Hold <--- Decode {Q[0], Q_-1} <+--+
                  |
                  v
       Arithmetic Right Shift (>>> 1, sign-extending MSB partial_product[2n])
```

### Radix-2 Bit-Pair Encoding Table

At each iteration $i \in [0, n-1]$, the least-significant multiplier bit `partial_product[1]` (`Q[0]`) and the trailing history bit `partial_product[0]` (`Q_-1`) determine the arithmetic operation on the upper accumulator slice `partial_product[2n : n+1]` prior to a 1-bit arithmetic right shift:

| `{Q[0], Q_-1}` | Recoded Weight | Datapath Operation before Arithmetic Right Shift |
| :---: | :---: | :--- |
| **`2'b00`** | `0` | **No operation** (`Hold A`) — inside a string of `0`s |
| **`2'b01`** | `+1` | **Add Multiplicand:** `A <= A + Multiplicand` — end of a string of `1`s |
| **`2'b10`** | `-1` | **Subtract Multiplicand:** `A <= A - Multiplicand` — start of a string of `1`s |
| **`2'b11`** | `0` | **No operation** (`Hold A`) — inside a string of `1`s |

---

## Module Interface & Parameterization

```verilog
// Default width: n = 4 (4x4 -> 8-bit signed product)
// Override at instantiation for arbitrary width N (e.g., 6x6 -> 12-bit, 16x16 -> 32-bit):
booth_nxn #(
    .n(6)
) u_booth_mult (
    .multiplicand (multiplicand), // input  signed [n-1:0]
    .multiplier   (multiplier),   // input  signed [n-1:0]
    .product      (product)       // output signed [2*n-1:0]
);
```

---

## Simulation & Verification (`iverilog` + `GTKWave`)

The testbench [`booth_nxn_tb.v`](booth_nxn_tb.v) instantiates a `6×6 → 12-bit` multiplier (`#(.n(6))`), dumps all signal transitions to `dump.vcd`, and automatically asserts `$signed(product) === ($signed(multiplicand) * $signed(multiplier))` across all four signed quadrants.

### Quickstart

```bash
# Option 1: Run via Makefile
make sim

# Option 2: Compile and run directly with Icarus Verilog
iverilog -o booth_sim booth_nxn.v booth_nxn_tb.v
vvp booth_sim

# Inspect VCD waveform in GTKWave
gtkwave dump.vcd
```

### Verified Test Vectors (`N = 6`)

| Test Vector | Multiplicand (`M`) | Multiplier (`Q`) | Signed Product (`2N`-bit) | Binary Output (`12`-bit 2's Complement) | Status |
| :---: | :---: | :---: | :---: | :---: | :---: |
| **1** | `+21` (`010101`) | `-22` (`101010`) | **`-462`** | `111000110010` | `PASS` |
| **2** | `+26` (`011010`) | `+26` (`011010`) | **`+676`** | `001010100100` | `PASS` |
| **3** | `-15` (`110001`) | `-12` (`110100`) | **`+180`** | `000010110100` | `PASS` |
| **4** | `-31` (`100001`) | `+19` (`010011`) | **`-589`** | `110110110011` | `PASS` |
| **5** | `0` (`000000`) | `-25` (`100111`) | **`0`** | `000000000000` | `PASS` |
| **6** | `-1` (`111111`) | `-1` (`111111`) | **`+1`** | `000000000001` | `PASS` |
| **7** | `+31` (`011111`) | `-31` (`100001`) | **`-961`** | `110000111111` | `PASS` |

---

## Repository Structure

```text
N-bit-Booth-s-Algorithm/
├── Makefile          # One-command iverilog build & verification target
├── README.md         # Architectural documentation & Radix-2 recoding spec
├── booth_nxn.v       # Parameterized N-bit signed Radix-2 Booth multiplier RTL
└── booth_nxn_tb.v    # Self-checking signed testbench with VCD waveform dump
```
