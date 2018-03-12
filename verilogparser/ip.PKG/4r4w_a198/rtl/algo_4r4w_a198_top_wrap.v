/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.UNKNOWN Date: Wed 2012.11.21 at 01:59:18 PM IST
 * */

module algo_4r4w_a198_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 8,	parameter IP_BITVBNK = 3, parameter IP_BITPBNK = 4,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 4, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 39, parameter T1_NUMVBNK = 16, parameter T1_BITVBNK = 3, parameter T1_DELAY = 1, parameter T1_NUMVROW = 1024, parameter T1_BITVROW = 10,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 2, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 512, parameter T1_BITSROW = 9, parameter T1_PHYWDTH = 78,
parameter T2_WIDTH = 39, parameter T2_NUMVBNK = 4, parameter T2_BITVBNK = 2, parameter T2_DELAY = 1, parameter T2_NUMVROW = 1024, parameter T2_BITVROW = 10,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 2, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 512, parameter T2_BITSROW = 9, parameter T2_PHYWDTH = 78,
parameter T3_WIDTH = 12, parameter T3_NUMVBNK = 4, parameter T3_BITVBNK = 2, parameter T3_DELAY = 1, parameter T3_NUMVROW = 1024, parameter T3_BITVROW = 10,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 1024, parameter T3_BITSROW = 10, parameter T3_PHYWDTH = 12)
( clk,  rst,  ready,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  t1_writeA,   t1_addrA,   t1_dinA,    t1_bwA,   t1_writeB,   t1_addrB,   t1_dinB,   t1_bwB,
  t1_readC,    t1_addrC,   t1_doutC,   t1_readD,   t1_addrD,   t1_doutD,
  t2_writeA,   t2_addrA,   t2_dinA,    t2_bwA,   t2_writeB,   t2_addrB,   t2_dinB,   t2_bwB,
  t2_readC,    t2_addrC,   t2_doutC,   t2_readD,   t2_addrD,   t2_doutD,
  t3_dinA,     t3_bwA,     t3_writeB,  t3_addrB,   t3_dinB,   t3_bwB,
  t3_readC,    t3_addrC,   t3_doutC,   t3_readD,   t3_addrD,   t3_doutD,   t3_writeA,   t3_addrA);
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR = 0;
  parameter ENAECC = 1;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter ECCWDTH = IP_DECCBITS;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T1_DELAY;
  
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  
  input [4-1:0]                        write;
  input [4*BITADDR-1:0]                wr_adr;
  input [4*WIDTH-1:0]                  din;

  input [4-1:0]                        read;
  input [4*BITADDR-1:0]                rd_adr;
  output [4-1:0]                       rd_vld;
  output [4*WIDTH-1:0]                 rd_dout;
  output [4-1:0]                       rd_serr;
  output [4-1:0]                       rd_derr;
  output [4*BITPADR-1:0]               rd_padr;

  output                               ready;
  input                                clk, rst;

  output [T1_NUMVBNK-1:0] t1_writeA;
  output [T1_NUMVBNK*BITSROW-1:0] t1_addrA;
  output [T1_NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [T1_NUMVBNK*PHYWDTH-1:0] t1_dinA;
  output [T1_NUMVBNK-1:0] t1_writeB;
  output [T1_NUMVBNK*BITSROW-1:0] t1_addrB;
  output [T1_NUMVBNK*PHYWDTH-1:0] t1_bwB;
  output [T1_NUMVBNK*PHYWDTH-1:0] t1_dinB;

  output [T1_NUMVBNK-1:0] t1_readC;
  output [T1_NUMVBNK*BITSROW-1:0] t1_addrC;
  input  [T1_NUMVBNK*PHYWDTH-1:0] t1_doutC;
  output [T1_NUMVBNK-1:0] t1_readD;
  output [T1_NUMVBNK*BITSROW-1:0] t1_addrD;
  input  [T1_NUMVBNK*PHYWDTH-1:0] t1_doutD;

  output [T2_NUMVBNK-1:0] t2_writeA;
  output [T2_NUMVBNK*BITSROW-1:0] t2_addrA;
  output [T2_NUMVBNK*PHYWDTH-1:0] t2_dinA;
  output [T2_NUMVBNK*PHYWDTH-1:0] t2_bwA;
  output [T2_NUMVBNK-1:0] t2_writeB;
  output [T2_NUMVBNK*BITVROW-1:0] t2_addrB;
  output [T2_NUMVBNK*PHYWDTH-1:0] t2_dinB;
  output [T2_NUMVBNK*PHYWDTH-1:0] t2_bwB;
  
  output [T2_NUMVBNK-1:0] t2_readC;
  output [T2_NUMVBNK*BITSROW-1:0] t2_addrC;
  input  [T2_NUMVBNK*PHYWDTH-1:0] t2_doutC;
  output [T2_NUMVBNK-1:0] t2_readD;
  output [T2_NUMVBNK*BITVROW-1:0] t2_addrD;
  input  [T2_NUMVBNK*PHYWDTH-1:0] t2_doutD;
  
  output [T3_NUMVBNK-1:0] t3_writeA;
  output [T3_NUMVBNK*BITVROW-1:0] t3_addrA;
  output [T3_NUMVBNK*SDOUT_WIDTH-1:0] t3_dinA;
  output [T3_NUMVBNK*SDOUT_WIDTH-1:0] t3_bwA;
  output [T3_NUMVBNK-1:0] t3_writeB;
  output [T3_NUMVBNK*BITVROW-1:0] t3_addrB;
  output [T3_NUMVBNK*SDOUT_WIDTH-1:0] t3_dinB;
  output [T3_NUMVBNK*SDOUT_WIDTH-1:0] t3_bwB;

  output [T3_NUMVBNK-1:0] t3_readC;
  output [T3_NUMVBNK*BITVROW-1:0] t3_addrC;
  input  [T3_NUMVBNK*SDOUT_WIDTH-1:0] t3_doutC;
  output [T3_NUMVBNK-1:0] t3_readD;
  output [T3_NUMVBNK*BITVROW-1:0] t3_addrD;
  input  [T3_NUMVBNK*SDOUT_WIDTH-1:0] t3_doutD;
  
  assign t3_bwA = ~0; assign t3_bwB = ~0;
  
  parameter wmax = 2;
  parameter rmax = 2;
  
  //For T1
  //Write Shorting.   Port Major format.
  wire [T1_NUMVBNK*wmax-1:0] 		 t1_writeA_wire;
  wire [T1_NUMVBNK*wmax*BITSROW-1:0] t1_addrA_wire;
  wire [T1_NUMVBNK*wmax*PHYWDTH-1:0] 	 t1_dinA_wire;
  wire [T1_NUMVBNK*wmax*PHYWDTH-1:0] 	 t1_bwA_wire;
  reg [T1_NUMVBNK*wmax-1:0] 		 t1_writeA_tmp;
  reg [T1_NUMVBNK*wmax*BITSROW-1:0]  t1_addrA_tmp;
  reg [T1_NUMVBNK*wmax*PHYWDTH-1:0] 	 t1_dinA_tmp;
  reg [T1_NUMVBNK*wmax*PHYWDTH-1:0] 	 t1_bwA_tmp;
  always_comb begin
    t1_writeA_tmp = 0; t1_addrA_tmp = 0; t1_dinA_tmp = 0; t1_bwA_tmp = 0;
    for(int rn = 0; rn < wmax; rn++) begin
      for(int cn = 0; cn < T1_NUMVBNK; cn++) begin
        t1_writeA_tmp[rn*T1_NUMVBNK+cn] = t1_writeA_wire[cn*wmax+rn];
        for(int wn = 0; wn < BITSROW; wn++)
          t1_addrA_tmp[(rn*T1_NUMVBNK+cn)*BITSROW+wn] = t1_addrA_wire[(cn*wmax+rn)*BITSROW+wn];
        for(int wn = 0; wn < PHYWDTH; wn++)
          t1_dinA_tmp[(rn*T1_NUMVBNK+cn)*PHYWDTH+wn] = t1_dinA_wire[(cn*wmax+rn)*PHYWDTH+wn];
        for(int wn = 0; wn < PHYWDTH; wn++)
          t1_bwA_tmp[(rn*T1_NUMVBNK+cn)*PHYWDTH+wn] = t1_bwA_wire[(cn*wmax+rn)*PHYWDTH+wn];
//        t1_writeA_tmp  |=  (t1_writeA_wire >> (cn*wmax+rn)*1             & {1{1'b1}})             << 1*(rn*T1_NUMVBNK+cn); 
//        t1_addrA_tmp   |=  (t1_addrA_wire  >> (cn*wmax+rn)*BITSROW       & {BITSROW{1'b1}})       << BITSROW*(rn*T1_NUMVBNK+cn); 
//        t1_dinA_tmp    |=  (t1_dinA_wire   >> (cn*wmax+rn)*PHYWDTH       & {PHYWDTH{1'b1}})       << PHYWDTH*(rn*T1_NUMVBNK+cn); 
//        t1_bwA_tmp     |=  (t1_bwA_wire    >> (cn*wmax+rn)*PHYWDTH       & {PHYWDTH{1'b1}})       << PHYWDTH*(rn*T1_NUMVBNK+cn); 
      end
    end
  end

  assign {t1_writeB, t1_writeA} =  t1_writeA_tmp;
  assign {t1_addrB, t1_addrA} 	=  t1_addrA_tmp;
  assign {t1_dinB, t1_dinA} 	=  t1_dinA_tmp;
  assign {t1_bwB, t1_bwA} 	=  t1_bwA_tmp;
  
  //For read Port Major format.
  wire [T1_NUMVBNK*rmax-1:0] 		 t1_readB_wire;
  wire [T1_NUMVBNK*rmax*BITSROW-1:0] t1_addrB_wire;
  reg [T1_NUMVBNK*rmax*PHYWDTH-1:0] 	 t1_doutB_wire;
  reg [T1_NUMVBNK*rmax-1:0] 		 t1_readB_tmp;
  reg [T1_NUMVBNK*rmax*BITSROW-1:0]  t1_addrB_tmp;
  wire [T1_NUMVBNK*rmax*PHYWDTH-1:0] 	 t1_doutB_tmp;
  always_comb begin
    t1_readB_tmp = 0; t1_addrB_tmp = 0; t1_doutB_wire = 0;
    for(int rn = 0; rn < rmax; rn++) begin
      for(int cn = 0; cn < T1_NUMVBNK; cn++) begin
        t1_readB_tmp[rn*T1_NUMVBNK+cn] = t1_readB_wire[cn*rmax+rn];
        for(int wn = 0; wn < BITSROW; wn++)
          t1_addrB_tmp[(rn*T1_NUMVBNK+cn)*BITSROW+wn] = t1_addrB_wire[(cn*rmax+rn)*BITSROW+wn];
        for(int wn = 0; wn < PHYWDTH; wn++)
          t1_doutB_wire[(cn*rmax+rn)*PHYWDTH+wn] = t1_doutB_tmp[(rn*T1_NUMVBNK+cn)*PHYWDTH+wn];
//        t1_readB_tmp  |=  (t1_readB_wire >> (cn*rmax+rn)*1             & {1{1'b1}})             << 1*(rn*T1_NUMVBNK+cn); 
//        t1_addrB_tmp  |=  (t1_addrB_wire >> (cn*rmax+rn)*BITSROW       & {BITSROW{1'b1}})       << BITSROW*(rn*T1_NUMVBNK+cn); 
//        t1_doutB_wire |=  (t1_doutB_tmp  >> (rn*T1_NUMVBNK+cn)*PHYWDTH & {PHYWDTH{1'b1}})   	<< PHYWDTH*(cn*rmax+rn); 
      end
    end
  end

  assign {t1_readD, t1_readC} =  t1_readB_tmp;
  assign {t1_addrD, t1_addrC} =  t1_addrB_tmp;
  assign {t1_doutB_tmp} = {t1_doutD, t1_doutC};

  
  //For T2 
  //Write Shorting.   Port Major format.
  wire [T2_NUMVBNK*wmax-1:0] 		 t2_writeA_wire;
  wire [T2_NUMVBNK*wmax*BITSROW-1:0] t2_addrA_wire;
  wire [T2_NUMVBNK*wmax*PHYWDTH-1:0] 	 t2_dinA_wire;
  wire [T2_NUMVBNK*wmax*PHYWDTH-1:0] 	 t2_bwA_wire;
  reg [T2_NUMVBNK*wmax-1:0] 		 t2_writeA_tmp;
  reg [T2_NUMVBNK*wmax*BITSROW-1:0]  t2_addrA_tmp;
  reg [T2_NUMVBNK*wmax*PHYWDTH-1:0] 	 t2_dinA_tmp;
  reg [T2_NUMVBNK*wmax*PHYWDTH-1:0] 	 t2_bwA_tmp;
  always_comb begin
    t2_writeA_tmp = 0; t2_addrA_tmp = 0; t2_dinA_tmp = 0; t2_bwA_tmp = 0;
    for(int rn = 0; rn < wmax; rn++) begin
      for(int cn = 0; cn < T2_NUMVBNK; cn++) begin
        t2_writeA_tmp[rn*T2_NUMVBNK+cn] = t2_writeA_wire[cn*wmax+rn];
        for(int wn = 0; wn < BITSROW; wn++)
          t2_addrA_tmp[(rn*T2_NUMVBNK+cn)*BITSROW+wn] = t2_addrA_wire[(cn*wmax+rn)*BITSROW+wn];
        for(int wn = 0; wn < PHYWDTH; wn++)
          t2_dinA_tmp[(rn*T2_NUMVBNK+cn)*PHYWDTH+wn] = t2_dinA_wire[(cn*wmax+rn)*PHYWDTH+wn];
        for(int wn = 0; wn < PHYWDTH; wn++)
          t2_bwA_tmp[(rn*T2_NUMVBNK+cn)*PHYWDTH+wn] = t2_bwA_wire[(cn*wmax+rn)*PHYWDTH+wn];
//        t2_writeA_tmp  |=  (t2_writeA_wire >> (cn*wmax+rn)*1             & {1{1'b1}})             << 1*(rn*T2_NUMVBNK+cn); 
//        t2_addrA_tmp   |=  (t2_addrA_wire  >> (cn*wmax+rn)*BITSROW       & {BITSROW{1'b1}})       << BITSROW*(rn*T2_NUMVBNK+cn); 
//        t2_dinA_tmp    |=  (t2_dinA_wire   >> (cn*wmax+rn)*PHYWDTH       & {PHYWDTH{1'b1}})       << PHYWDTH*(rn*T2_NUMVBNK+cn); 
//        t2_bwA_tmp     |=  (t2_bwA_wire    >> (cn*wmax+rn)*PHYWDTH       & {PHYWDTH{1'b1}})       << PHYWDTH*(rn*T2_NUMVBNK+cn); 
      end
    end
  end

  assign {t2_writeB, t2_writeA} =  t2_writeA_tmp;
  assign {t2_addrB, t2_addrA} 	=  t2_addrA_tmp;
  assign {t2_dinB, t2_dinA} 	=  t2_dinA_tmp;
  assign {t2_bwB, t2_bwA} 	=  t2_bwA_tmp;
  
  //For read Port Major format.
  wire [T2_NUMVBNK*rmax-1:0] 		 t2_readB_wire;
  wire [T2_NUMVBNK*rmax*BITSROW-1:0] t2_addrB_wire;
  reg [T2_NUMVBNK*rmax*PHYWDTH-1:0] 	 t2_doutB_wire;
  reg [T2_NUMVBNK*rmax-1:0] 		 t2_readB_tmp;
  reg [T2_NUMVBNK*rmax*BITSROW-1:0]  t2_addrB_tmp;
  wire [T2_NUMVBNK*rmax*PHYWDTH-1:0] 	 t2_doutB_tmp;
  always_comb begin
    t2_readB_tmp = 0; t2_addrB_tmp = 0; t2_doutB_wire = 0;
    for(int rn = 0; rn < rmax; rn++) begin
      for(int cn = 0; cn < T2_NUMVBNK; cn++) begin
        t2_readB_tmp[rn*T2_NUMVBNK+cn] = t2_readB_wire[cn*rmax+rn];
        for(int wn = 0; wn < BITSROW; wn++)
          t2_addrB_tmp[(rn*T2_NUMVBNK+cn)*BITSROW+wn] = t2_addrB_wire[(cn*rmax+rn)*BITSROW+wn];
        for(int wn = 0; wn < PHYWDTH; wn++)
          t2_doutB_wire[(cn*rmax+rn)*PHYWDTH+wn] = t2_doutB_tmp[(rn*T2_NUMVBNK+cn)*PHYWDTH+wn];
//        t2_readB_tmp  |=  (t2_readB_wire >> (cn*rmax+rn)*1             & {1{1'b1}})             << 1*(rn*T2_NUMVBNK+cn); 
//        t2_addrB_tmp  |=  (t2_addrB_wire >> (cn*rmax+rn)*BITSROW       & {BITSROW{1'b1}})       << BITSROW*(rn*T2_NUMVBNK+cn); 
//        t2_doutB_wire |=  (t2_doutB_tmp  >> (rn*T2_NUMVBNK+cn)*PHYWDTH & {PHYWDTH{1'b1}})       << PHYWDTH*(cn*rmax+rn); 
      end
    end
  end

  assign {t2_readD, t2_readC} =  t2_readB_tmp;
  assign {t2_addrD, t2_addrC} =  t2_addrB_tmp;
  assign {t2_doutB_tmp} = {t2_doutD, t2_doutC};

  //For T3 
  //Write Shorting.   Port Major format.
  wire [T3_NUMVBNK*wmax-1:0]             t3_writeA_wire;
  wire [T3_NUMVBNK*wmax*BITVROW-1:0] t3_addrA_wire;
  wire [T3_NUMVBNK*wmax*SDOUT_WIDTH-1:0]     t3_dinA_wire;
//  wire [T3_NUMVBNK*wmax*SDOUT_WIDTH-1:0]     t3_bwA_wire;
  reg [T3_NUMVBNK*wmax-1:0]              t3_writeA_tmp;
  reg [T3_NUMVBNK*wmax*BITVROW-1:0]  t3_addrA_tmp;
  reg [T3_NUMVBNK*wmax*SDOUT_WIDTH-1:0]      t3_dinA_tmp;
  reg [T3_NUMVBNK*wmax*SDOUT_WIDTH-1:0]      t3_bwA_tmp;
  always_comb begin
    t3_writeA_tmp = 0; t3_addrA_tmp = 0; t3_dinA_tmp = 0; t3_bwA_tmp = 0;
    for(int rn = 0; rn < wmax; rn++) begin
      for(int cn = 0; cn < T3_NUMVBNK; cn++) begin
        t3_writeA_tmp[rn*T3_NUMVBNK+cn] = t3_writeA_wire[cn*wmax+rn];
        for(int wn = 0; wn < BITVROW; wn++)
          t3_addrA_tmp[(rn*T3_NUMVBNK+cn)*BITVROW+wn] = t3_addrA_wire[(cn*wmax+rn)*BITVROW+wn];
        for(int wn = 0; wn < SDOUT_WIDTH; wn++)
          t3_dinA_tmp[(rn*T3_NUMVBNK+cn)*SDOUT_WIDTH+wn] = t3_dinA_wire[(cn*wmax+rn)*SDOUT_WIDTH+wn];
//        for(int wn = 0; wn < SDOUT_WIDTH; wn++)
//          t3_bwA_tmp[(rn*T3_NUMVBNK+cn)*SDOUT_WIDTH+wn] = t3_bwA_wire[(cn*wmax+rn)*SDOUT_WIDTH+wn];
//        t3_writeA_tmp  |=  (t3_writeA_wire >> (cn*wmax+rn)*1             & {1{1'b1}})             << 1*(rn*T3_NUMVBNK+cn); 
//        t3_addrA_tmp   |=  (t3_addrA_wire  >> (cn*wmax+rn)*BITVROW       & {BITVROW{1'b1}})       << BITVROW*(rn*T3_NUMVBNK+cn); 
//        t3_dinA_tmp    |=  (t3_dinA_wire   >> (cn*wmax+rn)*SDOUT_WIDTH   & {SDOUT_WIDTH{1'b1}})   << SDOUT_WIDTH*(rn*T3_NUMVBNK+cn); 
//        t3_bwA_tmp     |=  (t3_bwA_wire    >> (cn*wmax+rn)*SDOUT_WIDTH   & {SDOUT_WIDTH{1'b1}})   << SDOUT_WIDTH*(rn*T3_NUMVBNK+cn); 
      end
    end
  end

  assign {t3_writeB, t3_writeA} =  t3_writeA_tmp;
  assign {t3_addrB, t3_addrA}   =  t3_addrA_tmp;
  assign {t3_dinB, t3_dinA}     =  t3_dinA_tmp;
//  assign {t3_bwB, t3_bwA}       =  t3_bwA_tmp;

  //For read Port Major format.
  wire [T3_NUMVBNK*rmax-1:0] 		 t3_readB_wire;
  wire [T3_NUMVBNK*rmax*BITVROW-1:0] t3_addrB_wire;
  reg [T3_NUMVBNK*rmax*SDOUT_WIDTH-1:0] 	 t3_doutB_wire;
  reg [T3_NUMVBNK*rmax-1:0] 		 t3_readB_tmp;
  reg [T3_NUMVBNK*rmax*BITVROW-1:0]  t3_addrB_tmp;
  wire [T3_NUMVBNK*rmax*SDOUT_WIDTH-1:0] 	 t3_doutB_tmp;
  always_comb begin
    t3_readB_tmp = 0; t3_addrB_tmp = 0; t3_doutB_wire = 0;
    for(int rn = 0; rn < rmax; rn++) begin
      for(int cn = 0; cn < T3_NUMVBNK; cn++) begin
        t3_readB_tmp[rn*T3_NUMVBNK+cn] = t3_readB_wire[cn*rmax+rn];
        for(int wn = 0; wn < BITVROW; wn++)
          t3_addrB_tmp[(rn*T3_NUMVBNK+cn)*BITVROW+wn] = t3_addrB_wire[(cn*rmax+rn)*BITVROW+wn];
        for(int wn = 0; wn < SDOUT_WIDTH; wn++)
          t3_doutB_wire[(cn*rmax+rn)*SDOUT_WIDTH+wn] = t3_doutB_tmp[(rn*T3_NUMVBNK+cn)*SDOUT_WIDTH+wn];
//        t3_readB_tmp  |=  (t3_readB_wire >> (cn*rmax+rn)*1            		& {1{1'b1}})             << 1*(rn*T3_NUMVBNK+cn); 
//        t3_addrB_tmp  |=  (t3_addrB_wire >> (cn*rmax+rn)*BITVROW       		& {BITVROW{1'b1}})       << BITVROW*(rn*T3_NUMVBNK+cn); 
//        t3_doutB_wire |=  (t3_doutB_tmp  >> (rn*T3_NUMVBNK+cn)*SDOUT_WIDTH  & {SDOUT_WIDTH{1'b1}})   << SDOUT_WIDTH*(cn*rmax+rn); 
      end
    end
  end

  assign {t3_readD, t3_readC} =  t3_readB_tmp;
  assign {t3_addrD, t3_addrC} =  t3_addrB_tmp;
  assign {t3_doutB_tmp} = {t3_doutD, t3_doutC};
  
  algo_4r4w_a198_top 
		#(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH),
                  .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMVROW(NUMVROW), .BITVROW(BITVROW),
                  .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .BITPBNK(BITPBNK),
                  .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .NUMSROW(NUMSROW), .BITSROW(BITSROW),
		  .PHYWDTH(PHYWDTH), .ECCBITS(ECCBITS), .SRAM_DELAY(SRAM_DELAY), .FLOPIN(FLOPIN), .FLOPOUT (FLOPOUT))	
  algo_top
		(.clk(clk), .rst(rst), .ready(ready),
		.write(write), .wr_adr(wr_adr), .din(din),
		.read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
		.t1_writeA(t1_writeA_wire), .t1_addrA(t1_addrA_wire), .t1_bwA(t1_bwA_wire), .t1_dinA(t1_dinA_wire), .t1_readB(t1_readB_wire), .t1_addrB(t1_addrB_wire), .t1_doutB(t1_doutB_wire),
		.t2_writeA(t2_writeA_wire), .t2_addrA(t2_addrA_wire), .t2_bwA(t2_bwA_wire), .t2_dinA(t2_dinA_wire), .t2_readB(t2_readB_wire), .t2_addrB(t2_addrB_wire), .t2_doutB(t2_doutB_wire),
		.t3_writeA(t3_writeA_wire), .t3_addrA(t3_addrA_wire), .t3_dinA(t3_dinA_wire), .t3_readB(t3_readB_wire), .t3_addrB(t3_addrB_wire), .t3_doutB(t3_doutB_wire));
  
endmodule    //algo_4r4w_a198_top_wrap
