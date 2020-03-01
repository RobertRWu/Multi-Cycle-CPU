//////////////////////////////////////////////////////////////////////////////////
// Engineer: Robert Wu
// 
// Create Date: 06/01/2019
// Project Name: Multi-cycle CPU with 54 Instructions Based on MIPS Architecture
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module regfile(
    input clk, 
    input rst, 
    input we, 
    input [4:0] raddr1, 
    input [4:0] raddr2, 
    input [4:0] waddr, 
    input [31:0] wdata, 
    output [31:0] rdata1, 
    output [31:0] rdata2
    );
    
    wire [31:0] choose;
    wire [31:0] array_reg [0:31];

    decoder ref_decoder (waddr, we, choose);
    assign array_reg[0] = 0;
    
    register reg1 (clk, rst, choose[1], wdata, array_reg[1]);
    register reg2 (clk, rst, choose[2], wdata, array_reg[2]);
    register reg3 (clk, rst, choose[3], wdata, array_reg[3]);
    register reg4 (clk, rst, choose[4], wdata, array_reg[4]);
    register reg5 (clk, rst, choose[5], wdata, array_reg[5]);
    register reg6 (clk, rst, choose[6], wdata, array_reg[6]);
    register reg7 (clk, rst, choose[7], wdata, array_reg[7]);
    register reg8 (clk, rst, choose[8], wdata, array_reg[8]);
    register reg9 (clk, rst, choose[9], wdata, array_reg[9]);
    register reg10 (clk, rst, choose[10], wdata, array_reg[10]);
    register reg11 (clk, rst, choose[11], wdata, array_reg[11]);
    register reg12 (clk, rst, choose[12], wdata, array_reg[12]);
    register reg13 (clk, rst, choose[13], wdata, array_reg[13]);
    register reg14 (clk, rst, choose[14], wdata, array_reg[14]);
    register reg15 (clk, rst, choose[15], wdata, array_reg[15]);
    register reg16 (clk, rst, choose[16], wdata, array_reg[16]);
    register reg17 (clk, rst, choose[17], wdata, array_reg[17]);
    register reg18 (clk, rst, choose[18], wdata, array_reg[18]);
    register reg19 (clk, rst, choose[19], wdata, array_reg[19]);
    register reg20 (clk, rst, choose[20], wdata, array_reg[20]);
    register reg21 (clk, rst, choose[21], wdata, array_reg[21]);
    register reg22 (clk, rst, choose[22], wdata, array_reg[22]);
    register reg23 (clk, rst, choose[23], wdata, array_reg[23]);
    register reg24 (clk, rst, choose[24], wdata, array_reg[24]);
    register reg25 (clk, rst, choose[25], wdata, array_reg[25]);
    register reg26 (clk, rst, choose[26], wdata, array_reg[26]);
    register reg27 (clk, rst, choose[27], wdata, array_reg[27]);
    register reg28 (clk, rst, choose[28], wdata, array_reg[28]);
    register reg29 (clk, rst, choose[29], wdata, array_reg[29]);
    register reg30 (clk, rst, choose[30], wdata, array_reg[30]);
    register reg31 (clk, rst, choose[31], wdata, array_reg[31]);
    
    assign rdata1 = array_reg[raddr1];
    assign rdata2 = array_reg[raddr2];
endmodule

