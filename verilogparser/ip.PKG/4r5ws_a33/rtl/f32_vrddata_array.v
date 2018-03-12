module f32_vrddata_array (clk, sel, din, dout, prt, ptr);

   parameter WIDTH = 256;
   parameter NUMRDPT = 4;
   parameter NUMVBNK = 4;
   parameter READ_DELAY = 30;
   parameter BITRDPT = 2;
   parameter BITRDLY = 5;
   
   input clk;
   input [2:0] sel [0:NUMVBNK-1];
   input [2*WIDTH-1:0] din [0:NUMVBNK-1];
   input [2*BITRDPT-1:0] prt [0:NUMVBNK-1];
   input [2*BITRDLY-1:0] ptr [0:NUMVBNK-1];
   output [WIDTH-1:0]  dout [0:NUMRDPT-1][0:READ_DELAY-1];
   
   reg [WIDTH-1:0]     vrddata_reg [0:NUMRDPT-1][0:READ_DELAY-1];
   reg [WIDTH-1:0]     vrddata_reg_wire [0:NUMRDPT-1][0:READ_DELAY-1];
   wire [WIDTH-1:0]    vrddata_reg_din0 [0:NUMVBNK-1];
   wire [WIDTH-1:0]    vrddata_reg_din1 [0:NUMVBNK-1];
   wire [2:0] sel_wire0 [0:NUMVBNK-1];
   wire [2:0] sel_wire1 [0:NUMVBNK-1];
   
   genvar 	       vrdb_intr;
   generate for (vrdb_intr=0; vrdb_intr<NUMVBNK; vrdb_intr=vrdb_intr+1) begin

      assign sel_wire0 [vrdb_intr] = (sel[vrdb_intr] == 3'b100)? 3'b001 : sel[vrdb_intr];
      assign sel_wire1 [vrdb_intr] = (sel[vrdb_intr] == 3'b100)? 3'b010 : 3'b000;
      
      mux_3to1_onehot_nbits #(.WIDTH(WIDTH), .BITWIDTH(3), .NUMPRT(3)) mux_inst0 (.pin({{WIDTH{1'b0}},din[vrdb_intr]}), .select(sel_wire0[vrdb_intr]), .pout(vrddata_reg_din0[vrdb_intr]));
      
      mux_3to1_onehot_nbits #(.WIDTH(WIDTH), .BITWIDTH(3), .NUMPRT(3)) mux_inst1 (.pin({{WIDTH{1'b0}},din[vrdb_intr]}), .select(sel_wire1[vrdb_intr]), .pout(vrddata_reg_din1[vrdb_intr]));
   end
   endgenerate
  
     always_comb begin
	for(int r_ptr=0; r_ptr<NUMRDPT; r_ptr++)
	  for(int d_ptr=0; d_ptr<READ_DELAY; d_ptr++)
	    vrddata_reg_wire[r_ptr][d_ptr] = vrddata_reg[r_ptr][d_ptr];
	
	for (int vrdb_int=0; vrdb_int<NUMVBNK; vrdb_int=vrdb_int+1) begin
         if(sel[vrdb_int] == 3'b100)
           begin
              if((prt[vrdb_int][BITRDPT-1:0] == prt[vrdb_int][2*BITRDPT-1:BITRDPT]) && (ptr[vrdb_int][BITRDLY-1:0] == ptr[vrdb_int][2*BITRDLY-1:BITRDLY]))
                   vrddata_reg_wire [prt[vrdb_int][2*BITRDPT-1:BITRDPT]][ptr[vrdb_int][2*BITRDLY-1:BITRDLY]] =  vrddata_reg_din1[vrdb_int];
              else
                begin
                   vrddata_reg_wire [prt[vrdb_int][BITRDPT-1:0]][ptr[vrdb_int][BITRDLY-1:0]] =  vrddata_reg_din0[vrdb_int];
                   vrddata_reg_wire [prt[vrdb_int][2*BITRDPT-1:BITRDPT]][ptr[vrdb_int][2*BITRDLY-1:BITRDLY]] =  vrddata_reg_din1[vrdb_int];
                end
           end
         else if(sel[vrdb_int] == 3'b001)
           vrddata_reg_wire [prt[vrdb_int][BITRDPT-1:0]][ptr[vrdb_int][BITRDLY-1:0]] =  vrddata_reg_din0[vrdb_int];
         else if(sel[vrdb_int] == 3'b010)
           vrddata_reg_wire [prt[vrdb_int][2*BITRDPT-1:BITRDPT]][ptr[vrdb_int][2*BITRDLY-1:BITRDLY]] =  vrddata_reg_din0[vrdb_int];
        end
    end	
   genvar i, j;
   generate for (i=0; i<NUMRDPT; i=i+1) begin : prt_loop
      for(j=0; j<READ_DELAY; j=j+1) begin : flop_loop
         always @ (posedge clk)
           vrddata_reg [i][j] <= vrddata_reg_wire [i][j];
      end 
   end
   endgenerate

   assign dout = vrddata_reg;
   
   
endmodule // f32_vrddata_array
