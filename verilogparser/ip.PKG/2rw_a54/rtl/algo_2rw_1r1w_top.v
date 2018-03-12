/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_2rw_1r1w_top (clk, rst, ready,
                          read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
			  t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMRWPT = 2;
  parameter NUMPBNK = 4; // NUMRWPT*NUMRWPT
  parameter BITPBNK = 2;

  parameter NUMWRDS = 4;      // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = NUMWRDS*(MEMWDTH);
  parameter NUMWROW = NUMSROW; // STACK Parameters
  parameter BITWROW = BITSROW;
  parameter NUMWBNK = 1;
  parameter BITWBNK = 0;
  parameter SRAM_DELAY = 2;
  parameter FLOPECC = 0;
  parameter FLOPCMD = 0;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1; //?

  input [NUMRWPT-1:0]                  read;
  input [NUMRWPT-1:0]                  write;
  input [NUMRWPT*BITADDR-1:0]          addr;
  input [NUMRWPT*WIDTH-1:0]            din;
  output [NUMRWPT-1:0]                 rd_vld;
  output [NUMRWPT*WIDTH-1:0]           rd_dout;
  output [NUMRWPT-1:0]                 rd_serr;
  output [NUMRWPT-1:0]                 rd_derr;
  output [BITPADR-1:0]                 rd_padr;

  output                               ready;
  input                                clk;
  input                                rst;

  output [NUMPBNK-1:0]                 t1_writeA;
  output [NUMPBNK*BITSROW-1:0]         t1_addrA;
  output [NUMPBNK*PHYWDTH-1:0]         t1_bwA;
  output [NUMPBNK*PHYWDTH-1:0]         t1_dinA;

  output [NUMPBNK-1:0]                 t1_readB;
  output [NUMPBNK*BITSROW-1:0]         t1_addrB;
  input [NUMPBNK*PHYWDTH-1:0]          t1_doutB;

`ifdef FORMAL
  wire [BITADDR-1:0]                   select_addr;
  assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
  assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

  wire [BITSROW-1:0]                   select_srow;
  np2_addr #(
             .NUMADDR (NUMADDR), .BITADDR (BITADDR),
             .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
             .NUMVROW (NUMSROW), .BITVROW (BITSROW))
  vrow_inst (.vbadr(), .vradr(select_srow), .vaddr(select_addr));
`else
  wire [BITADDR-1:0]                   select_addr = 0;
  wire [BITSROW-1:0]                   select_srow = 0;
`endif

wire [NUMRWPT-1:0] rd_fwrd_int;
wire [NUMRWPT*(BITPADR-1)-1:0] rd_padr_int;
reg [BITPADR-2:0] rd_padr_tmp [0:NUMRWPT-1];
reg [NUMRWPT*BITPADR-1:0] rd_padr;
integer padr_int;
always_comb begin
  rd_padr = 0;
  for (padr_int=0; padr_int<NUMRWPT; padr_int=padr_int+1) begin
    rd_padr_tmp[padr_int] = rd_padr_int << (padr_int*(BITPADR-1));
    rd_padr = rd_padr | ({rd_fwrd_int[padr_int],rd_padr_tmp[padr_int]} << (padr_int*BITPADR));
  end
end

  wire [NUMPBNK-1:0]                   t1_writeA_a1;
  wire [NUMPBNK*BITADDR-1:0]           t1_addrA_a1;
  wire [NUMPBNK*WIDTH-1:0]             t1_dinA_a1;
  wire [NUMPBNK-1:0]                   t1_readB_a1;
  wire [NUMPBNK*BITADDR-1:0]           t1_addrB_a1;
  reg [NUMPBNK*WIDTH-1:0]              t1_doutB_a1;
  reg [NUMPBNK-1:0]                    t1_fwrdB_a1;
  reg [NUMPBNK-1:0]                    t1_serrB_a1;
  reg [NUMPBNK-1:0]                    t1_derrB_a1;
  reg [NUMPBNK*(BITSROW+BITWRDS)-1:0]  t1_padrB_a1; //?

  generate if (1) begin: a1_loop

    algo_nrw_1r1w #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMRWPT (NUMRWPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITPADR (BITPADR-1),
                    .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK),
                    .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPECC), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    algo (.clk(clk), .rst(rst), .ready(ready),
          .read(read), .write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd(rd_fwrd_int), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr_int),
	       .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
          .t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1),
	       .select_addr(select_addr), .select_bit({BITWDTH{1'b0}}));
  end
  endgenerate

  wire                       t1_writeA_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  wire [BITSROW-1:0]         t1_addrA_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  wire                       t1_readB_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  wire [BITSROW-1:0]         t1_addrB_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  wire [WIDTH-1:0]           t1_doutB_a1_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  wire                       t1_fwrdB_a1_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  wire                       t1_serrB_a1_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  wire                       t1_derrB_a1_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  wire [BITSROW+BITWRDS-1:0] t1_padrB_a1_wire [0:NUMRWPT-1][0:NUMRWPT-1];

  genvar                     t1p, t1b;
  generate
    for (t1p=0; t1p<NUMRWPT; t1p=t1p+1) begin: t1p_loop
      for (t1b=0; t1b<NUMRWPT; t1b=t1b+1) begin: t1b_loop
        wire t1_writeA_a1_wire = t1_writeA_a1 >> (t1p*NUMRWPT+t1b);
        wire [BITADDR-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> ((t1p*NUMRWPT+t1b)*BITADDR);
        wire [WIDTH-1:0]   t1_dinA_a1_wire = t1_dinA_a1 >> ((t1p*NUMRWPT+t1b)*WIDTH);
        wire               t1_readB_a1_wire = t1_readB_a1 >> (t1p*NUMRWPT+t1b);
        wire [BITADDR-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> ((t1p*NUMRWPT+t1b)*BITADDR);
        
        wire [NUMWRDS*MEMWDTH-1:0] t1_doutB_wire = t1_doutB >> ((t1p*NUMRWPT+t1b)*PHYWDTH);

        wire                       mem_write_wire;
        wire [BITSROW-1:0]         mem_wr_adr_wire;
        wire [NUMWRDS*MEMWDTH-1:0] mem_bw_wire;
        wire [NUMWRDS*MEMWDTH-1:0] mem_din_wire;
        wire                       mem_read_wire;
        wire [BITSROW-1:0]         mem_rd_adr_wire;
        wire [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_wire;
        wire                       mem_rd_fwrd_wire;
        wire                       mem_rd_serr_wire;
        wire                       mem_rd_derr_wire;
        wire [(BITWBNK+BITWROW)-1:0] mem_rd_padr_wire;

        if (1) begin: align_loop
          infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (NUMWRDS==1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .ENAPADR (1),
                                 .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                                 .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITWBNK+BITWROW),
                                 .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (0))
          infra (.write(t1_writeA_a1_wire), .wr_adr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
                 .read(t1_readB_a1_wire), .rd_adr(t1_addrB_a1_wire), .rd_dout(t1_doutB_a1_wire[t1p][t1b]),
                 .rd_fwrd(t1_fwrdB_a1_wire[t1p][t1b]), .rd_serr(t1_serrB_a1_wire[t1p][t1b]), .rd_derr(t1_derrB_a1_wire[t1p][t1b]), .rd_padr(t1_padrB_a1_wire[t1p][t1b]),
                 .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
                 .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_addr));
        end
        
        if (1) begin: stack_loop
          infra_stack_1r1w #(.WIDTH (NUMWRDS*MEMWDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                             .NUMWROW (NUMWROW), .BITWROW (BITWROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                             .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (0))
          infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
                 .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
                 .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
                 .mem_write (t1_writeA_wire[t1p][t1b]), .mem_wr_adr(t1_addrA_wire[t1p][t1b]), .mem_bw (t1_bwA_wire[t1p][t1b]), .mem_din (t1_dinA_wire[t1p][t1b]),
                 .mem_read (t1_readB_wire[t1p][t1b]), .mem_rd_adr(t1_addrB_wire[t1p][t1b]), .mem_rd_dout (t1_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_srow));
        end
      end // block: t1b_loop
    end // block: t1p_loop
  endgenerate

  reg [NUMPBNK-1:0] t1_writeA;
  reg [NUMPBNK*BITSROW-1:0] t1_addrA;
  reg [NUMPBNK*PHYWDTH-1:0] t1_bwA;
  reg [NUMPBNK*PHYWDTH-1:0] t1_dinA;
  reg [NUMPBNK-1:0]         t1_readB;
  reg [NUMPBNK*BITSROW-1:0] t1_addrB;
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
    for (t1p_int=0; t1p_int<NUMRWPT; t1p_int=t1p_int+1) begin
      for (t1b_int=0; t1b_int<NUMRWPT; t1b_int=t1b_int+1) begin
        t1_writeA = t1_writeA | (t1_writeA_wire[t1p_int][t1b_int] << (t1p_int*NUMRWPT+t1b_int));
        t1_addrA = t1_addrA | (t1_addrA_wire[t1p_int][t1b_int] << ((t1p_int*NUMRWPT+t1b_int)*BITSROW));
        t1_bwA = t1_bwA | (t1_bwA_wire[t1p_int][t1b_int] << ((t1p_int*NUMRWPT+t1b_int)*PHYWDTH));
        t1_dinA = t1_dinA | (t1_dinA_wire[t1p_int][t1b_int] << ((t1p_int*NUMRWPT+t1b_int)*PHYWDTH));
        t1_readB = t1_readB | (t1_readB_wire[t1p_int][t1b_int] << (t1p_int*NUMRWPT+t1b_int));
        t1_addrB = t1_addrB | (t1_addrB_wire[t1p_int][t1b_int] << ((t1p_int*NUMRWPT+t1b_int)*BITSROW));
        t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1p_int][t1b_int] << ((t1p_int*NUMRWPT+t1b_int)*WIDTH));
        t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[t1p_int][t1b_int] << (t1p_int*NUMRWPT+t1b_int));
        t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1p_int][t1b_int] << (t1p_int*NUMRWPT+t1b_int));
        t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1p_int][t1b_int] << (t1p_int*NUMRWPT+t1b_int));
        t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1p_int][t1b_int] << ((t1p_int*NUMRWPT+t1b_int)*(BITSROW+BITWRDS)));
      end
    end
  end

endmodule // algo_2rw_1r1w_top

