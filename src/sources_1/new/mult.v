//////////////////////////////////////////////////////////////////////////////////
// Engineer: Robert Wu
// 
// Create Date: 06/01/2019
// Project Name: Multi-cycle CPU with 54 Instructions Based on MIPS Architecture
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module mult(  
    input ena,
    input reset,      
    input [31:0] a,
    input [31:0] b,
    output [63:0] z
    );

    parameter bit_num = 32;

    reg [31:0] temp_a;
    reg [31:0] temp_b;
    reg [63:0] stored;
    reg [63:0] temp;
    reg is_minus;
    integer i;

    always @(*) begin
        if(reset) begin
            stored <= 0;
            is_minus <= 0;
            temp_a <= 0;
            temp_b <= 0;
        end

        else if(ena) begin
            if (a == 0 || b == 0) begin
                stored <= 0;
            end

            else begin
                stored = 0;
                is_minus = a[31] ^ b[31];   //judge 
                temp_a = a;
                temp_b = b;

                if (a[31] == 1) begin
                    temp_a = a ^ 32'hffffffff;
                    temp_a = temp_a + 1;
                end

                if (b[31] == 1) begin
                    temp_b = b ^ 32'hffffffff;
                    temp_b = temp_b + 1;
                end

                for (i = 0; i < bit_num; i = i + 1) begin
                    temp = temp_b[i] ? ({32'b0, temp_a} << i) : 64'b0;
                    stored = stored + temp;       
                end

                if (is_minus == 1) begin
                    stored = stored ^ 64'hffffffffffffffff;
                    stored = stored + 1;
                end
            end
            
        end
    end

    assign z = stored;
endmodule
