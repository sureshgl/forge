
module core_1rw1w_1rw (vrefr, vread, vwrite, vaddr, vdin, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                       prefr,
                       pwrite1, pwrbadr1, pwrradr1, pdin1,
                       pwrite2, pwrbadr2, pwrradr2, pdin2,
                       pread1, prdbadr1, prdradr1, pdout1, ppadr1,
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
  parameter BITPBNK = 4;
  parameter BITPADR = 14;
  parameter REFRESH = 0;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter ECCBITS = 4;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  parameter FIFOCNT = 2*SRAM_DELAY+2+REFRESH;

  input                              vrefr;

  input [1-1:0]                      vread;
  input [2-1:0]                      vwrite;
  input [2*BITADDR-1:0]              vaddr;
  input [2*WIDTH-1:0]                vdin;
  output [1-1:0]                     vread_vld;
  output [1*WIDTH-1:0]               vdout;
  output [1-1:0]                     vread_fwrd;
  output [1-1:0]                     vread_serr;
  output [1-1:0]                     vread_derr;
  output [1*BITPADR-1:0]             vread_padr;

  output                             prefr;

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
  input [BITPADR-BITPBNK-1:0]        ppadr1;

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

  wire               ready_wire;
  wire               vrefr_wire;
  wire [1-1 : 0]     vread_wire [0:2-1];
  wire               vwrite_wire [0:2-1];
  wire [BITADDR-1:0] vaddr_wire [0:2-1];
  wire [BITVBNK-1:0] vbadr_wire [0:2-1];
  wire [BITVROW-1:0] vradr_wire [0:2-1];
  wire [WIDTH-1:0]   vdin_wire [0:2-1];

  wire [BITVBNK-1:0] select_bank;
  wire [BITVROW-1:0] select_row;

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg vrefr_reg;
    reg [1-1:0] vread_reg;
    reg [2-1:0] vwrite_reg;
    reg [2*BITADDR-1:0] vaddr_reg;
    reg [2*WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vrefr_reg <= vrefr;
      vread_reg <= vread & ready;
      vwrite_reg <= vwrite & {2{ready}};
      vaddr_reg <= vaddr;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    assign vrefr_wire = vrefr_reg;

    assign vread_wire[0] = vread_reg;
    for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: np2_loop
      assign vwrite_wire[np2_var] = vwrite_reg >> np2_var;
      assign vaddr_wire[np2_var] = vaddr_reg >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*WIDTH);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rw_adr_inst (.vbadr(vbadr_wire[np2_var]), .vradr(vradr_wire[np2_var]), .vaddr(vaddr_wire[np2_var]));
    end

    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
      sel_adr (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));
  end else begin: noflpi_loop
    assign ready_wire = ready;
    assign vrefr_wire = vrefr;

    assign vread_wire[0] = vread;
    for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: np2_loop
      assign vwrite_wire[np2_var] = vwrite >> np2_var;
      assign vaddr_wire[np2_var] = vaddr >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rw_adr_inst (.vbadr(vbadr_wire[np2_var]), .vradr(vradr_wire[np2_var]), .vaddr(vaddr_wire[np2_var]));
    end

    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
      sel_adr (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));
  end
  endgenerate

  reg                vread_reg [0:2-1][0:DRAM_DELAY];
  reg                vwrite_reg [0:2-1][0:DRAM_DELAY];
  reg [BITVBNK-1:0]  vbadr_reg [0:2-1][0:DRAM_DELAY];
  reg [BITVROW-1:0]  vradr_reg [0:2-1][0:DRAM_DELAY];
  reg [WIDTH-1:0]    vdin_reg [0:2-1][0:DRAM_DELAY];
 
  integer vprt_int, vdel_int; 
  always @(posedge clk) 
    for (vprt_int=0; vprt_int<2; vprt_int=vprt_int+1)
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

  wire               vread1_out = vread_reg[0][DRAM_DELAY-1];
  wire [BITVBNK-1:0] vrdbadr1_out = vbadr_reg[0][DRAM_DELAY-1];
  wire [BITVROW-1:0] vrdradr1_out = vradr_reg[0][DRAM_DELAY-1];

  wire               vwrite1_out = vwrite_reg[0][SRAM_DELAY-1] && (!vwrite_reg[1][SRAM_DELAY-1] ||
                                                                   (vbadr_reg[0][SRAM_DELAY-1] != vbadr_reg[1][SRAM_DELAY-1]) ||
                                                                   (vradr_reg[0][SRAM_DELAY-1] != vradr_reg[1][SRAM_DELAY-1]));
  wire [BITVBNK-1:0] vwrbadr1_out = vbadr_reg[0][SRAM_DELAY-1];
  wire [BITVROW-1:0] vwrradr1_out = vradr_reg[0][SRAM_DELAY-1];
  wire [WIDTH-1:0]   vdin1_out = vdin_reg[0][SRAM_DELAY-1];

  wire               vwrite2_out = vwrite_reg[1][SRAM_DELAY-1];
  wire [BITVBNK-1:0] vwrbadr2_out = vbadr_reg[1][SRAM_DELAY-1];
  wire [BITVROW-1:0] vwrradr2_out = vradr_reg[1][SRAM_DELAY-1];
  wire [WIDTH-1:0]   vdin2_out = vdin_reg[1][SRAM_DELAY-1];

  assign prefr = vrefr_wire || !ready_wire;

  // Read request of pivoted data on DRAM memory
  assign pread1 = vread_wire[0];
  assign prdbadr1 = vbadr_wire[0];
  assign prdradr1 = vradr_wire[0];

  // Read request of mapping information on SRAM memory
  assign sread1 = (vread_wire[0] || vwrite_wire[0]) && (!swrite || (swrradr != srdradr1));
  assign srdradr1 = vradr_wire[0];
  assign sread2 = vwrite_wire[1] && (!swrite || (swrradr != srdradr2));
  assign srdradr2 = vradr_wire[1];

  assign cread1 = (vread_wire[0] || vwrite_wire[0]) && (!cwrite || (cwrradr != crdradr1));
  assign crdradr1 = vradr_wire[0];
  assign cread2 = vwrite_wire[1] && (!cwrite || (cwrradr != crdradr2));
  assign crdradr2 = vradr_wire[1];

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

  ecc_check   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
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

  ecc_check   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
            ecc_check_2 (.din(sdout2_data),
                         .eccin(sdout2_ecc),
                         .dout(sdout2_post_ecc),
                         .sec_err(sdout2_sec_err),
                         .ded_err(sdout2_ded_err),
                         .clk(clk),
                         .rst(rst));

  wire [BITVBNK:0]   sdout2_out = sdout2_ded_err ? sdout2_dup_data : sdout2_post_ecc;

  reg              map1_vld [0:DRAM_DELAY-1];
  reg [BITVBNK:0]  map1_reg [0:DRAM_DELAY-1];
  reg              map2_vld [0:DRAM_DELAY-1];
  reg [BITVBNK:0]  map2_reg [0:DRAM_DELAY-1];
  integer sfwd_int;
  always @(posedge clk) begin
    for (sfwd_int=0; sfwd_int<DRAM_DELAY; sfwd_int=sfwd_int+1)
      if (sfwd_int>SRAM_DELAY) begin
        map1_vld[sfwd_int] <= map1_vld[sfwd_int-1];
        map1_reg[sfwd_int] <= map1_reg[sfwd_int-1];
        map2_vld[sfwd_int] <= map2_vld[sfwd_int-1];
        map2_reg[sfwd_int] <= map2_reg[sfwd_int-1];
      end else if (sfwd_int==SRAM_DELAY) begin
        if (map1_vld[sfwd_int-1]) begin
          map1_vld[sfwd_int] <= map1_vld[sfwd_int-1];
          map1_reg[sfwd_int] <= map1_reg[sfwd_int-1];
        end else begin
          map1_vld[sfwd_int] <= 1'b1;
          map1_reg[sfwd_int] <= sdout1_out;
        end
        if (map2_vld[sfwd_int-1]) begin
          map2_vld[sfwd_int] <= map2_vld[sfwd_int-1];
          map2_reg[sfwd_int] <= map2_reg[sfwd_int-1];
        end else begin
          map2_vld[sfwd_int] <= 1'b1;
          map2_reg[sfwd_int] <= sdout2_out;
        end
      end else if (sfwd_int > 0) begin
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

  reg              cdat1_vld [0:DRAM_DELAY-1];
  reg [WIDTH-1:0]  cdat1_reg [0:DRAM_DELAY-1];
  reg              cdat2_vld [0:DRAM_DELAY-1];
  reg [WIDTH-1:0]  cdat2_reg [0:DRAM_DELAY-1];
  integer cfwd_int;
  always @(posedge clk) begin
    for (cfwd_int=0; cfwd_int<DRAM_DELAY; cfwd_int=cfwd_int+1)
      if (cfwd_int>SRAM_DELAY) begin
        cdat1_vld[cfwd_int] <= cdat1_vld[cfwd_int-1];
        cdat1_reg[cfwd_int] <= cdat1_reg[cfwd_int-1];
        cdat2_vld[cfwd_int] <= cdat2_vld[cfwd_int-1];
        cdat2_reg[cfwd_int] <= cdat2_reg[cfwd_int-1];
      end else if (cfwd_int==SRAM_DELAY) begin
        if (cdat1_vld[cfwd_int-1]) begin
          cdat1_vld[cfwd_int] <= cdat1_vld[cfwd_int-1];
          cdat1_reg[cfwd_int] <= cdat1_reg[cfwd_int-1];
        end else begin
          cdat1_vld[cfwd_int] <= 1'b1;
          cdat1_reg[cfwd_int] <= cdout1;
        end
        if (cdat2_vld[cfwd_int-1]) begin
          cdat2_vld[cfwd_int] <= cdat2_vld[cfwd_int-1];
          cdat2_reg[cfwd_int] <= cdat2_reg[cfwd_int-1];
        end else begin
          cdat2_vld[cfwd_int] <= 1'b1;
          cdat2_reg[cfwd_int] <= cdout2;
        end
      end else if (cfwd_int > 0) begin
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

  reg              pdat1_vld [0:DRAM_DELAY-1];
  reg [WIDTH-1:0]  pdat1_reg [0:DRAM_DELAY-1];
  integer pfwd_int;
  always @(posedge clk) begin
    for (pfwd_int=0; pfwd_int<DRAM_DELAY; pfwd_int=pfwd_int+1)
      if (pfwd_int >= SRAM_DELAY) begin
        pdat1_vld[pfwd_int] <= pdat1_vld[pfwd_int-1];
        pdat1_reg[pfwd_int] <= pdat1_reg[pfwd_int-1];
      end else if (pfwd_int > 0) begin
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

  reg wr_srch_flag1;
  parameter SRCWDTH = 1 << BITWDTH;
  reg [SRCWDTH-1:0] wr_srch_data1;
//  reg [WIDTH-1:0] wr_srch_data1;
  reg wr_srch_flags;
  reg [SRCWDTH-1:0] wr_srch_datas;
//  reg [WIDTH-1:0] wr_srch_datas;

  reg             rddat1_vld [0:DRAM_DELAY-1];
  reg [WIDTH-1:0] rddat1_reg [0:DRAM_DELAY-1];
  integer rfwd_int;
  always @(posedge clk) begin
    for (rfwd_int=0; rfwd_int<DRAM_DELAY; rfwd_int=rfwd_int+1)
      if (rfwd_int>SRAM_DELAY) begin
        rddat1_vld[rfwd_int] <= rddat1_vld[rfwd_int-1];
        rddat1_reg[rfwd_int] <= rddat1_reg[rfwd_int-1];
      end else if (rfwd_int==SRAM_DELAY) begin
        if (rddat1_vld[rfwd_int-1]) begin
          rddat1_vld[rfwd_int] <= rddat1_vld[rfwd_int-1];
          rddat1_reg[rfwd_int] <= rddat1_reg[rfwd_int-1];
        end else begin
          rddat1_vld[rfwd_int] <= wr_srch_flag1;
          rddat1_reg[rfwd_int] <= wr_srch_data1;
        end
      end else if (rfwd_int > 0) begin
        if (vwrite2_out && vread_reg[0][rfwd_int-1] && (vwrbadr2_out == vbadr_reg[0][rfwd_int-1]) && (vwrradr2_out == vradr_reg[0][rfwd_int-1])) begin
          rddat1_vld[rfwd_int] <= 1'b1;
          rddat1_reg[rfwd_int] <= vdin2_out;
        end else if (vwrite1_out && vread_reg[0][rfwd_int-1] && (vwrbadr1_out == vbadr_reg[0][rfwd_int-1]) && (vwrradr1_out == vradr_reg[0][rfwd_int-1])) begin
          rddat1_vld[rfwd_int] <= 1'b1;
          rddat1_reg[rfwd_int] <= vdin1_out;
        end else begin
          rddat1_vld[rfwd_int] <= rddat1_vld[rfwd_int-1];
          rddat1_reg[rfwd_int] <= rddat1_reg[rfwd_int-1];
        end
      end else begin
        if (vwrite2_out && vread_wire[0] && (vwrbadr2_out == vbadr_wire[0]) && (vwrradr2_out == vradr_wire[0])) begin
          rddat1_vld[rfwd_int] <= 1'b1;
          rddat1_reg[rfwd_int] <= vdin2_out;
        end else if (vwrite1_out && vread_wire[0] && (vwrbadr1_out == vbadr_wire[0]) && (vwrradr1_out == vradr_wire[0])) begin
          rddat1_vld[rfwd_int] <= 1'b1;
          rddat1_reg[rfwd_int] <= vdin1_out;
        end else begin
          rddat1_vld[rfwd_int] <= 1'b0;
          rddat1_reg[rfwd_int] <= 0;
        end
      end
  end

  wire [BITVBNK:0]   rmap1_out = map1_vld[DRAM_DELAY-1] ? map1_reg[DRAM_DELAY-1] : sdout1_out;
  wire [WIDTH-1:0]   rcdat1_out = cdat1_vld[DRAM_DELAY-1] ? cdat1_reg[DRAM_DELAY-1] : cdout1;
  wire [WIDTH-1:0]   rpdat1_out = pdat1_vld[DRAM_DELAY-1] ? pdat1_reg[DRAM_DELAY-1] : pdout1;

  wire               vread_vld_tmp = vread1_out;
  wire               vread_serr_tmp = 1'b0;
  wire               vread_derr_tmp = 1'b0;
//  wire [WIDTH-1:0]   vdout_int = (((SRAM_DELAY == DRAM_DELAY) && wr_srch_flag1) ? wr_srch_data1 :
//			          (rmap1_out[BITVBNK] && (rmap1_out[BITVBNK-1:0] == vrdbadr1_out)) ? rcdat1_out : rpdat1_out);
  wire [WIDTH-1:0]   vdout_int = ((rmap1_out[BITVBNK] && (rmap1_out[BITVBNK-1:0] == vrdbadr1_out)) ? rcdat1_out : rpdat1_out);
  wire [WIDTH-1:0]   vdout_tmp = (rddat1_vld[DRAM_DELAY-1] ? rddat1_reg[DRAM_DELAY-1] :
                                  ((SRAM_DELAY == DRAM_DELAY) && wr_srch_flag1) ? wr_srch_data1 : vdout_int);
  wire               vread_fwrd_tmp = (((SRAM_DELAY == DRAM_DELAY) && wr_srch_flag1) || rddat1_vld[DRAM_DELAY-1] ||
                                       ((rmap1_out[BITVBNK] && (rmap1_out[BITVBNK-1:0] == vrdbadr1_out)) ? cdat1_vld[DRAM_DELAY-1] :
                                                                                                           pdat1_vld[DRAM_DELAY-1]));
  wire [BITPADR-1:0] vread_padr_tmp = (rmap1_out[BITVBNK] && (rmap1_out[BITVBNK-1:0] == vrdbadr1_out)) ? ((NUMVBNK << (BITPADR-BITPBNK)) | vrdradr1_out) :
                                                                                                         {vrdbadr1_out,ppadr1};
  
  reg [1-1:0]         vread_vld;
  reg [1*WIDTH-1:0]   vdout;
  reg [1-1:0]         vread_fwrd;
  reg [1-1:0]         vread_serr;
  reg [1-1:0]         vread_derr;
  reg [1*BITPADR-1:0] vread_padr;

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

  wire [BITVBNK:0]   wmap1_out = map1_vld[SRAM_DELAY-1] ? map1_reg[SRAM_DELAY-1] : sdout1_out;
  wire [WIDTH-1:0]   wcdat1_out = cdat1_vld[SRAM_DELAY-1] ? cdat1_reg[SRAM_DELAY-1] : cdout1;

  wire [BITVBNK:0]   wmap2_out = map2_vld[SRAM_DELAY-1] ? map2_reg[SRAM_DELAY-1] : sdout2_out;
  wire [WIDTH-1:0]   wcdat2_out = cdat2_vld[SRAM_DELAY-1] ? cdat2_reg[SRAM_DELAY-1] : cdout2;

  reg [3:0]          wrfifo_cnt;
  reg                wrfifo_old_vld [0:FIFOCNT-1];
  reg [BITVBNK-1:0]  wrfifo_old_map [0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_old_dat [0:FIFOCNT-1];
  reg                wrfifo_new_vld [0:FIFOCNT-1];
  reg [BITVBNK-1:0]  wrfifo_new_map [0:FIFOCNT-1];
  reg [BITVROW-1:0]  wrfifo_new_row [0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_new_dat [0:FIFOCNT-1];

  wire wrfifo_deq1 = !(REFRESH && vrefr_wire) && |wrfifo_cnt;
  wire wrfifo_deq2 = !(REFRESH && vrefr_wire) && !vread_wire[0] && (wrfifo_cnt > 1);
  always @(posedge clk)
    if (rst)
      wrfifo_cnt <= 0;
    else
      wrfifo_cnt <= wrfifo_cnt + vwrite1_out + vwrite2_out - wrfifo_deq1 - wrfifo_deq2;

  wire wrfifo_cnt_gt = (wrfifo_cnt > 3);

  integer wfifo_int;
  always @(posedge clk)
    for (wfifo_int=FIFOCNT-1; wfifo_int>=0; wfifo_int=wfifo_int-1)
      if (vwrite1_out && (wrfifo_cnt == (wrfifo_deq1+wrfifo_deq2+wfifo_int))) begin
        if (swrite && (swrradr == vwrradr1_out)) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= wmap1_out[BITVBNK];
          wrfifo_old_map[wfifo_int] <= wmap1_out;
        end
        if (cwrite && (cwrradr == vwrradr1_out))
          wrfifo_old_dat[wfifo_int] <= cdin;
        else
          wrfifo_old_dat[wfifo_int] <= wcdat1_out;
        wrfifo_new_vld[wfifo_int] <= 1'b1;
        wrfifo_new_map[wfifo_int] <= vwrbadr1_out;
        wrfifo_new_row[wfifo_int] <= vwrradr1_out;
        wrfifo_new_dat[wfifo_int] <= vdin1_out;
      end else if (vwrite2_out && (wrfifo_cnt == (wrfifo_deq1+wrfifo_deq2-vwrite1_out+wfifo_int))) begin
        if (swrite && (swrradr == vwrradr2_out)) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= wmap2_out[BITVBNK];
          wrfifo_old_map[wfifo_int] <= wmap2_out;
        end
        if (cwrite && (cwrradr == vwrradr2_out))
          wrfifo_old_dat[wfifo_int] <= cdin;
        else
          wrfifo_old_dat[wfifo_int] <= wcdat2_out;
        wrfifo_new_vld[wfifo_int] <= 1'b1;
        wrfifo_new_map[wfifo_int] <= vwrbadr2_out;
        wrfifo_new_row[wfifo_int] <= vwrradr2_out;
        wrfifo_new_dat[wfifo_int] <= vdin2_out;
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
      end else begin
        wrfifo_old_vld[wfifo_int] <= wrfifo_old_vld[wfifo_int];
        wrfifo_old_map[wfifo_int] <= wrfifo_old_map[wfifo_int];
        wrfifo_old_dat[wfifo_int] <= wrfifo_old_dat[wfifo_int];
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int];
        wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int];
      end

  integer wsrc_int;
  always_comb begin
    wr_srch_flag1 = 1'b0;
    wr_srch_data1 = 0;
    for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) &&
          wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == vbadr_reg[0][SRAM_DELAY-1]) && (wrfifo_new_row[wsrc_int] == vradr_reg[0][SRAM_DELAY-1])) begin
        wr_srch_flag1 = 1'b1;
        wr_srch_data1 = wrfifo_new_dat[wsrc_int];
      end
    wr_srch_flags = 1'b0;
    wr_srch_datas = 0;
    for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == select_bank) && (wrfifo_new_row[wsrc_int] == select_row)) begin
        wr_srch_flags = 1'b1;
        wr_srch_datas = wrfifo_new_dat[wsrc_int];
      end
  end

  wire               sold_vld1 = wrfifo_deq2 && wrfifo_old_vld[0];
  wire [BITVBNK-1:0] sold_map1 = wrfifo_old_map[0];
  wire [BITVROW-1:0] sold_row1 = wrfifo_new_row[0];
  wire [WIDTH-1:0]   sold_dat1 = wrfifo_old_dat[0];
  wire               snew_vld1 = wrfifo_deq2 && wrfifo_new_vld[0];
  wire [BITVBNK-1:0] snew_map1 = wrfifo_new_map[0];
  wire [BITVROW-1:0] snew_row1 = wrfifo_new_row[0];
  wire [WIDTH-1:0]   snew_dat1 = wrfifo_new_dat[0];

  wire               sold_vld2 = wrfifo_deq2 ? wrfifo_old_vld[1] : (wrfifo_deq1 && wrfifo_old_vld[0]);
  wire [BITVBNK-1:0] sold_map2 = wrfifo_deq2 ? wrfifo_old_map[1] : wrfifo_old_map[0];
  wire [BITVROW-1:0] sold_row2 = wrfifo_deq2 ? wrfifo_new_row[1] : wrfifo_new_row[0];
  wire [WIDTH-1:0]   sold_dat2 = wrfifo_deq2 ? wrfifo_old_dat[1] : wrfifo_old_dat[0];
  wire               snew_vld2 = wrfifo_deq2 ? wrfifo_new_vld[1] : (wrfifo_deq1 && wrfifo_new_vld[0]);
  wire [BITVBNK-1:0] snew_map2 = wrfifo_deq2 ? wrfifo_new_map[1] : wrfifo_new_map[0];
  wire [BITVROW-1:0] snew_row2 = wrfifo_deq2 ? wrfifo_new_row[1] : wrfifo_new_row[0];
  wire [WIDTH-1:0]   snew_dat2 = wrfifo_deq2 ? wrfifo_new_dat[1] : wrfifo_new_dat[0];

  // Write request to pivoted banks
  wire new_to_cache_1 = snew_vld1 && sold_vld1 && (snew_map1 == sold_map1);
  wire new_to_pivot_1 = snew_vld1 && (!sold_vld1 || (snew_map1 != sold_map1));

  wire new_to_cache_2 = snew_vld2 && ((new_to_pivot_1 && (snew_map1 == snew_map2)) || (vread_wire[0] && (vbadr_wire[0] == snew_map2)));
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
  reg [BITVBNK:0]        sdin_pre_ecc;
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

// ECC Generation Module
  wire [ECCBITS-1:0] sdin_ecc;
  ecc_calc   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
      ecc_calc_inst (.din(sdin_pre_ecc), .eccout(sdin_ecc));

  assign sdin = {sdin_pre_ecc, sdin_ecc, sdin_pre_ecc};

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
