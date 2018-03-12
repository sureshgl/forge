module core_nror1w_dup (vrefr,
                        vwrite, vwraddr, vdin,
                        vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr, 
                        prefr, pwrite, pread, pradr, pdin, pdout, pdout_fwrd, pdout_serr, pdout_derr, pdout_padr,
	                ready, clk, rst);
 
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPADR = 13;

  parameter REFRESH = 0;
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  localparam LBITVBK = BITVBNK>0 ? BITVBNK : 1;

  input                                vrefr;

  input                                vwrite;
  input [BITADDR-1:0]                  vwraddr;
  input [WIDTH-1:0]                    vdin;
  
  input [NUMRDPT-1:0]                  vread;
  input [NUMRDPT*BITADDR-1:0]          vrdaddr;
  output [NUMRDPT-1:0]                 vread_vld;
  output [NUMRDPT*WIDTH-1:0]           vdout;
  output [NUMRDPT-1:0]                 vread_fwrd;
  output [NUMRDPT-1:0]                 vread_serr;
  output [NUMRDPT-1:0]                 vread_derr;
  output [NUMRDPT*BITPADR-1:0]         vread_padr;

  output [NUMRDPT*NUMVBNK-1:0]         prefr;
  output [NUMRDPT*NUMVBNK-1:0]         pwrite;
  output [NUMRDPT*NUMVBNK-1:0]         pread;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] pradr;
  output [NUMRDPT*NUMVBNK*WIDTH-1:0]   pdin;
  input [NUMRDPT*NUMVBNK*WIDTH-1:0]    pdout;
  input [NUMRDPT*NUMVBNK-1:0]          pdout_fwrd;
  input [NUMRDPT*NUMVBNK-1:0]          pdout_serr;
  input [NUMRDPT*NUMVBNK-1:0]          pdout_derr;
  input [NUMRDPT*NUMVBNK*(BITPADR-BITVBNK)-1:0] pdout_padr;

  output                               ready;
  input                                clk;
  input                                rst;

  reg ready;
  always @(posedge clk)
    ready <= !rst;

  wire ready_wire;
  wire vrefr_wire;
  wire vread_wire [0:NUMRDPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMRDPT-1];
  wire [LBITVBK-1:0] vrdbadr_wire [0:NUMRDPT-1];
  wire [BITVROW-1:0] vrdradr_wire [0:NUMRDPT-1];
  wire vwrite_wire;
  wire [BITADDR-1:0] vwraddr_wire;
  wire [WIDTH-1:0] vdin_wire;
  wire [LBITVBK-1:0] vwrbadr_wire;
  wire [BITVROW-1:0] vwrradr_wire;

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg vrefr_reg;
    reg [NUMRDPT-1:0] vread_reg;
    reg [NUMRDPT*BITADDR-1:0] vrdaddr_reg;
    reg vwrite_reg;
    reg [BITADDR-1:0] vwraddr_reg;
    reg [WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vrefr_reg <= vrefr;
      vread_reg <= vread & {NUMRDPT{ready}};
      vrdaddr_reg <= vrdaddr;
      vwrite_reg <= vwrite & ready;
      vwraddr_reg <= vwraddr;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    assign vrefr_wire = vrefr_reg;
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr_reg >> (np2_var*BITADDR);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end

    assign vwraddr_wire = vwraddr_reg;
    assign vwrite_wire = vwrite_reg && (vwraddr_wire < NUMADDR);
    assign vdin_wire = vdin_reg;
  
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
      wr_adr_inst (.vbadr(vwrbadr_wire), .vradr(vwrradr_wire), .vaddr(vwraddr_wire));
  end else begin: noflpi_loop
    assign ready_wire = ready;
    assign vrefr_wire = vrefr;
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end 

    assign vwrite_wire = vwrite && (vwraddr_wire < NUMADDR);
    assign vwraddr_wire = vwraddr;
    assign vdin_wire = vdin;

    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
      wr_adr_inst (.vbadr(vwrbadr_wire), .vradr(vwrradr_wire), .vaddr(vwraddr_wire));
  end
  endgenerate

  reg                vread_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg [LBITVBK-1:0]  vrdbadr_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
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

  assign prefr = {NUMRDPT*NUMVBNK{vrefr_wire}};

  reg [NUMRDPT*NUMVBNK-1:0] pwrite;
  reg [NUMRDPT*NUMVBNK-1:0] pread;
  reg [NUMRDPT*NUMVBNK*BITVROW-1:0] pradr;
  reg [NUMRDPT*NUMVBNK*WIDTH-1:0] pdin;
  integer prd_int;
  always_comb begin
    pwrite = 0;
    pread = 0;
    pradr = 0;
    pdin = 0;
    if (vwrite_wire) begin
      pwrite = {NUMRDPT{1'b1}} << (vwrbadr_wire*NUMRDPT);
      pradr = {NUMRDPT*NUMVBNK{vwrradr_wire}};
      pdin = {NUMRDPT*NUMVBNK{vdin_wire}}; 
    end else begin
      for (prd_int=0; prd_int<NUMRDPT; prd_int=prd_int+1)
	if (vread_wire[prd_int]) begin
          pread = pread | (vread_wire[prd_int] << (vrdbadr_wire[prd_int]*NUMRDPT+prd_int));
          pradr = pradr | (vrdradr_wire[prd_int] << ((vrdbadr_wire[prd_int]*NUMRDPT+prd_int)*BITVROW));
        end
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
      vdout_wire[vrd_int] = pdout >> ((NUMRDPT*vrdbadr_out[vrd_int]+vrd_int)*WIDTH);
      vread_fwrd_wire[vrd_int] = pdout_fwrd >> (NUMRDPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_serr_wire[vrd_int] = pdout_serr >> (NUMRDPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_derr_wire[vrd_int] = pdout_derr >> (NUMRDPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_padr_temp[vrd_int] = pdout_padr >> ((NUMRDPT*vrdbadr_out[vrd_int]+vrd_int)*(BITPADR-BITVBNK));
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



