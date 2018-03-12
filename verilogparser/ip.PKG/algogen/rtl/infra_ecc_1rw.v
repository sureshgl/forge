module infra_ecc_1rw
#(
parameter WORDS = 32,
parameter AW = 5, 
parameter DW = 26,
parameter ECCW = 6,
parameter PADW = 0,
parameter LATENCY = 0
)
(
input clk, 
input rst, 
input refr,
output ready,
 
input 				read_0, 
input 				write_0, 
input  [AW - 1:0] 	addr_0, 
input  [DW - 1:0] 	din_0, 
output [DW - 1:0] 	dout_0,
output 				read_vld_0, 
output 				read_serr_0,
output 				read_derr_0, 
output [PADW - 1:0] read_padr_0,

output 			in_read_0, 
output 			in_write_0, 
output [AW - 1:0] 		in_addr_0, 
output [DW + ECCW - 1:0] 	in_din_0, 
input  [DW + ECCW - 1:0] 	in_dout_0,
input  			in_read_vld_0, 
input  			in_read_serr_0,
input  			in_read_derr_0, 
input  [PADW - 1:0] 	in_read_padr_0
);
	assign in_read_0 = read_0;
	assign in_write_0 = write_0;
	assign in_addr_0 = addr_0;

	wire[ECCW-1:0] eccout;
	wire[DW+ECCW-1:0] err_mask;
	wire sec_err; wire ded_err;
	ecc_calc #(.ECCDWIDTH(DW), .ECCWIDTH(ECCW)) 
	calc    (.din(din_0), .eccout(eccout));
	assign in_din_0 = {eccout, din_0};
	wire [DW+ECCW-1:0] in_dout_0_tmp = in_dout_0 ^ err_mask;

	ecc_check #(.ECCDWIDTH(DW), .ECCWIDTH(ECCW))
	check   (.din(in_dout_0_tmp[DW-1:0]), .eccin(in_dout_0_tmp[DW+ECCW-1:DW]), .dout(dout_0), .sec_err(sec_err), .ded_err(ded_err), .clk(clk), .rst(rst));

	assign read_vld_0 = |in_read_vld_0;
	assign read_serr_0 = |in_read_serr_0 | sec_err;
	assign read_derr_0 = |in_read_derr_0 | ded_err;

`ifdef FORMAL

	wire[AW-1:0] select_addr;
	always_assume_select_addr_range: assume property(@(posedge clk) (select_addr < WORDS));	
	always_assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
	
	assume_1rw_check: assume property(@(posedge clk) disable iff(rst) !(read_0 & write_0));
	
	reg[DW-1:0] mem;
	always @(posedge clk) if(rst) mem <= 0; else if(write_0 && (addr_0 == select_addr)) mem <=  din_0;

	reg[DW+ECCW-1:0] in_mem;
	always @(posedge clk) if(rst) in_mem <= 0; else if(in_write_0 && (in_addr_0 == select_addr)) in_mem <= in_din_0;
	assume_mem_check: assume property (@(posedge clk) disable iff (rst) (in_read_0 && (in_addr_0 == select_addr)) |-> (in_dout_0 == in_mem));

	wire select_err; wire select_derr;
	wire [8-1:0] select_err_bit; wire[8-1:0] select_derr_bit;	

	always_assume_err_bit_range:  assume property(@(posedge clk) disable iff (rst) (select_err_bit  < DW+ECCW-1));
	always_assume_derr_bit_range: assume property(@(posedge clk) disable iff (rst) (select_derr_bit < DW+ECCW-1 && select_derr_bit != select_err_bit));
	

	assign err_mask = select_err ? 1 << select_err_bit  | (select_derr ? 1 << select_derr_bit : 0): 0;

	wire[ECCW-1:0]  eccout_tmp;
	ecc_calc #(.ECCDWIDTH(DW), .ECCWIDTH(ECCW))
        ecc_tmp  (.din(in_dout_0[DW-1:0]), .eccout(eccout_tmp));

	preassert_0_ecctie_0: assert property (@(posedge clk) disable iff(rst) (write_0 && in_addr_0 == select_addr ) |-> ( {calc.eccout, calc.din} == in_din_0));
	preassert_0_ecctie_1: assert property (@(posedge clk) disable iff(rst) (read_0 && in_addr_0 == select_addr) |-> (in_dout_0[ECCW+DW-1:DW] == eccout_tmp));
	
	preassert_1_noerr : assert property (@(posedge clk) disable iff(rst) (read_0 && in_addr_0 == select_addr && {check.eccin, check.din} == in_dout_0 ^ err_mask && !select_err && in_dout_0[ECCW+DW-1:DW] == eccout_tmp) |-> (check.dout == in_dout_0[DW-1:0] && check.sec_err == 0 && check.ded_err == 0));
	preassert_1_serr : assert property (@(posedge clk) disable iff(rst) (read_0 && in_addr_0 == select_addr && {check.eccin, check.din} == in_dout_0 ^ err_mask && select_err && !select_derr && in_dout_0[ECCW+DW-1:DW] == eccout_tmp) |-> (check.dout == in_dout_0[DW-1:0] && check.sec_err == 1 && check.ded_err == 0));
	preassert_1_derr : assert property (@(posedge clk) disable iff(rst) (read_0 && in_addr_0 == select_addr && {check.eccin, check.din} == in_dout_0 ^ err_mask && select_err && select_derr && in_dout_0[ECCW+DW-1:DW] == eccout_tmp) |-> (check.ded_err == 1));

	//preassert_1_noerr: assert property(@(posedge clk) disable iff(rst) (!select_err && read_0 && addr_0 == select_addr) |-> (in_dout_0[DW-1:0] == dout_0 && sec_err == 0 && ded_err ==0));
	//preassert_1_serr : assert property(@(posedge clk) disable iff(rst) (select_err && !select_derr && read_0 &&  addr_0 == select_addr) |-> ( in_dout_0[DW-1:0]== dout_0 && sec_err ==1 && ded_err ==0));
	//preassert_1_derr : assert property(@(posedge clk) disable iff(rst) (select_err && select_derr && read_0 && addr_0 == select_addr) |-> ( ded_err ==1));
	
	
	assert_noerr: assert property(@(posedge clk) disable iff(rst) (!select_err && read_0 && addr_0 == select_addr) |-> (mem == dout_0 && sec_err == 0 && ded_err ==0));
	assert_serr : assert property(@(posedge clk) disable iff(rst) (select_err && !select_derr && read_0 &&  addr_0 == select_addr) |-> (mem == dout_0 && sec_err ==1 && ded_err ==0));
	assert_derr : assert property(@(posedge clk) disable iff(rst) (select_err && select_derr && read_0 && addr_0 == select_addr) |-> ( ded_err ==1));
	
`else
	assign err_mask = 0;
`endif

endmodule

