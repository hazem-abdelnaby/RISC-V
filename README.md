# 32-bit Single-Cycle RISC-V Processor

## Project Overview

This project implements a 32-bit single-cycle RISC-V processor in Verilog HDL. The design follows a single-cycle datapath, where each instruction is fetched, decoded, executed, and completed within one clock cycle.

The processor includes instruction memory, data memory, a register file, an ALU, immediate-generation logic, and a control unit. Control signals generated from the instruction opcode drive the datapath and determine how data moves through the processor during instruction execution.

---

## Architecture

### Top-Level Design

The top-level module, `RISC_SC`, connects all processor components and implements the complete single-cycle datapath.

Major blocks:

- Program Counter (`PC`)
- Instruction Memory (`Instruction_MEM`)
- Control Unit (`Control_Unit`)
- Register File (`RegFile`)
- Immediate Generator (`Extend`)
- Arithmetic Logic Unit (`ALU`)
- Data Memory (`Data_MEM`)
- Result Selection Multiplexer (`MUX4X1`)
- ALU Source Multiplexer (`MUX2X1`)

### Instruction Execution Flow

1. Fetch instruction from instruction memory using the PC.
2. Decode instruction and generate control signals.
3. Read source registers and generate the immediate.
4. Execute the ALU operation.
5. Access data memory when required.
6. Select the write-back result.
7. Update the PC.

### Simplified Datapath

```text
           +----------------+
           |       PC       |
           +-------+--------+
                   |
                   v
         +-------------------+
         | Instruction_MEM   |
         +-------------------+
                   |
                   v
          +-----------------+
          | Control_Unit    |
          +-----------------+
                   |
        +----------+----------+
        |                     |
        v                     v
 +-------------+      +---------------+
 |  RegFile    |      |    Extend     |
 +-------------+      +---------------+
        |                     |
        +----------+----------+
                   |
                   v
              +--------+
              |  ALU   |
              +--------+
                   |
          +--------+--------+
          |                 |
          v                 v
     Data_MEM          Write-back
          |                 |
          +--------+--------+
                   |
                   v
               RegFile
```

---

## Implemented Modules

| Module | Description |
|----------|-------------|
| `Control_Unit` | Decodes instruction opcodes and generates control signals. |
| `ALU` | Performs ADD, SUB, AND, OR, and signed SLT operations. |
| `RegFile` | Implements 32 general-purpose 32-bit registers with two asynchronous read ports and one synchronous write port. |
| `PC` | Stores the current PC value and updates it with either `PC + 4` or a branch/jump target. |
| `Instruction_MEM` | 256-word instruction memory with combinational read access. |
| `Data_MEM` | 256-word data memory with combinational reads and synchronous writes. |
| `Extend` | Generates sign-extended immediates for I-type, S-type, B-type, and J-type instructions. |
| `MUX2X1` | Selects between register data and immediate data for the ALU input. |
| `MUX4X1` | Selects the write-back source. |
| `RISC_SC` | Top-level processor module integrating the complete datapath. |

---

## Supported Instructions

| Instruction | Type | Description |
|------------|------|-------------|
| `ADD` | R-type | Adds two register operands. |
| `SUB` | R-type | Subtracts the second operand from the first. |
| `AND` | R-type | Bitwise AND operation. |
| `OR` | R-type | Bitwise OR operation. |
| `SLT` | R-type | Sets destination register to 1 if `rs1 < rs2` (signed). |
| `ADDI` | I-type | Adds a sign-extended immediate to a register operand. |
| `LW` | I-type | Loads a 32-bit word from data memory. |
| `SW` | S-type | Stores a 32-bit word to data memory. |
| `BEQ` | B-type | Branches when two source registers are equal. |
| `JAL` | J-type | Jumps to a target and writes `PC + 4` to the destination register. |

> **Note:** The current control unit does not fully decode the I-type arithmetic `Funct3` field. The implemented arithmetic immediate instruction should therefore be considered `ADDI` only.

---

## Design Specifications

| Feature | Specification |
|----------|--------------|
| Datapath width | 32 bits |
| Register count | 32 |
| Register width | 32 bits |
| Read ports | Two asynchronous read ports |
| Write port | One synchronous write port |
| Register `x0` | Always reads as zero |
| Writes to `x0` | Blocked |
| Instruction memory | 256 × 32 bits |
| Data memory | 256 × 32 bits |
| Memory indexing | Address bits `[9:2]` |
| Reset type | Active-low asynchronous reset where implemented |

---

## Simulation and Verification

The supplied testbench (`RISC_SC_tb`) includes:

- 10 ns clock period
- Active-low reset sequence
- 21 instruction words loaded into instruction memory
- PC and instruction monitoring
- Register verification checks
- Data memory verification checks
- VCD waveform generation

### Expected Verification Checks

| Item | Expected Value |
|--------|---------------|
| PC | `0x50` |
| x2 | `25` |
| x3 | `68` |
| x4 | `1` |
| x5 | `11` |
| x7 | `7` |
| x9 | `18` |
| memory[24] | `7` |
| memory[25] | `25` |

The testbench reports PASS or FAIL based on these checks. This README does not claim that simulation passed.

---

## Instruction Memory Initialization

`Instruction_MEM` is modeled as a 256 × 32-bit memory array with combinational reads. The memory is not initialized inside the RTL module.

The testbench loads instructions using hierarchical assignments to:

```verilog
dut.U5.memory[index]
```

A synthesis or FPGA implementation requires a memory initialization method supported by the target flow.

---

## Lint

RTL lint checks are clean apart from warnings related to undriven instruction-memory contents. This is expected because the testbench initializes instruction memory externally. However, explicit memory initialization may still be required for synthesis.

---

