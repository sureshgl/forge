module priority_encode_rec (clk,rst,decode,encode,valid);
  parameter width = 2048;
  parameter log_width = 11;
  input clk,rst;
  input [width-1:0] decode;
  output [log_width-1:0] encode;
  output         valid;

  parameter potWidth = (1 << log_width);
  wire [potWidth-1:0] potDecode = (potWidth > width) ? {{(potWidth-width){1'b0}}, decode} : decode;

  priority_encode_pot#(.width(potWidth), .log_width(log_width)) 
  pot (.clk(clk), .rst(rst), .decode(potDecode), .encode(encode), .valid(valid));

endmodule

module priority_encode_pot (clk,rst,decode,encode,valid);
  parameter width = 2048;
  parameter log_width = 11;
  input clk,rst;
  input [width-1:0] decode;
  output [log_width-1:0] encode;
  output         valid;
  generate 
    if(width==2) begin
      assign encode = !decode[0];
      assign valid = decode[0] | decode[1];
    end
    else if(width > 2) begin
      wire [log_width-2:0]    encode_l, encode_r;
      wire valid_l, valid_r;
      priority_encode_pot #(.width(width/2), .log_width(log_width-1)) 
      left (.clk(clk), .rst(rst), .decode(decode[width/2-1:0]), .encode(encode_l), .valid(valid_l));
      priority_encode_pot #(.width(width/2), .log_width(log_width-1)) 
      right (.clk(clk), .rst(rst), .decode(decode[width-1:width/2]), .encode(encode_r), .valid(valid_r));
      reg [log_width-1:0] encode_reg;
      integer i;
      always_comb begin
        encode_reg[log_width-1] = !valid_l;
        for(i=0; i< log_width-1; i++)
          encode_reg[i] = encode_l[i] & (valid_l || encode_r[i]);
      end
      assign encode = encode_reg;
      
      //assign encode = {!valid_l, (valid_l ? encode_l : encode_r)};
      assign valid = valid_l | valid_r;
    end
  endgenerate

endmodule // encoder_test
