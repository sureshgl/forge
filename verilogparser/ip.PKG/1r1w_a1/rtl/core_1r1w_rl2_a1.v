
module core_1r1w_rl2_a1 (vwrite, vwraddr, vdin,
                      vread, vrdaddr, vread_vld, vdout, vread_err,
                      pwrite, pwrbadr, pwrradr, pdin,
                      pread, prdbadr, prdradr, pdout,
   	              swrite, swrradr, sdin, ddin,
	              sread1, srdradr1, sdout1, ddout1,
	              sread2, srdradr2, sdout2, ddout2,
                      ready, clk, rst);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter ECCDWIDTH = 4;
  parameter ECCBITS = 4;
  
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input                              vwrite;
  input [BITADDR-1:0]                vwraddr;
  input [WIDTH-1:0]                  vdin;
  
  input                              vread;
  input [BITADDR-1:0]                vrdaddr;
  output                             vread_vld;
  output [WIDTH-1:0]                 vdout;
  output                             vread_err;


  output                             pwrite;
  output [BITVBNK-1:0]               pwrbadr;
  output [BITVROW-1:0]               pwrradr;
  output [WIDTH-1:0]                 pdin;

  output                             pread;
  output [BITVBNK-1:0]               prdbadr;
  output [BITVROW-1:0]               prdradr;
  input [WIDTH-1:0]                  pdout;

  output                             swrite;
  output [BITVROW-1:0]               swrradr;
  output [SDOUT_WIDTH-1:0]           sdin;
  output [WIDTH-1:0]                 ddin;
  
  output                             sread1;
  output [BITVROW-1:0]               srdradr1;
  input [SDOUT_WIDTH-1:0]            sdout1;
  input [WIDTH-1:0]                  ddout1;
  
  output                             sread2;
  output [BITVROW-1:0]               srdradr2;
  input [SDOUT_WIDTH-1:0]            sdout2;  
  input [WIDTH-1:0]                  ddout2;  

  output                             ready;
  input                              clk;
  input                              rst;

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

  wire [BITVBNK-1:0] vrdbadr;
  wire [BITVROW-1:0] vrdradr;
  np2_addr #(
    .NUMADDR (NUMADDR), .BITADDR (BITADDR),
    .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
    .NUMVROW (NUMVROW), .BITVROW (BITVROW))
    rd_adr_inst (.vbadr(vrdbadr), .vradr(vrdradr), .vaddr(vrdaddr));

  wire [BITVBNK-1:0] vwrbadr;
  wire [BITVROW-1:0] vwrradr;
  np2_addr #(
    .NUMADDR (NUMADDR), .BITADDR (BITADDR),
    .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
    .NUMVROW (NUMVROW), .BITVROW (BITVROW))
    wr_adr_inst (.vbadr(vwrbadr), .vradr(vwrradr), .vaddr(vwraddr));

  reg                vread_reg [0:SRAM_DELAY];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:SRAM_DELAY];
  reg [BITVROW-1:0]  vrdradr_reg [0:SRAM_DELAY];
  reg                vwrite_reg [0:SRAM_DELAY];
  reg [BITVBNK-1:0]  vwrbadr_reg [0:SRAM_DELAY];
  reg [BITVROW-1:0]  vwrradr_reg [0:SRAM_DELAY];
  reg [WIDTH-1:0]    vdin_reg [0:SRAM_DELAY];
 
  integer vdel_int; 
  always @(posedge clk) begin
    for (vdel_int=0; vdel_int<SRAM_DELAY+1; vdel_int=vdel_int+1)
      if (vdel_int > 0) begin
        vread_reg[vdel_int] <= vread_reg[vdel_int-1];
        vrdbadr_reg[vdel_int] <= vrdbadr_reg[vdel_int-1];
        vrdradr_reg[vdel_int] <= vrdradr_reg[vdel_int-1];
        vwrite_reg[vdel_int] <= vwrite_reg[vdel_int-1];
        vwrbadr_reg[vdel_int] <= vwrbadr_reg[vdel_int-1];
        vwrradr_reg[vdel_int] <= vwrradr_reg[vdel_int-1];          
        vdin_reg[vdel_int] <= vdin_reg[vdel_int-1];
      end else begin
        vread_reg[vdel_int] <= vread;
        vrdbadr_reg[vdel_int] <= vrdbadr;
        vrdradr_reg[vdel_int] <= vrdradr;
        vwrite_reg[vdel_int] <= vwrite;
        vwrbadr_reg[vdel_int] <= vwrbadr;
        vwrradr_reg[vdel_int] <= vwrradr;
        vdin_reg[vdel_int] <= vdin;          
      end
  end

  wire               vread_out = vread_reg[SRAM_DELAY-1];
  wire [BITVBNK-1:0] vrdbadr_out = vrdbadr_reg[SRAM_DELAY-1];
  wire [BITVROW-1:0] vrdradr_out = vrdradr_reg[SRAM_DELAY-1];

  wire               vwrite_out = vwrite_reg[SRAM_DELAY];
  wire [BITVBNK-1:0] vwrbadr_out = vwrbadr_reg[SRAM_DELAY];
  wire [BITVROW-1:0] vwrradr_out = vwrradr_reg[SRAM_DELAY];
  wire [WIDTH-1:0]   vdin_out = vdin_reg[SRAM_DELAY];       

  // Read request of pivoted data on DRAM memory
  assign pread = vread;
  assign prdbadr = vrdbadr;
  assign prdradr = vrdradr;

  // Read request of nonpivoted data in SRAM memory
  assign dread1 = vread;
  assign drdradr1 = vrdradr;
  assign dread2 = vwrite;
  assign drdradr2 = vwrradr;

  // Read request of mapping information on SRAM memory
  assign sread1 = vwrite && (!swrite || (swrradr != srdradr1));
  assign srdradr1 = vwrradr;
  assign sread2 = vread && (!swrite || (swrradr != srdradr2));
  assign srdradr2 = vrdradr;

  reg                    wrmap_vld [0:SRAM_DELAY];
  reg [BITVBNK:0]        wrmap_reg [0:SRAM_DELAY];
  reg [WIDTH-1:0]        wrdat_reg [0:SRAM_DELAY];
  integer wfwd_int;
  always @(posedge clk) begin
    for (wfwd_int=0; wfwd_int<SRAM_DELAY+1; wfwd_int=wfwd_int+1)
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
        if (swrite && (swrradr == vwrradr)) begin
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

  wire [BITVBNK:0]       wrmap_out;
  wire [WIDTH-1:0]       wrdat_out;

  reg                    rdmap_vld [0:SRAM_DELAY-1];
  reg [BITVBNK:0]        rdmap_reg [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]        rdmap_dat [0:SRAM_DELAY-1];
  integer rmap_int;    
  always @(posedge clk) begin
    for (rmap_int=0; rmap_int<SRAM_DELAY; rmap_int=rmap_int+1)
      if (rmap_int > 0) begin
        rdmap_vld[rmap_int] <= rdmap_vld[rmap_int-1];
        rdmap_reg[rmap_int] <= rdmap_reg[rmap_int-1];            
        rdmap_dat[rmap_int] <= rdmap_dat[rmap_int-1];            
      end else begin
        rdmap_vld[rmap_int] <= swrite && (swrradr == vrdradr);
        rdmap_reg[rmap_int] <= wrmap_out;
        rdmap_dat[rmap_int] <= wrdat_out;
      end
  end

  reg             rddat_vld [0:SRAM_DELAY-1];
  reg [WIDTH-1:0] rddat_reg [0:SRAM_DELAY-1];
  integer rfwd_int;
  always @(posedge clk) begin
    for (rfwd_int=0; rfwd_int<SRAM_DELAY; rfwd_int=rfwd_int+1)
      if (rfwd_int > 0) begin
        if (vwrite_reg[SRAM_DELAY-1] && vread_reg[rfwd_int-1] &&
            (vwrbadr_reg[SRAM_DELAY-1] == vrdbadr_reg[rfwd_int-1]) &&
	    (vwrradr_reg[SRAM_DELAY-1] == vrdradr_reg[rfwd_int-1])) begin
          rddat_vld[rfwd_int] <= 1'b1;
          rddat_reg[rfwd_int] <= vdin_reg[SRAM_DELAY-1];
        end else if (vwrite_reg[SRAM_DELAY] && vread_reg[rfwd_int-1] &&
	             (vwrbadr_reg[SRAM_DELAY] == vrdbadr_reg[rfwd_int-1]) &&
		     (vwrradr_reg[SRAM_DELAY] == vrdradr_reg[rfwd_int-1])) begin
          rddat_vld[rfwd_int] <= 1'b1;
          rddat_reg[rfwd_int] <= vdin_reg[SRAM_DELAY];
        end else begin
          rddat_vld[rfwd_int] <= rddat_vld[rfwd_int-1];
          rddat_reg[rfwd_int] <= rddat_reg[rfwd_int-1];
        end
      end else begin
        if (vwrite_reg[SRAM_DELAY-1] && vread &&
            (vwrbadr_reg[SRAM_DELAY-1] == vrdbadr) &&
	    (vwrradr_reg[SRAM_DELAY-1] == vrdradr)) begin
          rddat_vld[rfwd_int] <= 1'b1;
          rddat_reg[rfwd_int] <= vdin_reg[SRAM_DELAY-1];
        end else if (vwrite_reg[SRAM_DELAY] && vread &&
                     (vwrbadr_reg[SRAM_DELAY] == vrdbadr) &&
		     (vwrradr_reg[SRAM_DELAY] == vrdradr)) begin
          rddat_vld[rfwd_int] <= 1'b1;
          rddat_reg[rfwd_int] <= vdin_reg[SRAM_DELAY];
        end else begin
          rddat_vld[rfwd_int] <= 1'b0;
          rddat_reg[rfwd_int] <= 0;
        end
      end
  end

// ECC Generation Module
  wire [BITVBNK:0]   sdin_pre_ecc;
  wire [ECCBITS-1:0] sdin_ecc;
  ecc_calc   #(.ECCDWIDTH(ECCDWIDTH), .ECCWIDTH(ECCBITS))
      ecc_calc_inst (.din(sdin_pre_ecc), .eccout(sdin_ecc));

  assign sdin = {sdin_pre_ecc, sdin_ecc, sdin_pre_ecc};

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

  ecc_check   #(.ECCDWIDTH(ECCDWIDTH), .ECCWIDTH(ECCBITS))
            ecc_check_sdout2(.din(sdout2_data),
                             .eccin(sdout2_ecc),
                             .dout(sdout2_post_ecc),
                             .sec_err(sdout2_sec_err),
                             .ded_err(sdout2_ded_err),
                             .clk(clk),
                             .rst(rst));

  wire [BITVBNK:0]   sdout2_out = sdout2_ded_err ? sdout2_dup_data : sdout2_post_ecc;

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

  ecc_check #(.ECCDWIDTH(ECCDWIDTH), .ECCWIDTH(ECCBITS))
            ecc_check_sdout1(.din(sdout1_data),
                             .eccin(sdout1_ecc),
                             .dout(sdout1_post_ecc),
                             .sec_err(sdout1_sec_err),
                             .ded_err(sdout1_ded_err),
                             .clk(clk),
                             .rst(rst));

  wire [BITVBNK:0]   sdout1_out = sdout1_ded_err ? sdout1_dup_data : sdout1_post_ecc;

  reg [BITVBNK:0] sdout1_reg;
  reg [WIDTH-1:0] ddout1_reg;
  always @(posedge clk)
    begin
      sdout1_reg <= sdout1_out;
      ddout1_reg <= ddout1;
    end
/*
  wire             wrmap_vld0 = wrmap_vld[0];
  wire [BITVBNK:0] wrmap_reg0 = wrmap_reg[0];
  wire             wrmap_vld1 = wrmap_vld[1];
  wire [BITVBNK:0] wrmap_reg1 = wrmap_reg[1];
  wire             rdmap_vld0 = rdmap_vld[0];
  wire [BITVBNK:0] rdmap_reg0 = rdmap_reg[0];
  wire             rdmap_vld1 = rdmap_vld[1];
  wire [BITVBNK:0] rdmap_reg1 = rdmap_reg[1];
*/
  wire [BITVBNK:0] rdmap_out = rdmap_vld[SRAM_DELAY-1] ? rdmap_reg[SRAM_DELAY-1] : sdout2_out;
  wire [WIDTH-1:0] rddat_out = rdmap_vld[SRAM_DELAY-1] ? rdmap_dat[SRAM_DELAY-1] : ddout2;

  assign           wrmap_out = wrmap_vld[SRAM_DELAY] ? wrmap_reg[SRAM_DELAY] : sdout1_reg;
  assign           wrdat_out = wrmap_vld[SRAM_DELAY] ? wrdat_reg[SRAM_DELAY] : ddout1_reg;

  wire               srdmap_vld = rdmap_out[BITVBNK];
  wire [BITVBNK-1:0] srdmap_map = rdmap_out[BITVBNK-1:0];

  assign             vread_vld = vread_reg[SRAM_DELAY-1];
  assign             vread_err = 1'b0;
  assign             vdout = (rddat_vld[SRAM_DELAY-1] ? rddat_reg[SRAM_DELAY-1] :
	                      (srdmap_vld && (srdmap_map == vrdbadr_out)) ? rddat_out : pdout);

  wire               swrold_vld = vwrite_out && wrmap_out[BITVBNK];
  wire [BITVBNK-1:0] swrold_map = wrmap_out[BITVBNK-1:0];
  wire               swrnew_vld = vwrite_out;
  wire [BITVBNK-1:0] swrnew_map = vwrbadr_out;

  // Write request to pivoted banks
  reg               pwrite;
  reg [BITVBNK-1:0] pwrbadr;
  reg [BITVROW-1:0] pwrradr;
  reg [WIDTH-1:0]   pdin;
  reg               change_bank;
  reg [BITVBNK:0]   wrmap_next;
  always_comb
    if (swrnew_vld && (!vread || (swrnew_map != vrdbadr)))
      begin
        pwrite = 1'b1;
        pwrbadr = vwrbadr_out;
        pwrradr = vwrradr_out;
        pdin = vdin_out;
        change_bank = swrold_vld && (swrnew_map == swrold_map);
        wrmap_next = 0;
      end
    else if (swrold_vld && (!vread || (swrold_map != vrdbadr)))
      begin
        pwrite = 1'b1;
        pwrbadr = swrold_map;
        pwrradr = vwrradr_out;
        pdin = wrdat_out;
        change_bank = swrnew_vld;
        wrmap_next = {1'b1,vwrbadr_out};
      end
    else
      begin
        pwrite = 1'b0;
        pwrbadr = 0;
        pwrradr = 0;
        pdin = 0;
        change_bank = swrnew_vld;
        wrmap_next = {1'b1,vwrbadr_out};
      end

  assign swrite = rstvld || change_bank;
  assign swrradr = rstvld ? rstaddr : vwrradr_out;
  assign sdin_pre_ecc = rstvld ? {{(BITVBNK+1){1'b0}}} : wrmap_next;
  assign ddin = rstvld ? 0 : vdin_out;

endmodule


