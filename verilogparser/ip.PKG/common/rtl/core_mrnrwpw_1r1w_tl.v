
module core_mrnrwpw_1r1w_tl (vrefr, vread, vwrite, vaddr, vdin, vread_vld, vdout, vread_serr, vread_derr, vread_padr,
                             prefr, pwrite, pwrbadr, pwrradr, pdin,
                             pread, prdbadr, prdradr, pdout, pdout_serr, pdout_derr, pdout_padr,
   	                     swrite, swrradr, sdin,
                             sread, srdradr, sdout,
                             cwrite, cwrradr, cdin,
	                     cread, crdradr, cdout,
                             ready, clk, rst,
	                     select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 1;
  parameter NUMRWPT = 1;
  parameter NUMWRPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 14;
  
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter REFRESH = 0;
  parameter ECCBITS = 4;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  parameter NUMCASH = 2*(NUMRDPT+NUMRWPT+NUMWRPT-1)-1;
  parameter FIFOCNT = (NUMRWPT+NUMWRPT)*(SRAM_DELAY+REFRESH);

  input                                           vrefr;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]           vread;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]           vwrite;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITADDR-1:0]   vaddr;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]     vdin;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]          vread_vld;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]    vdout;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]          vread_serr;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]          vread_derr;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0]    vread_padr;

  output                                       prefr;

  output [(NUMRWPT+NUMWRPT)-1:0]               pwrite;
  output [(NUMRWPT+NUMWRPT)*BITVBNK-1:0]       pwrbadr;
  output [(NUMRWPT+NUMWRPT)*BITVROW-1:0]       pwrradr;
  output [(NUMRWPT+NUMWRPT)*WIDTH-1:0]         pdin;

  output [(NUMRDPT+NUMRWPT)-1:0]               pread;
  output [(NUMRDPT+NUMRWPT)*BITVBNK-1:0]       prdbadr;
  output [(NUMRDPT+NUMRWPT)*BITVROW-1:0]       prdradr;
  input [(NUMRDPT+NUMRWPT)*WIDTH-1:0]          pdout;
  input [(NUMRDPT+NUMRWPT)-1:0]                pdout_serr;
  input [(NUMRDPT+NUMRWPT)-1:0]                pdout_derr;
  input [(NUMRDPT+NUMRWPT)*(BITPADR-BITPBNK-1)-1:0]    pdout_padr;

  output [NUMCASH*(NUMRWPT+NUMWRPT)-1:0]               swrite;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW-1:0]       swrradr;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0]   sdin;

  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]               sread;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0]       srdradr;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0]    sdout;
  
  output [NUMCASH-1:0]               cwrite;
  output [NUMCASH*BITVROW-1:0]       cwrradr;
  output [NUMCASH*WIDTH-1:0]         cdin;
  
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]               cread;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0]       crdradr;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]          cdout;
  
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

  reg                vread_reg [0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:DRAM_DELAY-1];
  reg                vwrite_reg [0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:DRAM_DELAY-1];
  reg [BITVBNK-1:0]  vbadr_reg [0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:DRAM_DELAY-1];
  reg [BITVROW-1:0]  vradr_reg [0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:DRAM_DELAY-1];
  reg [WIDTH-1:0]    vdin_reg [0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:DRAM_DELAY-1];
 
  integer vprt_int, vdel_int; 
  always @(posedge clk) 
    for (vprt_int=0; vprt_int<NUMRDPT+NUMRWPT+NUMWRPT; vprt_int=vprt_int+1)
      for (vdel_int=0; vdel_int<DRAM_DELAY; vdel_int=vdel_int+1)
        if (vdel_int > 0) begin
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
          vwrite_reg[vprt_int][vdel_int] <= vwrite_reg[vprt_int][vdel_int-1];
          vbadr_reg[vprt_int][vdel_int] <= vbadr_reg[vprt_int][vdel_int-1];
          vradr_reg[vprt_int][vdel_int] <= vradr_reg[vprt_int][vdel_int-1];
          vdin_reg[vprt_int][vdel_int] <= vdin_reg[vprt_int][vdel_int-1];
        end else begin
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
          vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int] && (vaddr_wire[vprt_int] < NUMADDR) && ready_wire;
          vbadr_reg[vprt_int][vdel_int] <= vbadr_wire[vprt_int];
          vradr_reg[vprt_int][vdel_int] <= vradr_wire[vprt_int];
          vdin_reg[vprt_int][vdel_int] <= vdin_wire[vprt_int];
        end

  reg vread_out [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg [BITVBNK-1:0] vrdbadr_out [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg [BITVROW-1:0] vrdradr_out [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg vwrite_out [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg [BITVBNK-1:0] vwrbadr_out [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg [BITVROW-1:0] vwrradr_out [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg [WIDTH-1:0] vdin_out [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  integer vout_int, vwpt_int;
  always_comb
    for (vout_int=0; vout_int<NUMRDPT+NUMRWPT+NUMWRPT; vout_int=vout_int+1) begin
      vread_out[vout_int] = vread_reg[vout_int][DRAM_DELAY-1];
      vrdbadr_out[vout_int] = vbadr_reg[vout_int][DRAM_DELAY-1];
      vrdradr_out[vout_int] = vradr_reg[vout_int][DRAM_DELAY-1];
//      for (vwpt_int=vout_int+1; vwpt_int<NUMRDPT+NUMRWPT+NUMWRPT; vwpt_int=vwpt_int+1)
//        vwrite_out[vout_int] = vwrite_out[vout_int] && !(vwrite_reg[vwpt_int][SRAM_DELAY-1] &&
//							 (vbadr_reg[vwpt_int][SRAM_DELAY-1] == vbadr_reg[vout_int][SRAM_DELAY-1]) &&
//							 (vradr_reg[vwpt_int][SRAM_DELAY-1] == vradr_reg[vout_int][SRAM_DELAY-1])); 
      vwrite_out[vout_int] = vwrite_reg[vout_int][SRAM_DELAY-1];
      vwrbadr_out[vout_int] = vbadr_reg[vout_int][SRAM_DELAY-1];
      vwrradr_out[vout_int] = vradr_reg[vout_int][SRAM_DELAY-1];
      vdin_out[vout_int] = vdin_reg[vout_int][SRAM_DELAY-1];
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
/*
  wire pread_wire_0 = pread_wire[0];
  wire [BITVBNK-1:0] prdbadr_wire_0 = prdbadr_wire[0];
  wire [BITVROW-1:0] prdradr_wire_0 = prdradr_wire[0];

  wire pread_wire_1 = pread_wire[1];
  wire [BITVBNK-1:0] prdbadr_wire_1 = prdbadr_wire[1];
  wire [BITVROW-1:0] prdradr_wire_1 = prdradr_wire[1];
*/

  reg pwrite_wire [0:NUMRWPT+NUMWRPT-1];
  reg [BITVBNK-1:0] pwrbadr_wire [0:NUMRWPT+NUMWRPT-1];
  reg [BITVROW-1:0] pwrradr_wire [0:NUMRWPT+NUMWRPT-1];
  reg [WIDTH-1:0] pdin_wire [0:NUMRWPT+NUMWRPT-1];

  wire pwrite_wire_0 = pwrite_wire[0];
  wire [BITVBNK-1:0] pwrbadr_wire_0 = pwrbadr_wire[0];
  wire [BITVROW-1:0] pwrradr_wire_0 = pwrradr_wire[0];
  wire [WIDTH-1:0] pdin_wire_0 = pdin_wire[0];

  wire pwrite_wire_1 = pwrite_wire[1];
  wire [BITVBNK-1:0] pwrbadr_wire_1 = pwrbadr_wire[1];
  wire [BITVROW-1:0] pwrradr_wire_1 = pwrradr_wire[1];
  wire [WIDTH-1:0] pdin_wire_1 = pdin_wire[1];
/*
  wire pwrite_wire_2 = pwrite_wire[2];
  wire [BITVBNK-1:0] pwrbadr_wire_2 = pwrbadr_wire[2];
  wire [BITVROW-1:0] pwrradr_wire_2 = pwrradr_wire[2];
  wire [WIDTH-1:0] pdin_wire_2 = pdin_wire[2];
*/
  // Read request of mapping information on SRAM memory
  reg swrite_wire [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
  reg [BITVROW-1:0] swrradr_wire [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
  reg [BITVBNK:0] sdin_pre_ecc [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
  wire [SDOUT_WIDTH-1:0] sdin_wire [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];

  reg cwrite_wire [0:NUMCASH-1];
  reg [BITVROW-1:0] cwrradr_wire [0:NUMCASH-1];
  reg [WIDTH-1:0] cdin_wire [0:NUMCASH-1];

  wire swrite_wire_0_0 = swrite_wire[0][0];
  wire [BITVROW-1:0] swrradr_wire_0_0 = swrradr_wire[0][0];
  wire [BITVBNK:0] sdin_wire_0_0 = sdin_wire[0][0];
  wire swrite_wire_0_1 = swrite_wire[0][1];
  wire [BITVROW-1:0] swrradr_wire_0_1 = swrradr_wire[0][1];
  wire [BITVBNK:0] sdin_wire_0_1 = sdin_wire[0][1];
/*
  wire swrite_wire_0_2 = swrite_wire[0][2];
  wire [BITVROW-1:0] swrradr_wire_0_2 = swrradr_wire[0][2];
  wire [BITVBNK:0] sdin_wire_0_2 = sdin_wire[0][2];
*/
  wire swrite_wire_1_0 = swrite_wire[1][0];
  wire [BITVROW-1:0] swrradr_wire_1_0 = swrradr_wire[1][0];
  wire [BITVBNK:0] sdin_wire_1_0 = sdin_wire[1][0];
  wire swrite_wire_1_1 = swrite_wire[1][1];
  wire [BITVROW-1:0] swrradr_wire_1_1 = swrradr_wire[1][1];
  wire [BITVBNK:0] sdin_wire_1_1 = sdin_wire[1][1];
  wire swrite_wire_2_0 = swrite_wire[2][0];
  wire [BITVROW-1:0] swrradr_wire_2_0 = swrradr_wire[2][0];
  wire [BITVBNK:0] sdin_wire_2_0 = sdin_wire[2][0];
  wire swrite_wire_2_1 = swrite_wire[2][1];
  wire [BITVROW-1:0] swrradr_wire_2_1 = swrradr_wire[2][1];
  wire [BITVBNK:0] sdin_wire_2_1 = sdin_wire[2][1];

  wire cwrite_wire_0 = cwrite_wire[0];
  wire [BITVROW-1:0] cwrradr_wire_0 = cwrradr_wire[0];
  wire [WIDTH-1:0] cdin_wire_0 = cdin_wire[0];
  wire cwrite_wire_1 = cwrite_wire[1];
  wire [BITVROW-1:0] cwrradr_wire_1 = cwrradr_wire[1];
  wire [WIDTH-1:0] cdin_wire_1 = cdin_wire[1];
  wire cwrite_wire_2 = cwrite_wire[2];
  wire [BITVROW-1:0] cwrradr_wire_2 = cwrradr_wire[2];
  wire [WIDTH-1:0] cdin_wire_2 = cdin_wire[2];
/*
  wire cwrite_wire_3 = cwrite_wire[3];
  wire [BITVROW-1:0] cwrradr_wire_3 = cwrradr_wire[3];
  wire [WIDTH-1:0] cdin_wire_3 = cdin_wire[3];
  wire cwrite_wire_4 = cwrite_wire[4];
  wire [BITVROW-1:0] cwrradr_wire_4 = cwrradr_wire[4];
  wire [WIDTH-1:0] cdin_wire_4 = cdin_wire[4];
*/

  reg sread_wire [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg [BITVROW-1:0] srdradr_wire [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg cread_wire [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg [BITVROW-1:0] crdradr_wire [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  integer srdp_int, srdc_int, srdw_int;
  always_comb 
    for (srdc_int=0; srdc_int<NUMCASH; srdc_int=srdc_int+1) begin
      for (srdp_int=0; srdp_int<NUMRDPT+NUMRWPT+NUMWRPT; srdp_int=srdp_int+1) begin
        sread_wire[srdc_int][srdp_int] = vread_wire[srdp_int] || vwrite_wire[srdp_int];
        cread_wire[srdc_int][srdp_int] = vread_wire[srdp_int] || vwrite_wire[srdp_int];
        for (srdw_int=0; srdw_int<NUMRWPT+NUMWRPT; srdw_int=srdw_int+1)
          sread_wire[srdc_int][srdp_int] = sread_wire[srdc_int][srdp_int] && !(swrite_wire[srdc_int][srdw_int] && (swrradr_wire[srdc_int][srdw_int] == vradr_wire[srdp_int]));
        cread_wire[srdc_int][srdp_int] = cread_wire[srdc_int][srdp_int] && !(cwrite_wire[srdc_int] && (cwrradr_wire[srdc_int] == vradr_wire[srdp_int]));
        srdradr_wire[srdc_int][srdp_int] = vradr_wire[srdp_int];
        crdradr_wire[srdc_int][srdp_int] = vradr_wire[srdp_int];
      end
    end

// ECC Checking Module for SRAM
  wire [BITVBNK:0] sdout_out [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  wire [WIDTH-1:0] cdout_out [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  genvar csh_int, sdo_int;
  generate for (csh_int=0; csh_int<NUMCASH; csh_int=csh_int+1) begin: csh_loop
    for (sdo_int=0; sdo_int<NUMRDPT+NUMRWPT+NUMWRPT; sdo_int=sdo_int+1) begin: sdo_loop
      wire [SDOUT_WIDTH-1:0] sdout_wire = sdout >> ((csh_int*(NUMRDPT+NUMRWPT+NUMWRPT)+sdo_int)*SDOUT_WIDTH);
      assign cdout_out[csh_int][sdo_int] = cdout >> ((csh_int*(NUMRDPT+NUMRWPT+NUMWRPT)+sdo_int)*WIDTH);

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

      wire [BITVBNK:0]   sdout_data = sdout_int;
      wire [ECCBITS-1:0] sdout_ecc = sdout_int >> BITVBNK+1;
      wire [BITVBNK:0]   sdout_dup_data = sdout_int >> BITVBNK+1+ECCBITS;
      wire [BITVBNK:0]   sdout_post_ecc;
      wire               sdout_sec_err;
      wire               sdout_ded_err;

      ecc_check   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
          ecc_check_inst (.din(sdout_data), .eccin(sdout_ecc),
                          .dout(sdout_post_ecc), .sec_err(sdout_sec_err), .ded_err(sdout_ded_err),
                          .clk(clk), .rst(rst));

      assign sdout_out[csh_int][sdo_int] = sdout_ded_err ? sdout_dup_data : sdout_post_ecc;
    end
  end
  endgenerate
/*
  wire [BITVBNK:0] sdout_out_0_0 = sdout_out[0][0];
  wire [BITVBNK:0] sdout_out_0_1 = sdout_out[0][1];
  wire [BITVBNK:0] sdout_out_0_2 = sdout_out[0][2];
  wire [BITVBNK:0] sdout_out_0_3 = sdout_out[0][3];
  wire [BITVBNK:0] sdout_out_1_0 = sdout_out[1][0];
  wire [BITVBNK:0] sdout_out_1_1 = sdout_out[1][1];
  wire [BITVBNK:0] sdout_out_1_2 = sdout_out[1][2];
  wire [BITVBNK:0] sdout_out_1_3 = sdout_out[1][3];
  wire [BITVBNK:0] sdout_out_2_0 = sdout_out[2][0];
  wire [BITVBNK:0] sdout_out_2_1 = sdout_out[2][1];
  wire [BITVBNK:0] sdout_out_2_2 = sdout_out[2][2];
  wire [BITVBNK:0] sdout_out_2_3 = sdout_out[2][3];
*/

  reg              map_vld [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:DRAM_DELAY-1];
  reg [BITVBNK:0]  map_reg [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:DRAM_DELAY-1];
  reg              cdat_vld [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:DRAM_DELAY-1];
  reg [WIDTH-1:0]  cdat_reg [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1][0:DRAM_DELAY-1];
  genvar scsh_int, sprt_int, sfwd_int;
  generate
    for (sfwd_int=0; sfwd_int<DRAM_DELAY; sfwd_int=sfwd_int+1) begin: map_loop
      for (scsh_int=0; scsh_int<NUMCASH; scsh_int=scsh_int+1) begin: csh_loop
        for (sprt_int=0; sprt_int<NUMRDPT+NUMRWPT+NUMWRPT; sprt_int=sprt_int+1) begin: prt_loop
          reg [BITVROW-1:0] vradr_temp;
          reg map_vld_next;
          reg [BITVBNK:0] map_reg_next;
          reg cdat_vld_next;
          reg [WIDTH-1:0] cdat_reg_next;
          integer swpt_int;
          always_comb begin
            if (sfwd_int==SRAM_DELAY) begin
              vradr_temp = vradr_reg[sprt_int][sfwd_int-1];
              if (map_vld[scsh_int][sprt_int][sfwd_int-1]) begin
                map_vld_next = map_vld[scsh_int][sprt_int][sfwd_int-1];
                map_reg_next = map_reg[scsh_int][sprt_int][sfwd_int-1];
              end else begin
                map_vld_next = 1'b1;
                map_reg_next = sdout_out[scsh_int][sprt_int];
              end
              if (cdat_vld[scsh_int][sprt_int][sfwd_int-1]) begin
                cdat_vld_next = cdat_vld[scsh_int][sprt_int][sfwd_int-1];
                cdat_reg_next = cdat_reg[scsh_int][sprt_int][sfwd_int-1];
              end else begin
                cdat_vld_next = 1'b1;
                cdat_reg_next = cdout_out[scsh_int][sprt_int];
              end
            end else if (sfwd_int>0) begin
	      vradr_temp = vradr_reg[sprt_int][sfwd_int-1];
              map_vld_next = map_vld[scsh_int][sprt_int][sfwd_int-1];
              map_reg_next = map_reg[scsh_int][sprt_int][sfwd_int-1];
              cdat_vld_next = cdat_vld[scsh_int][sprt_int][sfwd_int-1];
              cdat_reg_next = cdat_reg[scsh_int][sprt_int][sfwd_int-1];
            end else begin
              vradr_temp = vradr_wire[sprt_int];
	      map_vld_next = 1'b0;
	      map_reg_next = 0;
	      cdat_vld_next = 1'b0;
	      cdat_reg_next = 0;
            end
            for (swpt_int=0; swpt_int<NUMRWPT+NUMWRPT; swpt_int=swpt_int+1)
              if ((sfwd_int < SRAM_DELAY) && swrite_wire[scsh_int][swpt_int] && (swrradr_wire[scsh_int][swpt_int] == vradr_temp)) begin
		map_vld_next = 1'b1;
		map_reg_next = sdin_wire[scsh_int][swpt_int];
              end
            if ((sfwd_int < SRAM_DELAY) && cwrite_wire[scsh_int] && (cwrradr_wire[scsh_int] == vradr_temp)) begin
	      cdat_vld_next = 1'b1;
              cdat_reg_next = cdin_wire[scsh_int];
            end
          end 

          always @(posedge clk) begin
            map_vld[scsh_int][sprt_int][sfwd_int] <= map_vld_next;
            map_reg[scsh_int][sprt_int][sfwd_int] <= map_reg_next;
            cdat_vld[scsh_int][sprt_int][sfwd_int] <= cdat_vld_next;
            cdat_reg[scsh_int][sprt_int][sfwd_int] <= cdat_reg_next;
          end

        end
      end
    end
  endgenerate

/*
  reg              map_vld [0:NUMCASH-1][0:NUMWRPT-1][0:SRAM_DELAY-1];
  reg [BITVBNK:0]  map_reg [0:NUMCASH-1][0:NUMWRPT-1][0:SRAM_DELAY-1];
  integer scsh_int, sprt_int, sfwd_int;
  always @(posedge clk)
    for (scsh_int=0; scsh_int<NUMCASH; scsh_int=scsh_int+1)
      for (sprt_int=0; sprt_int<NUMWRPT; sprt_int=sprt_int+1)
        for (sfwd_int=0; sfwd_int<SRAM_DELAY; sfwd_int=sfwd_int+1)
          if (sfwd_int > 0)
            if (swrite_wire[scsh_int][1] && (swrradr_wire[scsh_int][1] == vradr_reg[sprt_int][sfwd_int-1])) begin
              map_vld[scsh_int][sprt_int][sfwd_int] <= 1'b1;
              map_reg[scsh_int][sprt_int][sfwd_int] <= sdin_wire[scsh_int][1];
            end else if (swrite_wire[scsh_int][0] && (swrradr_wire[scsh_int][0] == vradr_reg[sprt_int][sfwd_int-1])) begin
              map_vld[scsh_int][sprt_int][sfwd_int] <= 1'b1;
              map_reg[scsh_int][sprt_int][sfwd_int] <= sdin_wire[scsh_int][0];
            end else begin
              map_vld[scsh_int][sprt_int][sfwd_int] <= map_vld[scsh_int][sprt_int][sfwd_int-1];
              map_reg[scsh_int][sprt_int][sfwd_int] <= map_reg[scsh_int][sprt_int][sfwd_int-1];            
            end
          else
            if (swrite_wire[scsh_int][1] && (swrradr_wire[scsh_int][1] == vradr_wire[sprt_int])) begin
              map_vld[scsh_int][sprt_int][sfwd_int] <= 1'b1;
              map_reg[scsh_int][sprt_int][sfwd_int] <= sdin_wire[scsh_int][1];
            end else if (swrite_wire[scsh_int][0] && (swrradr_wire[scsh_int][0] == vradr_wire[sprt_int])) begin
              map_vld[scsh_int][sprt_int][sfwd_int] <= 1'b1;
              map_reg[scsh_int][sprt_int][sfwd_int] <= sdin_wire[scsh_int][0];
            end else begin
              map_vld[scsh_int][sprt_int][sfwd_int] <= 1'b0;
              map_reg[scsh_int][sprt_int][sfwd_int] <= 0;
            end

  reg              cdat_vld [0:NUMCASH-1][0:NUMWRPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]  cdat_reg [0:NUMCASH-1][0:NUMWRPT-1][0:SRAM_DELAY-1];
  integer ccsh_int, cprt_int, cfwd_int;
  always @(posedge clk)
    for (ccsh_int=0; ccsh_int<NUMCASH; ccsh_int=ccsh_int+1)
      for (cprt_int=0; cprt_int<NUMWRPT; cprt_int=cprt_int+1)
        for (cfwd_int=0; cfwd_int<SRAM_DELAY; cfwd_int=cfwd_int+1)
          if (cfwd_int > 0)
            if (cwrite_wire[ccsh_int][1] && (cwrradr_wire[ccsh_int][1] == vradr_reg[cprt_int][cfwd_int-1])) begin
              cdat_vld[ccsh_int][cprt_int][cfwd_int] <= 1'b1;
              cdat_reg[ccsh_int][cprt_int][cfwd_int] <= cdin_wire[ccsh_int][1];
            end else if (cwrite_wire[ccsh_int][0] && (cwrradr_wire[ccsh_int][0] == vradr_reg[cprt_int][cfwd_int-1])) begin
              cdat_vld[ccsh_int][cprt_int][cfwd_int] <= 1'b1;
              cdat_reg[ccsh_int][cprt_int][cfwd_int] <= cdin_wire[ccsh_int][0];
            end else begin
              cdat_vld[ccsh_int][cprt_int][cfwd_int] <= cdat_vld[ccsh_int][cprt_int][cfwd_int-1];
              cdat_reg[ccsh_int][cprt_int][cfwd_int] <= cdat_reg[ccsh_int][cprt_int][cfwd_int-1];            
            end
          else
            if (cwrite_wire[ccsh_int][1] && (cwrradr_wire[ccsh_int][1] == vradr_wire[cprt_int])) begin
              cdat_vld[ccsh_int][cprt_int][cfwd_int] <= 1'b1;
              cdat_reg[ccsh_int][cprt_int][cfwd_int] <= cdin_wire[ccsh_int][1];
            end else if (cwrite_wire[ccsh_int][0] && (cwrradr_wire[ccsh_int][0] == vradr_wire[cprt_int])) begin
              cdat_vld[ccsh_int][cprt_int][cfwd_int] <= 1'b1;
              cdat_reg[ccsh_int][cprt_int][cfwd_int] <= cdin_wire[ccsh_int][0];
            end else begin
              cdat_vld[ccsh_int][cprt_int][cfwd_int] <= 1'b0;
              cdat_reg[ccsh_int][cprt_int][cfwd_int] <= 0;
            end

  reg              pdat_vld [0:NUMWRPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]  pdat_reg [0:NUMWRPT-1][0:SRAM_DELAY-1];
  integer pprt_int, pfwd_int;
  always @(posedge clk)
    for (pprt_int=0; pprt_int<NUMWRPT; pprt_int=pprt_int+1)
      for (pfwd_int=0; pfwd_int<SRAM_DELAY; pfwd_int=pfwd_int+1)
        if (pfwd_int > 0)
          if (pwrite_wire[2] && (pwrbadr_wire[2] == vbadr_reg[pprt_int][pfwd_int-1]) && (pwrradr_wire[2] == vradr_reg[pprt_int][pfwd_int-1])) begin
            pdat_vld[pprt_int][pfwd_int] <= 1'b1;
            pdat_reg[pprt_int][pfwd_int] <= pdin_wire[2];
          end else if (pwrite_wire[1] && (pwrbadr_wire[1] == vbadr_reg[pprt_int][pfwd_int-1]) && (pwrradr_wire[1] == vradr_reg[pprt_int][pfwd_int-1])) begin
            pdat_vld[pprt_int][pfwd_int] <= 1'b1;
            pdat_reg[pprt_int][pfwd_int] <= pdin_wire[1];
          end else if (pwrite_wire[0] && (pwrbadr_wire[0] == vbadr_reg[pprt_int][pfwd_int-1]) && (pwrradr_wire[0] == vradr_reg[pprt_int][pfwd_int-1])) begin
            pdat_vld[pprt_int][pfwd_int] <= 1'b1;
            pdat_reg[pprt_int][pfwd_int] <= pdin_wire[0];
          end else begin
            pdat_vld[pprt_int][pfwd_int] <= pdat_vld[pprt_int][pfwd_int-1];
            pdat_reg[pprt_int][pfwd_int] <= pdat_reg[pprt_int][pfwd_int-1];            
          end
        else
          if (pwrite_wire[2] && (pwrbadr_wire[2] == vbadr_wire[pprt_int]) && (pwrradr_wire[2] == vradr_wire[pprt_int])) begin
            pdat_vld[pprt_int][pfwd_int] <= 1'b1;
            pdat_reg[pprt_int][pfwd_int] <= pdin_wire[2];
          end else if (pwrite_wire[1] && (pwrbadr_wire[1] == vbadr_wire[pprt_int]) && (pwrradr_wire[1] == vradr_wire[pprt_int])) begin
            pdat_vld[pprt_int][pfwd_int] <= 1'b1;
            pdat_reg[pprt_int][pfwd_int] <= pdin_wire[1];
          end else if (pwrite_wire[0] && (pwrbadr_wire[0] == vbadr_wire[pprt_int]) && (pwrradr_wire[0] == vradr_wire[pprt_int])) begin
            pdat_vld[pprt_int][pfwd_int] <= 1'b1;
            pdat_reg[pprt_int][pfwd_int] <= pdin_wire[0];
          end else begin
            pdat_vld[pprt_int][pfwd_int] <= 1'b0;
            pdat_reg[pprt_int][pfwd_int] <= 0;
          end
*/

  parameter SRCWDTH = 1 << BITWDTH;
  reg wr_srch_flag [0:NUMRDPT+NUMRWPT-1];
  reg [SRCWDTH-1:0] wr_srch_data [0:NUMRDPT+NUMRWPT-1];
  reg wr_srch_flags;
  reg [SRCWDTH-1:0] wr_srch_datas;

  reg             pdat_vld [0:NUMRDPT+NUMRWPT-1][0:DRAM_DELAY-1];
  reg [WIDTH-1:0] pdat_reg [0:NUMRDPT+NUMRWPT-1][0:DRAM_DELAY-1];
  reg             rddat_vld [0:NUMRDPT+NUMRWPT-1][0:DRAM_DELAY-1];
  reg [WIDTH-1:0] rddat_reg [0:NUMRDPT+NUMRWPT-1][0:DRAM_DELAY-1];
  genvar rprt_int, rfwd_int;
  generate
    for (rfwd_int=0; rfwd_int<DRAM_DELAY; rfwd_int=rfwd_int+1) begin: rddat_loop
      for (rprt_int=0; rprt_int<NUMRDPT+NUMRWPT; rprt_int=rprt_int+1) begin: prt_loop
        reg vread_temp;
        reg [BITVBNK-1:0] vbadr_temp;
        reg [BITVROW-1:0] vradr_temp;
        reg rddat_vld_next;
        reg [WIDTH-1:0] rddat_reg_next;
        reg pdat_vld_next;
        reg [WIDTH-1:0] pdat_reg_next;
        integer rwpt_int;
        always_comb begin
          if (rfwd_int>0) begin
            vread_temp = vread_reg[rprt_int][rfwd_int-1];
	    vbadr_temp = vbadr_reg[rprt_int][rfwd_int-1];
	    vradr_temp = vradr_reg[rprt_int][rfwd_int-1];
            pdat_vld_next = pdat_vld[rprt_int][rfwd_int-1];
            pdat_reg_next = pdat_reg[rprt_int][rfwd_int-1];
            rddat_vld_next = rddat_vld[rprt_int][rfwd_int-1];
            rddat_reg_next = rddat_reg[rprt_int][rfwd_int-1];
          end else begin
	    vread_temp = vread_wire[rprt_int];
            vbadr_temp = vbadr_wire[rprt_int];
            vradr_temp = vradr_wire[rprt_int];
	    pdat_vld_next = 1'b0;
	    pdat_reg_next = 0;
	    rddat_vld_next = 1'b0;
	    rddat_reg_next = 0;
          end
          for (rwpt_int=0; rwpt_int<NUMRWPT+NUMWRPT; rwpt_int=rwpt_int+1)
            if ((rfwd_int < SRAM_DELAY) && pwrite_wire[rwpt_int] && (pwrbadr_wire[rwpt_int] == vbadr_temp) && (pwrradr_wire[rwpt_int] == vradr_temp)) begin
              pdat_vld_next = 1'b1;
              pdat_reg_next = pdin_wire[rwpt_int];
            end
          for (rwpt_int=NUMRDPT; rwpt_int<NUMRDPT+NUMRWPT+NUMWRPT; rwpt_int=rwpt_int+1)
            if ((rfwd_int < SRAM_DELAY) && vwrite_out[rwpt_int] && vread_temp && (vwrbadr_out[rwpt_int] == vbadr_temp) && (vwrradr_out[rwpt_int] == vradr_temp)) begin
              rddat_vld_next = 1'b1;
              rddat_reg_next = vdin_out[rwpt_int];
            end else if (rfwd_int==SRAM_DELAY)
              if (!rddat_vld[rprt_int][rfwd_int-1]) begin
                rddat_vld_next = wr_srch_flag[rprt_int];
                rddat_reg_next = wr_srch_data[rprt_int];
              end
        end 

        always @(posedge clk) begin
          pdat_vld[rprt_int][rfwd_int] <= pdat_vld_next;
          pdat_reg[rprt_int][rfwd_int] <= pdat_reg_next;
          rddat_vld[rprt_int][rfwd_int] <= rddat_vld_next;
          rddat_reg[rprt_int][rfwd_int] <= rddat_reg_next;
        end

      end
    end
  endgenerate

/*
  reg             rddat_vld [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0] rddat_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  integer rprt_int, rfwd_int;
  always @(posedge clk)
    for (rprt_int=0; rprt_int<NUMRDPT; rprt_int=rprt_int+1)
      for (rfwd_int=0; rfwd_int<SRAM_DELAY; rfwd_int=rfwd_int+1)
        if (rfwd_int > 0)
          if (vwrite_reg[2][SRAM_DELAY-1] && vread_reg[rprt_int][rfwd_int-1] &&
              (vbadr_reg[2][SRAM_DELAY-1] == vbadr_reg[rprt_int][rfwd_int-1]) &&
	      (vradr_reg[2][SRAM_DELAY-1] == vradr_reg[rprt_int][rfwd_int-1])) begin
            rddat_vld[rprt_int][rfwd_int] <= 1'b1;
            rddat_reg[rprt_int][rfwd_int] <= vdin_reg[2][SRAM_DELAY-1];
          end else if (vwrite_reg[1][SRAM_DELAY-1] && vread_reg[rprt_int][rfwd_int-1] &&
              (vbadr_reg[1][SRAM_DELAY-1] == vbadr_reg[rprt_int][rfwd_int-1]) &&
	      (vradr_reg[1][SRAM_DELAY-1] == vradr_reg[rprt_int][rfwd_int-1])) begin
            rddat_vld[rprt_int][rfwd_int] <= 1'b1;
            rddat_reg[rprt_int][rfwd_int] <= vdin_reg[1][SRAM_DELAY-1];
          end else if (vwrite_reg[0][SRAM_DELAY-1] && vread_reg[rprt_int][rfwd_int-1] &&
                       (vbadr_reg[0][SRAM_DELAY-1] == vbadr_reg[rprt_int][rfwd_int-1]) &&
	               (vradr_reg[0][SRAM_DELAY-1] == vradr_reg[rprt_int][rfwd_int-1])) begin
            rddat_vld[rprt_int][rfwd_int] <= 1'b1;
            rddat_reg[rprt_int][rfwd_int] <= vdin_reg[0][SRAM_DELAY-1];
          end else begin
            rddat_vld[rprt_int][rfwd_int] <= rddat_vld[rprt_int][rfwd_int-1];
            rddat_reg[rprt_int][rfwd_int] <= rddat_reg[rprt_int][rfwd_int-1];
          end
        else 
          if (vwrite_reg[2][SRAM_DELAY-1] && vread_wire[rprt_int] &&
              (vbadr_reg[2][SRAM_DELAY-1] == vbadr_wire[rprt_int]) &&
	      (vradr_reg[2][SRAM_DELAY-1] == vradr_wire[rprt_int])) begin
            rddat_vld[rprt_int][rfwd_int] <= 1'b1;
            rddat_reg[rprt_int][rfwd_int] <= vdin_reg[2][SRAM_DELAY-1];
          end else if (vwrite_reg[1][SRAM_DELAY-1] && vread_wire[rprt_int] &&
              (vbadr_reg[1][SRAM_DELAY-1] == vbadr_wire[rprt_int]) &&
	      (vradr_reg[1][SRAM_DELAY-1] == vradr_wire[rprt_int])) begin
            rddat_vld[rprt_int][rfwd_int] <= 1'b1;
            rddat_reg[rprt_int][rfwd_int] <= vdin_reg[1][SRAM_DELAY-1];
          end else if (vwrite_reg[0][SRAM_DELAY-1] && vread_wire[rprt_int] &&
                       (vbadr_reg[0][SRAM_DELAY-1] == vbadr_wire[rprt_int]) &&
	               (vradr_reg[0][SRAM_DELAY-1] == vradr_wire[rprt_int])) begin
            rddat_vld[rprt_int][rfwd_int] <= 1'b1;
            rddat_reg[rprt_int][rfwd_int] <= vdin_reg[0][SRAM_DELAY-1];
          end else begin
            rddat_vld[rprt_int][rfwd_int] <= 1'b0;
            rddat_reg[rprt_int][rfwd_int] <= 0;
          end
*/

  reg [WIDTH-1:0] pdout_wire [0:NUMRDPT+NUMRWPT-1];
  integer pdow_int;
  always_comb
    for (pdow_int=0; pdow_int<NUMRDPT+NUMRWPT; pdow_int=pdow_int+1)
      pdout_wire[pdow_int] <= pdout >> (pdow_int*WIDTH);

  reg [BITVBNK:0] mapr_out [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg [WIDTH-1:0] cdatr_out [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg [WIDTH-1:0] pdatr_out [0:NUMRDPT+NUMRWPT-1];
  reg [BITVBNK:0] mapw_out [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  reg [WIDTH-1:0] cdatw_out [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
  integer fcsh_int, fprt_int;
  always_comb begin
    for (fprt_int=0; fprt_int<NUMRDPT+NUMRWPT+NUMWRPT; fprt_int=fprt_int+1)
      for (fcsh_int=0; fcsh_int<NUMCASH; fcsh_int=fcsh_int+1) begin
        mapr_out[fcsh_int][fprt_int] = map_vld[fcsh_int][fprt_int][DRAM_DELAY-1] ? map_reg[fcsh_int][fprt_int][DRAM_DELAY-1] : sdout_out[fcsh_int][fprt_int];
        cdatr_out[fcsh_int][fprt_int] = cdat_vld[fcsh_int][fprt_int][DRAM_DELAY-1] ? cdat_reg[fcsh_int][fprt_int][DRAM_DELAY-1] : cdout_out[fcsh_int][fprt_int];
        mapw_out[fcsh_int][fprt_int] = map_vld[fcsh_int][fprt_int][SRAM_DELAY-1] ? map_reg[fcsh_int][fprt_int][SRAM_DELAY-1] : sdout_out[fcsh_int][fprt_int];
        cdatw_out[fcsh_int][fprt_int] = cdat_vld[fcsh_int][fprt_int][SRAM_DELAY-1] ? cdat_reg[fcsh_int][fprt_int][SRAM_DELAY-1] : cdout_out[fcsh_int][fprt_int];
      end
    for (fprt_int=0; fprt_int<NUMRDPT+NUMRWPT; fprt_int=fprt_int+1)
      pdatr_out[fprt_int] = pdat_vld[fprt_int][DRAM_DELAY-1] ? pdat_reg[fprt_int][DRAM_DELAY-1] : pdout_wire[fprt_int];
  end
/*
  wire [WIDTH-1:0] pdout_wire_0 = pdout_wire[0];
  wire [WIDTH-1:0] pdout_wire_1 = pdout_wire[1];
*/  

  reg vread_vld_wire [0:NUMRDPT+NUMRWPT-1];
  reg vread_serr_wire [0:NUMRDPT+NUMRWPT-1];
  reg vread_derr_wire [0:NUMRDPT+NUMRWPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:NUMRDPT+NUMRWPT-1];
  reg [BITPADR-BITPBNK-2:0] pdout_padr_tmp [0:NUMRDPT+NUMRWPT-1];
  reg [WIDTH-1:0] vdout_int [0:NUMRDPT+NUMRWPT-1];
  integer vdip_int, vdic_int;
  always_comb
    for (vdip_int=0; vdip_int<NUMRDPT+NUMRWPT; vdip_int=vdip_int+1) begin
      vread_vld_wire[vdip_int] = vread_out[vdip_int];
      vread_serr_wire[vdip_int] = pdout_serr >> vdip_int;
      vread_derr_wire[vdip_int] = pdout_derr >> vdip_int;
      pdout_padr_tmp[vdip_int] = pdout_padr >> (vdip_int*(BITPADR-BITPBNK-1));
      vread_padr_wire[vdip_int] = vrdbadr_out[vdip_int] << (BITPADR-BITPBNK-1) | pdout_padr_tmp[vdip_int];
      vdout_int[vdip_int] = pdatr_out[vdip_int];
      for (vdic_int=0; vdic_int<NUMCASH; vdic_int=vdic_int+1)
        if (mapr_out[vdic_int][vdip_int][BITVBNK] && (mapr_out[vdic_int][vdip_int][BITVBNK-1:0] == vrdbadr_out[vdip_int]))
          vdout_int[vdip_int] = cdatr_out[vdic_int][vdip_int];
    end

  reg [WIDTH-1:0] vdout_wire [0:NUMRDPT+NUMRWPT-1];
  integer vdop_int;
  always_comb
    for (vdop_int=0; vdop_int<NUMRDPT+NUMRWPT; vdop_int=vdop_int+1) 
      vdout_wire[vdop_int] = (rddat_vld[vdop_int][DRAM_DELAY-1] ? rddat_reg[vdop_int][DRAM_DELAY-1] :
                              ((SRAM_DELAY==DRAM_DELAY) && wr_srch_flag[vdop_int]) ? wr_srch_data[vdop_int] : vdout_int[vdop_int]); 
/*
  wire [WIDTH-1:0] vdout_int_0 = vdout_int[0];

  wire [BITVBNK:0] mapr_out_0_0 = mapr_out[0][0];
  wire [BITVBNK:0] mapr_out_1_0 = mapr_out[1][0];
  wire [BITVBNK:0] mapr_out_2_0 = mapr_out[2][0];
  wire [WIDTH-1:0] cdatr_out_0_0 = cdatr_out[0][0];
  wire [WIDTH-1:0] cdatr_out_1_0 = cdatr_out[1][0];
  wire [WIDTH-1:0] cdatr_out_2_0 = cdatr_out[2][0];
  wire [WIDTH-1:0] pdatr_out_0 = pdatr_out[0];
  wire wr_srch_flag_0 = wr_srch_flag[0];
  wire [WIDTH-1:0] wr_srch_data_0 = wr_srch_data[0];
  wire rddat_vld_0 = rddat_vld[0][DRAM_DELAY-1];
  wire [WIDTH-1:0] rddat_reg_0 = rddat_reg[0][DRAM_DELAY-1];
  wire [WIDTH-1:0] pdout_wire_0 = pdout_wire[0];
  wire [WIDTH-1:0] vdout_wire_0 = vdout_wire[0];
*/    
/*
  wire             vread_vld1 = vread_out[0];
  wire             vread_err1 = 1'b0;
  wire [WIDTH-1:0] vdout1_int = (wr_srch_flag1 ? wr_srch_data1 :
			         (map_out[0][0][BITVBNK] && (map_out[0][0][BITVBNK-1:0] == vbadr_out[0])) ? cdat_out[0][0] :
			         (map_out[1][0][BITVBNK] && (map_out[1][0][BITVBNK-1:0] == vbadr_out[0])) ? cdat_out[1][0] :
			         (map_out[2][0][BITVBNK] && (map_out[2][0][BITVBNK-1:0] == vbadr_out[0])) ? cdat_out[2][0] : pdat_out[0]);
  wire [WIDTH-1:0] vdout1 = (rddat_vld[0][SRAM_DELAY-1] ? rddat_reg[0][SRAM_DELAY-1] : vdout1_int);

  assign vread_vld = vread_vld1;
  assign vdout = vdout1;
*/

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
  wire [WIDTH-1:0] cdat_out_0_0 = cdat_out[0][0];
  wire [WIDTH-1:0] cdat_out_1_0 = cdat_out[1][0];
  wire [WIDTH-1:0] cdat_out_2_0 = cdat_out[2][0];
  wire [WIDTH-1:0] cdat_out_0_1 = cdat_out[0][1];
  wire [WIDTH-1:0] cdat_out_1_1 = cdat_out[1][1];
  wire [WIDTH-1:0] cdat_out_2_1 = cdat_out[2][1];
  wire [WIDTH-1:0] cdat_out_0_2 = cdat_out[0][2];
  wire [WIDTH-1:0] cdat_out_1_2 = cdat_out[1][2];
  wire [WIDTH-1:0] cdat_out_2_2 = cdat_out[2][2];
  wire [WIDTH-1:0] cdat_out_0_3 = cdat_out[0][3];
  wire [WIDTH-1:0] cdat_out_1_3 = cdat_out[1][3];
  wire [WIDTH-1:0] cdat_out_2_3 = cdat_out[2][3];

  wire [BITVBNK:0] map_out_0_0 = map_out[0][0];
  wire [BITVBNK:0] map_out_1_0 = map_out[1][0];
  wire [BITVBNK:0] map_out_2_0 = map_out[2][0];
  wire [BITVBNK:0] map_out_0_1 = map_out[0][1];
  wire [BITVBNK:0] map_out_1_1 = map_out[1][1];
  wire [BITVBNK:0] map_out_2_1 = map_out[2][1];
  wire [BITVBNK:0] map_out_0_2 = map_out[0][2];
  wire [BITVBNK:0] map_out_1_2 = map_out[1][2];
  wire [BITVBNK:0] map_out_2_2 = map_out[2][2];
  wire [BITVBNK:0] map_out_0_3 = map_out[0][3];
  wire [BITVBNK:0] map_out_1_3 = map_out[1][3];
  wire [BITVBNK:0] map_out_2_3 = map_out[2][3];
*/

  reg [3:0]          wrfifo_cnt;
  reg                wrfifo_old_vld [0:NUMCASH-1][0:FIFOCNT-1];
  reg [BITVBNK-1:0]  wrfifo_old_map [0:NUMCASH-1][0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_old_dat [0:NUMCASH-1][0:FIFOCNT-1];
  reg                wrfifo_new_vld [0:FIFOCNT-1];
  reg [BITVBNK-1:0]  wrfifo_new_map [0:FIFOCNT-1];
  reg [BITVROW-1:0]  wrfifo_new_row [0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_new_dat [0:FIFOCNT-1];

  reg [3:0] wrfifo_dcnt;
  reg [3:0] wrfifo_ecnt;
  integer wcnt_int;
  always_comb begin
    if (!vrefr_wire || !REFRESH) begin
      wrfifo_dcnt = NUMRWPT+NUMWRPT;
      for (wcnt_int=0; wcnt_int<NUMRWPT; wcnt_int=wcnt_int+1)
        wrfifo_dcnt = wrfifo_dcnt - vread_wire[NUMRDPT+wcnt_int];
      wrfifo_dcnt = (wrfifo_cnt > wrfifo_dcnt) ? wrfifo_dcnt : wrfifo_cnt;
    end else
      wrfifo_dcnt = 0;
    wrfifo_ecnt = 0;
    for (wcnt_int=0; wcnt_int<NUMRWPT+NUMWRPT; wcnt_int=wcnt_int+1)
      wrfifo_ecnt = wrfifo_ecnt + vwrite_out[NUMRDPT+wcnt_int];
  end

      
/*      
  wire wrfifo_deq1 = (wrfifo_cnt > 0);
  wire wrfifo_deq2 = (wrfifo_cnt > 1);
  wire wrfifo_deq3 = !vread_wire[0] && (wrfifo_cnt > 2);
//  wire wrfifo_deq4 = !vread_wire[0] && (wrfifo_cnt > 3);
//  wire [3:0] wrfifo_dcnt = wrfifo_deq1 + wrfifo_deq2 + wrfifo_deq3 + wrfifo_deq4;
  wire [3:0] wrfifo_dcnt = wrfifo_deq1 + wrfifo_deq2 + wrfifo_deq3;
//  wire [NUMWRPT-1:0] wrfifo_deq = {wrfifo_deq3,wrfifo_deq2,wrfifo_deq1,wrfifo_deq4};
  wire [NUMWRPT-1:0] wrfifo_deq = {wrfifo_deq2,wrfifo_deq1,wrfifo_deq3};

  wire wrfifo_deq1 = !(vread_wire[0] && vread_wire[1]) && |wrfifo_cnt;
  wire wrfifo_deq2 = !(vread_wire[0] || vread_wire[1]) && (wrfifo_cnt > 1);
  wire wrfifo_deq3 = !vread_wire[0] && !vread_wire[1] && (wrfifo_cnt > 2);
*/
  always @(posedge clk)
    if (rst)
      wrfifo_cnt <= 0;
    else
      wrfifo_cnt <= wrfifo_cnt + wrfifo_ecnt - wrfifo_dcnt;

  wire wrfifo_cnt_gt = (wrfifo_cnt > 3);

  genvar fifo_int;
  generate for (fifo_int=0; fifo_int<FIFOCNT; fifo_int=fifo_int+1) begin: fifo_loop
    reg [3:0] vwr_sel;
    reg [3:0] fifo_cnt_temp;

    integer fcnt_int;
    always_comb begin
      fifo_cnt_temp = wrfifo_cnt - wrfifo_dcnt;
      if (fifo_int < fifo_cnt_temp)
        vwr_sel = NUMRWPT+NUMWRPT;
      else begin 
        vwr_sel = 0;
        for (fcnt_int=0; fcnt_int<NUMRWPT+NUMWRPT; fcnt_int=fcnt_int+1)
          if (fifo_cnt_temp <= fifo_int) begin
            if (vwrite_out[NUMRDPT+fcnt_int] && (fifo_cnt_temp == fifo_int))
              vwr_sel = vwr_sel;
            else
              vwr_sel = vwr_sel + 1;
            fifo_cnt_temp = fifo_cnt_temp + vwrite_out[NUMRDPT+fcnt_int];
          end
      end
    end

    reg               wrfifo_new_vld_next;
    reg [BITVBNK-1:0] wrfifo_new_map_next;
    reg [BITVROW-1:0] wrfifo_new_row_next;
    reg [WIDTH-1:0]   wrfifo_new_dat_next;
    reg               wrfifo_old_vld_next [0:NUMCASH-1];
    reg [BITVBNK-1:0] wrfifo_old_map_next [0:NUMCASH-1];
    reg [WIDTH-1:0]   wrfifo_old_dat_next [0:NUMCASH-1];
    integer fcsh_int, fcpt_int;
    always_comb
      if ((vwr_sel != NUMRWPT+NUMWRPT) && vwrite_out[NUMRDPT+vwr_sel]) begin
        for (fcsh_int=0; fcsh_int<NUMCASH; fcsh_int=fcsh_int+1) begin
          wrfifo_old_vld_next[fcsh_int] = mapw_out[fcsh_int][NUMRDPT+vwr_sel][BITVBNK];
          wrfifo_old_map_next[fcsh_int] = mapw_out[fcsh_int][NUMRDPT+vwr_sel];
          for (fcpt_int=0; fcpt_int<NUMRWPT+NUMWRPT; fcpt_int=fcpt_int+1)
            if (swrite_wire[fcsh_int][fcpt_int] && (swrradr_wire[fcsh_int][fcpt_int] == vwrradr_out[NUMRDPT+vwr_sel])) begin
              wrfifo_old_vld_next[fcsh_int] = sdin_wire[fcsh_int][fcpt_int][BITVBNK];
              wrfifo_old_map_next[fcsh_int] = sdin_wire[fcsh_int][fcpt_int];
            end
          wrfifo_old_dat_next[fcsh_int] = cdatw_out[fcsh_int][NUMRDPT+vwr_sel];
          if (cwrite_wire[fcsh_int] && (cwrradr_wire[fcsh_int] == vwrradr_out[NUMRDPT+vwr_sel]))
            wrfifo_old_dat_next[fcsh_int] = cdin_wire[fcsh_int];
        end
        wrfifo_new_vld_next = 1'b1;
        wrfifo_new_map_next = vwrbadr_out[NUMRDPT+vwr_sel];
        wrfifo_new_row_next = vwrradr_out[NUMRDPT+vwr_sel];
        wrfifo_new_dat_next = vdin_out[NUMRDPT+vwr_sel];
      end else if (|wrfifo_dcnt && (fifo_int<FIFOCNT-wrfifo_dcnt)) begin
        for (fcsh_int=0; fcsh_int<NUMCASH; fcsh_int=fcsh_int+1) begin
          wrfifo_old_vld_next[fcsh_int] = wrfifo_old_vld[fcsh_int][fifo_int+wrfifo_dcnt];
          wrfifo_old_map_next[fcsh_int] = wrfifo_old_map[fcsh_int][fifo_int+wrfifo_dcnt];
          for (fcpt_int=0; fcpt_int<NUMRWPT+NUMWRPT; fcpt_int=fcpt_int+1)
            if (swrite_wire[fcsh_int][fcpt_int] && (swrradr_wire[fcsh_int][fcpt_int] == wrfifo_new_row[fifo_int+wrfifo_dcnt])) begin
              wrfifo_old_vld_next[fcsh_int] = sdin_wire[fcsh_int][fcpt_int][BITVBNK];
              wrfifo_old_map_next[fcsh_int] = sdin_wire[fcsh_int][fcpt_int];
            end
          wrfifo_old_dat_next[fcsh_int] = wrfifo_old_dat[fcsh_int][fifo_int+wrfifo_dcnt];
          if (cwrite_wire[fcsh_int] && (cwrradr_wire[fcsh_int] == wrfifo_new_row[fifo_int+wrfifo_dcnt]))
            wrfifo_old_dat_next[fcsh_int] = cdin_wire[fcsh_int];
        end
        wrfifo_new_vld_next = wrfifo_new_vld[fifo_int+wrfifo_dcnt];
        wrfifo_new_map_next = wrfifo_new_map[fifo_int+wrfifo_dcnt];
        wrfifo_new_row_next = wrfifo_new_row[fifo_int+wrfifo_dcnt];
        wrfifo_new_dat_next = wrfifo_new_dat[fifo_int+wrfifo_dcnt];
      end else begin
        for (fcsh_int=0; fcsh_int<NUMCASH; fcsh_int=fcsh_int+1) begin
          wrfifo_old_vld_next[fcsh_int] = wrfifo_old_vld[fcsh_int][fifo_int];
          wrfifo_old_map_next[fcsh_int] = wrfifo_old_map[fcsh_int][fifo_int];
          wrfifo_old_dat_next[fcsh_int] = wrfifo_old_dat[fcsh_int][fifo_int];
        end
        wrfifo_new_vld_next = wrfifo_new_vld[fifo_int];
        wrfifo_new_map_next = wrfifo_new_map[fifo_int];
        wrfifo_new_row_next = wrfifo_new_row[fifo_int];
        wrfifo_new_dat_next = wrfifo_new_dat[fifo_int];
      end
/*
    wire wrfifo_old_vld_next_0 = wrfifo_old_vld_next[0];
    wire wrfifo_old_vld_next_1 = wrfifo_old_vld_next[1];
    wire wrfifo_old_vld_next_2 = wrfifo_old_vld_next[2];
*/
    integer flop_int;
    always @(posedge clk) begin
      for (flop_int=0; flop_int<NUMCASH; flop_int=flop_int+1) begin
        wrfifo_old_vld[flop_int][fifo_int] <= wrfifo_old_vld_next[flop_int];
        wrfifo_old_map[flop_int][fifo_int] <= wrfifo_old_map_next[flop_int];
        wrfifo_old_dat[flop_int][fifo_int] <= wrfifo_old_dat_next[flop_int];
      end
      wrfifo_new_vld[fifo_int] <= wrfifo_new_vld_next;
      wrfifo_new_map[fifo_int] <= wrfifo_new_map_next;
      wrfifo_new_row[fifo_int] <= wrfifo_new_row_next;
      wrfifo_new_dat[fifo_int] <= wrfifo_new_dat_next;
    end

  end
  endgenerate

/*
  integer wfifo_int, wfcsh_int;
  always @(posedge clk)
    for (wfifo_int=FIFOCNT-1; wfifo_int>=0; wfifo_int=wfifo_int-1)
      if (vwrite_out[1] && (wrfifo_cnt == (wrfifo_deq1+wrfifo_deq2+wrfifo_deq3+wfifo_int))) begin
        for (wfcsh_int=0; wfcsh_int<NUMCASH; wfcsh_int=wfcsh_int+1) begin
          if (swrite_wire[wfcsh_int][2] && (swrradr_wire[wfcsh_int][2] == vradr_out[1])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][2][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][2];
          end else if (swrite_wire[wfcsh_int][1] && (swrradr_wire[wfcsh_int][1] == vradr_out[1])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][1][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][1];
          end else if (swrite_wire[wfcsh_int][0] && (swrradr_wire[wfcsh_int][0] == vradr_out[1])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][0][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][0];
          end else begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= map_out[wfcsh_int][1][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= map_out[wfcsh_int][1];
          end
          if (cwrite_wire[wfcsh_int][2] && (cwrradr_wire[wfcsh_int][2] == vradr_out[1]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][2];
          else if (cwrite_wire[wfcsh_int][1] && (cwrradr_wire[wfcsh_int][1] == vradr_out[1]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][1];
          else if (cwrite_wire[wfcsh_int][0] && (cwrradr_wire[wfcsh_int][0] == vradr_out[1]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][0];
          else
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdat_out[wfcsh_int][1];
        end
        wrfifo_new_vld[wfifo_int] <= 1'b1;
        wrfifo_new_map[wfifo_int] <= vbadr_out[1];
        wrfifo_new_row[wfifo_int] <= vradr_out[1];
        wrfifo_new_dat[wfifo_int] <= vdin_out[1];
      end else if (vwrite_out[2] && (wrfifo_cnt == (wrfifo_deq1+wrfifo_deq2+wrfifo_deq3-vwrite_out[1]+wfifo_int))) begin
        for (wfcsh_int=0; wfcsh_int<NUMCASH; wfcsh_int=wfcsh_int+1) begin
          if (swrite_wire[wfcsh_int][2] && (swrradr_wire[wfcsh_int][2] == vradr_out[2])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][2][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][2];
          end else if (swrite_wire[wfcsh_int][1] && (swrradr_wire[wfcsh_int][1] == vradr_out[2])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][1][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][1];
          end else if (swrite_wire[wfcsh_int][0] && (swrradr_wire[wfcsh_int][0] == vradr_out[2])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][0][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][0];
          end else begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= map_out[wfcsh_int][2][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= map_out[wfcsh_int][2];
          end
          if (cwrite_wire[wfcsh_int][2] && (cwrradr_wire[wfcsh_int][2] == vradr_out[2]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][2];
          else if (cwrite_wire[wfcsh_int][1] && (cwrradr_wire[wfcsh_int][1] == vradr_out[2]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][1];
          else if (cwrite_wire[wfcsh_int][0] && (cwrradr_wire[wfcsh_int][0] == vradr_out[2]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][0];
          else
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdat_out[wfcsh_int][2];
        end
        wrfifo_new_vld[wfifo_int] <= 1'b1;
        wrfifo_new_map[wfifo_int] <= vbadr_out[2];
        wrfifo_new_row[wfifo_int] <= vradr_out[2];
        wrfifo_new_dat[wfifo_int] <= vdin_out[2];
      end else if (vwrite_out[3] && (wrfifo_cnt == (wrfifo_deq1+wrfifo_deq2+wrfifo_deq3-vwrite_out[1]-vwrite_out[2]+wfifo_int))) begin
        for (wfcsh_int=0; wfcsh_int<NUMCASH; wfcsh_int=wfcsh_int+1) begin
          if (swrite_wire[wfcsh_int][2] && (swrradr_wire[wfcsh_int][2] == vradr_out[3])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][2][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][2];
          end else if (swrite_wire[wfcsh_int][1] && (swrradr_wire[wfcsh_int][1] == vradr_out[3])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][1][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][1];
          end else if (swrite_wire[wfcsh_int][0] && (swrradr_wire[wfcsh_int][0] == vradr_out[3])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][0][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][0];
          end else begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= map_out[wfcsh_int][3][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= map_out[wfcsh_int][3];
          end
          if (cwrite_wire[wfcsh_int][2] && (cwrradr_wire[wfcsh_int][2] == vradr_out[3]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][2];
          else if (cwrite_wire[wfcsh_int][1] && (cwrradr_wire[wfcsh_int][1] == vradr_out[3]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][1];
          else if (cwrite_wire[wfcsh_int][0] && (cwrradr_wire[wfcsh_int][0] == vradr_out[3]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][0];
          else
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdat_out[wfcsh_int][3];
        end
        wrfifo_new_vld[wfifo_int] <= 1'b1;
        wrfifo_new_map[wfifo_int] <= vbadr_out[3];
        wrfifo_new_row[wfifo_int] <= vradr_out[3];
        wrfifo_new_dat[wfifo_int] <= vdin_out[3];
      end else if (wrfifo_deq3 && (wfifo_int<FIFOCNT-3)) begin
        for (wfcsh_int=0; wfcsh_int<NUMCASH; wfcsh_int=wfcsh_int+1) begin
          if (swrite_wire[wfcsh_int][2] && (swrradr_wire[wfcsh_int][2] == wrfifo_new_row[wfifo_int+3])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][2][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][2];
          end else if (swrite_wire[wfcsh_int][1] && (swrradr_wire[wfcsh_int][1] == wrfifo_new_row[wfifo_int+3])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][1][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][1];
          end else if (swrite_wire[wfcsh_int][0] && (swrradr_wire[wfcsh_int][0] == wrfifo_new_row[wfifo_int+3])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][0][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][0];
          end else begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= wrfifo_old_vld[wfcsh_int][wfifo_int+3];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= wrfifo_old_map[wfcsh_int][wfifo_int+3];
          end
          if (cwrite_wire[wfcsh_int][2] && (cwrradr_wire[wfcsh_int][2] == wrfifo_new_row[wfifo_int+3]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][2];
          else if (cwrite_wire[wfcsh_int][1] && (cwrradr_wire[wfcsh_int][1] == wrfifo_new_row[wfifo_int+3]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][1];
          else if (cwrite_wire[wfcsh_int][0] && (cwrradr_wire[wfcsh_int][0] == wrfifo_new_row[wfifo_int+3]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][0];
          else
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= wrfifo_old_dat[wfcsh_int][wfifo_int+3];
        end
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int+3];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int+3];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int+3];
        wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int+3];
      end else if (wrfifo_deq2 && (wfifo_int<FIFOCNT-2)) begin
        for (wfcsh_int=0; wfcsh_int<NUMCASH; wfcsh_int=wfcsh_int+1) begin
          if (swrite_wire[wfcsh_int][2] && (swrradr_wire[wfcsh_int][2] == wrfifo_new_row[wfifo_int+2])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][2][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][2];
          end else if (swrite_wire[wfcsh_int][1] && (swrradr_wire[wfcsh_int][1] == wrfifo_new_row[wfifo_int+2])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][1][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][1];
          end else if (swrite_wire[wfcsh_int][0] && (swrradr_wire[wfcsh_int][0] == wrfifo_new_row[wfifo_int+2])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][0][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][0];
          end else begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= wrfifo_old_vld[wfcsh_int][wfifo_int+2];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= wrfifo_old_map[wfcsh_int][wfifo_int+2];
          end
          if (cwrite_wire[wfcsh_int][2] && (cwrradr_wire[wfcsh_int][2] == wrfifo_new_row[wfifo_int+2]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][2];
          else if (cwrite_wire[wfcsh_int][1] && (cwrradr_wire[wfcsh_int][1] == wrfifo_new_row[wfifo_int+2]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][1];
          else if (cwrite_wire[wfcsh_int][0] && (cwrradr_wire[wfcsh_int][0] == wrfifo_new_row[wfifo_int+2]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][0];
          else
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= wrfifo_old_dat[wfcsh_int][wfifo_int+2];
        end
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int+2];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int+2];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int+2];
        wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int+2];
      end else if (wrfifo_deq1 && (wfifo_int<FIFOCNT-1)) begin
        for (wfcsh_int=0; wfcsh_int<NUMCASH; wfcsh_int=wfcsh_int+1) begin
          if (swrite_wire[wfcsh_int][2] && (swrradr_wire[wfcsh_int][2] == wrfifo_new_row[wfifo_int+1])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][2][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][2];
          end else if (swrite_wire[wfcsh_int][1] && (swrradr_wire[wfcsh_int][1] == wrfifo_new_row[wfifo_int+1])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][1][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][1];
          end else if (swrite_wire[wfcsh_int][0] && (swrradr_wire[wfcsh_int][0] == wrfifo_new_row[wfifo_int+1])) begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][0][BITVBNK];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= sdin_wire[wfcsh_int][0];
          end else begin
            wrfifo_old_vld[wfcsh_int][wfifo_int] <= wrfifo_old_vld[wfcsh_int][wfifo_int+1];
            wrfifo_old_map[wfcsh_int][wfifo_int] <= wrfifo_old_map[wfcsh_int][wfifo_int+1];
          end
          if (cwrite_wire[wfcsh_int][2] && (cwrradr_wire[wfcsh_int][2] == wrfifo_new_row[wfifo_int+1]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][2];
          else if (cwrite_wire[wfcsh_int][1] && (cwrradr_wire[wfcsh_int][1] == wrfifo_new_row[wfifo_int+1]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][1];
          else if (cwrite_wire[wfcsh_int][0] && (cwrradr_wire[wfcsh_int][0] == wrfifo_new_row[wfifo_int+1]))
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= cdin_wire[wfcsh_int][0];
          else
            wrfifo_old_dat[wfcsh_int][wfifo_int] <= wrfifo_old_dat[wfcsh_int][wfifo_int+1];
        end
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int+1];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int+1];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int+1];
        wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int+1];
      end
*/
/*
  wire wrfifo_old_vld_0_0 = wrfifo_old_vld[0][0];
  wire [BITVBNK-1:0] wrfifo_old_map_0_0 = wrfifo_old_map[0][0];
  wire [WIDTH-1:0] wrfifo_old_dat_0_0 = wrfifo_old_dat[0][0];
  wire wrfifo_old_vld_1_0 = wrfifo_old_vld[1][0];
  wire [BITVBNK-1:0] wrfifo_old_map_1_0 = wrfifo_old_map[1][0];
  wire [WIDTH-1:0] wrfifo_old_dat_1_0 = wrfifo_old_dat[1][0];
  wire wrfifo_old_vld_2_0 = wrfifo_old_vld[2][0];
  wire [BITVBNK-1:0] wrfifo_old_map_2_0 = wrfifo_old_map[2][0];
  wire [WIDTH-1:0] wrfifo_old_dat_2_0 = wrfifo_old_dat[2][0];
  wire wrfifo_new_vld_0 = wrfifo_new_vld[0];
  wire [BITVBNK-1:0] wrfifo_new_map_0 = wrfifo_new_map[0];
  wire [BITVROW-1:0] wrfifo_new_row_0 = wrfifo_new_row[0];
  wire [WIDTH-1:0] wrfifo_new_dat_0 = wrfifo_new_dat[0];
  wire wrfifo_old_vld_0_1 = wrfifo_old_vld[0][1];
  wire [BITVBNK-1:0] wrfifo_old_map_0_1 = wrfifo_old_map[0][1];
  wire [WIDTH-1:0] wrfifo_old_dat_0_1 = wrfifo_old_dat[0][1];
  wire wrfifo_old_vld_1_1 = wrfifo_old_vld[1][1];
  wire [BITVBNK-1:0] wrfifo_old_map_1_1 = wrfifo_old_map[1][1];
  wire [WIDTH-1:0] wrfifo_old_dat_1_1 = wrfifo_old_dat[1][1];
  wire wrfifo_old_vld_2_1 = wrfifo_old_vld[2][1];
  wire [BITVBNK-1:0] wrfifo_old_map_2_1 = wrfifo_old_map[2][1];
  wire [WIDTH-1:0] wrfifo_old_dat_2_1 = wrfifo_old_dat[2][1];
  wire wrfifo_new_vld_1 = wrfifo_new_vld[1];
  wire [BITVBNK-1:0] wrfifo_new_map_1 = wrfifo_new_map[1];
  wire [BITVROW-1:0] wrfifo_new_row_1 = wrfifo_new_row[1];
  wire [WIDTH-1:0] wrfifo_new_dat_1 = wrfifo_new_dat[1];
  wire wrfifo_old_vld_0_2 = wrfifo_old_vld[0][2];
  wire [BITVBNK-1:0] wrfifo_old_map_0_2 = wrfifo_old_map[0][2];
  wire [WIDTH-1:0] wrfifo_old_dat_0_2 = wrfifo_old_dat[0][2];
  wire wrfifo_old_vld_1_2 = wrfifo_old_vld[1][2];
  wire [BITVBNK-1:0] wrfifo_old_map_1_2 = wrfifo_old_map[1][2];
  wire [WIDTH-1:0] wrfifo_old_dat_1_2 = wrfifo_old_dat[1][2];
  wire wrfifo_old_vld_2_2 = wrfifo_old_vld[2][2];
  wire [BITVBNK-1:0] wrfifo_old_map_2_2 = wrfifo_old_map[2][2];
  wire [WIDTH-1:0] wrfifo_old_dat_2_2 = wrfifo_old_dat[2][2];
  wire wrfifo_new_vld_2 = wrfifo_new_vld[2];
  wire [BITVBNK-1:0] wrfifo_new_map_2 = wrfifo_new_map[2];
  wire [BITVROW-1:0] wrfifo_new_row_2 = wrfifo_new_row[2];
  wire [WIDTH-1:0] wrfifo_new_dat_2 = wrfifo_new_dat[2];
  wire wrfifo_old_vld_0_3 = wrfifo_old_vld[0][3];
  wire [BITVBNK-1:0] wrfifo_old_map_0_3 = wrfifo_old_map[0][3];
  wire [WIDTH-1:0] wrfifo_old_dat_0_3 = wrfifo_old_dat[0][3];
  wire wrfifo_old_vld_1_3 = wrfifo_old_vld[1][3];
  wire [BITVBNK-1:0] wrfifo_old_map_1_3 = wrfifo_old_map[1][3];
  wire [WIDTH-1:0] wrfifo_old_dat_1_3 = wrfifo_old_dat[1][3];
  wire wrfifo_old_vld_2_3 = wrfifo_old_vld[2][3];
  wire [BITVBNK-1:0] wrfifo_old_map_2_3 = wrfifo_old_map[2][3];
  wire [WIDTH-1:0] wrfifo_old_dat_2_3 = wrfifo_old_dat[2][3];
  wire wrfifo_new_vld_3 = wrfifo_new_vld[3];
  wire [BITVBNK-1:0] wrfifo_new_map_3 = wrfifo_new_map[3];
  wire [BITVROW-1:0] wrfifo_new_row_3 = wrfifo_new_row[3];
  wire [WIDTH-1:0] wrfifo_new_dat_3 = wrfifo_new_dat[3];
*/
  integer wsrc_int, wsrp_int;
  always_comb begin
    for (wsrp_int=0; wsrp_int<NUMRDPT+NUMRWPT; wsrp_int=wsrp_int+1) begin
      wr_srch_flag[wsrp_int] = 1'b0;
      wr_srch_data[wsrp_int] = 0;
      for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
        if ((wrfifo_cnt > wsrc_int) &&
            wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == vwrbadr_out[wsrp_int]) && (wrfifo_new_row[wsrc_int] == vwrradr_out[wsrp_int])) begin
          wr_srch_flag[wsrp_int] = 1'b1;
          wr_srch_data[wsrp_int] = wrfifo_new_dat[wsrc_int];
        end
    end
    wr_srch_flags = 1'b0;
    wr_srch_datas = 0;
    for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == select_bank) && (wrfifo_new_row[wsrc_int] == select_row)) begin
        wr_srch_flags = 1'b1;
        wr_srch_datas = wrfifo_new_dat[wsrc_int];
      end
  end

  reg snew_vld [0:NUMRWPT+NUMWRPT-1];
  reg [BITVBNK-1:0] snew_map [0:NUMRWPT+NUMWRPT-1];
  reg [BITVROW-1:0] snew_row [0:NUMRWPT+NUMWRPT-1];
  reg [WIDTH-1:0] snew_dat [0:NUMRWPT+NUMWRPT-1];
  reg sold_vld [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
  reg [BITVBNK-1:0] sold_map [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
  reg [BITVROW-1:0] sold_row [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
  reg [WIDTH-1:0] sold_dat [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
  integer snew_int, sold_int, snpt_int;
  always_comb 
    for (snew_int=0; snew_int<NUMRWPT+NUMWRPT; snew_int=snew_int+1) 
      if (snew_int<wrfifo_dcnt) begin
        snew_vld[snew_int] = wrfifo_new_vld[snew_int];
        for (snpt_int=0; snpt_int<FIFOCNT; snpt_int=snpt_int+1)
          if ((snpt_int>snew_int) && (snpt_int<wrfifo_dcnt))
            snew_vld[snew_int] = snew_vld[snew_int] && !(wrfifo_new_vld[snpt_int] &&
						         (wrfifo_new_map[snpt_int] == wrfifo_new_map[snew_int]) &&
						         (wrfifo_new_row[snpt_int] == wrfifo_new_row[snew_int])); 
        snew_map[snew_int] = wrfifo_new_map[snew_int];
        snew_row[snew_int] = wrfifo_new_row[snew_int];
        snew_dat[snew_int] = wrfifo_new_dat[snew_int];
        for (sold_int=0; sold_int<NUMCASH; sold_int=sold_int+1) begin
          sold_vld[sold_int][snew_int] = wrfifo_old_vld[sold_int][snew_int];
          sold_map[sold_int][snew_int] = wrfifo_old_map[sold_int][snew_int];
          sold_row[sold_int][snew_int] = wrfifo_new_row[snew_int];
          sold_dat[sold_int][snew_int] = wrfifo_old_dat[sold_int][snew_int];
        end
/*
      end else if (wrfifo_deq[snew_int] && (snew_int>0)) begin
        snew_vld[snew_int] = wrfifo_new_vld[snew_int-1];
        snew_map[snew_int] = wrfifo_new_map[snew_int-1];
        snew_row[snew_int] = wrfifo_new_row[snew_int-1];
        snew_dat[snew_int] = wrfifo_new_dat[snew_int-1];
        for (sold_int=0; sold_int<NUMCASH; sold_int=sold_int+1) begin
          sold_vld[sold_int][snew_int] = wrfifo_old_vld[sold_int][snew_int-1];
          sold_map[sold_int][snew_int] = wrfifo_old_map[sold_int][snew_int-1];
          sold_row[sold_int][snew_int] = wrfifo_new_row[snew_int-1];
          sold_dat[sold_int][snew_int] = wrfifo_old_dat[sold_int][snew_int-1];
        end
*/
      end else begin
        snew_vld[snew_int] = 1'b0;
        snew_map[snew_int] = 0;
        snew_row[snew_int] = 0;
        snew_dat[snew_int] = 0;
        for (sold_int=0; sold_int<NUMCASH; sold_int=sold_int+1) begin
          sold_vld[sold_int][snew_int] = 1'b0;
          sold_map[sold_int][snew_int] = 0;
          sold_row[sold_int][snew_int] = 0;
          sold_dat[sold_int][snew_int] = 0;
        end
      end

/*
  wire snew_vld_0 = snew_vld[0];
  wire [BITVBNK-1:0] snew_map_0 = snew_map[0];
  wire [BITVROW-1:0] snew_row_0 = snew_row[0];
  wire [WIDTH-1:0] snew_dat_0 = snew_dat[0];
  wire sold_vld_0_0 = sold_vld[0][0];
  wire [BITVBNK-1:0] sold_map_0_0 = sold_map[0][0];
  wire [BITVROW-1:0] sold_row_0_0 = sold_row[0][0];
  wire [WIDTH-1:0] sold_dat_0_0 = sold_dat[0][0];
  wire sold_vld_1_0 = sold_vld[1][0];
  wire [BITVBNK-1:0] sold_map_1_0 = sold_map[1][0];
  wire [BITVROW-1:0] sold_row_1_0 = sold_row[1][0];
  wire [WIDTH-1:0] sold_dat_1_0 = sold_dat[1][0];
  wire sold_vld_2_0 = sold_vld[2][0];
  wire [BITVBNK-1:0] sold_map_2_0 = sold_map[2][0];
  wire [BITVROW-1:0] sold_row_2_0 = sold_row[2][0];
  wire [WIDTH-1:0] sold_dat_2_0 = sold_dat[2][0];
  wire snew_vld_1 = snew_vld[1];
  wire [BITVBNK-1:0] snew_map_1 = snew_map[1];
  wire [BITVROW-1:0] snew_row_1 = snew_row[1];
  wire [WIDTH-1:0] snew_dat_1 = snew_dat[1];
  wire sold_vld_0_1 = sold_vld[0][1];
  wire [BITVBNK-1:0] sold_map_0_1 = sold_map[0][1];
  wire [BITVROW-1:0] sold_row_0_1 = sold_row[0][1];
  wire [WIDTH-1:0] sold_dat_0_1 = sold_dat[0][1];
  wire sold_vld_1_1 = sold_vld[1][1];
  wire [BITVBNK-1:0] sold_map_1_1 = sold_map[1][1];
  wire [BITVROW-1:0] sold_row_1_1 = sold_row[1][1];
  wire [WIDTH-1:0] sold_dat_1_1 = sold_dat[1][1];
  wire sold_vld_2_1 = sold_vld[2][1];
  wire [BITVBNK-1:0] sold_map_2_1 = sold_map[2][1];
  wire [BITVROW-1:0] sold_row_2_1 = sold_row[2][1];
  wire [WIDTH-1:0] sold_dat_2_1 = sold_dat[2][1];
  wire snew_vld_2 = snew_vld[2];
  wire [BITVBNK-1:0] snew_map_2 = snew_map[2];
  wire [BITVROW-1:0] snew_row_2 = snew_row[2];
  wire [WIDTH-1:0] snew_dat_2 = snew_dat[2];
  wire sold_vld_0_2 = sold_vld[0][2];
  wire [BITVBNK-1:0] sold_map_0_2 = sold_map[0][2];
  wire [BITVROW-1:0] sold_row_0_2 = sold_row[0][2];
  wire [WIDTH-1:0] sold_dat_0_2 = sold_dat[0][2];
  wire sold_vld_1_2 = sold_vld[1][2];
  wire [BITVBNK-1:0] sold_map_1_2 = sold_map[1][2];
  wire [BITVROW-1:0] sold_row_1_2 = sold_row[1][2];
  wire [WIDTH-1:0] sold_dat_1_2 = sold_dat[1][2];
  wire sold_vld_2_2 = sold_vld[2][2];
  wire [BITVBNK-1:0] sold_map_2_2 = sold_map[2][2];
  wire [BITVROW-1:0] sold_row_2_2 = sold_row[2][2];
  wire [WIDTH-1:0] sold_dat_2_2 = sold_dat[2][2];
  wire snew_vld_3 = snew_vld[3];
  wire [BITVBNK-1:0] snew_map_3 = snew_map[3];
  wire [BITVROW-1:0] snew_row_3 = snew_row[3];
  wire [WIDTH-1:0] snew_dat_3 = snew_dat[3];
  wire sold_vld_0_3 = sold_vld[0][3];
  wire [BITVBNK-1:0] sold_map_0_3 = sold_map[0][3];
  wire [BITVROW-1:0] sold_row_0_3 = sold_row[0][3];
  wire [WIDTH-1:0] sold_dat_0_3 = sold_dat[0][3];
  wire sold_vld_1_3 = sold_vld[1][3];
  wire [BITVBNK-1:0] sold_map_1_3 = sold_map[1][3];
  wire [BITVROW-1:0] sold_row_1_3 = sold_row[1][3];
  wire [WIDTH-1:0] sold_dat_1_3 = sold_dat[1][3];
  wire sold_vld_2_3 = sold_vld[2][3];
  wire [BITVBNK-1:0] sold_map_2_3 = sold_map[2][3];
  wire [BITVROW-1:0] sold_row_2_3 = sold_row[2][3];
  wire [WIDTH-1:0] sold_dat_2_3 = sold_dat[2][3];
*/
  // Write request to pivoted banks
  reg new_to_pivot [0:NUMRWPT+NUMWRPT-1];
  reg [NUMCASH-1:0] new_to_cshht [0:NUMRWPT+NUMWRPT-1];
  reg [NUMCASH-1:0] new_to_cshms [0:NUMRWPT+NUMWRPT-1];
  reg [NUMCASH-1:0] old_to_pivot [0:NUMRWPT+NUMWRPT-1];
  reg [NUMVBNK-1:0] used_pivot [0:NUMRWPT+NUMWRPT-1];
  reg [NUMCASH-1:0] used_cshht [0:NUMRWPT+NUMWRPT-1];
  reg [NUMCASH-1:0] used_cshms [0:NUMRWPT+NUMWRPT-1];

  integer newc_int, newp_int, newx_int;
  reg [NUMVBNK-1:0] used_pivot_temp [0:NUMRWPT+NUMWRPT-1];
  reg [NUMCASH-1:0] used_cshht_temp [0:NUMRWPT+NUMWRPT-1];
  reg [NUMCASH-1:0] used_cshms_temp [0:NUMRWPT+NUMWRPT-1];
  always_comb begin
    for (newp_int=0; newp_int<NUMRWPT+NUMWRPT; newp_int=newp_int+1) begin
      if (newp_int==0)
        used_cshht_temp[newp_int] = 0;
      else
        used_cshht_temp[newp_int] = used_cshht[newp_int-1];
      new_to_cshht[newp_int] = 0;
      for (newc_int=0; newc_int<NUMCASH; newc_int=newc_int+1)
        if (snew_vld[newp_int] && sold_vld[newc_int][newp_int] && (snew_map[newp_int] == sold_map[newc_int][newp_int]) && !used_cshht_temp[newp_int][newc_int])
          new_to_cshht[newp_int] = 1'b1 << newc_int;
      used_cshht[newp_int] = used_cshht_temp[newp_int] | new_to_cshht[newp_int];
    end
    for (newp_int=0; newp_int<NUMRWPT+NUMWRPT; newp_int=newp_int+1) begin
      if (newp_int==0) begin
        used_pivot_temp[newp_int] = 0;
        for (newx_int=0; newx_int<NUMRDPT+NUMRWPT; newx_int=newx_int+1)
          if (vread_wire[newx_int])
            used_pivot_temp[newp_int] = used_pivot_temp[newp_int] | (1'b1 << vbadr_wire[newx_int]);
        used_cshms_temp[newp_int] = used_cshht[NUMRWPT+NUMWRPT-1];
      end else begin
        used_pivot_temp[newp_int] = used_pivot[newp_int-1];
        used_cshms_temp[newp_int] = used_cshms[newp_int-1];
      end
      new_to_pivot[newp_int] = snew_vld[newp_int] && !used_pivot_temp[newp_int][snew_map[newp_int]] && !(|new_to_cshht[newp_int]);
      new_to_cshms[newp_int] = 0;
      old_to_pivot[newp_int] = 0;
      if (!new_to_pivot[newp_int] && !(|new_to_cshht[newp_int]))
        for (newc_int=0; newc_int<NUMCASH; newc_int=newc_int+1)
          if (snew_vld[newp_int] && !used_cshms_temp[newp_int][newc_int] && !(sold_vld[newc_int][newp_int] && used_pivot_temp[newp_int][sold_map[newc_int][newp_int]])) begin
            new_to_cshms[newp_int] = 1'b1 << newc_int;
            old_to_pivot[newp_int] = (sold_vld[newc_int][newp_int] && (sold_map[newc_int][newp_int] != snew_map[newp_int])) << newc_int;
          end
      used_pivot[newp_int] = used_pivot_temp[newp_int];
      if (new_to_pivot[newp_int])
        used_pivot[newp_int] = used_pivot[newp_int] | (1'b1 << snew_map[newp_int]);
      for (newc_int=0; newc_int<NUMCASH; newc_int=newc_int+1)
        if (old_to_pivot[newp_int][newc_int])
          used_pivot[newp_int] = used_pivot[newp_int] | (1'b1 << sold_map[newc_int][newp_int]);
      used_cshms[newp_int] = used_cshms_temp[newp_int] | new_to_cshms[newp_int];
    end
  end

/*
  assign new_to_pivot[0] = snew_vld[0] && !(sold_vld[0][0] && (snew_map[0] != sold_map[0][0]));
  assign new_to_cache[0][0] = snew_vld[0] && (sold_vld[0][0] && (snew_map[0] == sold_map[0][0]));
  assign new_to_cache[1][0] = 1'b0;
  assign new_to_cache[2][0] = 1'b0;
  assign old_to_pivot[0][0] = 1'b0;
  assign old_to_pivot[1][0] = 1'b0;
  assign old_to_pivot[2][0] = 1'b0;
  assign used_pivot[0] = vread_wire[0] << vbadr_wire[0];

  assign new_to_pivot[1] = snew_vld[1] && !used_pivot[0][snew_map[1]];
  assign new_to_cache[0][1] = snew_vld[1] && !new_to_pivot[1];
  assign new_to_cache[1][1] = 1'b0;
  assign new_to_cache[2][1] = 1'b0;
  assign old_to_pivot[0][1] = sold_vld[0][1] && new_to_cache[0][1] && (sold_map[0][1] != snew_map[1]) &&
			      !(snew_vld[2] && (sold_map[0][1] == snew_map[2]) && (sold_row[0][1] == snew_row[2])) &&
			      !(snew_vld[3] && (sold_map[0][1] == snew_map[3]) && (sold_row[0][1] == snew_row[3]));
  assign old_to_pivot[1][1] = 1'b0;
  assign old_to_pivot[2][1] = 1'b0;
  assign used_pivot[1] = used_pivot[0] | (new_to_pivot[1] << snew_map[1]) | (old_to_pivot[0][1] << sold_map[0][1]);

  assign new_to_pivot[2] = snew_vld[2] && !used_pivot[1][snew_map[2]];
  assign new_to_cache[0][2] = snew_vld[2] && !new_to_pivot[2] && (!sold_vld[0][2] || !used_pivot[1][sold_map[0][2]] || (sold_map[0][2] == snew_map[2]));
  assign new_to_cache[1][2] = snew_vld[2] && !new_to_pivot[2] && !new_to_cache[0][2] && (!sold_vld[1][2] || !used_pivot[1][sold_map[1][2]] || (sold_map[1][2] == snew_map[2]));
  assign new_to_cache[2][2] = 1'b0;
  assign old_to_pivot[0][2] = sold_vld[0][2] && new_to_cache[0][2] && (sold_map[0][2] != snew_map[2]) &&
			     !(snew_vld[3] && (sold_map[0][2] == snew_map[3]) && (sold_row[0][2] == snew_row[3]));
  assign old_to_pivot[1][2] = sold_vld[1][2] && new_to_cache[1][2] && (sold_map[1][2] != snew_map[2]) &&
			     !(snew_vld[3] && (sold_map[1][2] == snew_map[3]) && (sold_row[1][2] == snew_row[3]));
  assign old_to_pivot[2][2] = 1'b0;
  assign used_pivot[2] = used_pivot[1] | (new_to_pivot[2] << snew_map[2]) | (old_to_pivot[0][2] << sold_map[0][2]) |(old_to_pivot[1][2] << sold_map[1][2]);

  assign new_to_pivot[3] = snew_vld[3] && !used_pivot[2][snew_map[3]];
  assign new_to_cache[0][3] = snew_vld[3] && !new_to_pivot[3] && (!sold_vld[0][3] || !used_pivot[2][sold_map[0][3]] || (sold_map[0][3] == snew_map[3])) &&
			      !(new_to_cache[0][1] && (snew_row[1] == snew_row[3])) &&
		              !(new_to_cache[0][2] && (snew_row[2] == snew_row[3])); 
  assign new_to_cache[1][3] = snew_vld[3] && !new_to_pivot[3] && !new_to_cache[0][3] && (!sold_vld[1][3] || !used_pivot[2][sold_map[1][3]] || (sold_map[1][3] == snew_map[3]));
  assign new_to_cache[2][3] = snew_vld[3] && !new_to_pivot[3] && !new_to_cache[0][3] && !new_to_cache[1][3] && (!sold_vld[2][3] || !used_pivot[2][sold_map[2][3]] || (sold_map[2][3] == snew_map[3]));
  assign old_to_pivot[0][3] = sold_vld[0][3] && new_to_cache[0][3] && (sold_map[0][3] != snew_map[3]);
  assign old_to_pivot[1][3] = sold_vld[1][3] && new_to_cache[1][3] && (sold_map[1][3] != snew_map[3]);
  assign old_to_pivot[2][3] = sold_vld[2][3] && new_to_cache[2][3] && (sold_map[2][3] != snew_map[3]);
*/
/*
  wire new_to_pivot_0 = new_to_pivot[0];
  wire [NUMCASH-1:0] new_to_cshht_0 = new_to_cshht[0];
  wire [NUMCASH-1:0] new_to_cshms_0 = new_to_cshms[0];
  wire [NUMCASH-1:0] old_to_pivot_0 = old_to_pivot[0];
  wire [NUMVBNK-1:0] used_pivot_0 = used_pivot[0];
  wire [NUMVBNK-1:0] used_pivot_temp_0 = used_pivot_temp[0];
  wire [NUMCASH-1:0] used_cshht_0 = used_cshht[0];
  wire [NUMCASH-1:0] used_cshht_temp_0 = used_cshht_temp[0];
  wire [NUMCASH-1:0] used_cshms_0 = used_cshms[0];
  wire new_to_pivot_1 = new_to_pivot[1];
  wire [NUMCASH-1:0] new_to_cshht_1 = new_to_cshht[1];
  wire [NUMCASH-1:0] new_to_cshms_1 = new_to_cshms[1];
  wire [NUMCASH-1:0] old_to_pivot_1 = old_to_pivot[1];
  wire [NUMVBNK-1:0] used_pivot_1 = used_pivot[1];
  wire [NUMVBNK-1:0] used_pivot_temp_1 = used_pivot_temp[1];
  wire [NUMCASH-1:0] used_cshht_1 = used_cshht[1];
  wire [NUMCASH-1:0] used_cshht_temp_1 = used_cshht_temp[1];
  wire [NUMCASH-1:0] used_cshms_1 = used_cshms[1];
  wire new_to_pivot_2 = new_to_pivot[2];
  wire [NUMCASH-1:0] new_to_cshht_2 = new_to_cshht[2];
  wire [NUMCASH-1:0] new_to_cshms_2 = new_to_cshms[2];
  wire [NUMCASH-1:0] old_to_pivot_2 = old_to_pivot[2];
  wire [NUMVBNK-1:0] used_pivot_2 = used_pivot[2];
  wire [NUMCASH-1:0] used_cshht_2 = used_cshht[2];
  wire [NUMCASH-1:0] used_cshms_2 = used_cshms[2];
  wire new_to_pivot_3 = new_to_pivot[3];
  wire [NUMCASH-1:0] new_to_cshht_3 = new_to_cshht[3];
  wire [NUMCASH-1:0] new_to_cshms_3 = new_to_cshms[3];
  wire [NUMCASH-1:0] old_to_pivot_3 = old_to_pivot[3];
  wire [NUMVBNK-1:0] used_pivot_3 = used_pivot[3];
  wire [NUMCASH-1:0] used_cshht_3 = used_cshht[3];
  wire [NUMCASH-1:0] used_cshms_3 = used_cshms[3];
*/
/*
  wire old_to_clear [0:NUMCASH-1][0:NUMWRPT-1];
  assign old_to_clear[0][0] = 1'b0;
  assign old_to_clear[1][0] = 1'b0;
  assign old_to_clear[2][0] = 1'b0;
  assign old_to_clear[0][1] = sold_vld[0][1] && (new_to_pivot[1] && (sold_map[0][1] == snew_map[1]));
  assign old_to_clear[1][1] = sold_vld[1][1] && ((new_to_pivot[1] || new_to_cache[0][1]) && (sold_map[1][1] == snew_map[1]));
  assign old_to_clear[2][1] = sold_vld[2][1] && ((new_to_pivot[1] || new_to_cache[0][1]) && (sold_map[2][1] == snew_map[1]));
  assign old_to_clear[0][2] = sold_vld[0][2] && ((new_to_pivot[2] || new_to_cache[1][2]) && (sold_map[0][2] == snew_map[2])) &&
			      !(new_to_cache[0][1] && (snew_row[1] == sold_row[0][2]));
  assign old_to_clear[1][2] = sold_vld[1][2] && ((new_to_pivot[2] || new_to_cache[0][2]) && (sold_map[1][2] == snew_map[2]));
  assign old_to_clear[2][2] = sold_vld[2][2] && ((new_to_pivot[2] || new_to_cache[0][2] || new_to_cache[1][2]) && (sold_map[2][2] == snew_map[2]));
  assign old_to_clear[0][3] = sold_vld[0][3] && ((new_to_pivot[3] || new_to_cache[1][3] || new_to_cache[2][3]) && (sold_map[0][3] == snew_map[3])) &&
                              !(new_to_cache[0][1] && (snew_row[1] == sold_row[0][3])) &&
    		     	      !(new_to_cache[0][2] && (snew_row[2] == sold_row[0][3]));
  assign old_to_clear[1][3] = sold_vld[1][3] && ((new_to_pivot[3] || new_to_cache[0][3] || new_to_cache[2][3]) && (sold_map[1][3] == snew_map[3])) &&
                              !(new_to_cache[1][2] && (snew_row[2] == sold_row[1][3]));
  assign old_to_clear[2][3] = sold_vld[2][3] && ((new_to_pivot[3] || new_to_cache[0][3] || new_to_cache[1][3]) && (sold_map[2][3] == snew_map[3]));
*/

  reg old_to_clear [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
  reg old_to_clear_temp [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
  integer oldc_int, oldp_int, oldx_int;
  always_comb
    for (oldp_int=0; oldp_int<NUMRWPT+NUMWRPT; oldp_int=oldp_int+1)
      for (oldc_int=0; oldc_int<NUMCASH; oldc_int=oldc_int+1) begin
        old_to_clear[oldc_int][oldp_int] = new_to_pivot[oldp_int];
        for (oldx_int=0; oldx_int<NUMCASH; oldx_int=oldx_int+1)
          old_to_clear[oldc_int][oldp_int] = old_to_clear[oldc_int][oldp_int] || new_to_cshht[oldp_int][oldx_int] || new_to_cshms[oldp_int][oldx_int];
        old_to_clear_temp[oldc_int][oldp_int] = old_to_clear[oldc_int][oldp_int];
        old_to_clear[oldc_int][oldp_int] = old_to_clear[oldc_int][oldp_int] && sold_vld[oldc_int][oldp_int] && (sold_map[oldc_int][oldp_int] == snew_map[oldp_int]);
        for (oldx_int=0; oldx_int<NUMRWPT+NUMWRPT; oldx_int=oldx_int+1)
          old_to_clear[oldc_int][oldp_int] = old_to_clear[oldc_int][oldp_int] &&
					     !((new_to_cshht[oldx_int][oldc_int] || new_to_cshms[oldx_int][oldc_int]) && (snew_row[oldx_int] == sold_row[oldc_int][oldp_int]));
      end
/*
  wire old_to_clear_temp_0_0 = old_to_clear_temp[0][0];
  wire old_to_clear_temp_1_0 = old_to_clear_temp[1][0];
  wire old_to_clear_temp_2_0 = old_to_clear_temp[2][0];

  wire old_to_clear_0_0 = old_to_clear[0][0];
  wire old_to_clear_0_1 = old_to_clear[0][1];
  wire old_to_clear_0_2 = old_to_clear[0][2];
  wire old_to_clear_0_3 = old_to_clear[0][3];
  wire old_to_clear_1_0 = old_to_clear[1][0];
  wire old_to_clear_1_1 = old_to_clear[1][1];
  wire old_to_clear_1_2 = old_to_clear[1][2];
  wire old_to_clear_1_3 = old_to_clear[1][3];
  wire old_to_clear_2_0 = old_to_clear[2][0];
  wire old_to_clear_2_1 = old_to_clear[2][1];
  wire old_to_clear_2_2 = old_to_clear[2][2];
  wire old_to_clear_2_3 = old_to_clear[2][3];
*/
  integer pwrp_int, pwrc_int;
  always_comb begin
    for (pwrp_int=0; pwrp_int<NUMRWPT+NUMWRPT; pwrp_int=pwrp_int+1) begin
      pwrite_wire[pwrp_int] = 1'b0;
      pwrbadr_wire[pwrp_int] = 0;
      pwrradr_wire[pwrp_int] = 0;
      pdin_wire[pwrp_int] = 0;
    end
    for (pwrp_int=0; pwrp_int<NUMRWPT+NUMWRPT; pwrp_int=pwrp_int+1)
      if (new_to_pivot[pwrp_int]) begin
        pwrite_wire[pwrp_int] = 1'b1;
        pwrbadr_wire[pwrp_int] = snew_map[pwrp_int];
        pwrradr_wire[pwrp_int] = snew_row[pwrp_int];
        pdin_wire[pwrp_int] = snew_dat[pwrp_int];
      end else for (pwrc_int=0; pwrc_int<NUMCASH; pwrc_int=pwrc_int+1) begin
        if (old_to_pivot[pwrp_int][pwrc_int]) begin
          pwrite_wire[pwrp_int] = 1'b1;
          pwrbadr_wire[pwrp_int] = sold_map[pwrc_int][pwrp_int];
          pwrradr_wire[pwrp_int] = sold_row[pwrc_int][pwrp_int];
          pdin_wire[pwrp_int] = sold_dat[pwrc_int][pwrp_int];
        end
      end
  end

  integer swrp_int, swrc_int, swrx_int;
  always_comb
    for (swrp_int=0; swrp_int<NUMRWPT+NUMWRPT; swrp_int=swrp_int+1) 
      for (swrc_int=0; swrc_int<NUMCASH; swrc_int=swrc_int+1)
        if (rstvld && (swrp_int==0)) begin
          swrite_wire[swrc_int][swrp_int] = 1'b1;
	  swrradr_wire[swrc_int][swrp_int] = rstaddr;
	  sdin_pre_ecc[swrc_int][swrp_int] = 0;
        end else if (new_to_cshms[swrp_int][swrc_int]) begin
          swrite_wire[swrc_int][swrp_int] = 1'b1;
	  swrradr_wire[swrc_int][swrp_int] = snew_row[swrp_int];
	  sdin_pre_ecc[swrc_int][swrp_int] = {1'b1,snew_map[swrp_int]};
        end else if (old_to_clear[swrc_int][swrp_int]) begin
          swrite_wire[swrc_int][swrp_int] = 1'b1;
	  swrradr_wire[swrc_int][swrp_int] = sold_row[swrc_int][swrp_int];
	  sdin_pre_ecc[swrc_int][swrp_int] = 0;
//          for (swrx_int=0; swrx_int<NUMRWPT+NUMWRPT; swrx_int=swrx_int+1)
//            if (swrx_int<swrp_int)
//              swrite_wire[swrc_int][swrp_int] = swrite_wire[swrc_int][swrp_int] &&
//                                                !(swrite_wire[swrc_int][swrx_int] && (swrradr_wire[swrc_int][swrx_int] == swrradr_wire[swrc_int][swrp_int]));
        end else begin
          swrite_wire[swrc_int][swrp_int] = 1'b0;
	  swrradr_wire[swrc_int][swrp_int] = 0;
	  sdin_pre_ecc[swrc_int][swrp_int] = 0;
        end

  genvar ecsh_int, ewpt_int;
  generate for (ecsh_int=0; ecsh_int<NUMCASH; ecsh_int=ecsh_int+1) begin: ecsh_loop
    for (ewpt_int=0; ewpt_int<NUMRWPT+NUMWRPT; ewpt_int=ewpt_int+1) begin: ewpt_loop
      wire [ECCBITS-1:0] sdin_ecc;
      ecc_calc   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
        ecc_calc_inst (.din(sdin_pre_ecc[ecsh_int][ewpt_int]), .eccout(sdin_ecc));
      assign sdin_wire[ecsh_int][ewpt_int] = {sdin_pre_ecc[ecsh_int][ewpt_int],sdin_ecc,sdin_pre_ecc[ecsh_int][ewpt_int]};
    end
  end
  endgenerate

  integer cwrp_int, cwrc_int;
  always_comb
    for (cwrc_int=0; cwrc_int<NUMCASH; cwrc_int=cwrc_int+1)
      if (rstvld) begin
        cwrite_wire[cwrc_int] = 1'b1;
        cwrradr_wire[cwrc_int] = rstaddr;
        cdin_wire[cwrc_int] = 0;
      end else begin
        cwrite_wire[cwrc_int] = 1'b0;
        cwrradr_wire[cwrc_int] = 0;
        cdin_wire[cwrc_int] = 0;
        for (cwrp_int=0; cwrp_int<NUMRWPT+NUMWRPT; cwrp_int=cwrp_int+1) 
          if (new_to_cshht[cwrp_int][cwrc_int] || new_to_cshms[cwrp_int][cwrc_int]) begin
            cwrite_wire[cwrc_int] = 1'b1;
	    cwrradr_wire[cwrc_int] = snew_row[cwrp_int];
	    cdin_wire[cwrc_int] = snew_dat[cwrp_int];
          end
      end

  assign prefr = vrefr_wire || !ready_wire;

  reg [(NUMRDPT+NUMRWPT)-1:0] pread;
  reg [(NUMRDPT+NUMRWPT)*BITVBNK-1:0] prdbadr;
  reg [(NUMRDPT+NUMRWPT)*BITVROW-1:0] prdradr;
  integer prd_int;
  always_comb begin
    pread = 0;
    prdbadr = 0;
    prdradr = 0;
    for (prd_int=0; prd_int<NUMRDPT+NUMRWPT; prd_int=prd_int+1) begin
      pread = pread | (pread_wire[prd_int] << prd_int);
      prdbadr = prdbadr | (prdbadr_wire[prd_int] << (prd_int*BITVBNK));
      prdradr = prdradr | (prdradr_wire[prd_int] << (prd_int*BITVROW));
    end
  end

  reg [(NUMRWPT+NUMWRPT)-1:0] pwrite;
  reg [(NUMRWPT+NUMWRPT)*BITVBNK-1:0] pwrbadr;
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
      pwrbadr = pwrbadr | (pwrbadr_wire[pwr_int] << (pwr_int*BITVBNK));
      pwrradr = pwrradr | (pwrradr_wire[pwr_int] << (pwr_int*BITVROW));
      pdin = pdin | (pdin_wire[pwr_int] << (pwr_int*WIDTH));
    end
  end

  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] sread;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] srdradr;
  reg [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] swrite;
  reg [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW-1:0] swrradr;
  reg [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] sdin;
  integer smcc_int, smcp_int;
  always_comb begin
    sread = 0;
    srdradr = 0;
    swrite = 0;
    swrradr = 0;
    sdin = 0;
    for (smcc_int=0; smcc_int<NUMCASH; smcc_int=smcc_int+1) begin
      for (smcp_int=0; smcp_int<NUMRDPT+NUMRWPT+NUMWRPT; smcp_int=smcp_int+1) begin
        sread = sread | (sread_wire[smcc_int][smcp_int] << (smcc_int*(NUMRDPT+NUMRWPT+NUMWRPT)+smcp_int));
        srdradr = srdradr | (srdradr_wire[smcc_int][smcp_int] << ((smcc_int*(NUMRDPT+NUMRWPT+NUMWRPT)+smcp_int)*BITVROW));
      end
      for (smcp_int=0; smcp_int<NUMRWPT+NUMWRPT; smcp_int=smcp_int+1) begin
        swrite = swrite | (swrite_wire[smcc_int][smcp_int] << (smcc_int*(NUMRWPT+NUMWRPT)/*+smcp_int*/));
        swrradr = swrradr | (swrradr_wire[smcc_int][smcp_int] << ((smcc_int*(NUMRWPT+NUMWRPT)/*+smcp_int*/)*BITVROW));
        sdin = sdin | (sdin_wire[smcc_int][smcp_int] << ((smcc_int*(NUMRWPT+NUMWRPT)/*+smcp_int*/)*SDOUT_WIDTH));
      end
    end
  end

  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] cread;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] crdradr;
  reg [NUMCASH-1:0] cwrite;
  reg [NUMCASH*BITVROW-1:0] cwrradr;
  reg [NUMCASH*WIDTH-1:0] cdin;
  integer cmcc_int, cmcp_int;
  always_comb begin
    cread = 0;
    crdradr = 0;
    cwrite = 0;
    cwrradr = 0;
    cdin = 0;
    for (cmcc_int=0; cmcc_int<NUMCASH; cmcc_int=cmcc_int+1) begin
      for (cmcp_int=0; cmcp_int<NUMRDPT+NUMRWPT+NUMWRPT; cmcp_int=cmcp_int+1) begin
        cread = cread | (cread_wire[cmcc_int][cmcp_int] << (cmcc_int*(NUMRDPT+NUMRWPT+NUMWRPT)+cmcp_int));
        crdradr = crdradr | (crdradr_wire[cmcc_int][cmcp_int] << ((cmcc_int*(NUMRDPT+NUMRWPT+NUMWRPT)+cmcp_int)*BITVROW));
      end
      cwrite = cwrite | (cwrite_wire[cmcc_int] << cmcc_int);
      cwrradr = cwrradr | (cwrradr_wire[cmcc_int] << (cmcc_int*BITVROW));
      cdin = cdin | (cdin_wire[cmcc_int] << (cmcc_int*WIDTH));
    end
  end

endmodule
