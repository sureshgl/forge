
module core_2rw_rl_edram (vrefr, vread, vwrite, vaddr, vdin, vread_vld, vdout, vread_serr, vread_derr, vread_padr,
                          pwrite, pwrbadr, pwrradr, pdin,
                          pread1, prdbadr1, prdradr1, pdout1, pdout1_serr, pdout1_derr, pdout1_padr,
                          pread2, prdbadr2, prdradr2, pdout2, pdout2_serr, pdout2_derr, pdout2_padr,
	                  prefr, prfbadr, prfradr,
   	                  swrite, swrradr, sdin,
	                  sread, srdradr, sdout,
                          cwrite, cwrradr, cdin,
	                  cread, crdradr, cdout,
                          ready, clk, rst,
			  select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter REFRESH = 0;
  
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPOUT = 0;

  parameter BITPADR = 17;
  parameter ECCBITS = 4;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  parameter FIFOCNT = 2*SRAM_DELAY+2;

  input                              vrefr;

  input                              vread;
  input                              vwrite;
  input [BITADDR-1:0]                vaddr;
  input [WIDTH-1:0]                  vdin;
  output                             vread_vld;
  output [WIDTH-1:0]                 vdout;
  output                             vread_serr;
  output                             vread_derr;
  output [BITPADR-1:0]               vread_padr;

  output                             pwrite;
  output [BITVBNK-1:0]               pwrbadr;
  output [BITVROW-1:0]               pwrradr;
  output [WIDTH-1:0]                 pdin;

  output                             pread1;
  output [BITVBNK-1:0]               prdbadr1;
  output [BITVROW-1:0]               prdradr1;
  input [WIDTH-1:0]                  pdout1;
  input                              pdout1_serr;
  input                              pdout1_derr;
  input [BITPADR-2:0]                pdout1_padr;

  output                             pread2;
  output [BITVBNK-1:0]               prdbadr2;
  output [BITVROW-1:0]               prdradr2;
  input [WIDTH-1:0]                  pdout2;
  input                              pdout2_serr;
  input                              pdout2_derr;
  input [BITPADR-2:0]                pdout2_padr;

  output			     prefr;
  output [BITVBNK-1:0]               prfbadr;
  output [BITVROW-1:0]               prfradr;

  output                             swrite;
  output [BITVROW-1:0]               swrradr;
  output [SDOUT_WIDTH-1:0]           sdin;
  
  output                             sread;
  output [BITVROW-1:0]               srdradr;
  input [SDOUT_WIDTH-1:0]            sdout;
  
  output                             cwrite;
  output [BITVROW-1:0]               cwrradr;
  output [WIDTH-1:0]                 cdin;
  
  output                             cread;
  output [BITVROW-1:0]               crdradr;
  input [WIDTH-1:0]                  cdout;
  
  output                             ready;
  input                              clk;
  input                              rst;

  input [BITADDR-1:0]                select_addr;
  input [BITWDTH-1:0]                select_bit;

  reg rate_limit;
  always @(posedge clk)
    if (rst)
      rate_limit <= 1'b0;
    else
      rate_limit <= !rate_limit;

  reg [BITVROW:0] rstaddr;
  wire rstdone = (rstaddr == NUMVROW);
  wire rstvld = (rate_limit || !REFRESH) && !rstdone;
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg rstdone_reg [0:SRAM_DELAY];
  integer rst_int;
  always @(posedge clk)
    for (rst_int=0; rst_int<SRAM_DELAY+1; rst_int=rst_int+1)
      if (rst_int>0)
        rstdone_reg[rst_int] <= rstdone_reg[rst_int-1];
      else
        rstdone_reg[rst_int] <= rstdone;

  reg ready;
  always @(posedge clk)
    ready <= rstdone && rstdone_reg[SRAM_DELAY];

  reg request;
  always @(posedge clk)
    if (rst)
      request <= 1'b0;
    else
      request <= !request && ready;

  wire [BITVBNK-1:0] vbadr;
  wire [BITVROW-1:0] vradr;
  np2_addr #(
    .NUMADDR (NUMADDR), .BITADDR (BITADDR),
    .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
    .NUMVROW (NUMVROW), .BITVROW (BITVROW))
    adr_inst (.vbadr(vbadr), .vradr(vradr), .vaddr(vaddr));

  wire [BITVBNK-1:0] select_bank;
  wire [BITVROW-1:0] select_row;
  np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
             .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
             .NUMVROW (NUMVROW), .BITVROW (BITVROW))
    sel_adr (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));

  reg                request_reg [0:DRAM_DELAY];
  reg                vrefr_reg [0:DRAM_DELAY];
  reg                vread_reg [0:DRAM_DELAY];
  reg                vwrite_reg [0:DRAM_DELAY];
  reg [BITVBNK-1:0]  vbadr_reg [0:DRAM_DELAY];
  reg [BITVROW-1:0]  vradr_reg [0:DRAM_DELAY];
  reg [WIDTH-1:0]    vdin_reg [0:DRAM_DELAY];
 
  integer vdel_int; 
  always @(posedge clk) begin
    for (vdel_int=0; vdel_int<DRAM_DELAY+1; vdel_int=vdel_int+1)
      if (vdel_int > 0) begin
        request_reg[vdel_int] <= request_reg[vdel_int-1];
        vrefr_reg[vdel_int] <= vrefr_reg[vdel_int-1];
        vread_reg[vdel_int] <= vread_reg[vdel_int-1];
        vwrite_reg[vdel_int] <= vwrite_reg[vdel_int-1];
        vbadr_reg[vdel_int] <= vbadr_reg[vdel_int-1];
        vradr_reg[vdel_int] <= vradr_reg[vdel_int-1];
        vdin_reg[vdel_int] <= vdin_reg[vdel_int-1];
      end else begin
	request_reg[vdel_int] <= request;
        vrefr_reg[vdel_int] <= vrefr;
        vread_reg[vdel_int] <= vread;
        vwrite_reg[vdel_int] <= vwrite && (vaddr < NUMADDR) && ready;
        vbadr_reg[vdel_int] <= vbadr;
        vradr_reg[vdel_int] <= vradr;
        vdin_reg[vdel_int] <= vdin;          
      end
  end

  wire               vrefr1 = request && vrefr_reg[0] && REFRESH;
  wire               vread1 = request && vread_reg[0];
  wire               vwrite1 = request && vwrite_reg[0];
  wire [BITVBNK-1:0] vbadr1 = vbadr_reg[0]; 
  wire [BITVROW-1:0] vradr1 = vradr_reg[0];
  wire [WIDTH-1:0]   vdin1 = vdin_reg[0];

  wire               vrefr2 = request && vrefr && REFRESH;
  wire               vread2 = request && vread;
  wire               vwrite2 = request && vwrite;
  wire [BITVBNK-1:0] vbadr2 = vbadr; 
  wire [BITVROW-1:0] vradr2 = vradr;
  wire [WIDTH-1:0]   vdin2 = vdin;

  wire               vwrite_out = vwrite_reg[SRAM_DELAY-1];
  wire [BITVBNK-1:0] vwrbadr_out = vbadr_reg[SRAM_DELAY-1];
  wire [BITVROW-1:0] vwrradr_out = vradr_reg[SRAM_DELAY-1];
  wire [WIDTH-1:0]   vdin_out = vdin_reg[SRAM_DELAY-1];       

  wire               vread_out = vread_reg[DRAM_DELAY];
  wire [BITVBNK-1:0] vrdbadr_out = vbadr_reg[DRAM_DELAY];
  wire [BITVROW-1:0] vrdradr_out = vradr_reg[DRAM_DELAY];

  // Read request of pivoted data on DRAM memory
  wire prefr1_int = vrefr1;
  wire pread1_int = vread1 && (vbadr1 < NUMVBNK);
  wire [BITVBNK-1:0] prdbadr1_int = vbadr1;
  wire [BITVROW-1:0] prdradr1_int = vradr1;

  wire prefr2_int = vrefr2;
  wire pread2_int = vread2 && (vbadr2 < NUMVBNK);
  wire [BITVBNK-1:0] prdbadr2_int = vbadr2;
  wire [BITVROW-1:0] prdradr2_int = vradr2;

  // Read request of mapping information on SRAM memory
  assign sread = (vread || vwrite) && (!swrite || (swrradr != srdradr));
  assign srdradr = vradr;

  assign cread = (vread || vwrite) && (!cwrite || (cwrradr != crdradr));
  assign crdradr = vradr;

// ECC Generation Module
  reg [BITVBNK:0]   sdin_pre_ecc;
  wire [ECCBITS-1:0] sdin_ecc;
  ecc_calc #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
      ecc_calc_inst (.din(sdin_pre_ecc), .eccout(sdin_ecc));

  assign sdin = {sdin_pre_ecc, sdin_ecc, sdin_pre_ecc};

// ECC Checking Module for SRAM
  wire sdout_bit1_err = 0;
  wire sdout_bit2_err = 0;
  wire [7:0] sdout_bit1_pos = 0;
  wire [7:0] sdout_bit2_pos = 0;
  wire [SDOUT_WIDTH-1:0] sdout_bit1_mask = sdout_bit1_err << sdout_bit1_pos;
  wire [SDOUT_WIDTH-1:0] sdout_bit2_mask = sdout_bit2_err << sdout_bit2_pos;
  wire [SDOUT_WIDTH-1:0] sdout_mask = sdout_bit1_mask ^ sdout_bit2_mask;
  wire sdout_serr = |sdout_mask && (|sdout_bit1_mask ^ |sdout_bit2_mask);
  wire sdout_derr = |sdout_mask && |sdout_bit1_mask && |sdout_bit2_mask;
  wire [SDOUT_WIDTH-1:0] sdout_int = sdout ^ sdout_mask;

  wire [BITVBNK:0]   sdout_data = sdout_int;
  wire [ECCBITS-1:0] sdout_ecc = sdout_int >> BITVBNK+1;
  wire [BITVBNK:0]   sdout_dup_data = sdout_int >> BITVBNK+1+ECCBITS;
  wire [BITVBNK:0]   sdout_post_ecc;
  wire               sdout_sec_err;
  wire               sdout_ded_err;

  ecc_check #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
      ecc_check_inst (.din(sdout_data), .eccin(sdout_ecc),
                      .dout(sdout_post_ecc), .sec_err(sdout_sec_err), .ded_err(sdout_ded_err),
                      .clk(clk), .rst(rst));

  wire [BITVBNK:0]   sdout_out = sdout_ded_err ? sdout_dup_data : sdout_post_ecc;

  reg              map_vld [0:DRAM_DELAY];
  reg [BITVBNK:0]  map_reg [0:DRAM_DELAY];
  integer sfwd_int;
  always @(posedge clk) begin
    for (sfwd_int=0; sfwd_int<DRAM_DELAY+1; sfwd_int=sfwd_int+1)
      if (sfwd_int>SRAM_DELAY) begin
        map_vld[sfwd_int] <= map_vld[sfwd_int-1];
        map_reg[sfwd_int] <= map_reg[sfwd_int-1];
      end else if (sfwd_int==SRAM_DELAY) begin
        if (map_vld[sfwd_int-1]) begin
          map_vld[sfwd_int] <= map_vld[sfwd_int-1];
          map_reg[sfwd_int] <= map_reg[sfwd_int-1];
        end else begin
          map_vld[sfwd_int] <= 1'b1;
          map_reg[sfwd_int] <= sdout_out;
        end
      end else if (sfwd_int > 0) begin
        if (swrite && (swrradr == vradr_reg[sfwd_int-1])) begin
          map_vld[sfwd_int] <= 1'b1;
          map_reg[sfwd_int] <= sdin;
        end else begin
          map_vld[sfwd_int] <= map_vld[sfwd_int-1];
          map_reg[sfwd_int] <= map_reg[sfwd_int-1];            
        end
      end else begin
        if (swrite && (swrradr == vradr)) begin
          map_vld[sfwd_int] <= 1'b1;
          map_reg[sfwd_int] <= sdin;
        end else begin
          map_vld[sfwd_int] <= 1'b0;
          map_reg[sfwd_int] <= 0;
        end
      end
  end

  reg              cdat_vld [0:DRAM_DELAY];
  reg [WIDTH-1:0]  cdat_reg [0:DRAM_DELAY];
  integer cfwd_int;
  always @(posedge clk) begin
    for (cfwd_int=0; cfwd_int<DRAM_DELAY+1; cfwd_int=cfwd_int+1)
      if (cfwd_int>SRAM_DELAY) begin
        cdat_vld[cfwd_int] <= cdat_vld[cfwd_int-1];
        cdat_reg[cfwd_int] <= cdat_reg[cfwd_int-1];
      end else if (cfwd_int==SRAM_DELAY) begin
        if (cdat_vld[cfwd_int-1]) begin
          cdat_vld[cfwd_int] <= cdat_vld[cfwd_int-1];
          cdat_reg[cfwd_int] <= cdat_reg[cfwd_int-1];
        end else begin
          cdat_vld[cfwd_int] <= 1'b1;
          cdat_reg[cfwd_int] <= cdout;
        end
      end else if (cfwd_int > 0) begin
        if (cwrite && (cwrradr == vradr_reg[cfwd_int-1])) begin
          cdat_vld[cfwd_int] <= 1'b1;
          cdat_reg[cfwd_int] <= cdin;
        end else begin
          cdat_vld[cfwd_int] <= cdat_vld[cfwd_int-1];
          cdat_reg[cfwd_int] <= cdat_reg[cfwd_int-1];            
        end
      end else begin
        if (cwrite && (cwrradr == vradr)) begin
          cdat_vld[cfwd_int] <= 1'b1;
          cdat_reg[cfwd_int] <= cdin;
        end else begin
          cdat_vld[cfwd_int] <= 1'b0;
          cdat_reg[cfwd_int] <= 0;
        end
      end
  end

  reg               pwrite1_int;
  reg [BITVBNK-1:0] pwrbadr1_int;
  reg [BITVROW-1:0] pwrradr1_int;
  reg [WIDTH-1:0]   pdin1_int;

  reg               pwrite2_int;
  reg [BITVBNK-1:0] pwrbadr2_int;
  reg [BITVROW-1:0] pwrradr2_int;
  reg [WIDTH-1:0]   pdin2_int;

  reg              pdat_vld [0:DRAM_DELAY];
  reg [WIDTH-1:0]  pdat_reg [0:DRAM_DELAY];
  integer pfwd_int;
  always @(posedge clk) begin
    for (pfwd_int=0; pfwd_int<DRAM_DELAY+1; pfwd_int=pfwd_int+1)
      if (pfwd_int>SRAM_DELAY-1) begin
        pdat_vld[pfwd_int] <= pdat_vld[pfwd_int-1];
        pdat_reg[pfwd_int] <= pdat_reg[pfwd_int-1];
      end else if (pfwd_int > 0) begin
        if (pwrite2_int && (pwrbadr2_int == vbadr_reg[pfwd_int-1]) && (pwrradr2_int == vradr_reg[pfwd_int-1])) begin
          pdat_vld[pfwd_int] <= 1'b1;
          pdat_reg[pfwd_int] <= pdin2_int;
        end else if (pwrite1_int && (pwrbadr1_int == vbadr_reg[pfwd_int-1]) && (pwrradr1_int == vradr_reg[pfwd_int-1])) begin
          pdat_vld[pfwd_int] <= 1'b1;
          pdat_reg[pfwd_int] <= pdin1_int;
        end else begin
          pdat_vld[pfwd_int] <= pdat_vld[pfwd_int-1];
          pdat_reg[pfwd_int] <= pdat_reg[pfwd_int-1];            
        end
      end else begin
        if (pwrite2_int && (pwrbadr2_int == vbadr) && (pwrradr2_int == vradr)) begin
          pdat_vld[pfwd_int] <= 1'b1;
          pdat_reg[pfwd_int] <= pdin2_int;
        end else if (pwrite1_int && (pwrbadr1_int == vbadr) && (pwrradr1_int == vradr)) begin
          pdat_vld[pfwd_int] <= 1'b1;
          pdat_reg[pfwd_int] <= pdin1_int;
        end else begin
          pdat_vld[pfwd_int] <= 1'b0;
          pdat_reg[pfwd_int] <= 0;
        end
      end
  end

  reg             wr_srch_flag;
  reg [WIDTH-1:0] wr_srch_data;
  reg             rddat_vld [0:DRAM_DELAY];
  reg [WIDTH-1:0] rddat_reg [0:DRAM_DELAY];
  integer rfwd_int;
  always @(posedge clk) begin
    for (rfwd_int=0; rfwd_int<DRAM_DELAY+1; rfwd_int=rfwd_int+1)
      if (rfwd_int>SRAM_DELAY-1) begin
        rddat_vld[rfwd_int] <= rddat_vld[rfwd_int-1];
        rddat_reg[rfwd_int] <= rddat_reg[rfwd_int-1];
      end else if (rfwd_int>0) begin
        if (vwrite_out && vread_reg[rfwd_int-1] && (vwrbadr_out == vbadr_reg[rfwd_int-1]) && (vwrradr_out == vradr_reg[rfwd_int-1])) begin
          rddat_vld[rfwd_int] <= 1'b1;
          rddat_reg[rfwd_int] <= vdin_out;
        end else begin
          rddat_vld[rfwd_int] <= rddat_vld[rfwd_int-1];
          rddat_reg[rfwd_int] <= rddat_reg[rfwd_int-1];
        end
      end else begin
        if (vwrite_out && vread && (vwrbadr_out == vbadr) && (vwrradr_out == vradr)) begin
          rddat_vld[rfwd_int] <= 1'b1;
          rddat_reg[rfwd_int] <= vdin_out;
        end else begin
          rddat_vld[rfwd_int] <= wr_srch_flag;
          rddat_reg[rfwd_int] <= wr_srch_data;
        end
      end
  end

  wire                   map_vld0 = map_vld[0];
  wire [(BITVBNK+1)-1:0] map_reg0 = map_reg[0];
  wire                   map_vld1 = map_vld[1];
  wire [(BITVBNK+1)-1:0] map_reg1 = map_reg[1];
  wire                   map_vld2 = map_vld[2];
  wire [(BITVBNK+1)-1:0] map_reg2 = map_reg[2];

  wire [WIDTH-1:0]   pdout1_int;
  wire               pdout1_serr_int;
  wire               pdout1_derr_int;
  wire [BITPADR-2:0] pdout1_padr_int;
  wire [WIDTH-1:0]   pdout2_int;
  wire               pdout2_serr_int;
  wire               pdout2_derr_int;
  wire [BITPADR-2:0] pdout2_padr_int;

  reg [BITVBNK:0]   sdout_reg;
  reg [WIDTH-1:0]   pdout2_int_reg;
  reg               pdout2_serr_int_reg;
  reg               pdout2_derr_int_reg;
  reg [BITPADR-2:0] pdout2_padr_int_reg;
  reg [WIDTH-1:0]   cdout_reg;
  always @(posedge clk) begin
    sdout_reg <= sdout_out;
    pdout2_int_reg <= pdout2_int;
    pdout2_serr_int_reg <= pdout2_serr_int;
    pdout2_derr_int_reg <= pdout2_derr_int;
    pdout2_padr_int_reg <= pdout2_padr_int;
    cdout_reg <= cdout;
  end

  wire [BITVBNK:0]   mapw_out = map_vld[SRAM_DELAY-1] ? map_reg[SRAM_DELAY-1] : sdout_out;
  wire [WIDTH-1:0]   cdatw_out = cdat_vld[SRAM_DELAY-1] ? cdat_reg[SRAM_DELAY-1] : cdout;

  wire [BITVBNK:0]   mapr_out = map_vld[DRAM_DELAY] ? map_reg[DRAM_DELAY] : sdout_out;
  wire [WIDTH-1:0]   cdatr_out = cdat_vld[DRAM_DELAY] ? cdat_reg[DRAM_DELAY] : cdout;
  wire [WIDTH-1:0]   pdatr_out = pdat_vld[DRAM_DELAY] ? pdat_reg[DRAM_DELAY] : request_reg[DRAM_DELAY-1] ? pdout1_int : pdout2_int_reg;
  wire               pdatr_serr_out = request_reg[DRAM_DELAY-1] ? pdout1_serr_int : pdout2_serr_int_reg;
  wire               pdatr_derr_out = request_reg[DRAM_DELAY-1] ? pdout1_derr_int : pdout2_derr_int_reg;
  wire [BITPADR-2:0] pdatr_padr_out = request_reg[DRAM_DELAY-1] ? pdout1_padr_int : pdout2_padr_int_reg;

  wire               vread_vld_tmp = vread_out;
  wire [WIDTH-1:0]   vdout_tmp = (rddat_vld[DRAM_DELAY] ? rddat_reg[DRAM_DELAY] :
		                 (mapr_out[BITVBNK] && (mapr_out[BITVBNK-1:0] == vrdbadr_out)) ? cdatr_out : pdatr_out);
  wire               vread_serr_tmp = (rddat_vld[DRAM_DELAY] || (mapr_out[BITVBNK] && (mapr_out[BITVBNK-1:0] == vrdbadr_out))) ? 1'b0 : pdatr_serr_out;
  wire               vread_derr_tmp = (rddat_vld[DRAM_DELAY] || (mapr_out[BITVBNK] && (mapr_out[BITVBNK-1:0] == vrdbadr_out))) ? 1'b0 : pdatr_derr_out;
  wire [BITPADR-1:0] vread_padr_tmp = rddat_vld[DRAM_DELAY] ? ~0 :
				      (mapr_out[BITVBNK] && (mapr_out[BITVBNK-1:0] == vrdbadr_out)) ? (1 << (BITPADR-1)) | vrdradr_out : {1'b0,pdatr_padr_out};

  reg               vread_vld;
  reg [WIDTH-1:0]   vdout;
  reg               vread_serr;
  reg               vread_derr;
  reg [BITPADR-1:0] vread_padr;

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

  wire pdat_vld_0 = pdat_vld[0];
  wire [WIDTH-1:0] pdat_reg_0 = pdat_reg[0];
  wire pdat_vld_1 = pdat_vld[1];
  wire [WIDTH-1:0] pdat_reg_1 = pdat_reg[1];
  wire pdat_vld_2 = pdat_vld[2];
  wire [WIDTH-1:0] pdat_reg_2 = pdat_reg[2];
  wire pdat_vld_3 = pdat_vld[3];
  wire [WIDTH-1:0] pdat_reg_3 = pdat_reg[3];

  wire rddat_vld_0 = rddat_vld[0];
  wire [WIDTH-1:0] rddat_reg_0 = rddat_reg[0];
  wire rddat_vld_1 = rddat_vld[1];
  wire [WIDTH-1:0] rddat_reg_1 = rddat_reg[1];
  wire rddat_vld_2 = rddat_vld[2];
  wire [WIDTH-1:0] rddat_reg_2 = rddat_reg[2];
  wire rddat_vld_3 = rddat_vld[3];
  wire [WIDTH-1:0] rddat_reg_3 = rddat_reg[3];
/*
  wire [WIDTH-1:0] rddat_reg_2 = rddat_reg[2];
  wire rddat_vld_3 = rddat_vld[3];
  wire [WIDTH-1:0] rddat_reg_3 = rddat_reg[3];
  wire rddat_vld_4 = rddat_vld[4];
  wire [WIDTH-1:0] rddat_reg_4 = rddat_reg[4];
*/

  reg [3:0]          wrfifo_cnt;
  reg                wrfifo_old_vld [0:FIFOCNT-1];
  reg [BITVBNK-1:0]  wrfifo_old_map [0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_old_dat [0:FIFOCNT-1];
  reg                wrfifo_new_vld [0:FIFOCNT-1];
  reg [BITVBNK-1:0]  wrfifo_new_map [0:FIFOCNT-1];
  reg [BITVROW-1:0]  wrfifo_new_row [0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_new_dat [0:FIFOCNT-1];

  wire wrfifo_deq1 = request && !((vread1 || vrefr1) && (vread2 || vrefr2)) && |wrfifo_cnt;
  wire wrfifo_deq2 = request && !((vread1 || vrefr1) || (vread2 || vrefr2)) && (wrfifo_cnt > 1);
  always @(posedge clk)
    if (rst)
      wrfifo_cnt <= 0;
    else
      wrfifo_cnt <= wrfifo_cnt + vwrite_out - wrfifo_deq1 - wrfifo_deq2;

  wire wrfifo_cnt_gt = (wrfifo_cnt > 3);

  integer wfifo_int;
  always @(posedge clk)
    for (wfifo_int=FIFOCNT-1; wfifo_int>=0; wfifo_int=wfifo_int-1)
      if (vwrite_out && (wrfifo_cnt == (wrfifo_deq1+wrfifo_deq2+wfifo_int))) begin
        if (swrite && (swrradr == vwrradr_out)) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= mapw_out[BITVBNK];
          wrfifo_old_map[wfifo_int] <= mapw_out;
        end
        if (cwrite && (cwrradr == vwrradr_out))
          wrfifo_old_dat[wfifo_int] <= cdin;
        else
          wrfifo_old_dat[wfifo_int] <= cdatw_out;
        wrfifo_new_vld[wfifo_int] <= 1'b1;
        wrfifo_new_map[wfifo_int] <= vwrbadr_out;
        wrfifo_new_row[wfifo_int] <= vwrradr_out;
        wrfifo_new_dat[wfifo_int] <= vdin_out;
      end else if (wrfifo_deq2 && (wfifo_int<FIFOCNT-2)) begin
        if (swrite && (swrradr == wrfifo_new_row[wfifo_int+2])) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= wrfifo_old_vld[wfifo_int+2];
          wrfifo_old_map[wfifo_int] <= wrfifo_old_map[wfifo_int+2];
        end
        if (cwrite && (cwrradr == wrfifo_new_row[wfifo_int+2]))
          wrfifo_old_dat[wfifo_int] <= cdin;
        else
          wrfifo_old_dat[wfifo_int] <= wrfifo_old_dat[wfifo_int+2];
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int+2];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int+2];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int+2];
        wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int+2];
      end else if (wrfifo_deq1 && (wfifo_int<FIFOCNT-1)) begin
        if (swrite && (swrradr == wrfifo_new_row[wfifo_int+1])) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= wrfifo_old_vld[wfifo_int+1];
          wrfifo_old_map[wfifo_int] <= wrfifo_old_map[wfifo_int+1];
        end
        if (cwrite && (cwrradr == wrfifo_new_row[wfifo_int+1]))
          wrfifo_old_dat[wfifo_int] <= cdin;
        else
          wrfifo_old_dat[wfifo_int] <= wrfifo_old_dat[wfifo_int+1];
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int+1];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int+1];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int+1];
        wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int+1];
      end

  wire wrfifo_old_vld_0 = wrfifo_old_vld[0];
  wire [BITVBNK-1:0] wrfifo_old_map_0 = wrfifo_old_map[0];
  wire [WIDTH-1:0] wrfifo_old_dat_0 = wrfifo_old_dat[0];
  wire wrfifo_new_vld_0 = wrfifo_new_vld[0];
  wire [BITVBNK-1:0] wrfifo_new_map_0 = wrfifo_new_map[0];
  wire [BITVROW-1:0] wrfifo_new_row_0 = wrfifo_new_row[0];
  wire [WIDTH-1:0] wrfifo_new_dat_0 = wrfifo_new_dat[0];
  wire wrfifo_old_vld_1 = wrfifo_old_vld[1];
  wire [BITVBNK-1:0] wrfifo_old_map_1 = wrfifo_old_map[1];
  wire [WIDTH-1:0] wrfifo_old_dat_1 = wrfifo_old_dat[1];
  wire wrfifo_new_vld_1 = wrfifo_new_vld[1];
  wire [BITVBNK-1:0] wrfifo_new_map_1 = wrfifo_new_map[1];
  wire [BITVROW-1:0] wrfifo_new_row_1 = wrfifo_new_row[1];
  wire [WIDTH-1:0] wrfifo_new_dat_1 = wrfifo_new_dat[1];
  wire wrfifo_old_vld_2 = wrfifo_old_vld[2];
  wire [BITVBNK-1:0] wrfifo_old_map_2 = wrfifo_old_map[2];
  wire [WIDTH-1:0] wrfifo_old_dat_2 = wrfifo_old_dat[2];
  wire wrfifo_new_vld_2 = wrfifo_new_vld[2];
  wire [BITVBNK-1:0] wrfifo_new_map_2 = wrfifo_new_map[2];
  wire [BITVROW-1:0] wrfifo_new_row_2 = wrfifo_new_row[2];
  wire [WIDTH-1:0] wrfifo_new_dat_2 = wrfifo_new_dat[2];
  wire wrfifo_old_vld_3 = wrfifo_old_vld[3];
  wire [BITVBNK-1:0] wrfifo_old_map_3 = wrfifo_old_map[3];
  wire [WIDTH-1:0] wrfifo_old_dat_3 = wrfifo_old_dat[3];
  wire wrfifo_new_vld_3 = wrfifo_new_vld[3];
  wire [BITVBNK-1:0] wrfifo_new_map_3 = wrfifo_new_map[3];
  wire [BITVROW-1:0] wrfifo_new_row_3 = wrfifo_new_row[3];
  wire [WIDTH-1:0] wrfifo_new_dat_3 = wrfifo_new_dat[3];

  reg             wr_srch_flags;
  reg [WIDTH-1:0] wr_srch_datas;
  reg             wr_srch_dbits;
  integer wsrc_int;
  always_comb begin
    wr_srch_flag = 1'b0;
    wr_srch_data = 0;
    for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == vbadr) && (wrfifo_new_row[wsrc_int] == vradr)) begin
        wr_srch_flag = 1'b1;
        wr_srch_data = wrfifo_new_dat[wsrc_int];
      end
    wr_srch_flags = 1'b0;
    wr_srch_datas = 0;
    for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == select_bank) && (wrfifo_new_row[wsrc_int] == select_row)) begin
        wr_srch_flags = 1'b1;
        wr_srch_datas = wrfifo_new_dat[wsrc_int];
      end
    wr_srch_dbits = wr_srch_datas[select_bit];
  end

  wire               sold_vld1 = wrfifo_deq2 && wrfifo_old_vld[0];
  wire [BITVBNK-1:0] sold_map1 = wrfifo_old_map[0];
  wire [BITVROW-1:0] sold_row1 = wrfifo_new_row[0];
  wire [WIDTH-1:0]   sold_dat1 = wrfifo_old_dat[0];
  wire               snew_vld1 = wrfifo_deq2 && wrfifo_new_vld[0];
  wire [BITVBNK-1:0] snew_map1 = wrfifo_new_map[0];
  wire [BITVROW-1:0] snew_row1 = wrfifo_new_row[0];
  wire [WIDTH-1:0]   snew_dat1 = wrfifo_new_dat[0];

  wire               sold_vld2 = wrfifo_deq2 ? wrfifo_old_vld[1] : wrfifo_deq1 && wrfifo_old_vld[0];
  wire [BITVBNK-1:0] sold_map2 = wrfifo_deq2 ? wrfifo_old_map[1] : wrfifo_old_map[0];
  wire [BITVROW-1:0] sold_row2 = wrfifo_deq2 ? wrfifo_new_row[1] : wrfifo_new_row[0];
  wire [WIDTH-1:0]   sold_dat2 = wrfifo_deq2 ? wrfifo_old_dat[1] : wrfifo_old_dat[0];
  wire               snew_vld2 = wrfifo_deq2 ? wrfifo_new_vld[1] : wrfifo_deq1 && wrfifo_new_vld[0];
  wire [BITVBNK-1:0] snew_map2 = wrfifo_deq2 ? wrfifo_new_map[1] : wrfifo_new_map[0];
  wire [BITVROW-1:0] snew_row2 = wrfifo_deq2 ? wrfifo_new_row[1] : wrfifo_new_row[0];
  wire [WIDTH-1:0]   snew_dat2 = wrfifo_deq2 ? wrfifo_new_dat[1] : wrfifo_new_dat[0];

/*
  wire               sold_vld1 = vwrite1_out && map1_out[BITVBNK];
  wire [BITVBNK-1:0] sold_map1 = map1_out;
  wire [BITVROW-1:0] sold_row1 = vradr1_out;
  wire [WIDTH-1:0]   sold_dat1 = cdat1_out;
  wire               snew_vld1 = vwrite1_out;
  wire [BITVBNK-1:0] snew_map1 = vbadr1_out;
  wire [BITVROW-1:0] snew_row1 = vradr1_out;
  wire [WIDTH-1:0]   snew_dat1 = vdin1_out;

  wire               sold_vld2 = vwrite2_out && map2_out[BITVBNK];
  wire [BITVBNK-1:0] sold_map2 = map2_out;
  wire [BITVROW-1:0] sold_row2 = vradr2_out;
  wire [WIDTH-1:0]   sold_dat2 = cdat2_out;
  wire               snew_vld2 = vwrite2_out;
  wire [BITVBNK-1:0] snew_map2 = vbadr2_out;
  wire [BITVROW-1:0] snew_row2 = vradr2_out;
  wire [WIDTH-1:0]   snew_dat2 = vdin2_out;
*/

  wire               phigh;
  wire [BITVBNK-1:0] phibadr;
  reg prefr_del, prefr_del2, prefr_del3, prefr_del4;
  reg [BITVBNK-1:0] prefr_badr_del2, prefr_badr_del3, prefr_badr_del4;
  reg [BITVROW-1:0] prefr_radr_del2, prefr_radr_del3, prefr_radr_del4;

  // Write request to pivoted banks
  wire new_to_cache_1 = snew_vld1 && sold_vld1 && (snew_map1 == sold_map1);
  wire new_to_pivot_1 = snew_vld1 && (!sold_vld1 || (snew_map1 != sold_map1));

  wire new_to_cache_2 = snew_vld2 && ((new_to_pivot_1 && (snew_map1 == snew_map2)) ||
				      (vread1 && (vbadr1 == snew_map2)) ||
				      (vread2 && (vbadr2 == snew_map2)) ||
//				      ((vrefr1 || vrefr2) && phigh && (phibadr == snew_map2)) ||
				      ((vrefr1 || vrefr2) && !prefr_del3 && phigh && (phibadr == snew_map2)) ||
				      (vrefr1 && prefr_del3 && (prefr_badr_del3 == snew_map2)));
  wire new_to_pivot_2 = snew_vld2 && !new_to_cache_2;

  wire old_to_pivot_2 = sold_vld2 && new_to_cache_2 && (sold_map2 != snew_map2);
  wire old_to_clear_2 = sold_vld2 && new_to_pivot_2 && (sold_map2 == snew_map2);

  always_comb
    if (new_to_pivot_1) begin
      pwrite1_int = 1'b1;
      pwrbadr1_int = snew_map1;
      pwrradr1_int = snew_row1;
      pdin1_int = snew_dat1;
    end else begin
      pwrite1_int = 1'b0;
      pwrbadr1_int = 0;
      pwrradr1_int = 0;
      pdin1_int = 0;
    end

  always_comb
    if (new_to_pivot_2) begin
      pwrite2_int = 1'b1;
      pwrbadr2_int = snew_map2;
      pwrradr2_int = snew_row2;
      pdin2_int = snew_dat2;
    end else if (old_to_pivot_2) begin
      pwrite2_int = (sold_map2 < NUMVBNK);
      pwrbadr2_int = sold_map2;
      pwrradr2_int = sold_row2;
      pdin2_int = sold_dat2;
    end else begin
      pwrite2_int = 1'b0;
      pwrbadr2_int = 0;
      pwrradr2_int = 0;
      pdin2_int = 0;
    end

  reg                    swrite;
  reg [BITVROW-1:0]      swrradr;
  always_comb
    if (rstvld) begin
      swrite = 1'b1;
      swrradr = rstaddr;
      sdin_pre_ecc = 0;
    end else if (new_to_cache_2) begin
      swrite = 1'b1;
      swrradr = snew_row2;
      sdin_pre_ecc = {1'b1,snew_map2};
    end else if (old_to_clear_2) begin
      swrite = 1'b1;
      swrradr = sold_row2;
      sdin_pre_ecc = 0;
    end else begin
      swrite = 1'b0;
      swrradr = 0;
      sdin_pre_ecc = 0;
    end

  reg                    cwrite;
  reg [BITVROW-1:0]      cwrradr;
  reg [WIDTH-1:0]        cdin;
  always_comb
    if (rstvld) begin
      cwrite = 1'b1;
      cwrradr = rstaddr;
      cdin = 0;
    end else if (new_to_cache_1) begin
      cwrite = 1'b1;
      cwrradr = snew_row1;
      cdin = snew_dat1;
    end else if (new_to_cache_2) begin
      cwrite = 1'b1;
      cwrradr = snew_row2;
      cdin = snew_dat2;
    end else begin
      cwrite = 1'b0;
      cwrradr = 0;
      cdin = 0;
    end

  reg               last_bank_vld;
  reg [BITVBNK-1:0] last_bank_reg;
  always @(posedge clk) begin
    last_bank_vld <= pread1 || pread2 || pwrite || prefr;
    last_bank_reg <= pread1 ? prdbadr1 : pread2 ? prdbadr2 : pwrite ? pwrbadr : prfbadr;
  end

  wire delay_refr1 = prefr1_int && prefr_del3;
  wire delay_refr2 = pread1_int && prefr2_int && phigh && (prdbadr1_int == phibadr);
  wire delay_refr1n = !delay_refr1 && (prefr1_int || prefr2_int) && !wrfifo_deq1 && !pread1_int && !pread2_int && phigh && last_bank_vld && (last_bank_reg == phibadr);
  wire delay_refr1w = !delay_refr1 && (prefr1_int || prefr2_int) && wrfifo_deq1 && phigh && last_bank_vld && (last_bank_reg == phibadr);
//  wire delay_refr1w = prefr1_int && pwrite2_int && phigh && last_bank_vld && (last_bank_reg == phibadr);
  wire delay_refr = 0;
//  wire delay_refr = !delay_refr1 && prefr1_int && prefr2_int; 
  wire delay_both = pread1_int && pread2_int && (prdbadr1_int == prdbadr2_int);
  wire delay_req1 = (delay_both || delay_refr2 || 
		     (last_bank_vld && ((pread1_int && (last_bank_reg == prdbadr1_int)) ||
				        (pwrite1_int && (last_bank_reg == pwrbadr1_int)))));
  wire delay_refr1r = !delay_req1 && pread1_int && prefr2_int && phigh && last_bank_vld && (last_bank_reg == phibadr);
  wire delay_refr2r = !delay_refr1 && pread2_int && prefr1_int && phigh && last_bank_vld && (last_bank_reg == phibadr) && (prdbadr2_int != phibadr);
  wire advance_rreq2 = !delay_both && pread2_int && (delay_req1 || (!(pread1_int || pwrite1_int) && !(last_bank_vld && (last_bank_reg == prdbadr2_int))));
  wire advance_wreq2 = pwrite2_int && (delay_req1 || delay_refr1 || delay_refr1w || delay_refr1n ||
		                       (!(pread1_int || pwrite1_int) && pread2_int && last_bank_vld && (last_bank_reg == prdbadr2_int)));
//  wire advance_wreq2 = pwrite2_int && (delay_req1 || delay_refr1 || (!(pread1_int || pwrite1_int) && !(last_bank_vld && (last_bank_reg == prdbadr2_int))));

  always @(posedge clk)
    prefr_del <= delay_refr || delay_refr1w || delay_refr1n || delay_refr1r || delay_refr2r || delay_refr2;

  always @(posedge clk) begin
    prefr_del2 <= delay_refr2;
    prefr_badr_del2 <= phibadr;
    prefr_radr_del2 <= prdradr1_int;
    prefr_del3 <= prefr_del2;
    prefr_badr_del3 <= prefr_badr_del2;
    prefr_radr_del3 <= prefr_radr_del2;
    prefr_del4 <= delay_refr1;
    prefr_badr_del4 <= prefr_badr_del3;
    prefr_radr_del4 <= prefr_radr_del3;
  end

  wire               curr_rvld = !prefr_del && (pread1 || pread2 || pwrite);
  wire [BITVBNK-1:0] curr_rbnk = pread1 ? prdbadr1 : pread2 ? prdbadr2 : pwrbadr;
  wire               next_rvld = (delay_req1 && pread1_int) || (delay_req1 && pwrite1_int) ||
				 (!advance_rreq2 && pread2_int) || (!advance_wreq2 && pwrite2_int);
  wire [BITVBNK-1:0] next_rbnk = (delay_req1 && pread1_int) ? prdbadr1_int :
				 (delay_req1 && pwrite1_int) ? pwrbadr1_int :
				 (!advance_rreq2 && pread2_int) ? prdbadr2_int : pwrbadr2_int;

  wire prefr_int;
  wire [BITVBNK-1:0] prfbadr_int;
  refr_3stage_2pipe #(.NUMRBNK (NUMVBNK), .BITRBNK (BITVBNK))
      refresh_module (.clk (clk), .rst (rst),
		      .pacc1 (last_bank_vld), .pa1badr (last_bank_reg),
		      .pacc2 (curr_rvld), .pa2badr (curr_rbnk),
		      .pacc3 (next_rvld), .pa3badr (next_rbnk),
		      .norefr (prefr_del4 || delay_refr1w || delay_refr1n || delay_refr1r || delay_refr2r || delay_refr || (!request && !prefr_del)),
		      .prefr (prefr_int), .prfbadr (prfbadr_int),
		      .phigh (phigh), .phibadr (phibadr));

  assign prefr = prefr_del4 ||  prefr_int;
  assign prfbadr = prefr_del4 ? prefr_badr_del4 : prfbadr_int;
  assign prfradr = prefr_del4 ? prefr_radr_del4 : {BITVROW{1'b0}}; 

//  wire paccnbth = delay_both;
//  wire paccnext = delay_req1 || (!advance_rreq2 && pread2_int) || (!advance_wreq2 && pwrite2_int);
//  wire [BITVBNK-1:0] panbadr = (delay_req1 ? (pread1_int ? prdbadr1_int : pwrbadr1_int) :
//				(!advance_rreq2 && pread2_int) ? prdbadr2_int : pwrbadr2_int);
//  wire pacclast = last_bank_vld;
//  wire [BITVBNK-1:0] palbadr = last_bank_reg;

  reg pread1_del;
  reg [BITVBNK-1:0] prdbadr1_del;
  reg [BITVROW-1:0] prdradr1_del;
  reg pwrite1_del;
  reg [BITVBNK-1:0] pwrbadr1_del;
  reg [BITVROW-1:0] pwrradr1_del;
  reg [WIDTH-1:0] pdin1_del;
  reg pread2_del;
  reg [BITVBNK-1:0] prdbadr2_del;
  reg [BITVROW-1:0] prdradr2_del;
  reg pwrite2_del;
  reg [BITVBNK-1:0] pwrbadr2_del;
  reg [BITVROW-1:0] pwrradr2_del;
  reg [WIDTH-1:0] pdin2_del;
  always @(posedge clk) begin
    pread1_del <= delay_req1 && pread1_int;
    prdbadr1_del <= prdbadr1_int;
    prdradr1_del <= prdradr1_int;
    pwrite1_del <= delay_req1 && pwrite1_int;
    pwrbadr1_del <= pwrbadr1_int;
    pwrradr1_del <= pwrradr1_int;
    pdin1_del <= pdin1_int;
    pread2_del <= !advance_rreq2 && pread2_int;
    prdbadr2_del <= prdbadr2_int;
    prdradr2_del <= prdradr2_int;
    pwrite2_del <= !advance_wreq2 && pwrite2_int;
    pwrbadr2_del <= pwrbadr2_int;
    pwrradr2_del <= pwrradr2_int;
    pdin2_del <= pdin2_int;
  end
    
  reg               pread1;
  reg [BITVBNK-1:0] prdbadr1;
  reg [BITVROW-1:0] prdradr1;

  reg               pread2;
  reg [BITVBNK-1:0] prdbadr2;
  reg [BITVROW-1:0] prdradr2;

  reg               pwrite;
  reg [BITVBNK-1:0] pwrbadr;
  reg [BITVROW-1:0] pwrradr;
  reg [WIDTH-1:0]   pdin;

  always_comb 
    if (pread1_del || pwrite1_del || pread2_del || pwrite2_del) begin
      pread1 = pread1_del;
      prdbadr1 = prdbadr1_del;
      prdradr1 = prdradr1_del;
      pread2 = pread2_del;
      prdbadr2 = prdbadr2_del;
      prdradr2 = prdradr2_del;
      pwrite = pwrite1_del || pwrite2_del;
      pwrbadr = pwrite1_del ? pwrbadr1_del : pwrbadr2_del;
      pwrradr = pwrite1_del ? pwrradr1_del : pwrradr2_del;
      pdin = pwrite1_del ? pdin1_del : pdin2_del;
    end else if (delay_req1 || advance_rreq2 || advance_wreq2) begin
      pread1 = 0;
      prdbadr1 = 0;
      prdradr1 = 0;
      pread2 = advance_rreq2 && pread2_int;
      prdbadr2 = prdbadr2_int;
      prdradr2 = prdradr2_int;
      pwrite = advance_wreq2 && pwrite2_int;
      pwrbadr = pwrbadr2_int;
      pwrradr = pwrradr2_int;
      pdin = pdin2_int;
    end else begin
      pread1 = pread1_int;
      prdbadr1 = prdbadr1_int;
      prdradr1 = prdradr1_int;
      pread2 = 0;
      prdbadr2 = 0;
      prdradr2 = 0;
      pwrite = pwrite1_int;
      pwrbadr = pwrbadr1_int;
      pwrradr = pwrradr1_int;
      pdin = pdin1_int;
    end

  reg delay_req1_reg [0:DRAM_DELAY-1];
  reg advance_rreq2_reg [0:DRAM_DELAY-1];
  integer rord_int;
  always @(posedge clk)
    for (rord_int=0; rord_int<DRAM_DELAY; rord_int=rord_int+1) 
      if (rord_int>0) begin
        delay_req1_reg[rord_int] <= delay_req1_reg[rord_int-1];
        advance_rreq2_reg[rord_int] <= advance_rreq2_reg[rord_int-1];
      end else begin
        delay_req1_reg[rord_int] <= delay_req1;
        advance_rreq2_reg[rord_int] <= advance_rreq2;
      end
/*    
  always_comb begin
    pwrite1 = pwrite1_int;
    pwrbadr1 = pwrbadr1_int;
    pwrradr1 = pwrradr1_int;
    pdin1 = pdin1_int;

    pwrite2 = pwrite2_int;
    pwrbadr2 = pwrbadr2_int;
    pwrradr2 = pwrradr2_int;
    pdin2 = pdin2_int;
 
    pread1 = pread1_int;
    prdbadr1 = prdbadr1_int;
    prdradr1 = prdradr1_int;

    pread2 = pread2_int;
    prdbadr2 = prdbadr2_int;
    prdradr2 = prdradr2_int;
  end
*/
  reg [WIDTH-1:0]   pdout1_reg;
  reg               pdout1_serr_reg;
  reg               pdout1_derr_reg;
  reg [BITPADR-2:0] pdout1_padr_reg;
  reg [WIDTH-1:0]   pdout2_reg;
  reg               pdout2_serr_reg;
  reg               pdout2_derr_reg;
  reg [BITPADR-2:0] pdout2_padr_reg;
  always @(posedge clk) begin
    pdout1_reg <= pdout1;
    pdout1_serr_reg <= pdout1_serr;
    pdout1_derr_reg <= pdout1_derr;
    pdout1_padr_reg <= pdout1_padr;
    pdout2_reg <= pdout2;
    pdout2_serr_reg <= pdout2_serr;
    pdout2_derr_reg <= pdout2_derr;
    pdout2_padr_reg <= pdout2_padr;
  end

  assign pdout2_int = advance_rreq2_reg[DRAM_DELAY-1] ? pdout2_reg : pdout2;
  assign pdout2_serr_int = advance_rreq2_reg[DRAM_DELAY-1] ? pdout2_serr_reg : pdout2_serr;
  assign pdout2_derr_int = advance_rreq2_reg[DRAM_DELAY-1] ? pdout2_derr_reg : pdout2_derr;
  assign pdout2_padr_int = advance_rreq2_reg[DRAM_DELAY-1] ? pdout2_padr_reg : pdout2_padr;
  assign pdout1_int = delay_req1_reg[DRAM_DELAY-1] ? pdout1 : pdout1_reg;
  assign pdout1_serr_int = delay_req1_reg[DRAM_DELAY-1] ? pdout1_serr : pdout1_serr_reg;
  assign pdout1_derr_int = delay_req1_reg[DRAM_DELAY-1] ? pdout1_derr : pdout1_derr_reg;
  assign pdout1_padr_int = delay_req1_reg[DRAM_DELAY-1] ? pdout1_padr : pdout1_padr_reg;
//  assign pdout2_int = pdout2_reg;
//  assign pdout1_int = pdout1_reg;

endmodule
