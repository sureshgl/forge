module core_2ru_2nr2w (vwrite, vaddr, vdin,
                       vread, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                       pwrite, pwrradr, pdin, pread, prdradr, pdout, pdout_fwrd, pdout_serr, pdout_derr, pdout_padr,
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
  input [2*BITADDR-1:0]                vaddr;
  input [2*WIDTH-1:0]                  vdin;
  
  input [2*NUMRDPT-1:0]                vread;
  output [2*NUMRDPT-1:0]               vread_vld;
  output [2*NUMRDPT*WIDTH-1:0]         vdout;
  output [2*NUMRDPT-1:0]               vread_fwrd;
  output [2*NUMRDPT-1:0]               vread_serr;
  output [2*NUMRDPT-1:0]               vread_derr;
  output [2*NUMRDPT*BITPADR-1:0]       vread_padr;

  output [2*NUMRDPT*NUMVBNK-1:0]         pwrite;
  output [2*NUMRDPT*NUMVBNK*BITVROW-1:0] pwrradr;
  output [2*NUMRDPT*NUMVBNK*WIDTH-1:0]   pdin;

  output [2*NUMRDPT*NUMVBNK-1:0]         pread;
  output [2*NUMRDPT*NUMVBNK*BITVROW-1:0] prdradr;
  input [2*NUMRDPT*NUMVBNK*WIDTH-1:0]    pdout;
  input [2*NUMRDPT*NUMVBNK-1:0]          pdout_fwrd;
  input [2*NUMRDPT*NUMVBNK-1:0]    pdout_serr;
  input [2*NUMRDPT*NUMVBNK-1:0]    pdout_derr;
  input [2*NUMRDPT*NUMVBNK*(BITPADR-BITVBNK-1)-1:0]    pdout_padr;

  output                               ready;
  input                                clk;
  input                                rst;

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

  reg [(2*((SRAM_DELAY+FLOPIN+FLOPOUT)*BITADDR)-1):0] vaddr_del;
  always @(posedge clk) begin
    vaddr_del <= {vaddr_del, vaddr};
  end

  wire [2*BITADDR-1:0] vaddr_del_max = vaddr_del >> ((SRAM_DELAY+FLOPIN+FLOPOUT-1)*BITADDR*2);

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
      vrdaddr_reg <= vaddr;
      vwrite_reg <= vwrite & {2{ready}};
      vwraddr_reg <= vaddr_del_max;
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
      assign vrdaddr_wire[np2_var] = vaddr >> (np2_var*BITADDR);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end
    for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: wr_loop
      assign vwraddr_wire[np2_var] = vaddr_del_max >> (np2_var*BITADDR);
      assign vwrite_wire[np2_var] = (vwrite >> np2_var) & {2{(vwraddr_wire[np2_var] < NUMADDR)}};
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire[np2_var]), .vradr(vwrradr_wire[np2_var]), .vaddr(vwraddr_wire[np2_var]));
    end
  end
  endgenerate

  reg                vread_reg [0:2*NUMRDPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:2*NUMRDPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg [BITVROW-1:0]  vrdradr_reg [0:2*NUMRDPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg                vread_fwd [0:2*NUMRDPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg [WIDTH-1:0]    vread_dat [0:2*NUMRDPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg                vread_reg_comb [0:2*NUMRDPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg [BITVBNK-1:0]  vrdbadr_reg_comb [0:2*NUMRDPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg [BITVROW-1:0]  vrdradr_reg_comb [0:2*NUMRDPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg                vread_fwd_comb [0:2*NUMRDPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg [WIDTH-1:0]    vread_dat_comb [0:2*NUMRDPT-1][0:SRAM_DELAY+FLOPOUT-1];
  integer vreg_c_int, vrpt_c_int, vrupt_c_int;
  integer vreg_int, vrpt_int;
  always_comb begin
    for (vreg_c_int=0; vreg_c_int<SRAM_DELAY+FLOPOUT; vreg_c_int=vreg_c_int+1) 
      if (vreg_c_int>0) begin
        for (vrpt_c_int=0; vrpt_c_int<2*NUMRDPT; vrpt_c_int=vrpt_c_int+1) begin 
          vread_reg_comb[vrpt_c_int][vreg_c_int] = vread_reg[vrpt_c_int][vreg_c_int-1];
          vrdbadr_reg_comb[vrpt_c_int][vreg_c_int] = vrdbadr_reg[vrpt_c_int][vreg_c_int-1];
          vrdradr_reg_comb[vrpt_c_int][vreg_c_int] = vrdradr_reg[vrpt_c_int][vreg_c_int-1];
          vread_fwd_comb[vrpt_c_int][vreg_c_int] = vread_fwd[vrpt_c_int][vreg_c_int-1];
          vread_dat_comb[vrpt_c_int][vreg_c_int] = vread_dat[vrpt_c_int][vreg_c_int-1];
          for (vrupt_c_int=0; vrupt_c_int<2; vrupt_c_int=vrupt_c_int+1) begin 
            if (vwrite_wire[vrupt_c_int] && (vwrbadr_wire[vrupt_c_int] == vrdbadr_reg[vrpt_c_int][vreg_c_int-1]) && (vwrradr_wire[vrupt_c_int] == vrdradr_reg[vrpt_c_int][vreg_c_int-1])) begin
              vread_fwd_comb[vrpt_c_int][vreg_c_int] = 1;
              vread_dat_comb[vrpt_c_int][vreg_c_int] = vdin_wire[vrupt_c_int];
            end
          end
        end
      end else begin
        for (vrpt_c_int=0; vrpt_c_int<2*NUMRDPT; vrpt_c_int=vrpt_c_int+1) begin 
          vread_reg_comb[vrpt_c_int][vreg_c_int] = vread_wire[vrpt_c_int] && ready;
          vrdbadr_reg_comb[vrpt_c_int][vreg_c_int] = vrdbadr_wire[vrpt_c_int];
          vrdradr_reg_comb[vrpt_c_int][vreg_c_int] = vrdradr_wire[vrpt_c_int];
          vread_fwd_comb[vrpt_c_int][vreg_c_int] = 0;
          for (vrupt_c_int=0; vrupt_c_int<2; vrupt_c_int=vrupt_c_int+1) begin 
            if (vwrite_wire[vrupt_c_int] && (vwrbadr_wire[vrupt_c_int] == vrdbadr_wire[vrpt_c_int]) && (vwrradr_wire[vrupt_c_int] == vrdradr_wire[vrpt_c_int])) begin
              vread_fwd_comb[vrpt_c_int][vreg_c_int] = 1;
              vread_dat_comb[vrpt_c_int][vreg_c_int] = vdin_wire[vrupt_c_int];;
            end
          end
        end
      end
    end

  always @(posedge clk) begin
    for (vreg_int=0; vreg_int<SRAM_DELAY+FLOPOUT; vreg_int=vreg_int+1) begin
      if (rst) begin
        for (vrpt_int=0; vrpt_int<2*NUMRDPT; vrpt_int=vrpt_int+1)  begin
          vread_reg[vrpt_int][vreg_int]   <= 0;
          vrdbadr_reg[vrpt_int][vreg_int] <= 0;
          vrdradr_reg[vrpt_int][vreg_int] <= 0;
          vread_fwd[vrpt_int][vreg_int]   <= 0;
          vread_dat[vrpt_int][vreg_int]   <= 0;
        end
      end else begin
        for (vrpt_int=0; vrpt_int<2*NUMRDPT; vrpt_int=vrpt_int+1)  begin
          vread_reg[vrpt_int][vreg_int]   <= vread_reg_comb[vrpt_int][vreg_int];
          vrdbadr_reg[vrpt_int][vreg_int] <= vrdbadr_reg_comb[vrpt_int][vreg_int];
          vrdradr_reg[vrpt_int][vreg_int] <= vrdradr_reg_comb[vrpt_int][vreg_int];
          vread_fwd[vrpt_int][vreg_int]   <= vread_fwd_comb[vrpt_int][vreg_int];
          vread_dat[vrpt_int][vreg_int]   <= vread_dat_comb[vrpt_int][vreg_int];
        end
      end
    end
  end
  reg                vread_out [0:2*NUMRDPT-1];
  reg [BITVBNK-1:0]  vrdbadr_out [0:2*NUMRDPT-1];
  reg               vread_fwd_out [0:2*NUMRDPT-1];
  reg [WIDTH-1:0]   vread_dat_out [0:2*NUMRDPT-1]; 
  integer vdel_int;
  always_comb begin
    for (vdel_int=0; vdel_int<2*NUMRDPT; vdel_int=vdel_int+1) begin
      if (FLOPOUT) begin
        vrdbadr_out[vdel_int] = vrdbadr_reg_comb[vdel_int][SRAM_DELAY+FLOPOUT-1];
        vread_fwd_out[vdel_int] = vread_fwd_comb[vdel_int][SRAM_DELAY+FLOPOUT-1];
        vread_out[vdel_int] = vread_reg_comb[vdel_int][SRAM_DELAY+FLOPOUT-1];
        vread_dat_out[vdel_int] = vread_dat_comb[vdel_int][SRAM_DELAY+FLOPOUT-1];
      end else begin
        vrdbadr_out[vdel_int] = vrdbadr_reg[vdel_int][SRAM_DELAY+FLOPOUT-1];
        vread_fwd_out[vdel_int] = vread_fwd[vdel_int][SRAM_DELAY+FLOPOUT-1];
        vread_out[vdel_int] = vread_reg[vdel_int][SRAM_DELAY+FLOPOUT-1];
        vread_dat_out[vdel_int] = vread_dat[vdel_int][SRAM_DELAY+FLOPOUT-1];
      end
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
    if (rstvld && !rst) begin
      pwrite = ~0;
      pwrradr = {2*(NUMRDPT*NUMVBNK){rstaddr[BITVROW-1:0]}};
      pdin = 0;
    end else begin
      for (prd_int=0; prd_int<2*NUMRDPT; prd_int=prd_int+1) begin
        if (vread_wire[prd_int])
          pread = pread | (vread_wire[prd_int] << (vrdbadr_wire[prd_int]*2*NUMRDPT+prd_int));
        prdradr = prdradr | (vrdradr_wire[prd_int] << ((vrdbadr_wire[prd_int]*2*NUMRDPT+prd_int)*BITVROW));
      end
      for (prd_int=0; prd_int<2*NUMRDPT; prd_int=prd_int+1) begin
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
  end

  reg               vread_vld_wire [0:2*NUMRDPT-1];
  reg [WIDTH-1:0]   vdout_wire [0:2*NUMRDPT-1];
  reg               vread_fwrd_wire [0:2*NUMRDPT-1];
  reg               vread_fwrd_help [0:2*NUMRDPT-1];
  reg               vread_serr_wire [0:2*NUMRDPT-1];
  reg               vread_derr_wire [0:2*NUMRDPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:2*NUMRDPT-1];
  reg [BITPADR-BITVBNK-2:0] vread_padr_temp [0:2*NUMRDPT-1];
  integer vrd_int;
  always_comb
    for (vrd_int=0; vrd_int<2*NUMRDPT; vrd_int=vrd_int+1) begin
      vread_vld_wire[vrd_int] = vread_out[vrd_int];
      vdout_wire[vrd_int] = vread_fwd_out[vrd_int] ? vread_dat_out[vrd_int] : pdout >> ((2*NUMRDPT*vrdbadr_out[vrd_int]+vrd_int)*WIDTH);
      vread_fwrd_help[vrd_int] = pdout_fwrd >> (2*NUMRDPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_fwrd_wire[vrd_int] = vread_fwd_out[vrd_int] || vread_fwrd_help[vrd_int];
      vread_serr_wire[vrd_int] = pdout_serr >> (2*NUMRDPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_derr_wire[vrd_int] = pdout_derr >> (2*NUMRDPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_padr_temp[vrd_int] = pdout_padr >> ((2*NUMRDPT*vrdbadr_out[vrd_int]+vrd_int)*(BITPADR-BITVBNK-1));
      vread_padr_wire[vrd_int] = {vrdbadr_out[vrd_int],vread_padr_temp[vrd_int]};
    end

  reg [2*NUMRDPT-1:0]         vread_vld_tmp;
  reg [2*NUMRDPT*WIDTH-1:0]   vdout_tmp;
  reg [2*NUMRDPT-1:0]         vread_fwrd_tmp;
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
      vread_fwrd_tmp = vread_fwrd_tmp | (vread_fwrd_wire[vwire_int] << vwire_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vwire_int] << vwire_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vwire_int] << vwire_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vwire_int] << (vwire_int*BITPADR));
    end
  end

  reg [2*NUMRDPT-1:0]         vread_vld;
  reg [2*NUMRDPT*WIDTH-1:0]   vdout;
  reg [2*NUMRDPT-1:0]         vread_fwrd;
  reg [2*NUMRDPT-1:0]         vread_serr;
  reg [2*NUMRDPT-1:0]         vread_derr;
  reg [2*NUMRDPT*BITPADR-1:0] vread_padr;
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
      vread_serr = vread_serr_tmp;
      vread_derr = vread_derr_tmp;
      vread_padr = vread_padr_tmp;
    end
  end
  endgenerate

//Debug
wire [BITADDR-1:0] vrdaddr_wire_int_0 = vrdaddr_wire [0];
wire [BITADDR-1:0] vrdaddr_wire_int_1 = vrdaddr_wire [1];
wire [BITVBNK-1:0] vrdbadr_wire_int_0 = vrdbadr_wire [0];
wire [BITVBNK-1:0] vrdbadr_wire_int_1 = vrdbadr_wire [1];
wire [BITVROW-1:0] vrdradr_wire_int_0 = vrdradr_wire [0];
wire [BITVROW-1:0] vrdradr_wire_int_1 = vrdradr_wire [1];
wire [BITVBNK-1:0] vwrbadr_wire_int_0 = vwrbadr_wire [0];
wire [BITVBNK-1:0] vwrbadr_wire_int_1 = vwrbadr_wire [1];
wire [BITVROW-1:0] vwrradr_wire_int_0 = vwrradr_wire [0];
wire [BITVROW-1:0] vwrradr_wire_int_1 = vwrradr_wire [1];
wire [WIDTH-1:0]   vdout_wire_int_0   = vdout_wire[0];
wire [WIDTH-1:0]   vdout_wire_int_1   = vdout_wire[1];
wire               vread_fwd_out_int_0= vread_fwd_out [0];
wire               vread_fwd_out_int_1= vread_fwd_out [1];
wire               vread_fwd_if0_int_0= vread_fwd_comb [0][0];
wire               vread_fwd_if1_int_0= vread_fwd_comb [1][0];

wire [WIDTH-1:0]   vread_dat_if0_int_0= vread_dat_comb [0][0];
wire [WIDTH-1:0]   vread_dat_if1_int_0= vread_dat_comb [1][0];

wire [WIDTH-1:0]   vdin_wire_int_0    = vdin_wire [0];
wire [WIDTH-1:0]   vdin_wire_int_1    = vdin_wire [1];
wire               vwrite_wire_int_0  = vwrite_wire[0];
wire               vwrite_wire_int_1  = vwrite_wire[1];
// End Debug

endmodule



