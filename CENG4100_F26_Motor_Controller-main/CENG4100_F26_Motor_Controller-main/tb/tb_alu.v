
`timescale 1ns/1ps

// tb_alu.v -- Self-checking RV32I ALU testbench.
// Week 10 Lab 1, Step 10.
// Expected values come from tb/test_plan_lab1.md.
// ALU control codes come from docs/interfaces.md.

module tb_alu;

    integer errors = 0;
    integer checks = 0;

`ifdef DUMP
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_alu);
    end
`endif

    // Compare actual and expected 32-bit results.
    task check32(
        input [255:0] name,
        input [31:0] got,
        input [31:0] expected
    );
        begin
            checks = checks + 1;
            if (got !== expected) begin
                errors = errors + 1;
                $display("FAIL %0s: got 0x%08h, expected 0x%08h",
                         name, got, expected);
            end
        end
    endtask

    // ALU inputs and output.
    reg  [31:0] a;
    reg  [31:0] b;
    reg  [3:0]  alu_op;
    wire [31:0] result;

    // Device under test.
    alu uut (
        .a      (a),
        .b      (b),
        .alu_op (alu_op),
        .result (result)
    );

    // Apply one planned test case and check its result.
    task run_case(
        input [255:0] name,
        input [3:0]   operation,
        input [31:0]  operand_a,
        input [31:0]  operand_b,
        input [31:0]  expected
    );
        begin
            alu_op = operation;
            a = operand_a;
            b = operand_b;
            #1;
            check32(name, result, expected);
        end
    endtask

    initial begin
        a = 32'd0;
        b = 32'd0;
        alu_op = 4'b0000;

        // Case 1: ADD zero operands.
        run_case("add_zero", 4'b0000,
                 32'h00000000, 32'h00000000, 32'h00000000);

        // Case 2: ADD signed overflow.
        run_case("add_overflow", 4'b0000,
                 32'h7FFFFFFF, 32'h00000001, 32'h80000000);

        // Case 3: SUB signed overflow.
        run_case("sub_overflow", 4'b0001,
                 32'h80000000, 32'h00000001, 32'h7FFFFFFF);

        // Case 4: SLL by 31.
        run_case("sll_31", 4'b0010,
                 32'h00000001, 32'h0000001F, 32'h80000000);

        // Case 5: SRL by 31.
        run_case("srl_31", 4'b0110,
                 32'h80000000, 32'h0000001F, 32'h00000001);

        // Case 6: SRA preserves sign.
        run_case("sra_negative", 4'b0111,
                 32'hFFFFFFFF, 32'h00000001, 32'hFFFFFFFF);

        // Case 7: Shift by zero.
        run_case("shift_zero", 4'b0010,
                 32'h12345678, 32'h00000000, 32'h12345678);

        // Case 8: Only low five shift bits count.
        run_case("shift_mask", 4'b0010,
                 32'h00000001, 32'h00000020, 32'h00000001);

        // Case 9: Signed comparison, -1 < 1.
        run_case("slt_signed", 4'b0011,
                 32'hFFFFFFFF, 32'h00000001, 32'h00000001);

        // Case 10: Unsigned comparison of the same operands.
        run_case("sltu_unsigned", 4'b0100,
                 32'hFFFFFFFF, 32'h00000001, 32'h00000000);

        // Case 11: XOR alternating bits.
        run_case("xor_bits", 4'b0101,
                 32'hAAAAAAAA, 32'h55555555, 32'hFFFFFFFF);

        // Case 12: AND.
        run_case("and_bits", 4'b1001,
                 32'hFF00FF00, 32'h0F0F0F0F, 32'h0F000F00);

        // Case 13: OR.
        run_case("or_bits", 4'b1000,
                 32'hF0000000, 32'h0000000F, 32'hF000000F);

        if (errors == 0)
            $display("ALL TESTS PASSED (%0d checks)", checks);
        else
            $display("%0d of %0d CHECKS FAILED", errors, checks);

        $finish;
    end

endmodule
