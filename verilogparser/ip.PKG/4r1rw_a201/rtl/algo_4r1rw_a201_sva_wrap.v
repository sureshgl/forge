/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

module algo_4r1rw_a201_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 10240, parameter IP_BITADDR = 14, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_ENAHEC = 0, parameter IP_ENAQEC = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0, parameter ENAPSDO = 0,

parameter T1_WIDTH = 33, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 1, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 4, parameter T1_BITWRDS = 2, parameter T1_NUMSROW = 512, parameter T1_BITSROW = 9, parameter T1_PHYWDTH = 132, 
parameter T2_WIDTH = 33, parameter T2_NUMVBNK = 1, parameter T2_BITVBNK = 1, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 4, parameter T2_BITWRDS = 2, parameter T2_NUMSROW = 512, parameter T2_BITSROW = 9, parameter T2_PHYWDTH = 132)
( clk,  rst,  ready, ena_rdacc,
  rw_read,  rw_write,  rw_addr,  rw_din,  rw_dout,  rw_vld,  rw_serr,  rw_derr,  rw_padr,
  read,  rd_adr,  rd_dout,  rd_vld,  rd_serr,  rd_derr,  rd_padr,
  t1_writeA,  t1_addrA,  t1_dinA,  t1_bwA,  t1_readB,  t1_addrB,  t1_doutB,
  t2_writeA,  t2_addrA,  t2_dinA,  t2_bwA,  t2_readB,  t2_addrB,  t2_doutB);
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ENAHEC = IP_ENAHEC;
  parameter ENAQEC = IP_ENAQEC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMADDRB = IP_NUMADDR;
  parameter BITADDRB = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;   // ALGO Parameters
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = T1_NUMVBNK;
  parameter BITVBNK = T1_BITVBNK;
  parameter NUMPBNK = T1_NUMVBNK+1;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMADDRA = NUMVBNK*NUMADDRB/NUMPBNK;
  parameter BITADDRA = BITADDRB-1;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter SRAM_DELAY = T1_DELAY;
  parameter PHYWDTH = T1_PHYWDTH;

  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENAHEC ? WIDTH+2*ECCWDTH : ENAQEC ? WIDTH+4*ECCWDTH : WIDTH;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  
  input [1-1:0]                  rw_read;
  input [1-1:0]                  rw_write;
  input [1*BITADDRB-1:0]         rw_addr;
  input [1-1:0]                 rw_vld;
  input [1*WIDTH-1:0]           rw_dout;
  input [1*WIDTH-1:0]            rw_din;
  input [1-1:0]                 rw_serr;
  input [1-1:0]                 rw_derr;
  input [1*BITPADR-1:0]         rw_padr;

  input [4-1:0]                  read;
  input [4*BITADDRB-1:0]         rd_adr;
  input [4-1:0]                 rd_vld;
  input [4*WIDTH-1:0]           rd_dout;
  input [4-1:0]                 rd_serr;
  input [4-1:0]                 rd_derr;
  input [4*BITPADR-1:0]         rd_padr;

  input                          ena_rdacc;
  input                         ready;
  input                          clk, rst;

  input [NUMVBNK-1:0] t1_writeA;
  input [NUMVBNK*BITSROW-1:0] t1_addrA;
  input [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  input [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMVBNK-1:0] t1_readB;
  input [NUMVBNK*BITSROW-1:0] t1_addrB;
  input [NUMVBNK*PHYWDTH-1:0] t1_doutB;

  input [1-1:0] t2_writeA;
  input [1*BITSROW-1:0] t2_addrA;
  input [1*PHYWDTH-1:0] t2_bwA;
  input [1*PHYWDTH-1:0] t2_dinA;
  input [1-1:0] t2_readB;
  input [1*BITSROW-1:0] t2_addrB;
  input [1*PHYWDTH-1:0] t2_doutB;

  localparam BITADDR = BITADDRB;
  localparam NUMPRPT = 4;
  localparam NUMRDPT = 4;

  wire [BITPBNK-1:0] rbank [0:NUMPRPT-1];

  wire [BITADDR-1:0] addr [0:NUMPRPT-1];

  genvar i;
  generate
  for (i = 0; i < NUMPRPT; i++) begin
    assign addr[i] = rd_adr >> (i*BITADDR);
    assign rbank[i] =  addr[i]>> BITVROW;
  end
  endgenerate

  wire [BITADDR-1:0] addr_0 = addr[0];
  wire [BITADDR-1:0] addr_1 = addr[1];
  wire [BITADDR-1:0] addr_2 = addr[2];
  wire [BITADDR-1:0] addr_3 = addr[3];
  wire [BITPBNK-1:0] rbank_0 = rbank[0];
  wire [BITPBNK-1:0] rbank_1 = rbank[1];
  wire [BITPBNK-1:0] rbank_2 = rbank[2];
  wire [BITPBNK-1:0] rbank_3 = rbank[3];

  genvar           j;
  genvar           k;
  generate
  for (j = 0; j < NUMPRPT; j++) begin
    for (k = 0; k < j; k++) begin
      assert_r_bank_conflict: assert property (@(negedge clk) disable iff (!ready || rst) !(!ena_rdacc & read[j] & read[k] & (rbank[j] == rbank[k])))
          else $display("[ERROR:memoir:%m:%0t] read bank conflict r%0d r%0d bank%0d=0x%0x addr=0x%0x bank%0d=0x%0x addr=0x%0x", $time, j, k, j, rbank[j], addr[j], k, rbank[k], addr[k]);
    end
  end
  endgenerate

  assert_ena_rdacc_r_r_conflict: assert property (@(negedge clk) disable iff (!ready || rst) !(ena_rdacc & (|read[NUMPRPT-1:1] )))
  else $display("[ERROR:memoir:%m:%0t] read conflict - read_1 or read_2 or read_3 must not be active when ena_rdacc is asserted", $time);

  assert_rd_0_range_check: assert property (@(negedge clk) disable iff (!ready || rst) read[0] |-> (ena_rdacc ? (addr[0] < (NUMVROW*NUMVBNK)) : (addr[0] < (NUMVROW*NUMPBNK))));
  assert_rd_1_range_check: assert property (@(negedge clk) disable iff (!ready || rst) read[1] |-> (addr[1] < (NUMVROW*NUMPBNK)));
  assert_rd_2_range_check: assert property (@(negedge clk) disable iff (!ready || rst) read[2] |-> (addr[2] < (NUMVROW*NUMPBNK)));
  assert_rd_3_range_check: assert property (@(negedge clk) disable iff (!ready || rst) read[3] |-> (addr[3] < (NUMVROW*NUMPBNK)));
  assert_rw_4_range_check: assert property (@(negedge clk) disable iff (!ready || rst) (rw_read || rw_write) |-> (ena_rdacc ? (rw_addr < (NUMVROW*NUMVBNK)) : (rw_addr < (NUMVROW*NUMPBNK))));


endmodule
