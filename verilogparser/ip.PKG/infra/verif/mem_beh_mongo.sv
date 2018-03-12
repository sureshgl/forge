/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

// Memory model that supports two port of each type
// *Supports only one op per cycle out of twelve possible*
// This module is used as basic sanity test for the
// testbench environment.

module mem_beh_mongo  (clk, rst,
                       read_0, addr_0, dout_0, read_vld_0, read_serr_0, read_derr_0,
                       read_1, addr_1, dout_1, read_vld_1, read_serr_1, read_derr_1,
                       write_2, addr_2, bw_2, din_2,
                       write_3, addr_3, bw_3, din_3,
                       read_4, write_4, addr_4, din_4, bw_4, dout_4, read_vld_4, read_serr_4, read_derr_4,
                       read_5, write_5, addr_5, din_5, bw_5, dout_5, read_vld_5, read_serr_5, read_derr_5,
                       cnt_6, ct_adr_6, ct_imm_6, ct_vld_6, ct_serr_6, ct_derr_6,
                       cnt_7, ct_adr_7, ct_imm_7, ct_vld_7, ct_serr_7, ct_derr_7,
                       ac_read_8, ac_write_8, ac_addr_8, ac_din_8, ac_dout_8, ac_vld_8, ac_serr_8, ac_derr_8,
                       ac_read_9, ac_write_9, ac_addr_9, ac_din_9, ac_dout_9, ac_vld_9, ac_serr_9, ac_derr_9,
                       ru_read_10, ru_write_10, ru_addr_10, ru_din_10, ru_bw_10, ru_dout_10, ru_vld_10, ru_serr_10, ru_derr_10,
                       ru_read_11, ru_write_11, ru_addr_11, ru_din_11, ru_bw_11, ru_dout_11, ru_vld_11, ru_serr_11, ru_derr_11
                       );
  string name = "mem_beh_mongo";
  parameter AW      = 10;
  parameter DW      = 32;
  parameter WORDS   = 1024;
  parameter LATENCY = 2;

  localparam MAX_LATENCY = 30;

  input             clk;
  input             rst;

  input             read_0;
  input [AW-1:0]    addr_0;
  output [DW-1:0]   dout_0;
  output            read_vld_0;
  output            read_serr_0;
  output            read_derr_0;
  input             read_1;
  input [AW-1:0]    addr_1;
  output [DW-1:0]   dout_1;
  output            read_vld_1;
  output            read_serr_1;
  output            read_derr_1;
  
  input             write_2;
  input [AW-1:0]    addr_2;
  input [DW-1:0]    din_2;
  input [DW-1:0]    bw_2;
  input             write_3;
  input [AW-1:0]    addr_3;
  input [DW-1:0]    din_3;
  input [DW-1:0]    bw_3;
  
  input             read_4;
  input             write_4;
  input [AW-1:0]    addr_4;
  input [DW-1:0]    din_4;
  input [DW-1:0]    bw_4;
  output [DW-1:0]   dout_4;
  output            read_vld_4;
  output            read_serr_4;
  output            read_derr_4;
  input             read_5;
  input             write_5;
  input [AW-1:0]    addr_5;
  input [DW-1:0]    din_5;
  input [DW-1:0]    bw_5;
  output [DW-1:0]   dout_5;
  output            read_vld_5;
  output            read_serr_5;
  output            read_derr_5;
  
  input             cnt_6;
  input [AW-1:0]    ct_adr_6;
  input [DW-1:0]    ct_imm_6;
  output            ct_vld_6;
  output            ct_serr_6;
  output            ct_derr_6;
  input             cnt_7;
  input [AW-1:0]    ct_adr_7;
  input [DW-1:0]    ct_imm_7;
  output            ct_vld_7;
  output            ct_serr_7;
  output            ct_derr_7;
  
  input             ac_read_8;
  input             ac_write_8;
  input [AW-1:0]    ac_addr_8;
  input [DW-1:0]    ac_din_8;
  output [DW-1:0]   ac_dout_8;
  output            ac_vld_8;
  output            ac_serr_8;
  output            ac_derr_8;
  input             ac_read_9;
  input             ac_write_9;
  input [AW-1:0]    ac_addr_9;
  input [DW-1:0]    ac_din_9;
  output [DW-1:0]   ac_dout_9;
  output            ac_vld_9;
  output            ac_serr_9;
  output            ac_derr_9;
  
  input             ru_read_10;
  input             ru_write_10;
  input [AW-1:0]    ru_addr_10;
  input [DW-1:0]    ru_din_10;
  input [DW-1:0]    ru_bw_10;
  output [DW-1:0]   ru_dout_10;
  output            ru_vld_10;
  output            ru_serr_10;
  output            ru_derr_10;
  input             ru_read_11;
  input             ru_write_11;
  input [AW-1:0]    ru_addr_11;
  input [DW-1:0]    ru_din_11;
  input [DW-1:0]    ru_bw_11;
  output [DW-1:0]   ru_dout_11;
  output            ru_vld_11;
  output            ru_serr_11;
  output            ru_derr_11;

  wire [AW-1:0]     ru_addr_10_w;
  wire [AW-1:0]     ru_addr_11_w;
  
  wire [DW:0]       ct_6_t;
  wire [DW:0]       ct_7_t;
  wire [DW-1:0]     ct_din_6;
  wire [DW-1:0]     ct_din_7;

  reg [DW-1:0]      mem [0:WORDS-1];

  assign ct_6_t   = cnt_6 ? mem[ct_adr_6] + ct_imm_6 : {DW+1{1'b0}};
  assign ct_7_t   = cnt_7 ? mem[ct_adr_7] + ct_imm_7 : {DW+1{1'b0}};
  assign ct_din_6 = {|ct_6_t[DW:DW-1],ct_6_t[DW-2:0]};
  assign ct_din_7 = {|ct_7_t[DW:DW-1],ct_7_t[DW-2:0]};

  always @(posedge clk) begin
    if (write_2)
      mem[addr_2] <= (~bw_2 & mem[addr_2]) | (bw_2 & din_2);
    if (write_3)
      mem[addr_3] <= (~bw_3 & mem[addr_3]) | (bw_3 & din_3);
    if (write_4)
      mem[addr_4] <= (~bw_4 & mem[addr_4]) | (bw_4 & din_4);
    if (write_5)
      mem[addr_5] <= (~bw_5 & mem[addr_5]) | (bw_5 & din_5);
    if (cnt_6)
      mem[ct_adr_6] <= ct_din_6;
    if (cnt_7)
      mem[ct_adr_7] <= ct_din_7;
    if (ac_write_8)
      mem[ac_addr_8] <= ac_din_8;
    if (ac_write_9)
      mem[ac_addr_9] <= ac_din_9;
    if (ru_write_10)
      mem[ru_addr_10_w] <= (~ru_bw_10 & mem[ru_addr_10_w]) | (ru_bw_10 & ru_din_10);
    if (ru_write_11)
      mem[ru_addr_11_w] <= (~ru_bw_11 & mem[ru_addr_11_w]) | (ru_bw_11 & ru_din_11);
  end
  
  integer           dout_0_int;
  wire [DW-1:0]      dout_0_wire = read_0 ? mem[addr_0] : {DW{1'bx}};
  reg [DW-1:0]      dout_0_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (dout_0_int=0; dout_0_int<MAX_LATENCY; dout_0_int=dout_0_int+1)
      if (dout_0_int>0)
        dout_0_reg[dout_0_int] <= dout_0_reg[dout_0_int-1];
      else
        dout_0_reg[dout_0_int] <= dout_0_wire;
  generate
    if (LATENCY) 
      assign dout_0 = dout_0_reg[LATENCY-1];
    else 
      assign dout_0 = dout_0_wire;
  endgenerate

  integer           dout_1_int;
  wire [DW-1:0]      dout_1_wire = read_1 ? mem[addr_1] : {DW{1'bx}};
  reg [DW-1:0]      dout_1_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (dout_1_int=0; dout_1_int<MAX_LATENCY; dout_1_int=dout_1_int+1)
      if (dout_1_int>0)
        dout_1_reg[dout_1_int] <= dout_1_reg[dout_1_int-1];
      else
        dout_1_reg[dout_1_int] <= dout_1_wire;
  generate
    if (LATENCY) 
      assign dout_1 = dout_1_reg[LATENCY-1];
    else 
      assign dout_1 = dout_1_wire;
  endgenerate

  integer           dout_4_int;
  wire [DW-1:0]      dout_4_wire = read_4 ? mem[addr_4] : {DW{1'bx}};
  reg [DW-1:0]      dout_4_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (dout_4_int=0; dout_4_int<MAX_LATENCY; dout_4_int=dout_4_int+1)
      if (dout_4_int>0)
        dout_4_reg[dout_4_int] <= dout_4_reg[dout_4_int-1];
      else
        dout_4_reg[dout_4_int] <= dout_4_wire;
  generate
    if (LATENCY) 
      assign dout_4 = dout_4_reg[LATENCY-1];
    else 
      assign dout_4 = dout_4_wire;
  endgenerate

  integer           dout_5_int;
  wire [DW-1:0]      dout_5_wire = read_5 ? mem[addr_5] : {DW{1'bx}};
  reg [DW-1:0]      dout_5_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (dout_5_int=0; dout_5_int<MAX_LATENCY; dout_5_int=dout_5_int+1)
      if (dout_5_int>0)
        dout_5_reg[dout_5_int] <= dout_5_reg[dout_5_int-1];
      else
        dout_5_reg[dout_5_int] <= dout_5_wire;
  generate
    if (LATENCY) 
      assign dout_5 = dout_5_reg[LATENCY-1];
    else 
      assign dout_5 = dout_5_wire;
  endgenerate

  integer           ac_dout_8_int;
  wire [DW-1:0]     ac_dout_8_wire = ac_read_8 ? mem[ac_addr_8] : {DW{1'bx}};
  reg [DW-1:0]      ac_dout_8_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (ac_dout_8_int=0; ac_dout_8_int<MAX_LATENCY; ac_dout_8_int=ac_dout_8_int+1)
      if (ac_dout_8_int>0)
        ac_dout_8_reg[ac_dout_8_int] <= ac_dout_8_reg[ac_dout_8_int-1];
      else
        ac_dout_8_reg[ac_dout_8_int] <= ac_dout_8_wire;
  generate
    if (LATENCY) 
      assign ac_dout_8 = ac_dout_8_reg[LATENCY-1];
    else 
      assign ac_dout_8 = ac_dout_8_wire;
  endgenerate

  integer           ac_dout_9_int;
  wire [DW-1:0]     ac_dout_9_wire = ac_read_9 ? mem[ac_addr_9] : {DW{1'bx}};
  reg [DW-1:0]      ac_dout_9_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (ac_dout_9_int=0; ac_dout_9_int<MAX_LATENCY; ac_dout_9_int=ac_dout_9_int+1)
      if (ac_dout_9_int>0)
        ac_dout_9_reg[ac_dout_9_int] <= ac_dout_9_reg[ac_dout_9_int-1];
      else
        ac_dout_9_reg[ac_dout_9_int] <= ac_dout_9_wire;
  generate
    if (LATENCY) 
      assign ac_dout_9 = ac_dout_9_reg[LATENCY-1];
    else 
      assign ac_dout_9 = ac_dout_9_wire;
  endgenerate
  
  integer           ru_dout_10_int;
  wire [DW-1:0]     ru_dout_10_wire = ru_read_10 ? mem[ru_addr_10] : {DW{1'bx}};
  reg [DW-1:0]      ru_dout_10_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (ru_dout_10_int=0; ru_dout_10_int<MAX_LATENCY; ru_dout_10_int=ru_dout_10_int+1)
      if (ru_dout_10_int>0)
        ru_dout_10_reg[ru_dout_10_int] <= ru_dout_10_reg[ru_dout_10_int-1];
      else
        ru_dout_10_reg[ru_dout_10_int] <= ru_dout_10_wire;
  generate
    if (LATENCY) 
      assign ru_dout_10 = ru_dout_10_reg[LATENCY-1];
    else 
      assign ru_dout_10 = ru_dout_10_wire;
  endgenerate

  integer           ru_dout_11_int;
  wire [DW-1:0]     ru_dout_11_wire = ru_read_11 ? mem[ru_addr_11] : {DW{1'bx}};
  reg [DW-1:0]      ru_dout_11_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (ru_dout_11_int=0; ru_dout_11_int<MAX_LATENCY; ru_dout_11_int=ru_dout_11_int+1)
      if (ru_dout_11_int>0)
        ru_dout_11_reg[ru_dout_11_int] <= ru_dout_11_reg[ru_dout_11_int-1];
      else
        ru_dout_11_reg[ru_dout_11_int] <= ru_dout_11_wire;
  generate
    if (LATENCY) 
      assign ru_dout_11 = ru_dout_11_reg[LATENCY-1];
    else 
      assign ru_dout_11 = ru_dout_11_wire;
  endgenerate

  integer           ru_addr_10_int;
  wire [AW-1:0]     ru_addr_10_wire = ru_read_10 ? ru_addr_10 : {AW{1'bx}};
  reg [AW-1:0]      ru_addr_10_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (ru_addr_10_int=0; ru_addr_10_int<MAX_LATENCY; ru_addr_10_int=ru_addr_10_int+1)
      if (ru_addr_10_int>0)
        ru_addr_10_reg[ru_addr_10_int] <= ru_addr_10_reg[ru_addr_10_int-1];
      else
        ru_addr_10_reg[ru_addr_10_int] <= ru_addr_10_wire;
  generate
    if (LATENCY) 
      assign ru_addr_10_w = ru_addr_10_reg[LATENCY-1];
    else 
      assign ru_addr_10_w = ru_addr_10_wire;
  endgenerate

  integer           ru_addr_11_int;
  wire [AW-1:0]     ru_addr_11_wire = ru_read_11 ? ru_addr_11 : {AW{1'bx}};
  reg [AW-1:0]      ru_addr_11_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (ru_addr_11_int=0; ru_addr_11_int<MAX_LATENCY; ru_addr_11_int=ru_addr_11_int+1)
      if (ru_addr_11_int>0)
        ru_addr_11_reg[ru_addr_11_int] <= ru_addr_11_reg[ru_addr_11_int-1];
      else
        ru_addr_11_reg[ru_addr_11_int] <= ru_addr_11_wire;
  generate
    if (LATENCY) 
      assign ru_addr_11_w = ru_addr_11_reg[LATENCY-1];
    else 
      assign ru_addr_11_w = ru_addr_11_wire;
  endgenerate

  initial
    if (LATENCY >= MAX_LATENCY) begin
      $display("ERR :%m:%0t: LATENCY >= MAX_LATENCY", $time);
      $finish;
    end

  always @(posedge clk) begin 
    if (~rst & (read_0 & (addr_0 >= WORDS)))  begin `ERROR("(~rst & (read_0 & (addr_0 >= WORDS)))")  end
    if (~rst & (read_1 & (addr_1 >= WORDS)))  begin `ERROR("(~rst & (read_1 & (addr_1 >= WORDS)))")  end
    if (~rst & (write_2 & (addr_2 >= WORDS))) begin `ERROR("(~rst & (write_2 & (addr_2 >= WORDS)))") end
    if (~rst & (write_3 & (addr_3 >= WORDS))) begin `ERROR("(~rst & (write_3 & (addr_3 >= WORDS)))") end
    // TBD :: add more checks
  end 

  // TBD: add refresh asserts

endmodule // mem_beh_1r1w
