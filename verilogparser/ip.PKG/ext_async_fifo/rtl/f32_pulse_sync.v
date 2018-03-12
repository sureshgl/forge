/*
#------------------------------------------------------------------------------
# Copyright (c) 2008 - by Andiamo Systems Inc.
# All rights reserved.
#
# Permission to use, copy and modify this file is prohibited outside
# Andiamo, Inc. Use of this file by any other organization for any purpose
# is allowed only under express written permission of Andiamo, Inc.
#------------------------------------------------------------------------------
#
# Description: Thunderbird (from Riviera) Pulse synchronizer
# 
#
###############################################################################
#
# $Author: sudhansu $
# $Source: /nfs/nvbu-asic/repository/andiamo_vegas/f32/common/rtl/f32_pulse_sync.v,v $
# $Revision: 1.1 $
# $Date: 2014/07/07 09:35:27 $
#
###############################################################################
*/

`define F32_CLK2Q 0

module f32_pulse_sync
(
// Source Clock domain
input  wire	       src_clk   ,
input  wire	       src_pulse ,
// Dest Clock domain
input  wire	       dest_clk  ,
input  wire		   dest_rst  ,
output reg	       dest_pulse		       
);

   // Internal signal declarations

   wire			dest_rst_sync2;
   reg 			tog;
   reg 			tog_d1;
   reg 			tog_ext;
   wire			tog_sync2;
   reg 			tog_sync3;
   
   // State Machines   ***************************************

   
   // Sync dest_rst to src_clk
ip_sync_ctlbus_dst #(1)
   dest_rst_sync
   (
   .clk                      ( src_clk  ), // dstclk
   .srcclk_controlbus        ( dest_rst               ),
   .sync_dstclk_controlbus   ( dest_rst_sync2         )
   );// ip_sync_ctlbus_dst dest_rst_sync

   // run a toggle flop to capture the edge of the pulse
   always @(posedge src_clk)
     begin
     	if (dest_rst_sync2)
	  begin
	     tog  <= #`F32_CLK2Q 1'b0;
	  end
	else if (src_pulse)
	  begin
	     tog  <= #`F32_CLK2Q ~tog;
	  end
     end // always @ (posedge src_clk)
   //Extend the toggle to two clocks to care of back to back pulses
   always @(posedge src_clk)
     begin
	if (dest_rst_sync2)
	  begin
	     tog_d1    <= #`F32_CLK2Q 1'b0;
	     tog_ext   <= #`F32_CLK2Q 1'b0;
	  end
	else
	  begin
	     tog_d1    <= #`F32_CLK2Q tog;
	     tog_ext   <= #`F32_CLK2Q (tog | tog_d1);
	  end
     end // always @ (posedge src_clk)
   
	     
ip_sync_ctlbus_dst #(1)
   tog_sync
   (
   .clk                      ( dest_clk   ), // dstclk
   .srcclk_controlbus        ( tog_ext    ),
   .sync_dstclk_controlbus   ( tog_sync2  )
   );// ip_sync_ctlbus_dst
   always @(posedge dest_clk)
     begin
	if (dest_rst)
	  begin
	     tog_sync3  <= #`F32_CLK2Q 1'b0;
	  end
	else
	  begin
	     tog_sync3  <= #`F32_CLK2Q tog_sync2;
	  end // else: !if(dest_rst)
     end // always @ (posedge dest_clk)

   always @(posedge dest_clk)
     begin
	if (dest_rst)
	  begin
	     dest_pulse  <= #`F32_CLK2Q 1'b0;
	  end
	else
	  begin
	     dest_pulse  <= #`F32_CLK2Q tog_sync2 ^ tog_sync3;
	  end
     end // always @ (posedge dest_clk)
   
endmodule

