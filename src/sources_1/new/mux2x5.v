//////////////////////////////////////////////////////////////////////////////////
// Engineer: Robert Wu
// 
// Create Date: 06/01/2019
// Project Name: Multi-cycle CPU with 54 Instructions Based on MIPS Architecture
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module mux2x5(
    input [4:0] C0,
    input [4:0] C1,
    input S0,
    output reg [4:0] oZ
    );

    always @ (C0 or C1 or S0) begin
        case(S0)
            1'b0: oZ <= C0;
            1'b1: oZ <= C1;
        endcase
   end
   
endmodule