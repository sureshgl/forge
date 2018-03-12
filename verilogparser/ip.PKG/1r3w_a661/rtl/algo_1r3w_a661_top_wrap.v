/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_1r3w_a661_top_wrap
#(parameter IP_WIDTH = 64, parameter IP_BITWIDTH = 6, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, parameter IP_NUMVBNK = 32, parameter IP_BITVBNK = 5,
parameter IP_SECCBITS = 5, parameter IP_SECCDWIDTH = 6, parameter IP_DECCBITS= 0, parameter IP_ENAECC=0, parameter IP_ENAPAR=0,
parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPMEM = 0, parameter FLOPCMD=0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 42, parameter IP_REFFRHF = 0, parameter IP_BITPBNK = 6, parameter IP_REFLOPW = 0,

parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 32, parameter T1_BITVBNK = 5, parameter T1_DELAY = 2, parameter T1_NUMVROW = 256, parameter T1_BITVROW = 8,
parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 256, parameter T1_BITSROW = 8, parameter T1_PHYWDTH = 64, parameter T1_BITWSPF = 0,
parameter T1_NUMRBNK = 1, parameter T1_BITRBNK = 1, parameter T1_NUMRROW = 128, parameter T1_BITRROW = 7, parameter T1_NUMPROW = 1024, parameter T1_BITPROW = 10,

parameter T3_WIDTH = 64, parameter T3_NUMVBNK = 4, parameter T3_BITVBNK = 2, parameter T3_DELAY = 1, parameter T3_NUMVROW = 256, parameter T3_BITVROW = 8,
parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 256, parameter T3_BITSROW = 8, parameter T3_PHYWDTH = 64, parameter T3_BITWSPF=0,

parameter T2_WIDTH = 17, parameter T2_NUMVBNK = 4, parameter T2_BITVBNK = 2, parameter T2_DELAY = 1, parameter T2_NUMVROW = 256, parameter T2_BITVROW = 8,
parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 256, parameter T2_BITSROW = 8, parameter T2_PHYWDTH = 17, parameter T2_BITWSPF=0)
( clk,  rst,  ready,  refr,
  write,   wr_adr,   din,
 read,   rd_adr,   rd_dout,  rd_vld,  rd_serr,  rd_derr,   rd_padr,
  t1_writeA,  t1_addrA,   t1_dinA,   t1_bwA,   
  t1_readB,   t1_addrB,   t1_doutB,
  t2_writeA,   t2_addrA,   t2_dinA,   t2_bwA,
  t2_writeB,   t2_addrB,   t2_dinB,   t2_bwB,
  t2_readC,   t2_addrC,   t2_doutC,
  t2_readD,   t2_addrD,   t2_doutD,
  t2_readE,   t2_addrE,   t2_doutE,
  t2_readF,   t2_addrF,   t2_doutF,
  t3_writeA,   t3_addrA,   t3_dinA,   t3_bwA,
  t3_readB,   t3_addrB,   t3_doutB);
  
  parameter NUMRDPT = 1;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 3;
  parameter NUMCASH = NUMRDPT+NUMRWPT+NUMWRPT-1;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter PARITY = IP_ENAPAR;
  parameter MEMWDTH = WIDTH+PARITY;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter BITPROW = T1_BITPROW;
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters 
  parameter NUMRBNK = T1_NUMRBNK;
  parameter BITRBNK = T1_BITRBNK;
  parameter REFLOPW = IP_REFLOPW;
  parameter NUMRROW = T1_NUMRROW;
  parameter BITRROW = T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;
  parameter REFFRHF = IP_REFFRHF;
  
  parameter BITDWSN = 0;        //DWSN Parameters
  parameter NUMDWS0 = 0;
  parameter NUMDWS1 = 0;
  parameter NUMDWS2 = 0;
  parameter NUMDWS3 = 0;
  parameter NUMDWS4 = 0;
  parameter NUMDWS5 = 0;
  parameter NUMDWS6 = 0;
  parameter NUMDWS7 = 0;
  parameter NUMDWS8 = 0;
  parameter NUMDWS9 = 0;
  parameter NUMDWS10 = 0;
  parameter NUMDWS11 = 0;
  parameter NUMDWS12 = 0;
  parameter NUMDWS13 = 0;
  parameter NUMDWS14 = 0;
  parameter NUMDWS15 = 0;
  
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_DELAY;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter SDOUT_WIDTH = BITVBNK+1;

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
  output [NUMRDPT* BITPADR - 1:0]     rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  output [NUMVBNK-1:0] t1_readB;
  output [NUMVBNK*BITSROW-1:0] t1_addrB;
  input  [NUMVBNK*PHYWDTH-1:0] t1_doutB;
  
  parameter SHORTWR = 2;
  parameter EXTRARD = 0;

  output [NUMCASH-1:0] t2_writeA;
  output [NUMCASH*BITVROW-1:0] t2_addrA;
  output [NUMCASH*SDOUT_WIDTH-1:0] t2_dinA;
  output [NUMCASH*SDOUT_WIDTH-1:0] t2_bwA;
  output [NUMCASH-1:0] t2_writeB;
  output [NUMCASH*BITVROW-1:0] t2_addrB;
  output [NUMCASH*SDOUT_WIDTH-1:0] t2_dinB;
  output [NUMCASH*SDOUT_WIDTH-1:0] t2_bwB;
  
  
  output [NUMCASH-1:0] t2_readC;
  output [NUMCASH*BITVROW-1:0] t2_addrC;
  input  [NUMCASH*SDOUT_WIDTH-1:0] t2_doutC;
  output [NUMCASH-1:0] t2_readD;
  output [NUMCASH*BITVROW-1:0] t2_addrD;
  input  [NUMCASH*SDOUT_WIDTH-1:0] t2_doutD;
  output [NUMCASH-1:0] t2_readE;
  output [NUMCASH*BITVROW-1:0] t2_addrE;
  input  [NUMCASH*SDOUT_WIDTH-1:0] t2_doutE;
  output [NUMCASH-1:0] t2_readF;
  output [NUMCASH*BITVROW-1:0] t2_addrF;
  input  [NUMCASH*SDOUT_WIDTH-1:0] t2_doutF;


  output [SHORTWR*NUMCASH-1:0] t3_writeA;
  output [SHORTWR*NUMCASH*BITVROW-1:0] t3_addrA;
  output [SHORTWR*NUMCASH*WIDTH-1:0] t3_dinA;
  output [SHORTWR*NUMCASH*WIDTH-1:0] t3_bwA;
  
  output [SHORTWR*NUMCASH-1:0] t3_readB;
  output [SHORTWR*NUMCASH*BITVROW-1:0] t3_addrB;
  input  [SHORTWR*NUMCASH*WIDTH-1:0] t3_doutB;
  
  
  
  assign t2_bwA = ~0; 
  assign t3_bwA = ~0;
  assign t3_bwB = ~0;
  
  //Cache major format
  wire [NUMCASH*(NUMRWPT+NUMWRPT-1)-1:0] t2_writeA_wire;
  wire [NUMCASH*(NUMRWPT+NUMWRPT-1)*BITVROW-1:0] t2_addrA_wire;
  wire [NUMCASH*(NUMRWPT+NUMWRPT-1)*SDOUT_WIDTH-1:0] t2_dinA_wire;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB_wire;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrB_wire;
  reg  [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB_wire;

  //Cache major format
  wire [NUMCASH-1:0] t3_writeA_wire;
  wire [NUMCASH*BITVROW-1:0] t3_addrA_wire;
  wire [NUMCASH*WIDTH-1:0] t3_dinA_wire;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+1)-1:0] t3_readB_wire;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+1)*BITVROW-1:0] t3_addrB_wire;
  reg  [NUMCASH*(NUMRDPT+NUMRWPT+1)*WIDTH-1:0] t3_doutB_wire;
  
  parameter cmax = NUMCASH;
  parameter wmax = NUMRWPT+NUMWRPT-1; 
  
  //For Write.
  //Port Major format.
  reg [NUMCASH*(NUMRWPT+NUMWRPT-1)-1:0] t2_writeA_short;
  reg [NUMCASH*(NUMRWPT+NUMWRPT-1)*BITVROW-1:0] t2_addrA_short;
  reg [NUMCASH*(NUMRWPT+NUMWRPT-1)*SDOUT_WIDTH-1:0] t2_dinA_short;
  always_comb begin
    t2_writeA_short = 0; t2_addrA_short = 0; t2_dinA_short = 0;
    for(int wn = 0; wn < wmax; wn++) begin
      for(int cn = 0; cn < cmax; cn++) begin
        t2_writeA_short |=  (t2_writeA_wire >> (cn*wmax+wn)*1           & {1{1'b1}})             << 1*(wn*cmax+cn); 
        t2_addrA_short  |=  (t2_addrA_wire  >> (cn*wmax+wn)*BITVROW     & {BITVROW{1'b1}})       << BITVROW*(wn*cmax+cn); 
        t2_dinA_short   |=  (t2_dinA_wire   >> (cn*wmax+wn)*SDOUT_WIDTH & {SDOUT_WIDTH{1'b1}})   << SDOUT_WIDTH*(wn*cmax+cn); 
      end
    end
  end

  assign t2_writeA = {{t2_writeA_short[cmax*1             -1 :0]}};
  assign t2_addrA  = {{t2_addrA_short [cmax*BITVROW       -1 :0]}};
  assign t2_dinA   = {{t2_dinA_short  [cmax*SDOUT_WIDTH   -1 :0]}};
  assign t2_writeB = {{t2_writeA_short[2*cmax*1           -1 :cmax*1]}}; 
  assign t2_addrB  = {{t2_addrA_short [2*cmax*BITVROW     -1 :cmax*BITVROW]}};
  assign t2_dinB   = {{t2_dinA_short  [2*cmax*SDOUT_WIDTH -1 :cmax*SDOUT_WIDTH]}};   
  
  parameter wmax2=1;
  reg [NUMCASH-1:0] t3_writeA_short;
  reg [NUMCASH*BITVROW-1:0] t3_addrA_short;
  reg [NUMCASH*WIDTH-1:0] t3_dinA_short;
  always_comb begin
    t3_writeA_short = 0; t3_addrA_short = 0; t3_dinA_short = 0;
    for(int wn = 0; wn < wmax2; wn++) begin
      for(int cn = 0; cn < cmax; cn++) begin
        t3_writeA_short |=  (t3_writeA_wire >> (cn*wmax2+wn)*1           & {1{1'b1}})             << 1*(wn*cmax+cn); 
        t3_addrA_short  |=  (t3_addrA_wire  >> (cn*wmax2+wn)*BITVROW     & {BITVROW{1'b1}})       << BITVROW*(wn*cmax+cn); 
        t3_dinA_short   |=  (t3_dinA_wire   >> (cn*wmax2+wn)*WIDTH       & {WIDTH{1'b1}})         << WIDTH*(wn*cmax+cn); 
      end
    end
  end
  assign t3_writeA = {SHORTWR{t3_writeA_short[cmax*1             -1 :0]}};
  assign t3_addrA  = {SHORTWR{t3_addrA_short [cmax*BITVROW       -1 :0]}};
  assign t3_dinA   = {SHORTWR{t3_dinA_short  [cmax*WIDTH         -1 :0]}};
  
  //For read
  parameter rmax = NUMRDPT+NUMRWPT+NUMWRPT;
  
  //Port Major format.
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB_tmp;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrB_tmp;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB_tmp;
  always_comb begin
    t2_readB_tmp = 0; t2_addrB_tmp = 0; t2_doutB_wire = 0;
    for(int rn = 0; rn < rmax; rn++) begin
      for(int cn = 0; cn < cmax; cn++) begin
        t2_readB_tmp  |=  (t2_readB_wire >> (cn*rmax+rn)*1           & {1{1'b1}})             << 1*(rn*cmax+cn); 
        t2_addrB_tmp  |=  (t2_addrB_wire >> (cn*rmax+rn)*BITVROW     & {BITVROW{1'b1}})       << BITVROW*(rn*cmax+cn); 
        t2_doutB_wire  |=  (t2_doutB_tmp   >> (rn*cmax+cn)*SDOUT_WIDTH & {SDOUT_WIDTH{1'b1}})   << SDOUT_WIDTH*(cn*rmax+rn); 
      end
    end
  end
  
  assign {t2_readF, t2_readE, t2_readD, t2_readC} = {{1*EXTRARD{1'b0}}, t2_readB_tmp};
  assign {t2_addrF, t2_addrE, t2_addrD, t2_addrC} = {{BITVROW*EXTRARD{1'b0}}, t2_addrB_tmp};
  assign {t2_doutB_tmp} = {t2_doutF, t2_doutE, t2_doutD, t2_doutC};
  
  parameter rmax2 = NUMRDPT+NUMRWPT+1;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+1)-1:0] t3_readB_tmp;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+1)*BITVROW-1:0] t3_addrB_tmp;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+1)*WIDTH-1:0] t3_doutB_tmp;
  always_comb begin
    t3_readB_tmp = 0; t3_addrB_tmp = 0; t3_doutB_wire = 0;
    for(int rn = 0; rn < rmax2; rn++) begin
      for(int cn = 0; cn < cmax; cn++) begin
	t3_readB_tmp  |=  (t3_readB_wire >> (cn*rmax2+rn)*1           & {1{1'b1}})             << 1*(rn*cmax+cn); 
        t3_addrB_tmp  |=  (t3_addrB_wire >> (cn*rmax2+rn)*BITVROW     & {BITVROW{1'b1}})       << BITVROW*(rn*cmax+cn); 		
        t3_doutB_wire  |=  (t3_doutB_tmp   >> (rn*cmax+cn)*WIDTH       & {WIDTH{1'b1}})         << WIDTH*(cn*rmax2+rn); 
      end
    end
  end
  
  assign {t3_readB} = {{1*EXTRARD{1'b0}}, t3_readB_tmp};
  assign {t3_addrB} = {{BITVROW*EXTRARD{1'b0}}, t3_addrB_tmp};
  assign {t3_doutB_tmp} = {t3_doutB};


  wire [NUMWRPT*WIDTH-1 :0]     rd_dout_nocon;
  wire [NUMWRPT-1 :0]             rd_vld_nocon;
  wire [NUMWRPT-1 :0]             rd_serr_nocon;
  wire [NUMWRPT-1 :0]             rd_derr_nocon;
  wire [NUMWRPT*BITPADR-1 :0]     rd_padr_nocon;
    
  algo_1r3w_1r1w_tl_top 
          #(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .PARITY(PARITY),   .NUMADDR(NUMADDR),   .BITADDR(BITADDR),   .NUMVROW(NUMVROW),   .BITVROW(BITVROW),
        .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),   .BITPBNK(BITPBNK),   .FLOPIN(FLOPIN),   .FLOPOUT(FLOPOUT),
        .NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW),   .REFRESH(REFRESH),
        .NUMRBNK(NUMRBNK),   .BITRBNK(BITRBNK),   .REFLOPW(REFLOPW),   .NUMRROW(NUMRROW),   .BITRROW(BITRROW),   .REFFREQ(REFFREQ),   .REFFRHF(REFFRHF),
        .NUMDWS0(NUMDWS0),   .NUMDWS1(NUMDWS1),   .NUMDWS2(NUMDWS2),   .NUMDWS3(NUMDWS3),
        .NUMDWS4(NUMDWS4),   .NUMDWS5(NUMDWS5),   .NUMDWS6(NUMDWS6),   .NUMDWS7(NUMDWS7),
        .NUMDWS8(NUMDWS8),   .NUMDWS9(NUMDWS9),   .NUMDWS10(NUMDWS10),   .NUMDWS11(NUMDWS11),
        .NUMDWS12(NUMDWS12),   .NUMDWS13(NUMDWS13),   .NUMDWS14(NUMDWS14),   .NUMDWS15(NUMDWS15),
        .BITDWSN(BITDWSN),   .ECCBITS(ECCBITS),   .SRAM_DELAY(SRAM_DELAY),   .DRAM_DELAY(DRAM_DELAY),   .FLOPMEM(FLOPMEM))
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
        .t2_writeA(t2_writeA_wire), .t2_addrA(t2_addrA_wire), .t2_dinA(t2_dinA_wire), .t2_readB(t2_readB_wire), .t2_addrB(t2_addrB_wire), .t2_doutB(t2_doutB_wire),
        .t3_writeA(t3_writeA_wire), .t3_addrA(t3_addrA_wire), .t3_dinA(t3_dinA_wire), .t3_readB(t3_readB_wire), .t3_addrB(t3_addrB_wire), .t3_doutB(t3_doutB_wire));
        
 
        
  
endmodule    //algo_1r3w_a661_top_wrap

