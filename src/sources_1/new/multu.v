//////////////////////////////////////////////////////////////////////////////////
// Engineer: Robert Wu
// 
// Create Date: 06/01/2019
// Project Name: Multi-cycle CPU with 54 Instructions Based on MIPS Architecture
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module multu(
    input ena,       
    input reset,      
    input [31:0] a,
    input [31:0] b,
    output [63:0] z
    );

    parameter bit_num = 32;

    reg [63:0] stored;
    reg [63:0] temp;
    integer i;

    initial begin
        stored <= 0;
    end

    always @(*) begin
        if(reset) begin
            stored <= 0;
        end

        else if(ena) begin
            stored = 0;
            for (i = 0; i < bit_num; i = i + 1) begin
                temp = b[i] ? ({32'b0, a} << i) : 64'b0;
                stored = stored + temp;       
            end
        end
    end

    assign z = stored;
endmodule
