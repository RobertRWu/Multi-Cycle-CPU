//////////////////////////////////////////////////////////////////////////////////
// Engineer: Robert Wu
// 
// Create Date: 06/01/2019
// Project Name: Multi-cycle CPU with 54 Instructions Based on MIPS Architecture
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module II(
    input [3:0] a,
    input [25:0] b,
    output [31:0] r
    );

    assign r = {a, b, 2'b00};

endmodule