module sva
#(
  parameter WIDTH=400,
  parameter LG_WIDTH=9
)
(
  input clk,
  input rst,
  input [WIDTH-1:0] decode
);

wire [LG_WIDTH-1:0] encode_simple, encode;
wire valid_simple, valid;

priority_encode_simple #(.width(WIDTH), .log_width(LG_WIDTH))
simple (.clk(clk), .rst(rst), .decode(decode), .encode(encode_simple), .valid(valid_simple));

priority_encode_dsbu_shadow #(.width(WIDTH), .log_width(LG_WIDTH))
other (.clk(clk), .rst(rst), .decode(decode), .encode(encode), .valid(valid));

assert_check_valid : assert property (@(posedge clk) (valid_simple === valid)); 
assert_check_encode : assert property (@(posedge clk) (valid |-> (encode_simple === encode))); 

endmodule
