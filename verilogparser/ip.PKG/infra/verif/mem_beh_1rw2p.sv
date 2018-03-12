/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
module mem_beh_1rw2p  (clk, rst,
                     read_0, write_0, bank_0, addr_0, din_0, bw_0, dout_0,
                     read_serr_0, read_derr_0
                     );
  string name = "mem_beh_1rw2p";
  parameter AW      = 10;
  parameter DW      = 32;
  parameter LATENCY = 2;
  parameter WORDS   = 1024;
  parameter BANKS	= 1;
  parameter BAW		= 0;

  localparam MAX_LATENCY = 30;

  input             clk;
  input             rst;

  input             read_0;
  input             write_0;
  input [BAW-1:0]   bank_0;
  input [AW-1:0]    addr_0;
  input [DW-1:0]    din_0;
  input [DW-1:0]    bw_0;
  output [DW-1:0]   dout_0;

  output            read_serr_0;
  output            read_derr_0;
  assign read_serr_0 = 1'b0;
  assign read_derr_0 = 1'b0;
  
  reg [DW-1:0]      mem [0:BANKS*WORDS-1];
  always @(posedge clk)
    if (write_0)
      mem[bank_0*WORDS + addr_0] <= (~bw_0 & mem[bank_0*WORDS + addr_0]) | (bw_0 & din_0);

  integer           dout_0_int;
  reg [DW-1:0]      dout_0_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (dout_0_int=0; dout_0_int<MAX_LATENCY; dout_0_int=dout_0_int+1)
      if (dout_0_int>0)
        dout_0_reg[dout_0_int] <= dout_0_reg[dout_0_int-1];
      else
        dout_0_reg[dout_0_int] <= read_0 ? mem[bank_0*WORDS + addr_0] : {DW{1'bx}}; 

  generate
    if (LATENCY) 
      assign dout_0 = dout_0_reg[LATENCY-1];
    else 
      assign dout_0 = mem[bank_0*WORDS + addr_0];
  endgenerate

  initial
    if (LATENCY >= MAX_LATENCY) begin
      $display("ERR :%m:%0t: LATENCY >= MAX_LATENCY", $time);
      $finish;
    end

  always @(posedge clk) begin
    if (~rst & (read_0 & write_0)) begin `ERROR ("(~rst & (read_0 & write_0))") end
    if (~rst & ((write_0 | read_0) & (addr_0 >= WORDS || bank_0 >= BANKS))) begin `ERROR ("(~rst & ((write_0 | read_0) & (addr_0 >= WORDS || bank_0 >= BANKS)))") end
  end

  // TBD: add refresh asserts

endmodule
