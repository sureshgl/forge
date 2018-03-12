module search_fifo
#(
  parameter DEPTH=32,
  parameter LG_DEPTH=5,
  parameter KEY_WIDTH=10,
  parameter DATA_WIDTH=10
)
(
  input rst,
  input clk,
  output reg ready,

  output full,
  output empty,

  input pu_en,
  input [KEY_WIDTH+DATA_WIDTH-1:0] pu_data,

  input po_en,
  output reg [KEY_WIDTH+DATA_WIDTH-1:0] po_data,
  output reg po_vld,

  input sr_en,
  input [KEY_WIDTH-1:0] sr_key,
  output reg [DATA_WIDTH-1:0] sr_data,
  output reg  sr_vld,
  output reg sr_mhe,

  input wr_en,
  input [KEY_WIDTH+DATA_WIDTH-1:0] wr_data,
  input wr_invalidate
);

//This has VALID bit as last bit
reg [KEY_WIDTH+DATA_WIDTH:0] mem [0:DEPTH-1];

reg [LG_DEPTH-1:0] head,tail;
reg [LG_DEPTH:0] count;
assign empty = (count == 0);
assign full  = (count == DEPTH);

always_comb
  {po_data,po_vld} = mem[head][KEY_WIDTH+DATA_WIDTH:0];

reg [DATA_WIDTH-1:0] sr_data_reg;
reg sr_vld_reg;
reg sr_mhe_reg;
always_comb begin
  for(int i=0; i<DEPTH; i=i+1) begin
    if(mem[i][KEY_WIDTH+DATA_WIDTH] && mem[i][KEY_WIDTH-1:0] == sr_key) begin
      if(sr_vld) sr_mhe = 1;
      sr_data = sr_data |  mem[i][KEY_WIDTH+DATA_WIDTH-1:KEY_WIDTH];
      sr_vld = sr_vld | 1;
    end
  end
end

always @(posedge clk) begin
  if(rst) begin
    head <= 0; 
    tail <= 0;
    count <= 0;
    ready <= 1;
  end else begin
    if(!full && pu_en) begin
      mem[tail] <= {pu_data,1'b1};
      if(!po_en) count <= count+1;
      if(tail == DEPTH-1)
        tail <= 0;
      else 
        tail <= tail+1;
    end
    if(!empty && po_en) begin
      mem[head][KEY_WIDTH+DATA_WIDTH] <= 0;
      if(!pu_en) count <= count-1;
      if(head == DEPTH-1) 
        head <= 0;
      else 
        head <= head +1;
    end
    if(!pu_en && !po_en && wr_en) begin
      for(int i=0; i<DEPTH; i++) begin
        if(mem[i][KEY_WIDTH+DATA_WIDTH] && mem[i][KEY_WIDTH-1:0] == wr_data[KEY_WIDTH-1:0]) begin
          mem[i][KEY_WIDTH+DATA_WIDTH:KEY_WIDTH] <= {wr_data[KEY_WIDTH+DATA_WIDTH-1:KEY_WIDTH], !wr_invalidate};
	end
      end
    end
  end
end

endmodule // fifo_basic

