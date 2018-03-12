module core_mrcnw_1r2w_rl (vwrite, vwraddr, vdin,
                          vread, vread_clr, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                          t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                          t2_writeA, t2_addrA, t2_dinA, t2_writeB, t2_readB, t2_addrB, t2_dinB, t2_doutB,
                          ready, clk, rst);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 1;
  parameter NUMWRPT = 4;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter BITPADR = 14;
  
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter NUMPBNK = NUMWRPT/2;
  parameter BITPBNK = 1;

  input  [NUMWRPT-1:0]          vwrite;
  input  [NUMWRPT*BITADDR-1:0]  vwraddr;
  input  [NUMWRPT*WIDTH-1:0]    vdin;

  input  [NUMRDPT-1:0]          vread;
  input  [NUMRDPT-1:0]          vread_clr;
  input  [NUMRDPT*BITADDR-1:0]  vrdaddr;
  output [NUMRDPT-1:0]          vread_vld;
  output [NUMRDPT*WIDTH-1:0]    vdout;
  output [NUMRDPT-1:0]          vread_fwrd;
  output [NUMRDPT-1:0]          vread_serr;
  output [NUMRDPT-1:0]          vread_derr;
  output [NUMRDPT*BITPADR-1:0]  vread_padr;

  output [NUMRDPT*2*NUMPBNK-1:0]                   t1_writeA;
  output [NUMRDPT*2*NUMPBNK*BITADDR-1:0]           t1_addrA;
  output [NUMRDPT*2*NUMPBNK*WIDTH-1:0]             t1_dinA;

  output [NUMRDPT*NUMPBNK-1:0]                     t1_readB;
  output [NUMRDPT*NUMPBNK*BITADDR-1:0]             t1_addrB;
  input  [NUMRDPT*NUMPBNK*WIDTH-1:0]               t1_doutB;
  input  [NUMRDPT*NUMPBNK-1:0]                     t1_fwrdB;
  input  [NUMRDPT*NUMPBNK-1:0]                     t1_serrB;
  input  [NUMRDPT*NUMPBNK-1:0]                     t1_derrB;
  input  [NUMRDPT*NUMPBNK*(BITPADR-BITPBNK)-1:0]   t1_padrB;

  output [NUMRDPT*2*NUMPBNK-1:0]                   t2_writeA;
  output [NUMRDPT*2*NUMPBNK*BITADDR-1:0]           t2_addrA;
  output [NUMRDPT*2*NUMPBNK*2-1:0]                 t2_dinA;
  output [NUMRDPT*NUMPBNK-1:0]                     t2_readB;
  output [NUMRDPT*NUMPBNK*BITADDR-1:0]             t2_addrB;
  input  [NUMRDPT*NUMPBNK*2-1:0]                   t2_doutB;
  output [NUMRDPT*NUMPBNK-1:0]                     t2_writeB;
  output [NUMRDPT*NUMPBNK*2-1:0]                   t2_dinB;

  output                        ready;
  input                         clk;
  input                         rst;

  reg [BITADDR:0] rstaddr;
  wire rstvld = rstaddr < NUMADDR;
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg ready;
  always @(posedge clk)
    ready <= !rstvld;

  wire               ready_wire;
  wire               vwrite_wire [0:NUMWRPT-1];
  wire [BITADDR-1:0] vwraddr_wire [0:NUMWRPT-1];
  wire [WIDTH-1:0]   vdin_wire [0:NUMWRPT-1];
  wire               vread_wire [0:NUMRDPT-1];
  wire               vrdclr_wire [0:NUMRDPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMRDPT-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMWRPT-1:0] vwrite_reg;
    reg [NUMWRPT*BITADDR-1:0] vwraddr_reg;
    reg [NUMWRPT*WIDTH-1:0] vdin_reg;
    reg [NUMRDPT-1:0] vread_reg;
    reg [NUMRDPT-1:0] vrdclr_reg;
    reg [NUMRDPT*BITADDR-1:0] vrdaddr_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vwrite_reg <= vwrite & {NUMWRPT{ready}};
      vwraddr_reg <= vwraddr;
      vdin_reg <= vdin;
      vread_reg <= vread & {NUMRDPT{ready}};
      vrdclr_reg <= vread_clr;
      vrdaddr_reg <= vrdaddr;
    end

    assign ready_wire = ready_reg;
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite_reg >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr_reg >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*WIDTH);
    end
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
      assign vrdclr_wire[np2_var] = vrdclr_reg >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr_reg >> (np2_var*BITADDR);
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = (vwrite & {NUMWRPT{ready}}) >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);
    end
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = (vread & {NUMRDPT{ready}}) >> np2_var;
      assign vrdclr_wire[np2_var] = vread_clr >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);
    end
  end
  endgenerate

  reg                vwrite_reg  [0:NUMWRPT-1][0:SRAM_DELAY-1];
  reg [BITADDR-1:0]  vwraddr_reg [0:NUMWRPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]    vdin_reg    [0:NUMWRPT-1][0:SRAM_DELAY-1];

  reg                vread_reg   [0:NUMRDPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
  reg                vrdclr_reg  [0:NUMRDPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
  reg [BITADDR-1:0]  vrdaddr_reg [0:NUMRDPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
 
  integer vprt_int, vdel_int; 
  always @(posedge clk) begin
    for (vprt_int=0; vprt_int<NUMWRPT; vprt_int=vprt_int+1)
      for (vdel_int=0; vdel_int<SRAM_DELAY; vdel_int=vdel_int+1)
        if (vdel_int > 0) begin
          vwrite_reg[vprt_int][vdel_int] <= vwrite_reg[vprt_int][vdel_int-1];
          vwraddr_reg[vprt_int][vdel_int] <= vwraddr_reg[vprt_int][vdel_int-1];
          vdin_reg[vprt_int][vdel_int] <= vdin_reg[vprt_int][vdel_int-1];
        end else begin
          vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int] && (vwraddr_wire[vprt_int] < NUMADDR);
          vwraddr_reg[vprt_int][vdel_int] <= vwraddr_wire[vprt_int];
          vdin_reg[vprt_int][vdel_int] <= vdin_wire[vprt_int];
        end
    for (vprt_int=0; vprt_int<NUMRDPT; vprt_int=vprt_int+1)
      for (vdel_int=0; vdel_int<SRAM_DELAY; vdel_int=vdel_int+1)
        if (vdel_int > 0) begin
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
          vrdclr_reg[vprt_int][vdel_int] <= vrdclr_reg[vprt_int][vdel_int-1];
          vrdaddr_reg[vprt_int][vdel_int] <= vrdaddr_reg[vprt_int][vdel_int-1];
        end else begin
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
          vrdclr_reg[vprt_int][vdel_int] <= vrdclr_wire[vprt_int];
          vrdaddr_reg[vprt_int][vdel_int] <= vrdaddr_wire[vprt_int];
        end
  end 

  reg vwrite_out [0:NUMWRPT-1];
  reg [BITADDR-1:0] vwraddr_out [0:NUMWRPT-1];
  reg [WIDTH-1:0] vdin_out [0:NUMWRPT-1];
  reg vread_out [0:NUMRDPT-1];
  reg vrdclr_out [0:NUMRDPT-1];
  reg [BITADDR-1:0] vrdaddr_out [0:NUMRDPT-1];
  integer vout_int, vwpt_int;
  always_comb begin
    for (vout_int=0; vout_int<NUMWRPT; vout_int=vout_int+1) begin
      vwrite_out[vout_int] = vwrite_reg[vout_int][SRAM_DELAY-1];
      vwraddr_out[vout_int] = vwraddr_reg[vout_int][SRAM_DELAY-1];
      vdin_out[vout_int] = vdin_reg[vout_int][SRAM_DELAY-1];
    end
    for (vout_int=0; vout_int<NUMRDPT; vout_int=vout_int+1) begin
      vread_out[vout_int] = vread_reg[vout_int][SRAM_DELAY-1];
      vrdclr_out[vout_int] = vrdclr_reg[vout_int][SRAM_DELAY-1];
      vrdaddr_out[vout_int] = vrdaddr_reg[vout_int][SRAM_DELAY-1];
    end
  end

  reg             rddat_vld     [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0] rddat_reg     [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg             rddat_vld_nxt [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0] rddat_reg_nxt [0:NUMRDPT-1][0:SRAM_DELAY-1];

  integer ra_int, sa_int;
  always @(posedge clk) begin
    for (ra_int=0; ra_int<NUMRDPT; ra_int=ra_int+1) begin
      for (sa_int=0;sa_int<SRAM_DELAY;sa_int=sa_int+1) begin
        rddat_vld[ra_int][sa_int] <= rddat_vld_nxt[ra_int][sa_int];
        rddat_reg[ra_int][sa_int] <= rddat_reg_nxt[ra_int][sa_int];
      end
    end
  end

  integer rfwd_int, wp_int, pp_int, rp_int;
  always_comb begin
    for (rp_int=0; rp_int<NUMRDPT; rp_int=rp_int+1) begin
      for (rfwd_int=0;rfwd_int<SRAM_DELAY;rfwd_int=rfwd_int+1) begin
        if (rfwd_int>0) begin
          rddat_vld_nxt[rp_int][rfwd_int] = rddat_vld[rp_int][rfwd_int-1];
          rddat_reg_nxt[rp_int][rfwd_int] = rddat_reg[rp_int][rfwd_int-1];
          for (wp_int=0;wp_int<NUMWRPT;wp_int=wp_int+1)
            if (vwrite_out[wp_int] && (vrdaddr_reg[rp_int][rfwd_int-1] == vwraddr_out[wp_int])) begin
              rddat_vld_nxt[rp_int][rfwd_int] = 1'b1;
              rddat_reg_nxt[rp_int][rfwd_int] = vdin_out[wp_int];
            end
        end else begin
          rddat_vld_nxt[rp_int][rfwd_int] = 1'b0;
          rddat_reg_nxt[rp_int][rfwd_int] = 0;
          for (wp_int=0;wp_int<NUMWRPT;wp_int=wp_int+1)
            if (vwrite_out[wp_int] && (vrdaddr_wire[rp_int] == vwraddr_out[wp_int])) begin
              rddat_vld_nxt[rp_int][rfwd_int] = 1'b1;
              rddat_reg_nxt[rp_int][rfwd_int] = vdin_out[wp_int];
            end
        end
      end
    end 
  end   
/*
  wire vwrite_out_0 = vwrite_out[0];
  wire [BITADDR-1:0] vwraddr_out_0 = vwraddr_out[0];
  wire [WIDTH-1:0] vdin_out_0 = vdin_out[0];

  wire vwrite_wire_0 = vwrite_wire[0];
  wire [BITADDR-1:0] vwraddr_wire_0 = vwraddr_wire[0];
  wire [WIDTH-1:0] vdin_wire_0 = vdin_wire[0];

  wire vread_out_0 = vread_out[0];
  wire [BITADDR-1:0] vrdaddr_out_0 = vrdaddr_out[0];
*/
//  reg pread_wire [0:NUMRDPT-1];
//  reg [BITPBNK-1:0] prdbadr_wire [0:NUMRDPT-1];
//  reg [BITADDR-1:0] prdaddr_wire [0:NUMRDPT-1];

  reg pwrite_wire [0:NUMWRPT-1];
//  reg [BITPBNK-1:0] pwrbadr_wire [0:NUMWRPT-1];
  reg [BITADDR-1:0] pwraddr_wire [0:NUMWRPT-1];
  reg [WIDTH-1:0] pdin_wire [0:NUMWRPT-1];
/*
  wire pread_wire_0 = pread_wire[0];
  wire [BITPBNK-1:0] prdbadr_wire_0 = prdbadr_wire[0];
  wire [BITADDR-1:0] prdaddr_wire_0 = prdaddr_wire[0];

  wire pwrite_wire_0 = pwrite_wire[0];
  wire [BITPBNK-1:0] pwrbadr_wire_0 = pwrbadr_wire[0];
  wire [BITADDR-1:0] pwraddr_wire_0 = pwraddr_wire[0];
  wire [WIDTH-1:0] pdin_wire_0 = pdin_wire[0];

  wire pwrite_wire_1 = pwrite_wire[1];
  wire [BITPBNK-1:0] pwrbadr_wire_1 = pwrbadr_wire[1];
  wire [BITADDR-1:0] pwraddr_wire_0 = pwraddr_wire[1];
  wire [WIDTH-1:0] pdin_wire_1 = pdin_wire[1];

  wire pwrite_wire_2 = pwrite_wire[2];
  wire [BITPBNK-1:0] pwrbadr_wire_2 = pwrbadr_wire[2];
  wire [BITADDR-1:0] pwraddr_wire_2 = pwraddr_wire[2];
  wire [WIDTH-1:0] pdin_wire_2 = pdin_wire[2];
*/
  // Read request of mapping information on SRAM memory
  reg swrite_wire [0:NUMRDPT+NUMWRPT-1];
  reg [BITPBNK-1:0] swrbadr_wire [0:NUMRDPT+NUMWRPT-1];
  reg [BITADDR-1:0] swraddr_wire [0:NUMRDPT+NUMWRPT-1];
  reg sdin_wire [0:NUMRDPT+NUMWRPT-1];
/*
  wire swrite_wire_0 = swrite_wire[0];
  wire [BITPBNK-1:0] swrbadr_wire_0 = swrbadr_wire[0];
  wire [BITADDR-1:0] swraddr_wire_0 = swraddr_wire[0];
  wire sdin_wire_0 = sdin_wire[0];

  wire swrite_wire_1 = swrite_wire[1];
  wire [BITPBNK-1:0] swrbadr_wire_1 = swrbadr_wire[1];
  wire [BITADDR-1:0] swraddr_wire_1 = swraddr_wire[1];
  wire sdin_wire_1 = sdin_wire[1];

  wire swrite_wire_2 = swrite_wire[2];
  wire [BITPBNK-1:0] swrbadr_wire_2 = swrbadr_wire[2];
  wire [BITADDR-1:0] swraddr_wire_2 = swraddr_wire[2];
  wire sdin_wire_2 = sdin_wire[2];

  wire swrite_wire_3 = swrite_wire[3];
  wire [BITPBNK-1:0] swrbadr_wire_3 = swrbadr_wire[3];
  wire [BITADDR-1:0] swraddr_wire_3 = swraddr_wire[3];
  wire sdin_wire_3 = sdin_wire[3];

  wire swrite_wire_4 = swrite_wire[4];
  wire [BITPBNK-1:0] swrbadr_wire_4 = swrbadr_wire[4];
  wire [BITADDR-1:0] swraddr_wire_4 = swraddr_wire[4];
  wire sdin_wire_4 = sdin_wire[4];

  wire swrite_wire_5 = swrite_wire[5];
  wire [BITPBNK-1:0] swrbadr_wire_5 = swrbadr_wire[5];
  wire [BITADDR-1:0] swraddr_wire_5 = swraddr_wire[5];
  wire sdin_wire_5 = sdin_wire[5];
*/
  reg sread_wire [0:NUMRDPT-1];
  reg [BITADDR-1:0] srdaddr_wire [0:NUMRDPT-1];
  integer srdp_int, srdc_int, srdw_int;
  always_comb begin
    for (srdp_int=0; srdp_int<NUMRDPT; srdp_int=srdp_int+1) begin
      sread_wire[srdp_int] = vread_wire[srdp_int];
      srdaddr_wire[srdp_int] = vrdaddr_wire[srdp_int];
    end
  end
/*
  wire sread_wire_0 = sread_wire[0];
  wire [BITADDR-1:0] srdaddr_wire_0 = srdaddr_wire[0];
  wire sread_wire_1 = sread_wire[1];
  wire [BITADDR-1:0] srdaddr_wire_1 = srdaddr_wire[1];
  wire sread_wire_2 = sread_wire[2];
  wire [BITADDR-1:0] srdaddr_wire_2 = srdaddr_wire[2];
*/
  reg [2*NUMPBNK-1:0] map_vld [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg [2*NUMPBNK-1:0] map_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  genvar sprt_int, sfwd_int;
  generate
    for (sfwd_int=0; sfwd_int<SRAM_DELAY; sfwd_int=sfwd_int+1) begin: map_loop
      for (sprt_int=0; sprt_int<NUMRDPT; sprt_int=sprt_int+1) begin: prt_loop
        reg [BITADDR-1:0] vaddr_temp;
        reg [2*NUMPBNK-1:0] map_vld_next;
        reg [2*NUMPBNK-1:0] map_reg_next;
        always_comb begin
          integer swpt_int;
          if (sfwd_int>0) begin
            vaddr_temp = vrdaddr_reg[sprt_int][sfwd_int-1];
            map_vld_next = map_vld[sprt_int][sfwd_int-1];
            map_reg_next = map_reg[sprt_int][sfwd_int-1];
          end else begin
            vaddr_temp = vrdaddr_wire[sprt_int];
            map_vld_next = 0;
            map_reg_next = 0;
          end
          for (swpt_int=0; swpt_int<NUMRDPT+NUMWRPT; swpt_int=swpt_int+1)
            if (swrite_wire[swpt_int] && (swraddr_wire[swpt_int] == vaddr_temp)) begin
              map_vld_next = map_vld_next | (2'b11 << (2*swrbadr_wire[swpt_int]));
              map_reg_next = map_reg_next | ({2{sdin_wire[swpt_int]}} << (2*swrbadr_wire[swpt_int]));
            end
        end

        always @(posedge clk) begin
          map_vld[sprt_int][sfwd_int] <= map_vld_next;
          map_reg[sprt_int][sfwd_int] <= map_reg_next;
        end
      end
    end
  endgenerate

// ECC Checking Module for SRAM
  reg [2*NUMPBNK-1:0] sdout_wire [0:NUMRDPT-1];
  integer sdo_int;
  always_comb
    for (sdo_int=0; sdo_int<NUMRDPT; sdo_int=sdo_int+1)
      sdout_wire[sdo_int] = t2_doutB >> (sdo_int*2*NUMPBNK);

  reg [2*NUMPBNK-1:0] map_out [0:NUMRDPT-1];
  integer fprt_int;
  always_comb
    for (fprt_int=0; fprt_int<NUMRDPT; fprt_int=fprt_int+1) 
      map_out[fprt_int] = (map_vld[fprt_int][SRAM_DELAY-1] & map_reg[fprt_int][SRAM_DELAY-1]) |
                          (~map_vld[fprt_int][SRAM_DELAY-1] & sdout_wire[fprt_int]);

  reg [1:0] map_wire [0:NUMRDPT-1][0:NUMPBNK-1];
  integer mapp_int, mapb_int;
  always_comb
    for (mapp_int=0; mapp_int<NUMRDPT; mapp_int=mapp_int+1)
      for (mapb_int=0; mapb_int<NUMPBNK; mapb_int=mapb_int+1)
        map_wire[mapp_int][mapb_int] = map_out[mapp_int] >> ((mapp_int*NUMPBNK+mapb_int)*2);

  reg [BITPBNK-1:0] bnk_out [0:NUMRDPT-1];
  reg serr_out [0:NUMRDPT-1];
  reg derr_out [0:NUMRDPT-1];
  reg svld_flg [0:NUMRDPT-1];
  reg dvld_flg [0:NUMRDPT-1];
  integer bnkp_int, bnkb_int;
  always_comb
    for (bnkp_int=0; bnkp_int<NUMRDPT; bnkp_int=bnkp_int+1) begin
      bnk_out[bnkp_int] = 0;
      svld_flg[bnkp_int] = 1'b0;
      dvld_flg[bnkp_int] = 1'b0;
      serr_out[bnkp_int] = 1'b0;
      derr_out[bnkp_int] = 1'b1;
      for (bnkb_int=0; bnkb_int<NUMPBNK; bnkb_int=bnkb_int+1)
        if (^map_wire[bnkp_int][bnkb_int]) begin
          bnk_out[bnkp_int] = bnkb_int;
          if (svld_flg[bnkp_int]) begin
            serr_out[bnkp_int] = 1'b0;
            derr_out[bnkp_int] = 1'b1;
          end
          if (!svld_flg[bnkp_int]) begin
            serr_out[bnkp_int] = 1'b1;
            derr_out[bnkp_int] = 1'b0;
          end
          svld_flg[bnkp_int] = 1'b1;
        end 
      for (bnkb_int=0; bnkb_int<NUMPBNK; bnkb_int=bnkb_int+1)
        if (&map_wire[bnkp_int][bnkb_int]) begin
          bnk_out[bnkp_int] = bnkb_int;
          if (svld_flg[bnkp_int]) begin
            serr_out[bnkp_int] = 1'b1;
            derr_out[bnkp_int] = 1'b0;
          end
          if (dvld_flg[bnkp_int]) begin
            serr_out[bnkp_int] = 1'b0;
            derr_out[bnkp_int] = 1'b1;
          end
          if (!svld_flg[bnkp_int] && !dvld_flg[bnkp_int]) begin
            serr_out[bnkp_int] = 1'b0;
            derr_out[bnkp_int] = 1'b0;
          end
          dvld_flg[bnkp_int] = 1'b1;
        end
    end
/*
  wire [2*NUMPBNK-1:0] map_out_0 = map_out[0];
  wire [BITPBNK-1:0] bnk_out_0 = bnk_out[0];
*/
  reg vread_vld_wire [0:NUMRDPT-1];
  reg [WIDTH-1:0] vdout_wire [0:NUMRDPT-1];
  reg vread_fwrd_wire [0:NUMRDPT-1];
  reg vread_serr_wire [0:NUMRDPT-1];
  reg vread_derr_wire [0:NUMRDPT-1];
  reg [BITPADR-BITPBNK-1:0] vread_padr_help [0:NUMRDPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:NUMRDPT-1];
  integer vdop_int;
  always_comb
    for (vdop_int=0; vdop_int<NUMRDPT; vdop_int=vdop_int+1) begin
      vread_vld_wire[vdop_int] = vread_out[vdop_int];
      vdout_wire[vdop_int] = (rddat_vld[vdop_int][SRAM_DELAY-1] ? rddat_reg[vdop_int][SRAM_DELAY-1] : t1_doutB >> ((vdop_int*NUMPBNK+bnk_out[vdop_int])*WIDTH));
      vread_fwrd_wire[vdop_int] = rddat_vld[vdop_int][SRAM_DELAY-1];// || (t1_fwrdB >> (vdop_int*NUMPBNK+bnk_out[vdop_int]));
//    TBD derr/serr should be set based on t1_serr/derr also should the algo
//    support word ECC.
//      vread_serr_wire[vdop_int] = t1_serrA >> (vdop_int*NUMPBNK+prdbadr_reg[vdop_int][DRAM_DELAY-1]);
//      vread_derr_wire[vdop_int] = t1_derrA >> (vdop_int*NUMPBNK+prdbadr_reg[vdop_int][DRAM_DELAY-1]);
      vread_serr_wire[vdop_int] = rddat_vld[vdop_int][SRAM_DELAY-1] ? 1'b0 : serr_out[vdop_int];
      vread_derr_wire[vdop_int] = rddat_vld[vdop_int][SRAM_DELAY-1] ? 1'b0 : derr_out[vdop_int];
      vread_padr_help[vdop_int] = t1_padrB >> ((vdop_int*NUMPBNK+bnk_out[vdop_int])*(BITPADR-BITPBNK));
      vread_padr_wire[vdop_int] = {bnk_out[vdop_int],vread_padr_help[vdop_int]};
    end

  reg [NUMRDPT-1:0] vread_vld_tmp;
  reg [NUMRDPT-1:0] vread_fwrd_tmp;
  reg [NUMRDPT-1:0] vread_serr_tmp;
  reg [NUMRDPT-1:0] vread_derr_tmp;
  reg [NUMRDPT*BITPADR-1:0] vread_padr_tmp;
  reg [NUMRDPT*WIDTH-1:0] vdout_tmp;
  integer vdo_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_fwrd_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    for (vdo_int=0; vdo_int<NUMRDPT; vdo_int=vdo_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_vld_wire[vdo_int] << vdo_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vdo_int] << (vdo_int*WIDTH));
      vread_fwrd_tmp = vread_fwrd_tmp | (vread_fwrd_wire[vdo_int] << vdo_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vdo_int] << vdo_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vdo_int] << vdo_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vdo_int] << (vdo_int*BITPADR));
    end
  end

  reg [NUMRDPT-1:0] vread_vld;
  reg [NUMRDPT-1:0] vread_fwrd;
  reg [NUMRDPT-1:0] vread_serr;
  reg [NUMRDPT-1:0] vread_derr;
  reg [NUMRDPT*BITPADR-1:0] vread_padr;
  reg [NUMRDPT*WIDTH-1:0] vdout;
  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      vread_vld <= vread_vld_tmp;
      vdout <= vdout_tmp;
      vread_fwrd <= vread_fwrd_tmp;
      vread_serr <= vread_serr_tmp;
      vread_derr <= vread_derr_tmp;
      vread_padr <= vread_padr_tmp;
    end
  end else begin: nflp_loop
    always_comb begin
      vread_vld = vread_vld_tmp;
      vdout = vdout_tmp;
      vread_fwrd = vread_fwrd_tmp;
      vread_serr = vread_serr_tmp;
      vread_derr = vread_derr_tmp;
      vread_padr = vread_padr_tmp;
    end
  end
  endgenerate
/*
  reg [NUMPBNK-1:0] used_pivot_temp [0:NUMWRPT-1];
  reg [NUMPBNK-1:0] used_pivot [0:NUMWRPT-1];
  reg               new_vld [0:NUMWRPT-1];
  reg [BITPBNK-1:0] new_pos [0:NUMWRPT-1];
  integer newp_int, newx_int;
  always_comb
    for (newp_int=0; newp_int<NUMWRPT; newp_int=newp_int+1) begin
      new_vld[newp_int] = 1'b0;
      new_pos[newp_int] = 0;
      if (vwrite_out[newp_int])
        for (newx_int=NUMPBNK-1; newx_int>=0; newx_int=newx_int-1)
          if (!used_pivot_temp[newp_int][newx_int]) begin
            new_vld[newp_int] = 1'b1;
            new_pos[newp_int] = newx_int;
          end
    end

  integer usei_int;
  reg [NUMPBNK-1:0] used_pivot_init;
  always_comb begin
    used_pivot_init = 0;
    for (usei_int=0; usei_int<NUMRDPT; usei_int=usei_int+1)
      if (vread_out[usei_int])
        used_pivot_init = used_pivot_init | (1'b1 << bnk_out[usei_int]);
  end

  integer usep_int;
  always_comb
    for (usep_int=0; usep_int<NUMWRPT; usep_int=usep_int+1) begin
      if (usep_int>0)
        used_pivot_temp[usep_int] = used_pivot[usep_int-1];
      else
        used_pivot_temp[usep_int] = used_pivot_init;
      used_pivot[usep_int] = used_pivot_temp[usep_int];
      if (new_vld[usep_int])
        used_pivot[usep_int] = used_pivot[usep_int] | (1'b1 << new_pos[usep_int]);
    end

  wire [NUMPBNK-1:0] used_pivot_temp_0 = used_pivot_temp[0];
  wire [NUMPBNK-1:0] used_pivot_0 = used_pivot[0];
  wire [NUMPBNK-1:0] used_pivot_temp_1 = used_pivot_temp[1];
  wire [NUMPBNK-1:0] used_pivot_1 = used_pivot[1];

  integer prdw_int, prdb_int;
  always_comb
    for (prdw_int=0; prdw_int<NUMRDPT; prdw_int=prdw_int+1) begin
      pread_wire[prdw_int] = vread_wire[prdw_int];
      prdbadr_wire[prdw_int] = bnk_out[prdw_int];
      prdaddr_wire[prdw_int] = vrdaddr_out[prdw_int];
    end
     
  integer prdp_int, prdd_int, prdf_int;
  always @(posedge clk)
    for (prdp_int=0; prdp_int<NUMRDPT; prdp_int=prdp_int+1)
      for (prdd_int=0; prdd_int<DRAM_DELAY; prdd_int=prdd_int+1)
        if (prdd_int>0) begin
          prdbadr_reg[prdp_int][prdd_int] <= prdbadr_reg[prdp_int][prdd_int-1];
          prdserr_reg[prdp_int][prdd_int] <= prdserr_reg[prdp_int][prdd_int-1];
          prdderr_reg[prdp_int][prdd_int] <= prdderr_reg[prdp_int][prdd_int-1];
        end else begin
          prdbadr_reg[prdp_int][prdd_int] <= prdbadr_wire[prdp_int];
          prdserr_reg[prdp_int][prdd_int] <= serr_out[prdp_int];
          prdderr_reg[prdp_int][prdd_int] <= derr_out[prdp_int];
        end

  wire new_vld_0 = new_vld[0];
  wire [BITPBNK-1:0] new_pos_0 = new_pos[0];
  wire new_vld_1 = new_vld[1];
  wire [BITPBNK-1:0] new_pos_1 = new_pos[1];

  wire new_vld_1 = new_vld[1];
  wire [BITPBNK-1:0] new_pos_1 = new_pos[1];
*/

  integer pwrp_int;
  always_comb
    for (pwrp_int=0; pwrp_int<NUMWRPT; pwrp_int=pwrp_int+1) begin
      pwrite_wire[pwrp_int]  = vwrite_out[pwrp_int];
      pwraddr_wire[pwrp_int] = vwraddr_out[pwrp_int];
      pdin_wire[pwrp_int]    = vdin_out[pwrp_int];
    end

  reg [NUMRDPT*2*NUMPBNK-1:0] t1_writeA;
  reg [NUMRDPT*2*NUMPBNK*BITADDR-1:0] t1_addrA;
  reg [NUMRDPT*2*NUMPBNK*WIDTH-1:0] t1_dinA;
  reg [NUMRDPT*NUMPBNK-1:0] t1_readB;
  reg [NUMRDPT*NUMPBNK*BITADDR-1:0] t1_addrB;
  integer t1w_int, t1wa_int, t1wb_int, t1r_int, t1ra_int, t1rb_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
      for (t1w_int=0; t1w_int<NUMWRPT; t1w_int=t1w_int+1) begin
        if (pwrite_wire[t1w_int])
          t1_writeA = t1_writeA | (1'b1 << (t1r_int*NUMWRPT+t1w_int));
        for (t1wa_int=0; t1wa_int<BITADDR; t1wa_int=t1wa_int+1)
          t1_addrA[(t1r_int*NUMWRPT+t1w_int)*BITADDR+t1wa_int] = pwraddr_wire[t1w_int][t1wa_int];
        for (t1wb_int=0; t1wb_int<WIDTH; t1wb_int=t1wb_int+1)
          t1_dinA[(t1r_int*NUMWRPT+t1w_int)*WIDTH+t1wb_int] = pdin_wire[t1w_int][t1wb_int];
      end
    end
    t1_readB = 0;
    t1_addrB = 0;
    for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
      for (t1rb_int=0; t1rb_int<NUMPBNK; t1rb_int=t1rb_int+1) begin
        if (vread_wire[t1r_int]) 
          t1_readB = t1_readB | (1'b1 << (t1r_int*NUMPBNK+t1rb_int));
        for (t1ra_int=0; t1ra_int<BITADDR; t1ra_int=t1ra_int+1)
          t1_addrB[(t1r_int*NUMPBNK+t1rb_int)*BITADDR+t1ra_int] = vrdaddr_wire[t1r_int][t1ra_int];
      end
    end
  end

  always_comb begin
    integer swrp_int, swrx_int;
    for (swrp_int=0; swrp_int<NUMRDPT; swrp_int=swrp_int+1) 
/*      if (rstvld & !rst) begin
        swrite_wire[swrp_int] = 1'b1;
        swrbadr_wire[swrp_int] = swrp_int;
        swraddr_wire[swrp_int] = rstaddr;
        sdin_wire[swrp_int] = 1'b0;
      end else*/ if (vread_out[swrp_int] && vrdclr_out[swrp_int]) begin
        swrite_wire[swrp_int] = 1'b1;
        swrbadr_wire[swrp_int] = bnk_out[swrp_int];
        swraddr_wire[swrp_int] = vrdaddr_out[swrp_int];
        sdin_wire[swrp_int] = 1'b0;
      end else begin
        swrite_wire[swrp_int] = 1'b0;
        swrbadr_wire[swrp_int] = 0;
        swraddr_wire[swrp_int] = 0;
        sdin_wire[swrp_int] = 1'b0;
      end
    for (swrp_int=NUMRDPT; swrp_int<NUMRDPT+NUMWRPT; swrp_int=swrp_int+1) 
      if (rstvld & !rst) begin
        swrite_wire[swrp_int] = 1'b1;
        swrbadr_wire[swrp_int] = swrp_int-1;
        swraddr_wire[swrp_int] = rstaddr;
        sdin_wire[swrp_int] = 1'b0;
      end else if (vwrite_out[swrp_int-NUMRDPT]) begin
        swrite_wire[swrp_int] = 1'b1;
        swrbadr_wire[swrp_int] = (swrp_int-1) >> 1;
        swraddr_wire[swrp_int] = vwraddr_out[swrp_int-NUMRDPT];
        sdin_wire[swrp_int] = 1'b1;
      end else begin
        swrite_wire[swrp_int] = 1'b0;
        swrbadr_wire[swrp_int] = 0;
        swraddr_wire[swrp_int] = 0;
        sdin_wire[swrp_int] = 1'b0;
      end
    for (swrp_int=0; swrp_int<NUMRDPT; swrp_int=swrp_int+1)
      for (swrx_int=NUMRDPT; swrx_int<NUMRDPT+NUMWRPT; swrx_int=swrx_int+1)
        if (swrite_wire[swrx_int] && (swrbadr_wire[swrp_int] == swrbadr_wire[swrx_int]) && (swraddr_wire[swrp_int] == swraddr_wire[swrx_int]))
          swrite_wire[swrp_int] = 1'b0;
  end

  reg [NUMRDPT*2*NUMPBNK-1:0]         t2_writeA;
  reg [NUMRDPT*2*NUMPBNK*BITADDR-1:0] t2_addrA;
  reg [NUMRDPT*2*NUMPBNK*2-1:0]       t2_dinA;
  reg [NUMRDPT*NUMPBNK-1:0]           t2_readB;
  reg [NUMRDPT*NUMPBNK-1:0]           t2_writeB;
  reg [NUMRDPT*NUMPBNK*BITADDR-1:0]   t2_addrB;
  reg [NUMRDPT*NUMPBNK*2-1:0]         t2_dinB;
  integer smcp_int, smcb_int;
  always_comb begin
    t2_writeA = 0;
    t2_addrA = 0;
    t2_dinA = 0;
    t2_readB = 0;
    t2_addrB = 0;
    t2_writeB = 0;
    t2_dinB = 0;
    for (smcp_int=0; smcp_int<NUMRDPT; smcp_int=smcp_int+1)
      for (smcb_int=0; smcb_int<NUMPBNK; smcb_int=smcb_int+1)
        if (sread_wire[smcp_int]) begin
          t2_readB = t2_readB | (1'b1 << (smcp_int*NUMPBNK+smcb_int));
          t2_addrB = t2_addrB | (srdaddr_wire[smcp_int] << ((smcp_int*NUMPBNK+smcb_int)*BITADDR));
        end
    for (smcp_int=0; smcp_int<NUMRDPT; smcp_int=smcp_int+1)
      if (swrite_wire[smcp_int]) begin
        t2_writeB = t2_writeB | (1'b1 << (smcp_int*NUMPBNK+swrbadr_wire[smcp_int])); // should be NUMPBNK*2
        t2_dinB = t2_dinB | ({2{sdin_wire[smcp_int]}} << ((smcp_int*NUMPBNK+swrbadr_wire[smcp_int])*2));
      end
    for (smcp_int=0; smcp_int<NUMRDPT; smcp_int=smcp_int+1)
      for (smcb_int=1; smcb_int<NUMRDPT+NUMWRPT; smcb_int=smcb_int+1)
        if (swrite_wire[smcb_int]) begin
          t2_writeA = t2_writeA | (1'b1 << ((smcp_int*NUMPBNK)+(smcb_int-1)));
          t2_addrA = t2_addrA | (swraddr_wire[smcb_int] << ((smcp_int*NUMPBNK)+(smcb_int-1))*BITADDR);
          t2_dinA = t2_dinA | ({2{sdin_wire[smcb_int]}} << ((smcp_int*NUMPBNK)+(smcb_int-1))*2);
        end
  end

endmodule

