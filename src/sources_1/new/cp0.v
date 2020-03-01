//////////////////////////////////////////////////////////////////////////////////
// Engineer: Robert Wu
// 
// Create Date: 06/01/2019
// Project Name: Multi-cycle CPU with 54 Instructions Based on MIPS Architecture
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module cp0(
    input clk,
    input rst,
    input mfc0,
    input mtc0,
    input [31:0] pc,
    input [4:0] Rd,
    input [31:0] wdata,
    input exception,
    input eret,
    input [4:0] cause,
    output [31:0] rdata,
    output [31:0] status,
    output [31:0] exc_addr
    );

    parameter STATUS = 12;
    parameter CAUSE = 13;
    parameter EPC = 14;    
    parameter SYSCALL = 5'b01000;
    parameter BREAK = 5'b01001;
    parameter TEQ = 5'b01101;


    reg [31:0] register [31:0];
    reg [31:0] temp_status;
    integer i;

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            for(i = 0; i < 32; i = i + 1)
                register[i] <= 0;
            temp_status <= 0;
        end
        else begin
            if(mtc0)
                register[Rd] <= wdata;
            else if(exception) begin
                register[EPC] = pc;
                temp_status = register[STATUS];
                register[STATUS] = register[STATUS] << 5;
                register[CAUSE] = {25'b0, cause, 2'b0};
            end
            else if(eret) begin
                register[STATUS] = temp_status;
            end
        end 
    end

    assign exc_addr = eret ? register[EPC] : 32'h4;
    assign rdata = mfc0 ? register[Rd] : 32'hx;
    assign status = register[STATUS];

endmodule
