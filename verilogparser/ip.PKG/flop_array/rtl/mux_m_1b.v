module mux_m_1b (in, sel, out);
  
   parameter BITMUXPRT = 2;
   localparam MUXPRT = 2**BITMUXPRT;

   input [MUXPRT-1:0] 	           in;
   output	          	   out;
   input [BITMUXPRT-1:0]           sel;

   assign out = in [sel];

endmodule

