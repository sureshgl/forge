module core_nrw_cache_1r1w (vread, vwrite, vflush, vinvld, vucach, vucofst, vucsize, vucpfx, vsidx, vsqin, vaddr, vbyin, vdin, vread_vld, vread_hit, vread_serr, vsqout, vdout, vattr,
                            t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_serrB, t1_bidB,
                            t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_serrB, t2_bidB,
                            t3_readA, t3_writeA, t3_ucachA, t3_ucofstA, t3_ucsizeA, t3_ucpfxA, t3_sqinA, t3_addrA, t3_dinA, t3_vldA, t3_sqoutA, t3_doutA, t3_attrA, t3_stall, t3_block,
                            pf_stall,
                            e_pf_empty, e_pf_oflw, e_uc_stall, e_cache_rd_hit, e_cache_wr_hit,
                            e_tgerr_vld, e_tgerr_bid, e_tgerr_idx,
                            e_dterr_vld, e_dterr_bid, e_dterr_idx,
                            ready, clk, rst,
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
  parameter NUMSEQN = 256;  // TBD
  parameter BITSEQN = 8;
  parameter NUMBEAT = 2; // TBD
  parameter BITBEAT = 1; // TBD
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
  parameter FIFOCNT = 16;
  parameter BITFIFO = 4;
  parameter BITXATR = 3;
  parameter BITUOFS = 5;
  parameter BITUSIZ = 8;
  parameter BITUCPF = 2;

  parameter NUMTGBY = 1;
  parameter NUMDTBY = 1;

  parameter BITTGBY = 4;
  parameter BITDTBY = 7;

  parameter BITVTAG = BITVROW-BITBEAT; 
  parameter BITDTAG = BITADDR-BITVROW;
  parameter BITTAGW = BITDTAG+BITWRDS+2;

  input [NUMRWPT-1:0]                  vread;
  input [NUMRWPT-1:0]                  vwrite;
  input [NUMRWPT-1:0]                  vflush;
  input [NUMRWPT-1:0]                  vinvld;
  input [NUMRWPT-1:0]                  vucach;
  input [NUMRWPT*BITUOFS-1:0]          vucofst;
  input [NUMRWPT*BITUSIZ-1:0]          vucsize;
  input [NUMRWPT*BITUCPF-1:0]          vucpfx;
  input [NUMRWPT-1:0]                  vsidx;
  input [NUMRWPT*BITSEQN-1:0]          vsqin;
  input [NUMRWPT*BITADDR-1:0]          vaddr;
  input [NUMRWPT*BYTWDTH-1:0]          vbyin;
  input [NUMRWPT*WIDTH-1:0]            vdin;
  output [NUMRWPT-1:0]                 vread_vld;
  output [NUMRWPT-1:0]                 vread_hit;
  output [NUMRWPT-1:0]                 vread_serr;
  output [NUMRWPT*BITSEQN-1:0]         vsqout;
  output [NUMRWPT*WIDTH-1:0]           vdout;
  output [NUMRWPT*BITXATR-1:0]         vattr;

  output [NUMRWPT-1:0]                 t1_writeA;
  output [NUMRWPT*BITVROW-1:0]         t1_addrA;
  output [NUMRWPT*NUMWRDS*BITTAGW-1:0] t1_dinA;
  output [NUMRWPT-1:0]                 t1_readB;
  output [NUMRWPT*BITVROW-1:0]         t1_addrB;
  input  [NUMRWPT*NUMWRDS*BITTAGW-1:0] t1_doutB;
  input  [NUMRWPT-1:0]                 t1_serrB;
  input  [NUMRWPT*BITTGBY-1:0]         t1_bidB;

  output [NUMRWPT-1:0]                 t2_writeA;
  output [NUMRWPT*BITVROW-1:0]         t2_addrA;
  output [NUMRWPT*NUMWRDS*WIDTH-1:0]   t2_dinA;
  output [NUMRWPT-1:0]                 t2_readB;
  output [NUMRWPT*BITVROW-1:0]         t2_addrB;
  input  [NUMRWPT*NUMWRDS*WIDTH-1:0]   t2_doutB;
  input  [NUMRWPT-1:0]                 t2_serrB;
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
  input  [NUMRWPT-1:0]                 t3_vldA;
  input  [NUMRWPT*BITSEQN-1:0]         t3_sqoutA;
  input  [NUMRWPT*WIDTH-1:0]           t3_doutA;
  input  [NUMRWPT*BITXATR-1:0]         t3_attrA;
  
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

  output                               dbg_la_pf_stall;
  output                               dbg_la_t3_block;
  output [BITFIFO:0]                   dbg_la_sqfifo_cnt;
  output                               dbg_la_sqfifo_fnd;
  output                               dbg_la_sqfifo_fuc;
  output [BITSEQN-1:0]                 dbg_la_sqfifo_fsq;
  output                               dbg_la_sqfifo_pop;
  output                               dbg_la_sqfifo_deq;
  output [BITFIFO-1:0]                 dbg_la_sqfifo_dsl;
  output [BITFIFO-1:0]                 dbg_la_sqfifo_psl;
  output [BITFIFO-1:0]                 dbg_la_sqfifo_ssl;
  output                               dbg_la_sqfifo_sdq;
  output [BITSEQN-1:0]                 dbg_la_sqfifo_psl_help;
  output [BITSEQN-1:0]                 dbg_la_sqfifo_dsq_help;
  output                               dbg_la_vread_vld;
  output                               dbg_la_twrite_wire;
  output [BITVROW-1:0]                 dbg_la_twraddr_wire;
  output                               dbg_la_dwrite_wire;
  output [BITVROW-1:0]                 dbg_la_dwraddr_wire;
  output                               dbg_la_data_vld;
  output                               dbg_la_dtag_vld;
  output                               dbg_la_tg_rd_vld;
  output                               dbg_la_dt_rd_vld;
  output [NUMRWPT*NUMWRDS-1:0]         dbg_la_dvld_out;
  output [NUMRWPT*NUMWRDS-1:0]         dbg_la_drty_out;
  output [NUMRWPT*NUMWRDS*BITWRDS-1:0] dbg_la_dlru_out;
  output                               dbg_la_vread_out; 
  output                               dbg_la_vucach_out;
  output                               dbg_la_vwrite_out;
  output                               dbg_la_vflush_out;
  output                               dbg_la_vfill_out;
  output                               dbg_la_srdwr_out;
  output                               dbg_la_vinvld_out;
  output                               dbg_la_vsidx_out;
  output                               dbg_la_sqfifo_hit;
  output                               dbg_la_sqfifo_htv;
  output [BITSEQN-1:0]                 dbg_la_sqfifo_hsq;
  output                               dbg_la_cache_hit;
  output [BITWRDS-1:0]                 dbg_la_cache_map;
  output                               dbg_la_cache_add;
  output                               dbg_la_cache_evt;
  output [BITWRDS-1:0]                 dbg_la_cache_emp;
  output [FIFOCNT-1:0]                 dbg_la_sqfifo_vld;
  output [FIFOCNT-1:0]                 dbg_la_sqfifo_prv;
  output [FIFOCNT-1:0]                 dbg_la_sqfifo_rdv;
  output [FIFOCNT-1:0]                 dbg_la_sqfifo_wrv;
  output [FIFOCNT-1:0]                 dbg_la_sqfifo_flv;
  output [FIFOCNT-1:0]                 dbg_la_sqfifo_inv;
  output [FIFOCNT-1:0]                 dbg_la_sqfifo_uch;
  output [FIFOCNT-1:0]                 dbg_la_sqfifo_idx;
  output [FIFOCNT-1:0]                 dbg_la_sqfifo_fil;

  reg [BITVROW:0] rstaddr;
  wire            rstvld = (rstaddr < NUMVROW);
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg ready;
  always @(posedge clk)
    ready <= !rstvld;

  reg                srdwr_out [0:NUMRWPT-1];
  reg                vread_out [0:NUMRWPT-1];
  reg                vwrite_out [0:NUMRWPT-1];
  reg                vflush_out [0:NUMRWPT-1];
  reg                vinvld_out [0:NUMRWPT-1];
  reg                vucach_out [0:NUMRWPT-1];
  reg [BITUOFS-1:0]  vucofst_out [0:NUMRWPT-1];
  reg [BITUSIZ-1:0]  vucsize_out [0:NUMRWPT-1];
  reg                vsidx_out [0:NUMRWPT-1];
  reg                vfill_out [0:NUMRWPT-1];
  reg [BITSEQN-1:0]  vsqin_out [0:NUMRWPT-1];
  reg [BITXATR-1:0]  vserr_out [0:NUMRWPT-1];
  reg [BITADDR-1:0]  vaddr_out [0:NUMRWPT-1];
  reg [BYTWDTH-1:0]  vbyin_out [0:NUMRWPT-1];
  reg [WIDTH-1:0]    vbwin_out [0:NUMRWPT-1];
  reg [WIDTH-1:0]    vdin_out [0:NUMRWPT-1];
  reg [BITUCPF-1:0]  vucpfx_out [0:NUMRWPT-1];

  reg                sread_wire [0:NUMRWPT-1];
  reg                swrite_wire [0:NUMRWPT-1];
  reg                sflush_wire [0:NUMRWPT-1];
  reg                sinvld_wire [0:NUMRWPT-1];
  reg                sucach_wire [0:NUMRWPT-1];
  reg [BITUOFS-1:0]  sucofst_wire [0:NUMRWPT-1];
  reg [BITUSIZ-1:0]  sucsize_wire [0:NUMRWPT-1];
  reg                ssidx_wire [0:NUMRWPT-1];
  reg                sfill_wire [0:NUMRWPT-1];
  reg [BITSEQN-1:0]  ssqin_wire [0:NUMRWPT-1];
  reg [BITXATR-1:0]  sserr_wire [0:NUMRWPT-1];
  reg [BITADDR-1:0]  saddr_wire [0:NUMRWPT-1];
  reg [BYTWDTH-1:0]  sbyin_wire [0:NUMRWPT-1];
  reg [WIDTH-1:0]    sdin_wire [0:NUMRWPT-1];
  reg [BITUCPF-1:0]  sucpfx_wire [0:NUMRWPT-1];

  wire               ready_wire;
  wire               srdwr_wire [0:NUMRWPT-1];
  wire               vread_wire [0:NUMRWPT-1];
  wire               vwrite_wire [0:NUMRWPT-1];
  wire               vflush_wire [0:NUMRWPT-1];
  wire               vinvld_wire [0:NUMRWPT-1];
  wire               vucach_wire [0:NUMRWPT-1];
  wire [BITUOFS-1:0] vucofst_wire [0:NUMRWPT-1];
  wire [BITUSIZ-1:0] vucsize_wire [0:NUMRWPT-1];
  wire               vsidx_wire [0:NUMRWPT-1];
  wire               vfill_wire [0:NUMRWPT-1];
  wire [BITSEQN-1:0] vsqin_wire [0:NUMRWPT-1];
  wire [BITXATR-1:0] vserr_wire [0:NUMRWPT-1];
  wire [BITADDR-1:0] vaddr_wire [0:NUMRWPT-1];
  wire [BYTWDTH-1:0] vbyin_wire [0:NUMRWPT-1];
  wire [WIDTH-1:0]   vdin_wire [0:NUMRWPT-1];
  wire [BITUCPF-1:0] vucpfx_wire [0:NUMRWPT-1];

  genvar flp_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMRWPT-1:0] vread_reg;
    reg [NUMRWPT-1:0] vwrite_reg;
    reg [NUMRWPT-1:0] vflush_reg;
    reg [NUMRWPT-1:0] vinvld_reg;
    reg [NUMRWPT-1:0] vsidx_reg;
    reg [NUMRWPT-1:0] vucach_reg;
    reg [NUMRWPT*BITUOFS-1:0] vucofst_reg;
    reg [NUMRWPT*BITUSIZ-1:0] vucsize_reg;
    reg [NUMRWPT*BITUCPF-1:0] vucpfx_reg;
    reg [NUMRWPT*BITSEQN-1:0] vsqin_reg;
    reg [NUMRWPT*BITADDR-1:0] vaddr_reg;
    reg [NUMRWPT*BYTWDTH-1:0] vbyin_reg;
    reg [NUMRWPT*WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread && {NUMRWPT{ready}};
      vwrite_reg <= vwrite && {NUMRWPT{ready}};
      vflush_reg <= vflush && {NUMRWPT{ready}};
      vinvld_reg <= vinvld && {NUMRWPT{ready}};
      vucach_reg <= vucach && {NUMRWPT{ready}};
      vucofst_reg <= vucofst;
      vucsize_reg <= vucsize;
      vsidx_reg <= vsidx;
      vsqin_reg <= vsqin;
      vaddr_reg <= vaddr;
      vbyin_reg <= vbyin;
      vdin_reg <= vdin;
      vucpfx_reg <= vucpfx;
    end

    assign ready_wire = ready_reg;
    for (flp_var=0; flp_var<NUMRWPT; flp_var=flp_var+1) begin: ct_loop
      assign srdwr_wire[flp_var] = sread_wire[flp_var] || swrite_wire[flp_var] || sflush_wire[flp_var] || sinvld_wire[flp_var];
      assign vread_wire[flp_var] = srdwr_wire[flp_var] ? sread_wire[flp_var] : vread_reg[flp_var] && (vaddr_wire[flp_var]<NUMADDR);
      assign vwrite_wire[flp_var] = srdwr_wire[flp_var] ? swrite_wire[flp_var] : vwrite_reg[flp_var] && (vaddr_wire[flp_var]<NUMADDR);
      assign vflush_wire[flp_var] = srdwr_wire[flp_var] ? sflush_wire[flp_var] : vflush_reg[flp_var] && (vaddr_wire[flp_var]<NUMADDR);
      assign vinvld_wire[flp_var] = srdwr_wire[flp_var] ? sinvld_wire[flp_var] : vinvld_reg[flp_var] && (vaddr_wire[flp_var]<NUMADDR);
      assign vucach_wire[flp_var] = srdwr_wire[flp_var] ? sucach_wire[flp_var] : vucach_reg[flp_var] && (vaddr_wire[flp_var]<NUMADDR);
      assign vucofst_wire[flp_var] = srdwr_wire[flp_var] ? sucach_wire[flp_var] : vucofst_reg >> (flp_var*BITUOFS);
      assign vucsize_wire[flp_var] = srdwr_wire[flp_var] ? sucach_wire[flp_var] : vucsize_reg >> (flp_var*BITUSIZ);
      assign vucpfx_wire[flp_var] = srdwr_wire[flp_var] ? sucach_wire[flp_var] : vucpfx_reg >> (flp_var*BITUCPF);
      assign vsqin_wire[flp_var] = srdwr_wire[flp_var] ? ssqin_wire[flp_var] : vsqin_reg >> (flp_var*BITSEQN);
      assign vserr_wire[flp_var] = srdwr_wire[flp_var] ? sserr_wire[flp_var] : {BITXATR{1'b0}};
      assign vaddr_wire[flp_var] = srdwr_wire[flp_var] ? saddr_wire[flp_var] : vaddr_reg >> (flp_var*BITADDR);
      assign vbyin_wire[flp_var] = srdwr_wire[flp_var] ? sbyin_wire[flp_var] : vbyin_reg >> (flp_var*BYTWDTH);
      assign vdin_wire[flp_var] = srdwr_wire[flp_var] ? sdin_wire[flp_var] : vdin_reg >> (flp_var*WIDTH);
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (flp_var=0; flp_var<NUMRWPT; flp_var=flp_var+1) begin: ct_loop
      assign srdwr_wire[flp_var] = sread_wire[flp_var] || swrite_wire[flp_var] || sflush_wire[flp_var] || sinvld_wire[flp_var];
      assign vread_wire[flp_var] = srdwr_wire[flp_var] ? sread_wire[flp_var] : vread[flp_var] && (vaddr_wire[flp_var]<NUMADDR) && ready;
      assign vwrite_wire[flp_var] = srdwr_wire[flp_var] ? swrite_wire[flp_var] : vwrite[flp_var] && (vaddr_wire[flp_var]<NUMADDR) && ready;
      assign vflush_wire[flp_var] = srdwr_wire[flp_var] ? sflush_wire[flp_var] : vflush[flp_var] && (vaddr_wire[flp_var]<NUMADDR) && ready;
      assign vinvld_wire[flp_var] = srdwr_wire[flp_var] ? sinvld_wire[flp_var] : vinvld[flp_var] && (vaddr_wire[flp_var]<NUMADDR) && ready;
      assign vucach_wire[flp_var] = srdwr_wire[flp_var] ? sucach_wire[flp_var] : vucach[flp_var] && (vaddr_wire[flp_var]<NUMADDR) && ready;
      assign vucofst_wire[flp_var] = srdwr_wire[flp_var] ? sucofst_wire[flp_var] : vucofst >> (flp_var*BITUOFS);
      assign vucsize_wire[flp_var] = srdwr_wire[flp_var] ? sucsize_wire[flp_var] : vucsize >> (flp_var*BITUSIZ);
      assign vucpfx_wire[flp_var] = srdwr_wire[flp_var] ? sucpfx_wire[flp_var] : vucpfx >> (flp_var*BITUCPF);
      assign vsidx_wire[flp_var] = srdwr_wire[flp_var] ? ssidx_wire[flp_var] : vsidx[flp_var] && (vaddr_wire[flp_var]<NUMADDR) && ready;
      assign vfill_wire[flp_var] = srdwr_wire[flp_var] ? sfill_wire[flp_var] : 1'b0;
      assign vsqin_wire[flp_var] = srdwr_wire[flp_var] ? ssqin_wire[flp_var] : vsqin >> (flp_var*BITSEQN);
      assign vserr_wire[flp_var] = srdwr_wire[flp_var] ? sserr_wire[flp_var] : {BITXATR{1'b0}};
      assign vaddr_wire[flp_var] = srdwr_wire[flp_var] ? saddr_wire[flp_var] : vaddr >> (flp_var*BITADDR);
      assign vbyin_wire[flp_var] = srdwr_wire[flp_var] ? sbyin_wire[flp_var] : vbyin >> (flp_var*BYTWDTH);
      assign vdin_wire[flp_var] = srdwr_wire[flp_var] ? sdin_wire[flp_var] : vdin >> (flp_var*WIDTH);
    end
  end
  endgenerate

  reg                srdwr_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg                vread_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg                vwrite_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg                vflush_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg                vinvld_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg                vucach_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [BITUOFS-1:0]  vucofst_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [BITUSIZ-1:0]  vucsize_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [BITUCPF-1:0]  vucpfx_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg                vsidx_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg                vfill_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [BITSEQN-1:0]  vsqin_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [BITXATR-1:0]  vserr_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [BITADDR-1:0]  vaddr_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [BYTWDTH-1:0]  vbyin_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]    vdin_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  integer            vdel_int, vprt_int;
  always @(posedge clk) 
    for (vdel_int=0; vdel_int<SRAM_DELAY; vdel_int=vdel_int+1)
      if (vdel_int>0) begin
        for (vprt_int=0; vprt_int<NUMRWPT; vprt_int=vprt_int+1) begin
          srdwr_reg[vprt_int][vdel_int] <= srdwr_reg[vprt_int][vdel_int-1];
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
          vwrite_reg[vprt_int][vdel_int] <= vwrite_reg[vprt_int][vdel_int-1];
          vflush_reg[vprt_int][vdel_int] <= vflush_reg[vprt_int][vdel_int-1];
          vinvld_reg[vprt_int][vdel_int] <= vinvld_reg[vprt_int][vdel_int-1];
          vucach_reg[vprt_int][vdel_int] <= vucach_reg[vprt_int][vdel_int-1];
          vucofst_reg[vprt_int][vdel_int] <= vucofst_reg[vprt_int][vdel_int-1];
          vucsize_reg[vprt_int][vdel_int] <= vucsize_reg[vprt_int][vdel_int-1];
          vsidx_reg[vprt_int][vdel_int] <= vsidx_reg[vprt_int][vdel_int-1];
          vfill_reg[vprt_int][vdel_int] <= vfill_reg[vprt_int][vdel_int-1];
          vsqin_reg[vprt_int][vdel_int] <= vsqin_reg[vprt_int][vdel_int-1];
          vserr_reg[vprt_int][vdel_int] <= vserr_reg[vprt_int][vdel_int-1];
          vaddr_reg[vprt_int][vdel_int] <= vaddr_reg[vprt_int][vdel_int-1];
          vbyin_reg[vprt_int][vdel_int] <= vbyin_reg[vprt_int][vdel_int-1];
          vdin_reg[vprt_int][vdel_int] <= vdin_reg[vprt_int][vdel_int-1];
          vucpfx_reg[vprt_int][vdel_int] <= vucpfx_reg[vprt_int][vdel_int-1];
        end
      end else begin
        for (vprt_int=0; vprt_int<NUMRWPT; vprt_int=vprt_int+1) begin
          srdwr_reg[vprt_int][vdel_int] <= srdwr_wire[vprt_int];
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
          vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int];
          vflush_reg[vprt_int][vdel_int] <= vflush_wire[vprt_int];
          vinvld_reg[vprt_int][vdel_int] <= vinvld_wire[vprt_int];
          vucach_reg[vprt_int][vdel_int] <= vucach_wire[vprt_int];
          vucofst_reg[vprt_int][vdel_int] <= vucofst_wire[vprt_int];
          vucsize_reg[vprt_int][vdel_int] <= vucsize_wire[vprt_int];
          vsidx_reg[vprt_int][vdel_int] <= vsidx_wire[vprt_int];
          vfill_reg[vprt_int][vdel_int] <= vfill_wire[vprt_int];
          vsqin_reg[vprt_int][vdel_int] <= vsqin_wire[vprt_int];
          vserr_reg[vprt_int][vdel_int] <= vserr_wire[vprt_int];
          vaddr_reg[vprt_int][vdel_int] <= vaddr_wire[vprt_int];
          vbyin_reg[vprt_int][vdel_int] <= vbyin_wire[vprt_int];
          vdin_reg[vprt_int][vdel_int] <= vdin_wire[vprt_int];
          vucpfx_reg[vprt_int][vdel_int] <= vucpfx_wire[vprt_int];
        end
      end

  reg               pread_wire [0:NUMRWPT-1];
  reg               pwrite_wire [0:NUMRWPT-1];
  reg               pucach_wire [0:NUMRWPT-1];
  reg [BITUOFS-1:0] pucofst_wire[0:NUMRWPT-1];
  reg [BITUSIZ-1:0] pucsize_wire[0:NUMRWPT-1];
  reg [BITUCPF-1:0] pucpfx_wire[0:NUMRWPT-1];
  reg [BITSEQN-1:0] pseq_wire [0:NUMRWPT-1];
  reg [BITADDR-1:0] paddr_wire [0:NUMRWPT-1];
  reg [WIDTH-1:0]   pdin_wire [0:NUMRWPT-1];

  integer vout_int, vwpt_int;
  always_comb
    for (vout_int=0; vout_int<NUMRWPT; vout_int=vout_int+1) begin
      srdwr_out[vout_int] = srdwr_reg[vout_int][SRAM_DELAY-1];
      vread_out[vout_int] = vread_reg[vout_int][SRAM_DELAY-1];
      vwrite_out[vout_int] = vwrite_reg[vout_int][SRAM_DELAY-1];
      vflush_out[vout_int] = vflush_reg[vout_int][SRAM_DELAY-1];
      vinvld_out[vout_int] = vinvld_reg[vout_int][SRAM_DELAY-1];
      vucach_out[vout_int] = vucach_reg[vout_int][SRAM_DELAY-1];
      vucofst_out[vout_int] = vucofst_reg[vout_int][SRAM_DELAY-1];
      vucsize_out[vout_int] = vucsize_reg[vout_int][SRAM_DELAY-1];
      vsidx_out[vout_int] = vsidx_reg[vout_int][SRAM_DELAY-1];
      vfill_out[vout_int] = vfill_reg[vout_int][SRAM_DELAY-1];
      vsqin_out[vout_int] = vsqin_reg[vout_int][SRAM_DELAY-1];
      vserr_out[vout_int] = vserr_reg[vout_int][SRAM_DELAY-1];
      vaddr_out[vout_int] = vaddr_reg[vout_int][SRAM_DELAY-1];
      vbyin_out[vout_int] = vbyin_reg[vout_int][SRAM_DELAY-1];
      vucpfx_out[vout_int] = vucpfx_reg[vout_int][SRAM_DELAY-1];
      vbwin_out[vout_int] = 0;
      for (vwpt_int=0; vwpt_int<BYTWDTH; vwpt_int=vwpt_int+1)
        vbwin_out[vout_int] = vbwin_out[vout_int] | ({8{vbyin_out[vout_int][vwpt_int]}} << (vwpt_int*8));
      vdin_out[vout_int] = vdin_reg[vout_int][SRAM_DELAY-1];
      for (vwpt_int=0; vwpt_int<NUMRWPT; vwpt_int=vwpt_int+1)
        if (pwrite_wire[vwpt_int] && !pucach_wire[vwpt_int] && (paddr_wire[vwpt_int]==vaddr_out[vout_int]) && !vucach_out[vout_int])
          if (vwrite_out[vout_int] && !vucach_out[vout_int])
            vdin_out[vout_int] = (vbwin_out[vout_int] & vdin_out[vout_int]) | (~vbwin_out[vout_int] & pdin_wire[vwpt_int]);
          else
            vdin_out[vout_int] = pdin_wire[vwpt_int];
    end

  reg [NUMRWPT-1:0]          t1_readB;
  reg [NUMRWPT*BITVROW-1:0]  t1_addrB;
  integer t1rp_int, t1ra_int;
  always_comb begin
    t1_readB = 0;
    t1_addrB = 0;
    for (t1rp_int=0; t1rp_int<NUMRWPT; t1rp_int=t1rp_int+1) begin
      if ((vread_wire[t1rp_int] || vwrite_wire[t1rp_int] || vflush_wire[t1rp_int] || vinvld_wire[t1rp_int]) && !vucach_wire[t1rp_int])
        t1_readB = t1_readB | (1'b1 << t1rp_int);
      for (t1ra_int=0; t1ra_int<BITVROW; t1ra_int=t1ra_int+1)
        t1_addrB[t1rp_int*BITVROW+t1ra_int] = vaddr_wire[t1rp_int][t1ra_int];
    end
  end

  reg [NUMRWPT-1:0]          t2_readB;
  reg [NUMRWPT*BITVROW-1:0]  t2_addrB;
  integer t2rp_int, t2ra_int;
  always_comb begin
    t2_readB = 0;
    t2_addrB = 0;
    for (t2rp_int=0; t2rp_int<NUMRWPT; t2rp_int=t2rp_int+1) begin
      if ((vread_wire[t2rp_int] || vwrite_wire[t2rp_int] || vflush_wire[t2rp_int]) && !vucach_wire[t2rp_int])
        t2_readB = t2_readB | (1'b1 << t2rp_int);
      for (t2ra_int=0; t2ra_int<BITVROW; t2ra_int=t2ra_int+1)
        t2_addrB[t2rp_int*BITVROW+t2ra_int] = vaddr_wire[t2rp_int][t2ra_int];
    end
  end

  reg [NUMWRDS*BITTAGW-1:0] tdout_wire [0:NUMRWPT-1];
  reg [NUMWRDS*WIDTH-1:0]   ddout_wire [0:NUMRWPT-1];
  integer pdop_int;
  always_comb
    for (pdop_int=0; pdop_int<NUMRWPT; pdop_int=pdop_int+1) begin
      tdout_wire[pdop_int] = t1_doutB >> (pdop_int*NUMWRDS*BITTAGW);
      ddout_wire[pdop_int] = t2_doutB >> (pdop_int*NUMWRDS*WIDTH);
    end

  reg                       twrite_wire [0:NUMRWPT-1];
  reg [BITVROW-1:0]         twraddr_wire [0:NUMRWPT-1];
  reg [NUMWRDS*BITTAGW-1:0] tdin_wire [0:NUMRWPT-1];

  reg                       dtag_vld [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [NUMWRDS*BITTAGW-1:0] dtag_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  genvar tprt_var, tfwd_var;
  generate
    for (tfwd_var=0; tfwd_var<SRAM_DELAY; tfwd_var=tfwd_var+1) begin: dt_loop
      for (tprt_var=0; tprt_var<NUMRWPT; tprt_var=tprt_var+1) begin: rw_loop
        reg [BITVROW-1:0] vaddr_temp;
        reg dtag_vld_next;
        reg [NUMWRDS*BITTAGW-1:0] dtag_reg_next;
        integer fwpt_int;
        always_comb begin
          if (tfwd_var>0) begin
            vaddr_temp = vaddr_reg[tprt_var][tfwd_var-1];
            dtag_vld_next = dtag_vld[tprt_var][tfwd_var-1];
            dtag_reg_next = dtag_reg[tprt_var][tfwd_var-1];
          end else begin
            vaddr_temp = vaddr_wire[tprt_var];
            dtag_vld_next = 1'b0;
            dtag_reg_next = 0;
          end
          for (fwpt_int=0; fwpt_int<NUMRWPT; fwpt_int=fwpt_int+1)
            if (twrite_wire[fwpt_int] && (twraddr_wire[fwpt_int] == vaddr_temp)) begin
              dtag_vld_next = 1'b1;
              dtag_reg_next = tdin_wire[fwpt_int];
            end
        end

        always @(posedge clk) begin
          dtag_vld[tprt_var][tfwd_var] <= dtag_vld_next;
          dtag_reg[tprt_var][tfwd_var] <= dtag_reg_next;
        end
      end
    end
  endgenerate

  reg                     dwrite_wire [0:NUMRWPT-1];
  reg [BITVROW-1:0]       dwraddr_wire [0:NUMRWPT-1];
  reg [NUMWRDS*WIDTH-1:0] ddin_wire [0:NUMRWPT-1];

  reg                     data_vld [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [NUMWRDS*WIDTH-1:0] data_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  genvar dprt_var, dfwd_var;
  generate
    for (dfwd_var=0; dfwd_var<SRAM_DELAY; dfwd_var=dfwd_var+1) begin: da_loop
      for (dprt_var=0; dprt_var<NUMRWPT; dprt_var=dprt_var+1) begin: rw_loop
        reg [BITVROW-1:0] vaddr_temp;
        reg data_vld_next;
        reg [NUMWRDS*WIDTH-1:0] data_reg_next;
        integer fwpt_int;
        always_comb begin
          if (dfwd_var>0) begin
            vaddr_temp = vaddr_reg[dprt_var][dfwd_var-1];
            data_vld_next = data_vld[dprt_var][dfwd_var-1];
            data_reg_next = data_reg[dprt_var][dfwd_var-1];
          end else begin
            vaddr_temp = vaddr_wire[dprt_var];
            data_vld_next = 1'b0;
            data_reg_next = 0;
          end
          for (fwpt_int=0; fwpt_int<NUMRWPT; fwpt_int=fwpt_int+1)
            if (dwrite_wire[fwpt_int] && (dwraddr_wire[fwpt_int] == vaddr_temp)) begin
              data_vld_next = 1'b1;
              data_reg_next = ddin_wire[fwpt_int];
            end
        end

        always @(posedge clk) begin
          data_vld[dprt_var][dfwd_var] <= data_vld_next;
          data_reg[dprt_var][dfwd_var] <= data_reg_next;
        end
      end
    end
  endgenerate

  reg [NUMWRDS*BITTAGW-1:0] dtag_out [0:NUMRWPT-1];
  reg [NUMWRDS*WIDTH-1:0]   data_out [0:NUMRWPT-1];
  integer fwdp_int, fwdd_int;
  always_comb
    for (fwdp_int=0; fwdp_int<NUMRWPT; fwdp_int=fwdp_int+1) begin
      dtag_out[fwdp_int] = tdout_wire[fwdp_int];
      if (dtag_vld[fwdp_int][SRAM_DELAY-1])
        dtag_out[fwdp_int] = dtag_reg[fwdp_int][SRAM_DELAY-1];
      for (fwdd_int=0; fwdd_int<NUMRWPT; fwdd_int=fwdd_int+1)
        if (twrite_wire[fwdd_int] && (twraddr_wire[fwdd_int]==vaddr_out[fwdp_int][BITVROW-1:0]))
          dtag_out[fwdp_int] = tdin_wire[fwdd_int];
      data_out[fwdp_int] = ddout_wire[fwdp_int];
      if (data_vld[fwdp_int][SRAM_DELAY-1])
        data_out[fwdp_int] = data_reg[fwdp_int][SRAM_DELAY-1];
      for (fwdd_int=0; fwdd_int<NUMRWPT; fwdd_int=fwdd_int+1)
        if (dwrite_wire[fwdd_int] && (dwraddr_wire[fwdd_int]==vaddr_out[fwdp_int][BITVROW-1:0]))
          data_out[fwdp_int] = ddin_wire[fwdd_int];
    end

  reg               dvld_out [0:NUMRWPT-1][0:NUMWRDS-1];
  reg               drty_out [0:NUMRWPT-1][0:NUMWRDS-1];
  reg [BITWRDS-1:0] dlru_out [0:NUMRWPT-1][0:NUMWRDS-1];
  reg [BITDTAG-1:0] dmap_out [0:NUMRWPT-1][0:NUMWRDS-1];
  reg [WIDTH-1:0]   ddat_out [0:NUMRWPT-1][0:NUMWRDS-1];
  integer dvlp_int, dvlb_int;
  always_comb
    for (dvlp_int=0; dvlp_int<NUMRWPT; dvlp_int=dvlp_int+1)
      for (dvlb_int=0; dvlb_int<NUMWRDS; dvlb_int=dvlb_int+1) begin
        dvld_out[dvlp_int][dvlb_int] = dtag_out[dvlp_int] >> ((dvlb_int*BITTAGW)+BITDTAG+BITWRDS+1);
        drty_out[dvlp_int][dvlb_int] = dtag_out[dvlp_int] >> ((dvlb_int*BITTAGW)+BITDTAG+BITWRDS);
        dlru_out[dvlp_int][dvlb_int] = dtag_out[dvlp_int] >> ((dvlb_int*BITTAGW)+BITDTAG);
        dmap_out[dvlp_int][dvlb_int] = dtag_out[dvlp_int] >> (dvlb_int*BITTAGW);
        ddat_out[dvlp_int][dvlb_int] = data_out[dvlp_int] >> (dvlb_int*WIDTH);
      end

  reg               sqfifo_hit [0:NUMRWPT-1];
  reg               sqfifo_htv [0:NUMRWPT-1];
  reg [WIDTH-1:0]   sqfifo_hda [0:NUMRWPT-1];
  reg [BITSEQN-1:0] sqfifo_hsq [0:NUMRWPT-1];
  reg               cache_hit [0:NUMRWPT-1];
  reg [BITWRDS-1:0] cache_map [0:NUMRWPT-1];
  reg               cache_add [0:NUMRWPT-1];
  reg               cache_evt [0:NUMRWPT-1];
  reg [BITWRDS-1:0] cache_emp [0:NUMRWPT-1];
  integer casp_int, casb_int;
  always_comb
    for (casp_int=0; casp_int<NUMRWPT; casp_int=casp_int+1) begin
      cache_hit[casp_int] = 1'b0;
      cache_map[casp_int] = 0;
      cache_add[casp_int] = srdwr_out[casp_int] && vfill_out[casp_int];
      cache_evt[casp_int] = srdwr_out[casp_int] && vfill_out[casp_int];
      cache_emp[casp_int] = 0;
      for (casb_int=0; casb_int<NUMWRDS; casb_int=casb_int+1) begin
        if (dvld_out[casp_int][casb_int] && (vsidx_out[casp_int] ? (srdwr_out[casp_int] && vinvld_out[casp_int]) ||
                                                                   (srdwr_out[casp_int] && vflush_out[casp_int] && drty_out[casp_int][casb_int]) :
                                             (dmap_out[casp_int][casb_int]==vaddr_out[casp_int][BITADDR-1:BITVROW]))) begin
          cache_hit[casp_int] = 1'b1;
          cache_map[casp_int] = casb_int;
        end
        if (!dvld_out[casp_int][casb_int]) begin
          cache_evt[casp_int] = 1'b0;
          cache_emp[casp_int] = casb_int;
        end
      end
      for (casb_int=0; casb_int<NUMWRDS; casb_int=casb_int+1)
        if (cache_evt[casp_int] && (dlru_out[casp_int][casb_int]==(NUMWRDS-1)))
          cache_emp[casp_int] = casb_int;
      cache_add[casp_int] = cache_add[casp_int] && !cache_hit[casp_int] && !cache_evt[casp_int];
      cache_evt[casp_int] = cache_evt[casp_int] && !cache_hit[casp_int];
      if (vflush_out[casp_int])
        cache_emp[casp_int] = cache_map[casp_int];
    end

  reg [BITWRDS-1:0] dlru_nxt [0:NUMRWPT-1][0:NUMWRDS-1];
  integer lrup_int, lruw_int;
  always_comb
    for (lrup_int=0; lrup_int<NUMRWPT; lrup_int=lrup_int+1)
      for (lruw_int=0; lruw_int<NUMWRDS; lruw_int=lruw_int+1) begin
        dlru_nxt[lrup_int][lruw_int] = dlru_out[lrup_int][lruw_int];
        if ((cache_hit[lrup_int] && !vinvld_out[lrup_int] && !(|vserr_out[lrup_int]) && (dlru_out[lrup_int][lruw_int] < dlru_out[lrup_int][cache_map[lrup_int]])) ||
            (cache_evt[lrup_int] && (dlru_out[lrup_int][lruw_int] < dlru_out[lrup_int][cache_emp[lrup_int]])) ||
            (cache_add[lrup_int]))
          dlru_nxt[lrup_int][lruw_int] = dvld_out[lrup_int][lruw_int] ? dlru_out[lrup_int][lruw_int]+1 : 0;
        if (cache_hit[lrup_int] && (vinvld_out[lrup_int] || |vserr_out[lrup_int]) && (dlru_out[lrup_int][lruw_int] > dlru_out[lrup_int][cache_map[lrup_int]]))
          dlru_nxt[lrup_int][lruw_int] = dvld_out[lrup_int][lruw_int] ? dlru_out[lrup_int][lruw_int]-1 : 0;
        if (!cache_hit[lrup_int] && |vserr_out[lrup_int])
          dlru_nxt[lrup_int][lruw_int] = dlru_out[lrup_int][lruw_int];
      end

  reg  [NUMRWPT-1:0]         tg_rd_vld;
  reg  [NUMRWPT-1:0]         dt_rd_vld;
  wire [NUMRWPT-1:0]         tg_serr;
  wire [NUMRWPT-1:0]         dt_serr;  
  always @(posedge clk) begin
    tg_rd_vld <= t1_readB; 
    dt_rd_vld <= t2_readB;             
  end

  assign tg_serr = t1_serrB && tg_rd_vld;
  assign dt_serr = t2_serrB && dt_rd_vld;

  reg                       twrite_next [0:NUMRWPT-1];
  reg [BITVROW-1:0]         twraddr_next [0:NUMRWPT-1];
  reg [NUMWRDS*BITTAGW-1:0] tdin_next [0:NUMRWPT-1];
  integer twr_int, twx_int;
  always_comb
    for (twr_int=0; twr_int<NUMRWPT; twr_int=twr_int+1) begin
      twrite_next[twr_int] = 1'b0;
      twraddr_next[twr_int] = 0;
      tdin_next[twr_int] = 0;
      if (!rst && rstvld && (twr_int==0)) begin
        twrite_next[twr_int] = 1'b1;
        twraddr_next[twr_int] = rstaddr;
        tdin_next[twr_int] = 0;
      end else if (srdwr_out[twr_int] && !cache_hit[twr_int] && !vflush_out[twr_int] && !vinvld_out[twr_int] && !vucach_out[twr_int] && vfill_out[twr_int]) begin
        twrite_next[twr_int] = 1'b1;
        twraddr_next[twr_int] = vaddr_out[twr_int];
        for (twx_int=0; twx_int<NUMWRDS; twx_int=twx_int+1)
          if (cache_emp[twr_int]==twx_int)
            tdin_next[twr_int] = tdin_next[twr_int] |
                                 ({(1'b1 && !(|vserr_out[twr_int])),vwrite_out[twr_int],2'b00,vaddr_out[twr_int][BITADDR-1:BITVROW]} << (twx_int*BITTAGW));
          else
            tdin_next[twr_int] = tdin_next[twr_int] |
                                 ({dvld_out[twr_int][twx_int],drty_out[twr_int][twx_int],dlru_nxt[twr_int][twx_int],dmap_out[twr_int][twx_int]} << (twx_int*BITTAGW));
      end else if (((vread_out[twr_int] || vwrite_out[twr_int] || vflush_out[twr_int] || vinvld_out[twr_int]) && (srdwr_out[twr_int] || !sqfifo_hit[twr_int]) && cache_hit[twr_int] && !vucach_out[twr_int]) ||
                   (|vserr_out[twr_int] && cache_hit[twr_int] && !vucach_out[twr_int])) begin
        twrite_next[twr_int] = 1'b1;
        twraddr_next[twr_int] = vaddr_out[twr_int];
        for (twx_int=0; twx_int<NUMWRDS; twx_int=twx_int+1)
          if (cache_map[twr_int]==twx_int)
            tdin_next[twr_int] = tdin_next[twr_int] |
                                 ({(!vinvld_out[twr_int] && !(|vserr_out[twr_int])),((!vflush_out[twr_int] && drty_out[twr_int][twx_int]) || vwrite_out[twr_int]),2'b00,dmap_out[twr_int][twx_int]} << (twx_int*BITTAGW));
          else
            tdin_next[twr_int] = tdin_next[twr_int] |
                                 ({dvld_out[twr_int][twx_int],drty_out[twr_int][twx_int],dlru_nxt[twr_int][twx_int],dmap_out[twr_int][twx_int]} << (twx_int*BITTAGW));
      end 
      if (tg_serr[twr_int] || dt_serr[twr_int])
        twrite_next[twr_int] = 1'b0;
    end

  integer twd_int;
  always @(posedge clk)
    for (twd_int=0; twd_int<NUMRWPT; twd_int=twd_int+1) begin
      twrite_wire[twd_int] <= twrite_next[twd_int];
      twraddr_wire[twd_int] <= twraddr_next[twd_int];
      tdin_wire[twd_int] <= tdin_next[twd_int];
    end

  reg                     dwrite_next [0:NUMRWPT-1];
  reg [BITVROW-1:0]       dwraddr_next [0:NUMRWPT-1];
  reg [NUMWRDS*WIDTH-1:0] ddin_next [0:NUMRWPT-1];
  integer dwr_int, dwx_int;
  always_comb
    for (dwr_int=0; dwr_int<NUMRWPT; dwr_int=dwr_int+1) begin
      dwrite_next[dwr_int] = 1'b0;
      dwraddr_next[dwr_int] = 0;
      ddin_next[dwr_int] = 0;
      if (!rst && rstvld && (dwr_int==0)) begin
        dwrite_next[dwr_int] = 1'b1;
        dwraddr_next[dwr_int] = rstaddr;
        ddin_next[dwr_int] = 0;
      end else if (srdwr_out[dwr_int] && !vucach_out[dwr_int] && vfill_out[dwr_int]) begin
        dwrite_next[dwr_int] = 1'b1;
        dwraddr_next[dwr_int] = vaddr_out[dwr_int];
        if (cache_hit[dwr_int]) begin
          for (dwx_int=0; dwx_int<NUMWRDS; dwx_int=dwx_int+1)
            if (cache_map[dwr_int]==dwx_int)
              ddin_next[dwr_int] = ddin_next[dwr_int] | (((vbwin_out[dwr_int]&vdin_out[dwr_int]) | (~vbwin_out[dwr_int]&ddat_out[dwr_int][dwx_int])) << (dwx_int*WIDTH));
            else
              ddin_next[dwr_int] = ddin_next[dwr_int] | (ddat_out[dwr_int][dwx_int] << (dwx_int*WIDTH));
        end else begin
          for (dwx_int=0; dwx_int<NUMWRDS; dwx_int=dwx_int+1)
            if (cache_emp[dwr_int]==dwx_int)
              ddin_next[dwr_int] = ddin_next[dwr_int] | (vdin_out[dwr_int] << (dwx_int*WIDTH));
            else
              ddin_next[dwr_int] = ddin_next[dwr_int] | (ddat_out[dwr_int][dwx_int] << (dwx_int*WIDTH));
        end
      end else if (vwrite_out[dwr_int] && !sqfifo_hit[dwr_int] && cache_hit[dwr_int] && !vucach_out[dwr_int]) begin
        dwrite_next[dwr_int] = 1'b1;
        dwraddr_next[dwr_int] = vaddr_out[dwr_int];
        for (dwx_int=0; dwx_int<NUMWRDS; dwx_int=dwx_int+1)
          if (cache_map[dwr_int]==dwx_int)
            ddin_next[dwr_int] = ddin_next[dwr_int] | (((vbwin_out[dwr_int]&vdin_out[dwr_int]) | (~vbwin_out[dwr_int]&ddat_out[dwr_int][dwx_int])) << (dwx_int*WIDTH));
          else
            ddin_next[dwr_int] = ddin_next[dwr_int] | (ddat_out[dwr_int][dwx_int] << (dwx_int*WIDTH));
      end
      if (tg_serr[dwr_int] || dt_serr[dwr_int] || |vserr_out[dwr_int])
        dwrite_next[dwr_int] = 1'b0;
    end

  integer dwd_int;
  always @(posedge clk)
    for (dwd_int=0; dwd_int<NUMRWPT; dwd_int=dwd_int+1) begin
      dwrite_wire[dwd_int] <= dwrite_next[dwd_int];
      dwraddr_wire[dwd_int] <= dwraddr_next[dwd_int];
      ddin_wire[dwd_int] <= ddin_next[dwd_int];
    end

  reg               pwrite_temp [0:NUMRWPT-1];
  integer pwrt_int;
  always_comb
    for (pwrt_int=0; pwrt_int<NUMRWPT; pwrt_int=pwrt_int+1) begin
      pwrite_temp[pwrt_int] = (srdwr_out[pwrt_int] && cache_evt[pwrt_int] && drty_out[pwrt_int][cache_emp[pwrt_int]] && !vflush_out[pwrt_int] && !vinvld_out[pwrt_int] && !vucach_out[pwrt_int]) ||
                              (vflush_out[pwrt_int] && (srdwr_out[pwrt_int] || !sqfifo_hit[pwrt_int]) && cache_hit[pwrt_int] && drty_out[pwrt_int][cache_emp[pwrt_int]]) ||
                              (!srdwr_out[pwrt_int] && vucach_out[pwrt_int] && vwrite_out[pwrt_int]);
    end

  reg [BITADDR-1:0] paddr_wire_nxt [0:NUMRWPT-1];
  reg               pread_wire_int [0:NUMRWPT-1];
  always_comb
    for (integer i=0;i<NUMRWPT;i++) begin
      paddr_wire_nxt[i] = (pwrite_temp[i] && !vucach_out[i]) ? {dmap_out[i][cache_emp[i]],vaddr_out[i][BITVROW-1:0]} : vaddr_out[i];
      pread_wire_int[i] = (((vread_out[i] || vwrite_out[i]) && !sqfifo_hit[i] && !cache_hit[i] && !vucach_out[i] && !(tg_serr[i] || dt_serr[i])) || (!srdwr_out[i] && vucach_out[i] && vread_out[i]));
    end 

  integer pwr_int;
  always @(posedge clk)
    for (pwr_int=0; pwr_int<NUMRWPT; pwr_int=pwr_int+1) begin
//    pread_wire[pwr_int] <= !srdwr_out[pwr_int] && (((vread_out[pwr_int] || vwrite_out[pwr_int]) && !sqfifo_hit[pwr_int] && !cache_hit[pwr_int] && !vucach_out[pwr_int]) ||
      pread_wire[pwr_int] <= pread_wire_int[pwr_int];
      pwrite_wire[pwr_int] <= pwrite_temp[pwr_int];
      pucach_wire[pwr_int] <= vucach_out[pwr_int];
      pseq_wire[pwr_int] <= vsqin_out[pwr_int];
      paddr_wire[pwr_int] <= paddr_wire_nxt[pwr_int]; 
      pdin_wire[pwr_int] <= vucach_out[pwr_int] ? vdin_out[pwr_int] : ddat_out[pwr_int][cache_emp[pwr_int]];
      pucofst_wire[pwr_int] <= vucofst_out[pwr_int];
      pucsize_wire[pwr_int] <= vucsize_out[pwr_int];
      pucpfx_wire[pwr_int] <= vucpfx_out[pwr_int];
    end

  reg               sqfifo_fnd [0:NUMRWPT-1];
  reg               sqfifo_fuc [0:NUMRWPT-1];
  reg [BITSEQN-1:0] sqfifo_fsq [0:NUMRWPT-1];
  reg [BITADDR-1:0] sqfifo_fad [0:NUMRWPT-1];
  reg [WIDTH-1:0]   sqfifo_fda [0:NUMRWPT-1];
  reg               sqfifo_deq [0:NUMRWPT-1];
  reg [BITFIFO-1:0] sqfifo_dsl [0:NUMRWPT-1];
  reg               sqfifo_pop [0:NUMRWPT-1];
  reg [BITFIFO-1:0] sqfifo_psl [0:NUMRWPT-1];
  reg               sqfifo_sdq [0:NUMRWPT-1];
  reg [BITFIFO-1:0] sqfifo_ssl [0:NUMRWPT-1];
  reg [BITSEQN-1:0] sqfifo_psl_help [0:NUMRWPT-1];

  reg                vsqwr_nxt [0:NUMRWPT-1];
  reg                vsqpp_nxt [0:NUMRWPT-1];
  reg                vsqvld_nxt [0:NUMRWPT-1];
  reg                vprvld_nxt [0:NUMRWPT-1];
  reg                vread_nxt [0:NUMRWPT-1];
  reg                vwrite_nxt [0:NUMRWPT-1];
  reg                vflush_nxt [0:NUMRWPT-1];
  reg                vinvld_nxt [0:NUMRWPT-1];
  reg                vucach_nxt [0:NUMRWPT-1];
  reg [BITUOFS-1:0]  vucofst_nxt [0:NUMRWPT-1];
  reg [BITUSIZ-1:0]  vucsize_nxt [0:NUMRWPT-1];
  reg [BITUCPF-1:0]  vucpfx_nxt [0:NUMRWPT-1];
  reg                vsidx_nxt [0:NUMRWPT-1];
  reg                vfill_nxt [0:NUMRWPT-1];
  reg [BITSEQN-1:0]  vsqin_nxt [0:NUMRWPT-1];
  reg [BITADDR-1:0]  vaddr_nxt [0:NUMRWPT-1];
  reg [BYTWDTH-1:0]  vbyin_nxt [0:NUMRWPT-1];
  reg [WIDTH-1:0]    vbwin_nxt [0:NUMRWPT-1];
  reg [WIDTH-1:0]    vdin_nxt [0:NUMRWPT-1];
  integer vnxt_int, vnfd_int;
  always @(posedge clk)
    for (vnxt_int=0; vnxt_int<NUMRWPT; vnxt_int=vnxt_int+1) begin
      vsqwr_nxt[vnxt_int]  <= (!srdwr_out[vnxt_int] && vread_out[vnxt_int]  && !vucach_out[vnxt_int] && (sqfifo_hit[vnxt_int] || !cache_hit[vnxt_int]) && !(tg_serr[vnxt_int] || dt_serr[vnxt_int])) ||
                              (!srdwr_out[vnxt_int] && vwrite_out[vnxt_int] && !vucach_out[vnxt_int] && (sqfifo_hit[vnxt_int] || !cache_hit[vnxt_int]) && !(tg_serr[vnxt_int] || dt_serr[vnxt_int])) ||
                              (!srdwr_out[vnxt_int] && vinvld_out[vnxt_int] && sqfifo_hit[vnxt_int] && !tg_serr[vnxt_int]) ||
                              (!srdwr_out[vnxt_int] && vflush_out[vnxt_int] && sqfifo_hit[vnxt_int] && !tg_serr[vnxt_int]) ||
                              (!srdwr_out[vnxt_int] && vucach_out[vnxt_int]);
      vsqpp_nxt[vnxt_int]  <= (vread_out[vnxt_int]   && vfill_out[vnxt_int]) ||
                              (vwrite_out[vnxt_int]  && vfill_out[vnxt_int]) ||
                              (vread_out[vnxt_int]   && !vfill_out[vnxt_int] && !sqfifo_hit[vnxt_int] && cache_hit[vnxt_int] && !vucach_out[vnxt_int]) ||
                              (vwrite_out[vnxt_int]  && !vfill_out[vnxt_int] && !sqfifo_hit[vnxt_int] && cache_hit[vnxt_int] && !vucach_out[vnxt_int]) ||
                              (vread_out[vnxt_int]   && (tg_serr[vnxt_int] || dt_serr[vnxt_int] || |vserr_out[vnxt_int])) ||
                              (vwrite_out[vnxt_int]  && (tg_serr[vnxt_int] || dt_serr[vnxt_int] || |vserr_out[vnxt_int])) ||
                              (srdwr_out[vnxt_int]   && vinvld_out[vnxt_int] && !sqfifo_hit[vnxt_int]) ||
                              (srdwr_out[vnxt_int]   && vflush_out[vnxt_int] && !sqfifo_hit[vnxt_int]) ||
                              (srdwr_out[vnxt_int]   && vucach_out[vnxt_int]);
      vsqvld_nxt[vnxt_int] <= sqfifo_hit[vnxt_int] && sqfifo_htv[vnxt_int];
      vprvld_nxt[vnxt_int] <= (vread_out[vnxt_int] && !sqfifo_hit[vnxt_int] && !cache_hit[vnxt_int] && !vucach_out[vnxt_int] && !vfill_out[vnxt_int] && !(tg_serr[vnxt_int] || dt_serr[vnxt_int])) ||
                              (vwrite_out[vnxt_int] && !sqfifo_hit[vnxt_int] && !cache_hit[vnxt_int] && !vucach_out[vnxt_int] && !vfill_out[vnxt_int] && !(tg_serr[vnxt_int] || dt_serr[vnxt_int])) ||
                              (!srdwr_out[vnxt_int] && vread_out[vnxt_int] && vucach_out[vnxt_int]);
      vread_nxt[vnxt_int] <= vread_out[vnxt_int];
      vwrite_nxt[vnxt_int] <= vwrite_out[vnxt_int];
      vflush_nxt[vnxt_int] <= vflush_out[vnxt_int];
      vinvld_nxt[vnxt_int] <= vinvld_out[vnxt_int];
      vucach_nxt[vnxt_int] <= vucach_out[vnxt_int];
      vucofst_nxt[vnxt_int] <= vucofst_out[vnxt_int];
      vucsize_nxt[vnxt_int] <= vucsize_out[vnxt_int];
      vucpfx_nxt[vnxt_int] <= vucpfx_out[vnxt_int];
      vsidx_nxt[vnxt_int] <= vsidx_out[vnxt_int];
      vfill_nxt[vnxt_int] <= ((vread_out[vnxt_int] || vwrite_out[vnxt_int]) && !sqfifo_hit[vnxt_int] && !cache_hit[vnxt_int]) || vucach_out[vnxt_int];
      vsqin_nxt[vnxt_int] <= vsqin_out[vnxt_int];
      vaddr_nxt[vnxt_int] <= vaddr_out[vnxt_int];
      vaddr_nxt[vnxt_int] <= vaddr_out[vnxt_int];
      vbyin_nxt[vnxt_int] <= vbyin_out[vnxt_int];
      vdin_nxt[vnxt_int] <= vucach_out[vnxt_int] ? vdin_out[vnxt_int] :
                            vwrite_out[vnxt_int] ? (vbwin_out[vnxt_int] & vdin_out[vnxt_int]) | (~vbwin_out[vnxt_int] & sqfifo_hda[vnxt_int]) : sqfifo_hda[vnxt_int];
      for (vnfd_int=0; vnfd_int<NUMRWPT; vnfd_int=vnfd_int+1)
        if (sqfifo_fnd[vnfd_int] && (vaddr_out[vnxt_int]==sqfifo_fad[vnfd_int]) && !sqfifo_fuc[vnfd_int] && !vucach_out[vnxt_int]) begin
          vsqvld_nxt[vnxt_int] <= 1'b1;
//          if (vwrite_out[vnxt_int])
//            vdin_nxt[vnxt_int] <= (vbwin_out[vnxt_int] & vdin_out[vnxt_int]) | (~vbwin_out[vnxt_int] & sqfifo_fda[vnxt_int]);
//          else
//            vdin_nxt[vnxt_int] <= sqfifo_fda[vnxt_int];
        end
//      for (vnfd_int=0; vnfd_int<NUMRWPT; vnfd_int=vnfd_int+1)
//        if (pwrite_wire[vnfd_int] && (vaddr_out[vnxt_int]==paddr_wire[vnfd_int]) && !pucach_wire[vnfd_int] && !vucach_out[vnxt_int]) begin
//          if (vwrite_out[vnxt_int])
//            vdin_nxt[vnxt_int] <= (vbwin_out[vnxt_int] & vdin_out[vnxt_int]) | (~vbwin_out[vnxt_int] & pdin_wire[vnfd_int]);
//          else
//            vdin_nxt[vnxt_int] <= pdin_wire[vnfd_int];
//        end
    end

  reg               t3_vldA_wire [0:NUMRWPT-1];
  reg [BITSEQN-1:0] t3_sqoutA_wire [0:NUMRWPT-1];
  reg [BITXATR-1:0] t3_attrA_wire [0:NUMRWPT-1];
  reg [WIDTH-1:0]   t3_doutA_wire [0:NUMRWPT-1];
  integer t3r_int;
  always_comb
    for (t3r_int=0; t3r_int<NUMRWPT; t3r_int=t3r_int+1) begin
      t3_vldA_wire[t3r_int] = t3_vldA >> t3r_int;
      t3_sqoutA_wire[t3r_int] = t3_sqoutA >> (t3r_int*BITSEQN);
      t3_attrA_wire[t3r_int] = t3_attrA >> (t3r_int*BITXATR);
      t3_doutA_wire[t3r_int] = t3_doutA >> (t3r_int*WIDTH);
    end

  reg [BITFIFO:0]   sqfifo_cnt;
  reg               sqfifo_vld [0:FIFOCNT-1];
  reg               sqfifo_prv [0:FIFOCNT-1];
  reg               sqfifo_rdv [0:FIFOCNT-1];
  reg               sqfifo_wrv [0:FIFOCNT-1];
  reg               sqfifo_flv [0:FIFOCNT-1];
  reg               sqfifo_inv [0:FIFOCNT-1];
  reg               sqfifo_uch [0:FIFOCNT-1];
  reg [BITUOFS-1:0] sqfifo_uof [0:FIFOCNT-1];
  reg [BITUSIZ-1:0] sqfifo_usz [0:FIFOCNT-1];
  reg [BITUCPF-1:0] sqfifo_upf [0:FIFOCNT-1];
  reg               sqfifo_idx [0:FIFOCNT-1];
  reg               sqfifo_fil [0:FIFOCNT-1];
  reg [BITSEQN-1:0] sqfifo_seq [0:FIFOCNT-1];
  reg [BITADDR-1:0] sqfifo_adr [0:FIFOCNT-1];
  reg [BYTWDTH-1:0] sqfifo_bye [0:FIFOCNT-1];
  reg [WIDTH-1:0]   sqfifo_bwe [0:FIFOCNT-1];
  reg [WIDTH-1:0]   sqfifo_dat [0:FIFOCNT-1];

  reg [3:0] sqfifo_dcnt;
  reg [3:0] sqfifo_ecnt;
  integer sffc_int;
  always_comb begin
    sqfifo_dcnt = 0;
    for (sffc_int=0; sffc_int<NUMRWPT; sffc_int=sffc_int+1)
      sqfifo_dcnt = sqfifo_dcnt + sqfifo_pop[sffc_int];
    sqfifo_dcnt = (sqfifo_cnt > sqfifo_dcnt) ? sqfifo_dcnt : sqfifo_cnt;
    sqfifo_ecnt = 0;
    for (sffc_int=0; sffc_int<NUMRWPT; sffc_int=sffc_int+1)
      sqfifo_ecnt = sqfifo_ecnt + vsqwr_nxt[sffc_int];
  end

  always @(posedge clk)
    if (!ready)
      sqfifo_cnt <= 0;
    else
      sqfifo_cnt <= sqfifo_cnt + sqfifo_ecnt - sqfifo_dcnt;

  genvar sffo_var;
  generate
    for (sffo_var=0; sffo_var<FIFOCNT; sffo_var=sffo_var+1) begin: sffo_loop
      reg [3:0] vsq_sel;
      reg [3:0] fifo_cnt_temp;

      integer fcnt_int;
      always_comb begin
        vsq_sel = NUMRWPT;
        for (fcnt_int=0; fcnt_int<NUMRWPT; fcnt_int=fcnt_int+1)
          if (vsqwr_nxt[fcnt_int] && (sffo_var == (sqfifo_cnt - sqfifo_dcnt + fcnt_int)))
            vsq_sel = fcnt_int;
      end

      reg               sqfifo_vld_next;
      reg               sqfifo_prv_next;
      reg               sqfifo_rdv_next;
      reg               sqfifo_wrv_next;
      reg               sqfifo_flv_next;
      reg               sqfifo_inv_next;
      reg               sqfifo_uch_next;
      reg [BITUOFS-1:0] sqfifo_uof_next;
      reg [BITUSIZ-1:0] sqfifo_usz_next;
      reg [BITUSIZ-1:0] sqfifo_upf_next;
      reg               sqfifo_idx_next;
      reg               sqfifo_fil_next;
      reg [BITSEQN-1:0] sqfifo_seq_next;
      reg [BITADDR-1:0] sqfifo_adr_next;
      reg [BYTWDTH-1:0] sqfifo_bye_next;
      reg [WIDTH-1:0]   sqfifo_bwe_next;
      reg [WIDTH-1:0]   sqfifo_dat_next;
      integer fcnx_int;
      always_comb
        if ((vsq_sel != NUMRWPT) && vsqwr_nxt[vsq_sel]) begin
          sqfifo_vld_next = vsqvld_nxt[vsq_sel];
          sqfifo_prv_next = vprvld_nxt[vsq_sel] && (sqfifo_sdq[0] || t3_block);
          sqfifo_bye_next = vbyin_nxt[vsq_sel];
          sqfifo_dat_next = vdin_nxt[vsq_sel];
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (sqfifo_fnd[fcnx_int] && (vaddr_nxt[vsq_sel]==sqfifo_fad[fcnx_int]) && !sqfifo_fuc[fcnx_int] && !vucach_nxt[vsq_sel] && !vsidx_nxt[vsq_sel]) begin
              sqfifo_vld_next = 1'b1;
//              if (vwrite_nxt[vsq_sel])
//                sqfifo_dat_next = (sqfifo_bwe_next & vdin_nxt[vsq_sel]) | (~sqfifo_bwe_next & sqfifo_fda[fcnx_int]);
//              else
//                sqfifo_dat_next = sqfifo_fda[fcnx_int];
            end
          sqfifo_rdv_next = vread_nxt[vsq_sel];
          sqfifo_wrv_next = vwrite_nxt[vsq_sel];
          sqfifo_flv_next = vflush_nxt[vsq_sel];
          sqfifo_inv_next = vinvld_nxt[vsq_sel];
          sqfifo_uch_next = vucach_nxt[vsq_sel];
          sqfifo_uof_next = vucofst_nxt[vsq_sel];
          sqfifo_usz_next = vucsize_nxt[vsq_sel];
          sqfifo_upf_next = vucpfx_nxt[vsq_sel];
          sqfifo_idx_next = vsidx_nxt[vsq_sel];
          sqfifo_fil_next = vfill_nxt[vsq_sel];
          sqfifo_seq_next = vsqin_nxt[vsq_sel];
          sqfifo_adr_next = vaddr_nxt[vsq_sel];
          if ((sffo_var==0) && vsidx_nxt[vsq_sel])
            sqfifo_vld_next = 1'b1;
        end else if (|sqfifo_dcnt && (sffo_var>=sqfifo_psl[0]) && (sffo_var<FIFOCNT-sqfifo_dcnt)) begin
          sqfifo_vld_next = sqfifo_vld[sffo_var+sqfifo_dcnt];
          sqfifo_prv_next = sqfifo_prv[sffo_var+sqfifo_dcnt];
          sqfifo_bye_next = sqfifo_bye[sffo_var+sqfifo_dcnt];
          sqfifo_dat_next = sqfifo_dat[sffo_var+sqfifo_dcnt];
          sqfifo_rdv_next = sqfifo_rdv[sffo_var+sqfifo_dcnt];
          sqfifo_wrv_next = sqfifo_wrv[sffo_var+sqfifo_dcnt];
          sqfifo_flv_next = sqfifo_flv[sffo_var+sqfifo_dcnt];
          sqfifo_inv_next = sqfifo_inv[sffo_var+sqfifo_dcnt];
          sqfifo_uch_next = sqfifo_uch[sffo_var+sqfifo_dcnt];
          sqfifo_uof_next = sqfifo_uof[sffo_var+sqfifo_dcnt];
          sqfifo_usz_next = sqfifo_usz[sffo_var+sqfifo_dcnt];
          sqfifo_upf_next = sqfifo_upf[sffo_var+sqfifo_dcnt];
          sqfifo_idx_next = sqfifo_idx[sffo_var+sqfifo_dcnt];
          sqfifo_fil_next = sqfifo_fil[sffo_var+sqfifo_dcnt];
          sqfifo_seq_next = sqfifo_seq[sffo_var+sqfifo_dcnt];
          sqfifo_adr_next = sqfifo_adr[sffo_var+sqfifo_dcnt];
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1) begin
//            if (sqfifo_fnd[fcnx_int] && (sqfifo_seq[sffo_var+sqfifo_dcnt]==sqfifo_fsq[fcnx_int])) begin
//              sqfifo_fil_next = 1'b0;
//              sqfifo_vld_next = 1'b1;
//            end
            if (sqfifo_fnd[fcnx_int] && (sqfifo_adr[sffo_var+sqfifo_dcnt]==sqfifo_fad[fcnx_int]) && !sqfifo_fuc[fcnx_int] && !sqfifo_uch[sffo_var+sqfifo_dcnt] && !sqfifo_idx[sffo_var+sqfifo_dcnt])
              sqfifo_vld_next = 1'b1;
          end
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (sqfifo_deq[fcnx_int] && (sqfifo_dsl[0]==(sffo_var+sqfifo_dcnt)))
              sqfifo_vld_next = 1'b0;
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (sqfifo_sdq[fcnx_int] && (sqfifo_ssl[0]==(sffo_var+sqfifo_dcnt)))
              sqfifo_prv_next = 1'b0;
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (vprvld_nxt[fcnx_int] && (sqfifo_seq[sffo_var+sqfifo_dcnt]==vsqin_nxt[fcnx_int]) && !vucach_nxt[fcnx_int] && !sqfifo_uch[sffo_var+sqfifo_dcnt]) begin
              sqfifo_prv_next = sqfifo_sdq[0] || t3_block;
              sqfifo_fil_next = 1'b1;
            end
          if ((sffo_var==0) && sqfifo_idx[sffo_var+sqfifo_dcnt])
            sqfifo_vld_next = 1'b1;
        end else begin
          sqfifo_vld_next = sqfifo_vld[sffo_var];
          sqfifo_prv_next = sqfifo_prv[sffo_var];
          sqfifo_bye_next = sqfifo_bye[sffo_var];
          sqfifo_dat_next = sqfifo_dat[sffo_var];
          sqfifo_rdv_next = sqfifo_rdv[sffo_var];
          sqfifo_wrv_next = sqfifo_wrv[sffo_var];
          sqfifo_flv_next = sqfifo_flv[sffo_var];
          sqfifo_inv_next = sqfifo_inv[sffo_var];
          sqfifo_uch_next = sqfifo_uch[sffo_var];
          sqfifo_uof_next = sqfifo_uof[sffo_var];
          sqfifo_usz_next = sqfifo_usz[sffo_var];
          sqfifo_upf_next = sqfifo_upf[sffo_var];
          sqfifo_idx_next = sqfifo_idx[sffo_var];
          sqfifo_fil_next = sqfifo_fil[sffo_var];
          sqfifo_seq_next = sqfifo_seq[sffo_var];
          sqfifo_adr_next = sqfifo_adr[sffo_var];
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1) begin
//            if (sqfifo_fnd[fcnx_int] && (sqfifo_seq[sffo_var]==sqfifo_fsq[fcnx_int])) begin
//              sqfifo_fil_next = 1'b0;
//              sqfifo_vld_next = 1'b1;
//            end
            if (sqfifo_fnd[fcnx_int] && (sqfifo_adr[sffo_var]==sqfifo_fad[fcnx_int]) && !sqfifo_fuc[fcnx_int] && !sqfifo_uch[sffo_var] && !sqfifo_idx[sffo_var])
              sqfifo_vld_next = 1'b1;
          end
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (sqfifo_deq[fcnx_int] && (sqfifo_dsl[0]==sffo_var))
              sqfifo_vld_next = 1'b0;
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (sqfifo_sdq[fcnx_int] && (sqfifo_ssl[0]==sffo_var))
              sqfifo_prv_next = 1'b0;
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (vprvld_nxt[fcnx_int] && (sqfifo_seq[sffo_var]==vsqin_nxt[fcnx_int]) && !vucach_nxt[fcnx_int] && !sqfifo_uch[sffo_var]) begin
              sqfifo_prv_next = sqfifo_sdq[0] || t3_block;
              sqfifo_fil_next = 1'b1;
            end
        end

      integer byte_int;
      always_comb begin
        sqfifo_bwe_next = 0;
        for (byte_int=0; byte_int<BYTWDTH; byte_int=byte_int+1)
          sqfifo_bwe_next = sqfifo_bwe_next | ({8{sqfifo_bye_next[byte_int]}} << (byte_int*8));
      end

      always @(posedge clk) begin
        sqfifo_vld[sffo_var] <= sqfifo_vld_next;
        sqfifo_prv[sffo_var] <= sqfifo_prv_next;
        sqfifo_rdv[sffo_var] <= sqfifo_rdv_next;
        sqfifo_wrv[sffo_var] <= sqfifo_wrv_next;
        sqfifo_flv[sffo_var] <= sqfifo_flv_next;
        sqfifo_inv[sffo_var] <= sqfifo_inv_next;
        sqfifo_uch[sffo_var] <= sqfifo_uch_next;
        sqfifo_uof[sffo_var] <= sqfifo_uof_next;
        sqfifo_usz[sffo_var] <= sqfifo_usz_next;
        sqfifo_upf[sffo_var] <= sqfifo_upf_next;
        sqfifo_idx[sffo_var] <= sqfifo_idx_next;
        sqfifo_fil[sffo_var] <= sqfifo_fil_next;
        sqfifo_seq[sffo_var] <= sqfifo_seq_next;
        sqfifo_adr[sffo_var] <= sqfifo_adr_next;
        sqfifo_bye[sffo_var] <= sqfifo_bye_next;
        sqfifo_dat[sffo_var] <= sqfifo_dat_next;
      end
    end
  endgenerate

  integer sqfp_int, sqff_int, sqfx_int;
  always_comb
    for (sqfp_int=0; sqfp_int<NUMRWPT; sqfp_int=sqfp_int+1) begin
      sqfifo_deq[sqfp_int] = 1'b0;
      sqfifo_dsl[sqfp_int] = 0;
      for (sqff_int=FIFOCNT-1; sqff_int>=0; sqff_int=sqff_int-1) begin
        if ((sqff_int<sqfifo_cnt) && sqfifo_vld[sqff_int]) begin
          sqfifo_deq[sqfp_int] = 1'b1;
          sqfifo_dsl[sqfp_int] = sqff_int;
        end
      end
//      if (|sqfifo_cnt && (sqfifo_flv[0] || sqfifo_inv[0]) && sqfifo_idx[0]) begin
//        sqfifo_deq[sqfp_int] = 1'b1;
//        sqfifo_dsl[sqfp_int] = 0;
//      end
      for (sqff_int=FIFOCNT-1; sqff_int>=0; sqff_int=sqff_int-1) begin
        for (sqfx_int=0; sqfx_int<NUMRWPT; sqfx_int=sqfx_int+1)
          if ((sqff_int<sqfifo_cnt) && t3_vldA_wire[sqfx_int] && (sqfifo_seq[sqff_int]==t3_sqoutA_wire[sqfx_int])) begin
            sqfifo_deq[sqfp_int] = 1'b1;
            sqfifo_dsl[sqfp_int] = sqff_int;
          end
      end
      sqfifo_sdq[sqfp_int] = 1'b0;
      sqfifo_ssl[sqfp_int] = 0;
      for (sqff_int=FIFOCNT-1; sqff_int>=0; sqff_int=sqff_int-1) begin
        if ((sqff_int<sqfifo_cnt) && sqfifo_prv[sqff_int] && !t3_block) begin
          sqfifo_sdq[sqfp_int] = 1'b1;
          sqfifo_ssl[sqfp_int] = sqff_int;
        end
      end
      sqfifo_fnd[sqfp_int] = 1'b0;
      sqfifo_fuc[sqfp_int] = 1'b0;
      sqfifo_fsq[sqfp_int] = 1'b0;
      sqfifo_fad[sqfp_int] = 0;
      sqfifo_fda[sqfp_int] = 0;
      for (sqff_int=FIFOCNT-1; sqff_int>=0; sqff_int=sqff_int-1)
        if ((sqff_int<sqfifo_cnt) && t3_vldA_wire[sqfp_int] && (sqfifo_seq[sqff_int]==t3_sqoutA_wire[sqfp_int])) begin
          sqfifo_fnd[sqfp_int] = 1'b1;
          sqfifo_fuc[sqfp_int] = sqfifo_uch[sqff_int];
          sqfifo_fsq[sqfp_int] = sqfifo_seq[sqff_int];
          sqfifo_fad[sqfp_int] = sqfifo_adr[sqff_int];
          sqfifo_fda[sqfp_int] = t3_doutA_wire[sqfp_int];
        end
      sqfifo_pop[sqfp_int] = 1'b0;
      sqfifo_psl[sqfp_int] = 0;
      sqfifo_psl_help[sqfp_int] = 0;
      for (sqff_int=FIFOCNT-1; sqff_int>=0; sqff_int=sqff_int-1) begin
        for (sqfx_int=0; sqfx_int<NUMRWPT; sqfx_int=sqfx_int+1)
          if ((sqff_int<sqfifo_cnt) && (sqfifo_seq[sqff_int]==vsqin_nxt[sqfx_int]) && vsqpp_nxt[sqfx_int]) begin
            sqfifo_pop[sqfp_int] = 1'b1;
            sqfifo_psl[sqfp_int] = sqff_int;
            sqfifo_psl_help[sqfp_int] = sqfifo_seq[sqff_int];
          end
      end
      sqfifo_hit[sqfp_int] = 1'b0;
      sqfifo_htv[sqfp_int] = 1'b0;
      sqfifo_hda[sqfp_int] = 0;
      sqfifo_hsq[sqfp_int] = 0;
      for (sqff_int=0; sqff_int<NUMRWPT; sqff_int=sqff_int+1)
        if (vprvld_nxt[sqff_int] && (vaddr_nxt[sqff_int]==vaddr_out[sqfp_int]) && !vucach_nxt[sqff_int] && !vucach_out[sqfp_int]) begin
          sqfifo_hit[sqfp_int] = 1'b1;
          sqfifo_htv[sqfp_int] = 1'b0;
          sqfifo_hsq[sqfp_int] = vsqin_nxt[sqff_int];
        end
      for (sqff_int=0; sqff_int<NUMRWPT; sqff_int=sqff_int+1)
        if (vsqwr_nxt[sqff_int] && (vaddr_nxt[sqff_int]==vaddr_out[sqfp_int]) && !vucach_nxt[sqff_int] && !srdwr_out[sqfp_int] && !vucach_out[sqfp_int]) begin
          sqfifo_hit[sqfp_int] = 1'b1;
          sqfifo_htv[sqfp_int] = vsqvld_nxt[sqff_int];
          sqfifo_hda[sqfp_int] = vdin_nxt[sqff_int];
          sqfifo_hsq[sqfp_int] = vsqin_nxt[sqff_int];
        end
      for (sqff_int=FIFOCNT-1; sqff_int>=0; sqff_int=sqff_int-1)
        if ((sqff_int<sqfifo_cnt) && (sqfifo_adr[sqff_int]==vaddr_out[sqfp_int]) && !sqfifo_uch[sqff_int] && !srdwr_out[sqfp_int] && !vucach_out[sqfp_int] &&
            !(vsqpp_nxt[sqfp_int] && (sqfifo_seq[sqff_int]==vsqin_nxt[sqfp_int]))) begin
          sqfifo_hit[sqfp_int] = 1'b1;
          sqfifo_htv[sqfp_int] = sqfifo_vld[sqff_int];
          sqfifo_hda[sqfp_int] = sqfifo_dat[sqff_int];
          sqfifo_hsq[sqfp_int] = sqfifo_seq[sqff_int];
        end
      for (sqff_int=FIFOCNT-1; sqff_int>=0; sqff_int=sqff_int-1)
        if ((sqff_int<sqfifo_cnt) && (sqfifo_adr[sqff_int]==vaddr_out[sqfp_int]) && sqfifo_fil[sqff_int] && !sqfifo_uch[sqff_int] && !vucach_out[sqfp_int] &&
            !(vsqpp_nxt[sqfp_int] && (sqfifo_seq[sqff_int]==vsqin_nxt[sqfp_int]))) begin
          sqfifo_hit[sqfp_int] = 1'b1;
          sqfifo_htv[sqfp_int] = sqfifo_fnd[sqfp_int] && (sqfifo_fsq[sqfp_int]==sqfifo_seq[sqff_int]);
          sqfifo_hda[sqfp_int] = sqfifo_dat[sqff_int];
          sqfifo_hsq[sqfp_int] = sqfifo_seq[sqff_int];
        end
      if (!srdwr_out[sqfp_int] && (vinvld_out[sqfp_int] || vflush_out[sqfp_int]) && vsidx_out[sqfp_int]) begin
        sqfifo_hit[sqfp_int] = 1'b1;
        sqfifo_htv[sqfp_int] = 1'b0;
      end
    end

  reg [WIDTH-1:0] sbwin_wire [0:NUMRWPT-1];
  integer srcp_int, srcf_int;
  always_comb
    for (srcp_int=0; srcp_int<NUMRWPT; srcp_int=srcp_int+1) begin
      sread_wire[srcp_int] = sqfifo_deq[srcp_int] && sqfifo_rdv[sqfifo_dsl[srcp_int]];
      swrite_wire[srcp_int] = sqfifo_deq[srcp_int] && sqfifo_wrv[sqfifo_dsl[srcp_int]];
      sflush_wire[srcp_int] = sqfifo_deq[srcp_int] && sqfifo_flv[sqfifo_dsl[srcp_int]];
      sinvld_wire[srcp_int] = sqfifo_deq[srcp_int] && sqfifo_inv[sqfifo_dsl[srcp_int]];
      sucach_wire[srcp_int] = sqfifo_deq[srcp_int] && sqfifo_uch[sqfifo_dsl[srcp_int]];
      sucofst_wire[srcp_int] = sqfifo_uof[sqfifo_dsl[srcp_int]];
      sucsize_wire[srcp_int] = sqfifo_usz[sqfifo_dsl[srcp_int]];
      sucpfx_wire[srcp_int] = sqfifo_upf[sqfifo_dsl[srcp_int]];
      ssidx_wire[srcp_int] = sqfifo_idx[sqfifo_dsl[srcp_int]];
      sfill_wire[srcp_int] = sqfifo_fil[sqfifo_dsl[srcp_int]];
      ssqin_wire[srcp_int] = sqfifo_seq[sqfifo_dsl[srcp_int]];
      saddr_wire[srcp_int] = sqfifo_adr[sqfifo_dsl[srcp_int]];
      sbyin_wire[srcp_int] = sqfifo_bye[sqfifo_dsl[srcp_int]];
      sdin_wire[srcp_int] = sqfifo_dat[sqfifo_dsl[srcp_int]];
      sserr_wire[srcp_int] = sfill_wire[srcp_int] ? t3_attrA_wire[srcp_int] : 0;
      for (srcf_int=0; srcf_int<NUMRWPT; srcf_int=srcf_int+1)
        if (sqfifo_fnd[srcf_int] && (ssqin_wire[srcp_int]==sqfifo_fsq[srcf_int])) begin
          if (swrite_wire[srcp_int])
            sdin_wire[srcp_int] = (sbwin_wire[srcp_int] & sqfifo_dat[sqfifo_dsl[srcp_int]]) | (~sbwin_wire[srcp_int] & sqfifo_fda[srcf_int]);
          else
            sdin_wire[srcp_int] = sqfifo_fda[srcf_int];
        end
//        if (sqfifo_fnd[srcf_int] && (saddr_wire[srcp_int]==sqfifo_fad[srcf_int]) && !sqfifo_fuc[srcf_int] && !sucach_wire[srcp_int]) begin
//          if (swrite_wire[srcp_int])
//            sdin_wire[srcp_int] = (sbwin_wire[srcp_int] & sqfifo_dat[sqfifo_dsl[srcp_int]]) | (~sbwin_wire[srcp_int] & sqfifo_fda[srcf_int]);
//          else
//            sdin_wire[srcp_int] = sqfifo_fda[srcf_int];
//        end else if (sqfifo_fnd[srcf_int] && (ssqin_wire[srcp_int]==sqfifo_fsq[srcf_int])) begin
//          sdin_wire[srcp_int] = sqfifo_fda[srcf_int];
//        end
//      for (srcf_int=0; srcf_int<NUMRWPT; srcf_int=srcf_int+1)
//        if (pwrite_wire[srcf_int] && (paddr_wire[srcf_int]==saddr_wire[srcp_int]) && !pucach_wire[srcf_int] && !sucach_wire[srcp_int])
//          if (swrite_wire[srcp_int])
//            sdin_wire[srcp_int] = (sbwin_wire[srcp_int] & sqfifo_dat[sqfifo_dsl[srcp_int]]) | (~sbwin_wire[srcp_int] & pdin_wire[srcf_int]);
//          else
//            sdin_wire[srcp_int] = pdin_wire[srcf_int];
    end

  integer sbwp_int, sbwf_int;
  always_comb
    for (sbwp_int=0; sbwp_int<NUMRWPT; sbwp_int=sbwp_int+1) begin
      sbwin_wire[sbwp_int] = 0;
      for (sbwf_int=0; sbwf_int<BYTWDTH; sbwf_int=sbwf_int+1)
        sbwin_wire[sbwp_int] = sbwin_wire[sbwp_int] | ({8{sbyin_wire[sbwp_int][sbwf_int]}} << (sbwf_int*8));
    end

  reg               vread_vld_wire [0:NUMRWPT-1];
  reg               vread_hit_wire [0:NUMRWPT-1];
  reg               vread_serr_wire [0:NUMRWPT-1];
  reg [BITSEQN-1:0] vsqout_wire [0:NUMRWPT-1];
  reg [WIDTH-1:0]   vdout_wire [0:NUMRWPT-1];
  reg [BITXATR-1:0] vattr_wire [0:NUMRWPT-1];
  integer vdor_int, vdob_int;
  always_comb
    for (vdor_int=0; vdor_int<NUMRWPT; vdor_int=vdor_int+1) begin
      vread_vld_wire[vdor_int] = (vread_out[vdor_int] && !vucach_out[vdor_int] && !vfill_out[vdor_int] && !sqfifo_hit[vdor_int] && cache_hit[vdor_int]) ||
                                 (vwrite_out[vdor_int] && !vucach_out[vdor_int] && !vfill_out[vdor_int] && !sqfifo_hit[vdor_int] && cache_hit[vdor_int]) ||
                                 (vread_out[vdor_int] && vfill_out[vdor_int]) ||
                                 (vwrite_out[vdor_int] && vfill_out[vdor_int]) ||
                                 (vread_out[vdor_int] && srdwr_out[vdor_int] && vucach_out[vdor_int]) ||
                                 ((vread_out[vdor_int] || vwrite_out[vdor_int] || vinvld_out[vdor_int] || vflush_out[vdor_int]) && !vucach_out[vdor_int] && (tg_serr[vdor_int] || dt_serr[vdor_int])) ||
                                 (vread_out[vdor_int] && |vserr_out[vdor_int]) ||
                                 (vflush_out[vdor_int] && !sqfifo_hit[vdor_int]) ||
                                 (vinvld_out[vdor_int] && !sqfifo_hit[vdor_int]);
      vread_hit_wire[vdor_int] = !srdwr_out[vdor_int] && cache_hit[vdor_int];
      vread_serr_wire[vdor_int] = (!vucach_out[vdor_int] && (tg_serr[vdor_int] || dt_serr[vdor_int])) || |vserr_out[vdor_int] ;
      vsqout_wire[vdor_int] = vsqin_out[vdor_int];
      vdout_wire[vdor_int] = vdin_out[vdor_int];
      vattr_wire[vdor_int] = vserr_out[vdor_int];
      if (vwrite_out[vdor_int] && cache_hit[vdor_int] && !vucach_out[vdor_int])
        vdout_wire[vdor_int] = (vbwin_out[vdor_int] & vdin_out[vdor_int]) | (~vbwin_out[vdor_int] & ddat_out[vdor_int][cache_map[vdor_int]]);
      if (vread_out[vdor_int] && cache_hit[vdor_int] && !vucach_out[vdor_int])
        vdout_wire[vdor_int] = ddat_out[vdor_int][cache_map[vdor_int]];
    end

  reg [NUMRWPT-1:0]         vread_vld_tmp;
  reg [NUMRWPT-1:0]         vread_hit_tmp;
  reg [NUMRWPT-1:0]         vread_serr_tmp;
  reg [NUMRWPT*BITSEQN-1:0] vsqout_tmp;
  reg [NUMRWPT*WIDTH-1:0]   vdout_tmp;
  reg [NUMRWPT*BITXATR-1:0] vattr_tmp;
  integer vbus_int;
  always_comb begin
    vread_vld_tmp = 0;
    vread_hit_tmp = 0;
    vread_serr_tmp = 0;
    vsqout_tmp = 0;
    vdout_tmp = 0;
    vattr_tmp = 0;
    for (vbus_int=0; vbus_int<NUMRWPT; vbus_int=vbus_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_vld_wire[vbus_int] << vbus_int);
      vread_hit_tmp = vread_hit_tmp | (vread_hit_wire[vbus_int] << vbus_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vbus_int] << vbus_int);
      vsqout_tmp = vsqout_tmp | (vsqout_wire[vbus_int] << (vbus_int*BITSEQN));
      vdout_tmp = vdout_tmp | (vdout_wire[vbus_int] << (vbus_int*WIDTH));
      vattr_tmp = vattr_tmp | (vattr_wire[vbus_int] << (vbus_int*BITXATR));
    end
  end
  
  reg [NUMRWPT-1:0]         vread_vld;
  reg [NUMRWPT-1:0]         vread_hit;
  reg [NUMRWPT-1:0]         vread_serr;
  reg [NUMRWPT*BITSEQN-1:0] vsqout;
  reg [NUMRWPT*WIDTH-1:0]   vdout;
  reg [NUMRWPT*BITXATR-1:0] vattr;
  generate if (FLOPOUT) begin: flpo_loop
    always @(posedge clk) begin
      vread_vld <= vread_vld_tmp;
      vread_hit <= vread_hit_tmp;
      vread_serr <= vread_serr_tmp;
      vsqout <= vsqout_tmp; 
      vdout <= vdout_tmp; 
      vattr <= vattr_tmp; 
    end
  end else begin: nflpo_loop
    always_comb begin
      vread_vld = vread_vld_tmp;
      vread_hit = vread_hit_tmp;
      vread_serr = vread_serr_tmp;
      vsqout = vsqout_tmp;
      vdout = vdout_tmp;
      vattr = vattr_tmp;
    end
  end
  endgenerate

  assign pf_stall = sqfifo_deq[0];
  assign t3_stall = 1'b0;

  reg [NUMRWPT-1:0]                 t1_writeA;
  reg [NUMRWPT*BITVROW-1:0]         t1_addrA;
  reg [NUMRWPT*NUMWRDS*BITTAGW-1:0] t1_dinA;
  integer t1w_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (t1w_int=0; t1w_int<NUMRWPT; t1w_int=t1w_int+1)
      if (twrite_wire[t1w_int]) begin
        t1_writeA = t1_writeA | (1'b1 << t1w_int);
        t1_addrA  = t1_addrA | (twraddr_wire[t1w_int] <<  (t1w_int*BITVROW));
        t1_dinA   = t1_dinA | (tdin_wire[t1w_int] <<  (t1w_int*NUMWRDS*BITTAGW));
      end
  end

  reg [NUMRWPT-1:0]               t2_writeA;
  reg [NUMRWPT*BITVROW-1:0]       t2_addrA;
  reg [NUMRWPT*NUMWRDS*WIDTH-1:0] t2_dinA;
  integer t2w_int;
  always_comb begin
    t2_writeA = 0;
    t2_addrA = 0;
    t2_dinA = 0;
    for (t2w_int=0; t2w_int<NUMRWPT; t2w_int=t2w_int+1)
      if (dwrite_wire[t2w_int]) begin
        t2_writeA = t2_writeA | (1'b1 << t2w_int);
        t2_addrA  = t2_addrA | (dwraddr_wire[t2w_int] <<  (t2w_int*BITVROW));
        t2_dinA   = t2_dinA | (ddin_wire[t2w_int] <<  (t2w_int*NUMWRDS*WIDTH));
      end
  end

  reg [NUMRWPT-1:0]         t3_readA;
  reg [NUMRWPT-1:0]         t3_writeA;
  reg [NUMRWPT-1:0]         t3_ucachA;
  reg [NUMRWPT*BITUOFS-1:0] t3_ucofstA;
  reg [NUMRWPT*BITUSIZ-1:0] t3_ucsizeA;
  reg [NUMRWPT*BITUCPF-1:0] t3_ucpfxA;
  reg [NUMRWPT*BITSEQN-1:0] t3_sqinA;
  reg [NUMRWPT*BITADDR-1:0] t3_addrA;
  reg [NUMRWPT*WIDTH-1:0]   t3_dinA;
  integer t3w_int;
  always_comb begin
    t3_readA = 0;
    t3_writeA = 0;
    t3_ucachA = 0;
    t3_ucofstA = 0;
    t3_ucsizeA = 0;
    t3_ucpfxA = 0;
    t3_sqinA = 0;
    t3_addrA = 0;
    t3_dinA = 0;
    for (t3w_int=0; t3w_int<NUMRWPT; t3w_int=t3w_int+1) begin
      if (pread_wire[t3w_int]) begin
        t3_readA = t3_readA | (1'b1 << t3w_int);
        t3_ucachA = t3_ucachA | (pucach_wire[t3w_int] <<  (t3w_int*1));
        t3_ucofstA = t3_ucofstA | (pucofst_wire[t3w_int] <<  (t3w_int*BITUOFS));
        t3_ucsizeA = t3_ucsizeA | (pucsize_wire[t3w_int] <<  (t3w_int*BITUSIZ));
        t3_ucpfxA = t3_ucpfxA | (pucpfx_wire[t3w_int] <<  (t3w_int*BITUCPF));
        t3_sqinA = t3_sqinA | (pseq_wire[t3w_int] <<  (t3w_int*BITSEQN));
        t3_addrA = t3_addrA | (paddr_wire[t3w_int] <<  (t3w_int*BITADDR));
      end
      if (pwrite_wire[t3w_int]) begin
        t3_writeA = t3_writeA | (1'b1 << t3w_int);
        t3_ucachA  = t3_ucachA | (pucach_wire[t3w_int] <<  (t3w_int*1));
        t3_ucofstA = t3_ucofstA | (pucofst_wire[t3w_int] <<  (t3w_int*BITUOFS));
        t3_ucsizeA = t3_ucsizeA | (pucsize_wire[t3w_int] <<  (t3w_int*BITUSIZ));
        t3_ucpfxA = t3_ucpfxA | (pucpfx_wire[t3w_int] <<  (t3w_int*BITUCPF));
        t3_sqinA  = t3_sqinA | (pseq_wire[t3w_int] <<  (t3w_int*BITSEQN));
        t3_addrA  = t3_addrA | (paddr_wire[t3w_int] <<  (t3w_int*BITADDR));
        t3_dinA   = t3_dinA | (pdin_wire[t3w_int] <<  (t3w_int*WIDTH));
      end
    end
  end
  


  reg [NUMSEQN-1:0] vld_flag;
  integer vldf_int, vlds_int;
  always_comb
    for (vlds_int=0; vlds_int<NUMSEQN; vlds_int=vlds_int+1) begin
      vld_flag[vlds_int] = 1'b0;
      for (vldf_int=0; vldf_int<FIFOCNT; vldf_int=vldf_int+1)
        if ((vldf_int<sqfifo_cnt) && (vlds_int==sqfifo_seq[vldf_int]) && sqfifo_vld[vldf_int])
          vld_flag[vlds_int] = 1'b1;
    end

  reg [BITVROW-1:0] tg_addr;
  reg [BITVROW-1:0] dt_addr;
  always @(posedge clk) begin
    tg_addr <= t1_addrB[BITVROW-1:0];
    dt_addr <= t2_addrB[BITVROW-1:0];
  end

  reg e_pf_empty;
  reg e_pf_oflw;
  reg e_uc_stall;
  always @(posedge clk) begin
    e_pf_empty <= (sqfifo_cnt == 0);
    e_pf_oflw <= (sqfifo_cnt > FIFOCNT);
    e_uc_stall <= 1'b0;
  end

  reg e_cache_rd_hit;
  reg e_cache_wr_hit;
  always @(posedge clk) begin
    e_cache_rd_hit <=  vread_hit_wire[0] && vread_vld_wire[0] && vread_out[0];
    e_cache_wr_hit <=  vread_hit_wire[0] && vread_vld_wire[0] && vwrite_out[0];
  end

  reg                e_tgerr_vld;
  reg                e_dterr_vld;
  reg  [BITTGBY-1:0] e_tgerr_bid;
  reg  [BITDTBY-1:0] e_dterr_bid;
  reg  [BITVROW-1:0] e_tgerr_idx;
  reg  [BITVROW-1:0] e_dterr_idx;
  always @(posedge clk) begin    
    e_tgerr_vld <= tg_serr[0];   
    e_dterr_vld <= dt_serr[0];
    e_tgerr_bid <= t1_bidB[BITTGBY-1:0];
    e_dterr_bid <= t2_bidB[BITDTBY-1:0];
    e_tgerr_idx <= tg_addr[BITVROW-1:0];
    e_dterr_idx <= dt_addr[BITVROW-1:0];
  end 
  
  wire [BITSEQN-1:0] sqfifo_dsq_help = sqfifo_seq[sqfifo_dsl[0]];


  // synopsys translate_off

  reg [NUMRWPT*BITVROW-1:0]  dbg_rd_addrB;
  always @(posedge clk)
    dbg_rd_addrB <= t1_addrB;
  reg                  dbg_rd_lru [0:NUMWRDS-1];
  reg                  dbg_rd_vld [0:NUMWRDS-1];
  reg                  dbg_rd_dty [0:NUMWRDS-1];
  reg  [BITADDR-BITVROW-1:0]   dbg_rd_tag [0:NUMWRDS-1];
  reg  [BITADDR+5-1:0] dbg_rd_adr [0:NUMWRDS-1];
  reg  [WIDTH-1:0]     dbg_rd_dat [0:NUMWRDS-1];
  always_comb begin
    for (integer i=0; i<NUMWRDS; i++) begin
      dbg_rd_vld[i] = t1_doutB >> ((i*BITTAGW)+BITDTAG+BITWRDS+1);
      dbg_rd_dty[i] = t1_doutB >> ((i*BITTAGW)+BITDTAG+BITWRDS);
      dbg_rd_lru[i] = t1_doutB >> ((i*BITTAGW)+BITDTAG);
      dbg_rd_tag[i] = t1_doutB >>  (i*BITTAGW);
      dbg_rd_adr[i] = {dbg_rd_tag[i],dbg_rd_addrB,5'b0}; 
      dbg_rd_dat[i] = t2_doutB >>  (i*WIDTH);
    end
  end

  reg                  dbg_wr_lru [0:NUMWRDS-1];
  reg                  dbg_wr_vld [0:NUMWRDS-1];
  reg                  dbg_wr_dty [0:NUMWRDS-1];
  reg  [BITADDR-BITVROW-1:0]   dbg_wr_tag [0:NUMWRDS-1];
  reg  [BITADDR+5-1:0] dbg_wr_adr [0:NUMWRDS-1];
  reg  [WIDTH-1:0]     dbg_wr_dat [0:NUMWRDS-1];
  always_comb begin
    for (integer i=0; i<NUMWRDS; i++) begin
      dbg_wr_vld[i] = t1_dinA >> ((i*BITTAGW)+BITDTAG+BITWRDS+1);
      dbg_wr_dty[i] = t1_dinA >> ((i*BITTAGW)+BITDTAG+BITWRDS);
      dbg_wr_lru[i] = t1_dinA >> ((i*BITTAGW)+BITDTAG);
      dbg_wr_tag[i] = t1_dinA >>  (i*BITTAGW);
      dbg_wr_adr[i] = {dbg_wr_tag[i],t1_addrA,5'b0};
      dbg_wr_dat[i] = t2_dinA >>  (i*WIDTH);
    end
  end

//assert_sqfifo_overflow: assert property (@(posedge clk) disable iff (rst) (sqfifo_cnt <= FIFOCNT))
//else $display("[ERROR:memoir:%m:%0t] sqfifo overflow", $time);

  // synopsys translate_on

  assign dbg_la_pf_stall = pf_stall;
  assign dbg_la_t3_block = t3_block;
  assign dbg_la_sqfifo_cnt = sqfifo_cnt[BITFIFO:0];
  assign dbg_la_sqfifo_fnd = sqfifo_fnd[0];
  assign dbg_la_sqfifo_fuc = sqfifo_fuc[0];
  assign dbg_la_sqfifo_fsq = sqfifo_fsq[0];
  assign dbg_la_sqfifo_deq = sqfifo_deq[0];
  assign dbg_la_sqfifo_dsl = sqfifo_dsl[0];
  assign dbg_la_sqfifo_pop = sqfifo_pop[0];
  assign dbg_la_sqfifo_psl = sqfifo_psl[0];
  assign dbg_la_sqfifo_ssl = sqfifo_ssl[0];
  assign dbg_la_sqfifo_sdq = sqfifo_sdq[0];
  assign dbg_la_sqfifo_psl_help = sqfifo_psl_help[0]; 
  assign dbg_la_sqfifo_dsq_help = sqfifo_dsq_help[0];
  assign dbg_la_vread_vld = vread_vld[0];
  assign dbg_la_twrite_wire = twrite_wire[0];
  assign dbg_la_twraddr_wire = twraddr_wire[0];
  assign dbg_la_dwrite_wire = dwrite_wire[0];
  assign dbg_la_dwraddr_wire = dwraddr_wire[0];
  assign dbg_la_data_vld     = data_vld [0][SRAM_DELAY-1];
  assign dbg_la_dtag_vld     = dtag_vld [0][SRAM_DELAY-1];
  assign dbg_la_tg_rd_vld = tg_rd_vld[0];
  assign dbg_la_dt_rd_vld = dt_rd_vld[0];
  assign dbg_la_vread_out = vread_out[0]; 
  assign dbg_la_vwrite_out = vwrite_out[0];
  assign dbg_la_vflush_out = vflush_out[0];
  assign dbg_la_vinvld_out = vinvld_out[0];
  assign dbg_la_vucach_out = vucach_out[0];
  assign dbg_la_vsidx_out = vsidx_out[0];
  assign dbg_la_vfill_out = vfill_out[0];
  assign dbg_la_srdwr_out = srdwr_out[0];
  assign dbg_la_sqfifo_hit = sqfifo_hit[0];
  assign dbg_la_sqfifo_htv = sqfifo_htv[0];
  assign dbg_la_sqfifo_hsq = sqfifo_hsq[0];
  assign dbg_la_cache_hit  = cache_hit[0];
  assign dbg_la_cache_map  = cache_map[0];
  assign dbg_la_cache_add  = cache_add[0];
  assign dbg_la_cache_evt  = cache_evt[0];
  assign dbg_la_cache_emp  = cache_emp[0];

  genvar xf_var;
  generate for (xf_var=0; xf_var<FIFOCNT; xf_var++) begin : xf_loop
    assign dbg_la_sqfifo_vld[xf_var] = sqfifo_vld[xf_var];
    assign dbg_la_sqfifo_prv[xf_var] = sqfifo_prv[xf_var];
    assign dbg_la_sqfifo_rdv[xf_var] = sqfifo_rdv[xf_var];
    assign dbg_la_sqfifo_wrv[xf_var] = sqfifo_wrv[xf_var];
    assign dbg_la_sqfifo_flv[xf_var] = sqfifo_flv[xf_var];
    assign dbg_la_sqfifo_inv[xf_var] = sqfifo_inv[xf_var];
    assign dbg_la_sqfifo_uch[xf_var] = sqfifo_uch[xf_var];
    assign dbg_la_sqfifo_idx[xf_var] = sqfifo_idx[xf_var];
    assign dbg_la_sqfifo_fil[xf_var] = sqfifo_fil[xf_var];
  end
  endgenerate

  genvar xw_var, xp_var;
  generate for (xp_var=0; xp_var<NUMRWPT; xp_var++) begin : xp_loop
    for (xw_var=0; xw_var<NUMWRDS; xw_var++) begin : xw_loop
      assign dbg_la_dvld_out[(xp_var*NUMWRDS*1)+((xw_var+1)*1)-1:(xp_var*NUMWRDS*1)+((xw_var)*1)]= dvld_out[xp_var][xw_var];
      assign dbg_la_drty_out[(xp_var*NUMWRDS*1)+((xw_var+1)*1)-1:(xp_var*NUMWRDS*1)+((xw_var)*1)]= drty_out[xp_var][xw_var];
      assign dbg_la_dlru_out[(xp_var*NUMWRDS*BITWRDS)+((xw_var+1)*BITWRDS)-1:(xp_var*NUMWRDS*BITWRDS)+((xw_var)*BITWRDS)]= dlru_out[xp_var][xw_var];
    end 
  end
  endgenerate

endmodule // core_nrw_cache_1r1w
