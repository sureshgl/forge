/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
module mem_beh_1r1w1p  (clk, rst,
                      read_0, addr_0, bank_0, dout_0, read_serr_0, read_derr_0,
                      write_1, addr_1, bank_1, bw_1, din_1);

  string name = "mem_beh_1r1w1p";
  parameter AW      = 10;
  parameter DW      = 32;
  parameter WORDS   = 1024;
  parameter LATENCY = 2;
  parameter BANKS	= 1;
  parameter BAW		= 0;

  localparam MAX_LATENCY = 30;

  input             clk;
  input             rst;

  input             read_0;
  input [AW-1:0]    addr_0;
  input [BAW-1:0]	bank_0;
  output [DW-1:0]   dout_0;

  input             write_1;
  input [AW-1:0]    addr_1;
  input [BAW-1:0]	bank_1;
  input [DW-1:0]    din_1;
  input [DW-1:0]    bw_1;
  
  output            read_serr_0;
  output            read_derr_0;
  assign read_serr_0 = 1'b0;
  assign read_derr_0 = 1'b0;

  reg [DW-1:0]      mem [0:BANKS*WORDS-1];
  always @(posedge clk)
    if (write_1)
      mem[bank_1*WORDS + addr_1] <= (~bw_1 & mem[bank_1*WORDS + addr_1]) | (bw_1 & din_1);

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
    if(~rst & (read_0 & (addr_0 >= WORDS || bank_0 >= BANKS)))  begin `ERROR("(~rst & (read_0 & (addr_0 >= WORDS || bank_0 >= BANKS)))")  end
    if(~rst & (write_1 & (addr_1 >= WORDS || bank_1 >= BANKS))) begin `ERROR("(~rst & (write_1 & (addr_1 >= WORDS || bank_1 >= BANKS)))") end
  end

  // TBD: add refresh asserts

endmodule // mem_beh_1r1w1p
