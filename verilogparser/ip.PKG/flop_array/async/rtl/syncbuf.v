//
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
//  File Name: syncbuf.v
//
//  Language:  English
//
//  File Description:
//
//     This is a hand instantiated buffer with a special instance name.
//     It is used to identify paths that cross async clock boundaries
//     that do not use a synchronizer.  The special instance name
//     is used by STA timing exceptions.
//
//  Initial Version:  Tue May 10 13:47:37 PDT 2005  By: gcuan
//
//  Revision History:
//--------------------------------------------------------------------------
//
// $Id: syncbuf.v@@/main/2 2009/07/27 00:11:14 GMT gcuan $
//


module syncbuf (
   a,
   y
   );

// synopsys template

parameter WIDTH=1;

input   [WIDTH-1:0] a;
output  [WIDTH-1:0] y;

wire    [WIDTH-1:0] a;
wire    [WIDTH-1:0] y;

syncbuf_gates syncbuf[WIDTH-1:0] (
      .a(a),
      .y(y)
      );

endmodule
