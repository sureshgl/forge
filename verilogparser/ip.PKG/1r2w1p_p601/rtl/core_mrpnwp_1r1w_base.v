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

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter BITDMUX = 0;

  input [NUMWRPT-1:0]                   vwrite;
  input [NUMWRPT*WIDTH-1:0]             vdin;
  
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
  output [(WIDTH*NUMWRPT)-1:0]   pdin;
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

  wire vread_wire [0:NUMRDPT-1];
  wire vwrite_wire [0:NUMWRPT-1];
  wire [WIDTH-1:0] vdin_wire [0:NUMWRPT-1];

  reg [NUMWRPT-1:0] pwrite;
  reg [(WIDTH*NUMWRPT)-1:0]   pdin;
  integer pwrpo_int, pwba_int, pwra_int,pwd_int;
  always_comb begin
    for (pwrpo_int=0; pwrpo_int<NUMWRPT; pwrpo_int=pwrpo_int+1) begin
      pwrite[pwrpo_int] = vwrite_wire[pwrpo_int];
      for (pwd_int=0; pwd_int<WIDTH; pwd_int=pwd_int+1)
        pdin[pwrpo_int*WIDTH+pwd_int] = vdin_wire[pwrpo_int][pwd_int];
    end
  end
  reg [NUMRDPT-1:0] pread;
  integer prdpo_int, prba_int, prra_int;
  always_comb begin
    for (prdpo_int=0; prdpo_int<NUMRDPT; prdpo_int=prdpo_int+1) begin
      pread[prdpo_int] = vread_wire[prdpo_int];
    end
  end

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg [NUMRDPT-1:0] vread_reg [0:FLOPIN-1];
    reg [NUMWRPT-1:0] vwrite_reg [0:FLOPIN-1];
    reg [NUMWRPT*WIDTH-1:0] vdin_reg [0:FLOPIN-1];
    integer vdelay;
    always @(posedge clk) begin
      for (vdelay=0; vdelay<FLOPIN; vdelay=vdelay+1) begin
        if (vdelay==0) begin
          vread_reg[vdelay] <= vread & {NUMRDPT{ready}};
          vwrite_reg[vdelay] <= vwrite & {NUMWRPT{ready}};
          vdin_reg[vdelay] <= vdin;
        end else begin
          vread_reg[vdelay] <= vread_reg[vdelay-1];
          vwrite_reg[vdelay] <= vwrite_reg[vdelay-1];
          vdin_reg[vdelay] <= vdin_reg[vdelay-1];
        end 
      end
    end

    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_reg[FLOPIN-1] >> np2_var;
    end

    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite_reg[FLOPIN-1] >> np2_var;
      assign vdin_wire[np2_var] = vdin_reg[FLOPIN-1] >> (np2_var*WIDTH);
  
    end
  end else begin: noflpi_loop
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread >> np2_var;
    end 

    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite >> np2_var;
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);
    end 
  end
  endgenerate

  reg                vread_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  integer vreg_int, vrpt_int;
  always @(posedge clk)
    for (vreg_int=0; vreg_int<SRAM_DELAY; vreg_int=vreg_int+1) 
      if (vreg_int>0) begin
        for (vrpt_int=0; vrpt_int<NUMRDPT; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_reg[vrpt_int][vreg_int-1];
        end
      end else begin
        for (vrpt_int=0; vrpt_int<NUMRDPT; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_wire[vrpt_int];
        end
      end

  reg                vread_out [0:NUMRDPT-1];
  integer vdel_int;
  always_comb begin
    for (vdel_int=0; vdel_int<NUMRDPT; vdel_int=vdel_int+1) begin
      vread_out[vdel_int] = vread_reg[vdel_int][SRAM_DELAY-1];
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
      vread_vld_wire[vrd_int] = vread_vld_bus[vrd_int];
      vdout_wire[vrd_int] = t1_doutB >> (vrd_int*WIDTH);
      vread_fwrd_wire[vrd_int] = 1'b0;
      vread_serr_wire[vrd_int] = 1'b0;
      vread_derr_wire[vrd_int] = 1'b0;
      vread_padr_wire[vrd_int] = vread_padr_bus >> (vrd_int*BITPADR);
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
      vread_vld_tmp = vread_vld_tmp | (vread_vld_wire[vwire_int] << vwire_int);
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

  reg [NUMRDPT-1:0]         vread_vld_reg [0:FLOPOUT-1];
  reg [NUMRDPT*WIDTH-1:0]   vdout_reg [0:FLOPOUT-1];
  reg [NUMRDPT-1:0]         vread_fwrd_reg [0:FLOPOUT-1];
  reg [NUMRDPT-1:0]         vread_serr_reg [0:FLOPOUT-1];
  reg [NUMRDPT-1:0]         vread_derr_reg [0:FLOPOUT-1];
  reg [NUMRDPT*BITPADR-1:0] vread_padr_reg [0:FLOPOUT-1];

  generate if (FLOPOUT) begin: flp_loop
    integer vdelay;
    always @(posedge clk)
      for (vdelay=0; vdelay<FLOPOUT; vdelay=vdelay+1) begin
        if (vdelay==0) begin
          vread_vld_reg[vdelay] <= vread_vld_tmp;
          vdout_reg[vdelay] <= vdout_tmp;
          vread_fwrd_reg[vdelay] <= vread_fwrd_tmp;
          vread_serr_reg[vdelay] <= vread_serr_tmp;
          vread_derr_reg[vdelay] <= vread_derr_tmp;
          vread_padr_reg[vdelay] <= vread_padr_tmp;
        end else begin
          vread_vld_reg[vdelay] <= vread_vld_reg[vdelay-1];
          vdout_reg[vdelay] <= vdout_reg[vdelay-1];
          vread_fwrd_reg[vdelay] <= vread_fwrd_reg[vdelay-1];
          vread_serr_reg[vdelay] <= vread_serr_reg[vdelay-1];
          vread_derr_reg[vdelay] <= vread_derr_reg[vdelay-1];
          vread_padr_reg[vdelay] <= vread_padr_reg[vdelay-1];
        end
      end
    assign vread_vld = vread_vld_reg[FLOPOUT-1];
    assign vdout = vdout_reg[FLOPOUT-1];
    assign vread_fwrd = vread_fwrd_reg[FLOPOUT-1];
    assign vread_serr = vread_serr_reg[FLOPOUT-1];
    assign vread_derr = vread_derr_reg[FLOPOUT-1];
    assign vread_padr = vread_padr_reg[FLOPOUT-1];
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



