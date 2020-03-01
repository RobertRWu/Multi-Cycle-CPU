//////////////////////////////////////////////////////////////////////////////////
// Engineer: Robert Wu
// 
// Create Date: 06/01/2019
// Project Name: Multi-cycle CPU with 54 Instructions Based on MIPS Architecture
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module cpu_tb;
    reg clk_in;
    reg reset;
    wire [31:0] inst;
    wire [31:0] pc;
    integer file_output;
    integer counter = 0;

    sccomp_dataflow uut(.clk_in(clk_in), .reset(reset), .inst(inst), .pc(pc));

    initial begin
        $readmemh("test.txt", uut.scimem.temp);
        file_output = $fopen("result.txt", "w");
        clk_in = 0;
        reset = 1;
        #40 reset = 0;     
    end

    always begin
        #100 clk_in = ~clk_in;
    end
    
    always @ (posedge clk_in) begin
        if(counter == 2048 || inst === 32'bx)
            $fclose(file_output);
        else begin
            counter = counter + 1;
            $fdisplay(file_output, "pc: %h", pc - 32'h00400000);
            $fdisplay(file_output, "instr: %h", inst);

            $fdisplay(file_output, "regfile0: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[0]);
            $fdisplay(file_output, "regfile1: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[1]);
            $fdisplay(file_output, "regfile2: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[2]);
            $fdisplay(file_output, "regfile3: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[3]);
            $fdisplay(file_output, "regfile4: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[4]);
            $fdisplay(file_output, "regfile5: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[5]);
            $fdisplay(file_output, "regfile6: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[6]);
            $fdisplay(file_output, "regfile7: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[7]);
            $fdisplay(file_output, "regfile8: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[8]);
            $fdisplay(file_output, "regfile9: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[9]);
            $fdisplay(file_output, "regfile10: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[10]);
            $fdisplay(file_output, "regfile11: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[11]);
            $fdisplay(file_output, "regfile12: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[12]);
            $fdisplay(file_output, "regfile13: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[13]);
            $fdisplay(file_output, "regfile14: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[14]);
            $fdisplay(file_output, "regfile15: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[15]);
            $fdisplay(file_output, "regfile16: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[16]);
            $fdisplay(file_output, "regfile17: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[17]);
            $fdisplay(file_output, "regfile18: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[18]);
            $fdisplay(file_output, "regfile19: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[19]);
            $fdisplay(file_output, "regfile20: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[20]);
            $fdisplay(file_output, "regfile21: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[21]);
            $fdisplay(file_output, "regfile22: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[22]);
            $fdisplay(file_output, "regfile23: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[23]);
            $fdisplay(file_output, "regfile24: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[24]);
            $fdisplay(file_output, "regfile25: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[25]);
            $fdisplay(file_output, "regfile26: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[26]);
            $fdisplay(file_output, "regfile27: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[27]);
            $fdisplay(file_output, "regfile28: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[28]);
            $fdisplay(file_output, "regfile29: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[29]);
            $fdisplay(file_output, "regfile30: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[30]);
            $fdisplay(file_output, "regfile31: %h", sccomp_dataflow.sccpu.cpu_ref.array_reg[31]);
            
        end
    end

endmodule
