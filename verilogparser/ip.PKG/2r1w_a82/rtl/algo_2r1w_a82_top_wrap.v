/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_2r1w_a82_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAEXT = 0, parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 2, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 32,

parameter T1_IP_WIDTH = 32, parameter T1_IP_BITWIDTH = 5, parameter T1_IP_NUMADDR = 2048, parameter T1_IP_BITADDR = 11, parameter T1_IP_NUMVBNK = 4, parameter T1_IP_BITVBNK = 2,
parameter T1_IP_SECCBITS = 4, parameter T1_IP_SECCDWIDTH = 2, parameter T1_FLOPIN = 0, parameter T1_FLOPOUT = 0, parameter T1_FLOPMEM = 0,
parameter T1_IP_REFRESH = 1, parameter T1_IP_REFFREQ = 21, parameter T1_IP_REFFRHF = 0, parameter T1_IP_BITPBNK = 2,

parameter T1_T1_WIDTH = 32, parameter T1_T1_NUMVBNK = 4, parameter T1_T1_BITVBNK = 2, parameter T1_T1_DELAY = 2, parameter T1_T1_NUMVROW = 512, parameter T1_T1_BITVROW = 9,
parameter T1_T1_BITWSPF = 0, parameter T1_T1_NUMWRDS = 1, parameter T1_T1_BITWRDS = 0, parameter T1_T1_NUMSROW = 512, parameter T1_T1_BITSROW = 9, parameter T1_T1_PHYWDTH = 32,
parameter T1_T1_NUMRBNK = 8, parameter T1_T1_BITRBNK = 3, parameter T1_T1_NUMRROW = 64, parameter T1_T1_BITRROW = 6, parameter T1_T1_NUMPROW = 512, parameter T1_T1_BITPROW = 9,
parameter T1_T1_BITDWSN = 8, 
parameter T1_T1_NUMDWS0 = 0, parameter T1_T1_NUMDWS1 = 0, parameter T1_T1_NUMDWS2 = 0, parameter T1_T1_NUMDWS3 = 0,
parameter T1_T1_NUMDWS4 = 0, parameter T1_T1_NUMDWS5 = 0, parameter T1_T1_NUMDWS6 = 0, parameter T1_T1_NUMDWS7 = 0,
parameter T1_T1_NUMDWS8 = 0, parameter T1_T1_NUMDWS9 = 0, parameter T1_T1_NUMDWS10 = 0, parameter T1_T1_NUMDWS11 = 0,
parameter T1_T1_NUMDWS12 = 0, parameter T1_T1_NUMDWS13 = 0, parameter T1_T1_NUMDWS14 = 0, parameter T1_T1_NUMDWS15 = 0,

parameter T1_T2_WIDTH = 32, parameter T1_T2_NUMVBNK = 4, parameter T1_T2_BITVBNK = 2, parameter T1_T2_DELAY = 2, parameter T1_T2_NUMVROW = 512, parameter T1_T2_BITVROW = 9,
parameter T1_T2_BITWSPF = 0, parameter T1_T2_NUMWRDS = 1, parameter T1_T2_BITWRDS = 1, parameter T1_T2_NUMSROW = 512, parameter T1_T2_BITSROW = 9, parameter T1_T2_PHYWDTH = 32,
parameter T1_T2_NUMRBNK = 8, parameter T1_T2_BITRBNK = 3, parameter T1_T2_NUMRROW = 64, parameter T1_T2_BITRROW = 6, parameter T1_T2_NUMPROW = 512, parameter T1_T2_BITPROW = 9,
//Not delcaring DWSN for T1_T2

parameter T3_WIDTH = 32, parameter T3_NUMVBNK = 6, parameter T3_BITVBNK = 3, parameter T3_DELAY = 1, parameter T3_NUMVROW = 2048, parameter T3_BITVROW = 11,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 2048, parameter T3_BITSROW = 11, parameter T3_PHYWDTH = 32,

parameter T2_WIDTH = 10, parameter T2_NUMVBNK = 6, parameter T2_BITVBNK = 3, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 2048, parameter T2_BITSROW = 11, parameter T2_PHYWDTH = 10)
( clk,  rst,  ready,  refr,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  t1_readA,   t1_writeA,   t1_addrA,   t1_dinA,   t1_bwA,   t1_doutA,   t1_dwsnA,
  t1_refrB,   t1_bankB,
  t2_readA,   t2_writeA,   t2_addrA,   t2_dinA,   t2_bwA,   t2_doutA,   t2_dwsnA,
  t2_refrB,   t2_bankB,
  t3_writeA,   t3_addrA,   t3_dinA,   t3_bwA,   
  t3_readB,   t3_addrB,   t3_doutB,
  t4_writeA,   t4_addrA,   t4_dinA,   t4_bwA,   
  t4_readB,   t4_addrB,   t4_doutB);
  
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

  output [NUMVBNK1*NUMVBNK2-1:0] t1_readA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_writeA;
  output [NUMVBNK1*NUMVBNK2*BITSROW2-1:0] t1_addrA;
  output [NUMVBNK1*NUMVBNK2*BITDWSN-1:0] t1_dwsnA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_bwA;
  output [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_dinA;
  input [NUMVBNK1*NUMVBNK2*PHYWDTH2-1:0] t1_doutA;
  output [NUMVBNK1*NUMVBNK2-1:0] t1_refrB;
  output [NUMVBNK1*NUMVBNK2*BITRBNK-1:0] t1_bankB;

  output [NUMVBNK1-1:0] t2_readA;
  output [NUMVBNK1-1:0] t2_writeA;
  output [NUMVBNK1*BITSROW2-1:0] t2_addrA;
  output [NUMVBNK1*BITDWSN-1:0] t2_dwsnA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_bwA;
  output [NUMVBNK1*PHYWDTH2-1:0] t2_dinA;
  input [NUMVBNK1*PHYWDTH2-1:0] t2_doutA;
  output [NUMVBNK1-1:0] t2_refrB;
  output [NUMVBNK1*BITRBNK-1:0] t2_bankB;

  parameter SHORTWR = 3;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrA;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_dinA;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_bwA;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB;
  input  [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_doutB;

  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t4_writeA;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t4_addrA;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] t4_dinA;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] t4_bwA;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t4_addrB;
  input  [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t4_doutB;
  
  wire [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_bwA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_dinA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t4_writeA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t4_addrA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] t4_bwA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] t4_dinA_tmp;
  
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB_wire;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB_wire;
  reg  [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_doutB_wire;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_readB_wire;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t4_addrB_wire;
  reg  [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t4_doutB_wire;
  
  parameter cmax = NUMCASH;
  parameter rmax = NUMRDPT+NUMRWPT+NUMWRPT;
  
  //For read
  //Port Major format.
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB_tmp;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB_tmp;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t3_doutB_tmp;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t4_readB_tmp;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t4_addrB_tmp;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t4_doutB_tmp;
  always_comb begin
    t3_readB_tmp = 0; t3_addrB_tmp = 0; t3_doutB_wire = 0;
    t4_readB_tmp = 0; t4_addrB_tmp = 0; t4_doutB_wire = 0;
    for(int rn = 0; rn < rmax; rn++) begin
      for(int cn = 0; cn < cmax; cn++) begin
        t3_readB_tmp  |=  (t3_readB_wire >> (cn*rmax+rn)*1            & {1{1'b1}})              << 1*(rn*cmax+cn); 
        t3_addrB_tmp  |=  (t3_addrB_wire >> (cn*rmax+rn)*BITVROW1     & {BITVROW1{1'b1}})       << BITVROW1*(rn*cmax+cn); 
        t4_readB_tmp  |=  (t4_readB_wire >> (cn*rmax+rn)*1            & {1{1'b1}})              << 1*(rn*cmax+cn); 
        t4_addrB_tmp  |=  (t4_addrB_wire >> (cn*rmax+rn)*BITVROW1     & {BITVROW1{1'b1}})       << BITVROW1*(rn*cmax+cn); 
        
        t3_doutB_wire  |=  (t3_doutB_tmp   >> (rn*cmax+cn)*SDOUT_WIDTH & {SDOUT_WIDTH{1'b1}})   << SDOUT_WIDTH*(cn*rmax+rn); 
        t4_doutB_wire  |=  (t4_doutB_tmp   >> (rn*cmax+cn)*WIDTH       & {WIDTH{1'b1}})         << WIDTH*(cn*rmax+rn); 
      end
    end
  end
  
  assign t3_readB = t3_readB_tmp;
  assign t4_readB = t4_readB_tmp;
  assign t3_addrB = t3_addrB_tmp;
  assign t4_addrB = t4_addrB_tmp;
  assign t3_doutB_tmp = t3_doutB;
  assign t4_doutB_tmp = t4_doutB;
  
  wire [NUMWRPT*WIDTH-1 :0]     rd_dout_nocon;
  wire [NUMWRPT-1 :0]           rd_vld_nocon;
  wire [NUMWRPT-1 :0]           rd_serr_nocon;
  wire [NUMWRPT-1 :0]           rd_derr_nocon;
  wire [NUMWRPT*BITPADR1-1 :0]  rd_padr_nocon;
  
`ifdef AMP_REF

  task Write;
  input [BITADDR-1:0] addr;
  input [WIDTH-1:0] din;
  begin
    algo_ref.bdw_flag[addr] = 1'b1;
    algo_ref.mem[addr] = din;
  end
  endtask

  task Read;
  input [BITADDR-1:0] addr;
  output [WIDTH-1:0] dout;
  begin
`ifdef SUPPORTED
    if (algo_ref.mem.exists(addr))
      dout = algo_ref.mem[addr];
    else
      dout = {WIDTH{1'bx}};
`else
    dout = algo_ref.mem[addr];
`endif
  end
  endtask

  algo_mrnrwpw_ref #(
    .WIDTH(WIDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMRDPT(2), .NUMRWPT(0), .NUMWRPT(1),
    .NUMVROW(NUMVROW1), .BITVROW(BITVROW1), .NUMVBNK(NUMVBNK1), .BITVBNK(BITVBNK1),
    .NUMSROW(T1_NUMSROW), .BITSROW(T1_BITSROW), .NUMWRDS(T1_NUMWRDS), .BITWRDS(T1_BITWRDS), .BITPADR(BITPADR1),
    .MEM_DELAY(T1_DELAY+FLOPOUT+FLOPIN+FLOPMEM)) algo_ref (
       .rd_read(read), .rd_addr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
       .rw_read(), .rw_write(), .rw_addr(), .rw_din(), .rw_vld(), .rw_dout(), .rw_serr(), .rw_derr(), .rw_padr(),
       .wr_write(write), .wr_addr(wr_adr), .wr_din(din),
       .clk(clk), .ready(ready), .rst(rst));

`else

  algo_2r1w_1rw_rl_top 
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
          .FLOPMEM(FLOPMEM), .FLOPECC(FLOPECC))
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
        .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dwsnA(t1_dwsnA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA), .t1_refrB(t1_refrB), .t1_bankB(t1_bankB),
        .t2_readA(t2_readA), .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dwsnA(t2_dwsnA), .t2_bwA(t2_bwA), .t2_dinA(t2_dinA), .t2_doutA(t2_doutA), .t2_refrB(t2_refrB), .t2_bankB(t2_bankB),
        .t3_writeA(t3_writeA_tmp), .t3_addrA(t3_addrA_tmp), .t3_bwA(t3_bwA_tmp), .t3_dinA(t3_dinA_tmp), .t3_readB(t3_readB_wire), .t3_addrB(t3_addrB_wire), .t3_doutB(t3_doutB_wire),
        .t4_writeA(t4_writeA_tmp), .t4_addrA(t4_addrA_tmp), .t4_bwA(t4_bwA_tmp), .t4_dinA(t4_dinA_tmp), .t4_readB(t4_readB_wire), .t4_addrB(t4_addrB_wire), .t4_doutB(t4_doutB_wire));

assign t3_writeA = {SHORTWR{t3_writeA_tmp}};
assign t3_addrA = {SHORTWR{t3_addrA_tmp}};
assign t3_bwA = {SHORTWR{t3_bwA_tmp}};
assign t3_dinA = {SHORTWR{t3_dinA_tmp}};
assign t4_writeA = {SHORTWR{t4_writeA_tmp}};
assign t4_addrA = {SHORTWR{t4_addrA_tmp}};
assign t4_bwA = {SHORTWR{t4_bwA_tmp}}; 
assign t4_dinA = {SHORTWR{t4_dinA_tmp}}; 

`endif

// MEMOIR_TRANSLATE_ON

endmodule    //algo_2r1w_a82_top_wrap
