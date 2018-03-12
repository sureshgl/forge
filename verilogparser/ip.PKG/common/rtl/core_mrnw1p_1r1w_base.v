module core_mrnw1p_1r1w_base (vwrite, vwraddr, vdin,
                              vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr, 
                              t1_writeA, t1_addrA, t1_dinA,
                              t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
	                      ready, clk, rst);
 
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 2;
  parameter NUMWRPT = 3;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPADR = 13;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input [NUMWRPT-1:0]                   vwrite;
  input [NUMWRPT*BITADDR-1:0]           vwraddr;
  input [NUMWRPT*WIDTH-1:0]             vdin;
  
  input [NUMRDPT-1:0]                   vread;
  input [NUMRDPT*BITADDR-1:0]           vrdaddr;
  output [NUMRDPT-1:0]                  vread_vld;
  output [NUMRDPT*WIDTH-1:0]            vdout;
  output [NUMRDPT-1:0]                  vread_fwrd;
  output [NUMRDPT-1:0]                  vread_serr;
  output [NUMRDPT-1:0]                  vread_derr;
  output [NUMRDPT*BITPADR-1:0]          vread_padr;

  output [NUMVBNK-1:0]                  t1_writeA;
  output [NUMVBNK*BITVROW-1:0]          t1_addrA;
  output [NUMVBNK*WIDTH-1:0]            t1_dinA;

  output [NUMVBNK-1:0]                  t1_readB;
  output [NUMVBNK*BITVROW-1:0]          t1_addrB;
  input [NUMVBNK*WIDTH-1:0]             t1_doutB;
  input [NUMVBNK-1:0]                   t1_fwrdB;
  input [NUMVBNK-1:0]                   t1_serrB;
  input [NUMVBNK-1:0]                   t1_derrB;
  input [NUMVBNK*(BITPADR-BITVBNK)-1:0] t1_padrB;

  output                                ready;
  input                                 clk;
  input                                 rst;

  reg [2:0] rst_reg;
  always @(posedge clk)
    rst_reg <= {rst_reg[1:0],rst};

  wire rst_sync = rst_reg[2];

  reg ready;
  always @(posedge clk)
    ready <= !rst_sync;

  wire vread_wire [0:NUMRDPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMRDPT-1];
  wire [BITVBNK-1:0] vrdbadr_wire [0:NUMRDPT-1];
  wire [BITVROW-1:0] vrdradr_wire [0:NUMRDPT-1];
  wire vwrite_wire [0:NUMWRPT-1];
  wire [BITADDR-1:0] vwraddr_wire [0:NUMWRPT-1];
  wire [BITVBNK-1:0] vwrbadr_wire [0:NUMWRPT-1];
  wire [BITVROW-1:0] vwrradr_wire [0:NUMWRPT-1];
  wire [WIDTH-1:0] vdin_wire [0:NUMWRPT-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg [NUMRDPT-1:0] vread_reg;
    reg [NUMRDPT*BITADDR-1:0] vrdaddr_reg;
    reg [NUMWRPT-1:0] vwrite_reg;
    reg [NUMWRPT*BITADDR-1:0] vwraddr_reg;
    reg [NUMWRPT*WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      vread_reg <= vread & {NUMRDPT{ready}};
      vrdaddr_reg <= vrdaddr;
      vwrite_reg <= vwrite & {NUMWRPT{ready}};
      vwraddr_reg <= vwraddr;
      vdin_reg <= vdin;
    end

    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr_reg >> (np2_var*BITADDR);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end

    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite_reg >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr_reg >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*WIDTH);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire[np2_var]), .vradr(vwrradr_wire[np2_var]), .vaddr(vwraddr_wire[np2_var]));
    end
  end else begin: noflpi_loop
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end 

    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
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

  reg                vread_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  integer vreg_int, vrpt_int;
  always @(posedge clk)
    for (vreg_int=0; vreg_int<SRAM_DELAY; vreg_int=vreg_int+1) 
      if (vreg_int>0) begin
        for (vrpt_int=0; vrpt_int<NUMRDPT; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_reg[vrpt_int][vreg_int-1];
          vrdbadr_reg[vrpt_int][vreg_int] <= vrdbadr_reg[vrpt_int][vreg_int-1];
        end
      end else begin
        for (vrpt_int=0; vrpt_int<NUMRDPT; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_wire[vrpt_int];
          vrdbadr_reg[vrpt_int][vreg_int] <= vrdbadr_wire[vrpt_int];
        end
      end

  reg                vread_out [0:NUMRDPT-1];
  reg [BITVBNK-1:0]  vrdbadr_out [0:NUMRDPT-1];
  integer vdel_int;
  always_comb begin
    for (vdel_int=0; vdel_int<NUMRDPT; vdel_int=vdel_int+1) begin
      vread_out[vdel_int] = vread_reg[vdel_int][SRAM_DELAY-1];
      vrdbadr_out[vdel_int] = vrdbadr_reg[vdel_int][SRAM_DELAY-1];
    end
  end

  reg [NUMVBNK-1:0] t1_writeA;
  reg [NUMVBNK*BITVROW-1:0] t1_addrA;
  reg [NUMVBNK*WIDTH-1:0] t1_dinA;
  reg [NUMVBNK-1:0] t1_readB;
  reg [NUMVBNK*BITVROW-1:0] t1_addrB;
  integer pbnk_int, prtb_int, prtw_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (pbnk_int=0; pbnk_int<NUMVBNK; pbnk_int=pbnk_int+1)
      for (prtb_int=0; prtb_int<NUMWRPT; prtb_int=prtb_int+1)
        if (vwrite_wire[prtb_int] && (vwrbadr_wire[prtb_int]==pbnk_int)) begin
          t1_writeA[pbnk_int] = 1'b1;
          for (prtw_int=0; prtw_int<BITVROW; prtw_int=prtw_int+1)
            t1_addrA[pbnk_int*BITVROW+prtw_int] = vwrradr_wire[prtb_int][prtw_int];
          for (prtw_int=0; prtw_int<WIDTH; prtw_int=prtw_int+1)
            t1_dinA[pbnk_int*WIDTH+prtw_int] = vdin_wire[prtb_int][prtw_int];
        end
    t1_readB = 0;
    t1_addrB = 0;
    for (pbnk_int=0; pbnk_int<NUMVBNK; pbnk_int=pbnk_int+1)
      for (prtb_int=0; prtb_int<NUMRDPT; prtb_int=prtb_int+1)
        if (vread_wire[prtb_int] && (vrdbadr_wire[prtb_int]==pbnk_int)) begin
          t1_readB[pbnk_int] = 1'b1;
          for (prtw_int=0; prtw_int<BITVROW; prtw_int=prtw_int+1)
            t1_addrB[pbnk_int*BITVROW+prtw_int] = vrdradr_wire[prtb_int][prtw_int];
        end
  end

  reg               vread_vld_wire [0:NUMRDPT-1];
  reg [WIDTH-1:0]   vdout_wire [0:NUMRDPT-1];
  reg               vread_fwrd_wire [0:NUMRDPT-1];
  reg               vread_serr_wire [0:NUMRDPT-1];
  reg               vread_derr_wire [0:NUMRDPT-1];
  reg [BITPADR-BITVBNK-1:0] vread_padr_temp [0:NUMRDPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:NUMRDPT-1];
  integer vrd_int;
  always_comb 
    for (vrd_int=0; vrd_int<NUMRDPT; vrd_int=vrd_int+1) begin
      vread_vld_wire[vrd_int] = vread_out[vrd_int];
      vdout_wire[vrd_int] = t1_doutB >> ((NUMRDPT*vrdbadr_out[vrd_int]+vrd_int)*WIDTH);
      vread_fwrd_wire[vrd_int] = t1_fwrdB >> (NUMRDPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_serr_wire[vrd_int] = t1_serrB >> (NUMRDPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_derr_wire[vrd_int] = t1_derrB >> (NUMRDPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_padr_temp[vrd_int] = t1_padrB >> ((NUMRDPT*vrdbadr_out[vrd_int]+vrd_int)*(BITPADR-BITVBNK));
      vread_padr_wire[vrd_int] = {vrdbadr_out[vrd_int],vread_padr_temp[vrd_int]};
    end

  reg [NUMRDPT-1:0]         vread_vld_tmp;
  reg [NUMRDPT*WIDTH-1:0]   vdout_tmp;
  reg [NUMRDPT-1:0]         vread_fwrd_tmp;
  reg [NUMRDPT-1:0]         vread_serr_tmp;
  reg [NUMRDPT-1:0]         vread_derr_tmp;
  reg [NUMRDPT*BITPADR-1:0] vread_padr_tmp;
  integer vwire_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_fwrd_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    for (vwire_int=0; vwire_int<NUMRDPT; vwire_int=vwire_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_out[vwire_int] << vwire_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vwire_int] << (vwire_int*WIDTH));
      vread_fwrd_tmp = vread_fwrd_tmp | (vread_fwrd_wire[vwire_int] << vwire_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vwire_int] << vwire_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vwire_int] << vwire_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vwire_int] << (vwire_int*BITPADR));
    end
  end

  reg [NUMRDPT-1:0]         vread_vld;
  reg [NUMRDPT*WIDTH-1:0]   vdout;
  reg [NUMRDPT-1:0]         vread_fwrd;
  reg [NUMRDPT-1:0]         vread_serr;
  reg [NUMRDPT-1:0]         vread_derr;
  reg [NUMRDPT*BITPADR-1:0] vread_padr;

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

endmodule



