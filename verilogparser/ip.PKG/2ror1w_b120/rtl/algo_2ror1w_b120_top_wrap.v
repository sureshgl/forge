/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

module algo_2ror1w_b120_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 16, parameter T1_NUMVBNK = 8, parameter T1_BITVBNK = 3, parameter T1_DELAY = 2, parameter T1_NUMVROW = 16384, parameter T1_BITVROW = 14,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 4, parameter T1_BITWRDS = 2, parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 64, 
parameter T1_NUMRBNK = 2, parameter T1_BITRBNK = 1, parameter T1_NUMRROW = 256, parameter T1_BITRROW = 8, parameter T1_NUMPROW = 4096, parameter T1_BITPROW = 12,
parameter T1_BITDWSN = 8, 
parameter T1_NUMDWS0 = 0, parameter T1_NUMDWS1 = 0, parameter T1_NUMDWS2 = 0, parameter T1_NUMDWS3 = 0,
parameter T1_NUMDWS4 = 0, parameter T1_NUMDWS5 = 0, parameter T1_NUMDWS6 = 0, parameter T1_NUMDWS7 = 0,
parameter T1_NUMDWS8 = 0, parameter T1_NUMDWS9 = 0, parameter T1_NUMDWS10 = 0, parameter T1_NUMDWS11 = 0,
parameter T1_NUMDWS12 = 0, parameter T1_NUMDWS13 = 0, parameter T1_NUMDWS14 = 0, parameter T1_NUMDWS15 = 0
)
( clk,  rst,  ready,  refr,
 write, wr_adr, din, 
 read, rd_adr, rd_dout, rd_vld, rd_serr, rd_derr, rd_padr,
 t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_doutA, t1_dwsnA, t1_refrB, t1_bankB);

// MEMOIR_TRANSLATE_OFF
 
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ECCWDTH = IP_DECCBITS;
  parameter ENAPAR = 0;
  parameter ENAECC = 1;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;   // ALGO Parameters
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters 
  parameter NUMRBNK = T1_NUMRBNK;
  parameter BITWSPF = T1_BITWSPF;
  parameter BITRBNK = T1_BITRBNK;
  parameter NUMRROW = T1_NUMRROW;
  parameter BITRROW = T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;
  parameter REFFRHF = IP_REFFRHF;

  parameter SRAM_DELAY = T1_DELAY;
  parameter PHYWDTH = T1_PHYWDTH;
  
  parameter BITDWSN = T1_BITDWSN;		//DWSN Parameters
  parameter NUMDWS0 = T1_NUMDWS0;
  parameter NUMDWS1 = T1_NUMDWS1;
  parameter NUMDWS2 = T1_NUMDWS2;
  parameter NUMDWS3 = T1_NUMDWS3;
  parameter NUMDWS4 = T1_NUMDWS4;
  parameter NUMDWS5 = T1_NUMDWS5;
  parameter NUMDWS6 = T1_NUMDWS6;
  parameter NUMDWS7 = T1_NUMDWS7;
  parameter NUMDWS8 = T1_NUMDWS8;
  parameter NUMDWS9 = T1_NUMDWS9;
  parameter NUMDWS10 = T1_NUMDWS10;
  parameter NUMDWS11 = T1_NUMDWS11;
  parameter NUMDWS12 = T1_NUMDWS12;
  parameter NUMDWS13 = T1_NUMDWS13;
  parameter NUMDWS14 = T1_NUMDWS14;
  parameter NUMDWS15 = T1_NUMDWS15;

  parameter NUMRDPT = 2;
  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;

  input                          refr;

  input                          write;
  input [BITADDR-1:0]            wr_adr;
  input [WIDTH-1:0]              din;

  input [NUMRDPT-1:0]            read;
  input [NUMRDPT*BITADDR-1:0]    rd_adr;
  output [NUMRDPT-1:0]           rd_vld;
  output [NUMRDPT*WIDTH-1:0]     rd_dout;
  output [NUMRDPT-1:0]           rd_serr;
  output [NUMRDPT-1:0]           rd_derr;
  output [NUMRDPT*BITPADR-1:0]   rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMRDPT*NUMVBNK-1:0] t1_readA;
  output [NUMRDPT*NUMVBNK-1:0] t1_writeA;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input  [NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_doutA;
  output [NUMRDPT*NUMVBNK*BITDWSN-1:0] t1_dwsnA;

  output [NUMRDPT*NUMVBNK-1:0] t1_refrB;
  output [NUMRDPT*NUMVBNK*BITRBNK-1:0] t1_bankB;
/*
`ifdef AMP_REF
  wire [2-1:0]         rd_vld_rtl;
  wire [2*WIDTH-1:0]   rd_dout_rtl;
  wire [2-1:0]         rd_serr_rtl;
  wire [2-1:0]         rd_derr_rtl;
  wire [2*BITPADR-1:0] rd_padr_rtl;

  reg stop_sim = 0;
  reg ref_match_en = 0;
  initial if ($test$plusargs ("fhiqwelfhb3ior")) begin
    ref_match_en = 1;
    $display ("Reference model matching ENABLED");
  end

  always @(posedge clk) begin
    if (ref_match_en) begin
      if (rd_vld != rd_vld_rtl) begin
        $display ("ERROR: At %0t, read_vld mismatches [ref: %0d, rtl: %0d]", $time, rd_vld, rd_vld_rtl);
        stop_sim <= 1'b1;
      end

      if (rd_vld[0] && (rd_dout[WIDTH-1:0] != rd_dout_rtl[WIDTH-1:0])) begin
        $display ("ERROR: At %0t, dout_0 mismatches [ref: 0x%x, rtl: 0x%x]", $time, rd_dout[WIDTH-1:0], rd_dout_rtl[WIDTH-1:0]);
        stop_sim <= 1'b1;
      end

      if (rd_vld[1] && (rd_dout[2*WIDTH-1:WIDTH] != rd_dout_rtl[2*WIDTH-1:WIDTH])) begin
        $display ("ERROR: At %0t, dout_1 mismatches [ref: 0x%x, rtl: 0x%x]", $time, rd_dout[2*WIDTH-1:WIDTH], rd_dout_rtl[2*WIDTH-1:WIDTH]);
        stop_sim <= 1'b1;
      end

      if (rd_vld[0] && (rd_padr_rtl[BITPADR-2:BITPADR-BITPBNK-1] != {BITPBNK{1'b1}})
                    && (rd_padr[BITPADR-1:0] != rd_padr_rtl[BITPADR-1:0])) begin
        $display ("ERROR: At %0t, padr_0 mismatches [ref: 0x%x, rtl: 0x%x]", $time, rd_padr[BITPADR-1:0], rd_padr_rtl[BITPADR-1:0]);
        stop_sim <= 1'b1;
      end

      if (rd_vld[1] && (rd_padr_rtl[2*BITPADR-2:2*BITPADR-BITPBNK-1] != {BITPBNK{1'b1}})
                    && (rd_padr[2*BITPADR-1:BITPADR] != rd_padr_rtl[2*BITPADR-1:BITPADR])) begin
        $display ("ERROR: At %0t, padr_1 mismatches [ref: 0x%x, rtl: 0x%x]", $time, rd_padr[2*BITPADR-1:BITPADR], rd_padr_rtl[2*BITPADR-1:BITPADR]);
        stop_sim <= 1'b1;
      end

    end

    if (stop_sim) $finish;
  end
  
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

  algo_2ror1w_ref #(
    .WIDTH(WIDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .MEM_DELAY(T1_DELAY+FLOPIN+FLOPMEM+FLOPOUT),
    .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
    .NUMSROW(NUMSROW), .BITSROW(BITSROW), .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS),
    .BITPADR(BITPADR)) algo_ref (
    .read_0(read[0]), .addr_0(rd_adr[BITADDR-1:0]), .read_vld_0(rd_vld[0]), .dout_0(rd_dout[WIDTH-1:0]),
    .read_serr_0(rd_serr[0]), .read_derr_0(rd_derr[0]), .read_padr_0(rd_padr[BITPADR-1:0]),
    .read_1(read[1]), .addr_1(rd_adr[2*BITADDR-1:BITADDR]), .read_vld_1(rd_vld[1]), .dout_1(rd_dout[2*WIDTH-1:WIDTH]),
    .read_serr_1(rd_serr[1]), .read_derr_1(rd_derr[1]), .read_padr_1(rd_padr[2*BITPADR-1:BITPADR]),
    .write_2(write), .addr_2(wr_adr), .din_2(din), .clk(clk), .rst(rst));
`endif
*/ 

reg H2O_AMC2ROR1WB20_001_00;
always @(posedge clk)
  H2O_AMC2ROR1WB20_001_00 <= rst;
wire rst_int = H2O_AMC2ROR1WB20_001_00 && rst;


  algo_nror1w_dup_top
			#(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH), .NUMADDR(NUMADDR),   .BITADDR(BITADDR),   .NUMRDPT(NUMRDPT),   .NUMVROW(NUMVROW),    .BITVROW(BITVROW),
			.NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),   .NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),    .BITSROW(BITSROW),
			.REFRESH(REFRESH), .NUMRBNK(NUMRBNK),   .BITWSPF(BITWSPF),  .BITRBNK(BITRBNK),   .NUMRROW(NUMRROW),   .BITRROW(BITRROW),    .REFFREQ(REFFREQ),	 .REFFRHF(REFFRHF),
			.SRAM_DELAY(SRAM_DELAY),   .FLOPECC(FLOPECC),   .FLOPIN(FLOPIN),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT),   .PHYWDTH(PHYWDTH),
			.NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
			.NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
			.NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
			.NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15),
			.BITDWSN (BITDWSN))

  algo_top
		  (.clk(clk), .rst(rst_int), .ready(ready), .refr(refr),
		.write(write), .wr_adr(wr_adr), .din(din),
`ifdef AMP_REF
		.read(read), .rd_adr(rd_adr), .rd_vld(rd_vld_rtl), .rd_dout(rd_dout_rtl), .rd_serr(rd_serr_rtl), .rd_derr(rd_derr_rtl), .rd_padr(rd_padr_rtl),
`else
		.read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
`endif
		.t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA), .t1_dwsnA(t1_dwsnA),
		.t1_refrB(t1_refrB), .t1_bankB(t1_bankB));

// MEMOIR_TRANSLATE_ON

endmodule    //algo_2ror1w_b120_top_wrap
