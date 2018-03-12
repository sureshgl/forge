/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
module smp_driver (read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                   rw_read, rw_write, rw_addr, rw_din, rw_vld, rw_dout, rw_serr, rw_derr, rw_padr,
                   write, wr_adr, din,
                   cnt, ct_adr, ct_imm,
                   ac_read, ac_write, ac_addr, ac_din, ac_vld, ac_dout, ac_serr, ac_derr, ac_padr,
                   bisten, bread, brd_adr, bwrite, bwr_adr, bdin,
                   clk, ready, rst, refr);

parameter DEPTH = 32;
parameter BITADDR = 5;
parameter WIDTH   = 8;
parameter BITPADR = 16;

parameter NUMRDPT = 2;
parameter NUMRWPT = 0;
parameter NUMWRPT = 1;
parameter NUMCTPT = 0;
parameter NUMACPT = 0;

parameter MEM_DELAY = 0;

parameter BISTTST = 0;
parameter PSEUDOW = 0;
parameter TB_HALF_CLK_PER = 1000;

parameter REFRESH_M_IN_N_N_HF = 0;
parameter REFRESH_M_IN_N_N = 15;
parameter REFRESH_M_IN_N_M = 1;

parameter TB_VPD_DUMP_FILE = "dump.vpd";

parameter REFRESH = (REFRESH_M_IN_N_N > 0) ? 1 : 0;

parameter NUMMASK = 0;
parameter PTMASK1 = 0;
parameter PTMASK2 = 0;
parameter PTMASK3 = 0;
parameter PTMASK4 = 0;
parameter PTMASK5 = 0;
parameter PTMASK6 = 0;
parameter PTMASK7 = 0;
parameter PTMASK8 = 0;

output                       refr;

output [NUMRDPT-1:0]         read;
output [NUMRDPT*BITADDR-1:0] rd_adr;
input [NUMRDPT-1:0]          rd_vld;
input [NUMRDPT*WIDTH-1:0]    rd_dout; 
input [NUMRDPT-1:0]          rd_serr;
input [NUMRDPT-1:0]          rd_derr;
input [NUMRDPT*BITPADR-1:0]  rd_padr;

output [NUMRWPT-1:0]         rw_read;
output [NUMRWPT-1:0]         rw_write;
output [NUMRWPT*BITADDR-1:0] rw_addr;
output [NUMRWPT*WIDTH-1:0]   rw_din; 
input [NUMRWPT-1:0]          rw_vld;
input [NUMRWPT*WIDTH-1:0]    rw_dout; 
input [NUMRWPT-1:0]          rw_serr;
input [NUMRWPT-1:0]          rw_derr;
input [NUMRWPT*BITPADR-1:0]  rw_padr;

output [NUMWRPT-1:0]         write;
output [NUMWRPT*BITADDR-1:0] wr_adr;
output [NUMWRPT*WIDTH-1:0]   din; 

output [NUMCTPT-1:0]         cnt;
output [NUMCTPT*BITADDR-1:0] ct_adr;
output [NUMCTPT*WIDTH-1:0]   ct_imm; 

output [NUMACPT-1:0]         ac_read;
output [NUMACPT-1:0]         ac_write;
output [NUMACPT*BITADDR-1:0] ac_addr;
output [NUMACPT*WIDTH-1:0]   ac_din; 
input [NUMACPT-1:0]          ac_vld;
input [NUMACPT*WIDTH-1:0]    ac_dout; 
input [NUMACPT-1:0]          ac_serr;
input [NUMACPT-1:0]          ac_derr;
input [NUMACPT*BITPADR-1:0]  ac_padr;

output                       bisten;
output [NUMRDPT-1:0]         bread;
output [NUMRDPT*BITADDR-1:0] brd_adr;
output [NUMWRPT-1:0]         bwrite;
output [NUMWRPT*BITADDR-1:0] bwr_adr;
output [NUMWRPT*WIDTH-1:0]   bdin; 

output                       clk;
output                       rst;
input                        ready;

reg               read_wire [0:NUMRDPT-1];
reg [BITADDR-1:0] rd_adr_wire [0:NUMRDPT-1];
reg               rd_vld_wire [0:NUMRDPT-1];
reg [WIDTH-1:0]   rd_dout_wire [0:NUMRDPT-1]; 
reg               rd_serr_wire [0:NUMRDPT-1];
reg               rd_derr_wire [0:NUMRDPT-1];
reg [BITPADR-1:0] rd_padr_wire [0:NUMRDPT-1];

reg               rw_read_wire [0:NUMRWPT-1];
reg               rw_write_wire [0:NUMRWPT-1];
reg [BITADDR-1:0] rw_adr_wire [0:NUMRWPT-1];
reg [WIDTH-1:0]   rw_din_wire [0:NUMRWPT-1];
reg               rw_vld_wire [0:NUMRWPT-1];
reg [WIDTH-1:0]   rw_dout_wire [0:NUMRWPT-1]; 
reg               rw_serr_wire [0:NUMRWPT-1];
reg               rw_derr_wire [0:NUMRWPT-1];
reg [BITPADR-1:0] rw_padr_wire [0:NUMRWPT-1];

reg               write_wire [0:NUMWRPT-1];
reg [BITADDR-1:0] wr_adr_wire [0:NUMWRPT-1];
reg [WIDTH-1:0]   din_wire [0:NUMWRPT-1];

reg               cnt_wire [0:NUMCTPT-1];
reg [BITADDR-1:0] ct_adr_wire [0:NUMCTPT-1];
reg [WIDTH-1:0]   imm_wire [0:NUMCTPT-1];

reg               ac_read_wire [0:NUMACPT-1];
reg               ac_write_wire [0:NUMACPT-1];
reg [BITADDR-1:0] ac_adr_wire [0:NUMACPT-1];
reg [WIDTH-1:0]   ac_din_wire [0:NUMACPT-1];
reg               ac_vld_wire [0:NUMACPT-1];
reg [WIDTH-1:0]   ac_dout_wire [0:NUMACPT-1]; 
reg               ac_serr_wire [0:NUMACPT-1];
reg               ac_derr_wire [0:NUMACPT-1];
reg [BITPADR-1:0] ac_padr_wire [0:NUMACPT-1];

reg               bread_wire [0:NUMRDPT-1];
reg [BITADDR-1:0] brd_adr_wire [0:NUMRDPT-1];
reg               bwrite_wire [0:NUMWRPT-1];
reg [BITADDR-1:0] bwr_adr_wire [0:NUMWRPT-1];
reg [WIDTH-1:0]   bdin_wire [0:NUMWRPT-1];

reg rst;

string name = "testbench.drvr";

integer init_int;
reg clk;
initial begin
  clk = 0;
  for (init_int=0; init_int<NUMRDPT; init_int=init_int+1)
    read_wire[init_int] = 0;
  for (init_int=0; init_int<NUMRWPT; init_int=init_int+1) begin
    rw_read_wire[init_int] = 0;
    rw_write_wire[init_int] = 0;
  end
  for (init_int=0; init_int<NUMWRPT; init_int=init_int+1)
    write_wire[init_int] = 0;
  for (init_int=0; init_int<NUMCTPT; init_int=init_int+1)
    cnt_wire[init_int] = 0;
  for (init_int=0; init_int<NUMACPT; init_int=init_int+1) begin
    ac_read_wire[init_int] = 0;
    ac_write_wire[init_int] = 0;
  end
  for (init_int=0; init_int<NUMRDPT; init_int=init_int+1)
    bread_wire[init_int] = 0;
  for (init_int=0; init_int<NUMWRPT; init_int=init_int+1)
    bwrite_wire[init_int] = 0;
  forever #TB_HALF_CLK_PER clk = !clk;
end

reg [WIDTH-1:0] memchk [0:DEPTH-1];
reg [WIDTH:0] cnt_temp [0:NUMCTPT-1];
integer ct_int, ctp_int;
always_comb
  for (ct_int=0; ct_int<NUMCTPT; ct_int=ct_int+1) begin
    cnt_temp[ct_int] = memchk[ct_adr_wire[ct_int]] + imm_wire[ct_int];
    cnt_temp[ct_int] = {|cnt_temp[ct_int][WIDTH:WIDTH-1],cnt_temp[ct_int][WIDTH-2:0]};
    for (ctp_int=0; ctp_int<NUMCTPT; ctp_int=ctp_int+1)
      if ((ct_int != ctp_int) && (cnt_wire[ctp_int] && (ct_adr_wire[ctp_int] == ct_adr_wire[ct_int]))) begin
        cnt_temp[ct_int] = cnt_temp[ct_int] + imm_wire[ctp_int];
        cnt_temp[ct_int] = {|cnt_temp[ct_int][WIDTH:WIDTH-1],cnt_temp[ct_int][WIDTH-2:0]};
      end
  end

integer wr_int;
always @(posedge clk) begin
  for (wr_int=0; wr_int<NUMRWPT; wr_int=wr_int+1)
    if (rw_write_wire[wr_int]) 
      memchk[rw_adr_wire[wr_int]] <= rw_din_wire[wr_int];
  for (wr_int=0; wr_int<NUMWRPT; wr_int=wr_int+1)
    if (write_wire[wr_int]) 
      memchk[wr_adr_wire[wr_int]] <= din_wire[wr_int];
  for (wr_int=0; wr_int<NUMCTPT; wr_int=wr_int+1)
    if (cnt_wire[wr_int]) 
      memchk[ct_adr_wire[wr_int]] <= cnt_temp[wr_int];
  for (wr_int=0; wr_int<NUMACPT; wr_int=wr_int+1)
    if (ac_write_wire[wr_int]) 
      memchk[ac_adr_wire[wr_int]] <= ac_din_wire[wr_int];
  for (wr_int=0; wr_int<NUMWRPT; wr_int=wr_int+1)
    if (bwrite_wire[wr_int]) 
      memchk[bwr_adr_wire[wr_int]] <= bdin_wire[wr_int];
end

reg              read_reg    [0:NUMRDPT-1][0:MEM_DELAY-1];
reg              ac_read_reg [0:NUMACPT-1][0:MEM_DELAY-1];
reg              rw_read_reg [0:NUMRWPT-1][0:MEM_DELAY-1];
reg              bread_reg    [0:NUMRDPT-1][0:MEM_DELAY-1];
reg [WIDTH-1:0]  rd_dout_reg [0:NUMRDPT-1][0:MEM_DELAY-1];
reg [WIDTH-1:0]  rw_dout_reg [0:NUMRWPT-1][0:MEM_DELAY-1];
reg [WIDTH-1:0]  ac_dout_reg [0:NUMACPT-1][0:MEM_DELAY-1];
reg [WIDTH-1:0]  brd_dout_reg [0:NUMRDPT-1][0:MEM_DELAY-1];
integer rdel_int;
integer mdel_int;
always @(posedge clk)
  for (mdel_int=0; mdel_int<MEM_DELAY; mdel_int=mdel_int+1)
    if (mdel_int>0) begin
      for (rdel_int=0; rdel_int<NUMRDPT; rdel_int=rdel_int+1) begin
        rd_dout_reg[rdel_int][mdel_int] <= rd_dout_reg[rdel_int][mdel_int-1];
        read_reg[rdel_int][mdel_int] <= read_reg[rdel_int][mdel_int-1];
      end
      for (rdel_int=0; rdel_int<NUMRWPT; rdel_int=rdel_int+1) begin
        rw_dout_reg[rdel_int][mdel_int] <= rw_dout_reg[rdel_int][mdel_int-1];
        rw_read_reg[rdel_int][mdel_int] <= rw_read_reg[rdel_int][mdel_int-1];
      end
      for (rdel_int=0; rdel_int<NUMACPT; rdel_int=rdel_int+1) begin
          ac_dout_reg[rdel_int][mdel_int] <= ac_dout_reg[rdel_int][mdel_int-1];
          ac_read_reg[rdel_int][mdel_int] <= ac_read_reg[rdel_int][mdel_int-1];
      end
      for (rdel_int=0; rdel_int<NUMRDPT; rdel_int=rdel_int+1) begin
        brd_dout_reg[rdel_int][mdel_int] <= brd_dout_reg[rdel_int][mdel_int-1];
        bread_reg[rdel_int][mdel_int] <= bread_reg[rdel_int][mdel_int-1];
      end
    end else begin
      for (rdel_int=0; rdel_int<NUMRDPT; rdel_int=rdel_int+1) begin
        read_reg[rdel_int][mdel_int] <= read_wire[rdel_int];
        rd_dout_reg[rdel_int][mdel_int] <= read_wire[rdel_int] ? memchk[rd_adr_wire[rdel_int]] : {WIDTH{1'bx}};
      end
      for (rdel_int=0; rdel_int<NUMRWPT; rdel_int=rdel_int+1) begin
          rw_read_reg[rdel_int][mdel_int] <= rw_read_wire[rdel_int];
          rw_dout_reg[rdel_int][mdel_int] <= rw_read_wire[rdel_int] ? memchk[rw_adr_wire[rdel_int]] : {WIDTH{1'bx}};
      end
      for (rdel_int=0; rdel_int<NUMACPT; rdel_int=rdel_int+1) begin
        ac_read_reg[rdel_int][mdel_int] <= ac_read_wire[rdel_int];
        ac_dout_reg[rdel_int][mdel_int] <= ac_read_wire[rdel_int] ? memchk[ac_adr_wire[rdel_int]] : {WIDTH{1'bx}};
      end
      for (rdel_int=0; rdel_int<NUMRDPT; rdel_int=rdel_int+1) begin
        bread_reg[rdel_int][mdel_int] <= bread_wire[rdel_int];
        brd_dout_reg[rdel_int][mdel_int] <= bread_wire[rdel_int] ? memchk[brd_adr_wire[rdel_int]] : {WIDTH{1'bx}};
      end
    end

integer chk_int;
reg [NUMRDPT-1:0] match_rd;
reg [NUMRWPT-1:0] match_rw;
reg [NUMACPT-1:0] match_ac;
reg [NUMRDPT-1:0] match_br;
always_comb begin
  for (chk_int=0; chk_int<NUMRDPT; chk_int=chk_int+1)
    if (MEM_DELAY)
      match_rd[chk_int] = !read_reg[chk_int][MEM_DELAY-1] || ((rd_vld_wire[chk_int] === read_reg[chk_int][MEM_DELAY-1]) &&
					                       (rd_dout_wire[chk_int] === rd_dout_reg[chk_int][MEM_DELAY-1])); 
    else
      match_rd[chk_int] = !read_wire[chk_int] || ((rd_vld_wire[chk_int] === read_wire[chk_int]) &&
					          (rd_dout_wire[chk_int] === (read_wire[chk_int] ? memchk[rd_adr_wire[chk_int]] : {WIDTH{1'bx}})));
  for (chk_int=0; chk_int<NUMRWPT; chk_int=chk_int+1)
    match_rw[chk_int] = !rw_read_reg[chk_int][MEM_DELAY-1] || ((rw_vld_wire[chk_int] === rw_read_reg[chk_int][MEM_DELAY-1]) &&
                                                               (rw_dout_wire[chk_int] === rw_dout_reg[chk_int][MEM_DELAY-1])); 
  for (chk_int=0; chk_int<NUMACPT; chk_int=chk_int+1)
    match_ac[chk_int] = !ac_read_reg[chk_int][MEM_DELAY-1] || ((ac_vld_wire[chk_int] === ac_read_reg[chk_int][MEM_DELAY-1]) &&
                                                               (ac_dout_wire[chk_int] === ac_dout_reg[chk_int][MEM_DELAY-1])); 
  for (chk_int=0; chk_int<NUMRDPT; chk_int=chk_int+1)
    if (MEM_DELAY)
      match_br[chk_int] = !bread_reg[chk_int][MEM_DELAY-1] || ((rd_vld_wire[chk_int] === bread_reg[chk_int][MEM_DELAY-1]) &&
					                       (rd_dout_wire[chk_int] === brd_dout_reg[chk_int][MEM_DELAY-1])); 
    else
      match_br[chk_int] = !bread_wire[chk_int] || ((rd_vld_wire[chk_int] === bread_wire[chk_int]) &&
					           (rd_dout_wire[chk_int] === (bread_wire[chk_int] ? memchk[brd_adr_wire[chk_int]] : {WIDTH{1'bx}})));
end

integer stp_int;
reg stop_sim = 0;
always @(posedge clk) begin
  for (stp_int=0; stp_int<NUMRDPT; stp_int=stp_int+1)
    if (!match_rd[stp_int]) begin
//      if (MEM_DELAY)
//        `ERROR($psprintf("memory rd check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, rd_dout_reg[stp_int][MEM_DELAY-1], rd_dout_wire[stp_int]))
//      else 
        `ERROR($psprintf("memory rd check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, read_wire[stp_int] ? memchk[rd_adr_wire[stp_int]] : {WIDTH{1'bx}}, rd_dout_wire[stp_int]))
      stop_sim <= 1'b1;
    end
  for (stp_int=0; stp_int<NUMRWPT; stp_int=stp_int+1)
    if (!match_rw[stp_int]) begin
      `ERROR($psprintf("memory rw check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, rw_dout_reg[stp_int][MEM_DELAY-1], rw_dout_wire[stp_int]))
      stop_sim <= 1'b1;
    end
  for (stp_int=0; stp_int<NUMACPT; stp_int=stp_int+1)
    if (!match_ac[stp_int]) begin
      `ERROR($psprintf("memory ac check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, ac_dout_reg[stp_int][MEM_DELAY-1], ac_dout_wire[stp_int]))
      stop_sim <= 1'b1;
    end
  for (stp_int=0; stp_int<NUMRDPT; stp_int=stp_int+1)
    if (!match_br[stp_int]) begin
//      if (MEM_DELAY)
//        `ERROR($psprintf("memory bist rd check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, brd_dout_reg[stp_int][MEM_DELAY-1], rd_dout_wire[stp_int]))
//      else 
        `ERROR($psprintf("memory rd check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, bread_wire[stp_int] ? memchk[brd_adr_wire[stp_int]] : {WIDTH{1'bx}}, rd_dout_wire[stp_int]))
      stop_sim <= 1'b1;
    end
  if (stop_sim) $finish;
end

reg matchflag;
always @(posedge clk)
  if (rst)
    matchflag <= 1'b0;
  else
    matchflag <= matchflag || ((NUMRDPT>0) && ~&match_rd) || ((NUMRWPT>0) && ~&match_rw) || ((NUMACPT>0) && ~&match_ac) || ((NUMRDPT>0) && ~&match_br);

reg [31:0] refr_cnt;
reg refr_half;
always @(posedge clk)
  if (rst) begin
    refr_cnt <= 0;
    refr_half <= 0;
  end else if (|refr_cnt)
    refr_cnt <= refr_cnt - 1;
  else if (~(|refr_cnt)) begin
    refr_cnt <= REFRESH_M_IN_N_N + (REFRESH_M_IN_N_N_HF && refr_half) - 1;
    refr_half <= !refr_half;
  end

assign refr = (REFRESH && ready && (refr_cnt < REFRESH_M_IN_N_M));

reg [NUMRDPT-1:0]         read;
reg [NUMRDPT*BITADDR-1:0] rd_adr;

reg [NUMRWPT-1:0]         rw_read;
reg [NUMRWPT-1:0]         rw_write;
reg [NUMRWPT*BITADDR-1:0] rw_addr;
reg [NUMRWPT*WIDTH-1:0]   rw_din; 

reg [NUMWRPT-1:0]         write;
reg [NUMWRPT*BITADDR-1:0] wr_adr;
reg [NUMWRPT*WIDTH-1:0]   din; 

reg [NUMCTPT-1:0]         cnt;
reg [NUMCTPT*BITADDR-1:0] ct_adr;
reg [NUMCTPT*WIDTH-1:0]   ct_imm; 

reg [NUMACPT-1:0]         ac_read;
reg [NUMACPT-1:0]         ac_write;
reg [NUMACPT*BITADDR-1:0] ac_addr;
reg [NUMACPT*WIDTH-1:0]   ac_din; 

reg                       bisten;
reg [NUMRDPT-1:0]         bread;
reg [NUMRDPT*BITADDR-1:0] brd_adr;
reg [NUMWRPT-1:0]         bwrite;
reg [NUMWRPT*BITADDR-1:0] bwr_adr;
reg [NUMWRPT*WIDTH-1:0]   bdin; 

integer bus_int;
always_comb begin
  read = 0;
  rd_adr = 0;
  for (bus_int=0; bus_int<NUMRDPT; bus_int=bus_int+1) begin
    read = read | (read_wire[bus_int] << bus_int);
    rd_adr = rd_adr | (rd_adr_wire[bus_int] << (bus_int*BITADDR));
    rd_vld_wire[bus_int] = rd_vld >> bus_int;
    rd_dout_wire[bus_int] = rd_dout >> (bus_int*WIDTH);
    rd_serr_wire[bus_int] = rd_serr >> bus_int;
    rd_derr_wire[bus_int] = rd_derr >> bus_int;
    rd_padr_wire[bus_int] = rd_padr >> (bus_int*BITPADR);
  end
  rw_read = 0;
  rw_write = 0;
  rw_addr = 0;
  rw_din = 0;
  for (bus_int=0; bus_int<NUMRWPT; bus_int=bus_int+1) begin
    rw_read = rw_read | (rw_read_wire[bus_int] << bus_int);
    rw_write = rw_write | (rw_write_wire[bus_int] << bus_int);
    rw_addr = rw_addr | (rw_adr_wire[bus_int] << (bus_int*BITADDR));
    rw_din = rw_din | (rw_din_wire[bus_int] << (bus_int*WIDTH));
    rw_vld_wire[bus_int] = rw_vld >> bus_int;
    rw_dout_wire[bus_int] = rw_dout >> (bus_int*WIDTH);
    rw_serr_wire[bus_int] = rw_serr >> bus_int;
    rw_derr_wire[bus_int] = rw_derr >> bus_int;
    rw_padr_wire[bus_int] = rw_padr >> (bus_int*BITPADR);
  end
  write = 0;
  wr_adr = 0;
  din = 0;
  for (bus_int=0; bus_int<NUMWRPT; bus_int=bus_int+1) begin
    write = write | (write_wire[bus_int] << bus_int);
    wr_adr = wr_adr | (wr_adr_wire[bus_int] << (bus_int*BITADDR));
    din = din | (din_wire[bus_int] << (bus_int*WIDTH));
  end
  cnt = 0;
  ct_adr = 0;
  ct_imm = 0;
  for (bus_int=0; bus_int<NUMCTPT; bus_int=bus_int+1) begin
    cnt = cnt | (cnt_wire[bus_int] << bus_int);
    ct_adr = ct_adr | (ct_adr_wire[bus_int] << (bus_int*BITADDR));
    ct_imm = ct_imm | (imm_wire[bus_int] << (bus_int*WIDTH));
  end
  ac_read = 0;
  ac_write = 0;
  ac_addr = 0;
  ac_din = 0;
  for (bus_int=0; bus_int<NUMACPT; bus_int=bus_int+1) begin
    ac_read = ac_read | (ac_read_wire[bus_int] << bus_int);
    ac_write = ac_write | (ac_write_wire[bus_int] << bus_int);
    ac_addr = ac_addr | (ac_adr_wire[bus_int] << (bus_int*BITADDR));
    ac_din = ac_din | (ac_din_wire[bus_int] << (bus_int*WIDTH));
    ac_vld_wire[bus_int] = ac_vld >> bus_int;
    ac_dout_wire[bus_int] = ac_dout >> (bus_int*WIDTH);
    ac_serr_wire[bus_int] = ac_serr >> bus_int;
    ac_derr_wire[bus_int] = ac_derr >> bus_int;
    ac_padr_wire[bus_int] = ac_padr >> (bus_int*BITPADR);
  end
  bread = 0;
  brd_adr = 0;
  for (bus_int=0; bus_int<NUMRDPT; bus_int=bus_int+1) begin
    bread = bread | (bread_wire[bus_int] << bus_int);
    brd_adr = brd_adr | (brd_adr_wire[bus_int] << (bus_int*BITADDR));
  end
  bwrite = 0;
  bwr_adr = 0;
  bdin = 0;
  for (bus_int=0; bus_int<NUMWRPT; bus_int=bus_int+1) begin
    bwrite = bwrite | (bwrite_wire[bus_int] << bus_int);
    bwr_adr = bwr_adr | (bwr_adr_wire[bus_int] << (bus_int*BITADDR));
    bdin = bdin | (bdin_wire[bus_int] << (bus_int*WIDTH));
  end
end

task reset;
begin
  `TB_YAP("asserting reset")
  rst = 1;
  cyc (10);
  rst = 0;
  while (!ready)
    cyc (1);
end
endtask

function [NUMACPT*WIDTH-1:0] randomACvalue;
  input integer width;
  integer i;
  begin
    randomACvalue = 0;
    for (i = width/32; i >= 0; i--)
      randomACvalue = (randomACvalue << 32) + $urandom;
  end
endfunction



function [NUMCTPT*WIDTH-1:0] randomCTvalue;
  input integer width;
  integer i;
  begin
    randomCTvalue = 0;
    for (i = width/32; i >= 0; i--)
      randomCTvalue = (randomCTvalue << 32) + $urandom;
  end
endfunction


function [NUMWRPT*WIDTH-1:0] randomWRvalue;
  input integer width;
  integer i;
  begin
    randomWRvalue = 0;
    for (i = width/32; i >= 0; i--)
      randomWRvalue = (randomWRvalue << 32) + $urandom;
  end
endfunction

function [NUMRWPT*WIDTH-1:0] randomRWvalue;
  input integer width;
  integer i;
  begin
    randomRWvalue = 0;
    for (i = width/32; i >= 0; i--)
      randomRWvalue = (randomRWvalue << 32) + $urandom;
  end
endfunction

task test_write_all;
  integer m;
  if (bisten) begin
    `TB_YAP("test_write_all running") 
    for (m=0; m<DEPTH; m=m+1)
      membacc (0, 0,
               1, m, randomWRvalue(NUMWRPT*WIDTH));
    cyc (10);
    `TB_YAP("test_write_all completed")
  end else begin
    `TB_YAP("test_write_all running") 
    for (m=0; m<DEPTH; m=m+1)
      if (NUMWRPT>0)
        memacc (0, 0,
                0, 0, 0, 0,
                1, m, randomWRvalue(NUMWRPT*WIDTH),
                0, 0, 0,
                0, 0, 0, 0);
      else if (NUMRWPT>0)
        memacc (0, 0,
                0, 1, m, randomRWvalue(NUMRWPT*WIDTH),
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0);
      else if (NUMACPT>0)
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 1, m, randomACvalue(NUMACPT*WIDTH));
    cyc (10);
    `TB_YAP("test_write_all completed")
  end
endtask

task test_read_all;
  integer m;
  if (bisten) begin
    `TB_YAP("test_read_all running") 
    for (m=0; m<DEPTH; m=m+1)
      membacc (1, m,
               0, 0, 0);
    cyc (10);
    `TB_YAP("test_read_all completed")
  end else begin
    `TB_YAP("test_read_all running") 
    for (m=0; m<DEPTH; m=m+1)
      if (NUMRDPT>0)
        memacc (1, m,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0);
      else if (NUMRWPT>0)
        memacc (0, 0,
                1, 0, m, 0,
                0, 0, 0,
                0, 0, 0,
                0, 0, 0, 0);
      else if (NUMACPT>0)
        memacc (0, 0,
                0, 0, 0, 0,
                0, 0, 0,
                0, 0, 0,
                1, 0, m, 0);
    cyc (10);
    `TB_YAP("test_read_all completed")
  end
endtask

task cyc;
input [31:0] cycles;
integer i;
begin
  if (cycles > 0) begin
    for (i=0; i<cycles; i=i+1)
      @(negedge clk);
    #(TB_HALF_CLK_PER/2);
  end
end
endtask

task memacc;
input [NUMRDPT-1:0] rd;
input [NUMRDPT*BITADDR-1:0] rdadr;
input [NUMRWPT-1:0] rwrd;
input [NUMRWPT-1:0] rwwr;
input [NUMRWPT*BITADDR-1:0] rwadr;
input [NUMRWPT*WIDTH-1:0] rwdin;
input [NUMWRPT-1:0] wr;
input [NUMWRPT*BITADDR-1:0] wradr;
input [NUMWRPT*WIDTH-1:0] din;
input [NUMCTPT-1:0] cnt;
input [NUMCTPT*BITADDR-1:0] ctadr;
input [NUMCTPT*WIDTH-1:0] imm;
input [NUMACPT-1:0] acrd;
input [NUMACPT-1:0] acwr;
input [NUMACPT*BITADDR-1:0] acadr;
input [NUMACPT*WIDTH-1:0] acdin;
integer i;
  begin
    if (refr)
      cyc (1);
    for (i=0; i<NUMRDPT; i=i+1) begin
      read_wire[i] = rd >> i;
      rd_adr_wire[i] = rdadr >> i*BITADDR;
    end
    for (i=0; i<NUMRWPT; i=i+1) begin
      rw_read_wire[i] = rwrd >> i;
      rw_write_wire[i] = rwwr >> i;
      rw_adr_wire[i] = rwadr >> i*BITADDR;
      rw_din_wire[i] = rwdin >> i*WIDTH;
    end
    for (i=0; i<NUMWRPT; i=i+1) begin
      write_wire[i] = wr >> i;
      wr_adr_wire[i] = wradr >> i*BITADDR;
      din_wire[i] = din >> i*WIDTH;
    end
    for (i=0; i<NUMCTPT; i=i+1) begin
      cnt_wire[i] = cnt >> i;
      ct_adr_wire[i] = ctadr >> i*BITADDR;
      imm_wire[i] = imm >> i*WIDTH;
    end
    for (i=0; i<NUMACPT; i=i+1) begin
      ac_read_wire[i] = acrd >> i;
      ac_write_wire[i] = acwr >> i;
      ac_adr_wire[i] = acadr >> i*BITADDR;
      ac_din_wire[i] = acdin >> i*WIDTH;
    end
    cyc (1);
    for (i=0; i<NUMRDPT; i=i+1) begin
      read_wire[i] = 0;
      rd_adr_wire[i] = 'hx;
    end
    for (i=0; i<NUMRWPT; i=i+1) begin
      rw_read_wire[i] = 0;
      rw_write_wire[i] = 0;
      rw_adr_wire[i] = 'hx;
      rw_din_wire[i] = 'hx;
    end
    for (i=0; i<NUMWRPT; i=i+1) begin
      write_wire[i] = 0;
      wr_adr_wire[i] = 'hx;
      din_wire[i] = 'hx;
    end
    for (i=0; i<NUMCTPT; i=i+1) begin
      cnt_wire[i] = 0;
      ct_adr_wire[i] = 'hx;
      imm_wire[i] = 'hx;
    end
    for (i=0; i<NUMACPT; i=i+1) begin
      ac_read_wire[i] = 0;
      ac_write_wire[i] = 0;
      ac_adr_wire[i] = 'hx;
      ac_din_wire[i] = 'hx;
    end
  end
endtask

task membacc;
input [NUMRDPT-1:0] rd;
input [NUMRDPT*BITADDR-1:0] rdadr;
input [NUMWRPT-1:0] wr;
input [NUMWRPT*BITADDR-1:0] wradr;
input [NUMWRPT*WIDTH-1:0] din;
integer i;
  begin
    if (refr)
      cyc (1);
    for (i=0; i<NUMRDPT; i=i+1) begin
      bread_wire[i] = rd >> i;
      brd_adr_wire[i] = rdadr >> i*BITADDR;
    end
    for (i=0; i<NUMWRPT; i=i+1) begin
      bwrite_wire[i] = wr >> i;
      bwr_adr_wire[i] = wradr >> i*BITADDR;
      bdin_wire[i] = din >> i*WIDTH;
    end
    cyc (1);
    for (i=0; i<NUMRDPT; i=i+1) begin
      bread_wire[i] = 0;
      brd_adr_wire[i] = 'hx;
    end
    for (i=0; i<NUMWRPT; i=i+1) begin
      bwrite_wire[i] = 0;
      bwr_adr_wire[i] = 'hx;
      bdin_wire[i] = 'hx;
    end
  end
endtask

task test_random;
input [31:0] num;
integer n,i,j,k;
reg               tmpacc;
reg [BITADDR-1:0] tmpadr;
reg               tmpwrflg;
reg               tmpwracc [0:NUMWRPT-1];
reg [BITADDR-1:0] tmpwradr [0:NUMWRPT-1];
reg               tmprw;
reg               tmpacr;
reg               tmpacw;
reg [31:0]        mask;
reg [31:0]        ptmask;
reg [NUMRDPT-1:0] read;
reg [NUMRDPT*BITADDR-1:0] rdadr;
reg [NUMRWPT-1:0] rwrd;
reg [NUMRWPT-1:0] rwwr;
reg [NUMRWPT*BITADDR-1:0] rwadr;
reg [NUMWRPT-1:0] write;
reg [NUMWRPT*BITADDR-1:0] wradr;
reg [NUMCTPT-1:0] cnt;
reg [NUMCTPT*BITADDR-1:0] ctadr;
reg [NUMACPT-1:0] acrd;
reg [NUMACPT-1:0] acwr;
reg [NUMACPT*BITADDR-1:0] acadr;
  begin
    `TB_YAP("test_random running") 
    for (n=0; n<num; n=n+1) begin
      if ((n% 10000) == 0) 
        `TB_YAP($psprintf("test_random sent %0d of %0d", n, num))

      read = 0;
      rdadr = 0;
      for (i=0; i<NUMRDPT; i=i+1) begin
        tmpadr = $urandom%DEPTH;
        tmpacc = ($urandom < 32'hC0000000);
        read = read | (tmpacc << i); 
        rdadr = rdadr | (tmpadr << i*BITADDR);
      end

      rwrd = 0;
      rwwr = 0;
      rwadr = 0;
      for (i=0; i<NUMRWPT; i=i+1) begin
        tmpadr = $urandom%DEPTH;
        tmpacc = ($urandom < 32'hC0000000);
        tmprw = ($urandom < 32'h80000000);
        rwrd = rwrd | ((tmprw && tmpacc) << i); 
        rwwr = rwwr | ((!tmprw && tmpacc) << i); 
        rwadr = rwadr | (tmpadr << i*BITADDR);
      end

      write = 0;
      wradr = 0;
      for (i=0; i<NUMWRPT; i=i+1) begin
        tmpwrflg = 0;
        tmpwradr[i] = $urandom%DEPTH;
        tmpwracc[i] = ($urandom < 32'hC0000000);
        while (PSEUDOW && !tmpwrflg) begin
          tmpwrflg = 1;
          tmpwradr[i] = $urandom%DEPTH;
          for (k=0; k<i; k=k+1)
            if (tmpwracc[k] && tmpwracc[i] && (tmpwradr[k] == tmpwradr[i]))
              tmpwrflg = 0;
        end
        write = write | (tmpwracc[i] << i); 
        wradr = wradr | (tmpwradr[i] << i*BITADDR);
      end

      cnt = 0;
      ctadr = 0;
      for (i=0; i<NUMCTPT; i=i+1) begin
        tmpadr = $urandom%DEPTH;
        tmpacc = ($urandom < 32'hC0000000);
        cnt = cnt | (tmpacc << i); 
        ctadr = ctadr | (tmpadr << i*BITADDR);
      end

      acrd = 0;
      acwr = 0;
      acadr = 0;
      for (i=0; i<NUMACPT; i=i+1) begin
        tmpadr = $urandom%DEPTH;
        tmpacc = ($urandom < 32'hC0000000);
        tmpacr = ($urandom < 32'h80000000);
        tmpacw = ($urandom < 32'h80000000);
        acrd = acrd | ((tmpacr && tmpacc) << i); 
        acwr = acwr | ((tmpacw && tmpacc) << i); 
        acadr = acadr | (tmpadr << i*BITADDR);
      end

      if (NUMMASK>0) begin
        mask = $urandom%NUMMASK;
        case (mask)
          0: ptmask = PTMASK1;
          1: ptmask = PTMASK2;
          2: ptmask = PTMASK3;
          3: ptmask = PTMASK4;
          4: ptmask = PTMASK5;
          5: ptmask = PTMASK6;
          6: ptmask = PTMASK7;
          7: ptmask = PTMASK8;
        endcase
      end else ptmask = ~0;
      /*
       NUMMASK = 3
       rd0 rd1 rw2 wr3
       PTMASK1  1   1   0   0      // RD Port 0 and RD Port 1 active
       PTMAKS2  0   0   1   0      // RW Port 2 active
       PTMASK3  1   0   1   1      // RD Port 0 RW Port 2 WR Port 3 active
       */
      read = read & (ptmask >> (NUMRWPT+NUMWRPT+NUMCTPT+NUMACPT));
      rwrd = rwrd & (ptmask >> (NUMWRPT+NUMCTPT+NUMACPT));
      rwwr = rwwr & (ptmask >> (NUMWRPT+NUMCTPT+NUMACPT));
      write = write & (ptmask >> (NUMCTPT+NUMACPT));
      cnt = cnt & (ptmask >> NUMACPT);
      acrd = acrd & ptmask;
      acwr = acwr & ptmask;
      
      memacc(read, rdadr,
             rwrd, rwwr, rwadr, randomRWvalue(NUMRWPT*WIDTH),
             write, wradr, randomWRvalue(NUMWRPT*WIDTH),
             cnt, ctadr, randomCTvalue(NUMCTPT*WIDTH),
             acrd, acwr, acadr, randomACvalue(NUMACPT*WIDTH));
    end
    `TB_YAP("test_random completed") 
  end
endtask

task test_bist_random;
input [31:0] num;
integer n,i,j,k;
reg               tmpacc;
reg [BITADDR-1:0] tmpadr;
reg               tmpwrflg;
reg               tmpwracc [0:NUMWRPT-1];
reg [BITADDR-1:0] tmpwradr [0:NUMWRPT-1];
reg [31:0]        mask;
reg [31:0]        ptmask;
reg [NUMRDPT-1:0] read;
reg [NUMRDPT*BITADDR-1:0] rdadr;
reg [NUMWRPT-1:0] write;
reg [NUMWRPT*BITADDR-1:0] wradr;
  begin
    `TB_YAP("test_bist_random running") 
    for (n=0; n<num; n=n+1) begin
      if ((n% 10000) == 0) 
        `TB_YAP($psprintf("test_bist_random sent %0d of %0d", n, num))

      read = 0;
      rdadr = 0;
      for (i=0; i<NUMRDPT; i=i+1) begin
        tmpadr = $urandom%DEPTH;
        tmpacc = ($urandom < 32'hC0000000);
        read = read | (tmpacc << i); 
        rdadr = rdadr | (tmpadr << i*BITADDR);
      end

      write = 0;
      wradr = 0;
      for (i=0; i<NUMWRPT; i=i+1) begin
        tmpwrflg = 0;
        tmpwradr[i] = $urandom%DEPTH;
        tmpwracc[i] = ($urandom < 32'hC0000000);
        while (PSEUDOW && !tmpwrflg) begin
          tmpwrflg = 1;
          tmpwradr[i] = $urandom%DEPTH;
          for (k=0; k<i; k=k+1)
            if (tmpwracc[k] && tmpwracc[i] && (tmpwradr[k] == tmpwradr[i]))
              tmpwrflg = 0;
        end
        write = write | (tmpwracc[i] << i); 
        wradr = wradr | (tmpwradr[i] << i*BITADDR);
      end

      if (NUMMASK>0) begin
        mask = $urandom%NUMMASK;
        case (mask)
          0: ptmask = PTMASK1;
          1: ptmask = PTMASK2;
          2: ptmask = PTMASK3;
          3: ptmask = PTMASK4;
          4: ptmask = PTMASK5;
          5: ptmask = PTMASK6;
          6: ptmask = PTMASK7;
          7: ptmask = PTMASK8;
        endcase
      end else ptmask = ~0;
      /*
       NUMMASK = 3
       rd0 rd1 rw2 wr3
       PTMASK1  1   1   0   0      // RD Port 0 and RD Port 1 active
       PTMAKS2  0   0   1   0      // RW Port 2 active
       PTMASK3  1   0   1   1      // RD Port 0 RW Port 2 WR Port 3 active
       */
      read = read & (ptmask >> NUMWRPT);
      write = write & ptmask;
      
      membacc(read, rdadr,
              write, wradr, randomWRvalue(NUMWRPT*WIDTH));
    end
    `TB_YAP("test_bist_random completed") 
  end
endtask

initial begin
  bisten = 0;
  reset;
  `TB_YAP("Running tests")
  test_write_all();
  test_random(DEPTH + 20000);
  test_read_all();
  if (BISTTST) begin
    `TB_YAP("Running BIST tests")
    bisten = 1;
    test_write_all();
    test_bist_random(DEPTH + 20000);
    test_read_all();
  end
  `TB_YAP("All tests completed")
  $assertoff;
  rst = 1;
  cyc (50);
  $finish;
end

final begin
  if ((__err_cnt != 0) || matchflag) begin
    `ERROR($psprintf("failed with warnings=%0d errors=%0d\n", __warn_cnt, __err_cnt))
    `TB_YAP("Simulation FAILED")
  end else begin
     if(__warn_cnt != 0) begin
      `INFO($psprintf("passed with warnings=%0d \n", __warn_cnt))
    end
    `TB_YAP("Simulation PASSED")
  end
end

endmodule

