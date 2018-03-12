/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * Generated File by Ipgen. Version: 3.3.8424M Date: Sat 2014.10.25 at 10:33:29 AM PDT
 * */

module algo_1r4w_a216_sva_wrap 
#(
  parameter IP_WIDTH = 4, parameter IP_BITWIDTH = 2, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, parameter IP_ADDDELAY = 0,
  parameter IP_NUMVBNK = 4, parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
  parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 3, parameter IP_SECCDWIDTH = 4, parameter IP_DECCBITS = 4, 

  parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPMEM = 0, parameter FLOPCMD = 0, 

  parameter T1_WIDTH = 4, parameter T1_NUMVBNK = 8, parameter T1_BITVBNK = 3, parameter T1_DELAY = 1, parameter T1_NUMVROW = 2048, parameter T1_BITVROW = 11, 
  parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 0, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 4, 

  parameter T2_WIDTH = 4, parameter T2_NUMVBNK = 4, parameter T2_BITVBNK = 2, parameter T2_DELAY = 1, parameter T2_NUMVROW = 2048, parameter T2_BITVROW = 11,
  parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 2048, parameter T2_BITSROW = 11, parameter T2_PHYWDTH = 4,

  parameter T3_WIDTH = 10, parameter T3_NUMVBNK = 6, parameter T3_BITVBNK = 3, parameter T3_DELAY = 1, parameter T3_NUMVROW = 2048, parameter T3_BITVROW = 11,
  parameter T3_BITWSPF = 0, parameter T3_NUMWRDS = 1, parameter T3_BITWRDS = 0, parameter T3_NUMSROW = 2048, parameter T3_BITSROW = 11, parameter T3_PHYWDTH = 10, 

  parameter T4_WIDTH = 2, parameter T4_NUMVBNK = 6, parameter T4_BITVBNK = 3, parameter T4_DELAY = 1, parameter T4_NUMVROW = 8192, parameter T4_BITVROW = 13, 
  parameter T4_BITWSPF = 0, parameter T4_NUMWRDS = 1, parameter T4_BITWRDS = 0, parameter T4_NUMSROW = 8192, parameter T4_BITSROW = 13, parameter T4_PHYWDTH = 2)
  (
    clk,         rst,        ready,
    write,       wr_adr,     din,
    read,        rd_clr_0,     rd_adr,     rd_dout,     rd_vld,     rd_serr,   rd_derr,   rd_padr,
    t1_readB,    t1_addrB,   t1_doutB,   t1_writeA,   t1_addrA,   t1_dinA,   t1_bwA,
    t2_readB,    t2_addrB,   t2_doutB,   t2_writeA,   t2_addrA,   t2_dinA,   t2_bwA,
    t3_readB,    t3_addrB,   t3_doutB,   t3_writeA,   t3_addrA,   t3_dinA,   t3_bwA,
    t4_readB,    t4_addrB,   t4_doutB,   t4_writeA,   t4_addrA,   t4_dinA,   t4_bwA
  );
               
  
  parameter WIDTH   = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR  = IP_ENAPAR;
  parameter ENAECC  = IP_ENAECC;
  parameter ECCBITS = IP_SECCBITS;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = BITVBNK+1;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMWRDS = T1_NUMWRDS;
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_DELAY;
  parameter ADD_DELAY  = IP_ADDDELAY;
  parameter NUMRDPT = 1;
  parameter NUMWRPT = 4;
  
  parameter NUMCWDS = T4_NUMWRDS;      // C35 ALIGN Parameters
  parameter BITCWDS = T4_BITWRDS;
  parameter NUMCSRW = T4_NUMSROW;
  parameter BITCSRW = T4_BITSROW;
  parameter PHCWDTH = NUMCWDS*2;

  parameter BITPADR = 1+BITPBNK+BITSROW+BITWRDS+1;

  input  [NUMWRPT-1:0]                 write;
  input  [NUMWRPT*BITADDR-1:0]         wr_adr;
  input  [NUMWRPT*WIDTH-1:0]           din;
         
  input  [NUMRDPT-1:0]                 read;
  input  [NUMRDPT-1:0]                 rd_clr_0;
  input  [NUMRDPT*BITADDR-1:0]         rd_adr;
  input [NUMRDPT-1:0]                 rd_vld;
  input [NUMRDPT*WIDTH-1:0]           rd_dout;
  input [NUMRDPT-1:0]                 rd_serr;
  input [NUMRDPT-1:0]                 rd_derr;
  input [NUMRDPT*BITPADR:0]           rd_padr;

  input                               ready;
  input                                clk;
  input                                rst;

  input [T1_NUMVBNK-1:0]              t1_readB;
  input [T1_NUMVBNK*BITSROW-1:0]      t1_addrB;
  input  [T1_NUMVBNK*PHYWDTH-1:0]      t1_doutB;
  input [T1_NUMVBNK-1:0]              t1_writeA;
  input [T1_NUMVBNK*BITSROW-1:0]      t1_addrA;
  input [T1_NUMVBNK*PHYWDTH-1:0]      t1_dinA;
  input [T1_NUMVBNK*PHYWDTH-1:0]      t1_bwA;

  input [T2_NUMVBNK-1:0]              t2_readB;
  input [T2_NUMVBNK*BITSROW-1:0]      t2_addrB;
  input  [T2_NUMVBNK*PHYWDTH-1:0]      t2_doutB;
  input [T2_NUMVBNK-1:0]              t2_writeA;
  input [T2_NUMVBNK*BITSROW-1:0]      t2_addrA;
  input [T2_NUMVBNK*PHYWDTH-1:0]      t2_dinA;
  input [T2_NUMVBNK*PHYWDTH-1:0]      t2_bwA;

  input [T3_NUMVBNK-1:0]              t3_readB;
  input [T3_NUMVBNK*BITSROW-1:0]      t3_addrB;
  input  [T3_NUMVBNK*T3_PHYWDTH-1:0]   t3_doutB;
  input [T3_NUMVBNK-1:0]              t3_writeA;
  input [T3_NUMVBNK*BITSROW-1:0]      t3_addrA;
  input [T3_NUMVBNK*T3_PHYWDTH-1:0]   t3_dinA;
  input [T3_NUMVBNK*T3_PHYWDTH-1:0]   t3_bwA;


  input [T4_NUMVBNK-1:0]              t4_readB;
  input [T4_NUMVBNK*BITCSRW-1:0]      t4_addrB;
  input  [T4_NUMVBNK*T4_PHYWDTH-1:0]   t4_doutB;
  input [T4_NUMVBNK-1:0]              t4_writeA;
  input [T4_NUMVBNK*BITCSRW-1:0]      t4_addrA;
  input [T4_NUMVBNK*T4_PHYWDTH-1:0]   t4_dinA;
  input [T4_NUMVBNK*T4_PHYWDTH-1:0]   t4_bwA;


  reg [BITADDR-1:0] read_addr [0:NUMRDPT-1];
  always_comb begin : rdxf
    integer ri;
    for (ri=0;ri<NUMRDPT;ri=ri+1) begin
      read_addr[ri] = rd_adr >> (ri*BITADDR);
    end
  end
  
  reg [BITADDR-1:0] write_addr [0:NUMWRPT-1];
  always_comb begin : wrxf
    integer wi;
    for (wi=0;wi<NUMWRPT;wi=wi+1) begin
      write_addr[wi] = wr_adr >> (wi*BITADDR);
    end
  end

  reg score_board_vld [0:NUMADDR-1];

  always @(posedge clk) begin
    integer wi, ri, ei;
    if (rst)
      for (ei=0;ei<NUMADDR;ei=ei+1)
        score_board_vld[ei] <= 1'b0;
    else begin
      for (ri=0;ri<NUMRDPT;ri=ri+1)
        if (read[ri] && rd_clr_0[ri])
          score_board_vld[read_addr[ri]] <= 1'b0;
      for (wi=0;wi<NUMWRPT;wi=wi+1)
        if (write[wi])
          score_board_vld[write_addr[wi]] <= 1'b1;
    end
  end

  genvar rd_gv;
  generate for(rd_gv=0;rd_gv<NUMRDPT;rd_gv=rd_gv+1) begin : rd_chk
    assert_rd_clr_invalid_entry: assert property (@(negedge clk) disable iff (rst || !ready) !(read[rd_gv] && rd_clr_0[rd_gv] && !score_board_vld[read_addr[rd_gv]]))
      else $display("[ERROR:memoir:%m:%0t] r%0d read clear invalid addr=0x%0x", $time, rd_gv, read_addr[rd_gv]);
  end
  endgenerate

  genvar wr_gv;
  generate for(wr_gv=0;wr_gv<NUMWRPT;wr_gv=wr_gv+1) begin : wr_chk
    assert_wr_vld_entry: assert property (@(negedge clk) disable iff (rst | !ready) !(write[wr_gv] & score_board_vld[write_addr[wr_gv]]))
      else $display("[ERROR:memoir:%m:%0t] w%0d write valid addr=0x%0x", $time, wr_gv, write_addr[wr_gv]);
  end
  endgenerate

endmodule    // algo_1r4w_a216_sva_wrap

