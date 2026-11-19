
`timescale 1ns/1ps

// ============================================================================
// D6: ALU, Shifter, and Immediates
// Team decision:
// - Combinational 32-bit ALU
// - Barrel shifter for single-cycle shifts
// - Separate adders for CPU datapath functions
// - Immediate generator will be implemented in Lab 2
//
// Implements all ten RV32I ALU operations.
// ============================================================================

module alu (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  alu_op,
    output reg  [31:0] result
);

    // Only the lowest five bits determine the shift amount (0-31).
    wire [4:0] shamt = b[4:0];

    // Combinational ALU: output changes when an input changes.
    always @(*) begin
        case (alu_op)
            4'b0000: result = a + b;                  // ADD
            4'b0001: result = a - b;                  // SUB
            4'b0010: result = a << shamt;             // SLL
            4'b0011: result = ($signed(a) < $signed(b))
                             ? 32'd1 : 32'd0;         // SLT
            4'b0100: result = (a < b)
                             ? 32'd1 : 32'd0;         // SLTU
            4'b0101: result = a ^ b;                  // XOR
            4'b0110: result = a >> shamt;             // SRL
            4'b0111: result = $signed(a) >>> shamt;   // SRA
            4'b1000: result = a | b;                  // OR
            4'b1001: result = a & b;                  // AND
            default: result = 32'd0;                 // Invalid code
        endcase
    end

endmodule
