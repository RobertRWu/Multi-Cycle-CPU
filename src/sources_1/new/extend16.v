//////////////////////////////////////////////////////////////////////////////////
// Engineer: Robert Wu
// 
// Create Date: 06/01/2019
// Project Name: Multi-cycle CPU with 54 Instructions Based on MIPS Architecture
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module extend16 (
    input [15:0] a,
    input sign,
    output [31:0] b
    );

    assign b = (sign == 0 || a[15] == 0) ? {16'b0, a} : {16'hffff, a};
    
endmodule