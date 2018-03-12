/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
module test_driver_2r1w_b781 (read, rd_adr, rd_vld, rd_dout, flopout_en,//rd_serr, rd_derr, rd_padr,
                    rw_read, rw_write, rw_addr, rw_din, rw_bw, rw_vld, rw_dout, //rw_serr, rw_derr, rw_padr,
                    write, wr_adr, din, bw,
                    cnt, ct_adr, ct_imm, ct_vld, ct_serr, ct_derr,
                    ac_read, ac_write, ac_addr, ac_din, ac_vld, ac_dout, ac_serr, ac_derr, ac_padr,
                    ru_read, ru_write, ru_addr, ru_din, ru_bw, ru_vld, ru_dout, ru_serr, ru_derr, ru_padr,
                    ma_write, ma_adr, ma_din, ma_bp,
                    dq_vld, dq_adr, 
                    push, pu_adr, pu_din, pu_ptr, pu_vld, pu_cnt,
                    pop, po_adr, po_vld, po_dout, po_serr, po_derr, po_padr,
                    po_ptr, po_nxt, po_cnt, po_snxt, po_sdout,
                    dbg_en, dbg_read, dbg_write, dbg_bank, dbg_addr, dbg_din, dbg_vld, dbg_dout, dbg_refr, dbg_rbnk,
                    clk, lclk, rst, ready, refr);

parameter DEPTH = 32;
parameter BITADDR = 5;
parameter WIDTH   = 8;
parameter BITPADR = 16;

parameter NUMCELL = 2;
parameter BITCELL = 1;
parameter NUMQUEU = DEPTH/80;
parameter BITQUEU = 1;
parameter NUMSCNT = 2;
parameter CNTWDTH = WIDTH >=4 ? WIDTH/NUMSCNT : 4/NUMSCNT;

parameter ENARDSG = 0;
parameter ENAWRSG = 0;
parameter ENAPSDO = 1;
parameter ENARPSD = 0;
parameter ENARDSQ = 0;
parameter ENAWRSQ = 0;
parameter ENAWRST = 0;
parameter WRRDHAZ = 4;
parameter RDWRHAZ = 3;
parameter WIN_DELAY = 26;
parameter NUMVBNK = 4;
parameter BITVBNK = 2;
parameter NUMVROW = 8;
parameter BITVROW = 3;

parameter NUMRDPT = 0;
parameter NUMRWPT = 0;
parameter NUMWRPT = 0;
parameter NUMCTPT = 0;
parameter NUMACPT = 0;
parameter NUMRUPT = 0;
parameter NUMMAPT = 0;
parameter NUMDQPT = 0;
parameter NUMPUPT = 0;
parameter NUMPOPT = 0;

parameter MEM_DELAY = 1;
parameter UPD_DELAY = 1;

parameter TB_HALF_CLK_PER = 1000;
parameter TB_HALF_LCLK_PER = 1500;

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

parameter NUMDBNK = 0;
parameter BITDBNK = 0;
parameter NUMDROW = 0;
parameter BITDROW = 0;
parameter DBGWDTH = 0;
parameter BITDRBNK = 0;

parameter MAX_MEM_DELAY = 10;

parameter C1_BANK = 0;	parameter C1_ROWS = 0;	parameter C1_WDTH = 0;  parameter C1_DELY = 1;  parameter C1_RBNK = 0;  parameter C1_RROW = 0;
parameter C2_BANK = 0;	parameter C2_ROWS = 0;	parameter C2_WDTH = 0;  parameter C2_DELY = 1;  parameter C2_RBNK = 0;  parameter C2_RROW = 0;
parameter C3_BANK = 0;	parameter C3_ROWS = 0;	parameter C3_WDTH = 0;  parameter C3_DELY = 1;  parameter C3_RBNK = 0;  parameter C3_RROW = 0;
parameter C4_BANK = 0;	parameter C4_ROWS = 0;	parameter C4_WDTH = 0;  parameter C4_DELY = 1;  parameter C4_RBNK = 0;  parameter C4_RROW = 0;
parameter C5_BANK = 0;	parameter C5_ROWS = 0;	parameter C5_WDTH = 0;  parameter C5_DELY = 1;  parameter C5_RBNK = 0;  parameter C5_RROW = 0;
parameter C6_BANK = 0;	parameter C6_ROWS = 0;	parameter C6_WDTH = 0;  parameter C6_DELY = 1;  parameter C6_RBNK = 0;  parameter C6_RROW = 0;
parameter C7_BANK = 0;	parameter C7_ROWS = 0;	parameter C7_WDTH = 0;  parameter C7_DELY = 1;  parameter C7_RBNK = 0;  parameter C7_RROW = 0;
parameter C8_BANK = 0;	parameter C8_ROWS = 0;	parameter C8_WDTH = 0;  parameter C8_DELY = 1;  parameter C8_RBNK = 0;  parameter C8_RROW = 0;

localparam LENPSDO = 1;

output                       refr;

output [NUMRDPT-1:0]         read;
output [NUMRDPT*BITADDR-1:0] rd_adr;
input [NUMRDPT-1:0]          rd_vld;
input [NUMRDPT*WIDTH-1:0]    rd_dout; 
output                       flopout_en;
/*
input [NUMRDPT-1:0]          rd_serr;
input [NUMRDPT-1:0]          rd_derr;
input [NUMRDPT*BITPADR-1:0]  rd_padr;
*/
output [NUMRWPT-1:0]         rw_read;
output [NUMRWPT-1:0]         rw_write;
output [NUMRWPT*BITADDR-1:0] rw_addr;
output [NUMRWPT*WIDTH-1:0]   rw_din; 
output [NUMRWPT*WIDTH-1:0]   rw_bw; 
input [NUMRWPT-1:0]          rw_vld;
input [NUMRWPT*WIDTH-1:0]    rw_dout; 
/*input [NUMRWPT-1:0]          rw_serr;
input [NUMRWPT-1:0]          rw_derr;
input [NUMRWPT*BITPADR-1:0]  rw_padr;
*/
output [NUMWRPT-1:0]         write;
output [NUMWRPT*BITADDR-1:0] wr_adr;
output [NUMWRPT*WIDTH-1:0]   din; 
output [NUMWRPT*WIDTH-1:0]   bw; 

output [NUMCTPT-1:0]         cnt;
output [NUMCTPT*BITADDR-1:0] ct_adr;
output [NUMCTPT*WIDTH-1:0]   ct_imm; 
input [NUMCTPT-1:0]          ct_vld;
input [NUMCTPT-1:0]          ct_serr;
input [NUMCTPT-1:0]          ct_derr;

output [NUMACPT-1:0]         ac_read;
output [NUMACPT-1:0]         ac_write;
output [NUMACPT*BITADDR-1:0] ac_addr;
output [NUMACPT*WIDTH-1:0]   ac_din; 
input [NUMACPT-1:0]          ac_vld;
input [NUMACPT*WIDTH-1:0]    ac_dout; 
input [NUMACPT-1:0]          ac_serr;
input [NUMACPT-1:0]          ac_derr;
input [NUMACPT*BITPADR-1:0]  ac_padr;

output [NUMRUPT-1:0]         ru_read;
output [NUMRUPT-1:0]         ru_write;
output [NUMRUPT*BITADDR-1:0] ru_addr;
output [NUMRUPT*WIDTH-1:0]   ru_din; 
output [NUMRUPT*WIDTH-1:0]   ru_bw; 
input [NUMRUPT-1:0]          ru_vld;
input [NUMRUPT*WIDTH-1:0]    ru_dout; 
input [NUMRUPT-1:0]          ru_serr;
input [NUMRUPT-1:0]          ru_derr;
input [NUMRUPT*BITPADR-1:0]  ru_padr;

output [NUMMAPT-1:0]         ma_write;
input [NUMMAPT*BITADDR-1:0]  ma_adr;
output [NUMMAPT*WIDTH-1:0]   ma_din; 
input [NUMMAPT-1:0]          ma_bp;

output [NUMDQPT-1:0]         dq_vld;
output [NUMDQPT*BITADDR-1:0] dq_adr;

output [NUMPUPT-1:0]         push;
output [NUMPUPT*BITQUEU-1:0] pu_adr;
output [NUMPUPT*BITADDR-1:0] pu_ptr; 
output [NUMPUPT*WIDTH-1:0]   pu_din; 
input [NUMPUPT-1:0]          pu_vld;
input [NUMPUPT*(BITADDR+1)-1:0]    pu_cnt; 

output [NUMPOPT-1:0]         pop;
output [NUMPOPT*BITQUEU-1:0] po_adr;
input [NUMPOPT-1:0]          po_vld;
input [NUMPOPT*BITADDR-1:0]  po_ptr; 
input [NUMPOPT*BITADDR-1:0]  po_nxt; 
input [NUMPOPT*WIDTH-1:0]    po_dout; 
input [NUMPOPT-1:0]          po_serr;
input [NUMPOPT-1:0]          po_derr;
input [NUMPOPT*BITPADR-1:0]  po_padr;
input [NUMPOPT*(BITADDR+1)-1:0]    po_cnt; 
input [NUMPOPT*BITADDR-1:0]  po_snxt; 
input [NUMPOPT*WIDTH-1:0]    po_sdout; 


output                       dbg_en;
output                       dbg_read;
output                       dbg_write;
output [BITDBNK-1:0]         dbg_bank;
output [BITDROW-1:0]         dbg_addr;
output [DBGWDTH-1:0]         dbg_din; 
input                        dbg_vld;
input [DBGWDTH-1:0]          dbg_dout; 
output                       dbg_refr;
output [BITDRBNK-1:0]        dbg_rbnk;

output                       clk;
output                       lclk;
output                       rst;
input                        ready;

reg               read_wire [0:NUMRDPT-1];
reg [BITADDR-1:0] rd_adr_wire [0:NUMRDPT-1];
reg               rd_vld_wire [0:NUMRDPT-1];
reg [WIDTH-1:0]   rd_dout_wire [0:NUMRDPT-1]; 
reg [BITPADR-1:0] rd_padr_wire [0:NUMRDPT-1];

reg               write_wire [0:NUMWRPT-1];
reg [BITADDR-1:0] wr_adr_wire [0:NUMWRPT-1];
reg [WIDTH-1:0]   din_wire [0:NUMWRPT-1];

reg                       dbg_en;
reg                       dbg_read;
reg                       dbg_write;
reg [BITDBNK-1:0]         dbg_bank;
reg [BITDROW-1:0]         dbg_addr;
reg [DBGWDTH-1:0]         dbg_din; 
reg                       dbg_refr;
reg [BITDRBNK-1:0]        dbg_rbnk;

reg [NUMWRPT-1:0] wrsgmsk [0:NUMVBNK-1];

reg rst;

string name = "testbench.drvr";

  reg [WIDTH-1:0]outData;
integer init_int;
reg clk;
initial begin
  clk = 0;
  for (init_int=0; init_int<NUMVBNK; init_int=init_int+1)
    wrsgmsk[init_int] = 1<<($urandom%NUMWRPT);
  for (init_int=0; init_int<NUMRDPT; init_int=init_int+1)
    read_wire[init_int] = 0;
  for (init_int=0; init_int<NUMWRPT; init_int=init_int+1)
    write_wire[init_int] = 0;
  dbg_en = 0;
  dbg_read = 0;
  dbg_write = 0;
  dbg_refr = 0;
  forever #TB_HALF_CLK_PER clk = !clk;
end

reg lclk;
initial begin
  lclk = 0;
  forever #TB_HALF_LCLK_PER lclk = !lclk;
end

reg memflg [0:DEPTH-1];
reg [WIDTH-1:0] memchk [0:DEPTH-1];

integer wr_int;
always @(posedge clk) begin
  for (wr_int=0; wr_int<NUMWRPT; wr_int=wr_int+1)
    if (write_wire[wr_int]) begin
        memchk[wr_adr_wire[wr_int]] <= din_wire[wr_int];
    end
end

reg [DBGWDTH-1:0] dbgchk [0:NUMDBNK-1][0:NUMDROW-1];
always @(posedge clk)
  if (dbg_write)
    dbgchk[dbg_bank][dbg_addr] <= dbg_din;

reg               read_reg   [0:NUMRDPT-1][0:MEM_DELAY-1];
reg [BITADDR-1:0] rd_adr_reg [0:NUMRDPT-1][0:MEM_DELAY-1];
reg [WIDTH-1:0]   rd_dout_reg [0:NUMRDPT-1][0:MEM_DELAY-1];

reg               dbg_read_reg [0:NUMDBNK-1][0:MAX_MEM_DELAY-1];
reg [BITDBNK-1:0] dbg_bank_reg [0:NUMDBNK-1][0:MAX_MEM_DELAY-1];
reg [DBGWDTH-1:0] dbg_dout_reg [0:NUMDBNK-1][0:MAX_MEM_DELAY-1];
integer rdel_int, mdel_int,ddel_int;
always @(posedge clk)
  for (ddel_int=0; ddel_int<MAX_MEM_DELAY; ddel_int=ddel_int+1)
    if (ddel_int>0) begin
      if (ddel_int<C1_DELY) begin
        for (rdel_int=0; rdel_int<NUMDBNK; rdel_int=rdel_int+1) begin
          dbg_dout_reg[rdel_int][ddel_int] <= dbg_dout_reg[rdel_int][ddel_int-1];
          dbg_bank_reg[rdel_int][ddel_int] <= dbg_bank_reg[rdel_int][ddel_int-1];
          dbg_read_reg[rdel_int][ddel_int] <= dbg_read_reg[rdel_int][ddel_int-1];
        end
      end
    end else begin
      for (rdel_int=0; rdel_int<NUMDBNK; rdel_int=rdel_int+1) begin
        dbg_dout_reg[rdel_int][mdel_int] <= (dbg_read && (dbg_bank == rdel_int)) ? dbgchk[dbg_bank][dbg_addr] : {(DBGWDTH>0?DBGWDTH:1){1'bx}};
        dbg_read_reg[rdel_int][mdel_int] <= dbg_read && (dbg_bank == rdel_int);
      end
    end

always @(posedge clk)
  for (mdel_int=0; mdel_int<MEM_DELAY+UPD_DELAY; mdel_int=mdel_int+1)
    if (mdel_int>0) begin
      if (mdel_int<MEM_DELAY) begin
        for (rdel_int=0; rdel_int<NUMRDPT; rdel_int=rdel_int+1) begin
          read_reg[rdel_int][mdel_int] <= read_reg[rdel_int][mdel_int-1];
          rd_adr_reg[rdel_int][mdel_int] <= rd_adr_reg[rdel_int][mdel_int-1];
          rd_dout_reg[rdel_int][mdel_int] <= rd_dout_reg[rdel_int][mdel_int-1];
        end
      end
      // End masking
    end else begin
      for (rdel_int=0; rdel_int<NUMRDPT; rdel_int=rdel_int+1) begin
        read_reg[rdel_int][mdel_int] <= read_wire[rdel_int];
        rd_adr_reg[rdel_int][mdel_int] <= rd_adr_wire[rdel_int];
        rd_dout_reg[rdel_int][mdel_int] <= read_wire[rdel_int] ? memchk[rd_adr_wire[rdel_int]] : {WIDTH{1'bx}};
      end
    end

reg               write_reg [0:NUMWRPT-1][0:WIN_DELAY-1];
reg [BITADDR-1:0] wr_adr_reg [0:NUMWRPT-1][0:WIN_DELAY-1];
integer wdel_int, wprt_int;
always @(posedge clk)
  for (wdel_int=0; wdel_int<WIN_DELAY; wdel_int=wdel_int+1)
    if (wdel_int>0) begin
      for (wprt_int=0; wprt_int<NUMWRPT; wprt_int=wprt_int+1) begin
        write_reg[wprt_int][wdel_int] <= write_reg[wprt_int][wdel_int-1];
        wr_adr_reg[wprt_int][wdel_int] <= wr_adr_reg[wprt_int][wdel_int-1];
      end
    end else begin
      for (wprt_int=0; wprt_int<NUMWRPT; wprt_int=wprt_int+1) begin
        write_reg[wprt_int][wdel_int] <= write_wire[wprt_int];
        wr_adr_reg[wprt_int][wdel_int] <= wr_adr_wire[wprt_int];
      end
    end

integer chk_int;
reg [NUMRDPT-1:0] match_rd;
reg [NUMDBNK-1:0] match_db;
always_comb begin
  for (chk_int=0; chk_int<NUMRDPT; chk_int=chk_int+1) begin
    if (MEM_DELAY>0)
      match_rd[chk_int] = !read_reg[chk_int][MEM_DELAY-1] || ((rd_vld_wire[chk_int] === read_reg[chk_int][MEM_DELAY-1]) &&
                                      (rd_dout_wire[chk_int] === rd_dout_reg[chk_int][MEM_DELAY-1]));
    else
      match_rd[chk_int] = !read_wire[chk_int] || ((rd_vld_wire[chk_int] === read_wire[chk_int]) && (rd_dout_wire[chk_int] === memchk[rd_adr_wire[chk_int]]));
  end
  for (chk_int=0; chk_int<NUMDBNK; chk_int=chk_int+1) begin
    if (chk_int<C1_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C1_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C1_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C1_DELY-1]));
    else if (chk_int<C1_BANK+C2_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C2_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C2_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C2_DELY-1]));
    else if (chk_int<C1_BANK+C2_BANK+C3_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C3_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C3_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C3_DELY-1]));
    else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C4_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C4_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C4_DELY-1]));
    else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C5_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C5_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C5_DELY-1]));
    else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK+C6_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C6_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C6_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C6_DELY-1]));
    else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK+C6_BANK+C7_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C7_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C7_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C7_DELY-1]));
    else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK+C6_BANK+C7_BANK+C8_BANK)
      match_db[chk_int] = !dbg_read_reg[chk_int][C8_DELY-1] || ((dbg_vld === dbg_read_reg[chk_int][C8_DELY-1]) &&
                                                                (dbg_dout === dbg_dout_reg[chk_int][C8_DELY-1]));
  end
end

integer stp_int;
reg stop_sim = 0;
always @(posedge clk) begin
  for (stp_int=0; stp_int<NUMRDPT; stp_int=stp_int+1) begin
    if (!match_rd[stp_int]) begin
      `ERROR($psprintf("memory rd check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, rd_dout_reg[stp_int][MEM_DELAY-1], rd_dout_wire[stp_int]))
      stop_sim <= 1'b1;
    end
  end
  for (stp_int=0; stp_int<NUMDBNK; stp_int=stp_int+1)
    if (!match_db[stp_int]) begin
      stop_sim <= 1'b1;
      if (chk_int<C1_BANK) begin
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C1_DELY-1], dbg_dout))
      end else if (chk_int<C1_BANK+C2_BANK) begin
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C2_DELY-1], dbg_dout))
      end else if (chk_int<C1_BANK+C2_BANK+C3_BANK) begin
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C3_DELY-1], dbg_dout))
      end else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK) begin
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C4_DELY-1], dbg_dout))
      end else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK) begin
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C5_DELY-1], dbg_dout))
      end else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK+C6_BANK) begin
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C6_DELY-1], dbg_dout))
      end else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK+C6_BANK+C7_BANK) begin 
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C7_DELY-1], dbg_dout))
      end else if (chk_int<C1_BANK+C2_BANK+C3_BANK+C4_BANK+C5_BANK+C6_BANK+C7_BANK+C8_BANK) begin 
        `ERROR($psprintf("memory db check failed on port=%0d exp=0x%0x act=0x%0x", stp_int, dbg_dout_reg[stp_int][C8_DELY-1], dbg_dout))
      end
    end
  if (stop_sim) #1 $finish;
end

reg matchflag;
always @(posedge clk)
  if (rst)
    matchflag <= 1'b0;
  else
    matchflag <= matchflag || ((NUMRDPT>0) && ~&match_rd) || ((NUMDBNK>0) && ~&match_db);

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

assign refr = (REFRESH && (refr_cnt < REFRESH_M_IN_N_M));

reg [NUMRDPT-1:0]         read;
reg [NUMRDPT*BITADDR-1:0] rd_adr;

reg [NUMWRPT-1:0]         write;
reg [NUMWRPT*BITADDR-1:0] wr_adr;
reg [NUMWRPT*WIDTH-1:0]   din; 

integer bus_int;
always_comb begin
  read = 0;
  rd_adr = 0;
  for (bus_int=0; bus_int<NUMRDPT; bus_int=bus_int+1) begin
    read = read | (read_wire[bus_int] << bus_int);
    rd_adr = rd_adr | (rd_adr_wire[bus_int] << (bus_int*BITADDR));
    rd_vld_wire[bus_int] = rd_vld >> bus_int;
    rd_dout_wire[bus_int] = rd_dout >> (bus_int*WIDTH);
    /*rd_serr_wire[bus_int] = rd_serr >> bus_int;
    rd_derr_wire[bus_int] = rd_derr >> bus_int;
    rd_padr_wire[bus_int] = rd_padr >> (bus_int*BITPADR);*/
  end
  write = 0;
  wr_adr = 0;
  din = 0;
  for (bus_int=0; bus_int<NUMWRPT; bus_int=bus_int+1) begin
    write = write | (write_wire[bus_int] << bus_int);
    wr_adr = wr_adr | (wr_adr_wire[bus_int] << (bus_int*BITADDR));
    din = din | (din_wire[bus_int] << (bus_int*WIDTH));
  end
end

task reset;
begin
  `TB_YAP("asserting reset")
  rst = 1;
  cyc (20);
  rst = 0;
  cyc (10);
end
endtask

function [NUMWRPT*WIDTH-1:0] randomWRvalue; input integer width; integer i; begin randomWRvalue = 0; for (i = width/32; i >= 0; i--) randomWRvalue = (randomWRvalue << 32) + $urandom; end endfunction

function [C1_WDTH-1:0] randomT1value; input integer width; integer i; begin  randomT1value = 0;  for (i = width/32; i >= 0; i--)      randomT1value = (randomT1value << 32) + $urandom; end endfunction
function [C2_WDTH-1:0] randomT2value; input integer width; integer i; begin  randomT2value = 0;  for (i = width/32; i >= 0; i--)      randomT2value = (randomT2value << 32) + $urandom; end endfunction
function [C3_WDTH-1:0] randomT3value; input integer width; integer i; begin  randomT3value = 0;  for (i = width/32; i >= 0; i--)      randomT3value = (randomT3value << 32) + $urandom; end endfunction
function [C4_WDTH-1:0] randomT4value; input integer width; integer i; begin  randomT4value = 0;  for (i = width/32; i >= 0; i--)      randomT4value = (randomT4value << 32) + $urandom; end endfunction
function [C5_WDTH-1:0] randomT5value; input integer width; integer i; begin  randomT5value = 0;  for (i = width/32; i >= 0; i--)      randomT5value = (randomT5value << 32) + $urandom; end endfunction
function [C6_WDTH-1:0] randomT6value; input integer width; integer i; begin  randomT6value = 0;  for (i = width/32; i >= 0; i--)      randomT6value = (randomT6value << 32) + $urandom; end endfunction
function [C7_WDTH-1:0] randomT7value; input integer width; integer i; begin  randomT7value = 0;  for (i = width/32; i >= 0; i--)      randomT7value = (randomT7value << 32) + $urandom; end endfunction
function [C8_WDTH-1:0] randomT8value; input integer width; integer i; begin  randomT8value = 0;  for (i = width/32; i >= 0; i--)      randomT8value = (randomT8value << 32) + $urandom; end endfunction

task test_write_all;
  integer m, i;
  reg [BITADDR-1:0] tmpadr1, tmpadr2, tmpadr3;
  reg [BITVBNK-1:0] tmpbnk;
  begin
    `TB_YAP("test_write_all running") 
    for (m=0; m<DEPTH; m=m+1)
      if (NUMWRPT>0)
        if (ENAWRSG) begin
          tmpbnk = m >> BITVROW;
          for (i=0; i<NUMWRPT; i=i+1)
            if (wrsgmsk[tmpbnk][i])
              memacc (0, 0,
                      1 << i, m << (i*BITADDR), randomWRvalue(NUMWRPT*WIDTH));
        end else
          memacc (0, 0,
                  1, m, randomWRvalue(NUMWRPT*WIDTH));
    cyc (10);
    `TB_YAP("test_write_all completed")
  end
endtask

task test_read_all;
  integer m, i;
  reg [BITVBNK-1:0] tmpbnk;
  begin
    `TB_YAP("test_read_all running") 
    for (m=0; m<DEPTH; m=m+1)
      if (NUMRDPT>0)
        if (ENARDSG) begin
          tmpbnk = m >> BITVROW;
          for (i=0; i<NUMRDPT; i=i+1)
            if (wrsgmsk[tmpbnk][i])
              memacc (1 << i, m << (i*BITADDR),
                      0, 0, 0);
        end else
          memacc (1, m,
                  0, 0, 0);
    cyc (10);
    `TB_YAP("test_read_all completed")
  end
endtask

task test_dbg_write_all;
  integer m,n,start,rstart;
  begin
    `TB_YAP("test_dbg_write_all running")
	start = 0;
        for (m=0; m<C1_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C1_ROWS; n=n+1) begin
            if (C1_RBNK==0)
              dbgacc (0, 1, n, randomT1value(C1_WDTH), 0, 0);
            else if ((C1_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT1value(C1_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT1value(C1_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT1value(C1_WDTH), 1, rstart);
            rstart = (rstart + 1) % C1_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C2_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C2_ROWS; n=n+1) begin
            if (C2_RBNK==0)
              dbgacc (0, 1, n, randomT2value(C2_WDTH), 0, 0);
            else if ((C2_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT2value(C2_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT2value(C2_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT2value(C2_WDTH), 1, rstart);
            rstart = (rstart + 1) % C2_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C3_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C3_ROWS; n=n+1) begin
            if (C3_RBNK==0)
              dbgacc (0, 1, n, randomT3value(C3_WDTH), 0, 0);
            else if ((C3_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT3value(C3_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT3value(C3_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT3value(C3_WDTH), 1, rstart);
            rstart = (rstart + 1) % C3_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C4_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C4_ROWS; n=n+1) begin
            if (C4_RBNK==0)
              dbgacc (0, 1, n, randomT4value(C4_WDTH), 0, 0);
            else if ((C4_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT4value(C4_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT4value(C4_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT4value(C4_WDTH), 1, rstart);
            rstart = (rstart + 1) % C4_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C5_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C5_ROWS; n=n+1) begin
            if (C5_RBNK==0)
              dbgacc (0, 1, n, randomT5value(C5_WDTH), 0, 0);
            else if ((C5_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT5value(C5_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT5value(C5_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT5value(C5_WDTH), 1, rstart);
            rstart = (rstart + 1) % C5_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C6_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C6_ROWS; n=n+1) begin
            if (C6_RBNK==0)
              dbgacc (0, 1, n, randomT6value(C6_WDTH), 0, 0);
            else if ((C6_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT6value(C6_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT6value(C6_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT6value(C6_WDTH), 1, rstart);
            rstart = (rstart + 1) % C6_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C7_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C7_ROWS; n=n+1) begin
            if (C7_RBNK==0)
              dbgacc (0, 1, n, randomT7value(C7_WDTH), 0, 0);
            else if ((C7_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT7value(C7_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT7value(C7_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT7value(C7_WDTH), 1, rstart);
            rstart = (rstart + 1) % C7_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C8_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C8_ROWS; n=n+1) begin
            if (C8_RBNK==0)
              dbgacc (0, 1, n, randomT8value(C8_WDTH), 0, 0);
            else if ((C8_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, randomT8value(C8_WDTH), 1, rstart);
              dbgacc (0, 1, n, randomT8value(C8_WDTH), 0, 0);
            end else
              dbgacc (0, 1, n, randomT8value(C8_WDTH), 1, rstart);
            rstart = (rstart + 1) % C8_RBNK;
          end
          start = start + 1;
        end
	cyc (10);
    `TB_YAP("test_dbg_write_all completed")
  end
endtask

task test_dbg_read_all;
  integer m,n,start,rstart;
  begin
    `TB_YAP("test_dbg_read_all running") 
	start = 0;
        for (m=0; m<C1_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C1_ROWS; n=n+1) begin
            if (C1_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C1_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C1_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C2_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C2_ROWS; n=n+1) begin
            if (C2_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C2_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C2_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C3_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C3_ROWS; n=n+1) begin
            if (C3_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C3_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C3_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C4_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C4_ROWS; n=n+1) begin
            if (C4_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C4_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C4_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C5_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C5_ROWS; n=n+1) begin
            if (C5_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C5_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C5_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C6_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C6_ROWS; n=n+1) begin
            if (C6_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C6_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C6_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C7_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C7_ROWS; n=n+1) begin
            if (C7_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C7_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C7_RBNK;
          end
          start = start + 1;
        end
        for (m=0; m<C8_BANK; m=m+1) begin
          dbg_bank = start; 
          rstart = 0;
          for (n=0; n<C8_ROWS; n=n+1) begin
            if (C8_RBNK==0)
              dbgacc (1, 0, n, 0, 0, 0);
            else if ((C8_RROW == 128) ? (rstart==(n>>10)) : (rstart==(n>>11))) begin
              dbgacc (0, 0, n, 0, 1, rstart);
              dbgacc (1, 0, n, 0, 0, 0);
            end else
              dbgacc (1, 0, n, 0, 1, rstart);
            rstart = (rstart + 1) % C8_RBNK;
          end
          start = start + 1;
        end
	cyc (10);
    `TB_YAP("test_dbg_read_all completed")
  end
endtask

task cyc;
input [31:0] cycles;
integer i;
begin
  if (cycles > 0) begin
    for (i=0; i<cycles; i=i+1)
      @(posedge clk);
    #(TB_HALF_CLK_PER/2);
  end
end
endtask

task memacc;
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
      read_wire[i] = rd >> i;
      rd_adr_wire[i] = rdadr >> i*BITADDR;
    end
    for (i=0; i<NUMWRPT; i=i+1) begin
      write_wire[i] = wr >> i;
      wr_adr_wire[i] = wradr >> i*BITADDR;
      din_wire[i] = din >> i*WIDTH;
    end
    cyc (1);
    for (i=0; i<NUMRDPT; i=i+1) begin
      read_wire[i] = 0;
      rd_adr_wire[i] = 'hx;
    end
    for (i=0; i<NUMWRPT; i=i+1) begin
      write_wire[i] = 0;
      wr_adr_wire[i] = 'hx;
      din_wire[i] = 'hx;
    end
  end
endtask

task dbgacc;
input dbgrd;
input dbgwr;
input [BITDROW-1:0] dbgrow;
input [DBGWDTH-1:0] dbgdin;
input dbgrf;
input [BITDRBNK-1:0] dbgrfb;
integer i;
  begin
    dbg_read = dbgrd;
    dbg_write = dbgwr;
    dbg_addr = dbgrow;
    dbg_din = dbgdin;
    dbg_refr = dbgrf;
    dbg_rbnk = dbgrfb;
    cyc (1);
    dbg_read = 0;
    dbg_write = 0;
    dbg_addr = 'hx;
    dbg_din = 'hx;
    dbg_refr = 0;
    dbg_rbnk = 'hx;
  end
endtask

reg               read_del [0:NUMRDPT-1][0:4];
reg [BITADDR-1:0] rd_adr_del [0:NUMRDPT-1][0:4];
reg               write_del [0:NUMWRPT-1][0:4];
reg [BITADDR-1:0] wr_adr_del [0:NUMWRPT-1][0:4];

initial begin
  for(integer i=0; i<5; i=i+1) begin
    for (integer j=0; j<NUMRDPT; j=j+1) 
      read_del[j][i] = 1'b0;
    for(integer k=0;k<NUMWRPT; k=k+1)
      write_del[k][i] = 1'b0;
  end
end


always @(posedge clk) begin
  for (integer del_int=0; del_int<5; del_int=del_int+1) begin
    if(del_int>0)begin
      for(integer r_int=0; r_int<NUMRDPT; r_int=r_int+1) begin
        read_del[r_int][del_int]   <= read_del[r_int][del_int-1];
        rd_adr_del[r_int][del_int] <= rd_adr_del[r_int][del_int-1];
      end
      for(integer w_int=0; w_int<NUMWRPT; w_int=w_int+1) begin
        write_del[w_int][del_int]  <= write_del[w_int][del_int-1];
        wr_adr_del[w_int][del_int] <= wr_adr_del[w_int][del_int-1];
      end
    end else begin
      for(integer r_int=0; r_int<NUMRDPT; r_int=r_int+1) begin
        read_del[r_int][del_int]  <= read_wire[r_int];
        rd_adr_del[r_int][del_int] <= rd_adr_wire[r_int];
      end
      for(integer w_int=0; w_int<NUMWRPT; w_int=w_int+1) begin
        write_del[w_int][del_int]  <= write_wire[w_int];
        wr_adr_del[w_int][del_int] <= wr_adr_wire[w_int];
      end
    end
  end
end


task test_random;
input [31:0] num;
integer n,i,j,k;
reg               tmpacc;
reg [BITADDR-1:0] tmpadr;
reg [BITADDR-1:0] tmpchk;
reg [BITVBNK-1:0] tmpbnk;
reg [BITQUEU-1:0] tmpque;
reg [BITCELL-1:0] tmpcel;
reg [31:0]        tmpcnt;
reg               tmprw;
reg               tmpacr;
reg               tmpacw;
reg               tmpru;
reg [31:0]        mask;
reg [31:0]        ptmask;
reg               wrsgtmp;
reg [NUMVBNK-1:0] usedbnk;
reg [NUMRDPT-1:0] read;
reg [NUMRDPT*BITADDR-1:0] rdadr;
reg [NUMWRPT-1:0] write;
reg [NUMWRPT*BITADDR-1:0] wradr;
reg no_free_bnks;
  begin
    `TB_YAP("test_random running") 
    for (n=0; n<num; n=n+1) begin
      usedbnk = 0;
      no_free_bnks = 0;
      if ((n% 10000) == 0) 
        `TB_YAP($psprintf("test_random sent %0d of %0d", n, num))

      read = 0;
      rdadr = 0;
      for (i=0; i<NUMRDPT; i=i+1) begin
        if (ENARDSG) begin
          tmpacc = ($urandom < 32'hC0000000);
          wrsgtmp = 0;
          for (j=0; j<NUMVBNK; j=j+1)
            wrsgtmp = wrsgtmp || wrsgmsk[j][i];
          tmpacc = tmpacc && wrsgtmp;
          tmpadr = $urandom%DEPTH;
          tmpbnk = tmpadr >> BITVROW;
          while (tmpacc && !wrsgmsk[tmpbnk][i]) begin
            tmpadr = $urandom%DEPTH;
            tmpbnk = tmpadr >> BITVROW;
          end
        end if (ENARDSQ) begin
          tmpque = $urandom%NUMQUEU;
          tmpcel = $urandom%NUMCELL;
          tmpadr = {tmpque,tmpcel};
          tmpacc = ($urandom < 32'hC0000000);
          tmpcnt = 0;
          if (|tmpcel[BITCELL-1:0]) begin
            for (j=0; j<5; j=j+1)
              if (read_reg[i][j] && (rd_adr_reg[i][j][1:0]==tmpcel[0:0]))
                tmpcnt = tmpcnt+1;
          end else begin
            for (j=0; j<3; j=j+1)
              if (read_reg[i][j] && (rd_adr_reg[i][j][1:0]==tmpcel[0:0]))
                tmpcnt = tmpcnt+1;
          end
          tmpacc = tmpacc && (tmpcnt<1);
          for (j=0; j<NUMWRPT; j=j+1)
            for (k=0; k<WRRDHAZ; k=k+1)
              tmpacc = tmpacc && !(write_reg[j][k] && (wr_adr_reg[j][k]==tmpadr));
        end else begin
          tmpadr = $urandom%DEPTH;
          tmpacc = ($urandom < 32'hC0000000);
          tmpbnk = tmpadr >> BITVROW;
          if (&usedbnk && (LENPSDO || ENARPSD)) no_free_bnks = 1;
          while ((LENPSDO || ENARPSD) && tmpacc && usedbnk[tmpbnk] && !(&usedbnk)) begin
            tmpadr = $urandom%DEPTH;
            tmpbnk = tmpadr >> BITVROW;
          end
          usedbnk = usedbnk | (tmpacc << tmpbnk);
        end
        read = read | ((!no_free_bnks && tmpacc) << i); 
        rdadr = rdadr | (tmpadr << i*BITADDR);
      end

      write = 0;
      wradr = 0;
      for (i=0; i<NUMWRPT; i=i+1) begin
        if (ENAWRSG) begin
          tmpacc = ($urandom < 32'hC0000000);
          wrsgtmp = 0;
          for (j=0; j<NUMVBNK; j=j+1)
            wrsgtmp = wrsgtmp || wrsgmsk[j][i];
          tmpacc = tmpacc && wrsgtmp;
          tmpadr = $urandom%DEPTH;
          tmpbnk = tmpadr >> BITVROW;
          while (tmpacc && !wrsgmsk[tmpbnk][i]) begin
            tmpadr = $urandom%DEPTH;
            tmpbnk = tmpadr >> BITVROW;
          end
        end if (ENAWRSQ) begin
          tmpque = $urandom%NUMQUEU;
          tmpcel = $urandom%NUMCELL;
          tmpadr = {tmpque,tmpcel};
          tmpacc = ($urandom < 32'hC0000000);
          tmpcnt = 0;
          if (|tmpcel[BITCELL-1:0]) begin
            for (j=0; j<WIN_DELAY; j=j+1)
              if (write_reg[i][j] && (wr_adr_reg[i][j][1:0]==tmpcel[0:0]))
                tmpcnt = tmpcnt+1;
          end else
            for (j=0; j<12; j=j+1)
              if (write_reg[i][j] && (wr_adr_reg[i][j][1:0]==tmpcel[0:0]))
                tmpcnt = tmpcnt+1;
          tmpacc = tmpacc && (tmpcnt<4);
          for (j=0; j<NUMRDPT; j=j+1)
            for (k=0; k<RDWRHAZ; k=k+1)
              if (k>0)
                tmpacc = tmpacc && !(write_reg[j][k-1] && (wr_adr_reg[j][k-1]==tmpadr));
              else begin
                tmpchk = rdadr>>(j*BITADDR);
                tmpacc = tmpacc && !(read[j] && (tmpchk==tmpadr));
              end
          if (i==4)
            for (j=0; j<WIN_DELAY; j=j+1)
              tmpacc = tmpacc && !(write_reg[i][j]);
        end else begin
          tmpacc = ($urandom < 32'hC0000000);
          tmpadr = $urandom%DEPTH;
          tmpbnk = tmpadr >> BITVROW;
          if (&usedbnk && (LENPSDO || ENARPSD)) no_free_bnks = 1;
          while ((LENPSDO || ENARPSD) && tmpacc && usedbnk[tmpbnk] && !(&usedbnk)) begin
            tmpadr = $urandom%DEPTH;
            tmpbnk = tmpadr >> BITVROW;
          end
          if (ENAWRST)
            tmpacc = tmpacc && !memflg[tmpadr];
          usedbnk = usedbnk | (tmpacc << tmpbnk);
        end
        write = write | ((!no_free_bnks && tmpacc) << i); 
        wradr = wradr | (tmpadr << i*BITADDR);
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
      read = read & (ptmask >> (NUMRWPT+NUMWRPT+NUMCTPT+NUMACPT+NUMRUPT+NUMMAPT+NUMDQPT+NUMPUPT+NUMPOPT));
      write = write & (ptmask >> (NUMCTPT+NUMACPT+NUMRUPT+NUMMAPT+NUMDQPT+NUMPUPT+NUMPOPT));

      for (integer td_int=0; td_int<5; td_int=td_int+1) begin
        for(integer wr_int=0; wr_int<NUMWRPT; wr_int=wr_int+1) begin
          read = read && !(write_del[wr_int][td_int] && (wr_adr_del[wr_int][td_int] == rdadr));
        end
        for(integer rd_int=0; rd_int<NUMRDPT; rd_int=rd_int+1) begin
          write = write && !(read_del[rd_int][td_int] && (rd_adr_del[rd_int][td_int] == wradr));
        end
      end
      memacc(read, rdadr, write, wradr, randomWRvalue(NUMWRPT*WIDTH));
    end
    `TB_YAP("test_random completed") 
  end
endtask

task get_paddr;
input [BITADDR-1:0] addr;
output [BITPADR-1:0] paddr;
begin
  if (refr) cyc (1);
  if (NUMRDPT > 0) begin
    read_wire[0] = 1;
    rd_adr_wire[0] = addr;
  end

  cyc (1);

  if (NUMRDPT > 0) 
    read_wire[0] = 0;

  cyc (MEM_DELAY-1);

  #1;
  
  `TB_YAP($psprintf("The physical address for logical address 0x%0h is 0x%0h", addr, paddr))
end
endtask

//MEMOIR_SHIP_OFF
`ifdef FUNC_ERR_TEST
task test_err_inj;
reg [BITADDR-1:0] l_addr;
reg [BITPADR-1:0] p_addr;
reg [BITVROW-1:0] r_addr1, r_addr2;
begin
  l_addr = {$random()} % DEPTH; // pick a logical address
  get_paddr (l_addr, p_addr); // get physical address from the logical address
  testbench_func.ip_top.get_raddr (p_addr, r_addr1); // get row address from the physical address
  testbench_func.ip_top.show_all_laddr (r_addr1); // for information only
  // creating a serr
  `TB_YAP($psprintf("injecting an 1-bit error on field 1 of row 0x%0x", r_addr1))
  testbench_func.ip_top.put_serr (1, r_addr1);

  r_addr2 = r_addr1;
  while (r_addr2 == r_addr1) begin
    l_addr = {$random()} % DEPTH; // pick another logical address
    get_paddr (l_addr, p_addr);
    testbench_func.ip_top.get_raddr (p_addr, r_addr2);
  end
  testbench_func.ip_top.show_all_laddr (r_addr2); // for information only
  // creating a derr
  `TB_YAP($psprintf ("injecting an 2-bit error on field 0 of row 0x%0x", r_addr2))
  testbench_func.ip_top.put_derr (0, r_addr2);
  test_read_all(); // this should get error indications on all addresses with error rows
  test_write_all(); // clear all errors; another test_real_all later should be clean
end
endtask
`endif

`ifdef BEH_ERR_TEST
task test_err_inj;
  reg err_type;
  integer err_mem_mask;
  begin
    err_type = {$random()} % 2; // either 0 or 1
    err_mem_mask = get_err_type(testbench_beh.ip_top.num_mem_types);
    `TB_YAP($psprintf ("injecting %0d-bit error on Type %b memories", (err_type + 1), err_mem_mask))
    testbench_beh.ip_top.err_type = err_type;
    testbench_beh.ip_top.err_mem_mask = err_mem_mask;
  end
endtask
`endif

`ifdef BEH_SERR_TEST
task test_err_inj;
  reg err_type;
  integer err_mem_mask;
  begin
    err_type = 0;
    err_mem_mask = get_err_type(testbench_beh.ip_top.num_mem_types);
    `TB_YAP($psprintf ("injecting %0d-bit error on Type %b memories", (err_type + 1), err_mem_mask))
    testbench_beh.ip_top.err_type = err_type;
    testbench_beh.ip_top.err_mem_mask = err_mem_mask;
  end
endtask
`endif

`ifdef BEH_DERR_TEST
task test_err_inj;
  reg err_type;
  integer err_mem_mask;
  begin
    err_type = 1;
    err_mem_mask = get_err_type(testbench_beh.ip_top.num_mem_types);
    `TB_YAP($psprintf("injecting %0d-bit error on Type %b memories", (err_type + 1), err_mem_mask))
    testbench_beh.ip_top.err_type = err_type;
    testbench_beh.ip_top.err_mem_mask = err_mem_mask;
  end
endtask
`endif

`ifdef BEH_SERR_ALL_TEST
task test_err_inj;
  reg err_type;
  integer err_mem_mask;
  begin
    err_type = 0;
    err_mem_mask = ~0;
    `TB_YAP($psprintf ("injecting %0d-bit error on Type %b memories", (err_type + 1), err_mem_mask))
    testbench_beh.ip_top.err_type = err_type;
    testbench_beh.ip_top.err_mem_mask = err_mem_mask;
  end
endtask
`endif

function integer get_err_type;
  input integer num_mem_types;
  integer type_id;
  begin
`ifdef ERR_T1 type_id=1;
`elsif ERR_T2 type_id=2;
`elsif ERR_T3 type_id=3;
`elsif ERR_T4 type_id=4;
`elsif ERR_T5 type_id=5;
`elsif ERR_T6 type_id=6;
`elsif ERR_T7 type_id=7;
`elsif ERR_T8 type_id=8;
`else type_id = ({$random()} % num_mem_types) + 1;
`endif
    get_err_type = 1 << (type_id -1);
  end
endfunction

`ifdef PADDR_CHECK
integer unique_padr_check_on = 0;
wire [BITADDR-1:0] rd_adr_wire_dly [0:NUMRDPT-1];
wire [BITADDR-1:0] rw_adr_wire_dly [0:NUMRWPT-1];
reg [0:NUMRDPT-1][BITADDR-1:0] rd_adr_wire_d [MEM_DELAY-1:0];
int bus_i;
reg [0:NUMRWPT-1][BITADDR-1:0] rw_adr_wire_d [MEM_DELAY-1:0];
reg valid [DEPTH-1:0];
reg [BITPADR-1:0] ref_paddr_hash [DEPTH-1:0];
reg valid_un [DEPTH-1:0];
reg [BITPADR-1:0] ref_paddr_hash_un [DEPTH-1:0];

always @(posedge clk) begin    
  for (int bus_i=0; bus_i<NUMRDPT; bus_i=bus_i+1)
    rd_adr_wire_d[0][bus_i]<=rd_adr_wire[bus_i];

  for (int dly_i = 1; dly_i < MEM_DELAY; dly_i=dly_i+1)
    for (int bus_i=0; bus_i<NUMRDPT; bus_i=bus_i+1)
      rd_adr_wire_d[dly_i][bus_i] <= rd_adr_wire_d[dly_i-1][bus_i];
end

initial
  for(int i=0; i<DEPTH; i++)
    valid[i] = 0;

always @(posedge clk) begin
  for (bus_i=0; bus_i<NUMRDPT; bus_i=bus_i+1) begin
    if (rd_vld_wire[bus_i]) begin
      ;
//      if (valid[rd_adr_wire_d[MEM_DELAY-1][bus_i]]==1) begin
//        padr_last_bits_check_r: assert (ref_paddr_hash[rd_adr_wire_d[MEM_DELAY-1][bus_i]][BITVROW-1:0]==rd_padr_wire[bus_i][BITVROW-1:0])
//      end else begin
//        $error ("ERROR:the same addres %0b is mapped to both %0b and %0b physical addresses,lowest %0d bits of which do not match",rd_adr_wire_d[MEM_DELAY-1][bus_i],rd_padr_wire[bus_i],ref_paddr_hash[rd_adr_wire_d[MEM_DELAY-1][bus_i]],BITVROW);
//      end
    end else begin
      valid[rd_adr_wire_d[MEM_DELAY-1][bus_i]] = 1;    
      ref_paddr_hash[rd_adr_wire_d[MEM_DELAY-1][bus_i]] <= rd_padr_wire[bus_i];
    end
  end

end

initial
  for(int i=0; i<DEPTH; i++)
    valid_un[i] = 0;

always @(posedge clk) begin
  for (bus_i=0; bus_i<NUMRDPT; bus_i=bus_i+1) begin
    if (rd_vld_wire[bus_i] && unique_padr_check_on)  begin
      for(int i=0;i<DEPTH;i=i+1) begin
        if(valid_un[i]==1)begin 
          if(ref_paddr_hash_un[i] == rd_padr_wire[bus_i])
            padr_unique_check_r:assert(i==rd_adr_wire_d[MEM_DELAY-1][bus_i]) 
          else begin 
            $error ("ERROR: the physical address %0b is mapped to two addresses %0b and %0b",ref_paddr_hash_un[i],i,rd_adr_wire_d[MEM_DELAY-1][bus_i]);
          end
        end
      end 
      if (valid_un[rd_adr_wire_d[MEM_DELAY-1][bus_i]]!=1) begin 
        valid_un[rd_adr_wire_d[MEM_DELAY-1][bus_i]]=1;
        ref_paddr_hash_un[rd_adr_wire_d[MEM_DELAY-1][bus_i]]=rd_padr_wire[bus_i];
      end
    end
  end

end
`endif

function [WIDTH-1:0] randomDataWord; input integer width; integer i; begin randomDataWord = 0; for (i = width/32; i >= 0; i--) randomDataWord = (randomDataWord<< 32) + $urandom; end endfunction

//MEMOIR_SHIP_ON
task test_fast_read_all;
begin
  reg [BITADDR-1:0] addr;
  reg [WIDTH-1:0] data;
  reg match_rd;
  `TB_YAP("test_fast_read_all running") 
  for(int b=0;b<DEPTH;b=b+1) begin
    addr = b;
    testbench.ip_top.ReadTask(addr,data);
    match_rd = (memchk[addr] === data);
    if (!(match_rd ===1'b1)) begin
      `ERROR($psprintf("memory rd check failed on addr=%0d exp=0x%0x act=0x%0x", addr, memchk[addr], data))
      #2 $finish;
    end
  end
end
endtask

task test_fast_write_all;
begin
  reg [BITADDR-1:0] addr;
  reg [WIDTH-1:0] data;
  `TB_YAP("test_fast_write_all running") 
  for(int b=0;b<DEPTH;b=b+1) begin
    addr = b;
    data = randomDataWord(WIDTH);
    testbench.ip_top.WriteTask(addr,data,{WIDTH{1'b1}});
    memchk[addr] = data; 
  end
end
endtask

initial begin
  reset;
  `TB_YAP("Running tests")
  cyc(10);
  test_write_all();
  test_read_all();
  test_random(DEPTH + 20000);
  cyc(10);
  test_fast_write_all();
  cyc(10);
  test_read_all();
  test_fast_read_all();
  cyc (3);
`ifdef MEMOIR_FLOP_ARRAY
  cyc(10);
  //TODO: Fix this to not instantiate the cell name
  testbench.ip_top.mem_t1_bank0_cell_cell.ff_cell_ResetTask();
`endif
`ifdef MEMOIR_DBG_TEST
  `TB_YAP("Running debug tests")
  dbg_en = 1;
  test_dbg_write_all();
  test_dbg_read_all();
`endif
  `TB_YAP("All tests completed")
  $assertoff;
  rst = 1;
  cyc (50);
  $finish;
end

final begin
  if ((__err_cnt != 0) || matchflag) begin
    `TB_YAP($psprintf("Simulation FAILED (w=%0d e=%0d) (%s)", __warn_cnt, __err_cnt, memoir_design_name))
  end else begin
    `TB_YAP($psprintf("Simulation PASSED (w=%0d) (%s)\n", __warn_cnt, memoir_design_name))
  end
end
generate 
if(NUMWRPT>0) begin
  assign bw = {NUMWRPT*WIDTH{1'b1}};
end else if (NUMRWPT>0) begin
  assign rw_bw = {NUMRWPT*WIDTH{1'b1}};
end
  assign flopout_en = 1'b0;
endgenerate
endmodule
