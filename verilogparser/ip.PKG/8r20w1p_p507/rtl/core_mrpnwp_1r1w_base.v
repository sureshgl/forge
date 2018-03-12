module core_mrpnwp_1r1w_base (vwrite, vdin,
                              vread, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
          		      pwrite, pdin,
			      pread,                              
                              t1_doutB,
			      vread_vld_bus, vread_padr_bus,
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
  parameter WRBUSRED = 1;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter BITDMUX = 0;

  input [NUMWRPT-1:0]                   vwrite;
  input [(4+16/WRBUSRED)*WIDTH-1:0]  vdin;
  
  input [NUMRDPT-1:0]                   vread;
  output [NUMRDPT-1:0]                  vread_vld;
  output [NUMRDPT*WIDTH-1:0]            vdout;
  output [NUMRDPT-1:0]                  vread_fwrd;
  output [NUMRDPT-1:0]                  vread_serr;
  output [NUMRDPT-1:0]                  vread_derr;
  output [NUMRDPT*BITPADR-1:0]          vread_padr;

  input [NUMRDPT*WIDTH-1:0]             t1_doutB;
  input [NUMRDPT-1:0] 			vread_vld_bus;
  input [(BITPADR*NUMRDPT)-1:0] 	vread_padr_bus;

  output [NUMWRPT-1:0] pwrite;
  output [(WIDTH*(4+16/WRBUSRED))-1:0]   pdin;
  output [NUMRDPT-1:0] pread;

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

// FLOPIN part
  reg [NUMWRPT-1:0] pwrite;
  reg [(WIDTH*(4+16/WRBUSRED))-1:0]   pdin;
  reg [NUMRDPT-1:0] pread;

  generate if (FLOPIN) begin: flpi_loop
    always @(posedge clk) begin
      pread <= vread & {NUMRDPT{ready}};
      pwrite <= vwrite & {NUMWRPT{ready}};
      pdin <= vdin;
    end
  end else begin: noflpi_loop
    always_comb begin
      pread = vread & {NUMRDPT{ready}};
      pwrite = vwrite & {NUMWRPT{ready}};
      pdin = vdin;
    end
  end
  endgenerate


// FLOPOUT part
  reg [NUMRDPT-1:0]         vread_vld;
  reg [NUMRDPT*WIDTH-1:0]   vdout;
  reg [NUMRDPT*BITPADR-1:0] vread_padr;

  reg [NUMRDPT-1:0]         vread_fwrd;
  reg [NUMRDPT-1:0]         vread_serr;
  reg [NUMRDPT-1:0]         vread_derr;
  assign vread_serr = {NUMRDPT{1'b0}};
  assign vread_derr = {NUMRDPT{1'b0}};
  assign vread_fwrd = {NUMRDPT{1'b0}};

  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      vread_vld <= vread_vld_bus;
      vdout <= t1_doutB;
      vread_padr <= vread_padr_bus;
    end
  end else begin: nflp_loop
    always_comb begin
      vread_vld = vread_vld_bus;
      vdout = t1_doutB;
      vread_padr = vread_padr_bus;
    end
  end
  endgenerate

endmodule



