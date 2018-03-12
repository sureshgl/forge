module ff_array(
  write, wr_adr, din,
  read, rd_adr, rd_dout, clk, rst
);

parameter NUMWPRT = 4;
parameter NUMRPRT = 4;

parameter BITADDR = 6;
parameter NUMADDR = 64;
parameter WIDTH   = 24;

parameter FLOPOUT = 0;

input  [NUMWPRT-1:0]         write;
input  [NUMWPRT*BITADDR-1:0] wr_adr;
input  [NUMWPRT*WIDTH-1:0]   din;

input  [NUMRPRT-1:0]         read;
input  [NUMRPRT*BITADDR-1:0] rd_adr;
output [NUMRPRT*WIDTH-1:0]   rd_dout;

input                        clk;
input                        rst;

reg               write_wire [0:NUMWPRT-1];
reg [BITADDR-1:0] wr_adr_wire [0:NUMWPRT-1];
reg [WIDTH-1:0]   din_wire [0:NUMWPRT-1];
integer wr_int;
always_comb
  for (wr_int=0; wr_int<NUMWPRT; wr_int=wr_int+1) begin
    write_wire[wr_int] = write >> wr_int;
    wr_adr_wire[wr_int] = wr_adr >> wr_int*BITADDR;
    din_wire[wr_int] = din >> wr_int*WIDTH;
  end

reg [WIDTH-1:0] mem [0:NUMADDR-1];
integer wrm_int;
always @(posedge clk)
  for (wrm_int=0; wrm_int<NUMWPRT; wrm_int=wrm_int+1)
    if (write_wire[wrm_int])
      mem[wr_adr_wire[wrm_int]] <= din_wire[wrm_int];

reg [BITADDR-1:0] rd_adr_wire [0:NUMRPRT-1];
integer rd_int;
always_comb
  for (rd_int=0; rd_int<NUMRPRT; rd_int=rd_int+1)
    rd_adr_wire[rd_int] = rd_adr >> rd_int*BITADDR;

reg [NUMRPRT*WIDTH-1:0] rd_dout_tmp;
reg [NUMRPRT*WIDTH-1:0] rd_dout_reg;
integer rdm_int;
always_comb begin
  rd_dout_tmp = 0;
  for (rdm_int=0; rdm_int<NUMRPRT; rdm_int=rdm_int+1)
    rd_dout_tmp = rd_dout_tmp | (mem[rd_adr_wire[rdm_int]] << rdm_int*WIDTH);
end

generate if (FLOPOUT) begin : fo
  always @(posedge clk)
    rd_dout_reg <= rd_dout_tmp;
  assign rd_dout = rd_dout_reg;
end else begin : no_fo
  assign rd_dout = rd_dout_tmp;
end
endgenerate

endmodule

