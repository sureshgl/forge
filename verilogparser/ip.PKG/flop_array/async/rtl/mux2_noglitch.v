//--------------------------------------------------------------------------
//  Cisco Systems Inc.                                                    
//                                                                        
//  Copyright (c) 2009 Cisco Systems Inc.                                     
//  All rights reserved                                                   
//                                                                        
//  This software product contains the unpublished source code of         
//  Cisco Systems Inc.                                                        
//                                                                        
//  The copyright notices above do not evidence any actual or             
//  intended publication of such source code.                             
//                                                                        
//  File Name:		mux2_noglitch.v
//
//  Language:		SpecterX/Verilog
//
//  File Description:  A 2to1 mux.  This is instantiated by the memWrap for the flop based afifo.
// 	               The 2to1 mux is used to build a mux tree for the read data.
//                     Specifying this mux tree is necessary to guarantee that changes in nonselected data
//                     cannot cause a glitch on the output of the mux.
//
//  Initial Version:	Sun Sep 13 10:13:24 PST 2009	By: gcuan
//
//  Revision History:
//--------------------------------------------------------------------------
//
// $Id: mux2_noglitch.v@@/main/1 2009/09/14 04:14:28 GMT gcuan $
//


module mux2_noglitch (
  a,
  b,
  s,
  y
);

   parameter WIDTH=1;
   
   input [WIDTH-1:0] a;
   input [WIDTH-1:0] b;
   input             s;
   output [WIDTH-1:0] y;
   
   wire [WIDTH-1:0]   a;
   wire [WIDTH-1:0]   b;
   wire 	      s;
   wire [WIDTH-1:0]   y;


   mux2_noglitch_gates mux2[WIDTH-1:0] (
     .a(a),
     .b(b),
     .s(s),
     .y(y)
     );

endmodule // mux2_noglitch
