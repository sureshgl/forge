/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 *
 * */

module algo_4ror1wor5r5rwp_a943_top_wrap
#(parameter IP_WIDTH = 112,parameter IP_BITWIDTH = 7,parameter IP_NUMADDR = 16384,parameter IP_BITADDR = 14,parameter IP_NUMVBNK = 4,parameter IP_BITVBNK = 2,parameter IP_SECCBITS = 4,parameter IP_SECCDWIDTH = 3,parameter IP_BITPBNK = 3,parameter FLOPIN = 1,parameter FLOPOUT = 1,parameter FLOPECC = 0,parameter IP_ENAECC = 0,parameter IP_DECCBITS = 8,parameter IP_ENAPAR = 0,parameter FLOPMEM = 0,parameter FLOPCMD = 0,parameter IP_REFRESH = 0,parameter IP_REFFREQ = 0,parameter IP_REFFRHF = 0,parameter T1_WIDTH = 112,parameter T1_NUMVBNK = 4,parameter T1_BITVBNK = 2,parameter T1_DELAY = 2,parameter T1_NUMVROW = 4096,parameter T1_BITVROW = 12,parameter T1_BITWSPF = 0,parameter T1_NUMWRDS = 1,parameter T1_BITWRDS = 0,parameter T1_NUMSROW = 4096,parameter T1_BITSROW = 12,parameter T1_PHYWDTH = 112,parameter T1_IP_WIDTH = 112,parameter T1_IP_BITWIDTH = 7,parameter T1_IP_NUMADDR = 4096,parameter T1_IP_BITADDR = 12,parameter T1_IP_NUMVBNK = 4,parameter T1_IP_BITVBNK = 2,parameter T1_IP_SECCBITS = 4,parameter T1_IP_SECCDWIDTH = 3,parameter T1_IP_BITPBNK = 3,parameter T1_FLOPIN = 0,parameter T1_FLOPOUT = 0,parameter T1_IP_REFRESH = 0,parameter T1_IP_REFFREQ = 0,parameter T1_IP_REFFRHF = 0,parameter T1_T1_WIDTH = 112,parameter T1_T1_NUMVBNK = 4,parameter T1_T1_BITVBNK = 2,parameter T1_T1_DELAY = 2,parameter T1_T1_NUMVROW = 1024,parameter T1_T1_BITVROW = 10,parameter T1_T1_BITWSPF = 0,parameter T1_T1_NUMWRDS = 1,parameter T1_T1_BITWRDS = 0,parameter T1_T1_NUMSROW = 1024,parameter T1_T1_BITSROW = 10,parameter T1_T1_PHYWDTH = 112,parameter T1_T2_WIDTH = 112,parameter T1_T2_NUMVBNK = 1,parameter T1_T2_BITVBNK = 0,parameter T1_T2_DELAY = 2,parameter T1_T2_NUMVROW = 1024,parameter T1_T2_BITVROW = 10,parameter T1_T2_BITWSPF = 0,parameter T1_T2_NUMWRDS = 1,parameter T1_T2_BITWRDS = 0,parameter T1_T2_NUMSROW = 1024,parameter T1_T2_BITSROW = 10,parameter T1_T2_PHYWDTH = 112,parameter T2_WIDTH = 112,parameter T2_NUMVBNK = 1,parameter T2_BITVBNK = 0,parameter T2_DELAY = 2,parameter T2_NUMVROW = 4096,parameter T2_BITVROW = 12,parameter T2_BITWSPF = 0,parameter T2_NUMWRDS = 1,parameter T2_BITWRDS = 0,parameter T2_NUMSROW = 4096,parameter T2_BITSROW = 12,parameter T2_PHYWDTH = 112,parameter T2_IP_WIDTH = 112,parameter T2_IP_BITWIDTH = 7,parameter T2_IP_NUMADDR = 4096,parameter T2_IP_BITADDR = 12,parameter T2_IP_NUMVBNK = 4,parameter T2_IP_BITVBNK = 2,parameter T2_IP_SECCBITS = 4,parameter T2_IP_SECCDWIDTH = 3,parameter T2_IP_BITPBNK = 3,parameter T2_FLOPIN = 0,parameter T2_FLOPOUT = 0,parameter T2_IP_REFRESH = 0,parameter T2_IP_REFFREQ = 0,parameter T2_IP_REFFRHF = 0,parameter T2_T1_WIDTH = 112,parameter T2_T1_NUMVBNK = 4,parameter T2_T1_BITVBNK = 2,parameter T2_T1_DELAY = 2,parameter T2_T1_NUMVROW = 1024,parameter T2_T1_BITVROW = 10,parameter T2_T1_BITWSPF = 0,parameter T2_T1_NUMWRDS = 1,parameter T2_T1_BITWRDS = 0,parameter T2_T1_NUMSROW = 1024,parameter T2_T1_BITSROW = 10,parameter T2_T1_PHYWDTH = 112,parameter T2_T2_WIDTH = 112,parameter T2_T2_NUMVBNK = 1,parameter T2_T2_BITVBNK = 0,parameter T2_T2_DELAY = 2,parameter T2_T2_NUMVROW = 1024,parameter T2_T2_BITVROW = 10,parameter T2_T2_BITWSPF = 0,parameter T2_T2_NUMWRDS = 1,
parameter T2_T2_BITWRDS = 0,parameter T2_T2_NUMSROW = 1024,parameter T2_T2_BITSROW = 10,parameter T2_T2_PHYWDTH = 112,

parameter T1_T1_NUMRBNK = 2, parameter T1_T1_BITRBNK = 1, parameter T1_T1_NUMRROW = 256, parameter T1_T1_BITRROW = 8, parameter T1_T1_NUMPROW = 8192, parameter T1_T1_BITPROW = 13, parameter T1_T1_BITDWSN = 8,
parameter T1_T1_NUMDWS0 = 0, parameter T1_T1_NUMDWS1 = 0, parameter T1_T1_NUMDWS2 = 0, parameter T1_T1_NUMDWS3 = 0,
parameter T1_T1_NUMDWS4 = 0, parameter T1_T1_NUMDWS5 = 0, parameter T1_T1_NUMDWS6 = 0, parameter T1_T1_NUMDWS7 = 0,
parameter T1_T1_NUMDWS8 = 0, parameter T1_T1_NUMDWS9 = 0, parameter T1_T1_NUMDWS10 = 0, parameter T1_T1_NUMDWS11 = 0,
parameter T1_T1_NUMDWS12 = 0, parameter T1_T1_NUMDWS13 = 0, parameter T1_T1_NUMDWS14 = 0, parameter T1_T1_NUMDWS15 = 0, parameter IP_ENAEXT = 0

)
 
( clk,  rst,  refr,
 
  write, wr_adr, din,
  read, rd_adr, rd_dout, rd_vld, rd_serr, rd_derr, rd_padr, algo_sel, 
  ready,
  rw_read,  rw_write,  rw_addr,  rw_din,  rw_dout,  rw_vld,  rw_serr,  rw_derr,  rw_padr,  
  
  t1_readA,  t1_writeA,  t1_addrA,  t1_dinA,  t1_bwA,  t1_doutA,  t1_read_serrA, 
  t2_readA,  t2_writeA,  t2_addrA,  t2_dinA,  t2_bwA,  t2_doutA,  t2_read_serrA, 
  t3_readA,  t3_writeA,  t3_addrA,  t3_dinA,  t3_bwA,  t3_doutA,  t3_read_serrA, 
  t4_readA,  t4_writeA,  t4_addrA,  t4_dinA,  t4_bwA,  t4_doutA,  t4_read_serrA,
  
  t1_refrB, t1_bankB, t2_refrB, t2_bankB,  t3_refrB, t3_bankB,  t4_refrB, t4_bankB, 
  t1_dwsnA, t2_dwsnA, t3_dwsnA, t4_dwsnA   
 );

 // MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAEXT = IP_ENAEXT;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter MEMWDTH = ENAEXT ? WIDTH : ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW1 = T1_NUMVROW;
  parameter BITVROW1 = T1_BITVROW;
  parameter NUMVBNK1 = IP_NUMVBNK;
  parameter BITVBNK1 = IP_BITVBNK;
  parameter BITPBNK1 = IP_BITPBNK;
  parameter FLOPIN1 = FLOPIN;
  parameter FLOPOUT1 = FLOPOUT;
  parameter NUMVROW2 = T1_T1_NUMVROW;
  parameter BITVROW2 = T1_T1_BITVROW;
  parameter NUMVBNK2 = T1_IP_NUMVBNK;
  parameter BITVBNK2 = T1_IP_BITVBNK;
  parameter BITPBNK2 = T1_IP_BITPBNK;
  parameter FLOPIN2 = T1_FLOPIN;
  parameter FLOPOUT2 = T1_FLOPOUT;
  parameter NUMWRDS2 = T1_T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS2 = T1_T1_BITWRDS;
  parameter NUMSROW2 = T1_T1_NUMSROW;
  parameter BITSROW2 = T1_T1_BITSROW;
  parameter PHYWDTH2 = T1_T1_PHYWDTH;
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters
  parameter NUMRBNK = T1_T1_NUMRBNK;
  parameter BITWSPF = T1_T1_BITWSPF;
  parameter BITRBNK = T1_T1_BITRBNK;
  parameter REFLOPW = 0;
  parameter NUMRROW = T1_T1_NUMRROW;
  parameter BITRROW = T1_T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;
  parameter REFFRHF = IP_REFFRHF;

  parameter BITDWSN = T1_T1_BITDWSN;		//DWSN Parameters
  parameter NUMDWS0 = T1_T1_NUMDWS0;
  parameter NUMDWS1 = T1_T1_NUMDWS1;
  parameter NUMDWS2 = T1_T1_NUMDWS2;
  parameter NUMDWS3 = T1_T1_NUMDWS3;
  parameter NUMDWS4 = T1_T1_NUMDWS4;
  parameter NUMDWS5 = T1_T1_NUMDWS5;
  parameter NUMDWS6 = T1_T1_NUMDWS6;
  parameter NUMDWS7 = T1_T1_NUMDWS7;
  parameter NUMDWS8 = T1_T1_NUMDWS8;
  parameter NUMDWS9 = T1_T1_NUMDWS9;
  parameter NUMDWS10 = T1_T1_NUMDWS10;
  parameter NUMDWS11 = T1_T1_NUMDWS11;
  parameter NUMDWS12 = T1_T1_NUMDWS12;
  parameter NUMDWS13 = T1_T1_NUMDWS13;
  parameter NUMDWS14 = T1_T1_NUMDWS14;
  parameter NUMDWS15 = T1_T1_NUMDWS15;

  parameter SRAM_DELAY = T1_T1_DELAY;

  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;//17


  parameter IP_NUMADDR2 = T1_NUMVROW;//4096;
   parameter IP_BITADDR2 = T1_BITVROW;//12;
   parameter T1_NUMVROW2 = T1_T1_NUMVROW;//1024;
   parameter T1_BITVROW2 = T1_T1_BITVROW;//10;
   parameter T1_NUMSROW2 = T1_T1_NUMSROW;//1024;
   parameter T1_BITSROW2 = T1_T1_BITSROW;//10;
  parameter BITPADR3 = 3+T1_BITSROW2+0+1;
			
  parameter NUMADDR_2 = IP_NUMADDR2;
  parameter BITADDR_2 = IP_BITADDR2;
  parameter NUMVROW_2 = T1_NUMVROW2;  
  parameter BITVROW_2 = T1_BITVROW2;
  parameter NUMSROW_2 = T1_NUMSROW2;
  parameter BITSROW_2 = T1_BITSROW2;
  parameter BITPROW_2 = T1_T1_BITPROW; 
   

 
/*  parameter NUMVBNK = 4;
  parameter BITSROW = 10;
  parameter PHYWDTH = 112;
  parameter BITPADR = 3+10+0+1;
  parameter BITADDRB = 12;
  parameter ENAHEC = 0;//IP_ENAHEC;
  parameter ENAQEC = 0;//IP_ENAQEC; 
   
  parameter NUMADDRA = 3276;//4*4096/5;
  parameter NUMADDRB = 4096;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter BITVBNK = 2;
  parameter NUMPBNK = 5;
  parameter BITADDRA = 11;
  parameter BITPBNK = 3;
  parameter NUMWRDS = 1;     
  parameter BITWRDS = 0;
  parameter NUMSROW = 1024;
  parameter BITPROW = T1_T1_BITPROW; 
 */
  input                                refr;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input [5-1:0]                        read;
  input [5*BITADDR-1:0]                rd_adr;
  output [5-1:0]                       rd_vld;
  output [5*WIDTH-1:0]                 rd_dout;
  output [5-1:0]                       rd_serr;
  output [5-1:0]                       rd_derr;
  output [5*BITPADR1-1:0]              rd_padr;
  output                               ready;

  input [5-1:0] 		       rw_read;
  input [5-1:0] 		       rw_write;
  input [5*BITADDR-1:0] 	       rw_addr;
  output [5-1:0] 		       rw_vld;
  output [5*WIDTH-1:0] 	               rw_dout;
  input [5*WIDTH-1:0] 		       rw_din;
  output [5-1:0] 		       rw_serr;
  output [5-1:0] 		       rw_derr;
  output [5*BITPADR1-1:0] 	       rw_padr;
;

  input 			       algo_sel; 
  input                                clk, rst;
 
  output [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA;
  input [NUMVBNK1*NUMVBNK2-1:0] t1_read_serrA;
   
  output [NUMVBNK1*NUMVBNK2-1:0] t1_refrB;
  output [NUMVBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITSROW2-1:0] t2_addrA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutA;
  input [NUMVBNK1-1:0] t2_read_serrA;
  output [NUMVBNK1-1:0] t2_refrB;
  output [NUMVBNK1*BITRBNK-1:0] t2_bankB;

  output [NUMVBNK2-1:0] t3_readA;
  output [NUMVBNK2-1:0] t3_writeA;
  output [NUMVBNK2*BITSROW2-1:0] t3_addrA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_bwA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_dinA;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_doutA;
  input [NUMVBNK2-1:0] t3_read_serrA;
  output [NUMVBNK2-1:0] t3_refrB;
  output [NUMVBNK2*BITRBNK-1:0] t3_bankB;

  output [1-1:0] t4_readA;
  output [1-1:0] t4_writeA;
  output [1*BITSROW2-1:0] t4_addrA;
  output [1*PHYWDTH2-1:0] t4_bwA;
  output [1*PHYWDTH2-1:0] t4_dinA;
  input [1*PHYWDTH2-1:0] t4_doutA;
  input [1-1:0] t4_read_serrA;
  output [1-1:0] t4_refrB;
  output [1*BITRBNK-1:0] t4_bankB;

   output 		 t1_dwsnA;
   output 		 t2_dwsnA;
   output 		 t3_dwsnA;
   output 		 t4_dwsnA;
   
 //
  wire [NUMVBNK1*NUMVBNK2-1:0] t1_readA_a1;//16
  wire [NUMVBNK1*NUMVBNK2-1:0] t1_writeA_a1;
  wire [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA_a1;
  wire [NUMVBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA_a1;
  wire [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA_a1;
  wire [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA_a1;
  wire [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA_a1;
  wire [NUMVBNK1*NUMVBNK2-1:0] 	t1_read_serrA_a1 = {(NUMVBNK1*NUMVBNK2){1'b0}};
   
  wire [NUMVBNK1*NUMVBNK2-1:0] t1_refrB_a1;
  wire [NUMVBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB_a1;

  wire [NUMVBNK1-1:0] t2_readA_a1;
  wire [NUMVBNK1-1:0] t2_writeA_a1;
  wire [NUMVBNK1*BITSROW2-1:0] t2_addrA_a1;
  wire [NUMVBNK1*BITDWSN-1:0] t2_dwsnA_a1;
  wire [NUMVBNK1*PHYWDTH2-1:0] t2_bwA_a1;
  wire [NUMVBNK1*PHYWDTH2-1:0] t2_dinA_a1;
  wire [NUMVBNK1*PHYWDTH2-1:0] t2_doutA_a1;
  wire [NUMVBNK1-1:0] t2_read_serrA_a1 = {NUMVBNK1{1'b0}};
  wire [NUMVBNK1-1:0] t2_refrB_a1;
  wire [NUMVBNK1*BITRBNK-1:0] t2_bankB_a1;

  wire [NUMVBNK2-1:0] t3_readA_a1;
  wire [NUMVBNK2-1:0] t3_writeA_a1;
  wire [NUMVBNK2*BITSROW2-1:0] t3_addrA_a1;
  wire [NUMVBNK2*BITDWSN-1:0] t3_dwsnA_a1;
  wire [NUMVBNK2*PHYWDTH2-1:0] t3_bwA_a1;
  wire [NUMVBNK2*PHYWDTH2-1:0] t3_dinA_a1;
  wire [NUMVBNK2*PHYWDTH2-1:0] t3_doutA_a1;
  wire [NUMVBNK2-1:0] t3_read_serrA_a1 = {NUMVBNK2{1'b0}};
  wire [NUMVBNK2-1:0] t3_refrB_a1;
  wire [NUMVBNK2*BITRBNK-1:0] t3_bankB_a1;

  wire [1-1:0] t4_readA_a1;
  wire [1-1:0] t4_writeA_a1;
  wire [1*BITSROW2-1:0] t4_addrA_a1;
  wire [1*BITDWSN-1:0] t4_dwsnA_a1;
  wire [1*PHYWDTH2-1:0] t4_bwA_a1;
  wire [1*PHYWDTH2-1:0] t4_dinA_a1;
  wire [1*PHYWDTH2-1:0] t4_doutA_a1;
  wire [1-1:0] t4_read_serrA_a1 = 1'b0;
  wire [1-1:0] t4_refrB_a1;
  wire [1*BITRBNK-1:0] t4_bankB_a1;


  wire [5*NUMVBNK1-1:0] t1_writeA_a2 ;
  wire [5*NUMVBNK1*BITSROW2-1:0] t1_addrA_a2;
  wire [5*NUMVBNK1*PHYWDTH2-1:0] t1_bwA_a2;
  wire [5*NUMVBNK1*PHYWDTH2-1:0] t1_dinA_a2;
  wire [5*NUMVBNK1-1:0] t1_readB_a2;
  wire [5*NUMVBNK1*BITSROW2-1:0] t1_addrB_a2;
  wire [5*NUMVBNK1*PHYWDTH2-1:0] t1_doutB_a2;

  wire [5-1:0] t2_writeA_a2;
  wire [5*BITSROW2-1:0] t2_addrA_a2;
  wire [5*PHYWDTH2-1:0] t2_bwA_a2;
  wire [5*PHYWDTH2-1:0] t2_dinA_a2;
  wire [5-1:0] t2_readB_a2;
  wire [5*BITSROW2-1:0] t2_addrB_a2;
  wire [5*PHYWDTH2-1:0] t2_doutB_a2;

  wire [5*NUMVBNK2-1:0] t1_refrB_a2;
  wire [5-1:0] 	t2_refrB_a2; 
   
  wire [BITADDR-1:0] select_addr;
  wire [BITWDTH-1:0] select_bit;
   
 
  reg ena_rdacc_reg;
  reg algo_sel_reg;
  reg rst_reg;
  reg refr_reg;


    
  always @(posedge clk)
    begin
       ena_rdacc_reg <= 1'b0;//ena_rdacc;
       algo_sel_reg <= (rst? 0 : algo_sel);
       rst_reg <= rst;
       refr_reg <= 1'b0;
    end


  //Output Muxing
   assign t1_writeA           = t1_writeA_a1;
   assign t1_readA            = t1_readA_a1;
   assign t1_addrA            = t1_addrA_a1;
   assign t1_bwA              = t1_bwA_a1[WIDTH*16-1:0];
   assign t1_dinA             = t1_dinA_a1[WIDTH*16-1:0];
   assign t1_doutB_a2[WIDTH*16-1:0]         = t1_doutA [WIDTH*16-1:0];
   assign t1_doutB_a2[WIDTH*20-1:WIDTH*16] = t3_doutA [WIDTH*4-1:0];
   assign t1_doutA_a1 = t1_doutA;

   assign t2_readA  = t2_readA_a1;
   assign t2_writeA = t2_writeA_a1;
   assign t2_addrA = t2_addrA_a1;
   assign t2_bwA  = t2_bwA_a1;
   assign t2_dinA  = t2_dinA_a1;

   assign t2_doutB_a2[112*4-1:0] = t2_doutA[112*4-1:0];
   assign t2_doutB_a2[112*5-1:112*4] = t4_doutA;
   assign t2_doutA_a1 = t2_doutA;

   assign t3_readA = t3_readA_a1;
   assign t3_writeA = t3_writeA_a1;
   assign t3_addrA = t3_addrA_a1;
   assign t3_bwA = t3_bwA_a1;
   assign t3_dinA = t3_dinA_a1;
   assign t3_doutA_a1 = t3_doutA;

   assign t4_readA = t4_readA_a1;
   assign t4_writeA = t4_writeA_a1;
   assign t4_addrA = t4_addrA_a1;
   assign t4_bwA = t4_bwA_a1;
   assign t4_dinA = t4_dinA_a1;
   
   /*
   assign t1_writeA           = algo_sel_reg? t1_writeA_a2 : t1_writeA_a1;
   assign t1_readB            = algo_sel_reg? t1_readB_a2 : t1_readA_a1;
   assign t1_addrB            = algo_sel_reg? t1_addrB_a2   : t1_addrA_a1;
   assign t1_addrA            = algo_sel_reg? t1_addrA_a2   : t1_addrA_a1;
   assign t1_bwA              = algo_sel_reg? t1_bwA_a2[WIDTH*16-1:0] : t1_bwA_a1[WIDTH*16-1:0];
   assign t1_dinA             = algo_sel_reg? t1_dinA_a2[WIDTH*16-1:0] : t1_dinA_a1[WIDTH*16-1:0];
   assign t1_doutB_a2[WIDTH*16-1:0]         = t1_doutB [WIDTH*16-1:0];
   assign t1_doutB_a2[WIDTH*20-1:WIDTH*16] = t3_doutB [WIDTH*4-1:0];
   assign t1_doutA_a1 = t1_doutB;

   assign t2_readB  = algo_sel_reg? t2_readB_a2 [4-1:0] : t2_readA_a1;
   assign t2_writeA = algo_sel_reg? t2_writeA_a2 [4-1:0] : t2_writeA_a1;
   assign t2_addrA = algo_sel_reg? t2_addrA_a2[40-1:0] : t2_addrA_a1;
   assign t2_addrB = algo_sel_reg? t2_addrB_a2[40-1:0] : t2_addrA_a1;
   assign t2_bwA  = algo_sel_reg? t2_bwA_a2[112*4-1:0] : t2_bwA_a1;
   assign t2_dinA  = algo_sel_reg? t2_dinA_a2[112*4-1:0] : t2_dinA_a1;

   assign t2_doutB_a2[112*4-1:0] = t2_doutB[112*4-1:0];
   assign t2_doutB_a2[112*5-1:112*4] = t4_doutB;
   assign t2_doutA_a1 = t2_doutB;

   assign t3_readB = algo_sel_reg? t1_readB_a2[20-1:16] : t3_readA_a1;
   assign t3_writeA = algo_sel_reg? t1_writeA_a2[20-1:16] : t3_writeA_a1;
   assign t3_addrA = algo_sel_reg? t1_addrA_a2[200-1:160] : t3_addrA_a1;
   assign t3_addrB = algo_sel_reg? t1_addrB_a2[200-1:160] : t3_addrA_a1;
   assign t3_bwA = algo_sel_reg? t1_bwA_a2[112*20-1 : 112*16] : t3_bwA_a1;
   assign t3_dinA = algo_sel_reg? t1_dinA_a2[112*20-1:112*16] : t3_dinA_a1;
   assign t3_doutA_a1 = t3_doutB;

   assign t4_readB = algo_sel_reg? t2_readB_a2[5-1:4] : t4_readA_a1;
   assign t4_writeA = algo_sel_reg? t2_writeA_a2[5-1:4] : t4_writeA_a1;
   assign t4_addrA = algo_sel_reg? t2_addrA_a2[50-1:40] : t4_addrA_a1;
   assign t4_addrB = algo_sel_reg? t2_addrB_a2[50-1:40] : t4_addrA_a1;
   assign t4_bwA = algo_sel_reg? t2_bwA_a2[112*5-1:112*4] : t4_bwA_a1;
   assign t4_dinA = algo_sel_reg? t2_dinA_a2[112*5-1:112*4] : t4_dinA_a1;
    */
   assign t4_doutA_a1 = t4_doutA;
   

   reg [10-1:0] 		    readA_a2;
   reg [10*BITADDR-1:0] 	    rd_adrA_a2;
   reg [BITADDR-1:0] 		    rw_addr_wire;
   reg [BITADDR-1:0] 		    rd_adr_wire;
   
   wire [5-1:0]                     writeA = algo_sel_reg? rw_write : {4'b0,write};
   wire [5*BITADDR-1:0] 	    wr_adrA = !algo_sel_reg? {{4*BITADDR{1'b0}},wr_adr} : rw_addr;
   wire [5*WIDTH-1:0] 		    dinA = !algo_sel_reg? {{4*WIDTH{1'b0}},din} : rw_din;
   wire [10-1:0] 		    readA = !algo_sel_reg? {6'b0,read[4-1:0]}: readA_a2;
   wire [10*BITADDR-1:0] 	    rd_adrA = !algo_sel_reg? {{4*BITADDR{1'b0}},rd_adr} : rd_adrA_a2;

   integer a2_ptr;
   always_comb
     begin
	readA_a2 = 0;
	rd_adrA_a2 = 0;
	rw_addr_wire = 0;
	rd_adr_wire = 0;
	for(a2_ptr=0; a2_ptr<5; a2_ptr=a2_ptr+1) begin
	   readA_a2 = readA_a2 | ({rw_read[a2_ptr],read[a2_ptr]} << 2*a2_ptr);
	   rw_addr_wire = rw_addr >> (a2_ptr*BITADDR);
	   rd_adr_wire = rd_adr >> (a2_ptr*BITADDR);
	   rd_adrA_a2 = rd_adrA_a2 | ({rw_addr_wire, rd_adr_wire} << 2*a2_ptr*BITADDR);
	end
     end
   

   
   wire 			    readyA;
   wire [10*WIDTH-1:0] 		    rd_doutA;
   wire [10-1:0] 		    rd_serrA;
   wire [10-1:0] 		    rd_derrA;
   wire [10*BITPADR1-1:0] 	    rd_padrA;
   wire [10-1:0] 		    rd_vldA; 
   wire [5-1:0] 		    readyB_wire;

   reg 				    readyA_reg;
   reg [10*WIDTH-1:0] 		    rd_doutA_reg;
   reg [10-1:0] 		    rd_serrA_reg;
   reg [10-1:0] 		    rd_derrA_reg;
   reg [10*BITPADR1-1:0] 	    rd_padrA_reg;
   reg [10-1:0] 		    rd_vldA_reg;
   
   
  //assign ready  =    algo_sel_reg? &readyB_wire : readyA_reg;
  assign ready  =  readyA_reg; 
   
  wire [3-1:0]        unused_03;
     
  //generate if(1) begin: A1_loop 

  algo_10ror5w_top
		   #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAEXT(ENAEXT), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH),
                     .NUMADDR(NUMADDR),   .BITADDR(BITADDR),
		  .NUMVROW1(NUMVROW1),   .BITVROW1(BITVROW1),   .NUMVBNK1(NUMVBNK1),   .BITVBNK1(BITVBNK1),   .BITPBNK1(BITPBNK1),
		  .FLOPIN1(FLOPIN1),   .FLOPOUT1(FLOPOUT1),   .NUMVROW2(NUMVROW2),   .BITVROW2(BITVROW2),
		  .NUMVBNK2(NUMVBNK2),   .BITVBNK2(BITVBNK2),   .BITPBNK2(BITPBNK2), .PHYWDTH2(PHYWDTH2),
		  .FLOPIN2(FLOPIN2),   .FLOPOUT2(FLOPOUT2),
		  .NUMWRDS2(NUMWRDS2),   .BITWRDS2(BITWRDS2),   .NUMSROW2(NUMSROW2),   .BITSROW2(BITSROW2),
		  .REFRESH(REFRESH),   .NUMRBNK(NUMRBNK),   .BITWSPF(BITWSPF),  .BITRBNK(BITRBNK),   .REFLOPW(REFLOPW),
		  .NUMRROW(NUMRROW),   .BITRROW(BITRROW),   .REFFREQ(REFFREQ),   .REFFRHF(REFFRHF),
		  .NUMDWS0(NUMDWS0),   .NUMDWS1(NUMDWS1),   .NUMDWS2(NUMDWS2),   .NUMDWS3(NUMDWS3),
		  .NUMDWS4(NUMDWS4),   .NUMDWS5(NUMDWS5),   .NUMDWS6(NUMDWS6),   .NUMDWS7(NUMDWS7),
		  .NUMDWS8(NUMDWS8),   .NUMDWS9(NUMDWS9),   .NUMDWS10(NUMDWS10),   .NUMDWS11(NUMDWS11),
		  .NUMDWS12(NUMDWS12),   .NUMDWS13(NUMDWS13),   .NUMDWS14(NUMDWS14),   .NUMDWS15(NUMDWS15),
		  .BITDWSN(BITDWSN),   .SRAM_DELAY(SRAM_DELAY), .FLOPECC(FLOPECC), .FLOPMEM(FLOPMEM), .FLOPCMD(FLOPCMD))
  algo_top
		(.refr(refr_reg), .clk(clk), .rst(rst_reg), .ready(readyA),
		.write(writeA), .wr_adr(wr_adrA), .din(dinA),
		.read(readA), .rd_adr(rd_adrA), .rd_vld(rd_vldA), .rd_dout(rd_doutA), .rd_serr(rd_serrA), .rd_derr(rd_derrA), .rd_padr(rd_padrA),
		.t1_readA(t1_readA_a1), .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dwsnA(t1_dwsnA_a1), .t1_bwA(t1_bwA_a1), .t1_dinA(t1_dinA_a1), .t1_doutA(t1_doutA_a1), .t1_serrA(t1_read_serrA_a1), .t1_refrB(t1_refrB_a1), .t1_bankB(t1_bankB_a1),
		.t2_readA(t2_readA_a1), .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dwsnA(t2_dwsnA_a1), .t2_bwA(t2_bwA_a1), .t2_dinA(t2_dinA_a1), .t2_doutA(t2_doutA_a1), .t2_serrA(t2_read_serrA_a1), .t2_refrB(t2_refrB_a1), .t2_bankB(t2_bankB_a1),
		.t3_readA(t3_readA_a1), .t3_writeA(t3_writeA_a1), .t3_addrA(t3_addrA_a1), .t3_dwsnA(t3_dwsnA_a1), .t3_bwA(t3_bwA_a1), .t3_dinA(t3_dinA_a1), .t3_doutA(t3_doutA_a1), .t3_serrA(t3_read_serrA_a1), .t3_refrB(t3_refrB_a1), .t3_bankB(t3_bankB_a1),
		.t4_readA(t4_readA_a1), .t4_writeA(t4_writeA_a1), .t4_addrA(t4_addrA_a1), .t4_dwsnA(t4_dwsnA_a1), .t4_bwA(t4_bwA_a1), .t4_dinA(t4_dinA_a1), .t4_doutA(t4_doutA_a1), .t4_serrA(t4_read_serrA_a1), .t4_refrB(t4_refrB_a1), .t4_bankB(t4_bankB_a1), .algo_sel(algo_sel_reg), .select_addr(select_addr), .select_bit(select_bit)
		 );

  //end
  //endgenerate



 /*
  wire [2-1:0] rd_vldA_int[5-1:0];
  wire [2*WIDTH-1:0] rd_doutA_int[5-1:0];
  wire [2-1:0] rd_serrA_int[5-1:0];
  wire [2-1:0] rd_derrA_int[5-1:0];
  wire [2*BITPADR-1:0] rd_padrA_int[5-1:0];

  wire [5-1:0] rd_vldB_int[5-1:0];
  wire [5*WIDTH-1:0] rd_doutB_int[5-1:0];
  wire [5-1:0] rd_serrB_int[5-1:0];
  wire [5-1:0] rd_derrB_int[5-1:0];
  wire [5*BITPADR-1:0] rd_padrB_int[5-1:0];
  */

   wire [5-1:0]        rw_vldB_wire;
   wire [5*WIDTH-1:0]  rw_doutB_wire;
   wire [5-1:0]        rw_serrB_wire;
   wire [5-1:0]        rw_derrB_wire;
   wire [5*BITPADR3-1:0] rw_padrB_wire;

   wire [5-1:0] 	rd_vldB_wire;
   wire [5*WIDTH-1:0] 	rd_doutB_wire;
   wire [5-1:0] 	rd_serrB_wire;
   wire [5-1:0] 	rd_derrB_wire;
   wire [5*BITPADR3-1:0] rd_padrB_wire;


  reg [5-1:0]                 rw_vldB;
  reg [5*WIDTH-1:0]           rw_doutB;
  //reg [5*WIDTH-1:0] 	      rw_doutB_wire;
  reg [5-1:0]                 rw_serrB;
  reg [5-1:0]                 rw_derrB;
  reg [5*BITPADR3-1:0]         rw_padrB;
  //reg [5*BITPADR-1:0] 	      rw_padrB_wire;

  reg [5-1:0]                 rd_vldB;
  reg [5*WIDTH-1:0]           rd_doutB;
  //reg [5*WIDTH-1:0]           rd_doutB_wire; 
  reg [5-1:0]                 rd_serrB;
  reg [5-1:0]                 rd_derrB;
  reg [5*BITPADR3-1:0]         rd_padrB;
  //reg [5*BITPADR-1:0]         rd_padrB_wire;


  always @ (posedge clk)
    readyA_reg <= readyA;
    
   
  generate if (FLOPOUT) begin: flp_loop
      always @(posedge clk) begin
     	  rw_vldB  <= rw_vldB_wire;
	  rw_doutB <= rw_doutB_wire;
	  rw_serrB <= rw_serrB_wire;
	  rw_derrB <= rw_derrB_wire;
	  rw_padrB <= rw_padrB_wire;
	  rd_vldB  <= rd_vldB_wire;
	  rd_doutB <= rd_doutB_wire;
	  rd_serrB <= rd_serrB_wire;
	  rd_derrB <= rd_derrB_wire;
	  rd_padrB <= rd_padrB_wire;
      end 
  end else begin: nflp_loop
    always_comb begin
       rw_vldB  = rw_vldB_wire;
       rw_doutB = rw_doutB_wire;
       rw_serrB = rw_serrB_wire;
       rw_derrB = rw_derrB_wire;
       rw_padrB = rw_padrB_wire;
       rd_vldB  = rd_vldB_wire;
       rd_doutB = rd_doutB_wire;
       rd_serrB = rd_serrB_wire;
       rd_derrB = rd_derrB_wire;
       rd_padrB = rd_padrB_wire;
       
    end
  end
  endgenerate    

 
   
   wire [NUMVBNK2*BITSROW_2-1:0] t1_addrA_wire [0:5-1];
   wire [BITSROW_2-1:0] 	      t2_addrA_wire [0:5-1];
   
   genvar i;
   generate for(i=0; i<5; i++) begin
      	 assign t1_addrA_a2[(i+1)*NUMVBNK2*BITSROW_2-1 : i*NUMVBNK2*BITSROW_2] = t1_addrA_wire[i];
	 assign t1_addrB_a2[(i+1)*NUMVBNK2*BITSROW_2-1 : i*NUMVBNK2*BITSROW_2] = t1_addrA_wire[i];
	 assign t2_addrB_a2[(i+1)*BITSROW_2-1 : i*BITSROW_2] = t2_addrA_wire [i];
	 assign t2_addrA_a2[(i+1)*BITSROW_2-1 : i*BITSROW_2] = t2_addrA_wire [i];
   end
   endgenerate
   
   
   assign rw_vld = {rd_vldA[9],rd_vldA[7],rd_vldA[5],rd_vldA[3],rd_vldA[1]};
   assign rw_dout = {rd_doutA[10*WIDTH-1:9*WIDTH] ,rd_doutA[8*WIDTH-1:7*WIDTH], rd_doutA[6*WIDTH-1:5*WIDTH],rd_doutA[4*WIDTH-1:3*WIDTH], rd_doutA[2*WIDTH-1:1*WIDTH]};
   assign rw_serr = {rd_serrA[9],rd_serrA[7],rd_serrA[5],rd_serrA[3],rd_serrA[1]}; 
   assign rw_derr = {rd_derrA[9],rd_derrA[7],rd_derrA[5],rd_derrA[3],rd_derrA[1]}; 
   assign rw_padr = {rd_padrA[10*BITPADR1-1:9*BITPADR1] ,rd_padrA[8*BITPADR1-1:7*BITPADR1], rd_padrA[6*BITPADR1-1:5*BITPADR1],rd_padrA[4*BITPADR1-1:3*BITPADR1], rd_padrA[2*BITPADR1-1:1*BITPADR1]};
  
   assign rd_vld = algo_sel_reg? {rd_vldA[8],rd_vldA[6],rd_vldA[4],rd_vldA[2],rd_vldA[0]} : {1'b0, rd_vldA[3:0]};  
   assign rd_dout = algo_sel_reg? {rd_doutA[9*WIDTH-1:8*WIDTH] ,rd_doutA[7*WIDTH-1:6*WIDTH], rd_doutA[5*WIDTH-1:4*WIDTH],rd_doutA[3*WIDTH-1:2*WIDTH], rd_doutA[1*WIDTH-1:0*WIDTH]} : {{WIDTH{1'b0}}, rd_doutA[4*WIDTH-1:0]};
   assign rd_serr = algo_sel_reg? {rd_serrA[8],rd_serrA[6],rd_serrA[4],rd_serrA[2],rd_serrA[0]} : {1'b0,rd_serrA[3:0]}; 
   assign rd_derr = algo_sel_reg? {rd_derrA[8],rd_derrA[6],rd_derrA[4],rd_derrA[2],rd_derrA[0]} : {1'b0,rd_derrA[3:0]}; 
   assign rd_padr = algo_sel_reg? {rd_padrA[9*BITPADR1-1:8*BITPADR1] ,rd_padrA[7*BITPADR1-1:6*BITPADR1], rd_padrA[5*BITPADR1-1:4*BITPADR1],rd_padrA[3*BITPADR1-1:2*BITPADR1], rd_padrA[BITPADR1-1:0]} :
		    {{BITPADR1{1'b0}}, rd_padrA[4*BITPADR1-1:0]};


   
   
   `ifdef FORMAL_4ROR1W
      
   assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
   assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
   assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
   assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

   assume_select_algo_sel: assume property (@(posedge clk) ((algo_sel == 0) & (algo_sel_reg ==0)));
   assume_select_rd_wr: assume property (@(posedge clk) disable iff (rst) ((rw_read==0) & (rw_write==0) & (read[4]==0)));
   assume_select_rd_wr_conflict: assume property (@(posedge clk) disable iff (rst) (write |->  (read[3:0] == 0)));
   assume_select_wr_rd_conflict: assume property (@(posedge clk) disable iff (rst) (|read[3:0] |->  !write));
   assume_select_wr_start: assume property (@(posedge clk) (!readyA |->  (write == 0)));
   assume_select_rd_start: assume property (@(posedge clk) (!readyA |->  (read == 0)));
 

   reg 		   fakemem;
   reg             fakemem_inv;
   always @(posedge clk)
     if (rst)
       fakemem_inv <= 1'b1;
     else if (write && (wr_adr[BITADDR-1:0] == select_addr)) begin
        fakemem <= din[select_bit];
        fakemem_inv <= 1'b0;
     end

   wire [WIDTH-1:0] rd_dout_0 = rd_dout [WIDTH-1:0];
   wire [WIDTH-1:0] rd_dout_1 = rd_dout [2*WIDTH-1:WIDTH];
   wire [WIDTH-1:0] rd_dout_2 = rd_dout [3*WIDTH-1:2*WIDTH];
   wire [WIDTH-1:0] rd_dout_3 = rd_dout [4*WIDTH-1:3*WIDTH];
         
   assert_dout0_check: assert property (@(posedge clk) disable iff (rst) (read[0] && (rd_adr[BITADDR-1:0] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[0] & (rd_dout_0[select_bit] == $past(fakemem,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout1_check: assert property (@(posedge clk) disable iff (rst) (read[1] && (rd_adr[2*BITADDR-1:BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[1] & (rd_dout_1[select_bit] == $past(fakemem,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout2_check: assert property (@(posedge clk) disable iff (rst) (read[2] && (rd_adr[3*BITADDR-1:2*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[2] & (rd_dout_2[select_bit] == $past(fakemem,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout3_check: assert property (@(posedge clk) disable iff (rst) (read[3] && (rd_adr[4*BITADDR-1:3*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[3] & (rd_dout_3[select_bit] == $past(fakemem,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));

   `elsif FORMAL_10ROR5W
   
   assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMVROW1));
   assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
   assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
   assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));
      
   assume_select_algo_sel: assume property (@(posedge clk) disable iff (rst) ((algo_sel == 1) & (algo_sel_reg == 1)));
   assume_select_rd_wr: assume property (@(posedge clk) disable iff (rst) (write==0));
      
   assume_select_rd_wr_conflict_0: assume property (@(posedge clk) disable iff (rst) (rw_write[0] |->  (!read[0] & !rw_read[0])));
   assume_select_rd_wr_conflict_1: assume property (@(posedge clk) disable iff (rst) (rw_write[1] |->  (!read[1] & !rw_read[1])));
   assume_select_rd_wr_conflict_2: assume property (@(posedge clk) disable iff (rst) (rw_write[2] |->  (!read[2] & !rw_read[2])));
   assume_select_rd_wr_conflict_3: assume property (@(posedge clk) disable iff (rst) (rw_write[3] |->  (!read[3] & !rw_read[3])));
   assume_select_rd_wr_conflict_4: assume property (@(posedge clk) disable iff (rst) (rw_write[4] |->  (!read[4] & !rw_read[4])));
      
   assume_select_wr_rd_conflict_0: assume property (@(posedge clk) disable iff (rst) ((read[0] || rw_read[0]) |->  (rw_write[0] == 0)));
   assume_select_wr_rd_conflict_1: assume property (@(posedge clk) disable iff (rst) ((read[1] || rw_read[1]) |->  (rw_write[1] == 0)));
   assume_select_wr_rd_conflict_2: assume property (@(posedge clk) disable iff (rst) ((read[2] || rw_read[2]) |->  (rw_write[2] == 0)));
   assume_select_wr_rd_conflict_3: assume property (@(posedge clk) disable iff (rst) ((read[3] || rw_read[3]) |->  (rw_write[3] == 0)));
   assume_select_wr_rd_conflict_4: assume property (@(posedge clk) disable iff (rst) ((read[4] || rw_read[4]) |->  (rw_write[4] == 0)));   
   assume_select_wr_start: assume property (@(posedge clk) disable iff (rst) (!readyA |->  (rw_write[4:0] == 0)));

   reg 		   fakemem_0;
   reg 		   fakemem_1;
   reg 		   fakemem_2;
   reg 		   fakemem_3;
   reg 		   fakemem_4;
   reg             fakemem_inv_0;
   reg             fakemem_inv_1;
   reg             fakemem_inv_2;
   reg             fakemem_inv_3;
   reg             fakemem_inv_4;

   wire [WIDTH-1:0] din_0 = rw_din [WIDTH-1:0];
   wire [WIDTH-1:0] din_1 = rw_din [2*WIDTH-1:WIDTH];
   wire [WIDTH-1:0] din_2 = rw_din [3*WIDTH-1:2*WIDTH];
   wire [WIDTH-1:0] din_3 = rw_din [4*WIDTH-1:3*WIDTH];
   wire [WIDTH-1:0] din_4 = rw_din [5*WIDTH-1:4*WIDTH];
   
   
   always @(posedge clk)
     if (rst)
       begin
	  fakemem_inv_0 <= 1'b1;
	  fakemem_inv_1 <= 1'b1;
	  fakemem_inv_2 <= 1'b1;
	  fakemem_inv_3 <= 1'b1;
	  fakemem_inv_4 <= 1'b1;
       end
     else begin
	if (rw_write[0] && (rw_addr[BITVROW1-1:0] == select_addr)) begin
           fakemem_0 <= din_0[select_bit];
           fakemem_inv_0 <= 1'b0;
	end
	if (rw_write[1] && (rw_addr[BITADDR+BITVROW1-1:BITADDR] == select_addr)) begin
           fakemem_1 <= din_1[select_bit];
           fakemem_inv_1 <= 1'b0;
	end
	if (rw_write[2] && (rw_addr[2*BITADDR+BITVROW1-1:2*BITADDR] == select_addr)) begin
           fakemem_2 <= din_2[select_bit];
           fakemem_inv_2 <= 1'b0;
	end
	if (rw_write[3] && (rw_addr[3*BITADDR+BITVROW1-1:3*BITADDR] == select_addr)) begin
           fakemem_3 <= din_3[select_bit];
           fakemem_inv_3 <= 1'b0;
	end
	if (rw_write[4] && (rw_addr[4*BITADDR+BITVROW1-1:4*BITADDR] == select_addr)) begin
           fakemem_4 <= din_4[select_bit];
           fakemem_inv_4 <= 1'b0;
	end
     end // else: !if(rst)
   
   wire [WIDTH-1:0] rd_dout_0 = rd_dout [WIDTH-1:0];
   wire [WIDTH-1:0] rd_dout_1 = rd_dout [2*WIDTH-1:WIDTH];
   wire [WIDTH-1:0] rd_dout_2 = rd_dout [3*WIDTH-1:2*WIDTH];
   wire [WIDTH-1:0] rd_dout_3 = rd_dout [4*WIDTH-1:3*WIDTH];
   wire [WIDTH-1:0] rd_dout_4 = rd_dout [5*WIDTH-1:4*WIDTH];

   wire [WIDTH-1:0] rw_dout_0 = rw_dout [WIDTH-1:0];
   wire [WIDTH-1:0] rw_dout_1 = rw_dout [2*WIDTH-1:WIDTH];
   wire [WIDTH-1:0] rw_dout_2 = rw_dout [3*WIDTH-1:2*WIDTH];
   wire [WIDTH-1:0] rw_dout_3 = rw_dout [4*WIDTH-1:3*WIDTH];
   wire [WIDTH-1:0] rw_dout_4 = rw_dout [5*WIDTH-1:4*WIDTH];

   assert_dout0_check: assert property (@(posedge clk) disable iff (rst) (read[0] && (rd_adr[BITVROW1-1:0] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_0,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[0] & (rd_dout_0[select_bit] == $past(fakemem_0,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout1_check: assert property (@(posedge clk) disable iff (rst) (read[1] && (rd_adr[BITADDR+BITVROW1-1:BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_1,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[1] & (rd_dout_1[select_bit] == $past(fakemem_1,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout2_check: assert property (@(posedge clk) disable iff (rst) (read[2] && (rd_adr[2*BITADDR+BITVROW1-1:2*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_2,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[2] & (rd_dout_2[select_bit] == $past(fakemem_2,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout3_check: assert property (@(posedge clk) disable iff (rst) (read[3] && (rd_adr[3*BITADDR+BITVROW1-1:3*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_3,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[3] & (rd_dout_3[select_bit] == $past(fakemem_3,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_dout4_check: assert property (@(posedge clk) disable iff (rst) (read[4] && (rd_adr[4*BITADDR+BITVROW1-1:4*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_4,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rd_vld[4] & (rd_dout_4[select_bit] == $past(fakemem_4,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   

   assert_rw_dout0_check: assert property (@(posedge clk) disable iff (rst) (rw_read[0] && (rw_addr[BITVROW1-1:0] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_0,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rw_vld[0] & (rw_dout_0[select_bit] == $past(fakemem_0,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_rw_dout1_check: assert property (@(posedge clk) disable iff (rst) (rw_read[1] && (rw_addr[BITADDR+BITVROW1-1:BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_1,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rw_vld[1] & (rw_dout_1[select_bit] == $past(fakemem_1,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_rw_dout2_check: assert property (@(posedge clk) disable iff (rst) (rw_read[2] && (rw_addr[2*BITADDR+BITVROW1-1:2*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_2,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rw_vld[2] & (rw_dout_2[select_bit] == $past(fakemem_2,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_rw_dout3_check: assert property (@(posedge clk) disable iff (rst) (rw_read[3] && (rw_addr[3*BITADDR+BITVROW1-1:3*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_3,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rw_vld[3] & (rw_dout_3[select_bit] == $past(fakemem_3,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));
   assert_rw_dout4_check: assert property (@(posedge clk) disable iff (rst) (rw_read[4] && (rw_addr[4*BITADDR+BITVROW1-1:4*BITADDR] == select_addr)) |-> ##(SRAM_DELAY+FLOPIN1+FLOPOUT1) ($past(fakemem_inv_4,(SRAM_DELAY+FLOPIN1+FLOPOUT1)) || (rw_vld[4] & (rw_dout_4[select_bit] == $past(fakemem_4,(SRAM_DELAY+FLOPIN1+FLOPOUT1))))));

`endif
   
// MEMOIR_TRANSLATE_ON

endmodule    //algo_4ror1w_a94_top_wrap
