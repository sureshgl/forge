/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_2r1w6m2d_m63_sva_wrap
  #(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
    parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
    parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 5, parameter IP_SECCDWIDTH = 11, 
    parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
    parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,
    
    parameter T1_WIDTH = 32, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 1, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11, 
    parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 32,
    
    parameter T2_WIDTH = 27, parameter T2_NUMVBNK = 8, parameter T2_BITVBNK = 3, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
    parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 1, parameter T2_NUMSROW = 2048, parameter T2_BITSROW = 11, parameter T2_PHYWDTH = 27)
  ( clk, 		rst, 		ready,
    read, 	rd_adr, 	rd_dout, 	rd_vld, 	rd_serr, 	rd_derr, 	rd_padr,
    ma_write, 	ma_adr, 	ma_din,	        ma_bp,		bp_thr,
    write, 	wr_adr, 	din,
    dq_vld,       dq_adr,
    
    grpmsk,
    
    t1_writeA, t1_addrA, t1_dinA, t1_bwA,
    t1_readB, t1_addrB, t1_doutB,
    t2_writeA, t2_addrA, t2_dinA, t2_bwA, 
    t2_readB, t2_addrB, t2_doutB);
  
  parameter NUMRDPT = 2;
  parameter NUMWRPT = 1;
  parameter NUMMAPT = 6;
  parameter NUMDQPT = 2;
  
  parameter T1_INST = T1_NUMVBNK;
  parameter T2_INST = T2_NUMVBNK;
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  
  parameter NUMVROW = T1_NUMVROW;  // ALGO1 Parameters
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = T1_NUMVBNK;
  parameter BITVBNK = T1_BITVBNK;
  
  parameter NUMWRDS = T1_NUMWRDS;     // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  
  parameter ECCBITS = IP_SECCBITS;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_DELAY;
  
  parameter MEMWDTH = WIDTH;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;
  parameter SDOUT_WIDTH = 2*BITVROW+ECCBITS;
  //  parameter SDOUT_WIDTH = BITVROW;

  input                          clk; 
  input                          rst;
  input                          ready; 
  
  input [NUMMAPT - 1:0]          ma_write; 
  input [NUMMAPT* BITADDR - 1:0] ma_adr; 
  input [NUMMAPT* WIDTH - 1:0]   ma_din;
  input [NUMMAPT - 1:0]          ma_bp; 
  input [7:0]                    bp_thr;
  
  input [NUMWRPT - 1:0]          write; 
  input [NUMWRPT* BITADDR - 1:0] wr_adr; 
  input [NUMWRPT* WIDTH - 1:0]   din;
  
  input [NUMRDPT - 1:0]          read; 
  input [NUMRDPT* BITADDR - 1:0] rd_adr; 
  input [NUMRDPT* WIDTH - 1:0]   rd_dout; 
  input [NUMRDPT - 1:0]          rd_vld; 
  input [NUMRDPT - 1:0]          rd_serr; 
  input [NUMRDPT - 1:0]          rd_derr; 
  input [NUMRDPT* BITPADR - 1:0] rd_padr;
  
  input [NUMDQPT - 1:0]          dq_vld;
  input [NUMDQPT* BITADDR - 1:0] dq_adr;
  
  input [NUMVBNK - 1:0]          grpmsk;
  
  input [T1_INST- 1:0]           t1_writeA; 
  input [T1_INST*BITSROW - 1:0]  t1_addrA; 
  input [T1_INST*PHYWDTH - 1:0]  t1_dinA;
  input [T1_INST*PHYWDTH - 1:0]  t1_bwA; 
  input [T1_INST - 1:0]          t1_readB; 
  input [T1_INST*BITSROW - 1:0]  t1_addrB; 
  input [T1_INST*PHYWDTH - 1:0]  t1_doutB;
  
  input [T2_INST - 1:0]          t2_writeA; 
  input [T2_INST*BITVROW - 1:0]  t2_addrA; 
  input [T2_INST*SDOUT_WIDTH - 1:0] t2_dinA; 
  input [T2_INST*SDOUT_WIDTH - 1:0] t2_bwA;
  
  input [T2_INST - 1:0]             t2_readB; 
  input [T2_INST*BITVROW - 1:0]     t2_addrB; 
  input [T2_INST*SDOUT_WIDTH - 1:0] t2_doutB;


// BELOW is the shipped version of assertions for one instance.
// clean it up and enable it.

/* -----\/----- EXCLUDED -----\/-----


module memoir_2r1w6m2d_24Kx1794_sva_3_3_7207M
  #(
    parameter     NUMADDR = 24576,
    parameter     BITADDR = 15,
    parameter     NUMMAPT = 6,
    parameter     NUMDQPT = 2,
    parameter     BITVROW = 11,
    parameter     NUMVBNK = 12
    )
  (
   input                 clk,
   input                 rst,
   input                 ready,
   input [BITVROW:0]     bp_thr,
   input [BITVROW:0]     bp_hys,
   input [NUMVBNK-1:0]   grpmsk,
   input [NUMVBNK-1:0]   grpbp,
   input [NUMVBNK-1:0]   grpmt,
   input                 read_0,
   input [BITADDR - 1:0] addr_0,
   input                 read_vld_0,
   input                 read_1,
   input [BITADDR - 1:0] addr_1,
   input                 read_vld_1,

   input                 write_2,
   input [BITADDR - 1:0] addr_2,
   input                 wr_bp_3,
   input                 wr_vld_3,
   input [BITADDR - 1:0] addr_3,
   input                 wr_bp_4,
   input                 wr_vld_4,
   input [BITADDR - 1:0] addr_4,
   input                 wr_bp_5,
   input                 wr_vld_5,
   input [BITADDR - 1:0] addr_5,
   input                 wr_bp_6,
   input                 wr_vld_6,
   input [BITADDR - 1:0] addr_6,
   input                 wr_bp_7,
   input                 wr_vld_7,
   input [BITADDR - 1:0] addr_7,
   input                 wr_bp_8,
   input                 wr_vld_8,
   input [BITADDR - 1:0] addr_8,

   input                 dq_vld_9,
   input [BITADDR-1:0]   dq_adr_9,
   input                 dq_vld_10,
   input [BITADDR-1:0]   dq_adr_10
   );

  localparam CCWDTH = 32;
  localparam SBWDTH = CCWDTH + 1;
  localparam OCWDTH = BITVROW + 1;
  localparam BITBNK = BITADDR-BITVROW;
  localparam GPCWIN = 100;

  wire [BITBNK-1:0] bank_0  = addr_0[BITADDR-1:BITVROW];
  wire [BITBNK-1:0] bank_1  = addr_1[BITADDR-1:BITVROW];
  wire [BITBNK-1:0] bank_2  = addr_2[BITADDR-1:BITVROW];
  wire [BITBNK-1:0] bank_3  = addr_3[BITADDR-1:BITVROW];
  wire [BITBNK-1:0] bank_4  = addr_4[BITADDR-1:BITVROW];
  wire [BITBNK-1:0] bank_5  = addr_5[BITADDR-1:BITVROW];
  wire [BITBNK-1:0] bank_6  = addr_6[BITADDR-1:BITVROW];
  wire [BITBNK-1:0] bank_7  = addr_7[BITADDR-1:BITVROW];
  wire [BITBNK-1:0] bank_8  = addr_8[BITADDR-1:BITVROW];
  wire [BITBNK-1:0] bank_9  = dq_adr_9[BITADDR-1:BITVROW];
  wire [BITBNK-1:0] bank_10 = dq_adr_10[BITADDR-1:BITVROW];

  reg                    grpmsk_start;
  reg                    grpmsk_flag;
  reg                    grpbp_start;
  reg                    grpbp_flag;
  integer                grpf_int;
  always_comb begin
    grpmsk_start = 0;
    grpmsk_flag = 0;
    grpbp_start = 0;
    grpbp_flag = 0;
    for (grpf_int=NUMVBNK-1; grpf_int>=0; grpf_int=grpf_int-1) begin
      if (grpmsk_start && !grpmsk[grpf_int])
        grpmsk_flag = 1; // memoir - this line will not be covered under normal stimulus
      if (grpmsk[grpf_int])
        grpmsk_start = 1;
      if (grpbp_start && !grpbp[grpf_int])
        grpbp_flag = 1; // memoir - this line will not be covered under normal stimulus
      if (grpbp[grpf_int])
        grpbp_start = 1;
    end
  end
  
  assume_grpbp_less_check: assert property (@(posedge clk) disable iff (rst) (grpbp==(grpmsk & grpbp)))
    else $display("[ERROR:memoir:%m:%0t] grpbp not less grpmsk=0x%0x grpbp=0x%0x", $time, grpmsk, grpbp);
  assume_grpmsk_cont_check: assert property (@(posedge clk) disable iff (rst) !grpmsk_flag)
    else $display("[ERROR:memoir:%m:%0t] contiguous bits must be set grpmsk=0x%0x", $time, grpmsk);
  assume_grpbp_cont_check: assert property (@(posedge clk) disable iff (rst) !grpbp_flag)
    else $display("[ERROR:memoir:%m:%0t] contiguous bits must be set grpbp=0x%0x", $time, grpbp);
  /-* commented out since these two signals are changed in the tests
   assume_grpmsk_stable: assert property (@(posedge clk) disable iff (rst) $stable(grpmsk));
   assume_grpbp_stable: assert property (@(posedge clk) disable iff (rst) $stable(grpbp));
   *-/

  reg [NUMVBNK-1:0] grpmsk_d;
  always @(posedge clk)
    grpmsk_d <= grpmsk;
  wire              grpmsk_c = grpmsk_d != grpmsk;
  wire              grpmsk_c_l2h = grpmsk_d < grpmsk;
  wire              grpmsk_c_h2l = grpmsk_d > grpmsk;

  reg [NUMVBNK-1:0] grpbp_d;
  always @(posedge clk)
    grpbp_d <= grpbp;
  wire              grpbp_c = grpbp_d != grpbp;
  wire              grpbp_c_l2h = grpbp_d < grpbp;
  wire              grpbp_c_h2l = grpbp_d > grpbp;

  reg [6:0]         grp_ccnt;
  always @(posedge clk)
    if (!ready)
      grp_ccnt <= 7'h0;
    else
      if (grpbp_c_h2l)
        grp_ccnt <= GPCWIN;
      else
        grp_ccnt <= grp_ccnt - |grp_ccnt;

  wire              grp_ccnt_done = (grp_ccnt == 7'd1);

  reg               bp_bnk_alloc_chk;
  always @(posedge clk)
    if (!ready)
      bp_bnk_alloc_chk <= 1'b0;
    else
      if (grpmsk_c_h2l)
        bp_bnk_alloc_chk <= 1'b0;
      else if (grp_ccnt_done)
        bp_bnk_alloc_chk <= 1'b1;

  wire m_bad_bank = bp_bnk_alloc_chk & |((grpmsk ^ 
                                          grpbp) & 
                                         ((wr_vld_8 << bank_8) |
                                          (wr_vld_7 << bank_7) |
                                          (wr_vld_6 << bank_6) |
                                          (wr_vld_5 << bank_5) |
                                          (wr_vld_4 << bank_4) |
                                          (wr_vld_3 << bank_3)));
  
  assert_grpbp_h2l_to_grpmsk_change_check: assert property (@(posedge clk) disable iff (!ready) grpbp_c_h2l |-> (!grpmsk_c [*GPCWIN]))
    else $display("[ERROR:memoir:%m:%0t] grpbp_h2l - grpmsk changed too soon grpmsk=0x%0x grpbp=0x%0x grpmt=0x%0x", $time, grpmsk, grpbp, grpmt);

  assert_grpbp_h2l_bad_alloc_check : assert property (@(posedge clk) disable iff (!ready) (!m_bad_bank))
    else $display ("[ERROR:memoir:%m:%0t] grpbp_h2l - bank allocated %0d cycles after grpbp change grpmsk=0x%0x grpbp=0x%0x grpmt=0x%0x", $time, GPCWIN, grpmsk, grpbp, grpmt);

  assert_bp_thr_check: assert property (@(posedge clk) disable iff (!ready) (bp_hys >= bp_thr))
    else $display("[ERROR:memoir:%m:%0t] bp_hys >= bp_thr failed bp_thr=%0d bp_hys=%0d", $time, bp_thr, bp_hys);

  assert_read_0_range_check: assert property (@(posedge clk) disable iff (!ready) read_0 |-> (addr_0 < NUMADDR))
    else $display("[ERROR:memoir:%m:%0t] r0 read address not in range addr=0x%0x", $time, addr_0);
  assert_read_1_range_check: assert property (@(posedge clk) disable iff (!ready) read_1 |-> (addr_1 < NUMADDR))
    else $display("[ERROR:memoir:%m:%0t] r1 read address not in range addr=0x%0x", $time, addr_1);
  assert_write_2_range_check: assert property (@(posedge clk) disable iff (!ready) write_2 |-> (addr_2 < NUMADDR))
    else $display("[ERROR:memoir:%m:%0t] w2 write address not in range addr=0x%0x", $time, addr_2);

  assert_wr_vld_3_range_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_3 |-> (addr_3 < NUMADDR))
    else $display("[ERROR:memoir:%m:%0t] m0 malloc address not in range addr=0x%0x", $time, addr_3);
  assert_wr_vld_4_range_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_4 |-> (addr_4 < NUMADDR))
    else $display("[ERROR:memoir:%m:%0t] m1 malloc address not in range addr=0x%0x", $time, addr_4);
  assert_wr_vld_5_range_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_5 |-> (addr_5 < NUMADDR))
    else $display("[ERROR:memoir:%m:%0t] m2 malloc address not in range addr=0x%0x", $time, addr_5);
  assert_wr_vld_6_range_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_6 |-> (addr_6 < NUMADDR))
    else $display("[ERROR:memoir:%m:%0t] m3 malloc address not in range addr=0x%0x", $time, addr_6);
  assert_wr_vld_7_range_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_7 |-> (addr_7 < NUMADDR))
    else $display("[ERROR:memoir:%m:%0t] m4 malloc address not in range addr=0x%0x", $time, addr_7);
  assert_wr_vld_8_range_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_8 |-> (addr_8 < NUMADDR))
    else $display("[ERROR:memoir:%m:%0t] m5 malloc address not in range addr=0x%0x", $time, addr_8);

  assert_dq_vld_9_range_check: assert property (@(posedge clk) disable iff (!ready) dq_vld_9 |-> (dq_adr_9 < NUMADDR))
    else $display("[ERROR:memoir:%m:%0t] dq0 read address not in range addr=0x%0x", $time, dq_adr_9);
  assert_dq_vld_10_range_check: assert property (@(posedge clk) disable iff (!ready) dq_vld_10 |-> (dq_adr_10 < NUMADDR))
    else $display("[ERROR:memoir:%m:%0t] dq1 read address not in range addr=0x%0x", $time, dq_adr_10);

  reg [CCWDTH-1:0] cycle_count;

  always @(posedge clk) begin : cycle_counter
    if (rst)
      cycle_count <= {CCWDTH{1'b0}};
    else
      cycle_count <= cycle_count + 1'b1;
  end

  reg [SBWDTH-1:0] score_board [0:NUMADDR-1]; // {vld, cyc cnt at event}

  integer sb_c;
  always @(posedge clk) begin : score_board_write
    if (rst)
      for (sb_c = 0; sb_c < NUMADDR; sb_c++)
        score_board[sb_c] <= {SBWDTH{1'b0}};
    else begin
      if (wr_vld_3)
        score_board[addr_3] <= {1'b1,cycle_count};
      if (wr_vld_4)
        score_board[addr_4] <= {1'b1,cycle_count};
      if (wr_vld_5)
        score_board[addr_5] <= {1'b1,cycle_count};
      if (wr_vld_6)
        score_board[addr_6] <= {1'b1,cycle_count};
      if (wr_vld_7)
        score_board[addr_7] <= {1'b1,cycle_count};
      if (wr_vld_8)
        score_board[addr_8] <= {1'b1,cycle_count};
      if (dq_vld_9)
        score_board[dq_adr_9] <= {1'b0,cycle_count};
      if (dq_vld_10)
        score_board[dq_adr_10] <= {1'b0,cycle_count};
    end
  end
  
  assert_wr_vld_3_realloc_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_3 |-> !(score_board[addr_3][SBWDTH-1]))
    else $display("[ERROR:memoir:%m:%0t] m0 reallocating non-free addr=0x%0x", $time, addr_3);
  assert_wr_vld_4_realloc_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_4 |-> !(score_board[addr_4][SBWDTH-1]))
    else $display("[ERROR:memoir:%m:%0t] m1 reallocating non-free addr=0x%0x", $time, addr_4);
  assert_wr_vld_5_realloc_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_5 |-> !(score_board[addr_5][SBWDTH-1]))
    else $display("[ERROR:memoir:%m:%0t] m2 reallocating non-free addr=0x%0x", $time, addr_5);
  assert_wr_vld_6_realloc_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_6 |-> !(score_board[addr_6][SBWDTH-1]))
    else $display("[ERROR:memoir:%m:%0t] m3 reallocating non-free addr=0x%0x", $time, addr_6);
  assert_wr_vld_7_realloc_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_7 |-> !(score_board[addr_7][SBWDTH-1]))
    else $display("[ERROR:memoir:%m:%0t] m4 reallocating non-free addr=0x%0x", $time, addr_7);
  assert_wr_vld_8_realloc_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_8 |-> !(score_board[addr_8][SBWDTH-1]))
    else $display("[ERROR:memoir:%m:%0t] m5 reallocating non-free addr=0x%0x", $time, addr_8);
  assert_dq_vld_9_noalloc_check : assert property (@(posedge clk) disable iff (!ready) dq_vld_9  |-> (score_board[dq_adr_9][SBWDTH-1]))
    else $display("[ERROR:memoir:%m:%0t] dq0 freeing non-allocated addr=0x%0x", $time, dq_adr_9);
  assert_dq_vld_10_noalloc_check: assert property (@(posedge clk) disable iff (!ready) dq_vld_10 |-> (score_board[dq_adr_10][SBWDTH-1]))
    else $display("[ERROR:memoir:%m:%0t] dq1 freeing non-allocated addr=0x%0x", $time, dq_adr_10);


  assert_read_bank_conflict_check: assert property (@(posedge clk) disable iff (!ready) !(read_0 & read_1 & (bank_0 == bank_1)))
    else $display("[ERROR:memoir:%m:%0t] read bank conflict r0 r1 bank0=%0d bank1=%0d", $time, bank_0, bank_1);

  assert_write_2_bad_bank_check: assert property (@(posedge clk) disable iff (!ready) write_2 |-> (grpmt[bank_2]))
    else $display("[ERROR:memoir:%m:%0t] w2 write to non-empty bank grpmt=0x%0x bank=%0d", $time, grpmt, bank_2);

  assert_wr_vld_3_bad_bank_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_3 |-> (grpmsk[bank_3]))
    else $display("[ERROR:memoir:%m:%0t] m0 alloc on bad bank grpmsk=0x%0x bank=%0d", $time, grpmsk, bank_3);
  assert_wr_vld_4_bad_bank_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_4 |-> (grpmsk[bank_4]))
    else $display("[ERROR:memoir:%m:%0t] m1 alloc on bad bank grpmsk=0x%0x bank=%0d", $time, grpmsk, bank_4);
  assert_wr_vld_5_bad_bank_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_5 |-> (grpmsk[bank_5]))
    else $display("[ERROR:memoir:%m:%0t] m2 alloc on bad bank grpmsk=0x%0x bank=%0d", $time, grpmsk, bank_5);
  assert_wr_vld_6_bad_bank_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_6 |-> (grpmsk[bank_6]))
    else $display("[ERROR:memoir:%m:%0t] m3 alloc on bad bank grpmsk=0x%0x bank=%0d", $time, grpmsk, bank_6);
  assert_wr_vld_7_bad_bank_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_7 |-> (grpmsk[bank_7]))
    else $display("[ERROR:memoir:%m:%0t] m4 alloc on bad bank grpmsk=0x%0x bank=%0d", $time, grpmsk, bank_7);
  assert_wr_vld_8_bad_bank_check: assert property (@(posedge clk) disable iff (!ready) wr_vld_8 |-> (grpmsk[bank_8]))
    else $display("[ERROR:memoir:%m:%0t] m5 alloc on bad bank grpmsk=0x%0x bank=%0d", $time, grpmsk, bank_8);
  assert_dq_vld_9_empty_bank_check: assert property (@(posedge clk) disable iff (!ready) dq_vld_9 |-> (!grpmt[bank_9]))
    else $display("[ERROR:memoir:%m:%0t] dq0 dequeue on empty bank grpmt=0x%0x bank=%0d", $time, grpmt, bank_9);
  assert_dq_vld_10_empty_bank_check: assert property (@(posedge clk) disable iff (!ready) dq_vld_10 |-> (!grpmt[bank_10]))
    else $display("[ERROR:memoir:%m:%0t] dq1 dequeue on empty bank grpmt=0x%0x bank=%0d", $time, grpmt, bank_10);

  reg [OCWDTH-1:0]  bank_alloc_count [0:NUMVBNK-1];
  reg [OCWDTH-1:0]  bank_alloc_count_c [0:NUMVBNK-1];

  integer           bo_a;
  always_comb begin : bank_alloc_calc
    for (bo_a = 0; bo_a < NUMVBNK; bo_a++)
      bank_alloc_count_c[bo_a] = bank_alloc_count[bo_a];
    bank_alloc_count_c[bank_3] = bank_alloc_count_c[bank_3] + wr_vld_3;
    bank_alloc_count_c[bank_4] = bank_alloc_count_c[bank_4] + wr_vld_4;
    bank_alloc_count_c[bank_5] = bank_alloc_count_c[bank_5] + wr_vld_5;
    bank_alloc_count_c[bank_6] = bank_alloc_count_c[bank_6] + wr_vld_6;
    bank_alloc_count_c[bank_7] = bank_alloc_count_c[bank_7] + wr_vld_7;
    bank_alloc_count_c[bank_8] = bank_alloc_count_c[bank_8] + wr_vld_8;
  end

  integer bo_b;
  always @(posedge clk) begin : bank_alloc_count_write
    for (bo_b = 0; bo_b < NUMVBNK; bo_b++)
      if (rst)
        bank_alloc_count[bo_b] <= {OCWDTH{1'b0}};
      else
        bank_alloc_count[bo_b] <= bank_alloc_count_c[bo_b];
  end

  reg [OCWDTH-1:0] max_alloc;
  reg [OCWDTH-1:0] min_alloc;
  reg [BITADDR:0]  cnt_alloc;
  integer mmi;
  always_comb begin : min_max_alloc_calc
    max_alloc = 0;
    min_alloc = {OCWDTH{1'b1}};
    cnt_alloc = 0;
    for (mmi = 0; mmi < NUMVBNK; mmi++) begin
      if (grpmsk[mmi]) begin
        max_alloc = (bank_alloc_count[mmi] > max_alloc) ? bank_alloc_count[mmi] : max_alloc;
        min_alloc = (bank_alloc_count[mmi] < min_alloc) ? bank_alloc_count[mmi] : min_alloc;
        cnt_alloc = bank_alloc_count[mmi] + cnt_alloc;
      end
    end
  end
  wire [OCWDTH-1:0] dif_alloc = max_alloc - min_alloc;

  integer           bo_d;
  string            s;           
  final begin
    s = "";
    for (bo_d = 0; bo_d < NUMVBNK; bo_d++)
      if (grpmsk[bo_d]) 
        s = $psprintf("%s %0d", s, bank_alloc_count[bo_d]);
    $display("[INFO:memoir:%m:%0t] alloc stats: %s - min=%0d max=%0d diff=%0d tot=%0d", $time, s, min_alloc, max_alloc, dif_alloc, cnt_alloc);
  end

  reg [OCWDTH-1:0] bank_occupancy_count [0:NUMVBNK-1];
  reg [OCWDTH-1:0] bank_occupancy_count_c [0:NUMVBNK-1];
  integer bo_e;
  always_comb begin : bank_occ_calc
    for (bo_e = 0; bo_e < NUMVBNK; bo_e++)
      bank_occupancy_count_c[bo_e] = bank_occupancy_count[bo_e];
    bank_occupancy_count_c[bank_3] = bank_occupancy_count_c[bank_3] + wr_vld_3;
    bank_occupancy_count_c[bank_4] = bank_occupancy_count_c[bank_4] + wr_vld_4;
    bank_occupancy_count_c[bank_5] = bank_occupancy_count_c[bank_5] + wr_vld_5;
    bank_occupancy_count_c[bank_6] = bank_occupancy_count_c[bank_6] + wr_vld_6;
    bank_occupancy_count_c[bank_7] = bank_occupancy_count_c[bank_7] + wr_vld_7;
    bank_occupancy_count_c[bank_8] = bank_occupancy_count_c[bank_8] + wr_vld_8;
    bank_occupancy_count_c[bank_9] = bank_occupancy_count_c[bank_9]   - dq_vld_9;
    bank_occupancy_count_c[bank_10] = bank_occupancy_count_c[bank_10] - dq_vld_10;
  end

  integer bo_f;
  always @(posedge clk) begin : bank_occupancy_count_write
    for (bo_f = 0; bo_f < 12; bo_f++)
      if (rst)
        bank_occupancy_count[bo_f] <= {OCWDTH{1'b0}};
      else
        bank_occupancy_count[bo_f] <= bank_occupancy_count_c[bo_f];
  end

  reg [OCWDTH-1:0] max_occ;
  reg [OCWDTH-1:0] min_occ;
  reg [BITADDR:0]  cnt_occ;
  integer mmj;
  always_comb begin : min_max_occ_calc
    max_occ = 0;
    min_occ = {OCWDTH{1'b1}};
    cnt_occ = 0;
    for (mmj = 0; mmj < 12; mmj++) begin
      if (grpmsk[mmj]) begin
        max_occ = (bank_occupancy_count[mmj] > max_occ) ? bank_occupancy_count[mmj] : max_occ;
        min_occ = (bank_occupancy_count[mmj] < min_occ) ? bank_occupancy_count[mmj] : min_occ;
        cnt_occ = bank_occupancy_count[mmj] + cnt_occ;
      end
    end
  end
  wire [OCWDTH-1:0] dif_occ = max_occ - min_occ;

  reg [NUMVBNK-1:0] bank_alloc_map;
  integer           bo_c;
  always @(posedge clk) begin : bank_alloc_map_write
    for (bo_c = 0; bo_c < NUMVBNK; bo_c++)
      if (rst)
        bank_alloc_map[bo_c] <= 1'b0;
      else
        bank_alloc_map[bo_c] <= bank_alloc_map[bo_c] | (|bank_alloc_count[bo_c]);
  end

  reg [NUMVBNK-1:0] grpmsk_aggr;
  always @(posedge clk)
    grpmsk_aggr <= ready ? (grpmsk | grpmsk_aggr) : {NUMVBNK{1'b0}};
  
  cover_all_banks_allocated : cover property (@(posedge clk) disable iff (!ready || (cnt_alloc < 200)) (grpmsk_aggr == bank_alloc_map));

  // post-backpressure sent packet count

  wire [NUMMAPT-1:0] wr_bp_c = {wr_bp_8,wr_bp_7,wr_bp_6,wr_bp_5,wr_bp_4,wr_bp_3};
  reg [NUMMAPT-1:0] wr_bp_d;
  always @(posedge clk) begin : bp_del
    wr_bp_d <= wr_bp_c;
  end

  reg [NUMMAPT-1:0] wr_bp_up;
  reg [NUMMAPT-1:0] wr_bp_dn;
  integer           bp_a;
  always @(posedge clk) begin : bp_ud
    for (bp_a = 0; bp_a < NUMMAPT; bp_a++)
      if (rst) begin
        wr_bp_up[bp_a] <= 1'b0;
        wr_bp_dn[bp_a] <= 1'b0;
      end else begin
        wr_bp_up[bp_a] <=  wr_bp_c[bp_a] & !wr_bp_d[bp_a];
        wr_bp_dn[bp_a] <= !wr_bp_c[bp_a] &  wr_bp_d[bp_a];
      end
  end

  reg  [OCWDTH-1:0] pb_pkt_cnt[0:NUMMAPT-1];
  integer           bp_b;
  always @(posedge clk) begin : pb_pkt_cnt_write
    for (bp_b = 0; bp_b < NUMMAPT; bp_b++)
      if (rst)
        pb_pkt_cnt[bp_b] <= {OCWDTH{1'b0}};
      else if (wr_bp_up[bp_b] | wr_bp_dn[bp_b])
        pb_pkt_cnt[bp_b] <= {OCWDTH{1'b0}};
      else
        pb_pkt_cnt[bp_b] <= pb_pkt_cnt[bp_b] + wr_bp_d[bp_b];
  end

  covergroup pb_pkt_cnt_all_v (reg [OCWDTH-1:0] pkt_cnt) @(posedge clk);
    cnt : coverpoint pkt_cnt {
      bins all[] = {[0:256]};
    }
  endgroup // pb_pkts

  genvar pbi;
  generate begin : pb_pkt_cg_loop
    for (pbi = 0; pbi < NUMMAPT; pbi++)
      pb_pkt_cnt_all_v pb_pkt_cnt_cg = new(pb_pkt_cnt[pbi]);
  end
  endgenerate
  
  covergroup grpmsk_all_v @(posedge clk);
    all : coverpoint grpmsk {
      bins grpmsk_1f = {31};
      bins grpmsk_3f = {63};
      bins grpmsk_7f = {127};
      bins grpmsk_ff = {255};
      bins grpmsk_1ff = {511};
      bins grpmsk_3ff = {1023};
      bins grpmsk_7ff = {2047};
      bins grpmsk_fff = {4095};      
    }
  endgroup
  grpmsk_all_v gm_cg = new;

  covergroup grpbp_all_v @(posedge clk);
    all : coverpoint grpbp {
      bins grpbp_1f = {31};
      bins grpbp_3f = {63};
      bins grpbp_7f = {127};
      bins grpbp_ff = {255};
      bins grpbp_1ff = {511};
      bins grpbp_3ff = {1023};
      bins grpbp_7ff = {2047};
      bins grpbp_fff = {4095};      
    }
  endgroup
  grpbp_all_v gb_cg = new;

  covergroup bp_thr_all_v @(posedge clk);
    all : coverpoint bp_thr {
      bins bp_thr_low = {[0:20]};
      bins bp_thr_med = {[21:100]};
      bins bp_thr_high = {[101:2047]};
    }
  endgroup
  bp_thr_all_v bp_cg = new;

  wire [NUMMAPT-1:0] rd_vld_bus = {read_vld_1,read_vld_0};
  covergroup rd_vld_all_v @(posedge clk);
    all : coverpoint rd_vld_bus {
      bins all[] = {[0:3]};
    }
  endgroup // rd_vld_bus
  rd_vld_all_v rv_cg = new;

  wire [NUMMAPT-1:0] ma_vld_bus = {wr_vld_8,wr_vld_7,wr_vld_6,wr_vld_5,wr_vld_4,wr_vld_3};
  covergroup ma_vld_all_v @(posedge clk);
    all : coverpoint ma_vld_bus {
      bins all[] = {[0:63]};
    }
  endgroup // ma_vld_bus
  ma_vld_all_v mv_cg = new;

  wire [NUMDQPT-1:0] dq_vld_bus = {dq_vld_10,dq_vld_9};
  covergroup dq_vld_all_v @(posedge clk);
    all: coverpoint dq_vld_bus {
      bins all[] = {[0:3]};
    }
  endgroup // dq_vld_all_v
  dq_vld_all_v dv_cg = new;

endmodule // memoir_2r1w6m2d_24Kx1794_sva_3_3_7207M

 -----/\----- EXCLUDED -----/\----- */

endmodule
