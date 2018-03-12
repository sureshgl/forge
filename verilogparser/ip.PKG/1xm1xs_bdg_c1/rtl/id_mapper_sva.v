module id_mapper_sva #(
  parameter NUMID = 16,
  parameter BITID = 4
)
(
  input              clk,
  input              rst,
  input              fmap,
  input  [BITID-1:0] fmap_fid,
  output             fmap_vld,
  output [BITID-1:0] fmap_rid,
  input              rlkp,
  input  [BITID-1:0] rlkp_rid,
  output             rlkp_vld,
  output [BITID-1:0] rlkp_fid,
  input              rmap_0,
  input  [BITID-1:0] rmap_rid_0,
  output             rmap_vld_0,
  output [BITID-1:0] rmap_fid_0,
  input              rmap_1,
  input  [BITID-1:0] rmap_rid_1,
  output             rmap_vld_1,
  output [BITID-1:0] rmap_fid_1,
  output [BITID:0]   free_cnt
);

id_mapper #(
  .NUMID(NUMID),
  .BITID(BITID)
)
core (
  .*
);

reg [BITID-1:0] map     [0:NUMID-1];
reg             map_vld [0:NUMID-1];
always @(posedge clk)
  if (rst)
    for(integer i=0;i<NUMID;i++) begin
      map[i] <= {BITID{1'b0}};
      map_vld[i] <= 1'b0;
    end
  else begin
    if (fmap && fmap_vld) begin
      map[fmap_rid] <= fmap_fid;
      map_vld[fmap_rid] <= 1'b1;
    end
    if (rmap_0 && rmap_vld_0) begin
      map_vld[rmap_rid_0] <= 1'b0;
    end
    if (rmap_1 && rmap_vld_1) begin
      map_vld[rmap_rid_1] <= 1'b0;
    end
  end

assert_rmap0_match: assert property (@(posedge clk) disable iff (rst) (rmap_0 && map_vld[rmap_rid_0])  |-> ##0 (rmap_vld_0 && (rmap_fid_0 == map[rmap_rid_0])));
assert_rmap1_match: assert property (@(posedge clk) disable iff (rst) (rmap_1 && map_vld[rmap_rid_1])  |-> ##0 (rmap_vld_1 && (rmap_fid_1 == map[rmap_rid_1])));
assert_rlkp_match : assert property (@(posedge clk) disable iff (rst) (rlkp   && map_vld[rlkp_rid])    |-> ##0 (rlkp_vld   && (rlkp_fid   == map[rlkp_rid]  )));
assert_fmap_vld   : assert property (@(posedge clk) disable iff (rst) (fmap_vld |-> ((free_cnt!=0) && !map_vld[fmap_rid])));
assert_free_cnt_range : assert property (@(posedge clk) disable iff (rst) (free_cnt<=NUMID));

assume_id_range   : assert property (@(posedge clk) disable iff (rst) ((fmap_fid<NUMID) && (rmap_rid_0<NUMID) && (rmap_rid_1<NUMID) && (rlkp_rid<NUMID)))
  else $display("[ERROR:memoir:%m:%0t] bad id range fmap_fid=0x%0x rmap_rid_0=0x%0x rmap_rid_1=0x%0x rlkp_rid=0x%0x", $time, fmap_fid, rmap_rid_0, rmap_rid_1, rlkp_rid);

endmodule

