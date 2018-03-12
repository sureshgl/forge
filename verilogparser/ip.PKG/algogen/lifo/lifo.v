module lifo
#(
  parameter DEPTH=32,
  parameter LG_DEPTH=5,
  parameter WIDTH=10
)
(
  input rst,
  input clk,
  output reg ready,

  output full,
  output empty,

  input pu_en,
  input [WIDTH-1:0] pu_data,

  input po_en,
  output reg [WIDTH-1:0] po_data
);

reg [WIDTH-1:0] mem [0:DEPTH-1];

reg [LG_DEPTH:0] cnt;
assign empty = (cnt == 0);
assign full = (cnt == DEPTH);

wire push = !full && pu_en;
wire pop = !empty && po_en;

integer i;
always @(posedge clk) begin
  if(rst) begin
    cnt <= 0;
    ready <= 1;
  end
  else begin
    if(push) begin
      mem[cnt-pop] <= pu_data;
      if(!pop) cnt <= cnt+1;
    end
    if(pop) begin
      po_data <= mem[cnt-1];
      if(!push) cnt <= cnt-1;
    end
  end
end

endmodule
