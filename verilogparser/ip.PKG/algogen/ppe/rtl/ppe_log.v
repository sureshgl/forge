module ppe_log(
  clk,rst,
  decode, start,
  encode,valid
);

parameter width = 1024;
parameter log_width = 10;

localparam pot_width = 1 << log_width;

input                  clk;
input                  rst;
input  [width-1:0]     decode;
input  [log_width-1:0] start;
output [log_width-1:0] encode;
output                 valid;

wire [pot_width-1:0] pot_decode = {pot_width{1'b0}} | decode;

reg [pot_width-1:0] idx [0:log_width-1];
reg [pot_width-1:0] vld [0:log_width-1];
reg [pot_width-1:0] pri [0:log_width-1];

always_comb begin
  idx[0] = 0;
  vld[0] = 0;
  pri[0] = 0;
  for(integer i=0; i<pot_width; i=i+2) begin
    vld[0][i] = pot_decode[i] || pot_decode[i+1];
    idx[0][i] = (start==i+1) ? pot_decode[i+1] : !pot_decode[i];
    pri[0][i] = ((start==i) && pot_decode[i]) || ((start[log_width-1:1]==(i>>1)) && pot_decode[i+1]);
  end
end

genvar lvar;
generate for(lvar=1; lvar<log_width; lvar=lvar+1) begin
  always_comb begin
    idx[lvar] = 0;
    vld[lvar] = 0;
    pri[lvar] = 0;
    for(integer i=0; i<pot_width; i=i+(1<<(lvar+1))) begin
      vld[lvar][i] = vld[lvar-1][i] ||  vld[lvar-1][i+(1<<lvar)];
      idx[lvar][i +: lvar+1] = ((start[log_width-1:lvar]==(i>>lvar) && !pri[lvar-1][i]) || (pri[lvar-1][i+(1<<lvar)])) ?
                                    vld[lvar-1][i+(1<<lvar)] ? {1'b1,idx[lvar-1][i+(1<<lvar) +:lvar]} : {1'b0,idx[lvar-1][i +:lvar]} 
                                  : vld[lvar-1][i] ? {1'b0,idx[lvar-1][i +:lvar]} : {1'b1,idx[lvar-1][i+(1<<lvar) +:lvar]};
      pri[lvar][i] = pri[lvar-1][i] || (start[log_width-1:lvar]==(i>>lvar) && vld[lvar-1][i+(1<<lvar)]) || pri[lvar-1][i+(1<<lvar)];
    end
  end
end
endgenerate

assign valid  = vld[log_width-1][0];
assign encode = idx[log_width-1][0+:log_width];

endmodule // encoder_test
