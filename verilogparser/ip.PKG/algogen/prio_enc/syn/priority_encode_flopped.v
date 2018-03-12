module priority_encode_flopped(clk,rst,decode,encode,valid);
  parameter width = 1024;
  parameter log_width = 10;
  input clk,rst;
  input [width-1:0] decode;
  output [log_width-1:0] encode;
  output         valid;

  reg [width-1:0] decode_reg;
  reg [log_width-1:0] encode_reg;
  reg valid_reg;
  wire [ width-1:0] decode_wire;
  wire [log_width-1:0] encode_wire;
  wire valid_wire;

  always @(posedge clk) begin
    decode_reg <= decode;
    encode_reg <= encode_wire;
    valid_reg <= valid_wire;
  end
  assign encode = encode_reg;
  assign valid = valid_reg; 
  assign decode_wire = decode_reg;

  priority_encode_log#(.width(width), .log_width(log_width))
  pe (.clk(clk), .rst(rst), .decode(decode_wire), .encode(encode_wire), .valid(valid_wire));

endmodule

