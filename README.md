# Serial 2's Complementer Using a Shift Register and a Flip-Flop

## Project Overview

This project implements an 8-bit Serial 2's Complementer using a right-shift register, an XOR gate, an OR operation, and a D flip-flop.

The circuit calculates the 2's complement of a binary number serially, processing one bit per clock cycle.

## Objectives

- Design a serial 2's complementer using Verilog HDL.
- Implement the design using a shift register and a D flip-flop.
- Process binary data one bit at a time.
- Verify the design using a self-checking testbench.
- Analyse the simulation using GTKWave.

## Working Principle

The 2's complement of a binary number is obtained by inverting all bits and adding 1.

The serial method follows a simple rule:

1. Start processing from the least significant bit (LSB).
2. Copy all bits until and including the first `1`.
3. Invert all remaining bits.
4. After N clock cycles, the shift register contains the 2's complement.

### Example

Input: `01011000`

Output: `10101000`

## Circuit Architecture

The design consists of:

- **8-bit Right Shift Register:** Stores and shifts the binary input.
- **XOR Gate:** Determines whether the outgoing bit should be copied or inverted.
- **D Flip-Flop:** Stores the flag indicating whether the first `1` has been encountered.
- **OR Operation:** Keeps the flag set once the first `1` is shifted out.

### Important Verilog Expressions

```verilog
assign serial_in = sr[0] ^ flag;
flag <= flag | sr[0];
sr <= {serial_in, sr[N-1:1]};
```

## Finite State Machine

The circuit uses a two-state Mealy FSM:

- **S0 (flag = 0):** The first `1` has not yet been encountered.
- **S1 (flag = 1):** The first `1` has already been encountered.

The machine transitions from S0 to S1 when the first `1` is shifted out and remains in S1 for the rest of the operation.

## Project Files

| File | Description |
|---|---|
| `miniproject.v` | Main Verilog implementation |
| `miniproject_tb.v` | Self-checking testbench |
| `simulation/` | Simulation output and GTKWave screenshots |
| `docs/` | Project report |

## Tools and Technologies

- Verilog HDL
- Icarus Verilog
- GTKWave
- Digital Logic Design

## How to Run the Project

### 1. Compile the Verilog files

```bash
iverilog -o test1 miniproject.v miniproject_tb.v
```

### 2. Run the simulation

```bash
vvp test1
```

### 3. View the waveform

```bash
gtkwave wave.vcd
```

## Simulation and Results

The testbench verifies the design using 13 input patterns:

- 7 predefined test cases, including corner cases.
- 6 randomly generated test cases.

The expected result is calculated using:

```verilog
expected = (~val) + 1'b1;
```

The actual output is compared against the expected result for every test case.

**Simulation Result: ALL TESTS PASSED**

## Conclusion

The project successfully implements an 8-bit Serial 2's Complementer using a shift register and a D flip-flop.

The simulation results confirm that the design correctly computes the 2's complement for all 13 tested input patterns.

The project demonstrates the application of sequential logic, finite state machines, shift registers, and Verilog HDL.

## References

1. M. Morris Mano and Michael D. Ciletti, *Digital Design*.
2. Stephen Brown and Zvonko Vranesic, *Fundamentals of Digital Logic with Verilog Design*.
3. [Icarus Verilog](https://steveicarus.github.io/iverilog/)
4. [Two's Complement](https://en.wikipedia.org/wiki/Two%27s_complement)
5. [Shift Register](https://en.wikipedia.org/wiki/Shift_register)
