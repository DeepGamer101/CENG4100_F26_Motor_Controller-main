`timescale 1ns/1ps

// D5: Use LUT RAM for register storage and force reads of x0 to zero.
module regfile (
    input  wire        clk,
    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,
    input  wire [4:0]  rd,
    input  wire        reg_write,
    input  wire [31:0] write_data,
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data
);

    (* ram_style = "distributed" *) reg [31:0] registers [0:31];

    always @(posedge clk) begin
        if (reg_write)
            registers[rd] <= write_data;
    end

    assign rs1_data = (rs1 == 5'd0) ? 32'd0 : registers[rs1];
    assign rs2_data = (rs2 == 5'd0) ? 32'd0 : registers[rs2];

endmodule