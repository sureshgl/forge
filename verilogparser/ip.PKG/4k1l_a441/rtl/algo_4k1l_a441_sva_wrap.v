/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

module algo_4k1l_a441_sva_wrap
#(parameter IP_WIDTH = 10,
parameter IP_BITWIDTH = 4,
parameter IP_NUMADDR = 4096,
parameter IP_BITADDR = 12,
parameter IP_NUMVBNK = 4,
parameter IP_BITVBNK = 2,
parameter IP_SECCBITS = 4,
parameter IP_SECCDWIDTH = 3,
parameter IP_BITPBNK = 3,
parameter FLOPIN = 0,
parameter FLOPOUT = 0,
parameter IP_ENAECC = 0,
parameter IP_DECCBITS = 5,
parameter IP_ENAPAR = 0,
parameter FLOPMEM = 0,
parameter FLOPCMD = 0,
parameter T1_WIDTH = 18,
parameter T1_NUMVBNK = 4,
parameter T1_BITVBNK = 2,
parameter T1_DELAY = 2,
parameter T1_NUMVROW = 1024,
parameter T1_BITVROW = 10,
parameter T1_BITWSPF = 0,
parameter T1_NUMWRDS = 1,
parameter T1_BITWRDS = 0,
parameter T1_NUMSROW = 1024,
parameter T1_BITSROW = 10,
parameter T1_PHYWDTH = 18)
( clk, rst, ready, 
  pop, po_pvld, po_ptr,
  push, pu_ptr,
  t1_readB, t1_addrB, t1_doutB, t1_writeA, t1_addrA, t1_bwA, t1_dinA);
 
  parameter NUMPUPT = 4;
  parameter NUMPOPT = 1;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter BITQPTR = BITADDR;
  parameter BITQCNT = BITADDR+1;
  parameter QPTR_WIDTH = T1_WIDTH;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter FLOPECC = 1;
  parameter NUMWRDS = T1_NUMWRDS;
  parameter BITWRDS = T1_BITWRDS; 

  input [NUMPUPT-1:0]              push;
  input [NUMPUPT*BITQPTR-1:0]      pu_ptr;

  input [NUMPOPT-1:0]              pop;
  input [NUMPOPT-1:0]             po_pvld;
  input [NUMPOPT*BITQPTR-1:0]     po_ptr;


  input                           ready;
  input                            clk, rst;

  input [NUMVBNK-1:0]             t1_writeA;
  input [NUMVBNK*(BITADDR-BITVBNK)-1:0]     t1_addrA;
  input [NUMVBNK*QPTR_WIDTH-1:0]  t1_dinA;
  input [NUMVBNK*QPTR_WIDTH-1:0]  t1_bwA;
  input [NUMVBNK-1:0]             t1_readB;
  input [NUMVBNK*(BITADDR-BITVBNK)-1:0]     t1_addrB;
  input [NUMVBNK*QPTR_WIDTH-1:0]   t1_doutB;


  wire [NUMVBNK*QPTR_WIDTH-1:0]  t1_bwA =  ~0; 
 


endmodule    //algo_4k1l_a441_sva_wrap
