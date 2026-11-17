32-bit Single-Cycle RISC-V Processor
A 32-bit single-cycle RISC-V processor implemented in Verilog HDL. The design executes each instruction in a single clock cycle and includes instruction memory, data memory, a register file, an ALU, an immediate generator, and a control unit.

Architecture
The top-level module, RISC_SC, integrates all processor components.

Instruction Flow
Fetch instruction using the Program Counter (PC)
Decode instruction and generate control signals
Read source registers and generate immediate value
Execute ALU operation
Access data memory (for LW/SW)
Select write-back result
Update PC
Simplified Datapath
PC → Instruction Memory → Control Unit
              ↓
         Register File
              ↓
           Extend
              ↓
             ALU
              ↓
         Data Memory
              ↓
          Write Back
Implemented Modules
Module	Description
Control_Unit	Generates control signals from instruction fields.
ALU	Implements ADD, SUB, AND, OR, and SLT operations.
RegFile	32 × 32-bit register file with two read ports and one write port.
PC	Stores and updates the program counter.
Instruction_MEM	256 × 32-bit instruction memory.
Data_MEM	256 × 32-bit data memory.
Extend	Generates I, S, B, and J immediates.
MUX2X1	Selects the second ALU operand.
MUX4X1	Selects the write-back data source.
RISC_SC	Top-level processor module.
Supported Instructions
Instruction	Description
ADD	Register addition
SUB	Register subtraction
AND	Bitwise AND
OR	Bitwise OR
SLT	Signed set-less-than
ADDI	Add immediate
LW	Load word
SW	Store word
BEQ	Branch if equal
JAL	Jump and link
Note: The control unit does not fully decode I-type arithmetic Funct3. Only ADDI is implemented.

Design Specifications
Feature	Value
Datapath Width	32 bits
Registers	32 × 32-bit
Read Ports	2 asynchronous
Write Port	1 synchronous
Register x0	Constant zero
Writes to x0	Blocked
Instruction Memory	256 × 32 bits
Data Memory	256 × 32 bits
Addressing	memory[address[9:2]]
Reset	Active-low asynchronous (where implemented)
Simulation and Verification
The supplied testbench (RISC_SC_tb) includes:

10 ns clock period
Active-low reset sequence
21 instructions loaded into instruction memory
PC and instruction monitoring
Register and memory checking
VCD waveform generation
Expected Results
Signal	Expected Value
PC	0x50
x2	25
x3	68
x4	1
x5	11
x7	7
x9	18
memory[24]	7
memory[25]	25
The testbench reports PASS or FAIL based on these checks. No simulation results are claimed here.

Instruction Memory Initialization
Instruction_MEM is implemented as a 256 × 32-bit array with combinational reads.

Instructions are loaded externally by the testbench using hierarchical assignments:

dut.U5.memory[index] = instruction;
The memory is not initialized inside the RTL. FPGA or synthesis implementations require a target-specific initialization method.

Lint
RTL linting is clean except for warnings related to uninitialized instruction-memory contents. This is expected in simulation because the testbench initializes instruction memory externally, but synthesis flows may require explicit initialization.
