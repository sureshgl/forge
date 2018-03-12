module ecc_sva
#(
parameter ECCDWIDTH = 120,
parameter ECCWIDTH  = 8,
parameter LG_TWDTH = 7
)
(
input                            clk,
input                            rst,
input [ECCDWIDTH-1:0] din,
input select_err,
input select_derr,
input [LG_TWDTH-1:0] select_err_bit,
input [LG_TWDTH-1:0] select_derr_bit
);

wire[ECCWIDTH-1:0] eccout;

ecc_calc #(.ECCDWIDTH(ECCDWIDTH), .ECCWIDTH(ECCWIDTH))
calc	(.din(din), .eccout(eccout));

wire [ECCDWIDTH+ECCWIDTH-1:0]            eccout_mask; 
wire [ECCDWIDTH-1:0]           dout;  
wire                           sec_err; // asserted if a single error is detected/corrected
wire                           ded_err; // asserted if two errors are detected

assign eccout_mask = {eccout, din} ^ (select_err ? 1 << select_err_bit  | (select_derr ? 1 << select_derr_bit : 0): 0);

ecc_check #(.ECCDWIDTH(ECCDWIDTH), .ECCWIDTH(ECCWIDTH))
check	(.din(eccout_mask[ECCDWIDTH-1:0]), .eccin(eccout_mask[ECCDWIDTH+ECCWIDTH-1:ECCDWIDTH]), .dout(dout), .sec_err(sec_err), .ded_err(ded_err), .clk(clk), .rst(rst));



assume_err_bit_range:  assume property(@(posedge clk) (select_err_bit  < ECCDWIDTH + ECCWIDTH-1));
assume_derr_bit_range: assume property(@(posedge clk) (select_derr_bit < ECCDWIDTH + ECCWIDTH-1 && select_derr_bit != select_err_bit));

assert_noerr: assert property(@(posedge clk) disable iff(rst) (!select_err) |-> (din == dout && sec_err ==0 && ded_err ==0));
assert_serr : assert property(@(posedge clk) disable iff(rst) (select_err && !select_derr) |-> (din == dout && sec_err ==1 && ded_err ==0));
assert_derr : assert property(@(posedge clk) disable iff(rst) (select_err && select_derr) |-> ( ded_err ==1));

endmodule
