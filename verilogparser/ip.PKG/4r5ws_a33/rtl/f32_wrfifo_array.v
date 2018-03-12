module f32_wrfifo_array (clk, wrfifo_vwrite_dat, wrfifo_dcnt,  wrfifo_new_dat_out_0, wrfifo_new_dat_out_1, wrfifo_new_dat_out_2, wrfifo_new_dat_sel) ;

   parameter WIDTH = 256 ;
   parameter NUMWRPT = 3 ;
   parameter NUMVBNK = 4 ;
   parameter WFFOCNT = 16 ;
   
    
   input clk;
   output [WIDTH-1:0] wrfifo_new_dat_out_0 [0:NUMVBNK-1];
   output [WIDTH-1:0] wrfifo_new_dat_out_1 [0:NUMVBNK-1];
   output [WIDTH-1:0] wrfifo_new_dat_out_2 [0:NUMVBNK-1];
   //output [WIDTH-1:0] wrfifo_new_dat_out [0:1][0:NUMVBNK-1][0:WFFOCNT-1];
   wire [NUMWRPT*WIDTH-1:0] wrfifo_new_dat_in [0:1][0:NUMVBNK-1][0:WFFOCNT-1];
   input [NUMWRPT-1:0] 	     wrfifo_new_dat_sel [0:1][0:NUMVBNK-1][0:WFFOCNT-1];

   input [WIDTH-1:0] wrfifo_vwrite_dat [0:1][0:NUMVBNK-1][0:WFFOCNT-1];
   input [3:0] wrfifo_dcnt [0:1][0:NUMVBNK-1][0:WFFOCNT-1];
   
   
   reg [WIDTH-1:0] 	     wrfifo_new_dat [0:1][0:NUMVBNK-1][0:WFFOCNT-1];

   genvar p_hilo, bank, fifo_entry;
   generate for(bank=0; bank <NUMVBNK; bank=bank+1) begin : bank_loop
      for(p_hilo=0; p_hilo<2 ; p_hilo=p_hilo+1) begin: p_hilo_loop
	 for(fifo_entry=0; fifo_entry<WFFOCNT; fifo_entry=fifo_entry+1) begin : fifo_entry_loop

	    //reg [WIDTH-1:0] 	     wrfifo_mux_pin [0:NUMWRPT-1];
	    wire [WIDTH-1:0] 	     wrfifo_new_dat_next;
	    /*
	    always_comb
	      begin
		 for(int i=0; i<3; i++)
		    wrfifo_mux_pin[i] = wrfifo_new_dat_in[p_hilo][bank][fifo_entry] >> (i*WIDTH);
	      end
	    */
	    assign wrfifo_new_dat_in [p_hilo][bank][fifo_entry] = {wrfifo_new_dat[p_hilo][bank][fifo_entry], wrfifo_new_dat[p_hilo][bank][fifo_entry+wrfifo_dcnt[p_hilo][bank][fifo_entry]],wrfifo_vwrite_dat[p_hilo][bank][fifo_entry]};
	    
	    mux_3to1_onehot_nbits #(.WIDTH(WIDTH), .BITWIDTH(3), .NUMPRT(3)) mux_inst (.pin(wrfifo_new_dat_in[p_hilo][bank][fifo_entry]), .select(wrfifo_new_dat_sel[p_hilo][bank][fifo_entry]), .pout(wrfifo_new_dat_next));

	    always @ (posedge clk)
	      wrfifo_new_dat[p_hilo][bank][fifo_entry] <= wrfifo_new_dat_next;
	 end
      end
   end // block: bank_loop
   endgenerate

   reg [WIDTH-1:0] wrfifo_new_dat_out_0 [0:NUMVBNK-1];
   reg [WIDTH-1:0] wrfifo_new_dat_out_1 [0:NUMVBNK-1];
   reg [WIDTH-1:0] wrfifo_new_dat_out_2 [0:NUMVBNK-1];

   always_comb begin
      for(int i=0; i<NUMVBNK; i++) begin
	 wrfifo_new_dat_out_0[i] = wrfifo_new_dat[0][i][0];
	 wrfifo_new_dat_out_1[i] = wrfifo_new_dat[0][i][1];
	 wrfifo_new_dat_out_2[i] = wrfifo_new_dat[1][i][0];
      end
   end

endmodule // f32_wrfifo_array

     
     
