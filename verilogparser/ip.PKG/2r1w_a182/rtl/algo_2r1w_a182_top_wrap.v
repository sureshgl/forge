/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_2r1w_a182_top_wrap
#(parameter IP_WIDTH = 90, parameter IP_BITWIDTH = 7, parameter IP_DECCBITS = 8, parameter IP_NUMADDR = 393216, parameter IP_BITADDR = 19, 
parameter IP_NUMVBNK = 32,	parameter IP_BITVBNK = 5, parameter IP_BITPBNK = 6,
parameter IP_ENAEXT = 0, parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 5, parameter IP_SECCDWIDTH = 6, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 0, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 90, parameter T1_NUMVBNK = 32, parameter T1_BITVBNK = 5, parameter T1_DELAY = 1, parameter T1_NUMVROW = 12288, parameter T1_BITVROW = 14,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 12288, parameter T1_BITSROW = 14, parameter T1_PHYWDTH = 90,

parameter T1_IP_WIDTH = 90, parameter T1_IP_BITWIDTH = 7, parameter T1_IP_NUMADDR = 12288, parameter T1_IP_BITADDR = 14, parameter T1_IP_NUMVBNK = 6, parameter T1_IP_BITVBNK = 3,
parameter T1_IP_SECCBITS = 4, parameter T1_IP_SECCDWIDTH = 2, parameter T1_FLOPIN = 0, parameter T1_FLOPOUT = 0, parameter T1_FLOPMEM = 0,
parameter T1_IP_REFRESH = 0, parameter T1_IP_REFFREQ = 21, parameter T1_IP_REFFRHF = 0, parameter T1_IP_BITPBNK = 3,

parameter T1_T1_WIDTH = 90, parameter T1_T1_NUMVBNK = 6, parameter T1_T1_BITVBNK = 3, parameter T1_T1_DELAY = 1, parameter T1_T1_NUMVROW = 2048, parameter T1_T1_BITVROW = 11,
parameter T1_T1_BITWSPF = 0, parameter T1_T1_NUMWRDS = 1, parameter T1_T1_BITWRDS = 0, parameter T1_T1_NUMSROW = 2048, parameter T1_T1_BITSROW = 11, parameter T1_T1_PHYWDTH = 90,
parameter T1_T1_NUMRBNK = 8, parameter T1_T1_BITRBNK = 3, parameter T1_T1_NUMRROW = 256, parameter T1_T1_BITRROW = 8, parameter T1_T1_NUMPROW = 2048, parameter T1_T1_BITPROW = 11,
parameter T1_T1_BITDWSN = 8, 
parameter T1_T1_NUMDWS0 = 0, parameter T1_T1_NUMDWS1 = 0, parameter T1_T1_NUMDWS2 = 0, parameter T1_T1_NUMDWS3 = 0,
parameter T1_T1_NUMDWS4 = 0, parameter T1_T1_NUMDWS5 = 0, parameter T1_T1_NUMDWS6 = 0, parameter T1_T1_NUMDWS7 = 0,
parameter T1_T1_NUMDWS8 = 0, parameter T1_T1_NUMDWS9 = 0, parameter T1_T1_NUMDWS10 = 0, parameter T1_T1_NUMDWS11 = 0,
parameter T1_T1_NUMDWS12 = 0, parameter T1_T1_NUMDWS13 = 0, parameter T1_T1_NUMDWS14 = 0, parameter T1_T1_NUMDWS15 = 0,

parameter T1_T2_WIDTH = 90, parameter T1_T2_NUMVBNK = 1, parameter T1_T2_BITVBNK = 0, parameter T1_T2_DELAY = 1, parameter T1_T2_NUMVROW = 2048, parameter T1_T2_BITVROW = 11,
parameter T1_T2_BITWSPF = 0, parameter T1_T2_NUMWRDS = 1, parameter T1_T2_BITWRDS = 0, parameter T1_T2_NUMSROW = 2048, parameter T1_T2_BITSROW = 11, parameter T1_T2_PHYWDTH = 90,
parameter T1_T2_NUMRBNK = 8, parameter T1_T2_BITRBNK = 3, parameter T1_T2_NUMRROW = 256, parameter T1_T2_BITRROW = 8, parameter T1_T2_NUMPROW = 2048, parameter T1_T2_BITPROW = 11,
//Not delcaring DWSN for T1_T2

parameter T3_WIDTH = 90, parameter T3_NUMVBNK = 6, parameter T3_BITVBNK = 3, parameter T3_DELAY = 1, parameter T3_NUMVROW = 12288, parameter T3_BITVROW = 14,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 12288, parameter T3_BITSROW = 14, parameter T3_PHYWDTH = 90,

parameter T2_WIDTH = 17, parameter T2_NUMVBNK = 6, parameter T2_BITVBNK = 3, parameter T2_DELAY = 1, parameter T2_NUMVROW = 12288, parameter T2_BITVROW = 14,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 12288, parameter T2_BITSROW = 14, parameter T2_PHYWDTH = 17)
( clk,  rst,  ready,  refr,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA,
  t1_readB, t1_writeB, t1_addrB, t1_dinB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB, t1_refrC, t1_ready,
  t2_writeA,   t2_addrA,   t2_dinA,   t2_bwA,   
  t2_readB,   t2_addrB,   t2_doutB,
  t3_writeA,   t3_addrA,   t3_dinA,   t3_bwA,   
  t3_readB,   t3_addrB,   t3_doutB);
  
  // MEMOIR_TRANSLATE_OFF
  
  parameter NUMRDPT = 2;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 1;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAEXT = IP_ENAEXT;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW1 = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW1 = T1_BITVROW;
  parameter NUMVBNK1 = IP_NUMVBNK;
  parameter BITVBNK1 = IP_BITVBNK;
  parameter BITPBNK1 = IP_BITPBNK;
  parameter FLOPIN1 = FLOPIN;
  parameter FLOPOUT1 = FLOPOUT;
  parameter NUMWRDS1 = 1;     // ALIGN Parameters
  parameter BITWRDS1 = 0;
  parameter NUMSROW1 = T1_NUMSROW;
  parameter BITSROW1 = T1_BITVROW;
  parameter PHYWDTH1 = IP_WIDTH;
  parameter NUMVROW2 = T1_T1_NUMVROW;   // ALGO2 Parameters
  parameter BITVROW2 = T1_T1_BITVROW;
  parameter NUMVBNK2 = T1_IP_NUMVBNK;
  parameter BITVBNK2 = T1_IP_BITVBNK;
  parameter BITPBNK2 = T1_IP_BITPBNK;
  parameter FLOPIN2 = 1;
  parameter FLOPOUT2 = 1;
  parameter NUMWRDS2 = T1_T1_NUMWRDS;     // ALIGN Parameters
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
  
  parameter BITDWSN = T1_T1_BITDWSN;        //DWSN Parameters
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
  
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_T1_DELAY;

  parameter MEMWDTH = ENAEXT ? WIDTH : ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK1+1)+ECCBITS;
  parameter NUMCASH = NUMRDPT+NUMRWPT+NUMWRPT-1;

  input                                            refr;

  input  [NUMWRPT - 1:0]            write; 
  input  [NUMWRPT* BITADDR - 1:0]     wr_adr; 
  input  [NUMWRPT* WIDTH - 1:0]        din;

  input  [NUMRDPT - 1:0]             read; 
  input  [NUMRDPT* BITADDR - 1:0]     rd_adr; 
  output [NUMRDPT* WIDTH - 1:0]     rd_dout; 
  output [NUMRDPT - 1:0]             rd_vld; 
  output [NUMRDPT - 1:0]             rd_serr; 
  output [NUMRDPT - 1:0]             rd_derr; 
  output [NUMRDPT* BITPADR1 - 1:0]     rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMVBNK1-1:0] t1_readA;
  output [NUMVBNK1-1:0] t1_writeA;
  output [NUMVBNK1*BITVROW1-1:0] t1_addrA;
  output [NUMVBNK1*PHYWDTH2-1:0] t1_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t1_doutA;
  input [NUMVBNK1-1:0] t1_fwrdA;
  input [NUMVBNK1-1:0] t1_serrA;
  input [NUMVBNK1-1:0] t1_derrA;
  input [NUMVBNK1*BITPADR2-1:0] t1_padrA;
  output [NUMVBNK1-1:0] t1_readB;
  output [NUMVBNK1-1:0] t1_writeB;
  output [NUMVBNK1*BITVROW1-1:0] t1_addrB;
  output [NUMVBNK1*PHYWDTH2-1:0] t1_dinB;
  input [NUMVBNK1*PHYWDTH2-1:0] t1_doutB;
  input [NUMVBNK1-1:0] t1_fwrdB;
  input [NUMVBNK1-1:0] t1_serrB;
  input [NUMVBNK1-1:0] t1_derrB;
  input [NUMVBNK1*BITPADR2-1:0] t1_padrB;
  output [NUMVBNK1-1:0] t1_refrC;
  input [NUMVBNK1-1:0] t1_ready;

  parameter SHORTWR = 3;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t2_writeA;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrA;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_dinA;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_bwA;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrB;
  input  [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB;

  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrA;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_dinA;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_bwA;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB;
  input  [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_doutB;
  
  wire [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t2_writeA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_bwA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_dinA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_bwA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_dinA_tmp;

  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB_wire;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrB_wire;
  reg  [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB_wire;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB_wire;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB_wire;
  reg  [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_doutB_wire;

  //For read
  //Port Major format.
  reg [2*NUMVBNK1-1:0] t1_readA_tmp;
  reg [2*NUMVBNK1-1:0] t1_writeA_tmp;
  reg [2*NUMVBNK1*BITVROW1-1:0] t1_addrA_tmp;
  reg [2*NUMVBNK1*PHYWDTH2-1:0] t1_dinA_tmp;
  wire [2*NUMVBNK1*PHYWDTH2-1:0] t1_doutA_tmp;
  wire [2*NUMVBNK1-1:0] t1_fwrdA_tmp;
  wire [2*NUMVBNK1-1:0] t1_serrA_tmp;
  wire [2*NUMVBNK1-1:0] t1_derrA_tmp;
  wire [2*NUMVBNK1*BITPADR2-1:0] t1_padrA_tmp;
  reg [2*NUMVBNK1-1:0] t1_refrB_tmp;

  reg [2*NUMVBNK1*PHYWDTH2-1:0] t1_doutA_wire;
  reg [2*NUMVBNK1-1:0] t1_fwrdA_wire;
  reg [2*NUMVBNK1-1:0] t1_serrA_wire;
  reg [2*NUMVBNK1-1:0] t1_derrA_wire;
  reg [2*NUMVBNK1*BITPADR2-1:0] t1_padrA_wire;

  wire [2*NUMVBNK1-1:0] t1_readA_wire;
  wire [2*NUMVBNK1-1:0] t1_writeA_wire;
  wire [2*NUMVBNK1*BITVROW1-1:0] t1_addrA_wire;
  wire [2*NUMVBNK1*PHYWDTH2-1:0] t1_dinA_wire;
  wire [2*NUMVBNK1-1:0] t1_refrB_wire;
  always_comb begin
    t1_readA_tmp = 0; t1_writeA_tmp = 0; t1_addrA_tmp = 0; t1_dinA_tmp = 0; t1_refrB_tmp = 0;
    t1_doutA_wire = 0; t1_fwrdA_wire = 0; t1_serrA_wire = 0; t1_derrA_wire = 0; t1_padrA_wire = 0;
    for(int pn = 0; pn < 2; pn++) begin
      for(int bn = 0; bn < NUMVBNK1; bn++) begin
        t1_readA_tmp  |=  (t1_readA_wire >> (bn*2+pn)*1                   & {1{1'b1}})              << 1*(pn*NUMVBNK1+bn);
        t1_writeA_tmp  |=  (t1_writeA_wire >> (bn*2+pn)*1                 & {1{1'b1}})              << 1*(pn*NUMVBNK1+bn);
        t1_addrA_tmp  |=  (t1_addrA_wire >> (bn*2+pn)*BITVROW1            & {BITVROW1{1'b1}})       << BITVROW1*(pn*NUMVBNK1+bn);
        t1_dinA_tmp  |=  (t1_dinA_wire >> (bn*2+pn)*PHYWDTH2              & {PHYWDTH2{1'b1}})       << PHYWDTH2*(pn*NUMVBNK1+bn);

        t1_doutA_wire  |=  (t1_doutA_tmp   >> (pn*NUMVBNK1+bn)*PHYWDTH2   & {PHYWDTH2{1'b1}})       << PHYWDTH2*(bn*2+pn);
        t1_fwrdA_wire  |=  (t1_fwrdA_tmp   >> (pn*NUMVBNK1+bn)*1          & {1{1'b1}})              << 1*(bn*2+pn);
        t1_serrA_wire  |=  (t1_serrA_tmp   >> (pn*NUMVBNK1+bn)*1          & {1{1'b1}})              << 1*(bn*2+pn);
        t1_derrA_wire  |=  (t1_derrA_tmp   >> (pn*NUMVBNK1+bn)*1          & {1{1'b1}})              << 1*(bn*2+pn);
        t1_padrA_wire  |=  (t1_padrA_tmp   >> (pn*NUMVBNK1+bn)*BITPADR2   & {BITPADR2{1'b1}})       << BITPADR2*(bn*2+pn);
      end
    end
  end

  assign {t1_readB,t1_readA} = t1_readA_tmp;
  assign {t1_writeB,t1_writeA} = t1_writeA_tmp;
  assign {t1_addrB,t1_addrA} = t1_addrA_tmp;
  assign {t1_dinB,t1_dinA} = t1_dinA_tmp;
  assign t1_doutA_tmp = {t1_doutB,t1_doutA};
  assign t1_fwrdA_tmp = {t1_fwrdB,t1_fwrdA};
  assign t1_serrA_tmp = {t1_serrB,t1_serrA};
  assign t1_derrA_tmp = {t1_derrB,t1_derrA};
  assign t1_padrA_tmp = {t1_padrB,t1_padrA};

  
  parameter cmax = NUMCASH;
  parameter rmax = NUMRDPT+NUMRWPT+NUMWRPT;
  
  //For read
  //Port Major format.
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB_tmp;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrB_tmp;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB_tmp;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB_tmp;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB_tmp;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_doutB_tmp;
  always_comb begin
    t2_readB_tmp = 0; t2_addrB_tmp = 0; t2_doutB_wire = 0;
    t3_readB_tmp = 0; t3_addrB_tmp = 0; t3_doutB_wire = 0;
    for(int rn = 0; rn < rmax; rn++) begin
      for(int cn = 0; cn < cmax; cn++) begin
        t2_readB_tmp  |=  (t2_readB_wire >> (cn*rmax+rn)*1            & {1{1'b1}})              << 1*(rn*cmax+cn); 
        t2_addrB_tmp  |=  (t2_addrB_wire >> (cn*rmax+rn)*BITVROW1     & {BITVROW1{1'b1}})       << BITVROW1*(rn*cmax+cn); 
        t3_readB_tmp  |=  (t3_readB_wire >> (cn*rmax+rn)*1            & {1{1'b1}})              << 1*(rn*cmax+cn); 
        t3_addrB_tmp  |=  (t3_addrB_wire >> (cn*rmax+rn)*BITVROW1     & {BITVROW1{1'b1}})       << BITVROW1*(rn*cmax+cn); 
        
        t2_doutB_wire  |=  (t2_doutB_tmp   >> (rn*cmax+cn)*SDOUT_WIDTH & {SDOUT_WIDTH{1'b1}})   << SDOUT_WIDTH*(cn*rmax+rn); 
        t3_doutB_wire  |=  (t3_doutB_tmp   >> (rn*cmax+cn)*WIDTH       & {WIDTH{1'b1}})         << WIDTH*(cn*rmax+rn); 
      end
    end
  end
  
  assign t2_readB = t2_readB_tmp;
  assign t3_readB = t3_readB_tmp;
  assign t2_addrB = t2_addrB_tmp;
  assign t3_addrB = t3_addrB_tmp;
  assign t2_doutB_tmp = t2_doutB;
  assign t3_doutB_tmp = t3_doutB;
  
  wire [NUMWRPT*WIDTH-1 :0]     rd_dout_nocon;
  wire [NUMWRPT-1 :0]           rd_vld_nocon;
  wire [NUMWRPT-1 :0]           rd_serr_nocon;
  wire [NUMWRPT-1 :0]           rd_derr_nocon;
  wire [NUMWRPT*BITPADR1-1 :0]  rd_padr_nocon;
  
  algo_2r1w_2rw_rl_top 
           #(.WIDTH(WIDTH),   .BITWDTH(BITWDTH), .ENAEXT(ENAEXT), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH), .NUMADDR(NUMADDR),   .BITADDR(BITADDR),
          .NUMVROW1(NUMVROW1),   .BITVROW1(BITVROW1),   .NUMVBNK1(NUMVBNK1),   .BITVBNK1(BITVBNK1),   .BITPBNK1(BITPBNK1),
          .FLOPIN1(FLOPIN1),   .FLOPOUT1(FLOPOUT1),
          .NUMWRDS1(NUMWRDS1),   .BITWRDS1(BITWRDS1),   .NUMSROW1(NUMSROW1),   .BITSROW1(BITSROW1),
          .NUMVROW2(NUMVROW2),   .BITVROW2(BITVROW2),   .NUMVBNK2(NUMVBNK2),   .BITVBNK2(BITVBNK2),   .BITPBNK2(BITPBNK2),
          .FLOPIN2(FLOPIN2),   .FLOPOUT2(FLOPOUT2),
          .NUMWRDS2(NUMWRDS2),   .BITWRDS2(BITWRDS2),   .NUMSROW2(NUMSROW2),   .BITSROW2(BITSROW2),   .REFRESH(REFRESH),
          .NUMRBNK(NUMRBNK),   .BITWSPF(BITWSPF),  .BITRBNK(BITRBNK),   .REFLOPW(REFLOPW),   .NUMRROW(NUMRROW),   .BITRROW(BITRROW),
          .REFFREQ(REFFREQ),   .REFFRHF(REFFRHF),
          .NUMDWS0(NUMDWS0),   .NUMDWS1(NUMDWS1),   .NUMDWS2(NUMDWS2),   .NUMDWS3(NUMDWS3),
          .NUMDWS4(NUMDWS4),   .NUMDWS5(NUMDWS5),   .NUMDWS6(NUMDWS6),   .NUMDWS7(NUMDWS7),
          .NUMDWS8(NUMDWS8),   .NUMDWS9(NUMDWS9),   .NUMDWS10(NUMDWS10),   .NUMDWS11(NUMDWS11),
          .NUMDWS12(NUMDWS12),   .NUMDWS13(NUMDWS13),   .NUMDWS14(NUMDWS14),   .NUMDWS15(NUMDWS15),
          .BITDWSN(BITDWSN),   .ECCBITS(ECCBITS),   .SRAM_DELAY(SRAM_DELAY),   .DRAM_DELAY(DRAM_DELAY),
          .FLOPCMD(FLOPCMD), .FLOPMEM(FLOPMEM), .FLOPECC(FLOPECC))
  algo_top
        (.clk(clk), .rst(rst), .ready(ready), .refr(refr), 
        .read({{NUMWRPT{1'b0}}, read}),
        .write({write, {NUMRDPT{1'b0}}}),
        .addr({wr_adr, rd_adr}),
        .din({din, {(NUMRDPT*WIDTH){1'b0}}}),        
        .rd_dout({rd_dout_nocon, rd_dout}),
        .rd_vld ({rd_vld_nocon,  rd_vld}),
        .rd_serr({rd_serr_nocon,  rd_serr}),
        .rd_derr({rd_derr_nocon, rd_derr}),
        .rd_padr({rd_padr_nocon, rd_padr}),
        .t1_readA(t1_readA_wire), .t1_writeA(t1_writeA_wire), .t1_addrA(t1_addrA_wire), .t1_dinA(t1_dinA_wire),
        .t1_doutA(t1_doutA_wire), .t1_fwrdA(t1_fwrdA_wire), .t1_serrA(t1_serrA_wire), .t1_derrA(t1_derrA_wire), .t1_padrA(t1_padrA_wire), .t1_refrB(t1_refrB_wire),
        .t1_ready(t1_ready),
        .t2_writeA(t2_writeA_tmp), .t2_addrA(t2_addrA_tmp), .t2_bwA(t2_bwA_tmp), .t2_dinA(t2_dinA_tmp), .t2_readB(t2_readB_wire), .t2_addrB(t2_addrB_wire), .t2_doutB(t2_doutB_wire),
        .t3_writeA(t3_writeA_tmp), .t3_addrA(t3_addrA_tmp), .t3_bwA(t3_bwA_tmp), .t3_dinA(t3_dinA_tmp), .t3_readB(t3_readB_wire), .t3_addrB(t3_addrB_wire), .t3_doutB(t3_doutB_wire));

assign t2_writeA = {SHORTWR{t2_writeA_tmp}};
assign t2_addrA = {SHORTWR{t2_addrA_tmp}};
assign t2_bwA = {SHORTWR{t2_bwA_tmp}};
assign t2_dinA = {SHORTWR{t2_dinA_tmp}};
assign t3_writeA = {SHORTWR{t3_writeA_tmp}};
assign t3_addrA = {SHORTWR{t3_addrA_tmp}};
assign t3_bwA = {SHORTWR{t3_bwA_tmp}}; 
assign t3_dinA = {SHORTWR{t3_dinA_tmp}}; 

// MEMOIR_TRANSLATE_ON

endmodule    //algo_2r1w_a182_top_wrap
