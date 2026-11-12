# Lab 1 test plan: ALU and register file

Written by Verification, from the RISC-V spec and hand calculation, before any
testbench exists. Never take an expected value from Core's Verilog. Review the
plan with the team, then commit it. Copilot turns it into `tb/tb_alu.v` and
`tb/tb_regfile.v` and must use these values exactly.

Write every value in hex. "Name" is what the testbench prints when the case
fails, so keep it short and unique.

## ALU (at least 10 cases)

Must include: 0; −1 (0xFFFF_FFFF); the most negative number (0x8000_0000);
add and sub that overflow; shifts by 0 and by 31; a shift amount above 31
(only the low 5 bits count); signed and unsigned compare on the same pair
where they disagree (for example −1 and 1).

Using 13 cases so we cover all ten RV32I ALU operations, OR operation, plus important edge cases.

| # | Name | Operation | A | B | Expected result | Why this case (spec section) |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | add_zero | ADD | 0x00000000 | 0x00000000 | 0x00000000 | Zero operands; RV32I Ch. 2 |
| 2 | add_overflow | ADD | 0x7FFFFFFF | 0x00000001 | 0x80000000 | Signed overflow wraps to 32 bits; RV32I Ch. 2 |
| 3 | sub_overflow | SUB | 0x80000000 | 0x00000001 | 0x7FFFFFFF | Subtraction overflow wraps to 32 bits; RV32I Ch. 2 |
| 4 | sll_31 | SLL | 0x00000001 | 0x0000001F | 0x80000000 | Maximum left shift; RV32I Ch. 2 |
| 5 | srl_31 | SRL | 0x80000000 | 0x0000001F | 0x00000001 | Logical shift fills with zeros; RV32I Ch. 2 |
| 6 | sra_negative | SRA | 0xFFFFFFFF | 0x00000001 | 0xFFFFFFFF | Arithmetic shift preserves sign; RV32I Ch. 2 |
| 7 | shift_zero | SLL | 0x12345678 | 0x00000000 | 0x12345678 | Shift by zero leaves value unchanged; RV32I Ch. 2 |
| 8 | shift_mask | SLL | 0x00000001 | 0x00000020 | 0x00000001 | Only five low shift-count bits used; RV32I Ch. 2 |
| 9 | slt_signed | SLT | 0xFFFFFFFF | 0x00000001 | 0x00000001 | Signed -1 is less than +1; RV32I Ch. 2 |
| 10 | sltu_unsigned | SLTU | 0xFFFFFFFF | 0x00000001 | 0x00000000 | Unsigned 0xFFFFFFFF is greater than 1; RV32I Ch. 2 |
| 11 | xor_bits | XOR | 0xAAAAAAAA | 0x55555555 | 0xFFFFFFFF | Alternating bits; RV32I Ch. 2 |
| 12 | and_bits | AND | 0xFF00FF00 | 0x0F0F0F0F | 0x0F000F00 | Bitwise AND; RV32I Ch. 2 |
| 13 | or_bits | OR | 0xF0000000 | 0x0000000F | 0xF000000F | Bitwise OR; RV32I Ch. 2 |

## Register file (at least 5 cases)

Must include: write then read the same register; read two different registers
at once; write to x0, then read x0 (must be 0); a register that wasn't written
keeps its value. Write each case as a short sequence of steps.

| # | Name | Steps (writes, then reads) | Expected read values | Why this case (spec section) |
| --- | --- | --- | --- | --- |
| 1 | write_read | Write 0x12345678 to x5 on rising clock edge; read x5 through port A | A = 0x12345678 | Written register retains its value; RV32I Ch. 2 |
| 2 | dual_read | Write 0x00000005 to x6 and 0x00000003 to x7 on separate rising edges; read x6 on A and x7 on B simultaneously | A = 0x00000005; B = 0x00000003 | Two independent read ports; D5 interface |
| 3 | x0_zero | Attempt to write 0xDEADBEEF to x0; read x0 through both ports | A = 0x00000000; B = 0x00000000 | x0 must always read zero; RV32I Ch. 2 |
| 4 | retain_value | Write 0xA5A5A5A5 to x8; write 0xFFFFFFFF to x9; read x8 again | A = 0xA5A5A5A5 | Writing another register must not change x8; D5 interface |
| 5 | overwrite | Write 0x00000001 to x10; then write 0x0000000F to x10 on a later rising edge; read x10 through both ports | A = 0x0000000F; B = 0x0000000F | Latest write replaces prior value; D5 interface |

## Review

| Reviewed by (whole team) | Date | Changes made in review |
| --- | --- | --- |
| 1 | Brandon Reiner | 11/05/2026 | Updated ALU 13 cases and 5 register files |
| 2 | Jose Lopez | 11/12/2026 | None, just reviewed |
| 3 | Edward Corey | 11/12/2026 | None, just reviewed |
| 4 | Christian Sivongxay | 11/12/2026 | None, just reviewed |
