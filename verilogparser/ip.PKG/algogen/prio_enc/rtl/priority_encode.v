module priority_encode (global_en, enables, data, hit, dout);
parameter NUMENTRY = 8;
parameter NUMDSIZE = 16;

input global_en;
input [NUMENTRY-1:0] enables;
input [NUMENTRY*NUMDSIZE-1:0] data;

output hit;
output [NUMDSIZE-1:0] dout;

wire hit_local;

assign hit = hit_local & global_en;

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
    left_pe (.global_en(1'b1), .enables(enables[LHALF-1:0]), .data(data[LHALF*NUMDSIZE-1:0]), .hit(hit_l), .dout(dout_l));
    priority_encode #(.NUMENTRY(NUMENTRY-LHALF), .NUMDSIZE(NUMDSIZE)) 
    right_pe (.global_en(1'b1), .enables(enables[NUMENTRY-1:LHALF]), .data(data[NUMENTRY*NUMDSIZE-1:LHALF*NUMDSIZE]), .hit(hit_r), .dout(dout_r));
    assign hit_local = hit_l | hit_r;
    assign dout = hit_l ? dout_l : dout_r;
  end
endgenerate

endmodule

