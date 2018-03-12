module sva
#(
  parameter DEPTH=4,
  parameter LG_DEPTH=2,
  parameter KEY_WIDTH=2,
  parameter DATA_WIDTH=2
)
(
  input rst,
  input clk,
  output reg ready,

  input pu_en,
  input [KEY_WIDTH+DATA_WIDTH-1:0] pu_data,

  input po_en,
  
  input sr_en,
  input [KEY_WIDTH-1:0] sr_key,

  input wr_en,
  input [KEY_WIDTH+DATA_WIDTH-1:0] wr_data,
  input wr_invalidate
);

wire full, empty;
wire [KEY_WIDTH+DATA_WIDTH-1:0] po_data;
wire po_vld;
wire [DATA_WIDTH-1:0] sr_data;
wire sr_vld;
wire sr_mhe;



assume_noPush_onFull: assume property (@(posedge clk) disable iff(rst) full |-> !pu_en );
assume_noPop_onEmpty: assume property (@(posedge clk) disable iff(rst) empty |-> !po_en );

search_fifo #(.DEPTH(DEPTH), .LG_DEPTH(LG_DEPTH), .KEY_WIDTH(KEY_WIDTH), .DATA_WIDTH(DATA_WIDTH))
inst (.*);

reg[LG_DEPTH+1:0] push_cnt,pop_cnt, numElem;
always @(posedge clk) begin
  if(rst) begin
    push_cnt <= 0;
    pop_cnt <= 0;
    numElem <= 0;
  end
  else begin
    if(pu_en) begin
	push_cnt <= (push_cnt +1)%DEPTH;
        if(!po_en) numElem<= numElem+1;
    end
    if(po_en) begin
    	pop_cnt <=  (pop_cnt +1) %DEPTH;
	if(!pu_en) numElem<= numElem-1;
    end
  end
end

wire [LG_DEPTH-1:0] select_addr;
assume_select_addr: assume property (@(posedge clk) disable iff (rst) select_addr < DEPTH && $stable(select_addr));

reg[KEY_WIDTH+DATA_WIDTH-1:0]  mem;
reg initMem;
always @(posedge clk) begin
  if (rst) begin
    mem <= 0;
    initMem <=0;
  end
  else begin
    if(push_cnt == select_addr && pu_en) begin
       mem <= pu_data;
       initMem <= 1;
    end
  end
end  
assert_din_dout_mem: assert property (@(posedge clk) disable iff(rst) (!empty && pop_cnt == select_addr) |-> (po_data == mem));
assert_din_dout_mem_strict: assert property (@(posedge clk) disable iff(rst) (initMem && pop_cnt == select_addr) |-> (po_data == mem));
assert_not_full_and_empty: assert property(@(posedge clk) disable iff(rst) (!full || !empty));
assert_empty_at_rst: assert property(@(posedge clk) ($fell(rst) |-> empty));
assert_can_be_full : assert property(@(posedge clk) disable iff(rst) (numElem == DEPTH |-> full));
assert_never_overflow : assert property(@(posedge clk) disable iff(rst) (numElem < DEPTH+1));

endmodule
