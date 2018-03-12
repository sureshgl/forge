module core_2rw_base (vread, vwrite, vaddr, vdin, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                      pread, pwrite, pradr, pdin, pdout, pdout_fwrd, pdout_serr, pdout_derr, pdout_padr,
	              ready, clk, rst);
 
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
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

  localparam LBITVBK = BITVBNK>0 ? BITVBNK : 1;

  input [2-1:0]                        vread;
  input [2-1:0]                        vwrite;
  input [2*BITADDR-1:0]                vaddr;
  input [2*WIDTH-1:0]                  vdin;
  output [2-1:0]                       vread_vld;
  output [2*WIDTH-1:0]                 vdout;
  output [2-1:0]                       vread_fwrd;
  output [2-1:0]                       vread_serr;
  output [2-1:0]                       vread_derr;
  output [2*BITPADR-1:0]               vread_padr;
  
  output [2*NUMVBNK-1:0]               pread;
  output [2*NUMVBNK-1:0]               pwrite;
  output [2*NUMVBNK*BITVROW-1:0]       pradr;
  output [2*NUMVBNK*WIDTH-1:0]         pdin;
  input [2*NUMVBNK*WIDTH-1:0]          pdout;
  input [2*NUMVBNK-1:0]                pdout_fwrd;
  input [2*NUMVBNK-1:0]                pdout_serr;
  input [2*NUMVBNK-1:0]                pdout_derr;
  input [2*NUMVBNK*(BITPADR-BITVBNK)-1:0]  pdout_padr;

  output                               ready;
  input                                clk;
  input                                rst;

  reg ready;
  always @(posedge clk)
    ready <= !rst;

  wire vread_wire [0:2-1];
  wire vwrite_wire [0:2-1];
  wire [BITADDR-1:0] vaddr_wire [0:2-1];
  wire [LBITVBK-1:0] vbadr_wire [0:2-1];
  wire [BITVROW-1:0] vradr_wire [0:2-1];
  wire [WIDTH-1:0] vdin_wire [0:2-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [2-1:0] vread_reg;
    reg [2-1:0] vwrite_reg;
    reg [2*BITADDR-1:0] vaddr_reg;
    reg [2*WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread & {2{ready}};
      vwrite_reg <= vwrite & {2{ready}};
      vaddr_reg <= vaddr;
      vdin_reg <= vdin;
    end

    wire ready_wire = ready_reg;
    for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: np2_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
      assign vwrite_wire[np2_var] = (vwrite_reg >> np2_var) & {2{(vaddr_wire[np2_var] < NUMADDR)}};
      assign vaddr_wire[np2_var] = vaddr_reg >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rw_adr_inst (.vbadr(vbadr_wire[np2_var]), .vradr(vradr_wire[np2_var]), .vaddr(vaddr_wire[np2_var]));
    end
  end else begin: noflpi_loop
    wire ready_wire = ready;
    for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: np2_loop
      assign vread_wire[np2_var] = vread >> np2_var;
      assign vwrite_wire[np2_var] = (vwrite >> np2_var) & {2{(vaddr_wire[np2_var] < NUMADDR)}};
      assign vaddr_wire[np2_var] = vaddr >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rw_adr_inst (.vbadr(vbadr_wire[np2_var]), .vradr(vradr_wire[np2_var]), .vaddr(vaddr_wire[np2_var]));
    end
  end
  endgenerate

  reg               vwrite_del;
  reg [LBITVBK-1:0] vbadr_del;
  reg [BITVROW-1:0] vradr_del;
  parameter SRCWDTH = 1 << BITWDTH;
  reg [SRCWDTH-1:0] vdin_del;
//  reg [WIDTH-1:0]   vdin_del;

  wire move [0:2-1];
  wire flush [0:2-1];
  wire conflict = (vread_wire[0] || vwrite_wire[0]) && (vread_wire[1] || vwrite_wire[1]) && (vaddr_wire[0] == vaddr_wire[1]);
  assign move[0] = conflict && vwrite_wire[0] && !vwrite_wire[1];
  assign move[1] = conflict && vwrite_wire[1];
  assign flush[0] = conflict && move[0] && vwrite_del && !((vbadr_del == vbadr_wire[0]) && (vradr_del == vradr_wire[0]));
  assign flush[1] = conflict && move[1] && vwrite_del && !((vbadr_del == vbadr_wire[1]) && (vradr_del == vradr_wire[1]));
  wire clear = !conflict && vwrite_del && ((vwrite_wire[0] && (vbadr_del == vbadr_wire[0]) && (vradr_del == vradr_wire[0])) ||
					   (vwrite_wire[1] && (vbadr_del == vbadr_wire[1]) && (vradr_del == vradr_wire[1])));

  always @(posedge clk)
    if (rst)
      vwrite_del <= 1'b0;
    else if (move[0]) begin
      vwrite_del <= 1'b1;
      vbadr_del <= vbadr_wire[0];
      vradr_del <= vradr_wire[0];
      vdin_del <= vdin_wire[0];
    end else if (move[1]) begin
      vwrite_del <= 1'b1;
      vbadr_del <= vbadr_wire[1];
      vradr_del <= vradr_wire[1];
      vdin_del <= vdin_wire[1];
    end else if (clear)
      vwrite_del <= 1'b0;

  reg vread_int [0:2-1];
  reg vwrite_int [0:2-1];
  reg [BITVBNK-1:0] vbadr_int [0:2-1];
  reg [BITVROW-1:0] vradr_int [0:2-1];
  reg [WIDTH-1:0] vdin_int [0:2-1];
  integer vcft_int;
  always_comb 
    for (vcft_int=0; vcft_int<2; vcft_int=vcft_int+1) begin
      vread_int[vcft_int] = 1'b0;
      vwrite_int[vcft_int] = 1'b0;
      vbadr_int[vcft_int] = 0;
      vradr_int[vcft_int] = 0;
      vdin_int[vcft_int] = 0;
      if (vread_wire[vcft_int]) begin
        vread_int[vcft_int] = 1'b1;
        vbadr_int[vcft_int] = vbadr_wire[vcft_int];
        vradr_int[vcft_int] = vradr_wire[vcft_int];
      end else if (flush[vcft_int]) begin
        vwrite_int[vcft_int] = 1'b1;
        vbadr_int[vcft_int] = vbadr_del;
        vradr_int[vcft_int] = vradr_del;
        vdin_int[vcft_int] = vdin_del;
      end else if (!conflict && vwrite_wire[vcft_int]) begin
        vwrite_int[vcft_int] = 1'b1;
        vbadr_int[vcft_int] = vbadr_wire[vcft_int];
        vradr_int[vcft_int] = vradr_wire[vcft_int];
        vdin_int[vcft_int] = vdin_wire[vcft_int];
      end
    end

  wire vread_int_0 = vread_int[0];
  wire vread_int_1 = vread_int[1];
  wire vwrite_int_0 = vwrite_int[0];
  wire vwrite_int_1 = vwrite_int[1];
  wire [BITVBNK-1:0] vbadr_int_0 = vbadr_int[0];
  wire [BITVBNK-1:0] vbadr_int_1 = vbadr_int[1];
  wire [BITVROW-1:0] vradr_int_0 = vradr_int[0];
  wire [BITVROW-1:0] vradr_int_1 = vradr_int[1];
  wire [WIDTH-1:0] vdin_int_0 = vdin_int[0];
  wire [WIDTH-1:0] vdin_int_1 = vdin_int[1];

  wire forward_read [0:2-1];
  assign forward_read[0] = vread_wire[0] && vwrite_del && (vbadr_wire[0] == vbadr_del) && (vradr_wire[0] == vradr_del);
  assign forward_read[1] = vread_wire[1] && vwrite_del && (vbadr_wire[1] == vbadr_del) && (vradr_wire[1] == vradr_del);

  wire forward_read_0 = forward_read[0];
  wire forward_read_1 = forward_read[1];

  reg                vread_reg [0:2-1][0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  vbadr_reg [0:2-1][0:SRAM_DELAY-1];
  reg                vread_fwd [0:2-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]    vread_dat [0:2-1][0:SRAM_DELAY-1];
  integer vreg_int, vrpt_int;
  always @(posedge clk)
    for (vreg_int=0; vreg_int<SRAM_DELAY; vreg_int=vreg_int+1) 
      if (vreg_int>0) begin
        for (vrpt_int=0; vrpt_int<2; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_reg[vrpt_int][vreg_int-1];
          vbadr_reg[vrpt_int][vreg_int] <= vbadr_reg[vrpt_int][vreg_int-1];
          vread_fwd[vrpt_int][vreg_int] <= vread_fwd[vrpt_int][vreg_int-1];
          vread_dat[vrpt_int][vreg_int] <= vread_dat[vrpt_int][vreg_int-1];
        end
      end else begin
        for (vrpt_int=0; vrpt_int<2; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_wire[vrpt_int];
          vbadr_reg[vrpt_int][vreg_int] <= vbadr_wire[vrpt_int];
          vread_fwd[vrpt_int][vreg_int] <= forward_read[vrpt_int];
          vread_dat[vrpt_int][vreg_int] <= vdin_del;
        end
      end

  reg               vread_out [0:2-1];
  reg [BITVBNK-1:0] vbadr_out [0:2-1];
  reg               vread_fwd_out [0:2-1];
  reg [WIDTH-1:0]   vread_dat_out [0:2-1]; 
  integer vdel_int;
  always_comb begin
    for (vdel_int=0; vdel_int<2; vdel_int=vdel_int+1) begin
      vread_out[vdel_int] = vread_reg[vdel_int][SRAM_DELAY-1];
      vbadr_out[vdel_int] = vbadr_reg[vdel_int][SRAM_DELAY-1];
      vread_fwd_out[vdel_int] = vread_fwd[vdel_int][SRAM_DELAY-1];
      vread_dat_out[vdel_int] = vread_dat[vdel_int][SRAM_DELAY-1];
    end
  end

  reg [2*NUMVBNK-1:0] pread;
  reg [2*NUMVBNK-1:0] pwrite;
  reg [2*NUMVBNK*BITVROW-1:0] pradr;
  reg [2*NUMVBNK*WIDTH-1:0] pdin;
  integer prd_int;
  always_comb begin
    pread = 0;
    pwrite = 0;
    pradr = 0;
    pdin = 0;
    for (prd_int=0; prd_int<2; prd_int=prd_int+1) begin
      if (vwrite_int[prd_int]) begin
        pwrite = pwrite | (1'b1 << (vbadr_int[prd_int]*2+prd_int));
        pradr = pradr | (vradr_int[prd_int] << ((vbadr_int[prd_int]*2+prd_int)*BITVROW));
        pdin = pdin | (vdin_int[prd_int] << ((vbadr_int[prd_int]*2+prd_int)*WIDTH));
      end
      if (vread_int[prd_int]) begin
        pread = pread | (1'b1 << (vbadr_wire[prd_int]*2+prd_int));
        pradr = pradr | (vradr_int[prd_int] << ((vbadr_int[prd_int]*2+prd_int)*BITVROW));
      end
    end
  end   

  reg               vread_vld_wire [0:2-1];
  reg [WIDTH-1:0]   vdout_wire [0:2-1];
  reg               vread_fwrd_wire [0:2-1];
  reg               vread_serr_wire [0:2-1];
  reg               vread_derr_wire [0:2-1];
  reg [BITPADR-1:0] vread_padr_wire [0:2-1];
  reg [BITPADR-BITVBNK-1:0] vread_padr_temp [0:2-1];
  integer vrd_int;
  always_comb
    for (vrd_int=0; vrd_int<2; vrd_int=vrd_int+1) begin
      vread_vld_wire[vrd_int] = vread_out[vrd_int];
      vdout_wire[vrd_int] = vread_fwd_out[vrd_int] ? vread_dat_out[vrd_int] : pdout >> ((2*vbadr_out[vrd_int]+vrd_int)*WIDTH);
      vread_fwrd_wire[vrd_int] = pdout_fwrd >> (2*vbadr_out[vrd_int]+vrd_int);
      vread_fwrd_wire[vrd_int] = vread_fwrd_wire[vrd_int] || vread_fwd_out[vrd_int];
      vread_serr_wire[vrd_int] = pdout_serr >> (2*vbadr_out[vrd_int]+vrd_int);
      vread_derr_wire[vrd_int] = pdout_derr >> (2*vbadr_out[vrd_int]+vrd_int);
      vread_padr_temp[vrd_int] = pdout_padr >> ((2*vbadr_out[vrd_int]+vrd_int)*(BITPADR-BITVBNK));
      vread_padr_wire[vrd_int] = {vbadr_out[vrd_int],vread_padr_temp[vrd_int]};
    end

  wire vread_fwd_out_0 = vread_fwd_out[0];
  wire vread_fwd_out_1 = vread_fwd_out[1];
  wire vread_fwrd_wire_0 = vread_fwrd_wire[0];
  wire vread_fwrd_wire_1 = vread_fwrd_wire[1];

  reg [2-1:0]         vread_vld_tmp;
  reg [2*WIDTH-1:0]   vdout_tmp;
  reg [2-1:0]         vread_fwrd_tmp;
  reg [2-1:0]         vread_serr_tmp;
  reg [2-1:0]         vread_derr_tmp;
  reg [2*BITPADR-1:0] vread_padr_tmp;
  integer vwire_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_fwrd_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    for (vwire_int=0; vwire_int<2; vwire_int=vwire_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_out[vwire_int] << vwire_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vwire_int] << (vwire_int*WIDTH));
      vread_fwrd_tmp = vread_fwrd_tmp | (vread_fwrd_wire[vwire_int] << vwire_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vwire_int] << vwire_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vwire_int] << vwire_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vwire_int] << (vwire_int*BITPADR));
    end
  end

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

endmodule



