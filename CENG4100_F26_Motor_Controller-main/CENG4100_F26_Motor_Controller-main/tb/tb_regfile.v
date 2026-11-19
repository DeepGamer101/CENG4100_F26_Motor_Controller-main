
`timescale 1ns/1ps

// ============================================================================
// tb_regfile.v -- Self-checking Register File Testbench
// Week 10 Lab 1, Step 10
//
// Expected values come from tb/test_plan_lab1.md.
// Ports and timing come from docs/interfaces.md.
//
// Tests:
// 1. Write and read the same register
// 2. Read two different registers simultaneously
// 3. Write to x0 and verify both read ports return zero
// 4. Verify a register retains its value
// 5. Verify the latest write overwrites an earlier value
// ============================================================================

module tb_regfile;

    integer errors = 0;
    integer checks = 0;

    // Optional waveform generation.
`ifdef DUMP
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_regfile);
    end
`endif

    // ------------------------------------------------------------------------
    // Compare an actual 32-bit value with the expected value.
    // ------------------------------------------------------------------------
    task check32(
        input [255:0] name,
        input [31:0] got,
        input [31:0] expected
    );
        begin
            checks = checks + 1;

            if (got !== expected) begin
                errors = errors + 1;

                $display(
                    "FAIL %0s: got 0x%08h, expected 0x%08h",
                    name, got, expected
                );
            end
        end
    endtask

    // ------------------------------------------------------------------------
    // Register File Inputs and Outputs
    // ------------------------------------------------------------------------

    reg         clk = 1'b0;

    reg  [4:0]  rs1 = 5'd0;
    reg  [4:0]  rs2 = 5'd0;
    reg  [4:0]  rd  = 5'd0;

    reg         reg_write = 1'b0;

    reg  [31:0] write_data = 32'd0;

    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    // Clock period = 10 ns.
    // Rising edges occur at 5 ns, 15 ns, 25 ns, etc.
    always #5 clk = ~clk;

    // ------------------------------------------------------------------------
    // Device Under Test (DUT)
    // ------------------------------------------------------------------------

    regfile uut (
        .clk        (clk),
        .rs1        (rs1),
        .rs2        (rs2),
        .rd         (rd),
        .reg_write  (reg_write),
        .write_data (write_data),
        .rs1_data   (rs1_data),
        .rs2_data   (rs2_data)
    );

    // ------------------------------------------------------------------------
    // Write a value into a register on a rising clock edge.
    // ------------------------------------------------------------------------

    task write_reg(
        input [4:0]  address,
        input [31:0] value
    );
        begin
            // Prepare the inputs before the next rising edge.
            @(negedge clk);

            rd = address;
            write_data = value;
            reg_write = 1'b1;

            // Register file stores the value on this edge.
            @(posedge clk);

            // Allow the nonblocking assignment to update.
            #1;

            reg_write = 1'b0;
        end
    endtask

    // ------------------------------------------------------------------------
    // Execute the five planned register-file test cases.
    // ------------------------------------------------------------------------

    initial begin

        // ================================================================
        // TEST 1: Write then read the same register.
        // ================================================================

        write_reg(5'd5, 32'h12345678);

        rs1 = 5'd5;
        #1;

        check32(
            "write_read",
            rs1_data,
            32'h12345678
        );

        // ================================================================
        // TEST 2: Read two different registers simultaneously.
        // ================================================================

        write_reg(5'd6, 32'h00000005);
        write_reg(5'd7, 32'h00000003);

        rs1 = 5'd6;
        rs2 = 5'd7;
        #1;

        check32(
            "dual_read_A",
            rs1_data,
            32'h00000005
        );

        check32(
            "dual_read_B",
            rs2_data,
            32'h00000003
        );

        // ================================================================
        // TEST 3: Attempt to write to x0.
        // Both read ports must return zero.
        // ================================================================

        write_reg(5'd0, 32'hDEADBEEF);

        rs1 = 5'd0;
        rs2 = 5'd0;
        #1;

        check32(
            "x0_zero_A",
            rs1_data,
            32'h00000000
        );

        check32(
            "x0_zero_B",
            rs2_data,
            32'h00000000
        );

        // ================================================================
        // TEST 4: Verify a register retains its previous value.
        // Writing to x9 must not change x8.
        // ================================================================

        write_reg(5'd8, 32'hA5A5A5A5);
        write_reg(5'd9, 32'hFFFFFFFF);

        rs1 = 5'd8;
        #1;

        check32(
            "retain_value",
            rs1_data,
            32'hA5A5A5A5
        );

        // ================================================================
        // TEST 5: Verify that a new write overwrites the old value.
        // ================================================================

        write_reg(5'd10, 32'h00000001);
        write_reg(5'd10, 32'h0000000F);

        rs1 = 5'd10;
        rs2 = 5'd10;
        #1;

        check32(
            "overwrite_A",
            rs1_data,
            32'h0000000F
        );

        check32(
            "overwrite_B",
            rs2_data,
            32'h0000000F
        );

        // ================================================================
        // Final test results.
        // ================================================================

        if (errors == 0)
            $display("ALL TESTS PASSED (%0d checks)", checks);
        else
            $display("%0d of %0d CHECKS FAILED", errors, checks);

        $finish;

    end

endmodule
