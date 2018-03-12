module sva
#(
  parameter KEYWIDTH=320
)
(
  input clk,
  input [KEYWIDTH-1:0] key
);


  
genvar CRCWIDTH;
genvar CRCPOLYID;

generate 
  for(CRCWIDTH=7; CRCWIDTH<16; CRCWIDTH=CRCWIDTH+1) begin
    for(CRCPOLYID=0; CRCPOLYID<16; CRCPOLYID=CRCPOLYID+1) begin
      wire [CRCWIDTH-1:0] crc;
      wire [CRCWIDTH-1:0] rev_crc;

      crc_calc #(.KEYWIDTH(KEYWIDTH), .CRCWIDTH(CRCWIDTH), .CRCPOLYID(CRCPOLYID))
      crc_calc (.clk(clk), .key(key), .result(crc));

      crc_reverse #(.KEYWIDTH(KEYWIDTH), .CRCWIDTH(CRCWIDTH), .CRCPOLYID(CRCPOLYID))
      crc_rev (.clk(clk), .key(key[KEYWIDTH-1:CRCWIDTH]), .crc(crc),  .result(rev_crc));

      assert_check : assert property (@(posedge clk) (rev_crc === key[CRCWIDTH-1:0]));
    end
  end
endgenerate
endmodule
