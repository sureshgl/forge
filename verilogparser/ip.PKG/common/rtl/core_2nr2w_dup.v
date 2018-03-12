module core_2nr2w_dup (vwrite, vwraddr, vdin,
                       vread, vrdaddr, vread_vld, vdout, vread_serr, vread_derr, vread_padr,
                       pwrite, pwrradr, pdin, pread, prdradr, pdout, pdout_serr, pdout_derr, pdout_padr,
	               ready, clk, rst);
 
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 2;
  parameter BITADDR = 13;
  parameter NUMADDR = 8192;
  parameter BITVROW = 10;
  parameter NUMVROW = 1024;
  parameter BITVBNK = 3;
  parameter NUMVBNK = 8;
  parameter BITPADR = 14;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input [2-1:0]                        vwrite;
  input [2*BITADDR-1:0]                vwraddr;
  input [2*WIDTH-1:0]                  vdin;
  
  input [2*NUMRDPT-1:0]                vread;
  input [2*NUMRDPT*BITADDR-1:0]        vrdaddr;
  output [2*NUMRDPT-1:0]               vread_vld;
  output [2*NUMRDPT*WIDTH-1:0]         vdout;
  output [2*NUMRDPT-1:0]               vread_serr;
  output [2*NUMRDPT-1:0]               vread_derr;
  output [2*NUMRDPT*BITPADR-1:0]       vread_padr;

  output [2*NUMRDPT*NUMVBNK-1:0]         pwrite;
  output [2*NUMRDPT*NUMVBNK*BITVROW-1:0] pwrradr;
  output [2*NUMRDPT*NUMVBNK*WIDTH-1:0]   pdin;

  output [2*NUMRDPT*NUMVBNK-1:0]         pread;
  output [2*NUMRDPT*NUMVBNK*BITVROW-1:0] prdradr;
  input [2*NUMRDPT*NUMVBNK*WIDTH-1:0]    pdout;
  input [2*NUMRDPT*NUMVBNK-1:0]    pdout_serr;
  input [2*NUMRDPT*NUMVBNK-1:0]    pdout_derr;
  input [2*NUMRDPT*NUMVBNK*(BITPADR-BITVBNK-1)-1:0]    pdout_padr;

  output                               ready;
  input                                clk;
  input                                rst;

  reg ready;
  always @(posedge clk)
    ready <= !rst;

  wire vread_wire [0:2*NUMRDPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:2*NUMRDPT-1];
  wire [BITVBNK-1:0] vrdbadr_wire [0:2*NUMRDPT-1];
  wire [BITVROW-1:0] vrdradr_wire [0:2*NUMRDPT-1];
  wire vwrite_wire [0:2-1];
  wire [BITADDR-1:0] vwraddr_wire [0:2-1];
  wire [WIDTH-1:0] vdin_wire [0:2-1];
  wire [BITVBNK-1:0] vwrbadr_wire [0:2-1];
  wire [BITVROW-1:0] vwrradr_wire [0:2-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [2*NUMRDPT-1:0] vread_reg;
    reg [2*NUMRDPT*BITADDR-1:0] vrdaddr_reg;
    reg [2-1:0] vwrite_reg;
    reg [2*BITADDR-1:0] vwraddr_reg;
    reg [2*WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread & {2{ready}};
      vrdaddr_reg <= vrdaddr;
      vwrite_reg <= vwrite & {2{ready}};
      vwraddr_reg <= vwraddr;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    for (np2_var=0; np2_var<2*NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr_reg >> (np2_var*BITADDR);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end
    for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: wr_loop
      assign vwraddr_wire[np2_var] = vwraddr_reg >> (np2_var*BITADDR);
      assign vwrite_wire[np2_var] = (vwrite_reg >> np2_var) & {2{(vwraddr_wire[np2_var] < NUMADDR)}};
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire[np2_var]), .vradr(vwrradr_wire[np2_var]), .vaddr(vwraddr_wire[np2_var]));
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (np2_var=0; np2_var<2*NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end
    for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: wr_loop
      assign vwraddr_wire[np2_var] = vwraddr >> (np2_var*BITADDR);
      assign vwrite_wire[np2_var] = (vwrite >> np2_var) & {2{(vwraddr_wire[np2_var] < NUMADDR)}};
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire[np2_var]), .vradr(vwrradr_wire[np2_var]), .vaddr(vwraddr_wire[np2_var]));
    end
  end
  endgenerate

  reg                vread_reg [0:2*NUMRDPT-1][0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:2*NUMRDPT-1][0:SRAM_DELAY-1];
  integer vreg_int, vrpt_int;
  always @(posedge clk)
    for (vreg_int=0; vreg_int<SRAM_DELAY; vreg_int=vreg_int+1) 
      if (vreg_int>0) begin
        for (vrpt_int=0; vrpt_int<2*NUMRDPT; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_reg[vrpt_int][vreg_int-1];
          vrdbadr_reg[vrpt_int][vreg_int] <= vrdbadr_reg[vrpt_int][vreg_int-1];
        end
      end else begin
        for (vrpt_int=0; vrpt_int<2*NUMRDPT; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_wire[vrpt_int] && ready;
          vrdbadr_reg[vrpt_int][vreg_int] <= vrdbadr_wire[vrpt_int];
        end
      end

  reg                vread_out [0:2*NUMRDPT-1];
  reg [BITVBNK-1:0]  vrdbadr_out [0:2*NUMRDPT-1];
  integer vdel_int;
  always_comb begin
    for (vdel_int=0; vdel_int<2*NUMRDPT; vdel_int=vdel_int+1) begin
      vread_out[vdel_int] = vread_reg[vdel_int][SRAM_DELAY-1];
      vrdbadr_out[vdel_int] = vrdbadr_reg[vdel_int][SRAM_DELAY-1];
    end
  end

  reg [2*NUMRDPT*NUMVBNK-1:0] pwrite;
  reg [2*NUMRDPT*NUMVBNK*BITVROW-1:0] pwrradr;
  reg [2*NUMRDPT*NUMVBNK*WIDTH-1:0] pdin;
  reg [2*NUMRDPT*NUMVBNK-1:0] pread;
  reg [2*NUMRDPT*NUMVBNK*BITVROW-1:0] prdradr;
  integer prd_int;
  always_comb begin
    pwrite = 0;
    pwrradr = 0;
    pdin = 0;
    pread = 0;
    prdradr = 0;
    for (prd_int=0; prd_int<2*NUMRDPT; prd_int=prd_int+1) begin
      if (vread_wire[prd_int])
        pread = pread | (vread_wire[prd_int] << (vrdbadr_wire[prd_int]*2*NUMRDPT+prd_int));
      prdradr = prdradr | (vrdradr_wire[prd_int] << ((vrdbadr_wire[prd_int]*2*NUMRDPT+prd_int)*BITVROW));
    end
    for (prd_int=0; prd_int<NUMRDPT; prd_int=prd_int+1) begin
      if (vwrite_wire[0])
        pwrite = pwrite | (vwrite_wire[0] << (vwrbadr_wire[0]*2*NUMRDPT+2*prd_int));
      pwrradr = pwrradr | (vwrradr_wire[0] << ((vwrbadr_wire[0]*2*NUMRDPT+2*prd_int)*BITVROW));
      pdin = pdin | (vdin_wire[0] << ((vwrbadr_wire[0]*2*NUMRDPT+2*prd_int)*WIDTH));
      if (vwrite_wire[1])
        pwrite = pwrite | (vwrite_wire[1] << (vwrbadr_wire[1]*2*NUMRDPT+2*prd_int+1));
      pwrradr = pwrradr | (vwrradr_wire[1] << ((vwrbadr_wire[1]*2*NUMRDPT+2*prd_int+1)*BITVROW));
      pdin = pdin | (vdin_wire[1] << ((vwrbadr_wire[1]*2*NUMRDPT+2*prd_int+1)*WIDTH));
    end
  end

  reg               vread_vld_wire [0:2*NUMRDPT-1];
  reg [WIDTH-1:0]   vdout_wire [0:2*NUMRDPT-1];
  reg               vread_serr_wire [0:2*NUMRDPT-1];
  reg               vread_derr_wire [0:2*NUMRDPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:2*NUMRDPT-1];
  reg [BITPADR-BITVBNK-2:0] vread_padr_temp [0:2*NUMRDPT-1];
  integer vrd_int;
  always_comb
    for (vrd_int=0; vrd_int<2*NUMRDPT; vrd_int=vrd_int+1) begin
      vread_vld_wire[vrd_int] = vread_out[vrd_int];
      vdout_wire[vrd_int] = pdout >> ((2*NUMRDPT*vrdbadr_out[vrd_int]+vrd_int)*WIDTH);
      vread_serr_wire[vrd_int] = pdout_serr >> (2*NUMRDPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_derr_wire[vrd_int] = pdout_derr >> (2*NUMRDPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_padr_temp[vrd_int] = pdout_padr >> ((2*NUMRDPT*vrdbadr_out[vrd_int]+vrd_int)*(BITPADR-BITVBNK-1));
      vread_padr_wire[vrd_int] = {vrdbadr_out[vrd_int],vread_padr_temp[vrd_int]};
    end

  reg [2*NUMRDPT-1:0]         vread_vld_tmp;
  reg [2*NUMRDPT*WIDTH-1:0]   vdout_tmp;
  reg [2*NUMRDPT-1:0]         vread_serr_tmp;
  reg [2*NUMRDPT-1:0]         vread_derr_tmp;
  reg [2*NUMRDPT*BITPADR-1:0] vread_padr_tmp;
  integer vwire_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    for (vwire_int=0; vwire_int<2*NUMRDPT; vwire_int=vwire_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_out[vwire_int] << vwire_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vwire_int] << (vwire_int*WIDTH));
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vwire_int] << vwire_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vwire_int] << vwire_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vwire_int] << (vwire_int*BITPADR));
    end
  end

  reg [2*NUMRDPT-1:0]         vread_vld;
  reg [2*NUMRDPT*WIDTH-1:0]   vdout;
  reg [2*NUMRDPT-1:0]         vread_serr;
  reg [2*NUMRDPT-1:0]         vread_derr;
  reg [2*NUMRDPT*BITPADR-1:0] vread_padr;
  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      vread_vld <= vread_vld_tmp;
      vdout <= vdout_tmp;
      vread_serr <= vread_serr_tmp;
      vread_derr <= vread_derr_tmp;
      vread_padr <= vread_padr_tmp;
    end
  end else begin: nflp_loop
    always_comb begin
      vread_vld = vread_vld_tmp;
      vdout = vdout_tmp;
      vread_serr = vread_serr_tmp;
      vread_derr = vread_derr_tmp;
      vread_padr = vread_padr_tmp;
    end
  end
  endgenerate

endmodule



