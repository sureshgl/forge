module priority_encode_simple (clk,rst,decode,encode,valid);
  parameter width = 512;
  parameter log_width = 9;
  input clk,rst;
  input [width-1:0] decode;
  output [log_width-1:0] encode;
  output         valid;

  reg [log_width-1:0]    encode;
  reg            valid;

  integer i;
  always_comb begin
    valid =0;
    encode =0;
    for(i=0; i<width; i++) begin
      if(!valid & decode[i]) begin
        valid =1;
        encode = i;
      end
    end
  end
endmodule // encoder_test
