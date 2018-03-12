module core_1r1w_dl (vrefr,
		     vwrite, vwraddr, vdin,
                     vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                     pref,
                     pwrite, pwrbadr, pwrradr, pdin,
                     pread, prdbadr, prdradr, pdout, pdout_fwrd, pdout_serr, pdout_derr, pdout_padr,
                     cwrite, cwrradr, cdin,
                     cread, crdradr, cdout,
   	             swrite, swrradr, sdin,
	             sread1, srdradr1, sdout1,
	             sread2, srdradr2, sdout2,
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
  parameter FIFOCNT = SRAM_DELAY+1;

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

  output                             pref;

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

  output                             cwrite;
  output [BITVROW-1:0]               cwrradr;
  output [WIDTH-1:0]                 cdin;

  output                             cread;
  output [BITVROW-1:0]               crdradr;
  input [WIDTH-1:0]                  cdout;

  output                             swrite;
  output [BITVROW-1:0]               swrradr;
  output [SDOUT_WIDTH-1:0]           sdin;
  
  output                             sread1;
  output [BITVROW-1:0]               srdradr1;
  input [SDOUT_WIDTH-1:0]            sdout1;
  
  output                             sread2;
  output [BITVROW-1:0]               srdradr2;
  input [SDOUT_WIDTH-1:0]            sdout2;  

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
    sel_adr (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));

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

  reg                vrefr_reg [0:SRAM_DELAY+DRAM_DELAY-1];
  reg                vread_reg [0:SRAM_DELAY+DRAM_DELAY-1];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:SRAM_DELAY+DRAM_DELAY-1];
  reg [BITVROW-1:0]  vrdradr_reg [0:SRAM_DELAY+DRAM_DELAY-1];
  reg                vwrite_reg [0:SRAM_DELAY+DRAM_DELAY-1];
  reg [BITVBNK-1:0]  vwrbadr_reg [0:SRAM_DELAY+DRAM_DELAY-1];
  reg [BITVROW-1:0]  vwrradr_reg [0:SRAM_DELAY+DRAM_DELAY-1];
  reg [WIDTH-1:0]    vdin_reg [0:SRAM_DELAY+DRAM_DELAY-1];
 
  integer vdel_int; 
  always @(posedge clk) begin
    for (vdel_int=0; vdel_int<SRAM_DELAY+DRAM_DELAY; vdel_int=vdel_int+1)
      if (vdel_int > 0) begin
        vrefr_reg[vdel_int] <= vrefr_reg[vdel_int-1];
        vread_reg[vdel_int] <= vread_reg[vdel_int-1];
        vrdbadr_reg[vdel_int] <= vrdbadr_reg[vdel_int-1];
        vrdradr_reg[vdel_int] <= vrdradr_reg[vdel_int-1];
        vwrite_reg[vdel_int] <= vwrite_reg[vdel_int-1];
        vwrbadr_reg[vdel_int] <= vwrbadr_reg[vdel_int-1];
        vwrradr_reg[vdel_int] <= vwrradr_reg[vdel_int-1];          
        vdin_reg[vdel_int] <= vdin_reg[vdel_int-1];
      end else begin
        vrefr_reg[vdel_int] <= vrefr_wire || !ready_wire;
        vread_reg[vdel_int] <= vread_wire && ready_wire;
        vrdbadr_reg[vdel_int] <= vrdbadr_wire;
        vrdradr_reg[vdel_int] <= vrdradr_wire;
        vwrite_reg[vdel_int] <= vwrite_wire && (vwraddr_wire < NUMADDR) && ready_wire;
        vwrbadr_reg[vdel_int] <= vwrbadr_wire;
        vwrradr_reg[vdel_int] <= vwrradr_wire;
        vdin_reg[vdel_int] <= vdin_wire;          
      end
  end

  wire               vrefr_out = vrefr_reg[SRAM_DELAY-1];

  wire               vread_out = vread_reg[SRAM_DELAY-1];
  wire [BITVBNK-1:0] vrdbadr_out = vrdbadr_reg[SRAM_DELAY-1];
  wire [BITVROW-1:0] vrdradr_out = vrdradr_reg[SRAM_DELAY-1];

  wire               vwrite_out = vwrite_reg[SRAM_DELAY-1];
  wire [BITVBNK-1:0] vwrbadr_out = vwrbadr_reg[SRAM_DELAY-1];
  wire [BITVROW-1:0] vwrradr_out = vwrradr_reg[SRAM_DELAY-1];
  wire [WIDTH-1:0]   vdin_out = vdin_reg[SRAM_DELAY-1];       
/*
  // Read request of pivoted data on DRAM memory
  assign pread = vread;
  assign prdbadr = vrdbadr;
  assign prdradr = vrdradr;

  // Read request of nonpivoted data in SRAM memory
  assign dread1 = vread;
  assign drdradr1 = vrdradr;
  assign dread2 = vwrite;
  assign drdradr2 = vwrradr;
*/
  // Read request of mapping information on SRAM memory
  assign sread1 = vwrite_wire && (!swrite || (swrradr != srdradr1));
  assign srdradr1 = vwrradr_wire;
  assign sread2 = vread_wire && (!swrite || (swrradr != srdradr2));
  assign srdradr2 = vrdradr_wire;

  reg              wrmap_vld [0:SRAM_DELAY-1];
  reg [BITVBNK:0]  wrmap_reg [0:SRAM_DELAY-1];
  integer wfwd_int;
  always @(posedge clk)
    for (wfwd_int=0; wfwd_int<SRAM_DELAY; wfwd_int=wfwd_int+1)
      if (wfwd_int > 0) begin
        if (swrite && (swrradr == vwrradr_reg[wfwd_int-1])) begin
          wrmap_vld[wfwd_int] <= 1'b1;
          wrmap_reg[wfwd_int] <= sdin[BITVBNK:0];
        end else begin
          wrmap_vld[wfwd_int] <= wrmap_vld[wfwd_int-1];
          wrmap_reg[wfwd_int] <= wrmap_reg[wfwd_int-1];            
        end
      end else begin
        wrmap_vld[wfwd_int] <= swrite && (swrradr == vwrradr_wire);
        wrmap_reg[wfwd_int] <= sdin[BITVBNK:0];
      end

  reg              rdmap_vld [0:SRAM_DELAY-1];
  reg [BITVBNK:0]  rdmap_reg [0:SRAM_DELAY-1];
  integer rmap_int;    
  always @(posedge clk)
    for (rmap_int=0; rmap_int<SRAM_DELAY; rmap_int=rmap_int+1)
      if (rmap_int > 0) begin
        if (swrite && (swrradr == vrdradr_reg[rmap_int-1])) begin
          rdmap_vld[rmap_int] <= 1'b1;
          rdmap_reg[rmap_int] <= sdin[BITVBNK:0];
        end else begin
          rdmap_vld[rmap_int] <= rdmap_vld[rmap_int-1];
          rdmap_reg[rmap_int] <= rdmap_reg[rmap_int-1];            
        end
      end else begin
        rdmap_vld[rmap_int] <= swrite && (swrradr == vrdradr_wire);
        rdmap_reg[rmap_int] <= sdin[BITVBNK:0];
      end

  reg [3:0]          wrfifo_cnt;
  reg                wrfifo_old_vld [0:FIFOCNT-1];
  reg [BITVBNK-1:0]  wrfifo_old_map [0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_old_dat [0:FIFOCNT-1];
  reg                wrfifo_new_vld [0:FIFOCNT-1];
  reg [BITVBNK-1:0]  wrfifo_new_map [0:FIFOCNT-1];
  reg [BITVROW-1:0]  wrfifo_new_row [0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_new_dat [0:FIFOCNT-1];

  reg wr_srch_flag;
//  reg [WIDTH-1:0] wr_srch_data;
  parameter SRCWDTH = 1 << BITWDTH;
  reg [SRCWDTH-1:0] wr_srch_data;
//  reg wr_srch_dbit;
  reg wr_srch_flags;
  reg [SRCWDTH-1:0] wr_srch_datas;
  integer wsrc_int;
  always_comb begin
    wr_srch_flag = 1'b0;
    wr_srch_data = 0;
    for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == vrdbadr_out) && (wrfifo_new_row[wsrc_int] == vrdradr_out)) begin
        wr_srch_flag = 1'b1;
        wr_srch_data = wrfifo_new_dat[wsrc_int];
      end
//    wr_srch_dbit = wr_srch_data[select_bit];
    wr_srch_flags = 1'b0;
//    wr_srch_dbits = 0;
    for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == select_bank) && (wrfifo_new_row[wsrc_int] == select_row)) begin
        wr_srch_flags = 1'b1;
        wr_srch_datas = wrfifo_new_dat[wsrc_int];
      end
  end

  reg             rddat_vld [SRAM_DELAY:SRAM_DELAY+DRAM_DELAY-1];
  reg [WIDTH-1:0] rddat_reg [SRAM_DELAY:SRAM_DELAY+DRAM_DELAY-1];
  integer rfwd_int;
  always @(posedge clk) begin
    for (rfwd_int=SRAM_DELAY; rfwd_int<SRAM_DELAY+DRAM_DELAY; rfwd_int=rfwd_int+1)
      if (rfwd_int>SRAM_DELAY) begin
        if (vwrite_reg[SRAM_DELAY+DRAM_DELAY-1] && vread_reg[rfwd_int-1] &&
            (vwrbadr_reg[SRAM_DELAY+DRAM_DELAY-1] == vrdbadr_reg[rfwd_int-1]) &&
	    (vwrradr_reg[SRAM_DELAY+DRAM_DELAY-1] == vrdradr_reg[rfwd_int-1])) begin
          rddat_vld[rfwd_int] <= 1'b1;
          rddat_reg[rfwd_int] <= vdin_reg[SRAM_DELAY+DRAM_DELAY-1];
        end else begin
          rddat_vld[rfwd_int] <= rddat_vld[rfwd_int-1];
          rddat_reg[rfwd_int] <= rddat_reg[rfwd_int-1];
        end
      end else begin
        if (vwrite_reg[SRAM_DELAY+DRAM_DELAY-1] && vread_reg[rfwd_int-1] &&
            (vwrbadr_reg[SRAM_DELAY+DRAM_DELAY-1] == vrdbadr_reg[rfwd_int-1]) &&
	    (vwrradr_reg[SRAM_DELAY+DRAM_DELAY-1] == vrdradr_reg[rfwd_int-1])) begin
          rddat_vld[rfwd_int] <= 1'b1;
          rddat_reg[rfwd_int] <= vdin_reg[SRAM_DELAY+DRAM_DELAY-1];
        end else begin
          rddat_vld[rfwd_int] <= wr_srch_flag;
          rddat_reg[rfwd_int] <= wr_srch_data;
        end
      end
  end

// ECC Checking Module for Rd SRAM
  wire sdout2_bit1_err = 0;
  wire sdout2_bit2_err = 0;
  wire [7:0] sdout2_bit1_pos = 0;
  wire [7:0] sdout2_bit2_pos = 0;
  wire [2*(BITVBNK+1)+ECCBITS-1:0] sdout2_bit1_mask = sdout2_bit1_err << sdout2_bit1_pos;
  wire [2*(BITVBNK+1)+ECCBITS-1:0] sdout2_bit2_mask = sdout2_bit2_err << sdout2_bit2_pos;
  wire [2*(BITVBNK+1)+ECCBITS-1:0] sdout2_mask = sdout2_bit1_mask ^ sdout2_bit2_mask;
  wire sdout2_serr = |sdout2_mask && (|sdout2_bit1_mask ^ |sdout2_bit2_mask);
  wire sdout2_derr = |sdout2_mask && |sdout2_bit1_mask && |sdout2_bit2_mask;
  wire [2*(BITVBNK+1)+ECCBITS-1:0] sdout2_int = sdout2 ^ sdout2_mask;

  wire [BITVBNK:0]   sdout2_data = sdout2_int[BITVBNK:0];
  wire [ECCBITS-1:0] sdout2_ecc = sdout2_int[BITVBNK+ECCBITS:BITVBNK+1];
  wire [BITVBNK:0]   sdout2_dup_data = sdout2_int[2*BITVBNK+ECCBITS+1:BITVBNK+ECCBITS+1];
  wire [BITVBNK:0]   sdout2_post_ecc;
  wire               rd_sec_err;
  wire               rd_ded_err;

  ecc_check   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
            ecc_check_rdmap(.din(sdout2_data),
                            .eccin(sdout2_ecc),
                            .dout(sdout2_post_ecc),
                            .sec_err(rd_sec_err),
                            .ded_err(rd_ded_err),
                            .clk(clk),
                            .rst(rst));

  wire [BITVBNK:0]   sdout2_out = rd_ded_err ? sdout2_dup_data : sdout2_post_ecc;

// ECC Checking Module for Wr SRAM
  wire sdout1_bit1_err = 0;
  wire sdout1_bit2_err = 0;
  wire [7:0] sdout1_bit1_pos = 0;
  wire [7:0] sdout1_bit2_pos = 0;
  wire [2*(BITVBNK+1)+ECCBITS-1:0] sdout1_bit1_mask = sdout1_bit1_err << sdout1_bit1_pos;
  wire [2*(BITVBNK+1)+ECCBITS-1:0] sdout1_bit2_mask = sdout1_bit2_err << sdout1_bit2_pos;
  wire [2*(BITVBNK+1)+ECCBITS-1:0] sdout1_mask = sdout1_bit1_mask ^ sdout1_bit2_mask;
  wire sdout1_serr = |sdout1_mask && (|sdout1_bit1_mask ^ |sdout1_bit2_mask);
  wire sdout1_derr = |sdout1_mask && |sdout1_bit1_mask && |sdout1_bit2_mask;
  wire [2*(BITVBNK+1)+ECCBITS-1:0] sdout1_int = sdout1 ^ sdout1_mask;

  wire [BITVBNK:0]   sdout1_data = sdout1_int[BITVBNK:0];
  wire [ECCBITS-1:0] sdout1_ecc = sdout1_int[BITVBNK+ECCBITS:BITVBNK+1];
  wire [BITVBNK:0]   sdout1_dup_data = sdout1_int[2*BITVBNK+ECCBITS+1:BITVBNK+ECCBITS+1];
  wire [BITVBNK:0]   sdout1_post_ecc;
  wire               wr_sec_err;
  wire               wr_ded_err;

  ecc_check   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
            ecc_check_wrmap(.din(sdout1_data),
                            .eccin(sdout1_ecc),
                            .dout(sdout1_post_ecc),
                            .sec_err(wr_sec_err),
                            .ded_err(wr_ded_err),
                            .clk(clk),
                            .rst(rst));

  wire [BITVBNK:0]   sdout1_out = wr_ded_err ? sdout1_dup_data : sdout1_post_ecc;

  wire [(BITVBNK+1)-1:0] rdmap_out = rdmap_vld[SRAM_DELAY-1] ? rdmap_reg[SRAM_DELAY-1] : sdout2_out;
//  wire [WIDTH-1:0]       rddat_out = rdmap_vld[SRAM_DELAY-1] ? rdmap_dat[SRAM_DELAY-1] : ddout2;


  wire               srdmap_vld = rdmap_out[BITVBNK];
  wire [BITVBNK-1:0] srdmap_map = rdmap_out[BITVBNK-1:0];

  assign pread = vread_out && !(srdmap_vld && (srdmap_map == vrdbadr_out));
  assign prdbadr = vrdbadr_out;
  assign prdradr = vrdradr_out;

  wire read_from_cache = vread_out && (srdmap_vld && (srdmap_map == vrdbadr_out));

  wire               cread2 = vread_out && read_from_cache;
  wire [BITVROW-1:0] crdradr2 = vrdradr_out;

  wire               cread1 = !read_from_cache && vwrite_out;
  wire [BITVROW-1:0] crdradr1 = vwrradr_out;

  assign cread = (cread1 || cread2) && (!cwrite || (cwrradr != crdradr));
//  assign cread = cread1 || cread2;
  assign crdradr = cread2 ? vrdradr_out : vwrradr_out;

  reg                pread_reg [0:DRAM_DELAY-1];
  reg                cread2_reg [0:DRAM_DELAY-1];
  reg [WIDTH-1:0]    cdout2_reg [0:DRAM_DELAY-1];
  reg                cread1_reg [0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  crdbadr1_reg [0:SRAM_DELAY-1];
  reg [BITVROW-1:0]  crdradr1_reg [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]    cdin1_reg [0:SRAM_DELAY-1];
 
  integer cdel_int; 
  always @(posedge clk) begin
    for (cdel_int=0; cdel_int<DRAM_DELAY; cdel_int=cdel_int+1)
      if (cdel_int > 0) begin
        pread_reg[cdel_int] <= pread_reg[cdel_int-1];
        cread2_reg[cdel_int] <= cread2_reg[cdel_int-1];
        if (cdel_int==SRAM_DELAY)
          cdout2_reg[cdel_int] <= cdout;
        else
          cdout2_reg[cdel_int] <= cdout2_reg[cdel_int-1];
        if (cdel_int<SRAM_DELAY) begin
          cread1_reg[cdel_int] <= cread1_reg[cdel_int-1];
          crdbadr1_reg[cdel_int] <= crdbadr1_reg[cdel_int-1];
          crdradr1_reg[cdel_int] <= crdradr1_reg[cdel_int-1];
          if (read_from_cache && vwrite_out && (crdbadr1_reg[cdel_int-1] == vwrbadr_out) && (crdradr1_reg[cdel_int-1] == vwrradr_out))
            cdin1_reg[cdel_int] <= vdin_out;
          else
            cdin1_reg[cdel_int] <= cdin1_reg[cdel_int-1];
        end
      end else begin
        pread_reg[cdel_int] <= pread;
        cread2_reg[cdel_int] <= cread2;
        cread1_reg[cdel_int] <= cread1;
        crdbadr1_reg[cdel_int] <= vwrbadr_out;
        crdradr1_reg[cdel_int] <= vwrradr_out;
        cdin1_reg[cdel_int] <= vdin_out;
      end
  end

  wire               pread_out = pread_reg[DRAM_DELAY-1];
  wire               cread2_out = cread2_reg[DRAM_DELAY-1];
  wire [WIDTH-1:0]   cdout2_out = (SRAM_DELAY < DRAM_DELAY) ? cdout2_reg[DRAM_DELAY-1] : cdout;

  wire               cread1_out = cread1_reg[SRAM_DELAY-1];
  wire [BITVBNK-1:0] crdbadr1_out = crdbadr1_reg[SRAM_DELAY-1];
  wire [BITVROW-1:0] crdradr1_out = crdradr1_reg[SRAM_DELAY-1];
  wire [WIDTH-1:0]   cdin1_out = cdin1_reg[SRAM_DELAY-1];       

  wire [BITVBNK:0]   wrmap_out = wrmap_vld[SRAM_DELAY-1] ? wrmap_reg[SRAM_DELAY-1] : sdout1_out;

  reg              wmmap_vld [0:SRAM_DELAY-1];
  reg [BITVBNK:0]  wmmap_reg [0:SRAM_DELAY-1];
  integer wmfwd_int;
  always @(posedge clk)
    for (wmfwd_int=0; wmfwd_int<SRAM_DELAY; wmfwd_int=wmfwd_int+1)
      if (wmfwd_int > 0) begin
        if (swrite && (swrradr == crdradr1_reg[wmfwd_int-1])) begin
          wmmap_vld[wmfwd_int] <= 1'b1;
          wmmap_reg[wmfwd_int] <= sdin;
        end else begin
          wmmap_vld[wmfwd_int] <= wmmap_vld[wmfwd_int-1];
          wmmap_reg[wmfwd_int] <= wmmap_reg[wmfwd_int-1];            
        end
      end else
	if (swrite && (swrradr == crdradr1)) begin
          wmmap_vld[wmfwd_int] <= 1'b1;
          wmmap_reg[wmfwd_int] <= sdin;
        end else begin
          wmmap_vld[wmfwd_int] <= 1'b0;
          wmmap_reg[wmfwd_int] <= wrmap_out;
        end

  reg              wrdat_vld [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]  wrdat_reg [0:SRAM_DELAY-1];
  integer wdfwd_int;
  always @(posedge clk)
    for (wdfwd_int=0; wdfwd_int<SRAM_DELAY; wdfwd_int=wdfwd_int+1)
      if (wdfwd_int > 0)
        if (cwrite && (cwrradr == crdradr1_reg[wdfwd_int-1])) begin
          wrdat_vld[wdfwd_int] <= 1'b1;
          wrdat_reg[wdfwd_int] <= cdin;
        end else begin
          wrdat_vld[wdfwd_int] <= wrdat_vld[wdfwd_int-1];
          wrdat_reg[wdfwd_int] <= wrdat_reg[wdfwd_int-1];            
        end
      else
	if (cwrite && (cwrradr == crdradr1)) begin
          wrdat_vld[wdfwd_int] <= 1'b1;
          wrdat_reg[wdfwd_int] <= cdin;
        end else begin
          wrdat_vld[wdfwd_int] <= 1'b0;
          wrdat_reg[wdfwd_int] <= 0;
        end

  wire [BITVBNK:0]       wmmap_out = wmmap_reg[SRAM_DELAY-1];
  wire [WIDTH-1:0]       wrdat_out = wrdat_vld[SRAM_DELAY-1] ? wrdat_reg[SRAM_DELAY-1] : cdout;

  wire wrfifo_deq = !(REFRESH && vrefr_out) && !read_from_cache && |wrfifo_cnt;
  always @(posedge clk)
    if (rst)
      wrfifo_cnt <= 0;
    else
      wrfifo_cnt <= wrfifo_cnt + cread1_out - wrfifo_deq;

  integer wfifo_int;
  always @(posedge clk)
    for (wfifo_int=FIFOCNT-1; wfifo_int>=0; wfifo_int=wfifo_int-1)
      if (cread1_out && (wrfifo_cnt == (wrfifo_deq+wfifo_int))) begin
        if (swrite && (swrradr == crdradr1_out)) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK]; 
          wrfifo_old_map[wfifo_int] <= sdin[BITVBNK-1:0];
        end else begin
          wrfifo_old_vld[wfifo_int] <= wmmap_out[BITVBNK]; 
          wrfifo_old_map[wfifo_int] <= wmmap_out[BITVBNK-1:0];
        end
        if (cwrite && (cwrradr == crdradr1_out))
          wrfifo_old_dat[wfifo_int] <= cdin;
        else
          wrfifo_old_dat[wfifo_int] <= wrdat_out;
        wrfifo_new_vld[wfifo_int] <= 1'b1;
        wrfifo_new_map[wfifo_int] <= crdbadr1_out;
        wrfifo_new_row[wfifo_int] <= crdradr1_out;
        if (read_from_cache && vwrite_out && (crdbadr1_out == vwrbadr_out) && (crdradr1_out == vwrradr_out)) 
          wrfifo_new_dat[wfifo_int] <= vdin_out;
        else
          wrfifo_new_dat[wfifo_int] <= cdin1_out;
      end else if (wrfifo_deq && (wfifo_int<FIFOCNT-1)) begin
        if (swrite && (swrradr == wrfifo_new_row[wfifo_int+1])) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin[BITVBNK-1:0]; 
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
        if (read_from_cache && vwrite_out && (wrfifo_new_map[wfifo_int+1] == vwrbadr_out) && (wrfifo_new_row[wfifo_int+1] == vwrradr_out)) 
          wrfifo_new_dat[wfifo_int] <= vdin_out;
        else
          wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int+1];
      end else begin
        if (swrite && (swrradr == wrfifo_new_row[wfifo_int])) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin[BITVBNK-1:0];
        end else begin
          wrfifo_old_vld[wfifo_int] <= wrfifo_old_vld[wfifo_int];
          wrfifo_old_map[wfifo_int] <= wrfifo_old_map[wfifo_int];
        end
        if (cwrite && (cwrradr == wrfifo_new_row[wfifo_int]))
          wrfifo_old_dat[wfifo_int] <= vdin_out;
        else
          wrfifo_old_dat[wfifo_int] <= wrfifo_old_dat[wfifo_int];
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int];
        if (read_from_cache && vwrite_out && (wrfifo_new_map[wfifo_int] == vwrbadr_out) && (wrfifo_new_row[wfifo_int] == vwrradr_out)) 
          wrfifo_new_dat[wfifo_int] <= vdin_out;
        else
          wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int];
      end


  // Read request of pivoted data on DRAM memory

  wire               vread_vld_tmp = pread_out || cread2_out;
  wire               vread_serr_tmp = cread2_out ? 1'b0 : pdout_serr;
  wire               vread_derr_tmp = cread2_out ? 1'b0 : pdout_derr;
  wire [WIDTH-1:0]   vdout_int = cread2_out ? cdout2_out : pdout;
  wire [WIDTH-1:0]   vdout_tmp = rddat_vld[SRAM_DELAY+DRAM_DELAY-1] ? rddat_reg[SRAM_DELAY+DRAM_DELAY-1] : vdout_int;
  wire               vread_fwrd_tmp = rddat_vld[SRAM_DELAY+DRAM_DELAY-1] || (cread2_out ? 1'b0 : pdout_fwrd);
  wire [BITPADR-1:0] vread_padr_tmp = cread2_out ? ((NUMVBNK << (BITPADR-BITPBNK)) | vrdradr_reg[SRAM_DELAY+DRAM_DELAY-1]) :
					           {vrdbadr_reg[SRAM_DELAY+DRAM_DELAY-1],pdout_padr};

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
/*
  wire                   wrmap_vld0 = wrmap_vld[0];
  wire [(BITVBNK+1)-1:0] wrmap_reg0 = wrmap_reg[0];
  wire                   wrmap_vld1 = wrmap_vld[1];
  wire [(BITVBNK+1)-1:0] wrmap_reg1 = wrmap_reg[1];

  wire rddat_vld_1 = rddat_vld[1];
  wire [WIDTH-1:0] rddat_reg_1 = rddat_reg[1];
  wire rddat_vld_2 = rddat_vld[2];
  wire [WIDTH-1:0] rddat_reg_2 = rddat_reg[2];
  wire rddat_vld_3 = rddat_vld[3];
  wire [WIDTH-1:0] rddat_reg_3 = rddat_reg[3];

  wire wrdat_vld_0 = wrdat_vld[0];
  wire [WIDTH-1:0] wrdat_reg_0 = wrdat_reg[0];
  wire wrdat_vld_1 = wrdat_vld[1];
  wire [WIDTH-1:0] wrdat_reg_1 = wrdat_reg[1];

  wire vwrite_reg_0 = vwrite_reg[0];
  wire [BITVBNK-1:0] vwrbadr_reg_0 = vwrbadr_reg[0];
  wire [BITVROW-1:0] vwrradr_reg_0 = vwrradr_reg[0];
  wire vwrite_reg_1 = vwrite_reg[1];
  wire [BITVBNK-1:0] vwrbadr_reg_1 = vwrbadr_reg[1];
  wire [BITVROW-1:0] vwrradr_reg_1 = vwrradr_reg[1];
  wire vwrite_reg_2 = vwrite_reg[2];
  wire [BITVBNK-1:0] vwrbadr_reg_2 = vwrbadr_reg[2];
  wire [BITVROW-1:0] vwrradr_reg_2 = vwrradr_reg[2];
  wire vwrite_reg_3 = vwrite_reg[3];
  wire [BITVBNK-1:0] vwrbadr_reg_3 = vwrbadr_reg[3];
  wire [BITVROW-1:0] vwrradr_reg_3 = vwrradr_reg[3];
*/
  wire               swrold_vld = wrfifo_deq && wrfifo_old_vld[0];
  wire [BITVBNK-1:0] swrold_map = wrfifo_old_map[0];
  wire [BITVROW-1:0] swrold_row = wrfifo_new_row[0];
  wire [WIDTH-1:0]   swrold_dat = wrfifo_old_dat[0];

  wire               swrnew_vld = wrfifo_deq && wrfifo_new_vld[0];
  wire [BITVBNK-1:0] swrnew_map = wrfifo_new_map[0];
  wire [BITVROW-1:0] swrnew_row = wrfifo_new_row[0];
  wire [WIDTH-1:0]   swrnew_dat = wrfifo_new_dat[0]; 

  // Write request to pivoted banks
  wire new_to_pivot = swrnew_vld && (read_from_cache || !pread || (prdbadr != swrnew_map));
  wire new_to_cache = swrnew_vld && !new_to_pivot;

  wire old_to_pivot = swrold_vld && new_to_cache && (swrold_map != swrnew_map);
  wire old_to_clear = swrold_vld && new_to_pivot && (swrold_map == swrnew_map);

  wire cut_to_pivot = vwrite_out && read_from_cache;
  wire cut_to_clear = cut_to_pivot && wrmap_out[BITVBNK] && (wrmap_out[BITVBNK-1:0] == vwrbadr_out);

  assign pref = vrefr_out;

  reg               pwrite;
  reg [BITVBNK-1:0] pwrbadr;
  reg [BITVROW-1:0] pwrradr;
  reg [WIDTH-1:0]   pdin;
  always_comb
    if (cut_to_pivot) begin
      pwrite = 1'b1;
      pwrbadr = vwrbadr_out;
      pwrradr = vwrradr_out;
      pdin = vdin_out; 
    end else if (new_to_pivot) begin
      pwrite = 1'b1;
      pwrbadr = swrnew_map;
      pwrradr = swrnew_row;
      pdin = swrnew_dat;
    end else if (old_to_pivot) begin
      pwrite = 1'b1;
      pwrbadr = swrold_map;
      pwrradr = swrold_row;
      pdin = swrold_dat;
    end else begin
      pwrite = 1'b0;
      pwrbadr = 0;
      pwrradr = 0;
      pdin = 0;
    end

  reg               swrite;
  reg [BITVROW-1:0] swrradr;
  reg [BITVBNK:0]   sdin_pre_ecc;
  always_comb
    if (rstvld) begin
      swrite = 1'b1;
      swrradr = rstaddr;
      sdin_pre_ecc = 0;
    end else if (new_to_cache) begin
      swrite = 1'b1;
      swrradr = swrnew_row;
      sdin_pre_ecc = {1'b1,swrnew_map};
    end else if (old_to_clear) begin
      swrite = 1'b1;
      swrradr = swrold_row;
      sdin_pre_ecc = 0;
    end else if (cut_to_clear) begin
      swrite = 1'b1;
      swrradr = vwrradr_out;
      sdin_pre_ecc = 0;
    end else begin
      swrite = 1'b0;
      swrradr = 0;
      sdin_pre_ecc = 0;
    end

  reg               cwrite;
  reg [BITVROW-1:0] cwrradr;
  reg [WIDTH-1:0]   cdin;
  always_comb
    if (rstvld) begin
      cwrite = 1'b1;
      cwrradr = rstaddr;
      cdin = 0;
    end else if (new_to_cache) begin
      cwrite = 1'b1;
      cwrradr = swrnew_row;
      cdin = swrnew_dat;
    end else begin
      cwrite = 1'b0;
      cwrradr = 0;
      cdin = 0;
    end

// ECC Generation Module
  wire [ECCBITS-1:0] sdin_ecc;
  ecc_calc   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
      ecc_calc_inst (.din(sdin_pre_ecc), .eccout(sdin_ecc));

  assign sdin = {sdin_pre_ecc, sdin_ecc, sdin_pre_ecc};

endmodule


