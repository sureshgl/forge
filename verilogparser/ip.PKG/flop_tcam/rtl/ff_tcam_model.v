module ff_tcam_model(clk,rst, 
                     search, key, bitmap_out,
                     write, addr, mask_in);

parameter BITADDR = 4;
parameter WIDTH   = 10;
parameter NUMADDR = 1 << BITADDR;

input                   clk, rst;
input                   search;
input [WIDTH-1:0]       key;
output [NUMADDR-1:0]    bitmap_out;

input                   write;
input [BITADDR-1:0]     addr;
input [WIDTH-1:0]       mask_in;

reg [WIDTH-1:0] data[NUMADDR-1:0];
reg [WIDTH-1:0] mask[NUMADDR-1:0];

reg [NUMADDR-1:0]   bitmap_out_temp;

integer i;
always_comb begin
  for(i=0;i<NUMADDR; i=i+1) begin
    bitmap_out_temp[i] = &(~(data[i] ^ key) | mask[i]);
  end
end

reg [NUMADDR-1:0]    bitmap_out;
always @(posedge clk) begin
  if(search ^~ write) begin
    bitmap_out <= {NUMADDR{1'b0}};
  end else if(search) begin
    bitmap_out <= bitmap_out_temp;
  end else if(write) begin
    data [addr] <= key;
    mask [addr] <= mask_in;
  end
end

endmodule
