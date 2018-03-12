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
// $Id: mux2_noglitch_gates.v@@/main/1 2009/09/14 04:14:47 GMT gcuan $
//


module mux2_noglitch_gates (
  a,
  b,
  s,
  y
);

   input  a;
   input  b;
   input  s;
   output y;
   
   wire   a;
   wire   b;
   wire   s;
   wire   y;


   assign y = s ? b : a; 

endmodule // mux2_noglitch
