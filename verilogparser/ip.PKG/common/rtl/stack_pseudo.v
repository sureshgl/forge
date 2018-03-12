module stack_pseudo (write, wr_adr, bw, din,
                     read, rd_adr, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	             mem_read, mem_write, mem_addr, mem_bw, mem_din, mem_dout,
                     clk, rst);

  parameter WIDTH = 32;
  parameter NUMADDR = 1024;
  parameter BITADDR = 10;
  parameter NUMWROW = 256;
  parameter BITWROW = 8;
  parameter NUMWBNK = 4;
  parameter BITWBNK = 2;
  parameter SRAM_DELAY = 2;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  input write;
  input [BITADDR-1:0] wr_adr;
  input [WIDTH-1:0] bw;
  input [WIDTH-1:0] din;

  input read;
  input [BITADDR-1:0] rd_adr;
  output [WIDTH-1:0] rd_dout;
  output rd_fwrd;
  output rd_serr;
  output rd_derr;
  output [BITWBNK+BITWROW-1:0] rd_padr;

  output [NUMWBNK-1:0] mem_read;
  output [NUMWBNK-1:0] mem_write;
  output [NUMWBNK*BITWROW-1:0] mem_addr;
  output [NUMWBNK*WIDTH-1:0] mem_bw;
  output [NUMWBNK*WIDTH-1:0] mem_din;
  input [NUMWBNK*WIDTH-1:0] mem_dout;

  input clk;
  input rst;

  wire write_wire = write;
  wire [BITADDR-1:0] wr_adr_wire = wr_adr;
  wire [WIDTH-1:0] bw_wire = bw;
  wire [WIDTH-1:0] din_wire = din;
  wire read_wire = read;
  wire [BITADDR-1:0] rd_adr_wire = rd_adr;

  wire [BITWBNK-1:0] wr_wadr;
  wire [BITWROW-1:0] wr_radr;
  wire [BITWBNK-1:0] rd_wadr;
  wire [BITWROW-1:0] rd_radr;
  generate if (BITWBNK>0) begin: np2_loop
    np2_addr #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMWBNK), .BITVBNK (BITWBNK),
      .NUMVROW (NUMWROW), .BITVROW (BITWROW))
      wr_adr_inst (.vbadr(wr_wadr), .vradr(wr_radr), .vaddr(wr_adr_wire));

    np2_addr #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMWBNK), .BITVBNK (BITWBNK),
      .NUMVROW (NUMWROW), .BITVROW (BITWROW))
      rd_adr_inst (.vbadr(rd_wadr), .vradr(rd_radr), .vaddr(rd_adr_wire));
  end else begin: no_np2_loop
    assign wr_wadr = 0;
    assign wr_radr = wr_adr_wire;
    assign rd_wadr = 0;
    assign rd_radr = rd_adr_wire;
  end
  endgenerate

  wire [NUMWBNK-1:0] mem_read_tmp = read_wire ? (1'b1 << rd_wadr) : 0;
  wire [NUMWBNK-1:0] mem_write_tmp = write_wire ? (1'b1 << wr_wadr) : 0;
  wire [NUMWBNK*BITWROW-1:0] mem_addr_tmp = (read_wire ? (rd_radr << (rd_wadr*BITWROW)) : 0) | (write_wire ? (wr_radr << (wr_wadr*BITWROW)) : 0);
  wire [NUMWBNK*WIDTH-1:0] mem_bw_tmp = {NUMWBNK{bw_wire}};
  wire [NUMWBNK*WIDTH-1:0] mem_din_tmp = {NUMWBNK{din_wire}};

  reg [BITWBNK-1:0] rd_wadr_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg [BITWROW-1:0] rd_radr_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];

  integer rd_int;
  always @(posedge clk)
    for (rd_int=0; rd_int<SRAM_DELAY+FLOPCMD+FLOPMEM; rd_int=rd_int+1)
      if (rd_int>0) begin
        rd_wadr_reg[rd_int] <= rd_wadr_reg[rd_int-1];
        rd_radr_reg[rd_int] <= rd_radr_reg[rd_int-1];
      end else begin
        rd_wadr_reg[rd_int] <= rd_wadr;
        rd_radr_reg[rd_int] <= rd_radr;
    end

  generate if (FLOPCMD) begin: flpc_loop
    reg [NUMWBNK-1:0] mem_read_reg;
    reg [NUMWBNK-1:0] mem_write_reg;
    reg [NUMWBNK*BITWROW-1:0] mem_addr_reg;
    reg [NUMWBNK*WIDTH-1:0] mem_bw_reg;
    reg [NUMWBNK*WIDTH-1:0] mem_din_reg;
    always @(posedge clk) begin
      mem_read_reg <= mem_read_tmp;
      mem_write_reg <= mem_write_tmp;
      mem_addr_reg <= mem_addr_tmp;
      mem_bw_reg <= mem_bw_tmp;
      mem_din_reg <= mem_din_tmp;
    end
    
    assign mem_read = mem_read_reg;
    assign mem_write = mem_write_reg;
    assign mem_addr = mem_addr_reg;
    assign mem_bw = mem_bw_reg;
    assign mem_din = mem_din_reg;
  end else begin: nflpc_loop
    assign mem_read = mem_read_tmp;
    assign mem_write = mem_write_tmp;
    assign mem_addr = mem_addr_tmp;
    assign mem_bw = mem_bw_tmp;
    assign mem_din = mem_din_tmp;
  end
  endgenerate

  wire [NUMWBNK*WIDTH-1:0] mem_dout_tmp;
  generate if (FLOPMEM) begin: flpm_loop
    reg [NUMWBNK*WIDTH-1:0] mem_dout_reg;
    always @(posedge clk)
      mem_dout_reg <= mem_dout;
    assign mem_dout_tmp = mem_dout_reg;
  end else begin: noflpm_loop
    assign mem_dout_tmp = mem_dout;
  end
  endgenerate

  reg [WIDTH-1:0] rd_dout_wire;
  integer bit_int;
  always_comb
    for (bit_int=0; bit_int<WIDTH; bit_int=bit_int+1)
      rd_dout_wire[bit_int] = mem_dout_tmp[rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]*WIDTH+bit_int];

  wire [WIDTH-1:0] rd_dout_tmp = rd_dout_wire;
  wire rd_fwrd_tmp = 1'b0;
  wire rd_serr_tmp = 1'b0;
  wire rd_derr_tmp = 1'b0;
  wire [BITWBNK+BITWROW-1:0] rd_padr_tmp = (NUMWBNK>1) ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]} :
                                                         rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];

  generate if (FLOPOUT) begin: flpo_loop
    reg [WIDTH-1:0] rd_dout_reg;
    reg rd_fwrd_reg;
    reg rd_serr_reg;
    reg rd_derr_reg;
    reg [BITWBNK+BITWROW-1:0] rd_padr_reg;
    always @(posedge clk) begin
      rd_dout_reg <= rd_dout_tmp;
      rd_fwrd_reg <= rd_fwrd_tmp;
      rd_serr_reg <= rd_serr_tmp;
      rd_derr_reg <= rd_derr_tmp;
      rd_padr_reg <= rd_padr_tmp;
    end
    assign rd_dout = rd_dout_reg;
    assign rd_fwrd = rd_fwrd_reg;
    assign rd_serr = rd_serr_reg;
    assign rd_derr = rd_derr_reg;
    assign rd_padr = rd_padr_reg;
  end else begin: noflpo_loop
    assign rd_dout = rd_dout_tmp;
    assign rd_fwrd = rd_fwrd_tmp;
    assign rd_serr = rd_serr_tmp;
    assign rd_derr = rd_derr_tmp;
    assign rd_padr = rd_padr_tmp;
  end
  endgenerate

endmodule

