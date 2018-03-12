/*
 ###############################################################################
 # Copyright (c) 2011 - by Cisco Systems Inc.
 # All rights reserved.
 #
 # Author     : Derived from Wei-Jen's nor2 gate instantiation
 # Owner      : Hsitung Huang (ctung@cisco.com)
 #
 # Description: The data_out have been qualified with !af_empty
 #
 ###############################################################################
 # $Id: vendor__nor2_gate.v,v 1.1 2014/06/25 10:50:48 pmadhuna Exp $
 # $Author: pmadhuna $
 # $Source: /nfs/nvbu/asic/repository/andiamo_vegas/f32/f32_ip/rtl/vendor__nor2_gate.v,v $
 # $Revision: 1.1 $$
 # $Date: 2014/06/25 10:50:48 $
 #
 # $Log: vendor__nor2_gate.v,v $
 # Revision 1.1  2014/06/25 10:50:48  pmadhuna
 # Initial release for memoir ip
 #
 # Revision 1.4  2012/02/15 20:51:07  chuang
 # fix // set_dont_touch { DONT_TOUCH_a4_nor2_b1_inst* }
 #
 # Revision 1.3  2012/02/15 15:07:43  chuang
 # add width input  [FIFO_WIDTH-1:0] af_empty_vec
 #
 # Revision 1.2  2011/11/13 17:32:09  ctung
 # Change to pure nor gate
 #
 # Revision 1.1  2011/11/12 22:27:40  ctung
 # data_out have been qualified with !af_emtpy
 #
 # $Endlog
 ###############################################################################
*/
// synopsys translate_off
`ifdef TCQ 
`else 
	`define TCQ #1 
`endif
// synopsys translate_on

module vendor__nor2_gate (
                   inv_af_rd_data,
                   af_empty_vec,
                   data_out
                   );
// synopsys template 
   
   parameter    FIFO_WIDTH = 1;       // Any integer larger than 0
   
   input [FIFO_WIDTH-1:0]  inv_af_rd_data; // af_rd_data is before qualifying with !af_empty

   input  [FIFO_WIDTH-1:0] af_empty_vec; // Async FIFO empty status on read clock domain

   output [FIFO_WIDTH-1:0] data_out;     // data_out is after qualifying with !af_empty

   //===========================================================
   // Start of Logic
   //===========================================================

   // The data_out is the af_rd_data qualified with !af_empty

`ifdef USE_VENDOR__NOR2_GATE

   // Use Wei-Jen's gate instantiation with set_dont_touch attribute
   // so that Synopsys will not re-synthesize the gates to cause glitches.

   // synopsys dc_script_begin
   // set_dont_touch { DONT_TOUCH_a4_nor2_b1_inst* }
   // synopsys dc_script_end

   a28_nor2_a2  DONT_TOUCH_a4_nor2_b1_inst [FIFO_WIDTH-1:0] 
     (.A        ( inv_af_rd_data ),
      .B        ( af_empty_vec   ),
      .Q        ( data_out       )
     );

`else

   // assign data_out = (~af_empty_vec) & af_rd_data;
   assign data_out = ~(af_empty_vec | inv_af_rd_data);

`endif

   
// synopsys dc_script_begin
// synopsys dc_script_end

endmodule

// Local Variables:
// verilog-auto-sense-defines-constant: t
// verilog-library-directories: (".")
// verilog-library-extensions: (".v")
// End:
