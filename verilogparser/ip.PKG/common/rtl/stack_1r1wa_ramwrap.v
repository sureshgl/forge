module stack_1r1wa_ramwrap (write, wr_adr, bw, din, read, rd_adr, rd_dout,
	           mem_write, mem_wr_adr, mem_bw, mem_din, mem_read, mem_rd_adr, mem_rd_dout,
                   rd_clk, wr_clk, rd_rst , wr_rst);

  parameter WIDTH = 32;
  parameter ENAPSDO = 1;
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

  output [NUMWBNK-1:0] mem_write;
  output [NUMWBNK*BITWROW-1:0] mem_wr_adr;
  output [NUMWBNK*WIDTH-1:0] mem_bw;
  output [NUMWBNK*WIDTH-1:0] mem_din;
  output [NUMWBNK-1:0] mem_read;
  output [NUMWBNK*BITWROW-1:0] mem_rd_adr;
  input [NUMWBNK*WIDTH-1:0] mem_rd_dout;

  input rd_clk;
  input wr_clk;
  input rd_rst;
  input wr_rst;

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
    np2_addr_ramwrap #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMWBNK), .BITVBNK (BITWBNK),
      .NUMVROW (NUMWROW), .BITVROW (BITWROW))
      wr_adr_inst (.vbadr(wr_wadr), .vradr(wr_radr), .vaddr(wr_adr_wire));

    np2_addr_ramwrap #(
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

  wire [NUMWBNK-1:0] mem_write_tmp;
  wire [NUMWBNK*BITWROW-1:0] mem_wr_adr_tmp;
  wire [NUMWBNK*WIDTH-1:0] mem_bw_tmp;
  wire [NUMWBNK*WIDTH-1:0] mem_din_tmp;
  wire [NUMWBNK-1:0] mem_read_tmp;
  wire [NUMWBNK*BITWROW-1:0] mem_rd_adr_tmp;
  wire forward_read;

  reg [BITWBNK-1:0] rd_wadr_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg [BITWROW-1:0] rd_radr_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg               rd_fwd_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg [WIDTH-1:0]   rd_msk_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg [WIDTH-1:0]   rd_dat_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg               rd_vld_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];

  generate if (ENAPSDO) begin: psdo_loop
    reg write_vld_reg;
    reg [BITWBNK-1:0] write_wadr_reg; 
    reg [BITWROW-1:0] write_radr_reg;
    reg [WIDTH-1:0] write_bw_reg;
    reg [WIDTH-1:0] write_din_reg;
    always @(posedge rd_clk)
      if (wr_rst)
        write_vld_reg <= 1'b0;
      else if (write_wire && read_wire && (wr_radr == rd_radr) && (wr_wadr == rd_wadr)) begin
        write_vld_reg <= 1'b1;
        write_wadr_reg <= wr_wadr; 
        write_radr_reg <= wr_radr; 
        if (write_vld_reg && (wr_radr == write_radr_reg) && (wr_wadr == write_wadr_reg)) begin
          write_bw_reg <= write_bw_reg | bw_wire;
          write_din_reg <= (write_din_reg & ~bw_wire) | (din_wire & bw_wire);
        end else begin
          write_bw_reg <= bw_wire;
          write_din_reg <= din_wire;
        end
      end else if (write_wire && write_vld_reg && (wr_radr == write_radr_reg) && (wr_wadr == write_wadr_reg)) begin
        write_vld_reg <= 1'b1;
        write_wadr_reg <= wr_wadr; 
        write_radr_reg <= wr_radr; 
        write_bw_reg <= write_bw_reg | bw_wire;
        write_din_reg <= (write_din_reg & ~bw_wire) | (din_wire & bw_wire);
      end else if (!write_wire && !read_wire)
        write_vld_reg <= 1'b0;

    wire rd_wr_cflt = write_wire && read_wire && (wr_radr == rd_radr) && (wr_wadr == rd_wadr);
    wire rd_wr_idle = !write_wire && !read_wire;

    wire write_tmp = rd_wr_idle ? write_vld_reg :
                                  write_wire && !(read_wire && (wr_radr == rd_radr) && (wr_wadr == rd_wadr) &&
                                                  (!write_vld_reg || ((write_radr_reg == rd_radr) && (write_wadr_reg == rd_wadr))));
    wire [BITWBNK-1:0] bank_tmp = (rd_wr_cflt || rd_wr_idle) ? write_wadr_reg : wr_wadr;

    assign mem_write_tmp = write_tmp ? (1'b1 << bank_tmp) : 0;
    assign mem_wr_adr_tmp = {NUMWBNK{(rd_wr_cflt || rd_wr_idle) ? write_radr_reg : wr_radr}};
    assign mem_bw_tmp = {NUMWBNK{(rd_wr_cflt || rd_wr_idle) ? write_bw_reg : bw_wire}};
    assign mem_din_tmp = {NUMWBNK{(rd_wr_cflt || rd_wr_idle) ? write_din_reg : din_wire}};
    assign mem_read_tmp = read_wire ? (1'b1 << rd_wadr) : 0;
    assign mem_rd_adr_tmp = {NUMWBNK{rd_radr}};
    assign forward_read = read_wire && write_vld_reg && (rd_radr == write_radr_reg) && (rd_wadr == write_wadr_reg);

    integer rd_int;
    always @(posedge rd_clk)
      for (rd_int=0; rd_int<SRAM_DELAY+FLOPCMD+FLOPMEM; rd_int=rd_int+1)
        if (rd_int>0) begin
          rd_wadr_reg[rd_int] <= rd_wadr_reg[rd_int-1];
          rd_radr_reg[rd_int] <= rd_radr_reg[rd_int-1];
          rd_fwd_reg[rd_int] <= rd_fwd_reg[rd_int-1];
          rd_msk_reg[rd_int] <= rd_msk_reg[rd_int-1];
          rd_dat_reg[rd_int] <= rd_dat_reg[rd_int-1];
          rd_vld_reg[rd_int] <= rd_vld_reg[rd_int-1];
        end else begin
          rd_wadr_reg[rd_int] <= rd_wadr;
          rd_radr_reg[rd_int] <= rd_radr;
          rd_fwd_reg[rd_int] <= read_wire && write_vld_reg && (rd_radr == write_radr_reg) && (rd_wadr == write_wadr_reg);
          rd_msk_reg[rd_int] <= write_bw_reg;
          rd_dat_reg[rd_int] <= write_din_reg;
          rd_vld_reg[rd_int] <= read_wire;
      end
  end else begin: npsdo_loop
    assign mem_write_tmp = write_wire ? (1'b1 << wr_wadr) : 0;
    assign mem_wr_adr_tmp = {NUMWBNK{wr_radr}};
    assign mem_bw_tmp = {NUMWBNK{bw_wire}};
    assign mem_din_tmp = {NUMWBNK{din_wire}};
    assign mem_read_tmp = read_wire ? (1'b1 << rd_wadr) : 0;
    assign mem_rd_adr_tmp = {NUMWBNK{rd_radr}};
    assign forward_read = 1'b0;

    integer rd_int;
    always @(posedge rd_clk)
      for (rd_int=0; rd_int<SRAM_DELAY+FLOPCMD+FLOPMEM; rd_int=rd_int+1)
        if (rd_int>0) begin
          rd_wadr_reg[rd_int] <= rd_wadr_reg[rd_int-1];
          rd_radr_reg[rd_int] <= rd_radr_reg[rd_int-1];
        end else begin
          rd_wadr_reg[rd_int] <= rd_wadr;
          rd_radr_reg[rd_int] <= rd_radr;
      end
  end
  endgenerate

  generate if (FLOPCMD) begin: flpc_loop
    reg [NUMWBNK-1:0] mem_write_reg;
    reg [NUMWBNK*BITWROW-1:0] mem_wr_adr_reg;
    reg [NUMWBNK*WIDTH-1:0] mem_bw_reg;
    reg [NUMWBNK*WIDTH-1:0] mem_din_reg;
    reg [NUMWBNK-1:0] mem_read_reg;
    reg [NUMWBNK*BITWROW-1:0] mem_rd_adr_reg;
    always @(posedge rd_clk) begin
      mem_write_reg <= mem_write_tmp;
      mem_wr_adr_reg <= mem_wr_adr_tmp;
      mem_bw_reg <= mem_bw_tmp;
      mem_din_reg <= mem_din_tmp;
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

  wire [NUMWBNK*WIDTH-1:0] mem_rd_dout_tmp;
  generate if (FLOPMEM) begin: flpm_loop
    reg [NUMWBNK*WIDTH-1:0] mem_rd_dout_reg;
    always @(posedge rd_clk)
      mem_rd_dout_reg <= mem_rd_dout;
    assign mem_rd_dout_tmp = mem_rd_dout_reg;
  end else begin: noflpm_loop
    assign mem_rd_dout_tmp = mem_rd_dout;
  end
  endgenerate


  wire [WIDTH-1:0] rd_dout_wire = (NUMWBNK>1) ? (mem_rd_dout_tmp>>(rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]*WIDTH)) : mem_rd_dout_tmp ;

  wire [WIDTH-1:0] rd_dout_tmp = (ENAPSDO && rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]) ?
                                  ((rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] & rd_msk_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]) |
                                   rd_dout_wire & ~rd_msk_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]) : rd_dout_wire;

  generate if (FLOPOUT) begin: flpo_loop
    reg [WIDTH-1:0] rd_dout_reg;
    always @(posedge rd_clk) begin
      rd_dout_reg <= rd_dout_tmp;
    end
    assign rd_dout = rd_dout_reg;
  end else begin: noflpo_loop
    assign rd_dout = rd_dout_tmp;
  end
  endgenerate

endmodule

