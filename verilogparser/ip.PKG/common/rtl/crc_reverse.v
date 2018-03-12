module crc_reverse (clk, key, crc, result);

  parameter KEYWIDTH = 32;
  parameter CRCWIDTH = 0;
  parameter CRCPOLYID = 0;
  parameter FLOPCRC = 0;

  input                     clk;
  input  [KEYWIDTH-CRCWIDTH-1:0]     key;
  input  [CRCWIDTH-1:0]     crc;
  output [CRCWIDTH-1:0]     result;

  wire   [CRCWIDTH-1:0]     result_tmp;
  wire   [CRCWIDTH-1:0]     part_crc;

  crc_calc #(.KEYWIDTH(KEYWIDTH), .CRCWIDTH(CRCWIDTH), .CRCPOLYID(CRCPOLYID), .FLOPCRC(0))
  calc (.clk(clk), .key({key, {CRCWIDTH{1'b0}}}), .result(part_crc));

  wire    [CRCWIDTH-1:0] exp = part_crc ^ crc;

  generate if (1) begin: crc_rev_inst
    if  (CRCWIDTH == 7)
        crc_reverse_7 #(.CRCPOLYID(CRCPOLYID)) crc_reverse (.exp(exp), .result(result_tmp));
    else if  (CRCWIDTH == 8)
        crc_reverse_8 #(.CRCPOLYID(CRCPOLYID)) crc_reverse (.exp(exp), .result(result_tmp));
    else if  (CRCWIDTH == 9)
        crc_reverse_9 #(.CRCPOLYID(CRCPOLYID)) crc_reverse (.exp(exp), .result(result_tmp));
    else if  (CRCWIDTH == 10)
        crc_reverse_10 #(.CRCPOLYID(CRCPOLYID)) crc_reverse (.exp(exp), .result(result_tmp));
    else if  (CRCWIDTH == 11)
        crc_reverse_11 #(.CRCPOLYID(CRCPOLYID)) crc_reverse (.exp(exp), .result(result_tmp));
    else if  (CRCWIDTH == 12)
        crc_reverse_12 #(.CRCPOLYID(CRCPOLYID)) crc_reverse (.exp(exp), .result(result_tmp));
    else if  (CRCWIDTH == 13)
        crc_reverse_13 #(.CRCPOLYID(CRCPOLYID)) crc_reverse (.exp(exp), .result(result_tmp));
    else if  (CRCWIDTH == 14)
        crc_reverse_14 #(.CRCPOLYID(CRCPOLYID)) crc_reverse (.exp(exp), .result(result_tmp));
    else if  (CRCWIDTH == 15)
        crc_reverse_15 #(.CRCPOLYID(CRCPOLYID)) crc_reverse (.exp(exp), .result(result_tmp));
  end
  endgenerate

  generate if(FLOPCRC) begin : flpcrc_loop
    reg [CRCWIDTH-1:0] result_reg;
    always @(posedge clk) result_reg <= result_tmp;
    assign result = result_reg;
  end
  else begin : noflpcrc_loop
    assign result = result_tmp;
  end
  endgenerate

endmodule


module crc_reverse_7 #(parameter CRCPOLYID = 0) (exp, result);

  input  [6:0] exp;
  output [6:0] result;

  generate if (1) begin: polyinst
    if(CRCPOLYID == 0)
      ip_gf_2_poly_0x11_crc7_rev crc_poly_0 (.exp(exp), .result(result));
    else if(CRCPOLYID == 1)
      ip_gf_2_poly_0x9_crc7_rev crc_poly_1 (.exp(exp), .result(result));
    else if(CRCPOLYID == 2)
      ip_gf_2_poly_0x65_crc7_rev crc_poly_2 (.exp(exp), .result(result));
    else if(CRCPOLYID == 3)
      ip_gf_2_poly_0x4f_crc7_rev crc_poly_3 (.exp(exp), .result(result));
    else if(CRCPOLYID == 4)
      ip_gf_2_poly_0x7d_crc7_rev crc_poly_4 (.exp(exp), .result(result));
    else if(CRCPOLYID == 5)
      ip_gf_2_poly_0x39_crc7_rev crc_poly_5 (.exp(exp), .result(result));
    else if(CRCPOLYID == 6)
      ip_gf_2_poly_0x53_crc7_rev crc_poly_6 (.exp(exp), .result(result));
    else if(CRCPOLYID == 7)
      ip_gf_2_poly_0x6f_crc7_rev crc_poly_7 (.exp(exp), .result(result));
    else if(CRCPOLYID == 8)
      ip_gf_2_poly_0x2b_crc7_rev crc_poly_8 (.exp(exp), .result(result));
    else if(CRCPOLYID == 9)
      ip_gf_2_poly_0x77_crc7_rev crc_poly_9 (.exp(exp), .result(result));
    else if(CRCPOLYID == 10)
      ip_gf_2_poly_0x55_crc7_rev crc_poly_10 (.exp(exp), .result(result));
    else if(CRCPOLYID == 11)
      ip_gf_2_poly_0x3_crc7_rev crc_poly_11 (.exp(exp), .result(result));
    else if(CRCPOLYID == 12)
      ip_gf_2_poly_0x71_crc7_rev crc_poly_12 (.exp(exp), .result(result));
    else if(CRCPOLYID == 13)
      ip_gf_2_poly_0x41_crc7_rev crc_poly_13 (.exp(exp), .result(result));
    else if(CRCPOLYID == 14)
      ip_gf_2_poly_0x27_crc7_rev crc_poly_14 (.exp(exp), .result(result));
    else if(CRCPOLYID == 15)
      ip_gf_2_poly_0x3f_crc7_rev crc_poly_15 (.exp(exp), .result(result));
  end
  endgenerate

endmodule

module crc_reverse_8 #(parameter CRCPOLYID = 0) (exp, result);

  input  [7:0] exp;
  output [7:0] result;

  generate if (1) begin: polyinst
    if(CRCPOLYID == 0)
      ip_gf_2_poly_0x31_crc8_rev crc_poly_0 (.exp(exp), .result(result));
    else if(CRCPOLYID == 1)
      ip_gf_2_poly_0x2f_crc8_rev crc_poly_1 (.exp(exp), .result(result));
    else if(CRCPOLYID == 2)
      ip_gf_2_poly_0x39_crc8_rev crc_poly_2 (.exp(exp), .result(result));
    else if(CRCPOLYID == 3)
      ip_gf_2_poly_0xd5_crc8_rev crc_poly_3 (.exp(exp), .result(result));
    else if(CRCPOLYID == 4)
      ip_gf_2_poly_0x65_crc8_rev crc_poly_4 (.exp(exp), .result(result));
    else if(CRCPOLYID == 5)
      ip_gf_2_poly_0x87_crc8_rev crc_poly_5 (.exp(exp), .result(result));
    else if(CRCPOLYID == 6)
      ip_gf_2_poly_0x5f_crc8_rev crc_poly_6 (.exp(exp), .result(result));
    else if(CRCPOLYID == 7)
      ip_gf_2_poly_0x63_crc8_rev crc_poly_7 (.exp(exp), .result(result));
    else if(CRCPOLYID == 8)
      ip_gf_2_poly_0xcf_crc8_rev crc_poly_8 (.exp(exp), .result(result));
    else if(CRCPOLYID == 9)
      ip_gf_2_poly_0x4d_crc8_rev crc_poly_9 (.exp(exp), .result(result));
    else if(CRCPOLYID == 10)
      ip_gf_2_poly_0x1d_crc8_rev crc_poly_10 (.exp(exp), .result(result));
    else if(CRCPOLYID == 11)
      ip_gf_2_poly_0x8d_crc8_rev crc_poly_11 (.exp(exp), .result(result));
    else if(CRCPOLYID == 12)
      ip_gf_2_poly_0x69_crc8_rev crc_poly_12 (.exp(exp), .result(result));
    else if(CRCPOLYID == 13)
      ip_gf_2_poly_0xf5_crc8_rev crc_poly_13 (.exp(exp), .result(result));
    else if(CRCPOLYID == 14)
      ip_gf_2_poly_0xa9_crc8_rev crc_poly_14 (.exp(exp), .result(result));
    else if(CRCPOLYID == 15)
      ip_gf_2_poly_0x2d_crc8_rev crc_poly_15 (.exp(exp), .result(result));
  end
  endgenerate

endmodule

module crc_reverse_9 #(parameter CRCPOLYID = 0) (exp, result);

  input  [8:0] exp;
  output [8:0] result;

  generate if (1) begin: polyinst
    if(CRCPOLYID == 0)
      ip_gf_2_poly_0x79_crc9_rev crc_poly_0 (.exp(exp), .result(result));
    else if(CRCPOLYID == 1)
      ip_gf_2_poly_0x137_crc9_rev crc_poly_1 (.exp(exp), .result(result));
    else if(CRCPOLYID == 2)
      ip_gf_2_poly_0x10b_crc9_rev crc_poly_2 (.exp(exp), .result(result));
    else if(CRCPOLYID == 3)
      ip_gf_2_poly_0x5f_crc9_rev crc_poly_3 (.exp(exp), .result(result));
    else if(CRCPOLYID == 4)
      ip_gf_2_poly_0x95_crc9_rev crc_poly_4 (.exp(exp), .result(result));
    else if(CRCPOLYID == 5)
      ip_gf_2_poly_0x1e3_crc9_rev crc_poly_5 (.exp(exp), .result(result));
    else if(CRCPOLYID == 6)
      ip_gf_2_poly_0x1b5_crc9_rev crc_poly_6 (.exp(exp), .result(result));
    else if(CRCPOLYID == 7)
      ip_gf_2_poly_0x77_crc9_rev crc_poly_7 (.exp(exp), .result(result));
    else if(CRCPOLYID == 8)
      ip_gf_2_poly_0x1cd_crc9_rev crc_poly_8 (.exp(exp), .result(result));
    else if(CRCPOLYID == 9)
      ip_gf_2_poly_0xa5_crc9_rev crc_poly_9 (.exp(exp), .result(result));
    else if(CRCPOLYID == 10)
      ip_gf_2_poly_0x1b_crc9_rev crc_poly_10 (.exp(exp), .result(result));
    else if(CRCPOLYID == 11)
      ip_gf_2_poly_0x13b_crc9_rev crc_poly_11 (.exp(exp), .result(result));
    else if(CRCPOLYID == 12)
      ip_gf_2_poly_0x173_crc9_rev crc_poly_12 (.exp(exp), .result(result));
    else if(CRCPOLYID == 13)
      ip_gf_2_poly_0x87_crc9_rev crc_poly_13 (.exp(exp), .result(result));
    else if(CRCPOLYID == 14)
      ip_gf_2_poly_0x16d_crc9_rev crc_poly_14 (.exp(exp), .result(result));
    else if(CRCPOLYID == 15)
      ip_gf_2_poly_0x11_crc9_rev crc_poly_15 (.exp(exp), .result(result));
  end
  endgenerate

endmodule

module crc_reverse_10 #(parameter CRCPOLYID = 0) (exp, result);

  input  [9:0] exp;
  output [9:0] result;

  generate if (1) begin: polyinst
    if(CRCPOLYID == 0)
      ip_gf_2_poly_0x11d_crc10_rev crc_poly_0 (.exp(exp), .result(result));
    else if(CRCPOLYID == 1)
      ip_gf_2_poly_0x173_crc10_rev crc_poly_1 (.exp(exp), .result(result));
    else if(CRCPOLYID == 2)
      ip_gf_2_poly_0x233_crc10_rev crc_poly_2 (.exp(exp), .result(result));
    else if(CRCPOLYID == 3)
      ip_gf_2_poly_0x24f_crc10_rev crc_poly_3 (.exp(exp), .result(result));
    else if(CRCPOLYID == 4)
      ip_gf_2_poly_0x37d_crc10_rev crc_poly_4 (.exp(exp), .result(result));
    else if(CRCPOLYID == 5)
      ip_gf_2_poly_0x27f_crc10_rev crc_poly_5 (.exp(exp), .result(result));
    else if(CRCPOLYID == 6)
      ip_gf_2_poly_0x81_crc10_rev crc_poly_6 (.exp(exp), .result(result));
    else if(CRCPOLYID == 7)
      ip_gf_2_poly_0x2df_crc10_rev crc_poly_7 (.exp(exp), .result(result));
    else if(CRCPOLYID == 8)
      ip_gf_2_poly_0x2d_crc10_rev crc_poly_8 (.exp(exp), .result(result));
    else if(CRCPOLYID == 9)
      ip_gf_2_poly_0x18f_crc10_rev crc_poly_9 (.exp(exp), .result(result));
    else if(CRCPOLYID == 10)
      ip_gf_2_poly_0x289_crc10_rev crc_poly_10 (.exp(exp), .result(result));
    else if(CRCPOLYID == 11)
      ip_gf_2_poly_0x225_crc10_rev crc_poly_11 (.exp(exp), .result(result));
    else if(CRCPOLYID == 12)
      ip_gf_2_poly_0x393_crc10_rev crc_poly_12 (.exp(exp), .result(result));
    else if(CRCPOLYID == 13)
      ip_gf_2_poly_0x197_crc10_rev crc_poly_13 (.exp(exp), .result(result));
    else if(CRCPOLYID == 14)
      ip_gf_2_poly_0x317_crc10_rev crc_poly_14 (.exp(exp), .result(result));
    else if(CRCPOLYID == 15)
      ip_gf_2_poly_0x215_crc10_rev crc_poly_15 (.exp(exp), .result(result));
  end
  endgenerate

endmodule

module crc_reverse_11 #(parameter CRCPOLYID = 0) (exp, result);

  input  [10:0] exp;
  output [10:0] result;

  generate if (1) begin: polyinst
    if(CRCPOLYID == 0)
      ip_gf_2_poly_0x265_crc11_rev crc_poly_0 (.exp(exp), .result(result));
    else if(CRCPOLYID == 1)
      ip_gf_2_poly_0x3af_crc11_rev crc_poly_1 (.exp(exp), .result(result));
    else if(CRCPOLYID == 2)
      ip_gf_2_poly_0x307_crc11_rev crc_poly_2 (.exp(exp), .result(result));
    else if(CRCPOLYID == 3)
      ip_gf_2_poly_0x49b_crc11_rev crc_poly_3 (.exp(exp), .result(result));
    else if(CRCPOLYID == 4)
      ip_gf_2_poly_0x175_crc11_rev crc_poly_4 (.exp(exp), .result(result));
    else if(CRCPOLYID == 5)
      ip_gf_2_poly_0x5f5_crc11_rev crc_poly_5 (.exp(exp), .result(result));
    else if(CRCPOLYID == 6)
      ip_gf_2_poly_0x457_crc11_rev crc_poly_6 (.exp(exp), .result(result));
    else if(CRCPOLYID == 7)
      ip_gf_2_poly_0x29d_crc11_rev crc_poly_7 (.exp(exp), .result(result));
    else if(CRCPOLYID == 8)
      ip_gf_2_poly_0x79b_crc11_rev crc_poly_8 (.exp(exp), .result(result));
    else if(CRCPOLYID == 9)
      ip_gf_2_poly_0x2fb_crc11_rev crc_poly_9 (.exp(exp), .result(result));
    else if(CRCPOLYID == 10)
      ip_gf_2_poly_0x5e7_crc11_rev crc_poly_10 (.exp(exp), .result(result));
    else if(CRCPOLYID == 11)
      ip_gf_2_poly_0x2b3_crc11_rev crc_poly_11 (.exp(exp), .result(result));
    else if(CRCPOLYID == 12)
      ip_gf_2_poly_0x3c9_crc11_rev crc_poly_12 (.exp(exp), .result(result));
    else if(CRCPOLYID == 13)
      ip_gf_2_poly_0x61d_crc11_rev crc_poly_13 (.exp(exp), .result(result));
    else if(CRCPOLYID == 14)
      ip_gf_2_poly_0x67b_crc11_rev crc_poly_14 (.exp(exp), .result(result));
    else if(CRCPOLYID == 15)
      ip_gf_2_poly_0x4e9_crc11_rev crc_poly_15 (.exp(exp), .result(result));
  end
  endgenerate

endmodule

module crc_reverse_12 #(parameter CRCPOLYID = 0) (exp, result);

  input  [11:0] exp;
  output [11:0] result;

  generate if (1) begin: polyinst
    if(CRCPOLYID == 0)
      ip_gf_2_poly_0x683_crc12_rev crc_poly_0 (.exp(exp), .result(result));
    else if(CRCPOLYID == 1)
      ip_gf_2_poly_0x80b_crc12_rev crc_poly_1 (.exp(exp), .result(result));
    else if(CRCPOLYID == 2)
      ip_gf_2_poly_0x807_crc12_rev crc_poly_2 (.exp(exp), .result(result));
    else if(CRCPOLYID == 3)
      ip_gf_2_poly_0x6eb_crc12_rev crc_poly_3 (.exp(exp), .result(result));
    else if(CRCPOLYID == 4)
      ip_gf_2_poly_0xc9f_crc12_rev crc_poly_4 (.exp(exp), .result(result));
    else if(CRCPOLYID == 5)
      ip_gf_2_poly_0xa1b_crc12_rev crc_poly_5 (.exp(exp), .result(result));
    else if(CRCPOLYID == 6)
      ip_gf_2_poly_0xd43_crc12_rev crc_poly_6 (.exp(exp), .result(result));
    else if(CRCPOLYID == 7)
      ip_gf_2_poly_0x45d_crc12_rev crc_poly_7 (.exp(exp), .result(result));
    else if(CRCPOLYID == 8)
      ip_gf_2_poly_0x7b_crc12_rev crc_poly_8 (.exp(exp), .result(result));
    else if(CRCPOLYID == 9)
      ip_gf_2_poly_0x371_crc12_rev crc_poly_9 (.exp(exp), .result(result));
    else if(CRCPOLYID == 10)
      ip_gf_2_poly_0x5c5_crc12_rev crc_poly_10 (.exp(exp), .result(result));
    else if(CRCPOLYID == 11)
      ip_gf_2_poly_0x7bf_crc12_rev crc_poly_11 (.exp(exp), .result(result));
    else if(CRCPOLYID == 12)
      ip_gf_2_poly_0x3a9_crc12_rev crc_poly_12 (.exp(exp), .result(result));
    else if(CRCPOLYID == 13)
      ip_gf_2_poly_0x107_crc12_rev crc_poly_13 (.exp(exp), .result(result));
    else if(CRCPOLYID == 14)
      ip_gf_2_poly_0x935_crc12_rev crc_poly_14 (.exp(exp), .result(result));
    else if(CRCPOLYID == 15)
      ip_gf_2_poly_0xfbd_crc12_rev crc_poly_15 (.exp(exp), .result(result));
  end
  endgenerate

endmodule

module crc_reverse_13 #(parameter CRCPOLYID = 0) (exp, result);

  input  [12:0] exp;
  output [12:0] result;

  generate if (1) begin: polyinst
    if(CRCPOLYID == 0)
      ip_gf_2_poly_0x16f_crc13_rev crc_poly_0 (.exp(exp), .result(result));
    else if(CRCPOLYID == 1)
      ip_gf_2_poly_0x54b_crc13_rev crc_poly_1 (.exp(exp), .result(result));
    else if(CRCPOLYID == 2)
      ip_gf_2_poly_0x1213_crc13_rev crc_poly_2 (.exp(exp), .result(result));
    else if(CRCPOLYID == 3)
      ip_gf_2_poly_0x55_crc13_rev crc_poly_3 (.exp(exp), .result(result));
    else if(CRCPOLYID == 4)
      ip_gf_2_poly_0x1477_crc13_rev crc_poly_4 (.exp(exp), .result(result));
    else if(CRCPOLYID == 5)
      ip_gf_2_poly_0x15d5_crc13_rev crc_poly_5 (.exp(exp), .result(result));
    else if(CRCPOLYID == 6)
      ip_gf_2_poly_0x1907_crc13_rev crc_poly_6 (.exp(exp), .result(result));
    else if(CRCPOLYID == 7)
      ip_gf_2_poly_0x5d7_crc13_rev crc_poly_7 (.exp(exp), .result(result));
    else if(CRCPOLYID == 8)
      ip_gf_2_poly_0xce7_crc13_rev crc_poly_8 (.exp(exp), .result(result));
    else if(CRCPOLYID == 9)
      ip_gf_2_poly_0x38d_crc13_rev crc_poly_9 (.exp(exp), .result(result));
    else if(CRCPOLYID == 10)
      ip_gf_2_poly_0x4c1_crc13_rev crc_poly_10 (.exp(exp), .result(result));
    else if(CRCPOLYID == 11)
      ip_gf_2_poly_0x1d1b_crc13_rev crc_poly_11 (.exp(exp), .result(result));
    else if(CRCPOLYID == 12)
      ip_gf_2_poly_0xf4d_crc13_rev crc_poly_12 (.exp(exp), .result(result));
    else if(CRCPOLYID == 13)
      ip_gf_2_poly_0x729_crc13_rev crc_poly_13 (.exp(exp), .result(result));
    else if(CRCPOLYID == 14)
      ip_gf_2_poly_0x6b1_crc13_rev crc_poly_14 (.exp(exp), .result(result));
    else if(CRCPOLYID == 15)
      ip_gf_2_poly_0x1f49_crc13_rev crc_poly_15 (.exp(exp), .result(result));
  end
  endgenerate

endmodule

module crc_reverse_14 #(parameter CRCPOLYID = 0) (exp, result);

  input  [13:0] exp;
  output [13:0] result;

  generate if (1) begin: polyinst
    if(CRCPOLYID == 0)
      ip_gf_2_poly_0x2ce5_crc14_rev crc_poly_0 (.exp(exp), .result(result));
    else if(CRCPOLYID == 1)
      ip_gf_2_poly_0x117d_crc14_rev crc_poly_1 (.exp(exp), .result(result));
    else if(CRCPOLYID == 2)
      ip_gf_2_poly_0xd31_crc14_rev crc_poly_2 (.exp(exp), .result(result));
    else if(CRCPOLYID == 3)
      ip_gf_2_poly_0x53_crc14_rev crc_poly_3 (.exp(exp), .result(result));
    else if(CRCPOLYID == 4)
      ip_gf_2_poly_0x3c93_crc14_rev crc_poly_4 (.exp(exp), .result(result));
    else if(CRCPOLYID == 5)
      ip_gf_2_poly_0x2a6d_crc14_rev crc_poly_5 (.exp(exp), .result(result));
    else if(CRCPOLYID == 6)
      ip_gf_2_poly_0x3a1b_crc14_rev crc_poly_6 (.exp(exp), .result(result));
    else if(CRCPOLYID == 7)
      ip_gf_2_poly_0x147b_crc14_rev crc_poly_7 (.exp(exp), .result(result));
    else if(CRCPOLYID == 8)
      ip_gf_2_poly_0x1615_crc14_rev crc_poly_8 (.exp(exp), .result(result));
    else if(CRCPOLYID == 9)
      ip_gf_2_poly_0x1a1f_crc14_rev crc_poly_9 (.exp(exp), .result(result));
    else if(CRCPOLYID == 10)
      ip_gf_2_poly_0x2139_crc14_rev crc_poly_10 (.exp(exp), .result(result));
    else if(CRCPOLYID == 11)
      ip_gf_2_poly_0x35d1_crc14_rev crc_poly_11 (.exp(exp), .result(result));
    else if(CRCPOLYID == 12)
      ip_gf_2_poly_0xf9f_crc14_rev crc_poly_12 (.exp(exp), .result(result));
    else if(CRCPOLYID == 13)
      ip_gf_2_poly_0x5f_crc14_rev crc_poly_13 (.exp(exp), .result(result));
    else if(CRCPOLYID == 14)
      ip_gf_2_poly_0xaf9_crc14_rev crc_poly_14 (.exp(exp), .result(result));
    else if(CRCPOLYID == 15)
      ip_gf_2_poly_0x2c57_crc14_rev crc_poly_15 (.exp(exp), .result(result));
  end
  endgenerate

endmodule

module crc_reverse_15 #(parameter CRCPOLYID = 0) (exp, result);

  input  [14:0] exp;
  output [14:0] result;

  generate if (1) begin: polyinst
    if(CRCPOLYID == 0)
      ip_gf_2_poly_0x1227_crc15_rev crc_poly_0 (.exp(exp), .result(result));
    else if(CRCPOLYID == 1)
      ip_gf_2_poly_0x4a2f_crc15_rev crc_poly_1 (.exp(exp), .result(result));
    else if(CRCPOLYID == 2)
      ip_gf_2_poly_0x5b45_crc15_rev crc_poly_2 (.exp(exp), .result(result));
    else if(CRCPOLYID == 3)
      ip_gf_2_poly_0x7ba3_crc15_rev crc_poly_3 (.exp(exp), .result(result));
    else if(CRCPOLYID == 4)
      ip_gf_2_poly_0x210f_crc15_rev crc_poly_4 (.exp(exp), .result(result));
    else if(CRCPOLYID == 5)
      ip_gf_2_poly_0x5237_crc15_rev crc_poly_5 (.exp(exp), .result(result));
    else if(CRCPOLYID == 6)
      ip_gf_2_poly_0x7f13_crc15_rev crc_poly_6 (.exp(exp), .result(result));
    else if(CRCPOLYID == 7)
      ip_gf_2_poly_0x347_crc15_rev crc_poly_7 (.exp(exp), .result(result));
    else if(CRCPOLYID == 8)
      ip_gf_2_poly_0x123f_crc15_rev crc_poly_8 (.exp(exp), .result(result));
    else if(CRCPOLYID == 9)
      ip_gf_2_poly_0x40cb_crc15_rev crc_poly_9 (.exp(exp), .result(result));
    else if(CRCPOLYID == 10)
      ip_gf_2_poly_0x3ad7_crc15_rev crc_poly_10 (.exp(exp), .result(result));
    else if(CRCPOLYID == 11)
      ip_gf_2_poly_0x665_crc15_rev crc_poly_11 (.exp(exp), .result(result));
    else if(CRCPOLYID == 12)
      ip_gf_2_poly_0x4357_crc15_rev crc_poly_12 (.exp(exp), .result(result));
    else if(CRCPOLYID == 13)
      ip_gf_2_poly_0x376b_crc15_rev crc_poly_13 (.exp(exp), .result(result));
    else if(CRCPOLYID == 14)
      ip_gf_2_poly_0x35f_crc15_rev crc_poly_14 (.exp(exp), .result(result));
    else if(CRCPOLYID == 15)
      ip_gf_2_poly_0x4aad_crc15_rev crc_poly_15 (.exp(exp), .result(result));
  end
  endgenerate

endmodule



module ip_gf_2_poly_0x11_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[0]^exp[3];
  assign result[1]=exp[0]^exp[1]^exp[4];
  assign result[2]=exp[1]^exp[2]^exp[5];
  assign result[3]=exp[2]^exp[3]^exp[6];
  assign result[4]=exp[0]^exp[4];
  assign result[5]=exp[1]^exp[5];
  assign result[6]=exp[2]^exp[6];
endmodule

module ip_gf_2_poly_0x9_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[0]^exp[1]^exp[4];
  assign result[1]=exp[1]^exp[2]^exp[5];
  assign result[2]=exp[0]^exp[2]^exp[3]^exp[6];
  assign result[3]=exp[0]^exp[3];
  assign result[4]=exp[1]^exp[4];
  assign result[5]=exp[2]^exp[5];
  assign result[6]=exp[0]^exp[3]^exp[6];
endmodule

module ip_gf_2_poly_0x65_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[0]^exp[2]^exp[3]^exp[5];
  assign result[1]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6];
  assign result[2]=exp[1]^exp[3]^exp[4];
  assign result[3]=exp[2]^exp[4]^exp[5];
  assign result[4]=exp[3]^exp[5]^exp[6];
  assign result[5]=exp[0]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6];
  assign result[6]=exp[1]^exp[2]^exp[4]^exp[6];
endmodule

module ip_gf_2_poly_0x4f_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[3]^exp[6];
  assign result[1]=exp[0]^exp[4]^exp[6];
  assign result[2]=exp[0]^exp[2]^exp[3]^exp[5]^exp[6];
  assign result[3]=exp[0]^exp[2]^exp[4];
  assign result[4]=exp[1]^exp[3]^exp[5];
  assign result[5]=exp[2]^exp[4]^exp[6];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6];
endmodule

module ip_gf_2_poly_0x7d_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[1]^exp[2]^exp[4]^exp[5];
  assign result[1]=exp[2]^exp[3]^exp[5]^exp[6];
  assign result[2]=exp[1]^exp[2]^exp[3]^exp[5]^exp[6];
  assign result[3]=exp[0]^exp[1]^exp[3]^exp[5]^exp[6];
  assign result[4]=exp[5]^exp[6];
  assign result[5]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6];
  assign result[6]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6];
endmodule

module ip_gf_2_poly_0x39_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6];
  assign result[3]=exp[0]^exp[5]^exp[6];
  assign result[4]=exp[2]^exp[3]^exp[4]^exp[6];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[5];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[3]^exp[6];
endmodule

module ip_gf_2_poly_0x53_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6];
  assign result[1]=exp[1]^exp[3]^exp[4];
  assign result[2]=exp[0]^exp[2]^exp[4]^exp[5];
  assign result[3]=exp[1]^exp[3]^exp[5]^exp[6];
  assign result[4]=exp[0]^exp[1]^exp[5];
  assign result[5]=exp[1]^exp[2]^exp[6];
  assign result[6]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[6];
endmodule

module ip_gf_2_poly_0x6f_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[1]^exp[3]^exp[6];
  assign result[1]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6];
  assign result[2]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[5];
  assign result[4]=exp[1]^exp[2]^exp[3]^exp[6];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[4]^exp[6];
  assign result[6]=exp[0]^exp[2]^exp[5]^exp[6];
endmodule

module ip_gf_2_poly_0x2b_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[0]^exp[2]^exp[3]^exp[5]^exp[6];
  assign result[1]=exp[1]^exp[2]^exp[4]^exp[5];
  assign result[2]=exp[2]^exp[3]^exp[5]^exp[6];
  assign result[3]=exp[0]^exp[2]^exp[4]^exp[5];
  assign result[4]=exp[0]^exp[1]^exp[3]^exp[5]^exp[6];
  assign result[5]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5];
  assign result[6]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6];
endmodule

module ip_gf_2_poly_0x77_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[4]^exp[6];
  assign result[1]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6];
  assign result[2]=exp[2]^exp[5];
  assign result[3]=exp[0]^exp[3]^exp[6];
  assign result[4]=exp[2]^exp[6];
  assign result[5]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6];
  assign result[6]=exp[0]^exp[1]^exp[3]^exp[5]^exp[6];
endmodule

module ip_gf_2_poly_0x55_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[0]^exp[5];
  assign result[1]=exp[0]^exp[1]^exp[6];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[5];
  assign result[3]=exp[1]^exp[2]^exp[3]^exp[6];
  assign result[4]=exp[2]^exp[3]^exp[4]^exp[5];
  assign result[5]=exp[3]^exp[4]^exp[5]^exp[6];
  assign result[6]=exp[4]^exp[6];
endmodule

module ip_gf_2_poly_0x3_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6];
  assign result[1]=exp[0]^exp[1];
  assign result[2]=exp[0]^exp[1]^exp[2];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[3];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6];
endmodule

module ip_gf_2_poly_0x71_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[3];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4];
  assign result[2]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5];
  assign result[3]=exp[0]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6];
  assign result[4]=exp[0]^exp[2]^exp[4]^exp[5]^exp[6];
  assign result[5]=exp[2]^exp[5]^exp[6];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[6];
endmodule

module ip_gf_2_poly_0x41_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[0]^exp[1];
  assign result[1]=exp[1]^exp[2];
  assign result[2]=exp[2]^exp[3];
  assign result[3]=exp[3]^exp[4];
  assign result[4]=exp[4]^exp[5];
  assign result[5]=exp[0]^exp[5]^exp[6];
  assign result[6]=exp[0]^exp[6];
endmodule

module ip_gf_2_poly_0x27_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6];
  assign result[1]=exp[0]^exp[5]^exp[6];
  assign result[2]=exp[0]^exp[2]^exp[3]^exp[4];
  assign result[3]=exp[1]^exp[3]^exp[4]^exp[5];
  assign result[4]=exp[2]^exp[4]^exp[5]^exp[6];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[6];
endmodule

module ip_gf_2_poly_0x3f_crc7_rev(exp, result);
  input  [6:0] exp;
  output [6:0] result;
  assign result[0]=exp[1]^exp[6];
  assign result[1]=exp[1]^exp[2]^exp[6];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[3]^exp[6];
  assign result[3]=exp[0]^exp[2]^exp[3]^exp[4]^exp[6];
  assign result[4]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6];
  assign result[5]=exp[4]^exp[5];
  assign result[6]=exp[0]^exp[5]^exp[6];
endmodule

module ip_gf_2_poly_0x31_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[3]^exp[4];
  assign result[1]=exp[4]^exp[5];
  assign result[2]=exp[0]^exp[5]^exp[6];
  assign result[3]=exp[1]^exp[6]^exp[7];
  assign result[4]=exp[0]^exp[2]^exp[3]^exp[4]^exp[7];
  assign result[5]=exp[0]^exp[1]^exp[5];
  assign result[6]=exp[1]^exp[2]^exp[6];
  assign result[7]=exp[2]^exp[3]^exp[7];
endmodule

module ip_gf_2_poly_0x2f_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[1]^exp[4]^exp[7];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[7];
  assign result[2]=exp[0]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7];
  assign result[3]=exp[3]^exp[5]^exp[6];
  assign result[4]=exp[4]^exp[6]^exp[7];
  assign result[5]=exp[1]^exp[4]^exp[5];
  assign result[6]=exp[2]^exp[5]^exp[6];
  assign result[7]=exp[0]^exp[3]^exp[6]^exp[7];
endmodule

module ip_gf_2_poly_0x39_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[2]^exp[3]^exp[4]^exp[5];
  assign result[1]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6];
  assign result[2]=exp[1]^exp[4]^exp[5]^exp[6]^exp[7];
  assign result[3]=exp[3]^exp[4]^exp[6]^exp[7];
  assign result[4]=exp[0]^exp[2]^exp[3]^exp[7];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[5];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[3]^exp[6];
  assign result[7]=exp[1]^exp[2]^exp[3]^exp[4]^exp[7];
endmodule

module ip_gf_2_poly_0xd5_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[1]^exp[6];
  assign result[1]=exp[2]^exp[7];
  assign result[2]=exp[0]^exp[1]^exp[3]^exp[6];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7];
  assign result[4]=exp[2]^exp[3]^exp[5]^exp[6];
  assign result[5]=exp[0]^exp[3]^exp[4]^exp[6]^exp[7];
  assign result[6]=exp[0]^exp[4]^exp[5]^exp[6]^exp[7];
  assign result[7]=exp[0]^exp[5]^exp[7];
endmodule

module ip_gf_2_poly_0x65_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[3]^exp[4]^exp[6];
  assign result[1]=exp[0]^exp[4]^exp[5]^exp[7];
  assign result[2]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[6];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[7];
  assign result[6]=exp[1]^exp[2]^exp[4]^exp[6];
  assign result[7]=exp[2]^exp[3]^exp[5]^exp[7];
endmodule

module ip_gf_2_poly_0x87_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[0]^exp[2]^exp[4]^exp[5]^exp[7];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7];
  assign result[2]=exp[0]^exp[1]^exp[3];
  assign result[3]=exp[1]^exp[2]^exp[4];
  assign result[4]=exp[0]^exp[2]^exp[3]^exp[5];
  assign result[5]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[7];
  assign result[7]=exp[1]^exp[3]^exp[4]^exp[6]^exp[7];
endmodule

module ip_gf_2_poly_0x5f_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[3]^exp[7];
  assign result[1]=exp[3]^exp[4]^exp[7];
  assign result[2]=exp[3]^exp[4]^exp[5]^exp[7];
  assign result[3]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7];
  assign result[4]=exp[1]^exp[3]^exp[4]^exp[5]^exp[6];
  assign result[5]=exp[0]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7];
  assign result[6]=exp[1]^exp[5]^exp[6];
  assign result[7]=exp[2]^exp[6]^exp[7];
endmodule

module ip_gf_2_poly_0x63_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[0]^exp[4]^exp[5]^exp[6]^exp[7];
  assign result[1]=exp[0]^exp[1]^exp[4];
  assign result[2]=exp[1]^exp[2]^exp[5];
  assign result[3]=exp[0]^exp[2]^exp[3]^exp[6];
  assign result[4]=exp[0]^exp[1]^exp[3]^exp[4]^exp[7];
  assign result[5]=exp[1]^exp[2]^exp[6]^exp[7];
  assign result[6]=exp[2]^exp[3]^exp[4]^exp[5]^exp[6];
  assign result[7]=exp[3]^exp[4]^exp[5]^exp[6]^exp[7];
endmodule

module ip_gf_2_poly_0xcf_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[7];
  assign result[1]=exp[0]^exp[5]^exp[7];
  assign result[2]=exp[2]^exp[3]^exp[4]^exp[6]^exp[7];
  assign result[3]=exp[1]^exp[2]^exp[5];
  assign result[4]=exp[0]^exp[2]^exp[3]^exp[6];
  assign result[5]=exp[0]^exp[1]^exp[3]^exp[4]^exp[7];
  assign result[6]=exp[3]^exp[5]^exp[7];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[3]^exp[6]^exp[7];
endmodule

module ip_gf_2_poly_0x4d_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[6];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7];
  assign result[2]=exp[0]^exp[3]^exp[5]^exp[7];
  assign result[3]=exp[0]^exp[2]^exp[5];
  assign result[4]=exp[1]^exp[3]^exp[6];
  assign result[5]=exp[0]^exp[2]^exp[4]^exp[7];
  assign result[6]=exp[0]^exp[2]^exp[3]^exp[4]^exp[6];
  assign result[7]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[7];
endmodule

module ip_gf_2_poly_0x1d_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[0]^exp[1]^exp[5]^exp[6];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[6]^exp[7];
  assign result[2]=exp[2]^exp[3]^exp[5]^exp[6]^exp[7];
  assign result[3]=exp[1]^exp[3]^exp[4]^exp[5]^exp[7];
  assign result[4]=exp[1]^exp[2]^exp[4];
  assign result[5]=exp[2]^exp[3]^exp[5];
  assign result[6]=exp[3]^exp[4]^exp[6];
  assign result[7]=exp[0]^exp[4]^exp[5]^exp[7];
endmodule

module ip_gf_2_poly_0x8d_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[0]^exp[4]^exp[5]^exp[6];
  assign result[1]=exp[0]^exp[1]^exp[5]^exp[6]^exp[7];
  assign result[2]=exp[1]^exp[2]^exp[4]^exp[5]^exp[7];
  assign result[3]=exp[2]^exp[3]^exp[4];
  assign result[4]=exp[0]^exp[3]^exp[4]^exp[5];
  assign result[5]=exp[1]^exp[4]^exp[5]^exp[6];
  assign result[6]=exp[2]^exp[5]^exp[6]^exp[7];
  assign result[7]=exp[3]^exp[4]^exp[5]^exp[7];
endmodule

module ip_gf_2_poly_0x69_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[0]^exp[3]^exp[5];
  assign result[1]=exp[0]^exp[1]^exp[4]^exp[6];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[5]^exp[7];
  assign result[3]=exp[1]^exp[2]^exp[5]^exp[6];
  assign result[4]=exp[2]^exp[3]^exp[6]^exp[7];
  assign result[5]=exp[0]^exp[4]^exp[5]^exp[7];
  assign result[6]=exp[1]^exp[3]^exp[6];
  assign result[7]=exp[2]^exp[4]^exp[7];
endmodule

module ip_gf_2_poly_0xf5_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[1]^exp[3]^exp[6];
  assign result[1]=exp[0]^exp[2]^exp[4]^exp[7];
  assign result[2]=exp[5]^exp[6];
  assign result[3]=exp[6]^exp[7];
  assign result[4]=exp[1]^exp[3]^exp[6]^exp[7];
  assign result[5]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7];
  assign result[7]=exp[0]^exp[2]^exp[5]^exp[7];
endmodule

module ip_gf_2_poly_0xa9_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7];
  assign result[3]=exp[4]^exp[6];
  assign result[4]=exp[5]^exp[7];
  assign result[5]=exp[1]^exp[2]^exp[3]^exp[5]^exp[6];
  assign result[6]=exp[2]^exp[3]^exp[4]^exp[6]^exp[7];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7];
endmodule

module ip_gf_2_poly_0x2d_crc8_rev(exp, result);
  input  [7:0] exp;
  output [7:0] result;
  assign result[0]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[6];
  assign result[1]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7];
  assign result[3]=exp[0]^exp[2]^exp[4]^exp[6];
  assign result[4]=exp[1]^exp[3]^exp[5]^exp[7];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5];
  assign result[6]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6];
  assign result[7]=exp[0]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7];
endmodule

module ip_gf_2_poly_0x79_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[1]^exp[4]^exp[5]^exp[6];
  assign result[1]=exp[2]^exp[5]^exp[6]^exp[7];
  assign result[2]=exp[3]^exp[6]^exp[7]^exp[8];
  assign result[3]=exp[1]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[4]=exp[1]^exp[2]^exp[4]^exp[5]^exp[7]^exp[8];
  assign result[5]=exp[1]^exp[2]^exp[3]^exp[4]^exp[8];
  assign result[6]=exp[1]^exp[2]^exp[3]^exp[6];
  assign result[7]=exp[2]^exp[3]^exp[4]^exp[7];
  assign result[8]=exp[0]^exp[3]^exp[4]^exp[5]^exp[8];
endmodule

module ip_gf_2_poly_0x137_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[0]^exp[4]^exp[6]^exp[8];
  assign result[1]=exp[1]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[2]=exp[0]^exp[2]^exp[4]^exp[5]^exp[7];
  assign result[3]=exp[0]^exp[1]^exp[3]^exp[5]^exp[6]^exp[8];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[7]^exp[8];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6];
  assign result[6]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7];
  assign result[7]=exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8];
  assign result[8]=exp[3]^exp[5]^exp[7]^exp[8];
endmodule

module ip_gf_2_poly_0x10b_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[2]^exp[5]^exp[7]^exp[8];
  assign result[1]=exp[0]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7];
  assign result[2]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8];
  assign result[3]=exp[0]^exp[1]^exp[4];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[5];
  assign result[5]=exp[1]^exp[2]^exp[3]^exp[6];
  assign result[6]=exp[0]^exp[2]^exp[3]^exp[4]^exp[7];
  assign result[7]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[8];
  assign result[8]=exp[1]^exp[4]^exp[6]^exp[7]^exp[8];
endmodule

module ip_gf_2_poly_0x5f_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[0]^exp[1]^exp[4]^exp[8];
  assign result[1]=exp[2]^exp[4]^exp[5]^exp[8];
  assign result[2]=exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[4]=exp[2]^exp[3]^exp[4]^exp[6]^exp[7];
  assign result[5]=exp[3]^exp[4]^exp[5]^exp[7]^exp[8];
  assign result[6]=exp[1]^exp[5]^exp[6];
  assign result[7]=exp[2]^exp[6]^exp[7];
  assign result[8]=exp[0]^exp[3]^exp[7]^exp[8];
endmodule

module ip_gf_2_poly_0x95_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[3]^exp[7];
  assign result[1]=exp[1]^exp[2]^exp[3]^exp[4]^exp[8];
  assign result[2]=exp[1]^exp[4]^exp[5]^exp[7];
  assign result[3]=exp[0]^exp[2]^exp[5]^exp[6]^exp[8];
  assign result[4]=exp[0]^exp[2]^exp[6];
  assign result[5]=exp[0]^exp[1]^exp[3]^exp[7];
  assign result[6]=exp[1]^exp[2]^exp[4]^exp[8];
  assign result[7]=exp[0]^exp[1]^exp[5]^exp[7];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[6]^exp[8];
endmodule

module ip_gf_2_poly_0x1e3_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[1]=exp[1]^exp[3]^exp[5];
  assign result[2]=exp[0]^exp[2]^exp[4]^exp[6];
  assign result[3]=exp[0]^exp[1]^exp[3]^exp[5]^exp[7];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[4]^exp[6]^exp[8];
  assign result[5]=exp[3]^exp[6]^exp[8];
  assign result[6]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[8];
  assign result[7]=exp[1]^exp[3]^exp[8];
  assign result[8]=exp[0]^exp[1]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8];
endmodule

module ip_gf_2_poly_0x1b5_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[2]^exp[3]^exp[4]^exp[7];
  assign result[1]=exp[0]^exp[3]^exp[4]^exp[5]^exp[8];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7];
  assign result[3]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8];
  assign result[4]=exp[5]^exp[8];
  assign result[5]=exp[0]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7];
  assign result[6]=exp[1]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8];
  assign result[7]=exp[0]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[8]=exp[1]^exp[2]^exp[3]^exp[6]^exp[8];
endmodule

module ip_gf_2_poly_0x77_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[0]^exp[3]^exp[4]^exp[6]^exp[8];
  assign result[1]=exp[0]^exp[1]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[2]=exp[1]^exp[2]^exp[3]^exp[7];
  assign result[3]=exp[2]^exp[3]^exp[4]^exp[8];
  assign result[4]=exp[5]^exp[6]^exp[8];
  assign result[5]=exp[0]^exp[3]^exp[4]^exp[7]^exp[8];
  assign result[6]=exp[0]^exp[1]^exp[3]^exp[5]^exp[6];
  assign result[7]=exp[1]^exp[2]^exp[4]^exp[6]^exp[7];
  assign result[8]=exp[2]^exp[3]^exp[5]^exp[7]^exp[8];
endmodule

module ip_gf_2_poly_0x1cd_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[1]^exp[3]^exp[5]^exp[6]^exp[7];
  assign result[1]=exp[2]^exp[4]^exp[6]^exp[7]^exp[8];
  assign result[2]=exp[1]^exp[6]^exp[8];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[6];
  assign result[4]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7];
  assign result[5]=exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8];
  assign result[6]=exp[1]^exp[4]^exp[7]^exp[8];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[3]^exp[6]^exp[7]^exp[8];
  assign result[8]=exp[0]^exp[2]^exp[4]^exp[5]^exp[6]^exp[8];
endmodule

module ip_gf_2_poly_0xa5_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7];
  assign result[1]=exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[6];
  assign result[3]=exp[1]^exp[2]^exp[3]^exp[7];
  assign result[4]=exp[0]^exp[2]^exp[3]^exp[4]^exp[8];
  assign result[5]=exp[2]^exp[7];
  assign result[6]=exp[3]^exp[8];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[7];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[8];
endmodule

module ip_gf_2_poly_0x1b_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[3]^exp[7]^exp[8];
  assign result[1]=exp[0]^exp[4]^exp[7];
  assign result[2]=exp[0]^exp[1]^exp[5]^exp[8];
  assign result[3]=exp[0]^exp[3]^exp[6]^exp[7]^exp[8];
  assign result[4]=exp[2]^exp[3]^exp[4];
  assign result[5]=exp[3]^exp[4]^exp[5];
  assign result[6]=exp[0]^exp[4]^exp[5]^exp[6];
  assign result[7]=exp[0]^exp[1]^exp[5]^exp[6]^exp[7];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[6]^exp[7]^exp[8];
endmodule

module ip_gf_2_poly_0x13b_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[3]^exp[4]^exp[7]^exp[8];
  assign result[1]=exp[3]^exp[5]^exp[7];
  assign result[2]=exp[4]^exp[6]^exp[8];
  assign result[3]=exp[3]^exp[4]^exp[5]^exp[8];
  assign result[4]=exp[0]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[5]=exp[1]^exp[3]^exp[6];
  assign result[6]=exp[0]^exp[2]^exp[4]^exp[7];
  assign result[7]=exp[1]^exp[3]^exp[5]^exp[8];
  assign result[8]=exp[2]^exp[3]^exp[6]^exp[7]^exp[8];
endmodule

module ip_gf_2_poly_0x173_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[1]^exp[3]^exp[6]^exp[7]^exp[8];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8];
  assign result[4]=exp[0]^exp[2]^exp[4]^exp[5]^exp[8];
  assign result[5]=exp[5]^exp[7]^exp[8];
  assign result[6]=exp[0]^exp[1]^exp[3]^exp[7];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[4]^exp[8];
  assign result[8]=exp[0]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8];
endmodule

module ip_gf_2_poly_0x87_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[0]^exp[3]^exp[5]^exp[6]^exp[8];
  assign result[1]=exp[1]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8];
  assign result[2]=exp[0]^exp[2]^exp[3]^exp[4];
  assign result[3]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5];
  assign result[4]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6];
  assign result[5]=exp[2]^exp[3]^exp[5]^exp[6]^exp[7];
  assign result[6]=exp[0]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8];
  assign result[7]=exp[1]^exp[3]^exp[4]^exp[6]^exp[7];
  assign result[8]=exp[2]^exp[4]^exp[5]^exp[7]^exp[8];
endmodule

module ip_gf_2_poly_0x16d_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[2]=exp[0]^exp[8];
  assign result[3]=exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7];
  assign result[4]=exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[3]^exp[8];
  assign result[6]=exp[5]^exp[6]^exp[7];
  assign result[7]=exp[6]^exp[7]^exp[8];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8];
endmodule

module ip_gf_2_poly_0x11_crc9_rev(exp, result);
  input  [8:0] exp;
  output [8:0] result;
  assign result[0]=exp[0]^exp[1]^exp[5];
  assign result[1]=exp[1]^exp[2]^exp[6];
  assign result[2]=exp[2]^exp[3]^exp[7];
  assign result[3]=exp[0]^exp[3]^exp[4]^exp[8];
  assign result[4]=exp[0]^exp[4];
  assign result[5]=exp[1]^exp[5];
  assign result[6]=exp[2]^exp[6];
  assign result[7]=exp[3]^exp[7];
  assign result[8]=exp[0]^exp[4]^exp[8];
endmodule

module ip_gf_2_poly_0x11d_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[1]^exp[2]^exp[3]^exp[7]^exp[8];
  assign result[1]=exp[2]^exp[3]^exp[4]^exp[8]^exp[9];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9];
  assign result[3]=exp[5]^exp[6]^exp[7]^exp[9];
  assign result[4]=exp[1]^exp[2]^exp[3]^exp[6];
  assign result[5]=exp[0]^exp[2]^exp[3]^exp[4]^exp[7];
  assign result[6]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[8];
  assign result[7]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[9];
  assign result[8]=exp[0]^exp[1]^exp[5]^exp[6]^exp[8];
  assign result[9]=exp[0]^exp[1]^exp[2]^exp[6]^exp[7]^exp[9];
endmodule

module ip_gf_2_poly_0x173_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[1]^exp[2]^exp[4]^exp[7]^exp[8]^exp[9];
  assign result[1]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[7];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[8];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[9];
  assign result[4]=exp[0]^exp[3]^exp[6]^exp[9];
  assign result[5]=exp[0]^exp[2]^exp[8]^exp[9];
  assign result[6]=exp[2]^exp[3]^exp[4]^exp[7]^exp[8];
  assign result[7]=exp[0]^exp[3]^exp[4]^exp[5]^exp[8]^exp[9];
  assign result[8]=exp[0]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[9]=exp[0]^exp[1]^exp[3]^exp[6]^exp[7]^exp[8]^exp[9];
endmodule

module ip_gf_2_poly_0x233_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[2]^exp[7]^exp[8]^exp[9];
  assign result[1]=exp[2]^exp[3]^exp[7];
  assign result[2]=exp[0]^exp[3]^exp[4]^exp[8];
  assign result[3]=exp[1]^exp[4]^exp[5]^exp[9];
  assign result[4]=exp[5]^exp[6]^exp[7]^exp[8]^exp[9];
  assign result[5]=exp[2]^exp[6];
  assign result[6]=exp[3]^exp[7];
  assign result[7]=exp[0]^exp[4]^exp[8];
  assign result[8]=exp[0]^exp[1]^exp[5]^exp[9];
  assign result[9]=exp[1]^exp[6]^exp[7]^exp[8]^exp[9];
endmodule

module ip_gf_2_poly_0x24f_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[0]^exp[4]^exp[5]^exp[6]^exp[9];
  assign result[1]=exp[1]^exp[4]^exp[7]^exp[9];
  assign result[2]=exp[0]^exp[2]^exp[4]^exp[6]^exp[8]^exp[9];
  assign result[3]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6]^exp[7];
  assign result[4]=exp[1]^exp[2]^exp[4]^exp[5]^exp[7]^exp[8];
  assign result[5]=exp[2]^exp[3]^exp[5]^exp[6]^exp[8]^exp[9];
  assign result[6]=exp[0]^exp[3]^exp[5]^exp[7];
  assign result[7]=exp[1]^exp[4]^exp[6]^exp[8];
  assign result[8]=exp[2]^exp[5]^exp[7]^exp[9];
  assign result[9]=exp[3]^exp[4]^exp[5]^exp[8]^exp[9];
endmodule

module ip_gf_2_poly_0x37d_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8];
  assign result[1]=exp[0]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[9];
  assign result[2]=exp[2]^exp[6]^exp[8]^exp[9];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[8]^exp[9];
  assign result[4]=exp[4]^exp[6]^exp[7]^exp[8]^exp[9];
  assign result[5]=exp[1]^exp[2]^exp[3]^exp[4]^exp[9];
  assign result[6]=exp[0]^exp[1]^exp[7]^exp[8];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[8]^exp[9];
  assign result[8]=exp[4]^exp[5]^exp[7]^exp[8]^exp[9];
  assign result[9]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[9];
endmodule

module ip_gf_2_poly_0x27f_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[3]^exp[9];
  assign result[1]=exp[4]^exp[9];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[9];
  assign result[3]=exp[0]^exp[4]^exp[6]^exp[9];
  assign result[4]=exp[2]^exp[3]^exp[5]^exp[7]^exp[9];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[4]^exp[6]^exp[8]^exp[9];
  assign result[6]=exp[0]^exp[5]^exp[7];
  assign result[7]=exp[1]^exp[6]^exp[8];
  assign result[8]=exp[2]^exp[7]^exp[9];
  assign result[9]=exp[0]^exp[1]^exp[2]^exp[8]^exp[9];
endmodule

module ip_gf_2_poly_0x81_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[0]^exp[3];
  assign result[1]=exp[1]^exp[4];
  assign result[2]=exp[2]^exp[5];
  assign result[3]=exp[3]^exp[6];
  assign result[4]=exp[0]^exp[4]^exp[7];
  assign result[5]=exp[1]^exp[5]^exp[8];
  assign result[6]=exp[2]^exp[6]^exp[9];
  assign result[7]=exp[0]^exp[7];
  assign result[8]=exp[1]^exp[8];
  assign result[9]=exp[2]^exp[9];
endmodule

module ip_gf_2_poly_0x2df_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[2]^exp[3]^exp[5]^exp[9];
  assign result[1]=exp[2]^exp[4]^exp[5]^exp[6]^exp[9];
  assign result[2]=exp[2]^exp[6]^exp[7]^exp[9];
  assign result[3]=exp[0]^exp[2]^exp[5]^exp[7]^exp[8]^exp[9];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[8];
  assign result[5]=exp[1]^exp[2]^exp[3]^exp[6]^exp[7]^exp[9];
  assign result[6]=exp[0]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9];
  assign result[7]=exp[1]^exp[2]^exp[3]^exp[6]^exp[8];
  assign result[8]=exp[0]^exp[2]^exp[3]^exp[4]^exp[7]^exp[9];
  assign result[9]=exp[1]^exp[2]^exp[4]^exp[8]^exp[9];
endmodule

module ip_gf_2_poly_0x2d_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[0]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[1]=exp[1]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9];
  assign result[2]=exp[2]^exp[3]^exp[6]^exp[9];
  assign result[3]=exp[0]^exp[4]^exp[5]^exp[6]^exp[8];
  assign result[4]=exp[0]^exp[1]^exp[5]^exp[6]^exp[7]^exp[9];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5];
  assign result[6]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6];
  assign result[7]=exp[0]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7];
  assign result[8]=exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8];
  assign result[9]=exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9];
endmodule

module ip_gf_2_poly_0x18f_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[3]^exp[5]^exp[6]^exp[9];
  assign result[1]=exp[3]^exp[4]^exp[5]^exp[7]^exp[9];
  assign result[2]=exp[3]^exp[4]^exp[8]^exp[9];
  assign result[3]=exp[0]^exp[3]^exp[4]^exp[6];
  assign result[4]=exp[1]^exp[4]^exp[5]^exp[7];
  assign result[5]=exp[2]^exp[5]^exp[6]^exp[8];
  assign result[6]=exp[3]^exp[6]^exp[7]^exp[9];
  assign result[7]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9];
  assign result[8]=exp[1]^exp[3]^exp[4]^exp[7]^exp[8];
  assign result[9]=exp[2]^exp[4]^exp[5]^exp[8]^exp[9];
endmodule

module ip_gf_2_poly_0x289_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[0]^exp[3]^exp[4]^exp[7];
  assign result[1]=exp[1]^exp[4]^exp[5]^exp[8];
  assign result[2]=exp[0]^exp[2]^exp[5]^exp[6]^exp[9];
  assign result[3]=exp[1]^exp[4]^exp[6];
  assign result[4]=exp[0]^exp[2]^exp[5]^exp[7];
  assign result[5]=exp[0]^exp[1]^exp[3]^exp[6]^exp[8];
  assign result[6]=exp[1]^exp[2]^exp[4]^exp[7]^exp[9];
  assign result[7]=exp[0]^exp[2]^exp[4]^exp[5]^exp[7]^exp[8];
  assign result[8]=exp[1]^exp[3]^exp[5]^exp[6]^exp[8]^exp[9];
  assign result[9]=exp[2]^exp[3]^exp[6]^exp[9];
endmodule

module ip_gf_2_poly_0x225_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[0]^exp[2]^exp[4]^exp[5]^exp[6]^exp[8];
  assign result[1]=exp[1]^exp[3]^exp[5]^exp[6]^exp[7]^exp[9];
  assign result[2]=exp[0]^exp[5]^exp[7];
  assign result[3]=exp[1]^exp[6]^exp[8];
  assign result[4]=exp[2]^exp[7]^exp[9];
  assign result[5]=exp[2]^exp[3]^exp[4]^exp[5]^exp[6];
  assign result[6]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7];
  assign result[7]=exp[0]^exp[1]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9];
  assign result[9]=exp[1]^exp[3]^exp[4]^exp[5]^exp[7]^exp[9];
endmodule

module ip_gf_2_poly_0x393_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[5]^exp[7]^exp[8]^exp[9];
  assign result[1]=exp[0]^exp[5]^exp[6]^exp[7];
  assign result[2]=exp[0]^exp[1]^exp[6]^exp[7]^exp[8];
  assign result[3]=exp[1]^exp[2]^exp[7]^exp[8]^exp[9];
  assign result[4]=exp[0]^exp[2]^exp[3]^exp[5]^exp[7];
  assign result[5]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6]^exp[8];
  assign result[6]=exp[1]^exp[2]^exp[4]^exp[5]^exp[7]^exp[9];
  assign result[7]=exp[2]^exp[3]^exp[6]^exp[7]^exp[9];
  assign result[8]=exp[3]^exp[4]^exp[5]^exp[9];
  assign result[9]=exp[4]^exp[6]^exp[7]^exp[8]^exp[9];
endmodule

module ip_gf_2_poly_0x197_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[0]^exp[1]^exp[7]^exp[9];
  assign result[1]=exp[0]^exp[2]^exp[7]^exp[8]^exp[9];
  assign result[2]=exp[3]^exp[7]^exp[8];
  assign result[3]=exp[4]^exp[8]^exp[9];
  assign result[4]=exp[1]^exp[5]^exp[7];
  assign result[5]=exp[2]^exp[6]^exp[8];
  assign result[6]=exp[0]^exp[3]^exp[7]^exp[9];
  assign result[7]=exp[0]^exp[4]^exp[7]^exp[8]^exp[9];
  assign result[8]=exp[5]^exp[7]^exp[8];
  assign result[9]=exp[0]^exp[6]^exp[8]^exp[9];
endmodule

module ip_gf_2_poly_0x317_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[0]^exp[1]^exp[3]^exp[7]^exp[9];
  assign result[1]=exp[2]^exp[3]^exp[4]^exp[7]^exp[8]^exp[9];
  assign result[2]=exp[0]^exp[1]^exp[4]^exp[5]^exp[7]^exp[8];
  assign result[3]=exp[1]^exp[2]^exp[5]^exp[6]^exp[8]^exp[9];
  assign result[4]=exp[1]^exp[2]^exp[6];
  assign result[5]=exp[0]^exp[2]^exp[3]^exp[7];
  assign result[6]=exp[0]^exp[1]^exp[3]^exp[4]^exp[8];
  assign result[7]=exp[1]^exp[2]^exp[4]^exp[5]^exp[9];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[9];
  assign result[9]=exp[0]^exp[2]^exp[6]^exp[8]^exp[9];
endmodule

module ip_gf_2_poly_0x215_crc10_rev(exp, result);
  input  [9:0] exp;
  output [9:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[4]^exp[8];
  assign result[1]=exp[1]^exp[2]^exp[3]^exp[5]^exp[9];
  assign result[2]=exp[1]^exp[3]^exp[6]^exp[8];
  assign result[3]=exp[0]^exp[2]^exp[4]^exp[7]^exp[9];
  assign result[4]=exp[2]^exp[3]^exp[4]^exp[5];
  assign result[5]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6];
  assign result[6]=exp[0]^exp[1]^exp[4]^exp[5]^exp[6]^exp[7];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[8]=exp[1]^exp[2]^exp[3]^exp[6]^exp[7]^exp[8]^exp[9];
  assign result[9]=exp[0]^exp[1]^exp[3]^exp[7]^exp[9];
endmodule

module ip_gf_2_poly_0x265_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[0]^exp[1]^exp[3]^exp[6]^exp[7]^exp[9];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7]^exp[8]^exp[10];
  assign result[2]=exp[0]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[3]=exp[1]^exp[3]^exp[6]^exp[7]^exp[8]^exp[9];
  assign result[4]=exp[2]^exp[4]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[5]=exp[1]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[3]^exp[8];
  assign result[7]=exp[1]^exp[2]^exp[3]^exp[4]^exp[9];
  assign result[8]=exp[2]^exp[3]^exp[4]^exp[5]^exp[10];
  assign result[9]=exp[1]^exp[4]^exp[5]^exp[7]^exp[9];
  assign result[10]=exp[0]^exp[2]^exp[5]^exp[6]^exp[8]^exp[10];
endmodule

module ip_gf_2_poly_0x3af_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[0]^exp[2]^exp[7]^exp[10];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[7]^exp[8]^exp[10];
  assign result[2]=exp[0]^exp[1]^exp[3]^exp[4]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[3]=exp[0]^exp[1]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10];
  assign result[5]=exp[0]^exp[1]^exp[3]^exp[6]^exp[9];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7]^exp[10];
  assign result[7]=exp[0]^exp[1]^exp[3]^exp[5]^exp[7]^exp[8]^exp[10];
  assign result[8]=exp[1]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[9]=exp[0]^exp[5]^exp[8]^exp[9];
  assign result[10]=exp[1]^exp[6]^exp[9]^exp[10];
endmodule

module ip_gf_2_poly_0x307_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[10];
  assign result[1]=exp[0]^exp[3]^exp[6]^exp[7]^exp[9]^exp[10];
  assign result[2]=exp[0]^exp[1]^exp[3]^exp[5];
  assign result[3]=exp[1]^exp[2]^exp[4]^exp[6];
  assign result[4]=exp[0]^exp[2]^exp[3]^exp[5]^exp[7];
  assign result[5]=exp[1]^exp[3]^exp[4]^exp[6]^exp[8];
  assign result[6]=exp[2]^exp[4]^exp[5]^exp[7]^exp[9];
  assign result[7]=exp[0]^exp[3]^exp[5]^exp[6]^exp[8]^exp[10];
  assign result[8]=exp[0]^exp[1]^exp[3]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10];
  assign result[9]=exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[8]^exp[9];
  assign result[10]=exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[9]^exp[10];
endmodule

module ip_gf_2_poly_0x49b_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[1]^exp[2]^exp[3]^exp[5]^exp[9]^exp[10];
  assign result[1]=exp[1]^exp[4]^exp[5]^exp[6]^exp[9];
  assign result[2]=exp[2]^exp[5]^exp[6]^exp[7]^exp[10];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[4]=exp[0]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[5]=exp[1]^exp[6]^exp[7]^exp[8]^exp[9];
  assign result[6]=exp[2]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[5]^exp[8];
  assign result[8]=exp[1]^exp[2]^exp[3]^exp[6]^exp[9];
  assign result[9]=exp[2]^exp[3]^exp[4]^exp[7]^exp[10];
  assign result[10]=exp[0]^exp[1]^exp[2]^exp[4]^exp[8]^exp[9]^exp[10];
endmodule

module ip_gf_2_poly_0x175_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[0]^exp[2]^exp[6]^exp[9];
  assign result[1]=exp[1]^exp[3]^exp[7]^exp[10];
  assign result[2]=exp[0]^exp[4]^exp[6]^exp[8]^exp[9];
  assign result[3]=exp[0]^exp[1]^exp[5]^exp[7]^exp[9]^exp[10];
  assign result[4]=exp[0]^exp[1]^exp[8]^exp[9]^exp[10];
  assign result[5]=exp[0]^exp[1]^exp[6]^exp[10];
  assign result[6]=exp[0]^exp[1]^exp[6]^exp[7]^exp[9];
  assign result[7]=exp[1]^exp[2]^exp[7]^exp[8]^exp[10];
  assign result[8]=exp[3]^exp[6]^exp[8];
  assign result[9]=exp[0]^exp[4]^exp[7]^exp[9];
  assign result[10]=exp[1]^exp[5]^exp[8]^exp[10];
endmodule

module ip_gf_2_poly_0x5f5_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[1]^exp[2]^exp[4]^exp[6]^exp[9];
  assign result[1]=exp[2]^exp[3]^exp[5]^exp[7]^exp[10];
  assign result[2]=exp[1]^exp[2]^exp[3]^exp[8]^exp[9];
  assign result[3]=exp[0]^exp[2]^exp[3]^exp[4]^exp[9]^exp[10];
  assign result[4]=exp[2]^exp[3]^exp[5]^exp[6]^exp[9]^exp[10];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[3]^exp[7]^exp[9]^exp[10];
  assign result[6]=exp[0]^exp[3]^exp[6]^exp[8]^exp[9]^exp[10];
  assign result[7]=exp[2]^exp[6]^exp[7]^exp[10];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9];
  assign result[9]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[10]=exp[0]^exp[1]^exp[3]^exp[5]^exp[8]^exp[10];
endmodule

module ip_gf_2_poly_0x457_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[0]^exp[4]^exp[5]^exp[8]^exp[10];
  assign result[1]=exp[1]^exp[4]^exp[6]^exp[8]^exp[9]^exp[10];
  assign result[2]=exp[2]^exp[4]^exp[7]^exp[8]^exp[9];
  assign result[3]=exp[0]^exp[3]^exp[5]^exp[8]^exp[9]^exp[10];
  assign result[4]=exp[1]^exp[5]^exp[6]^exp[8]^exp[9];
  assign result[5]=exp[0]^exp[2]^exp[6]^exp[7]^exp[9]^exp[10];
  assign result[6]=exp[1]^exp[3]^exp[4]^exp[5]^exp[7];
  assign result[7]=exp[0]^exp[2]^exp[4]^exp[5]^exp[6]^exp[8];
  assign result[8]=exp[1]^exp[3]^exp[5]^exp[6]^exp[7]^exp[9];
  assign result[9]=exp[2]^exp[4]^exp[6]^exp[7]^exp[8]^exp[10];
  assign result[10]=exp[3]^exp[4]^exp[7]^exp[9]^exp[10];
endmodule

module ip_gf_2_poly_0x29d_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[1]^exp[8]^exp[9];
  assign result[1]=exp[2]^exp[9]^exp[10];
  assign result[2]=exp[1]^exp[3]^exp[8]^exp[9]^exp[10];
  assign result[3]=exp[1]^exp[2]^exp[4]^exp[8]^exp[10];
  assign result[4]=exp[1]^exp[2]^exp[3]^exp[5]^exp[8];
  assign result[5]=exp[2]^exp[3]^exp[4]^exp[6]^exp[9];
  assign result[6]=exp[0]^exp[3]^exp[4]^exp[5]^exp[7]^exp[10];
  assign result[7]=exp[4]^exp[5]^exp[6]^exp[9];
  assign result[8]=exp[0]^exp[5]^exp[6]^exp[7]^exp[10];
  assign result[9]=exp[6]^exp[7]^exp[9];
  assign result[10]=exp[0]^exp[7]^exp[8]^exp[10];
endmodule

module ip_gf_2_poly_0x79b_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[0]^exp[5]^exp[9]^exp[10];
  assign result[1]=exp[1]^exp[5]^exp[6]^exp[9];
  assign result[2]=exp[2]^exp[6]^exp[7]^exp[10];
  assign result[3]=exp[0]^exp[3]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[4]=exp[0]^exp[1]^exp[4]^exp[5]^exp[6]^exp[8];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[9];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[3]^exp[6]^exp[7]^exp[8]^exp[10];
  assign result[7]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[10];
  assign result[8]=exp[2]^exp[3]^exp[4]^exp[6]^exp[8]^exp[10];
  assign result[9]=exp[3]^exp[4]^exp[7]^exp[10];
  assign result[10]=exp[4]^exp[8]^exp[9]^exp[10];
endmodule

module ip_gf_2_poly_0x2fb_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[2]^exp[4]^exp[6]^exp[9]^exp[10];
  assign result[1]=exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9];
  assign result[2]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[5]^exp[7]^exp[8]^exp[10];
  assign result[4]=exp[0]^exp[1]^exp[3]^exp[4]^exp[8]^exp[10];
  assign result[5]=exp[0]^exp[1]^exp[5]^exp[6]^exp[10];
  assign result[6]=exp[1]^exp[4]^exp[7]^exp[9]^exp[10];
  assign result[7]=exp[4]^exp[5]^exp[6]^exp[8]^exp[9];
  assign result[8]=exp[5]^exp[6]^exp[7]^exp[9]^exp[10];
  assign result[9]=exp[0]^exp[2]^exp[4]^exp[7]^exp[8]^exp[9];
  assign result[10]=exp[1]^exp[3]^exp[5]^exp[8]^exp[9]^exp[10];
endmodule

module ip_gf_2_poly_0x5e7_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[0]^exp[4]^exp[6]^exp[7]^exp[8]^exp[10];
  assign result[1]=exp[1]^exp[4]^exp[5]^exp[6]^exp[9]^exp[10];
  assign result[2]=exp[0]^exp[2]^exp[4]^exp[5]^exp[8];
  assign result[3]=exp[0]^exp[1]^exp[3]^exp[5]^exp[6]^exp[9];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[4]^exp[6]^exp[7]^exp[10];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[10];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[8]^exp[10];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[3]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[8]=exp[1]^exp[2]^exp[3]^exp[6]^exp[7]^exp[9];
  assign result[9]=exp[2]^exp[3]^exp[4]^exp[7]^exp[8]^exp[10];
  assign result[10]=exp[3]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10];
endmodule

module ip_gf_2_poly_0x2b3_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[1]^exp[2]^exp[3]^exp[4]^exp[8]^exp[9]^exp[10];
  assign result[1]=exp[1]^exp[5]^exp[8];
  assign result[2]=exp[0]^exp[2]^exp[6]^exp[9];
  assign result[3]=exp[1]^exp[3]^exp[7]^exp[10];
  assign result[4]=exp[1]^exp[3]^exp[9]^exp[10];
  assign result[5]=exp[1]^exp[3]^exp[8]^exp[9];
  assign result[6]=exp[2]^exp[4]^exp[9]^exp[10];
  assign result[7]=exp[1]^exp[2]^exp[4]^exp[5]^exp[8]^exp[9];
  assign result[8]=exp[2]^exp[3]^exp[5]^exp[6]^exp[9]^exp[10];
  assign result[9]=exp[0]^exp[1]^exp[2]^exp[6]^exp[7]^exp[8]^exp[9];
  assign result[10]=exp[0]^exp[1]^exp[2]^exp[3]^exp[7]^exp[8]^exp[9]^exp[10];
endmodule

module ip_gf_2_poly_0x3c9_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[0]^exp[3]^exp[4]^exp[8];
  assign result[1]=exp[0]^exp[1]^exp[4]^exp[5]^exp[9];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[10];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[4]^exp[6]^exp[7]^exp[8];
  assign result[4]=exp[1]^exp[2]^exp[3]^exp[5]^exp[7]^exp[8]^exp[9];
  assign result[5]=exp[2]^exp[3]^exp[4]^exp[6]^exp[8]^exp[9]^exp[10];
  assign result[6]=exp[0]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[7]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6]^exp[9]^exp[10];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[7]^exp[8]^exp[10];
  assign result[9]=exp[1]^exp[2]^exp[6]^exp[9];
  assign result[10]=exp[2]^exp[3]^exp[7]^exp[10];
endmodule

module ip_gf_2_poly_0x61d_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[0]^exp[4]^exp[8]^exp[9];
  assign result[1]=exp[1]^exp[5]^exp[9]^exp[10];
  assign result[2]=exp[2]^exp[4]^exp[6]^exp[8]^exp[9]^exp[10];
  assign result[3]=exp[0]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[10];
  assign result[4]=exp[1]^exp[5]^exp[6];
  assign result[5]=exp[0]^exp[2]^exp[6]^exp[7];
  assign result[6]=exp[0]^exp[1]^exp[3]^exp[7]^exp[8];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[4]^exp[8]^exp[9];
  assign result[8]=exp[1]^exp[2]^exp[3]^exp[5]^exp[9]^exp[10];
  assign result[9]=exp[2]^exp[3]^exp[6]^exp[8]^exp[9]^exp[10];
  assign result[10]=exp[3]^exp[7]^exp[8]^exp[10];
endmodule

module ip_gf_2_poly_0x67b_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[0]^exp[1]^exp[6]^exp[9]^exp[10];
  assign result[1]=exp[2]^exp[6]^exp[7]^exp[9];
  assign result[2]=exp[3]^exp[7]^exp[8]^exp[10];
  assign result[3]=exp[1]^exp[4]^exp[6]^exp[8]^exp[10];
  assign result[4]=exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[10];
  assign result[5]=exp[1]^exp[2]^exp[3]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[6]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[8];
  assign result[7]=exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[9];
  assign result[8]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[10];
  assign result[9]=exp[0]^exp[4]^exp[5]^exp[7]^exp[10];
  assign result[10]=exp[0]^exp[5]^exp[8]^exp[9]^exp[10];
endmodule

module ip_gf_2_poly_0x4e9_crc11_rev(exp, result);
  input  [10:0] exp;
  output [10:0] result;
  assign result[0]=exp[2]^exp[4]^exp[6]^exp[8];
  assign result[1]=exp[0]^exp[3]^exp[5]^exp[7]^exp[9];
  assign result[2]=exp[1]^exp[4]^exp[6]^exp[8]^exp[10];
  assign result[3]=exp[0]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9];
  assign result[4]=exp[1]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[5]=exp[4]^exp[7]^exp[9]^exp[10];
  assign result[6]=exp[0]^exp[2]^exp[4]^exp[5]^exp[6]^exp[10];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[9];
  assign result[9]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10];
  assign result[10]=exp[1]^exp[3]^exp[5]^exp[7]^exp[10];
endmodule

module ip_gf_2_poly_0x683_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[1]=exp[2]^exp[3]^exp[5]^exp[6];
  assign result[2]=exp[0]^exp[3]^exp[4]^exp[6]^exp[7];
  assign result[3]=exp[1]^exp[4]^exp[5]^exp[7]^exp[8];
  assign result[4]=exp[0]^exp[2]^exp[5]^exp[6]^exp[8]^exp[9];
  assign result[5]=exp[1]^exp[3]^exp[6]^exp[7]^exp[9]^exp[10];
  assign result[6]=exp[2]^exp[4]^exp[7]^exp[8]^exp[10]^exp[11];
  assign result[7]=exp[0]^exp[1]^exp[4]^exp[5]^exp[6]^exp[7]^exp[10];
  assign result[8]=exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8]^exp[11];
  assign result[9]=exp[1]^exp[2]^exp[4]^exp[10]^exp[11];
  assign result[10]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[11]=exp[0]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11];
endmodule

module ip_gf_2_poly_0x80b_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[0]^exp[3]^exp[4]^exp[5]^exp[8]^exp[10]^exp[11];
  assign result[1]=exp[1]^exp[3]^exp[6]^exp[8]^exp[9]^exp[10];
  assign result[2]=exp[0]^exp[2]^exp[4]^exp[7]^exp[9]^exp[10]^exp[11];
  assign result[3]=exp[0]^exp[1]^exp[4];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[5];
  assign result[5]=exp[1]^exp[2]^exp[3]^exp[6];
  assign result[6]=exp[0]^exp[2]^exp[3]^exp[4]^exp[7];
  assign result[7]=exp[1]^exp[3]^exp[4]^exp[5]^exp[8];
  assign result[8]=exp[2]^exp[4]^exp[5]^exp[6]^exp[9];
  assign result[9]=exp[0]^exp[3]^exp[5]^exp[6]^exp[7]^exp[10];
  assign result[10]=exp[1]^exp[4]^exp[6]^exp[7]^exp[8]^exp[11];
  assign result[11]=exp[2]^exp[3]^exp[4]^exp[7]^exp[9]^exp[10]^exp[11];
endmodule

module ip_gf_2_poly_0x807_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[8]^exp[9]^exp[11];
  assign result[1]=exp[1]^exp[4]^exp[5]^exp[7]^exp[8]^exp[10]^exp[11];
  assign result[2]=exp[0]^exp[1]^exp[3];
  assign result[3]=exp[1]^exp[2]^exp[4];
  assign result[4]=exp[0]^exp[2]^exp[3]^exp[5];
  assign result[5]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6];
  assign result[6]=exp[1]^exp[2]^exp[4]^exp[5]^exp[7];
  assign result[7]=exp[0]^exp[2]^exp[3]^exp[5]^exp[6]^exp[8];
  assign result[8]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6]^exp[7]^exp[9];
  assign result[9]=exp[1]^exp[2]^exp[4]^exp[5]^exp[7]^exp[8]^exp[10];
  assign result[10]=exp[2]^exp[3]^exp[5]^exp[6]^exp[8]^exp[9]^exp[11];
  assign result[11]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[7]^exp[8]^exp[10]^exp[11];
endmodule

module ip_gf_2_poly_0x6eb_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[0]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[9]^exp[10];
  assign result[2]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[10]^exp[11];
  assign result[3]=exp[0]^exp[3]^exp[4]^exp[6]^exp[8]^exp[10];
  assign result[4]=exp[1]^exp[4]^exp[5]^exp[7]^exp[9]^exp[11];
  assign result[5]=exp[0]^exp[7]^exp[11];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[10]^exp[11];
  assign result[7]=exp[1]^exp[3]^exp[5]^exp[10];
  assign result[8]=exp[0]^exp[2]^exp[4]^exp[6]^exp[11];
  assign result[9]=exp[1]^exp[2]^exp[3]^exp[6]^exp[8]^exp[10]^exp[11];
  assign result[10]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10];
  assign result[11]=exp[1]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10]^exp[11];
endmodule

module ip_gf_2_poly_0xc9f_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[3]^exp[5]^exp[6]^exp[7]^exp[11];
  assign result[1]=exp[0]^exp[3]^exp[4]^exp[5]^exp[8]^exp[11];
  assign result[2]=exp[0]^exp[1]^exp[3]^exp[4]^exp[7]^exp[9]^exp[11];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[4]^exp[6]^exp[8]^exp[9];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[7]^exp[9]^exp[10];
  assign result[6]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[8]^exp[10]^exp[11];
  assign result[7]=exp[2]^exp[4]^exp[6]^exp[9];
  assign result[8]=exp[0]^exp[3]^exp[5]^exp[7]^exp[10];
  assign result[9]=exp[0]^exp[1]^exp[4]^exp[6]^exp[8]^exp[11];
  assign result[10]=exp[1]^exp[2]^exp[3]^exp[6]^exp[9]^exp[11];
  assign result[11]=exp[2]^exp[4]^exp[5]^exp[6]^exp[10]^exp[11];
endmodule

module ip_gf_2_poly_0xa1b_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[3]^exp[4]^exp[5]^exp[6]^exp[10]^exp[11];
  assign result[1]=exp[0]^exp[3]^exp[7]^exp[10];
  assign result[2]=exp[0]^exp[1]^exp[4]^exp[8]^exp[11];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[9]^exp[10]^exp[11];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[6]^exp[7];
  assign result[5]=exp[1]^exp[2]^exp[3]^exp[7]^exp[8];
  assign result[6]=exp[0]^exp[2]^exp[3]^exp[4]^exp[8]^exp[9];
  assign result[7]=exp[1]^exp[3]^exp[4]^exp[5]^exp[9]^exp[10];
  assign result[8]=exp[2]^exp[4]^exp[5]^exp[6]^exp[10]^exp[11];
  assign result[9]=exp[0]^exp[4]^exp[7]^exp[10];
  assign result[10]=exp[1]^exp[5]^exp[8]^exp[11];
  assign result[11]=exp[2]^exp[3]^exp[4]^exp[5]^exp[9]^exp[10]^exp[11];
endmodule

module ip_gf_2_poly_0xd43_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[1]=exp[0]^exp[3]^exp[6]^exp[7];
  assign result[2]=exp[1]^exp[4]^exp[7]^exp[8];
  assign result[3]=exp[0]^exp[2]^exp[5]^exp[8]^exp[9];
  assign result[4]=exp[0]^exp[1]^exp[3]^exp[6]^exp[9]^exp[10];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7]^exp[10]^exp[11];
  assign result[6]=exp[1]^exp[2]^exp[4]^exp[7]^exp[9]^exp[10];
  assign result[7]=exp[0]^exp[2]^exp[3]^exp[5]^exp[8]^exp[10]^exp[11];
  assign result[8]=exp[1]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10];
  assign result[9]=exp[0]^exp[2]^exp[6]^exp[7]^exp[8]^exp[9]^exp[11];
  assign result[10]=exp[1]^exp[4]^exp[5]^exp[11];
  assign result[11]=exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11];
endmodule

module ip_gf_2_poly_0x45d_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[0]^exp[2]^exp[3]^exp[5]^exp[6]^exp[9]^exp[10];
  assign result[1]=exp[1]^exp[3]^exp[4]^exp[6]^exp[7]^exp[10]^exp[11];
  assign result[2]=exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[3]=exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[11];
  assign result[4]=exp[2]^exp[4]^exp[6]^exp[7]^exp[8]^exp[10];
  assign result[5]=exp[0]^exp[3]^exp[5]^exp[7]^exp[8]^exp[9]^exp[11];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[8];
  assign result[7]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[9];
  assign result[8]=exp[0]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[10];
  assign result[9]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[11];
  assign result[10]=exp[0]^exp[1]^exp[3]^exp[4]^exp[7]^exp[8]^exp[10];
  assign result[11]=exp[1]^exp[2]^exp[4]^exp[5]^exp[8]^exp[9]^exp[11];
endmodule

module ip_gf_2_poly_0x7b_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[0]^exp[1]^exp[3]^exp[7]^exp[10]^exp[11];
  assign result[1]=exp[2]^exp[3]^exp[4]^exp[7]^exp[8]^exp[10];
  assign result[2]=exp[0]^exp[3]^exp[4]^exp[5]^exp[8]^exp[9]^exp[11];
  assign result[3]=exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9]^exp[11];
  assign result[4]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[11];
  assign result[5]=exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[9]^exp[10]^exp[11];
  assign result[6]=exp[1]^exp[4]^exp[5]^exp[6];
  assign result[7]=exp[2]^exp[5]^exp[6]^exp[7];
  assign result[8]=exp[3]^exp[6]^exp[7]^exp[8];
  assign result[9]=exp[0]^exp[4]^exp[7]^exp[8]^exp[9];
  assign result[10]=exp[1]^exp[5]^exp[8]^exp[9]^exp[10];
  assign result[11]=exp[0]^exp[2]^exp[6]^exp[9]^exp[10]^exp[11];
endmodule

module ip_gf_2_poly_0x371_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[0]^exp[2]^exp[3]^exp[6]^exp[7]^exp[8];
  assign result[1]=exp[0]^exp[1]^exp[3]^exp[4]^exp[7]^exp[8]^exp[9];
  assign result[2]=exp[1]^exp[2]^exp[4]^exp[5]^exp[8]^exp[9]^exp[10];
  assign result[3]=exp[0]^exp[2]^exp[3]^exp[5]^exp[6]^exp[9]^exp[10]^exp[11];
  assign result[4]=exp[1]^exp[2]^exp[4]^exp[8]^exp[10]^exp[11];
  assign result[5]=exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[11];
  assign result[6]=exp[0]^exp[2]^exp[3]^exp[9]^exp[10];
  assign result[7]=exp[0]^exp[1]^exp[3]^exp[4]^exp[10]^exp[11];
  assign result[8]=exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[11];
  assign result[9]=exp[0]^exp[3]^exp[4]^exp[5]^exp[9];
  assign result[10]=exp[0]^exp[1]^exp[4]^exp[5]^exp[6]^exp[10];
  assign result[11]=exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[11];
endmodule

module ip_gf_2_poly_0x5c5_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[1]^exp[2]^exp[5]^exp[8]^exp[10];
  assign result[1]=exp[2]^exp[3]^exp[6]^exp[9]^exp[11];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[9];
  assign result[4]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10];
  assign result[5]=exp[0]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11];
  assign result[6]=exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[9]^exp[10]^exp[11];
  assign result[7]=exp[1]^exp[2]^exp[3]^exp[4]^exp[7]^exp[11];
  assign result[8]=exp[0]^exp[1]^exp[3]^exp[4]^exp[10];
  assign result[9]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[11];
  assign result[10]=exp[0]^exp[3]^exp[6]^exp[8]^exp[10];
  assign result[11]=exp[0]^exp[1]^exp[4]^exp[7]^exp[9]^exp[11];
endmodule

module ip_gf_2_poly_0x7bf_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[0]^exp[1]^exp[4]^exp[6]^exp[11];
  assign result[1]=exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[11];
  assign result[2]=exp[1]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[11];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[5]^exp[8]^exp[9]^exp[11];
  assign result[4]=exp[0]^exp[2]^exp[3]^exp[4]^exp[9]^exp[10]^exp[11];
  assign result[5]=exp[0]^exp[3]^exp[5]^exp[6]^exp[10];
  assign result[6]=exp[0]^exp[1]^exp[4]^exp[6]^exp[7]^exp[11];
  assign result[7]=exp[0]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[11];
  assign result[8]=exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9]^exp[11];
  assign result[9]=exp[0]^exp[1]^exp[5]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[10]=exp[2]^exp[4]^exp[9]^exp[10];
  assign result[11]=exp[0]^exp[3]^exp[5]^exp[10]^exp[11];
endmodule

module ip_gf_2_poly_0x3a9_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9];
  assign result[1]=exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10];
  assign result[2]=exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[11];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[6]^exp[8]^exp[10];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[3]^exp[7]^exp[9]^exp[11];
  assign result[5]=exp[0]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[6]=exp[0]^exp[1]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[7]=exp[0]^exp[4]^exp[6]^exp[8]^exp[10]^exp[11];
  assign result[8]=exp[2]^exp[4]^exp[6]^exp[11];
  assign result[9]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[9];
  assign result[10]=exp[0]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[10];
  assign result[11]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[11];
endmodule

module ip_gf_2_poly_0x107_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[9]^exp[11];
  assign result[1]=exp[0]^exp[3]^exp[7]^exp[8]^exp[10]^exp[11];
  assign result[2]=exp[0]^exp[1]^exp[3]^exp[5]^exp[6];
  assign result[3]=exp[1]^exp[2]^exp[4]^exp[6]^exp[7];
  assign result[4]=exp[2]^exp[3]^exp[5]^exp[7]^exp[8];
  assign result[5]=exp[0]^exp[3]^exp[4]^exp[6]^exp[8]^exp[9];
  assign result[6]=exp[0]^exp[1]^exp[4]^exp[5]^exp[7]^exp[9]^exp[10];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[8]^exp[10]^exp[11];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[7]^exp[8];
  assign result[9]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[8]^exp[9];
  assign result[10]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[9]^exp[10];
  assign result[11]=exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[10]^exp[11];
endmodule

module ip_gf_2_poly_0x935_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[1]^exp[2]^exp[3]^exp[6]^exp[7]^exp[10];
  assign result[1]=exp[2]^exp[3]^exp[4]^exp[7]^exp[8]^exp[11];
  assign result[2]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[3]=exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[4]=exp[1]^exp[2]^exp[4]^exp[8]^exp[9]^exp[11];
  assign result[5]=exp[0]^exp[1]^exp[5]^exp[6]^exp[7]^exp[9];
  assign result[6]=exp[1]^exp[2]^exp[6]^exp[7]^exp[8]^exp[10];
  assign result[7]=exp[0]^exp[2]^exp[3]^exp[7]^exp[8]^exp[9]^exp[11];
  assign result[8]=exp[0]^exp[2]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9];
  assign result[9]=exp[1]^exp[3]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[10]=exp[2]^exp[4]^exp[6]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[11]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[9]^exp[11];
endmodule

module ip_gf_2_poly_0xfbd_crc12_rev(exp, result);
  input  [11:0] exp;
  output [11:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[7]^exp[9]^exp[10];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[8]^exp[10]^exp[11];
  assign result[2]=exp[5]^exp[6]^exp[7]^exp[10]^exp[11];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[4]=exp[5]^exp[11];
  assign result[5]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[9]^exp[10];
  assign result[6]=exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[10]^exp[11];
  assign result[7]=exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11];
  assign result[8]=exp[1]^exp[4]^exp[6]^exp[8]^exp[10]^exp[11];
  assign result[9]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[10]^exp[11];
  assign result[10]=exp[3]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10]^exp[11];
  assign result[11]=exp[0]^exp[1]^exp[2]^exp[3]^exp[6]^exp[8]^exp[9]^exp[11];
endmodule

module ip_gf_2_poly_0x16f_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9]^exp[12];
  assign result[1]=exp[3]^exp[4]^exp[8]^exp[9]^exp[10]^exp[12];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[6]^exp[7]^exp[10]^exp[11]^exp[12];
  assign result[3]=exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[9]^exp[11];
  assign result[4]=exp[4]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10]^exp[12];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[4]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[6]=exp[3]^exp[4]^exp[6]^exp[7]^exp[10]^exp[11];
  assign result[7]=exp[4]^exp[5]^exp[7]^exp[8]^exp[11]^exp[12];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7]^exp[8];
  assign result[9]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[8]^exp[9];
  assign result[10]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[9]^exp[10];
  assign result[11]=exp[0]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[10]^exp[11];
  assign result[12]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[11]^exp[12];
endmodule

module ip_gf_2_poly_0x54b_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9]^exp[11]^exp[12];
  assign result[1]=exp[0]^exp[1]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[2]=exp[1]^exp[2]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[3]=exp[0]^exp[1]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10];
  assign result[4]=exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11];
  assign result[5]=exp[0]^exp[2]^exp[3]^exp[6]^exp[7]^exp[8]^exp[9]^exp[11]^exp[12];
  assign result[6]=exp[0]^exp[2]^exp[5]^exp[6]^exp[8]^exp[10]^exp[11];
  assign result[7]=exp[0]^exp[1]^exp[3]^exp[6]^exp[7]^exp[9]^exp[11]^exp[12];
  assign result[8]=exp[3]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[9]=exp[4]^exp[6]^exp[7]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[10]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[8]^exp[9]^exp[10];
  assign result[11]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[9]^exp[10]^exp[11];
  assign result[12]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[10]^exp[11]^exp[12];
endmodule

module ip_gf_2_poly_0x1213_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[1]^exp[4]^exp[5]^exp[6]^exp[8]^exp[10]^exp[11]^exp[12];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[2]=exp[1]^exp[2]^exp[3]^exp[5]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[3]=exp[0]^exp[2]^exp[3]^exp[4]^exp[6]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[4]=exp[3]^exp[6]^exp[7]^exp[8];
  assign result[5]=exp[4]^exp[7]^exp[8]^exp[9];
  assign result[6]=exp[0]^exp[5]^exp[8]^exp[9]^exp[10];
  assign result[7]=exp[1]^exp[6]^exp[9]^exp[10]^exp[11];
  assign result[8]=exp[0]^exp[2]^exp[7]^exp[10]^exp[11]^exp[12];
  assign result[9]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6]^exp[10];
  assign result[10]=exp[1]^exp[4]^exp[5]^exp[6]^exp[7]^exp[11];
  assign result[11]=exp[0]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8]^exp[12];
  assign result[12]=exp[0]^exp[3]^exp[4]^exp[5]^exp[7]^exp[9]^exp[10]^exp[11]^exp[12];
endmodule

module ip_gf_2_poly_0x55_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[0]^exp[3]^exp[5]^exp[11];
  assign result[1]=exp[1]^exp[4]^exp[6]^exp[12];
  assign result[2]=exp[0]^exp[2]^exp[3]^exp[7]^exp[11];
  assign result[3]=exp[0]^exp[1]^exp[3]^exp[4]^exp[8]^exp[12];
  assign result[4]=exp[1]^exp[2]^exp[3]^exp[4]^exp[9]^exp[11];
  assign result[5]=exp[2]^exp[3]^exp[4]^exp[5]^exp[10]^exp[12];
  assign result[6]=exp[4]^exp[6];
  assign result[7]=exp[5]^exp[7];
  assign result[8]=exp[0]^exp[6]^exp[8];
  assign result[9]=exp[1]^exp[7]^exp[9];
  assign result[10]=exp[0]^exp[2]^exp[8]^exp[10];
  assign result[11]=exp[1]^exp[3]^exp[9]^exp[11];
  assign result[12]=exp[2]^exp[4]^exp[10]^exp[12];
endmodule

module ip_gf_2_poly_0x1477_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[1]^exp[3]^exp[7]^exp[8]^exp[10]^exp[12];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[7]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[2]=exp[0]^exp[2]^exp[4]^exp[5]^exp[7]^exp[11];
  assign result[3]=exp[1]^exp[3]^exp[5]^exp[6]^exp[8]^exp[12];
  assign result[4]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[8]^exp[9]^exp[10]^exp[12];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[8]^exp[9]^exp[11]^exp[12];
  assign result[6]=exp[0]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9];
  assign result[7]=exp[0]^exp[1]^exp[3]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[8]=exp[1]^exp[2]^exp[4]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[9]=exp[2]^exp[3]^exp[5]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[10]=exp[0]^exp[1]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[11];
  assign result[11]=exp[0]^exp[1]^exp[2]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10]^exp[12];
  assign result[12]=exp[0]^exp[2]^exp[6]^exp[7]^exp[9]^exp[11]^exp[12];
endmodule

module ip_gf_2_poly_0x15d5_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[0]^exp[2]^exp[6]^exp[11];
  assign result[1]=exp[1]^exp[3]^exp[7]^exp[12];
  assign result[2]=exp[0]^exp[4]^exp[6]^exp[8]^exp[11];
  assign result[3]=exp[1]^exp[5]^exp[7]^exp[9]^exp[12];
  assign result[4]=exp[8]^exp[10]^exp[11];
  assign result[5]=exp[0]^exp[9]^exp[11]^exp[12];
  assign result[6]=exp[1]^exp[2]^exp[6]^exp[10]^exp[11]^exp[12];
  assign result[7]=exp[0]^exp[3]^exp[6]^exp[7]^exp[12];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[4]^exp[6]^exp[7]^exp[8]^exp[11];
  assign result[9]=exp[1]^exp[2]^exp[3]^exp[5]^exp[7]^exp[8]^exp[9]^exp[12];
  assign result[10]=exp[0]^exp[3]^exp[4]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[11]=exp[0]^exp[1]^exp[4]^exp[5]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[12]=exp[1]^exp[5]^exp[10]^exp[12];
endmodule

module ip_gf_2_poly_0x1907_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[0]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10]^exp[12];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[8]^exp[9]^exp[11]^exp[12];
  assign result[2]=exp[0]^exp[1]^exp[3]^exp[6]^exp[7];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7]^exp[8];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[8]^exp[9];
  assign result[5]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[9]^exp[10];
  assign result[6]=exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[10]^exp[11];
  assign result[7]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[11]^exp[12];
  assign result[8]=exp[1]^exp[2]^exp[10];
  assign result[9]=exp[2]^exp[3]^exp[11];
  assign result[10]=exp[0]^exp[3]^exp[4]^exp[12];
  assign result[11]=exp[0]^exp[1]^exp[2]^exp[6]^exp[7]^exp[9]^exp[10]^exp[12];
  assign result[12]=exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[9]^exp[11]^exp[12];
endmodule

module ip_gf_2_poly_0x5d7_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[7]^exp[10]^exp[12];
  assign result[1]=exp[0]^exp[2]^exp[3]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11]^exp[12];
  assign result[2]=exp[5]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[3]=exp[6]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[4]=exp[1]^exp[3]^exp[4]^exp[5]^exp[11];
  assign result[5]=exp[0]^exp[2]^exp[4]^exp[5]^exp[6]^exp[12];
  assign result[6]=exp[0]^exp[4]^exp[6]^exp[10]^exp[12];
  assign result[7]=exp[3]^exp[4]^exp[10]^exp[11]^exp[12];
  assign result[8]=exp[0]^exp[1]^exp[3]^exp[7]^exp[10]^exp[11];
  assign result[9]=exp[1]^exp[2]^exp[4]^exp[8]^exp[11]^exp[12];
  assign result[10]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7]^exp[9]^exp[10];
  assign result[11]=exp[1]^exp[2]^exp[3]^exp[5]^exp[8]^exp[10]^exp[11];
  assign result[12]=exp[0]^exp[2]^exp[3]^exp[4]^exp[6]^exp[9]^exp[11]^exp[12];
endmodule

module ip_gf_2_poly_0xce7_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10]^exp[12];
  assign result[1]=exp[1]^exp[4]^exp[5]^exp[7]^exp[8]^exp[11]^exp[12];
  assign result[2]=exp[1]^exp[3]^exp[10];
  assign result[3]=exp[2]^exp[4]^exp[11];
  assign result[4]=exp[0]^exp[3]^exp[5]^exp[12];
  assign result[5]=exp[0]^exp[2]^exp[3]^exp[4]^exp[5]^exp[8]^exp[9]^exp[10]^exp[12];
  assign result[6]=exp[2]^exp[4]^exp[8]^exp[11]^exp[12];
  assign result[7]=exp[1]^exp[2]^exp[6]^exp[8]^exp[10];
  assign result[8]=exp[0]^exp[2]^exp[3]^exp[7]^exp[9]^exp[11];
  assign result[9]=exp[1]^exp[3]^exp[4]^exp[8]^exp[10]^exp[12];
  assign result[10]=exp[1]^exp[3]^exp[4]^exp[6]^exp[8]^exp[10]^exp[11]^exp[12];
  assign result[11]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11];
  assign result[12]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9]^exp[11]^exp[12];
endmodule

module ip_gf_2_poly_0x38d_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[0]^exp[1]^exp[3]^exp[5]^exp[9]^exp[10]^exp[11];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[4]^exp[6]^exp[10]^exp[11]^exp[12];
  assign result[2]=exp[0]^exp[2]^exp[7]^exp[9]^exp[10]^exp[12];
  assign result[3]=exp[5]^exp[8]^exp[9];
  assign result[4]=exp[0]^exp[6]^exp[9]^exp[10];
  assign result[5]=exp[0]^exp[1]^exp[7]^exp[10]^exp[11];
  assign result[6]=exp[1]^exp[2]^exp[8]^exp[11]^exp[12];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[5]^exp[10]^exp[11]^exp[12];
  assign result[8]=exp[2]^exp[5]^exp[6]^exp[9]^exp[10]^exp[12];
  assign result[9]=exp[1]^exp[5]^exp[6]^exp[7]^exp[9];
  assign result[10]=exp[0]^exp[2]^exp[6]^exp[7]^exp[8]^exp[10];
  assign result[11]=exp[1]^exp[3]^exp[7]^exp[8]^exp[9]^exp[11];
  assign result[12]=exp[0]^exp[2]^exp[4]^exp[8]^exp[9]^exp[10]^exp[12];
endmodule

module ip_gf_2_poly_0x4c1_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[0]^exp[1]^exp[3]^exp[6]^exp[7];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7]^exp[8];
  assign result[2]=exp[1]^exp[2]^exp[3]^exp[5]^exp[8]^exp[9];
  assign result[3]=exp[2]^exp[3]^exp[4]^exp[6]^exp[9]^exp[10];
  assign result[4]=exp[3]^exp[4]^exp[5]^exp[7]^exp[10]^exp[11];
  assign result[5]=exp[0]^exp[4]^exp[5]^exp[6]^exp[8]^exp[11]^exp[12];
  assign result[6]=exp[3]^exp[5]^exp[9]^exp[12];
  assign result[7]=exp[1]^exp[3]^exp[4]^exp[7]^exp[10];
  assign result[8]=exp[2]^exp[4]^exp[5]^exp[8]^exp[11];
  assign result[9]=exp[0]^exp[3]^exp[5]^exp[6]^exp[9]^exp[12];
  assign result[10]=exp[0]^exp[3]^exp[4]^exp[10];
  assign result[11]=exp[1]^exp[4]^exp[5]^exp[11];
  assign result[12]=exp[0]^exp[2]^exp[5]^exp[6]^exp[12];
endmodule

module ip_gf_2_poly_0x1d1b_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[0]^exp[2]^exp[6]^exp[7]^exp[11]^exp[12];
  assign result[1]=exp[1]^exp[2]^exp[3]^exp[6]^exp[8]^exp[11];
  assign result[2]=exp[0]^exp[2]^exp[3]^exp[4]^exp[7]^exp[9]^exp[12];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11]^exp[12];
  assign result[4]=exp[1]^exp[3]^exp[4]^exp[5]^exp[8]^exp[9];
  assign result[5]=exp[2]^exp[4]^exp[5]^exp[6]^exp[9]^exp[10];
  assign result[6]=exp[0]^exp[3]^exp[5]^exp[6]^exp[7]^exp[10]^exp[11];
  assign result[7]=exp[0]^exp[1]^exp[4]^exp[6]^exp[7]^exp[8]^exp[11]^exp[12];
  assign result[8]=exp[0]^exp[1]^exp[5]^exp[6]^exp[8]^exp[9]^exp[11];
  assign result[9]=exp[0]^exp[1]^exp[2]^exp[6]^exp[7]^exp[9]^exp[10]^exp[12];
  assign result[10]=exp[0]^exp[1]^exp[3]^exp[6]^exp[8]^exp[10]^exp[12];
  assign result[11]=exp[0]^exp[1]^exp[4]^exp[6]^exp[9]^exp[12];
  assign result[12]=exp[1]^exp[5]^exp[6]^exp[10]^exp[11]^exp[12];
endmodule

module ip_gf_2_poly_0xf4d_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[1]^exp[3]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10]^exp[11];
  assign result[1]=exp[0]^exp[2]^exp[4]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11]^exp[12];
  assign result[2]=exp[0]^exp[6]^exp[8]^exp[10]^exp[12];
  assign result[3]=exp[0]^exp[3]^exp[5]^exp[6]^exp[10];
  assign result[4]=exp[1]^exp[4]^exp[6]^exp[7]^exp[11];
  assign result[5]=exp[2]^exp[5]^exp[7]^exp[8]^exp[12];
  assign result[6]=exp[0]^exp[1]^exp[5]^exp[7]^exp[8]^exp[10]^exp[11];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[6]^exp[8]^exp[9]^exp[11]^exp[12];
  assign result[8]=exp[0]^exp[2]^exp[5]^exp[6]^exp[11]^exp[12];
  assign result[9]=exp[0]^exp[5]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[10]=exp[3]^exp[5]^exp[7]^exp[9]^exp[12];
  assign result[11]=exp[1]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9]^exp[11];
  assign result[12]=exp[0]^exp[2]^exp[4]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10]^exp[12];
endmodule

module ip_gf_2_poly_0x729_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[1]^exp[2]^exp[5]^exp[7]^exp[8]^exp[10];
  assign result[1]=exp[0]^exp[2]^exp[3]^exp[6]^exp[8]^exp[9]^exp[11];
  assign result[2]=exp[0]^exp[1]^exp[3]^exp[4]^exp[7]^exp[9]^exp[10]^exp[12];
  assign result[3]=exp[4]^exp[7]^exp[11];
  assign result[4]=exp[5]^exp[8]^exp[12];
  assign result[5]=exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[6]=exp[2]^exp[3]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[7]=exp[3]^exp[4]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7]^exp[9]^exp[11]^exp[12];
  assign result[9]=exp[0]^exp[3]^exp[7]^exp[12];
  assign result[10]=exp[2]^exp[4]^exp[5]^exp[7]^exp[10];
  assign result[11]=exp[0]^exp[3]^exp[5]^exp[6]^exp[8]^exp[11];
  assign result[12]=exp[0]^exp[1]^exp[4]^exp[6]^exp[7]^exp[9]^exp[12];
endmodule

module ip_gf_2_poly_0x6b1_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[1]^exp[4]^exp[5]^exp[6]^exp[8]^exp[9];
  assign result[1]=exp[2]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10];
  assign result[2]=exp[3]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11];
  assign result[3]=exp[0]^exp[4]^exp[7]^exp[8]^exp[9]^exp[11]^exp[12];
  assign result[4]=exp[4]^exp[6]^exp[10]^exp[12];
  assign result[5]=exp[0]^exp[1]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[11];
  assign result[6]=exp[1]^exp[2]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10]^exp[12];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[10]^exp[11];
  assign result[8]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[11]^exp[12];
  assign result[9]=exp[1]^exp[2]^exp[3]^exp[7]^exp[8]^exp[9]^exp[12];
  assign result[10]=exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[10];
  assign result[11]=exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[11];
  assign result[12]=exp[0]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[12];
endmodule

module ip_gf_2_poly_0x1f49_crc13_rev(exp, result);
  input  [12:0] exp;
  output [12:0] result;
  assign result[0]=exp[0]^exp[2]^exp[3]^exp[5]^exp[10];
  assign result[1]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6]^exp[11];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[7]^exp[12];
  assign result[3]=exp[0]^exp[1]^exp[6]^exp[8]^exp[10];
  assign result[4]=exp[1]^exp[2]^exp[7]^exp[9]^exp[11];
  assign result[5]=exp[2]^exp[3]^exp[8]^exp[10]^exp[12];
  assign result[6]=exp[0]^exp[2]^exp[4]^exp[5]^exp[9]^exp[10]^exp[11];
  assign result[7]=exp[0]^exp[1]^exp[3]^exp[5]^exp[6]^exp[10]^exp[11]^exp[12];
  assign result[8]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[10]^exp[11]^exp[12];
  assign result[9]=exp[1]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11]^exp[12];
  assign result[10]=exp[3]^exp[4]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[11]=exp[0]^exp[2]^exp[3]^exp[4]^exp[8]^exp[9]^exp[11]^exp[12];
  assign result[12]=exp[1]^exp[2]^exp[4]^exp[9]^exp[12];
endmodule

module ip_gf_2_poly_0x2ce5_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[2]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10]^exp[12];
  assign result[1]=exp[0]^exp[3]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11]^exp[13];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[8]^exp[10]^exp[11];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[9]^exp[11]^exp[12];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[10]^exp[12]^exp[13];
  assign result[5]=exp[1]^exp[3]^exp[4]^exp[6]^exp[8]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[6]=exp[4]^exp[6]^exp[10]^exp[11]^exp[13];
  assign result[7]=exp[2]^exp[6]^exp[9]^exp[10]^exp[11];
  assign result[8]=exp[0]^exp[3]^exp[7]^exp[10]^exp[11]^exp[12];
  assign result[9]=exp[1]^exp[4]^exp[8]^exp[11]^exp[12]^exp[13];
  assign result[10]=exp[6]^exp[7]^exp[10]^exp[13];
  assign result[11]=exp[0]^exp[2]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[12]=exp[0]^exp[1]^exp[3]^exp[6]^exp[7]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[13]=exp[1]^exp[4]^exp[5]^exp[6]^exp[8]^exp[9]^exp[11]^exp[13];
endmodule

module ip_gf_2_poly_0x117d_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[11]^exp[12];
  assign result[1]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10]^exp[12]^exp[13];
  assign result[2]=exp[1]^exp[5]^exp[7]^exp[10]^exp[12]^exp[13];
  assign result[3]=exp[0]^exp[1]^exp[3]^exp[4]^exp[7]^exp[9]^exp[12]^exp[13];
  assign result[4]=exp[3]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[5]=exp[1]^exp[2]^exp[3]^exp[9]^exp[10]^exp[13];
  assign result[6]=exp[0]^exp[1]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[12];
  assign result[7]=exp[1]^exp[2]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[13];
  assign result[8]=exp[1]^exp[4]^exp[6]^exp[7]^exp[10];
  assign result[9]=exp[0]^exp[2]^exp[5]^exp[7]^exp[8]^exp[11];
  assign result[10]=exp[1]^exp[3]^exp[6]^exp[8]^exp[9]^exp[12];
  assign result[11]=exp[2]^exp[4]^exp[7]^exp[9]^exp[10]^exp[13];
  assign result[12]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10]^exp[12];
  assign result[13]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11]^exp[13];
endmodule

module ip_gf_2_poly_0xd31_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[1]^exp[2]^exp[3]^exp[9]^exp[10];
  assign result[1]=exp[0]^exp[2]^exp[3]^exp[4]^exp[10]^exp[11];
  assign result[2]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[11]^exp[12];
  assign result[3]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[12]^exp[13];
  assign result[4]=exp[1]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10]^exp[13];
  assign result[5]=exp[1]^exp[3]^exp[6]^exp[7]^exp[8]^exp[9]^exp[11];
  assign result[6]=exp[0]^exp[2]^exp[4]^exp[7]^exp[8]^exp[9]^exp[10]^exp[12];
  assign result[7]=exp[1]^exp[3]^exp[5]^exp[8]^exp[9]^exp[10]^exp[11]^exp[13];
  assign result[8]=exp[1]^exp[3]^exp[4]^exp[6]^exp[11]^exp[12];
  assign result[9]=exp[2]^exp[4]^exp[5]^exp[7]^exp[12]^exp[13];
  assign result[10]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10]^exp[13];
  assign result[11]=exp[0]^exp[6]^exp[7]^exp[11];
  assign result[12]=exp[0]^exp[1]^exp[7]^exp[8]^exp[12];
  assign result[13]=exp[0]^exp[1]^exp[2]^exp[8]^exp[9]^exp[13];
endmodule

module ip_gf_2_poly_0x53_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[0]^exp[1]^exp[3]^exp[4]^exp[7]^exp[8]^exp[9]^exp[11]^exp[12]^exp[13];
  assign result[1]=exp[2]^exp[3]^exp[5]^exp[7]^exp[10]^exp[11];
  assign result[2]=exp[3]^exp[4]^exp[6]^exp[8]^exp[11]^exp[12];
  assign result[3]=exp[0]^exp[4]^exp[5]^exp[7]^exp[9]^exp[12]^exp[13];
  assign result[4]=exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[5]=exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[6]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[6];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7];
  assign result[8]=exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8];
  assign result[9]=exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9];
  assign result[10]=exp[0]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[11]=exp[0]^exp[1]^exp[4]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[12]=exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[13]=exp[0]^exp[2]^exp[3]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11]^exp[12]^exp[13];
endmodule

module ip_gf_2_poly_0x3c93_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[9]^exp[11]^exp[12]^exp[13];
  assign result[1]=exp[1]^exp[2]^exp[3]^exp[7]^exp[9]^exp[10]^exp[11];
  assign result[2]=exp[2]^exp[3]^exp[4]^exp[8]^exp[10]^exp[11]^exp[12];
  assign result[3]=exp[3]^exp[4]^exp[5]^exp[9]^exp[11]^exp[12]^exp[13];
  assign result[4]=exp[0]^exp[1]^exp[3]^exp[9]^exp[10]^exp[11];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[4]^exp[10]^exp[11]^exp[12];
  assign result[6]=exp[1]^exp[2]^exp[3]^exp[5]^exp[11]^exp[12]^exp[13];
  assign result[7]=exp[1]^exp[2]^exp[5]^exp[9]^exp[11];
  assign result[8]=exp[2]^exp[3]^exp[6]^exp[10]^exp[12];
  assign result[9]=exp[3]^exp[4]^exp[7]^exp[11]^exp[13];
  assign result[10]=exp[0]^exp[1]^exp[3]^exp[6]^exp[8]^exp[9]^exp[11]^exp[13];
  assign result[11]=exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[10]^exp[11]^exp[13];
  assign result[12]=exp[0]^exp[1]^exp[5]^exp[7]^exp[8]^exp[9]^exp[13];
  assign result[13]=exp[0]^exp[2]^exp[3]^exp[4]^exp[5]^exp[8]^exp[10]^exp[11]^exp[12]^exp[13];
endmodule

module ip_gf_2_poly_0x2a6d_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[1]=exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[2]=exp[2]^exp[3]^exp[6]^exp[8]^exp[13];
  assign result[3]=exp[0]^exp[2]^exp[5]^exp[8]^exp[10]^exp[11]^exp[12];
  assign result[4]=exp[0]^exp[1]^exp[3]^exp[6]^exp[9]^exp[11]^exp[12]^exp[13];
  assign result[5]=exp[0]^exp[1]^exp[3]^exp[5]^exp[8]^exp[9]^exp[11]^exp[13];
  assign result[6]=exp[1]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8]^exp[11];
  assign result[7]=exp[0]^exp[2]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[12];
  assign result[8]=exp[1]^exp[3]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10]^exp[13];
  assign result[9]=exp[0]^exp[3]^exp[5]^exp[6]^exp[7]^exp[12];
  assign result[10]=exp[1]^exp[4]^exp[6]^exp[7]^exp[8]^exp[13];
  assign result[11]=exp[3]^exp[4]^exp[10]^exp[11]^exp[12];
  assign result[12]=exp[0]^exp[4]^exp[5]^exp[11]^exp[12]^exp[13];
  assign result[13]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[13];
endmodule

module ip_gf_2_poly_0x3a1b_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[0]^exp[5]^exp[6]^exp[7]^exp[8]^exp[12]^exp[13];
  assign result[1]=exp[0]^exp[1]^exp[5]^exp[9]^exp[12];
  assign result[2]=exp[1]^exp[2]^exp[6]^exp[10]^exp[13];
  assign result[3]=exp[2]^exp[3]^exp[5]^exp[6]^exp[8]^exp[11]^exp[12]^exp[13];
  assign result[4]=exp[0]^exp[3]^exp[4]^exp[5]^exp[8]^exp[9];
  assign result[5]=exp[0]^exp[1]^exp[4]^exp[5]^exp[6]^exp[9]^exp[10];
  assign result[6]=exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[10]^exp[11];
  assign result[7]=exp[0]^exp[2]^exp[3]^exp[6]^exp[7]^exp[8]^exp[11]^exp[12];
  assign result[8]=exp[1]^exp[3]^exp[4]^exp[7]^exp[8]^exp[9]^exp[12]^exp[13];
  assign result[9]=exp[0]^exp[2]^exp[4]^exp[6]^exp[7]^exp[9]^exp[10]^exp[12];
  assign result[10]=exp[1]^exp[3]^exp[5]^exp[7]^exp[8]^exp[10]^exp[11]^exp[13];
  assign result[11]=exp[2]^exp[4]^exp[5]^exp[7]^exp[9]^exp[11]^exp[13];
  assign result[12]=exp[3]^exp[7]^exp[10]^exp[13];
  assign result[13]=exp[4]^exp[5]^exp[6]^exp[7]^exp[11]^exp[12]^exp[13];
endmodule

module ip_gf_2_poly_0x147b_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[1]^exp[3]^exp[4]^exp[5]^exp[9]^exp[12]^exp[13];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[6]^exp[9]^exp[10]^exp[12];
  assign result[2]=exp[1]^exp[2]^exp[3]^exp[4]^exp[7]^exp[10]^exp[11]^exp[13];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[8]^exp[9]^exp[11]^exp[13];
  assign result[4]=exp[0]^exp[2]^exp[4]^exp[5]^exp[10]^exp[13];
  assign result[5]=exp[0]^exp[4]^exp[6]^exp[9]^exp[11]^exp[12]^exp[13];
  assign result[6]=exp[0]^exp[3]^exp[4]^exp[7]^exp[9]^exp[10];
  assign result[7]=exp[1]^exp[4]^exp[5]^exp[8]^exp[10]^exp[11];
  assign result[8]=exp[0]^exp[2]^exp[5]^exp[6]^exp[9]^exp[11]^exp[12];
  assign result[9]=exp[0]^exp[1]^exp[3]^exp[6]^exp[7]^exp[10]^exp[12]^exp[13];
  assign result[10]=exp[0]^exp[2]^exp[3]^exp[5]^exp[7]^exp[8]^exp[9]^exp[11]^exp[12];
  assign result[11]=exp[1]^exp[3]^exp[4]^exp[6]^exp[8]^exp[9]^exp[10]^exp[12]^exp[13];
  assign result[12]=exp[1]^exp[2]^exp[3]^exp[7]^exp[10]^exp[11]^exp[12];
  assign result[13]=exp[0]^exp[2]^exp[3]^exp[4]^exp[8]^exp[11]^exp[12]^exp[13];
endmodule

module ip_gf_2_poly_0x1615_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[0]^exp[1]^exp[4]^exp[5]^exp[6]^exp[8]^exp[12];
  assign result[1]=exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[9]^exp[13];
  assign result[2]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[10]^exp[12];
  assign result[3]=exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[11]^exp[13];
  assign result[4]=exp[0]^exp[1]^exp[3]^exp[7]^exp[8]^exp[9];
  assign result[5]=exp[1]^exp[2]^exp[4]^exp[8]^exp[9]^exp[10];
  assign result[6]=exp[0]^exp[2]^exp[3]^exp[5]^exp[9]^exp[10]^exp[11];
  assign result[7]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6]^exp[10]^exp[11]^exp[12];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[7]^exp[11]^exp[12]^exp[13];
  assign result[9]=exp[2]^exp[3]^exp[4]^exp[13];
  assign result[10]=exp[0]^exp[1]^exp[3]^exp[6]^exp[8]^exp[12];
  assign result[11]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7]^exp[9]^exp[13];
  assign result[12]=exp[2]^exp[3]^exp[4]^exp[6]^exp[10]^exp[12];
  assign result[13]=exp[0]^exp[3]^exp[4]^exp[5]^exp[7]^exp[11]^exp[13];
endmodule

module ip_gf_2_poly_0x1a1f_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[8]^exp[9]^exp[13];
  assign result[1]=exp[0]^exp[1]^exp[6]^exp[8]^exp[10]^exp[13];
  assign result[2]=exp[0]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[11]^exp[13];
  assign result[3]=exp[0]^exp[2]^exp[3]^exp[6]^exp[12]^exp[13];
  assign result[4]=exp[2]^exp[5]^exp[7]^exp[8]^exp[9];
  assign result[5]=exp[3]^exp[6]^exp[8]^exp[9]^exp[10];
  assign result[6]=exp[0]^exp[4]^exp[7]^exp[9]^exp[10]^exp[11];
  assign result[7]=exp[0]^exp[1]^exp[5]^exp[8]^exp[10]^exp[11]^exp[12];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[6]^exp[9]^exp[11]^exp[12]^exp[13];
  assign result[9]=exp[0]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10]^exp[12];
  assign result[10]=exp[0]^exp[1]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10]^exp[11]^exp[13];
  assign result[11]=exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[12]=exp[0]^exp[1]^exp[2]^exp[3]^exp[6]^exp[7]^exp[11]^exp[12];
  assign result[13]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[7]^exp[8]^exp[12]^exp[13];
endmodule

module ip_gf_2_poly_0x2139_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[0]^exp[1]^exp[5]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[1]=exp[1]^exp[2]^exp[6]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[2]=exp[2]^exp[3]^exp[7]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[3]=exp[1]^exp[3]^exp[4]^exp[5]^exp[9]^exp[10]^exp[12]^exp[13];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[4]^exp[6]^exp[8]^exp[9]^exp[13];
  assign result[5]=exp[2]^exp[3]^exp[7]^exp[8]^exp[11];
  assign result[6]=exp[0]^exp[3]^exp[4]^exp[8]^exp[9]^exp[12];
  assign result[7]=exp[0]^exp[1]^exp[4]^exp[5]^exp[9]^exp[10]^exp[13];
  assign result[8]=exp[0]^exp[2]^exp[6]^exp[8]^exp[9];
  assign result[9]=exp[0]^exp[1]^exp[3]^exp[7]^exp[9]^exp[10];
  assign result[10]=exp[1]^exp[2]^exp[4]^exp[8]^exp[10]^exp[11];
  assign result[11]=exp[2]^exp[3]^exp[5]^exp[9]^exp[11]^exp[12];
  assign result[12]=exp[0]^exp[3]^exp[4]^exp[6]^exp[10]^exp[12]^exp[13];
  assign result[13]=exp[0]^exp[4]^exp[7]^exp[8]^exp[9]^exp[10]^exp[13];
endmodule

module ip_gf_2_poly_0x35d1_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7]^exp[8]^exp[10];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[8]^exp[9]^exp[11];
  assign result[2]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[9]^exp[10]^exp[12];
  assign result[3]=exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[10]^exp[11]^exp[13];
  assign result[4]=exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[10]^exp[11]^exp[12];
  assign result[5]=exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[11]^exp[12]^exp[13];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[9]^exp[10]^exp[12]^exp[13];
  assign result[7]=exp[3]^exp[6]^exp[7]^exp[8]^exp[11]^exp[13];
  assign result[8]=exp[1]^exp[2]^exp[9]^exp[10]^exp[12];
  assign result[9]=exp[2]^exp[3]^exp[10]^exp[11]^exp[13];
  assign result[10]=exp[1]^exp[2]^exp[3]^exp[7]^exp[8]^exp[10]^exp[11]^exp[12];
  assign result[11]=exp[2]^exp[3]^exp[4]^exp[8]^exp[9]^exp[11]^exp[12]^exp[13];
  assign result[12]=exp[1]^exp[2]^exp[3]^exp[5]^exp[7]^exp[8]^exp[9]^exp[12]^exp[13];
  assign result[13]=exp[0]^exp[1]^exp[3]^exp[6]^exp[7]^exp[9]^exp[13];
endmodule

module ip_gf_2_poly_0xf9f_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[13];
  assign result[1]=exp[1]^exp[5]^exp[6]^exp[10]^exp[13];
  assign result[2]=exp[1]^exp[3]^exp[4]^exp[8]^exp[9]^exp[11]^exp[13];
  assign result[3]=exp[0]^exp[1]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10]^exp[12]^exp[13];
  assign result[4]=exp[3]^exp[11];
  assign result[5]=exp[0]^exp[4]^exp[12];
  assign result[6]=exp[0]^exp[1]^exp[5]^exp[13];
  assign result[7]=exp[0]^exp[3]^exp[4]^exp[7]^exp[8]^exp[9]^exp[13];
  assign result[8]=exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[10]^exp[13];
  assign result[9]=exp[1]^exp[2]^exp[9]^exp[11]^exp[13];
  assign result[10]=exp[1]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[12]^exp[13];
  assign result[11]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[10]^exp[11];
  assign result[12]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[11]^exp[12];
  assign result[13]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8]^exp[12]^exp[13];
endmodule

module ip_gf_2_poly_0x5f_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[9]^exp[13];
  assign result[1]=exp[1]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10]^exp[13];
  assign result[2]=exp[0]^exp[1]^exp[3]^exp[4]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[13];
  assign result[3]=exp[3]^exp[5]^exp[6]^exp[8]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[4]=exp[0]^exp[1]^exp[2]^exp[3]^exp[7]^exp[11]^exp[12];
  assign result[5]=exp[1]^exp[2]^exp[3]^exp[4]^exp[8]^exp[12]^exp[13];
  assign result[6]=exp[1]^exp[5]^exp[6];
  assign result[7]=exp[2]^exp[6]^exp[7];
  assign result[8]=exp[0]^exp[3]^exp[7]^exp[8];
  assign result[9]=exp[1]^exp[4]^exp[8]^exp[9];
  assign result[10]=exp[0]^exp[2]^exp[5]^exp[9]^exp[10];
  assign result[11]=exp[0]^exp[1]^exp[3]^exp[6]^exp[10]^exp[11];
  assign result[12]=exp[0]^exp[1]^exp[2]^exp[4]^exp[7]^exp[11]^exp[12];
  assign result[13]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[8]^exp[12]^exp[13];
endmodule

module ip_gf_2_poly_0xaf9_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[1]^exp[3]^exp[6]^exp[7]^exp[9]^exp[10]^exp[11];
  assign result[1]=exp[0]^exp[2]^exp[4]^exp[7]^exp[8]^exp[10]^exp[11]^exp[12];
  assign result[2]=exp[1]^exp[3]^exp[5]^exp[8]^exp[9]^exp[11]^exp[12]^exp[13];
  assign result[3]=exp[1]^exp[2]^exp[3]^exp[4]^exp[7]^exp[11]^exp[12]^exp[13];
  assign result[4]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[5]^exp[8]^exp[12]^exp[13];
  assign result[6]=exp[2]^exp[7]^exp[10]^exp[11]^exp[13];
  assign result[7]=exp[0]^exp[1]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[12];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[13];
  assign result[9]=exp[2]^exp[6]^exp[7]^exp[8]^exp[12];
  assign result[10]=exp[0]^exp[3]^exp[7]^exp[8]^exp[9]^exp[13];
  assign result[11]=exp[0]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[11];
  assign result[12]=exp[1]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9]^exp[12];
  assign result[13]=exp[0]^exp[2]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10]^exp[13];
endmodule

module ip_gf_2_poly_0x2c57_crc14_rev(exp, result);
  input  [13:0] exp;
  output [13:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[3]^exp[7]^exp[8]^exp[11]^exp[13];
  assign result[1]=exp[0]^exp[4]^exp[7]^exp[9]^exp[11]^exp[12]^exp[13];
  assign result[2]=exp[0]^exp[2]^exp[3]^exp[5]^exp[7]^exp[10]^exp[11]^exp[12];
  assign result[3]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6]^exp[8]^exp[11]^exp[12]^exp[13];
  assign result[4]=exp[3]^exp[4]^exp[5]^exp[8]^exp[9]^exp[11]^exp[12];
  assign result[5]=exp[4]^exp[5]^exp[6]^exp[9]^exp[10]^exp[12]^exp[13];
  assign result[6]=exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[8]^exp[10];
  assign result[7]=exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[9]^exp[11];
  assign result[8]=exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[10]^exp[12];
  assign result[9]=exp[4]^exp[5]^exp[6]^exp[8]^exp[9]^exp[11]^exp[13];
  assign result[10]=exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[11]=exp[1]^exp[4]^exp[6]^exp[8]^exp[9]^exp[10]^exp[12];
  assign result[12]=exp[2]^exp[5]^exp[7]^exp[9]^exp[10]^exp[11]^exp[13];
  assign result[13]=exp[0]^exp[1]^exp[2]^exp[6]^exp[7]^exp[10]^exp[12]^exp[13];
endmodule

module ip_gf_2_poly_0x1227_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[0]^exp[3]^exp[4]^exp[9]^exp[10]^exp[11]^exp[12]^exp[14];
  assign result[1]=exp[0]^exp[1]^exp[3]^exp[5]^exp[9]^exp[13]^exp[14];
  assign result[2]=exp[1]^exp[2]^exp[3]^exp[6]^exp[9]^exp[11]^exp[12];
  assign result[3]=exp[2]^exp[3]^exp[4]^exp[7]^exp[10]^exp[12]^exp[13];
  assign result[4]=exp[0]^exp[3]^exp[4]^exp[5]^exp[8]^exp[11]^exp[13]^exp[14];
  assign result[5]=exp[1]^exp[3]^exp[5]^exp[6]^exp[10]^exp[11];
  assign result[6]=exp[2]^exp[4]^exp[6]^exp[7]^exp[11]^exp[12];
  assign result[7]=exp[3]^exp[5]^exp[7]^exp[8]^exp[12]^exp[13];
  assign result[8]=exp[0]^exp[4]^exp[6]^exp[8]^exp[9]^exp[13]^exp[14];
  assign result[9]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[7]^exp[11]^exp[12];
  assign result[10]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[8]^exp[12]^exp[13];
  assign result[11]=exp[0]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[9]^exp[13]^exp[14];
  assign result[12]=exp[0]^exp[1]^exp[6]^exp[7]^exp[8]^exp[9]^exp[11]^exp[12];
  assign result[13]=exp[1]^exp[2]^exp[7]^exp[8]^exp[9]^exp[10]^exp[12]^exp[13];
  assign result[14]=exp[2]^exp[3]^exp[8]^exp[9]^exp[10]^exp[11]^exp[13]^exp[14];
endmodule

module ip_gf_2_poly_0x4a2f_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[4]^exp[5]^exp[7]^exp[8]^exp[11]^exp[14];
  assign result[1]=exp[0]^exp[4]^exp[6]^exp[7]^exp[9]^exp[11]^exp[12]^exp[14];
  assign result[2]=exp[0]^exp[1]^exp[4]^exp[10]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[3]=exp[1]^exp[2]^exp[4]^exp[7]^exp[8]^exp[12]^exp[13];
  assign result[4]=exp[0]^exp[2]^exp[3]^exp[5]^exp[8]^exp[9]^exp[13]^exp[14];
  assign result[5]=exp[0]^exp[1]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[6]=exp[1]^exp[2]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[7]=exp[0]^exp[2]^exp[3]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[8]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[9]=exp[0]^exp[1]^exp[2]^exp[8]^exp[9]^exp[10]^exp[12]^exp[13];
  assign result[10]=exp[1]^exp[2]^exp[3]^exp[9]^exp[10]^exp[11]^exp[13]^exp[14];
  assign result[11]=exp[0]^exp[2]^exp[3]^exp[5]^exp[7]^exp[8]^exp[10]^exp[12];
  assign result[12]=exp[1]^exp[3]^exp[4]^exp[6]^exp[8]^exp[9]^exp[11]^exp[13];
  assign result[13]=exp[2]^exp[4]^exp[5]^exp[7]^exp[9]^exp[10]^exp[12]^exp[14];
  assign result[14]=exp[3]^exp[4]^exp[6]^exp[7]^exp[10]^exp[13]^exp[14];
endmodule

module ip_gf_2_poly_0x5b45_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[2]^exp[4]^exp[6]^exp[11]^exp[13];
  assign result[1]=exp[3]^exp[5]^exp[7]^exp[12]^exp[14];
  assign result[2]=exp[0]^exp[2]^exp[8]^exp[11];
  assign result[3]=exp[1]^exp[3]^exp[9]^exp[12];
  assign result[4]=exp[0]^exp[2]^exp[4]^exp[10]^exp[13];
  assign result[5]=exp[1]^exp[3]^exp[5]^exp[11]^exp[14];
  assign result[6]=exp[11]^exp[12]^exp[13];
  assign result[7]=exp[12]^exp[13]^exp[14];
  assign result[8]=exp[2]^exp[4]^exp[6]^exp[11]^exp[14];
  assign result[9]=exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[11]^exp[12]^exp[13];
  assign result[10]=exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[12]^exp[13]^exp[14];
  assign result[11]=exp[0]^exp[2]^exp[5]^exp[7]^exp[8]^exp[9]^exp[11]^exp[14];
  assign result[12]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[13]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[14]=exp[1]^exp[3]^exp[5]^exp[10]^exp[12]^exp[14];
endmodule

module ip_gf_2_poly_0x7ba3_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[3]^exp[5]^exp[8]^exp[9]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[1]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[10]^exp[11];
  assign result[2]=exp[1]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9]^exp[11]^exp[12];
  assign result[3]=exp[0]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10]^exp[12]^exp[13];
  assign result[4]=exp[0]^exp[1]^exp[3]^exp[6]^exp[7]^exp[8]^exp[9]^exp[11]^exp[13]^exp[14];
  assign result[5]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[10]^exp[11]^exp[13];
  assign result[6]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[11]^exp[12]^exp[14];
  assign result[7]=exp[2]^exp[4]^exp[6]^exp[7]^exp[8]^exp[11]^exp[14];
  assign result[8]=exp[7]^exp[11]^exp[13]^exp[14];
  assign result[9]=exp[3]^exp[5]^exp[9]^exp[11]^exp[13];
  assign result[10]=exp[4]^exp[6]^exp[10]^exp[12]^exp[14];
  assign result[11]=exp[0]^exp[3]^exp[7]^exp[8]^exp[9]^exp[12]^exp[14];
  assign result[12]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[10]^exp[11]^exp[12]^exp[14];
  assign result[13]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[8]^exp[9]^exp[14];
  assign result[14]=exp[2]^exp[4]^exp[7]^exp[8]^exp[10]^exp[11]^exp[12]^exp[13]^exp[14];
endmodule

module ip_gf_2_poly_0x210f_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[3]^exp[5]^exp[6]^exp[10]^exp[11]^exp[14];
  assign result[1]=exp[0]^exp[3]^exp[4]^exp[5]^exp[7]^exp[10]^exp[12]^exp[14];
  assign result[2]=exp[1]^exp[3]^exp[4]^exp[8]^exp[10]^exp[13]^exp[14];
  assign result[3]=exp[2]^exp[3]^exp[4]^exp[6]^exp[9]^exp[10];
  assign result[4]=exp[0]^exp[3]^exp[4]^exp[5]^exp[7]^exp[10]^exp[11];
  assign result[5]=exp[1]^exp[4]^exp[5]^exp[6]^exp[8]^exp[11]^exp[12];
  assign result[6]=exp[2]^exp[5]^exp[6]^exp[7]^exp[9]^exp[12]^exp[13];
  assign result[7]=exp[0]^exp[3]^exp[6]^exp[7]^exp[8]^exp[10]^exp[13]^exp[14];
  assign result[8]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10];
  assign result[9]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[10]=exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[11]=exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[12]=exp[0]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[13]=exp[1]^exp[3]^exp[4]^exp[8]^exp[9]^exp[12]^exp[13];
  assign result[14]=exp[2]^exp[4]^exp[5]^exp[9]^exp[10]^exp[13]^exp[14];
endmodule

module ip_gf_2_poly_0x5237_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[0]^exp[1]^exp[4]^exp[6]^exp[7]^exp[10]^exp[12]^exp[14];
  assign result[1]=exp[0]^exp[2]^exp[4]^exp[5]^exp[6]^exp[8]^exp[10]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[2]=exp[0]^exp[3]^exp[4]^exp[5]^exp[9]^exp[10]^exp[11]^exp[13];
  assign result[3]=exp[0]^exp[1]^exp[4]^exp[5]^exp[6]^exp[10]^exp[11]^exp[12]^exp[14];
  assign result[4]=exp[2]^exp[4]^exp[5]^exp[10]^exp[11]^exp[13]^exp[14];
  assign result[5]=exp[0]^exp[1]^exp[3]^exp[4]^exp[5]^exp[7]^exp[10]^exp[11];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[8]^exp[11]^exp[12];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[9]^exp[12]^exp[13];
  assign result[8]=exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[8]^exp[10]^exp[13]^exp[14];
  assign result[9]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[10]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[11]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[10]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[12]=exp[1]^exp[2]^exp[3]^exp[5]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[13];
  assign result[13]=exp[0]^exp[2]^exp[3]^exp[4]^exp[6]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12]^exp[14];
  assign result[14]=exp[0]^exp[3]^exp[5]^exp[6]^exp[9]^exp[11]^exp[13]^exp[14];
endmodule

module ip_gf_2_poly_0x7f13_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[0]^exp[2]^exp[3]^exp[4]^exp[6]^exp[8]^exp[10]^exp[12]^exp[13]^exp[14];
  assign result[1]=exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[2]=exp[2]^exp[3]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[3]=exp[3]^exp[4]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[4]=exp[2]^exp[3]^exp[5]^exp[6]^exp[9]^exp[11];
  assign result[5]=exp[0]^exp[3]^exp[4]^exp[6]^exp[7]^exp[10]^exp[12];
  assign result[6]=exp[0]^exp[1]^exp[4]^exp[5]^exp[7]^exp[8]^exp[11]^exp[13];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[8]^exp[9]^exp[12]^exp[14];
  assign result[8]=exp[1]^exp[4]^exp[7]^exp[8]^exp[9]^exp[12]^exp[14];
  assign result[9]=exp[3]^exp[4]^exp[5]^exp[6]^exp[9]^exp[12]^exp[14];
  assign result[10]=exp[0]^exp[2]^exp[3]^exp[5]^exp[7]^exp[8]^exp[12]^exp[14];
  assign result[11]=exp[0]^exp[1]^exp[2]^exp[9]^exp[10]^exp[12]^exp[14];
  assign result[12]=exp[1]^exp[4]^exp[6]^exp[8]^exp[11]^exp[12]^exp[14];
  assign result[13]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[14];
  assign result[14]=exp[1]^exp[2]^exp[3]^exp[5]^exp[7]^exp[9]^exp[11]^exp[12]^exp[13]^exp[14];
endmodule

module ip_gf_2_poly_0x347_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[0]^exp[1]^exp[3]^exp[4]^exp[8]^exp[11]^exp[12]^exp[14];
  assign result[1]=exp[0]^exp[2]^exp[3]^exp[5]^exp[8]^exp[9]^exp[11]^exp[13]^exp[14];
  assign result[2]=exp[0]^exp[6]^exp[8]^exp[9]^exp[10]^exp[11];
  assign result[3]=exp[1]^exp[7]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[4]=exp[2]^exp[8]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[5]=exp[0]^exp[3]^exp[9]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[6]=exp[0]^exp[3]^exp[8]^exp[10]^exp[11]^exp[13];
  assign result[7]=exp[1]^exp[4]^exp[9]^exp[11]^exp[12]^exp[14];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[8]^exp[10]^exp[11]^exp[13]^exp[14];
  assign result[9]=exp[2]^exp[5]^exp[6]^exp[8]^exp[9];
  assign result[10]=exp[3]^exp[6]^exp[7]^exp[9]^exp[10];
  assign result[11]=exp[0]^exp[4]^exp[7]^exp[8]^exp[10]^exp[11];
  assign result[12]=exp[0]^exp[1]^exp[5]^exp[8]^exp[9]^exp[11]^exp[12];
  assign result[13]=exp[1]^exp[2]^exp[6]^exp[9]^exp[10]^exp[12]^exp[13];
  assign result[14]=exp[0]^exp[2]^exp[3]^exp[7]^exp[10]^exp[11]^exp[13]^exp[14];
endmodule

module ip_gf_2_poly_0x123f_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[4]^exp[6]^exp[8]^exp[9]^exp[14];
  assign result[1]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10]^exp[14];
  assign result[2]=exp[2]^exp[5]^exp[7]^exp[11]^exp[14];
  assign result[3]=exp[1]^exp[2]^exp[3]^exp[4]^exp[9]^exp[12]^exp[14];
  assign result[4]=exp[1]^exp[3]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10]^exp[13]^exp[14];
  assign result[5]=exp[0]^exp[1]^exp[7]^exp[8]^exp[10]^exp[11];
  assign result[6]=exp[1]^exp[2]^exp[8]^exp[9]^exp[11]^exp[12];
  assign result[7]=exp[2]^exp[3]^exp[9]^exp[10]^exp[12]^exp[13];
  assign result[8]=exp[3]^exp[4]^exp[10]^exp[11]^exp[13]^exp[14];
  assign result[9]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[8]^exp[9]^exp[11]^exp[12];
  assign result[10]=exp[0]^exp[1]^exp[2]^exp[3]^exp[6]^exp[7]^exp[9]^exp[10]^exp[12]^exp[13];
  assign result[11]=exp[1]^exp[2]^exp[3]^exp[4]^exp[7]^exp[8]^exp[10]^exp[11]^exp[13]^exp[14];
  assign result[12]=exp[1]^exp[3]^exp[5]^exp[6]^exp[11]^exp[12];
  assign result[13]=exp[0]^exp[2]^exp[4]^exp[6]^exp[7]^exp[12]^exp[13];
  assign result[14]=exp[0]^exp[1]^exp[3]^exp[5]^exp[7]^exp[8]^exp[13]^exp[14];
endmodule

module ip_gf_2_poly_0x40cb_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[0]^exp[2]^exp[3]^exp[5]^exp[9]^exp[11]^exp[13]^exp[14];
  assign result[1]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[2]=exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[10]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[3]=exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[12];
  assign result[4]=exp[0]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[13];
  assign result[5]=exp[1]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[14];
  assign result[6]=exp[0]^exp[3]^exp[7]^exp[8]^exp[10]^exp[12]^exp[13]^exp[14];
  assign result[7]=exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[8];
  assign result[8]=exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[9];
  assign result[9]=exp[0]^exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[10];
  assign result[10]=exp[0]^exp[1]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[11];
  assign result[11]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[12];
  assign result[12]=exp[1]^exp[2]^exp[3]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[13];
  assign result[13]=exp[0]^exp[2]^exp[3]^exp[4]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[14];
  assign result[14]=exp[1]^exp[2]^exp[4]^exp[8]^exp[10]^exp[12]^exp[13]^exp[14];
endmodule

module ip_gf_2_poly_0x3ad7_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[0]^exp[3]^exp[5]^exp[9]^exp[12]^exp[14];
  assign result[1]=exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[9]^exp[10]^exp[12]^exp[13]^exp[14];
  assign result[2]=exp[2]^exp[3]^exp[4]^exp[6]^exp[7]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[3]=exp[0]^exp[3]^exp[4]^exp[5]^exp[7]^exp[8]^exp[10]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[4]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6]^exp[8]^exp[11]^exp[13];
  assign result[5]=exp[1]^exp[2]^exp[4]^exp[5]^exp[7]^exp[9]^exp[12]^exp[14];
  assign result[6]=exp[0]^exp[2]^exp[6]^exp[8]^exp[9]^exp[10]^exp[12]^exp[13]^exp[14];
  assign result[7]=exp[0]^exp[1]^exp[5]^exp[7]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[8]=exp[1]^exp[2]^exp[6]^exp[8]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[9]=exp[0]^exp[2]^exp[5]^exp[7]^exp[13];
  assign result[10]=exp[1]^exp[3]^exp[6]^exp[8]^exp[14];
  assign result[11]=exp[2]^exp[3]^exp[4]^exp[5]^exp[7]^exp[12]^exp[14];
  assign result[12]=exp[0]^exp[4]^exp[6]^exp[8]^exp[9]^exp[12]^exp[13]^exp[14];
  assign result[13]=exp[1]^exp[3]^exp[7]^exp[10]^exp[12]^exp[13];
  assign result[14]=exp[2]^exp[4]^exp[8]^exp[11]^exp[13]^exp[14];
endmodule

module ip_gf_2_poly_0x665_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[3]^exp[7]^exp[10]^exp[11]^exp[13];
  assign result[1]=exp[4]^exp[8]^exp[11]^exp[12]^exp[14];
  assign result[2]=exp[0]^exp[3]^exp[5]^exp[7]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[3]=exp[1]^exp[4]^exp[6]^exp[8]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[4]=exp[0]^exp[2]^exp[5]^exp[7]^exp[9]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[5]=exp[0]^exp[1]^exp[6]^exp[7]^exp[8]^exp[11]^exp[12]^exp[14];
  assign result[6]=exp[0]^exp[1]^exp[2]^exp[3]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[10]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[9]=exp[1]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[10]^exp[12]^exp[14];
  assign result[10]=exp[2]^exp[5]^exp[6]^exp[8]^exp[10];
  assign result[11]=exp[3]^exp[6]^exp[7]^exp[9]^exp[11];
  assign result[12]=exp[0]^exp[4]^exp[7]^exp[8]^exp[10]^exp[12];
  assign result[13]=exp[1]^exp[5]^exp[8]^exp[9]^exp[11]^exp[13];
  assign result[14]=exp[2]^exp[6]^exp[9]^exp[10]^exp[12]^exp[14];
endmodule

module ip_gf_2_poly_0x4357_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[0]^exp[2]^exp[4]^exp[6]^exp[7]^exp[8]^exp[9]^exp[12]^exp[14];
  assign result[1]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[5]^exp[6]^exp[10]^exp[12]^exp[13]^exp[14];
  assign result[2]=exp[0]^exp[1]^exp[3]^exp[5]^exp[8]^exp[9]^exp[11]^exp[12]^exp[13];
  assign result[3]=exp[1]^exp[2]^exp[4]^exp[6]^exp[9]^exp[10]^exp[12]^exp[13]^exp[14];
  assign result[4]=exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[5]=exp[4]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[6]=exp[0]^exp[2]^exp[4]^exp[5]^exp[9]^exp[10]^exp[11]^exp[13];
  assign result[7]=exp[0]^exp[1]^exp[3]^exp[5]^exp[6]^exp[10]^exp[11]^exp[12]^exp[14];
  assign result[8]=exp[1]^exp[8]^exp[9]^exp[11]^exp[13]^exp[14];
  assign result[9]=exp[0]^exp[4]^exp[6]^exp[7]^exp[8]^exp[10];
  assign result[10]=exp[0]^exp[1]^exp[5]^exp[7]^exp[8]^exp[9]^exp[11];
  assign result[11]=exp[0]^exp[1]^exp[2]^exp[6]^exp[8]^exp[9]^exp[10]^exp[12];
  assign result[12]=exp[0]^exp[1]^exp[2]^exp[3]^exp[7]^exp[9]^exp[10]^exp[11]^exp[13];
  assign result[13]=exp[0]^exp[1]^exp[2]^exp[3]^exp[4]^exp[8]^exp[10]^exp[11]^exp[12]^exp[14];
  assign result[14]=exp[1]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8]^exp[11]^exp[13]^exp[14];
endmodule

module ip_gf_2_poly_0x376b_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[1]^exp[2]^exp[4]^exp[6]^exp[7]^exp[9]^exp[10]^exp[11]^exp[13]^exp[14];
  assign result[1]=exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[8]^exp[9]^exp[12]^exp[13];
  assign result[2]=exp[0]^exp[2]^exp[4]^exp[5]^exp[6]^exp[7]^exp[9]^exp[10]^exp[13]^exp[14];
  assign result[3]=exp[0]^exp[2]^exp[3]^exp[4]^exp[5]^exp[8]^exp[9]^exp[13];
  assign result[4]=exp[1]^exp[3]^exp[4]^exp[5]^exp[6]^exp[9]^exp[10]^exp[14];
  assign result[5]=exp[1]^exp[5]^exp[9]^exp[13]^exp[14];
  assign result[6]=exp[0]^exp[1]^exp[4]^exp[7]^exp[9]^exp[11]^exp[13];
  assign result[7]=exp[0]^exp[1]^exp[2]^exp[5]^exp[8]^exp[10]^exp[12]^exp[14];
  assign result[8]=exp[3]^exp[4]^exp[7]^exp[10]^exp[14];
  assign result[9]=exp[0]^exp[1]^exp[2]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[10]^exp[13]^exp[14];
  assign result[10]=exp[0]^exp[3]^exp[4]^exp[8]^exp[13];
  assign result[11]=exp[0]^exp[1]^exp[4]^exp[5]^exp[9]^exp[14];
  assign result[12]=exp[0]^exp[4]^exp[5]^exp[7]^exp[9]^exp[11]^exp[13]^exp[14];
  assign result[13]=exp[0]^exp[2]^exp[4]^exp[5]^exp[7]^exp[8]^exp[9]^exp[11]^exp[12]^exp[13];
  assign result[14]=exp[0]^exp[1]^exp[3]^exp[5]^exp[6]^exp[8]^exp[9]^exp[10]^exp[12]^exp[13]^exp[14];
endmodule

module ip_gf_2_poly_0x35f_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[0]^exp[1]^exp[2]^exp[3]^exp[6]^exp[10]^exp[14];
  assign result[1]=exp[4]^exp[6]^exp[7]^exp[10]^exp[11]^exp[14];
  assign result[2]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[6]^exp[7]^exp[8]^exp[10]^exp[11]^exp[12]^exp[14];
  assign result[3]=exp[0]^exp[4]^exp[7]^exp[8]^exp[9]^exp[10]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[4]=exp[0]^exp[2]^exp[3]^exp[5]^exp[6]^exp[8]^exp[9]^exp[11]^exp[12]^exp[13];
  assign result[5]=exp[0]^exp[1]^exp[3]^exp[4]^exp[6]^exp[7]^exp[9]^exp[10]^exp[12]^exp[13]^exp[14];
  assign result[6]=exp[3]^exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[11]^exp[13];
  assign result[7]=exp[4]^exp[5]^exp[6]^exp[7]^exp[8]^exp[9]^exp[12]^exp[14];
  assign result[8]=exp[0]^exp[1]^exp[2]^exp[3]^exp[5]^exp[7]^exp[8]^exp[9]^exp[13]^exp[14];
  assign result[9]=exp[0]^exp[4]^exp[8]^exp[9];
  assign result[10]=exp[1]^exp[5]^exp[9]^exp[10];
  assign result[11]=exp[2]^exp[6]^exp[10]^exp[11];
  assign result[12]=exp[0]^exp[3]^exp[7]^exp[11]^exp[12];
  assign result[13]=exp[0]^exp[1]^exp[4]^exp[8]^exp[12]^exp[13];
  assign result[14]=exp[0]^exp[1]^exp[2]^exp[5]^exp[9]^exp[13]^exp[14];
endmodule

module ip_gf_2_poly_0x4aad_crc15_rev(exp, result);
  input  [14:0] exp;
  output [14:0] result;
  assign result[0]=exp[0]^exp[1]^exp[3]^exp[6]^exp[10]^exp[11]^exp[12]^exp[13];
  assign result[1]=exp[1]^exp[2]^exp[4]^exp[7]^exp[11]^exp[12]^exp[13]^exp[14];
  assign result[2]=exp[1]^exp[2]^exp[5]^exp[6]^exp[8]^exp[10]^exp[11]^exp[14];
  assign result[3]=exp[0]^exp[1]^exp[2]^exp[7]^exp[9]^exp[10]^exp[13];
  assign result[4]=exp[1]^exp[2]^exp[3]^exp[8]^exp[10]^exp[11]^exp[14];
  assign result[5]=exp[1]^exp[2]^exp[4]^exp[6]^exp[9]^exp[10]^exp[13];
  assign result[6]=exp[2]^exp[3]^exp[5]^exp[7]^exp[10]^exp[11]^exp[14];
  assign result[7]=exp[1]^exp[4]^exp[8]^exp[10]^exp[13];
  assign result[8]=exp[0]^exp[2]^exp[5]^exp[9]^exp[11]^exp[14];
  assign result[9]=exp[0]^exp[11]^exp[13];
  assign result[10]=exp[0]^exp[1]^exp[12]^exp[14];
  assign result[11]=exp[0]^exp[2]^exp[3]^exp[6]^exp[10]^exp[11]^exp[12];
  assign result[12]=exp[0]^exp[1]^exp[3]^exp[4]^exp[7]^exp[11]^exp[12]^exp[13];
  assign result[13]=exp[0]^exp[1]^exp[2]^exp[4]^exp[5]^exp[8]^exp[12]^exp[13]^exp[14];
  assign result[14]=exp[0]^exp[2]^exp[5]^exp[9]^exp[10]^exp[11]^exp[12]^exp[14];
endmodule



