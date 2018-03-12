module sva
#(
  parameter WIDTH=61,
  parameter LG_WIDTH=6
)
(
  input clk,
  input rst,
  input [WIDTH-1:0]    decode,
  input [LG_WIDTH-1:0] start
);

wire [LG_WIDTH-1:0] encode_simple, encode;
wire valid_simple, valid;

ppe_simple_loop #(.width(WIDTH), .log_width(LG_WIDTH))
simple (.clk(clk), .rst(rst), .decode(decode), .start(start), .encode(encode_simple), .valid(valid_simple));

ppe_log #(.width(WIDTH), .log_width(LG_WIDTH))
other (.clk(clk), .rst(rst), .decode(decode), .start(start), .encode(encode), .valid(valid));

assert_check_valid : assert property (@(posedge clk) (valid_simple === valid)); 
assert_check_encode : assert property (@(posedge clk) (valid |-> (encode_simple === encode))); 

endmodule
