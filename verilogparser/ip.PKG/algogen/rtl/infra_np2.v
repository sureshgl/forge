module infra_np2
#(
parameter NUMADDR = 90000,
parameter BITADDR = 17,
parameter NUMVROW = 2000,
parameter BITVROW = 11,
parameter NUMVBNK = 45,
parameter BITVBNK = 6
)
(
input clk,
input [BITADDR-1:0] addr,
output reg [BITVBNK-1:0] bnk,
output reg [BITVROW-1:0] row
);

`define LG(x)  x <= 1 << 1 ? 1 : x <= 1<<2 ? 2 : x <= 1<<3 ? 3 : x <= 1<<4 ? 4 : x <= 1<<5 ? 5 : x <= 1<<6 ? 6 : x <= 1<<7 ? 7 : x <= 1<<8 ? 8 : x <= 1<<9 ? 9 : x <= 1<<10 ? 10 : x <= 1<<11 ? 11 : x <= 1<<12 ? 12 : x <= 1<<13 ? 13 : x <= 1<<14 ? 14 : x <= 1<<15 ? 15 : x <= 1<<16 ? 16 : x <= 1<<17 ? 17 : x <= 1<<18 ? 18 : x <= 1<<19 ? 19 : x <= 1<<20 ? 20 : x <= 1<<21 ? 21 : x <= 1<<22 ? 22 : x <= 1<<23 ? 23 : x <= 1<<24 ? 24 : x <= 1<<25 ? 25 : x <= 1<<26 ? 26 : x <= 1<<27 ? 27 : x <= 1<<28 ? 28 : x <= 1<<29 ? 29 : x <= 1<<30 ? 30 : x <= 1<<31 ? 31 : x <= 1<<32 ? 32 : -1

`define POPCNT(x) (x >> 0 & 1'b1) + (x >> 1 & 1'b1) + (x >> 2 & 1'b1) + (x >> 3 & 1'b1) + (x >> 4 & 1'b1) + (x >> 5 & 1'b1) + (x >> 6 & 1'b1) + (x >> 7 & 1'b1) + (x >> 8 & 1'b1) + (x >> 9 & 1'b1) + (x >> 10 & 1'b1) + (x >> 11 & 1'b1) + (x >> 12 & 1'b1) + (x >> 13 & 1'b1) + (x >> 14 & 1'b1) + (x >> 15 & 1'b1) + (x >> 16 & 1'b1) + (x >> 17 & 1'b1) + (x >> 18 & 1'b1) + (x >> 19 & 1'b1) + (x >> 20 & 1'b1) + (x >> 21 & 1'b1) + (x >> 22 & 1'b1) + (x >> 23 & 1'b1) + (x >> 24 & 1'b1) + (x >> 25 & 1'b1) + (x >> 26 & 1'b1) + (x >> 27 & 1'b1) + (x >> 28 & 1'b1) + (x >> 29 & 1'b1) + (x >> 30 & 1'b1) + (x >> 31 & 1'b1) 

integer i1;
parameter numOneBnk = `POPCNT(NUMVBNK); 
parameter numOneRow = `POPCNT(NUMVROW); 

parameter REMAINDER = NUMVROW*NUMVBNK >  NUMADDR ? NUMADDR - NUMVROW*(NUMVBNK-1) : 0;
parameter BNKMAJOR = (REMAINDER ==  0 &&  numOneRow > numOneBnk) ? 1 : 0;
parameter POTROWS = 1 << BITVROW > NUMVROW ? 1 << (BITVROW-1) : 1 << BITVROW;
parameter POTBNKS = 1 << BITVBNK > NUMVBNK ? 1 << (BITVBNK-1) : 1 << BITVBNK;

parameter NEW_NUMVROW = NUMVROW- POTROWS;
parameter NEW_BITVROW = `LG(NEW_NUMVROW);
wire [NEW_BITVROW-1:0] row_tmpr;
wire [BITVBNK-1:0] bnk_tmpr;
parameter NEW_NUMADDR_R = NUMADDR - (NUMVBNK-1) * POTROWS - ((REMAINDER == 0 || REMAINDER > POTROWS) ?  POTROWS : REMAINDER);
parameter NEW_BITADDR_R = `LG(NEW_NUMADDR_R);
generate if(!BNKMAJOR && NUMVROW > POTROWS) begin :RowMajor
	infra_np2 #(.NUMADDR(NEW_NUMADDR_R), .BITADDR(NEW_BITADDR_R), .NUMVROW(NEW_NUMVROW), .BITVROW(NEW_BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK))
	np2_recursive(.clk(clk), .addr(addr-(NUMADDR-NEW_NUMADDR_R)), .bnk(bnk_tmpr), .row(row_tmpr));
end
endgenerate

parameter NEW_NUMVBNK = NUMVBNK- POTBNKS;
parameter NEW_BITVBNK = `LG(NEW_NUMVBNK);
wire [BITVROW-1:0] row_tmpb;
wire [NEW_BITVBNK-1:0] bnk_tmpb;
parameter NEW_NUMADDR_B = NUMADDR - NUMVROW * POTBNKS;
parameter NEW_BITADDR_B = `LG(NEW_NUMADDR_B);
generate if(BNKMAJOR && NUMVBNK > POTBNKS) begin : BnkMajor
	infra_np2 #(.NUMADDR(NEW_NUMADDR_B), .BITADDR(NEW_BITADDR_B), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NEW_NUMVBNK), .BITVBNK(NEW_BITVBNK))
	np2_recursive(.clk(clk), .addr(addr-(NUMVROW*POTBNKS)), .bnk(bnk_tmpb), .row(row_tmpb));
end
endgenerate

always @(*) begin
	if(BNKMAJOR) begin
		if(addr < NUMVROW*POTBNKS) begin
			row <= NUMVBNK > POTBNKS ? addr >> (BITVBNK-1) : addr >> BITVBNK;
			bnk <= addr & ~POTBNKS;
		end
		else begin
			row <= row_tmpb;
			bnk <= POTBNKS | bnk_tmpb;
		end
	end
	else begin
		if(addr < NUMADDR - NEW_NUMADDR_R) begin
			row <= addr & ~POTROWS;
			bnk <= NUMVROW > POTROWS ? addr >> (BITVROW-1) : addr >> BITVROW;
		end
		else begin
			row <= POTROWS | row_tmpr;
			bnk <= bnk_tmpr;
		end
	end
end
endmodule
