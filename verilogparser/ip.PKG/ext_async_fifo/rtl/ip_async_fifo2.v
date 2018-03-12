/*
 ###############################################################################
 # Copyright (c) 2011 - by Cisco Systems Inc.
 # All rights reserved.
 #
 # Author     : Derived from Wei-Jen's nor2 gate instantiation
 # Owner      : Hsitung Huang (ctung@cisco.com)
 #
 # Description: The ip_async_fifo2 will qualify data_out with !af_empty
 #
 # Important Note: To make sure RTL is not synthesized to the logic gates with glitches
 #                 such that !af_empty qualification is compromised in gate level,
 #                 user should instantiate gates with dont_touch in ip_async_fifo2.
 #
 ###############################################################################
 # $Id: ip_async_fifo2.v,v 1.8 2012/09/26 22:07:04 saikatb Exp $
 # $Author: saikatb $
 # $Source: /nfs/nvbu/asic/repository/andiamo_vegas/vegas_ip/ip_async_fifo/rtl/ip_async_fifo2.v,v $
 # $Revision: 1.8 $$
 # $Date: 2012/09/26 22:07:04 $
 #
 # $Log: ip_async_fifo2.v,v $
 # Revision 1.8  2012/09/26 22:07:04  saikatb
 #
 # - Added af_cnt to the port list.
 #
 # Revision 1.7  2012/09/26 20:50:05  saikatb
 #
 # - Added output af_cnt.
 #
 # Revision 1.6  2012/04/14 03:02:33  mahampto
 # Changed inline ifdef to be multiple lines (some vcs versions don't like inline
 # ifdefs).
 #
 # Revision 1.5  2012/04/10 22:01:44  ctung
 # no logic change: remove "//syopsys translate" enclosure for "define TCQ"
 #
 # Revision 1.4  2012/02/15 15:48:46  chuang
 # clobber comment
 #
 # Revision 1.3  2012/02/15 15:27:13  ctung
 # Remove MONTICELLO, use USE_VENDOR__NOR2_GATE
 #
 # Revision 1.2  2012/02/11 00:19:07  ctung
 # Important Note: User should instantiate gates with dont_touch
 #
 # Revision 1.1  2012/02/09 22:18:13  ctung
 # Initial checkin (Rename from ip_async_fifo_wrap)
 #
 # Revision 1.4  2011/11/13 17:29:19  ctung
 # Add USE_VENDOR__NOR2_GATE
 #
 # Revision 1.3  2011/11/07 19:16:44  ctung
 # USE_VENDOR__NOR2_GATE with set_dont_touch attr
 #
 # Revision 1.2  2011/11/02 02:17:13  ctung
 # Change ip_async_fifo2 to qualify data_out with !af_empty
 #
 # $Endlog
 ###############################################################################
*/
`ifdef TCQ 
`else 
`define TCQ #1 
`endif

module ip_async_fifo2 (
                   // Write Clock domain
                   w_rst,
                   w_clk,
                   wr_en,
                   data_in,
                   af_alm_full,
                   af_thrsh,
                   af_set_intr_p,
                   af_cnt,
                   
                   // Read Clock domain
                   r_rst,
                   r_clk,                      
                   rd_en,
                   data_out,
                   af_empty
                   );
// synopsys template 
   
   // Note: The following parameters will apply to ip_async_fifo
   parameter    FIFO_DEPTH = 8;         // power-of-2 number
   parameter    FIFO_WIDTH = 256;       // Any integer larger than 0
// parameter    FIFO_ADDR  = 3          // log2(FIFO_DEPTH)
   parameter    FIFO_ADDR  =            // log2(FIFO_DEPTH)
                             (FIFO_DEPTH<=2)?1:
                             (FIFO_DEPTH<=4)?2:
                             (FIFO_DEPTH<=8)?3:
                             (FIFO_DEPTH<=16)?4:
                             (FIFO_DEPTH<=32)?5:
                             32;

   //-----------------------------------
   // Write clock interface
   //-----------------------------------
   
   input                w_rst;           // Write clock domain reset signal
   input                w_clk;           // Write clock domain clock signal  
   input                wr_en;           // Write clock domain write enable 

   input [FIFO_WIDTH-1:0] data_in;       // Write clock domain data-in bus 

   output                 af_alm_full;   // Async FIFO almost full status in write clock domain
   input [FIFO_ADDR-1:0]  af_thrsh;      // Almost full threshold, CPU register bits on write clock domain
                                         // Note: af_thrsh is the threshold (distance) from full.
                                         // If set af_thrsh to 0, af_alm_full equals to af_full.

   output                 af_set_intr_p; // Overflow interrupt
   
   output [FIFO_ADDR:0] af_cnt;          // FIFO valid entry count
   
   //-----------------------------------
   // Read clock interface
   //-----------------------------------
   
   input                r_rst;           // Read clock domain reset signal
   input                r_clk;           // Read clock domain clock signal
   input                rd_en;           // Read clock domain read enable

   output [FIFO_WIDTH-1:0] data_out;     // Read clock domain read data-out which is not flopped out.
                                         // Note: Don't put too much logic after data_out (user should flop in data_out path ASAP)

   output                  af_empty;     // Async FIFO empty status on read clock domain
   
   //===========================================================
   // Start of Logic
   //===========================================================

   wire [FIFO_WIDTH-1:0] af_rd_data;    // af_rd_data is before qualifying with !af_empty

   // The data_out is the af_rd_data qualified with !af_empty

   // Important Note: To make sure RTL is not synthesized to the logic gates with glitches
   //                 such that !af_empty qualification is compromised in gate level,
   //                 user should instantiate gates with dont_touch in ip_async_fifo2.
   //

   /*
   // Use Wei-Jen's gate instantiation with set_dont_touch attribute
   // so that Synopsys will not re-synthesize the gates to cause glitches.
  
   // s-y-n-o-p-s-y-s d-c_s-cript_begin
   // s-e-t d-o-n-t -touch { a4_nor2_b1_inst* }
   // s-y-n-o-p-s-ys dc_script_end
  
   a4_nor2_b1  DONT_TOUCH_a4_nor2_b1_inst [FIFO_WIDTH-1:0] 
     (.A        ( ~af_rd_data            ),
      .B        ( {FIFO_WIDTH{af_empty}} ),
      .Q        ( data_out               )
     );
   */

`ifdef USE_VENDOR__NOR2_GATE

   wire [FIFO_WIDTH-1:0] inv_af_rd_data = ~af_rd_data;
   wire [FIFO_WIDTH-1:0] af_empty_vec = {FIFO_WIDTH{af_empty}};

   // The data_out is the af_rd_data qualified with !af_empty
   vendor__nor2_gate #(FIFO_WIDTH)
        vendor__nor2_gate_inst0
        (
          .inv_af_rd_data ( inv_af_rd_data ),
          .af_empty_vec   ( af_empty_vec   ),
          .data_out       ( data_out       )
        );

`else

   assign data_out = !af_empty ? af_rd_data : 0;

`endif

   //===========================================================
   // Instantiation
   //===========================================================

   ip_async_fifo #(.FIFO_DEPTH(FIFO_DEPTH), .FIFO_WIDTH(FIFO_WIDTH), .FIFO_ADDR(FIFO_ADDR)) ip_async_fifo_inst0 
     (
      // Write Clock domain
      .w_rst            (w_rst          ),
      .w_clk            (w_clk          ),
      .wr_en            (wr_en          ),
      .data_in          (data_in        ),
      .af_alm_full      (af_alm_full    ),
      .af_thrsh         (af_thrsh       ),
      .af_set_intr_p    (af_set_intr_p  ),
      .af_cnt           (af_cnt         ),
      
      // Read Clock domain
      .r_rst            (r_rst          ),
      .r_clk            (r_clk          ),                      
      .rd_en            (rd_en          ),
      .data_out         (af_rd_data     ),
      .af_empty         (af_empty       )
   );
 
   
// synopsys dc_script_begin
// synopsys dc_script_end

endmodule

// Local Variables:
// verilog-auto-sense-defines-constant: t
// verilog-library-directories: (".")
// verilog-library-extensions: (".v")
// End:
