module priority_encode_comb (clk, rst, in_vld, in_dat, res_idx, res_dat, res_vld);
  parameter NUMELEM = 4;
  parameter BITDATA = 3;
  localparam BITELEM = NUMELEM>1 ? $clog2(NUMELEM) : 1;
  localparam POTELEM = (1 << BITELEM);

  input               clk;
  input               rst;

  input [NUMELEM-1:0] in_vld;
  input [BITDATA-1:0] in_dat [0:NUMELEM-1];

  output [BITELEM-1:0] res_idx;
  output [BITDATA-1:0] res_dat; 
  output               res_vld;

  reg               vld_tree [0:BITELEM][0:POTELEM-1];
  reg [BITDATA-1:0] dat_tree [0:BITELEM][0:POTELEM-1];
  reg [BITELEM-1:0] idx_tree [0:BITELEM][0:POTELEM-1];


  generate 
    if(NUMELEM==1) begin: zero_loop
      assign res_idx = 0;
      assign res_dat = in_dat[0];
      assign res_vld = in_vld[0];
    end
    else begin: non_zero_loop
      always_comb begin
        for(integer l=0; l<=BITELEM; l=l+1) begin
          for(integer i=0; i<POTELEM; i=i+1) begin
            idx_tree[l][i] = l==0 ? i : '0;
            dat_tree[l][i] = (l==0 && i<NUMELEM)? in_dat[i] : '0;
            vld_tree[l][i] = (l==0 && i<NUMELEM)? in_vld[i] : '0;
          end
        end
        for(integer i=1; i<=BITELEM; i=i+1) begin
          for(integer j=0; j<(POTELEM>>i); j=j+1) begin
            idx_tree[i][j] = vld_tree[i-1][2*j] ? idx_tree[i-1][2*j] : idx_tree[i-1][2*j+1];
            dat_tree[i][j] = vld_tree[i-1][2*j] ? dat_tree[i-1][2*j] : dat_tree[i-1][2*j+1];
            vld_tree[i][j] = vld_tree[i-1][2*j] || vld_tree[i-1][2*j+1];
          end
        end
      end
    end
  endgenerate

  assign res_vld = vld_tree[BITELEM][0];
  assign res_idx = idx_tree[BITELEM][0];
  assign res_dat = dat_tree[BITELEM][0];

`ifdef FORMAL
  reg [BITELEM-1:0] winner;
  reg               winner_vld;
  reg [BITDATA-1:0] winner_dat;
  always_comb begin
    winner_vld = 0;
    winner = 0;
    winner_dat = 0;
    for(integer i=NUMELEM-1; i>=0; i=i-1) 
      if(in_vld[i]) begin
        winner_vld = 1;
        winner = i;
        winner_dat = in_dat[i];
      end
  end

assert_res_vld_check: assert property (@(posedge clk) disable iff(rst) winner_vld == res_vld);
assert_res_idx_check: assert property (@(posedge clk) disable iff(rst) winner_vld |-> winner == res_idx);
assert_res_dat_check: assert property (@(posedge clk) disable iff(rst) winner_vld |-> winner_dat == res_dat);
`endif

endmodule
