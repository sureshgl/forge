module mem_sm_mem (
  clk, rst,
  sm_mem_write, sm_mem_wr_adr, sm_mem_din,
  sm_mem_read, sm_mem_rd_adr, sm_mem_rd_dout
);

parameter NUMRPRT = 2;
parameter NUMWPRT = 1;
parameter NUMADDR = 1024;
parameter BITDATA = 45;
parameter BITADDR = 1;

input                        clk;
input                        rst;
input  [NUMWPRT-1:0] sm_mem_write;
input  [BITADDR-1:0] sm_mem_wr_adr  [0:NUMWPRT-1];
input  [BITDATA-1:0] sm_mem_din     [0:NUMWPRT-1];
input  [NUMRPRT-1:0] sm_mem_read;
input  [BITADDR-1:0] sm_mem_rd_adr  [0:NUMRPRT-1];
output [BITDATA-1:0] sm_mem_rd_dout [0:NUMRPRT-1];

generate if (memoir) begin: flpflop_mem

	memoir_ff_mem #(
	      .NUMRPRT(NUMRPRT), .NUMWPRT(NUMWPRT), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .WIDTH(BITDATA), .FLOPOUT(0))
	      mem_sm_mem (.clk(clk), .rst(rst),
	      .write(sm_mem_write), .wr_adr(sm_mem_wr_adr), .din(sm_mem_din), .read(sm_mem_read), .rd_adr(sm_mem_rd_adr), .rd_dout(sm_mem_rd_dout)
	      );

end else begin: nflpflop_mem
        memoir_mem #()
        mem_sm_mem();
end

endmodule
