/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 *
 * */

module algo_4ror1wor5r5rwp_a943_top_wrap
#(parameter IP_WIDTH = 64, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 8, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13,
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAEXT = 0, parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3,
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 2, parameter T1_BITVBNK = 1, parameter T1_DELAY = 2, parameter T1_NUMVROW = 16384, parameter T1_BITVROW = 14,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 16384, parameter T1_BITSROW = 14, parameter T1_PHYWDTH = 64,
parameter T2_WIDTH = 64, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 16384, parameter T2_BITVROW = 14,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 16384, parameter T2_BITSROW = 14, parameter T2_PHYWDTH = 64,

parameter T1_IP_WIDTH = 64, parameter T1_IP_BITWIDTH = 6, parameter T1_IP_NUMADDR = 16384, parameter T1_IP_BITADDR = 14, parameter T1_IP_NUMVBNK = 2, parameter T1_IP_BITVBNK = 1,
parameter T1_IP_SECCBITS = 4, parameter T1_IP_SECCDWIDTH = 2, parameter T1_FLOPIN = 0, parameter T1_FLOPOUT = 0, parameter T1_FLOPMEM = 0, parameter T1_FLOPECC = 0,
parameter T1_IP_REFRESH = 1, parameter T1_IP_REFFREQ = 24, parameter T1_IP_REFFRHF = 1, parameter T1_IP_BITPBNK = 2, parameter T1_IP_ENAECC = 0, parameter T1_IP_ENAPAR = 0,

parameter T1_T1_WIDTH = 64, parameter T1_T1_NUMVBNK = 2, parameter T1_T1_BITVBNK = 1, parameter T1_T1_DELAY = 2, parameter T1_T1_NUMVROW = 8192, parameter T1_T1_BITVROW = 13,
parameter T1_T1_BITWSPF = 0, parameter T1_T1_NUMWRDS = 1, parameter T1_T1_BITWRDS = 1, parameter T1_T1_NUMSROW = 8192, parameter T1_T1_BITSROW = 13, parameter T1_T1_PHYWDTH = 64,
parameter T1_T1_NUMRBNK = 2, parameter T1_T1_BITRBNK = 1, parameter T1_T1_NUMRROW = 256, parameter T1_T1_BITRROW = 8, parameter T1_T1_NUMPROW = 8192, parameter T1_T1_BITPROW = 13,
parameter T1_T1_BITDWSN = 8,
parameter T1_T1_NUMDWS0 = 0, parameter T1_T1_NUMDWS1 = 0, parameter T1_T1_NUMDWS2 = 0, parameter T1_T1_NUMDWS3 = 0,
parameter T1_T1_NUMDWS4 = 0, parameter T1_T1_NUMDWS5 = 0, parameter T1_T1_NUMDWS6 = 0, parameter T1_T1_NUMDWS7 = 0,
parameter T1_T1_NUMDWS8 = 0, parameter T1_T1_NUMDWS9 = 0, parameter T1_T1_NUMDWS10 = 0, parameter T1_T1_NUMDWS11 = 0,
parameter T1_T1_NUMDWS12 = 0, parameter T1_T1_NUMDWS13 = 0, parameter T1_T1_NUMDWS14 = 0, parameter T1_T1_NUMDWS15 = 0,

parameter T1_T2_WIDTH = 64, parameter T1_T2_NUMVBNK = 1, parameter T1_T2_BITVBNK = 1, parameter T1_T2_DELAY = 2, parameter T1_T2_NUMVROW = 8192, parameter T1_T2_BITVROW = 13,
parameter T1_T2_BITWSPF = 0, parameter T1_T2_NUMWRDS = 1, parameter T1_T2_BITWRDS = 1, parameter T1_T2_NUMSROW = 8192, parameter T1_T2_BITSROW = 13, parameter T1_T2_PHYWDTH = 64,
parameter T1_T2_NUMRBNK = 2, parameter T1_T2_BITRBNK = 1, parameter T1_T2_NUMRROW = 256, parameter T1_T2_BITRROW = 8, parameter T1_T2_NUMPROW = 8192, parameter T1_T2_BITPROW = 13,
//Not Declaring T1_T2 DWSN

parameter T2_IP_WIDTH = 64, parameter T2_IP_BITWIDTH = 6, parameter T2_IP_NUMADDR = 16384, parameter T2_IP_BITADDR = 14, parameter T2_IP_NUMVBNK = 2, parameter T2_IP_BITVBNK = 1,
parameter T2_IP_SECCBITS = 4, parameter T2_IP_SECCDWIDTH = 2, parameter T2_FLOPIN = 0, parameter T2_FLOPOUT = 0, parameter T2_FLOPMEM = 0, parameter T2_FLOPECC = 0,
parameter T2_IP_REFRESH = 1, parameter T2_IP_REFFREQ = 24, parameter T2_IP_REFFRHF = 1, parameter T2_IP_BITPBNK = 2, parameter T2_IP_ENAECC = 0, parameter T2_IP_ENAPAR = 0,

parameter T2_T1_WIDTH = 64, parameter T2_T1_NUMVBNK = 2, parameter T2_T1_BITVBNK = 1, parameter T2_T1_DELAY = 2, parameter T2_T1_NUMVROW = 8192, parameter T2_T1_BITVROW = 13,
parameter T2_T1_BITWSPF = 0, parameter T2_T1_NUMWRDS = 1, parameter T2_T1_BITWRDS = 1, parameter T2_T1_NUMSROW = 8192, parameter T2_T1_BITSROW = 13, parameter T2_T1_PHYWDTH = 64,
parameter T2_T1_NUMRBNK = 2, parameter T2_T1_BITRBNK = 1, parameter T2_T1_NUMRROW = 256, parameter T2_T1_BITRROW = 8, parameter T2_T1_NUMPROW = 8192, parameter T2_T1_BITPROW = 13,
//Not Declaring T2_T1 DWSN

parameter T2_T2_WIDTH = 64, parameter T2_T2_NUMVBNK = 1, parameter T2_T2_BITVBNK = 1, parameter T2_T2_DELAY = 2, parameter T2_T2_NUMVROW = 8192, parameter T2_T2_BITVROW = 13,
parameter T2_T2_BITWSPF = 0, parameter T2_T2_NUMWRDS = 1, parameter T2_T2_BITWRDS = 1, parameter T2_T2_NUMSROW = 8192, parameter T2_T2_BITSROW = 13, parameter T2_T2_PHYWDTH = 64,
parameter T2_T2_NUMRBNK = 2, parameter T2_T2_BITRBNK = 1, parameter T2_T2_NUMRROW = 256, parameter T2_T2_BITRROW = 8, parameter T2_T2_NUMPROW = 8192, parameter T2_T2_BITPROW = 13
//Not Declaring T2_T2 DWSN

)
( clk,  rst,  refr,
 
write, wr_adr, din,
read, rd_adr, rd_dout, rd_vld, rd_serr, rd_derr, rd_padr, algo_sel, 
ready,
rw_read,  rw_write,  rw_addr,  rw_din,  rw_dout,  rw_vld,  rw_serr,  rw_derr,  rw_padr,  
 /*writeA,  wr_adrA,  dinA,
 readA,  rd_adrA,  rd_doutA,  rd_vldA,  rd_serrA,  rd_derrA,  rd_padrA, algo_sel,
 ena_rdaccB, readyB,
 rw_readB,  rw_writeB,  rw_addrB,  rw_dinB,  rw_doutB,  rw_vldB,  rw_serrB,  rw_derrB,  rw_padrB,
 readB,  rd_adrB,  rd_doutB,  rd_vldB,  rd_serrB,  rd_derrB,  rd_padrB,*/
 
 t1_readB,  t1_writeA,  t1_addrA,  t1_addrB, t1_dinA,  t1_bwA,  t1_doutB,  t1_read_serrB, 
 t2_readB,  t2_writeA,  t2_addrA,  t2_addrB, t2_dinA,  t2_bwA,  t2_doutB,  t2_read_serrB, 
 t3_readB,  t3_writeA,  t3_addrA,  t3_addrB, t3_dinA,  t3_bwA,  t3_doutB,  t3_read_serrB, 
 t4_readB,  t4_writeA,  t4_addrA,  t4_addrB, t4_dinA,  t4_bwA,  t4_doutB,  t4_read_serrB 
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
  parameter FLOPIN2 = 0;
  parameter FLOPOUT2 = 0;
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

  parameter NUMVBNK = 4;
  parameter BITSROW = 10;
  parameter PHYWDTH = 112;
  parameter BITPADR = 3+10+0+1;
  parameter BITADDRB = 12;
  parameter ENAHEC = 0;//IP_ENAHEC;
  parameter ENAQEC = 0;//IP_ENAQEC; 
   
  parameter NUMADDRA = 3276;//4*4096/5; //NUMVBNK*NUMADDRB/NUMPBNK;
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
   
  /*
  input [5-1:0] 		       readB;
  input [5*BITADDRB-1:0] 	       rd_adrB;
  output [5-1:0] 		       rd_vldB;
  output [5*WIDTH-1:0] 	               rd_doutB;
  output [5-1:0] 		       rd_serrB;
  output [5-1:0] 		       rd_derrB;
  output [5*BITPADR-1:0] 	       rd_padrB;
  */
   

  /* 
  input                                writeA;
  input [BITADDR-1:0]                  wr_adrA;
  input [WIDTH-1:0]                    dinA;

  input [4-1:0]                        readA;
  input [4*BITADDR-1:0]                rd_adrA;
  output [4-1:0]                       rd_vldA;
  output [4*WIDTH-1:0]                 rd_doutA;
  output [4-1:0]                       rd_serrA;
  output [4-1:0]                       rd_derrA;
  output [4*BITPADR1-1:0]              rd_padrA;
  output                               readyA;
  

  input [5-1:0] 		       rw_readB;
  input [5-1:0] 		       rw_writeB;
  input [5*BITADDRB-1:0] 	       rw_addrB;
  output [5-1:0] 		       rw_vldB;
  output [5*WIDTH-1:0] 	               rw_doutB;
  input [5*WIDTH-1:0] 		       rw_dinB;
  output [5-1:0] 		       rw_serrB;
  output [5-1:0] 		       rw_derrB;
  output [5*BITPADR-1:0] 	       rw_padrB;
   
  input [5-1:0] 		       readB;
  input [5*BITADDRB-1:0] 	       rd_adrB;
  output [5-1:0] 		       rd_vldB;
  output [5*WIDTH-1:0] 	               rd_doutB;
  output [5-1:0] 		       rd_serrB;
  output [5-1:0] 		       rd_derrB;
  output [5*BITPADR-1:0] 	       rd_padrB;
  */
    
  //input 			       ena_rdacc;
  //output 			       readyB;

  input 			       algo_sel; 
  input                                clk, rst;

  wire [5*BITADDRB-1:0] 	       rw_addrB = {rw_addr[4*BITADDR+BITADDRB-1:4*BITADDR], rw_addr[3*BITADDR+BITADDRB-1:3*BITADDR], rw_addr[2*BITADDR+BITADDRB-1:2*BITADDR], rw_addr[BITADDR+BITADDRB-1:BITADDR], rw_addr[BITADDRB-1:0]};
    
 
  output [NUMVBNK1*NUMVBNK2-1:0] t1_readB;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrB; 
  //output [NUMVBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutB;
  input [NUMVBNK1*NUMVBNK2-1:0] t1_read_serrB;
  //output [NUMVBNK1*NUMVBNK2-1:0] t1_refrB;
  //output [NUMVBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB;

  output [NUMVBNK1-1:0] t2_readB;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITSROW2-1:0] t2_addrA;
  output [NUMVBNK1*BITSROW2-1:0] t2_addrB; 
  //output [NUMVBNK1*BITDWSN-1:0] t2_dwsnA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutB;
  input [NUMVBNK1-1:0] t2_read_serrB;
  //output [NUMVBNK1-1:0] t2_refrB;
  //output [NUMVBNK1*BITRBNK-1:0] t2_bankB;

  output [NUMVBNK2-1:0] t3_readB;
  output [NUMVBNK2-1:0] t3_writeA;
  output [NUMVBNK2*BITSROW2-1:0] t3_addrA;
  output [NUMVBNK2*BITSROW2-1:0] t3_addrB;
  //output [NUMVBNK2*BITDWSN-1:0] t3_dwsnA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_bwA;
  output [NUMVBNK2*PHYWDTH2-1:0] t3_dinA;
  input [NUMVBNK2*PHYWDTH2-1:0] t3_doutB;
  input [NUMVBNK2-1:0] t3_read_serrB;
  //output [NUMVBNK2-1:0] t3_refrB;
  //output [NUMVBNK2*BITRBNK-1:0] t3_bankB;

  output [1-1:0] t4_readB;
  output [1-1:0] t4_writeA;
  output [1*BITSROW2-1:0] t4_addrA;
  output [1*BITSROW2-1:0] t4_addrB; 
  //output [1*BITDWSN-1:0] t4_dwsnA;
  output [1*PHYWDTH2-1:0] t4_bwA;
  output [1*PHYWDTH2-1:0] t4_dinA;
  input [1*PHYWDTH2-1:0] t4_doutB;
  input [1-1:0] t4_read_serrB;
  //output [1-1:0] t4_refrB;
  //output [1*BITRBNK-1:0] t4_bankB;
   
 //
  wire [NUMVBNK1*NUMVBNK2-1:0] t1_readA_a1;//16
  wire [NUMVBNK1*NUMVBNK2-1:0] t1_writeA_a1;
  wire [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA_a1;
  wire [NUMVBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA_a1;
  wire [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA_a1;
  wire [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA_a1;
  wire [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA_a1;
  wire [NUMVBNK1*NUMVBNK2-1:0] t1_read_serrA_a1 = t1_read_serrB;
  wire [NUMVBNK1*NUMVBNK2-1:0] t1_refrB_a1;
  wire [NUMVBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB_a1;

  wire [NUMVBNK1-1:0] t2_readA_a1;
  wire [NUMVBNK1-1:0] t2_writeA_a1;
  wire [NUMVBNK1*BITSROW2-1:0] t2_addrA_a1;
  wire [NUMVBNK1*BITDWSN-1:0] t2_dwsnA_a1;
  wire [NUMVBNK1*PHYWDTH2-1:0] t2_bwA_a1;
  wire [NUMVBNK1*PHYWDTH2-1:0] t2_dinA_a1;
  wire [NUMVBNK1*PHYWDTH2-1:0] t2_doutA_a1;
  wire [NUMVBNK1-1:0] t2_read_serrA_a1 = t2_read_serrB;
  wire [NUMVBNK1-1:0] t2_refrB_a1;
  wire [NUMVBNK1*BITRBNK-1:0] t2_bankB_a1;

  wire [NUMVBNK2-1:0] t3_readA_a1;
  wire [NUMVBNK2-1:0] t3_writeA_a1;
  wire [NUMVBNK2*BITSROW2-1:0] t3_addrA_a1;
  wire [NUMVBNK2*BITDWSN-1:0] t3_dwsnA_a1;
  wire [NUMVBNK2*PHYWDTH2-1:0] t3_bwA_a1;
  wire [NUMVBNK2*PHYWDTH2-1:0] t3_dinA_a1;
  wire [NUMVBNK2*PHYWDTH2-1:0] t3_doutA_a1;
  wire [NUMVBNK2-1:0] t3_read_serrA_a1 = t3_read_serrB;
  wire [NUMVBNK2-1:0] t3_refrB_a1;
  wire [NUMVBNK2*BITRBNK-1:0] t3_bankB_a1;

  wire [1-1:0] t4_readA_a1;
  wire [1-1:0] t4_writeA_a1;
  wire [1*BITSROW2-1:0] t4_addrA_a1;
  wire [1*BITDWSN-1:0] t4_dwsnA_a1;
  wire [1*PHYWDTH2-1:0] t4_bwA_a1;
  wire [1*PHYWDTH2-1:0] t4_dinA_a1;
  wire [1*PHYWDTH2-1:0] t4_doutA_a1;
  wire [1-1:0] t4_read_serrA_a1 = t4_read_serrB;
  wire [1-1:0] t4_refrB_a1;
  wire [1*BITRBNK-1:0] t4_bankB_a1;


  wire [5*NUMVBNK-1:0] t1_writeA_a2 ;
  wire [5*NUMVBNK*BITSROW-1:0] t1_addrA_a2;
  wire [5*NUMVBNK*PHYWDTH-1:0] t1_bwA_a2;
  wire [5*NUMVBNK*PHYWDTH-1:0] t1_dinA_a2;
  wire [5*NUMVBNK-1:0] t1_readB_a2;
  wire [5*NUMVBNK*BITSROW-1:0] t1_addrB_a2;
  wire [5*NUMVBNK*PHYWDTH-1:0] t1_doutB_a2;

  wire [5-1:0] t2_writeA_a2;
  wire [5*BITSROW-1:0] t2_addrA_a2;
  wire [5*PHYWDTH-1:0] t2_bwA_a2;
  wire [5*PHYWDTH-1:0] t2_dinA_a2;
  wire [5-1:0] t2_readB_a2;
  wire [5*BITSROW-1:0] t2_addrB_a2;
  wire [5*PHYWDTH-1:0] t2_doutB_a2;

  
  reg ena_rdacc_reg;
  reg algo_sel_reg;
  reg rst_reg;
 
 
  always @(posedge clk)
    begin
       ena_rdacc_reg <= 1'b0;//ena_rdacc;
       algo_sel_reg <= algo_sel;
       rst_reg <= rst;
    end


  //Output Muxing 
   assign t1_writeA [16-1:0] = algo_sel_reg? t1_writeA_a2[16-1:0] : t1_writeA_a1[16-1:0];
   assign t1_readB [16-1:0] = algo_sel_reg? t1_readB_a2[16-1:0] : t1_readA_a1[16-1:0];
   assign t1_addrB [160-1:0]  = algo_sel_reg? t1_addrB_a2[160-1:0]   : t1_addrA_a1[160-1:0];
   assign t1_addrA [160-1:0]  = algo_sel_reg? t1_addrA_a2[160-1:0]   : t1_addrA_a1[160-1:0];
   assign t1_bwA[WIDTH*16-1:0] = algo_sel_reg? t1_bwA_a2[WIDTH*16-1:0] : t1_bwA_a1[WIDTH*16-1:0];
   assign t1_dinA[WIDTH*16-1:0] = algo_sel_reg? t1_dinA_a2[WIDTH*16-1:0] : t1_dinA_a1[WIDTH*16-1:0];
   assign t1_doutB_a2 [WIDTH*16-1:0] = t1_doutB [WIDTH*16-1:0];
   assign t1_doutB_a2 [WIDTH*20-1:WIDTH*16] = t3_doutB [WIDTH*4-1:0];
   assign t1_doutA_a1 = t1_doutB;

   assign t2_readB[4-1:0] = algo_sel_reg? t2_readB_a2 [4-1:0] : t2_readA_a1;
   assign t2_writeA[4-1:0] = algo_sel_reg? t2_writeA_a2 [4-1:0] : t2_writeA_a1;
   assign t2_addrA[10*4-1:0] = algo_sel_reg? t2_addrA_a2[40-1:0] : t2_addrA_a1[40-1:0];
   assign t2_addrB[10*4-1:0] = algo_sel_reg? t2_addrB_a2[40-1:0] : t2_addrA_a1[40-1:0];
   assign t2_bwA[112*4-1:0] = algo_sel_reg? t2_bwA_a2[112*4-1:0] : t2_bwA_a1[112*4-1:0];
   assign t2_dinA[112*4-1:0] = algo_sel_reg? t2_dinA_a2[112*4-1:0] : t2_dinA_a1[112*4-1:0];

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
   assign t4_doutA_a1 = t4_doutB;


  wire                                writeA = write;
  wire [BITADDR-1:0]                  wr_adrA = !algo_sel_reg? wr_adr : 0;
  wire [WIDTH-1:0]                    dinA = din;
  wire [4-1:0]                        readA = !algo_sel_reg? read[4-1:0] : 0;
  wire [4*BITADDR-1:0]                rd_adrA = !algo_sel_reg? rd_adr[4*BITADDR-1:0] : 0;
  wire [5-1:0] 		              readB = algo_sel_reg? read : 0;
  wire [5*BITADDRB-1:0] 	      rd_adrB = algo_sel_reg? {rd_adr[4*BITADDR+BITADDRB-1:4*BITADDR], rd_adr[3*BITADDR+BITADDRB-1:3*BITADDR], rd_adr[2*BITADDR+BITADDRB-1:2*BITADDR], rd_adr[BITADDR+BITADDRB-1:BITADDR], rd_adr[BITADDRB-1:0]} : 0;

  wire readyA;
  wire [4*WIDTH-1:0] rd_doutA;
  wire [4-1:0]      rd_serrA;
  wire [4-1:0]     rd_derrA;
  wire [4*BITPADR1-1:0] rd_padrA;
  wire [4-1:0] 	rd_vldA; 
  wire [5-1:0] 	readyB_wire;
   
  assign ready  =    algo_sel_reg? &readyB_wire : readyA;
   
  wire [3-1:0]        unused_03;
     
  generate if(1) begin: A1_loop 

  algo_4ror1w_top
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
		(.refr(refr), .clk(clk), .rst(rst_reg), .ready(readyA),
		.write(writeA), .wr_adr(wr_adrA), .din(dinA),
		.read(readA), .rd_adr(rd_adrA), .rd_vld(rd_vldA), .rd_dout(rd_doutA), .rd_serr(rd_serrA), .rd_derr(rd_derrA), .rd_padr(rd_padrA),
		.t1_readA(t1_readA_a1), .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dwsnA(t1_dwsnA_a1), .t1_bwA(t1_bwA_a1), .t1_dinA(t1_dinA_a1), .t1_doutA(t1_doutA_a1), .t1_serrA(t1_read_serrA_a1), .t1_refrB(t1_refrB_a1), .t1_bankB(t1_bankB_a1),
		.t2_readA(t2_readA_a1), .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dwsnA(t2_dwsnA_a1), .t2_bwA(t2_bwA_a1), .t2_dinA(t2_dinA_a1), .t2_doutA(t2_doutA_a1), .t2_serrA(t2_read_serrA_a1), .t2_refrB(t2_refrB_a1), .t2_bankB(t2_bankB_a1),
		.t3_readA(t3_readA_a1), .t3_writeA(t3_writeA_a1), .t3_addrA(t3_addrA_a1), .t3_dwsnA(t3_dwsnA_a1), .t3_bwA(t3_bwA_a1), .t3_dinA(t3_dinA_a1), .t3_doutA(t3_doutA_a1), .t3_serrA(t3_read_serrA_a1), .t3_refrB(t3_refrB_a1), .t3_bankB(t3_bankB_a1),
		.t4_readA(t4_readA_a1), .t4_writeA(t4_writeA_a1), .t4_addrA(t4_addrA_a1), .t4_dwsnA(t4_dwsnA_a1), .t4_bwA(t4_bwA_a1), .t4_dinA(t4_dinA_a1), .t4_doutA(t4_doutA_a1), .t4_serrA(t4_read_serrA_a1), .t4_refrB(t4_refrB_a1), .t4_bankB(t4_bankB_a1));

  end
  endgenerate


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



  reg [5-1:0]                 rw_vldB;
  reg [5*WIDTH-1:0]           rw_doutB;
  reg [5*WIDTH-1:0] 	      rw_doutB_wire;
  reg [5-1:0]                 rw_serrB;
  reg [5-1:0]                 rw_derrB;
  reg [5*BITPADR-1:0]         rw_padrB;
  reg [5*BITPADR-1:0] 	      rw_padrB_wire;

  reg [5-1:0]                 rd_vldB;
  reg [5*WIDTH-1:0]           rd_doutB;
  reg [5*WIDTH-1:0]           rd_doutB_wire; 
  reg [5-1:0]                 rd_serrB;
  reg [5-1:0]                 rd_derrB;
  reg [5*BITPADR-1:0]         rd_padrB;
  reg [5*BITPADR-1:0]         rd_padrB_wire; 

  generate if (FLOPOUT) begin: flp_loop
     always_comb begin
	rw_doutB_wire = 0;
	rw_padrB_wire = 0;
	rd_doutB_wire = 0;
	rd_padrB_wire = 0;
       for(int i=0; i<5; i++) begin
	  rw_doutB_wire = rw_doutB_wire | ((ena_rdacc_reg ? rd_doutA_int[i][2*WIDTH-1:WIDTH] : rd_doutB_int[i][5*WIDTH-1:4*WIDTH]) << (i*WIDTH));
	  rw_padrB_wire = rw_padrB_wire | ((ena_rdacc_reg ? rd_padrA_int[i][2*BITPADR-1:BITPADR] : rd_padrB_int[i][5*BITPADR-1:4*BITPADR]) << (i*BITPADR));
	  rd_doutB_wire = rd_doutB_wire | ((ena_rdacc_reg ? rd_doutA_int[i][WIDTH-1:0] : rd_doutB_int[i][WIDTH-1:0]) << (i*WIDTH));
	  rd_padrB_wire = rd_padrB_wire | ((ena_rdacc_reg ? rd_padrA_int[i][BITPADR-1:0] : rd_padrB_int[i][BITPADR-1:0]) << (i*BITPADR));
       end
     end
     always @(posedge clk) begin
       for (int i=0; i<5; i++) begin
	  rw_vldB[i] <= ena_rdacc_reg ? rd_vldA_int[i][2-1] : rd_vldB_int[i][5-1];
	  rw_doutB <= rw_doutB_wire;
	  rw_serrB[i] <= ena_rdacc_reg ? rd_serrA_int[i][2-1] : rd_serrB_int[i][5-1];
	  rw_derrB[i] <= ena_rdacc_reg ? rd_derrA_int[i][2-1] : rd_derrB_int[i][5-1];
	  rw_padrB <= rw_padrB_wire;
	  rd_vldB[i] <= ena_rdacc_reg ? rd_vldA_int[i][0] : rd_vldB_int[i][0];
	  rd_doutB <= rd_doutB_wire;
	  rd_serrB[i] <= ena_rdacc_reg ? rd_serrA_int[i][0] : rd_serrB_int[i][0];
	  rd_derrB[i] <= ena_rdacc_reg ? rd_derrA_int[i][0] : rd_derrB_int[i][0];
	  rd_padrB <= rd_padrB_wire;
       end
     end // always @ (posedge clk)
  end else begin: nflp_loop
    always_comb begin
       for(int i=0; i<5; i++) begin
	  rw_vldB[i] = ena_rdacc_reg ? rd_vldA_int[i][2-1] : rd_vldB_int[i][5-1];
	  rw_doutB = rd_doutB | ((ena_rdacc_reg ? rd_doutA_int[i][2*WIDTH-1:WIDTH] : rd_doutB_int[i][5*WIDTH-1:4*WIDTH]) << (i*WIDTH));
	  rw_serrB[i] = ena_rdacc_reg ? rd_serrA_int[i][2-1] : rd_serrB_int[i][5-1];
	  rw_derrB[i] = ena_rdacc_reg ? rd_derrA_int[i][2-1] : rd_derrB_int[i][5-1];
	  rw_padrB = rw_padrB | ((ena_rdacc_reg ? rd_padrA_int[i][2*BITPADR-1:BITPADR] : rd_padrB_int[i][5*BITPADR-1:4*BITPADR]) << (i*BITPADR));
	  rd_vldB[i] = ena_rdacc_reg ? rd_vldA_int[i][0] : rd_vldB_int[i][0];
	  rd_doutB = rd_doutB | ((ena_rdacc_reg ? rd_doutA_int[i][WIDTH-1:0] : rd_doutB_int[i][WIDTH-1:0]) << (i*WIDTH));
	  rd_serrB[i] = ena_rdacc_reg ? rd_serrA_int[i][0] : rd_serrB_int[i][0];
	  rd_derrB[i] = ena_rdacc_reg ? rd_derrA_int[i][0] : rd_derrB_int[i][0];
	  rd_padrB = rd_padrB | ((ena_rdacc_reg ? rd_padrA_int[i][BITPADR-1:0] : rd_padrB_int[i][BITPADR-1:0]) << (i*BITPADR));
       end
    end
  end
  endgenerate 

   
   
  genvar i;
  generate for(i=0; i<5; i++) begin: A2_loop 
  algo_1r1rwor5rp1wp_top
		  #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ENAHEC(ENAHEC), .ENAQEC(ENAQEC), .ECCWDTH(ECCWDTH), 
                    .NUMADDRA(NUMADDRA), .BITADDRA(BITADDRA), .NUMADDRB(NUMADDRB),   .BITADDRB(BITADDRB),
                    .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK),
                    .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMSROW(NUMSROW), .BITSROW(BITSROW), .SRAM_DELAY(SRAM_DELAY), 
		    .FLOPIN(FLOPIN), .FLOPMEM(FLOPMEM),  .FLOPECC(FLOPECC), .FLOPOUT(0), .PHYWDTH(PHYWDTH))
  algo_top
		(.clk(clk), .rst(rst_reg), .ready(readyB_wire[i]), .ena_rdacc(ena_rdacc_reg),
		.writeA(rw_write[i]), .wr_adrA(rw_addrB[(i+1)*BITADDRA-1 : i*BITADDRA]), .dinA(rw_din[(i+1)*WIDTH-1 : i*WIDTH]),
		.readA({rw_read[i],read[i]}), .rd_adrA({rw_addrB[(i+1)*BITADDRA-1 : i*BITADDRA],rd_adr[(i+1)*BITADDRA-1 : i*BITADDRA]}), .rd_vldA(rd_vldA_int[i]), .rd_doutA(rd_doutA_int[i]),
                .rd_serrA(rd_serrA_int[i]), .rd_derrA(rd_derrA_int[i]), .rd_padrA(rd_padrA_int[i]),
		.writeB(rw_write[i]), .wr_adrB(rw_addrB[(i+1)*BITADDRB-1 : i*BITADDRB]), .dinB(rw_din[(i+1)*WIDTH-1 : i*WIDTH]),
		.readB({rw_read[i],{3'b0,read[i]}}), .rd_adrB({rw_addrB[(i+1)*BITADDRB-1 : i*BITADDRB],{(3*BITADDRB){1'b0}},rd_adrB[(i+1)*BITADDRB-1 : i*BITADDRB]}), .rd_vldB(rd_vldB_int[i]), .rd_doutB(rd_doutB_int[i]),
                .rd_serrB(rd_serrB_int[i]), .rd_derrB(rd_derrB_int[i]), .rd_padrB(rd_padrB_int[i]),
		.t1_writeA(t1_writeA_a2[(i+1)*NUMVBNK-1 : i*NUMVBNK]), .t1_addrA(t1_addrA_a2[(i+1)*NUMVBNK*BITSROW-1 : i*NUMVBNK*BITSROW]), .t1_bwA(t1_bwA_a2[(i+1)*NUMVBNK*PHYWDTH-1 : i*NUMVBNK*PHYWDTH]), .t1_dinA(t1_dinA_a2[(i+1)*NUMVBNK*PHYWDTH-1 : i*NUMVBNK*PHYWDTH]), .t1_readB(t1_readB_a2[(i+1)*NUMVBNK-1 : i*NUMVBNK]), .t1_addrB(t1_addrB_a2[(i+1)*NUMVBNK*BITSROW-1 : i*NUMVBNK*BITSROW]), .t1_doutB(t1_doutB_a2[(i+1)*NUMVBNK*PHYWDTH-1 : i*NUMVBNK*PHYWDTH]),
		.t2_writeA(t2_writeA_a2[i]), .t2_addrA(t2_addrA_a2[(i+1)*BITSROW-1 : i*BITSROW]), .t2_bwA(t2_bwA_a2[(i+1)*PHYWDTH-1 : i*PHYWDTH]), .t2_dinA(t2_dinA_a2[(i+1)*PHYWDTH-1 : i*PHYWDTH]), .t2_readB(t2_readB_a2[i]), .t2_addrB(t2_addrB_a2[(i+1)*BITSROW-1 : i*BITSROW]), .t2_doutB(t2_doutB_a2[(i+1)*PHYWDTH-1 : i*PHYWDTH]));
  end // block: A2_loop
  endgenerate
   
  assign rw_vld = rw_vldB;
  assign rw_dout = rw_doutB;
  assign rw_serr = rw_serrB;
  assign rw_derr = rw_derrB;
  assign rw_padr = {3'b0,rw_padrB[5*BITPADR-1:4*BITPADR], 3'b0,rw_padrB[4*BITPADR-1:3*BITPADR], 3'b0,rw_padrB[3*BITPADR-1:2*BITPADR], 3'b0,rw_padrB[2*BITPADR-1:BITPADR], 3'b0,rw_padrB[BITPADR-1:0]};
   
   assign rd_dout = algo_sel_reg? rd_doutB : {112'b0,rd_doutA};
   assign rd_vld = algo_sel_reg? rd_vldB : rd_vldA;
   assign rd_serr = algo_sel_reg? rd_serrB : {1'b0, rd_serrA};
   assign rd_derr = algo_sel_reg? rd_derrB : {1'b0,rd_derrA};
   assign rd_padr = algo_sel_reg? {3'b0,rd_padrB[5*BITPADR-1:4*BITPADR], 3'b0,rd_padrB[4*BITPADR-1:3*BITPADR], 3'b0,rd_padrB[3*BITPADR-1:2*BITPADR], 3'b0,rd_padrB[2*BITPADR-1:BITPADR], 3'b0,rd_padrB[BITPADR-1:0]} : {17'b0,rd_padrA};

   
 
// MEMOIR_TRANSLATE_ON

endmodule    //algo_4ror1w_a94_top_wrap
