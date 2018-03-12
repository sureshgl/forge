module tot (
  clk, rst, rdin,
  write, din, 
  dout
);

parameter BITDATA = 8;

input                clk;
input                rst;
input  [BITDATA-1:0] rdin;
input                write;
input  [BITDATA-1:0] din;
output [BITDATA-1:0] dout;

reg [BITDATA-1:0] mem;

always @(posedge clk) begin : mem_f
  if (rst)
    mem <= rdin;
  else if (write)
    mem <= din;
end

assign dout = mem;

endmodule
