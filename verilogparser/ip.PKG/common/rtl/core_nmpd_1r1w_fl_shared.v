
module core_nmpd_1r1w_fl_shared (vmalloc, vma_bp, vma_vld, vma_addr, vma_fwrd, vma_serr, vma_derr, vma_padr,
                                    // vwrite, vwraddr,
                                     vdeq, vdqaddr,
                                     vcpread, vcpwrite, vcpdin, vcpaddr, vcpread_vld, vcpread_dout,
                                     pwrite, pwrbadr, pwrradr, 
                                     t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB,
                                     bp_thr, bp_hys, grpmt, grpmsk, grpcnt, grpbp, ena_rand,
                                     ready, clk, rst);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMMAPT = 16;
  parameter NUMDQPT = 8;
  parameter NUMEGPT = 8;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter FLOPCMD = 0;

  parameter NUMSBFL = SRAM_DELAY+1;
  parameter NUMARPT = 16;
  parameter NUMARSTAGE = 4;
  parameter NUMFPAD = 4;
  parameter NUMSTP2 = 6;

  parameter BITCPAD = 2+3+5;
  parameter CPUWDTH = 54;

  input [NUMMAPT-1:0]                      vmalloc;
  output [NUMMAPT-1:0]                     vma_bp;
  output [NUMMAPT-1:0]                     vma_vld;
  output [NUMMAPT*BITADDR-1:0]             vma_addr;
  output [NUMMAPT-1:0]                     vma_fwrd;
  output [NUMMAPT-1:0]                     vma_serr;
  output [NUMMAPT-1:0]                     vma_derr;
  output [NUMMAPT*(BITVROW+1)-1:0]         vma_padr;

  output [(NUMMAPT)-1:0]           pwrite;
  output [((NUMMAPT)*BITVBNK)-1:0] pwrbadr;
  output [((NUMMAPT)*BITVROW)-1:0] pwrradr;

  input [NUMDQPT-1:0]                      vdeq;
  input [NUMDQPT*BITADDR-1:0]              vdqaddr;

  input                                    vcpread;
  input                                    vcpwrite;
  input [BITCPAD-1:0]                      vcpaddr;
  input [CPUWDTH-1:0]                      vcpdin;
  output                                   vcpread_vld;
  output [CPUWDTH-1:0]                     vcpread_dout;

  output [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0]             t2_writeA;
  output [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0]     t2_addrA;
  output [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0]     t2_dinA;

  output [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0]             t2_readB;
  output [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0]     t2_addrB;
  input [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0]      t2_doutB;
  input [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0]              t2_fwrdB;
  input [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0]              t2_serrB;
  input [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0]              t2_derrB;
  input [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0]      t2_padrB;

  input [BITVROW:0]                        bp_thr;
  input [BITVROW:0]                        bp_hys;

  input [NUMMAPT*NUMVBNK-1:0]              grpmsk;
  input [NUMMAPT*NUMVBNK-1:0]              grpbp;
  input [NUMMAPT*(BITVBNK+1)-1:0]          grpcnt;
  output [NUMVBNK-1:0]                     grpmt;
  input                                    ena_rand;

  output                                   ready;
  input                                    clk;
  input                                    rst;

  reg [BITVROW:0] rstaddr;
  wire rstvld = (rstaddr != NUMVROW-NUMSBFL);
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg ready_int;
  always @(posedge clk)
    ready_int <= !rstvld;

  wire               vmalloc_wire [0:NUMMAPT-1];
  wire               vdeq_wire [0:NUMDQPT-1];
  wire [BITADDR-1:0] vdqaddr_wire [0:NUMDQPT-1];
  wire [BITVBNK-1:0] vdqbadr_wire [0:NUMDQPT-1];
  wire [BITVROW-1:0] vdqradr_wire [0:NUMDQPT-1];
  wire               vcpread_wire;
  wire               vcpwrite_wire;
  wire [BITCPAD-1:0] vcpaddr_wire;
  wire [CPUWDTH-1:0] vcpdin_wire;
  wire               ena_rand_wire;
  wire [BITVROW:0]   bp_thr_wire;
  wire [BITVROW:0]   bp_hys_wire;
  wire [NUMVBNK-1:0] grpmsk_wire [0:NUMMAPT-1];
  wire [NUMVBNK-1:0] grpbp_wire [0:NUMMAPT-1];
  wire [BITVBNK:0]   grpcnt_wire [0:NUMMAPT-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg [0:FLOPIN-1];
    reg [NUMMAPT-1:0] vmalloc_reg [0:FLOPIN-1];
    reg [NUMDQPT-1:0] vdeq_reg [0:FLOPIN-1];
    reg [NUMDQPT*BITADDR-1:0] vdqaddr_reg [0:FLOPIN-1];
    reg vcpread_reg [0:FLOPIN-1];
    reg vcpwrite_reg [0:FLOPIN-1];
    reg [BITCPAD-1:0] vcpaddr_reg [0:FLOPIN-1];
    reg [CPUWDTH-1:0] vcpdin_reg [0:FLOPIN-1];
    reg ena_rand_reg [0:FLOPIN-1];
    reg [BITVROW:0] bp_thr_reg [0:FLOPIN-1];
    reg [BITVROW:0] bp_hys_reg [0:FLOPIN-1];
    reg [NUMMAPT*NUMVBNK-1:0] grpmsk_reg [0:FLOPIN-1];
    reg [NUMMAPT*NUMVBNK-1:0] grpbp_reg [0:FLOPIN-1];
    reg [NUMMAPT*(BITVBNK+1)-1:0] grpcnt_reg [0:FLOPIN-1];
    integer flpi_int;
    always @(posedge clk)
      for (flpi_int=0; flpi_int<FLOPIN; flpi_int=flpi_int+1)
        if (flpi_int>0) begin
          ready_reg[flpi_int] <= ready_reg[flpi_int-1];
          vmalloc_reg[flpi_int] <= vmalloc_reg[flpi_int-1];
          vdeq_reg[flpi_int] <= vdeq_reg[flpi_int-1];
          vdqaddr_reg[flpi_int] <= vdqaddr_reg[flpi_int-1];
          vcpread_reg[flpi_int] <= vcpread_reg[flpi_int-1];
          vcpwrite_reg[flpi_int] <= vcpwrite_reg[flpi_int-1];
          vcpaddr_reg[flpi_int] <= vcpaddr_reg[flpi_int-1];
          vcpdin_reg[flpi_int] <= vcpdin_reg[flpi_int-1];
          ena_rand_reg[flpi_int] <= ena_rand_reg[flpi_int-1];
          bp_thr_reg[flpi_int] <= bp_thr_reg[flpi_int-1];
          bp_hys_reg[flpi_int] <= bp_hys_reg[flpi_int-1];
          grpmsk_reg[flpi_int] <= grpmsk_reg[flpi_int-1];
          grpbp_reg[flpi_int] <= grpbp_reg[flpi_int-1];
          grpcnt_reg[flpi_int] <= grpcnt_reg[flpi_int-1];
        end else begin
          ready_reg[flpi_int] <= ready;
          vmalloc_reg[flpi_int] <= vmalloc;
          vdeq_reg[flpi_int] <= vdeq;
          vdqaddr_reg[flpi_int] <= vdqaddr;
          vcpread_reg[flpi_int] <= vcpread;
          vcpwrite_reg[flpi_int] <= vcpwrite;
          vcpaddr_reg[flpi_int] <= vcpaddr;
          vcpdin_reg[flpi_int] <= vcpdin;
          ena_rand_reg[flpi_int] <= ena_rand;
          bp_thr_reg[flpi_int] <= bp_thr;
          bp_hys_reg[flpi_int] <= bp_hys;
          grpmsk_reg[flpi_int] <= grpmsk;
          grpbp_reg[flpi_int] <= grpbp;
          grpcnt_reg[flpi_int] <= grpcnt;
        end

    for (np2_var=0; np2_var<NUMMAPT; np2_var=np2_var+1) begin: ma_loop
      assign vmalloc_wire[np2_var] = (vmalloc_reg[FLOPIN-1] & {NUMMAPT{ready_reg[FLOPIN-1]}}) >> np2_var;
      assign grpmsk_wire[np2_var] = grpmsk_reg[FLOPIN-1] >> (np2_var*NUMVBNK);
      assign grpbp_wire[np2_var] = grpbp_reg[FLOPIN-1] >> (np2_var*NUMVBNK);
      assign grpcnt_wire[np2_var] = grpcnt_reg[FLOPIN-1] >> (np2_var*(BITVBNK+1));
    end
    for (np2_var=0; np2_var<NUMDQPT; np2_var=np2_var+1) begin: dq_loop
      assign vdeq_wire[np2_var] = (vdeq_reg[FLOPIN-1] & {NUMDQPT{ready_reg[FLOPIN-1]}}) >> np2_var;
      assign vdqaddr_wire[np2_var] = vdqaddr_reg[FLOPIN-1] >> (np2_var*BITADDR);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        dq_adr_inst (.vbadr(vdqbadr_wire[np2_var]), .vradr(vdqradr_wire[np2_var]), .vaddr(vdqaddr_wire[np2_var]));
    end
    assign vcpread_wire = vcpread_reg[FLOPIN-1];
    assign vcpwrite_wire = vcpwrite_reg[FLOPIN-1];
    assign vcpaddr_wire = vcpaddr_reg[FLOPIN-1];
    assign vcpdin_wire = vcpdin_reg[FLOPIN-1];
    assign ena_rand_wire = ena_rand_reg[FLOPIN-1];
    assign bp_thr_wire = bp_thr_reg[FLOPIN-1];
    assign bp_hys_wire = bp_hys_reg[FLOPIN-1];
  end else begin: noflpi_loop
    for (np2_var=0; np2_var<NUMMAPT; np2_var=np2_var+1) begin: ma_loop
      assign vmalloc_wire[np2_var] = (vmalloc & {NUMMAPT{ready_int}}) >> np2_var;
      assign grpmsk_wire[np2_var] = grpmsk >> (np2_var*NUMVBNK);
      assign grpbp_wire[np2_var] = grpbp >> (np2_var*NUMVBNK);
      assign grpcnt_wire[np2_var] = grpcnt >> (np2_var*(BITVBNK+1));
    end
    for (np2_var=0; np2_var<NUMDQPT; np2_var=np2_var+1) begin: dq_loop
      assign vdeq_wire[np2_var] = (vdeq & {NUMDQPT{ready_int}}) >> np2_var;
      assign vdqaddr_wire[np2_var] = vdqaddr >> (np2_var*BITADDR);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        dq_adr_inst (.vbadr(vdqbadr_wire[np2_var]), .vradr(vdqradr_wire[np2_var]), .vaddr(vdqaddr_wire[np2_var]));
    end
    assign vcpread_wire = vcpread;
    assign vcpwrite_wire = vcpwrite;
    assign vcpaddr_wire = vcpaddr;
    assign vcpdin_wire = vcpdin;
    assign ena_rand_wire = ena_rand;
    assign bp_thr_wire = bp_thr;
    assign bp_hys_wire = bp_hys;
  end
  endgenerate

  reg                vdeq_reg [0:NUMDQPT-1][0:1-1];
  reg [BITVBNK-1:0]  vdqbadr_reg [0:NUMDQPT-1][0:1-1];
  reg [BITVROW-1:0]  vdqradr_reg [0:NUMDQPT-1][0:1-1];
  integer vprt_int, vdel_int; 
  always @(posedge clk) begin
    for (vdel_int=0; vdel_int<1; vdel_int=vdel_int+1)
      for (vprt_int=0; vprt_int<NUMDQPT; vprt_int=vprt_int+1)
        if (vdel_int > 0) begin
          vdeq_reg[vprt_int][vdel_int] <= vdeq_reg[vprt_int][vdel_int-1];
          vdqbadr_reg[vprt_int][vdel_int] <= vdqbadr_reg[vprt_int][vdel_int-1];
          vdqradr_reg[vprt_int][vdel_int] <= vdqradr_reg[vprt_int][vdel_int-1];
        end else begin
          vdeq_reg[vprt_int][vdel_int] <= vdeq_wire[vprt_int];
          vdqbadr_reg[vprt_int][vdel_int] <= vdqbadr_wire[vprt_int];
          vdqradr_reg[vprt_int][vdel_int] <= vdqradr_wire[vprt_int];
        end
  end
     
  reg               vdeq_out [0:NUMDQPT-1];
  reg [BITVBNK-1:0] vdqbadr_out [0:NUMDQPT-1];
  reg [BITVROW-1:0] vdqradr_out [0:NUMDQPT-1];
  integer prto_int;
  always_comb begin
    for (prto_int=0; prto_int<NUMDQPT; prto_int=prto_int+1) begin
      vdeq_out[prto_int] = vdeq_reg[prto_int][0];
      vdqbadr_out[prto_int] = vdqbadr_reg[prto_int][0];
      vdqradr_out[prto_int] = vdqradr_reg[prto_int][0];
    end
  end

  reg pwrite_wire [0:NUMMAPT-1];
  reg [BITVBNK-1:0] pwrbadr_wire [0:NUMMAPT-1];
  reg [BITVROW-1:0] pwrradr_wire [0:NUMMAPT-1];

  reg swrite_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];
  reg [BITVROW-1:0] swrradr_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];
  reg [BITVROW-1:0] sdin_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];

  reg sread_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];
  reg [BITVROW-1:0] srdradr_wire [0:NUMVBNK-1][0:(NUMDQPT/NUMEGPT)-1];
/*
  reg [NUMVBNK-1:0] grpmsk_reg [0:NUMSTP2+2];
  integer grpm_int;
  always @(posedge clk)
    for (grpm_int=0; grpm_int<=NUMSTP2+2; grpm_int=grpm_int+1)
      if (grpm_int>0)
        grpmsk_reg[grpm_int] <= grpmsk_reg[grpm_int-1];
      else
        grpmsk_reg[grpm_int] <= grpmsk_wire;

  reg [NUMVBNK-1:0] grpbp_reg [0:NUMSTP2-FLOPIN-FLOPOUT+4];
  integer grpb_int;
  always @(posedge clk)
    for (grpb_int=0; grpb_int<=NUMSTP2-FLOPIN-FLOPOUT+4; grpb_int=grpb_int+1)
      if (grpb_int>0) begin
        grpbp_reg[grpb_int] <= grpbp_reg[grpb_int-1];
      end else begin
        grpbp_reg[grpb_int] <= grpbp_wire;
      end
*/

  reg [BITVROW-1:0] freehead [0:NUMSBFL-1][0:NUMVBNK-1];
  reg [BITVROW-1:0] freetail [0:NUMSBFL-1][0:NUMVBNK-1];
  reg [BITVROW:0]   freecnt [0:NUMVBNK-1];
  reg [BITVROW:0]   usedcnt [0:NUMVBNK-1];
  reg [3:0]         free_enq_ptr [0:NUMVBNK-1];
  reg [3:0]         free_deq_ptr [0:NUMVBNK-1];

  reg [NUMVBNK-1:0] free_pivot_bp;
  reg [NUMVBNK-1:0] free_hyste_bp;
  integer frbp_int;
  always @(posedge clk)
    for (frbp_int=0; frbp_int<NUMVBNK; frbp_int=frbp_int+1) begin
//      free_pivot_bp[frbp_int] <= (freecnt[frbp_int] > NUMSBFL+FLOPIN+FLOPOUT+NUMFPAD+0+/*NUMFPAD+*/bp_thr_wire);
//      free_hyste_bp[frbp_int] <= (freecnt[frbp_int] > NUMSBFL+FLOPIN+FLOPOUT+NUMFPAD+0+/*NUMFPAD+*/bp_hys_wire);
      free_pivot_bp[frbp_int] <= (freecnt[frbp_int] > NUMSBFL+FLOPIN+FLOPOUT+NUMFPAD+6+/*NUMFPAD+*/bp_thr_wire);
      free_hyste_bp[frbp_int] <= (freecnt[frbp_int] > NUMSBFL+FLOPIN+FLOPOUT+NUMFPAD+6+/*NUMFPAD+*/bp_hys_wire);
    end

  reg [BITVBNK:0] free_pivot_cnt_nxt [0:NUMMAPT-1];
  reg [BITVBNK:0] free_hyste_cnt_nxt [0:NUMMAPT-1];
  integer frcp_int, frcb_int;
  always_comb
    for (frcp_int=0; frcp_int<NUMMAPT; frcp_int=frcp_int+1) begin
      free_pivot_cnt_nxt[frcp_int] = 0;
      free_hyste_cnt_nxt[frcp_int] = 0;
      for (frcb_int=0; frcb_int<NUMVBNK; frcb_int=frcb_int+1) begin
        if (grpbp_wire[frcp_int][frcb_int] && free_pivot_bp[frcb_int])
          free_pivot_cnt_nxt[frcp_int] = free_pivot_cnt_nxt[frcp_int] + 1;
        if (grpbp_wire[frcp_int][frcb_int] && free_hyste_bp[frcb_int])
          free_hyste_cnt_nxt[frcp_int] = free_hyste_cnt_nxt[frcp_int] + 1;
      end
    end

  reg [BITVBNK:0] free_pivot_cnt [0:NUMMAPT-1];
  reg [BITVBNK:0] free_hyste_cnt [0:NUMMAPT-1];
  integer frcr_int;
  always @(posedge clk)
    for (frcr_int=0; frcr_int<NUMMAPT; frcr_int=frcr_int+1) begin
      free_pivot_cnt[frcr_int] <= free_pivot_cnt_nxt[frcr_int];
      free_hyste_cnt[frcr_int] <= free_hyste_cnt_nxt[frcr_int];
    end

  reg [NUMVBNK-1:0] grpbp_vld;
  integer grpb_int;
  always_comb begin
    grpbp_vld = 0;
    for (grpb_int=0; grpb_int<NUMMAPT; grpb_int=grpb_int+1)
      grpbp_vld = grpbp_vld | grpbp_wire[grpb_int];
  end

  reg [BITVROW:0] freecnt_min;
  reg [BITVROW:0] freecnt_max;
  reg [BITVBNK-1:0] freebnk_min;
  reg [BITVBNK-1:0] freebnk_max;
  integer diff_int;
  always_comb begin
    freecnt_min = NUMVROW;
    freecnt_max = 0;
    freebnk_min = 0;
    freebnk_max = 0;
    for (diff_int=0; diff_int<NUMVBNK; diff_int=diff_int+1) begin
      if (grpbp_vld[diff_int] && (freecnt[diff_int] < freecnt_min)) begin
        freecnt_min = freecnt[diff_int];
        freebnk_min = diff_int;
      end
      if (grpbp_vld[diff_int] && (freecnt[diff_int] > freecnt_max)) begin
        freecnt_max = freecnt[diff_int];
        freebnk_max = diff_int;
      end
    end
  end

  wire [BITVROW:0] freecnt_dif = freecnt_max-freecnt_min;

  reg [BITVROW:0]   formcnt [0:NUMVBNK-1];
  reg [BITVBNK-1:0] formbnk [0:NUMVBNK-1];
  reg [NUMVBNK-1:0] formmsk [0:NUMVBNK-1];
  integer form_int, forb_int;
  always_comb
    for (form_int=0; form_int<NUMVBNK; form_int=form_int+1) begin
      formcnt[form_int] = 0;
      formbnk[form_int] = 0;
      for (forb_int=NUMVBNK-1; forb_int>=0; forb_int=forb_int-1)
        if (!formmsk[form_int][forb_int] && ((grpbp_vld[forb_int] ? freecnt[forb_int] : 0) >= formcnt[form_int])) begin
          formcnt[form_int] = grpbp_vld[forb_int] ? freecnt[forb_int] : 0;
          formbnk[form_int] = forb_int;
        end
    end

  integer forf_int;
  always_comb
    for (forf_int=0; forf_int<NUMVBNK; forf_int=forf_int+1)
      if (forf_int>0)
        formmsk[forf_int] = formmsk[forf_int-1] | (1'b1 << formbnk[forf_int-1]);
      else
        formmsk[forf_int] = 0;

  reg [BITVROW:0]   mostcnt_nxt [0:NUMVBNK-1][0:NUMVBNK];
  reg [BITVBNK-1:0] mostidx_nxt [0:NUMVBNK-1][0:NUMVBNK];
  reg [BITVROW:0]   mostcnt_reg [0:NUMVBNK-1][0:NUMVBNK];
  reg [BITVBNK-1:0] mostidx_reg [0:NUMVBNK-1][0:NUMVBNK];
  reg [BITVBNK-1:0] mostbnk_tmp [0:NUMVBNK-1];
  genvar modl_var, modb_var;
  generate
    for (modl_var=0; modl_var<NUMVBNK+1; modl_var=modl_var+1) begin: modl_loop
      for (modb_var=0; modb_var<NUMVBNK; modb_var=modb_var+1) begin: modb_loop
        if ((modl_var%4)==0) begin: flp_loop
          always @(posedge clk) begin
            mostcnt_reg[modb_var][modl_var] <= mostcnt_nxt[modb_var][modl_var];
            mostidx_reg[modb_var][modl_var] <= mostidx_nxt[modb_var][modl_var];
          end
        end else begin: nflp_loop
          always_comb begin
            mostcnt_reg[modb_var][modl_var] = mostcnt_nxt[modb_var][modl_var];
            mostidx_reg[modb_var][modl_var] = mostidx_nxt[modb_var][modl_var];
          end
        end
      end
    end
  endgenerate

  integer most_int, mosb_int;
  always_comb
    for (most_int=0; most_int<NUMVBNK+1; most_int=most_int+1)
      if (most_int==0) begin
        for (mosb_int=0; mosb_int<NUMVBNK; mosb_int=mosb_int+1) begin
          mostcnt_nxt[mosb_int][most_int] = grpbp_vld[mosb_int] ? freecnt[mosb_int] : 0;
          mostidx_nxt[mosb_int][most_int] = mosb_int;
        end
      end else begin
        for (mosb_int=0; mosb_int<NUMVBNK; mosb_int=mosb_int+1) begin
          mostcnt_nxt[mosb_int][most_int] = mostcnt_reg[mosb_int][most_int-1];
          mostidx_nxt[mosb_int][most_int] = mostidx_reg[mosb_int][most_int-1];
        end
        for (mosb_int=!most_int[0]; mosb_int<NUMVBNK-1; mosb_int=mosb_int+2)
          if (mostcnt_reg[mosb_int+1][most_int-1] > mostcnt_reg[mosb_int][most_int-1]) begin
            mostcnt_nxt[mosb_int][most_int] = mostcnt_reg[mosb_int+1][most_int-1];
            mostidx_nxt[mosb_int][most_int] = mostidx_reg[mosb_int+1][most_int-1];
            mostcnt_nxt[mosb_int+1][most_int] = mostcnt_reg[mosb_int][most_int-1];
            mostidx_nxt[mosb_int+1][most_int] = mostidx_reg[mosb_int][most_int-1];
          end
      end
           
  integer mosf_int;
  always_comb
    for (mosf_int=0; mosf_int<NUMVBNK; mosf_int=mosf_int+1) begin
      mostbnk_tmp[mosf_int] = mostidx_reg[mosf_int][NUMVBNK];
    end

  reg [BITVBNK-1:0] permide [0:NUMVBNK-1];
  reg [BITVBNK-1:0] perminv [0:NUMVBNK-1];
  reg [BITVBNK-1:0] permide_next [0:NUMVBNK-1];
  reg [BITVBNK-1:0] perminv_next [0:NUMVBNK-1];
  integer pern_int;
  always_comb begin
    for (pern_int=0; pern_int<NUMVBNK; pern_int=pern_int+1) begin
      permide_next[pern_int] = pern_int;
      perminv_next[pern_int] = pern_int;
    end
    for (pern_int=0; pern_int<NUMVBNK; pern_int=pern_int+1) begin
/*      if (free_pivot_cnt<bp_cnt_wire) begin
        permide_next[pern_int] = mostbnk_tmp[pern_int];
        perminv_next[mostbnk_tmp[pern_int]] = pern_int;
      end else*/ if (ena_rand_wire) begin
        permide_next[pern_int] = mostbnk_tmp[pern_int];
        perminv_next[mostbnk_tmp[pern_int]] = pern_int;
      end else begin
        permide_next[pern_int] = pern_int;
        perminv_next[pern_int] = pern_int;
      end
    end
  end

  reg [NUMVBNK-1:0] permide_chk, perminv_chk, permmst_chk;
  reg permmat_chk;
  integer pchk_int;
  always_comb begin
    permide_chk = 0;
    perminv_chk = 0;
    permmst_chk = 0;
    permmat_chk = 1'b0;
    for (pchk_int=0; pchk_int<NUMVBNK; pchk_int=pchk_int+1) begin
      permide_chk[permide[pchk_int]] = 1'b1;
      perminv_chk[perminv[pchk_int]] = 1'b1;
      permmst_chk[mostbnk_tmp[pchk_int]] = 1'b1;
      if (permide[perminv[pchk_int]]!=pchk_int)
        permmat_chk = 1'b1;
    end
  end

  integer perr_int;
  always @(posedge clk)
    for (perr_int=0; perr_int<NUMVBNK; perr_int=perr_int+1) begin
      permide[perr_int] <= permide_next[perr_int];
      perminv[perr_int] <= perminv_next[perr_int];
    end

  reg [BITVBNK-1:0] permide_reg [0:NUMVBNK-1][0:NUMMAPT];
  reg [BITVBNK-1:0] perminv_reg [0:NUMVBNK-1][0:NUMMAPT];
  integer perd_int, perb_int;
  always @(posedge clk)
    for (perb_int=0; perb_int<NUMVBNK; perb_int=perb_int+1)
      for (perd_int=0; perd_int<NUMMAPT+1; perd_int=perd_int+1)
        if (perd_int>0) begin
          permide_reg[perb_int][perd_int] <= permide_reg[perb_int][perd_int-1];
          perminv_reg[perb_int][perd_int] <= perminv_reg[perb_int][perd_int-1];
        end else begin
          permide_reg[perb_int][perd_int] <= permide[perb_int];
          perminv_reg[perb_int][perd_int] <= perminv[perb_int];
        end

  reg [BITVBNK*NUMVBNK-1:0] permide_bus;
  reg [BITVBNK*NUMVBNK-1:0] perminv_bus;
  reg [BITVBNK*NUMVBNK-1:0] permide_reg_bus;
  reg [BITVBNK*NUMVBNK-1:0] perminv_reg_bus;
  integer pebu_int;
  always_comb begin
    permide_bus = 0;
    perminv_bus = 0;
    permide_reg_bus = 0;
    perminv_reg_bus = 0;
    for (pebu_int=0; pebu_int<NUMVBNK; pebu_int=pebu_int+1) begin
      permide_bus = permide_bus | (permide[pebu_int] << (pebu_int*BITVBNK));
      perminv_bus = perminv_bus | (perminv[pebu_int] << (pebu_int*BITVBNK));
      permide_reg_bus = permide_reg_bus | (permide_reg[pebu_int][NUMMAPT] << (pebu_int*BITVBNK));
      perminv_reg_bus = perminv_reg_bus | (perminv_reg[pebu_int][NUMMAPT] << (pebu_int*BITVBNK));
    end
  end

  reg [NUMVBNK-1:0] free_pivot_next [0:NUMMAPT-1];
  integer frei_int, frep_int;
  always_comb
    for (frep_int=0; frep_int<NUMMAPT; frep_int=frep_int+1) begin
      free_pivot_next[frep_int] = 0;
      for (frei_int=0; frei_int<NUMVBNK; frei_int=frei_int+1)
        if (grpmsk_wire[frep_int][frei_int] && (freecnt[frei_int] > NUMSBFL+NUMFPAD+4))
          free_pivot_next[frep_int] = free_pivot_next[frep_int] | (1'b1 << perminv[frei_int]);
    end

  reg [NUMVBNK-1:0] free_pivot_init [0:NUMMAPT-1];
  reg [NUMVBNK-1:0] free_pivot_inir [0:NUMMAPT-1];
  integer fred_int;
  always @(posedge clk)
    for (fred_int=0; fred_int<NUMMAPT; fred_int=fred_int+1) begin
      free_pivot_init[fred_int] <= free_pivot_next[fred_int];
      free_pivot_inir[fred_int] <= free_pivot_init[fred_int];
    end

  reg [NUMVBNK-1:0] free_pivot_temp [0:NUMMAPT];
  reg [NUMVBNK-1:0] used_pivot_temp [0:NUMMAPT];
  reg [NUMVBNK-1:0] used_pivot [0:NUMMAPT];
  reg [NUMVBNK-1:0] new_pivot [0:NUMMAPT-1];
  reg               new_vld [0:NUMMAPT-1];
  reg [BITVBNK-1:0] new_bnk [0:NUMMAPT-1];

  integer newp_int, newx_int;
  always_comb
    for (newp_int=0; newp_int<NUMMAPT; newp_int=newp_int+1) begin
      new_vld[newp_int] = 1'b0;
      new_bnk[newp_int] = 0;
      for (newx_int=NUMVBNK-1; newx_int>=0; newx_int=newx_int-1)
        if (free_pivot_temp[newp_int][newx_int]) begin
          new_vld[newp_int] = 1'b1;
          new_bnk[newp_int] = newx_int;
        end
    end

  reg [NUMVBNK-1:0] free_pivot_del [0:NUMMAPT-1][0:NUMMAPT-1];
  reg               new_vld_del [0:NUMMAPT-1][0:NUMMAPT-1];
  reg [BITVBNK-1:0] new_bnk_del [0:NUMMAPT-1][0:NUMMAPT-1];
  genvar used_var;
  generate for (used_var=0; used_var<NUMMAPT; used_var=used_var+1) begin: used_loop
    if (used_var==0) begin: init_loop
      always_comb begin
        used_pivot_temp[used_var] = 0;
        for (integer free_int=0; free_int<NUMMAPT; free_int=free_int+1) begin
          free_pivot_del[free_int][used_var] = free_pivot_init[free_int];
          if (free_int==used_var) begin
            new_vld_del[free_int][used_var] = new_vld[free_int];
            new_bnk_del[free_int][used_var] = new_bnk[free_int];
          end else begin
            new_vld_del[free_int][used_var] = 0;
            new_bnk_del[free_int][used_var] = 0;
          end
        end
      end
    end
    else if ((used_var%1)==0) begin: flp_loop
      always @(posedge clk) begin
        used_pivot_temp[used_var] <= used_pivot[used_var-1];
        for (integer free_int=0; free_int<NUMMAPT; free_int=free_int+1) begin
          free_pivot_del[free_int][used_var] <= free_pivot_del[free_int][used_var-1];
          if (free_int==used_var) begin
            new_vld_del[free_int][used_var] <= new_vld[free_int];
            new_bnk_del[free_int][used_var] <= new_bnk[free_int];
          end else begin
            new_vld_del[free_int][used_var] <= new_vld_del[free_int][used_var-1];
            new_bnk_del[free_int][used_var] <= new_bnk_del[free_int][used_var-1];
          end
        end
      end
    end else begin: nflp_loop
      always_comb begin
        used_pivot_temp[used_var] = used_pivot[used_var-1];
        for (integer free_int=0; free_int<NUMMAPT; free_int=free_int+1) begin
          free_pivot_del[free_int][used_var] = free_pivot_del[free_int][used_var-1];
          if (free_int==used_var) begin
            new_vld_del[free_int][used_var] = new_vld[free_int];
            new_bnk_del[free_int][used_var] = new_bnk[free_int];
          end else begin
            new_vld_del[free_int][used_var] = new_vld_del[free_int][used_var-1];
            new_bnk_del[free_int][used_var] = new_bnk_del[free_int][used_var-1];
          end
        end
      end
    end
  end
  endgenerate

  reg               new_vld_temp [0:NUMMAPT-1];
  reg [BITVBNK-1:0] new_bnk_temp [0:NUMMAPT-1];
  integer newt_int;
  always_comb
    for (newt_int=0; newt_int<NUMMAPT; newt_int=newt_int+1) begin
      new_vld_temp[newt_int] = new_vld_del[newt_int][NUMMAPT-1];
      new_bnk_temp[newt_int] = permide_reg[new_bnk_del[newt_int][NUMMAPT-1]][NUMMAPT-1];
    end

  integer usep_int;
  always_comb
    for (usep_int=0; usep_int<NUMMAPT; usep_int=usep_int+1) begin
      free_pivot_temp[usep_int] = free_pivot_del[usep_int][usep_int] & ~used_pivot_temp[usep_int];
      new_pivot[usep_int] = new_vld[usep_int] ? (1'b1 << new_bnk[usep_int]) : 0;
      used_pivot[usep_int] = used_pivot_temp[usep_int] | new_pivot[usep_int];
    end

  reg               new_vld_wire [0:NUMMAPT-1];
  reg [BITVBNK-1:0] new_bnk_wire [0:NUMMAPT-1];
  reg [3:0]         new_sel;
  integer neww_int;
  always_comb begin
    new_sel = 0;
    for (neww_int=0; neww_int<NUMMAPT; neww_int=neww_int+1) begin
      if ((neww_int%NUMEGPT)==0)
        new_sel = neww_int;
      new_vld_wire[neww_int] = 1'b0;
      new_bnk_wire[neww_int] = 0; 
      if (vmalloc_wire[neww_int]) begin
        new_vld_wire[neww_int] = new_vld_temp[new_sel];
        new_bnk_wire[neww_int] = new_bnk_temp[new_sel];
        new_sel=new_sel+1;
      end
    end
  end
     
  reg new_enq [0:NUMVBNK-1];
  reg [BITVROW-1:0] new_radr [0:NUMVBNK-1];
  integer newe_int, newb_int;
  always_comb
    for (newb_int=0; newb_int<NUMVBNK; newb_int=newb_int+1) begin
      new_enq[newb_int] = 1'b0;
      for (newe_int=0; newe_int<NUMMAPT; newe_int=newe_int+1)
        if (new_vld_wire[newe_int] && (new_bnk_wire[newe_int] == newb_int))
          new_enq[newb_int] = 1'b1;
      new_radr[newb_int] = freehead[free_enq_ptr[newb_int]][newb_int];
    end 

  reg [NUMVBNK-1:0] new_deq [0:NUMDQPT-1];
  integer deqb_int;
  always @(posedge clk)
    for (deqb_int=0; deqb_int<NUMDQPT; deqb_int=deqb_int+1) 
      if (vdeq_wire[deqb_int])
        new_deq[deqb_int] <= (1'b1 << vdqbadr_wire[deqb_int]);
      else
        new_deq[deqb_int] <= 0;

  reg [3:0] free_deq_ptr_nxt [0:NUMVBNK-1][0:NUMDQPT];
  integer fdqb_int, fdqp_int;
  always_comb
    for (fdqb_int=0; fdqb_int<NUMVBNK; fdqb_int=fdqb_int+1) begin
      free_deq_ptr_nxt[fdqb_int][0] = free_deq_ptr[fdqb_int];
      for (fdqp_int=0; fdqp_int<NUMDQPT; fdqp_int=fdqp_int+1)
        if (vdeq_out[fdqp_int] && (vdqbadr_out[fdqp_int] == fdqb_int))
          free_deq_ptr_nxt[fdqb_int][fdqp_int+1] = (free_deq_ptr_nxt[fdqb_int][fdqp_int] + 1) % NUMSBFL;
        else
          free_deq_ptr_nxt[fdqb_int][fdqp_int+1] = free_deq_ptr_nxt[fdqb_int][fdqp_int];
    end

  integer fptb_int, fptr_int;
  always @(posedge clk)
    for (fptb_int=0; fptb_int<NUMVBNK; fptb_int=fptb_int+1)
      if (rst) begin
        free_enq_ptr[fptb_int] <= 0;
        free_deq_ptr[fptb_int] <= 0;
      end else if (vcpwrite_wire && (vcpaddr_wire[BITVBNK-1:0] == fptb_int)) begin
        free_enq_ptr[fptb_int] <= vcpdin_wire >> (3*BITVROW+5);
        free_deq_ptr[fptb_int] <= vcpdin_wire >> (3*BITVROW+1);
      end else begin
        if (new_enq[fptb_int])
          free_enq_ptr[fptb_int] <= (free_enq_ptr[fptb_int] + 1) % NUMSBFL;
        free_deq_ptr[fptb_int] <= free_deq_ptr_nxt[fptb_int][NUMDQPT];
      end

  reg       new_enq_reg [0:NUMVBNK-1][0:SRAM_DELAY-1];
  reg [3:0] new_list_reg [0:NUMVBNK-1][0:SRAM_DELAY-1];
  integer fnwb_int, fnwd_int;
  always @(posedge clk)
    for (fnwb_int=0; fnwb_int<NUMVBNK; fnwb_int=fnwb_int+1)
      for (fnwd_int=0; fnwd_int<SRAM_DELAY; fnwd_int=fnwd_int+1)
        if (fnwd_int>0) begin
          new_enq_reg[fnwb_int][fnwd_int] <= new_enq_reg[fnwb_int][fnwd_int-1];
          new_list_reg[fnwb_int][fnwd_int] <= new_list_reg[fnwb_int][fnwd_int-1];
        end else begin
          new_enq_reg[fnwb_int][fnwd_int] <= new_enq[fnwb_int];
          new_list_reg[fnwb_int][fnwd_int] <= free_enq_ptr[fnwb_int];
        end

  reg [BITVROW:0] freecnt_nxt [0:NUMVBNK-1];
  reg [BITVROW:0] usedcnt_nxt [0:NUMVBNK-1];
  integer fctb_int, fctr_int;
  always_comb
    for (fctb_int=0; fctb_int<NUMVBNK; fctb_int=fctb_int+1) begin
      freecnt_nxt[fctb_int] = freecnt[fctb_int];
      usedcnt_nxt[fctb_int] = usedcnt[fctb_int];
      if (new_enq_reg[fctb_int][0]) begin
        freecnt_nxt[fctb_int] = freecnt_nxt[fctb_int] - 1;
        usedcnt_nxt[fctb_int] = usedcnt_nxt[fctb_int] + 1;
      end
      for (fctr_int=0; fctr_int<NUMDQPT; fctr_int=fctr_int+1)
        if (new_deq[fctr_int][fctb_int]) begin
          freecnt_nxt[fctb_int] = freecnt_nxt[fctb_int] + 1;
          usedcnt_nxt[fctb_int] = usedcnt_nxt[fctb_int] - 1;
        end
    end

  integer frer_int, freb_int, fres_int;
  always @(posedge clk)
    if (rst)
      for (freb_int=0; freb_int<NUMVBNK; freb_int=freb_int+1) begin
        for (fres_int=0; fres_int<NUMSBFL; fres_int=fres_int+1) begin
          freehead[fres_int][freb_int] <= fres_int;
          freetail[fres_int][freb_int] <= (NUMSBFL==2) ? NUMVROW-NUMSBFL + fres_int : NUMVROW-NUMVROW%NUMSBFL-NUMSBFL+fres_int;
        end
        freecnt[freb_int] <= NUMVROW - NUMVROW%NUMSBFL;
        usedcnt[freb_int] <= 0;
      end
    else for (freb_int=0; freb_int<NUMVBNK; freb_int=freb_int+1)
      if (vcpwrite_wire && (vcpaddr_wire[BITVBNK-1:0] == freb_int)) begin
        freehead[vcpaddr_wire[BITVBNK+2:BITVBNK]][freb_int] <= vcpdin_wire >> (2*BITVROW+1);
        freetail[vcpaddr_wire[BITVBNK+2:BITVBNK]][freb_int] <= vcpdin_wire >> (1*BITVROW+1);
        freecnt[freb_int] <= vcpdin_wire;
        usedcnt[freb_int] <= vcpdin_wire >> (3*BITVROW+9);
      end else begin
        for (frer_int=0; frer_int<NUMDQPT; frer_int=frer_int+1)
          if (vdeq_out[frer_int] && (vdqbadr_out[frer_int] == freb_int))
            freetail[free_deq_ptr_nxt[freb_int][frer_int]][freb_int] <= vdqradr_out[frer_int];
        if (new_enq_reg[freb_int][SRAM_DELAY-1])
          freehead[new_list_reg[freb_int][SRAM_DELAY-1]][freb_int] <= t2_doutB >> ((new_list_reg[freb_int][SRAM_DELAY-1][0]*NUMVBNK+freb_int)*BITVROW);
        freecnt[freb_int] <= freecnt_nxt[freb_int];
        usedcnt[freb_int] <= usedcnt_nxt[freb_int];
      end

  integer pwrp_int;
  always_comb begin
    for (pwrp_int=0; pwrp_int<NUMMAPT; pwrp_int=pwrp_int+1) begin
      pwrite_wire[pwrp_int] = new_vld_wire[pwrp_int];
      pwrbadr_wire[pwrp_int] = new_bnk_wire[pwrp_int];
      pwrradr_wire[pwrp_int] = new_radr[new_bnk_wire[pwrp_int]];
    end
  end

  reg [NUMMAPT-1:0] pwrite;
  reg [(NUMMAPT)*BITVBNK-1:0] pwrbadr;
  reg [(NUMMAPT)*BITVROW-1:0] pwrradr;
  integer pwrpo_int, pwba_int, pwra_int;
  always_comb begin
    for (pwrpo_int=0; pwrpo_int<NUMMAPT; pwrpo_int=pwrpo_int+1) begin
      pwrite[pwrpo_int] = pwrite_wire[pwrpo_int];
      for (pwba_int=0; pwba_int<BITVBNK; pwba_int=pwba_int+1)
        pwrbadr[pwrpo_int*BITVBNK+pwba_int] = pwrbadr_wire[pwrpo_int][pwba_int];
      for (pwra_int=0; pwra_int<BITVROW; pwra_int=pwra_int+1)
        pwrradr[pwrpo_int*BITVROW+pwra_int] = pwrradr_wire[pwrpo_int][pwra_int];
    end
  end

  reg               new_vld_reg [0:NUMMAPT-1][0:SRAM_DELAY-1];
  reg [BITVBNK-1:0] new_bnk_reg [0:NUMMAPT-1][0:SRAM_DELAY-1];
  reg [BITVROW-1:0] new_adr_reg [0:NUMMAPT-1][0:SRAM_DELAY-1];
  integer newr_int, newd_int;
  always @(posedge clk)
    for (newr_int=0; newr_int<NUMMAPT; newr_int=newr_int+1)
      for (newd_int=0; newd_int<SRAM_DELAY; newd_int=newd_int+1)
        if (newd_int>0) begin
          new_vld_reg[newr_int][newd_int] <= new_vld_reg[newr_int][newd_int-1];
          new_bnk_reg[newr_int][newd_int] <= new_bnk_reg[newr_int][newd_int-1];
          new_adr_reg[newr_int][newd_int] <= new_adr_reg[newr_int][newd_int-1];
        end else begin
          new_vld_reg[newr_int][newd_int] <= new_vld_wire[newr_int];
          new_bnk_reg[newr_int][newd_int] <= new_bnk_wire[newr_int];
          new_adr_reg[newr_int][newd_int] <= new_radr[new_bnk_wire[newr_int]];
        end

  reg hold_bp [0:NUMMAPT-1];
  integer hldb_int;
  always @(posedge clk)
    for (hldb_int=0; hldb_int<NUMMAPT; hldb_int=hldb_int+1) begin
      if (rst)
        hold_bp[hldb_int] <= 1'b0;
      else if (free_pivot_cnt[hldb_int] < grpcnt_wire[hldb_int])
        hold_bp[hldb_int] <= 1'b1;
      else if (free_hyste_cnt[hldb_int] >= grpcnt_wire[hldb_int])
        hold_bp[hldb_int] <= 1'b0;
    end

  reg vma_bp_temp [0:NUMMAPT-1];
  reg vma_vld_temp [0:NUMMAPT-1];
  reg [BITADDR-1:0] vma_addr_temp [0:NUMMAPT-1];
  reg vma_list_temp [0:NUMMAPT-1];
  reg vma_fwrd_temp [0:NUMMAPT-1];
  reg vma_serr_temp [0:NUMMAPT-1];
  reg vma_derr_temp [0:NUMMAPT-1];
  reg [BITVROW:0] vma_padr_temp [0:NUMMAPT-1];
  integer vmat_int;
  always_comb
    for (vmat_int=0; vmat_int<NUMMAPT; vmat_int=vmat_int+1) begin
      vma_bp_temp[vmat_int] = hold_bp[vmat_int] ? (free_hyste_cnt[vmat_int] < grpcnt_wire[vmat_int]) : (free_pivot_cnt[vmat_int] < grpcnt_wire[vmat_int]);
      vma_vld_temp[vmat_int] = new_vld_reg[vmat_int][SRAM_DELAY-1];
      if (NUMVROW == (1 << BITVROW))
        vma_addr_temp[vmat_int] = {new_bnk_reg[vmat_int][SRAM_DELAY-1],new_adr_reg[vmat_int][SRAM_DELAY-1]};
      else
        vma_addr_temp[vmat_int] = {new_adr_reg[vmat_int][SRAM_DELAY-1],new_bnk_reg[vmat_int][SRAM_DELAY-1]};
      vma_list_temp[vmat_int] = new_list_reg[new_bnk_reg[vmat_int][SRAM_DELAY-1]][SRAM_DELAY-1][0];
      vma_fwrd_temp[vmat_int] = t2_fwrdB >> (vma_list_temp[vmat_int]*NUMVBNK+new_bnk_reg[vmat_int][SRAM_DELAY-1]);
      vma_serr_temp[vmat_int] = t2_serrB >> (vma_list_temp[vmat_int]*NUMVBNK+new_bnk_reg[vmat_int][SRAM_DELAY-1]);
      vma_derr_temp[vmat_int] = t2_derrB >> (vma_list_temp[vmat_int]*NUMVBNK+new_bnk_reg[vmat_int][SRAM_DELAY-1]);
      vma_padr_temp[vmat_int][BITVROW] = vma_list_temp[vmat_int];
      vma_padr_temp[vmat_int][BITVROW-1:0] = t2_padrB >> ((vma_list_temp[vmat_int]*NUMVBNK+new_bnk_reg[vmat_int][SRAM_DELAY-1])*BITVROW);
    end

  reg [NUMMAPT-1:0] vma_bp_bus;
  reg [NUMMAPT-1:0] vma_vld_bus;
  reg [NUMMAPT*BITADDR-1:0] vma_addr_bus;
  reg [NUMMAPT-1:0] vma_fwrd_bus;
  reg [NUMMAPT-1:0] vma_serr_bus;
  reg [NUMMAPT-1:0] vma_derr_bus;
  reg [NUMMAPT*(BITVROW+1)-1:0] vma_padr_bus;
  integer vmab_int;
  always_comb begin
    vma_bp_bus = 0;
    vma_vld_bus = 0;
    vma_addr_bus = 0;
    vma_fwrd_bus = 0;
    vma_serr_bus = 0;
    vma_derr_bus = 0;
    vma_padr_bus = 0;
    for (vmab_int=0; vmab_int<NUMMAPT; vmab_int=vmab_int+1) begin
      vma_bp_bus = vma_bp_bus | (vma_bp_temp[vmab_int] << vmab_int);
      vma_vld_bus = vma_vld_bus | (vma_vld_temp[vmab_int] << vmab_int);
      vma_addr_bus = vma_addr_bus | (vma_addr_temp[vmab_int] << (vmab_int*BITADDR));
      vma_serr_bus = vma_serr_bus | (vma_serr_temp[vmab_int] << vmab_int);
      vma_derr_bus = vma_derr_bus | (vma_derr_temp[vmab_int] << vmab_int);
      vma_padr_bus = vma_padr_bus | (vma_padr_temp[vmab_int] << (vmab_int*(BITVROW+1)));
    end
  end

  reg [NUMVBNK-1:0] grpmt;
  reg [NUMMAPT-1:0] vma_bp;
  reg [NUMMAPT-1:0] vma_vld;
  reg [NUMMAPT*BITADDR-1:0] vma_addr;
  reg [NUMMAPT-1:0] vma_fwrd;
  reg [NUMMAPT-1:0] vma_serr;
  reg [NUMMAPT-1:0] vma_derr;
  reg [NUMMAPT*(BITVROW+1)-1:0] vma_padr;
  reg ready;
  generate if (FLOPOUT) begin: flpma_loop
    reg [NUMVBNK-1:0] grpmt_reg [0:FLOPOUT-1];
    reg [NUMMAPT-1:0] vma_bp_reg [0:FLOPOUT-1];
    reg [NUMMAPT-1:0] vma_vld_reg [0:FLOPOUT-1];
    reg [NUMMAPT*BITADDR-1:0] vma_addr_reg [0:FLOPOUT-1];
    reg [NUMMAPT-1:0] vma_fwrd_reg [0:FLOPOUT-1];
    reg [NUMMAPT-1:0] vma_serr_reg [0:FLOPOUT-1];
    reg [NUMMAPT-1:0] vma_derr_reg [0:FLOPOUT-1];
    reg [NUMMAPT*(BITVROW+1)-1:0] vma_padr_reg [0:FLOPOUT-1];
    reg ready_reg [0:FLOPOUT-1];
    integer flpo_int, grp_int;
    always @(posedge clk)
      for (flpo_int=0; flpo_int<FLOPOUT; flpo_int=flpo_int+1)
        if (flpo_int>0) begin
          grpmt_reg[flpo_int] <= grpmt_reg[flpo_int-1];
          vma_bp_reg[flpo_int] <= vma_bp_reg[flpo_int-1];
          vma_vld_reg[flpo_int] <= vma_vld_reg[flpo_int-1];
          vma_addr_reg[flpo_int] <= vma_addr_reg[flpo_int-1];
          vma_fwrd_reg[flpo_int] <= vma_fwrd_reg[flpo_int-1];
          vma_serr_reg[flpo_int] <= vma_serr_reg[flpo_int-1];
          vma_derr_reg[flpo_int] <= vma_derr_reg[flpo_int-1];
          vma_padr_reg[flpo_int] <= vma_padr_reg[flpo_int-1];
          ready_reg[flpo_int] <= ready_reg[flpo_int-1];
        end else begin
          for (grp_int=0; grp_int<NUMVBNK; grp_int=grp_int+1)
            grpmt_reg[flpo_int][grp_int] <= !(|usedcnt[grp_int]);
          vma_bp_reg[flpo_int] <= vma_bp_bus;
          vma_vld_reg[flpo_int] <= vma_vld_bus;
          vma_addr_reg[flpo_int] <= vma_addr_bus;
          vma_fwrd_reg[flpo_int] <= vma_fwrd_bus;
          vma_serr_reg[flpo_int] <= vma_serr_bus;
          vma_derr_reg[flpo_int] <= vma_derr_bus;
          vma_padr_reg[flpo_int] <= vma_padr_bus;
          ready_reg[flpo_int] <= ready_int;
        end

    always_comb begin
      grpmt = grpmt_reg[FLOPOUT-1];
      vma_bp = vma_bp_reg[FLOPOUT-1];
      vma_vld = vma_vld_reg[FLOPOUT-1];
      vma_addr = vma_addr_reg[FLOPOUT-1];
      vma_fwrd = vma_fwrd_reg[FLOPOUT-1];
      vma_serr = vma_serr_reg[FLOPOUT-1];
      vma_derr = vma_derr_reg[FLOPOUT-1];
      vma_padr = vma_padr_reg[FLOPOUT-1];
      ready = ready_reg[FLOPOUT-1];
    end
  end else begin: nflpma_loop
    integer grp_int;
    always_comb begin
      for (grp_int=0; grp_int<NUMVBNK; grp_int=grp_int+1)
        grpmt[grp_int] = !(|usedcnt[grp_int]);
      vma_bp = vma_bp_bus;
      vma_vld = vma_vld_bus;
      vma_addr = vma_addr_bus;
      vma_fwrd = vma_fwrd_bus;
      vma_serr = vma_serr_bus;
      vma_derr = vma_derr_bus;
      vma_padr = vma_padr_bus;
      ready = ready_int;
    end
  end
  endgenerate

  integer swrr_int, swrb_int, swrd_int;
  always_comb
    for (swrb_int=0; swrb_int<NUMVBNK; swrb_int=swrb_int+1) begin
      for (swrd_int=0; swrd_int<(NUMDQPT/NUMEGPT); swrd_int=swrd_int+1) begin
        swrite_wire[swrb_int][swrd_int] = 1'b0;
        swrradr_wire[swrb_int][swrd_int] = 0;
        sdin_wire[swrb_int][swrd_int] = 0;
        for (swrr_int=0; swrr_int<NUMDQPT; swrr_int=swrr_int+1)
          if (vdeq_out[swrr_int] && (vdqbadr_out[swrr_int] == swrb_int)) begin
            swrite_wire[swrb_int][free_deq_ptr_nxt[swrb_int][swrr_int][0]] = 1'b1;
            swrradr_wire[swrb_int][free_deq_ptr_nxt[swrb_int][swrr_int][0]] = freetail[free_deq_ptr_nxt[swrb_int][swrr_int]][swrb_int];
            sdin_wire[swrb_int][free_deq_ptr_nxt[swrb_int][swrr_int][0]] = vdqradr_out[swrr_int];
          end
        if (rstvld && !rst) begin
          swrite_wire[swrb_int][swrd_int] = 1'b1;
          swrradr_wire[swrb_int][swrd_int] = rstaddr;
          sdin_wire[swrb_int][swrd_int] = rstaddr+NUMSBFL;
        end
      end
    end
     
  integer srdb_int, srdd_int;
  always_comb 
    for (srdb_int=0; srdb_int<NUMVBNK; srdb_int=srdb_int+1) begin
      for (srdd_int=0; srdd_int<(NUMDQPT/NUMEGPT); srdd_int=srdd_int+1) begin
        sread_wire[srdb_int][srdd_int] = 1'b0;
        srdradr_wire[srdb_int][srdd_int] = 0;
      end
      if (new_enq[srdb_int])
        sread_wire[srdb_int][free_enq_ptr[srdb_int][0]] = 1'b1;
      srdradr_wire[srdb_int][free_enq_ptr[srdb_int][0]] = new_radr[srdb_int];
    end

  reg [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_writeA;
  reg [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_addrA;
  reg [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_dinA;
  reg [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_readB;
  reg [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_addrB;
  integer t2d_int, t2a_int, t2b_int;
  always_comb begin
    t2_writeA = 0;
    t2_addrA = 0;
    t2_dinA = 0;
    for (t2b_int=0; t2b_int<NUMVBNK; t2b_int=t2b_int+1)
      for (t2d_int=0; t2d_int<(NUMDQPT/NUMEGPT); t2d_int=t2d_int+1) begin
        if (swrite_wire[t2b_int][t2d_int])
          t2_writeA[t2d_int*NUMVBNK+t2b_int] = 1'b1;
        for (t2a_int=0; t2a_int<BITVROW; t2a_int=t2a_int+1) begin
          t2_addrA[(t2d_int*NUMVBNK+t2b_int)*BITVROW+t2a_int] = swrradr_wire[t2b_int][t2d_int][t2a_int];
          t2_dinA[(t2d_int*NUMVBNK+t2b_int)*BITVROW+t2a_int] = sdin_wire[t2b_int][t2d_int][t2a_int];
        end
      end
    t2_readB = 0;
    t2_addrB = 0;
    for (t2b_int=0; t2b_int<NUMVBNK; t2b_int=t2b_int+1)
      for (t2d_int=0; t2d_int<(NUMDQPT/NUMEGPT); t2d_int=t2d_int+1) begin
        if (sread_wire[t2b_int][t2d_int])
          t2_readB[t2d_int*NUMVBNK+t2b_int] = 1'b1;
        for (t2a_int=0; t2a_int<BITVROW; t2a_int=t2a_int+1)
          t2_addrB[(t2d_int*NUMVBNK+t2b_int)*BITVROW+t2a_int] = srdradr_wire[t2b_int][t2d_int][t2a_int];
      end
  end

  wire vcpread_vld_tmp = vcpread_wire;
  wire [CPUWDTH-1:0] vcpread_dout_tmp = {usedcnt[vcpaddr_wire[BITVBNK-1:0]],
                                         free_enq_ptr[vcpaddr_wire[BITVBNK-1:0]],
                                         free_deq_ptr[vcpaddr_wire[BITVBNK-1:0]],
                                         freehead[vcpaddr_wire[BITVBNK+2:BITVBNK]][vcpaddr_wire[BITVBNK-1:0]],
                                         freetail[vcpaddr_wire[BITVBNK+2:BITVBNK]][vcpaddr_wire[BITVBNK-1:0]],
                                         freecnt[vcpaddr_wire[BITVBNK-1:0]]};

  wire vcpread_vld;
  wire [CPUWDTH-1:0] vcpread_dout;
  generate if (FLOPOUT) begin: cpflp_loop
    reg vcpread_vld_reg [0:FLOPOUT-1];
    reg [CPUWDTH-1:0] vcpread_dout_reg [0:FLOPOUT-1];
    integer flpo_int;
    always@(posedge clk)
      for (flpo_int=0; flpo_int<FLOPOUT; flpo_int=flpo_int+1)
        if (flpo_int>0) begin
          vcpread_vld_reg[flpo_int] <= vcpread_vld_reg[flpo_int-1];
          vcpread_dout_reg[flpo_int] <= vcpread_dout_reg[flpo_int-1];
        end else begin
          vcpread_vld_reg[flpo_int] <= vcpread_vld_tmp;
          vcpread_dout_reg[flpo_int] <= vcpread_dout_tmp;
        end

    assign vcpread_vld = vcpread_vld_reg[FLOPOUT-1];
    assign vcpread_dout = vcpread_dout_reg[FLOPOUT-1];
  end else begin: cpnflp_loop
    assign vcpread_vld = vcpread_vld_tmp;
    assign vcpread_dout = vcpread_dout_tmp;
  end
  endgenerate

endmodule
