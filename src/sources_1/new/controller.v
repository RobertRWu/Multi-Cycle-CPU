//////////////////////////////////////////////////////////////////////////////////
// Engineer: Robert Wu
// 
// Create Date: 06/01/2019
// Project Name: Multi-cycle CPU with 54 Instructions Based on MIPS Architecture
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module controller(
    input clk,
    input zero,
    input negative,
    input [31:0] inst,
    input [31:0] STATUS, 
    output PC_CLK,      
    output M_EC,
    output M_EXT5,
    output M_DIV_H,
    output M_DIV_L,
    output M_ALU1,       
    output [1:0] M_ALU2,               
    output [1:0] M_HI,
    output [1:0] M_LO,
    output [2:0] M_PC,
    output [2:0] M_RD,
    output [3:0] ALUC,
    output RF_W,     
    output DM_W,     
    output DM_CS,
    output [1:0] DM_W_CS,
    output [1:0] DM_R_CS,
    output EXT16_sign,
    output SIGN_EC,
    output [2:0] EC_CS,
    output HI_W,
    output LO_W,
    output [4:0] Rd_C,
    output [4:0] Rs_C,
    output [4:0] Rt_C,
    output CLZ_ENA,
    output MUL_ENA,
    output MULTU_ENA,
    output DIV_ENA,
    output DIVU_ENA, 
    output MFC0,
    output MTC0,
    output [4:0] CP0_ADDR,
    output ERET,
    output EXCEPTION,
    output [4:0] CAUSE
    );

    wire [5:0] op = inst[31:26];
    wire [5:0] func = inst[5:0];

    wire Addi = (op == 6'b001000);
    wire Addiu = (op == 6'b001001);
    wire Andi = (op == 6'b001100);
    wire Ori = (op == 6'b001101);
    wire Sltiu = (op == 6'b001011);
    wire Lui = (op == 6'b001111);
    wire Xori = (op == 6'b001110);
    wire Slti = (op == 6'b001010);
    wire Addu = (op == 6'b000000 && func==6'b100001);
    wire And = (op == 6'b000000 && func == 6'b100100);
    wire Beq = (op == 6'b000100);
    wire Bne = (op == 6'b000101);
    wire J = (op == 6'b000010);
    wire Jal = (op == 6'b000011);
    wire Jr = (op == 6'b000000 && func == 6'b001000);
    wire Lw = (op == 6'b100011);
    wire Xor = (op == 6'b000000 && func == 6'b100110);
    wire Nor = (op == 6'b000000 && func == 6'b100111);
    wire Or = (op == 6'b000000 && func == 6'b100101);
    wire Sll = (op == 6'b000000 && func == 6'b000000);
    wire Sllv = (op == 6'b000000 && func == 6'b000100);
    wire Sltu = (op == 6'b000000 && func == 6'b101011);
    wire Sra = (op == 6'b000000 && func == 6'b000011);
    wire Srl = (op == 6'b000000 && func == 6'b000010);
    wire Subu = (op == 6'b000000 && func == 6'b100011);
    wire Sw = (op == 6'b101011);
    wire Add = (op == 6'b000000 && func == 6'b100000);
    wire Sub = (op == 6'b000000 && func == 6'b100010);
    wire Slt = (op == 6'b000000 && func == 6'b101010);
    wire Srlv = (op == 6'b000000 && func == 6'b000110);
    wire Srav = (op == 6'b000000 && func == 6'b000111);
    
    wire Clz = (op == 6'b011100 && func == 6'b100000);
    wire Divu = (op == 6'b000000 && func == 6'b011011);
    wire Eret = (op == 6'b010000 && func == 6'b011000);
    wire Jalr = (op == 6'b000000 && func == 6'b001001);
    wire Lb = (op == 6'b100000);
    wire Lbu = (op == 6'b100100);
    wire Lhu = (op == 6'b100101);
    wire Sb = (op == 6'b101000);
    wire Sh = (op == 6'b101001);
    wire Lh = (op == 6'b100001);
    wire Mfc0 = (inst[31:21] == 11'b01000000000 && inst[10:3]==8'b00000000);
    wire Mfhi = (op == 6'b000000 && func == 6'b010000);
    wire Mflo = (op == 6'b000000 && func == 6'b010010);
    wire Mtc0 = (inst[31:21] == 11'b01000000100 && inst[10:3]==8'b00000000);
    wire Mthi = (op == 6'b000000 && func == 6'b010001);
    wire Mtlo = (op == 6'b000000 && func == 6'b010011);
    wire Mul = (op == 6'b011100 && func == 6'b000010);
    wire Multu = (op == 6'b000000 && func == 6'b011001);
    wire Syscall = (op == 6'b000000 && func== 6'b001100);
    wire Teq = (op == 6'b000000 && func == 6'b110100);
    wire Bgez = (op == 6'b000001);
    wire Break = (op == 6'b000000 && func == 6'b001101);
    wire Div = (op == 6'b000000 && func == 6'b011010);

    assign PC_CLK = clk;
    assign MUL_ENA = Mul;
    assign MULTU_ENA = Multu;
    assign DIV_ENA = Div;
    assign DIVU_ENA = Divu;

    assign M_PC[2] = Eret+(Beq&&(zero?1:0))+(Bne&&(zero?0:1))+(Bgez&&((!negative||zero)?1:0));
    assign M_PC[1] = ~(J+Jr+Jal+Jalr+M_PC[2]);
    assign M_PC[0] = Eret+EXCEPTION+Jr+Jalr;

    assign RF_W = Addi+Addiu+Andi+Ori+Sltiu+Lui+Xori+Slti+Addu+And+Xor+Nor+Or+Sll+Sllv+Sltu+Sra+Srl+Subu+Add+Sub+Slt+Srlv+Srav+Lb+Lbu+Lh+Lhu+Lw+Mfc0+Clz+Jal+Jalr+Mfhi+Mflo+Mul;
    
    assign ALUC[3] = Slt+Sltu+Sllv+Srlv+Srav+Lui+Srl+Sra+Slti+Sltiu+Sll;
    assign ALUC[2] = And+Or+Xor+Nor+Sll+Srl+Sra+Sllv+Srlv+Srav+Andi+Ori+Xori;
    assign ALUC[1] = Add+Sub+Xor+Nor+Slt+Sltu+Sll+Sllv+Addi+Xori+Beq+Bne+Slti+Sltiu+Bgez+Teq;
    assign ALUC[0] = Subu+Sub+Or+Nor+Slt+Sllv+Srlv+Sll+Srl+Slti+Ori+Beq+Bne+Bgez+Teq;
    
    assign M_RD[2] = ~(Beq+Bne+Bgez+Div+Divu+Sb+Multu+Sh+Sw+J+Jr+Jal+Jalr+Mfc0+Mtc0+Mflo+Mthi+Mtlo+Clz+Eret+Syscall+Teq+Break);
    assign M_RD[1] = Mul+Mfc0+Mtc0+Clz+Mfhi;
    assign M_RD[0] = ~(Beq+Bne+Bgez+Div+Divu+Multu+Lb+Lbu+Lh+Lhu+Lw+Sb+Sh+Sw+J+Mtc0+Mfhi+Mflo+Mthi+Mtlo+Clz+Eret+Syscall+Teq+Break);
    
    assign DM_W = Sb+Sh+Sw;
    assign DM_CS = Lw+Sw+Sb+Sh+Lb+Lh+Lhu+Lbu;
    assign DM_W_CS[1] = Sh+Sb;
    assign DM_W_CS[0] = Sw+Sb;
    assign DM_R_CS[1] = Lh+Lb+Lhu+Lbu;
    assign DM_R_CS[0] = Lw+Lb+Lbu; 
    
    assign M_EXT5 = Sllv+Srav+Srlv;
    assign M_DIV_H = Divu;
    assign M_DIV_L = Divu;

    assign M_ALU1 = ~(Sll+Srl+Sra+Div+Divu+Mul+Multu+J+Jr+Jal+Jalr+Mfc0+Mtc0+Mfhi+Mflo+Mthi+Mtlo+Clz+Eret+Syscall+Break);
    assign M_ALU2[1] = Bgez;
    assign M_ALU2[0] = Slti+Sltiu+Addi+Addiu+Andi+Ori+Xori+Lb+Lbu+Lh+Lhu+Lw+Sb+Sh+Sw+Lui;

    assign EC_CS[2] = Sh;
    assign EC_CS[1] = Lb+Lbu+Sb;
    assign EC_CS[0] = Lh+Lhu+Sb;
    
    assign M_HI[1] = Multu+Mthi;
    assign M_HI[0] = Mul+Mthi;
    assign M_LO[1] = Multu+Mtlo;
    assign M_LO[0] = Mul+Mtlo;
    assign M_EC = ~(Sb+Sh+Sw);

    assign HI_W = Div+Divu+Multu+Mthi;
    assign LO_W = Div+Divu+Multu+Mtlo;

    assign SIGN_EC=Lb+Lh;

    assign EXT16_sign = Addi+Addiu+Sltiu+Slti;

    assign Rd_C = (Add+Addu+Sub+Subu+And+Or+Xor+Nor+Slt+Sltu+Sll+Srl+Sra+Sllv+Srlv+Srav+Clz+Jalr+Mfhi+Mflo+Mul) ? inst[15:11]:(( Addi+Addiu+Andi+Ori+Xori+Lb+Lbu+Lh+Lhu+Lw+Slti+Sltiu+Lui+Mfc0) ? inst[20:16]:(Jal?5'd31:5'b0));
    assign Rs_C = inst[25:21];
    assign Rt_C = inst[20:16];

    assign CLZ_ENA = Clz;

    assign MFC0 = Mfc0;
    assign MTC0 = Mtc0;
    assign CP0_ADDR = inst[15:11];
    assign EXCEPTION = STATUS[0] && ((Syscall && STATUS[1]) || (Break && STATUS[2]) || (Teq && STATUS[3] && zero));
    assign ERET = Eret;
    assign CAUSE = Break ? 5'b01001 : (Syscall ? 5'b01000 : (Teq ? 5'b01101 : 5'b00000));

endmodule
