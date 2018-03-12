module infra_potwsp_2rw
#(
parameter AW = 10, 
parameter DW = 32,
parameter WSPF = 4,
parameter BNKAW = 8,
parameter PADW = 0,
parameter POTWSPF = 1,
parameter LATENCY = 1
)
(
input clk, 
input rst, 
input refr,
output ready,
 
input 				read_0,					input 				read_1, 
input 				write_0,				input 				write_1, 
input  [AW - 1:0] 	addr_0,					input  [AW - 1:0] 	addr_1, 
input  [DW-1:0] 	bw_0,					input  [DW-1:0] 	bw_1,
input  [DW - 1:0] 	din_0,					input  [DW - 1:0] 	din_1, 
output [DW - 1:0] 	dout_0,					output [DW - 1:0] 	dout_1,
output 				read_vld_0,				output 				read_vld_1, 
output 				read_serr_0,			output 				read_serr_1,
output 				read_derr_0,			output 				read_derr_1, 
output [PADW - 1:0] read_padr_0,			output [PADW - 1:0] read_padr_1,

output [WSPF - 1:0]			in_read_0,		output [WSPF - 1:0]			in_read_1, 
output [WSPF - 1:0]			in_write_0,		output [WSPF - 1:0]			in_write_1, 
output [BNKAW*WSPF - 1:0] 	in_addr_0,		output [BNKAW*WSPF - 1:0] 	in_addr_1, 
output [DW*WSPF - 1:0] 		in_bw_0,		output [DW*WSPF - 1:0] 		in_bw_1,
output [DW*WSPF - 1:0] 		in_din_0,		output [DW*WSPF - 1:0] 		in_din_1, 
input  [DW*WSPF - 1:0] 		in_dout_0,		input  [DW*WSPF - 1:0] 		in_dout_1,
input  [WSPF - 1:0]			in_read_vld_0,	input  [WSPF - 1:0]			in_read_vld_1, 
input  [WSPF - 1:0]			in_read_serr_0,	input  [WSPF - 1:0]			in_read_serr_1,
input  [WSPF - 1:0]			in_read_derr_0,	input  [WSPF - 1:0]			in_read_derr_1, 
input  [PADW*WSPF - 1:0] 	in_read_padr_0,	input  [PADW*WSPF - 1:0] 	in_read_padr_1
);

	infra_potwsp_1rw #(.AW(AW), .DW(DW), .WSPF(WSPF), .BNKAW(BNKAW), .PADW(PADW), .POTWSPF(POTWSPF), .LATENCY(LATENCY))
	port1 ( .clk(clk), .rst(rst), .refr(refr), .ready(),
			.read_0(read_0), .write_0(write_0), .addr_0(addr_0), .bw_0(bw_0), .din_0(din_0), .dout_0(dout_0),
			.read_vld_0(read_vld_0), .read_serr_0(read_serr_0), .read_derr_0(read_derr_0), .read_padr_0(read_padr_0), 
			.in_read_0(in_read_0), .in_write_0(in_write_0), .in_addr_0(in_addr_0), .in_bw_0(in_bw_0), .in_din_0(in_din_0), .in_dout_0(in_dout_0),
			.in_read_vld_0(in_read_vld_0), .in_read_serr_0(in_read_serr_0), .in_read_derr_0(in_read_derr_0), .in_read_padr_0(in_read_padr_0));
			
	infra_potwsp_1rw #(.AW(AW), .DW(DW), .WSPF(WSPF), .BNKAW(BNKAW), .PADW(PADW), .POTWSPF(POTWSPF), .LATENCY(LATENCY))
	port2 ( .clk(clk), .rst(rst), .refr(refr), .ready(),
			.read_0(read_1), .write_0(write_1), .addr_0(addr_1), .bw_0(bw_1), .din_0(din_1), .dout_0(dout_1),
			.read_vld_0(read_vld_1), .read_serr_0(read_serr_1), .read_derr_0(read_derr_1), .read_padr_0(read_padr_1), 
			.in_read_0(in_read_1), .in_write_0(in_write_1), .in_addr_0(in_addr_1), .in_bw_0(in_bw_1), .in_din_0(in_din_1), .in_dout_0(in_dout_1),
			.in_read_vld_0(in_read_vld_1), .in_read_serr_0(in_read_serr_1), .in_read_derr_0(in_read_derr_1), .in_read_padr_0(in_read_padr_1));
	
endmodule