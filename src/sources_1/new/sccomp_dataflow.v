//////////////////////////////////////////////////////////////////////////////////
// Engineer: Robert Wu
// 
// Create Date: 06/01/2019
// Project Name: Multi-cycle CPU with 54 Instructions Based on MIPS Architecture
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module sccomp_dataflow(
    input clk_in,
    input reset,
    output [31:0] inst,
    output [31:0] pc
//    output [7:0] o_seg,
//    output [7:0] o_sel
    );

    parameter T1s = 99_999;

    reg [30:0] count;
    reg clk_1s;
    wire IM_R;   
    wire DM_CS;  
    wire DM_W;
    wire [1:0] DM_W_CS;
    wire [1:0] DM_R_CS;   
    wire [31:0] addr;
    wire [31:0] wdata;
    wire [31:0] rdata;
//    wire [31:0] inst;
//    wire [31:0] pc;
    
    always @ (posedge clk_in or posedge reset) begin
        if(reset) begin
            clk_1s <= 0;
            count <= 0;
        end
        else if(count == T1s) begin
            count <= 0;
            clk_1s <= ~clk_1s;
        end
        else
            count <= count + 1;
    end
    assign IM_R = 1;
    
    imem scimem(IM_R, pc, inst);
    cpu sccpu(clk_in, reset, inst, rdata, pc, addr, wdata, DM_CS, DM_W, DM_W_CS, DM_R_CS);
//    imem scimem(.a(pc[12:2]),
//                 .spo(inst)
//                 );
                 
    dmem scdmem(clk_in, DM_CS, DM_W, DM_W_CS, DM_R_CS, wdata, addr, rdata);
    //seg7x16 seg7(clk_in, reset, 1, pc, o_seg, o_sel);

endmodule