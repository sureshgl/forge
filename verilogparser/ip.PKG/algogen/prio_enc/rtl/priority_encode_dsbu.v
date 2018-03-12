// $Header: /auto/dsbu-asic/MASTER/rtl/prioenc.v,v 1.6 2007/12/08 01:36:14 glambida Exp $
//  _____________________________________________________________________________
//
//   Copyright 2005, Cisco Systems, Inc.
//
//   Permission to use, copy and modify this file is prohibited outside Cisco
//   Systems, Inc.
//
//   Use of this file by any other organization for any purpose is allowed only
//   under express written permission of Cisco Systems, Inc.
//  _____________________________________________________________________________
//
//   File name   : prioenc.v
//   Project     : DSBU ASIC
//   Author      : Pete Johnson
//
//   Overview    : This module implements an efficient priority encoder.
//   Description : Low numbered bits have higher priority.
//  _____________________________________________________________________________
//
//   Issues:
//
//  Some Verilog synthesis tools may be unable to grok this file. The loops may
//  be completely unrolled, but since the loop bounds are not parameter expressions
//  unsophisticated tools may croak.
//
//  Note: even though the divide operator is used in this RTL code, rest assured
//  that no division is used in the actual generated gates.
//
//  _____________________________________________________________________________
//

module priority_encode_dsbu (clk, rst, decode,encode,valid);
  parameter width = 2048;
  parameter log_width = 11;
  input clk, rst;
  input [width-1:0] decode;
  output [log_width-1:0] encode;
  output         valid;

  reg [log_width-1:0]    encode;
  reg            valid;

  /*//synopsys translate_off
  initial
    if ((width > (1<<log_width)) || (width <= (1<<(log_width-1))))
      begin
    $display("Fatal: %m: illegal log_width. width %0d is not within range %0d..%0d",
         width,1<<log_width,(1<<(log_width-1))+1);
    $finish;
      end
  //synopsys translate_on
  */

  always @(*)
    begin : encoder
      integer i, j, k, t;
      reg [log_width*width-1:0] encode_vec;
      reg [log_width*width-1:0] valid_vec;

      t = (width+1)/2;

      for (i=0; i<(width>>1); i=i+1)
    begin
      valid_vec[i] = decode[2*i] | decode[2*i+1];
      encode_vec[i] = !decode[2*i];
    end
      if (width%2 == 1)
    begin
      valid_vec[t-1] = decode[width-1];
      encode_vec[t-1] = !decode[width-1];
    end

      for (i=1; i<log_width; i=i+1)
    begin : loop1
      reg odd_stage;
      integer limit;

      odd_stage = t[0];
      limit = t/2;
      t = (t+1)/2;

      for (j=0; j<limit; j=j+1)
        begin
          valid_vec[i*width+j] = valid_vec[(i-1)*width+2*j] |
                     valid_vec[(i-1)*width+2*j+1];
          encode_vec[i*width+(i+1)*(j+1)-1] = !valid_vec[(i-1)*width+2*j];
          for (k=1; k<=i; k=k+1)
        encode_vec[i*width+(i+1)*(j+1)-1-k] = valid_vec[(i-1)*width+2*j] ?
                              encode_vec[(i-1)*width+(2*j+1)*i-k] :
                              encode_vec[(i-1)*width+2*(j+1)*i-k];
        end
      if (odd_stage)
        begin
          valid_vec[i*width+limit] = valid_vec[(i-1)*width+2*limit];
          encode_vec[i*width+(i+1)*(limit+1)-1] = !valid_vec[(i-1)*width+2*limit];
          for (j=1; j<=i; j=j+1)
        encode_vec[i*width+(i+1)*(limit+1)-j-1] = encode_vec[(i-1)*width+(2*limit+1)*i-j];
        end
    end
      valid = valid_vec[(log_width-1)*width];
      for (i=0; i<log_width; i=i+1)
    encode[i] = encode_vec[(log_width-1)*width+i];
    end
endmodule // encoder_test
