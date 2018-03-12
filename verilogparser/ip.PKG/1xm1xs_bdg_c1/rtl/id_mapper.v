module id_mapper #(
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
  output [BITID:0]   free_cnt,
  output [NUMID-1:0] id_bsy
);

reg bsy     [0:NUMID-1];
reg bsy_nxt [0:NUMID-1]; 
always @(posedge clk) begin : bsy_f
  if (rst)
    for (integer i=0;i<NUMID;i++)
      bsy[i] <= 1'b0;
  else
    for (integer i=0;i<NUMID;i++)
      bsy[i] <= bsy_nxt[i];
end

genvar bvar;
generate for (bvar=0; bvar<NUMID; bvar++) begin : bsy_map_a
  assign id_bsy[bvar] = bsy[bvar];
end
endgenerate

always_comb begin : bsy_c
  for (integer i=0;i<NUMID;i++) begin
    bsy_nxt[i] = bsy[i];
    if (rmap_0 && (i==rmap_rid_0))
      bsy_nxt[i] = 1'b0;
    if (rmap_1 && (i==rmap_rid_1))
      bsy_nxt[i] = 1'b0;
    if (fmap && fmap_vld && (i==fmap_rid))
      bsy_nxt[i] = 1'b1;
  end
end

reg [BITID:0] free_cnt_reg;
reg [BITID:0] free_cnt_nxt;
always @(posedge clk)
  free_cnt_reg <= free_cnt_nxt;

always_comb begin : free_c
  free_cnt_nxt = NUMID;
  for (integer i=0;i<NUMID;i++)
    free_cnt_nxt = free_cnt_nxt - bsy_nxt[i];
end

assign free_cnt = free_cnt_reg;

reg [BITID-1:0] map     [0:NUMID-1];
reg [BITID-1:0] map_nxt [0:NUMID-1];
always @(posedge clk) begin : map_f
  if (rst)
    for (integer i=0;i<NUMID;i++)
      map[i] <= {BITID{1'b0}};
  else
    for (integer i=0;i<NUMID;i++)
      map[i] <= map_nxt[i];
end

always_comb begin : map_c
  for (integer i=0;i<NUMID;i++) begin
    map_nxt[i] = map[i];
  end
  for (integer i=0;i<NUMID;i++) begin
    if (fmap_vld && (fmap_rid==i))
      map_nxt[i] = fmap_fid;
  end
end
/* impl 0
reg             fmap_vld_wire;
reg [BITID-1:0] fmap_rid_wire;
always_comb begin : fmap_c
  fmap_vld_wire = 1'b0;
  fmap_rid_wire = {BITID{1'b0}};
  for (integer i=0; i<NUMID; i++)
    if (!fmap_vld_wire && !bsy_nxt[i]) begin
      fmap_rid_wire = i;
      fmap_vld_wire = 1'b1;
    end
end
*/
/* impl 1
reg             fmap_vld_wire;
reg [BITID-1:0] fmap_rid_wire;
reg [BITID-1:0] fmap_rid_last;
always_comb begin : fmap_c
  fmap_vld_wire = 1'b0;
  fmap_rid_wire = {BITID{1'b0}};
  for (integer i=fmap_rid_last; i<NUMID; i++)
    if (!fmap_vld_wire && !bsy_nxt[i]) begin
      fmap_rid_wire = i;
      fmap_vld_wire = 1'b1;
    end
  for (integer j=0;j<fmap_rid_last;j++)
    if (!fmap_vld_wire && !bsy_nxt[j]) begin
      fmap_rid_wire = j;
      fmap_vld_wire = 1'b1;
    end
end

always @(posedge clk) 
  if (rst)
    fmap_rid_last <= {BITID{1'b0}};
  else if (fmap && fmap_vld)
    fmap_rid_last <= (fmap_rid == (NUMID-1)) ? {BITID{1'b0}} : (fmap_rid + 1);
*/

reg             fmap_vld_wire;
reg [BITID-1:0] fmap_rid_wire;
reg [NUMID-1:0] fmap_mask;
always_comb begin : fmap_c
  fmap_vld_wire = 1'b0;
  fmap_rid_wire = {BITID{1'b0}};
  for (integer i=0; i<NUMID; i++)
    if (!fmap_vld_wire && fmap_mask[i] && !bsy_nxt[i]) begin
      fmap_rid_wire = i;
      fmap_vld_wire = 1'b1;
    end
  for (integer j=0;j<NUMID;j++)
    if (!fmap_vld_wire && !bsy_nxt[j]) begin
      fmap_vld_wire = 1'b1;
      fmap_rid_wire = j;
    end
end

always @(posedge clk)
  if (rst)
    fmap_mask <= {NUMID{1'b1}};
  else if (fmap && fmap_vld)
    fmap_mask <= ({NUMID{1'b1}} << fmap_rid) << 1;

reg             fmap_vld_reg;
reg [BITID-1:0] fmap_rid_reg;
always @(posedge clk) begin : fmap_f
  fmap_vld_reg <= fmap_vld_wire;
  fmap_rid_reg <= fmap_rid_wire;
end

assign fmap_vld = fmap_vld_reg;
assign fmap_rid = fmap_rid_reg;

assign rmap_vld_0 = bsy[rmap_rid_0];
assign rmap_fid_0 = map[rmap_rid_0];
assign rmap_vld_1 = bsy[rmap_rid_1];
assign rmap_fid_1 = map[rmap_rid_1];
assign rlkp_vld   = bsy[rlkp_rid];
assign rlkp_fid   = map[rlkp_rid];

endmodule // id_mapper_4

