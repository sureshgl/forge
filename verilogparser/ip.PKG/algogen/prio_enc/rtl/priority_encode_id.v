module priority_encode_id (global_en, enables, hit, hit_id);
parameter NUMENTRY = 8;
parameter BITENTRY = 3;

input global_en;
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
pe (.global_en(global_en), .enables(enables), .data(data), .hit(hit),  .dout(hit_id));

endmodule

