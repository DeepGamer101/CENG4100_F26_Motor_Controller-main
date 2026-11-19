
`timescale 1ns/1ps

// ============================================================================
// D1: Single-Cycle Datapath
// Connects the register file and ALU using docs/interfaces.md.
// Register values feed the ALU; the ALU result feeds register write-back.
// Instruction decoding and immediate generation come in Lab 2.
// ============================================================================

module datapath (
    input  wire        clk,
    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,
    input  wire [4:0]  rd,
    input  wire        reg_write,
    input  wire [3:0]  alu_op,
    output wire [31:0] alu_result
);

    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    // Register file: two asynchronous reads and one synchronous write.
    regfile u_regfile (
        .clk        (clk),
        .rs1        (rs1),
        .rs2        (rs2),
        .rd         (rd),
        .reg_write  (reg_write),
        .write_data (alu_result),
        .rs1_data   (rs1_data),
        .rs2_data   (rs2_data)
    );

    // ALU: processes the two register operands combinationally.
    alu u_alu (
        .a       (rs1_data),
        .b       (rs2_data),
        .alu_op  (alu_op),
        .result  (alu_result)
    );

endmodule
