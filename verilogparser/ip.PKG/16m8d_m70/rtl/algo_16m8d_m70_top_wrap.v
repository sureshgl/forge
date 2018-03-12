/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_16m8d_m70_top_wrap
#(parameter IP_WIDTH = 16, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 16384, parameter IP_BITADDR = 14,
parameter IP_NUMVBNK = 8,      parameter IP_BITVBNK = 3, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 5, parameter IP_SECCDWIDTH = 11,
parameter FLOPECC = 0, parameter FLOPIN = 1, parameter FLOPOUT = 1, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,
parameter T1_WIDTH = 16, parameter T1_NUMVBNK = 16, parameter T1_BITVBNK = 3, parameter T1_DELAY = 2, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 16)
( clk,rst, ready,
  ma_write, ma_vld,	ma_adr, ma_bp, ma_serr, ma_derr, ma_padr, bp_thr, bp_hys,
  dq_vld, dq_adr,
  cp_read, cp_write, cp_adr, cp_din, cp_vld, cp_dout,
  grpmsk, grpbp, grpcnt, grpmt, ena_rand,
  t1_writeA, t1_addrA, t1_dinA, t1_bwA,
  t1_readB, t1_addrB, t1_doutB ,
  pwrite, pwrbadr, pwrradr);

// MEMOIR_TRANSLATE_OFF

  parameter NUMMAPT = 16;
  parameter NUMDQPT = 8;
  parameter NUMEGPT = 4;
  
  parameter T1_INST = T1_NUMVBNK;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  
  parameter NUMVROW = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  
  parameter NUMWRDS = T1_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T1_DELAY;
  
  parameter MEMWDTH = WIDTH;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter NUMGRPW = 1; //SJ
  parameter GRPWDTH = PHYWDTH/NUMGRPW;
  parameter NUMGRPF = 1;
  parameter NUMGRPD = (NUMGRPW%NUMGRPF) ? ((NUMGRPW-(NUMGRPW%NUMGRPF))/NUMGRPF)+1 : NUMGRPW/NUMGRPF;
  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;
  parameter SDOUT_WIDTH = BITVROW+ECCBITS;
//  parameter SDOUT_WIDTH = BITVROW;

  parameter BITCPAD = 2+3+5;
  parameter CPUWDTH = 54;

input clk; input rst;
output ready; 

input  [NUMMAPT - 1:0]				ma_write; 
output  [NUMMAPT - 1:0] 		ma_vld; 
output  [NUMMAPT* BITADDR - 1:0] 	ma_adr; 
output  [NUMMAPT - 1:0]				ma_bp; 
output  [NUMMAPT - 1:0]                         ma_serr;
output  [NUMMAPT - 1:0]                         ma_derr;
output  [NUMMAPT* (BITVROW+2) - 1:0]            ma_padr;
input [BITVROW:0]				bp_thr;
input [BITVROW:0]				bp_hys;

input  [NUMDQPT - 1:0]			dq_vld;
input  [NUMDQPT* BITADDR - 1:0]		dq_adr;

input                                   cp_read;
input                                   cp_write;
input [BITCPAD-1:0]                     cp_adr;
input [CPUWDTH-1:0]                     cp_din;
output                                  cp_vld;
output [CPUWDTH-1:0]                    cp_dout;

input  [NUMMAPT*NUMVBNK - 1:0]          grpmsk;
input  [NUMMAPT*NUMVBNK - 1:0]          grpbp;
input  [NUMMAPT*(BITVBNK+1) - 1:0]      grpcnt;
output [NUMVBNK - 1:0]                  grpmt;
input                                   ena_rand;

output [(NUMMAPT)-1:0] pwrite ;
output [((NUMMAPT)*BITVBNK)-1:0] pwrbadr;
output [((NUMMAPT)*BITVROW)-1:0] pwrradr;

output [T1_INST - 1:0] t1_writeA; 
output [T1_INST*BITVROW - 1:0] t1_addrA; 
output [T1_INST*SDOUT_WIDTH - 1:0] t1_dinA; 
output [T1_INST*SDOUT_WIDTH - 1:0] t1_bwA;

output [T1_INST - 1:0] t1_readB; 
output [T1_INST*BITVROW - 1:0] t1_addrB; 
input  [T1_INST*SDOUT_WIDTH - 1:0] t1_doutB;

wire ready_int;
reg  H2O_2R1W4M2D_M73_3_3_7208M  ;
assign ready=((H2O_2R1W4M2D_M73_3_3_7208M & ready_int));
always @(posedge clk)begin
 H2O_2R1W4M2D_M73_3_3_7208M  = ready_int ;
end

  algo_16m8d_1r1w_top
		#(.NUMADDR(NUMADDR),  .BITADDR(BITADDR),
		  .NUMMAPT(NUMMAPT), .NUMDQPT(NUMDQPT), .NUMEGPT(NUMEGPT),
          .NUMVROW(NUMVROW),   .BITVROW(BITVROW),   .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),
		.ECCBITS(ECCBITS),   .SRAM_DELAY(SRAM_DELAY),   
                .FLOPIN(FLOPIN),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT))
  algo_top
	(.clk(clk), .rst(rst), .ready(ready_int),
	
        .malloc(ma_write),
        .ma_vld(ma_vld),
        .ma_adr(ma_adr),
        .ma_bp(ma_bp),
        .ma_serr(ma_serr),
        .ma_derr(ma_derr),
        .ma_padr(ma_padr),
        .bp_thr(bp_thr),
        .bp_hys(bp_hys),

        .dq_vld(dq_vld),
        .dq_adr(dq_adr),

        .cp_read(cp_read),
        .cp_write(cp_write),
        .cp_adr(cp_adr),
        .cp_din(cp_din),
        .cp_vld(cp_vld),
        .cp_dout(cp_dout),

        .grpmsk(grpmsk),
        .grpbp(grpbp),
        .grpcnt(grpcnt),
        .grpmt(grpmt),
        .ena_rand(ena_rand),

	.t2_writeA(t1_writeA), .t2_addrA(t1_addrA), .t2_dinA(t1_dinA), .t2_readB(t1_readB), .t2_addrB(t1_addrB), .t2_doutB(t1_doutB),
    .pwrite(pwrite), .pwrbadr(pwrbadr), .pwrradr(pwrradr));

// MEMOIR_TRANSLATE_ON

endmodule    //algo_4r2w4m4d_m69_top_wrap