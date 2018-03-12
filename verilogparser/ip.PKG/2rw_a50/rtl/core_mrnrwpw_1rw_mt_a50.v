
module core_mrnrwpw_1rw_mt_a50 (vrefr, vread, vwrite, vaddr, vdin, vread_vld, vdout, vread_serr, vread_derr, vread_padr,
                            prefr, pwrite, pwrbadr, pwrradr, pdin,
                            pread, prdbadr, prdradr, pdout, pdout_serr, pdout_derr, pdout_padr,
   	                    swrite, swrradr, sdin,
                            sread, srdradr, sdout,
                            ready, clk, rst,
	                    select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 2;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMPBNK = 11;
  parameter BITPBNK = 4;
  parameter BITPADR = 15;
  
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter REFRESH = 0;
  parameter ECCBITS = 8;

  parameter BITMAPT = BITPBNK*NUMPBNK;
  parameter SDOUT_WIDTH = 2*BITMAPT+ECCBITS;

  input                                           vrefr;

  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]           vread;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]           vwrite;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITADDR-1:0]   vaddr;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]     vdin;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]          vread_vld;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]    vdout;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]          vread_serr;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]          vread_derr;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0]  vread_padr;

  output                                       prefr;

  output [(NUMRWPT+NUMWRPT)-1:0]               pwrite;
  output [(NUMRWPT+NUMWRPT)*BITPBNK-1:0]       pwrbadr;
  output [(NUMRWPT+NUMWRPT)*BITVROW-1:0]       pwrradr;
  output [(NUMRWPT+NUMWRPT)*WIDTH-1:0]         pdin;

  output [(NUMRDPT+NUMRWPT)-1:0]               pread;
  output [(NUMRDPT+NUMRWPT)*BITPBNK-1:0]       prdbadr;
  output [(NUMRDPT+NUMRWPT)*BITVROW-1:0]       prdradr;
  input [(NUMRDPT+NUMRWPT)*WIDTH-1:0]          pdout;
  output [(NUMRDPT+NUMRWPT)-1:0]               pdout_serr;
  output [(NUMRDPT+NUMRWPT)-1:0]               pdout_derr;
  input [(NUMRDPT+NUMRWPT)*(BITPADR-1)-1:0]    pdout_padr;

  output [(NUMRWPT+NUMWRPT-!NUMRDPT)-1:0]               swrite;
  output [(NUMRWPT+NUMWRPT-!NUMRDPT)*BITVROW-1:0]       swrradr;
  output [(NUMRWPT+NUMWRPT-!NUMRDPT)*SDOUT_WIDTH-1:0]   sdin;

  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]               sread;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0]       srdradr;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0]    sdout;
  
  output                             ready;
  input                              clk;
  input                              rst;

  input [BITADDR-1:0]                select_addr;
  input [BITWDTH-1:0]                select_bit;

  reg [BITVROW:0] rstaddr;
  wire rstvld = rstaddr < NUMVROW;
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg [BITMAPT-1:0] rstdin;
  integer rst_int;
  always_comb begin
    rstdin = 0;
    for (rst_int=0; rst_int<NUMPBNK; rst_int=rst_int+1)
      rstdin = rstdin | (rst_int << (rst_int*BITPBNK));
  end

  reg ready;
  always @(posedge clk)
    ready <= !rstvld;

  wire [BITVBNK-1:0] select_bank;
  wire [BITVROW-1:0] select_row;
  np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
             .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
             .NUMVROW (NUMVROW), .BITVROW (BITVROW))
    sel_adr (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));
  
  wire               ready_wire;
  wire               vrefr_wire;
  wire               vread_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  wire               vwrite_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  wire [BITADDR-1:0] vaddr_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  wire [BITVBNK-1:0] vbadr_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  wire [BITVROW-1:0] vradr_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  wire [WIDTH-1:0]   vdin_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg vrefr_reg;
    reg [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] vread_reg;
    reg [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] vwrite_reg;
    reg [(NUMRDPT+NUMRWPT+NUMWRPT)*BITADDR-1:0] vaddr_reg;
    reg [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vrefr_reg <= vrefr;
      vread_reg <= vread & {(NUMRDPT+NUMRWPT+NUMWRPT){ready}};
      vwrite_reg <= vwrite & {(NUMRDPT+NUMRWPT+NUMWRPT){ready}};
      vaddr_reg <= vaddr;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    assign vrefr_wire = vrefr_reg;
    for (np2_var=0; np2_var<NUMRDPT+NUMRWPT+NUMWRPT; np2_var=np2_var+1) begin: np2_loop
      assign vread_wire[np2_var] = (np2_var<(NUMRDPT+NUMRWPT)) ? vread_reg >> np2_var : 1'b0;
      assign vwrite_wire[np2_var] = (np2_var<NUMRDPT) ? 1'b0 : vwrite_reg >> np2_var;
      assign vaddr_wire[np2_var] = vaddr_reg >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = (np2_var<NUMRDPT) ? 0 : vdin_reg >> (np2_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rw_adr_inst (.vbadr(vbadr_wire[np2_var]), .vradr(vradr_wire[np2_var]), .vaddr(vaddr_wire[np2_var]));
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    assign vrefr_wire = vrefr;
    for (np2_var=0; np2_var<NUMRDPT+NUMRWPT+NUMWRPT; np2_var=np2_var+1) begin: np2_loop
      assign vread_wire[np2_var] = (np2_var<(NUMRDPT+NUMRWPT)) ? vread >> np2_var : 1'b0;
      assign vwrite_wire[np2_var] = (np2_var<NUMRDPT) ? 1'b0 : vwrite >> np2_var;
      assign vaddr_wire[np2_var] = vaddr >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = (np2_var<NUMRDPT) ? 0 : vdin >> (np2_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rw_adr_inst (.vbadr(vbadr_wire[np2_var]), .vradr(vradr_wire[np2_var]), .vaddr(vaddr_wire[np2_var]));
    end
  end
  endgenerate

  reg                vrefr_reg [0:SRAM_DELAY+DRAM_DELAY-1];
  reg                vread_reg [0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
  reg                vwrite_reg [0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
  reg [BITVBNK-1:0]  vbadr_reg [0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
  reg [BITVROW-1:0]  vradr_reg [0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
  reg [WIDTH-1:0]    vdin_reg [0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
 
  integer vprt_int, vdel_int; 
  always @(posedge clk) 
    for (vprt_int=0; vprt_int<NUMRDPT+NUMRWPT+NUMWRPT; vprt_int=vprt_int+1)
      for (vdel_int=0; vdel_int<SRAM_DELAY+DRAM_DELAY; vdel_int=vdel_int+1)
        if (vdel_int > 0) begin
          if (vprt_int==0) begin
            vrefr_reg[vdel_int] <= vrefr_reg[vdel_int-1];
          end
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
          vwrite_reg[vprt_int][vdel_int] <= vwrite_reg[vprt_int][vdel_int-1];
          vbadr_reg[vprt_int][vdel_int] <= vbadr_reg[vprt_int][vdel_int-1];
          vradr_reg[vprt_int][vdel_int] <= vradr_reg[vprt_int][vdel_int-1];
          vdin_reg[vprt_int][vdel_int] <= vdin_reg[vprt_int][vdel_int-1];
        end else begin
          if (vprt_int==0) begin
            vrefr_reg[vdel_int] <= vrefr_wire || !ready_wire;
          end
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
          vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int];
          vbadr_reg[vprt_int][vdel_int] <= vbadr_wire[vprt_int];
          vradr_reg[vprt_int][vdel_int] <= vradr_wire[vprt_int];
          vdin_reg[vprt_int][vdel_int] <= vdin_wire[vprt_int];
        end

  reg vrefr_out;
  reg vread_out [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg vwrite_out [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg [BITVBNK-1:0] vbadr_out [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg [BITVROW-1:0] vradr_out [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg [WIDTH-1:0] vdin_out [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  integer vout_int, vwpt_int;
  always_comb begin
    vrefr_out = vrefr_reg[SRAM_DELAY-1];
    for (vout_int=0; vout_int<NUMRDPT+NUMRWPT+NUMWRPT; vout_int=vout_int+1) begin
      vread_out[vout_int] = vread_reg[vout_int][SRAM_DELAY-1];
      vwrite_out[vout_int] = vwrite_reg[vout_int][SRAM_DELAY-1];
      for (vwpt_int=vout_int+1; vwpt_int<NUMRDPT+NUMRWPT+NUMWRPT; vwpt_int=vwpt_int+1)
        vwrite_out[vout_int] = vwrite_out[vout_int] && !(vwrite_reg[vwpt_int][SRAM_DELAY-1] &&
							 (vbadr_reg[vwpt_int][SRAM_DELAY-1] == vbadr_reg[vout_int][SRAM_DELAY-1]) &&
							 (vradr_reg[vwpt_int][SRAM_DELAY-1] == vradr_reg[vout_int][SRAM_DELAY-1])); 
      vbadr_out[vout_int] = vbadr_reg[vout_int][SRAM_DELAY-1];
      vradr_out[vout_int] = vradr_reg[vout_int][SRAM_DELAY-1];
      vdin_out[vout_int] = vdin_reg[vout_int][SRAM_DELAY-1];
    end
  end
/*
  wire vread_out_wire_0 = vread_out[0];
  wire vwrite_out_wire_0 = vwrite_out[0];
  wire [BITVBNK-1:0] vbadr_out_wire_0 = vbadr_out[0];
  wire [BITVROW-1:0] vradr_out_wire_0 = vradr_out[0];
  wire vread_out_wire_1 = vread_out[1];
  wire vwrite_out_wire_1 = vwrite_out[1];
  wire [BITVBNK-1:0] vbadr_out_wire_1 = vbadr_out[1];
  wire [BITVROW-1:0] vradr_out_wire_1 = vradr_out[1];
  wire vread_out_wire_2 = vread_out[2];
  wire vwrite_out_wire_2 = vwrite_out[2];
  wire [BITVBNK-1:0] vbadr_out_wire_2 = vbadr_out[2];
  wire [BITVROW-1:0] vradr_out_wire_2 = vradr_out[2];
  wire vread_out_wire_3 = vread_out[3];
  wire vwrite_out_wire_3 = vwrite_out[3];
  wire [BITVBNK-1:0] vbadr_out_wire_3 = vbadr_out[3];
  wire [BITVROW-1:0] vradr_out_wire_3 = vradr_out[3];
*/
  // Read request of pivoted data on DRAM memory
/*
  reg pread_wire [0:NUMRDPT+NUMRWPT-1];
  reg [BITVBNK-1:0] prdbadr_wire [0:NUMRDPT+NUMRWPT-1];
  reg [BITVROW-1:0] prdradr_wire [0:NUMRDPT+NUMRWPT-1];
  integer prdw_int;
  always_comb
    for (prdw_int=0; prdw_int<NUMRDPT+NUMRWPT; prdw_int=prdw_int+1) begin
      pread_wire[prdw_int] = vread_wire[prdw_int];
      prdbadr_wire[prdw_int] = vbadr_wire[prdw_int];
      prdradr_wire[prdw_int] = vradr_wire[prdw_int];
    end
*/

  reg pwrite_wire [0:NUMRWPT+NUMWRPT-1];
  reg [BITPBNK-1:0] pwrbadr_wire [0:NUMRWPT+NUMWRPT-1];
  reg [BITVROW-1:0] pwrradr_wire [0:NUMRWPT+NUMWRPT-1];
  reg [WIDTH-1:0] pdin_wire [0:NUMRWPT+NUMWRPT-1];
/*
  wire pwrite_wire_0 = pwrite_wire[0];
  wire [BITPBNK-1:0] pwrbadr_wire_0 = pwrbadr_wire[0];
  wire [BITVROW-1:0] pwrradr_wire_0 = pwrradr_wire[0];
  wire [WIDTH-1:0] pdin_wire_0 = pdin_wire[0];

  wire pwrite_wire_1 = pwrite_wire[1];
  wire [BITPBNK-1:0] pwrbadr_wire_1 = pwrbadr_wire[1];
  wire [BITVROW-1:0] pwrradr_wire_1 = pwrradr_wire[1];
  wire [WIDTH-1:0] pdin_wire_1 = pdin_wire[1];

  wire pwrite_wire_2 = pwrite_wire[2];
  wire [BITPBNK-1:0] pwrbadr_wire_2 = pwrbadr_wire[2];
  wire [BITVROW-1:0] pwrradr_wire_2 = pwrradr_wire[2];
  wire [WIDTH-1:0] pdin_wire_2 = pdin_wire[2];
*/
  // Read request of mapping information on SRAM memory
  reg swrite_wire [0:NUMRWPT+NUMWRPT-!NUMRDPT-1];
  reg [BITVROW-1:0] swrradr_wire [0:NUMRWPT+NUMWRPT-!NUMRDPT-1];
  reg [BITMAPT-1:0] sdin_pre_ecc [0:NUMRWPT+NUMWRPT-!NUMRDPT-1];
  wire [SDOUT_WIDTH-1:0] sdin_wire [0:NUMRWPT+NUMWRPT-!NUMRDPT-1];
/*
  wire swrite_wire_0 = swrite_wire[0];
  wire [BITVROW-1:0] swrradr_wire_0 = swrradr_wire[0];
  wire [BITMAPT-1:0] sdin_wire_0 = sdin_wire[0];
  wire swrite_wire_1 = swrite_wire[1];
  wire [BITVROW-1:0] swrradr_wire_1 = swrradr_wire[1];
  wire [BITMAPT-1:0] sdin_wire_1 = sdin_wire[1];
  wire swrite_wire_2 = swrite_wire[2];
  wire [BITVROW-1:0] swrradr_wire_2 = swrradr_wire[2];
  wire [BITMAPT-1:0] sdin_wire_2 = sdin_wire[2];
*/
  reg sread_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg [BITVROW-1:0] srdradr_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  integer srdp_int, srdc_int, srdw_int;
  always_comb 
    for (srdp_int=0; srdp_int<NUMRDPT+NUMRWPT+NUMWRPT; srdp_int=srdp_int+1) begin
      sread_wire[srdp_int] = vread_wire[srdp_int] || vwrite_wire[srdp_int];
      for (srdw_int=0; srdw_int<NUMRWPT+NUMWRPT-!NUMRDPT; srdw_int=srdw_int+1) begin
        sread_wire[srdp_int] = sread_wire[srdp_int] && !(swrite_wire[srdw_int] && (swrradr_wire[srdw_int] == vradr_wire[srdp_int]));
      end
      srdradr_wire[srdp_int] = vradr_wire[srdp_int];
    end
/*
  wire sread_wire_0 = sread_wire[0];
  wire [BITVROW-1:0] srdradr_wire_0 = srdradr_wire[0];
  wire sread_wire_1 = sread_wire[1];
  wire [BITVROW-1:0] srdradr_wire_1 = srdradr_wire[1];
  wire sread_wire_2 = sread_wire[2];
  wire [BITVROW-1:0] srdradr_wire_2 = srdradr_wire[2];
  wire sread_wire_3 = sread_wire[3];
  wire [BITVROW-1:0] srdradr_wire_3 = srdradr_wire[3];
*/
  reg               map_vld [0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:SRAM_DELAY-1];
  reg [BITMAPT-1:0] map_reg [0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:SRAM_DELAY-1];
/*
  genvar sprt_int, sfwd_int;
  generate
    for (sfwd_int=0; sfwd_int<SRAM_DELAY; sfwd_int=sfwd_int+1) begin: map_loop
      for (sprt_int=0; sprt_int<NUMRDPT+NUMRWPT+NUMWRPT; sprt_int=sprt_int+1) begin: prt_loop
        reg [BITVROW-1:0] vradr_temp;
        reg map_vld_next;
        reg [BITMAPT-1:0] map_reg_next;
        integer swpt_int;
        always_comb begin
          if (sfwd_int>0) begin
	    vradr_temp = vradr_reg[sprt_int][sfwd_int-1];
            map_vld_next = map_vld[sprt_int][sfwd_int-1];
            map_reg_next = map_reg[sprt_int][sfwd_int-1];
          end else begin
            vradr_temp = vradr_wire[sprt_int];
	    map_vld_next = 1'b0;
	    map_reg_next = 0;
          end
          if (swrite && (swrradr == vradr_temp)) begin
            map_vld_next = 1'b1;
            map_reg_next = sdin;
          end
//          for (swpt_int=0; swpt_int<NUMRWPT+NUMWRPT; swpt_int=swpt_int+1)
//            if (swrite_wire[swpt_int] && (swrradr_wire[swpt_int] == vradr_temp)) begin
//              map_vld_next = 1'b1;
//              map_reg_next = sdin_wire[swpt_int];
//            end
        end

        always @(posedge clk) begin
          map_vld[sprt_int][sfwd_int] <= map_vld_next;
          map_reg[sprt_int][sfwd_int] <= map_reg_next;
        end
      end
    end
  endgenerate
*/
  integer sprt_int, sfwd_int;
  always @(posedge clk)
    for (sfwd_int=0; sfwd_int<SRAM_DELAY; sfwd_int=sfwd_int+1)
      for (sprt_int=0; sprt_int<NUMRDPT+NUMRWPT+NUMWRPT; sprt_int=sprt_int+1)
        if (sfwd_int>0) begin
          if (swrite && (swrradr == vradr_reg[sprt_int][sfwd_int-1])) begin
            map_vld[sprt_int][sfwd_int] <= 1'b1;
            map_reg[sprt_int][sfwd_int] <= sdin[BITMAPT-1:0];
          end else begin
            map_vld[sprt_int][sfwd_int] <= map_vld[sprt_int][sfwd_int-1];
            map_reg[sprt_int][sfwd_int] <= map_reg[sprt_int][sfwd_int-1];
          end
        end else begin
          if (swrite && (swrradr == vradr_wire[sprt_int])) begin
            map_vld[sprt_int][sfwd_int] <= 1'b1;
            map_reg[sprt_int][sfwd_int] <= sdin[BITMAPT-1:0];
          end else begin
            map_vld[sprt_int][sfwd_int] <= 1'b0;
            map_reg[sprt_int][sfwd_int] <= 0;
          end
        end

// ECC Checking Module for SRAM
  wire [BITMAPT-1:0] sdout_out [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  genvar sdo_int;
  generate
    for (sdo_int=0; sdo_int<NUMRDPT+NUMRWPT+NUMWRPT; sdo_int=sdo_int+1) begin: sdo_loop
      wire [SDOUT_WIDTH-1:0] sdout_wire = sdout >> (sdo_int*SDOUT_WIDTH);

      wire sdout_bit1_err = 0;
      wire sdout_bit2_err = 0;
      wire [7:0] sdout_bit1_pos = 0;
      wire [7:0] sdout_bit2_pos = 0;
      wire [SDOUT_WIDTH-1:0] sdout_bit1_mask = sdout_bit1_err << sdout_bit1_pos;
      wire [SDOUT_WIDTH-1:0] sdout_bit2_mask = sdout_bit2_err << sdout_bit2_pos;
      wire [SDOUT_WIDTH-1:0] sdout_mask = sdout_bit1_mask ^ sdout_bit2_mask;
      wire sdout_serr = |sdout_mask && (|sdout_bit1_mask ^ |sdout_bit2_mask);
      wire sdout_derr = |sdout_mask && |sdout_bit1_mask && |sdout_bit2_mask;
      wire [SDOUT_WIDTH-1:0] sdout_int = sdout_wire ^ sdout_mask;

      wire [BITMAPT-1:0] sdout_data = sdout_int;
      wire [ECCBITS-1:0] sdout_ecc = sdout_int >> BITMAPT;
      wire [BITMAPT-1:0] sdout_dup_data = sdout_int >> BITMAPT+ECCBITS;
      wire [BITMAPT-1:0] sdout_post_ecc;
      wire               sdout_sec_err;
      wire               sdout_ded_err;

      ecc_check #(.ECCDWIDTH(BITMAPT), .ECCWIDTH(ECCBITS))
          ecc_check_sdout (.din(sdout_data), .eccin(sdout_ecc),
                           .dout(sdout_post_ecc), .sec_err(sdout_sec_err), .ded_err(sdout_ded_err),
                           .clk(clk), .rst(rst));

      assign sdout_out[sdo_int] = sdout_ded_err ? sdout_dup_data : sdout_post_ecc;
    end
  endgenerate

  wire [BITMAPT-1:0] sdout_out_0 = sdout_out[0];
  wire [BITMAPT-1:0] sdout_out_1 = sdout_out[1];
/*
  wire [BITMAPT-1:0] sdout_out_2 = sdout_out[2];
  wire [BITMAPT-1:0] sdout_out_3 = sdout_out[3];
*/
  reg [BITMAPT-1:0] map_out [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  integer fprt_int;
  always_comb
    for (fprt_int=0; fprt_int<NUMRDPT+NUMRWPT+NUMWRPT; fprt_int=fprt_int+1)
      map_out[fprt_int] = map_vld[fprt_int][SRAM_DELAY-1] ? map_reg[fprt_int][SRAM_DELAY-1] : sdout_out[fprt_int];
  
  wire [BITMAPT-1:0] map_out_0 = map_out[0];
  wire [BITMAPT-1:0] map_out_1 = map_out[1];

  reg [BITPBNK-1:0] map_wire [0:NUMPBNK-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  integer mprt_int, mloc_int;
  always_comb
    for (mprt_int=0; mprt_int<NUMRDPT+NUMRWPT+NUMWRPT; mprt_int=mprt_int+1)
      for (mloc_int=0; mloc_int<NUMPBNK; mloc_int=mloc_int+1)
        map_wire[mloc_int][mprt_int] = map_out[mprt_int] >> (mloc_int*BITPBNK);

  reg vread_vld_wire [0:NUMRDPT+NUMRWPT-1];
  reg vread_serr_wire [0:NUMRDPT+NUMRWPT-1];
  reg vread_derr_wire [0:NUMRDPT+NUMRWPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:NUMRDPT+NUMRWPT-1];
  reg [WIDTH-1:0] vdout_wire [0:NUMRDPT+NUMRWPT-1];
  integer vdop_int;
  always_comb
    for (vdop_int=0; vdop_int<NUMRDPT+NUMRWPT; vdop_int=vdop_int+1) begin
      vread_vld_wire[vdop_int] = vread_reg[vdop_int][SRAM_DELAY+DRAM_DELAY-1];
      vread_serr_wire[vdop_int] = pdout_serr >> vdop_int;
      vread_derr_wire[vdop_int] = pdout_derr >> vdop_int;
      vread_padr_wire[vdop_int] = pdout_padr >> (vdop_int*(BITPADR-1));
      vdout_wire[vdop_int] = pdout >> (vdop_int*WIDTH);
    end
      
  reg [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] vread_vld_tmp;
  reg [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] vread_serr_tmp;
  reg [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] vread_derr_tmp;
  reg [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0] vread_padr_tmp;
  reg [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] vdout_tmp;
  integer vdo_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    for (vdo_int=0; vdo_int<NUMRDPT+NUMRWPT; vdo_int=vdo_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_vld_wire[vdo_int] << vdo_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vdo_int] << (vdo_int*WIDTH));
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vdo_int] << vdo_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vdo_int] << vdo_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vdo_int] << (vdo_int*BITPADR));
    end
  end

  reg [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] vread_vld;
  reg [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] vread_serr;
  reg [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] vread_derr;
  reg [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0] vread_padr;
  reg [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] vdout;
  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      vread_vld <= vread_vld_tmp;
      vdout <= vdout_tmp;
      vread_serr <= vread_serr_tmp;
      vread_derr <= vread_derr_tmp;
      vread_padr <= vread_padr_tmp;
    end
  end else begin: nflp_loop
    always_comb begin
      vread_vld = vread_vld_tmp;
      vdout = vdout_tmp;
      vread_serr = vread_serr_tmp;
      vread_derr = vread_derr_tmp;
      vread_padr = vread_padr_tmp;
    end
  end
  endgenerate

/*
  wire map_vld_0 = map_vld[0][SRAM_DELAY-1];
  wire map_vld_1 = map_vld[1][SRAM_DELAY-1];
  wire map_vld_2 = map_vld[2][SRAM_DELAY-1];
  wire map_vld_3 = map_vld[3][SRAM_DELAY-1];
  wire [BITMAPT-1:0] map_reg_0 = map_reg[0][SRAM_DELAY-1];
  wire [BITMAPT-1:0] map_reg_1 = map_reg[1][SRAM_DELAY-1];
  wire [BITMAPT-1:0] map_reg_2 = map_reg[2][SRAM_DELAY-1];
  wire [BITMAPT-1:0] map_reg_3 = map_reg[3][SRAM_DELAY-1];
  wire [BITMAPT-1:0] map_out_0 = map_out[0];
  wire [BITMAPT-1:0] map_out_1 = map_out[1];
  wire [BITMAPT-1:0] map_out_2 = map_out[2];
  wire [BITMAPT-1:0] map_out_3 = map_out[3];
*/
  reg [NUMPBNK-1:0] used_pivot_temp [0:NUMRWPT+NUMWRPT-1];
  reg [NUMPBNK-1:0] used_pivot [0:NUMRWPT+NUMWRPT-1];
  reg               new_vld [0:NUMRWPT+NUMWRPT-1];
  reg [BITPBNK-1:0] new_bank [0:NUMRWPT+NUMWRPT-1];
  reg [BITPBNK-1:0] new_pos [0:NUMRWPT+NUMWRPT-1];
/*
  integer newp_int, newx_int;
  always_comb
    for (newp_int=0; newp_int<NUMRWPT+NUMWRPT; newp_int=newp_int+1) begin
      new_vld[newp_int] = 1'b0;
      new_bank[newp_int] = 0;
      new_pos[newp_int] = 0;
      if (newp_int==0) begin
        used_pivot_temp[newp_int] = 0;
        for (newx_int=0; newx_int<NUMRDPT+NUMRWPT; newx_int=newx_int+1)
          if (vread_out[newx_int])
            used_pivot_temp[newp_int] = used_pivot_temp[newp_int] | (1'b1 << map_wire[vbadr_out[newx_int]][newx_int]);
      end else
        used_pivot_temp[newp_int] = used_pivot[newp_int-1];
      for (newx_int=NUMPBNK-1; newx_int>=0; newx_int=newx_int-1)
        if ((newx_int == vbadr_out[newp_int+NUMRDPT]) || (newx_int >=NUMVBNK)) 
          if (!used_pivot_temp[newp_int][map_wire[newx_int][newp_int+NUMRDPT]]) begin
            new_vld[newp_int] = 1'b1;
            new_bank[newp_int] = map_wire[newx_int][newp_int+NUMRDPT];
            new_pos[newp_int] = newx_int;
          end
      if (vwrite_out[newp_int+NUMRDPT])
        used_pivot[newp_int] = used_pivot_temp[newp_int] | (1'b1 << new_bank[newp_int]);
      else
        used_pivot[newp_int] = used_pivot_temp[newp_int];
    end
*/
  always_comb begin
    new_vld[0] = 1'b0;
    new_bank[0] = 0;
    new_pos[0] = 0;
    new_vld[1] = 1'b0;
    new_bank[1] = 0;
    new_pos[1] = 0;
    used_pivot[0] = 0;
    used_pivot[1] = 0;
    if (vread_out[0])
      used_pivot[0] = used_pivot[0] | (1'b1 << map_wire[vbadr_out[0]][0]);
    if (vread_out[1])
      used_pivot[0] = used_pivot[0] | (1'b1 << map_wire[vbadr_out[1]][1]);
    if (vwrite_out[0])
      if (!used_pivot[0][map_wire[vbadr_out[0]][0]]) begin
        new_vld[0] = 1'b1;
        new_bank[0] = map_wire[vbadr_out[0]][0];
        new_pos[0] = vbadr_out[0];
        used_pivot[1] = used_pivot[0] | (1'b1 << map_wire[vbadr_out[0]][0]);
      end else begin
        new_vld[0] = 1'b1;
        new_bank[0] = map_wire[NUMVBNK][0];
        new_pos[0] = NUMVBNK;
        used_pivot[1] = used_pivot[0] | (1'b1 << map_wire[NUMVBNK][0]);
      end
    else
      used_pivot[1] = used_pivot[0];
    if (vwrite_out[1])
      if (!used_pivot[1][map_wire[vbadr_out[1]][1]]) begin
        new_vld[1] = 1'b1;
        new_bank[1] = map_wire[vbadr_out[1]][1];
        new_pos[1] = vbadr_out[1];
      end else begin
        new_vld[1] = 1'b1;
        new_bank[1] = map_wire[NUMVBNK][1];
        new_pos[1] = NUMVBNK;
      end
  end

  wire new_vld_0 = new_vld[0];
  wire [BITPBNK-1:0] new_bank_0 = new_bank[0];
  wire [BITPBNK-1:0] new_pos_0 = new_pos[0];
  wire [NUMPBNK-1:0] used_pivot_0 = used_pivot[0];
  wire new_vld_1 = new_vld[1];
  wire [BITPBNK-1:0] new_bank_1 = new_bank[1];
  wire [BITPBNK-1:0] new_pos_1 = new_pos[1];
  wire [NUMPBNK-1:0] used_pivot_1 = used_pivot[1];

  reg pread_wire [0:NUMRDPT+NUMRWPT-1]; 
  reg [BITPBNK-1:0] prdbadr_wire [0:NUMRDPT+NUMRWPT-1];
  reg [BITVROW-1:0] prdradr_wire [0:NUMRDPT+NUMRWPT-1];
  integer prdw_int;
  always_comb
    for (prdw_int=0; prdw_int<NUMRDPT+NUMRWPT; prdw_int=prdw_int+1) begin
      pread_wire[prdw_int] = vread_out[prdw_int];
      prdbadr_wire[prdw_int] = map_wire[vbadr_out[prdw_int]][prdw_int];
      prdradr_wire[prdw_int] = vradr_out[prdw_int];
    end
/*
  wire pread_wire_0 = pread_wire[0];
  wire [BITVBNK-1:0] prdbadr_wire_0 = prdbadr_wire[0];
  wire [BITVROW-1:0] prdradr_wire_0 = prdradr_wire[0];

  wire pread_wire_1 = pread_wire[1];
  wire [BITVBNK-1:0] prdbadr_wire_1 = prdbadr_wire[1];
  wire [BITVROW-1:0] prdradr_wire_1 = prdradr_wire[1];
*/
  assign prefr = vrefr_out;

  reg [(NUMRDPT+NUMRWPT)-1:0] pread;
  reg [(NUMRDPT+NUMRWPT)*BITPBNK-1:0] prdbadr;
  reg [(NUMRDPT+NUMRWPT)*BITVROW-1:0] prdradr;
  integer prd_int;
  always_comb begin
    pread = 0;
    prdbadr = 0;
    prdradr = 0;
    for (prd_int=0; prd_int<NUMRDPT+NUMRWPT; prd_int=prd_int+1) begin
      pread = pread | (pread_wire[prd_int] << prd_int);
      prdbadr = prdbadr | (prdbadr_wire[prd_int] << (prd_int*BITPBNK));
      prdradr = prdradr | (prdradr_wire[prd_int] << (prd_int*BITVROW));
    end
  end

  integer pwrp_int;
  always_comb
    for (pwrp_int=0; pwrp_int<NUMRWPT+NUMWRPT; pwrp_int=pwrp_int+1) begin
      pwrite_wire[pwrp_int] = vwrite_out[pwrp_int+NUMRDPT]/* && new_vld[pwrp_int]*/;
      pwrbadr_wire[pwrp_int] = new_bank[pwrp_int];
      pwrradr_wire[pwrp_int] = vradr_out[pwrp_int+NUMRDPT];
      pdin_wire[pwrp_int] = vdin_out[pwrp_int+NUMRDPT];
    end

  reg [(NUMRWPT+NUMWRPT)-1:0] pwrite;
  reg [(NUMRWPT+NUMWRPT)*BITPBNK-1:0] pwrbadr;
  reg [(NUMRWPT+NUMWRPT)*BITVROW-1:0] pwrradr;
  reg [(NUMRWPT+NUMWRPT)*WIDTH-1:0] pdin; 
  integer pwr_int;
  always_comb begin
    pwrite = 0;
    pwrbadr = 0;
    pwrradr = 0; 
    pdin = 0;
    for (pwr_int=0; pwr_int<NUMRWPT+NUMWRPT; pwr_int=pwr_int+1) begin
      pwrite = pwrite | (pwrite_wire[pwr_int] << pwr_int);
      pwrbadr = pwrbadr | (pwrbadr_wire[pwr_int] << (pwr_int*BITPBNK));
      pwrradr = pwrradr | (pwrradr_wire[pwr_int] << (pwr_int*BITVROW));
      pdin = pdin | (pdin_wire[pwr_int] << (pwr_int*WIDTH));
    end
  end

  wire write_helpme = (new_pos[0] >= NUMVBNK);
  wire [BITMAPT-1:0] new_map = (new_bank[0] << (vbadr_out[0+NUMRDPT]*BITPBNK));
  wire [BITMAPT-1:0] old_map = (map_wire[vbadr_out[0+NUMRDPT]][0+NUMRDPT] << (new_pos[0]*BITPBNK));

  wire vwrite_out_0 = vwrite_out[0];
  wire vwrite_out_1 = vwrite_out[1];

  always_comb
    if (rstvld) begin
      swrite_wire[0] = 1'b1;
      swrradr_wire[0] = rstaddr;
      sdin_pre_ecc[0] = rstdin;
    end else if (vwrite_out[0] && (new_pos[0] >= NUMVBNK)) begin
      swrite_wire[0] = 1'b1;
      swrradr_wire[0] = vradr_out[0];
      sdin_pre_ecc[0] = (map_out[0] & ~({BITPBNK{1'b1}} << (vbadr_out[0]*BITPBNK)) & ~({BITPBNK{1'b1}} << (new_pos[0]*BITPBNK))) |
			(new_bank[0] << (vbadr_out[0]*BITPBNK)) | (map_wire[vbadr_out[0]][0] << (new_pos[0]*BITPBNK));
    end else if (vwrite_out[1] && (new_pos[1] >= NUMVBNK)) begin
      swrite_wire[0] = 1'b1;
      swrradr_wire[0] = vradr_out[1];
      sdin_pre_ecc[0] = (map_out[1] & ~({BITPBNK{1'b1}} << (vbadr_out[1]*BITPBNK)) & ~({BITPBNK{1'b1}} << (new_pos[1]*BITPBNK))) |
			(new_bank[1] << (vbadr_out[1]*BITPBNK)) | (map_wire[vbadr_out[1]][1] << (new_pos[1]*BITPBNK));
    end else begin
      swrite_wire[0] = 1'b0;
      swrradr_wire[0] = 0;
      sdin_pre_ecc[0] = 0;
    end
/*
  integer swrp_int, swrx_int;
  always_comb
    for (swrp_int=0; swrp_int<NUMRWPT+NUMWRPT; swrp_int=swrp_int+1) 
      if (rstvld) begin
        swrite_wire[0] = 1'b1;
        swrradr_wire[0] = rstaddr;
        sdin_pre_ecc[0] = rstdin;
      end else if (vwrite_out[swrp_int+NUMRDPT]) begin
        swrite_wire[swrp_int] = (new_pos[swrp_int] >= NUMVBNK);
        swrradr_wire[swrp_int] = vradr_out[swrp_int+NUMRDPT];
        sdin_pre_ecc[swrp_int] = map_out[swrp_int+NUMRDPT];
        for (swrx_int=0; swrx_int<swrp_int; swrx_int=swrx_int+1)
          if (swrite_wire[swrx_int] && swrite_wire[swrp_int] && (swrradr_wire[swrx_int] == swrradr_wire[swrp_int])) begin
            swrite_wire[swrx_int] = 1'b0;
            sdin_pre_ecc[swrp_int] = sdin_pre_ecc[swrx_int];
          end
	sdin_pre_ecc[swrp_int] = (sdin_pre_ecc[swrp_int] &
				  ~({BITPBNK{1'b1}} << (vbadr_out[swrp_int+NUMRDPT]*BITPBNK)) &
				  ~({BITPBNK{1'b1}} << (new_pos[swrp_int]*BITPBNK))) |
				 (new_bank[swrp_int] << (vbadr_out[swrp_int+NUMRDPT]*BITPBNK)) |
				 (map_wire[vbadr_out[swrp_int+NUMRDPT]][swrp_int+NUMRDPT] << (new_pos[swrp_int]*BITPBNK));
      end else begin
        swrite_wire[swrp_int] = 1'b0;
        swrradr_wire[swrp_int] = 0;
        sdin_pre_ecc[swrp_int] = 0;
      end
*/
  genvar ewpt_int;
  generate
    for (ewpt_int=0; ewpt_int<NUMRWPT+NUMWRPT-!NUMRDPT; ewpt_int=ewpt_int+1) begin: ewpt_loop
      wire [ECCBITS-1:0] sdin_ecc;
      ecc_calc #(.ECCDWIDTH(BITMAPT), .ECCWIDTH(ECCBITS))
          ecc_calc_inst (.din(sdin_pre_ecc[ewpt_int]), .eccout(sdin_ecc));
      assign sdin_wire[ewpt_int] = {sdin_pre_ecc[ewpt_int],sdin_ecc,sdin_pre_ecc[ewpt_int]};
    end
  endgenerate

  reg [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] sread;
  reg [(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] srdradr;
  reg [(NUMRWPT+NUMWRPT-!NUMRDPT)-1:0] swrite;
  reg [(NUMRWPT+NUMWRPT-!NUMRDPT)*BITVROW-1:0] swrradr;
  reg [(NUMRWPT+NUMWRPT-!NUMRDPT)*SDOUT_WIDTH-1:0] sdin;
  reg swrite_temp;
  integer smcp_int;
  always_comb begin
    sread = 0;
    srdradr = 0;
//    swrite = 0;
//    swrradr = 0;
//    sdin = 0;
    for (smcp_int=0; smcp_int<NUMRDPT+NUMRWPT+NUMWRPT; smcp_int=smcp_int+1) begin
      sread = sread | (sread_wire[smcp_int] << smcp_int);
      srdradr = srdradr | (srdradr_wire[smcp_int] << (smcp_int*BITVROW));
    end
//    if (NUMRDPT>0) 
//      for (smcp_int=0; smcp_int<NUMRWPT+NUMWRPT; smcp_int=smcp_int+1) begin
//        swrite = swrite | (swrite_wire[smcp_int] << smcp_int);
//        swrradr = swrradr | (swrradr_wire[smcp_int] << (smcp_int*BITVROW));
//        sdin = sdin | (sdin_wire[smcp_int] << (smcp_int*SDOUT_WIDTH));
//      end
//    else
//      for (smcp_int=0; smcp_int<NUMRWPT+NUMWRPT; smcp_int=smcp_int+1)
//        if (swrite_wire[smcp_int]) begin
//          swrite = swrite | (swrite_wire[smcp_int] << 0);
//          swrradr = swrradr | (swrradr_wire[smcp_int] << (0*BITVROW));
//          sdin = sdin | (sdin_wire[smcp_int] << (0*SDOUT_WIDTH));
//        end
  end

  assign swrite = swrite_wire[0];
  assign swrradr = swrradr_wire[0];
  assign sdin = sdin_wire[0];
/*
  integer smwp_int;
  always_comb begin
    swrite = 0;
    swrradr = 0;
    sdin = 0;
    for (smwp_int=0; smwp_int<NUMRWPT+NUMWRPT; smwp_int=smwp_int+1)
      if (swrite_wire[smwp_int]) begin
        swrite = swrite_wire[smwp_int];
        swrradr = swrradr_wire[smwp_int];
        sdin = sdin_wire[smwp_int];
      end
  end
*/   

/*
  wire [NUMPBNK-1:0] used_pivot_temp_0 = used_pivot_temp[0];
  wire [NUMPBNK-1:0] used_pivot_temp_1 = used_pivot_temp[1];
  wire [NUMPBNK-1:0] used_pivot_0 = used_pivot[0];
  wire [NUMPBNK-1:0] used_pivot_1 = used_pivot[1];
  wire [BITPBNK-1:0] new_bank_0 = new_bank[0];
  wire [BITPBNK-1:0] new_bank_1 = new_bank[1];
  wire [BITPBNK-1:0] new_pos_0 = new_pos[0];
  wire [BITPBNK-1:0] new_pos_1 = new_pos[1];
  wire [BITPBNK-1:0] map_wire_0_2 = map_wire[0][2];
  wire [BITPBNK-1:0] map_wire_1_2 = map_wire[1][2];
  wire [BITPBNK-1:0] map_wire_2_2 = map_wire[2][2];
  wire [BITPBNK-1:0] map_wire_3_2 = map_wire[3][2];
  wire [BITPBNK-1:0] map_temp_0 = map_temp[0];
  wire [BITPBNK-1:0] map_temp_1 = map_temp[1];
  wire used_0 = used[0];
  wire used_1 = used[1];
  wire [BITPBNK-1:0] map_wire_0_0 = map_wire[0][0];
  wire [BITPBNK-1:0] map_wire_1_0 = map_wire[1][0];
  wire [BITPBNK-1:0] map_wire_2_0 = map_wire[2][0];
  wire [BITPBNK-1:0] map_wire_3_0 = map_wire[3][0];
  wire [BITPBNK-1:0] map_prt0 = map_wire[vbadr_out[0]][0];
  wire [BITPBNK-1:0] map_prt1 = map_wire[vbadr_out[1]][1];
  wire [BITPBNK-1:0] map_prt2 = map_wire[vbadr_out[2]][2];
  wire [BITPBNK-1:0] map_prt3 = map_wire[vbadr_out[3]][3];
*/

endmodule
