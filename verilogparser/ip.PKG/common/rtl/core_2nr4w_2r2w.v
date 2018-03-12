module core_2nr4w_2r2w (vwrite, vwraddr, vdin,
                        vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                        t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_padrB,
                        t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                        t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
                        ready, clk, rst);

  parameter BITWDTH = 5;
  parameter WIDTH = 32;
  parameter NUMDUPL = 1;
  parameter NUMRDPT = 2;
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
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter ECCBITS = 4;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input [2*NUMWRPT-1:0]                vwrite;
  input [2*NUMWRPT*BITADDR-1:0]        vwraddr;
  input [2*NUMWRPT*WIDTH-1:0]          vdin;

  input [NUMDUPL*NUMRDPT-1:0]          vread;
  input [NUMDUPL*NUMRDPT*BITADDR-1:0]  vrdaddr;
  output [NUMDUPL*NUMRDPT-1:0]         vread_vld;
  output [NUMDUPL*NUMRDPT*WIDTH-1:0]   vdout;
  output [NUMDUPL*NUMRDPT-1:0]         vread_fwrd;
  output [NUMDUPL*NUMRDPT-1:0]         vread_serr;
  output [NUMDUPL*NUMRDPT-1:0]         vread_derr;
  output [NUMDUPL*NUMRDPT*BITPADR-1:0] vread_padr;

  output [NUMWRPT*NUMVBNK-1:0] t1_writeA;
  output [NUMWRPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMWRPT*NUMVBNK*WIDTH-1:0] t1_dinA;
  
  output [NUMDUPL*NUMRDPT*NUMVBNK-1:0] t1_readB;
  output [NUMDUPL*NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMDUPL*NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutB;
  input [NUMDUPL*NUMRDPT*NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB;
  
  output [NUMWRPT-1:0] t2_writeA;
  output [NUMWRPT*BITVROW-1:0] t2_addrA;
  output [NUMWRPT*WIDTH-1:0] t2_dinA;
  
  output [NUMDUPL*NUMRDPT+NUMWRPT-1:0] t2_readB;
  output [(NUMDUPL*NUMRDPT+NUMWRPT)*BITVROW-1:0] t2_addrB;
  input [(NUMDUPL*NUMRDPT+NUMWRPT)*WIDTH-1:0] t2_doutB;
  
  output [NUMWRPT-1:0] t3_writeA;
  output [NUMWRPT*BITVROW-1:0] t3_addrA;
  output [NUMWRPT*SDOUT_WIDTH-1:0] t3_dinA;
  
  output [NUMDUPL*NUMRDPT+2*NUMWRPT-1:0] t3_readB;
  output [(NUMDUPL*NUMRDPT+2*NUMWRPT)*BITVROW-1:0] t3_addrB;
  input [(NUMDUPL*NUMRDPT+2*NUMWRPT)*SDOUT_WIDTH-1:0] t3_doutB;

  output                             ready;
  input                              clk;
  input                              rst;

  reg [BITVROW:0] rstaddr;
  wire rstvld = (rstaddr < NUMVROW);
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg ready;
  always @(posedge clk)
    ready <= !rstvld;

  wire ready_wire;

  wire vread_wire [0:NUMDUPL*NUMRDPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMDUPL*NUMRDPT-1];
  wire [BITVBNK-1:0] vrdbadr_wire [0:NUMDUPL*NUMRDPT-1];
  wire [BITVROW-1:0] vrdradr_wire [0:NUMDUPL*NUMRDPT-1];

  wire vread_wire_0 = vread_wire[0];
  wire [BITVBNK-1:0] vrdbadr_wire_0 = vrdbadr_wire[0];
  wire [BITVROW-1:0] vrdradr_wire_0 = vrdradr_wire[0];
  wire vread_wire_1 = vread_wire[1];
  wire [BITVBNK-1:0] vrdbadr_wire_1 = vrdbadr_wire[1];
  wire [BITVROW-1:0] vrdradr_wire_1 = vrdradr_wire[1];
  wire vread_wire_2 = vread_wire[2];
  wire [BITVBNK-1:0] vrdbadr_wire_2 = vrdbadr_wire[2];
  wire [BITVROW-1:0] vrdradr_wire_2 = vrdradr_wire[2];
  wire vread_wire_3 = vread_wire[3];
  wire [BITVBNK-1:0] vrdbadr_wire_3 = vrdbadr_wire[3];
  wire [BITVROW-1:0] vrdradr_wire_3 = vrdradr_wire[3];

  wire vwrite_wire [0:2*NUMWRPT-1];
  wire [BITADDR-1:0] vwraddr_wire [0:2*NUMWRPT-1];
  wire [BITVBNK-1:0] vwrbadr_wire [0:2*NUMWRPT-1];
  wire [BITVROW-1:0] vwrradr_wire [0:2*NUMWRPT-1];
  wire [WIDTH-1:0] vdin_wire [0:2*NUMWRPT-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMDUPL*NUMRDPT-1:0] vread_reg;
    reg [NUMDUPL*NUMRDPT*BITADDR-1:0] vrdaddr_reg;
    reg [2*NUMWRPT-1:0] vwrite_reg;
    reg [2*NUMWRPT*BITADDR-1:0] vwraddr_reg;
    reg [2*NUMWRPT*WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread & {NUMDUPL*NUMRDPT{ready}};
      vrdaddr_reg <= vrdaddr;
      vwrite_reg <= vwrite & {2*NUMWRPT{ready}};
      vwraddr_reg <= vwraddr;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    for (np2_var=0; np2_var<NUMDUPL*NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr_reg >> (np2_var*BITADDR);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end
    for (np2_var=0; np2_var<2*NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite_reg >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr_reg >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*WIDTH);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire[np2_var]), .vradr(vwrradr_wire[np2_var]), .vaddr(vwraddr_wire[np2_var]));
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (np2_var=0; np2_var<NUMDUPL*NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end
    for (np2_var=0; np2_var<2*NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire[np2_var]), .vradr(vwrradr_wire[np2_var]), .vaddr(vwraddr_wire[np2_var]));
    end
  end
  endgenerate
/*
  wire vread_wire_0 = vread_wire[0];
  wire [BITADDR-1:0] vrdaddr_wire_0 = vrdaddr_wire[0];
  wire [BITVBNK-1:0] vrdbadr_wire_0 = vrdbadr_wire[0];
  wire [BITVROW-1:0] vrdradr_wire_0 = vrdradr_wire[0];
*/
  wire vwrite_wire_0 = vwrite_wire[0];
  wire [BITADDR-1:0] vwraddr_wire_0 = vwraddr_wire[0];
  wire [BITVBNK-1:0] vwrbadr_wire_0 = vwrbadr_wire[0];
  wire [BITVROW-1:0] vwrradr_wire_0 = vwrradr_wire[0];
  wire [WIDTH-1:0] vdin_wire_0 = vdin_wire[0];
  wire vwrite_wire_1 = vwrite_wire[1];
  wire [BITADDR-1:0] vwraddr_wire_1 = vwraddr_wire[1];
  wire [BITVBNK-1:0] vwrbadr_wire_1 = vwrbadr_wire[1];
  wire [BITVROW-1:0] vwrradr_wire_1 = vwrradr_wire[1];
  wire [WIDTH-1:0] vdin_wire_1 = vdin_wire[1];
  wire vwrite_wire_2 = vwrite_wire[2];
  wire [BITADDR-1:0] vwraddr_wire_2 = vwraddr_wire[2];
  wire [BITVBNK-1:0] vwrbadr_wire_2 = vwrbadr_wire[2];
  wire [BITVROW-1:0] vwrradr_wire_2 = vwrradr_wire[2];
  wire [WIDTH-1:0] vdin_wire_2 = vdin_wire[2];
  wire vwrite_wire_3 = vwrite_wire[3];
  wire [BITADDR-1:0] vwraddr_wire_3 = vwraddr_wire[3];
  wire [BITVBNK-1:0] vwrbadr_wire_3 = vwrbadr_wire[3];
  wire [BITVROW-1:0] vwrradr_wire_3 = vwrradr_wire[3];
  wire [WIDTH-1:0] vdin_wire_3 = vdin_wire[3];

  reg                vread_reg [0:NUMDUPL*NUMRDPT-1][0:SRAM_DELAY];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:NUMDUPL*NUMRDPT-1][0:SRAM_DELAY];
  reg [BITVROW-1:0]  vrdradr_reg [0:NUMDUPL*NUMRDPT-1][0:SRAM_DELAY];
  reg                vwrite_reg [0:2*NUMWRPT-1][0:SRAM_DELAY];
  reg [BITVBNK-1:0]  vwrbadr_reg [0:2*NUMWRPT-1][0:SRAM_DELAY];
  reg [BITVROW-1:0]  vwrradr_reg [0:2*NUMWRPT-1][0:SRAM_DELAY];
  reg [WIDTH-1:0]    vdin_reg [0:2*NUMWRPT-1][0:SRAM_DELAY];
  integer vdel_int, vprt_int;
  always @(posedge clk) 
    for (vdel_int=SRAM_DELAY; vdel_int>=0; vdel_int=vdel_int-1)
      if (vdel_int>0) begin
        for (vprt_int=0; vprt_int<NUMDUPL*NUMRDPT; vprt_int=vprt_int+1) begin
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
          vrdbadr_reg[vprt_int][vdel_int] <= vrdbadr_reg[vprt_int][vdel_int-1];
          vrdradr_reg[vprt_int][vdel_int] <= vrdradr_reg[vprt_int][vdel_int-1];
        end
        for (vprt_int=0; vprt_int<2*NUMWRPT; vprt_int=vprt_int+1) begin
          vwrite_reg[vprt_int][vdel_int] <= vwrite_reg[vprt_int][vdel_int-1];
          vwrbadr_reg[vprt_int][vdel_int] <= vwrbadr_reg[vprt_int][vdel_int-1];
          vwrradr_reg[vprt_int][vdel_int] <= vwrradr_reg[vprt_int][vdel_int-1];          
          vdin_reg[vprt_int][vdel_int] <= vdin_reg[vprt_int][vdel_int-1];
        end
      end else begin
        for (vprt_int=0; vprt_int<NUMDUPL*NUMRDPT; vprt_int=vprt_int+1) begin
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
          vrdbadr_reg[vprt_int][vdel_int] <= vrdbadr_wire[vprt_int];
          vrdradr_reg[vprt_int][vdel_int] <= vrdradr_wire[vprt_int];
        end
        for (vprt_int=0; vprt_int<2*NUMWRPT; vprt_int=vprt_int+1) begin
          vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int] && (vwraddr_wire[vprt_int] < NUMADDR) && ready;
          vwrbadr_reg[vprt_int][vdel_int] <= vwrbadr_wire[vprt_int];
          vwrradr_reg[vprt_int][vdel_int] <= vwrradr_wire[vprt_int];
          vdin_reg[vprt_int][vdel_int] <= vdin_wire[vprt_int];          
        end
      end

  reg               vread_out[0:NUMDUPL*NUMRDPT-1];
  reg [BITVBNK-1:0] vrdbadr_out[0:NUMDUPL*NUMRDPT-1];
  reg [BITVROW-1:0] vrdradr_out[0:NUMDUPL*NUMRDPT-1];
  reg               vwrite_nxt[0:2*NUMWRPT-1];
  reg               vwrite_out[0:2*NUMWRPT-1];
  reg [BITVBNK-1:0] vwrbadr_out[0:2*NUMWRPT-1];
  reg [BITVROW-1:0] vwrradr_out[0:2*NUMWRPT-1];
  reg [WIDTH-1:0]   vdin_out[0:2*NUMWRPT-1];
//  reg vwrsam_out[0:NUMWRPT-1];
//  reg [2*NUMWRPT-1:0] vwrgrp_out[0:NUMWRPT-1];
  integer vout_int, vwpt_int;
  always_comb  begin
    for (vout_int=0; vout_int<NUMDUPL*NUMRDPT; vout_int=vout_int+1) begin
      vread_out[vout_int] = vread_reg[vout_int][SRAM_DELAY-1];
      vrdbadr_out[vout_int] = vrdbadr_reg[vout_int][SRAM_DELAY-1];
      vrdradr_out[vout_int] = vrdradr_reg[vout_int][SRAM_DELAY-1];
    end
    for (vout_int=0; vout_int<2*NUMWRPT; vout_int=vout_int+1) begin
      vwrite_nxt[vout_int] = vwrite_reg[vout_int][SRAM_DELAY-1];
      for (vwpt_int=vout_int+1; vwpt_int<2*NUMWRPT; vwpt_int=vwpt_int+1)
        vwrite_nxt[vout_int] = vwrite_nxt[vout_int] && !(vwrite_reg[vwpt_int][SRAM_DELAY-1] &&
                                                         (vwrbadr_reg[vwpt_int][SRAM_DELAY-1] == vwrbadr_reg[vout_int][SRAM_DELAY-1]) &&
                                                         (vwrradr_reg[vwpt_int][SRAM_DELAY-1] == vwrradr_reg[vout_int][SRAM_DELAY-1])); 
      vwrbadr_out[vout_int] = vwrbadr_reg[vout_int][SRAM_DELAY];
      vwrradr_out[vout_int] = vwrradr_reg[vout_int][SRAM_DELAY];
      vdin_out[vout_int] = vdin_reg[vout_int][SRAM_DELAY];
    end
/*
    for (vout_int=0; vout_int<NUMWRPT; vout_int=vout_int+1) begin
      vwrgrp_out[vout_int] = 0;
      vwrsam_out[vout_int] = 0;
      for (vwpt_int=vout_int+1; vwpt_int<2*NUMWRPT; vwpt_int=vwpt_int+1)
        if (vwrite_out[vout_int] && vwrite_out[vwpt_int] && (vwrradr_out[vout_int] == vwrradr_out[vwpt_int])) begin
          vwrgrp_out[vout_int] = vwrgrp_out[vout_int] | (1'b1 << vwpt_int);
          vwrsam_out[vout_int] = 1;
        end
    end
    if (!vwrsam_out[0] && !vwrsam_out[1]) begin
      vwrgrp_out[0] = 2'b11;
      vwrgrp_out[1] = ~vwrgrp_out[0];
    end else if (vwrsam_out[0]) begin
      vwrgrp_out[0] = vwrgrp_out[0] | 1'b1;
      vwrgrp_out[1] = ~vwrgrp_out[0];
      vwrsam_out[1] = 0;
    end else if (|vwrgrp_out[1]) begin
      vwrgrp_out[1] = vwrgrp_out[1] | (1'b1 << 1);
      vwrgrp_out[0] = ~vwrgrp_out[1];
      vwrsam_out[0] = 0;
    end
*/
  end

  integer vwrt_int;
  always @(posedge clk)
    for (vwrt_int=0; vwrt_int<2*NUMWRPT; vwrt_int=vwrt_int+1)
      vwrite_out[vwrt_int] <= vwrite_nxt[vwrt_int];

  wire vwrite_out_0 = vwrite_out[0];
  wire [BITVBNK-1:0] vwrbadr_out_0 = vwrbadr_out[0];
  wire [BITVROW-1:0] vwrradr_out_0 = vwrradr_out[0];
  wire [WIDTH-1:0] vdin_out_0 = vdin_out[0];
  wire vwrite_out_1 = vwrite_out[1];
  wire [BITVBNK-1:0] vwrbadr_out_1 = vwrbadr_out[1];
  wire [BITVROW-1:0] vwrradr_out_1 = vwrradr_out[1];
  wire [WIDTH-1:0] vdin_out_1 = vdin_out[1];
  wire vwrite_out_2 = vwrite_out[2];
  wire [BITVBNK-1:0] vwrbadr_out_2 = vwrbadr_out[2];
  wire [BITVROW-1:0] vwrradr_out_2 = vwrradr_out[2];
  wire [WIDTH-1:0] vdin_out_2 = vdin_out[2];
/*
  wire [2*NUMWRPT-1:0] vwrgrp_out_0 = vwrgrp_out[0];
  wire [2*NUMWRPT-1:0] vwrgrp_out_1 = vwrgrp_out[1];
  wire vwrsam_out_0 = vwrsam_out[0];
  wire vwrsam_out_1 = vwrsam_out[1];
*/
/*
  wire               vwritea_out = vwrite_reg[0][SRAM_DELAY];
  wire [BITVBNK-1:0] vwrbadra_out = vwrbadr_reg[0][SRAM_DELAY];
  wire [BITVROW-1:0] vwrradra_out = vwrradr_reg[0][SRAM_DELAY];
  wire [WIDTH-1:0]   vdina_out = vdin_reg[0][SRAM_DELAY];       

  wire               vwriteb_out = vwrite_reg[1][SRAM_DELAY];
  wire [BITVBNK-1:0] vwrbadrb_out = vwrbadr_reg[1][SRAM_DELAY];
  wire [BITVROW-1:0] vwrradrb_out = vwrradr_reg[1][SRAM_DELAY];
  wire [WIDTH-1:0]   vdinb_out = vdin_reg[1][SRAM_DELAY];       
*/
  // Read request of pivoted data on DRAM memory
  reg               pwrite_wire [0:2*NUMWRPT-1];
  reg [BITVBNK-1:0] pwrbadr_wire [0:2*NUMWRPT-1];
  reg [BITVROW-1:0] pwrradr_wire [0:2*NUMWRPT-1];
  reg [WIDTH-1:0]   pdin_wire [0:2*NUMWRPT-1];
  
  reg               cwrite_wire [0:NUMWRPT-1];
  reg [BITVROW-1:0] cwrradr_wire [0:NUMWRPT-1];
  reg [WIDTH-1:0]   cdin_wire [0:NUMWRPT-1];

  reg                    swrite_wire [0:NUMWRPT-1];
  reg [BITVROW-1:0]      swrradr_wire [0:NUMWRPT-1];
  wire [SDOUT_WIDTH-1:0] sdin_wire [0:NUMWRPT-1];

  wire pwrite_wire_0 = pwrite_wire[0];
  wire [BITVBNK-1:0] pwrbadr_wire_0 = pwrbadr_wire[0];
  wire [BITVROW-1:0] pwrradr_wire_0 = pwrradr_wire[0];
  wire [WIDTH-1:0] pdin_wire_0 = pdin_wire[0];
  wire pwrite_wire_1 = pwrite_wire[1];
  wire [BITVBNK-1:0] pwrbadr_wire_1 = pwrbadr_wire[1];
  wire [BITVROW-1:0] pwrradr_wire_1 = pwrradr_wire[1];
  wire [WIDTH-1:0] pdin_wire_1 = pdin_wire[1];
  wire pwrite_wire_2 = pwrite_wire[2];
  wire [BITVBNK-1:0] pwrbadr_wire_2 = pwrbadr_wire[2];
  wire [BITVROW-1:0] pwrradr_wire_2 = pwrradr_wire[2];
  wire [WIDTH-1:0] pdin_wire_2 = pdin_wire[2];
  wire pwrite_wire_3 = pwrite_wire[3];
  wire [BITVBNK-1:0] pwrbadr_wire_3 = pwrbadr_wire[3];
  wire [BITVROW-1:0] pwrradr_wire_3 = pwrradr_wire[3];
  wire [WIDTH-1:0] pdin_wire_3 = pdin_wire[3];

  wire cwrite_wire_0 = cwrite_wire[0];
  wire [BITVROW-1:0] cwrradr_wire_0 = cwrradr_wire[0];
  wire [WIDTH-1:0] cdin_wire_0 = cdin_wire[0];
  wire cwrite_wire_1 = cwrite_wire[1];
  wire [BITVROW-1:0] cwrradr_wire_1 = cwrradr_wire[1];
  wire [WIDTH-1:0] cdin_wire_1 = cdin_wire[1];

  wire swrite_wire_0 = swrite_wire[0];
  wire [BITVROW-1:0] swrradr_wire_0 = swrradr_wire[0];
  wire [SDOUT_WIDTH-1:0] sdin_wire_0 = sdin_wire[0];
  wire swrite_wire_1 = swrite_wire[1];
  wire [BITVROW-1:0] swrradr_wire_1 = swrradr_wire[1];
  wire [SDOUT_WIDTH-1:0] sdin_wire_1 = sdin_wire[1];

/*
  reg               pwritea;
  reg [BITVBNK-1:0] pwrbadra;
  reg [BITVROW-1:0] pwrradra;
  reg [WIDTH-1:0]   pdina;
  reg               pwriteb;
  reg [BITVBNK-1:0] pwrbadrb;
  reg [BITVROW-1:0] pwrradrb;
  reg [WIDTH-1:0]   pdinb;

  reg                    cwrite;
  reg [BITVROW-1:0]      cwrradr;
  reg [WIDTH-1:0]        cdin;

  reg                    swrite;
  reg [BITVROW-1:0]      swrradr;
  wire [SDOUT_WIDTH-1:0] sdin;
*/

//  reg [NUMVBNK-1:0] t1_readB_tmp [0:NUMRDPT-1][0:NUMDUPL-1];
//  reg [NUMVBNK*BITVROW-1:0] t1_addrB_tmp [0:NUMRDPT-1][0:NUMDUPL-1];
  reg [NUMDUPL*NUMRDPT*NUMVBNK-1:0] t1_readB;
  reg [NUMDUPL*NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  reg [NUMDUPL*NUMRDPT*NUMVBNK-1:0] t1_read_tmp;
  integer t1rp_int, t1rd_int, t1rw_int;
  always_comb begin
    t1_readB = 0;
    t1_addrB = 0;
    for (t1rd_int=0; t1rd_int<NUMDUPL; t1rd_int=t1rd_int+1)
      for (t1rp_int=0; t1rp_int<NUMRDPT; t1rp_int=t1rp_int+1) begin
        t1_read_tmp[NUMRDPT*t1rd_int+t1rp_int] = vread_wire[NUMRDPT*t1rd_int+t1rp_int] && (vrdbadr_wire[NUMRDPT*t1rd_int+t1rp_int] < NUMVBNK);
        for (t1rw_int=0; t1rw_int<2*NUMWRPT; t1rw_int=t1rw_int+1)
          t1_read_tmp[NUMRDPT*t1rd_int+t1rp_int] = t1_read_tmp[NUMRDPT*t1rd_int+t1rp_int] &&
                                                   !(pwrite_wire[t1rw_int] && (vrdbadr_wire[NUMRDPT*t1rd_int+t1rp_int] == pwrbadr_wire[t1rw_int]) &&
                                                                              (vrdradr_wire[NUMRDPT*t1rd_int+t1rp_int] == pwrradr_wire[t1rw_int]));
        if (t1_read_tmp[NUMRDPT*t1rd_int+t1rp_int]) begin
          t1_readB = t1_readB | (1'b1 << (NUMDUPL*NUMRDPT*vrdbadr_wire[NUMRDPT*t1rd_int+t1rp_int]+NUMRDPT*t1rd_int+t1rp_int));
          t1_addrB = t1_addrB | (vrdradr_wire[NUMRDPT*t1rd_int+t1rp_int] << ((NUMDUPL*NUMRDPT*vrdbadr_wire[NUMRDPT*t1rd_int+t1rp_int]+NUMRDPT*t1rd_int+t1rp_int)*BITVROW));
        end
      end
  end

  reg [WIDTH-1:0] pdout_wire [0:NUMDUPL*NUMRDPT-1];
  reg [BITPADR-BITPBNK-1:0] padr_wire [0:NUMDUPL*NUMRDPT-1];
  integer pdop_int, pdod_int;
  always_comb
    for (pdod_int=0; pdod_int<NUMDUPL; pdod_int=pdod_int+1)
      for (pdop_int=0; pdop_int<NUMRDPT; pdop_int=pdop_int+1) begin
        pdout_wire[NUMRDPT*pdod_int+pdop_int] = t1_doutB >> ((NUMDUPL*NUMRDPT*vrdbadr_out[NUMRDPT*pdod_int+pdop_int]+NUMRDPT*pdod_int+pdop_int)*WIDTH);
        padr_wire[NUMRDPT*pdod_int+pdop_int] = t1_padrB >> ((NUMDUPL*NUMRDPT*vrdbadr_out[NUMRDPT*pdod_int+pdop_int]+NUMRDPT*pdod_int+pdop_int)*(BITPADR-BITPBNK));
      end

  // Read request of mapping information on SRAM memory
  reg [NUMDUPL*NUMRDPT+NUMWRPT-1:0] t2_readB;
  reg [(NUMDUPL*NUMRDPT+NUMWRPT)*BITVROW-1:0] t2_addrB;
  reg [NUMDUPL*NUMRDPT+NUMWRPT-1:0] t2_read_tmp;
  integer t2rp_int, t2rw_int;
  always_comb begin
    t2_readB = 0;
    t2_addrB = 0;
    for (t2rp_int=0; t2rp_int<NUMDUPL*NUMRDPT; t2rp_int=t2rp_int+1) begin
      t2_read_tmp[t2rp_int] = vread_wire[t2rp_int];
      for (t2rw_int=0; t2rw_int<NUMWRPT; t2rw_int=t2rw_int+1)
        t2_read_tmp[t2rp_int] = t2_read_tmp[t2rp_int] && !(cwrite_wire[t2rw_int] && (vrdradr_wire[t2rp_int] == cwrradr_wire[t2rw_int]));
      if (t2_read_tmp[t2rp_int]) begin
        t2_readB = t2_readB | (1'b1 << t2rp_int);
        t2_addrB = t2_addrB | (vrdradr_wire[t2rp_int] << (t2rp_int*BITVROW));
      end
    end
    for (t2rp_int=0; t2rp_int<NUMWRPT; t2rp_int=t2rp_int+1) begin
      t2_read_tmp[NUMDUPL*NUMRDPT+t2rp_int] = vwrite_wire[2*t2rp_int+1];
      for (t2rw_int=0; t2rw_int<NUMWRPT; t2rw_int=t2rw_int+1)
        t2_read_tmp[NUMDUPL*NUMRDPT+t2rp_int] = t2_read_tmp[NUMDUPL*NUMRDPT+t2rp_int] && !(cwrite_wire[t2rw_int] && (vwrradr_wire[2*t2rp_int+1] == cwrradr_wire[t2rw_int]));
      if (t2_read_tmp[NUMDUPL*NUMRDPT+t2rp_int]) begin
        t2_readB = t2_readB | (1'b1 << (NUMDUPL*NUMRDPT+t2rp_int));
        t2_addrB = t2_addrB | (vwrradr_wire[2*t2rp_int+1] << ((NUMDUPL*NUMRDPT+t2rp_int)*BITVROW));
      end
    end
  end

  reg [WIDTH-1:0] cdout_wire [0:NUMDUPL*NUMRDPT+NUMWRPT-1];
  integer cdo_int;
  always_comb
    for (cdo_int=0; cdo_int<NUMDUPL*NUMRDPT+NUMWRPT; cdo_int=cdo_int+1)
      cdout_wire[cdo_int] = t2_doutB >> (cdo_int*WIDTH);

  reg [NUMDUPL*NUMRDPT+2*NUMWRPT-1:0] t3_readB;
  reg [(NUMDUPL*NUMRDPT+2*NUMWRPT)*BITVROW-1:0] t3_addrB;
  reg [NUMDUPL*NUMRDPT+2*NUMWRPT-1:0] t3_read_tmp;
  integer t3rp_int, t3rw_int;
  always_comb begin
    t3_readB = 0;
    t3_addrB = 0;
    for (t3rp_int=0; t3rp_int<NUMDUPL*NUMRDPT; t3rp_int=t3rp_int+1) begin
      t3_read_tmp[t3rp_int] = vread_wire[t3rp_int];
      for (t3rw_int=0; t3rw_int<NUMWRPT; t3rw_int=t3rw_int+1)
        t3_read_tmp[t3rp_int] = t3_read_tmp[t3rp_int] && !(swrite_wire[t3rw_int] && (vrdradr_wire[t3rp_int] == swrradr_wire[t3rw_int]));
      if (t3_read_tmp[t3rp_int]) begin
        t3_readB = t3_readB | (1'b1 << t3rp_int);
        t3_addrB = t3_addrB | (vrdradr_wire[t3rp_int] << (t3rp_int*BITVROW));
      end
    end
    for (t3rp_int=0; t3rp_int<2*NUMWRPT; t3rp_int=t3rp_int+1) begin
      t3_read_tmp[NUMDUPL*NUMRDPT+t3rp_int] = vwrite_wire[t3rp_int];
      for (t3rw_int=0; t3rw_int<NUMWRPT; t3rw_int=t3rw_int+1)
        t3_read_tmp[NUMDUPL*NUMRDPT+t3rp_int] = t3_read_tmp[NUMDUPL*NUMRDPT+t3rp_int] && !(swrite_wire[t3rw_int] && (vwrradr_wire[t3rp_int] == swrradr_wire[t3rw_int]));
      if (t3_read_tmp[NUMDUPL*NUMRDPT+t3rp_int]) begin
        t3_readB = t3_readB | (1'b1 << (NUMDUPL*NUMRDPT+t3rp_int));
        t3_addrB = t3_addrB | (vwrradr_wire[t3rp_int] << ((NUMDUPL*NUMRDPT+t3rp_int)*BITVROW));
      end
    end
  end

  reg [SDOUT_WIDTH-1:0] sdout_wire [0:NUMDUPL*NUMRDPT+2*NUMWRPT-1];
  integer sdo_int;
  always_comb
    for (sdo_int=0; sdo_int<NUMDUPL*NUMRDPT+2*NUMWRPT; sdo_int=sdo_int+1)
      sdout_wire[sdo_int] = t3_doutB >> (sdo_int*SDOUT_WIDTH);

  reg              wrmap_vld [0:2*NUMWRPT-1][0:SRAM_DELAY];
  reg [BITVBNK:0]  wrmap_reg [0:2*NUMWRPT-1][0:SRAM_DELAY];
  reg              wcdat_vld [0:2*NUMWRPT-1][0:SRAM_DELAY];
  reg [WIDTH-1:0]  wcdat_reg [0:2*NUMWRPT-1][0:SRAM_DELAY];

  genvar wrmf_int, wrmp_int;
  generate
    for (wrmf_int=0; wrmf_int<=SRAM_DELAY; wrmf_int=wrmf_int+1) begin: wrmap_loop
      for (wrmp_int=0; wrmp_int<2*NUMWRPT; wrmp_int=wrmp_int+1) begin: prt_loop
        reg [BITVROW-1:0] vradr_temp;
        reg map_vld_next; 
        reg [BITVBNK:0] map_reg_next;
        reg cdat_vld_next;
        reg [WIDTH-1:0] cdat_reg_next;
        integer wrmw_int;
        always_comb begin
          if (wrmf_int>0) begin
            vradr_temp = vwrradr_reg[wrmp_int][wrmf_int-1];
            map_vld_next = wrmap_vld[wrmp_int][wrmf_int-1];
            map_reg_next = wrmap_reg[wrmp_int][wrmf_int-1];
            cdat_vld_next = wcdat_vld[wrmp_int][wrmf_int-1];
            cdat_reg_next = wcdat_reg[wrmp_int][wrmf_int-1];
          end else begin
            vradr_temp = vwrradr_wire[wrmp_int];
            map_vld_next = 1'b0;
            map_reg_next = 0;
            cdat_vld_next = 1'b0;
            cdat_reg_next = 0;
          end
          for (wrmw_int=0; wrmw_int<2; wrmw_int=wrmw_int+1) begin
            if (swrite_wire[wrmw_int] && (swrradr_wire[wrmw_int] == vradr_temp)) begin
              map_vld_next = 1'b1;
              map_reg_next = sdin_wire[wrmw_int];
            end
            if (cwrite_wire[wrmw_int] && (cwrradr_wire[wrmw_int] == vradr_temp)) begin
              cdat_vld_next = 1'b1;
              cdat_reg_next = cdin_wire[wrmw_int];
            end
          end
        end

        always @(posedge clk) begin
          wrmap_vld[wrmp_int][wrmf_int] <= map_vld_next;
          wrmap_reg[wrmp_int][wrmf_int] <= map_reg_next;
          wcdat_vld[wrmp_int][wrmf_int] <= cdat_vld_next;
          wcdat_reg[wrmp_int][wrmf_int] <= cdat_reg_next;
        end
      end
    end
  endgenerate

/*
  integer wrmf_int, wrmp_int, wrmw_int;
  always @(posedge clk) 
    for (wrmf_int=SRAM_DELAY; wrmf_int>=0; wrmf_int=wrmf_int-1) begin
      for (wrmp_int=0; wrmp_int<NUMWRPT; wrmp_int=wrmp_int+1)
        for (wrmw_int=0; wrmw_int<1; wrmw_int=wrmw_int+1)
          if (wrmf_int>0)
            if (swrite_wire[wrmw_int] && (swrradr_wire[wrmw_int] == vwrradr_reg[wrmp_int][wrmf_int-1])) begin
              wrmap_vld[wrmp_int][wrmf_int] <= 1'b1;
              wrmap_reg[wrmp_int][wrmf_int] <= sdin_wire[wrmw_int];
            end else begin
              wrmap_vld[wrmp_int][wrmf_int] <= wrmap_vld[wrmp_int][wrmf_int-1];
              wrmap_reg[wrmp_int][wrmf_int] <= wrmap_reg[wrmp_int][wrmf_int-1];            
            end
          else
            if (swrite_wire[wrmw_int] && (swrradr_wire[wrmw_int] == vwrradr_wire[wrmp_int])) begin
              wrmap_vld[wrmp_int][wrmf_int] <= 1'b1;
              wrmap_reg[wrmp_int][wrmf_int] <= sdin_wire[wrmw_int];
            end else begin
              wrmap_vld[wrmp_int][wrmf_int] <= 1'b0;
              wrmap_reg[wrmp_int][wrmf_int] <= 0;
            end
      for (wrmp_int=0; wrmp_int<NUMWRPT; wrmp_int=wrmp_int+1)
        for (wrmw_int=0; wrmw_int<1; wrmw_int=wrmw_int+1)
          if (wrmf_int>0)
            if (cwrite_wire[wrmw_int] && (cwrradr_wire[wrmw_int] == vwrradr_reg[wrmp_int][wrmf_int-1])) begin
              wcdat_vld[wrmp_int][wrmf_int] <= 1'b1;
              wcdat_reg[wrmp_int][wrmf_int] <= cdin_wire[wrmw_int];
            end else begin
              wcdat_vld[wrmp_int][wrmf_int] <= wcdat_vld[wrmp_int][wrmf_int-1];
              wcdat_reg[wrmp_int][wrmf_int] <= wcdat_reg[wrmp_int][wrmf_int-1];
            end
          else
            if (cwrite_wire[wrmw_int] && (cwrradr_wire[wrmw_int] == vwrradr_wire[wrmp_int])) begin
              wcdat_vld[wrmp_int][wrmf_int] <= 1'b1;
              wcdat_reg[wrmp_int][wrmf_int] <= cdin_wire[wrmw_int];
            end else begin
              wcdat_vld[wrmp_int][wrmf_int] <= 1'b0;
              wcdat_reg[wrmp_int][wrmf_int] <= 0;
            end
    end
*/
  wire wcdat_vld_0_0 = wcdat_vld[0][0];
  wire wcdat_vld_1_0 = wcdat_vld[1][0];
  wire wcdat_vld_2_0 = wcdat_vld[2][0];
  wire wcdat_vld_3_0 = wcdat_vld[3][0];
  wire wcdat_vld_0_1 = wcdat_vld[0][1];
  wire wcdat_vld_1_1 = wcdat_vld[1][1];
  wire wcdat_vld_2_1 = wcdat_vld[2][1];
  wire wcdat_vld_3_1 = wcdat_vld[3][1];
  wire [WIDTH-1:0] wcdat_reg_1_0 = wcdat_reg[1][0];

  reg             rdmap_vld [0:NUMDUPL*NUMRDPT-1][0:SRAM_DELAY-1];
  reg [BITVBNK:0] rdmap_reg [0:NUMDUPL*NUMRDPT-1][0:SRAM_DELAY-1];
  reg             rcdat_vld [0:NUMDUPL*NUMRDPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0] rcdat_reg [0:NUMDUPL*NUMRDPT-1][0:SRAM_DELAY-1];
  genvar rdmf_int, rdmp_int;
  generate
    for (rdmf_int=0; rdmf_int<SRAM_DELAY; rdmf_int=rdmf_int+1) begin: rdmap_loop
      for (rdmp_int=0; rdmp_int<NUMDUPL*NUMRDPT; rdmp_int=rdmp_int+1) begin: prt_loop
        reg [BITVROW-1:0] vradr_temp;
        reg map_vld_next; 
        reg [BITVBNK:0] map_reg_next;
        reg cdat_vld_next;
        reg [WIDTH-1:0] cdat_reg_next;
        integer rdmw_int;
        always_comb begin
          if (rdmf_int>0) begin
            vradr_temp = vrdradr_reg[rdmp_int][rdmf_int-1];
            map_vld_next = rdmap_vld[rdmp_int][rdmf_int-1];
            map_reg_next = rdmap_reg[rdmp_int][rdmf_int-1];
            cdat_vld_next = rcdat_vld[rdmp_int][rdmf_int-1];
            cdat_reg_next = rcdat_reg[rdmp_int][rdmf_int-1];
          end else begin
            vradr_temp = vrdradr_wire[rdmp_int];
            map_vld_next = 1'b0;
            map_reg_next = 0;
            cdat_vld_next = 1'b0;
            cdat_reg_next = 0;
          end
          for (rdmw_int=0; rdmw_int<NUMWRPT; rdmw_int=rdmw_int+1) begin
            if (swrite_wire[rdmw_int] && (swrradr_wire[rdmw_int] == vradr_temp)) begin
              map_vld_next = 1'b1;
              map_reg_next = sdin_wire[rdmw_int];
            end
            if (cwrite_wire[rdmw_int] && (cwrradr_wire[rdmw_int] == vradr_temp)) begin
              cdat_vld_next = 1'b1;
              cdat_reg_next = cdin_wire[rdmw_int];
            end
          end
        end

        always @(posedge clk) begin
          rdmap_vld[rdmp_int][rdmf_int] <= map_vld_next;
          rdmap_reg[rdmp_int][rdmf_int] <= map_reg_next;
          rcdat_vld[rdmp_int][rdmf_int] <= cdat_vld_next;
          rcdat_reg[rdmp_int][rdmf_int] <= cdat_reg_next;
        end
      end
    end
  endgenerate

/*
  integer rdmf_int, rdmp_int, rdmw_int;
  always @(posedge clk) 
      for (rdmf_int=0; rdmf_int<SRAM_DELAY; rdmf_int=rdmf_int+1) begin
        for (rdmp_int=0; rdmp_int<NUMDUPL*NUMRDPT; rdmp_int=rdmp_int+1)
          for (rdmw_int=0; rdmw_int<1; rdmw_int=rdmw_int+1)
            if (rdmf_int>0) 
              if (swrite_wire[rdmw_int] && (swrradr_wire[rdmw_int] == vrdradr_reg[rdmp_int][rdmf_int-1])) begin
                rdmap_vld[rdmp_int][rdmf_int] <= 1'b1;
                rdmap_reg[rdmp_int][rdmf_int] <= sdin_wire[rdmw_int];
              end else begin
                rdmap_vld[rdmp_int][rdmf_int] <= rdmap_vld[rdmp_int][rdmf_int-1];
                rdmap_reg[rdmp_int][rdmf_int] <= rdmap_reg[rdmp_int][rdmf_int-1];
              end
            else
              if (swrite_wire[rdmw_int] && (swrradr_wire[rdmw_int] == vrdradr_wire[rdmp_int])) begin
                rdmap_vld[rdmp_int][rdmf_int] <= 1'b1;
                rdmap_reg[rdmp_int][rdmf_int] <= sdin_wire[rdmw_int];
              end else begin
                rdmap_vld[rdmp_int][rdmf_int] <= 1'b0;
                rdmap_reg[rdmp_int][rdmf_int] <= 0;
              end
        for (rdmp_int=0; rdmp_int<NUMDUPL*NUMRDPT; rdmp_int=rdmp_int+1)
          for (rdmw_int=0; rdmw_int<1; rdmw_int=rdmw_int+1)
            if (rdmf_int>0) 
              if (cwrite_wire[rdmw_int] && (cwrradr_wire[rdmw_int] == vrdradr_reg[rdmp_int][rdmf_int-1])) begin
                rcdat_vld[rdmp_int][rdmf_int] <= 1'b1;
                rcdat_reg[rdmp_int][rdmf_int] <= cdin_wire[rdmw_int];
              end else begin
                rcdat_vld[rdmp_int][rdmf_int] <= rcdat_vld[rdmp_int][rdmf_int-1];
                rcdat_reg[rdmp_int][rdmf_int] <= rcdat_reg[rdmp_int][rdmf_int-1];
              end
            else
              if (cwrite_wire[rdmw_int] && (cwrradr_wire[rdmw_int] == vrdradr_wire[rdmp_int])) begin
                rcdat_vld[rdmp_int][rdmf_int] <= 1'b1;
                rcdat_reg[rdmp_int][rdmf_int] <= cdin_wire[rdmw_int];
              end else begin
                rcdat_vld[rdmp_int][rdmf_int] <= 1'b0;
                rcdat_reg[rdmp_int][rdmf_int] <= 0;
              end
      end
*/
  reg             rddat_vld [0:NUMDUPL*NUMRDPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0] rddat_reg [0:NUMDUPL*NUMRDPT-1][0:SRAM_DELAY-1];
  integer rdff_int, rdfp_int, rdfwp_int;
  always @(posedge clk) 
    for (rdff_int=SRAM_DELAY-1; rdff_int>=0; rdff_int=rdff_int-1)
      for (rdfp_int=0; rdfp_int<NUMDUPL*NUMRDPT; rdfp_int=rdfp_int+1)
        if (rdff_int>0) begin
          rddat_vld[rdfp_int][rdff_int] <= rddat_vld[rdfp_int][rdff_int-1];
          rddat_reg[rdfp_int][rdff_int] <= rddat_reg[rdfp_int][rdff_int-1];
          for (rdfwp_int=0; rdfwp_int<2*NUMWRPT; rdfwp_int=rdfwp_int+1)
            if (vwrite_reg[rdfwp_int][SRAM_DELAY-1] && vread_reg[rdfp_int][rdff_int-1] &&
                (vwrbadr_reg[rdfwp_int][SRAM_DELAY-1] == vrdbadr_reg[rdfp_int][rdff_int-1]) &&
                (vwrradr_reg[rdfwp_int][SRAM_DELAY-1] == vrdradr_reg[rdfp_int][rdff_int-1])) begin
              rddat_vld[rdfp_int][rdff_int] <= 1'b1;
              rddat_reg[rdfp_int][rdff_int] <= vdin_reg[rdfwp_int][SRAM_DELAY-1];
            end
        end else begin
          rddat_vld[rdfp_int][rdff_int] <= 1'b0;
          rddat_reg[rdfp_int][rdff_int] <= 0;
          for (rdfwp_int=0; rdfwp_int<2*NUMWRPT; rdfwp_int=rdfwp_int+1)
            if (vwrite_reg[rdfwp_int][SRAM_DELAY-1] && vread_wire[rdfp_int] &&
                (vwrbadr_reg[rdfwp_int][SRAM_DELAY-1] == vrdbadr_wire[rdfp_int]) &&
                (vwrradr_reg[rdfwp_int][SRAM_DELAY-1] == vrdradr_wire[rdfp_int])) begin
              rddat_vld[rdfp_int][rdff_int] <= 1'b1;
              rddat_reg[rdfp_int][rdff_int] <= vdin_reg[rdfwp_int][SRAM_DELAY-1];
            end
        end

  reg             rpdat_vld [0:NUMDUPL*NUMRDPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0] rpdat_reg [0:NUMDUPL*NUMRDPT-1][0:SRAM_DELAY-1];
  integer rpff_int, rpfp_int, rpfwp_int;
  always @(posedge clk) 
    for (rpff_int=SRAM_DELAY-1; rpff_int>=0; rpff_int=rpff_int-1)
      for (rpfp_int=0; rpfp_int<NUMDUPL*NUMRDPT; rpfp_int=rpfp_int+1)
        if (rpff_int>0) begin
          rpdat_vld[rpfp_int][rpff_int] <= rpdat_vld[rpfp_int][rpff_int-1];
          rpdat_reg[rpfp_int][rpff_int] <= rpdat_reg[rpfp_int][rpff_int-1];
          for (rpfwp_int=0; rpfwp_int<2*NUMWRPT; rpfwp_int=rpfwp_int+1)
            if (pwrite_wire[rpfwp_int] && vread_reg[rpfp_int][rpff_int-1] &&
                (pwrbadr_wire[rpfwp_int] == vrdbadr_reg[rpfp_int][rpff_int-1]) &&
                (pwrradr_wire[rpfwp_int] == vrdradr_reg[rpfp_int][rpff_int-1])) begin
              rpdat_vld[rpfp_int][rpff_int] <= 1'b1;
              rpdat_reg[rpfp_int][rpff_int] <= pdin_wire[rpfwp_int];
            end
        end else begin
          rpdat_vld[rpfp_int][rpff_int] <= 1'b0;
          rpdat_reg[rpfp_int][rpff_int] <= 0;
          for (rpfwp_int=0; rpfwp_int<2*NUMWRPT; rpfwp_int=rpfwp_int+1)
            if (pwrite_wire[rpfwp_int] && vread_wire[rpfp_int] &&
                (pwrbadr_wire[rpfwp_int] == vrdbadr_wire[rpfp_int]) &&
                (pwrradr_wire[rpfwp_int] == vrdradr_wire[rpfp_int])) begin
              rpdat_vld[rpfp_int][rpff_int] <= 1'b1;
              rpdat_reg[rpfp_int][rpff_int] <= pdin_wire[rpfwp_int];
            end
        end

// ECC Generation Module
  reg [BITVBNK:0] sdin_pre_ecc [0:NUMWRPT-1];
  wire [ECCBITS-1:0] sdin_ecc [0:NUMWRPT-1];
  genvar sgen_int;
  generate for (sgen_int=0; sgen_int<NUMWRPT; sgen_int=sgen_int+1) begin: sgen_loop
    ecc_calc   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
        ecc_calc_inst (.din(sdin_pre_ecc[sgen_int]), .eccout(sdin_ecc[sgen_int]));

    assign sdin_wire[sgen_int] = {sdin_pre_ecc[sgen_int], sdin_ecc[sgen_int], sdin_pre_ecc[sgen_int]};
  end
  endgenerate

// ECC Checking Module
  wire [BITVBNK:0] sdout_final [0:NUMDUPL*NUMRDPT+2*NUMWRPT-1];
  genvar schk_int;
  generate for (schk_int=0; schk_int<NUMDUPL*NUMRDPT+2*NUMWRPT; schk_int=schk_int+1) begin: schk_loop
    wire sdout_bit1_err = 0;
    wire sdout_bit2_err = 0;
    wire [7:0] sdout_bit1_pos = 0;
    wire [7:0] sdout_bit2_pos = 0;
    wire [SDOUT_WIDTH-1:0] sdout_bit1_mask = sdout_bit1_err << sdout_bit1_pos;
    wire [SDOUT_WIDTH-1:0] sdout_bit2_mask = sdout_bit2_err << sdout_bit2_pos;
    wire [SDOUT_WIDTH-1:0] sdout_mask = sdout_bit1_mask ^ sdout_bit2_mask;
    wire sdout_serr = |sdout_mask && (|sdout_bit1_mask ^ |sdout_bit2_mask);
    wire sdout_derr = |sdout_mask && |sdout_bit1_mask && |sdout_bit2_mask;
    wire [SDOUT_WIDTH-1:0] sdout_int = sdout_wire[schk_int] ^ sdout_mask;

    wire [BITVBNK:0] sdout_data_wire = sdout_int;
    wire [ECCBITS-1:0] sdout_ecc_wire = sdout_int >> (BITVBNK+1);
    wire [BITVBNK:0] sdout_dup_data_wire = sdout_int >> (BITVBNK+1+ECCBITS);
    wire [BITVBNK:0] sdout_post_ecc_wire;
    wire sdout_sec_err_wire;
    wire sdout_ded_err_wire;

    ecc_check   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
        ecc_check_inst (.din(sdout_data_wire), .eccin(sdout_ecc_wire),
                        .dout(sdout_post_ecc_wire), .sec_err(sdout_sec_err_wire), .ded_err(sdout_ded_err_wire),
                        .clk(clk), .rst(rst));

    assign sdout_final[schk_int] = sdout_ded_err_wire ? sdout_dup_data_wire : sdout_post_ecc_wire;
  end
  endgenerate

  wire vread_vld_wire [0:NUMDUPL*NUMRDPT-1];
  wire [WIDTH-1:0] vdout_int [0:NUMDUPL*NUMRDPT-1];
  wire [WIDTH-1:0] vdout_wire [0:NUMDUPL*NUMRDPT-1];
  wire vread_fwrd_wire [0:NUMDUPL*NUMRDPT-1];
  wire vread_serr_wire [0:NUMDUPL*NUMRDPT-1];
  wire vread_derr_wire [0:NUMDUPL*NUMRDPT-1];
  wire [BITPADR-1:0] vread_padr_wire [0:NUMDUPL*NUMRDPT-1];
  genvar vmap_int;
  generate for (vmap_int=0; vmap_int<NUMDUPL*NUMRDPT; vmap_int=vmap_int+1) begin: vdo_loop
    wire [BITVBNK:0] rdmap_out = rdmap_vld[vmap_int][SRAM_DELAY-1] ? rdmap_reg[vmap_int][SRAM_DELAY-1] : sdout_final[vmap_int];
    wire rdmap_vld = rdmap_out >> BITVBNK;
    wire [BITVBNK-1:0] rdmap_map = rdmap_out;
    wire [WIDTH-1:0] rcdat_out = rcdat_vld[vmap_int][SRAM_DELAY-1] ? rcdat_reg[vmap_int][SRAM_DELAY-1] : cdout_wire[vmap_int];
    wire [WIDTH-1:0] rpdat_out = rpdat_vld[vmap_int][SRAM_DELAY-1] ? rpdat_reg[vmap_int][SRAM_DELAY-1] : pdout_wire[vmap_int];

    assign vread_vld_wire[vmap_int] = vread_out[vmap_int];
    assign vdout_int[vmap_int] = (rdmap_vld && (rdmap_map == vrdbadr_out[vmap_int])) ? rcdat_out : rpdat_out;
    assign vdout_wire[vmap_int] = rddat_vld[vmap_int][SRAM_DELAY-1] ? rddat_reg[vmap_int][SRAM_DELAY-1] : vdout_int[vmap_int];
    assign vread_fwrd_wire[vmap_int] = (rddat_vld[vmap_int][SRAM_DELAY-1] ||
                                        ((rdmap_vld && (rdmap_map == vrdbadr_out[vmap_int])) ? rcdat_vld[vmap_int][SRAM_DELAY-1] :
                                                                                               rpdat_vld[vmap_int][SRAM_DELAY-1]));
    assign vread_serr_wire[vmap_int] = 1'b0;
    assign vread_derr_wire[vmap_int] = 1'b0;
    assign vread_padr_wire[vmap_int] = (rdmap_vld && (rdmap_map == vrdbadr_out[vmap_int])) ? ((NUMVBNK << (BITPADR-BITPBNK)) | vrdradr_out[vmap_int]) :
                                                                                             {vrdbadr_out[vmap_int],padr_wire[vmap_int]};
  end
  endgenerate

  reg [NUMDUPL*NUMRDPT-1:0] vread_vld_tmp;
  reg [NUMDUPL*NUMRDPT*WIDTH-1:0] vdout_tmp;
  reg [NUMDUPL*NUMRDPT-1:0] vread_fwrd_tmp;
  reg [NUMDUPL*NUMRDPT-1:0] vread_serr_tmp;
  reg [NUMDUPL*NUMRDPT-1:0] vread_derr_tmp;
  reg [NUMDUPL*NUMRDPT*BITPADR-1:0] vread_padr_tmp;
  integer vdo_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_fwrd_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    for (vdo_int=0; vdo_int<NUMDUPL*NUMRDPT; vdo_int=vdo_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_vld_wire[vdo_int] << vdo_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vdo_int] << (vdo_int*WIDTH));
      vread_fwrd_tmp = vread_fwrd_tmp | (vread_fwrd_wire[vdo_int] << vdo_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vdo_int] << vdo_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vdo_int] << vdo_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vdo_int] << (vdo_int*BITPADR));
    end
  end

  reg [NUMDUPL*NUMRDPT-1:0]         vread_vld;
  reg [NUMDUPL*NUMRDPT*WIDTH-1:0]   vdout;
  reg [NUMDUPL*NUMRDPT-1:0]         vread_fwrd;
  reg [NUMDUPL*NUMRDPT-1:0]         vread_serr;
  reg [NUMDUPL*NUMRDPT-1:0]         vread_derr;
  reg [NUMDUPL*NUMRDPT*BITPADR-1:0] vread_padr;

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

  reg [BITVBNK:0] sdout_reg [0:2*NUMWRPT-1];
  reg [WIDTH-1:0] cdout_reg [0:2*NUMWRPT-1];
  integer scsh_int;
  always @(posedge clk) begin
    for (scsh_int=0; scsh_int<2*NUMWRPT; scsh_int=scsh_int+1)
      sdout_reg[scsh_int] <= sdout_final[NUMDUPL*NUMRDPT+scsh_int];
    for (scsh_int=0; scsh_int<NUMWRPT; scsh_int=scsh_int+1)
      cdout_reg[2*scsh_int+1] <= cdout_wire[NUMDUPL*NUMRDPT+scsh_int];
  end

  wire [WIDTH-1:0] cdout_wire_0 = cdout_wire[0];
  wire [WIDTH-1:0] cdout_wire_1 = cdout_wire[1];
  wire [WIDTH-1:0] cdout_wire_2 = cdout_wire[2];
  wire [WIDTH-1:0] cdout_wire_3 = cdout_wire[3];
  wire [WIDTH-1:0] cdout_wire_4 = cdout_wire[4];
  wire [WIDTH-1:0] cdout_wire_5 = cdout_wire[5];
  wire [WIDTH-1:0] cdout_reg_1 = cdout_reg[1];

//  always_comb begin
//    sdoutwa_reg = sdout_final[NUMRDPT];
//    sdoutwb_reg = sdout_final[NUMRDPT+1];
//    cdoutwb_reg = cdout[NUMRDPT];
//  end
      
  reg [BITVBNK:0] wrmap_out [0:2*NUMWRPT-1];
  reg [WIDTH-1:0] wcdat_out [0:2*NUMWRPT-1];
  integer sfwd_int;
  always_comb begin
    for (sfwd_int=0; sfwd_int<2*NUMWRPT; sfwd_int=sfwd_int+1)
      wrmap_out[sfwd_int] = wrmap_vld[sfwd_int][SRAM_DELAY] ? wrmap_reg[sfwd_int][SRAM_DELAY] : sdout_reg[sfwd_int];
    for (sfwd_int=1; sfwd_int<2*NUMWRPT; sfwd_int=sfwd_int+2)
      wcdat_out[sfwd_int] = wcdat_vld[sfwd_int][SRAM_DELAY] ? wcdat_reg[sfwd_int][SRAM_DELAY] : cdout_reg[sfwd_int];
  end

  wire [BITVBNK:0] wrmap_out_0 = wrmap_out[0];
  wire [BITVBNK:0] wrmap_out_1 = wrmap_out[1];
  wire wcdat_vld_1 = wcdat_vld[1][SRAM_DELAY];
  wire [WIDTH-1:0] wcdat_reg_1 = wcdat_reg[1][SRAM_DELAY];
  wire [WIDTH-1:0] wcdat_out_1 = wcdat_out[1];
  wire wcdat_vld_3 = wcdat_vld[3][SRAM_DELAY];
  wire [WIDTH-1:0] wcdat_reg_3 = wcdat_reg[3][SRAM_DELAY];
  wire [WIDTH-1:0] wcdat_out_3 = wcdat_out[3];
  wire [WIDTH-1:0] cdout_reg_3 = cdout_reg[3];

  wire wrmap_vld_0 = wrmap_vld[0][SRAM_DELAY];
  wire [BITVBNK:0] wrmap_reg_0 = wrmap_reg[0][SRAM_DELAY];
  wire [BITVBNK:0] sdout_reg_0 = sdout_reg[0];
  wire wrmap_vld_1 = wrmap_vld[1][SRAM_DELAY];
  wire [BITVBNK:0] wrmap_reg_1 = wrmap_reg[1][SRAM_DELAY];
  wire [BITVBNK:0] sdout_reg_1 = sdout_reg[1];

//  wire [(BITVBNK+1)-1:0] wrmapa_out = wrmapa_vld[SRAM_DELAY] ? wrmapa_reg[SRAM_DELAY] : sdoutwa_reg;

//  wire [(BITVBNK+1)-1:0] wrmapb_out = wrmapb_vld[SRAM_DELAY] ? wrmapb_reg[SRAM_DELAY] : sdoutwb_reg;
//  wire [WIDTH-1:0]       wrdatb_out = wrdatb_vld[SRAM_DELAY] ? wrdatb_reg[SRAM_DELAY] : cdoutwb_reg;

//  wire [(BITVBNK+1)-1:0] wrmapa_out = (swrite && (swrradr == vwrradra_out)) ? sdin :
//				      wrmapa_vld[SRAM_DELAY-1] ? wrmapa_reg[SRAM_DELAY-1] : sdoutwa_reg;

//  wire [(BITVBNK+1)-1:0] wrmapb_out = (swrite && (swrradr == vwrradrb_out)) ? sdin :
//				      wrmapb_vld[SRAM_DELAY-1] ? wrmapb_reg[SRAM_DELAY-1] : sdoutwb_reg;
//  wire [WIDTH-1:0]       wrdatb_out = (cwrite && (cwrradr == vwrradrb_out)) ? cdin :
//				      wrdatb_vld[SRAM_DELAY-1] ? wrdatb_reg[SRAM_DELAY-1] : cdoutwb_reg;

  reg               swrold_vld_tmp [0:2*NUMWRPT-1];
  reg [BITVBNK-1:0] swrold_map_tmp [0:2*NUMWRPT-1];
  reg [WIDTH-1:0]   swrold_din_tmp [0:2*NUMWRPT-1];
  reg               swrnew_vld_tmp [0:2*NUMWRPT-1];
  reg [BITVBNK-1:0] swrnew_map_tmp [0:2*NUMWRPT-1];
  reg [BITVROW-1:0] swrnew_row_tmp [0:2*NUMWRPT-1];
  reg [WIDTH-1:0]   swrnew_din_tmp [0:2*NUMWRPT-1];
  integer snew_tmp_int;
  always_comb
    for (snew_tmp_int=0; snew_tmp_int<2*NUMWRPT; snew_tmp_int=snew_tmp_int+1) begin
      swrold_vld_tmp[snew_tmp_int] = vwrite_out[snew_tmp_int] && wrmap_out[snew_tmp_int][BITVBNK];
      swrold_map_tmp[snew_tmp_int] = wrmap_out[snew_tmp_int][BITVBNK-1:0];
      swrold_din_tmp[snew_tmp_int] = wcdat_out[snew_tmp_int];
      swrnew_vld_tmp[snew_tmp_int] = vwrite_out[snew_tmp_int];
      swrnew_map_tmp[snew_tmp_int] = vwrbadr_out[snew_tmp_int];
      swrnew_row_tmp[snew_tmp_int] = vwrradr_out[snew_tmp_int];
      swrnew_din_tmp[snew_tmp_int] = vdin_out[snew_tmp_int];
    end

  reg swrnew_row_eq_0_1, swrnew_row_eq_0_2, swrnew_row_eq_0_3;
  reg swrnew_row_eq_1_2, swrnew_row_eq_1_3;
  reg swrnew_map_eq_0_1;
  reg swrnew_map_eq_2_3;
  always @(posedge clk) begin
    swrnew_row_eq_0_1 <= (vwrradr_reg[0][SRAM_DELAY-1] == vwrradr_reg[1][SRAM_DELAY-1]);
    swrnew_row_eq_0_2 <= (vwrradr_reg[0][SRAM_DELAY-1] == vwrradr_reg[2][SRAM_DELAY-1]);
    swrnew_row_eq_0_3 <= (vwrradr_reg[0][SRAM_DELAY-1] == vwrradr_reg[3][SRAM_DELAY-1]);
    swrnew_row_eq_1_2 <= (vwrradr_reg[1][SRAM_DELAY-1] == vwrradr_reg[2][SRAM_DELAY-1]);
    swrnew_row_eq_1_3 <= (vwrradr_reg[1][SRAM_DELAY-1] == vwrradr_reg[3][SRAM_DELAY-1]);
    swrnew_map_eq_0_1 <= (vwrbadr_reg[0][SRAM_DELAY-1] == vwrbadr_reg[1][SRAM_DELAY-1]);
    swrnew_map_eq_2_3 <= (vwrbadr_reg[2][SRAM_DELAY-1] == vwrbadr_reg[3][SRAM_DELAY-1]);
  end

  wire samerow_0_1 = swrnew_vld_tmp[0] && swrnew_vld_tmp[1] && swrnew_row_eq_0_1;
  wire samerow_0_2 = swrnew_vld_tmp[0] && swrnew_vld_tmp[2] && swrnew_row_eq_0_2;
  wire samerow_0_3 = swrnew_vld_tmp[0] && swrnew_vld_tmp[3] && swrnew_row_eq_0_3;
  wire samerow_1_2 = swrnew_vld_tmp[1] && swrnew_vld_tmp[2] && swrnew_row_eq_1_2;
  wire samerow_1_3 = swrnew_vld_tmp[1] && swrnew_vld_tmp[3] && swrnew_row_eq_1_3;
  wire samemap_0_1 = swrnew_vld_tmp[0] && swrnew_vld_tmp[1] && swrnew_map_eq_0_1;
  wire samemap_2_3 = swrnew_vld_tmp[2] && swrnew_vld_tmp[3] && swrnew_map_eq_2_3;

/*
  wire samerow_0_1 = swrnew_vld_tmp[0] && swrnew_vld_tmp[1] && (swrnew_row_tmp[0] == swrnew_row_tmp[1]);
  wire samerow_0_2 = swrnew_vld_tmp[0] && swrnew_vld_tmp[2] && (swrnew_row_tmp[0] == swrnew_row_tmp[2]);
  wire samerow_0_3 = swrnew_vld_tmp[0] && swrnew_vld_tmp[3] && (swrnew_row_tmp[0] == swrnew_row_tmp[3]);
  wire samerow_1_2 = swrnew_vld_tmp[1] && swrnew_vld_tmp[2] && (swrnew_row_tmp[1] == swrnew_row_tmp[2]);
  wire samerow_1_3 = swrnew_vld_tmp[1] && swrnew_vld_tmp[3] && (swrnew_row_tmp[1] == swrnew_row_tmp[3]);
  wire samemap_0_1 = swrnew_vld_tmp[0] && swrnew_vld_tmp[1] && (swrnew_map_tmp[0] == swrnew_map_tmp[1]);
  wire samemap_2_3 = swrnew_vld_tmp[2] && swrnew_vld_tmp[3] && (swrnew_map_tmp[2] == swrnew_map_tmp[3]);
*/

  reg [1:0] snew_map [0:2*NUMWRPT-1];
  always_comb
    if (samerow_0_1 && samerow_0_3 && samemap_2_3) begin
      snew_map[0] = 0;
      snew_map[1] = 3;
      snew_map[2] = 2;
      snew_map[3] = 1;
    end else if (samerow_0_1) begin
      snew_map[0] = 0;
      snew_map[1] = 1;
      snew_map[2] = 2;
      snew_map[3] = 3;
    end else if (samerow_0_2 && samerow_0_3) begin
      snew_map[0] = 0;
      snew_map[1] = 2;
      snew_map[2] = 3;
      snew_map[3] = 1;
    end else if (samerow_0_2) begin
      snew_map[0] = 0;
      snew_map[1] = 2;
      snew_map[2] = 1;
      snew_map[3] = 3;
    end else if (samerow_1_2 && samerow_1_3 && samemap_0_1) begin
      snew_map[0] = 0;
      snew_map[1] = 2;
      snew_map[2] = 1;
      snew_map[3] = 3;
    end else if (samerow_0_3) begin
      snew_map[0] = 0;
      snew_map[1] = 3;
      snew_map[2] = 2;
      snew_map[3] = 1;
    end else if (samerow_1_2 && !samerow_1_3) begin
      snew_map[0] = 1;
      snew_map[1] = 2;
      snew_map[2] = 0;
      snew_map[3] = 3;
    end else if (samerow_1_3 && samemap_0_1 && samemap_2_3) begin
      snew_map[0] = 0;
      snew_map[1] = 3;
      snew_map[2] = 2;
      snew_map[3] = 1;
    end else begin
      snew_map[0] = 0;
      snew_map[1] = 1;
      snew_map[2] = 2;
      snew_map[3] = 3;
    end

  reg               swrold_vld [0:2*NUMWRPT-1];
  reg [BITVBNK-1:0] swrold_map [0:2*NUMWRPT-1];
  reg [WIDTH-1:0]   swrold_din [0:2*NUMWRPT-1];
  reg               swrnew_vld [0:2*NUMWRPT-1];
  reg [BITVBNK-1:0] swrnew_map [0:2*NUMWRPT-1];
  reg [BITVROW-1:0] swrnew_row [0:2*NUMWRPT-1];
  reg [WIDTH-1:0]   swrnew_din [0:2*NUMWRPT-1];
  integer snew_int;
  always_comb
    for (snew_int=0; snew_int<2*NUMWRPT; snew_int=snew_int+1) begin
      swrold_vld[snew_int] = swrold_vld_tmp[snew_map[snew_int]];
      swrold_map[snew_int] = swrold_map_tmp[snew_map[snew_int]];
      swrold_din[snew_int] = swrold_din_tmp[snew_map[snew_int]];
      swrnew_vld[snew_int] = swrnew_vld_tmp[snew_map[snew_int]];
      swrnew_map[snew_int] = swrnew_map_tmp[snew_map[snew_int]];
      swrnew_row[snew_int] = swrnew_row_tmp[snew_map[snew_int]];
      swrnew_din[snew_int] = swrnew_din_tmp[snew_map[snew_int]];
    end

  wire swrold_vld_0 = swrold_vld[0];
  wire [BITVBNK-1:0] swrold_map_0 = swrold_map[0];
  wire swrnew_vld_0 = swrnew_vld[0];
  wire [BITVBNK-1:0] swrnew_map_0 = swrnew_map[0];
  wire [BITVROW-1:0] swrnew_row_0 = swrnew_row[0];
  wire [WIDTH-1:0] swrnew_din_0 = swrnew_din[0];
  wire swrold_vld_1 = swrold_vld[1];
  wire [BITVBNK-1:0] swrold_map_1 = swrold_map[1];
  wire swrnew_vld_1 = swrnew_vld[1];
  wire [BITVBNK-1:0] swrnew_map_1 = swrnew_map[1];
  wire [BITVROW-1:0] swrnew_row_1 = swrnew_row[1];
  wire [WIDTH-1:0] swrnew_din_1 = swrnew_din[1];
  wire swrold_vld_2 = swrold_vld[2];
  wire [BITVBNK-1:0] swrold_map_2 = swrold_map[2];
  wire swrnew_vld_2 = swrnew_vld[2];
  wire [BITVBNK-1:0] swrnew_map_2 = swrnew_map[2];
  wire [BITVROW-1:0] swrnew_row_2 = swrnew_row[2];
  wire [WIDTH-1:0] swrnew_din_2 = swrnew_din[2];
  wire swrold_vld_3 = swrold_vld[3];
  wire [BITVBNK-1:0] swrold_map_3 = swrold_map[3];
  wire swrnew_vld_3 = swrnew_vld[3];
  wire [BITVBNK-1:0] swrnew_map_3 = swrnew_map[3];
  wire [BITVROW-1:0] swrnew_row_3 = swrnew_row[3];
  wire [WIDTH-1:0] swrnew_din_3 = swrnew_din[3];
/*
  wire               swrolda_vld = vwritea_out && wrmapa_out[BITVBNK];
  wire [BITVBNK-1:0] swrolda_map = wrmapa_out[BITVBNK-1:0];
  wire               swrnewa_vld = vwritea_out;
  wire [BITVBNK-1:0] swrnewa_map = vwrbadra_out;

  wire               swroldb_vld = vwriteb_out && wrmapb_out[BITVBNK];
  wire [BITVBNK-1:0] swroldb_map = wrmapb_out[BITVBNK-1:0];
  wire               swrnewb_vld = vwriteb_out;
  wire [BITVBNK-1:0] swrnewb_map = vwrbadrb_out;
*/

  // Write request to pivoted banks
  reg write_new_a_to_cache [0:NUMWRPT-1];
  reg write_new_a_to_pivot [0:NUMWRPT-1];
  reg update_a_to_invalid [0:NUMWRPT-1]; 

  reg write_old_b_to_pivot [0:NUMWRPT-1];
  reg write_new_b_to_pivot [0:NUMWRPT-1];
  reg write_new_b_to_cache [0:NUMWRPT-1];
  reg update_b_to_invalid [0:NUMWRPT-1];
  reg update_b_to_new [0:NUMWRPT-1];

  integer warb_int;
  always_comb
    for (warb_int=0; warb_int<NUMWRPT; warb_int=warb_int+1) begin
      if (warb_int>0) begin
        write_new_a_to_cache[warb_int] = (swrold_vld[2*warb_int] && swrnew_vld[2*warb_int] && (swrold_map[2*warb_int] == swrnew_map[2*warb_int]));
        write_new_a_to_pivot[warb_int] = swrnew_vld[2*warb_int] && !write_new_a_to_cache[warb_int];
        update_a_to_invalid[warb_int] = 1'b0;
      end else begin
        write_new_a_to_cache[warb_int] = swrold_vld[2*warb_int] && swrnew_vld[2*warb_int] && (swrold_map[2*warb_int] == swrnew_map[2*warb_int]);
        write_new_a_to_pivot[warb_int] = swrnew_vld[2*warb_int] && !write_new_a_to_cache[warb_int];
        update_a_to_invalid[warb_int] = 1'b0;
      end
      if (write_new_a_to_cache[warb_int]) begin
        write_new_b_to_cache[warb_int] = 1'b0;
        write_new_b_to_pivot[warb_int] = swrnew_vld[2*warb_int+1];
        update_b_to_new[warb_int] = 1'b0;
        if (warb_int==0) 
          update_b_to_invalid[warb_int] = swrnew_vld[2*warb_int+1] && swrold_vld[2*warb_int+1] && (swrold_map[2*warb_int+1] == swrnew_map[2*warb_int+1]);
        else
          update_b_to_invalid[warb_int] = swrnew_vld[2*warb_int+1] && swrold_vld[2*warb_int+1] && (swrold_map[2*warb_int+1] == swrnew_map[2*warb_int+1]) &&
                                          !(update_b_to_new[warb_int-1] && (swrnew_row[2*(warb_int-1)+1] == swrnew_row[2*warb_int+1]));
        write_old_b_to_pivot[warb_int] = 1'b0;
      end else if (swrnew_vld[2*warb_int] && swrnew_vld[2*warb_int+1] && (swrnew_map[2*warb_int] == swrnew_map[2*warb_int+1])) begin
        write_new_b_to_cache[warb_int] = 1'b1;
        write_new_b_to_pivot[warb_int] = 1'b0;
        update_b_to_new[warb_int] = 1'b1;
        update_b_to_invalid[warb_int] = 1'b0;
        if (warb_int==0)
          write_old_b_to_pivot[warb_int] = swrold_vld[2*warb_int+1] && (swrold_map[2*warb_int+1] != swrnew_map[2*warb_int+1]) &&
                                           !(swrnew_vld[2*warb_int+2] && (swrold_map[2*warb_int+1] == swrnew_map[2*warb_int+2]) &&
                                                                         (swrnew_row[2*warb_int+1] == swrnew_row[2*warb_int+2])) &&
                                           !(swrnew_vld[2*warb_int+3] && (swrold_map[2*warb_int+1] == swrnew_map[2*warb_int+3]) &&
                                                                         (swrnew_row[2*warb_int+1] == swrnew_row[2*warb_int+3]));
        else
          write_old_b_to_pivot[warb_int] = swrold_vld[2*warb_int+1] && (swrold_map[2*warb_int+1] != swrnew_map[2*warb_int+1]) &&
                                           !(swrnew_vld[2*warb_int-1] && (swrnew_map[2*warb_int-1] == swrold_map[2*warb_int+1]) &&
                                                                         (swrnew_row[2*warb_int-1] == swrnew_row[2*warb_int+1]));
      end else begin
        write_new_b_to_cache[warb_int] = 1'b0;
        write_new_b_to_pivot[warb_int] = swrnew_vld[2*warb_int+1];
        update_b_to_new[warb_int] = 1'b0;
        if (warb_int==0)
          update_b_to_invalid[warb_int] = swrnew_vld[2*warb_int+1] && swrold_vld[2*warb_int+1] && (swrold_map[2*warb_int+1] == swrnew_map[2*warb_int+1]);
        else
          update_b_to_invalid[warb_int] = swrnew_vld[2*warb_int+1] && swrold_vld[2*warb_int+1] && (swrold_map[2*warb_int+1] == swrnew_map[2*warb_int+1]) &&
                                          !(update_b_to_new[warb_int-1] && (swrnew_row[2*(warb_int-1)+1] == swrnew_row[2*warb_int+1]));
        write_old_b_to_pivot[warb_int] = 1'b0;
      end
    end
/* 
  wire write_new_a_to_cache = swrolda_vld && swrnewa_vld && (swrolda_map == swrnewa_map);
  wire write_new_a_to_pivot = swrnewa_vld && !write_new_a_to_cache;

  always_comb
    if (write_new_a_to_cache) begin
      write_new_b_to_cache = 1'b0;
      write_new_b_to_pivot = swrnewb_vld;
      update_b_to_new = 1'b0;
      update_b_to_invalid = swrnewb_vld && swroldb_vld && (swroldb_map == swrnewb_map);
      write_old_b_to_pivot = 1'b0;
    end else if (swrnewa_vld && swrnewb_vld && (swrnewa_map == swrnewb_map)) begin
      write_new_b_to_cache = 1'b1;
      write_new_b_to_pivot = 1'b0;
      update_b_to_new = 1'b1;
      update_b_to_invalid = 1'b0;
      write_old_b_to_pivot = swroldb_vld && (swroldb_map != swrnewb_map);
    end else begin
      write_new_b_to_cache = 1'b0;
      write_new_b_to_pivot = swrnewb_vld;
      update_b_to_new = 1'b0;
      update_b_to_invalid = swrnewb_vld && swroldb_vld && (swroldb_map == swrnewb_map);
      write_old_b_to_pivot = 1'b0;
    end
*/
/*
  always @(posedge clk)
    if (rstvld) begin
      cwrite <= 1'b1;
      cwrradr <= rstaddr;
      cdin <= 0;
    end else if (write_new_a_to_cache) begin
      cwrite <= 1'b1;
      cwrradr <= vwrradra_out;
      cdin <= vdina_out;
    end else begin
      cwrite <= write_new_b_to_cache;
      cwrradr <= vwrradrb_out;
      cdin <= vdinb_out;
    end
*/
  wire write_new_a_to_cache_0 = write_new_a_to_cache[0];
  wire write_new_a_to_pivot_0 = write_new_a_to_pivot[0];
  wire update_a_to_invalid_0 = update_a_to_invalid[0];

  wire write_old_b_to_pivot_0 = write_old_b_to_pivot[0];
  wire write_new_b_to_pivot_0 = write_new_b_to_pivot[0];
  wire write_new_b_to_cache_0 = write_new_b_to_cache[0];
  wire update_b_to_invalid_0 = update_b_to_invalid[0];
  wire update_b_to_new_0 = update_b_to_new[0];

  wire write_new_a_to_cache_1 = write_new_a_to_cache[1];
  wire write_new_a_to_pivot_1 = write_new_a_to_pivot[1];
  wire update_a_to_invalid_1 = update_a_to_invalid[1];

  wire write_old_b_to_pivot_1 = write_old_b_to_pivot[1];
  wire write_new_b_to_pivot_1 = write_new_b_to_pivot[1];
  wire write_new_b_to_cache_1 = write_new_b_to_cache[1];
  wire update_b_to_invalid_1 = update_b_to_invalid[1];
  wire update_b_to_new_1 = update_b_to_new[1];

  integer cwr_int; 
  always_comb begin
    for (cwr_int=0; cwr_int<NUMWRPT; cwr_int=cwr_int+1)
      if (rstvld) begin
        cwrite_wire[cwr_int] = (cwr_int==0) && !rst;
        cwrradr_wire[cwr_int] = rstaddr;
        cdin_wire[cwr_int] = 0;
      end else if (write_new_a_to_cache[cwr_int]) begin
        cwrite_wire[cwr_int] = 1'b1;
        cwrradr_wire[cwr_int] = swrnew_row[2*cwr_int];
        cdin_wire[cwr_int] = swrnew_din[2*cwr_int];
      end else begin
        cwrite_wire[cwr_int] = write_new_b_to_cache[cwr_int];
        cwrradr_wire[cwr_int] = swrnew_row[2*cwr_int+1];
        cdin_wire[cwr_int] = swrnew_din[2*cwr_int+1];
      end
    if (cwrite_wire[1] && (cwrradr_wire[0] == cwrradr_wire[1]))
      cwrite_wire[0] = 1'b0;
  end
/*        
  always_comb
    if (rstvld) begin
      cwrite = 1'b1;
      cwrradr = rstaddr;
      cdin = 0;
    end else if (write_new_a_to_cache) begin
      cwrite = 1'b1;
      cwrradr = vwrradra_out;
      cdin = vdina_out;
    end else begin
      cwrite = write_new_b_to_cache;
      cwrradr = vwrradrb_out;
      cdin = vdinb_out;
    end
*/
/*
  always @(posedge clk)
    if (rstvld) begin
      swrite <= 1'b1;
      swrradr <= rstaddr;
      sdin_pre_ecc <= 0;
    end else if (update_b_to_invalid) begin
      swrite <= 1'b1;
      swrradr <= vwrradrb_out;
      sdin_pre_ecc <= 0;
    end else if (update_b_to_new) begin
      swrite <= 1'b1;
      swrradr <= vwrradrb_out;
      sdin_pre_ecc <= {swrnewb_vld,swrnewb_map};
    end else begin
      swrite <= 1'b0;
      swrradr <= vwrradrb_out;
      sdin_pre_ecc <= 0;
    end
*/
  integer swr_int;
  always_comb begin
    for (swr_int=0; swr_int<NUMWRPT; swr_int=swr_int+1)
      if (rstvld) begin
        swrite_wire[swr_int] = (swr_int==0) && !rst;
        swrradr_wire[swr_int] = rstaddr;
        sdin_pre_ecc[swr_int] = 0;
      end else if (update_a_to_invalid[swr_int]) begin
        swrite_wire[swr_int] = 1'b1;
        swrradr_wire[swr_int] = swrnew_row[2*swr_int];
        sdin_pre_ecc[swr_int] = 0;
      end else if (update_b_to_invalid[swr_int]) begin
        swrite_wire[swr_int] = 1'b1;
        swrradr_wire[swr_int] = swrnew_row[2*swr_int+1];
        sdin_pre_ecc[swr_int] = 0;
      end else if (update_b_to_new[swr_int]) begin
        swrite_wire[swr_int] = 1'b1;
        swrradr_wire[swr_int] = swrnew_row[2*swr_int+1];
        sdin_pre_ecc[swr_int] = {swrnew_vld[2*swr_int+1],swrnew_map[2*swr_int+1]};
      end else begin
        swrite_wire[swr_int] = 1'b0;
        swrradr_wire[swr_int] = swrnew_row[2*swr_int+1];
        sdin_pre_ecc[swr_int] = 0;
      end
    if (swrite_wire[1] && (swrradr_wire[0] == swrradr_wire[1]))
      swrite_wire[0] = 1'b0;
  end     
/*
  always_comb
    if (rstvld) begin
      swrite = 1'b1;
      swrradr = rstaddr;
      sdin_pre_ecc = 0;
    end else if (update_b_to_invalid) begin
      swrite = 1'b1;
      swrradr = vwrradrb_out;
      sdin_pre_ecc = 0;
    end else if (update_b_to_new) begin
      swrite = 1'b1;
      swrradr = vwrradrb_out;
      sdin_pre_ecc = {swrnewb_vld,swrnewb_map};
    end else begin
      swrite = 1'b0;
      swrradr = vwrradrb_out;
      sdin_pre_ecc = 0;
    end
*/
/*
  always @(posedge clk)
    if (write_new_a_to_pivot) begin
      pwritea <= 1'b1;
      pwrbadra <= vwrbadra_out;
      pwrradra <= vwrradra_out;
      pdina <= vdina_out;
      pwriteb <= write_new_b_to_pivot || write_old_b_to_pivot;
      pwrbadrb <= write_new_b_to_pivot ? vwrbadrb_out : swroldb_map;
      pwrradrb <= vwrradrb_out;
      pdinb <= write_new_b_to_pivot ? vdinb_out : wrdatb_out;
    end else begin
      pwritea <= write_new_b_to_pivot;
      pwrbadra <= vwrbadrb_out;
      pwrradra <= vwrradrb_out;
      pdina <= vdinb_out;
      pwriteb <= write_old_b_to_pivot;
      pwrbadrb <= swroldb_map;
      pwrradrb <= vwrradrb_out;
      pdinb <= wrdatb_out;
    end
*/
  integer pwr_int;
  always_comb
    for (pwr_int=0; pwr_int<NUMWRPT; pwr_int=pwr_int+1)
      if (write_new_a_to_pivot[pwr_int]) begin
        pwrite_wire[2*pwr_int] = 1'b1;
        pwrbadr_wire[2*pwr_int] = swrnew_map[2*pwr_int];
        pwrradr_wire[2*pwr_int] = swrnew_row[2*pwr_int];
        pdin_wire[2*pwr_int] = swrnew_din[2*pwr_int];
        pwrite_wire[2*pwr_int+1] = write_new_b_to_pivot[pwr_int] || write_old_b_to_pivot[pwr_int];
        pwrbadr_wire[2*pwr_int+1] = write_new_b_to_pivot[pwr_int] ? swrnew_map[2*pwr_int+1] : swrold_map[2*pwr_int+1];
        pwrradr_wire[2*pwr_int+1] = swrnew_row[2*pwr_int+1];
        pdin_wire[2*pwr_int+1] = write_new_b_to_pivot[pwr_int] ? swrnew_din[2*pwr_int+1] : swrold_din[2*pwr_int+1];
      end else begin
        pwrite_wire[2*pwr_int] = write_new_b_to_pivot[pwr_int];
        pwrbadr_wire[2*pwr_int] = swrnew_map[2*pwr_int+1];
        pwrradr_wire[2*pwr_int] = swrnew_row[2*pwr_int+1];
        pdin_wire[2*pwr_int] = swrnew_din[2*pwr_int+1];
        pwrite_wire[2*pwr_int+1] = write_old_b_to_pivot[pwr_int];
        pwrbadr_wire[2*pwr_int+1] = swrold_map[2*pwr_int+1];
        pwrradr_wire[2*pwr_int+1] = swrnew_row[2*pwr_int+1];
        pdin_wire[2*pwr_int+1] = swrold_din[2*pwr_int+1];
      end
/* 
  always_comb
    if (write_new_a_to_pivot) begin
      pwritea = 1'b1;
      pwrbadra = vwrbadra_out;
      pwrradra = vwrradra_out;
      pdina = vdina_out;
      pwriteb = write_new_b_to_pivot || write_old_b_to_pivot;
      pwrbadrb = write_new_b_to_pivot ? vwrbadrb_out : swroldb_map;
      pwrradrb = vwrradrb_out;
      pdinb = write_new_b_to_pivot ? vdinb_out : wrdatb_out;
    end else begin
      pwritea = write_new_b_to_pivot;
      pwrbadra = vwrbadrb_out;
      pwrradra = vwrradrb_out;
      pdina = vdinb_out;
      pwriteb = write_old_b_to_pivot;
      pwrbadrb = swroldb_map;
      pwrradrb = vwrradrb_out;
      pdinb = wrdatb_out;
    end

  reg [2-1:0] pwrite;
  reg [2*BITVBNK-1:0] pwrbadr;
  reg [2*BITVROW-1:0] pwrradr;
  reg [2*WIDTH-1:0] pdin;
  integer pwr_int;
  always_comb begin
    pwrite = pwritea;
    pwrbadr = pwrbadra;
    pwrradr = pwrradra;
    pdin = pdina;
    pwrite = pwrite | (pwriteb << 1);
    pwrbadr = pwrbadr | (pwrbadrb << BITVBNK);
    pwrradr = pwrradr | (pwrradrb << BITVROW);
    pdin = pdin | (pdinb << WIDTH);
  end
*/
  reg [NUMWRPT*NUMVBNK-1:0] t1_writeA;
  reg [NUMWRPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  reg [NUMWRPT*NUMVBNK*WIDTH-1:0] t1_dinA;
  integer t1wp_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (t1wp_int=0; t1wp_int<NUMWRPT; t1wp_int=t1wp_int+1) begin
      if (pwrite_wire[2*t1wp_int] && (pwrbadr_wire[2*t1wp_int]<NUMVBNK)) begin
        t1_writeA = t1_writeA | (1'b1 << (NUMWRPT*pwrbadr_wire[2*t1wp_int]+t1wp_int));
        t1_addrA = t1_addrA | (pwrradr_wire[2*t1wp_int] << ((NUMWRPT*pwrbadr_wire[2*t1wp_int]+t1wp_int)*BITVROW));
        t1_dinA = t1_dinA | (pdin_wire[2*t1wp_int] << ((NUMWRPT*pwrbadr_wire[2*t1wp_int]+t1wp_int)*WIDTH));
      end
      if (pwrite_wire[2*t1wp_int+1] && (pwrbadr_wire[2*t1wp_int+1]<NUMVBNK)) begin
        t1_writeA = t1_writeA | (1'b1 << (NUMWRPT*pwrbadr_wire[2*t1wp_int+1]+t1wp_int));
        t1_addrA = t1_addrA | (pwrradr_wire[2*t1wp_int+1] << ((NUMWRPT*pwrbadr_wire[2*t1wp_int+1]+t1wp_int)*BITVROW));
        t1_dinA = t1_dinA | (pdin_wire[2*t1wp_int+1] << ((NUMWRPT*pwrbadr_wire[2*t1wp_int+1]+t1wp_int)*WIDTH));
      end
    end
  end

  reg [NUMWRPT-1:0] t2_writeA;
  reg [NUMWRPT*BITVROW-1:0] t2_addrA;
  reg [NUMWRPT*WIDTH-1:0] t2_dinA;
  integer t2wp_int;
  always_comb begin
    t2_writeA = 0;
    t2_addrA = 0;
    t2_dinA = 0;
    for (t2wp_int=0; t2wp_int<NUMWRPT; t2wp_int=t2wp_int+1)
      if (cwrite_wire[t2wp_int]) begin
        t2_writeA = t2_writeA | (1'b1 << t2wp_int);
        t2_addrA = t2_addrA | (cwrradr_wire[t2wp_int] << (t2wp_int*BITVROW));
        t2_dinA = t2_dinA | (cdin_wire[t2wp_int] << (t2wp_int*WIDTH));
      end
  end

  reg [NUMWRPT-1:0] t3_writeA;
  reg [NUMWRPT*BITVROW-1:0] t3_addrA;
  reg [NUMWRPT*SDOUT_WIDTH-1:0] t3_dinA;
  integer t3wp_int;
  always_comb begin
    t3_writeA = 0;
    t3_addrA = 0;
    t3_dinA = 0;
    for (t3wp_int=0; t3wp_int<NUMWRPT; t3wp_int=t3wp_int+1)
      if (swrite_wire[t3wp_int]) begin
        t3_writeA = t3_writeA | (1'b1 << t3wp_int);
        t3_addrA = t3_addrA | (swrradr_wire[t3wp_int] << (t3wp_int*BITVROW));
        t3_dinA = t3_dinA | (sdin_wire[t3wp_int] << (t3wp_int*SDOUT_WIDTH));
      end
  end

endmodule


