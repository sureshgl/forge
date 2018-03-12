module align (read, write, addr, din, dout, serr, padr,
	      mem_read, mem_write, mem_addr, mem_bw, mem_din, mem_dout, clk);

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

  parameter MEMWDTH = WIDTH+PARITY;

  input read;
  input write;
  input [BITADDR-1:0] addr;
  input [WIDTH-1:0] din;
  output [WIDTH-1:0] dout;
  output             serr;
  output [BITPADR-1:0] padr;

  output mem_read;
  output mem_write;
  output [BITSROW-1:0] mem_addr;
  output [NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [NUMWRDS*MEMWDTH-1:0] mem_din;
  input [NUMWRDS*MEMWDTH-1:0] mem_dout;

  input clk;

  wire [BITWRDS-1:0] wadr;
  wire [BITSROW-1:0] radr;
  generate if (BITWRDS>0) begin: np2_loop
    np2_addr #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
      .NUMVROW (NUMSROW), .BITVROW (BITSROW))
      np2_addr_inst (.vbadr(wadr), .vradr(radr), .vaddr(addr));
  end else begin: no_np2_loop
    assign wadr = 0;
    assign radr = addr;
  end
  endgenerate

  assign mem_read = read;
  assign mem_write = write;
  assign mem_addr = radr;
  assign mem_bw = {MEMWDTH{1'b1}} << (wadr*MEMWDTH);
  assign mem_din = {(PARITY && ^din),din} << (wadr*MEMWDTH);

  reg [BITWRDS-1:0] wadr_reg [0:SRAM_DELAY-1];
  reg [BITSROW-1:0] radr_reg [0:SRAM_DELAY-1];
  integer rd_int;
  always @(posedge clk)
    for (rd_int=SRAM_DELAY-1; rd_int>=0; rd_int=rd_int-1)
      if (rd_int>0) begin
	wadr_reg[rd_int] <= wadr_reg[rd_int-1];
        radr_reg[rd_int] <= radr_reg[rd_int-1];
      end else begin
	wadr_reg[rd_int] <= wadr;
	radr_reg[rd_int] <= radr;
      end

  wire               dout_bit_err = 0;
  wire [15:0]        dout_bit_pos = 0;
  wire [MEMWDTH-1:0] dout_bit_mask = dout_bit_err << dout_bit_pos;
  wire               dout_serr_mask = |dout_bit_mask;

  wire [MEMWDTH-1:0] dout_wire = mem_dout >> (wadr_reg[SRAM_DELAY-1]*MEMWDTH);
  assign dout = dout_wire ^ dout_bit_mask;
  assign serr = PARITY ? ^(dout_wire ^ dout_bit_mask) : 1'b0;
  assign padr = (NUMWRDS>1) ? {wadr_reg[SRAM_DELAY-1],radr_reg[SRAM_DELAY-1]} :
                              {radr_reg[SRAM_DELAY-1]};

endmodule
