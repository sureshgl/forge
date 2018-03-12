/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_2r1w_a682_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAEXT = 0, parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 2, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 32,

parameter T2_WIDTH = 10, parameter T2_NUMVBNK = 6, parameter T2_BITVBNK = 3, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 2048, parameter T2_BITSROW = 11, parameter T2_PHYWDTH = 10,

parameter T3_WIDTH = 71, parameter T3_NUMVBNK = 6, parameter T3_BITVBNK = 3, parameter T3_DELAY = 1, parameter T3_NUMVROW = 2048, parameter T3_BITVROW = 11,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 2048, parameter T3_BITSROW = 11, parameter T3_PHYWDTH = 71)
( clk,  rst,  ready,
  write,   wr_adr,   din,
  read,   rd_adr,   rd_dout,   rd_vld,   rd_serr,   rd_derr,   rd_padr,
  t1_readA,   t1_writeA,   t1_addrA,   t1_dinA,   t1_bwA,   t1_doutA,
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
  parameter NUMWRDS1 = T1_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS1 = T1_BITWRDS;
  parameter NUMSROW1 = T1_NUMSROW;
  parameter BITSROW1 = T1_BITSROW;
  parameter PHYWDTH1 = T1_PHYWDTH;
  
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_DELAY;

  parameter MEMWDTH = ENAEXT ? WIDTH : ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter BITPADR = BITPBNK1+BITSROW1+BITWRDS1+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK1+1)+ECCBITS;
  parameter CDOUT_WIDTH = 2*WIDTH+ECCWDTH;
  parameter NUMCASH = NUMRDPT+NUMRWPT+NUMWRPT-1;

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

  output [NUMVBNK1*NUMRDPT-1:0] t1_readA;
  output [NUMVBNK1*NUMRDPT-1:0] t1_writeA;
  output [NUMVBNK1*NUMRDPT*BITSROW1-1:0] t1_addrA;
  output [NUMVBNK1*NUMRDPT*PHYWDTH1-1:0] t1_bwA;
  output [NUMVBNK1*NUMRDPT*PHYWDTH1-1:0] t1_dinA;
  input [NUMVBNK1*NUMRDPT*PHYWDTH1-1:0] t1_doutA;

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
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*CDOUT_WIDTH-1:0] t3_dinA;
  output [SHORTWR*NUMCASH*(NUMRWPT+NUMWRPT)*CDOUT_WIDTH-1:0] t3_bwA;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB;
  input  [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*CDOUT_WIDTH-1:0] t3_doutB;
  
  wire [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t2_writeA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_bwA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_dinA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*CDOUT_WIDTH-1:0] t3_bwA_tmp;
  wire [NUMCASH*(NUMRWPT+NUMWRPT)*CDOUT_WIDTH-1:0] t3_dinA_tmp;
  
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB_wire;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrB_wire;
  reg  [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB_wire;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB_wire;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB_wire;
  reg  [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*CDOUT_WIDTH-1:0] t3_doutB_wire;
  
  parameter cmax = NUMCASH;
  parameter rmax = NUMRDPT+NUMRWPT+NUMWRPT;
  
  //For read
  //Port Major format.
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB_tmp;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrB_tmp;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB_tmp;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB_tmp;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB_tmp;
  wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*CDOUT_WIDTH-1:0] t3_doutB_tmp;
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
        t3_doutB_wire  |=  (t3_doutB_tmp   >> (rn*cmax+cn)*CDOUT_WIDTH & {CDOUT_WIDTH{1'b1}})   << CDOUT_WIDTH*(cn*rmax+rn); 
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
  wire [NUMWRPT*BITPADR-1 :0]  rd_padr_nocon;
  
/*
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
    .NUMSROW(T1_NUMSROW), .BITSROW(T1_BITSROW), .NUMWRDS(T1_NUMWRDS), .BITWRDS(T1_BITWRDS), .BITPADR(BITPADR),
    .MEM_DELAY(T1_DELAY+FLOPOUT+FLOPIN+FLOPCMD+FLOPMEM)) algo_ref (
       .rd_read(read), .rd_addr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
       .rw_read(), .rw_write(), .rw_addr(), .rw_din(), .rw_vld(), .rw_dout(), .rw_serr(), .rw_derr(), .rw_padr(),
       .wr_write(write), .wr_addr(wr_adr), .wr_din(din),
       .clk(clk), .ready(ready), .rst(rst));

`else
*/

  algo_nr1w_1rw_rl_a682_top 
           #(.WIDTH(WIDTH),   .BITWDTH(BITWDTH), .ENAEXT(ENAEXT), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH), .NUMRDPT(NUMRDPT),
             .NUMADDR(NUMADDR),   .BITADDR(BITADDR),
             .NUMVROW1(NUMVROW1),   .BITVROW1(BITVROW1),   .NUMVBNK1(NUMVBNK1),   .BITVBNK1(BITVBNK1),   .BITPBNK1(BITPBNK1),
             .FLOPIN1(FLOPIN1),   .FLOPOUT1(FLOPOUT1),
             .NUMWRDS1(NUMWRDS1),   .BITWRDS1(BITWRDS1),   .NUMSROW1(NUMSROW1),   .BITSROW1(BITSROW1),
             .ECCBITS(ECCBITS),   .SRAM_DELAY(SRAM_DELAY),   .DRAM_DELAY(DRAM_DELAY), .FLOPCMD(FLOPCMD),   .FLOPMEM(FLOPMEM), .FLOPECC(FLOPECC))
  algo_top
        (.clk(clk), .rst(rst), .ready(ready),
        .read({{NUMWRPT{1'b0}}, read}),
        .write({write, {NUMRDPT{1'b0}}}),
        .addr({wr_adr, rd_adr}),
        .din({din, {(NUMRDPT*WIDTH){1'b0}}}),        
        .rd_dout({rd_dout_nocon, rd_dout}),
        .rd_vld ({rd_vld_nocon,  rd_vld}),
        .rd_serr({rd_serr_nocon,  rd_serr}),
        .rd_derr({rd_derr_nocon, rd_derr}),
        .rd_padr({rd_padr_nocon, rd_padr}),
        .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
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

/*
`endif
*/

// MEMOIR_TRANSLATE_ON

endmodule    //algo_2r1w_a682_top_wrap
