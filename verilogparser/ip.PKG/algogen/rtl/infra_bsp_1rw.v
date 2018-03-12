module infra_bsp_1rw
#(
parameter AW = 10, 
parameter DW = 32,
parameter BSPF = 4,
parameter BNKDW = 8,
parameter PADW = 0
)
(
input clk, 
input rst, 
input refr,
output ready,
 
input 				read_0, 
input 				write_0, 
input  [AW - 1:0] 	addr_0, 
input  [DW-1:0] 	bw_0,
input  [DW - 1:0] 	din_0, 
output [DW - 1:0] 	dout_0,
output 				read_vld_0, 
output 				read_serr_0,
output 				read_derr_0, 
output [PADW - 1:0] read_padr_0,

output [BSPF - 1:0]			in_read_0, 
output [BSPF - 1:0]			in_write_0, 
output [AW*BSPF - 1:0] 		in_addr_0, 
output [BNKDW*BSPF - 1:0] 	in_bw_0,
output [BNKDW*BSPF - 1:0] 	in_din_0, 
input  [BNKDW*BSPF - 1:0] 	in_dout_0,
input  [BSPF - 1:0]			in_read_vld_0, 
input  [BSPF - 1:0]			in_read_serr_0,
input  [BSPF - 1:0]			in_read_derr_0, 
input  [PADW*BSPF - 1:0] 	in_read_padr_0
);
	assign in_read_0 = {BSPF{read_0}};
	assign in_write_0 = {BSPF{write_0}};
	assign in_addr_0 = {BSPF{addr_0}};
	assign in_bw_0 = bw_0;
	assign in_din_0 = din_0;
	assign dout_0 = in_dout_0;
	assign read_vld_0 = |in_read_vld_0;
	assign read_serr_0 = |in_read_serr_0;
	assign read_derr_0 = |in_read_derr_0;

endmodule

