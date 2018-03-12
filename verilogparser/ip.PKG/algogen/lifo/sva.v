module sva
#(
  parameter DEPTH=64,
  parameter LG_DEPTH=6,
  parameter WIDTH=8,
  parameter LG_WIDTH=3
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

lifo #(.DEPTH(DEPTH), .LG_DEPTH(LG_DEPTH), .WIDTH(WIDTH))
inst (.*);

reg[LG_DEPTH:0] cnt;
always @(posedge clk) begin
  if(rst) begin
    cnt <= 0;
  end
  else begin
    if(pu_en && !po_en) cnt <= cnt+1; 
    if(po_en && !pu_en) cnt <=  cnt-1;
  end
end

wire [LG_WIDTH-1:0] select_bit;
assume_select_bit: assume property (@(posedge clk) disable iff (rst) select_bit < WIDTH && $stable(select_bit));

property din_dout_2;
integer data;
integer pu_cnt;
//@(posedge clk) disable iff(rst) ((pu_en,data =pu_data,pu_cnt=cnt-po_en) |=>  pop_cnt > pu_cnt || po_data==data );
@(posedge clk) disable iff(rst) (((pu_en,data =pu_data[select_bit],pu_cnt=cnt-po_en) ##1 ((cnt > pu_cnt+1 || !po_en) [*0:$]) ##1 (po_en && cnt ==pu_cnt+1))  |-> ##1  po_data[select_bit] == data);
 // (  ((pop_cnt > pu_cnt) [*1:$] ##1 (pop_cnt == pu_cnt && po_data == data))
 //   or  (pop_cnt==pu_cnt && po_data == data)
 // ));
endproperty
assert_din_dout_2: assert property (din_dout_2);
endmodule
