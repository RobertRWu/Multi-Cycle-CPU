//////////////////////////////////////////////////////////////////////////////////
// Engineer: Robert Wu
// 
// Create Date: 06/01/2019
// Project Name: Multi-cycle CPU with 54 Instructions Based on MIPS Architecture
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module imem (
    input rena,
    input [31:0] addr,
    output [31:0] data_out
    );

    reg [31:0] temp [2047:0];

    assign data_out = (rena == 1) ? temp[(addr - 32'h00400000) / 4] : 32'bz;
    
endmodule