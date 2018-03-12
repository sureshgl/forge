/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.1.UNKNOWN Date: Wed 2012.03.07 at 08:01:10 PM IST
 * */

module algo_1rw_a26_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3, parameter IP_NUMVROW = 32, parameter IP_BITVROW = 5,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 3, parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 32,
parameter T1_NUMRBNK = 4, parameter T1_BITRBNK = 2, parameter T1_NUMRROW = 256, parameter T1_BITRROW = 8, parameter T1_NUMPROW = 8192, parameter T1_BITPROW = 13,
parameter T1_M_NUMVBNK = 4, parameter T1_M_BITVBNK = 2, parameter T1_ISDCR = 0,
parameter T1_BITDWSN = 8, 
parameter T1_NUMDWS0 = 0, parameter T1_NUMDWS1 = 0, parameter T1_NUMDWS2 = 0, parameter T1_NUMDWS3 = 0,
parameter T1_NUMDWS4 = 0, parameter T1_NUMDWS5 = 0, parameter T1_NUMDWS6 = 0, parameter T1_NUMDWS7 = 0,
parameter T1_NUMDWS8 = 0, parameter T1_NUMDWS9 = 0, parameter T1_NUMDWS10 = 0, parameter T1_NUMDWS11 = 0,
parameter T1_NUMDWS12 = 0, parameter T1_NUMDWS13 = 0, parameter T1_NUMDWS14 = 0, parameter T1_NUMDWS15 = 0,
parameter T2_WIDTH = 32, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 8192, parameter T2_BITVROW = 13,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 8192, parameter T2_BITSROW = 13, parameter T2_PHYWDTH = 32,
parameter T2_NUMRBNK = 4, parameter T2_BITRBNK = 2, parameter T2_NUMRROW = 256, parameter T2_BITRROW = 8, parameter T2_NUMPROW = 8192, parameter T2_BITPROW = 13,
parameter T2_M_NUMVBNK = 4, parameter T2_M_BITVBNK = 2, parameter T2_ISDCR = 0,
parameter T2_BITDWSN = 8, 
parameter T2_NUMDWS0 = 0, parameter T2_NUMDWS1 = 0, parameter T2_NUMDWS2 = 0, parameter T2_NUMDWS3 = 0,
parameter T2_NUMDWS4 = 0, parameter T2_NUMDWS5 = 0, parameter T2_NUMDWS6 = 0, parameter T2_NUMDWS7 = 0,
parameter T2_NUMDWS8 = 0, parameter T2_NUMDWS9 = 0, parameter T2_NUMDWS10 = 0, parameter T2_NUMDWS11 = 0,
parameter T2_NUMDWS12 = 0, parameter T2_NUMDWS13 = 0, parameter T2_NUMDWS14 = 0, parameter T2_NUMDWS15 = 0,
parameter T3_WIDTH = 10, parameter T3_NUMVBNK = 1, parameter T3_BITVBNK = 1, parameter T3_DELAY = 2, parameter T3_NUMVROW = 2048, parameter T3_BITVROW = 11,
parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 1, parameter T3_NUMSROW = 2048, parameter T3_BITSROW = 11, parameter T3_PHYWDTH = 10, 
parameter T4_WIDTH = 32, parameter T4_NUMVBNK = 1, parameter T4_BITVBNK = 1, parameter T4_DELAY = 2, parameter T4_NUMVROW = 2048, parameter T4_BITVROW = 11,
parameter T4_BITWSPF = 0, parameter T4_NUMWRDS = 1, parameter T4_BITWRDS = 1, parameter T4_NUMSROW = 2048, parameter T4_BITSROW = 11, parameter T4_PHYWDTH = 32
)
						(refr, rw_read, rw_write, rw_addr, rw_din, rw_vld, rw_dout, rw_serr, rw_derr, rw_padr,
                              ready, clk, rst,
                              t1_readA, t1_writeA, t1_addrA, t1_bankA, t1_bwA, t1_dinA, t1_doutA, t1_dwsnA, t1_refrB, t1_bankB,
                              t2_readA, t2_writeA, t2_addrA, t2_bankA, t2_bwA, t2_dinA, t2_doutA, t2_dwsnA, t2_refrB, t2_bankB,
                              t3_writeA, t3_addrA, t3_dinA, t3_bwA, t3_readB, t3_addrB, t3_doutB,
                              t4_writeA, t4_addrA, t4_dinA, t4_bwA, t4_readB, t4_addrB, t4_doutB);
							  
// MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;			
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;

  parameter NUMVBNK = T1_M_NUMVBNK;
  parameter BITVBNK = T1_M_BITVBNK;
  parameter NUMVROW = IP_NUMVROW;
  parameter BITVROW = IP_BITVROW;

  parameter NUMMBNK = T1_NUMVBNK;
  parameter BITMBNK = T1_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMMROW = T1_NUMVROW;
  parameter BITMROW = T1_BITVROW;

  parameter NUMWRDS = T1_NUMWRDS;
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;

  parameter REFRESH = IP_REFRESH;
  parameter NUMRBNK = T1_NUMRBNK;
  parameter BITWSPF = T1_BITWSPF;
  parameter BITRBNK = T1_BITRBNK;
  parameter NUMRROW = T1_NUMRROW;
  parameter BITRROW = T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;

  parameter ECCBITS = IP_SECCBITS;
  parameter PARITY = 1;
  parameter PHYWDTH = T1_PHYWDTH;

  parameter SRAM_DELAY = T3_DELAY;
  parameter DRAM_DELAY = T1_DELAY;
  
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
                                   
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  parameter MEMWDTH = WIDTH+PARITY;
  parameter BITPADR = BITPBNK+BITVBNK+BITWRDS+BITSROW+2;

  input                        refr;

  input                        rw_read;
  input                        rw_write;
  input [BITADDR-1:0]          rw_addr;
  input [WIDTH-1:0]            rw_din;
  output                       rw_vld;
  output [WIDTH-1:0]           rw_dout;
  output                       rw_serr;
  output                       rw_derr;
  output [BITPADR-1:0]         rw_padr;

  output                       ready;
  input                        clk;
  input                        rst;

  output [NUMMBNK-1:0] t1_readA;
  output [NUMMBNK-1:0] t1_writeA;
  output [NUMMBNK*BITSROW-1:0] t1_addrA;
  output [NUMMBNK*BITVBNK-1:0] t1_bankA;
  output [NUMMBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMMBNK*PHYWDTH-1:0] t1_dinA;
  input  [NUMMBNK*PHYWDTH-1:0] t1_doutA;
  output [NUMMBNK*BITDWSN-1:0] t1_dwsnA;

  output [NUMMBNK-1:0] t1_refrB;
  output [NUMMBNK*BITRBNK-1:0] t1_bankB;

  output [1-1:0] t2_readA;
  output [1-1:0] t2_writeA;
  output [1*BITVBNK-1:0] t2_bankA;
  output [1*BITSROW-1:0] t2_addrA;
  output [1*PHYWDTH-1:0] t2_bwA;
  output [1*PHYWDTH-1:0] t2_dinA;
  input  [1*PHYWDTH-1:0] t2_doutA;
  output [1*BITDWSN-1:0] t2_dwsnA;

  output [1-1:0] t2_refrB;
  output [1*BITRBNK-1:0] t2_bankB;

  output [1-1:0] t3_writeA;
  output [1*BITVROW-1:0] t3_addrA;
  output [1*SDOUT_WIDTH-1:0] t3_dinA;
  output [1*SDOUT_WIDTH-1:0] t3_bwA;

  output [1-1:0] t3_readB;
  output [1*BITVROW-1:0] t3_addrB;
  input [1*SDOUT_WIDTH-1:0] t3_doutB;

  output [1-1:0] t4_writeA;
  output [1*BITVROW-1:0] t4_addrA;
  output [1*WIDTH-1:0] t4_dinA;
  output [1*WIDTH-1:0] t4_bwA;

  output [1-1:0] t4_readB;
  output [1*BITVROW-1:0] t4_addrB;
  input [1*WIDTH-1:0] t4_doutB;
  
`ifdef AMP_REF
  wire                       rw_vld_rtl;
  wire [WIDTH-1:0]           rw_dout_rtl;
  wire                       rw_serr_rtl;
  wire                       rw_derr_rtl;
  wire [BITPADR-1:0]         rw_padr_rtl;

  reg stop_sim = 0;
  reg ref_match_en = 0;
  initial if ($test$plusargs ("fhiqwelfhb3ior")) begin
    ref_match_en = 1;
    $display ("Reference model matching ENABLED");
  end

  always @(posedge clk) begin
    if (ref_match_en) begin
      if (rw_vld != rw_vld_rtl) begin
        $display ("ERROR: At %0t, read_vld mismatches [ref: %0d, rtl: %0d]", $time, rw_vld, rw_vld_rtl);
        stop_sim <= 1'b1;
      end

      if (rw_vld && (rw_dout != rw_dout_rtl)) begin
        $display ("ERROR: At %0t, dout_0 mismatches [ref: 0x%x, rtl: 0x%x]", $time, rw_dout, rw_dout_rtl);
        stop_sim <= 1'b1;
      end

      if (rw_vld && (rw_padr_rtl != {BITPADR{1'b1}}) && (rw_padr != rw_padr_rtl)) begin
        $display ("ERROR: At %0t, padr_0 mismatches [ref: 0x%x, rtl: 0x%x]", $time, rw_padr[BITPADR-1:0], rw_padr_rtl[BITPADR-1:0]);
        stop_sim <= 1'b1;
      end

    end

    if (stop_sim) $finish;
  end

  task put_err;
  input [BITADDR-1:0] vaddr;
  input err_on_spare;
  reg [BITVBNK-1:0] vbadr;
  reg [BITVROW-1:0] vradr;
  integer v_int;
  integer v1_int, v2_int;
  begin
    if (NUMVROW == (1'b1 << BITVROW)) begin
      vbadr = vaddr >> BITVROW;
      vradr = vaddr & {BITVROW{1'b1}};
    end else if (NUMVBNK == (1'b1 << BITVBNK)) begin
      vbadr = vaddr & {BITVBNK{1'b1}};
      vradr = vaddr >> BITVBNK;
    end else begin
      vbadr = ~0;
      vradr = ~0;
      for (v_int=0; v_int<=BITVROW-1; v_int=v_int+1)
        if (NUMVROW & (1'b1 << v_int)) begin
          v1_int = ((~0) << v_int) & NUMVROW;
          v2_int = ((~0) << (v_int+1)) & NUMVROW;
          if (vaddr < NUMVBNK*v1_int) begin
            vbadr = (vaddr - NUMVBNK*v2_int) >> v_int;
            vradr = (~((~0) << v_int) & vaddr[BITVROW-1:0]) | v2_int;
          end
        end
    end
  
    if (err_on_spare)
      algo_ref.err[NUMVBNK][vradr] = 1'b1;
    else
      algo_ref.err[vbadr][vradr] = 1'b1;
  
  end
  endtask
  
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

  algo_1rw_ref #(
    .WIDTH(WIDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .MEM_DELAY(T1_DELAY+FLOPIN+FLOPMEM+FLOPOUT+4),
    .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
    .NUMSROW(NUMSROW), .BITSROW(BITSROW), .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS),
    .BITPADR(BITPADR)) algo_ref (
    .read_0(rw_read), .addr_0(rw_addr), .read_vld_0(rw_vld), .dout_0(rw_dout),
    .read_serr_0(rw_serr), .read_derr_0(rw_derr), .read_padr_0(rw_padr),
    .write_0(rw_write), .din_0(rw_din), .clk(clk), .rst(rst));
`endif

reg H2O_AMP1RWA26_001_00;
always @(posedge clk)
  H2O_AMP1RWA26_001_00 <= rst;
wire rst_int = H2O_AMP1RWA26_001_00 && rst;


  assign t3_bwA = ~0;
  assign t4_bwA = ~0;

  algo_2rw_rl_edram_del_top 
 #(.WIDTH(WIDTH),   .BITWDTH(BITWDTH),   .NUMADDR(NUMADDR),   .BITADDR(BITADDR), 
	.NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),   .NUMVROW(NUMVROW),   .BITVROW(BITVROW),
	.NUMMBNK(NUMMBNK),   .BITMBNK(BITMBNK),   .BITPBNK(BITPBNK),   .NUMMROW(NUMMROW),   .BITMROW(BITMROW),
	.NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW),
	.REFRESH(REFRESH),   .NUMRROW(NUMRROW),   .BITRROW(BITRROW),   .REFFREQ(REFFREQ),   .NUMRBNK(NUMRBNK),    .BITWSPF(BITWSPF),  .BITRBNK(BITRBNK),
	.ECCBITS(ECCBITS),   .PARITY(PARITY),    .PHYWDTH(PHYWDTH),
	.SRAM_DELAY(SRAM_DELAY),   .DRAM_DELAY(DRAM_DELAY),   .FLOPIN(FLOPIN),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT),
	.NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
	.NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
	.NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
	.NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15),
	.BITDWSN (BITDWSN))
  
  algo_top
`ifdef AMP_REF
		(.refr(refr), .read(rw_read), .write(rw_write), .addr(rw_addr), .din(rw_din), .rd_vld(rw_vld_rtl), .rd_dout(rw_dout_rtl), .rd_serr(rw_serr_rtl), .rd_derr(rw_derr_rtl), .rd_padr(rw_padr_rtl),
`else
		(.refr(refr), .read(rw_read), .write(rw_write), .addr(rw_addr), .din(rw_din), .rd_vld(rw_vld), .rd_dout(rw_dout), .rd_serr(rw_serr), .rd_derr(rw_derr), .rd_padr(rw_padr),
`endif
		  .ready(ready), .clk(clk), .rst(rst_int),
		  .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_bankA(t1_bankA), .t1_bwA(t1_bwA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA), .t1_dwsnA(t1_dwsnA),
		  .t1_refrB(t1_refrB), .t1_bankB(t1_bankB),
		  .t2_readA(t2_readA), .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_bankA(t2_bankA), .t2_bwA(t2_bwA), .t2_dinA(t2_dinA), .t2_doutA(t2_doutA), .t2_dwsnA(t2_dwsnA),
		  .t2_refrB(t2_refrB), .t2_bankB(t2_bankB),
		  .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB),
		  .t4_writeA(t4_writeA), .t4_addrA(t4_addrA), .t4_dinA(t4_dinA), .t4_readB(t4_readB), .t4_addrB(t4_addrB), .t4_doutB(t4_doutB));

// MEMOIR_TRANSLATE_ON
endmodule    //algo_1rw_a26_top_wrap
