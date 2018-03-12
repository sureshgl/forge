/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */
interface mem_rw_ifc #(int AW=8, int DW=32, int LATENCY=1) (input clk);
  
  localparam MAX_LATENCY = 30;
  
  logic           read;
  logic           read_vld;
  logic           read_serr;  
  logic           read_derr;  
  logic           write;
  logic [AW-1:0]  addr;
  logic [DW-1:0]  dout;
  logic [DW-1:0]  din;
  logic           read_d;
  logic           read_c;

  clocking tb_req @(posedge clk);
    default input #30 output #10;
    output        read;
    output        write;
    output        addr;
    output        din;
  endclocking
  clocking tb_rsp @(posedge clk);
    default input #30 output #10;
    input         read_vld;
    input         read_serr;
    input         read_derr;
    input         dout;
  endclocking

  integer         read_int;
  reg             read_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (read_int=0; read_int<MAX_LATENCY; read_int=read_int+1)
      if (read_int>0)
        read_reg[read_int] <= read_reg[read_int-1];
      else
        read_reg[read_int] <= read;

  generate
    if (LATENCY) 
      assign read_d = read_reg[LATENCY-1];
    else 
      assign read_d = read;
  endgenerate

endinterface

interface mem_r_ifc #(int AW=8, int DW=32, int LATENCY=1) (input clk);

  localparam MAX_LATENCY = 30;

  logic           read;
  logic [AW-1:0]  addr;
  logic           read_vld;
  logic           read_serr;
  logic           read_derr;
  logic [DW-1:0]  dout;
  logic           read_d;

  clocking tb_req @(posedge clk);
    default input #30 output #10;
    output        read;
    output        addr;
  endclocking
  clocking tb_rsp @(posedge clk);
    default input #30 output #10;
    input         read_vld;
    input         read_serr;
    input         read_derr;
    input         dout;
  endclocking

  integer         read_int;
  reg             read_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (read_int=0; read_int<MAX_LATENCY; read_int=read_int+1)
      if (read_int>0)
        read_reg[read_int] <= read_reg[read_int-1];
      else
        read_reg[read_int] <= read;

  generate
    if (LATENCY) 
      assign read_d = read_reg[LATENCY-1];
    else 
      assign read_d = read;
  endgenerate

endinterface

interface mem_w_ifc #(int AW=8, int DW=32) (input clk);
  logic           write;
  logic [AW-1:0]  addr;
  logic [DW-1:0]  din;

  clocking tb_req @(posedge clk);
    default input #30 output #10;
    output        write;
    output        addr;
    output        din;
  endclocking
endinterface

interface mem_misc_ifc (input clk);
  logic           rst;
  logic           ready;
  logic           refr;           

  clocking tb_req @(posedge clk);
    output        rst;
  endclocking
  clocking tb_rsp @(posedge clk);
    default input #30 output #10;
    input         ready;
    input         refr;
  endclocking

  modport tb (output rst, input ready, input refr); 

endinterface

interface mem_c_ifc #(int AW=8, int DW=32) (input clk);
  logic           cnt;
  logic [AW-1:0]  ct_adr;
  logic [DW-1:0]  ct_imm;
  logic           ct_serr;
  logic           ct_derr;
  logic           ct_vld;

  clocking tb_req @(posedge clk);
    default input #30 output #10;
    output        cnt;
    output        ct_adr;
    output        ct_imm;
  endclocking

  clocking tb_rsp @(posedge clk);
    default input #30 output #10;
    input         ct_vld;
    input         ct_serr;
    input         ct_derr;
  endclocking

endinterface

interface mem_a_ifc #(int AW=8, int DW=32, int LATENCY=1) (input clk);

  localparam MAX_LATENCY = 30;

  logic           ac_read;
  logic           ac_vld;
  logic           ac_serr;  
  logic           ac_derr;  
  logic           ac_write;
  logic [AW-1:0]  ac_addr;
  logic [DW-1:0]  ac_dout;
  logic [DW-1:0]  ac_din;
  logic           read_d;
  logic           read_c;

  clocking tb_req @(posedge clk);
    default input #30 output #10;
    output        ac_read;
    output        ac_write;
    output        ac_addr;
    output        ac_din;
  endclocking
  clocking tb_rsp @(posedge clk);
    default input #30 output #10;
    input         ac_vld;
    input         ac_serr;
    input         ac_derr;
    input         ac_dout;
  endclocking

  integer         ac_int;
  reg             ac_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (ac_int=0; ac_int<MAX_LATENCY; ac_int=ac_int+1)
      if (ac_int>0)
        ac_reg[ac_int] <= ac_reg[ac_int-1];
      else
        ac_reg[ac_int] <= ac_read;

  generate
    if (LATENCY) 
      assign read_d = ac_reg[LATENCY-1];
    else 
      assign read_d = ac_read;
  endgenerate

endinterface

interface mem_dbg_ifc #(int AW=8, int WORDS=256, int DW=32, int LATENCY=1, int BW=1, int NUMPRT=0) (input clk);

  localparam MAX_LATENCY = 30;
  
  logic           dbg_en;
  logic           dbg_read;
  logic           dbg_refr;
  logic           dbg_vld;
  logic           dbg_err;  
  logic           dbg_derr;  
  logic           dbg_write;
  logic [AW-1:0]  dbg_addr;
  logic [DW-1:0]  dbg_dout;
  logic [DW-1:0]  dbg_din;
  logic [BW-1:0]  dbg_bank;
  logic [BW-1:0]  dbg_rbnk;
  logic           read_d;
  logic           read_c;

  clocking tb_req @(posedge clk);
    default input #30 output #10;
    output        dbg_en;
    output        dbg_read;
    output        dbg_refr;
    output        dbg_write;
    output        dbg_addr;
    output        dbg_din;
    output	      dbg_bank;
    output	      dbg_rbnk;
  endclocking
  clocking tb_rsp @(posedge clk);
    default input #30 output #10;
    input         dbg_vld;
    input         dbg_err;
    input         dbg_derr;
    input         dbg_dout;
  endclocking

  integer         read_int;
  reg             read_reg [0:MAX_LATENCY-1];
  always @(posedge clk)
    for (read_int=0; read_int<MAX_LATENCY; read_int=read_int+1)
      if (read_int>0)
        read_reg[read_int] <= read_reg[read_int-1];
      else
        read_reg[read_int] <= dbg_read;

  generate
    if (LATENCY) 
      assign read_d = read_reg[LATENCY-1];
    else 
      assign read_d = dbg_read;
  endgenerate


endinterface


interface mem_r_ifc_pkd #(int AW=8, int DW=32, int LATENCY=1, int NUMPRT=0)
  (input clk);
  logic [NUMPRT-1:0]    read;
  logic [NUMPRT*AW-1:0] addr;
  logic [NUMPRT-1:0]    read_vld;
  logic [NUMPRT-1:0]    read_serr;
  logic [NUMPRT-1:0]    read_derr;
  logic [NUMPRT*DW-1:0] dout;

  modport tb (output read, addr, input dout, read_vld, read_serr, read_derr);

  //TODO: IF NEEDED, generate another parameter and init array with length 1
  mem_r_ifc #(AW,DW,LATENCY) r_ifc[0:NUMPRT-1](clk);

  genvar                i;
  generate
    for(i=0;i<NUMPRT;i=i+1) begin
      assign read[i]=r_ifc[i].read ;
      assign r_ifc[i].read_serr = read_serr[i];
      assign r_ifc[i].read_derr = read_derr[i];
      assign r_ifc[i].read_vld = read_vld[i];
      assign addr[(i+1)*AW-1:i*AW]= r_ifc[i].addr;
      assign r_ifc[i].dout = dout[(i+1)*DW-1:i*DW];
    end
  endgenerate

endinterface

interface mem_w_ifc_pkd #(int AW=8, int DW=32, int NUMPRT=0)
  (input clk);  
  logic [NUMPRT-1:0]     write;  
  logic [NUMPRT*AW-1:0]  addr;  
  logic [NUMPRT*DW-1:0]  din;

  modport tb (output write, addr, din);

  //TODO: IF NEEDED, generate another parameter and init array with length 1
  mem_w_ifc #(AW,DW) w_ifc[0:NUMPRT-1](clk);

  genvar                 i;
  generate
    for(i=0;i<NUMPRT;i=i+1) begin
      assign write[i]=w_ifc[i].write;
      assign addr[(i+1)*AW-1:i*AW]= w_ifc[i].addr;
      assign din[(i+1)*DW-1:i*DW] = w_ifc[i].din;
    end
  endgenerate

endinterface

interface mem_rw_ifc_pkd #(int AW=8, int DW=32, int LATENCY=1, int NUMPRT=0)
  (input clk);
  logic [NUMPRT-1:0]     read;
  logic [NUMPRT-1:0]     write;  
  logic [NUMPRT*AW-1:0]  addr;
  logic [NUMPRT-1:0]     read_vld;
  logic [NUMPRT-1:0]     read_serr;
  logic [NUMPRT-1:0]     read_derr;
  logic [NUMPRT*DW-1:0]  din;
  logic [NUMPRT*DW-1:0]  dout;

  modport tb (output read, write, addr, din, input dout, read_vld, read_serr, read_derr);

  //TODO: IF NEEDED, generate another parameter and init array with length 1
  mem_rw_ifc #(AW,DW,LATENCY) rw_ifc[0:NUMPRT-1](clk);

  genvar                 i;
  generate
    for(i=0;i<NUMPRT;i=i+1) begin
      assign read[i]=rw_ifc[i].read ;
      assign write[i]=rw_ifc[i].write;
      assign rw_ifc[i].read_serr = read_serr[i];
      assign rw_ifc[i].read_derr = read_derr[i];
      assign rw_ifc[i].read_vld = read_vld[i];
      assign addr[(i+1)*AW-1:i*AW]= rw_ifc[i].addr;
      assign din[(i+1)*DW-1:i*DW] = rw_ifc[i].din;
      assign rw_ifc[i].dout = dout[(i+1)*DW-1:i*DW];
    end
  endgenerate

endinterface

interface mem_c_ifc_pkd #(int AW=8, int DW=32,int NUMPRT=0)
  (input clk);
  logic [NUMPRT-1:0]     cnt;
  logic [NUMPRT*AW-1:0]  ct_adr;
  logic [NUMPRT-1:0]     ct_vld;
  logic [NUMPRT-1:0]     ct_serr;
  logic [NUMPRT-1:0]     ct_derr;
  logic [NUMPRT*DW-1:0]  ct_imm;

  modport tb (output cnt, ct_adr, ct_imm, input ct_vld, ct_serr, ct_derr);

  //TODO: IF NEEDED, generate another parameter and init array with length 1
  mem_c_ifc #(AW,DW) c_ifc[0:NUMPRT-1](clk);

  genvar                 i;
  generate
    for(i=0;i<NUMPRT;i=i+1) begin
      assign cnt[i]=c_ifc[i].cnt;
      assign c_ifc[i].ct_serr = ct_serr[i];
      assign c_ifc[i].ct_derr = ct_derr[i];
      assign c_ifc[i].ct_vld = ct_vld[i];
      assign ct_adr[(i+1)*AW-1:i*AW]= c_ifc[i].ct_adr;
      assign ct_imm[(i+1)*DW-1:i*DW] = c_ifc[i].ct_imm;
    end
  endgenerate

endinterface

interface mem_a_ifc_pkd #(int AW=8, int DW=32, int LATENCY=1, int NUMPRT=0)
  (input clk);
  logic [NUMPRT-1:0]     ac_read;
  logic [NUMPRT-1:0]     ac_write;
  logic [NUMPRT*AW-1:0]  ac_addr;
  logic [NUMPRT-1:0]     ac_vld;
  logic [NUMPRT-1:0]     ac_serr;
  logic [NUMPRT-1:0]     ac_derr;
  logic [NUMPRT*DW-1:0]  ac_din;
  logic [NUMPRT*DW-1:0]  ac_dout;

  modport tb (output ac_read, ac_write, ac_addr, ac_din, input ac_vld, ac_serr, ac_derr, ac_dout);

  //TODO: IF NEEDED, generate another parameter and init array with length 1
  mem_a_ifc #(AW,DW,LATENCY) a_ifc[0:NUMPRT-1](clk);

  genvar                 i;
  generate
    for(i=0;i<NUMPRT;i=i+1) begin
      assign ac_read[i] = a_ifc[i].ac_read;
      assign ac_write[i] = a_ifc[i].ac_write;
      assign a_ifc[i].ac_serr = ac_serr[i];
      assign a_ifc[i].ac_derr = ac_derr[i];
      assign a_ifc[i].ac_vld = ac_vld[i];
      assign a_ifc[i].ac_dout = ac_dout[(i+1)*DW-1:i*DW];
      assign ac_addr[(i+1)*AW-1:i*AW]= a_ifc[i].ac_addr;
      assign ac_din[(i+1)*DW-1:i*DW] = a_ifc[i].ac_din;
    end
  endgenerate

endinterface
