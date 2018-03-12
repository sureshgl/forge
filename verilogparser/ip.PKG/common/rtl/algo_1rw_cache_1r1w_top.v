/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * 
 * */

module algo_1rw_cache_1r1w_top (clk, rst, ready,
                                read, write, flush, invld, sidx, ucach, ucofst, ucsize, ucpfx, sqin, addr, din, byin, rd_vld, rd_hit, rd_sqout, rd_dout, rd_attr, pf_stall,
			                    t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_serrB,
			                    t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_serrB,
			                    t3_readA, t3_writeA, t3_ucachA, t3_ucofstA, t3_ucsizeA, t3_ucpfxA, t3_sqinA, t3_addrA, t3_dinA, t3_vldA, t3_sqoutA, t3_doutA, t3_block, t3_attrA, t3_stall);

  parameter BITWDTH = 3;
  parameter WIDTH = 8;
  parameter BYTWDTH = WIDTH/8;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 5;
  parameter NUMRWPT = 1;
  parameter NUMSEQN = 16;
  parameter BITSEQN = 4;
  parameter NUMBEAT = 2;
  parameter BITBEAT = 1;
  parameter NUMADDR = 256;
  parameter BITADDR = 8;
  parameter NUMVROW = 16; 
  parameter BITVROW = 4;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 4;
  parameter FLOPECC = 0;
  parameter FLOPCMD = 0;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;
  parameter BITXATR = 3;
  parameter BITBYTS = 5;
  parameter BITXSIZ = 8;
  parameter BITUOFS = 5;
  parameter BITUSIZ = 8;
  parameter BITUCPF = 2;

  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = NUMWRDS*(MEMWDTH);
  parameter BITVTAG = BITVROW-BITBEAT;
  parameter BITDTAG = BITADDR-BITVROW;
  parameter BITTAGW = BITDTAG+BITWRDS+2;

  input [NUMRWPT-1:0]                  read;
  input [NUMRWPT-1:0]                  write;
  input [NUMRWPT-1:0]                  flush;
  input [NUMRWPT-1:0]                  invld;
  input [NUMRWPT-1:0]                  sidx;
  input [NUMRWPT-1:0]                  ucach;
  input [NUMRWPT*BITUOFS-1:0]          ucofst;
  input [NUMRWPT*BITXSIZ-1:0]          ucsize;
  input [NUMRWPT*BITUCPF-1:0]          ucpfx;
  input [NUMRWPT*BITSEQN-1:0]          sqin;
  input [NUMRWPT*BITADDR-1:0]          addr;
  input [NUMRWPT*BYTWDTH-1:0]          byin;
  input [NUMRWPT*WIDTH-1:0]            din;
  output [NUMRWPT-1:0]                 rd_vld;
  output [NUMRWPT-1:0]                 rd_hit;
  output [NUMRWPT*BITSEQN-1:0]         rd_sqout;
  output [NUMRWPT*WIDTH-1:0]           rd_dout;
  output [NUMRWPT*BITXATR-1:0]         rd_attr;
  output                               pf_stall; 

  output [NUMRWPT-1:0]                 t1_writeA;
  output [NUMRWPT*BITVTAG-1:0]         t1_addrA;
  output [NUMRWPT*NUMWRDS*BITTAGW-1:0] t1_dinA;
  output [NUMRWPT-1:0]                 t1_readB;
  output [NUMRWPT*BITVTAG-1:0]         t1_addrB;
  input [NUMRWPT*NUMWRDS*BITTAGW-1:0]  t1_doutB;
  input [NUMRWPT-1:0]                  t1_serrB;

  output [NUMRWPT-1:0]                 t2_writeA;
  output [NUMRWPT*BITVROW-1:0]         t2_addrA;
  output [NUMRWPT*NUMWRDS*WIDTH-1:0]   t2_dinA;
  output [NUMRWPT-1:0]                 t2_readB;
  output [NUMRWPT*BITVROW-1:0]         t2_addrB;
  input [NUMRWPT*NUMWRDS*WIDTH-1:0]    t2_doutB;
  input [NUMRWPT-1:0]                  t2_serrB;
  
  output [NUMRWPT-1:0]                 t3_readA;
  output [NUMRWPT-1:0]                 t3_writeA;
  output [NUMRWPT-1:0]                 t3_ucachA;
  output [NUMRWPT*BITBYTS-1:0]         t3_ucofstA;
  output[NUMRWPT*BITXSIZ-1:0]          t3_ucsizeA;
  output [NUMRWPT*BITUCPF-1:0]         t3_ucpfxA;
  output [NUMRWPT*BITSEQN-1:0]         t3_sqinA;
  output [NUMRWPT*BITADDR-1:0]         t3_addrA;
  output [NUMRWPT*WIDTH-1:0]           t3_dinA;
  input [NUMRWPT-1:0]                  t3_vldA;
  input [NUMRWPT*BITSEQN-1:0]          t3_sqoutA;
  input [NUMRWPT*WIDTH-1:0]            t3_doutA;

  input                                t3_block;
  input [BITXATR-1:0]                  t3_attrA;
  output                               t3_stall;

  output                               ready;
  input                                clk;
  input                                rst;

`ifdef FORMAL
  wire [BITADDR-1:0] select_addr;
  wire [BITWDTH-1:0] select_bit;
  assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
  assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
  assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
  assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

  wire [BITVROW-1:0] select_vrow = select_addr;
`else
  wire [BITADDR-1:0] select_addr = 0;
  wire [BITVROW-1:0] select_vrow = 0;
`endif

  wire [NUMRWPT-1:0]                   t1_writeA_a1;
  wire [NUMRWPT*BITVTAG-1:0]           t1_addrA_a1;
  wire [NUMRWPT*NUMWRDS*BITTAGW-1:0]   t1_dinA_a1;
  wire [NUMRWPT-1:0]                   t1_readB_a1;
  wire [NUMRWPT*BITVTAG-1:0]           t1_addrB_a1;
  reg [NUMRWPT*NUMWRDS*BITTAGW-1:0]    t1_doutB_a1;

  generate if (1) begin: a1_loop

    algo_nrw_cache_1r1w #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMRWPT (NUMRWPT), .BITSEQN (BITSEQN), 
                          .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                          .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS),
                          .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT),
                          .BITUOFS (BITBYTS), .BITUSIZ (BITXSIZ), .BITXATR (BITXATR))
      algo (.clk(clk), .rst(rst), .ready(ready),
            .read(read), .write(write), .flush(flush), .invld(invld), .sidx(sidx), .ucach(ucach), .sqin(sqin), .din(din), .byin(byin), .addr(addr), .ucofst(ucofst), .ucsize (ucsize), .ucpfx(ucpfx),
            .rd_vld(rd_vld), .rd_hit(rd_hit), .rd_sqout(rd_sqout), .rd_dout(rd_dout), .rd_attr(rd_attr), .pf_stall(pf_stall),
  	        .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB), .t1_serrB(t1_serrB),
  	        .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB), .t2_serrB(t2_serrB),
  	        .t3_readA(t3_readA), .t3_writeA(t3_writeA), .t3_ucachA(t3_ucachA), .t3_ucofstA(t3_ucofstA), .t3_ucsizeA(t3_ucsizeA), .t3_ucpfxA(t3_ucpfxA), .t3_dinA(t3_dinA), .t3_sqinA(t3_sqinA), .t3_addrA(t3_addrA), 
            .t3_vldA(t3_vldA), .t3_sqoutA(t3_sqoutA), .t3_doutA(t3_doutA), .t3_block(t3_block), .t3_attrA(t3_attrA), .t3_stall(t3_stall),
  	        .select_addr(select_addr), .select_bit(select_bit));

  end
  endgenerate
endmodule // algo_1rw_cache_1r1w_top

