module ppe_simple_loop(clk,rst,decode,start,encode,valid);
  parameter width = 2048;
  parameter log_width = 11;
  input clk,rst;
  input [width-1:0] decode;
  input [log_width-1:0] start;
  output [log_width-1:0] encode;
  output         valid;

  reg [log_width-1:0]    encode_one,encode_two;
  reg            valid_one,valid_two;

  always_comb begin
    valid_one =0;
    encode_one =0;
    for(integer i=0; i<width; i++) begin
      if(i >= start)
      if(!valid_one && decode[i]) begin
        valid_one =1;
        encode_one = i;
      end
    end
  end
  integer i2;
  always_comb begin
    valid_two=0;
    encode_two=0;
    for(integer i=0; i<width; i++) begin
      if(!valid_two && decode[i]) begin
        valid_two =1;
        encode_two = i;
      end
    end
  end

  assign valid = valid_two;
  assign encode = valid_one ? encode_one : encode_two;

endmodule // encoder_test
