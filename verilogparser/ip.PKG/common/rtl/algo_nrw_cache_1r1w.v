module algo_nrw_cache_1r1w (read, write, flush, invld, ucach, ucofst, ucsize, ucpfx, sidx, sqin, addr, byin, din, rd_vld, rd_hit, rd_serr, rd_sqout, rd_dout, rd_attr,
                            t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_serrB, t1_bidB,
                            t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_serrB, t2_bidB,
                            t3_readA, t3_writeA, t3_ucachA, t3_ucofstA, t3_ucsizeA, t3_ucpfxA, t3_sqinA, t3_addrA, t3_dinA, t3_vldA, t3_sqoutA, t3_doutA, t3_attrA,
                            pf_stall, t3_stall, t3_block,
                            e_pf_empty, e_pf_oflw, e_uc_stall, e_cache_rd_hit, e_cache_wr_hit,
                            e_tgerr_vld, e_tgerr_bid, e_tgerr_idx,
                            e_dterr_vld, e_dterr_bid, e_dterr_idx,
                            ready, clk, rst,
                            select_addr, select_bit,
                            dbg_la_pf_stall,
                            dbg_la_t3_block,
                            dbg_la_sqfifo_cnt,
                            dbg_la_sqfifo_fnd,
                            dbg_la_sqfifo_fuc,
                            dbg_la_sqfifo_fsq,
                            dbg_la_sqfifo_pop,
                            dbg_la_sqfifo_deq,
                            dbg_la_sqfifo_dsl,
                            dbg_la_sqfifo_psl,
                            dbg_la_sqfifo_ssl,
                            dbg_la_sqfifo_sdq,
                            dbg_la_sqfifo_psl_help,
                            dbg_la_sqfifo_dsq_help,
                            dbg_la_vread_vld,
                            dbg_la_twrite_wire,
                            dbg_la_twraddr_wire,
                            dbg_la_dwrite_wire,
                            dbg_la_dwraddr_wire,
                            dbg_la_data_vld,
                            dbg_la_dtag_vld,
                            dbg_la_tg_rd_vld,
                            dbg_la_dt_rd_vld,
                            dbg_la_dvld_out,
                            dbg_la_drty_out,
                            dbg_la_dlru_out,
                            dbg_la_vread_out, 
                            dbg_la_vucach_out,
                            dbg_la_vwrite_out,
                            dbg_la_vflush_out,
                            dbg_la_vfill_out,
                            dbg_la_srdwr_out,
                            dbg_la_vinvld_out,
                            dbg_la_vsidx_out,
                            dbg_la_sqfifo_hit,
                            dbg_la_sqfifo_htv,
                            dbg_la_sqfifo_hsq,
                            dbg_la_cache_hit,
                            dbg_la_cache_map,
                            dbg_la_cache_add,
                            dbg_la_cache_evt,
                            dbg_la_cache_emp,
                            dbg_la_sqfifo_vld,
                            dbg_la_sqfifo_prv,
                            dbg_la_sqfifo_rdv,
                            dbg_la_sqfifo_wrv,
                            dbg_la_sqfifo_flv,
                            dbg_la_sqfifo_inv,
                            dbg_la_sqfifo_uch,
                            dbg_la_sqfifo_idx,
                            dbg_la_sqfifo_fil
		                    );
  
  parameter BITWDTH = 5;
  parameter WIDTH = 32;
  parameter BYTWDTH = WIDTH/8;
  parameter NUMRWPT = 1;
  parameter BITSEQN = 4;
  parameter NUMADDR = 65536;
  parameter BITADDR = 16;
  parameter NUMVROW = 256; 
  parameter BITVROW = 8;
  parameter NUMWRDS = 1;
  parameter BITWRDS = 0;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 4;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter FIFOCNT = 4;
  parameter BITFIFO = 2;
  parameter BITUOFS = 5;
  parameter BITUSIZ = 8;
  parameter BITUCPF = 2;

  parameter BITXATR = 3;

  parameter NUMTGBY = 1;
  parameter NUMDTBY = 1;

  parameter BITTGBY = 4;
  parameter BITDTBY = 7;

  parameter BITDTAG = BITADDR-BITVROW;
  parameter BITTAGW = BITDTAG+BITWRDS+2;

  input [NUMRWPT-1:0]                  read;
  input [NUMRWPT-1:0]                  write;
  input [NUMRWPT-1:0]                  flush;
  input [NUMRWPT-1:0]                  invld;
  input [NUMRWPT-1:0]                  ucach;
  input [NUMRWPT-1:0]                  sidx;
  input [NUMRWPT*BITUOFS-1:0]          ucofst;
  input [NUMRWPT*BITUSIZ-1:0]          ucsize;
  input [NUMRWPT*BITUCPF-1:0]          ucpfx;
  input [NUMRWPT*BITSEQN-1:0]          sqin;
  input [NUMRWPT*BITADDR-1:0]          addr;
  input [NUMRWPT*BYTWDTH-1:0]          byin;
  input [NUMRWPT*WIDTH-1:0]            din;
  output [NUMRWPT-1:0]                 rd_vld;
  output [NUMRWPT-1:0]                 rd_hit;
  output [NUMRWPT-1:0]                 rd_serr;
  output [NUMRWPT*BITSEQN-1:0]         rd_sqout;
  output [NUMRWPT*WIDTH-1:0]           rd_dout;
  output [NUMRWPT*BITXATR-1:0]         rd_attr;

  output [NUMRWPT-1:0]                 t1_writeA;
  output [NUMRWPT*BITVROW-1:0]         t1_addrA;
  output [NUMRWPT*NUMWRDS*BITTAGW-1:0] t1_dinA;
  output [NUMRWPT-1:0]                 t1_readB;
  output [NUMRWPT*BITVROW-1:0]         t1_addrB;
  input [NUMRWPT*NUMWRDS*BITTAGW-1:0]  t1_doutB;
  input [NUMRWPT*1-1:0]                t1_serrB;
  input  [NUMRWPT*BITTGBY-1:0]         t1_bidB;

  output [NUMRWPT-1:0]                 t2_writeA;
  output [NUMRWPT*BITVROW-1:0]         t2_addrA;
  output [NUMRWPT*NUMWRDS*WIDTH-1:0]   t2_dinA;
  output [NUMRWPT-1:0]                 t2_readB;
  output [NUMRWPT*BITVROW-1:0]         t2_addrB;
  input [NUMRWPT*NUMWRDS*WIDTH-1:0]    t2_doutB;
  input [NUMRWPT*1-1:0]                t2_serrB;
  input  [NUMRWPT*BITDTBY-1:0]         t2_bidB;

  output [NUMRWPT-1:0]                 t3_readA;
  output [NUMRWPT-1:0]                 t3_writeA;
  output [NUMRWPT-1:0]                 t3_ucachA;
  output [NUMRWPT*BITUOFS-1:0]         t3_ucofstA;
  output [NUMRWPT*BITUSIZ-1:0]         t3_ucsizeA;
  output [NUMRWPT*BITUCPF-1:0]         t3_ucpfxA;
  output [NUMRWPT*BITSEQN-1:0]         t3_sqinA;
  output [NUMRWPT*BITADDR-1:0]         t3_addrA;
  output [NUMRWPT*WIDTH-1:0]           t3_dinA;
  input [NUMRWPT-1:0]                  t3_vldA;
  input [NUMRWPT*BITSEQN-1:0]          t3_sqoutA;
  input [NUMRWPT*WIDTH-1:0]            t3_doutA;
  input [NUMRWPT*BITXATR-1:0]          t3_attrA;
  
  output                               pf_stall;
  output                               t3_stall;
  input                                t3_block;

  output                               e_pf_empty;
  output                               e_pf_oflw;
  output                               e_uc_stall;
  output                               e_cache_rd_hit;
  output                               e_cache_wr_hit;
  output                               e_tgerr_vld;
  output [BITTGBY-1:0]                 e_tgerr_bid;
  output [BITVROW-1:0]                 e_tgerr_idx;
  output                               e_dterr_vld;
  output [BITDTBY-1:0]                 e_dterr_bid;
  output [BITVROW-1:0]                 e_dterr_idx;
 
  output                               ready;
  input                                clk;
  input                                rst;

  output dbg_la_pf_stall;
  output dbg_la_t3_block;
  output [BITFIFO:0] dbg_la_sqfifo_cnt;
  output dbg_la_sqfifo_fnd;
  output dbg_la_sqfifo_fuc;
  output [BITSEQN-1:0]dbg_la_sqfifo_fsq;
  output dbg_la_sqfifo_pop;
  output dbg_la_sqfifo_deq;
  output [BITFIFO-1:0]dbg_la_sqfifo_dsl;
  output [BITFIFO-1:0]dbg_la_sqfifo_psl;
  output [BITFIFO-1:0]dbg_la_sqfifo_ssl;
  output dbg_la_sqfifo_sdq;
  output [BITSEQN-1:0]dbg_la_sqfifo_psl_help;
  output [BITSEQN-1:0]dbg_la_sqfifo_dsq_help;
  output dbg_la_vread_vld;
  output dbg_la_twrite_wire;
  output [BITVROW-1:0] dbg_la_twraddr_wire;
  output dbg_la_dwrite_wire;
  output [BITVROW-1:0] dbg_la_dwraddr_wire;
  output dbg_la_data_vld;
  output dbg_la_dtag_vld;
  output dbg_la_tg_rd_vld;
  output dbg_la_dt_rd_vld;
  output [NUMWRDS-1:0]dbg_la_dvld_out;
  output [NUMWRDS-1:0]dbg_la_drty_out;
  output [NUMWRDS*BITWRDS-1:0]dbg_la_dlru_out;
  output dbg_la_vread_out; 
  output dbg_la_vucach_out;
  output dbg_la_vwrite_out;
  output dbg_la_vflush_out;
  output dbg_la_vfill_out;
  output dbg_la_srdwr_out;
  output dbg_la_vinvld_out;
  output dbg_la_vsidx_out;
  output dbg_la_sqfifo_hit;
  output dbg_la_sqfifo_htv;
  output [BITSEQN-1:0]dbg_la_sqfifo_hsq;
  output dbg_la_cache_hit;
  output [BITWRDS-1:0]dbg_la_cache_map;
  output dbg_la_cache_add;
  output dbg_la_cache_evt;
  output [BITWRDS-1:0]dbg_la_cache_emp;
  output [FIFOCNT-1:0]dbg_la_sqfifo_vld;
  output [FIFOCNT-1:0]dbg_la_sqfifo_prv;
  output [FIFOCNT-1:0]dbg_la_sqfifo_rdv;
  output [FIFOCNT-1:0]dbg_la_sqfifo_wrv;
  output [FIFOCNT-1:0]dbg_la_sqfifo_flv;
  output [FIFOCNT-1:0]dbg_la_sqfifo_inv;
  output [FIFOCNT-1:0]dbg_la_sqfifo_uch;
  output [FIFOCNT-1:0]dbg_la_sqfifo_idx;
  output [FIFOCNT-1:0]dbg_la_sqfifo_fil;


  input [BITADDR-1:0]                  select_addr;
  input [BITWDTH-1:0]                  select_bit;

  core_nrw_cache_1r1w #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMRWPT (NUMRWPT), .BITSEQN (BITSEQN), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                        .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .FIFOCNT (FIFOCNT), .BITFIFO (BITFIFO),
                        .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .BITXATR(BITXATR),
                        .BITUOFS(BITUOFS), .BITUSIZ (BITUSIZ), .BITUCPF (BITUCPF),
                        .NUMTGBY     (NUMTGBY     ), .NUMDTBY     (NUMDTBY     ), .BITTGBY     (BITTGBY     ), .BITDTBY     (BITDTBY     ))
    core (.vread(read), .vwrite(write), .vflush(flush), .vinvld(invld), .vucach(ucach), .vucofst (ucofst), .vucsize (ucsize), .vucpfx (ucpfx), .vsidx(sidx), .vsqin(sqin), .vaddr(addr), .vbyin(byin), .vdin(din), 
          .vread_vld(rd_vld), .vread_hit(rd_hit), .vread_serr(rd_serr), .vsqout(rd_sqout), .vdout(rd_dout), .vattr(rd_attr),
          .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB), .t1_serrB (t1_serrB), .t1_bidB(t1_bidB),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB), .t2_serrB (t2_serrB), .t2_bidB(t2_bidB),
          .t3_readA(t3_readA), .t3_writeA(t3_writeA), .t3_ucachA(t3_ucachA), .t3_ucofstA (t3_ucofstA), .t3_ucsizeA(t3_ucsizeA), .t3_ucpfxA(t3_ucpfxA), .t3_sqinA(t3_sqinA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), 
          .t3_vldA(t3_vldA), .t3_sqoutA(t3_sqoutA), .t3_doutA(t3_doutA), .t3_attrA(t3_attrA), .t3_stall(t3_stall), .t3_block(t3_block),
          .e_pf_empty (e_pf_empty ), .e_pf_oflw  (e_pf_oflw), .e_uc_stall (e_uc_stall), .e_cache_rd_hit(e_cache_rd_hit), .e_cache_wr_hit(e_cache_wr_hit),
          .e_tgerr_vld(e_tgerr_vld), .e_tgerr_bid(e_tgerr_bid), .e_tgerr_idx(e_tgerr_idx),
          .e_dterr_vld(e_dterr_vld), .e_dterr_bid(e_dterr_bid), .e_dterr_idx(e_dterr_idx),
          .pf_stall(pf_stall), .ready (ready), .clk (clk), .rst (rst),
          .dbg_la_pf_stall(dbg_la_pf_stall),
          .dbg_la_t3_block(dbg_la_t3_block),
          .dbg_la_sqfifo_cnt(dbg_la_sqfifo_cnt),
          .dbg_la_sqfifo_fnd(dbg_la_sqfifo_fnd),
          .dbg_la_sqfifo_fuc(dbg_la_sqfifo_fuc),
          .dbg_la_sqfifo_fsq(dbg_la_sqfifo_fsq),
          .dbg_la_sqfifo_pop(dbg_la_sqfifo_pop),
          .dbg_la_sqfifo_deq(dbg_la_sqfifo_deq),
          .dbg_la_sqfifo_dsl(dbg_la_sqfifo_dsl),
          .dbg_la_sqfifo_psl(dbg_la_sqfifo_psl),
          .dbg_la_sqfifo_ssl(dbg_la_sqfifo_ssl),
          .dbg_la_sqfifo_sdq(dbg_la_sqfifo_sdq),
          .dbg_la_sqfifo_psl_help(dbg_la_sqfifo_psl_help),
          .dbg_la_sqfifo_dsq_help(dbg_la_sqfifo_dsq_help),
          .dbg_la_vread_vld(dbg_la_vread_vld),
          .dbg_la_twrite_wire(dbg_la_twrite_wire),
          .dbg_la_twraddr_wire(dbg_la_twraddr_wire),
          .dbg_la_dwrite_wire(dbg_la_dwrite_wire),
          .dbg_la_dwraddr_wire(dbg_la_dwraddr_wire),
          .dbg_la_data_vld(dbg_la_data_vld),
          .dbg_la_dtag_vld(dbg_la_dtag_vld),
          .dbg_la_tg_rd_vld(dbg_la_tg_rd_vld),
          .dbg_la_dt_rd_vld(dbg_la_dt_rd_vld),
          .dbg_la_dvld_out(dbg_la_dvld_out),
          .dbg_la_drty_out(dbg_la_drty_out),
          .dbg_la_dlru_out(dbg_la_dlru_out),
          .dbg_la_vread_out(dbg_la_vread_out), 
          .dbg_la_vucach_out(dbg_la_vucach_out),
          .dbg_la_vwrite_out(dbg_la_vwrite_out),
          .dbg_la_vflush_out(dbg_la_vflush_out),
          .dbg_la_vfill_out(dbg_la_vfill_out),
          .dbg_la_srdwr_out(dbg_la_srdwr_out),
          .dbg_la_vinvld_out(dbg_la_vinvld_out),
          .dbg_la_vsidx_out(dbg_la_vsidx_out),
          .dbg_la_sqfifo_hit(dbg_la_sqfifo_hit),
          .dbg_la_sqfifo_htv(dbg_la_sqfifo_htv),
          .dbg_la_sqfifo_hsq(dbg_la_sqfifo_hsq),
          .dbg_la_cache_hit(dbg_la_cache_hit),
          .dbg_la_cache_map(dbg_la_cache_map),
          .dbg_la_cache_add(dbg_la_cache_add),
          .dbg_la_cache_evt(dbg_la_cache_evt),
          .dbg_la_cache_emp(dbg_la_cache_emp),
          .dbg_la_sqfifo_vld(dbg_la_sqfifo_vld),
          .dbg_la_sqfifo_prv(dbg_la_sqfifo_prv),
          .dbg_la_sqfifo_rdv(dbg_la_sqfifo_rdv),
          .dbg_la_sqfifo_wrv(dbg_la_sqfifo_wrv),
          .dbg_la_sqfifo_flv(dbg_la_sqfifo_flv),
          .dbg_la_sqfifo_inv(dbg_la_sqfifo_inv),
          .dbg_la_sqfifo_uch(dbg_la_sqfifo_uch),
          .dbg_la_sqfifo_idx(dbg_la_sqfifo_idx),
          .dbg_la_sqfifo_fil(dbg_la_sqfifo_fil)

        );

`ifdef FORMAL
  assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
  assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

  ip_top_sva_nrw_cache_1r1w #(
                              .WIDTH       (WIDTH),
                              .BITWDTH     (BITWDTH),
                              .NUMRWPT     (NUMRWPT),
                              .BITSEQN     (BITSEQN),
                              .NUMADDR     (NUMADDR),
                              .BITADDR     (BITADDR),
                              .NUMVROW     (NUMVROW),
                              .BITVROW     (BITVROW),
                              .NUMWRDS     (NUMWRDS),
                              .BITWRDS     (BITWRDS),
                              .SRAM_DELAY  (SRAM_DELAY),
                              .DRAM_DELAY  (DRAM_DELAY),
                              .FIFOCNT     (FIFOCNT),
                              .FLOPIN      (FLOPIN),
                              .FLOPOUT     (FLOPOUT))
  ip_top_sva (.*);

  ip_top_sva_2_nrw_cache_1r1w #(
                                .WIDTH       (WIDTH),
                                .NUMRWPT     (NUMRWPT),
                                .BITSEQN     (BITSEQN),
                                .NUMADDR     (NUMADDR),
                                .BITADDR     (BITADDR),
                                .NUMVROW     (NUMVROW),
                                .BITVROW     (BITVROW))
  ip_top_sva_2 (.*);

  //`else
`elsif SIM_SVA

  genvar                                sva_int;
  generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin : ip_top_sva
    wire [BITADDR-1:0] help_addr = sva_int;
    wire [BITWDTH-1:0] help_bit = sva_int;

    ip_top_sva_nrw_cache_1r1w #(
                                .WIDTH       (WIDTH),
                                .BITWDTH     (BITWDTH),
                                .NUMRWPT     (NUMRWPT),
                                .BITSEQN     (BITSEQN),
                                .NUMADDR     (NUMADDR),
                                .BITADDR     (BITADDR),
                                .NUMVROW     (NUMVROW),
                                .BITVROW     (BITVROW),
                                .NUMWRDS     (NUMWRDS),
                                .BITWRDS     (BITWRDS),
                                .SRAM_DELAY  (SRAM_DELAY),
                                .DRAM_DELAY  (DRAM_DELAY),
                                .FIFOCNT     (FIFOCNT),
                                .FLOPIN      (FLOPIN),
                                .FLOPOUT     (FLOPOUT))
    ip_top_sva (.select_addr(help_addr), .select_bit(help_bit), .*);
  end
  endgenerate

  ip_top_sva_2_nrw_cache_1r1w #(
                                .WIDTH       (WIDTH),
                                .NUMRWPT     (NUMRWPT),
                                .BITSEQN     (BITSEQN),
                                .NUMADDR     (NUMADDR),
                                .BITADDR     (BITADDR),
                                .NUMVROW     (NUMVROW),
                                .BITVROW     (BITVROW))
  ip_top_sva_2 (.*);

`endif

  endmodule
