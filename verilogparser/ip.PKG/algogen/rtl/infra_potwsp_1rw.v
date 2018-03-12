module infra_potwsp_1rw
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
 
input 				read_0, 
input 				write_0, 
input  [AW - 1:0] 	addr_0, 
input  [DW-1:0] 	bw_0,
input  [DW - 1:0] 	din_0, 
output reg [DW - 1:0] 	dout_0,
output reg				read_vld_0, 
output reg				read_serr_0,
output reg				read_derr_0, 
output [PADW - 1:0] read_padr_0,

output [WSPF - 1:0]			in_read_0, 
output [WSPF - 1:0]			in_write_0, 
output [BNKAW*WSPF - 1:0] 	in_addr_0, 
output [DW*WSPF - 1:0] 		in_bw_0,
output [DW*WSPF - 1:0] 		in_din_0, 
input  [DW*WSPF - 1:0] 		in_dout_0,
input  [WSPF - 1:0]			in_read_vld_0, 
input  [WSPF - 1:0]			in_read_serr_0,
input  [WSPF - 1:0]			in_read_derr_0, 
input  [PADW*WSPF - 1:0] 	in_read_padr_0
);

parameter DIFAW = AW - BNKAW;
wire[BNKAW-1:0] bank_addr_0 	= POTWSPF ?  addr_0 >> DIFAW : addr_0;
wire[DIFAW-1:0] bank_sel_0 	= POTWSPF ? addr_0 : addr_0 >> BNKAW;
wire 		cen_0	   	= read_0 | write_0;
wire[WSPF-1:0]  bank_cen_0 	= cen_0 << bank_sel_0;

assign in_read_0 = {WSPF{read_0}} & bank_cen_0;
assign in_write_0 = {WSPF{write_0}} & bank_cen_0;
assign in_addr_0 = {WSPF{bank_addr_0}};
assign in_bw_0 = {WSPF{bw_0}};
assign in_din_0 = {WSPF{din_0}};

reg  [WSPF*LATENCY-1:0]  bank_cen_reg_0;
always @(posedge clk) begin bank_cen_reg_0 <= bank_cen_0 << WSPF*(LATENCY-1) |  bank_cen_reg_0 >> WSPF; end

integer i;
always @(*) begin
	dout_0 = 'hx; 
	read_vld_0 =0; 
	read_serr_0 = 'hx; 
	read_derr_0 = 'hx;
	for(i=0; i<WSPF; i=i+1) begin
		if(bank_cen_reg_0[i]) begin
			dout_0 = in_dout_0 >> i*DW;
			read_vld_0 = in_read_vld_0[i];
			read_serr_0 = in_read_serr_0[i];
			read_derr_0 = in_read_derr_0[i];
		end
	end
end

endmodule
