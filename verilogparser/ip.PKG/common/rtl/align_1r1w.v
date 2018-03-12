module align_1r1w (write, wr_adr, din, read, rd_adr, rd_dout, rd_serr, rd_padr,
	           mem_write, mem_wr_adr, mem_bw, mem_din, mem_read, mem_rd_adr, mem_rd_dout,
                   clk, rst);

  parameter WIDTH = 32;
  parameter PARITY = 1;
  parameter NUMADDR = 1024;
  parameter BITADDR = 10;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter BITPADR = 10;
  parameter SRAM_DELAY = 2;
  parameter FLOPMEM = 0;

  parameter MEMWDTH = WIDTH+PARITY;

  input write;
  input [BITADDR-1:0] wr_adr;
  input [WIDTH-1:0] din;

  input read;
  input [BITADDR-1:0] rd_adr;
  output [WIDTH-1:0] rd_dout;
  output rd_serr;
  output [BITPADR-1:0] rd_padr;

  output mem_write;
  output [BITSROW-1:0] mem_wr_adr;
  output [NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [NUMWRDS*MEMWDTH-1:0] mem_din;
  output mem_read;
  output [BITSROW-1:0] mem_rd_adr;
  input [NUMWRDS*MEMWDTH-1:0] mem_rd_dout;

  input clk;
  input rst;

  wire [BITWRDS-1:0] wr_wadr;
  wire [BITSROW-1:0] wr_radr;
  wire [BITWRDS-1:0] rd_wadr;
  wire [BITSROW-1:0] rd_radr;
  generate if (BITWRDS>0) begin: np2_loop
    np2_addr #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
      .NUMVROW (NUMSROW), .BITVROW (BITSROW))
      wr_adr_inst (.vbadr(wr_wadr), .vradr(wr_radr), .vaddr(wr_adr));

    np2_addr #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
      .NUMVROW (NUMSROW), .BITVROW (BITSROW))
      rd_adr_inst (.vbadr(rd_wadr), .vradr(rd_radr), .vaddr(rd_adr));
  end else begin: no_np2_loop
    assign wr_wadr = 0;
    assign wr_radr = wr_adr;
    assign rd_wadr = 0;
    assign rd_radr = rd_adr;
  end
  endgenerate

  wire [MEMWDTH-1:0] din_tmp = {(PARITY && ^din),din};
  reg write_vld_reg;
  reg [BITSROW-1:0] write_adr_reg;
  reg [NUMWRDS-1:0] write_msk_reg;
  reg [NUMWRDS*MEMWDTH-1:0] write_dat_reg;
  always @(posedge clk)
    if (rst)
      write_vld_reg <= 1'b0;
    else if (write && read && (wr_radr == rd_radr)) begin
      write_vld_reg <= 1'b1;
      write_adr_reg <= wr_radr; 
      if (write_vld_reg && (wr_radr == write_adr_reg)) begin
        write_msk_reg <= write_msk_reg | (1 << wr_wadr);
        write_dat_reg <= (write_dat_reg & ~({MEMWDTH{1'b1}} << (wr_wadr*MEMWDTH))) | (din_tmp << (wr_wadr*MEMWDTH));
      end else begin
        write_msk_reg <= 1 << wr_wadr;
        write_dat_reg <= din_tmp << (wr_wadr*MEMWDTH);
      end
    end else if (write && write_vld_reg && (wr_radr == write_adr_reg)) begin
      write_vld_reg <= 1'b1;
      write_adr_reg <= wr_radr; 
      write_msk_reg <= write_msk_reg | (1 << wr_wadr);
      write_dat_reg <= (write_dat_reg & ~({MEMWDTH{1'b1}} << (wr_wadr*MEMWDTH))) | (din_tmp << (wr_wadr*MEMWDTH));
    end

  reg [NUMWRDS*MEMWDTH-1:0] write_msk_tmp;
  integer msk_int;
  always_comb begin
    write_msk_tmp = 0;
    for (msk_int=0; msk_int<NUMWRDS; msk_int=msk_int+1)
      write_msk_tmp = write_msk_tmp | ({MEMWDTH{write_msk_reg[msk_int]}} << (msk_int*MEMWDTH)); 
  end

  assign mem_write = write && !(read && (wr_radr == rd_radr) && (!write_vld_reg || (write_adr_reg == rd_radr)));
  assign mem_wr_adr = (write && read && (wr_radr == rd_radr)) ? write_adr_reg : wr_radr;
  assign mem_bw = (write && read && (wr_radr == rd_radr)) ? write_msk_tmp : {MEMWDTH{1'b1}} << (wr_wadr*MEMWDTH);
  assign mem_din = (write && read && (wr_radr == rd_radr)) ? write_dat_reg : din_tmp << (wr_wadr*MEMWDTH);

  assign mem_read = read;
  assign mem_rd_adr = rd_radr;

  reg [BITWRDS-1:0] rd_wadr_reg [0:SRAM_DELAY+FLOPMEM-1];
  reg [BITSROW-1:0] rd_radr_reg [0:SRAM_DELAY+FLOPMEM-1];
  reg               rd_fwd_reg [0:SRAM_DELAY+FLOPMEM-1];
  reg [MEMWDTH-1:0] rd_dat_reg [0:SRAM_DELAY+FLOPMEM-1];
  integer rd_int;
  always @(posedge clk)
    for (rd_int=SRAM_DELAY+FLOPMEM-1; rd_int>=0; rd_int=rd_int-1)
      if (rd_int>0) begin
	rd_wadr_reg[rd_int] <= rd_wadr_reg[rd_int-1];
        rd_radr_reg[rd_int] <= rd_radr_reg[rd_int-1];
        rd_fwd_reg[rd_int] <= rd_fwd_reg[rd_int-1];
        rd_dat_reg[rd_int] <= rd_dat_reg[rd_int-1];
      end else begin
	rd_wadr_reg[rd_int] <= rd_wadr;
	rd_radr_reg[rd_int] <= rd_radr;
        rd_fwd_reg[rd_int] <= read && write_vld_reg && (rd_radr == write_adr_reg) && write_msk_reg[rd_wadr];
        rd_dat_reg[rd_int] <= write_dat_reg >> (rd_wadr*MEMWDTH);
      end

  wire [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_tmp;
  generate if (FLOPMEM) begin: flpm_loop
    reg [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_reg;
    always @(posedge clk)
      mem_rd_dout_reg <= mem_rd_dout;
    assign mem_rd_dout_tmp = mem_rd_dout_reg;
  end else begin: noflpm_loop
    assign mem_rd_dout_tmp = mem_rd_dout;
  end
  endgenerate

  wire               dout_bit_err = 0;
  wire [15:0]        dout_bit_pos = 0;
  wire [MEMWDTH-1:0] dout_bit_mask = dout_bit_err << dout_bit_pos;
  wire               dout_serr_mask = |dout_bit_mask;

  wire [MEMWDTH-1:0] rd_dout_wire = mem_rd_dout_tmp >> (rd_wadr_reg[SRAM_DELAY+FLOPMEM-1]*MEMWDTH);
  assign rd_dout = rd_fwd_reg[SRAM_DELAY+FLOPMEM-1] ? rd_dat_reg[SRAM_DELAY+FLOPMEM-1] : rd_dout_wire ^ dout_bit_mask;
  assign rd_serr = PARITY ? (!rd_fwd_reg[SRAM_DELAY+FLOPMEM-1] && ^(rd_dout_wire ^ dout_bit_mask)) : 1'b0;
  assign rd_padr = (NUMWRDS>1) ? {rd_wadr_reg[SRAM_DELAY+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPMEM-1]} : {rd_radr_reg[SRAM_DELAY+FLOPMEM-1]};

endmodule
