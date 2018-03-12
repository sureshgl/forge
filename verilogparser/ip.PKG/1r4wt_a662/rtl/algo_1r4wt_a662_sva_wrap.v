/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_1r4wt_a662_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter BITFIFO = 6,

parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 11, parameter T1_BITVBNK = 4, parameter T1_DELAY = 1, parameter T1_NUMVROW = 745, parameter T1_BITVROW = 10,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 745, parameter T1_BITSROW = 10, parameter T1_PHYWDTH = 32)

		(clk, rst, ready,
		 write, wr_adr, din, wr_bp, bp_thr,
		 read, rd_adr, rd_vld, rd_serr, rd_derr, rd_dout, rd_padr,
		 t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB);

 
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMRDPT = 1;
  parameter NUMWRPT = 4;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T1_DELAY;
  
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;


  parameter NUMWTPT = 2;

  localparam FCNTDEL = (SRAM_DELAY+FLOPIN-1 > 0) ? SRAM_DELAY+FLOPIN-1 : 1;
  localparam FNUMWRDS = 2**BITFIFO;

  input [NUMWRPT-1:0]                  write;
  input [NUMWRPT*BITADDR-1:0]          wr_adr;
  input [NUMWRPT*WIDTH-1:0]            din;
  input [3:0]                           wr_bp;

  input [NUMRDPT-1:0]                  read;
  input [NUMRDPT*BITADDR-1:0]          rd_adr;
  input [NUMRDPT-1:0]                  rd_vld;
  input [NUMRDPT*WIDTH-1:0]            rd_dout;
  input [NUMRDPT-1:0]                  rd_serr;
  input [NUMRDPT-1:0]                  rd_derr;
  input [NUMRDPT*BITPADR-1:0]          rd_padr;
  
  input [BITFIFO:0]                    bp_thr;

  input                                ready;
  input                                clk, rst;

  input [NUMRDPT*NUMVBNK-1:0]          t1_writeA;
  input [NUMRDPT*NUMVBNK*BITSROW-1:0]  t1_addrA;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0]  t1_bwA;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0]  t1_dinA;

  input [NUMRDPT*NUMVBNK-1:0]          t1_readB;
  input [NUMRDPT*NUMVBNK*BITSROW-1:0]  t1_addrB;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0]  t1_doutB;


  reg [BITFIFO-1:0]                    wrfifo_cnt;
  reg [NUMWRPT-1:0]                    wrfifo_dcnt;
  reg [NUMWRPT-1:0]                    wrfifo_ecnt;
  integer                              wffc_int;
  always_comb begin
    wrfifo_dcnt = NUMWTPT;
    wrfifo_dcnt = (wrfifo_cnt > wrfifo_dcnt) ? wrfifo_dcnt : wrfifo_cnt;
    wrfifo_ecnt = 0;
    for (wffc_int=0; wffc_int<NUMWRPT; wffc_int=wffc_int+1)
      wrfifo_ecnt = wrfifo_ecnt + write[wffc_int];
  end
  
  wire [BITFIFO:0] wrfifo_cnt_nxt = wrfifo_cnt + wrfifo_ecnt - wrfifo_dcnt;
  
  always @(posedge clk)
    if (!ready)
      wrfifo_cnt <= 0;
    else
      wrfifo_cnt <= wrfifo_cnt_nxt;
  
  assert_wrfifo_overflow_check: assert property (@(posedge clk) disable iff (!ready) (wrfifo_cnt_nxt <= FNUMWRDS))
    else $display("[ERROR:memoir:%m:%0t] (memoir_1r4wt_wrfifocnt > %0d) should always be false", $time, FNUMWRDS);

  genvar             i;
  generate
    for (i = 0; i < NUMWRPT; i++) begin : bp_chk
      assert_wr_bp_check: assert property (@(posedge clk) disable iff (!ready) (wr_bp[i] == ($past(wrfifo_cnt,FCNTDEL) > bp_thr)))
        else $display("[ERROR:memoir:%m:%0t] wr_bp_%0d == wrfifo_cnt > bp_thr failed", $time, i+NUMRDPT);
    end
  endgenerate

`ifdef FORMAL
  generate if (FLOPIN) begin: flp_loop
    assert_wrfifo_cnt_check: assert property (@(posedge clk) disable iff (!ready) 1'b1 |-> ##(FLOPIN) ($past(wrfifo_cnt,FLOPIN) == core.des.algo_top.a1_loop.algo.core.wrfifo_cnt));
  end else begin: nflp_loop
    assert_wrfifo_cnt_check: assert property (@(posedge clk) disable iff (!ready) (wrfifo_cnt == core.des.algo_top.a1_loop.algo.core.wrfifo_cnt));
  end
  endgenerate
`endif

endmodule // memoir_1r4wt_4a667_sva