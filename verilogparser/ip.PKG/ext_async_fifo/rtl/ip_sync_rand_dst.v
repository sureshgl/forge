/*
 *------------------------------------------------------------------------------
 * Copyright (c) 2003 - by Andiamo Systems Inc. All rights reserved.
 * Permission to use, copy and modify this file is prohibited outside
 * Andiamo, Inc. Use of this file by any other organization for any purpose
 * is allowed only under express written permission of Andiamo, Inc.
 *
 * $Source: /nfs/nvbu-asic/repository/andiamo_vegas/vegas_ip/ip_synchronizer/rtl/ip_sync_rand_dst.v,v $
 * $Revision: 1.7 $
 * $Date: 2006/10/04 01:16:04 $
 * $Author: cino $
 *
 * $Owner: Georges Akis
 * $Description: ASYNC clock boundary crossing IP enforces NAMING.
 * 
 * Used by the _databus_ or _controlbus_ IP. Should only be used directly if the 
 * flops in the _databus_ or _controlbus_ ip are not needed. 
 * 
 * Models the different delays that will exist between the bits of the input
 * data in the physical implementation. In the dst clock domain, each bit is
 * randomly flopped in the current period or the next one. This model finds
 * design flaws where the async dat is used too early by the dst clock logic
 * i.e. the ctl path is not double-flopped. After synthesis it is simply
 * a pass-thru.
 *  
 * $Log: ip_sync_rand_dst.v,v $
 * Revision 1.7  2006/10/04 01:16:04  cino
 * removed v2k syntax: same functionality
 *
 * Revision 1.6  2005/10/31 19:14:17  vikask
 * Changed the declaration of bit to bit_i as bit is a keyword in vcs 2005
 *
 * Revision 1.5  2005/07/15 14:57:36  maypatel
 * Do not randomly skew data if IP_SYNC_RAND_SKEW_DISABLE is not defined.
 *
 * Revision 1.4  2003/11/21 01:22:57  gakis
 * set_attribute current_design CVS Id
 *
 * Revision 1.3  2003/07/15 17:32:44  gakis
 * Removed reg initialization at declaration.
 *
 * Revision 1.2  2003/07/15 02:40:59  npatwa
 * changed rand_seed from wire to reg to make nc_verilog work (ziad)
 *
 * Revision 1.1  2003/04/08 18:16:31  gakis
 * Shorter names for IBM
 *
 * Revision 1.2  2003/03/12 02:29:38  gakis
 * Fixed random bit skew
 *
 * Revision 1.1  2003/02/27 23:57:38  gakis
 * Parameterizable width and depth components force presync_ naming
 * conventions and inserts random bit skews when crossing clock boundaries.
 *
 * $Endlog
 *
 *------------------------------------------------------------------------------
 */

module ip_sync_rand_dst (
   clk, // dstclk
   srcclk_bus,
   rand_dstclk_bus
   );
   
   // synopsys template
   parameter            P_WIDTH = 128;
   
   input                clk; // dstclk
   input [P_WIDTH-1:0]  srcclk_bus; // async data in
   output [P_WIDTH-1:0] rand_dstclk_bus; // random skew data out
   reg [P_WIDTH-1:0]    rand_dstclk_bus;

   /////////////////////////////////////////////////////////////////////
   // synopsys translate_off
   /////////////////////////////////////////////////////////////////////
`ifdef IP_SYNC_RAND_SKEW_DISABLE
`else
   reg [P_WIDTH-1:0]    input_srcclk_bus;
   reg [P_WIDTH-1:0]    latch_srcclk_bus;
   reg [P_WIDTH-1:0]    skewed_dstclk_bus;
   reg                  skew_srcclk_toggle;
   reg                  skew_srcclk_toggle_d;
   integer              bit_i;
   reg                  rand_seed;

   initial begin
      rand_seed = 0;
      skew_srcclk_toggle = 0;
      skew_srcclk_toggle_d = 0;
   end
   
   always @(srcclk_bus) begin
      input_srcclk_bus <= #1 srcclk_bus;
      latch_srcclk_bus <= #1 input_srcclk_bus; // delayed version
      skew_srcclk_toggle <= #1 ~skew_srcclk_toggle;
   end

   always @(posedge clk // to remove skew
            or input_srcclk_bus
            or latch_srcclk_bus 
            or skew_srcclk_toggle // to cause skew on input changes
            ) begin
      skewed_dstclk_bus = input_srcclk_bus;
      if (skew_srcclk_toggle ^ skew_srcclk_toggle_d) begin
         if (^{input_srcclk_bus, latch_srcclk_bus} !== 1'bx) begin
            for (bit_i=0 ; bit_i<P_WIDTH ; bit_i=bit_i+1) begin
               if ({$random(rand_seed)} % 2) begin // rand MUX select
                  // assign the old value for some ctl
                  skewed_dstclk_bus[bit_i] = latch_srcclk_bus[bit_i];
               end
            end
         end
      end
      skew_srcclk_toggle_d = skew_srcclk_toggle;
   end
`endif

   /////////////////////////////////////////////////////////////////////
   // synopsys translate_on
   /////////////////////////////////////////////////////////////////////
   always @(srcclk_bus
            // synopsys translate_off
`ifdef IP_SYNC_RAND_SKEW_DISABLE
`else
            or skewed_dstclk_bus
`endif
            // synopsys translate_on
            ) begin
      rand_dstclk_bus = srcclk_bus; // pass-thru after synthesis
      // synopsys translate_off
`ifdef IP_SYNC_RAND_SKEW_DISABLE
`else
      rand_dstclk_bus = skewed_dstclk_bus;
`endif
      // synopsys translate_on
   end

   

// synopsys dc_script_begin
// synopsys dc_script_end

endmodule

