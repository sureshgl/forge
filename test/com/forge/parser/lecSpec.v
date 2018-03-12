module lecSpec(
  write, wr_adr, din,
  read, rd_adr, rd_dout, clk, rst
);

parameter NUMWPRT = 4;
parameter NUMRPRT = 4;

parameter BITADDR = 6;
parameter NUMADDR = 64;
parameter WIDTH   = 24;

parameter FLOPOUT = 0;

input  [NUMWPRT-1:0] write;
input  [BITADDR-1:0] wr_adr [0:NUMWPRT-1];
input  [WIDTH-1:0]   din    [0:NUMWPRT-1];

input  [NUMRPRT-1:0] read;
input  [BITADDR-1:0] rd_adr  [0:NUMRPRT-1];
output [WIDTH-1:0]   rd_dout [0:NUMRPRT-1];

input                        clk;
input                        rst;

reg [WIDTH-1:0] mem [0:NUMADDR-1];
always @(posedge clk)
  for (integer wrm_int=0; wrm_int<NUMWPRT; wrm_int=wrm_int+1)
    if (write[wrm_int])
      mem[wr_adr[wrm_int]] <= din[wrm_int];

reg [WIDTH-1:0] rd_dout_tmp[0:NUMRPRT-1];
reg [WIDTH-1:0] rd_dout[0:NUMRPRT-1];
always_comb begin
  for (integer rdm_int=0; rdm_int<NUMRPRT; rdm_int=rdm_int+1)
    rd_dout_tmp[rdm_int] = mem[rd_adr[rdm_int]];
end

generate if (FLOPOUT) begin : fo
  always @(posedge clk)
    for (integer rdm_int=0; rdm_int<NUMRPRT; rdm_int=rdm_int+1)
      rd_dout[rdm_int] <= rd_dout_tmp[rdm_int];
end else begin : no_fo
  always_comb
    for (integer rdm_int=0; rdm_int<NUMRPRT; rdm_int=rdm_int+1)
       rd_dout[rdm_int] = rd_dout_tmp[rdm_int];
end
endgenerate

endmodule
