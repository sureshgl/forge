module infra_subpack_1rw
#(
parameter WORDS = 1000,
parameter AW = 10, 
parameter DW = 8,
parameter PADW = 0,
parameter SPF = 4,
parameter LGSPF = 2,
parameter BNKWORDS = 250,
parameter BNKAW = 8,
parameter BNKDW = 32,
parameter LATENCY = 2
)
(
input clk, 
input rst, 
input refr,
output ready,
 
input 				read_0, 
input 				write_0, 
input  [AW - 1:0] 		addr_0, 
input  [DW-1:0] 		bw_0,
input  [DW - 1:0] 		din_0, 
output reg [DW - 1:0] 		dout_0,
output reg			read_vld_0, 
output reg			read_serr_0,
output reg			read_derr_0, 
output [PADW - 1:0] 		read_padr_0,

output [1 - 1:0]		in_read_0, 
output [1 - 1:0]		in_write_0, 
output [BNKAW - 1:0] 		in_addr_0, 
output reg [BNKDW - 1:0] 		in_bw_0,
output reg [BNKDW - 1:0] 		in_din_0, 
input  [BNKDW - 1:0] 		in_dout_0,
input  [1 - 1:0]		in_read_vld_0, 
input  [1 - 1:0]		in_read_serr_0,
input  [1 - 1:0]		in_read_derr_0, 
input  [PADW - 1:0] 		in_read_padr_0
);

wire [LGSPF-1:0] bnk_sel_0;

np2_addr#(.NUMADDR(WORDS), .BITADDR(AW), .NUMVBNK(SPF), .BITVBNK(LGSPF), .NUMVROW(BNKWORDS), .BITVROW(BNKAW))
np2 (.vaddr(addr_0), .vradr(in_addr_0), .vbadr(bnk_sel_0));

wire cen_0 = read_0 | write_0;
wire[SPF-1:0]  bnk_cen_0 = cen_0 << bnk_sel_0;

reg  [SPF*LATENCY-1:0] bnk_cen_reg_0; 
always @(posedge clk) begin bnk_cen_reg_0 <= bnk_cen_0 << SPF*(LATENCY-1) |  bnk_cen_reg_0 >> SPF; end

assign in_read_0 = read_0;
assign in_write_0 = write_0;

integer i;
always @(*)  begin
	in_bw_0 =0; in_din_0 =0; 
	dout_0 ='hx; read_vld_0 = 0; read_serr_0 = 'hx; read_derr_0 = 'hx;
	for(i=0; i< SPF; i=i+1) begin
		if(bnk_cen_0[i]) begin
			in_bw_0 = 0 | bw_0 << i*DW;
			in_din_0 = 0 | din_0 << i*DW; 
		end
		if(bnk_cen_reg_0[i]) begin
			dout_0 = in_dout_0 >> i*DW; 
			read_vld_0 = 1;
			read_serr_0 = in_read_serr_0;
			read_derr_0 = in_read_derr_0;
		end
	end
end

endmodule
