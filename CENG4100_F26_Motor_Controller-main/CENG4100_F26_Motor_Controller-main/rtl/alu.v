
`timescale 1ns/1ps

// ============================================================================
// D6: ALU, Shifter, and Immediates
//
// Team architecture decisions:
// - Separate adders for ALU arithmetic, PC+4, and branch targets.
// - This module implements the combinational 32-bit ALU.
// - Barrel shifter performs shifts using the low five bits of operand b.
// - PC+4 and branch-target adders are outside this module.
// - One immediate generator for I, S, B, U, and J formats comes in Lab 2.
//
// ALU operation codes follow docs/interfaces.md, NOT raw RISC-V funct3.
// ADD and SUB remain separate expressions pending synthesis evaluation.
// ============================================================================

module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  alu_op,
    output reg  [31:0] result
);

    // Shift amount is determined by the lowest five bits of operand b.
    // RV32I supports shift amounts from 0 to 31.
    wire [4:0] shamt;
    assign shamt = b[4:0];

    // Combinational ALU: no clock or additional instruction cycles.
    always @(*) begin
        case (alu_op)

            // ADD: 0000
            4'b0000: result = a + b;

            // SUB: 0001
            4'b0001: result = a - b;

            // SLL: 0010 - Logical shift left.
            4'b0010: result = a << shamt;

            // SLT: 0011 - Signed less-than comparison.
            4'b0011: result = ($signed(a) < $signed(b))
                             ? 32'd1 : 32'd0;

            // SLTU: 0100 - Unsigned less-than comparison.
            4'b0100: result = (a < b)
                             ? 32'd1 : 32'd0;

            // XOR: 0101
            4'b0101: result = a ^ b;

            // SRL: 0110 - Logical shift right, fills with zeros.
            4'b0110: result = a >> shamt;

            // SRA: 0111 - Arithmetic shift right, preserves sign.
            4'b0111: result = $signed(a) >>> shamt;

            // OR: 1000
            4'b1000: result = a | b;

            // AND: 1001
            4'b1001: result = a & b;

            // Undefined ALU codes return zero.
            default: result = 32'd0;

        endcase
    end

endmodule
