module core_nrw_cache_1r1w_mb2 (vread, vinvld, vucach, vucofst, vucsize, vsidx, vsqin, vaddr, vbbmp, vread_vld, vread_hit, vread_serr, vread_last, vsqout, vdout, vattr,
                                t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_serrB, t1_bidB,
                                t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_serrB, t2_bidB,
                                t3_readA, t3_ucachA, t3_ucofstA, t3_ucsizeA, t3_sqinA, t3_addrA, t3_vldA, t3_sqoutA, t3_doutA, t3_attrA, t3_stall, t3_block,
                                pf_stall,
                                e_pf_empty, e_pf_oflw, e_uc_stall, e_cache_rd_hit,
                                e_tgerr_vld, e_tgerr_bid, e_tgerr_idx,
                                e_dterr_vld, e_dterr_bid, e_dterr_idx,
                                ready, clk, rst,
                                dbg_la_sqfifo_cnt  ,
                                dbg_la_t3_readA  ,
                                dbg_la_t3_writeA  ,
                                dbg_la_t3_ucachA  ,
                                dbg_la_t3_ucofstA  ,
                                dbg_la_t3_ucsizeA  ,
                                dbg_la_t3_sqinA  ,
                                dbg_la_t3_addrA  ,
                                dbg_la_sqfifo_vld,
                                dbg_la_sqfifo_prv,
                                dbg_la_sqfifo_rdv,
                                dbg_la_sqfifo_inv,
                                dbg_la_sqfifo_uch,
                                dbg_la_sqfifo_idx,
                                dbg_la_sqfifo_fil,
                                dbg_la_pf_stall,
                                dbg_la_t3_stall,
                                dbg_la_t3_block,
                                dbg_la_l2uc_stall,
                                dbg_la_vread,
                                dbg_la_vinvld,
                                dbg_la_vucach,
                                dbg_la_vread_vld ,
                                dbg_la_vread_hit ,
                                dbg_la_vread_last,
                                dbg_la_sqfifo_fbe,
                                dbg_la_sqfifo_fbm,
                                dbg_la_t3_attrA_wire,
                                dbg_la_sqfifo_fnd ,
                                dbg_la_sqfifo_fuc ,
                                dbg_la_sqfifo_fsq ,
                                dbg_la_sqfifo_deq ,
                                dbg_la_sqfifo_dsl ,
                                dbg_la_sqfifo_pop ,
                                dbg_la_sqfifo_psl ,
                                dbg_la_sqfifo_sdq ,
                                dbg_la_sqfifo_ssl ,
                                dbg_la_sqfifo_psl_help , 
                                dbg_la_sqfifo_dsq_help,
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
                                dbg_la_sqfifo_hit,
                                dbg_la_sqfifo_htv,
                                dbg_la_cache_hit,
                                dbg_la_cache_map,
                                dbg_la_cache_add,
                                dbg_la_cache_evt,
                                dbg_la_cache_emp,
                                dbg_la_cache_drt
                              );



  parameter BITWDTH = 3;
  parameter WIDTH = 8;
  parameter BYTWDTH = WIDTH/8;
  parameter NUMRWPT = 1;
  parameter NUMSEQN = 256;
  parameter BITSEQN = 8;
  parameter NUMBEAT = 2;
  parameter BITBEAT = 1;
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

  parameter NUMTGBY = 1;
  parameter NUMDTBY = 1;
  parameter BITTGBY = 5;
  parameter BITDTBY = 7; 

  parameter BITVTAG = BITVROW-BITBEAT; 
  parameter BITDTAG = BITADDR-BITVROW;
  parameter BITTAGW = BITDTAG+BITWRDS+2;

  input [NUMRWPT-1:0]                  vread;
  input [NUMRWPT-1:0]                  vinvld;
  input [NUMRWPT-1:0]                  vucach;
  input [NUMRWPT*BITUOFS-1:0]          vucofst;
  input [NUMRWPT*BITUSIZ-1:0]          vucsize;
  input [NUMRWPT-1:0]                  vsidx;
  input [NUMRWPT*BITSEQN-1:0]          vsqin;
  input [NUMRWPT*BITADDR-1:0]          vaddr;
  input [NUMRWPT*NUMBEAT-1:0]          vbbmp;
  output [NUMRWPT-1:0]                 vread_vld;
  output [NUMRWPT-1:0]                 vread_hit;
  output [NUMRWPT-1:0]                 vread_serr;
  output [NUMRWPT-1:0]                 vread_last;
  output [NUMRWPT*BITSEQN-1:0]         vsqout;
  output [NUMRWPT*WIDTH-1:0]           vdout;
  output [NUMRWPT*BITXATR-1:0]         vattr;

  output [NUMRWPT-1:0]                 t1_writeA;
  output [NUMRWPT*BITVTAG-1:0]         t1_addrA;
  output [NUMRWPT*NUMWRDS*BITTAGW-1:0] t1_dinA;
  output [NUMRWPT-1:0]                 t1_readB;
  output [NUMRWPT*BITVTAG-1:0]         t1_addrB;
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
  output [NUMRWPT-1:0]                 t3_ucachA;
  output [NUMRWPT*BITUOFS-1:0]         t3_ucofstA;
  output [NUMRWPT*BITUSIZ-1:0]         t3_ucsizeA;
  output [NUMRWPT*BITSEQN-1:0]         t3_sqinA;
  output [NUMRWPT*BITADDR-1:0]         t3_addrA;
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
  output                               e_tgerr_vld;
  output [BITTGBY-1:0]                 e_tgerr_bid;
  output [BITVTAG-1:0]                 e_tgerr_idx;
  output                               e_dterr_vld;
  output [BITDTBY-1:0]                 e_dterr_bid;
  output [BITVROW-1:0]                 e_dterr_idx;

  output                               ready;
  input                                clk;
  input                                rst;

  output [BITFIFO:0]dbg_la_sqfifo_cnt  ;
  output dbg_la_t3_readA  ;
  output dbg_la_t3_writeA  ;
  output dbg_la_t3_ucachA  ;
  output [NUMRWPT*BITUOFS-1:0]dbg_la_t3_ucofstA  ;
  output [NUMRWPT*BITUSIZ-1:0]dbg_la_t3_ucsizeA  ;
  output [NUMRWPT*BITSEQN-1:0]dbg_la_t3_sqinA  ;
  output [NUMRWPT*BITADDR-1:0]dbg_la_t3_addrA  ;
  output [FIFOCNT-1:0]dbg_la_sqfifo_vld;
  output [FIFOCNT-1:0]dbg_la_sqfifo_prv;
  output [FIFOCNT-1:0]dbg_la_sqfifo_rdv;
  output [FIFOCNT-1:0]dbg_la_sqfifo_inv;
  output [FIFOCNT-1:0]dbg_la_sqfifo_uch;
  output [FIFOCNT-1:0]dbg_la_sqfifo_idx;
  output [FIFOCNT-1:0]dbg_la_sqfifo_fil;
  output dbg_la_pf_stall;
  output dbg_la_t3_stall;
  output dbg_la_t3_block;
  output dbg_la_l2uc_stall ;
  output dbg_la_vread;
  output dbg_la_vinvld;
  output dbg_la_vucach;
  output dbg_la_vread_vld ;
  output dbg_la_vread_hit ;
  output dbg_la_vread_last;
  output [BITBEAT-1:0] dbg_la_sqfifo_fbe;
  output [NUMBEAT-1:0] dbg_la_sqfifo_fbm;
  output [BITXATR-1:0] dbg_la_t3_attrA_wire;

  output         dbg_la_sqfifo_fnd ;
  output         dbg_la_sqfifo_fuc ;
  output [BITSEQN-1:0] dbg_la_sqfifo_fsq ;
  output         dbg_la_sqfifo_deq ;
  output [BITFIFO-1:0] dbg_la_sqfifo_dsl ;
  output         dbg_la_sqfifo_pop ;
  output [BITFIFO-1:0] dbg_la_sqfifo_psl ;
  output         dbg_la_sqfifo_sdq ;
  output [BITFIFO-1:0] dbg_la_sqfifo_ssl ;
  output [BITSEQN-1:0] dbg_la_sqfifo_psl_help ; 
  output [BITSEQN-1:0] dbg_la_sqfifo_dsq_help;
 
  output dbg_la_twrite_wire;
  output [BITVTAG-1:0] dbg_la_twraddr_wire;
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
  output dbg_la_sqfifo_hit;
  output dbg_la_sqfifo_htv;
  output dbg_la_cache_hit;
  output [BITWRDS-1:0]dbg_la_cache_map;
  output dbg_la_cache_add;
  output dbg_la_cache_evt;
  output [BITWRDS-1:0]dbg_la_cache_emp;
  output [BITWRDS-1:0]dbg_la_cache_drt;


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
  reg                vcirc_out [0:NUMRWPT-1];
  reg                vread_out [0:NUMRWPT-1];
  reg                vinvld_out [0:NUMRWPT-1];
  reg                vucach_out [0:NUMRWPT-1];
  reg [BITUOFS-1:0]  vucofst_out [0:NUMRWPT-1];
  reg [BITUSIZ-1:0]  vucsize_out [0:NUMRWPT-1];
  reg                vsidx_out [0:NUMRWPT-1];
  reg                vfill_out [0:NUMRWPT-1];
  reg [BITSEQN-1:0]  vsqin_out [0:NUMRWPT-1];
  reg [BITXATR-1:0]  vserr_out [0:NUMRWPT-1];
  reg [BITBEAT-1:0]  vbeat_out [0:NUMRWPT-1];
  reg [BITBEAT-1:0]  vbeat_tmp [0:NUMRWPT-1];
  reg [BITADDR-1:0]  vaddr_out [0:NUMRWPT-1];
  reg [BITBEAT-1:0]  vabea_out [0:NUMRWPT-1];
  reg [WIDTH-1:0]    vdin_out [0:NUMRWPT-1];
  reg [NUMBEAT-1:0]  vbbmp_out [0:NUMRWPT-1];

  reg                sread_wire [0:NUMRWPT-1];
  reg                sinvld_wire [0:NUMRWPT-1];
  reg                sucach_wire [0:NUMRWPT-1];
  reg [BITUOFS-1:0]  sucofst_wire [0:NUMRWPT-1];
  reg [BITUSIZ-1:0]  sucsize_wire [0:NUMRWPT-1];
  reg                ssidx_wire [0:NUMRWPT-1];
  reg                sfill_wire [0:NUMRWPT-1];
  reg [BITSEQN-1:0]  ssqin_wire [0:NUMRWPT-1];
  reg [BITXATR-1:0]  sserr_wire [0:NUMRWPT-1];
  reg [BITBEAT-1:0]  sbeat_wire [0:NUMRWPT-1];
  reg [BITADDR-1:0]  saddr_wire [0:NUMRWPT-1];
  reg [WIDTH-1:0]    sdin_wire [0:NUMRWPT-1];
  reg [NUMBEAT-1:0]  sbbmp_wire [0:NUMRWPT-1];

  wire               ready_wire;
  wire               srdwr_wire [0:NUMRWPT-1];
  wire               vcirc_wire [0:NUMRWPT-1];
  wire               vread_wire [0:NUMRWPT-1];
  wire               vinvld_wire [0:NUMRWPT-1];
  wire               vucach_wire [0:NUMRWPT-1];
  wire [BITUOFS-1:0] vucofst_wire [0:NUMRWPT-1];
  wire [BITUSIZ-1:0] vucsize_wire [0:NUMRWPT-1];
  wire               vsidx_wire [0:NUMRWPT-1];
  wire               vfill_wire [0:NUMRWPT-1];
  wire [BITSEQN-1:0] vsqin_wire [0:NUMRWPT-1];
  wire [BITXATR-1:0] vserr_wire [0:NUMRWPT-1];
  wire [BITBEAT-1:0] vbeat_wire [0:NUMRWPT-1];
  wire [BITADDR-1:0] vaddr_wire [0:NUMRWPT-1];
  wire [WIDTH-1:0]   vdin_wire [0:NUMRWPT-1];
  wire [NUMBEAT-1:0] vbbmp_wire [0:NUMRWPT-1];

  genvar flp_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMRWPT-1:0] vread_reg;
    reg [NUMRWPT-1:0] vinvld_reg;
    reg [NUMRWPT-1:0] vsidx_reg;
    reg [NUMRWPT-1:0] vucach_reg;
    reg [NUMRWPT*BITUOFS-1:0] vucofst_reg;
    reg [NUMRWPT*BITUSIZ-1:0] vucsize_reg;
    reg [NUMRWPT*BITSEQN-1:0] vsqin_reg;
    reg [NUMRWPT*BITADDR-1:0] vaddr_reg;
    reg [NUMRWPT*NUMBEAT-1:0] vbbmp_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread && {NUMRWPT{ready}};
      vinvld_reg <= vinvld && {NUMRWPT{ready}};
      vucach_reg <= vucach && {NUMRWPT{ready}};
      vucofst_reg <= vucofst;
      vucsize_reg <= vucsize;
      vsidx_reg <= vsidx;
      vsqin_reg <= vsqin;
      vaddr_reg <= vaddr;
      vbbmp_reg <= vbbmp;
    end

    assign ready_wire = ready_reg;
    for (flp_var=0; flp_var<NUMRWPT; flp_var=flp_var+1) begin: ct_loop
      assign srdwr_wire[flp_var] = sread_wire[flp_var]; 
      assign vread_wire[flp_var] = srdwr_wire[flp_var] ? sread_wire[flp_var] : vread_reg[flp_var];// && (vaddr_wire[flp_var]<NUMADDR);
      assign vinvld_wire[flp_var] = srdwr_wire[flp_var] ? sinvld_wire[flp_var] : vinvld_reg[flp_var];// && (vaddr_wire[flp_var]<NUMADDR);
      assign vucach_wire[flp_var] = srdwr_wire[flp_var] ? sucach_wire[flp_var] : vucach_reg[flp_var];// && (vaddr_wire[flp_var]<NUMADDR);
      assign vucofst_wire[flp_var] = srdwr_wire[flp_var] ? sucofst_wire[flp_var] : vucofst_reg[flp_var];
      assign vucsize_wire[flp_var] = srdwr_wire[flp_var] ? sucsize_wire[flp_var] : vucsize_reg[flp_var];
      assign vsidx_wire[flp_var] = srdwr_wire[flp_var] ? ssidx_wire[flp_var] : vsidx_reg[flp_var];
      assign vfill_wire[flp_var] = srdwr_wire[flp_var] ? sfill_wire[flp_var] : 1'b0;
      assign vsqin_wire[flp_var] = srdwr_wire[flp_var] ? ssqin_wire[flp_var] : vsqin_reg >> (flp_var*BITSEQN);
      assign vserr_wire[flp_var] = srdwr_wire[flp_var] ? sserr_wire[flp_var] : {BITXATR{1'b0}};
      assign vbeat_wire[flp_var] = srdwr_wire[flp_var] ? sbeat_wire[flp_var] : vaddr_wire[flp_var][BITBEAT-1:0];
      assign vaddr_wire[flp_var] = srdwr_wire[flp_var] ? saddr_wire[flp_var] : vaddr_reg >> (flp_var*BITADDR);
      assign vdin_wire[flp_var] = sdin_wire[flp_var]; 
      assign vbbmp_wire[flp_var] = srdwr_wire[flp_var] ? sbbmp_wire[flp_var] : vbbmp_reg >> (flp_var*NUMBEAT);
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (flp_var=0; flp_var<NUMRWPT; flp_var=flp_var+1) begin: ct_loop
      assign srdwr_wire[flp_var] = vcirc_wire[flp_var] ? srdwr_out[flp_var] : sread_wire[flp_var] || sinvld_wire[flp_var];
      assign vread_wire[flp_var] = vcirc_wire[flp_var] ? vread_out[flp_var] : srdwr_wire[flp_var] ? sread_wire[flp_var] : vread[flp_var] && ready;// && (vaddr_wire[flp_var]<NUMADDR) && ready;
      assign vinvld_wire[flp_var] = vcirc_wire[flp_var] ? 1'b0 : srdwr_wire[flp_var] ? sinvld_wire[flp_var] : vinvld[flp_var] && ready;// && (vaddr_wire[flp_var]<NUMADDR) && ready;
      assign vucach_wire[flp_var] = vcirc_wire[flp_var] ? 1'b0 : srdwr_wire[flp_var] ? sucach_wire[flp_var] : vucach[flp_var] && ready;// && (vaddr_wire[flp_var]<NUMADDR) && ready;
      assign vucofst_wire[flp_var] = vcirc_wire[flp_var] ? {BITUOFS{1'b0}} : srdwr_wire[flp_var] ? sucofst_wire[flp_var] : vucofst >> (flp_var*BITUOFS);
      assign vucsize_wire[flp_var] = vcirc_wire[flp_var] ? {BITUOFS{1'b0}} : srdwr_wire[flp_var] ? sucsize_wire[flp_var] : vucsize >> (flp_var*BITUSIZ);
      assign vsidx_wire[flp_var] = vcirc_wire[flp_var] ? 1'b0 : srdwr_wire[flp_var] ? ssidx_wire[flp_var] : vsidx >> flp_var;
      assign vfill_wire[flp_var] = vcirc_wire[flp_var] ? 1'b0 : srdwr_wire[flp_var] ? sfill_wire[flp_var] : 1'b0;
      assign vsqin_wire[flp_var] = vcirc_wire[flp_var] ? vsqin_out[flp_var] : srdwr_wire[flp_var] ? ssqin_wire[flp_var] : vsqin >> (flp_var*BITSEQN);
      assign vserr_wire[flp_var] = vcirc_wire[flp_var] ? {BITXATR{1'b0}} : srdwr_wire[flp_var] ? sserr_wire[flp_var] : {BITXATR{1'b0}};
      assign vbeat_wire[flp_var] = vcirc_wire[flp_var] ? ((&vbeat_out[flp_var] && vfill_out[flp_var]) ? vabea_out[flp_var] : vabea_out[flp_var]+1) : srdwr_wire[flp_var] ? sbeat_wire[flp_var] : vaddr_wire[flp_var];
      assign vaddr_wire[flp_var] = vcirc_wire[flp_var] ? ((&vbeat_out[flp_var] && vfill_out[flp_var]) ? vaddr_out[flp_var] : vaddr_out[flp_var]+1) : srdwr_wire[flp_var] ? saddr_wire[flp_var] : vaddr >> (flp_var*BITADDR);
      assign vdin_wire[flp_var] = sdin_wire[flp_var];
      assign vbbmp_wire[flp_var] = vcirc_wire[flp_var] ? vbbmp_out[flp_var] : srdwr_wire[flp_var] ? sbbmp_wire[flp_var] : vbbmp >> (flp_var*NUMBEAT);
    end
  end
  endgenerate

  reg                srdwr_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg                vcirc_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg                vread_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg                vinvld_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg                vucach_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [BITUOFS-1:0]  vucofst_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [BITUSIZ-1:0]  vucsize_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg                vsidx_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg                vfill_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [BITSEQN-1:0]  vsqin_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [BITXATR-1:0]  vserr_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [BITBEAT-1:0]  vbeat_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [BITADDR-1:0]  vaddr_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]    vdin_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [NUMBEAT-1:0]  vbbmp_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  integer            vdel_int, vprt_int;
  always @(posedge clk) 
    for (vdel_int=0; vdel_int<SRAM_DELAY; vdel_int=vdel_int+1)
      if (vdel_int>0) begin
        for (vprt_int=0; vprt_int<NUMRWPT; vprt_int=vprt_int+1) begin
          srdwr_reg[vprt_int][vdel_int] <= srdwr_reg[vprt_int][vdel_int-1];
          vcirc_reg[vprt_int][vdel_int] <= vcirc_reg[vprt_int][vdel_int-1];
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
          vinvld_reg[vprt_int][vdel_int] <= vinvld_reg[vprt_int][vdel_int-1];
          vucach_reg[vprt_int][vdel_int] <= vucach_reg[vprt_int][vdel_int-1];
          vucofst_reg[vprt_int][vdel_int] <= vucofst_reg[vprt_int][vdel_int-1];
          vucsize_reg[vprt_int][vdel_int] <= vucsize_reg[vprt_int][vdel_int-1];
          vsidx_reg[vprt_int][vdel_int] <= vsidx_reg[vprt_int][vdel_int-1];
          vfill_reg[vprt_int][vdel_int] <= vfill_reg[vprt_int][vdel_int-1];
          vsqin_reg[vprt_int][vdel_int] <= vsqin_reg[vprt_int][vdel_int-1];
          vserr_reg[vprt_int][vdel_int] <= vserr_reg[vprt_int][vdel_int-1];
          vbeat_reg[vprt_int][vdel_int] <= vbeat_reg[vprt_int][vdel_int-1];
          vaddr_reg[vprt_int][vdel_int] <= vaddr_reg[vprt_int][vdel_int-1];
          vdin_reg[vprt_int][vdel_int] <= vdin_reg[vprt_int][vdel_int-1];
          vbbmp_reg[vprt_int][vdel_int] <= vbbmp_reg[vprt_int][vdel_int-1];
        end
      end else begin
        for (vprt_int=0; vprt_int<NUMRWPT; vprt_int=vprt_int+1) begin
          srdwr_reg[vprt_int][vdel_int] <= srdwr_wire[vprt_int];
          vcirc_reg[vprt_int][vdel_int] <= vcirc_wire[vprt_int];
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
          vinvld_reg[vprt_int][vdel_int] <= vinvld_wire[vprt_int];
          vucach_reg[vprt_int][vdel_int] <= vucach_wire[vprt_int];
          vucofst_reg[vprt_int][vdel_int] <= vucofst_wire[vprt_int];
          vucsize_reg[vprt_int][vdel_int] <= vucsize_wire[vprt_int];
          vsidx_reg[vprt_int][vdel_int] <= vsidx_wire[vprt_int];
          vfill_reg[vprt_int][vdel_int] <= vfill_wire[vprt_int];
          vsqin_reg[vprt_int][vdel_int] <= vsqin_wire[vprt_int];
          vserr_reg[vprt_int][vdel_int] <= vserr_wire[vprt_int];
          vbeat_reg[vprt_int][vdel_int] <= vbeat_wire[vprt_int];
          vaddr_reg[vprt_int][vdel_int] <= vaddr_wire[vprt_int];
          vdin_reg[vprt_int][vdel_int] <= vdin_wire[vprt_int];
          vbbmp_reg[vprt_int][vdel_int] <= vbbmp_wire[vprt_int];
        end
      end
  
  integer vout_int, vwpt_int;
  always_comb
    for (vout_int=0; vout_int<NUMRWPT; vout_int=vout_int+1) begin
      srdwr_out[vout_int] = srdwr_reg[vout_int][SRAM_DELAY-1];
      vcirc_out[vout_int] = vcirc_reg[vout_int][SRAM_DELAY-1];
      vread_out[vout_int] = vread_reg[vout_int][SRAM_DELAY-1];
      vinvld_out[vout_int] = vinvld_reg[vout_int][SRAM_DELAY-1];
      vucach_out[vout_int] = vucach_reg[vout_int][SRAM_DELAY-1];
      vucofst_out[vout_int] = vucofst_reg[vout_int][SRAM_DELAY-1];
      vucsize_out[vout_int] = vucsize_reg[vout_int][SRAM_DELAY-1];
      vsidx_out[vout_int] = vsidx_reg[vout_int][SRAM_DELAY-1];
      vfill_out[vout_int] = vfill_reg[vout_int][SRAM_DELAY-1];
      vsqin_out[vout_int] = vsqin_reg[vout_int][SRAM_DELAY-1];
      vserr_out[vout_int] = vserr_reg[vout_int][SRAM_DELAY-1];
      vbeat_out[vout_int] = vbeat_reg[vout_int][SRAM_DELAY-1];
      vbeat_tmp[vout_int] = vbeat_out[vout_int]+1;
      vaddr_out[vout_int] = vaddr_reg[vout_int][SRAM_DELAY-1];
      vdin_out[vout_int] = vdin_reg[vout_int][SRAM_DELAY-1];
      vbbmp_out[vout_int] = vbbmp_reg[vout_int][SRAM_DELAY-1];
    end

  reg [NUMRWPT-1:0]          t1_readB;
  reg [NUMRWPT*BITVTAG-1:0]  t1_addrB;
  integer t1rp_int, t1ra_int;
  always_comb begin
    t1_readB = 0;
    t1_addrB = 0;
    for (t1rp_int=0; t1rp_int<NUMRWPT; t1rp_int=t1rp_int+1) begin
      if ((vread_wire[t1rp_int] || vinvld_wire[t1rp_int]) && !vucach_wire[t1rp_int])
        t1_readB = t1_readB | (1'b1 << t1rp_int);
      for (t1ra_int=0; t1ra_int<BITVTAG; t1ra_int=t1ra_int+1)
        t1_addrB[t1rp_int*BITVTAG+t1ra_int] = vaddr_wire[t1rp_int][t1ra_int+BITBEAT];
    end
  end

  reg [NUMRWPT-1:0]          t2_readB;
  reg [NUMRWPT*BITVROW-1:0]  t2_addrB;
  integer t2rp_int, t2ra_int;
  always_comb begin
    t2_readB = 0;
    t2_addrB = 0;
    for (t2rp_int=0; t2rp_int<NUMRWPT; t2rp_int=t2rp_int+1) begin
      if (vread_wire[t2rp_int] && !vucach_wire[t2rp_int])
        t2_readB = t2_readB | (1'b1 << t2rp_int);
      for (t2ra_int=0; t2ra_int<BITVROW; t2ra_int=t2ra_int+1)
//        t2_addrB[t2rp_int*BITVROW+t2ra_int] = vaddr_wire[t2rp_int][t2ra_int];
      t2_addrB = t2_addrB | ((BITBEAT==0) ? vaddr_wire[t2rp_int] : {vaddr_wire[t2rp_int][BITADDR-1:BITBEAT],vbeat_wire[t2rp_int]});
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
  reg [BITVTAG-1:0]         twraddr_wire [0:NUMRWPT-1];
  reg [NUMWRDS*BITTAGW-1:0] tdin_wire [0:NUMRWPT-1];

  reg                       dtag_vld [0:NUMRWPT-1][0:SRAM_DELAY-1];
  reg [NUMWRDS*BITTAGW-1:0] dtag_reg [0:NUMRWPT-1][0:SRAM_DELAY-1];
  genvar tprt_var, tfwd_var;
  generate
    for (tfwd_var=0; tfwd_var<SRAM_DELAY; tfwd_var=tfwd_var+1) begin: dt_loop
      for (tprt_var=0; tprt_var<NUMRWPT; tprt_var=tprt_var+1) begin: rw_loop
        reg [BITVTAG-1:0] vaddr_temp;
        reg dtag_vld_next;
        reg [NUMWRDS*BITTAGW-1:0] dtag_reg_next;
        integer fwpt_int;
        always_comb begin
          if (tfwd_var>0) begin
            vaddr_temp = vaddr_reg[tprt_var][tfwd_var-1] >> BITBEAT;
            dtag_vld_next = dtag_vld[tprt_var][tfwd_var-1];
            dtag_reg_next = dtag_reg[tprt_var][tfwd_var-1];
          end else begin
            vaddr_temp = vaddr_wire[tprt_var] >> BITBEAT;
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
            vaddr_temp = (BITBEAT==0) ? vaddr_reg[dprt_var][dfwd_var-1] : {vaddr_reg[dprt_var][dfwd_var-1][BITVROW-1:BITBEAT],vbeat_reg[dprt_var][dfwd_var-1]};
//            vaddr_temp = vaddr_reg[dprt_var][dfwd_var-1];
            data_vld_next = data_vld[dprt_var][dfwd_var-1];
            data_reg_next = data_reg[dprt_var][dfwd_var-1];
          end else begin
            vaddr_temp = (BITBEAT==0) ? vaddr_wire[dprt_var] : {vaddr_wire[dprt_var][BITVROW-1:BITBEAT],vbeat_wire[dprt_var]};
//            vaddr_temp = vaddr_wire[dprt_var];
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
        if (twrite_wire[fwdd_int] && (twraddr_wire[fwdd_int]==vaddr_out[fwdp_int][BITVROW-1:BITBEAT]))
          dtag_out[fwdp_int] = tdin_wire[fwdd_int];
      data_out[fwdp_int] = ddout_wire[fwdp_int];
      if (data_vld[fwdp_int][SRAM_DELAY-1])
        data_out[fwdp_int] = data_reg[fwdp_int][SRAM_DELAY-1];
      for (fwdd_int=0; fwdd_int<NUMRWPT; fwdd_int=fwdd_int+1)
        if (dwrite_wire[fwdd_int] && (dwraddr_wire[fwdd_int]==((BITBEAT==0) ? vaddr_out[fwdp_int][BITVROW-1:BITBEAT] : {vaddr_out[fwdp_int][BITVROW-1:BITBEAT],vbeat_out[fwdp_int]})))
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
  reg [BITFIFO-1:0] sqfifo_hsl [0:NUMRWPT-1];
  reg [BITSEQN-1:0] sqfifo_help_seq [0:NUMRWPT-1];
  reg               cache_hit [0:NUMRWPT-1];
  reg [BITWRDS-1:0] cache_map [0:NUMRWPT-1];
  reg               cache_add [0:NUMRWPT-1];
  reg               cache_evt [0:NUMRWPT-1];
  reg [BITWRDS-1:0] cache_emp [0:NUMRWPT-1];
  reg [BITWRDS-1:0] cache_drt [0:NUMRWPT-1];
  integer casp_int, casb_int;
  always_comb
    for (casp_int=0; casp_int<NUMRWPT; casp_int=casp_int+1) begin
      cache_hit[casp_int] = 1'b0;
      cache_map[casp_int] = 0;
      cache_add[casp_int] = srdwr_out[casp_int];
      cache_evt[casp_int] = srdwr_out[casp_int];
      cache_emp[casp_int] = 0;
      cache_drt[casp_int] = 0;
      for (casb_int=0; casb_int<NUMWRDS; casb_int=casb_int+1) begin
        if (dvld_out[casp_int][casb_int] && (vsidx_out[casp_int] ? (srdwr_out[casp_int] && vinvld_out[casp_int]) :
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
      for (casb_int=0; casb_int<NUMWRDS; casb_int=casb_int+1)
        if (dvld_out[casp_int][casb_int] && (drty_out[casp_int][casb_int]))
          cache_drt[casp_int] = casb_int;
      cache_add[casp_int] = cache_add[casp_int] && !cache_hit[casp_int] && !cache_evt[casp_int];
      cache_evt[casp_int] = cache_evt[casp_int] && !cache_hit[casp_int];
//      if (cache_hit[casp_int]) begin
//        cache_emp[casp_int] = cache_map[casp_int];
//        if (dbea_out[casp_int][cache_map[casp_int]]<vaddr_out[casp_int][BITBEAT-1:0])
//          cache_hit[casp_int] = 1'b0;
//      end
    end
  
  wire [NUMRWPT-1:0]         tg_serr;
  wire [NUMRWPT-1:0]         dt_serr;
  assign vcirc_wire[0] = vread_out[0] && !vucach_out[0] && (BITBEAT!=0) && !(|vserr_out[0]) && ready && 
                         ((vfill_out[0] && &vbeat_out[0]) ||
                          (cache_hit[0] && !vfill_out[0] && !(&vabea_out[0]) && vbbmp_out[0][vbeat_tmp[0]]));

  reg [BITWRDS-1:0] dlru_tmp [0:NUMRWPT-1];
  integer lrut_int;
  always_comb
   for (lrut_int=0; lrut_int<NUMRWPT; lrut_int=lrut_int+1)
     dlru_tmp[lrut_int] = dlru_out[lrut_int][cache_map[lrut_int]];

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
  always @(posedge clk) begin
    tg_rd_vld <= t1_readB; 
    dt_rd_vld <= t2_readB;
  end

  assign tg_serr = t1_serrB && tg_rd_vld;
  assign dt_serr = t2_serrB && dt_rd_vld;

  reg                       twrite_next [0:NUMRWPT-1];
  reg [BITVTAG-1:0]         twraddr_next [0:NUMRWPT-1];
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
      end else if (srdwr_out[twr_int] && !cache_hit[twr_int] && !vucach_out[twr_int] && vfill_out[twr_int]) begin
        twrite_next[twr_int] = 1'b1;
        twraddr_next[twr_int] = vaddr_out[twr_int] >> BITBEAT;
        for (twx_int=0; twx_int<NUMWRDS; twx_int=twx_int+1)
          if (cache_emp[twr_int]==twx_int)
            tdin_next[twr_int] = tdin_next[twr_int] |
                                 ({(1'b1 && !(|vserr_out[twr_int])),1'b0,{BITWRDS{1'b0}},vaddr_out[twr_int][BITADDR-1:BITVROW]} << (twx_int*BITTAGW));
                                 //({(1'b1 && !(|vserr_out[twr_int])),1'b0,2'b00,vaddr_out[twr_int][BITADDR-1:BITVROW]} << (twx_int*BITTAGW));
          else
            tdin_next[twr_int] = tdin_next[twr_int] |
                                 ({dvld_out[twr_int][twx_int],drty_out[twr_int][twx_int],dlru_nxt[twr_int][twx_int],dmap_out[twr_int][twx_int]} << (twx_int*BITTAGW));
      //end else if ((vread_out[twr_int] || vinvld_out[twr_int]) && (srdwr_out[twr_int] || !sqfifo_hit[twr_int]) && cache_hit[twr_int] && !vucach_out[twr_int]) begin
      end else if ((vread_out[twr_int] && !sqfifo_hit[twr_int] && cache_hit[twr_int] && !vucach_out[twr_int]) || 
                   (((vinvld_out[twr_int] && !sqfifo_hit[twr_int]) || |vserr_out[twr_int]) && cache_hit[twr_int] && !vucach_out[twr_int])) begin
        twrite_next[twr_int] = 1'b1;
        twraddr_next[twr_int] = vaddr_out[twr_int] >> BITBEAT;
        for (twx_int=0; twx_int<NUMWRDS; twx_int=twx_int+1)
          if (cache_map[twr_int]==twx_int)
            tdin_next[twr_int] = tdin_next[twr_int] |
                                 ({(!vinvld_out[twr_int] && !(|vserr_out[twr_int])),drty_out[twr_int][twx_int],{BITWRDS{1'b0}},dmap_out[twr_int][twx_int]} << (twx_int*BITTAGW));
                                 //({(!vinvld_out[twr_int] && !(|vserr_out[twr_int])),drty_out[twr_int][twx_int],2'b00,dmap_out[twr_int][twx_int]} << (twx_int*BITTAGW));
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
  reg [WIDTH-1:0]         ddin_next [0:NUMRWPT-1][0:NUMWRDS-1];
  always_comb
    for (integer dwr_int=0; dwr_int<NUMRWPT; dwr_int=dwr_int+1) begin
      dwrite_next[dwr_int] = 1'b0;
      dwraddr_next[dwr_int] = {BITVROW{1'b0}};
      for (integer dwx_int=0; dwx_int<NUMWRDS; dwx_int=dwx_int+1)
        ddin_next[dwr_int][dwx_int] = {WIDTH{1'b0}};
      if (!rst && rstvld && (dwr_int==0)) begin
        dwrite_next[dwr_int] = 1'b1;
        dwraddr_next[dwr_int] = rstaddr;
      end else if (srdwr_out[dwr_int] && !vucach_out[dwr_int] && vfill_out[dwr_int]) begin
        dwrite_next[dwr_int] = 1'b1;
        dwraddr_next[dwr_int] = (BITBEAT==0) ? vaddr_out[dwr_int] : {vaddr_out[dwr_int][BITADDR-1:BITBEAT],vbeat_out[dwr_int]};
        if (cache_hit[dwr_int]) begin
          for (integer dwx_int=0; dwx_int<NUMWRDS; dwx_int=dwx_int+1)
            if (cache_map[dwr_int]==dwx_int)
              ddin_next[dwr_int][dwx_int] = vdin_out[dwr_int];
            else
              ddin_next[dwr_int][dwx_int] = ddat_out[dwr_int][dwx_int]; 
        end else begin
          for (integer dwx_int=0; dwx_int<NUMWRDS; dwx_int=dwx_int+1)
            if (cache_emp[dwr_int]==dwx_int)
              ddin_next[dwr_int][dwx_int] = vdin_out[dwr_int];
            else
              ddin_next[dwr_int][dwx_int] = ddat_out[dwr_int][dwx_int];
        end
      end
      if (tg_serr[dwr_int] || dt_serr[dwr_int] || |vserr_out[dwr_int])
        dwrite_next[dwr_int] = 1'b0;
    end

  always @(posedge clk)
    for (integer dwd_int=0; dwd_int<NUMRWPT; dwd_int=dwd_int+1) begin
      dwrite_wire[dwd_int] <= dwrite_next[dwd_int];
      dwraddr_wire[dwd_int] <= dwraddr_next[dwd_int];
    end
  genvar dwd_var, dww_var;
  generate for (dwd_var=0;dwd_var<NUMRWPT;dwd_var=dwd_var+1) begin : dwd_loop
    for (dww_var=0;dww_var<NUMWRDS;dww_var=dww_var+1) begin : dww_loop
      always @(posedge clk)
        ddin_wire[dwd_var][(WIDTH*(dww_var+1))-1:WIDTH*dww_var] <= ddin_next[dwd_var][dww_var];
    end
  end
  endgenerate

  reg               sqfifo_fnd [0:NUMRWPT-1];
  reg               sqfifo_fuc [0:NUMRWPT-1];
  reg [BITSEQN-1:0] sqfifo_fsq [0:NUMRWPT-1];
  reg [BITADDR-1:0] sqfifo_fad [0:NUMRWPT-1];
  reg [BITBEAT-1:0] sqfifo_fbe [0:NUMRWPT-1];
  reg [NUMBEAT-1:0] sqfifo_fbm [0:NUMRWPT-1];
  reg [WIDTH-1:0]   sqfifo_fda [0:NUMRWPT-1];
  reg               sqfifo_deq [0:NUMRWPT-1];
  reg [BITFIFO-1:0] sqfifo_dsl [0:NUMRWPT-1];
  reg               sqfifo_pop [0:NUMRWPT-1];
  reg [BITFIFO-1:0] sqfifo_psl [0:NUMRWPT-1];
  reg               sqfifo_sdq [0:NUMRWPT-1];
  reg [BITFIFO-1:0] sqfifo_ssl [0:NUMRWPT-1];
  reg [BITSEQN-1:0] sqfifo_psl_help [0:NUMRWPT-1];

  reg               vsqwr_nxt [0:NUMRWPT-1];
  reg               vsqpp_nxt [0:NUMRWPT-1];
  reg               vsqvld_nxt [0:NUMRWPT-1];
  reg               vprvld_nxt [0:NUMRWPT-1];
  reg               vread_nxt [0:NUMRWPT-1];
  reg               vinvld_nxt [0:NUMRWPT-1];
  reg               vucach_nxt [0:NUMRWPT-1];
  reg [BITUOFS-1:0] vucofst_nxt [0:NUMRWPT-1];
  reg [BITUSIZ-1:0] vucsize_nxt [0:NUMRWPT-1];
  reg               vsidx_nxt [0:NUMRWPT-1];
  reg               vfill_nxt [0:NUMRWPT-1];
  reg [BITSEQN-1:0] vsqin_nxt [0:NUMRWPT-1];
  reg [BITADDR-1:0] vaddr_nxt [0:NUMRWPT-1];
  reg [BITBEAT-1:0] vbeat_nxt [0:NUMRWPT-1];
  reg [NUMBEAT-1:0] vbbmp_nxt [0:NUMRWPT-1];
  integer vnxt_int, vnfd_int;
  always @(posedge clk)
    for (vnxt_int=0; vnxt_int<NUMRWPT; vnxt_int=vnxt_int+1) begin
      vsqwr_nxt[vnxt_int]  <= (!srdwr_out[vnxt_int] && !vcirc_out[vnxt_int] && vread_out[vnxt_int] && !vucach_out[vnxt_int] && (sqfifo_hit[vnxt_int] || !cache_hit[vnxt_int]) && !(tg_serr[vnxt_int] || dt_serr[vnxt_int])) ||
                              (!srdwr_out[vnxt_int] && vinvld_out[vnxt_int] && sqfifo_hit[vnxt_int] && !tg_serr[vnxt_int]) ||
                              (!srdwr_out[vnxt_int] && vucach_out[vnxt_int]);
      vsqpp_nxt[vnxt_int]  <= (vread_out[vnxt_int] && vfill_out[vnxt_int] && ((BITBEAT==0) || &vbeat_out[vnxt_int])) ||
                              (vread_out[vnxt_int] && !vfill_out[vnxt_int] && !sqfifo_hit[vnxt_int] && cache_hit[vnxt_int] && !vucach_out[vnxt_int]) ||
                              (vread_out[vnxt_int] && |vserr_out[vnxt_int]) ||
                              (vread_out[vnxt_int] && !cache_hit[vnxt_int] && !vfill_out[vnxt_int] && (tg_serr[vnxt_int] || dt_serr[vnxt_int])) ||
                              (vread_out[vnxt_int] && cache_hit[vnxt_int] && !vfill_out[vnxt_int] && (tg_serr[vnxt_int] || dt_serr[vnxt_int])) ||
                              (srdwr_out[vnxt_int] && vinvld_out[vnxt_int] && !sqfifo_hit[vnxt_int]) ||
                              (srdwr_out[vnxt_int] && vucach_out[vnxt_int] && ((BITBEAT==0) || &vbeat_out[vnxt_int] || !vbbmp_out[vnxt_int][vbeat_tmp[vnxt_int]]));
      vsqvld_nxt[vnxt_int] <= sqfifo_hit[vnxt_int] && sqfifo_htv[vnxt_int];
      vprvld_nxt[vnxt_int] <= (!vcirc_out[vnxt_int] && vread_out[vnxt_int] && !sqfifo_hit[vnxt_int] && !cache_hit[vnxt_int] && !vucach_out[vnxt_int] && !vfill_out[vnxt_int] && !(tg_serr[vnxt_int] || dt_serr[vnxt_int])) ||
                              (!srdwr_out[vnxt_int] && vread_out[vnxt_int] && vucach_out[vnxt_int]);
      vread_nxt[vnxt_int]  <= vread_out[vnxt_int];
      vinvld_nxt[vnxt_int] <= vinvld_out[vnxt_int];
      vucach_nxt[vnxt_int] <= vucach_out[vnxt_int];
      vucofst_nxt[vnxt_int] <= vucofst_out[vnxt_int];
      vucsize_nxt[vnxt_int] <= vucsize_out[vnxt_int];
      vsidx_nxt[vnxt_int] <= vsidx_out[vnxt_int];
      vfill_nxt[vnxt_int] <= (vread_out[vnxt_int] && !sqfifo_hit[vnxt_int] && !cache_hit[vnxt_int]) || vucach_out[vnxt_int];
      vsqin_nxt[vnxt_int] <= vsqin_out[vnxt_int];
      vaddr_nxt[vnxt_int] <= vaddr_out[vnxt_int];
      vbeat_nxt[vnxt_int] <= (vread_out[vnxt_int] && !vucach_out[vnxt_int] && !cache_hit[vnxt_int] && !sqfifo_hit[vnxt_int]) ? 0 : vaddr_out[vnxt_int];
      vbbmp_nxt[vnxt_int] <= vbbmp_out[vnxt_int];
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
  reg               sqfifo_inv [0:FIFOCNT-1];
  reg               sqfifo_uch [0:FIFOCNT-1];
  reg [BITUOFS-1:0] sqfifo_uof [0:FIFOCNT-1];
  reg [BITUSIZ-1:0] sqfifo_usz [0:FIFOCNT-1];
  reg               sqfifo_idx [0:FIFOCNT-1];
  reg               sqfifo_fil [0:FIFOCNT-1];
  reg [BITSEQN-1:0] sqfifo_seq [0:FIFOCNT-1];
  reg [BITBEAT-1:0] sqfifo_bea [0:FIFOCNT-1];
  reg [BITADDR-1:0] sqfifo_adr [0:FIFOCNT-1];
  reg [NUMBEAT-1:0] sqfifo_bbm [0:FIFOCNT-1];

  reg [BITFIFO-1:0] sqfifo_dcnt;
  reg [BITFIFO-1:0] sqfifo_ecnt;
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

  reg [BITFIFO-1:0] vsq_pos;
  always_comb begin
    vsq_pos = 0;
    for (integer pi=0; pi<FIFOCNT; pi++)
      if (sqfifo_seq[pi] == vsqin_out[0])
        vsq_pos = pi;
  end

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
      reg               sqfifo_inv_next;
      reg               sqfifo_uch_next;
      reg [BITUOFS-1:0] sqfifo_uof_next;
      reg [BITUSIZ-1:0] sqfifo_usz_next;
      reg               sqfifo_idx_next;
      reg               sqfifo_fil_next;
      reg [BITSEQN-1:0] sqfifo_seq_next;
      reg [BITBEAT-1:0] sqfifo_bea_next;
      reg [BITADDR-1:0] sqfifo_adr_next;
      reg [NUMBEAT-1:0] sqfifo_bbm_next;
      integer fcnx_int;
      always_comb
        if ((vsq_sel != NUMRWPT) && vsqwr_nxt[vsq_sel]) begin
          sqfifo_vld_next = vsqvld_nxt[vsq_sel];
          sqfifo_prv_next = vprvld_nxt[vsq_sel] && (sqfifo_sdq[0] || t3_block);
          sqfifo_bbm_next = vbbmp_nxt[vsq_sel];
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (sqfifo_fnd[fcnx_int] && (vaddr_nxt[vsq_sel][BITADDR-1:BITBEAT]==sqfifo_fad[fcnx_int][BITADDR-1:BITBEAT]) && ((BITBEAT==0) || &sqfifo_fbe[fcnx_int] || |t3_attrA_wire[fcnx_int]) && !sqfifo_fuc[fcnx_int] && !vucach_nxt[vsq_sel]) begin
              sqfifo_vld_next = 1'b1;
            end
          sqfifo_rdv_next = vread_nxt[vsq_sel];
          sqfifo_inv_next = vinvld_nxt[vsq_sel];
          sqfifo_uch_next = vucach_nxt[vsq_sel];
          sqfifo_uof_next = vucofst_nxt[vsq_sel];
          sqfifo_usz_next = vucsize_nxt[vsq_sel];
          sqfifo_idx_next = vsidx_nxt[vsq_sel];
          sqfifo_fil_next = vfill_nxt[vsq_sel];
          sqfifo_seq_next = vsqin_nxt[vsq_sel];
          sqfifo_adr_next = vaddr_nxt[vsq_sel];
          sqfifo_bea_next = vbeat_nxt[vsq_sel];
          if ((sffo_var==0) && vsidx_nxt[vsq_sel])
            sqfifo_vld_next = 1'b1;
        end else if (|sqfifo_dcnt && (sffo_var>=sqfifo_psl[0]) && (sffo_var<FIFOCNT-sqfifo_dcnt)) begin
          sqfifo_vld_next = sqfifo_vld[sffo_var+sqfifo_dcnt];
          sqfifo_prv_next = sqfifo_prv[sffo_var+sqfifo_dcnt];
          sqfifo_bbm_next = sqfifo_bbm[sffo_var+sqfifo_dcnt];
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (sqfifo_fnd[fcnx_int] && (sqfifo_adr[sffo_var+sqfifo_dcnt][BITADDR-1:BITBEAT]==sqfifo_fad[fcnx_int][BITADDR-1:BITBEAT]) && ((BITBEAT==0) || &sqfifo_fbe[fcnx_int] || |t3_attrA_wire[fcnx_int]) &&
                !sqfifo_fuc[fcnx_int] && !sqfifo_uch[sffo_var+sqfifo_dcnt]) begin
              sqfifo_vld_next = 1'b1;
            end else if (sqfifo_fnd[fcnx_int] && (sqfifo_seq[sffo_var+sqfifo_dcnt]==sqfifo_fsq[fcnx_int])) begin
              sqfifo_vld_next = 1'b1;
            end
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (sqfifo_deq[fcnx_int] && (sqfifo_dsl[0]==(sffo_var+sqfifo_dcnt)))
              sqfifo_vld_next = 1'b0;
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (sqfifo_sdq[fcnx_int] && (sqfifo_ssl[0]==(sffo_var+sqfifo_dcnt)))
              sqfifo_prv_next = 1'b0;
          sqfifo_rdv_next = sqfifo_rdv[sffo_var+sqfifo_dcnt];
          sqfifo_inv_next = sqfifo_inv[sffo_var+sqfifo_dcnt];
          sqfifo_uch_next = sqfifo_uch[sffo_var+sqfifo_dcnt];
          sqfifo_uof_next = sqfifo_uof[sffo_var+sqfifo_dcnt];
          sqfifo_usz_next = sqfifo_usz[sffo_var+sqfifo_dcnt];
          sqfifo_idx_next = sqfifo_idx[sffo_var+sqfifo_dcnt];
          sqfifo_fil_next = sqfifo_fil[sffo_var+sqfifo_dcnt];
          sqfifo_seq_next = sqfifo_seq[sffo_var+sqfifo_dcnt];
          sqfifo_adr_next = sqfifo_adr[sffo_var+sqfifo_dcnt];
          sqfifo_bea_next = sqfifo_bea[sffo_var+sqfifo_dcnt];
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (sqfifo_fnd[fcnx_int] && (sqfifo_seq[sffo_var+sqfifo_dcnt]==sqfifo_fsq[fcnx_int])) begin
//              sqfifo_fil_next = !(&sqfifo_bea[sffo_var+sqfifo_dcnt] || (BITBEAT==0));
              sqfifo_bea_next = sqfifo_bea[sffo_var+sqfifo_dcnt] + 1;
            end
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (vprvld_nxt[fcnx_int] && (sqfifo_seq[sffo_var+sqfifo_dcnt]==vsqin_nxt[fcnx_int]) && !vucach_nxt[fcnx_int] && !sqfifo_uch[sffo_var+sqfifo_dcnt]) begin
              sqfifo_prv_next = sqfifo_sdq[0] || t3_block;
              sqfifo_fil_next = 1'b1;
              sqfifo_bea_next = 0;
            end
          if ((sffo_var==0) && sqfifo_idx[sffo_var+sqfifo_dcnt])
            sqfifo_vld_next = 1'b1;
        end else begin
          sqfifo_vld_next = sqfifo_vld[sffo_var];
          sqfifo_prv_next = sqfifo_prv[sffo_var];
          sqfifo_bbm_next = sqfifo_bbm[sffo_var];
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (sqfifo_fnd[fcnx_int] && (sqfifo_adr[sffo_var][BITADDR-1:BITBEAT]==sqfifo_fad[fcnx_int][BITADDR-1:BITBEAT]) && ((BITBEAT==0) || &sqfifo_fbe[fcnx_int] || |t3_attrA_wire[fcnx_int]) &&
                !sqfifo_fuc[fcnx_int] && !sqfifo_uch[sffo_var]) begin
              sqfifo_vld_next = !sqfifo_fil[sffo_var];
            end else if (sqfifo_fnd[fcnx_int] && (sqfifo_seq[sffo_var]==sqfifo_fsq[fcnx_int])) begin
              sqfifo_vld_next = !sqfifo_fil[sffo_var];
            end
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (sqfifo_deq[fcnx_int] && (sqfifo_dsl[0]==sffo_var))
              sqfifo_vld_next = 1'b0;
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (sqfifo_sdq[fcnx_int] && (sqfifo_ssl[0]==sffo_var))
              sqfifo_prv_next = 1'b0;
          sqfifo_rdv_next = sqfifo_rdv[sffo_var];
          sqfifo_inv_next = sqfifo_inv[sffo_var];
          sqfifo_uch_next = sqfifo_uch[sffo_var];
          sqfifo_uof_next = sqfifo_uof[sffo_var];
          sqfifo_usz_next = sqfifo_usz[sffo_var];
          sqfifo_idx_next = sqfifo_idx[sffo_var];
          sqfifo_fil_next = sqfifo_fil[sffo_var];
          sqfifo_seq_next = sqfifo_seq[sffo_var];
          sqfifo_adr_next = sqfifo_adr[sffo_var];
          sqfifo_bea_next = sqfifo_bea[sffo_var];
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (sqfifo_fnd[fcnx_int] && (sqfifo_seq[sffo_var]==sqfifo_fsq[fcnx_int])) begin
//              sqfifo_fil_next = !(&sqfifo_bea[sffo_var] || (BITBEAT==0));
              sqfifo_bea_next = sqfifo_bea[sffo_var] + 1;
            end
          for (fcnx_int=0; fcnx_int<NUMRWPT; fcnx_int=fcnx_int+1)
            if (vprvld_nxt[fcnx_int] && (sqfifo_seq[sffo_var]==vsqin_nxt[fcnx_int]) && !vucach_nxt[fcnx_int] && !sqfifo_uch[sffo_var]) begin
              sqfifo_prv_next = sqfifo_sdq[0] || t3_block;
              sqfifo_fil_next = 1'b1;
              sqfifo_bea_next = 0;
            end
        end

      always @(posedge clk) begin
        sqfifo_vld[sffo_var] <= sqfifo_vld_next;
        sqfifo_prv[sffo_var] <= sqfifo_prv_next;
        sqfifo_rdv[sffo_var] <= sqfifo_rdv_next;
        sqfifo_inv[sffo_var] <= sqfifo_inv_next;
        sqfifo_uch[sffo_var] <= sqfifo_uch_next;
        sqfifo_uof[sffo_var] <= sqfifo_uof_next;
        sqfifo_usz[sffo_var] <= sqfifo_usz_next;
        sqfifo_idx[sffo_var] <= sqfifo_idx_next;
        sqfifo_fil[sffo_var] <= sqfifo_fil_next;
        sqfifo_seq[sffo_var] <= sqfifo_seq_next;
        sqfifo_bea[sffo_var] <= sqfifo_bea_next;
        sqfifo_adr[sffo_var] <= sqfifo_adr_next;
        sqfifo_bbm[sffo_var] <= sqfifo_bbm_next;
      end
    end
  endgenerate

  integer vbea_int;
  always_comb
    for (vbea_int=0; vbea_int<NUMRWPT; vbea_int=vbea_int+1)
      vabea_out[vbea_int] = vaddr_out[vbea_int];

  reg l2uc_stall [0:NUMRWPT-1];

  integer sqfp_int, sqff_int, sqfx_int;
  always_comb
    for (sqfp_int=0; sqfp_int<NUMRWPT; sqfp_int=sqfp_int+1) begin
      sqfifo_deq[sqfp_int] = 1'b0;
      sqfifo_dsl[sqfp_int] = 0;
      for (sqff_int=FIFOCNT-1; sqff_int>=0; sqff_int=sqff_int-1) begin
        if ((sqff_int<sqfifo_cnt) && sqfifo_vld[sqff_int] && !vcirc_wire[0] && !l2uc_stall[0]) begin
          sqfifo_deq[sqfp_int] = 1'b1;
          sqfifo_dsl[sqfp_int] = sqff_int;
        end
      end
//      if (|sqfifo_cnt && sqfifo_inv[0] && sqfifo_idx[0] && !vcirc_wire[0] && !l2uc_stall[0]) begin
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
      sqfifo_fbe[sqfp_int] = 0;
      sqfifo_fbm[sqfp_int] = 0;
      for (sqff_int=FIFOCNT-1; sqff_int>=0; sqff_int=sqff_int-1)
        if ((sqff_int<sqfifo_cnt) && t3_vldA_wire[sqfp_int] && (sqfifo_seq[sqff_int]==t3_sqoutA_wire[sqfp_int])) begin
          sqfifo_fnd[sqfp_int] = 1'b1;
          sqfifo_fuc[sqfp_int] = sqfifo_uch[sqff_int];
          sqfifo_fsq[sqfp_int] = sqfifo_seq[sqff_int];
          sqfifo_fad[sqfp_int] = (BITBEAT==0) ? sqfifo_adr[sqff_int] : {sqfifo_adr[sqff_int][BITADDR-1:BITBEAT],sqfifo_bea[sqff_int]};
          sqfifo_fda[sqfp_int] = t3_doutA_wire[sqfp_int];
          sqfifo_fbe[sqfp_int] = sqfifo_fad[sqfp_int];
          sqfifo_fbm[sqfp_int] = sqfifo_bbm[sqff_int];
        end
      sqfifo_pop[sqfp_int] = 1'b0;
      sqfifo_psl[sqfp_int] = 0;
      sqfifo_psl_help[sqfp_int] = 0;
      for (sqff_int=FIFOCNT-1; sqff_int>=0; sqff_int=sqff_int-1) begin
        for (sqfx_int=0; sqfx_int<NUMRWPT; sqfx_int=sqfx_int+1)
          if ((sqff_int<sqfifo_cnt) && (sqfifo_seq[sqff_int]==vsqin_nxt[sqfx_int] && vsqpp_nxt[sqfx_int])) begin
            sqfifo_pop[sqfp_int] = 1'b1;
            sqfifo_psl[sqfp_int] = sqff_int;
            sqfifo_psl_help[sqfp_int] = sqfifo_seq[sqff_int];
          end
      end
      sqfifo_hit[sqfp_int] = 1'b0;
      sqfifo_htv[sqfp_int] = 1'b0;
      sqfifo_hsl[sqfp_int] = 0;
      sqfifo_help_seq[sqfp_int] = 0;
      for (sqff_int=0; sqff_int<NUMRWPT; sqff_int=sqff_int+1)
        if (vprvld_nxt[sqff_int] && (vaddr_nxt[sqff_int][BITADDR-1:BITBEAT]==vaddr_out[sqfp_int][BITADDR-1:BITBEAT]) && !vucach_nxt[sqff_int] && !vucach_out[sqfp_int]) begin
          sqfifo_hit[sqfp_int] = 1'b1;
          sqfifo_htv[sqfp_int] = 1'b0;
          sqfifo_hsl[sqfp_int] = 1;
        end
      for (sqff_int=0; sqff_int<NUMRWPT; sqff_int=sqff_int+1)
        if (vsqwr_nxt[sqff_int] && (vaddr_nxt[sqff_int][BITADDR-1:BITBEAT]==vaddr_out[sqfp_int][BITADDR-1:BITBEAT]) && vfill_nxt[sqff_int] && !vucach_nxt[sqff_int] && !vucach_out[sqfp_int]) begin
          sqfifo_hit[sqfp_int] = 1'b1;
//          sqfifo_htv[sqfp_int] = vsqvld_nxt[sqff_int];
          sqfifo_htv[sqfp_int] = 1'b0;
          sqfifo_hsl[sqfp_int] = 2;
        end
      for (sqff_int=FIFOCNT-1; sqff_int>=0; sqff_int=sqff_int-1)
        if ((sqff_int<sqfifo_cnt) && (sqfifo_adr[sqff_int][BITADDR-1:BITBEAT]==vaddr_out[sqfp_int][BITADDR-1:BITBEAT]) && !sqfifo_uch[sqff_int] && !srdwr_out[sqfp_int] && !vucach_out[sqfp_int] &&
            !(vsqpp_nxt[sqfp_int] && (sqfifo_seq[sqff_int]==vsqin_nxt[sqfp_int]))) begin
          sqfifo_hit[sqfp_int] = 1'b1;
          sqfifo_htv[sqfp_int] = sqfifo_vld[sqff_int];
          sqfifo_hsl[sqfp_int] = 4;
          sqfifo_help_seq[sqfp_int] = sqfifo_seq[sqff_int];
        end
      for (sqff_int=FIFOCNT-1; sqff_int>=0; sqff_int=sqff_int-1)
        if ((sqff_int<sqfifo_cnt) && (sqfifo_adr[sqff_int][BITADDR-1:BITBEAT]==vaddr_out[sqfp_int][BITADDR-1:BITBEAT]) && sqfifo_fil[sqff_int] && !sqfifo_uch[sqff_int] && !vucach_out[sqfp_int] &&
            !(vsqpp_nxt[sqfp_int] && (sqfifo_seq[sqff_int]==vsqin_nxt[sqfp_int]))) begin
          sqfifo_hit[sqfp_int] = 1'b1;
//          sqfifo_htv[sqfp_int] = sqfifo_fil[sqff_int] && ((BITBEAT==0) || (vabea_out[sqfp_int]<sqfifo_bea[sqff_int]));
          sqfifo_htv[sqfp_int] = 1'b0;
          sqfifo_hsl[sqfp_int] = 5;
        end
      for (sqff_int=0; sqff_int<NUMRWPT; sqff_int=sqff_int+1)
        if (sqfifo_fnd[sqff_int] && (sqfifo_fad[sqff_int][BITADDR-1:BITBEAT]==vaddr_out[sqfp_int][BITADDR-1:BITBEAT]) && ((BITBEAT==0) || &sqfifo_fbe[sqff_int] || |t3_attrA_wire[sqff_int]) &&
            !sqfifo_fuc[sqff_int] && !vucach_out[sqfp_int]) begin
          sqfifo_hit[sqfp_int] = 1'b1;
          sqfifo_htv[sqfp_int] = 1'b1;
          sqfifo_hsl[sqfp_int] = 6;
        end
      if (!srdwr_out[sqfp_int] && vinvld_out[sqfp_int] && vsidx_out[sqfp_int]) begin
        sqfifo_hit[sqfp_int] = 1'b1;
        sqfifo_htv[sqfp_int] = 1'b0;
        sqfifo_hsl[sqfp_int] = 7;
      end
   end

  wire [BITBEAT-1:0] sqfifo_fbe_nxt = sqfifo_fbe[0] + 1;
  always @(posedge clk)
    for (integer i=0;i<NUMRWPT;i++)
      if (rst)
        l2uc_stall[i] <= 1'b0;
      else if (BITBEAT==0)
        l2uc_stall[i] <= 1'b0;
      else if (sqfifo_fnd[i] && sqfifo_fuc[i])
        l2uc_stall[i] <= !(&sqfifo_fbe[0] || !sqfifo_fbm[0][sqfifo_fbe_nxt] || (|t3_attrA_wire[0]));

  integer srcp_int, srcf_int;
  always_comb
    for (srcp_int=0; srcp_int<NUMRWPT; srcp_int=srcp_int+1) begin
      sread_wire[srcp_int] = sqfifo_deq[srcp_int] && sqfifo_rdv[sqfifo_dsl[srcp_int]];
      sinvld_wire[srcp_int] = sqfifo_deq[srcp_int] && sqfifo_inv[sqfifo_dsl[srcp_int]];
      sucach_wire[srcp_int] = sqfifo_deq[srcp_int] && sqfifo_uch[sqfifo_dsl[srcp_int]];
      sucofst_wire[srcp_int] = sqfifo_uof[sqfifo_dsl[srcp_int]];
      sucsize_wire[srcp_int] = sqfifo_usz[sqfifo_dsl[srcp_int]];
      ssidx_wire[srcp_int] = sqfifo_idx[sqfifo_dsl[srcp_int]];
      sfill_wire[srcp_int] = sqfifo_fil[sqfifo_dsl[srcp_int]];
      ssqin_wire[srcp_int] = sqfifo_seq[sqfifo_dsl[srcp_int]];
      saddr_wire[srcp_int] = sqfifo_adr[sqfifo_dsl[srcp_int]];
      sbeat_wire[srcp_int] = sqfifo_bea[sqfifo_dsl[srcp_int]];
      sdin_wire[srcp_int] = sqfifo_fda[srcp_int];
      sbbmp_wire[srcp_int] = sqfifo_bbm[sqfifo_dsl[srcp_int]];
      sserr_wire[srcp_int] = sfill_wire[srcp_int] ? t3_attrA_wire[srcp_int] : 0;
    end

  reg  mem_serr;
  wire mem_serr_wire;

  reg               vread_vld_wire [0:NUMRWPT-1];
  reg               vread_hit_wire [0:NUMRWPT-1];
  reg               vread_serr_wire [0:NUMRWPT-1];
  reg               vread_last_wire [0:NUMRWPT-1];
  reg [BITSEQN-1:0] vsqout_wire [0:NUMRWPT-1];
  reg [WIDTH-1:0]   vdout_wire [0:NUMRWPT-1];
  reg [BITXATR-1:0] vattr_wire [0:NUMRWPT-1];
  integer vdor_int, vdob_int;
  always_comb
    for (vdor_int=0; vdor_int<NUMRWPT; vdor_int=vdor_int+1) begin
      vread_vld_wire[vdor_int]  = (vread_out[vdor_int] && !vucach_out[vdor_int] && !vfill_out[vdor_int] && !sqfifo_hit[vdor_int] && cache_hit[vdor_int]) ||
                                  (vread_out[vdor_int] && (BITBEAT==0) && vfill_out[vdor_int]) ||
                                  (vread_out[vdor_int] && srdwr_out[vdor_int] && vucach_out[vdor_int]) ||
                                  ((vinvld_out[vdor_int] || vread_out[vdor_int]) && !vucach_out[vdor_int] && !srdwr_out[vdor_int] && (tg_serr[vdor_int] || dt_serr[vdor_int])) || // e first time, mem err, one beat
                                  (vread_out[vdor_int] && |vserr_out[vdor_int]) ||                                                                                                // e fill, l2 err terminate, one beat
                                  ((vread_out[vdor_int] || vinvld_out[vdor_int]) && !vucach_out[vdor_int] && srdwr_out[vdor_int] && !vfill_out[vdor_int] && tg_serr[vdor_int]) || // e replay, tag error, is last beat
                                  (vinvld_out[vdor_int] && !sqfifo_hit[vdor_int]);
      vread_serr_wire[vdor_int] = (!vucach_out[vdor_int] && (BITBEAT==0) && (tg_serr[vdor_int] || dt_serr[vdor_int])) || 
                                  ((vinvld_out[vdor_int] || vread_out[vdor_int]) && !vucach_out[vdor_int] && !srdwr_out[vdor_int] && !cache_hit[vdor_int] && (tg_serr[vdor_int] || dt_serr[vdor_int])) ||  // e first time, miss, mem err, one beat
                                                                                                                                               // l2 error sent throguh vattr_wire // e fill, l2 err terminate, one beat 
                                  ((vread_out[vdor_int] || vinvld_out[vdor_int]) && !vucach_out[vdor_int] && srdwr_out[vdor_int] && !vfill_out[vdor_int] && !cache_hit[vdor_int] && tg_serr[vdor_int]) || // e replay, tag error, is last beat
                                  (!vucach_out[vdor_int] && ((BITBEAT!=0) && (&vabea_out[0]) || !vbbmp_out[0][vbeat_tmp[0]]) && mem_serr_wire);  // e replay OR first time hit, error on last beat
      vread_last_wire[vdor_int] = (vucach_out[vdor_int] ? &vbeat_out[0] : &vabea_out[0]) || !vbbmp_out[0][vbeat_tmp[0]] || (BITBEAT==0) ||
                                  ((vinvld_out[vdor_int] || vread_out[vdor_int]) && !vucach_out[vdor_int] && !srdwr_out[vdor_int] && !cache_hit[vdor_int] && (tg_serr[vdor_int] || dt_serr[vdor_int])) || // e first time, miss, mem err, one beat
                                  (vread_out[vdor_int] && |vserr_out[vdor_int]) ||                                                                                                // e fill, l2 err terminate, one beat
                                  ((vread_out[vdor_int] || vinvld_out[vdor_int]) && !vucach_out[vdor_int] && srdwr_out[vdor_int] && !vfill_out[vdor_int] && !cache_hit[vdor_int] && tg_serr[vdor_int]);   // e replay, tag error, is last beat
      vsqout_wire[vdor_int] = vsqin_out[vdor_int];
      vdout_wire[vdor_int] = vdin_out[vdor_int];
      vattr_wire[vdor_int] = vserr_out[vdor_int];
      vread_hit_wire[vdor_int]  = !srdwr_out[vdor_int] && cache_hit[vdor_int];
      if (vread_out[vdor_int] && cache_hit[vdor_int] && !vucach_out[vdor_int])
        vdout_wire[vdor_int] = ddat_out[vdor_int][cache_map[vdor_int]];
    end

// wire last_beat = (!vucach_out[0] && &vabea_out[0]) || !vbbmp_out[0][vbeat_tmp[0]] || (BITBEAT==0) ||
//   ((vinvld_out[0] || vread_out[0]) && !vucach_out[0] && !srdwr_out[0] && !cache_hit[0] && (tg_serr[0] || dt_serr[0])) || // e first time, miss, mem err, one beat
//   (vread_out[0] && |vserr_out[0]) ||                                                                                     // e fill, l2 err terminate, one beat
//   ((vread_out[0] || vinvld_out[0]) && !vucach_out[0] && srdwr_out[0] && !vfill_out[0] && !cache_hit[0] && tg_serr[0]);   // e replay, tag error, is last beat

  assign mem_serr_wire = mem_serr || (dt_serr || tg_serr);
  wire last_beat = vread_last_wire[0];
  always @(posedge clk)
    if (rst)
      mem_serr <= 1'b0;
    else if (last_beat)
      mem_serr <= 1'b0;
    else if (!last_beat && vread_out[0] && !vfill_out[0])
      mem_serr <= mem_serr_wire;

  reg [NUMRWPT-1:0]         vread_vld_tmp;
  reg [NUMRWPT-1:0]         vread_hit_tmp;
  reg [NUMRWPT-1:0]         vread_serr_tmp;
  reg [NUMRWPT-1:0]         vread_last_tmp;
  reg [NUMRWPT*BITSEQN-1:0] vsqout_tmp;
  reg [NUMRWPT*WIDTH-1:0]   vdout_tmp;
  reg [NUMRWPT*BITXATR-1:0] vattr_tmp;
  integer vbus_int;
  always_comb begin
    vread_vld_tmp = 0;
    vread_hit_tmp = 0;
    vread_serr_tmp = 0;
    vread_last_tmp = 0;
    vsqout_tmp = 0;
    vdout_tmp = 0;
    vattr_tmp = 0;
    for (vbus_int=0; vbus_int<NUMRWPT; vbus_int=vbus_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_vld_wire[vbus_int] << vbus_int);
      vread_hit_tmp = vread_hit_tmp | (vread_hit_wire[vbus_int] << vbus_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vbus_int] << vbus_int);
      vread_last_tmp = vread_last_tmp | (vread_last_wire[vbus_int] << vbus_int);
      vsqout_tmp = vsqout_tmp | (vsqout_wire[vbus_int] << (vbus_int*BITSEQN));
      vdout_tmp = vdout_tmp | (vdout_wire[vbus_int] << (vbus_int*WIDTH));
      vattr_tmp = vattr_tmp | (vattr_wire[vbus_int] << (vbus_int*BITXATR));
    end
  end
  
  reg [NUMRWPT-1:0]         vread_vld;
  reg [NUMRWPT-1:0]         vread_hit;
  reg [NUMRWPT-1:0]         vread_serr;
  reg [NUMRWPT-1:0]         vread_last;
  reg [NUMRWPT*BITSEQN-1:0] vsqout;
  reg [NUMRWPT*WIDTH-1:0]   vdout;
  reg [NUMRWPT*BITXATR-1:0] vattr;
  generate if (FLOPOUT) begin: flpo_loop
    always @(posedge clk) begin
      vread_vld <= vread_vld_tmp;
      vread_hit <= vread_hit_tmp;
      vread_serr <= vread_serr_tmp;
      vread_last <= vread_last_tmp;
      vsqout <= vsqout_tmp; 
      vdout <= vdout_tmp; 
      vattr <= vattr_tmp; 
    end
  end else begin: nflpo_loop
    always_comb begin
      vread_vld = vread_vld_tmp;
      vread_hit = vread_hit_tmp;
      vread_serr = vread_serr_tmp;
      vread_last = vread_last_tmp;
      vsqout = vsqout_tmp;
      vdout = vdout_tmp;
      vattr = vattr_tmp;
    end
  end
  endgenerate

  assign pf_stall = sqfifo_deq[0] || vcirc_wire[0] || l2uc_stall[0];
  assign t3_stall = vcirc_wire[0];

  reg [NUMRWPT-1:0]                 t1_writeA;
  reg [NUMRWPT*BITVTAG-1:0]         t1_addrA;
  reg [NUMRWPT*NUMWRDS*BITTAGW-1:0] t1_dinA;
  integer t1w_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (t1w_int=0; t1w_int<NUMRWPT; t1w_int=t1w_int+1)
      if (twrite_wire[t1w_int]) begin
        t1_writeA = t1_writeA | (1'b1 << t1w_int);
        t1_addrA  = t1_addrA | (twraddr_wire[t1w_int] <<  (t1w_int*BITVTAG));
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
    t3_sqinA = 0;
    t3_addrA = 0;
    t3_dinA = 0;
    for (t3w_int=0; t3w_int<NUMRWPT; t3w_int=t3w_int+1) begin
      if (sqfifo_sdq[0]) begin
        t3_readA   = t3_readA   | (1'b1 << t3w_int);
        t3_ucachA  = t3_ucachA  | (sqfifo_uch[sqfifo_ssl[0]] << t3w_int);
        t3_ucofstA = t3_ucofstA | (sqfifo_uof[sqfifo_ssl[0]] << (t3w_int*BITUOFS));
        t3_ucsizeA = t3_ucsizeA | (sqfifo_usz[sqfifo_ssl[0]] << (t3w_int*BITUSIZ));
        t3_sqinA   = t3_sqinA   | (sqfifo_seq[sqfifo_ssl[0]] << (t3w_int*BITSEQN));
        t3_addrA   = t3_addrA   | (sqfifo_adr[sqfifo_ssl[0]] << (t3w_int*BITADDR));
      end else if (vprvld_nxt[t3w_int] && !t3_block) begin
        t3_readA   = t3_readA   | (1'b1 << t3w_int);
        t3_ucachA  = t3_ucachA  | (vucach_nxt[t3w_int]  << t3w_int);
        t3_ucofstA = t3_ucofstA | (vucofst_nxt[t3w_int] << (t3w_int*BITUOFS));
        t3_ucsizeA = t3_ucsizeA | (vucsize_nxt[t3w_int] << (t3w_int*BITUSIZ));
        t3_sqinA   = t3_sqinA   | (vsqin_nxt[t3w_int]   << (t3w_int*BITSEQN));
        t3_addrA   = t3_addrA   | (vaddr_nxt[t3w_int]   << (t3w_int*BITADDR));
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

  reg [BITVTAG-1:0] tg_addr;
  reg [BITVROW-1:0] dt_addr;
  always @(posedge clk) begin
    tg_addr <= t1_addrB;
    dt_addr <= t2_addrB;
  end

  reg e_pf_empty;
  reg e_pf_oflw;
  reg e_uc_stall;
  always @(posedge clk) begin
    e_pf_empty <= (sqfifo_cnt == 0);
    e_pf_oflw <= (sqfifo_cnt > FIFOCNT);
    e_uc_stall <= l2uc_stall[0];
  end

  reg e_cache_rd_hit;
  always @(posedge clk)
    e_cache_rd_hit <=  vread_hit_wire[0] && vread_vld_wire[0] && vread_last_wire[0] && vread_out[0];

  reg                e_tgerr_vld;
  reg                e_dterr_vld;
  reg  [BITTGBY-1:0] e_tgerr_bid;
  reg  [BITDTBY-1:0] e_dterr_bid;
  reg  [BITVTAG-1:0] e_tgerr_idx;
  reg  [BITVROW-1:0] e_dterr_idx;
  always @(posedge clk) begin
    e_tgerr_vld <= tg_serr[0]; 
    e_dterr_vld <= dt_serr[0]; 
    e_tgerr_bid <= t1_bidB[BITTGBY-1:0];
    e_dterr_bid <= t2_bidB[BITDTBY-1:0];
    e_tgerr_idx <= tg_addr[BITVTAG-1:0];
    e_dterr_idx <= dt_addr[BITVROW-1:0];
  end

  wire [BITSEQN-1:0] sqfifo_dsq_help = sqfifo_seq[sqfifo_dsl[0]];

  assign dbg_la_sqfifo_cnt = sqfifo_cnt ;
  assign dbg_la_t3_readA = t3_readA ;
  assign dbg_la_t3_writeA = t3_writeA  ;
  assign dbg_la_t3_ucachA = t3_ucachA ;
  assign dbg_la_t3_ucofstA = t3_ucofstA ;
  assign dbg_la_t3_ucsizeA = t3_ucsizeA ;
  assign dbg_la_t3_sqinA = t3_sqinA ;
  assign dbg_la_t3_addrA = t3_addrA ;


  assign dbg_la_pf_stall = pf_stall;
  assign dbg_la_t3_stall = t3_stall;
  assign dbg_la_t3_block = t3_block;
  assign dbg_la_l2uc_stall = l2uc_stall[0];
  assign dbg_la_vread = vread;
  assign dbg_la_vinvld = vinvld;
  assign dbg_la_vucach = vucach;
  assign dbg_la_vread_vld = vread_vld;
  assign dbg_la_vread_hit = vread_hit;
  assign dbg_la_vread_last= vread_last;
  assign dbg_la_sqfifo_fbe = sqfifo_fbe [0];
  assign dbg_la_sqfifo_fbm = sqfifo_fbm [0];
  assign dbg_la_t3_attrA_wire = t3_attrA_wire[0];
  assign dbg_la_sqfifo_fnd = sqfifo_fnd[0];
  assign dbg_la_sqfifo_fuc = sqfifo_fuc[0];
  assign dbg_la_sqfifo_fsq = sqfifo_fsq[0];
  assign dbg_la_sqfifo_deq = sqfifo_deq[0];
  assign dbg_la_sqfifo_dsl = sqfifo_dsl[0];
  assign dbg_la_sqfifo_pop = sqfifo_pop[0];
  assign dbg_la_sqfifo_psl = sqfifo_psl[0];
  assign dbg_la_sqfifo_sdq = sqfifo_sdq[0];
  assign dbg_la_sqfifo_ssl = sqfifo_ssl[0];
  assign dbg_la_sqfifo_psl_help = sqfifo_psl_help[0]; 
  assign dbg_la_sqfifo_dsq_help = sqfifo_dsq_help;

  assign dbg_la_twrite_wire = twrite_wire[0];
  assign dbg_la_twraddr_wire = twraddr_wire[0];
  assign dbg_la_dwrite_wire = dwrite_wire[0];
  assign dbg_la_dwraddr_wire = dwraddr_wire[0];
  assign dbg_la_data_vld     = data_vld [0][SRAM_DELAY-1];
  assign dbg_la_dtag_vld     = dtag_vld [0][SRAM_DELAY-1];
  assign dbg_la_tg_rd_vld = tg_rd_vld;
  assign dbg_la_dt_rd_vld = dt_rd_vld;
  assign dbg_la_vread_out = vread_out[0]; 
  assign dbg_la_vucach_out = vucach_out[0];
  assign dbg_la_vwrite_out = 1'b0;
  assign dbg_la_vflush_out = 1'b0;
  assign dbg_la_vfill_out = vfill_out[0];
  assign dbg_la_srdwr_out = srdwr_out[0];
  assign dbg_la_vinvld_out = vinvld_out[0];
  assign dbg_la_sqfifo_hit = sqfifo_hit[0];
  assign dbg_la_sqfifo_htv = sqfifo_htv[0];
  assign dbg_la_cache_hit  = cache_hit[0];
  assign dbg_la_cache_map  = cache_map[0];
  assign dbg_la_cache_add  = cache_add[0];
  assign dbg_la_cache_evt  = cache_evt[0];
  assign dbg_la_cache_emp  = cache_emp[0];
  assign dbg_la_cache_drt  = cache_drt[0];

  genvar xf_var;
  generate for (xf_var=0; xf_var<FIFOCNT; xf_var++) begin : xf_loop
    assign dbg_la_sqfifo_vld[xf_var] = sqfifo_vld[xf_var];
    assign dbg_la_sqfifo_prv[xf_var] = sqfifo_prv[xf_var];
    assign dbg_la_sqfifo_rdv[xf_var] = sqfifo_rdv[xf_var];
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

  // synopsys translate_off
  reg                  dbg_rd_lru [0:NUMWRDS-1];
  reg                  dbg_rd_vld [0:NUMWRDS-1];
  reg                  dbg_rd_dty [0:NUMWRDS-1];
  reg  [BITADDR-1:0]   dbg_rd_tag [0:NUMWRDS-1];
  reg  [BITADDR+5-1:0] dbg_rd_adr [0:NUMWRDS-1];
  reg  [WIDTH-1:0]     dbg_rd_dat [0:NUMWRDS-1];
  always_comb begin
    for (integer i=0; i<NUMWRDS; i++) begin
      dbg_rd_vld[i] = t1_doutB >> ((i*BITTAGW)+BITDTAG+BITWRDS+1);
      dbg_rd_dty[i] = t1_doutB >> ((i*BITTAGW)+BITDTAG+BITWRDS);
      dbg_rd_lru[i] = t1_doutB >> ((i*BITTAGW)+BITDTAG);
      dbg_rd_tag[i] = t1_doutB >>  (i*BITTAGW);
      dbg_rd_adr[i] = (t1_doutB >>  (i*BITTAGW)) << 5;
      dbg_rd_dat[i] = t2_doutB >>  (i*WIDTH);
    end
  end
  // synopsys translate_on

endmodule // core_nrw_cache_1r1w_mb2

