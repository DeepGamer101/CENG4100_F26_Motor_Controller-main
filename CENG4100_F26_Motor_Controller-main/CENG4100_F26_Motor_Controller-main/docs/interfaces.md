# Module interfaces

This file is the contract between Core and Verification. Core builds each
module to match it. Verification writes each testbench from it, without
opening Core's Verilog. Change it only when the whole team agrees, and tell
both roles when you do.

## Register file (`rtl/regfile.v`, module `regfile`)

Decision: D5 Register file. Use LUT RAM for the 32 registers.

| Port | Direction | Width | What it does |
| --- | --- | --- | --- |
| `clk` | Input | 1 | Clocks register writes. |
| `rs1` | Input | 5 | Selects the register to read on port A. |
| `rs2` | Input | 5 | Selects the register to read on port B. |
| `rd` | Input | 5 | Selects the destination register. |
| `reg_write` | Input | 1 | Enables a write when high. |
| `write_data` | Input | 32 | Supplies the value to write to `rd`. |
| `rs1_data` | Output | 32 | Returns the value selected by `rs1`. |
| `rs2_data` | Output | 32 | Returns the value selected by `rs2`. |

Timing: A write is stored on the rising edge of `clk` when `reg_write`
is high. Both reads are asynchronous. If a read port selects the register
being written, it sees the updated value after the write edge. Either
port returns zero whenever it selects `x0`. Values in `x1`–`x31` are
unspecified until written.

## ALU (`rtl/alu.v`, module `alu`)

Decision: D6 ALU, shifter and immediates. The Lab 1 ALU is combinational
and uses the low five bits of `b` as the barrel shifter's shift amount.

| Port | Direction | Width | What it does |
| --- | --- | --- | --- |
| `a` | Input | 32 | First operand. |
| `b` | Input | 32 | Second operand. For shifts, `b[4:0]` is the shift amount. |
| `alu_op` | Input | 4 | Selects the operation from the table below. |
| `result` | Output | 32 | Returns the selected operation's result. |

### ALU operation codes

| Code (binary) | Operation | RV32I instructions that use it |
| --- | --- | --- |
| `0000` | add | `ADD`, `ADDI` |
| `0001` | sub | `SUB` |
| `0010` | sll | `SLL`, `SLLI` |
| `0011` | slt | `SLT`, `SLTI` |
| `0100` | sltu | `SLTU`, `SLTIU` |
| `0101` | xor | `XOR`, `XORI` |
| `0110` | srl | `SRL`, `SRLI` |
| `0111` | sra | `SRA`, `SRAI` |
| `1000` | or | `OR`, `ORI` |
| `1001` | and | `AND`, `ANDI` |

## Datapath (`rtl/datapath.v`, module `datapath`)

Decision: D1 Single-cycle microarchitecture.

| Port | Direction | Width | What it does |
| --- | --- | --- | --- |
| `clk` | Input | 1 | Clocks register writes. |
| `rs1` | Input | 5 | Selects the register for ALU operand A. |
| `rs2` | Input | 5 | Selects the register for ALU operand B. |
| `rd` | Input | 5 | Selects the register that receives the ALU result. |
| `reg_write` | Input | 1 | Enables writing the ALU result to `rd`. |
| `alu_op` | Input | 4 | Selects the ALU operation. |
| `alu_result` | Output | 32 | Exposes the ALU result for observation. |

The register file's two read outputs feed ALU inputs `a` and `b`.
The ALU's `result` drives both `alu_result` and the register file's
`write_data` input.

## Change log

| Date | What changed | Agreed by |
| --- | --- | --- |
| [Review date] | Defined the Lab 1 ports, register timing, and ALU operation codes. | [Team members who agreed] |
| 11-16-26 | Filled out all the Intefaces | Jose Lopez |