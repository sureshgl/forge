/*
#------------------------------------------------------------------------------
# Copyright 2011 Cisco Systems
#
# Permission to use, copy and modify this file is prohibited outside Cisco Systems
# Use of this file by any other organization for any purpose is allowed only
# under express written permission of Cisco Systems
#------------------------------------------------------------------------------
# description:   Briefly describe the purpose of this file, if its original code
#                or copied from another design, etc.
########################################################################
#
# $Author: sr2 $
# $Source: /nfs/nvbu/asic/repository/andiamo_vegas/f32/f32_ip/rtl/vendor__sync_flop.v,v $ 
# $Revision: 1.1 $
# $Date: 2014/05/14 05:06:58 $
# $Log: vendor__sync_flop.v,v $
# Revision 1.1  2014/05/14 05:06:58  sr2
# initial revision
#
#
#
# $Endlog
########################################################################
 */

module vendor__sync_flop (/*AUTOARG*/
  // Outputs
  data_out,
  // Inputs
  dstclk, data_in
  );

 
  // synopsys template
  parameter                  DATA_WIDTH = 1;

  /*********************************************************
   * Ports Declaration                                    *
   *********************************************************/

  input                      dstclk;

  input [DATA_WIDTH-1:0]     data_in;
  output [DATA_WIDTH-1:0]    data_out;

// TBD: do we need 3x?

	avago28_3xsync_flop #(DATA_WIDTH)
	avago28_sync_flop_inst0
	(
	  .data_out(data_out),
	  .dstclk(dstclk),
	  .data_in(data_in)
	);
	
endmodule // avago28_sync_flop
                                                                              
