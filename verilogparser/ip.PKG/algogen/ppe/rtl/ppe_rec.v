module ppe_simple_dsbu(clk,rst,decode,start,encode,valid);
  parameter width = 1024;
  parameter log_width = 10;
  input clk,rst;
  input [width-1:0] decode;
  input [log_width-1:0] start;
  output [log_width-1:0] encode;
  output         valid;

  wire [log_width-1:0]    encode_one,encode_two;
  wire            valid_one,valid_two;
  reg [width-1:0]  decode_one;

  integer i;
  always_comb begin
    decode_one = 0;
    for(i=0; i<width; i++) 
      decode_one[i] = decode[i] & (i >= start);
  end

  priority_encode_dsbu#(.width(width), .log_width(log_width))
  pe_one (.clk(clk), .rst(rst), .decode(decode_one), .encode(encode_one), .valid(valid_one));

  priority_encode_dsbu#(.width(width), .log_width(log_width))
  pe_two (.clk(clk), .rst(rst), .decode(decode), .encode(encode_two), .valid(valid_two));
  
  assign valid = valid_two;
  assign encode = valid_one ? encode_one : encode_two;

endmodule // encoder_test
