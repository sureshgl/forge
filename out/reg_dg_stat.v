module reg_dg_stat (
  clk, rst,
  cwrite, cdin, cwack, cdout,
  dg_stat_fl1, dg_stat_fl1_wr, dg_stat_fl1_din,
  dg_stat_nms, dg_stat_nms_wr, dg_stat_nms_din,
  dg_stat_xen, dg_stat_xen_wr, dg_stat_xen_din,
  dg_stat_cnt, dg_stat_cnt_wr, dg_stat_cnt_din
);

localparam BITDATA = 22;
localparam FLOPODT = 0;
localparam FLOPOFL = 0;

localparam BITOFST_FL1 = 0;
localparam BITOFST_NMS = 2;
localparam BITOFST_XEN = 4;
localparam BITOFST_CNT = 16;
  

localparam BITDATA_FL1 = 0;
localparam BITDATA_NMS = 0;
localparam BITDATA_XEN = 0;
localparam BITDATA_CNT = 1'b0;
  

input                clk;
input                rst;
input                cwrite;
output               cwack;
input  [BITDATA-1:0] cdin;
output [BITDATA-1:0] cdout;

output [BITDATA_FL1-1:0] dg_stat_fl1; 
 
input  [BITDATA_FL1-1:0] dg_stat_fl1_din;
input                    dg_stat_fl1_wr;
output [BITDATA_NMS-1:0] dg_stat_nms; 
 
input  [BITDATA_FL1-1:0] dg_stat_nms_din;
input                    dg_stat_nms_wr;
output [BITDATA_XEN-1:0] dg_stat_xen; 
 
input  [BITDATA_FL1-1:0] dg_stat_xen_din;
input                    dg_stat_xen_wr;
output [BITDATA_CNT-1:0] dg_stat_cnt; 
 
input  [BITDATA_FL1-1:0] dg_stat_cnt_din;
input                    dg_stat_cnt_wr;


wire fwrite = (dg_stat_fl1 || dg_stat_nms || dg_stat_xen ||  dg_stat_cnt); 

wire cwack  = cwrite & !fwrite;

wire fl1_write = dg_stat_fl1_wr || cwack; 
wire nms_write = dg_stat_nms_wr || cwack; 
wire xen_write = dg_stat_xen_wr || cwack; 
wire cnt_write = dg_stat_cnt_wr || cwack; 


wire [BITDATA_FL1-1:0] fl1_din = cdin >> BITOFST_FL1; 
wire [BITDATA_NMS-1:0] nms_din = cdin >> BITOFST_NMS; 
wire [BITDATA_XEN-1:0] xen_din = cdin >> BITOFST_XEN; 
wire [BITDATA_CNT-1:0] cnt_din = cdin >> BITOFST_CNT; 


wire [BITDATA_FL1-1:0] fl1_rdin = 'b0; 
wire [BITDATA_NMS-1:0] nms_rdin = 'b0; 
wire [BITDATA_XEN-1:0] xen_rdin = 'b0; 
wire [BITDATA_CNT-1:0] cnt_rdin = 'b0; 



wire [BITDATA_FL1-1:0] fl1_dout; 
wire [BITDATA_NMS-1:0] nms_dout; 
wire [BITDATA_XEN-1:0] xen_dout; 
wire [BITDATA_CNT-1:0] cnt_dout; 


conf_reg #(.BITDATA(BITDATA_FL1))
  fl1 (
    .clk(clk),
    .rst(rst), .rdin(fl1_rdin),
    .write (fl1_write), .din(fl1_din),
    .dout(fl1_dout)
  );
conf_reg #(.BITDATA(BITDATA_NMS))
  nms (
    .clk(clk),
    .rst(rst), .rdin(nms_rdin),
    .write (nms_write), .din(nms_din),
    .dout(nms_dout)
  );
conf_reg #(.BITDATA(BITDATA_XEN))
  xen (
    .clk(clk),
    .rst(rst), .rdin(xen_rdin),
    .write (xen_write), .din(xen_din),
    .dout(xen_dout)
  );
conf_reg #(.BITDATA(BITDATA_CNT))
  cnt (
    .clk(clk),
    .rst(rst), .rdin(cnt_rdin),
    .write (cnt_write), .din(cnt_din),
    .dout(cnt_dout)
  );



reg  [BITDATA-1:0]     cdout;
reg  [BITDATA-1:0]     cdout_c;


always_comb begin : do_l
  cdout_c  = {BITDATA{1'b0}};
  cdout_c |= fl1_dout << BITOFST_FL1;
  cdout_c |= nms_dout << BITOFST_NMS;
  cdout_c |= xen_dout << BITOFST_XEN;
  cdout_c |= cnt_dout << BITOFST_CNT;

end

generate if (FLOPODT) begin : fo_loop
  always_comb
    cdout = cdout_c;
end else begin : fo_loop
  always @(posedge clk)
    cdout <= cdout_c;
end
endgenerate

endmodule