//////////////////////////////////////////////////////////////////////////////////
// Engineer: Robert Wu
// 
// Create Date: 06/01/2019
// Project Name: Multi-cycle CPU with 54 Instructions Based on MIPS Architecture
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module cpu(
    input clk,
    input reset,
    input  [31:0] inst,   
    input  [31:0] wdata,  
    output [31:0] pc,
    output [31:0] addr,
    output [31:0] rdata,
    output DM_CS,
    output DM_W,
    output [1:0] DM_W_CS,
    output [1:0] DM_R_CS
    );

    wire PC_CLK;                
    wire PC_ENA;
    wire MUL_ENA;
    wire MULTU_ENA;
    wire DIV_ENA;
    wire DIVU_ENA;    
                 
    wire [2:0] M_PC;        
    wire [2:0] M_RD;                                                                   
    wire M_ALU1;                         
    wire [1:0] M_ALU2;      
    wire M_EC;              
    wire M_DIV_H;
    wire M_DIV_L;
    wire [1:0] M_HI;   // CS of MUX_HI
    wire [1:0] M_LO;   // CS of MUX_LO
    wire M_EXT5;

    wire [2:0] EC_CS;  //CS of extend_cut

    wire [31:0] MUX_PC_D;                                       

    wire [31:0] MUX_ALU1_D;              
    wire [31:0] MUX_ALU2_D;
    wire [31:0] MUX_EC_D;
    wire [31:0] MUX_DIV_H_D;
    wire [31:0] MUX_DIV_L_D;
    wire [31:0] MUX_HI_D;
    wire [31:0] MUX_LO_D;
    wire [4:0] MUX_EXT5_D;

    wire [31:0] MUX_RD_D;

    wire [3:0] ALUC;    //CS of ALUC 
    wire [31:0] ALU_D;  //output of ALUC

    wire RF_W;        //regfile write enable  
    wire [31:0] RF_D;  

    wire [31:0] Rs_D;  //source data               
    wire [31:0] Rt_D;  //the second source data      

    wire [4:0] Rs_C;  //source CS
    wire [4:0] Rt_C;  //
    wire [4:0] Rd_C;  //destination CS

    wire EXT16_sign;  
    
    //
    wire zero;                       
    wire carry;                      
    wire negative;                   
    wire overflow;                                

    wire [31:0] PC_D;
    
    wire [31:0] EXT5_D;           
    wire [31:0] EXT16_D;             
    wire [31:0] EXT18_D;     
    wire [31:0] EC_D;

    wire [31:0] ADD_D;            
    wire [31:0] ADD4_D;              
    wire [31:0] NPC_D;                
    wire [31:0] II_D;                
    wire [31:0] CLZ_D;

    wire CLZ_ENA;

   //signal of cp0
    wire MFC0;
    wire MTC0;
    wire [4:0] CP0_ADDR;
    wire EXCEPTION;
    wire ERET;
    wire [4:0] CAUSE;
    wire [31:0] CP0_D;
    wire [31:0] EXC_ADDR;
    wire [31:0] STATUS;

    wire SIGN_EC;

    wire [63:0] MUL_D;      //output of mul
    wire [31:0] MUL_HI_D;
    wire [31:0] MUL_LO_D;
    wire [63:0] MULTU_D;
    wire [31:0] MULTU_HI_D;
    wire [31:0] MULTU_LO_D;

    wire [31:0] DIV_Q_D;    //quotient
    wire [31:0] DIV_R_D;    //remainder
    wire [31:0] DIVU_Q_D;   //quotient
    wire [31:0] DIVU_R_D;   //remainder

    wire HI_W;   //enable of HI
    wire LO_W;   //enable of LO
    wire [31:0] HI_D;   //output of HI
    wire [31:0] LO_D;   //output of LO

    assign PC_ENA = 1;
    assign pc = PC_D;
    assign addr = ALU_D;
    assign rdata = EC_D;

    controller cpu_controller(clk, zero, negative, inst, STATUS, PC_CLK, M_EC, M_EXT5, M_DIV_H, M_DIV_L, M_ALU1, M_ALU2, M_HI, M_LO, 
                              M_PC, M_RD, ALUC, RF_W, DM_W, DM_CS, DM_W_CS, DM_R_CS, EXT16_sign, SIGN_EC, EC_CS, HI_W, LO_W, 
                              Rd_C, Rs_C, Rt_C, CLZ_ENA, MUL_ENA, MULTU_ENA, DIV_ENA, DIVU_ENA, MFC0, MTC0, CP0_ADDR, ERET, 
                              EXCEPTION, CAUSE);
    
    npc cpu_npc(PC_D, reset, NPC_D);
    pcreg pc_out(PC_CLK, reset, PC_ENA, MUX_PC_D, PC_D);

    regfile cpu_ref(clk, reset, RF_W, Rs_C, Rt_C, Rd_C, MUX_RD_D, Rs_D, Rt_D);

    alu cpu_alu(MUX_ALU1_D, MUX_ALU2_D, ALUC, ALU_D, zero, carry, negative, overflow);

    div cpu_divider(Rs_D, Rt_D, reset, DIV_ENA, DIV_Q_D, DIV_R_D);
    divu cpu_unsigned_divider(Rs_D, Rt_D, reset, DIVU_ENA, DIVU_Q_D, DIVU_R_D);
    mult cpu_multiplier(MUL_ENA, reset, Rs_D, Rt_D, MUL_D);
    multu cpu_unsigned_multiplier(MULTU_ENA, reset, Rs_D, Rt_D, MULTU_D);

    assign MUL_HI_D = MUL_D[63:32];
    assign MUL_LO_D = MUL_D[31:0];
    assign MULTU_HI_D = MULTU_D[63:32];
    assign MULTU_LO_D = MULTU_D[31:0];

    register cpu_hi(clk, reset, HI_W, MUX_HI_D, HI_D);
    register cpu_lo(clk, reset, LO_W, MUX_LO_D, LO_D);

    clz cpu_clz(Rs_D, CLZ_ENA, CLZ_D);
    cp0 cpu_cp0(clk, reset, MFC0, MTC0, PC_D, CP0_ADDR, Rt_D, EXCEPTION, ERET, CAUSE, CP0_D, STATUS, EXC_ADDR);

    mux2x5 cpu_mux_ext5(inst[10:6], Rs_D[4:0], M_EXT5, MUX_EXT5_D);

    mux2 cpu_mux_alu1(EXT5_D, Rs_D, M_ALU1, MUX_ALU1_D);
    mux4 cpu_mux_alu2(Rt_D, EXT16_D, 32'b0, 32'b0, M_ALU2, MUX_ALU2_D);

    mux2 cpu_mux_ec(Rt_D, wdata, M_EC, MUX_EC_D);

    mux2 cpu_mux_div_h(DIV_R_D, DIVU_R_D, M_DIV_H, MUX_DIV_H_D);
    mux2 cpu_mux_div_l(DIV_Q_D, DIVU_Q_D, M_DIV_L, MUX_DIV_L_D);

    mux4 cpu_mux_hi(MUX_DIV_H_D, MUL_HI_D, MULTU_HI_D, Rs_D, M_HI, MUX_HI_D);
    mux4 cpu_mux_lo(MUX_DIV_L_D, MUL_LO_D, MULTU_LO_D, Rs_D, M_LO, MUX_LO_D);

    mux8 cpu_mux_pc(II_D, Rs_D, NPC_D, 32'h00400004, ADD_D, EXC_ADDR, 0, 0, M_PC, MUX_PC_D);
    //mux of regfile 
    mux8 cpu_mux_rd(LO_D, ADD4_D, CLZ_D, CP0_D, EC_D, ALU_D, HI_D, MUL_LO_D, M_RD, MUX_RD_D);  

    extend5 cpu_ext5(MUX_EXT5_D, EXT5_D);
    extend16 cpu_ext16(inst[15:0], EXT16_sign, EXT16_D);
    extend18 cpu_ext18(inst[15:0], EXT18_D);
    extend_cut cpu_ext_cut(MUX_EC_D, EC_CS, SIGN_EC, EC_D);

    adder4 cpu_adder4(PC_D, ADD4_D);
    adder cpu_adder(EXT18_D, NPC_D, ADD_D);
    II cpu_ii(PC_D[31:28], inst[25:0], II_D);

endmodule