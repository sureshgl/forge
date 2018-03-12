/*
 *------------------------------------------------------------------------------
 * Copyright (c) 2003 - by Andiamo Systems Inc. All rights reserved.
 * Permission to use, copy and modify this file is prohibited outside
 * Andiamo, Inc. Use of this file by any other organization for any purpose
 * is allowed only under express written permission of Andiamo, Inc.
 *
 * $Source: /nfs/nvbu/asic/repository/andiamo_vegas/vegas_ip/ip_synchronizer/rtl/ip_sync_ctlbus_dst.v,v $
 * $Revision: 1.7 $
 * $Date: 2010/05/26 07:55:39 $
 * $Author: chuang $
 *
 * $Owner: Georges Akis
 * $Description: ASYNC clock boundary crossing IP enforces NAMING.
 * 
 * Uses the following naming convention:
 *    async_ -> presync_ -> sync_
 *    async_ -> notsync_ -> sync_
 * Which can be used by the backend timing tools:
 *    set_multi_cycle_path -to presync_*
 *    set_multi_cycle_path -from async_* -to notsync_*
 *  
 * Double-flops the ctl signals when crossing clock boundaries. 
 * The dat path should use the associated _databus_ IP.
 * 
 * $Log: ip_sync_ctlbus_dst.v,v $
 * Revision 1.7  2010/05/26 07:55:39  chuang
 * remove KATANA and replaced with USE_VENDOR__SYNC_FLOP
 *
 * Revision 1.6  2010/01/16 21:14:48  chuang
 * add KATANA and `elsif
 *
 * Revision 1.5  2008/06/18 01:42:23  achander
 * ifdef for using vendor provided flop at clock crossing boundary
 *
 * Revision 1.4  2008/03/05 06:05:29  lixin
 * added special handling for async flops
 *
 * Revision 1.3  2003/11/21 01:22:57  gakis
 * set_attribute current_design CVS Id
 *
 * Revision 1.2  2003/04/08 18:55:33  gakis
 * Shorter instance names too.
 *
 * Revision 1.1  2003/04/08 18:16:30  gakis
 * Shorter names for IBM
 *
 * Revision 1.1  2003/02/27 23:57:37  gakis
 * Parameterizable width and depth components force presync_ naming
 * conventions and inserts random bit skews when crossing clock boundaries.
 *
 * $Endlog
 *
 *------------------------------------------------------------------------------
 */

module ip_sync_ctlbus_dst (
   clk, // dstclk
   srcclk_controlbus,
   sync_dstclk_controlbus
   );

   // synopsys template
   parameter P_WIDTH = 1;

   input                clk; // dstclk
   input [P_WIDTH-1:0]  srcclk_controlbus;
   output [P_WIDTH-1:0] sync_dstclk_controlbus;
   wire [P_WIDTH-1:0]   rand_dstclk_controlbus;
   reg [P_WIDTH-1:0]    presync_dstclk_controlbus;

`ifdef VERILOGXL_ENV
`else
   // synopsys translate_off
   initial begin
      if ($test$plusargs("async_display")) begin
         $display ("INFO: async clock boundary: %m/presync_dstclk_controlbus");
      end
   end
   // synopsys translate_on
`endif

   // randomly flopped in the current period or the next one
   ip_sync_rand_dst #(P_WIDTH) rand_dst_i0 (
      .clk ( clk ),
      .srcclk_bus ( srcclk_controlbus ),
      .rand_dstclk_bus ( rand_dstclk_controlbus )
      );

`ifdef ELECTRA

   wire [P_WIDTH-1:0]    sync_dstclk_controlbus;

   ele_sync_flop #(P_WIDTH)
     ele_sync_flop_inst0
   (
     .data_out(sync_dstclk_controlbus),
     .dstclk(clk),
     .data_in(rand_dstclk_controlbus)
   );

`elsif USE_VENDOR__SYNC_FLOP
    
        wire [P_WIDTH-1:0]    sync_dstclk_controlbus;

        vendor__sync_flop #(P_WIDTH)
        vendor__sync_flop_inst0
        (
          .data_out(sync_dstclk_controlbus),
          .dstclk(clk),
          .data_in(rand_dstclk_controlbus)
        );
                
`else
   
        reg [P_WIDTH-1:0]    sync_dstclk_controlbus;

        always @(posedge clk) begin
                presync_dstclk_controlbus <= #1 rand_dstclk_controlbus;
                sync_dstclk_controlbus <= #1 presync_dstclk_controlbus;
        end
`endif

// synopsys dc_script_begin
// synopsys dc_script_end

endmodule
