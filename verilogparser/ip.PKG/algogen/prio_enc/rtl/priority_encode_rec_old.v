module priority_encode_rec_old (clk, rst, enables, hit, hit_id);
parameter NUMENTRY = 2048;
parameter BITENTRY = 11;

input clk, rst;
input [NUMENTRY-1:0] enables;
output hit;
output [BITENTRY-1:0] hit_id;

reg [BITENTRY*NUMENTRY-1:0] data;

integer g;
always_comb begin
  data = 0;
  for(g=0; g<NUMENTRY;g = g+1) begin
    data = data | (({BITENTRY{1'b0}} | g) << (g*BITENTRY));
  end
end

priority_encode #(.NUMENTRY(NUMENTRY), .NUMDSIZE(BITENTRY))
pe (.clk(clk), .rst(rst), .enables(enables), .data(data), .hit(hit),  .dout(hit_id));

endmodule

module priority_encode (clk, rst, enables, data, hit, dout);
parameter NUMENTRY = 8;
parameter NUMDSIZE = 16;

input clk,rst;
input [NUMENTRY-1:0] enables;
input [NUMENTRY*NUMDSIZE-1:0] data;

output hit;
output [NUMDSIZE-1:0] dout;

wire hit_local;

assign hit = hit_local;

generate
  if(NUMENTRY==1) begin : pe_one
    assign hit_local = enables[0];
    assign dout = data;
  end
  if (NUMENTRY > 1) begin : pe_more
    parameter LHALF = NUMENTRY/2;
    parameter RHALF = NUMENTRY - LHALF;
    wire hit_l;
    wire hit_r;
    wire [NUMDSIZE-1:0] dout_l;
    wire [NUMDSIZE-1:0] dout_r;
    priority_encode #(.NUMENTRY(LHALF), .NUMDSIZE(NUMDSIZE))
    left_pe (.clk(clk), .rst(rst), .enables(enables[LHALF-1:0]), .data(data[LHALF*NUMDSIZE-1:0]), .hit(hit_l), .dout(dout_l));
    priority_encode #(.NUMENTRY(NUMENTRY-LHALF), .NUMDSIZE(NUMDSIZE))
    right_pe (.clk(clk), .rst(rst), .enables(enables[NUMENTRY-1:LHALF]), .data(data[NUMENTRY*NUMDSIZE-1:LHALF*NUMDSIZE]), .hit(hit_r), .dout(dout_r));
    assign hit_local = hit_l | hit_r;
    assign dout = hit_l ? dout_l : dout_r;
  end
endgenerate

endmodule

