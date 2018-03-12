//--------------------------------------------------------------------------
//  Cisco Systems Inc.                                                    
//                                                                        
//  Copyright (c) 2004 Cisco Systems                                      
//  All rights reserved                                                   
//                                                                        
//  This software product contains the unpublished source code of         
//  Cisco Systems.                                                        
//                                                                        
//  The copyright notices above do not evidence any actual or             
//  intended publication of such source code.                             
//                                                                        
//  File Name: syncbuf_gates.v
//
//  Language:  Verilog
//
//  File Description:
//
//     This is a hand instantiated buffer with a special instance name.
//     It is used to identify paths that cross async clock boundaries
//     that do not use a synchronizer.  The special instance name
//     is used by STA for timing exceptions.
//
//  NOTE:  This module should not be synthesized.  There is
//         a technology specific version for synthesis.
//
//  Initial Version: Tue May 10 13:47:37 PDT 2005  By: gcuan
//
//  Revision History:
//--------------------------------------------------------------------------
//
// $Id: syncbuf_gates.v@@/main/3 2009/07/27 00:13:55 GMT gcuan $
//
//

module syncbuf_gates (
   a,
   y
   );


input  a;
output y;


wire   a;
wire   y;

   assign 	   y = a;
   

endmodule
