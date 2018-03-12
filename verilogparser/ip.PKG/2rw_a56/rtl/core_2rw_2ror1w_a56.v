
module core_2rw_2ror1w_a56 (vrefr, vread, vwrite, vaddr, vdin, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                            prefr,
                            pwrite1, pwrbadr1, pwrradr1, pdin1,
                            pwrite2, pwrbadr2, pwrradr2, pdin2,
                            pread1, prdbadr1, prdradr1, pdout1, pdout1_fwrd, pdout1_serr, pdout1_derr, pdout1_padr,
                            pread2, prdbadr2, prdradr2, pdout2, pdout2_fwrd, pdout2_serr, pdout2_derr, pdout2_padr,
      	                    swrite, swrradr, sdin,
            	            sread1, srdradr1, sdout1,
     	                    sread2, srdradr2, sdout2,
                            cwrite, cwrradr, cdin,
    	                    cread1, crdradr1, cdout1, cdout1_fwrd, cdout1_serr, cdout1_derr, cdout1_padr,
     	                    cread2, crdradr2, cdout2, cdout2_fwrd, cdout2_serr, cdout2_derr, cdout2_padr,
                            ready, clk, rst,
	                        select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPSDO = 0;
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

  parameter SDOUT_WIDTH = BITVBNK+1;
  parameter FIFOCNT = 2*SRAM_DELAY+2;

  input                              vrefr;

  input [2-1:0]                      vread;
  input [2-1:0]                      vwrite;
  input [2*BITADDR-1:0]              vaddr;
  input [2*WIDTH-1:0]                vdin;
  output [2-1:0]                     vread_vld;
  output [2*WIDTH-1:0]               vdout;
  output [2-1:0]                     vread_fwrd;
  output [2-1:0]                     vread_serr;
  output [2-1:0]                     vread_derr;
  output [2*BITPADR-1:0]             vread_padr;

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
  input                              pdout1_fwrd;
  input                              pdout1_serr;
  input                              pdout1_derr;
  input [BITPADR-BITPBNK-1:0]        pdout1_padr;

  output                             pread2;
  output [BITVBNK-1:0]               prdbadr2;
  output [BITVROW-1:0]               prdradr2;
  input [WIDTH-1:0]                  pdout2;
  input                              pdout2_fwrd;
  input                              pdout2_serr;
  input                              pdout2_derr;
  input [BITPADR-BITPBNK-1:0]        pdout2_padr;

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
  input                              cdout1_fwrd;
  input                              cdout1_serr;
  input                              cdout1_derr;
  input [BITPADR-BITPBNK-1:0]        cdout1_padr;
  
  output                             cread2;
  output [BITVROW-1:0]               crdradr2;
  input [WIDTH-1:0]                  cdout2;  
  input                              cdout2_fwrd;
  input                              cdout2_serr;
  input                              cdout2_derr;
  input [BITPADR-BITPBNK-1:0]        cdout2_padr;

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
  wire               vread_wire [0:2-1];
  wire               vwrite_wire [0:2-1];
  wire [BITADDR-1:0] vaddr_wire [0:2-1];
  wire [BITVBNK-1:0] vbadr_wire [0:2-1];
  wire [BITVROW-1:0] vradr_wire [0:2-1];
  wire [WIDTH-1:0]   vdin_wire [0:2-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg vrefr_reg;
    reg [2-1:0] vread_reg;
    reg [2-1:0] vwrite_reg;
    reg [2*BITADDR-1:0] vaddr_reg;
    reg [2*WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vrefr_reg <= vrefr;
      vread_reg <= vread & {2{ready}};
      vwrite_reg <= vwrite & {2{ready}};
      vaddr_reg <= vaddr;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    assign vrefr_wire = vrefr_reg;
    for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: np2_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
      assign vwrite_wire[np2_var] = vwrite_reg >> np2_var;
      assign vaddr_wire[np2_var] = vaddr_reg >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rw_adr_inst (.vbadr(vbadr_wire[np2_var]), .vradr(vradr_wire[np2_var]), .vaddr(vaddr_wire[np2_var]));
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    assign vrefr_wire = vrefr;
    for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: np2_loop
      assign vread_wire[np2_var] = vread >> np2_var;
      assign vwrite_wire[np2_var] = vwrite >> np2_var;
      assign vaddr_wire[np2_var] = vaddr >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rw_adr_inst (.vbadr(vbadr_wire[np2_var]), .vradr(vradr_wire[np2_var]), .vaddr(vaddr_wire[np2_var]));
    end
  end
  endgenerate

  reg                vread_reg [0:2-1][0:DRAM_DELAY-1];
  reg                vwrite_reg [0:2-1][0:DRAM_DELAY-1];
  reg [BITVBNK-1:0]  vbadr_reg [0:2-1][0:DRAM_DELAY-1];
  reg [BITVROW-1:0]  vradr_reg [0:2-1][0:DRAM_DELAY-1];
  reg [WIDTH-1:0]    vdin_reg [0:2-1][0:DRAM_DELAY-1];
 
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

  wire               vread2_out = vread_reg[1][DRAM_DELAY-1];
  wire [BITVBNK-1:0] vrdbadr2_out = vbadr_reg[1][DRAM_DELAY-1];
  wire [BITVROW-1:0] vrdradr2_out = vradr_reg[1][DRAM_DELAY-1];

  wire               vwrite2_out = vwrite_reg[1][SRAM_DELAY-1];
  wire [BITVBNK-1:0] vwrbadr2_out = vbadr_reg[1][SRAM_DELAY-1];
  wire [BITVROW-1:0] vwrradr2_out = vradr_reg[1][SRAM_DELAY-1];
  wire [WIDTH-1:0]   vdin2_out = vdin_reg[1][SRAM_DELAY-1];       

  // Read request of pivoted data on DRAM memory
  assign prefr = vrefr_wire || !ready_wire;

  assign pread1 = vread_wire[0];
  assign prdbadr1 = vbadr_wire[0];
  assign prdradr1 = vradr_wire[0];

  assign pread2 = vread_wire[1];
  assign prdbadr2 = vbadr_wire[1];
  assign prdradr2 = vradr_wire[1];

  // Read request of mapping information on SRAM memory
  assign sread1 = (vread_wire[0] || vwrite_wire[0]) && (!ENAPSDO || !swrite || (swrradr != srdradr1));
  assign srdradr1 = vradr_wire[0];
  assign sread2 = (vread_wire[1] || vwrite_wire[1]) && (!ENAPSDO || !swrite || (swrradr != srdradr2));
  assign srdradr2 = vradr_wire[1];

  assign cread1 = (vread_wire[0] || vwrite_wire[0]) && (!ENAPSDO || !cwrite || (cwrradr != crdradr1));
  assign crdradr1 = vradr_wire[0];
  assign cread2 = (vread_wire[1] || vwrite_wire[1]) && (!ENAPSDO || !cwrite || (cwrradr != crdradr2));
  assign crdradr2 = vradr_wire[1];

  reg              map1_vld [0:DRAM_DELAY-1];
  reg [BITVBNK:0]  map1_reg [0:DRAM_DELAY-1];
  reg              map2_vld [0:DRAM_DELAY-1];
  reg [BITVBNK:0]  map2_reg [0:DRAM_DELAY-1];
  integer sfwd_int;
  always @(posedge clk) begin
    for (sfwd_int=0; sfwd_int<DRAM_DELAY; sfwd_int=sfwd_int+1)
      if (sfwd_int==SRAM_DELAY) begin
        if (swrite && (swrradr == vradr_reg[0][sfwd_int-1])) begin
          map1_vld[sfwd_int] <= 1'b1;
          map1_reg[sfwd_int] <= sdin;
        end else if (map1_vld[sfwd_int-1]) begin
          map1_vld[sfwd_int] <= map1_vld[sfwd_int-1];
          map1_reg[sfwd_int] <= map1_reg[sfwd_int-1];
        end else begin
          map1_vld[sfwd_int] <= 1'b1;
          map1_reg[sfwd_int] <= sdout1;
        end
        if (swrite && (swrradr == vradr_reg[1][sfwd_int-1])) begin
          map2_vld[sfwd_int] <= 1'b1;
          map2_reg[sfwd_int] <= sdin;
        end else if (map2_vld[sfwd_int-1]) begin
          map2_vld[sfwd_int] <= map2_vld[sfwd_int-1];
          map2_reg[sfwd_int] <= map2_reg[sfwd_int-1];
        end else begin
          map2_vld[sfwd_int] <= 1'b1;
          map2_reg[sfwd_int] <= sdout2;
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
      if (cfwd_int==SRAM_DELAY) begin
        if (cwrite && (cwrradr == vradr_reg[0][cfwd_int-1])) begin
          cdat1_vld[cfwd_int] <= 1'b1;
          cdat1_reg[cfwd_int] <= cdin;
        end else if (cdat1_vld[cfwd_int-1]) begin
          cdat1_vld[cfwd_int] <= cdat1_vld[cfwd_int-1];
          cdat1_reg[cfwd_int] <= cdat1_reg[cfwd_int-1];
        end else begin
          cdat1_vld[cfwd_int] <= 1'b1;
          cdat1_reg[cfwd_int] <= cdout1;
        end
        if (cwrite && (cwrradr == vradr_reg[1][cfwd_int-1])) begin
          cdat2_vld[cfwd_int] <= 1'b1;
          cdat2_reg[cfwd_int] <= cdin;
        end else if (cdat2_vld[cfwd_int-1]) begin
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
  reg              pdat2_vld [0:DRAM_DELAY-1];
  reg [WIDTH-1:0]  pdat2_reg [0:DRAM_DELAY-1];
  integer pfwd_int;
  always @(posedge clk) begin
    for (pfwd_int=0; pfwd_int<DRAM_DELAY; pfwd_int=pfwd_int+1)
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
        if (pwrite2 && (pwrbadr2 == vbadr_reg[1][pfwd_int-1]) && (pwrradr2 == vradr_reg[1][pfwd_int-1])) begin
          pdat2_vld[pfwd_int] <= 1'b1;
          pdat2_reg[pfwd_int] <= pdin2;
        end else if (pwrite1 && (pwrbadr1 == vbadr_reg[1][pfwd_int-1]) && (pwrradr1 == vradr_reg[1][pfwd_int-1])) begin
          pdat2_vld[pfwd_int] <= 1'b1;
          pdat2_reg[pfwd_int] <= pdin1;
        end else begin
          pdat2_vld[pfwd_int] <= pdat2_vld[pfwd_int-1];
          pdat2_reg[pfwd_int] <= pdat2_reg[pfwd_int-1];            
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
        if (pwrite2 && (pwrbadr2 == vbadr_wire[1]) && (pwrradr2 == vradr_wire[1])) begin
          pdat2_vld[pfwd_int] <= 1'b1;
          pdat2_reg[pfwd_int] <= pdin2;
        end else if (pwrite1 && (pwrbadr1 == vbadr_wire[1]) && (pwrradr1 == vradr_wire[1])) begin
          pdat2_vld[pfwd_int] <= 1'b1;
          pdat2_reg[pfwd_int] <= pdin1;
        end else begin
          pdat2_vld[pfwd_int] <= 1'b0;
          pdat2_reg[pfwd_int] <= 0;
        end
      end
  end

  reg wr_srch_flag1;
  parameter SRCWDTH = 1 << BITWDTH;
  reg [SRCWDTH-1:0] wr_srch_data1;
//  reg [WIDTH-1:0] wr_srch_data1;
  reg wr_srch_flag2;
  reg [SRCWDTH-1:0] wr_srch_data2;
//  reg [WIDTH-1:0] wr_srch_data2;
  reg wr_srch_flags;
//  reg [SRCWDTH-1:0] wr_srch_datas;
  reg [SRCWDTH-1:0] wr_srch_datas;
//  reg wr_srch_dbits;

  reg             rddat1_vld [0:DRAM_DELAY-1];
  reg [WIDTH-1:0] rddat1_reg [0:DRAM_DELAY-1];
  reg             rddat2_vld [0:DRAM_DELAY-1];
  reg [WIDTH-1:0] rddat2_reg [0:DRAM_DELAY-1];
  integer rfwd_int;
  always @(posedge clk) begin
    for (rfwd_int=0; rfwd_int<DRAM_DELAY; rfwd_int=rfwd_int+1)
      if (rfwd_int>SRAM_DELAY) begin
        rddat1_vld[rfwd_int] <= rddat1_vld[rfwd_int-1];
        rddat1_reg[rfwd_int] <= rddat1_reg[rfwd_int-1];
        rddat2_vld[rfwd_int] <= rddat2_vld[rfwd_int-1];
        rddat2_reg[rfwd_int] <= rddat2_reg[rfwd_int-1];
      end else if (rfwd_int==SRAM_DELAY) begin
        if (rddat1_vld[rfwd_int-1]) begin
          rddat1_vld[rfwd_int] <= rddat1_vld[rfwd_int-1];
          rddat1_reg[rfwd_int] <= rddat1_reg[rfwd_int-1];
        end else begin
          rddat1_vld[rfwd_int] <= wr_srch_flag1;
          rddat1_reg[rfwd_int] <= wr_srch_data1;
        end
        if (rddat2_vld[rfwd_int-1]) begin
          rddat2_vld[rfwd_int] <= rddat2_vld[rfwd_int-1];
          rddat2_reg[rfwd_int] <= rddat2_reg[rfwd_int-1];
        end else begin
          rddat2_vld[rfwd_int] <= wr_srch_flag2;
          rddat2_reg[rfwd_int] <= wr_srch_data2;
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
        if (vwrite2_out && vread_reg[1][rfwd_int-1] && (vwrbadr2_out == vbadr_reg[1][rfwd_int-1]) && (vwrradr2_out == vradr_reg[1][rfwd_int-1])) begin
          rddat2_vld[rfwd_int] <= 1'b1;
          rddat2_reg[rfwd_int] <= vdin2_out;
        end else if (vwrite1_out && vread_reg[1][rfwd_int-1] && (vwrbadr1_out == vbadr_reg[1][rfwd_int-1]) && (vwrradr1_out == vradr_reg[1][rfwd_int-1])) begin
          rddat2_vld[rfwd_int] <= 1'b1;
          rddat2_reg[rfwd_int] <= vdin1_out;
        end else begin
          rddat2_vld[rfwd_int] <= rddat2_vld[rfwd_int-1];
          rddat2_reg[rfwd_int] <= rddat2_reg[rfwd_int-1];
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
        if (vwrite2_out && vread_wire[1] && (vwrbadr2_out == vbadr_wire[1]) && (vwrradr2_out == vradr_wire[1])) begin
          rddat2_vld[rfwd_int] <= 1'b1;
          rddat2_reg[rfwd_int] <= vdin2_out;
        end else if (vwrite1_out && vread_wire[1] && (vwrbadr1_out == vbadr_wire[1]) && (vwrradr1_out == vradr_wire[1])) begin
          rddat2_vld[rfwd_int] <= 1'b1;
          rddat2_reg[rfwd_int] <= vdin1_out;
        end else begin
          rddat2_vld[rfwd_int] <= 1'b0;
          rddat2_reg[rfwd_int] <= 0;
        end
      end
  end

//  wire                   map1_vld0 = map1_vld[0];
//  wire [(BITVBNK+1)-1:0] map1_reg0 = map1_reg[0];
//  wire                   map1_vld1 = map1_vld[1];
//  wire [(BITVBNK+1)-1:0] map1_reg1 = map1_reg[1];
//  wire                   map2_vld0 = map2_vld[0];
//  wire [(BITVBNK+1)-1:0] map2_reg0 = map2_reg[0];
//  wire                   map2_vld1 = map2_vld[1];
//  wire [(BITVBNK+1)-1:0] map2_reg1 = map2_reg[1];

  wire [BITVBNK:0]   rmap1_out = map1_vld[DRAM_DELAY-1] ? map1_reg[DRAM_DELAY-1] : sdout1;
  wire [WIDTH-1:0]   rcdat1_out = cdat1_vld[DRAM_DELAY-1] ? cdat1_reg[DRAM_DELAY-1] : cdout1;
  wire [WIDTH-1:0]   rpdat1_out = pdat1_vld[DRAM_DELAY-1] ? pdat1_reg[DRAM_DELAY-1] : pdout1;

  wire [BITVBNK:0]   rmap2_out = map2_vld[DRAM_DELAY-1] ? map2_reg[DRAM_DELAY-1] : sdout2;
  wire [WIDTH-1:0]   rcdat2_out = cdat2_vld[DRAM_DELAY-1] ? cdat2_reg[DRAM_DELAY-1] : cdout2;
  wire [WIDTH-1:0]   rpdat2_out = pdat2_vld[DRAM_DELAY-1] ? pdat2_reg[DRAM_DELAY-1] : pdout2;

  wire               vread_vld1 = vread1_out;
  wire [WIDTH-1:0]   vdout1_int = (rmap1_out[BITVBNK] && (rmap1_out[BITVBNK-1:0] == vrdbadr1_out)) ? rcdat1_out : rpdat1_out;
  wire [WIDTH-1:0]   vdout1 = (rddat1_vld[DRAM_DELAY-1] ? rddat1_reg[DRAM_DELAY-1] :
                               ((SRAM_DELAY==DRAM_DELAY) && wr_srch_flag1) ? wr_srch_data1 : vdout1_int);
//  wire [WIDTH-1:0] vdout1 = (rddat1_vld[DRAM_DELAY-1] ? rddat1_reg[DRAM_DELAY-1] :
//			     wr_srch_flag1 ? wr_srch_data1 :
//			     (rmap1_out[BITVBNK] && (rmap1_out[BITVBNK-1:0] == vrdbadr1_out)) ? rcdat1_out : rpdat1_out);
  wire               vread_fwrd1_int = (rmap1_out[BITVBNK] && (rmap1_out[BITVBNK-1:0] == vrdbadr1_out)) ? cdout1_fwrd : pdout1_fwrd;
  wire               vread_fwrd1 = rddat1_vld[DRAM_DELAY-1] || ((SRAM_DELAY==DRAM_DELAY) && wr_srch_flag1) || vread_fwrd1_int;
  wire               vread_serr1 = (rmap1_out[BITVBNK] && (rmap1_out[BITVBNK-1:0] == vrdbadr1_out)) ? cdout1_serr : pdout1_serr;
  wire               vread_derr1 = (rmap1_out[BITVBNK] && (rmap1_out[BITVBNK-1:0] == vrdbadr1_out)) ? cdout1_derr : pdout1_derr;
  wire [BITPADR-1:0] vread_padr1 = (rmap1_out[BITVBNK] && (rmap1_out[BITVBNK-1:0] == vrdbadr1_out)) ? (NUMVBNK << (BITPADR-BITPBNK)) | cdout1_padr :
                                                                                                      {vrdbadr1_out,pdout1_padr};

  wire               vread_vld2 = vread2_out;
  wire [WIDTH-1:0]   vdout2_int = (rmap2_out[BITVBNK] && (rmap2_out[BITVBNK-1:0] == vrdbadr2_out)) ? rcdat2_out : rpdat2_out;
  wire [WIDTH-1:0]   vdout2 = (rddat2_vld[DRAM_DELAY-1] ? rddat2_reg[DRAM_DELAY-1] :
                               ((SRAM_DELAY==DRAM_DELAY) && wr_srch_flag2) ? wr_srch_data2 : vdout2_int);
//  wire [WIDTH-1:0] vdout2 = (rddat2_vld[DRAM_DELAY-1] ? rddat2_reg[DRAM_DELAY-1] :
//			       wr_srch_flag2 ? wr_srch_data2 :
//			       (rmap2_out[BITVBNK] && (rmap2_out[BITVBNK-1:0] == vrdbadr2_out)) ? rcdat2_out : rpdat2_out);
  wire               vread_fwrd2_int = (rmap2_out[BITVBNK] && (rmap2_out[BITVBNK-1:0] == vrdbadr2_out)) ? cdout2_fwrd : pdout2_fwrd;
  wire               vread_fwrd2 = rddat2_vld[DRAM_DELAY-1] || ((SRAM_DELAY==DRAM_DELAY) && wr_srch_flag2) || vread_fwrd2_int;
  wire               vread_serr2 = (rmap2_out[BITVBNK] && (rmap2_out[BITVBNK-1:0] == vrdbadr2_out)) ? cdout2_serr : pdout2_serr;
  wire               vread_derr2 = (rmap2_out[BITVBNK] && (rmap2_out[BITVBNK-1:0] == vrdbadr2_out)) ? cdout2_derr : pdout2_derr;
  wire [BITPADR-1:0] vread_padr2 = (rmap2_out[BITVBNK] && (rmap2_out[BITVBNK-1:0] == vrdbadr2_out)) ? (NUMVBNK << (BITPADR-BITPBNK)) | cdout2_padr :
                                                                                                      {vrdbadr2_out,pdout2_padr};

  wire [2-1:0]         vread_vld_tmp = {vread_vld2,vread_vld1};
  wire [2*WIDTH-1:0]   vdout_tmp = {vdout2,vdout1};
  wire [2-1:0]         vread_fwrd_tmp = {vread_fwrd2,vread_fwrd1};
  wire [2-1:0]         vread_serr_tmp = {vread_serr2,vread_serr1};
  wire [2-1:0]         vread_derr_tmp = {vread_derr2,vread_derr1};
  wire [2*BITPADR-1:0] vread_padr_tmp = {vread_padr2,vread_padr1};

  reg [2-1:0]         vread_vld;
  reg [2*WIDTH-1:0]   vdout;
  reg [2-1:0]         vread_fwrd;
  reg [2-1:0]         vread_serr;
  reg [2-1:0]         vread_derr;
  reg [2*BITPADR-1:0] vread_padr;

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

  wire [BITVBNK:0]   wmap1_out = map1_vld[SRAM_DELAY-1] ? map1_reg[SRAM_DELAY-1] : sdout1;
  wire [WIDTH-1:0]   wcdat1_out = cdat1_vld[SRAM_DELAY-1] ? cdat1_reg[SRAM_DELAY-1] : cdout1;
  wire               wcser1_out = cdat1_vld[SRAM_DELAY-1] ? 1'b0 : cdout1_serr;
  wire               wcder1_out = cdat1_vld[SRAM_DELAY-1] ? 1'b0 : cdout1_derr;

  wire [BITVBNK:0]   wmap2_out = map2_vld[SRAM_DELAY-1] ? map2_reg[SRAM_DELAY-1] : sdout2;
  wire [WIDTH-1:0]   wcdat2_out = cdat2_vld[SRAM_DELAY-1] ? cdat2_reg[SRAM_DELAY-1] : cdout2;
  wire               wcser2_out = cdat2_vld[SRAM_DELAY-1] ? 1'b0 : cdout2_serr;
  wire               wcder2_out = cdat2_vld[SRAM_DELAY-1] ? 1'b0 : cdout2_derr;

//  wire rddat2_vld_0 = rddat2_vld[0];
//  wire [WIDTH-1:0] rddat2_reg_0 = rddat2_reg[0];
//  wire rddat2_vld_1 = rddat2_vld[1];
//  wire [WIDTH-1:0] rddat2_reg_1 = rddat2_reg[1];

  reg [3:0]          wrfifo_cnt;
  reg                wrfifo_old_vld [0:FIFOCNT-1];
  reg [BITVBNK-1:0]  wrfifo_old_map [0:FIFOCNT-1];
  reg [BITVROW-1:0]  wrfifo_old_row [0:FIFOCNT-1];
  reg                wrfifo_old_ser [0:FIFOCNT-1];
  reg                wrfifo_old_der [0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_old_dat [0:FIFOCNT-1];
  reg                wrfifo_new_vld [0:FIFOCNT-1];
  reg [BITVBNK-1:0]  wrfifo_new_map [0:FIFOCNT-1];
  reg [BITVROW-1:0]  wrfifo_new_row [0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_new_dat [0:FIFOCNT-1];

  wire wrfifo_deq1 = !(vrefr_wire && REFRESH) && !(vread_wire[0] && vread_wire[1]) && |wrfifo_cnt;
  wire wrfifo_deq2 = !(vrefr_wire && REFRESH) && !(vread_wire[0] || vread_wire[1]) && (wrfifo_cnt > 1);
  always @(posedge clk)
    if (rst)
      wrfifo_cnt <= 0;
    else
      wrfifo_cnt <= wrfifo_cnt + vwrite1_out + vwrite2_out - wrfifo_deq1 - wrfifo_deq2;

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
        wrfifo_old_row[wfifo_int] <= vwrradr1_out;
        if (cwrite && (cwrradr == vwrradr1_out)) begin
          wrfifo_old_dat[wfifo_int] <= cdin;
          wrfifo_old_ser[wfifo_int] <= 1'b0;
          wrfifo_old_der[wfifo_int] <= 1'b0;
        end else begin
          wrfifo_old_dat[wfifo_int] <= wcdat1_out;
          wrfifo_old_ser[wfifo_int] <= wcser1_out;
          wrfifo_old_der[wfifo_int] <= wcder1_out;
        end
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
        wrfifo_old_row[wfifo_int] <= vwrradr2_out;
        if (cwrite && (cwrradr == vwrradr2_out)) begin
          wrfifo_old_dat[wfifo_int] <= cdin;
          wrfifo_old_ser[wfifo_int] <= 1'b0;
          wrfifo_old_der[wfifo_int] <= 1'b0;
        end else begin
          wrfifo_old_dat[wfifo_int] <= wcdat2_out;
          wrfifo_old_ser[wfifo_int] <= wcser2_out;
          wrfifo_old_der[wfifo_int] <= wcder2_out;
        end
        wrfifo_new_vld[wfifo_int] <= 1'b1;
        wrfifo_new_map[wfifo_int] <= vwrbadr2_out;
        wrfifo_new_row[wfifo_int] <= vwrradr2_out;
        wrfifo_new_dat[wfifo_int] <= vdin2_out;
      end else if (wrfifo_deq2 && (wfifo_int<FIFOCNT-2)) begin
        if (swrite && (swrradr == wrfifo_old_row[wfifo_int+2])) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= wrfifo_old_vld[wfifo_int+2];
          wrfifo_old_map[wfifo_int] <= wrfifo_old_map[wfifo_int+2];
        end
        wrfifo_old_row[wfifo_int] <= wrfifo_old_row[wfifo_int+2];
        if (cwrite && (cwrradr == wrfifo_old_row[wfifo_int+2])) begin
          wrfifo_old_dat[wfifo_int] <= cdin;
          wrfifo_old_ser[wfifo_int] <= 1'b0;
          wrfifo_old_der[wfifo_int] <= 1'b0;
        end else begin
          wrfifo_old_dat[wfifo_int] <= wrfifo_old_dat[wfifo_int+2];
          wrfifo_old_ser[wfifo_int] <= wrfifo_old_ser[wfifo_int+2];
          wrfifo_old_der[wfifo_int] <= wrfifo_old_der[wfifo_int+2];
        end
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int+2];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int+2];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int+2];
        wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int+2];
      end else if (wrfifo_deq1 && (wfifo_int<FIFOCNT-1)) begin
        if (swrite && (swrradr == wrfifo_old_row[wfifo_int+1])) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= wrfifo_old_vld[wfifo_int+1];
          wrfifo_old_map[wfifo_int] <= wrfifo_old_map[wfifo_int+1];
        end
        wrfifo_old_row[wfifo_int] <= wrfifo_old_row[wfifo_int+1];
        if (cwrite && (cwrradr == wrfifo_old_row[wfifo_int+1])) begin
          wrfifo_old_dat[wfifo_int] <= cdin;
          wrfifo_old_ser[wfifo_int] <= 1'b0;
          wrfifo_old_der[wfifo_int] <= 1'b0;
        end else begin
          wrfifo_old_dat[wfifo_int] <= wrfifo_old_dat[wfifo_int+1];
          wrfifo_old_ser[wfifo_int] <= wrfifo_old_ser[wfifo_int+1];
          wrfifo_old_der[wfifo_int] <= wrfifo_old_der[wfifo_int+1];
        end
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int+1];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int+1];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int+1];
        wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int+1];
      end else begin
        wrfifo_old_vld[wfifo_int] <= wrfifo_old_vld[wfifo_int];
        wrfifo_old_map[wfifo_int] <= wrfifo_old_map[wfifo_int];
        wrfifo_old_row[wfifo_int] <= wrfifo_old_row[wfifo_int];
        wrfifo_old_dat[wfifo_int] <= wrfifo_old_dat[wfifo_int];
        wrfifo_old_ser[wfifo_int] <= wrfifo_old_ser[wfifo_int];
        wrfifo_old_der[wfifo_int] <= wrfifo_old_der[wfifo_int];
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int];
        wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int];
      end
/*
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
*/
  integer wsrc_int;
  always_comb begin
    wr_srch_flag1 = 1'b0;
    wr_srch_data1 = 0;
    for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == vbadr_reg[0][SRAM_DELAY-1]) && (wrfifo_new_row[wsrc_int] == vradr_reg[0][SRAM_DELAY-1])) begin
        wr_srch_flag1 = 1'b1;
        wr_srch_data1 = wrfifo_new_dat[wsrc_int];
      end
    wr_srch_flag2 = 1'b0;
    wr_srch_data2 = 0;
    for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == vbadr_reg[1][SRAM_DELAY-1]) && (wrfifo_new_row[wsrc_int] == vradr_reg[1][SRAM_DELAY-1])) begin
        wr_srch_flag2 = 1'b1;
        wr_srch_data2 = wrfifo_new_dat[wsrc_int];
      end
    wr_srch_flags = 1'b0;
    wr_srch_datas = 0;
    for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == select_bank) && (wrfifo_new_row[wsrc_int] == select_row)) begin
        wr_srch_flags = 1'b1;
        wr_srch_datas = wrfifo_new_dat[wsrc_int];
      end
//    wr_srch_dbits = wr_srch_datas[select_bit];
  end

  wire               sold_vld1 = wrfifo_deq2 && wrfifo_old_vld[0];
  wire [BITVBNK-1:0] sold_map1 = wrfifo_old_map[0];
  wire [BITVROW-1:0] sold_row1 = wrfifo_old_row[0];
  wire               sold_ser1 = wrfifo_old_ser[0];
  wire               sold_der1 = wrfifo_old_der[0];
  wire [WIDTH-1:0]   sold_dat1 = wrfifo_old_dat[0];
  wire               snew_vld1 = wrfifo_deq2 && wrfifo_new_vld[0];
  wire [BITVBNK-1:0] snew_map1 = wrfifo_new_map[0];
  wire [BITVROW-1:0] snew_row1 = wrfifo_new_row[0];
  wire [WIDTH-1:0]   snew_dat1 = wrfifo_new_dat[0];

  wire               sold_vld2 = wrfifo_deq2 ? wrfifo_old_vld[1] : (wrfifo_deq1 && wrfifo_old_vld[0]);
  wire [BITVBNK-1:0] sold_map2 = wrfifo_deq2 ? wrfifo_old_map[1] : wrfifo_old_map[0];
  wire [BITVROW-1:0] sold_row2 = wrfifo_deq2 ? wrfifo_old_row[1] : wrfifo_old_row[0];
  wire               sold_ser2 = wrfifo_deq2 ? wrfifo_old_ser[1] : wrfifo_old_ser[0];
  wire               sold_der2 = wrfifo_deq2 ? wrfifo_old_der[1] : wrfifo_old_der[0];
  wire [WIDTH-1:0]   sold_dat2 = wrfifo_deq2 ? wrfifo_old_dat[1] : wrfifo_old_dat[0];
  wire               snew_vld2 = wrfifo_deq2 ? wrfifo_new_vld[1] : (wrfifo_deq1 && wrfifo_new_vld[0]);
  wire [BITVBNK-1:0] snew_map2 = wrfifo_deq2 ? wrfifo_new_map[1] : wrfifo_new_map[0];
  wire [BITVROW-1:0] snew_row2 = wrfifo_deq2 ? wrfifo_new_row[1] : wrfifo_new_row[0];
  wire [WIDTH-1:0]   snew_dat2 = wrfifo_deq2 ? wrfifo_new_dat[1] : wrfifo_new_dat[0];

/*
  wire               sold_vld1 = vwrite1_out && wmap1_out[BITVBNK];
  wire [BITVBNK-1:0] sold_map1 = wmap1_out;
  wire [BITVROW-1:0] sold_row1 = vwrradr1_out;
  wire [WIDTH-1:0]   sold_dat1 = wcdat1_out;
  wire               snew_vld1 = vwrite1_out;
  wire [BITVBNK-1:0] snew_map1 = vwrbadr1_out;
  wire [BITVROW-1:0] snew_row1 = vwrradr1_out;
  wire [WIDTH-1:0]   snew_dat1 = vdin1_out;

  wire               sold_vld2 = vwrite2_out && wmap2_out[BITVBNK];
  wire [BITVBNK-1:0] sold_map2 = wmap2_out;
  wire [BITVROW-1:0] sold_row2 = vwrradr2_out;
  wire [WIDTH-1:0]   sold_dat2 = wcdat2_out;
  wire               snew_vld2 = vwrite2_out;
  wire [BITVBNK-1:0] snew_map2 = vwrbadr2_out;
  wire [BITVROW-1:0] snew_row2 = vwrradr2_out;
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

  reg               swrite;
  reg [BITVROW-1:0] swrradr;
  reg [BITVBNK:0]   sdin;
  always_comb
    if (rstvld) begin
      swrite = 1'b1;
      swrradr = rstaddr;
      sdin = 0;
    end else if (new_to_cache_2) begin
      swrite = 1'b1;
      swrradr = snew_row2;
      sdin = {1'b1,snew_map2};
    end else if (old_to_clear_2) begin
      swrite = 1'b1;
      swrradr = sold_row2;
      sdin = 0;
    end else begin
      swrite = 1'b0;
      swrradr = 0;
      sdin = 0;
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
