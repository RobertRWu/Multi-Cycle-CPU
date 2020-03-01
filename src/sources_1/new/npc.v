//////////////////////////////////////////////////////////////////////////////////
// Engineer: Robert Wu
// 
// Create Date: 06/01/2019
// Project Name: Multi-cycle CPU with 54 Instructions Based on MIPS Architecture
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module npc(
    input [31:0] addr,
    input rst,
    output [31:0] r
    );

    assign r = rst ? addr : addr + 4;

endmodule