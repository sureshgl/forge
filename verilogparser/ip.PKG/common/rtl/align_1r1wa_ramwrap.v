module align_1r1wa_ramwrap (write, wr_adr, bw, din, read, rd_adr, rd_vld, rd_dout,
	                       mem_write, mem_wr_adr, mem_bw, mem_din, mem_read, mem_rd_adr, mem_rd_dout,
                           rd_clk, wr_clk, rd_rst, wr_rst);

  parameter WIDTH = 32;
  parameter ENAPSDO = 0;
  parameter NUMADDR = 1024;
  parameter BITADDR = 10;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter SRAM_DELAY = 2;
  parameter FLOPGEN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  localparam L_BITWRDS = (BITWRDS>0) ? BITWRDS : 1;

  input write;
  input [BITADDR-1:0] wr_adr;
  input [WIDTH-1:0] bw;
  input [WIDTH-1:0] din;

  input read;
  input [BITADDR-1:0] rd_adr;
  output rd_vld;
  output [WIDTH-1:0] rd_dout;

  output mem_write;
  output [BITSROW-1:0] mem_wr_adr;
  output [NUMWRDS*WIDTH-1:0] mem_bw;
  output [NUMWRDS*WIDTH-1:0] mem_din;
  output mem_read;
  output [BITSROW-1:0] mem_rd_adr;
  input [NUMWRDS*WIDTH-1:0] mem_rd_dout;

  input rd_clk;
  input rd_rst;
  input wr_clk;
  input wr_rst;

  wire write_wire;
  wire [BITADDR-1:0] wr_adr_wire;
  wire [WIDTH-1:0] bw_wire;
  wire [WIDTH-1:0] din_wire;
  wire read_wire;
  wire [BITADDR-1:0] rd_adr_wire;
  generate if (1) begin: flp_loop
    assign write_wire = write;
    assign wr_adr_wire = wr_adr;
    assign bw_wire = bw;
    assign din_wire = din;
    assign read_wire = read;
    assign rd_adr_wire = rd_adr;
  end
  endgenerate

  wire [L_BITWRDS-1:0] wr_wadr;
  wire [BITSROW-1:0] wr_radr;
  wire [L_BITWRDS-1:0] rd_wadr;
  wire [BITSROW-1:0] rd_radr;
  generate if (BITWRDS>0) begin: np2_loop
    np2_addr_ramwrap #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
      .NUMVROW (NUMSROW), .BITVROW (BITSROW))
      wr_adr_inst (.vbadr(wr_wadr), .vradr(wr_radr), .vaddr(wr_adr_wire));

    np2_addr_ramwrap #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
      .NUMVROW (NUMSROW), .BITVROW (BITSROW))
      rd_adr_inst (.vbadr(rd_wadr), .vradr(rd_radr), .vaddr(rd_adr_wire));
  end else begin: no_np2_loop
    assign wr_wadr = 0;
    assign wr_radr = wr_adr_wire;
    assign rd_wadr = 0;
    assign rd_radr = rd_adr_wire;
  end
  endgenerate

  wire forward_read = 1'b0;
  wire mem_write_tmp = write_wire;
  wire [BITSROW-1:0] mem_wr_adr_tmp = wr_radr;
  wire [NUMWRDS*WIDTH-1:0] mem_bw_tmp = bw_wire << (wr_wadr*WIDTH);
  wire [NUMWRDS*WIDTH-1:0] mem_din_tmp = din_wire << (wr_wadr*WIDTH);
  wire mem_read_tmp = read_wire && !(ENAPSDO && forward_read);
  wire [BITSROW-1:0] mem_rd_adr_tmp = rd_radr;

  generate if (FLOPCMD) begin: flpc_loop
    reg mem_write_reg;
    reg [BITSROW-1:0] mem_wr_adr_reg;
    reg [NUMWRDS*WIDTH-1:0] mem_bw_reg;
    reg [NUMWRDS*WIDTH-1:0] mem_din_reg;
    reg mem_read_reg;
    reg [BITSROW-1:0] mem_rd_adr_reg;
    always @(posedge wr_clk) begin
      mem_write_reg <= mem_write_tmp;
      mem_wr_adr_reg <= mem_wr_adr_tmp;
      mem_bw_reg <= mem_bw_tmp;
      mem_din_reg <= mem_din_tmp;
    end
    always @(posedge rd_clk) begin
      mem_read_reg <= mem_read_tmp;
      mem_rd_adr_reg <= mem_rd_adr_tmp;
    end
    
    assign mem_write = mem_write_reg;
    assign mem_wr_adr = mem_wr_adr_reg;
    assign mem_bw = mem_bw_reg;
    assign mem_din = mem_din_reg;
    assign mem_read = mem_read_reg;
    assign mem_rd_adr = mem_rd_adr_reg;
  end else begin: nflpc_loop
    assign mem_write = mem_write_tmp;
    assign mem_wr_adr = mem_wr_adr_tmp;
    assign mem_bw = mem_bw_tmp;
    assign mem_din = mem_din_tmp;
    assign mem_read = mem_read_tmp;
    assign mem_rd_adr = mem_rd_adr_tmp;
  end
  endgenerate

  reg [L_BITWRDS-1:0] rd_wadr_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg                 rd_vld_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  integer rd_int;
  always @(posedge rd_clk)
    for (rd_int=0; rd_int<SRAM_DELAY+FLOPCMD+FLOPMEM; rd_int=rd_int+1)
      if (rd_int>0) begin
        rd_vld_reg[rd_int] <= rd_vld_reg[rd_int-1];
        rd_wadr_reg[rd_int] <= rd_wadr_reg[rd_int-1];
      end else begin
        rd_vld_reg[rd_int] <= read_wire;
        rd_wadr_reg[rd_int] <= rd_wadr;
      end


  wire [NUMWRDS*WIDTH-1:0] mem_rd_dout_tmp;
  wire rd_vld_tmp;
  generate if (FLOPMEM) begin: flpm_loop
    reg [NUMWRDS*WIDTH-1:0] mem_rd_dout_reg;
    always @(posedge rd_clk) begin
      mem_rd_dout_reg <= mem_rd_dout;
    end
    assign mem_rd_dout_tmp = mem_rd_dout_reg;
  end else begin: noflpm_loop
    assign mem_rd_dout_tmp = mem_rd_dout;
  end
  endgenerate

  reg [WIDTH-1:0] rd_dout_wire;
  generate if (SRAM_DELAY+FLOPCMD+FLOPMEM>0) begin: nz_loop
    if (BITWRDS>0) begin: nbw_loop
      always_comb
        rd_dout_wire = mem_rd_dout_tmp >> (rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]*WIDTH);
    end else begin
      always_comb
        rd_dout_wire = mem_rd_dout_tmp;
    end
    assign rd_vld_tmp = rd_vld_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  end else begin: z_loop
    if (BITWRDS>0) begin: nbw_loop
      always_comb
        rd_dout_wire = mem_rd_dout_tmp >> (rd_wadr*WIDTH);
    end else begin
      always_comb
        rd_dout_wire = mem_rd_dout_tmp;
    end
    assign rd_vld_tmp = read_wire;
  end
  endgenerate

  wire [WIDTH-1:0] rd_dout_tmp = rd_dout_wire;

  generate if (FLOPOUT) begin: flpo_loop
    reg rd_vld_reg;
    reg [WIDTH-1:0] rd_dout_reg;
    always @(posedge rd_clk) begin
      rd_vld_reg <= rd_vld_tmp;
      rd_dout_reg <= rd_dout_tmp;
    end
    assign rd_vld = rd_vld_reg;
    assign rd_dout = rd_dout_reg;
  end else begin: noflpo_loop
    assign rd_vld = rd_vld_tmp;
    assign rd_dout = rd_dout_tmp;
  end
  endgenerate

endmodule // align_1r1wa_ramwrap

