/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_2ru_a44_top (clk, rst, ready,
                          read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
			              t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMRUPT = 2;
  parameter NUMPBNK = 4; // NUMRUPT*NUMRUPT
  parameter BITPBNK = 2;

  parameter NUMWRDS = 8;      // ALIGN Parameters
  parameter BITWRDS = 3;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter MEMWDTH = ENAPAR ? NUMWRDS*WIDTH+1 : ENAECC ? NUMWRDS*WIDTH+ECCWDTH : NUMWRDS*WIDTH;
  parameter PHYWDTH = MEMWDTH; 
  parameter NUMWROW = NUMVROW; // STACK Parameters
  parameter BITWROW = BITVROW;
  parameter NUMWBNK = 1;
  parameter BITWBNK = 0;
  parameter SRAM_DELAY = 2;
  parameter UPD_DELAY = 2;
  parameter FLOPECC = 0;
  parameter FLOPCMD = 0;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  parameter BITPADR = BITPBNK+BITVROW+BITWRDS+1; //?

  input [NUMRUPT-1:0]                  read;
  input [NUMRUPT-1:0]                  write;
  input [NUMRUPT*BITADDR-1:0]          addr;
  input [NUMRUPT*WIDTH-1:0]            din;
  output [NUMRUPT-1:0]                 rd_vld;
  output [NUMRUPT*WIDTH-1:0]           rd_dout;
  output [NUMRUPT-1:0]                 rd_serr;
  output [NUMRUPT-1:0]                 rd_derr;
  output [NUMRUPT*BITPADR-1:0]         rd_padr;

  output                               ready;
  input                                clk;
  input                                rst;

  output [NUMPBNK-1:0]                 t1_writeA;
  output [NUMPBNK*BITVROW-1:0]         t1_addrA;
  output [NUMPBNK*PHYWDTH-1:0]         t1_bwA;
  output [NUMPBNK*PHYWDTH-1:0]         t1_dinA;

  output [NUMPBNK-1:0]                 t1_readB;
  output [NUMPBNK*BITVROW-1:0]         t1_addrB;
  input [NUMPBNK*PHYWDTH-1:0]          t1_doutB;

`ifdef FORMAL
  wire [BITADDR-1:0]                   select_addr;
  assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
  assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

  wire [BITVROW-1:0]                   select_vrow;
  np2_addr #(
             .NUMADDR (NUMADDR), .BITADDR (BITADDR),
             .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
             .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  vrow_inst (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));
`else
  wire [BITADDR-1:0]                   select_addr = 0;
  wire [BITVROW-1:0]                   select_vrow = 0;
`endif

wire [NUMRUPT-1:0] rd_fwrd_int;
wire [NUMRUPT*(BITPADR-1)-1:0] rd_padr_int;
reg [BITPADR-2:0] rd_padr_tmp [0:NUMRUPT-1];
reg [NUMRUPT*BITPADR-1:0] rd_padr;
integer padr_int;
always_comb begin
  rd_padr = 0;
  for (padr_int=0; padr_int<NUMRUPT; padr_int=padr_int+1) begin
    rd_padr_tmp[padr_int] = rd_padr_int << (padr_int*(BITPADR-1));
    rd_padr = rd_padr | ({rd_fwrd_int[padr_int],rd_padr_tmp[padr_int]} << (padr_int*BITPADR));
  end
end

  wire [NUMPBNK-1:0]                   t1_writeA_a1;
  wire [NUMPBNK*BITVROW-1:0]           t1_addrA_a1;
  wire [NUMPBNK*NUMWRDS*WIDTH-1:0]     t1_dinA_a1;
  wire [NUMPBNK-1:0]                   t1_readB_a1;
  wire [NUMPBNK*BITVROW-1:0]           t1_addrB_a1;
  reg [NUMPBNK*NUMWRDS*WIDTH-1:0]      t1_doutB_a1;
  reg [NUMPBNK-1:0]                    t1_fwrdB_a1;
  reg [NUMPBNK-1:0]                    t1_serrB_a1;
  reg [NUMPBNK-1:0]                    t1_derrB_a1;
  reg [NUMPBNK*(BITPADR-BITPBNK-BITWRDS-1)-1:0] t1_padrB_a1;

  generate if (1) begin: a1_loop

    algo_nru_1r1w #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMRUPT (NUMRUPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITPADR (BITPADR-1),
                    .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS),
                    .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK),
                    .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPECC), .UPD_DELAY (UPD_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    algo (.clk(clk), .rst(rst), .ready(ready),
          .read(read), .write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd(rd_fwrd_int), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr_int),
	      .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
          .t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1),
	      .select_addr(select_addr));
  end
  endgenerate

  wire               t1_writeA_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  wire [BITVROW-1:0] t1_addrA_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  wire [MEMWDTH-1:0] t1_bwA_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  wire [MEMWDTH-1:0] t1_dinA_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  wire               t1_readB_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  wire [BITVROW-1:0] t1_addrB_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  wire [MEMWDTH-1:0] t1_doutB_a1_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  wire               t1_fwrdB_a1_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  wire               t1_serrB_a1_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  wire               t1_derrB_a1_wire [0:NUMRUPT-1][0:NUMRUPT-1];
  wire [BITWBNK+BITWROW-1:0] t1_padrB_a1_wire [0:NUMRUPT-1][0:NUMRUPT-1];

  genvar                     t1p, t1b;
  generate
    for (t1p=0; t1p<NUMRUPT; t1p=t1p+1) begin: t1p_loop
      for (t1b=0; t1b<NUMRUPT; t1b=t1b+1) begin: t1b_loop
        wire t1_writeA_a1_wire = t1_writeA_a1 >> (t1p*NUMRUPT+t1b);
        wire [BITVROW-1:0]       t1_addrA_a1_wire = t1_addrA_a1 >> ((t1p*NUMRUPT+t1b)*BITVROW);
        wire [NUMWRDS*WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> ((t1p*NUMRUPT+t1b)*NUMWRDS*WIDTH);
        wire                     t1_readB_a1_wire = t1_readB_a1 >> (t1p*NUMRUPT+t1b);
        wire [BITVROW-1:0]       t1_addrB_a1_wire = t1_addrB_a1 >> ((t1p*NUMRUPT+t1b)*BITVROW);
        
        wire [MEMWDTH-1:0]       t1_doutB_wire = t1_doutB >> ((t1p*NUMRUPT+t1b)*PHYWDTH);

        wire                     mem_write_wire;
        wire [BITVROW-1:0]       mem_wr_adr_wire;
        wire [MEMWDTH-1:0]       mem_bw_wire;
        wire [MEMWDTH-1:0]       mem_din_wire;
        wire                     mem_read_wire;
        wire [BITVROW-1:0]       mem_rd_adr_wire;
        wire [MEMWDTH-1:0]       mem_rd_dout_wire;
        wire                     mem_rd_fwrd_wire;
        wire                     mem_rd_serr_wire;
        wire                     mem_rd_derr_wire;
        wire [(BITWBNK+BITWROW)-1:0] mem_rd_padr_wire;

        if (1) begin: align_loop
          infra_align_ecc_1r1w #(.WIDTH (NUMWRDS*WIDTH), .ENAPSDO (1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .ENAPADR (1),
                                 .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                                 .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITWBNK+BITWROW),
                                 .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (.write(t1_writeA_a1_wire), .wr_adr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
                 .read(t1_readB_a1_wire), .rd_adr(t1_addrB_a1_wire), .rd_dout(t1_doutB_a1_wire[t1p][t1b]),
                 .rd_fwrd(t1_fwrdB_a1_wire[t1p][t1b]), .rd_serr(t1_serrB_a1_wire[t1p][t1b]), .rd_derr(t1_derrB_a1_wire[t1p][t1b]), .rd_padr(t1_padrB_a1_wire[t1p][t1b]),
                 .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
                 .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
        end
        
        if (1) begin: stack_loop
          infra_stack_1r1w #(.WIDTH (MEMWDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                             .NUMWROW (NUMWROW), .BITWROW (BITWROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                             .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
          infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
                 .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
                 .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
                 .mem_write (t1_writeA_wire[t1p][t1b]), .mem_wr_adr(t1_addrA_wire[t1p][t1b]), .mem_bw (t1_bwA_wire[t1p][t1b]), .mem_din (t1_dinA_wire[t1p][t1b]),
                 .mem_read (t1_readB_wire[t1p][t1b]), .mem_rd_adr(t1_addrB_wire[t1p][t1b]), .mem_rd_dout (t1_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_vrow));
        end
      end // block: t1b_loop
    end // block: t1p_loop
  endgenerate

  reg [NUMPBNK-1:0] t1_writeA;
  reg [NUMPBNK*BITVROW-1:0] t1_addrA;
  reg [NUMPBNK*PHYWDTH-1:0] t1_bwA;
  reg [NUMPBNK*PHYWDTH-1:0] t1_dinA;
  reg [NUMPBNK-1:0]         t1_readB;
  reg [NUMPBNK*BITVROW-1:0] t1_addrB;
  integer                   t1p_int, t1b_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_bwA = 0;
    t1_dinA = 0;
    t1_readB = 0;
    t1_addrB = 0;
    t1_doutB_a1 = 0;
    t1_fwrdB_a1 = 0;
    t1_serrB_a1 = 0;
    t1_derrB_a1 = 0;
    t1_padrB_a1 = 0;
    for (t1p_int=0; t1p_int<NUMRUPT; t1p_int=t1p_int+1) begin
      for (t1b_int=0; t1b_int<NUMRUPT; t1b_int=t1b_int+1) begin
        t1_writeA = t1_writeA | (t1_writeA_wire[t1p_int][t1b_int] << (t1p_int*NUMRUPT+t1b_int));
        t1_addrA = t1_addrA | (t1_addrA_wire[t1p_int][t1b_int] << ((t1p_int*NUMRUPT+t1b_int)*BITVROW));
        t1_bwA = t1_bwA | (t1_bwA_wire[t1p_int][t1b_int] << ((t1p_int*NUMRUPT+t1b_int)*PHYWDTH));
        t1_dinA = t1_dinA | (t1_dinA_wire[t1p_int][t1b_int] << ((t1p_int*NUMRUPT+t1b_int)*PHYWDTH));
        t1_readB = t1_readB | (t1_readB_wire[t1p_int][t1b_int] << (t1p_int*NUMRUPT+t1b_int));
        t1_addrB = t1_addrB | (t1_addrB_wire[t1p_int][t1b_int] << ((t1p_int*NUMRUPT+t1b_int)*BITVROW));
        t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1p_int][t1b_int] << ((t1p_int*NUMRUPT+t1b_int)*MEMWDTH));
        t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[t1p_int][t1b_int] << (t1p_int*NUMRUPT+t1b_int));
        t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1p_int][t1b_int] << (t1p_int*NUMRUPT+t1b_int));
        t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1p_int][t1b_int] << (t1p_int*NUMRUPT+t1b_int));
        t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1p_int][t1b_int] << ((t1p_int*NUMRUPT+t1b_int)*BITVROW));
      end
    end
  end

endmodule // algo_2ru_a44_top

