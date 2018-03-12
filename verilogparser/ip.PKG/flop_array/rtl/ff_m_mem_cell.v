module ff_m_mem_cell (clk, din, dout, addr, bw, write, bd_write, bd_data);

 parameter NUMWRPT = 2;
 parameter BITADDR = 4;
 parameter FF_DEPTH = 2 ** BITADDR;      
 localparam DEPTH = 2 ** BITADDR;
 
 input   clk;
 input   [NUMWRPT-1:0] write;
 input   [NUMWRPT*BITADDR-1:0] addr;
 input   [NUMWRPT-1:0] din;
 input   [NUMWRPT-1:0] bw;  
 output  [DEPTH-1:0] dout ;
 input 	             bd_write;
 input   [DEPTH-1:0]   bd_data; 
 

 reg [FF_DEPTH-1:0] memoir_ff_array_flops;
 reg [FF_DEPTH-1:0] flop_mem_nxt;

 always_comb
   begin
      flop_mem_nxt = memoir_ff_array_flops;
      for(int i=0; i<NUMWRPT; i++)
	begin
	   if(write[i] & bw[i])
	     flop_mem_nxt [addr[(i+1)*BITADDR-1 -: BITADDR]] = din[i];
	   //synopsys translate_off
	   else if (bd_write)
	     flop_mem_nxt = bd_data;
	   //synopsys translate_on
	end
   end // always_comb

 always @ (posedge clk)
   memoir_ff_array_flops <= flop_mem_nxt;
   
 assign dout = memoir_ff_array_flops;


 `ifdef FORMAL
   assert_wr_sanity_check: assert property (@(posedge clk) (write[0] && addr[BITADDR-1:0] == 0) |-> ##1 (memoir_ff_array_flops[0] == $past(din[0],1)));
 `endif
    
endmodule
