
module core_1r1wor2w_1rw (vread, vwrite, vaddr, vdin, vread_vld, vdout, vread_err,
                          pwrite1, pwrbadr1, pwrradr1, pdin1,
                          pwrite2, pwrbadr2, pwrradr2, pdin2,
                          pread1, prdbadr1, prdradr1, pdout1,
   	                  swrite, swrradr, sdin,
           	          sread1, srdradr1, sdout1,
	                  sread2, srdradr2, sdout2,
                          cwrite, cwrradr, cdin,
	                  cread1, crdradr1, cdout1,
	                  cread2, crdradr2, cdout2,
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
  
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;

  parameter ECCDWIDTH = 4;
  parameter ECCBITS = 4;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input [1-1:0]                      vread;
  input [2-1:0]                      vwrite;
  input [2*BITADDR-1:0]              vaddr;
  input [2*WIDTH-1:0]                vdin;
  output [1-1:0]                     vread_vld;
  output [1*WIDTH-1:0]               vdout;
  output [1-1:0]                     vread_err;

  output                             pwrite1;
  output [BITVBNK-1:0]               pwrbadr1;
  output [BITVROW-1:0]               pwrradr1;
  output [WIDTH-1:0]                 pdin1;

  output                             pwrite2;
  output [BITVBNK-1:0]               pwrbadr2;
  output [BITVROW-1:0]               pwrradr2;
  output [WIDTH-1:0]                 pdin2;

  output                             pread1;
  output [BITVBNK-1:0]               prdbadr1;
  output [BITVROW-1:0]               prdradr1;
  input [WIDTH-1:0]                  pdout1;

  output                             swrite;
  output [BITVROW-1:0]               swrradr;
  output [SDOUT_WIDTH-1:0]           sdin;
  
  output                             sread1;
  output [BITVROW-1:0]               srdradr1;
  input [SDOUT_WIDTH-1:0]            sdout1;
  
  output                             sread2;
  output [BITVROW-1:0]               srdradr2;
  input [SDOUT_WIDTH-1:0]            sdout2;  

  output                             cwrite;
  output [BITVROW-1:0]               cwrradr;
  output [WIDTH-1:0]                 cdin;
  
  output                             cread1;
  output [BITVROW-1:0]               crdradr1;
  input [WIDTH-1:0]                  cdout1;
  
  output                             cread2;
  output [BITVROW-1:0]               crdradr2;
  input [WIDTH-1:0]                  cdout2;  

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

  wire               vread_wire [0:2-1];
  wire               vwrite_wire [0:2-1];
  wire [BITADDR-1:0] vaddr_wire [0:2-1];
  wire [BITVBNK-1:0] vbadr_wire [0:2-1];
  wire [BITVROW-1:0] vradr_wire [0:2-1];
  wire [WIDTH-1:0]   vdin_wire [0:2-1];

  wire [BITVBNK-1:0] select_bank;
  wire [BITVROW-1:0] select_row;
  
  genvar np2_int;
  generate begin: np2_loop
    assign vread_wire[0] = vread;
    assign vread_wire[1] = 1'b0;

    for (np2_int=0; np2_int<2; np2_int=np2_int+1) begin: np2_loop
      assign vwrite_wire[np2_int] = vwrite >> np2_int;
      assign vaddr_wire[np2_int] = vaddr >> (np2_int*BITADDR);
      assign vdin_wire[np2_int] = vdin >> (np2_int*WIDTH);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rw_adr_inst (.vbadr(vbadr_wire[np2_int]), .vradr(vradr_wire[np2_int]), .vaddr(vaddr_wire[np2_int]));
    end

    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
      sel_adr (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));
  end
  endgenerate

  reg                vread_reg [0:2-1][0:SRAM_DELAY];
  reg                vwrite_reg [0:2-1][0:SRAM_DELAY];
  reg [BITVBNK-1:0]  vbadr_reg [0:2-1][0:SRAM_DELAY];
  reg [BITVROW-1:0]  vradr_reg [0:2-1][0:SRAM_DELAY];
  reg [WIDTH-1:0]    vdin_reg [0:2-1][0:SRAM_DELAY];
 
  integer vprt_int, vdel_int; 
  always @(posedge clk) 
    for (vprt_int=0; vprt_int<2; vprt_int=vprt_int+1)
      for (vdel_int=0; vdel_int<SRAM_DELAY+1; vdel_int=vdel_int+1)
        if (vdel_int > 0) begin
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
          vwrite_reg[vprt_int][vdel_int] <= vwrite_reg[vprt_int][vdel_int-1];
          vbadr_reg[vprt_int][vdel_int] <= vbadr_reg[vprt_int][vdel_int-1];
          vradr_reg[vprt_int][vdel_int] <= vradr_reg[vprt_int][vdel_int-1];
          vdin_reg[vprt_int][vdel_int] <= vdin_reg[vprt_int][vdel_int-1];
        end else begin
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
          vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int];
          vbadr_reg[vprt_int][vdel_int] <= vbadr_wire[vprt_int];
          vradr_reg[vprt_int][vdel_int] <= vradr_wire[vprt_int];
          vdin_reg[vprt_int][vdel_int] <= vdin_wire[vprt_int];
        end

  wire               vread1_out = vread_reg[0][SRAM_DELAY-1];
  wire               vwrite1_out = vwrite_reg[0][SRAM_DELAY-1] && (!vwrite_reg[1][SRAM_DELAY-1] ||
								   (vbadr_reg[0][SRAM_DELAY-1] != vbadr_reg[1][SRAM_DELAY-1]) ||
								   (vradr_reg[0][SRAM_DELAY-1] != vradr_reg[1][SRAM_DELAY-1]));
  wire [BITVBNK-1:0] vbadr1_out = vbadr_reg[0][SRAM_DELAY-1];
  wire [BITVROW-1:0] vradr1_out = vradr_reg[0][SRAM_DELAY-1];
  wire [WIDTH-1:0]   vdin1_out = vdin_reg[0][SRAM_DELAY-1];       

  wire               vread2_out = vread_reg[1][SRAM_DELAY-1];
  wire               vwrite2_out = vwrite_reg[1][SRAM_DELAY-1];
  wire [BITVBNK-1:0] vbadr2_out = vbadr_reg[1][SRAM_DELAY-1];
  wire [BITVROW-1:0] vradr2_out = vradr_reg[1][SRAM_DELAY-1];
  wire [WIDTH-1:0]   vdin2_out = vdin_reg[1][SRAM_DELAY-1];       

  // Read request of pivoted data on DRAM memory
  assign pread1 = vread_wire[0];
  assign prdbadr1 = vbadr_wire[0];
  assign prdradr1 = vradr_wire[0];

  // Read request of mapping information on SRAM memory
  assign sread1 = (vread_wire[0] || vwrite_wire[0]) && (!swrite || (swrradr != srdradr1));
  assign srdradr1 = vradr_wire[0];
  assign sread2 = (vread_wire[1] || vwrite_wire[1]) && (!swrite || (swrradr != srdradr2));
  assign srdradr2 = vradr_wire[1];

  assign cread1 = (vread_wire[0] || vwrite_wire[0]) && (!cwrite || (cwrradr != crdradr1));
  assign crdradr1 = vradr_wire[0];
  assign cread2 = (vread_wire[1] || vwrite_wire[1]) && (!cwrite || (cwrradr != crdradr2));
  assign crdradr2 = vradr_wire[1];

  reg              map1_vld [0:SRAM_DELAY-1];
  reg [BITVBNK:0]  map1_reg [0:SRAM_DELAY-1];
  reg              map2_vld [0:SRAM_DELAY-1];
  reg [BITVBNK:0]  map2_reg [0:SRAM_DELAY-1];
  integer sfwd_int;
  always @(posedge clk) begin
    for (sfwd_int=0; sfwd_int<SRAM_DELAY+1; sfwd_int=sfwd_int+1)
      if (sfwd_int > 0) begin
        if (swrite && (swrradr == vradr_reg[0][sfwd_int-1])) begin
          map1_vld[sfwd_int] <= 1'b1;
          map1_reg[sfwd_int] <= sdin;
        end else begin
          map1_vld[sfwd_int] <= map1_vld[sfwd_int-1];
          map1_reg[sfwd_int] <= map1_reg[sfwd_int-1];            
        end
        if (swrite && (swrradr == vradr_reg[1][sfwd_int-1])) begin
          map2_vld[sfwd_int] <= 1'b1;
          map2_reg[sfwd_int] <= sdin;
        end else begin
          map2_vld[sfwd_int] <= map2_vld[sfwd_int-1];
          map2_reg[sfwd_int] <= map2_reg[sfwd_int-1];            
        end
      end else begin
        if (swrite && (swrradr == vradr_wire[0])) begin
          map1_vld[sfwd_int] <= 1'b1;
          map1_reg[sfwd_int] <= sdin;
        end else begin
          map1_vld[sfwd_int] <= 1'b0;
          map1_reg[sfwd_int] <= 0;
        end
        if (swrite && (swrradr == vradr_wire[1])) begin
          map2_vld[sfwd_int] <= 1'b1;
          map2_reg[sfwd_int] <= sdin;
        end else begin
          map2_vld[sfwd_int] <= 1'b0;
          map2_reg[sfwd_int] <= 0;
        end
      end
  end

  reg              cdat1_vld [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]  cdat1_reg [0:SRAM_DELAY-1];
  reg              cdat2_vld [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]  cdat2_reg [0:SRAM_DELAY-1];
  integer cfwd_int;
  always @(posedge clk) begin
    for (cfwd_int=0; cfwd_int<SRAM_DELAY; cfwd_int=cfwd_int+1)
      if (cfwd_int > 0) begin
        if (cwrite && (cwrradr == vradr_reg[0][cfwd_int-1])) begin
          cdat1_vld[cfwd_int] <= 1'b1;
          cdat1_reg[cfwd_int] <= cdin;
        end else begin
          cdat1_vld[cfwd_int] <= cdat1_vld[cfwd_int-1];
          cdat1_reg[cfwd_int] <= cdat1_reg[cfwd_int-1];            
        end
        if (cwrite && (cwrradr == vradr_reg[1][cfwd_int-1])) begin
          cdat2_vld[cfwd_int] <= 1'b1;
          cdat2_reg[cfwd_int] <= cdin;
        end else begin
          cdat2_vld[cfwd_int] <= cdat2_vld[cfwd_int-1];
          cdat2_reg[cfwd_int] <= cdat2_reg[cfwd_int-1];            
        end
      end else begin
        if (cwrite && (cwrradr == vradr_wire[0])) begin
          cdat1_vld[cfwd_int] <= 1'b1;
          cdat1_reg[cfwd_int] <= cdin;
        end else begin
          cdat1_vld[cfwd_int] <= 1'b0;
          cdat1_reg[cfwd_int] <= 0;
        end
        if (cwrite && (cwrradr == vradr_wire[1])) begin
          cdat2_vld[cfwd_int] <= 1'b1;
          cdat2_reg[cfwd_int] <= cdin;
        end else begin
          cdat2_vld[cfwd_int] <= 1'b0;
          cdat2_reg[cfwd_int] <= 0;
        end
      end
  end

  reg              pdat1_vld [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]  pdat1_reg [0:SRAM_DELAY-1];
  integer pfwd_int;
  always @(posedge clk) begin
    for (pfwd_int=0; pfwd_int<SRAM_DELAY; pfwd_int=pfwd_int+1)
      if (pfwd_int > 0) begin
        if (pwrite2 && (pwrbadr2 == vbadr_reg[0][pfwd_int-1]) && (pwrradr2 == vradr_reg[0][pfwd_int-1])) begin
          pdat1_vld[pfwd_int] <= 1'b1;
          pdat1_reg[pfwd_int] <= pdin2;
        end else if (pwrite1 && (pwrbadr1 == vbadr_reg[0][pfwd_int-1]) && (pwrradr1 == vradr_reg[0][pfwd_int-1])) begin
          pdat1_vld[pfwd_int] <= 1'b1;
          pdat1_reg[pfwd_int] <= pdin1;
        end else begin
          pdat1_vld[pfwd_int] <= pdat1_vld[pfwd_int-1];
          pdat1_reg[pfwd_int] <= pdat1_reg[pfwd_int-1];            
        end
      end else begin
        if (pwrite2 && (pwrbadr2 == vbadr_wire[0]) && (pwrradr2 == vradr_wire[0])) begin
          pdat1_vld[pfwd_int] <= 1'b1;
          pdat1_reg[pfwd_int] <= pdin2;
        end else if (pwrite1 && (pwrbadr1 == vbadr_wire[0]) && (pwrradr1 == vradr_wire[0])) begin
          pdat1_vld[pfwd_int] <= 1'b1;
          pdat1_reg[pfwd_int] <= pdin1;
        end else begin
          pdat1_vld[pfwd_int] <= 1'b0;
          pdat1_reg[pfwd_int] <= 0;
        end
      end
  end

  reg             rddat1_vld [0:SRAM_DELAY-1];
  reg [WIDTH-1:0] rddat1_reg [0:SRAM_DELAY-1];
  integer rfwd_int;
  always @(posedge clk) begin
    for (rfwd_int=0; rfwd_int<SRAM_DELAY; rfwd_int=rfwd_int+1)
      if (rfwd_int > 0) begin
        if (vwrite_reg[1][SRAM_DELAY-1] && vread_reg[0][rfwd_int-1] &&
            (vbadr_reg[1][SRAM_DELAY-1] == vbadr_reg[0][rfwd_int-1]) &&
	    (vradr_reg[1][SRAM_DELAY-1] == vradr_reg[0][rfwd_int-1])) begin
          rddat1_vld[rfwd_int] <= 1'b1;
          rddat1_reg[rfwd_int] <= vdin_reg[1][SRAM_DELAY-1];
        end else if (vwrite_reg[0][SRAM_DELAY-1] && vread_reg[0][rfwd_int-1] &&
                     (vbadr_reg[0][SRAM_DELAY-1] == vbadr_reg[0][rfwd_int-1]) &&
	             (vradr_reg[0][SRAM_DELAY-1] == vradr_reg[0][rfwd_int-1])) begin
          rddat1_vld[rfwd_int] <= 1'b1;
          rddat1_reg[rfwd_int] <= vdin_reg[0][SRAM_DELAY-1];
        end else begin
          rddat1_vld[rfwd_int] <= rddat1_vld[rfwd_int-1];
          rddat1_reg[rfwd_int] <= rddat1_reg[rfwd_int-1];
        end
      end else begin
        if (vwrite_reg[1][SRAM_DELAY-1] && vread_wire[0] &&
            (vbadr_reg[1][SRAM_DELAY-1] == vbadr_wire[0]) &&
	    (vradr_reg[1][SRAM_DELAY-1] == vradr_wire[0])) begin
          rddat1_vld[rfwd_int] <= 1'b1;
          rddat1_reg[rfwd_int] <= vdin_reg[1][SRAM_DELAY-1];
        end else if (vwrite_reg[0][SRAM_DELAY-1] && vread_wire[0] &&
                     (vbadr_reg[0][SRAM_DELAY-1] == vbadr_wire[0]) &&
	             (vradr_reg[0][SRAM_DELAY-1] == vradr_wire[0])) begin
          rddat1_vld[rfwd_int] <= 1'b1;
          rddat1_reg[rfwd_int] <= vdin_reg[0][SRAM_DELAY-1];
        end else begin
          rddat1_vld[rfwd_int] <= 1'b0;
          rddat1_reg[rfwd_int] <= 0;
        end
      end
  end

// ECC Generation Module
  reg [BITVBNK:0]   sdin_pre_ecc;
  wire [ECCBITS-1:0] sdin_ecc;
  ecc_calc   #(.ECCDWIDTH(ECCDWIDTH), .ECCWIDTH(ECCBITS))
      ecc_calc_inst (.din(sdin_pre_ecc), .eccout(sdin_ecc));

  assign sdin = {sdin_pre_ecc, sdin_ecc, sdin_pre_ecc};

// ECC Checking Module for SRAM
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
  wire [ECCBITS-1:0] sdout1_ecc = sdout1_int >> BITVBNK+1;
  wire [BITVBNK:0]   sdout1_dup_data = sdout1_int >> BITVBNK+1+ECCBITS;
  wire [BITVBNK:0]   sdout1_post_ecc;
  wire               sdout1_sec_err;
  wire               sdout1_ded_err;

  ecc_check   #(.ECCDWIDTH(ECCDWIDTH), .ECCWIDTH(ECCBITS))
            ecc_check_1 (.din(sdout1_data),
                         .eccin(sdout1_ecc),
                         .dout(sdout1_post_ecc),
                         .sec_err(sdout1_sec_err),
                         .ded_err(sdout1_ded_err),
                         .clk(clk),
                         .rst(rst));

  wire [BITVBNK:0]   sdout1_out = sdout1_ded_err ? sdout1_dup_data : sdout1_post_ecc;

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
  wire [ECCBITS-1:0] sdout2_ecc = sdout2_int >> BITVBNK+1;
  wire [BITVBNK:0]   sdout2_dup_data = sdout2_int >> BITVBNK+1+ECCBITS;
  wire [BITVBNK:0]   sdout2_post_ecc;
  wire               sdout2_sec_err;
  wire               sdout2_ded_err;

  ecc_check   #(.ECCDWIDTH(ECCDWIDTH), .ECCWIDTH(ECCBITS))
            ecc_check_2 (.din(sdout2_data),
                         .eccin(sdout2_ecc),
                         .dout(sdout2_post_ecc),
                         .sec_err(sdout2_sec_err),
                         .ded_err(sdout2_ded_err),
                         .clk(clk),
                         .rst(rst));

  wire [BITVBNK:0]   sdout2_out = sdout2_ded_err ? sdout2_dup_data : sdout2_post_ecc;

//  wire                   map1_vld0 = map1_vld[0];
//  wire [(BITVBNK+1)-1:0] map1_reg0 = map1_reg[0];
//  wire                   map1_vld1 = map1_vld[1];
//  wire [(BITVBNK+1)-1:0] map1_reg1 = map1_reg[1];
//  wire                   map2_vld0 = map2_vld[0];
//  wire [(BITVBNK+1)-1:0] map2_reg0 = map2_reg[0];
//  wire                   map2_vld1 = map2_vld[1];
//  wire [(BITVBNK+1)-1:0] map2_reg1 = map2_reg[1];

  wire [BITVBNK:0]   map1_out = map1_vld[SRAM_DELAY-1] ? map1_reg[SRAM_DELAY-1] : sdout1_out;
  wire [WIDTH-1:0]   cdat1_out = cdat1_vld[SRAM_DELAY-1] ? cdat1_reg[SRAM_DELAY-1] : cdout1;
  wire [WIDTH-1:0]   pdat1_out = pdat1_vld[SRAM_DELAY-1] ? pdat1_reg[SRAM_DELAY-1] : pdout1;

  wire [BITVBNK:0]   map2_out = map2_vld[SRAM_DELAY-1] ? map2_reg[SRAM_DELAY-1] : sdout2_out;
  wire [WIDTH-1:0]   cdat2_out = cdat2_vld[SRAM_DELAY-1] ? cdat2_reg[SRAM_DELAY-1] : cdout2;

  reg wr_srch_flag1;
  reg [WIDTH-1:0] wr_srch_data1;
  reg wr_srch_flags;
  reg [WIDTH-1:0] wr_srch_datas;
  reg wr_srch_dbits;

  wire             vread_vld1 = vread1_out;
  wire             vread_err1 = 1'b0;
  wire [WIDTH-1:0] vdout1_int = (wr_srch_flag1 ? wr_srch_data1 :
			         (map1_out[BITVBNK] && (map1_out[BITVBNK-1:0] == vbadr1_out)) ? cdat1_out : pdat1_out);
  wire [WIDTH-1:0] vdout1 = (rddat1_vld[SRAM_DELAY-1] ? rddat1_reg[SRAM_DELAY-1] : vdout1_int);
//  wire [WIDTH-1:0] vdout1 = (rddat1_vld[SRAM_DELAY-1] ? rddat1_reg[SRAM_DELAY-1] :
//			     wr_srch_flag1 ? wr_srch_data1 :
//			     (map1_out[BITVBNK] && (map1_out[BITVBNK-1:0] == vbadr1_out)) ? cdat1_out : pdat1_out);

  assign vread_vld = vread_vld1;
  assign vdout = vdout1;

  reg [3:0]          wrfifo_cnt;
  reg                wrfifo_old_vld [0:2*SRAM_DELAY+1];
  reg [BITVBNK-1:0]  wrfifo_old_map [0:2*SRAM_DELAY+1];
  reg [BITVROW-1:0]  wrfifo_old_row [0:2*SRAM_DELAY+1];
  reg [WIDTH-1:0]    wrfifo_old_dat [0:2*SRAM_DELAY+1];
  reg                wrfifo_new_vld [0:2*SRAM_DELAY+1];
  reg [BITVBNK-1:0]  wrfifo_new_map [0:2*SRAM_DELAY+1];
  reg [BITVROW-1:0]  wrfifo_new_row [0:2*SRAM_DELAY+1];
  reg [WIDTH-1:0]    wrfifo_new_dat [0:2*SRAM_DELAY+1];

  wire wrfifo_deq1 = !(vread_wire[0] && vread_wire[1]) && |wrfifo_cnt;
  wire wrfifo_deq2 = !(vread_wire[0] || vread_wire[1]) && (wrfifo_cnt > 1);
  always @(posedge clk)
    if (rst)
      wrfifo_cnt <= 0;
    else
      wrfifo_cnt <= wrfifo_cnt + vwrite1_out + vwrite2_out - wrfifo_deq1 - wrfifo_deq2;

  wire wrfifo_cnt_gt = (wrfifo_cnt > 3);

  integer wfifo_int;
  always @(posedge clk)
    for (wfifo_int=2*SRAM_DELAY+1; wfifo_int>=0; wfifo_int=wfifo_int-1)
      if (vwrite1_out && (wrfifo_cnt == (wrfifo_deq1+wrfifo_deq2+wfifo_int))) begin
        if (swrite && (swrradr == vradr1_out)) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= map1_out[BITVBNK];
          wrfifo_old_map[wfifo_int] <= map1_out;
        end
        wrfifo_old_row[wfifo_int] <= vradr1_out;
        if (cwrite && (cwrradr == vradr1_out))
          wrfifo_old_dat[wfifo_int] <= cdin;
        else
          wrfifo_old_dat[wfifo_int] <= cdat1_out;
        wrfifo_new_vld[wfifo_int] <= 1'b1;
        wrfifo_new_map[wfifo_int] <= vbadr1_out;
        wrfifo_new_row[wfifo_int] <= vradr1_out;
        wrfifo_new_dat[wfifo_int] <= vdin1_out;
      end else if (vwrite2_out && (wrfifo_cnt == (wrfifo_deq1+wrfifo_deq2-vwrite1_out+wfifo_int))) begin
        if (swrite && (swrradr == vradr2_out)) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= map2_out[BITVBNK];
          wrfifo_old_map[wfifo_int] <= map2_out;
        end
        wrfifo_old_row[wfifo_int] <= vradr2_out;
        if (cwrite && (cwrradr == vradr2_out))
          wrfifo_old_dat[wfifo_int] <= cdin;
        else
          wrfifo_old_dat[wfifo_int] <= cdat2_out;
        wrfifo_new_vld[wfifo_int] <= 1'b1;
        wrfifo_new_map[wfifo_int] <= vbadr2_out;
        wrfifo_new_row[wfifo_int] <= vradr2_out;
        wrfifo_new_dat[wfifo_int] <= vdin2_out;
      end else if (wrfifo_deq2 && (wfifo_int<2*SRAM_DELAY)) begin
        if (swrite && (swrradr == wrfifo_old_row[wfifo_int+2])) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= wrfifo_old_vld[wfifo_int+2];
          wrfifo_old_map[wfifo_int] <= wrfifo_old_map[wfifo_int+2];
        end
        wrfifo_old_row[wfifo_int] <= wrfifo_old_row[wfifo_int+2];
        if (cwrite && (cwrradr == wrfifo_old_row[wfifo_int+2]))
          wrfifo_old_dat[wfifo_int] <= cdin;
        else
          wrfifo_old_dat[wfifo_int] <= wrfifo_old_dat[wfifo_int+2];
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int+2];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int+2];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int+2];
        wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int+2];
      end else if (wrfifo_deq1 && (wfifo_int<2*SRAM_DELAY+1)) begin
        if (swrite && (swrradr == wrfifo_old_row[wfifo_int+1])) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= wrfifo_old_vld[wfifo_int+1];
          wrfifo_old_map[wfifo_int] <= wrfifo_old_map[wfifo_int+1];
        end
        wrfifo_old_row[wfifo_int] <= wrfifo_old_row[wfifo_int+1];
        if (cwrite && (cwrradr == wrfifo_old_row[wfifo_int+1]))
          wrfifo_old_dat[wfifo_int] <= cdin;
        else
          wrfifo_old_dat[wfifo_int] <= wrfifo_old_dat[wfifo_int+1];
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int+1];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int+1];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int+1];
        wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int+1];
      end else begin
        wrfifo_old_vld[wfifo_int] <= wrfifo_old_vld[wfifo_int];
        wrfifo_old_map[wfifo_int] <= wrfifo_old_map[wfifo_int];
        wrfifo_old_row[wfifo_int] <= wrfifo_old_row[wfifo_int];
        wrfifo_old_dat[wfifo_int] <= wrfifo_old_dat[wfifo_int];
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int];
        wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int];
      end

  wire wrfifo_old_vld_0 = wrfifo_old_vld[0];
  wire [BITVBNK-1:0] wrfifo_old_map_0 = wrfifo_old_map[0];
  wire [BITVROW-1:0] wrfifo_old_row_0 = wrfifo_old_row[0];
  wire [WIDTH-1:0] wrfifo_old_dat_0 = wrfifo_old_dat[0];
  wire wrfifo_new_vld_0 = wrfifo_new_vld[0];
  wire [BITVBNK-1:0] wrfifo_new_map_0 = wrfifo_new_map[0];
  wire [BITVROW-1:0] wrfifo_new_row_0 = wrfifo_new_row[0];
  wire [WIDTH-1:0] wrfifo_new_dat_0 = wrfifo_new_dat[0];
  wire wrfifo_old_vld_1 = wrfifo_old_vld[1];
  wire [BITVBNK-1:0] wrfifo_old_map_1 = wrfifo_old_map[1];
  wire [BITVROW-1:0] wrfifo_old_row_1 = wrfifo_old_row[1];
  wire [WIDTH-1:0] wrfifo_old_dat_1 = wrfifo_old_dat[1];
  wire wrfifo_new_vld_1 = wrfifo_new_vld[1];
  wire [BITVBNK-1:0] wrfifo_new_map_1 = wrfifo_new_map[1];
  wire [BITVROW-1:0] wrfifo_new_row_1 = wrfifo_new_row[1];
  wire [WIDTH-1:0] wrfifo_new_dat_1 = wrfifo_new_dat[1];
  wire wrfifo_old_vld_2 = wrfifo_old_vld[2];
  wire [BITVBNK-1:0] wrfifo_old_map_2 = wrfifo_old_map[2];
  wire [BITVROW-1:0] wrfifo_old_row_2 = wrfifo_old_row[2];
  wire [WIDTH-1:0] wrfifo_old_dat_2 = wrfifo_old_dat[2];
  wire wrfifo_new_vld_2 = wrfifo_new_vld[2];
  wire [BITVBNK-1:0] wrfifo_new_map_2 = wrfifo_new_map[2];
  wire [BITVROW-1:0] wrfifo_new_row_2 = wrfifo_new_row[2];
  wire [WIDTH-1:0] wrfifo_new_dat_2 = wrfifo_new_dat[2];
  wire wrfifo_old_vld_3 = wrfifo_old_vld[3];
  wire [BITVBNK-1:0] wrfifo_old_map_3 = wrfifo_old_map[3];
  wire [BITVROW-1:0] wrfifo_old_row_3 = wrfifo_old_row[3];
  wire [WIDTH-1:0] wrfifo_old_dat_3 = wrfifo_old_dat[3];
  wire wrfifo_new_vld_3 = wrfifo_new_vld[3];
  wire [BITVBNK-1:0] wrfifo_new_map_3 = wrfifo_new_map[3];
  wire [BITVROW-1:0] wrfifo_new_row_3 = wrfifo_new_row[3];
  wire [WIDTH-1:0] wrfifo_new_dat_3 = wrfifo_new_dat[3];

  integer wsrc_int;
  always_comb begin
    wr_srch_flag1 = 1'b0;
    wr_srch_data1 = 0;
    for (wsrc_int=0; wsrc_int<2*SRAM_DELAY+2; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == vbadr1_out) && (wrfifo_new_row[wsrc_int] == vradr1_out)) begin
        wr_srch_flag1 = 1'b1;
        wr_srch_data1 = wrfifo_new_dat[wsrc_int];
      end
    wr_srch_flags = 1'b0;
    wr_srch_datas = 0;
    for (wsrc_int=0; wsrc_int<2*SRAM_DELAY+2; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == select_bank) && (wrfifo_new_row[wsrc_int] == select_row)) begin
        wr_srch_flags = 1'b1;
        wr_srch_datas = wrfifo_new_dat[wsrc_int];
      end
    wr_srch_dbits = wr_srch_datas[select_bit];
  end

  wire               sold_vld1 = wrfifo_deq2 && wrfifo_old_vld[0];
  wire [BITVBNK-1:0] sold_map1 = wrfifo_old_map[0];
  wire [BITVROW-1:0] sold_row1 = wrfifo_old_row[0];
  wire [WIDTH-1:0]   sold_dat1 = wrfifo_old_dat[0];
  wire               snew_vld1 = wrfifo_deq2 && wrfifo_new_vld[0];
  wire [BITVBNK-1:0] snew_map1 = wrfifo_new_map[0];
  wire [BITVROW-1:0] snew_row1 = wrfifo_new_row[0];
  wire [WIDTH-1:0]   snew_dat1 = wrfifo_new_dat[0];

  wire               sold_vld2 = wrfifo_deq2 ? wrfifo_old_vld[1] : (wrfifo_deq1 && wrfifo_old_vld[0]);
  wire [BITVBNK-1:0] sold_map2 = wrfifo_deq2 ? wrfifo_old_map[1] : wrfifo_old_map[0];
  wire [BITVROW-1:0] sold_row2 = wrfifo_deq2 ? wrfifo_old_row[1] : wrfifo_old_row[0];
  wire [WIDTH-1:0]   sold_dat2 = wrfifo_deq2 ? wrfifo_old_dat[1] : wrfifo_old_dat[0];
  wire               snew_vld2 = wrfifo_deq2 ? wrfifo_new_vld[1] : (wrfifo_deq1 && wrfifo_new_vld[0]);
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
  // Write request to pivoted banks
  wire new_to_cache_1 = snew_vld1 && sold_vld1 && (snew_map1 == sold_map1);
  wire new_to_pivot_1 = snew_vld1 && (!sold_vld1 || (snew_map1 != sold_map1));

  wire new_to_cache_2 = snew_vld2 && ((new_to_pivot_1 && (snew_map1 == snew_map2)) || (vread_wire[0] && (vbadr_wire[0] == snew_map2)) || (vread_wire[1] && (vbadr_wire[1] == snew_map2)));
  wire new_to_pivot_2 = snew_vld2 && !new_to_cache_2;

  wire old_to_pivot_2 = sold_vld2 && new_to_cache_2 && (sold_map2 != snew_map2);
  wire old_to_clear_2 = sold_vld2 && new_to_pivot_2 && (sold_map2 == snew_map2);

  reg               pwrite1;
  reg [BITVBNK-1:0] pwrbadr1;
  reg [BITVROW-1:0] pwrradr1;
  reg [WIDTH-1:0]   pdin1;
  always_comb
    if (new_to_pivot_1) begin
      pwrite1 = 1'b1;
      pwrbadr1 = snew_map1;
      pwrradr1 = snew_row1;
      pdin1 = snew_dat1;
    end else begin
      pwrite1 = 1'b0;
      pwrbadr1 = 0;
      pwrradr1 = 0;
      pdin1 = 0;
    end

  reg               pwrite2;
  reg [BITVBNK-1:0] pwrbadr2;
  reg [BITVROW-1:0] pwrradr2;
  reg [WIDTH-1:0]   pdin2;
  always_comb
    if (new_to_pivot_2) begin
      pwrite2 = 1'b1;
      pwrbadr2 = snew_map2;
      pwrradr2 = snew_row2;
      pdin2 = snew_dat2;
    end else if (old_to_pivot_2) begin
      pwrite2 = 1'b1;
      pwrbadr2 = sold_map2;
      pwrradr2 = sold_row2;
      pdin2 = sold_dat2;
    end else begin
      pwrite2 = 1'b0;
      pwrbadr2 = 0;
      pwrradr2 = 0;
      pdin2 = 0;
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

endmodule
