
module core_1r1w_rl2 (vrefr,
                      vwrite, vwraddr, vdin,
                      vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                      prefr,
                      pwrite, pwrbadr, pwrradr, pdin,
                      pread, prdbadr, prdradr, pdout, pdout_fwrd, pdout_serr, pdout_derr, pdout_padr,
   	              swrite, swrradr, sdin, ddin,
	              sread1, srdradr1, sdout1, ddout1, ddout1_fwrd, ddout1_serr, ddout1_derr, ddout1_padr,
	              sread2, srdradr2, sdout2, ddout2, ddout2_fwrd, ddout2_serr, ddout2_derr, ddout2_padr,
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
  parameter BITPBNK = 4;
  parameter BITPADR = 14;
  parameter REFRESH = 0;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter ECCBITS = 4;
  
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  parameter FIFOCNT = SRAM_DELAY+REFRESH;

  input                              vrefr;

  input                              vwrite;
  input [BITADDR-1:0]                vwraddr;
  input [WIDTH-1:0]                  vdin;
  
  input                              vread;
  input [BITADDR-1:0]                vrdaddr;
  output                             vread_vld;
  output [WIDTH-1:0]                 vdout;
  output                             vread_fwrd;
  output                             vread_serr;
  output                             vread_derr;
  output [BITPADR-1:0]               vread_padr;

  output                             prefr;

  output                             pwrite;
  output [BITVBNK-1:0]               pwrbadr;
  output [BITVROW-1:0]               pwrradr;
  output [WIDTH-1:0]                 pdin;

  output                             pread;
  output [BITVBNK-1:0]               prdbadr;
  output [BITVROW-1:0]               prdradr;
  input [WIDTH-1:0]                  pdout;
  input                              pdout_fwrd;
  input                              pdout_serr;
  input                              pdout_derr;
  input [BITPADR-BITPBNK-1:0]        pdout_padr;

  output                             swrite;
  output [BITVROW-1:0]               swrradr;
  output [SDOUT_WIDTH-1:0]           sdin;
  output [WIDTH-1:0]                 ddin;
  
  output                             sread1;
  output [BITVROW-1:0]               srdradr1;
  input [SDOUT_WIDTH-1:0]            sdout1;
  input [WIDTH-1:0]                  ddout1;
  input                              ddout1_fwrd;
  input                              ddout1_serr;
  input                              ddout1_derr;
  input [BITPADR-BITPBNK-1:0]        ddout1_padr;
  
  output                             sread2;
  output [BITVROW-1:0]               srdradr2;
  input [SDOUT_WIDTH-1:0]            sdout2;  
  input [WIDTH-1:0]                  ddout2;  
  input                              ddout2_fwrd;
  input                              ddout2_serr;
  input                              ddout2_derr;
  input [BITPADR-BITPBNK-1:0]        ddout2_padr;

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
  np2_addr #(
    .NUMADDR (NUMADDR), .BITADDR (BITADDR),
    .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
    .NUMVROW (NUMVROW), .BITVROW (BITVROW))
    sl_adr (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));

  wire ready_wire;
  wire vrefr_wire;
  wire vread_wire;
  wire [BITADDR-1:0] vrdaddr_wire;
  wire [BITVBNK-1:0] vrdbadr_wire;
  wire [BITVROW-1:0] vrdradr_wire;
  wire vwrite_wire;
  wire [BITADDR-1:0] vwraddr_wire;
  wire [BITVBNK-1:0] vwrbadr_wire;
  wire [BITVROW-1:0] vwrradr_wire;
  wire [WIDTH-1:0] vdin_wire;

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg vrefr_reg;
    reg vread_reg;
    reg [BITADDR-1:0] vrdaddr_reg;
    reg vwrite_reg;
    reg [BITADDR-1:0] vwraddr_reg;
    reg [WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vrefr_reg <= vrefr;
      vread_reg <= vread & ready;
      vrdaddr_reg <= vrdaddr;
      vwrite_reg <= vwrite & ready;
      vwraddr_reg <= vwraddr;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    assign vrefr_wire = vrefr_reg;
    assign vread_wire = vread_reg;
    assign vrdaddr_wire = vrdaddr_reg;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire), .vradr(vrdradr_wire), .vaddr(vrdaddr_wire));

    assign vwrite_wire = vwrite_reg;
    assign vwraddr_wire = vwraddr_reg;
    assign vdin_wire = vdin_reg;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire), .vradr(vwrradr_wire), .vaddr(vwraddr_wire));
  end else begin: noflpi_loop
    assign ready_wire = ready;
    assign vrefr_wire = vrefr;
    assign vread_wire = vread;
    assign vrdaddr_wire = vrdaddr;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire), .vradr(vrdradr_wire), .vaddr(vrdaddr_wire));

    assign vwrite_wire = vwrite && (vwraddr_wire < NUMADDR);
    assign vwraddr_wire = vwraddr;
    assign vdin_wire = vdin;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire), .vradr(vwrradr_wire), .vaddr(vwraddr_wire));
  end
  endgenerate

  reg                vread_reg [0:DRAM_DELAY-1];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:DRAM_DELAY-1];
  reg [BITVROW-1:0]  vrdradr_reg [0:DRAM_DELAY-1];
  reg                vwrite_reg [0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  vwrbadr_reg [0:SRAM_DELAY-1];
  reg [BITVROW-1:0]  vwrradr_reg [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]    vdin_reg [0:SRAM_DELAY-1];
 
  integer vdel_int; 
  always @(posedge clk) begin
    for (vdel_int=0; vdel_int<DRAM_DELAY; vdel_int=vdel_int+1)
      if (vdel_int > 0) begin
        vread_reg[vdel_int] <= vread_reg[vdel_int-1];
        vrdbadr_reg[vdel_int] <= vrdbadr_reg[vdel_int-1];
        vrdradr_reg[vdel_int] <= vrdradr_reg[vdel_int-1];
        if (vdel_int<SRAM_DELAY) begin
          vwrite_reg[vdel_int] <= vwrite_reg[vdel_int-1];
          vwrbadr_reg[vdel_int] <= vwrbadr_reg[vdel_int-1];
          vwrradr_reg[vdel_int] <= vwrradr_reg[vdel_int-1];          
          vdin_reg[vdel_int] <= vdin_reg[vdel_int-1];
        end
      end else begin
        vread_reg[vdel_int] <= vread_wire;
        vrdbadr_reg[vdel_int] <= vrdbadr_wire;
        vrdradr_reg[vdel_int] <= vrdradr_wire;
        vwrite_reg[vdel_int] <= vwrite_wire && (vwraddr_wire < NUMADDR) && ready_wire;
        vwrbadr_reg[vdel_int] <= vwrbadr_wire;
        vwrradr_reg[vdel_int] <= vwrradr_wire;
        vdin_reg[vdel_int] <= vdin_wire;          
      end
  end

  wire               vread_out = vread_reg[DRAM_DELAY-1];
  wire [BITVBNK-1:0] vrdbadr_out = vrdbadr_reg[DRAM_DELAY-1];
  wire [BITVROW-1:0] vrdradr_out = vrdradr_reg[DRAM_DELAY-1];

  wire               vwrite_out = vwrite_reg[SRAM_DELAY-1];
  wire [BITVBNK-1:0] vwrbadr_out = vwrbadr_reg[SRAM_DELAY-1];
  wire [BITVROW-1:0] vwrradr_out = vwrradr_reg[SRAM_DELAY-1];
  wire [WIDTH-1:0]   vdin_out = vdin_reg[SRAM_DELAY-1];       

  assign prefr = vrefr_wire || !ready_wire;

  // Read request of pivoted data on DRAM memory
  assign pread = vread_wire;
  assign prdbadr = vrdbadr_wire;
  assign prdradr = vrdradr_wire;

  // Read request of nonpivoted data in SRAM memory
  wire dread1 = vread_wire;
  wire [BITVROW-1:0] drdradr1 = vrdradr_wire;
  wire dread2 = vwrite_wire;
  wire [BITVROW-1:0] drdradr2 = vwrradr_wire;

  // Read request of mapping information on SRAM memory
  assign sread1 = vwrite_wire && (!swrite || (swrradr != srdradr1));
  assign srdradr1 = vwrradr_wire;
  assign sread2 = vread_wire && (!swrite || (swrradr != srdradr2));
  assign srdradr2 = vrdradr_wire;

  reg                    wrmap_vld [0:SRAM_DELAY-1];
  reg [BITVBNK:0]        wrmap_reg [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]        wrdat_reg [0:SRAM_DELAY-1];
  integer wfwd_int;
  always @(posedge clk) begin
    for (wfwd_int=0; wfwd_int<SRAM_DELAY; wfwd_int=wfwd_int+1)
      if (wfwd_int > 0) begin
        if (swrite && (swrradr == vwrradr_reg[wfwd_int-1])) begin
          wrmap_vld[wfwd_int] <= 1'b1;
          wrmap_reg[wfwd_int] <= sdin[BITVBNK:0];
          wrdat_reg[wfwd_int] <= ddin;
        end else begin
          wrmap_vld[wfwd_int] <= wrmap_vld[wfwd_int-1];
          wrmap_reg[wfwd_int] <= wrmap_reg[wfwd_int-1];            
          wrdat_reg[wfwd_int] <= wrdat_reg[wfwd_int-1];
        end
      end else begin
        if (swrite && (swrradr == vwrradr_wire)) begin
          wrmap_vld[wfwd_int] <= 1'b1;
          wrmap_reg[wfwd_int] <= sdin[BITVBNK:0];
          wrdat_reg[wfwd_int] <= ddin;
        end else begin
          wrmap_vld[wfwd_int] <= 1'b0;
          wrmap_reg[wfwd_int] <= 0;
          wrdat_reg[wfwd_int] <= 0;
        end
      end
  end

  wire [BITVBNK:0]  sdout2_out;

  reg               rdmap_vld [0:DRAM_DELAY-1];
  reg [BITVBNK:0]   rdmap_reg [0:DRAM_DELAY-1];
  reg [WIDTH-1:0]   rdmap_dat [0:DRAM_DELAY-1];
  integer rmap_int;    
  always @(posedge clk) begin
    for (rmap_int=0; rmap_int<DRAM_DELAY; rmap_int=rmap_int+1)
      if (rmap_int==SRAM_DELAY) begin
        if (swrite && (swrradr == vrdradr_reg[rmap_int-1])) begin
          rdmap_vld[rmap_int] <= 1'b1;
          rdmap_reg[rmap_int] <= sdin[BITVBNK:0];
          rdmap_dat[rmap_int] <= ddin;
        end else if (rdmap_vld[rmap_int-1]) begin
          rdmap_vld[rmap_int] <= rdmap_vld[rmap_int-1];
          rdmap_reg[rmap_int] <= rdmap_reg[rmap_int-1];            
          rdmap_dat[rmap_int] <= rdmap_dat[rmap_int-1];            
        end else begin
          rdmap_vld[rmap_int] <= 1'b1;
          rdmap_reg[rmap_int] <= sdout2_out;
          rdmap_dat[rmap_int] <= ddout2;
        end
      end else if (rmap_int > 0) begin
        if (swrite && (swrradr == vrdradr_reg[rmap_int-1])) begin
          rdmap_vld[rmap_int] <= 1'b1;
          rdmap_reg[rmap_int] <= sdin[BITVBNK:0];
          rdmap_dat[rmap_int] <= ddin;
        end else begin
          rdmap_vld[rmap_int] <= rdmap_vld[rmap_int-1];
          rdmap_reg[rmap_int] <= rdmap_reg[rmap_int-1];            
          rdmap_dat[rmap_int] <= rdmap_dat[rmap_int-1];            
        end
      end else begin
        rdmap_vld[rmap_int] <= swrite && (swrradr == vrdradr_wire);
        rdmap_reg[rmap_int] <= sdin[BITVBNK:0];
        rdmap_dat[rmap_int] <= ddin;
      end
  end

  reg wr_srch_flag;
  parameter SRCWDTH = 1 << BITWDTH;
  reg [SRCWDTH-1:0] wr_srch_data;
//  reg [WIDTH-1:0] wr_srch_data;
//  reg wr_srch_dbit;
  reg wr_srch_flags;
  reg [SRCWDTH-1:0] wr_srch_datas;
//  reg [WIDTH-1:0] wr_srch_datas;
//  reg wr_srch_dbits;

  reg             rddat_vld [0:DRAM_DELAY-1];
  reg [WIDTH-1:0] rddat_reg [0:DRAM_DELAY-1];
  integer rfwd_int;
  always @(posedge clk) begin
    for (rfwd_int=0; rfwd_int<DRAM_DELAY; rfwd_int=rfwd_int+1)
      if (rfwd_int>SRAM_DELAY) begin
        rddat_vld[rfwd_int] <= rddat_vld[rfwd_int-1];
        rddat_reg[rfwd_int] <= rddat_reg[rfwd_int-1];
      end else if (rfwd_int==SRAM_DELAY) begin
        if (rddat_vld[rfwd_int-1]) begin
          rddat_vld[rfwd_int] <= rddat_vld[rfwd_int-1];
          rddat_reg[rfwd_int] <= rddat_reg[rfwd_int-1];
        end else begin
          rddat_vld[rfwd_int] <= wr_srch_flag;
          rddat_reg[rfwd_int] <= wr_srch_data;
        end
      end else if (rfwd_int > 0) begin
        if (vwrite_out && vread_reg[rfwd_int-1] && (vwrbadr_out == vrdbadr_reg[rfwd_int-1]) && (vwrradr_out == vrdradr_reg[rfwd_int-1])) begin
          rddat_vld[rfwd_int] <= 1'b1;
          rddat_reg[rfwd_int] <= vdin_out;
        end else begin
          rddat_vld[rfwd_int] <= rddat_vld[rfwd_int-1];
          rddat_reg[rfwd_int] <= rddat_reg[rfwd_int-1];
        end
      end else begin
        if (vwrite_out && vread_wire && (vwrbadr_out == vrdbadr_wire) && (vwrradr_out == vrdradr_wire)) begin
          rddat_vld[rfwd_int] <= 1'b1;
          rddat_reg[rfwd_int] <= vdin_out;
        end else begin
          rddat_vld[rfwd_int] <= 1'b0;
          rddat_reg[rfwd_int] <= 0;
        end
      end
  end

  reg              pdat_vld [0:DRAM_DELAY-1];
  reg [WIDTH-1:0]  pdat_reg [0:DRAM_DELAY-1];
  integer pfwd_int;
  always @(posedge clk) 
    for (pfwd_int=0; pfwd_int<DRAM_DELAY; pfwd_int=pfwd_int+1)
      if (pfwd_int > 0) begin
        if (pwrite && (pwrbadr == vrdbadr_reg[pfwd_int-1]) && (pwrradr == vrdradr_reg[pfwd_int-1])) begin
          pdat_vld[pfwd_int] <= 1'b1;
          pdat_reg[pfwd_int] <= pdin;
        end else begin
          pdat_vld[pfwd_int] <= pdat_vld[pfwd_int-1];
          pdat_reg[pfwd_int] <= pdat_reg[pfwd_int-1];
        end
      end else begin
        if (pwrite && (pwrbadr == vrdbadr_wire) && (pwrradr == vrdradr_wire)) begin
          pdat_vld[pfwd_int] <= 1'b1;
          pdat_reg[pfwd_int] <= pdin;
        end else begin
          pdat_vld[pfwd_int] <= 1'b0;
          pdat_reg[pfwd_int] <= 0;
        end
      end

// ECC Checking Module for Rd SRAM
  wire sdout2_bit1_err = 0;
  wire sdout2_bit2_err = 0;
  wire [7:0] sdout2_bit1_pos = 0;
  wire [7:0] sdout2_bit2_pos = 0;
  wire [SDOUT_WIDTH-1:0] sdout2_bit1_mask = sdout2_bit1_err << sdout2_bit1_pos;
  wire [SDOUT_WIDTH-1:0] sdout2_bit2_mask = sdout2_bit2_err << sdout2_bit2_pos;
  wire [SDOUT_WIDTH-1:0] sdout2_mask = sdout2_bit1_mask ^ sdout2_bit2_mask;
  wire sdout2_serr = |sdout2_mask && (|sdout2_bit1_mask ^ |sdout2_bit2_mask);
  wire sdout2_derr = |sdout2_mask && |sdout2_bit1_mask && |sdout2_bit2_mask;
  wire [SDOUT_WIDTH-1:0] sdout2_int = sdout2 ^ sdout2_mask;

  wire [BITVBNK:0]   sdout2_data = sdout2_int;
  wire [ECCBITS-1:0] sdout2_ecc = sdout2_int >> (BITVBNK+1);
  wire [BITVBNK:0]   sdout2_dup_data = sdout2_int >> (BITVBNK+1+ECCBITS);
  wire [BITVBNK:0]   sdout2_post_ecc;
  wire               sdout2_sec_err;
  wire               sdout2_ded_err;

  ecc_check   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
            ecc_check_sdout2(.din(sdout2_data),
                             .eccin(sdout2_ecc),
                             .dout(sdout2_post_ecc),
                             .sec_err(sdout2_sec_err),
                             .ded_err(sdout2_ded_err),
                             .clk(clk),
                             .rst(rst));

  assign sdout2_out = sdout2_ded_err ? sdout2_dup_data : sdout2_post_ecc;

// ECC Checking Module for Wr SRAM
  wire sdout1_bit1_err = 0;
  wire sdout1_bit2_err = 0;
  wire [7:0] sdout1_bit1_pos = 0;
  wire [7:0] sdout1_bit2_pos = 0;
  wire [SDOUT_WIDTH-1:0] sdout1_bit1_mask = sdout1_bit1_err << sdout1_bit1_pos;
  wire [SDOUT_WIDTH-1:0] sdout1_bit2_mask = sdout1_bit2_err << sdout1_bit2_pos;
  wire [SDOUT_WIDTH-1:0] sdout1_mask = sdout1_bit1_mask ^ sdout1_bit2_mask;
  wire sdout1_serr = |sdout1_mask && (|sdout1_bit1_mask ^ |sdout1_bit2_mask);
  wire sdout1_derr = |sdout1_mask && |sdout1_bit1_mask && |sdout1_bit2_mask;
  wire [SDOUT_WIDTH-1:0] sdout1_int = sdout1 ^ sdout1_mask;

  wire [BITVBNK:0]   sdout1_data = sdout1_int;
  wire [ECCBITS-1:0] sdout1_ecc = sdout1_int >> (BITVBNK+1);
  wire [BITVBNK:0]   sdout1_dup_data = sdout1_int >> (BITVBNK+1+ECCBITS);
  wire [BITVBNK:0]   sdout1_post_ecc;
  wire               sdout1_sec_err;
  wire               sdout1_ded_err;

  ecc_check #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
            ecc_check_sdout1(.din(sdout1_data),
                             .eccin(sdout1_ecc),
                             .dout(sdout1_post_ecc),
                             .sec_err(sdout1_sec_err),
                             .ded_err(sdout1_ded_err),
                             .clk(clk),
                             .rst(rst));

  wire [BITVBNK:0]   sdout1_out = sdout1_ded_err ? sdout1_dup_data : sdout1_post_ecc;
/*
  wire             wrmap_vld0 = wrmap_vld[0];
  wire [BITVBNK:0] wrmap_reg0 = wrmap_reg[0];
  wire             wrmap_vld1 = wrmap_vld[1];
  wire [BITVBNK:0] wrmap_reg1 = wrmap_reg[1];
  wire             rdmap_vld0 = rdmap_vld[0];
  wire [BITVBNK:0] rdmap_reg0 = rdmap_reg[0];
  wire             rdmap_vld1 = rdmap_vld[1];
  wire [BITVBNK:0] rdmap_reg1 = rdmap_reg[1];
  wire             rddat_vld0 = rddat_vld[0];
  wire [WIDTH-1:0] rddat_reg0 = rddat_reg[0];
  wire             rddat_vld1 = rddat_vld[1];
  wire [WIDTH-1:0] rddat_reg1 = rddat_reg[1];
*/

  wire [BITVBNK:0] rdmap_out = rdmap_vld[DRAM_DELAY-1] ? rdmap_reg[DRAM_DELAY-1] : sdout2_out;
  wire [WIDTH-1:0] rddat_out = rdmap_vld[DRAM_DELAY-1] ? rdmap_dat[DRAM_DELAY-1] : ddout2;
  wire [WIDTH-1:0] pdat_out = pdat_vld[DRAM_DELAY-1] ? pdat_reg[DRAM_DELAY-1] : pdout;

  wire               vread_vld_tmp = vread_out;
  wire               vread_serr_tmp = (rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ? ddout2_serr : pdout_serr;
  wire               vread_derr_tmp = (rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ? ddout2_derr : pdout_derr;
  wire [WIDTH-1:0]   vdout_int = (rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ? rddat_out : pdat_out;
  wire [WIDTH-1:0]   vdout_tmp = rddat_vld[DRAM_DELAY-1] ? rddat_reg[DRAM_DELAY-1] :
                                 ((SRAM_DELAY == DRAM_DELAY) && wr_srch_flag) ? wr_srch_data : vdout_int;
  wire               vread_fwrd_tmp = (((SRAM_DELAY == DRAM_DELAY) && wr_srch_flag) || rddat_vld[DRAM_DELAY-1] ||
                                       ((rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ? rdmap_vld[DRAM_DELAY-1] || ddout2_fwrd:
                                                                                                          (pdat_vld[DRAM_DELAY-1] || pdout_fwrd)));
  wire [BITPADR-1:0] vread_padr_tmp = ((rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ?
                                       ((NUMVBNK << (BITPADR-BITPBNK)) | ddout2_padr) : {vrdbadr_out,pdout_padr});

  reg               vread_vld;
  reg [WIDTH-1:0]   vdout;
  reg               vread_fwrd;
  reg               vread_serr;
  reg               vread_derr;
  reg [BITPADR-1:0] vread_padr;

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

  wire [BITVBNK:0]   wrmap_out = wrmap_vld[SRAM_DELAY-1] ? wrmap_reg[SRAM_DELAY-1] : sdout1_out;
  wire [WIDTH-1:0]   wrdat_out = wrmap_vld[SRAM_DELAY-1] ? wrdat_reg[SRAM_DELAY-1] : ddout1;

  reg [3:0]          wrfifo_cnt; 
  reg                wrfifo_old_vld [0:FIFOCNT-1];
  reg [BITVBNK-1:0]  wrfifo_old_map [0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_old_dat [0:FIFOCNT-1];
  reg                wrfifo_new_vld [0:FIFOCNT-1];
  reg [BITVBNK-1:0]  wrfifo_new_map [0:FIFOCNT-1];
  reg [BITVROW-1:0]  wrfifo_new_row [0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_new_dat [0:FIFOCNT-1];
  
  wire wrfifo_deq1 = !(REFRESH && vrefr_wire) && |wrfifo_cnt;
  always @(posedge clk)
    if (rst)
      wrfifo_cnt <= 0;
    else
      wrfifo_cnt <= wrfifo_cnt + vwrite_out - wrfifo_deq1;
  
  integer wfifo_int;
  always @(posedge clk)
    for (wfifo_int=FIFOCNT-1; wfifo_int>=0; wfifo_int=wfifo_int-1)
      if (vwrite_out && (wrfifo_cnt == (wrfifo_deq1+wfifo_int))) begin
        if (swrite && (swrradr == vwrradr_out)) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin;
          wrfifo_old_dat[wfifo_int] <= ddin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= wrmap_out[BITVBNK];
          wrfifo_old_map[wfifo_int] <= wrmap_out;
          wrfifo_old_dat[wfifo_int] <= wrdat_out;
        end
        wrfifo_new_vld[wfifo_int] <= 1'b1;
        wrfifo_new_map[wfifo_int] <= vwrbadr_out;
        wrfifo_new_row[wfifo_int] <= vwrradr_out;
        wrfifo_new_dat[wfifo_int] <= vdin_out;
      end else if (wrfifo_deq1 && (wfifo_int<FIFOCNT-1)) begin
        if (swrite && (swrradr == wrfifo_new_row[wfifo_int+1])) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin;
          wrfifo_old_dat[wfifo_int] <= ddin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= wrfifo_old_vld[wfifo_int+1];
          wrfifo_old_map[wfifo_int] <= wrfifo_old_map[wfifo_int+1];
          wrfifo_old_dat[wfifo_int] <= wrfifo_old_dat[wfifo_int+1];
        end
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int+1];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int+1];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int+1];
        wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int+1];
      end

  integer wsrc_int;
  always_comb begin
    wr_srch_flag = 1'b0;
    wr_srch_data = 0;
    for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] &&
	  (wrfifo_new_map[wsrc_int] == vrdbadr_reg[SRAM_DELAY-1]) &&
	  (wrfifo_new_row[wsrc_int] == vrdradr_reg[SRAM_DELAY-1])) begin
        wr_srch_flag = 1'b1;
        wr_srch_data = wrfifo_new_dat[wsrc_int];
      end
//    wr_srch_dbit = wr_srch_data[select_bit];
    wr_srch_flags = 1'b0;
    wr_srch_datas = 0;
    for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == select_bank) && (wrfifo_new_row[wsrc_int] == select_row)) begin
        wr_srch_flags = 1'b1;
        wr_srch_datas = wrfifo_new_dat[wsrc_int];
      end
//    wr_srch_dbits = wr_srch_datas[select_bit];
  end

  wire               sold_vld = wrfifo_deq1 && wrfifo_old_vld[0];
  wire [BITVBNK-1:0] sold_map = wrfifo_old_map[0];
  wire [BITVROW-1:0] sold_row = wrfifo_new_row[0];
  wire [WIDTH-1:0]   sold_dat = wrfifo_old_dat[0];
  wire               snew_vld = wrfifo_deq1 && wrfifo_new_vld[0];
  wire [BITVBNK-1:0] snew_map = wrfifo_new_map[0];
  wire [BITVROW-1:0] snew_row = wrfifo_new_row[0];
  wire [WIDTH-1:0]   snew_dat = wrfifo_new_dat[0];

  wire new_to_cache = snew_vld && (vread_wire && (vrdbadr_wire == snew_map));
  wire new_to_pivot = snew_vld && !new_to_cache;

  wire old_to_pivot = sold_vld && new_to_cache && (sold_map != snew_map);
  wire old_to_clear = sold_vld && new_to_pivot && (sold_map == snew_map);

  reg               pwrite;
  reg [BITVBNK-1:0] pwrbadr;
  reg [BITVROW-1:0] pwrradr;
  reg [WIDTH-1:0]   pdin;
  always_comb
    if (new_to_pivot) begin
      pwrite = 1'b1;
      pwrbadr = snew_map;
      pwrradr = snew_row;
      pdin = snew_dat;
    end else if (old_to_pivot) begin
      pwrite = 1'b1;
      pwrbadr = sold_map;
      pwrradr = sold_row;
      pdin = sold_dat;
    end else begin
      pwrite = 1'b0;
      pwrbadr = 0;
      pwrradr = 0;
      pdin = 0;
    end

  reg               swrite;
  reg [BITVROW-1:0] swrradr;
  reg [BITVBNK:0]   sdin_pre_ecc;
  reg [WIDTH-1:0]   ddin;
  always_comb
    if (rstvld) begin
      swrite = !rst;
      swrradr = rstaddr;
      sdin_pre_ecc = 0;
      ddin = 0;
    end else if (new_to_cache) begin
      swrite = 1'b1;
      swrradr = snew_row;
      sdin_pre_ecc = {1'b1,snew_map};
      ddin = snew_dat;
    end else if (old_to_clear) begin
      swrite = 1'b1;
      swrradr = sold_row;
      sdin_pre_ecc = 0;
      ddin = 0;
    end else begin
      swrite = 1'b0;
      swrradr = 0; 
      sdin_pre_ecc = 0;
      ddin = 0;
    end

  wire [ECCBITS-1:0] sdin_ecc;
  ecc_calc   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
      ecc_calc_inst (.din(sdin_pre_ecc), .eccout(sdin_ecc));

  assign sdin = {sdin_pre_ecc, sdin_ecc, sdin_pre_ecc};

endmodule



