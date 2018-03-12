module muxn_noglitch (y, s, x);
   parameter WIDTH = 32;  
   parameter PRT = 32;

   parameter BITPRT = $clog2(PRT);
   

   output [WIDTH-1:0] y;
   //input [PRT*WIDTH-1:0] x; 
   input [WIDTH-1:0] x [0:PRT-1];
   input [BITPRT-1:0] s;


    reg [PRT*WIDTH-1:0] x_s;
    always_comb begin
	x_s = 0;
      for(int i=0; i<PRT; i++) begin	
	  x_s = x_s | (x[i] << (i*WIDTH)); 
      end
    end	

   wire [PRT/2*WIDTH-1:0] mux_dout_wire[0:BITPRT-1];
 
   genvar lv_var, pos_var; 
   generate for(lv_var=0; lv_var<BITPRT; lv_var++) begin
      for(pos_var=0; pos_var<PRT/2; pos_var++) begin
	 if(lv_var==0) begin
	    mux2_noglitch #(WIDTH) mux2_inst (.y(mux_dout_wire[lv_var][(pos_var+1)*WIDTH-1:pos_var*WIDTH]), .s(s[lv_var]), .b(x_s[(2*pos_var+2)*WIDTH-1 : (2*pos_var+1)*WIDTH]), .a(x_s[(2*pos_var+1)*WIDTH-1:2*pos_var*WIDTH]));
	 end
	 else if(pos_var < ((PRT/2)>>lv_var)) begin
	    mux2_noglitch #(WIDTH) mux2_inst (.y(mux_dout_wire[lv_var][(pos_var+1)*WIDTH-1:pos_var*WIDTH]), .s(s[lv_var]), .b(mux_dout_wire[lv_var-1][(2*pos_var+2)*WIDTH-1 : (2*pos_var+1)*WIDTH]), .a(mux_dout_wire[lv_var-1][(2*pos_var+1)*WIDTH-1:2*pos_var*WIDTH]));
	 end
	 else begin
	    assign mux_dout_wire [lv_var][(pos_var+1)*WIDTH-1:pos_var*WIDTH] = 0;
	 end
      end // for (pos_var=0; pos_var<PRT/2; pos_var++)
   end	 
   endgenerate

 
   assign y = mux_dout_wire[BITPRT-1][WIDTH-1:0];
   

endmodule // mux32_noglitch
