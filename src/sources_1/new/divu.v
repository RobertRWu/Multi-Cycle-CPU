//////////////////////////////////////////////////////////////////////////////////
// Engineer: Robert Wu
// 
// Create Date: 06/01/2019
// Project Name: Multi-cycle CPU with 54 Instructions Based on MIPS Architecture
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module divu(
    input [31:0] dividend,
    input [31:0] divisor,
    //input clk,
    input reset,
    input ena,
    output [31:0] q,
    output [31:0] r
    );

    reg [63:0] temp_dividend;
    reg [63:0] temp_divisor;
    integer counter;
    integer i;

    assign q = temp_dividend[31:0];
    assign r = temp_dividend[63:32];
    
    always @ (*) begin
        if (reset == 1) begin
            temp_dividend <= 0;
            temp_divisor <= 0;
            counter <= 0;
        end

        else if(ena) begin
            temp_dividend = dividend;
            temp_divisor = {divisor, 32'b0}; 

            for (counter = 0; counter < 32; counter = counter + 1) begin
                temp_dividend = temp_dividend << 1;
                            
                if (temp_dividend >= temp_divisor) begin
                    temp_dividend = temp_dividend - temp_divisor;
                    temp_dividend = temp_dividend + 1;
                end
            end
                
            counter = 0;
        end
    end

endmodule
