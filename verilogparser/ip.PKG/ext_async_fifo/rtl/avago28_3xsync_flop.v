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
# $Source: /nfs/nvbu/asic/repository/andiamo_vegas/f32/f32_ip/rtl/avago28_3xsync_flop.v,v $ 
# $Revision: 1.1 $
# $Date: 2014/05/14 05:06:58 $
# $Log: avago28_3xsync_flop.v,v $
# Revision 1.1  2014/05/14 05:06:58  sr2
# initial revision
#
#
#
# $Endlog
########################################################################
 */

module avago28_3xsync_flop (/*AUTOARG*/
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

  reg [DATA_WIDTH-1:0]       presync_data_out, presync_data_out_d1;
  reg [DATA_WIDTH-1:0]       sync_data_out;


`ifdef AVAGO28_ASYNC_FLOP

   a28_3xsyncdff0_a2 a28_3xsyncdff0_a2_inst0 [DATA_WIDTH-1:0] (
    .D (data_in),
    .CK (dstclk),
    .Q (data_out),
    .SE (1'b0),
    .SI (1'b0));

`else

  assign                     data_out = sync_data_out;

  always @ (posedge dstclk)
  begin
      presync_data_out[DATA_WIDTH-1:0] <= #1 data_in[DATA_WIDTH-1:0];
      presync_data_out_d1[DATA_WIDTH-1:0] <= #1 presync_data_out[DATA_WIDTH-1:0];
      sync_data_out[DATA_WIDTH-1:0] <= #1 presync_data_out_d1[DATA_WIDTH-1:0];
  end // always @ (posedge dstclk)

`endif

endmodule // avago28_sync_flop
                                                                              
