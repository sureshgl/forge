module mux_m_nr (pin, select, pout );

   parameter WIDTH  = 32;
   parameter BITWIDTH = 2;
   parameter NUMPRT = 4;
   

   input [WIDTH-1:0]             pin [0:NUMPRT-1];
   output[WIDTH-1:0] 	         pout;
   input [BITWIDTH-1:0] 	 select;

   reg [NUMPRT-1:0] 		 pin_temp [0 : WIDTH-1];
  

   always_comb
      begin
       for(int i=0; i<WIDTH; i++) begin
	  for(int j=0; j<NUMPRT; j++)
	    pin_temp [i][j]= pin [j][i]	;
       end	
      end	
		
   genvar i;
   generate for (i=0 ; i<WIDTH; i++) begin
   	mux_m_1b #(.BITMUXPRT(BITWIDTH)) mux_inst (.in(pin_temp[i]), .sel(select), .out(pout[i]));
    end	
   endgenerate
 	

endmodule 
