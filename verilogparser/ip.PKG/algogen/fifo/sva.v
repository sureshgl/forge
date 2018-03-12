module sva
#(
  parameter DEPTH=16,
  parameter LG_DEPTH=4,
  parameter WIDTH=2,
  parameter LG_WIDTH=1
)
(
  input rst,
  input clk,
  output reg ready,


  input pu_en,
  input [WIDTH-1:0] pu_data,

  input po_en
);

wire full, empty;
wire [WIDTH-1:0] po_data;

assume_noPush_onFull: assume property (@(posedge clk) disable iff(rst) full |-> !pu_en );
assume_noPop_onEmpty: assume property (@(posedge clk) disable iff(rst) empty |-> !po_en );

fifo_basic #(.DEPTH(DEPTH), .LG_DEPTH(LG_DEPTH), .WIDTH(WIDTH))
inst (.*);


/*property fifo;
integer pd1,pd2;
@(posedge clk) disable iff (rst) (((pu_en,pd1=pu_data) ##1 ((po_data!=pd1 && !empty)[*0:$]) ##1 (!empty && pu_en,pd2=pu_data)) |-> !empty[*100] or (##[0:$] po_data == pd1  ##[1:$] po_data==pd2));
endproperty
assert_fifo: assert property (fifo);
*/
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
//wire [LG_WIDTH-1:0] select_bit;
//assume_select_bit: assume property (@(posedge clk) disable iff (rst) select_bit < WIDTH && $stable(select_bit));

//property din_dout_2;
//@(posedge clk) disable iff(rst) (((pu_en && push_cnt==select_addr,data =pu_data[select_bit]) ##1 ((pop_cnt != select_addr || !po_en) [*0:$]) ##1 (po_en && pop_cnt ==select_addr))  |-> ##1  po_data[select_bit] == data);
//integer data;
//integer pu_cnt;
//@(posedge clk) disable iff(rst) (((pu_en,data =pu_data,pu_cnt=push_cnt) ##1 ((pop_cnt != pu_cnt || !po_en) [*0:$]) |=>( (po_en && pop_cnt ==pu_cnt))  |-> ##1  po_data== data));
//@(posedge clk) disable iff(rst) (((pu_en,data =pu_data,pu_cnt=push_cnt) ##1 ((pop_cnt != pu_cnt || !po_en) [*0:$]) ##1 (po_en && pop_cnt ==pu_cnt))  |-> ##1  po_data== data);
//integer data; integer cnt;
//@(posedge clk) disable iff(rst) ((pu_en,data =pu_data,cnt=(push_cnt+1)%DEPTH) |->  ( pop_cnt != cnt ||  po_data==data) [*DEPTH+1]);
//endproperty
//assert_din_dout_2: assert property (din_dout_2);

reg[WIDTH-1:0]  mem;
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
