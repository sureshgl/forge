/* Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

// NOTE: this is an example stitched env for understanding the testbench

// below function enumerates all possible combinations of ports on which stimulus can be sent per cycle
// also enumerates the port types
function MemoryOpcodes::new ();
  rid     = new();
  wid     = new();
  rwid    = new();
  cid     = new();
  aid     = new();
  ruid    = new();
  
  opCodes[0]    = 12'b0000_0000_0000;
  opCodes[1]    = 12'b0000_0000_0001;
  opCodes[2]    = 12'b0000_0000_0010;
  opCodes[3]    = 12'b0000_0000_0100;
  opCodes[4]    = 12'b0000_0000_1000;
  opCodes[5]    = 12'b0000_0001_0000;
  opCodes[6]    = 12'b0000_0010_0000;
  opCodes[7]    = 12'b0000_0100_0000;
  opCodes[8]    = 12'b0000_1000_0000;
  opCodes[9]    = 12'b0001_0000_0000;
  opCodes[10]   = 12'b0010_0000_0000;
  opCodes[11]   = 12'b0100_0000_0000;
  opCodes[12]   = 12'b1000_0000_0000;
  maxOpCodes[0] = 12'b0000_0011_0000; // RW
  ptype[0]      = PORT_R;
  ptype[1]      = PORT_R;
  ptype[2]      = PORT_W;
  ptype[3]      = PORT_W;
  ptype[4]      = PORT_RW;
  ptype[5]      = PORT_RW;
  ptype[6]      = PORT_C;
  ptype[7]      = PORT_C;
  ptype[8]      = PORT_A;
  ptype[9]      = PORT_A;
  ptype[10]     = PORT_RU;
  ptype[11]     = PORT_RU;
endfunction

// constraints to select a port at random
// since empty array is not accepted, dump some value
// in to non-existent port type
constraint MemoryReadPortId::id_c       {id inside  {[0:1]};}
constraint MemoryWritePortId::id_c      {id inside  {[2:3]};}
constraint MemoryReadWritePortId::id_c  {id inside  {[4:5]};}
constraint MemoryCountPortId::id_c      {id inside  {[6:7]};}
constraint MemoryAccessPortId::id_c     {id inside  {[8:9]};}
constraint MemoryReadUpdatePortId::id_c {id inside  {[10:11]};}

module testbench (
                  );
  string name = "testbench";
  parameter IP_BITS    = 32;
  parameter IP_WORDS   = 8192;
  parameter IP_AW      = 13;
  parameter IP_LATENCY = 2;

  parameter AW      = IP_AW;
  parameter DW      = IP_BITS;

  parameter TB_HALF_CLK_PER  = 1000;
  parameter TB_RST_NUM_CYC   = 10;
  parameter TB_VPD_DUMP_FILE = "dump.vpd";

  parameter TB_REQ_PIPE_DELAY = 5;
  parameter REFRESH_M_IN_N_M = 0;
  parameter REFRESH_M_IN_N_N = 0;

  parameter RESET_NEEDED = 1;
  parameter WAIT_FOR_READY = 0;
  parameter CHK_READ_VLD = 0;
  parameter CHK_READ_ERR = 0;

  parameter NRP  = 2;
  parameter NWP  = 2;
  parameter NRWP = 2;
  parameter NCP  = 2;
  parameter NAP  = 2;
  parameter NRUP = 2;

  wire                 rst;
  wire                 clk;
  wire                 refr;
  wire                 refr_e;
  wire                 ready;
  
  wire [DW-1:0]        bw_2 = {DW{1'b1}};
  
  wire [DW-1:0]        bw_3 = {DW{1'b1}};
  
  wire [DW-1:0]        bw_4  = {DW{1'b1}};
  wire [DW-1:0]        bw_5 = {DW{1'b1}};
  
  wire [DW-1:0]        ru_bw_10 = {DW{1'b1}};
  wire [DW-1:0]        ru_bw_11 = {DW{1'b1}};

  mem_r_ifc_pkd #(
                  .AW(AW), 
                  .DW(DW), 
                  .LATENCY(IP_LATENCY),
                  .NUMPRT(NRP)
                  ) 
  r_ifc_pkd (
             .clk (clk)
             );

  mem_w_ifc_pkd #(
                  .AW(AW), 
                  .DW(DW), 
                  .NUMPRT(NWP)
                  )
  w_ifc_pkd (
             .clk (clk)
             );

  mem_misc_ifc 
    misc_ifc (
              .clk (clk)
              );

  mem_dbg_ifc 
    dbg_ifc (
             .clk (clk)
              );

  mem_rw_ifc_pkd #(
                   .AW(AW), 
                   .DW(DW), 
                   .LATENCY(IP_LATENCY), 
                   .NUMPRT(NRWP)
                   ) 
  rw_ifc_pkd (
              .clk (clk)
              );

  mem_c_ifc_pkd     
    #(
      .AW(AW),
      .DW(DW),
      .NUMPRT(NCP)
      )
  c_ifc_pkd (
             .clk(clk)
             );
  
  mem_a_ifc_pkd     
    #(
      .AW(AW),
      .DW(DW),
      .LATENCY(IP_LATENCY),
      .NUMPRT(NAP)
      )  
  a_ifc_pkd     (
                  .clk(clk)
                  );

  mem_rw_ifc_pkd #(
                   .AW(AW), 
                   .DW(DW), 
                   .LATENCY(IP_LATENCY), 
                   .NUMPRT(NRUP)
                   ) 
  ru_ifc_pkd (
              .clk (clk)
              );

  testbench_init #(
                   .TB_HALF_CLK_PER(TB_HALF_CLK_PER),
                   .TB_VPD_DUMP_FILE(TB_VPD_DUMP_FILE),
                   .REFRESH_M_IN_N_M(REFRESH_M_IN_N_M),
                   .REFRESH_M_IN_N_N(REFRESH_M_IN_N_N)
                   )
  i (
     .rst(rst),
     .clk(clk),
     .refr(refr),
     .refr_e(refr_e)
     );

  mem_beh_mongo  #(
                  .AW(AW),
                  .DW(DW),
                  .WORDS(IP_WORDS),
                  .LATENCY(IP_LATENCY)
                  )
  mem (
       .clk(clk), 
       .rst(rst),

       .read_0(r_ifc_pkd.read[0]),
       .addr_0(r_ifc_pkd.addr[AW-1:0]),
       .dout_0(r_ifc_pkd.dout[DW-1:0]),
       .read_vld_0(r_ifc_pkd.read_vld[0]),
       .read_serr_0(r_ifc_pkd.read_serr[0]),
       .read_derr_0(r_ifc_pkd.read_derr[0]), 

       .read_1(r_ifc_pkd.read[1]),
       .addr_1(r_ifc_pkd.addr[2*AW-1:AW]),
       .dout_1(r_ifc_pkd.dout[2*DW-1:DW]),
       .read_vld_1(r_ifc_pkd.read_vld[1]),
       .read_serr_1(r_ifc_pkd.read_serr[1]),
       .read_derr_1(r_ifc_pkd.read_derr[1]), 
       
       .write_2(w_ifc_pkd.write[0]),
       .addr_2(w_ifc_pkd.addr[AW-1:0]), 
       .bw_2(bw_2[DW-1:0]), 
       .din_2(w_ifc_pkd.din[DW-1:0]),
       
       .write_3(w_ifc_pkd.write[1]),
       .addr_3(w_ifc_pkd.addr[2*AW-1:AW]), 
       .bw_3(bw_3[DW-1:0]), 
       .din_3(w_ifc_pkd.din[2*DW-1:DW]),
       
       .read_4(rw_ifc_pkd.read[0]), 
       .write_4(rw_ifc_pkd.write[0]), 
       .addr_4(rw_ifc_pkd.addr[AW-1:0]), 
       .din_4(rw_ifc_pkd.din[DW-1:0]), 
       .bw_4(bw_4), 
       .dout_4(rw_ifc_pkd.dout[DW-1:0]), 
       .read_vld_4(rw_ifc_pkd.read_vld[0]), 
       .read_serr_4(rw_ifc_pkd.read_serr[0]), 
       .read_derr_4(rw_ifc_pkd.read_derr[0]), 
       
       .read_5(rw_ifc_pkd.read[1]), 
       .write_5(rw_ifc_pkd.write[1]), 
       .addr_5(rw_ifc_pkd.addr[2*AW-1:AW]), 
       .din_5(rw_ifc_pkd.din[2*DW-1:DW]), 
       .bw_5(bw_5), 
       .dout_5(rw_ifc_pkd.dout[2*DW-1:DW]), 
       .read_vld_5(rw_ifc_pkd.read_vld[1]), 
       .read_serr_5(rw_ifc_pkd.read_serr[1]), 
       .read_derr_5(rw_ifc_pkd.read_derr[1]), 

       .cnt_6(c_ifc_pkd.cnt[0]), 
       .ct_adr_6(c_ifc_pkd.ct_adr[AW-1:0]), 
       .ct_imm_6(c_ifc_pkd.ct_imm[DW-1:0]), 
       .ct_vld_6(c_ifc_pkd.ct_vld[0]), 
       .ct_serr_6(c_ifc_pkd.ct_serr[0]), 
       .ct_derr_6(c_ifc_pkd.ct_derr[0]),
       
       .cnt_7(c_ifc_pkd.cnt[1]), 
       .ct_adr_7(c_ifc_pkd.ct_adr[2*AW-1:AW]), 
       .ct_imm_7(c_ifc_pkd.ct_imm[2*DW-1:DW]), 
       .ct_vld_7(c_ifc_pkd.ct_vld[1]), 
       .ct_serr_7(c_ifc_pkd.ct_serr[1]), 
       .ct_derr_7(c_ifc_pkd.ct_derr[1]),
       
       .ac_read_8(a_ifc_pkd.ac_read[0]), 
       .ac_write_8(a_ifc_pkd.ac_write[0]), 
       .ac_addr_8(a_ifc_pkd.ac_addr[AW-1:0]), 
       .ac_din_8(a_ifc_pkd.ac_din[DW-1:0]), 
       .ac_dout_8(a_ifc_pkd.ac_dout[DW-1:0]), 
       .ac_vld_8(a_ifc_pkd.ac_vld[0]), 
       .ac_serr_8(a_ifc_pkd.ac_serr[0]), 
       .ac_derr_8(a_ifc_pkd.ac_derr[0]), 
       
       .ac_read_9(a_ifc_pkd.ac_read[1]), 
       .ac_write_9(a_ifc_pkd.ac_write[1]), 
       .ac_addr_9(a_ifc_pkd.ac_addr[2*AW-1:AW]), 
       .ac_din_9(a_ifc_pkd.ac_din[2*DW-1:DW]), 
       .ac_dout_9(a_ifc_pkd.ac_dout[2*DW-1:DW]), 
       .ac_vld_9(a_ifc_pkd.ac_vld[1]), 
       .ac_serr_9(a_ifc_pkd.ac_serr[1]), 
       .ac_derr_9(a_ifc_pkd.ac_derr[1]), 
       
       .ru_read_10(ru_ifc_pkd.read[0]), 
       .ru_write_10(ru_ifc_pkd.write[0]), 
       .ru_addr_10(ru_ifc_pkd.addr[AW-1:0]), 
       .ru_din_10(ru_ifc_pkd.din[DW-1:0]), 
       .ru_bw_10(ru_bw_10), 
       .ru_dout_10(ru_ifc_pkd.dout[DW-1:0]), 
       .ru_vld_10(ru_ifc_pkd.read_vld[0]), 
       .ru_serr_10(ru_ifc_pkd.read_serr[0]), 
       .ru_derr_10(ru_ifc_pkd.read_derr[0]), 
       
       .ru_read_11(ru_ifc_pkd.read[1]), 
       .ru_write_11(ru_ifc_pkd.write[1]), 
       .ru_addr_11(ru_ifc_pkd.addr[2*AW-1:AW]), 
       .ru_din_11(ru_ifc_pkd.din[2*DW-1:DW]), 
       .ru_bw_11(ru_bw_11), 
       .ru_dout_11(ru_ifc_pkd.dout[2*DW-1:DW]), 
       .ru_vld_11(ru_ifc_pkd.read_vld[1]), 
       .ru_serr_11(ru_ifc_pkd.read_serr[1]), 
       .ru_derr_11(ru_ifc_pkd.read_derr[1])
       );

  testbench_program #(
                      .AW (AW),
                      .DW (DW),
                      .WORDS (IP_WORDS),
                      .LATENCY(IP_LATENCY),
                      .RESET_NEEDED(RESET_NEEDED),
                      .WAIT_FOR_READY(WAIT_FOR_READY),
                      .CHK_READ_VLD(CHK_READ_VLD),
                      .CHK_READ_ERR(CHK_READ_ERR),
                      .TOTAL_PORTS(NRP+NWP+NRWP+NCP+NAP+NRUP)
                      )
  p (
     .misc_ifc(misc_ifc), 
     .dbg_ifc(dbg_ifc), 
     .r_ifc_pkd(r_ifc_pkd), 
     .w_ifc_pkd(w_ifc_pkd), 
     .rw_ifc_pkd(rw_ifc_pkd),
     .c_ifc_pkd(c_ifc_pkd),
     .a_ifc_pkd(a_ifc_pkd),
     .ru_ifc_pkd(ru_ifc_pkd)
     );

endmodule
