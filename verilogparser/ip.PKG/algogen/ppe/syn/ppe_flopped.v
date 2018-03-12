module ppe_flopped(clk,rst,decode,start,encode,valid);
  parameter width = 1024;
  parameter log_width = 10;
  input clk,rst;
  input [width-1:0] decode;
  input [log_width-1:0] start;
  output [log_width-1:0] encode;
  output         valid;

  reg [width-1:0] decode_reg;
  reg [log_width-1:0] start_reg;
  reg [log_width-1:0] encode_reg;
  reg valid_reg;
  wire [ width-1:0] decode_wire;
  wire [log_width-1:0] start_wire;
  wire [log_width-1:0] encode_wire;
  wire valid_wire;

  always @(posedge clk) begin
    decode_reg <= decode;
    start_reg <= start;
    encode_reg <= encode_wire;
    valid_reg <= valid_wire;
  end
  assign encode = encode_reg;
  assign valid = valid_reg; 
  assign decode_wire = decode_reg;
  assign start_wire = start_reg;

  ppe_log#(.width(width), .log_width(log_width))
  ppe (.clk(clk), .rst(rst), .decode(decode_wire), .start(start_wire), .encode(encode_wire), .valid(valid_wire));

endmodule

