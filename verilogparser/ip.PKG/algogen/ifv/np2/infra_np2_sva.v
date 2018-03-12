module infra_np2_sva
#(
parameter NUMADDR = 20000-41,
parameter BITADDR = 15,
parameter NUMVROW = 200,
parameter BITVROW = 8,
parameter NUMVBNK = 100,
parameter BITVBNK = 7
)
(
input clk,
input [BITADDR-1:0] addr_1,
input [BITADDR-1:0] addr_2
//input [BITADDR-1:0] select_addr_1,
//input [BITADDR-1:0] select_addr_2
);

//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr_1 < NUMADDR));
//assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr_1));
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr_2 < NUMADDR));
//assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr_2));

assume_select_addr_range_1: assume property (@(posedge clk) (addr_1 < NUMADDR));
assume_select_addr_range_2: assume property (@(posedge clk) (addr_2 < NUMADDR));

wire [BITVBNK-1:0] bnk_1;
wire [BITVBNK-1:0] bnk_2;
wire [BITVROW-1:0] row_1;
wire [BITVROW-1:0] row_2;

`ifdef OLD_NP2
	np2_addr #(.NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK))
	np2_1 (.vaddr(addr_1), .vbadr(bnk_1), .vradr(row_1));
	
	np2_addr #(.NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK))
	np2_2 (.vaddr(addr_2), .vbadr(bnk_2), .vradr(row_2));

`else
	infra_np2 #(.NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK))
	np2_1 (.clk(clk), .addr(addr_1), .bnk(bnk_1), .row(row_1));

	infra_np2 #(.NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK))
	np2_2 (.clk(clk), .addr(addr_2), .bnk(bnk_2), .row(row_2));
`endif

assert_inequal : assert property(@(posedge clk) (addr_1 != addr_2) |-> (bnk_1 != bnk_2 || row_1 != row_2));
assert_equal : assert property(@(posedge clk)  (addr_1 == addr_2) |-> (bnk_1 == bnk_2 || row_1 == row_2));

assert_range_1 : assert property(@(posedge clk) (bnk_1 < NUMVBNK && row_1 < NUMVROW));
assert_range_2 : assert property(@(posedge clk) (bnk_2 < NUMVBNK && row_2 < NUMVROW));


assert_remainder_1 : assert property(@(posedge clk) (NUMADDR < NUMVBNK*NUMVROW && bnk_1 == NUMVBNK-1) |-> ( row_1 < NUMADDR - NUMVROW*(NUMVBNK-1)));
assert_remainder_2 : assert property(@(posedge clk) (NUMADDR < NUMVBNK*NUMVROW && bnk_2 == NUMVBNK-1) |-> ( row_2 < NUMADDR - NUMVROW*(NUMVBNK-1)));

endmodule
