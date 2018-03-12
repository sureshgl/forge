// $Id: RamWrapPipe.v,v 2.5 2012/03/02 22:04:14 tlantz Exp $
//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2008, Cisco Systems, Inc.
// All Rights Reserved.
//
// This is UNPUBLISHED PROPRIETARY SOURCE CODE of Cisco Systems, Inc;
// the contents of this file may not be disclosed to third parties, copied or
// duplicated in any form, in whole or in part, without the prior written
// permission of Cisco Systems, Inc.
//
// RESTRICTED RIGHTS LEGEND:
// Use, duplication or disclosure by the Government is subject to restrictions
// as set forth in subdivision (c)(1)(ii) of the Rights in Technical Data
// and Computer Software clause at DFARS 252.227-7013, and/or in similar or
// successor clauses in the FAR, DOD or NASA FAR Supplement. Unpublished -
// rights reserved under the Copyright Laws of the United States.
//
//////////////////////////////////////////////////////////////////////////////
//
// File          : RamWrapPipe.v
// Author        : Ofer Licht  <olicht@cisco.com>
// Description   : parameterizable fifo for ram wrapper pipelined output
//

`timescale 1ns/1ns
module RamWrapPipe
#(
   parameter WIDTH=0,
   parameter PIPELINE=0,
   parameter CORE_PIPE=0,
   parameter MAX_PIPE=4
)
(
   input                   clk,
   input  wire             gaten,  // low-true, one clock preceeding pipein (eg SELN)
   input  wire [WIDTH-1:0] pipein,
   output wire [WIDTH-1:0] pipeout
);

   localparam              WRAP_PIPE = PIPELINE - CORE_PIPE - 1;
   localparam              WRAP_GTN = PIPELINE - 1;   // The gaten pipe includes any core pipe

   generate

      if (PIPELINE > MAX_PIPE) begin : e0
`ifdef SYNTHESIS
`else
         initial begin
            $display("***ERROR: %m requested PIPELINE(%0d) exceeds MAX(%0d)",PIPELINE,MAX_PIPE);
            $finish;
         end
`endif
      end
      else if (PIPELINE < CORE_PIPE) begin : e1
`ifdef SYNTHESIS
         always $display("Error: Requested PIPELINE(%d) smaller than CORE(%d)",PIPELINE,CORE_PIPE);
`else
         initial begin
            $display("***ERROR: %m requested PIPELINE(%0d) smaller than CORE(%0d)",PIPELINE,CORE_PIPE);
            $finish;
         end
`endif
      end
      else if (PIPELINE > CORE_PIPE) begin : p0
         reg [WRAP_GTN:0]                gtn;
         reg [(WRAP_PIPE+1)*WIDTH-1:0]   pipe;

         assign pipeout = pipe[WIDTH-1:0];

         // DO NOT rely on for-loops to condition when WRAP_GTN or WRAP_PIPE are equal to zero
         // The case with a for-loop used to condition when WRAP_PIPE equals to zero
         //    does NOT work in DC synthesis. Although the for-loop is logically never entered,
         //    extra gates are being generated in synthesis due to tool error.

         // pipe the gaten (including any CORE_PIPE)
         if (WRAP_GTN > 0) begin
            always @(posedge clk)
               gtn <= {gaten, gtn[WRAP_GTN:1]};
         end
         else begin
            always @(posedge clk)
               gtn <= gaten;
         end

         // pipe the pipein gated by matching gaten pipe
         if (WRAP_PIPE > 0) begin
            always @(posedge clk) 
               if (~&gtn[WRAP_PIPE:0])
                  pipe <= {pipein, pipe[(WRAP_PIPE+1)*WIDTH-1:WIDTH]};
         end
         else begin
            always @(posedge clk)
               if (~gtn[0])
                  pipe <= pipein;
         end

      end
      else begin : p1
         assign pipeout = pipein;
      end

   endgenerate

endmodule
