/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
module mem_beh_2rw  (clk, rst,
                     read_0, write_0, addr_0, din_0, bw_0, dout_0, read_serr_0, read_derr_0,
                     read_1, write_1, addr_1, din_1, bw_1, dout_1, read_serr_1, read_derr_1
                     );
  string name = "mem_beh_2rw";
  parameter AW      = 10;
  parameter DW      = 32;
  parameter LATENCY = 2;
  parameter WORDS   = 1024;

  localparam MAX_LATENCY = 30;

  input             clk;
  input             rst;

  input             read_0;
  input             write_0;
  input [AW-1:0]    addr_0;
  input [DW-1:0]    din_0;
  input [DW-1:0]    bw_0;
  output [DW-1:0]   dout_0;

  input             read_1;
  input             write_1;
  input [AW-1:0]    addr_1;
  input [DW-1:0]    din_1;
  input [DW-1:0]    bw_1;
  output [DW-1:0]   dout_1;
  
  output            read_serr_0;
  output            read_derr_0;
  output            read_serr_1;
  output            read_derr_1;
  assign read_serr_0 = 1'b0;
  assign read_derr_0 = 1'b0;
  assign read_serr_1 = 1'b0;
  assign read_derr_1 = 1'b0;

  reg [DW-1:0]      mem [0:WORDS-1];
  always @(posedge clk)
    if (write_0)
      mem[addr_0] <= (~bw_0 & mem[addr_0]) | (bw_0 & din_0);

  always @(posedge clk)
    if (write_1)
      mem[addr_1] <= (~bw_1 & mem[addr_1]) | (bw_1 & din_1);

  integer           dout_0_int;
  reg [DW-1:0]      dout_0_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (dout_0_int=0; dout_0_int<MAX_LATENCY; dout_0_int=dout_0_int+1)
      if (dout_0_int>0)
        dout_0_reg[dout_0_int] <= dout_0_reg[dout_0_int-1];
      else
        dout_0_reg[dout_0_int] <= read_0 ? mem[addr_0] : {DW{1'bx}}; 

  generate
    if (LATENCY) 
      assign dout_0 = dout_0_reg[LATENCY-1];
    else 
      assign dout_0 = mem[addr_0];
  endgenerate

  integer           dout_1_int;
  reg [DW-1:0]      dout_1_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (dout_1_int=0; dout_1_int<MAX_LATENCY; dout_1_int=dout_1_int+1)
      if (dout_1_int>0)
        dout_1_reg[dout_1_int] <= dout_1_reg[dout_1_int-1];
      else
        dout_1_reg[dout_1_int] <= read_1 ? mem[addr_1] : {DW{1'bx}}; 

  generate
    if (LATENCY)
      assign dout_1 = dout_1_reg[LATENCY-1];
    else 
      assign dout_1 = mem[addr_1];
  endgenerate

  initial
    if (LATENCY >= MAX_LATENCY) begin
      $display("ERR :%m:%0t: LATENCY >= MAX_LATENCY", $time);
      $finish;
    end

  always @(posedge clk) begin
    if(~rst & read_0 & write_0) begin `ERROR("(~rst & read_0 & write_0))") end
    if(~rst & read_1 & write_1) begin `ERROR("(~rst & read_1 & write_1))") end
    if(~rst & (write_0 | read_0) & (addr_0 >= WORDS)) begin `ERROR("(~rst & (write_0 | read_0) & (addr_0 >= WORDS)))") end
    if(~rst & (write_1 | read_1) & (addr_1 >= WORDS)) begin `ERROR("(~rst & (write_1 | read_1) & (addr_1 >= WORDS)))") end
  end

  // TBD: add refresh asserts

endmodule
