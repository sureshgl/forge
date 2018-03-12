module core_nbor1u_1r1w_nocam 
(
  clk, rst, ready, disp_en, freeze,
  cpu_read, cpu_write, cpu_bnk, cpu_addr, cpu_din, cpu_dout, cpu_vld, 
  sr_en, sr_key, sr_dout, sr_vld, sr_match, sr_mhe,
  up_en, up_key, up_din, up_del, up_bp, 
  t1_readB, t1_addrB, t1_doutB, 
  t1_writeA, t1_addrA, t1_dinA
);
  parameter NUMSEPT = 1;

  parameter KYWIDTH = 32;
  parameter DTWIDTH = 32;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  //BITPBNK also includes FIFO
  parameter BITPBNK = 4;
  parameter MEM_DELAY = 2;
  parameter FLOPCRC=0;
  parameter FLOPDLF=1;

  parameter QSIZE = 5;
  parameter LG_QSIZE = 3;

  parameter PHWIDTH = KYWIDTH+DTWIDTH+1;
  parameter PLINE_DELAY = MEM_DELAY + FLOPDLF ;//+ FLOPCRC;
  parameter LG_PLINE_DELAY = (PLINE_DELAY<3 ? 1: (PLINE_DELAY<5 ? 2 : (PLINE_DELAY<9 ? 3 : (PLINE_DELAY<17 ? 4 : 5))));

  input clk, rst;
  output ready;
  input  disp_en, freeze;

  input cpu_read;
  input cpu_write;
  input [BITPBNK-1:0] cpu_bnk;
  input [BITVROW-1:0] cpu_addr;
  input [PHWIDTH-1:0] cpu_din;
  output[PHWIDTH-1:0] cpu_dout;
  output              cpu_vld;

  input  [NUMSEPT-1:0] sr_en;
  input  [NUMSEPT*KYWIDTH-1:0] sr_key;
  output [NUMSEPT*DTWIDTH-1:0] sr_dout;
  output [NUMSEPT-1:0] sr_vld;
  output [NUMSEPT-1:0] sr_match;
  output [NUMSEPT-1:0] sr_mhe;

  input  up_en;
  input  [KYWIDTH-1:0] up_key;
  input  [DTWIDTH-1:0] up_din;
  input  up_del;
  output up_bp;

  output [NUMSEPT*NUMVBNK-1:0] t1_readB;
  output [NUMSEPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  input  [NUMSEPT*NUMVBNK*PHWIDTH-1:0] t1_doutB;

  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*PHWIDTH-1:0] t1_dinA;
  
  
  //
  //Few accounting parameters
  //
  parameter MAX_RETRY = 1024;
  parameter LG_MAX_RETRY = 10;
  reg [LG_MAX_RETRY-1:0] retry_cnt;
  
  //
  //Getting CRC CalC Module
  //
  reg [KYWIDTH-1:0] crc_key_arr [0:NUMSEPT-1];
  wire [BITVROW-1:0] crc_res [0:NUMSEPT-1][0:NUMVBNK-1];
  genvar crcg;
  generate for(crcg=0; crcg<NUMSEPT; crcg=crcg+1) begin : hash
    if(NUMVBNK>0)crc_calc #(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(0))crc_calc_0 (.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][0]));
    if(NUMVBNK>1)crc_calc #(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(1))crc_calc_1 (.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][1]));
    if(NUMVBNK>2)crc_calc #(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(2))crc_calc_2 (.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][2]));
    if(NUMVBNK>3)crc_calc #(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(3))crc_calc_3 (.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][3]));
    if(NUMVBNK>4)crc_calc #(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(4))crc_calc_4 (.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][4]));
    if(NUMVBNK>5)crc_calc #(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(5))crc_calc_5 (.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][5]));
    if(NUMVBNK>6)crc_calc #(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(6))crc_calc_6 (.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][6]));
    if(NUMVBNK>7)crc_calc #(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(7))crc_calc_7 (.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][7]));
    if(NUMVBNK>8)crc_calc #(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(8))crc_calc_8 (.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][8]));
    if(NUMVBNK>9)crc_calc #(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(9))crc_calc_9 (.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][9]));
    if(NUMVBNK>10)crc_calc#(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(10))crc_calc_10(.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][10]));
    if(NUMVBNK>11)crc_calc#(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(11))crc_calc_11(.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][11]));
    if(NUMVBNK>12)crc_calc#(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(12))crc_calc_12(.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][12]));
    if(NUMVBNK>13)crc_calc#(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(13))crc_calc_13(.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][13]));
    if(NUMVBNK>14)crc_calc#(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(14))crc_calc_14(.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][14]));
    if(NUMVBNK>15)crc_calc#(.KEYWIDTH(KYWIDTH),.CRCWIDTH(BITVROW),.FLOPCRC(FLOPCRC),.CRCPOLYID(15))crc_calc_15(.clk(clk),.key(crc_key_arr[crcg]),.result(crc_res[crcg][15]));
  end
  endgenerate
  
  //
  //Queue Structures.
  //Its not a queue anymore. Its more like 2R2W CAM. Valid bit tracks valid and free slots.
  //
  reg               fifo_vld  [0:QSIZE-1];
  reg [KYWIDTH-1:0] fifo_key  [0:QSIZE-1];
  reg [DTWIDTH-1:0] fifo_dat  [0:QSIZE-1];
  reg               fifo_del  [0:QSIZE-1];
  
  reg               fifo_vld_nxt [0:QSIZE-1];
  reg [LG_QSIZE:0]  fifo_cnt;

  //Pop interface
  wire po_en;

  //Push Interfaces
  //Hi Prio is for incoming updates
  //Low prio for either failed update or displacements
  wire pu_hi_en, pu_lo_en;
  wire [KYWIDTH-1:0] pu_hi_key, pu_lo_key;
  wire [DTWIDTH-1:0] pu_hi_dat, pu_lo_dat;
  wire pu_hi_del, pu_lo_del;

  //Actual push pop
  wire pu1_en = pu_hi_en || pu_lo_en;
  wire [KYWIDTH-1:0] pu1_key = pu_hi_en ? pu_hi_key : pu_lo_key;
  wire [DTWIDTH-1:0] pu1_dat = pu_hi_en ? pu_hi_dat : pu_lo_dat;
  wire               pu1_del = pu_hi_en ? pu_hi_del : pu_lo_del;
  wire pu2_en = pu_hi_en && pu_lo_en;
  wire [KYWIDTH-1:0] pu2_key = pu_lo_key;
  wire [DTWIDTH-1:0] pu2_dat = pu_lo_dat;
  wire pu2_del = pu_lo_del;

  integer fifo_int;
  always @(posedge clk) begin
    for(fifo_int=0; fifo_int<QSIZE;fifo_int=fifo_int+1) begin
      if(!ready) fifo_vld[fifo_int] <= 0;
      else begin
        if(fifo_int < (fifo_cnt-po_en)) begin
          fifo_vld[fifo_int] <= fifo_vld_nxt[fifo_int+po_en];
          fifo_key[fifo_int] <= fifo_key[fifo_int+po_en];
          fifo_dat[fifo_int] <= fifo_dat[fifo_int+po_en];
          fifo_del[fifo_int] <= fifo_del[fifo_int+po_en];
        end
        else if(fifo_int == (fifo_cnt-po_en)) begin
            fifo_vld[fifo_int] <= pu1_en;
            fifo_key[fifo_int] <= pu1_key;
            fifo_dat[fifo_int] <= pu1_dat;
            fifo_del[fifo_int] <= pu1_del;
        end
        else if(fifo_int == (fifo_cnt-po_en+1)) begin
            fifo_vld[fifo_int] <= pu2_en;
            fifo_key[fifo_int] <= pu2_key;
            fifo_dat[fifo_int] <= pu2_dat;
            fifo_del[fifo_int] <= pu2_del;
        end
      end
    end
  end

  always @(posedge clk)
    if(rst) fifo_cnt <= 0;
    else fifo_cnt <= fifo_cnt - po_en + pu1_en + pu2_en;

  //Invalidate all matching entries for hi pri updates(only one at max)
  integer puh_int;
  always_comb 
    for(puh_int=0; puh_int<QSIZE; puh_int=puh_int+1) 
      fifo_vld_nxt[puh_int] = fifo_vld[puh_int] & (!pu_hi_en | (fifo_key[puh_int] != pu_hi_key));

  //Two Search Interfaces.
  //One for current update (if it fails)
  //Another for displacements
  wire fcm_en, fdm_en;
  wire [KYWIDTH-1:0] fcm_key, fdm_key;
  reg fcm_hit, fdm_hit;
  integer fm_int;
  always_comb begin
    fcm_hit=0; fdm_hit=0;
    for(fm_int=0;fm_int<QSIZE;fm_int=fm_int+1) begin
      if(fcm_en && fm_int != 0) fcm_hit = fcm_hit | (fifo_vld[fm_int] & (fifo_key[fm_int] == fcm_key));
      if(fdm_en) fdm_hit = fdm_hit | (fifo_vld[fm_int] & (fifo_key[fm_int] == fdm_key));
    end
  end

  
  //Search Forward from Queue
  reg sr_q_en [0:NUMSEPT-1];
  reg [KYWIDTH-1:0] sr_q_key[0:NUMSEPT-1];
  reg sr_q_hit[0:NUMSEPT-1];
  reg sr_q_del[0:NUMSEPT-1];
  reg [DTWIDTH-1:0] sr_q_dat[0:NUMSEPT-1];
  reg srqg_match [0:NUMSEPT-1] [0:QSIZE-1];
  integer  srqgen, srqgen2, srqg_mi, srqg_int;
  always_comb 
    for(srqgen=0;srqgen<NUMSEPT;srqgen=srqgen+1) 
      for(srqg_mi=0;srqg_mi<QSIZE;srqg_mi=srqg_mi+1)
        srqg_match[srqgen][srqg_mi] = sr_q_en[srqgen] & fifo_vld[srqg_mi] & (fifo_key[srqg_mi] == sr_q_key[srqgen]);
    
  always_comb begin
    for(srqgen2=0;srqgen2<NUMSEPT;srqgen2=srqgen2+1) begin
      sr_q_hit[srqgen2] =0; sr_q_del[srqgen2]=0; sr_q_dat[srqgen2]={DTWIDTH{1'b0}};
      for(srqg_int=0;srqg_int<QSIZE;srqg_int=srqg_int+1) 
        if(srqg_match[srqgen2][srqg_int]) begin
          sr_q_hit[srqgen2] = sr_q_hit[srqgen2] | 1'b1;
          sr_q_del[srqgen2] = sr_q_del[srqgen2] | fifo_del[srqg_int];
          sr_q_dat[srqgen2] = sr_q_dat[srqgen2] | fifo_dat[srqg_int];
        end
    end
  end

  //Update from FIFO

  wire               up_f_en;
  wire [KYWIDTH-1:0] up_f_key;
  wire [DTWIDTH-1:0] up_f_dat;
  wire               up_f_del;
  
  //
  // END OF FIFO OPS
  //

  //
  // Delaying all input signals in flopcrc
  //
  reg [KYWIDTH-1:0] sr_key_arr [0:NUMSEPT-1];
  reg               sr_en_arr [0:NUMSEPT-1];
  integer srk_int;
  always_comb 
    for(srk_int=0;srk_int<NUMSEPT; srk_int=srk_int+1) begin
      sr_key_arr[srk_int] = sr_key >> (srk_int*KYWIDTH);
      sr_en_arr[srk_int]  = sr_en  >> (srk_int*1);
    end
  
  //
  //FLOPCRC Handling
  //
  wire [NUMSEPT-1:0]         sr_en_wire;  
  wire [KYWIDTH*NUMSEPT-1:0] sr_key_wire; 
  wire               up_en_wire;
  wire [KYWIDTH-1:0] up_key_wire;
  wire [DTWIDTH-1:0] up_din_wire;
  wire               up_del_wire;
  wire               up_f_en_wire;
  wire [KYWIDTH-1:0] up_f_key_wire;
  wire [DTWIDTH-1:0] up_f_dat_wire;
  wire               up_f_del_wire;
  wire               cpu_read_wire;
  wire               cpu_write_wire;
  wire [BITPBNK-1:0] cpu_bnk_wire;
  wire [BITVROW-1:0] cpu_addr_wire;
  wire [PHWIDTH-1:0] cpu_din_wire;
   
  generate 
    if(FLOPCRC) begin : flcrc
      reg [NUMSEPT-1:0]         sr_en_fcrc;  
      reg [KYWIDTH*NUMSEPT-1:0] sr_key_fcrc; 
      reg               up_en_fcrc;
      reg [KYWIDTH-1:0] up_key_fcrc;
      reg [DTWIDTH-1:0] up_din_fcrc;
      reg               up_del_fcrc;
      reg               up_f_en_fcrc;
      reg [KYWIDTH-1:0] up_f_key_fcrc;
      reg [DTWIDTH-1:0] up_f_dat_fcrc;
      reg               up_f_del_fcrc;
      reg               cpu_read_fcrc;
      reg               cpu_write_fcrc;
      reg [BITPBNK-1:0] cpu_bnk_fcrc;
      reg [BITVROW-1:0] cpu_addr_fcrc;
      reg [PHWIDTH-1:0] cpu_din_fcrc;
      always @(posedge clk) begin
        if(!ready) begin
          sr_en_fcrc <= 0;
          up_en_fcrc <= 0;
          up_f_en_fcrc <= 0;
          cpu_read_fcrc <= 0;
          cpu_write_fcrc <= 0;
        end
        else begin 
          sr_en_fcrc <= sr_en;
          sr_key_fcrc <= sr_key;
          up_en_fcrc <= up_en;
          up_key_fcrc <= up_key;
          up_din_fcrc <= up_din;
          up_del_fcrc <= up_del;
          up_f_en_fcrc <= up_f_en;
          up_f_key_fcrc <= up_f_key;
          up_f_dat_fcrc <= up_f_dat;
          up_f_del_fcrc <= up_f_del;
          cpu_read_fcrc <= cpu_read;
          cpu_write_fcrc <= cpu_write;
          cpu_bnk_fcrc <= cpu_bnk;
          cpu_addr_fcrc <= cpu_addr;
          cpu_din_fcrc <= cpu_din;
        end
      end
      assign sr_en_wire = sr_en_fcrc;
      assign sr_key_wire = sr_key_fcrc;
      assign up_en_wire = up_en_fcrc;
      assign up_key_wire = up_key_fcrc;
      assign up_din_wire = up_din_fcrc;
      assign up_del_wire = up_del_fcrc;
      assign up_f_en_wire = up_f_en_fcrc;
      assign up_f_key_wire = up_f_key_fcrc;
      assign up_f_dat_wire = up_f_dat_fcrc;
      assign up_f_del_wire = up_f_del_fcrc;
      assign cpu_read_wire = cpu_read_fcrc;
      assign cpu_write_wire = cpu_write_fcrc;
      assign cpu_bnk_wire = cpu_bnk_fcrc;
      assign cpu_addr_wire = cpu_addr_fcrc;
      assign cpu_din_wire = cpu_din_fcrc;
    end
    if(!FLOPCRC) begin :no_flcrc
      assign sr_en_wire = sr_en;
      assign sr_key_wire = sr_key;
      assign up_en_wire = up_en;
      assign up_key_wire = up_key;
      assign up_din_wire = up_din;
      assign up_del_wire = up_del;
      assign up_f_en_wire = up_f_en;
      assign up_f_key_wire = up_f_key;
      assign up_f_dat_wire = up_f_dat;
      assign up_f_del_wire = up_f_del;
      assign cpu_read_wire = cpu_read;
      assign cpu_write_wire = cpu_write;
      assign cpu_bnk_wire = cpu_bnk;
      assign cpu_addr_wire = cpu_addr;
      assign cpu_din_wire = cpu_din;
    end
  endgenerate

  //
  //Stitching CRC Input
  //
  integer crc_int;
  always_comb
    for(crc_int=0;crc_int<NUMSEPT;crc_int=crc_int+1) 
      crc_key_arr[crc_int]  = (crc_int ==0 && up_f_en) ? up_f_key : sr_key_arr[crc_int];
  
  //
  //Stitching CRC output
  //
  reg [BITVROW-1:0] up_hash [0:NUMVBNK-1];
  integer crco_int;
  always_comb
    for(crco_int=0;crco_int<NUMVBNK;crco_int=crco_int+1) 
      up_hash[crco_int] = crc_res[0][crco_int];

  //
  // Array Expansion of T1 bus
  //
  reg [PHWIDTH-1:0] t1_doutB_arr [0:NUMSEPT-1][0:NUMVBNK-1];

  reg [KYWIDTH-1:0] t1_doutB_key [0:NUMSEPT-1][0:NUMVBNK-1];
  reg [DTWIDTH-1:0] t1_doutB_data [0:NUMSEPT-1][0:NUMVBNK-1];
  reg t1_doutB_vld [0:NUMSEPT-1][0:NUMVBNK-1];
  integer t1do_si, t1do_bi;
  always_comb begin
    for(t1do_si=0; t1do_si<NUMSEPT; t1do_si = t1do_si+1) begin
      for(t1do_bi=0; t1do_bi<NUMVBNK; t1do_bi=t1do_bi+1) begin
        t1_doutB_arr[t1do_si][t1do_bi] = t1_doutB >> (t1do_si*NUMVBNK*PHWIDTH+t1do_bi*PHWIDTH);
        t1_doutB_key[t1do_si][t1do_bi] = t1_doutB_arr[t1do_si][t1do_bi];
        t1_doutB_data[t1do_si][t1do_bi] = t1_doutB_arr[t1do_si][t1do_bi] >> KYWIDTH;
        t1_doutB_vld[t1do_si][t1do_bi] = t1_doutB_arr[t1do_si][t1do_bi][KYWIDTH+DTWIDTH];
      end
    end
  end
  
  //
  //Queue next update Logic
  //
  wire sr_idle = !(|sr_en);
  reg[LG_PLINE_DELAY:0]  up_nxt_id;
  assign up_f_en = !freeze  & !cpu_read & !cpu_write  & sr_idle & (up_nxt_id < fifo_cnt) & (|retry_cnt);
  assign up_f_key = fifo_key[up_nxt_id];
  assign up_f_dat = fifo_dat[up_nxt_id];
  assign up_f_del = fifo_del[up_nxt_id];
  always @(posedge clk)
    if(!ready) up_nxt_id <= 0;
    else if(up_nxt_id ==0 && !up_f_en) up_nxt_id <= 0;
    else up_nxt_id <= up_nxt_id -po_en + up_f_en; 
  
  //
  //Retry Accounting Logic.
  //
  always @(posedge clk) begin
    if(!ready || up_en) retry_cnt <= MAX_RETRY-1;
    else if(up_f_en && retry_cnt>0) retry_cnt <= retry_cnt -1;
  end

  //
  //PipeLine Structures.
  //
  reg [NUMSEPT-1:0] sr_en_dly [0:MEM_DELAY-1];
  reg [NUMSEPT*KYWIDTH-1:0] sr_key_dly [0:MEM_DELAY-1];
  integer spline_int;
  always @(posedge clk) begin 
    for(spline_int=0; spline_int<MEM_DELAY; spline_int = spline_int+1) begin 
      if(!ready) begin
        sr_en_dly[spline_int] <= 0;
      end
      else if(spline_int ==0) begin
        sr_en_dly[spline_int]  <= sr_en_wire;
        sr_key_dly[spline_int] <= sr_key_wire;
      end
      else begin
        sr_en_dly[spline_int]  <= sr_en_dly[spline_int-1];
        sr_key_dly[spline_int] <= sr_key_dly[spline_int-1];
      end
    end
  end

  reg               up_en_dly   [0:PLINE_DELAY-1];
  reg [KYWIDTH-1:0] up_key_dly  [0:PLINE_DELAY-1];
  reg [BITVROW-1:0] up_hash_dly [0:NUMVBNK-1][0:PLINE_DELAY-1];
  reg               cpu_write_dly [0:PLINE_DELAY-1];
  reg [BITPBNK-1:0] cpu_bnk_dly  [0:PLINE_DELAY-1];
  reg [BITVROW-1:0] cpu_addr_dly  [0:PLINE_DELAY-1];
  reg [PHWIDTH-1:0] cpu_din_dly   [0:PLINE_DELAY-1];
  integer pline_int,pline_bnk;
  always @(posedge clk) begin 
    for(pline_int=0; pline_int<PLINE_DELAY; pline_int = pline_int+1) begin : pline_loop
      if(!ready) begin
        up_en_dly[pline_int] <= 0;
        cpu_write_dly[pline_int]<= 0;
      end
      else if(pline_int ==0) begin
        up_en_dly[pline_int]  <= up_f_en_wire;
        up_key_dly[pline_int]  <= up_f_key_wire;
        for(pline_bnk=0;pline_bnk<NUMVBNK;pline_bnk=pline_bnk+1) up_hash_dly[pline_bnk][pline_int] <= up_hash[pline_bnk];
        cpu_write_dly[pline_int] <= cpu_write_wire;
        cpu_addr_dly[pline_int] <= cpu_addr_wire;
        cpu_bnk_dly[pline_int] <= cpu_bnk_wire;
        cpu_din_dly[pline_int] <= cpu_din_wire;
      end
      else begin
        up_en_dly[pline_int]  <= up_en_dly[pline_int-1];
        up_key_dly[pline_int]  <= up_key_dly[pline_int-1];
        for(pline_bnk=0;pline_bnk<NUMVBNK;pline_bnk=pline_bnk+1)  up_hash_dly[pline_bnk][pline_int] <= up_hash_dly[pline_bnk][pline_int-1];
        cpu_write_dly[pline_int] <= cpu_write_dly[pline_int-1];
        cpu_addr_dly[pline_int] <= cpu_addr_dly[pline_int-1];
        cpu_bnk_dly[pline_int] <= cpu_bnk_dly[pline_int-1];
        cpu_din_dly[pline_int] <= cpu_din_dly[pline_int-1];
      end
    end
  end



  //
  //Update DS
  //
  wire udlf_hit;
  wire up_disp_hit;
  wire up_cur_hit = udlf_hit || up_disp_hit;
  reg [BITVBNK-1:0] up_cur_bnk; 
  
  //
  // Update Lookahead
  //
  reg ula_vld [0:NUMVBNK-1][0:PLINE_DELAY-1];
  reg [BITVROW-1:0] ula_row [0:NUMVBNK-1][0:PLINE_DELAY-1];
  integer uld_int, ulb_int;
  always @(posedge clk) begin
    for(uld_int =0; uld_int< PLINE_DELAY; uld_int=uld_int+1) begin
      for(ulb_int =0; ulb_int< NUMVBNK;   ulb_int=ulb_int+1) begin
        if(!ready) begin
          ula_vld[ulb_int][uld_int] <= 0;
        end
        else if(uld_int ==0) begin
          ula_vld[ulb_int][uld_int] <= up_cur_hit && (up_cur_bnk == ulb_int);
          ula_row[ulb_int][uld_int] <= up_hash_dly[ulb_int][PLINE_DELAY-1];
        end
        else begin
          ula_vld[ulb_int][uld_int] <= ula_vld[ulb_int][uld_int-1];
          ula_row[ulb_int][uld_int] <= ula_row[ulb_int][uld_int-1];
        end
      end
    end
  end


  //
  //Update Lookahead check per bank
  //
  reg ula_cur_block [0:NUMVBNK-1];
  integer ulcb_int, ulcd_int;
  always_comb begin 
    for(ulcb_int=0;ulcb_int<NUMVBNK; ulcb_int=ulcb_int+1) begin
      ula_cur_block[ulcb_int] =0;
      for(ulcd_int=0; ulcd_int < PLINE_DELAY; ulcd_int=ulcd_int+1) 
        ula_cur_block[ulcb_int] = ula_cur_block[ulcb_int] |  (ula_vld[ulcb_int][ulcd_int] && up_hash_dly[ulcb_int][MEM_DELAY-1] == ula_row[ulcb_int][ulcd_int]);
      if(FLOPDLF && up_cur_hit && ulcb_int == up_cur_bnk) ula_cur_block[ulcb_int] = ula_cur_block[ulcb_int] | (up_hash_dly[ulcb_int][MEM_DELAY-1] == up_hash_dly[ulcb_int][PLINE_DELAY-1]);
    end
  end
 
  //
  //Displacement bank.
  //
  reg [BITVBNK-1:0] disp_bnk;
  always @(posedge clk)
    if(!ready) disp_bnk <= 0;
    else if(disp_bnk == NUMVBNK-1) disp_bnk <=0;
    else disp_bnk <= disp_bnk+1;

  wire [KYWIDTH-1:0] disp_key  = t1_doutB_key[0][disp_bnk];
  wire [DTWIDTH-1:0] disp_dat  = t1_doutB_data[0][disp_bnk];
  wire               disp_del  = !t1_doutB_vld[0][disp_bnk];
  
  wire [BITVBNK-1:0] disp_bnk_wire;
  wire [KYWIDTH-1:0] disp_key_wire;  
  wire [DTWIDTH-1:0] disp_dat_wire;
  wire               disp_del_wire;

  generate if(FLOPDLF) begin :fldlf
    reg [BITVBNK-1:0] disp_bnk_reg;  
    reg [KYWIDTH-1:0] disp_key_reg;  
    reg [DTWIDTH-1:0] disp_dat_reg;
    reg               disp_del_reg;
    always @(posedge clk) begin
      disp_bnk_reg <= disp_bnk;
      disp_key_reg <= disp_key;
      disp_dat_reg <= disp_dat;
      disp_del_reg <= disp_del;
    end
    assign disp_bnk_wire = disp_bnk_reg;
    assign disp_key_wire = disp_key_reg;
    assign disp_dat_wire = disp_dat_reg;
    assign disp_del_wire = disp_del_reg;
  end
  if(!FLOPDLF) begin :no_fldlf
    assign disp_bnk_wire = disp_bnk;
    assign disp_key_wire = disp_key;
    assign disp_dat_wire = disp_dat;
    assign disp_del_wire = disp_del;
  end
  endgenerate

  wire [KYWIDTH-1:0] cur_key = fifo_key[0];//up_key_dly[PLINE_DELAY-1];
  wire [DTWIDTH-1:0] cur_dat = fifo_dat[0];//up_dat_dly[PLINE_DELAY-1];
  wire               cur_del = fifo_del[0];//up_del_dly[PLINE_DELAY-1];
  
  wire         cur_up_match   = up_en_wire ? (up_key_wire == cur_key)  :0;
  wire         disp_up_match  = up_en_wire ? (up_key_wire == disp_key_wire) :0;

  //Cur Update
  wire               cur_en  = up_en_dly [PLINE_DELAY-1] & fifo_vld[0] & !cur_up_match;

  // Killing low prio push  if it matches incoming update

  //POP
  assign po_en = up_en_dly[PLINE_DELAY-1];

  //
  // Hi Prio Push
  //
  assign pu_hi_en = up_en_wire;
  assign pu_hi_key = up_key_wire;
  assign pu_hi_dat = up_din_wire;
  assign pu_hi_del = up_del_wire;

  //
  //Low Prio Push
  //
  assign fcm_en = 1; 
  assign fdm_en = 1;
  assign fcm_key = cur_key;
  assign fdm_key = disp_key_wire;
  
  wire disp_pu = up_disp_hit & !disp_up_match & !fdm_hit;
  wire fail_pu = cur_en & !up_cur_hit & !cur_up_match & !fcm_hit;

  assign pu_lo_en = disp_pu || fail_pu;
  assign pu_lo_key = disp_pu ? disp_key_wire : cur_key;
  assign pu_lo_dat = disp_pu ? disp_dat_wire : cur_dat;
  assign pu_lo_del = disp_pu ? disp_del_wire : cur_del;

  assign up_bp = (fifo_cnt > QSIZE-2);
  
  //
  // Actual Update Handling.
  //
  
  //dout_key_match
  reg [NUMVBNK-1:0] bnk_dout_match;
  integer bdm_int;
  always_comb 
    for(bdm_int=0; bdm_int<NUMVBNK; bdm_int=bdm_int+1)
      bnk_dout_match[bdm_int] = (t1_doutB_vld[0][bdm_int] && (t1_doutB_key[0][bdm_int] == up_key_dly[MEM_DELAY-1]) && !ula_cur_block[bdm_int]);

  //dout_free_match
  reg [NUMVBNK-1:0] bnk_free_match;
  integer bfm_int;
  always_comb
    for(bfm_int=0; bfm_int<NUMVBNK; bfm_int=bfm_int+1)
      bnk_free_match[bfm_int] = (!t1_doutB_vld[0][bfm_int] && !ula_cur_block[bfm_int]);

  //
  // Current Update Handling
  //
  wire disp_ula_blk = ula_cur_block[disp_bnk];
  wire [BITVBNK-1:0] udlf_free_bnk,  udlf_match_bnk; 
  wire udlf_free_hit, udlf_match_hit;
  
  priority_encode_id #(.NUMENTRY(NUMVBNK), .BITENTRY(BITVBNK)) 
  pe_match (.global_en(1'b1), .enables(bnk_dout_match), .hit(udlf_match_hit), .hit_id(udlf_match_bnk)); 
  priority_encode_id #(.NUMENTRY(NUMVBNK), .BITENTRY(BITVBNK)) 
  pe_free (.global_en(1'b1), .enables(bnk_free_match), .hit(udlf_free_hit), .hit_id(udlf_free_bnk)); 
  
  wire [BITVBNK-1:0] udlf_free_bnk_wire, udlf_match_bnk_wire; 
  wire udlf_free_hit_wire, udlf_match_hit_wire, disp_ula_blk_wire;
  generate if(FLOPDLF) begin : fldlf2
    reg [BITVBNK-1:0] udlf_free_bnk_reg, udlf_match_bnk_reg; 
    reg udlf_free_hit_reg,  udlf_match_hit_reg, disp_ula_blk_reg;
    always @(posedge clk) begin
      if(!ready) begin
        udlf_free_hit_reg <= 0;
        udlf_match_hit_reg <= 0;
        disp_ula_blk_reg <= 0;
      end
      else begin
        udlf_free_bnk_reg <= udlf_free_bnk;
        udlf_match_bnk_reg <= udlf_match_bnk;
        udlf_free_hit_reg <= udlf_free_hit;
        udlf_match_hit_reg <= udlf_match_hit;
        disp_ula_blk_reg <= disp_ula_blk;
      end
    end
    assign udlf_free_bnk_wire = udlf_free_bnk_reg;
    assign udlf_match_bnk_wire = udlf_match_bnk_reg;
    assign udlf_free_hit_wire = udlf_free_hit_reg;
    assign udlf_match_hit_wire = udlf_match_hit_reg;
    assign disp_ula_blk_wire = disp_ula_blk_reg;
  end
  if(!FLOPDLF) begin : no_fldlf2
    assign udlf_free_bnk_wire = udlf_free_bnk;
    assign udlf_match_bnk_wire = udlf_match_bnk;
    assign udlf_free_hit_wire = udlf_free_hit;
    assign udlf_match_hit_wire = udlf_match_hit;
    assign disp_ula_blk_wire = disp_ula_blk;
  end
  endgenerate


  assign udlf_hit     = cur_en & (udlf_free_hit_wire | udlf_match_hit_wire);
  assign up_disp_hit  = cur_en & disp_en & !disp_ula_blk_wire  & !udlf_hit;
  assign up_cur_bnk   = udlf_match_hit_wire ? udlf_match_bnk_wire : (udlf_free_hit_wire ? udlf_free_bnk_wire : disp_bnk_wire);

  //
  //End of update handling.
  //
  
  //
  //Search the queue
  //
  integer srq_int;
  always_comb begin
    for(srq_int=0; srq_int<NUMSEPT; srq_int=srq_int+1) begin
      sr_q_en[srq_int] = sr_en_wire[srq_int];
      sr_q_key[srq_int] = sr_key_wire >> (srq_int*KYWIDTH);
    end
  end

  //
  // Get search result from queue or pipeline, and delay them.
  //
  reg               sr_found_dly[0:NUMSEPT-1][0:MEM_DELAY-1];
  reg [DTWIDTH-1:0] sr_dout_dly [0:NUMSEPT-1][0:MEM_DELAY-1];
  reg               sr_match_dly[0:NUMSEPT-1][0:MEM_DELAY-1];
  integer spd_int, pld_int;
  always @(posedge clk)
    for(spd_int=0; spd_int < NUMSEPT; spd_int = spd_int+1)
      for(pld_int=0; pld_int < MEM_DELAY; pld_int = pld_int+1)
        if(!ready) begin
          sr_found_dly[spd_int][pld_int] <= 0;
          sr_dout_dly[spd_int][pld_int]  <= 0;
          sr_match_dly[spd_int][pld_int] <= 0;
        end
        else if(pld_int ==0) begin
          sr_found_dly[spd_int][pld_int] <= sr_q_hit[spd_int];
          sr_dout_dly[spd_int][pld_int]  <= sr_q_dat[spd_int];
          sr_match_dly[spd_int][pld_int] <= !sr_q_del[spd_int]; 
        end
        else begin
          sr_found_dly[spd_int][pld_int] <= sr_found_dly[spd_int][pld_int-1];
          sr_dout_dly[spd_int][pld_int]  <= sr_dout_dly[spd_int][pld_int-1];
          sr_match_dly[spd_int][pld_int] <= sr_match_dly[spd_int][pld_int-1];
        end
  
  //
  //CPU Read Pipeline
  //
  wire cpu_faddr_wire = cpu_addr_wire[LG_QSIZE-1:0];
  wire cpu_fread_wire = cpu_read_wire & (cpu_bnk_wire == NUMVBNK);
  reg               cpu_read_dly  [0:MEM_DELAY-1];
  reg               cpu_fread_dly [0:MEM_DELAY-1];
  reg [PHWIDTH-1:0] cpu_fdout_dly [0:MEM_DELAY-1];
  integer crp_int;
  always @(posedge clk)
    for(crp_int=0;crp_int<MEM_DELAY;crp_int=crp_int+1) 
      if(!ready) begin
        cpu_read_dly[crp_int] <= 0;
        cpu_fread_dly[crp_int] <=0;
      end
      else if(crp_int == 0) begin
        cpu_read_dly[crp_int] <= cpu_read_wire & (cpu_bnk_wire <= NUMVBNK);
        cpu_fread_dly[crp_int] <= cpu_fread_wire;
        cpu_fdout_dly[crp_int] <=  {!fifo_del[cpu_faddr_wire], fifo_dat[cpu_faddr_wire], fifo_key[cpu_faddr_wire]};
      end
      else begin
        cpu_read_dly[crp_int] <= cpu_read_dly[crp_int-1];
        cpu_fread_dly[crp_int] <= cpu_fread_dly[crp_int-1];
        cpu_fdout_dly[crp_int] <= cpu_fdout_dly[crp_int-1];
      end

  //
  // Connecting calculated Hashes to memories.
  //
  reg [NUMVBNK-1:0] t1_readB_reg [0:NUMSEPT-1];
  reg [NUMVBNK*BITVROW-1:0] t1_addrB_reg [0:NUMSEPT-1];
  integer t1rp_int,t1ra_int;
  always_comb begin
    for(t1rp_int=0; t1rp_int<NUMSEPT; t1rp_int = t1rp_int+1) begin
      t1_readB_reg[t1rp_int] = 0;
      t1_addrB_reg[t1rp_int] = 0;
    end
    if(cpu_read_wire) begin
      if(cpu_bnk_wire < NUMVBNK) t1_readB_reg[0][cpu_bnk_wire] = 1'b1;
      for(t1ra_int=0; t1ra_int<NUMVBNK; t1ra_int = t1ra_int+1)
        t1_addrB_reg[0] = t1_addrB_reg[0] | (cpu_addr_wire[BITVROW-1:0] << t1ra_int*BITVROW);
    end
    else if (up_f_en_wire) begin
      t1_readB_reg[0] = ~0;
      for(t1ra_int=0; t1ra_int<NUMVBNK; t1ra_int = t1ra_int+1)
        t1_addrB_reg[0] = t1_addrB_reg[0] | (up_hash[t1ra_int] << t1ra_int*BITVROW);
    end
    else begin
      for(t1rp_int=0; t1rp_int<NUMSEPT; t1rp_int = t1rp_int+1) begin
        t1_readB_reg[t1rp_int] = {NUMVBNK{sr_en_wire[t1rp_int]}};
        for(t1ra_int=0; t1ra_int<NUMVBNK; t1ra_int = t1ra_int+1)
          t1_addrB_reg[t1rp_int] = t1_addrB_reg[t1rp_int] | (crc_res[t1rp_int][t1ra_int] << t1ra_int*BITVROW);
      end
    end
  end
  
  reg [NUMSEPT*NUMVBNK-1:0] t1_readB;
  reg [NUMSEPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  integer t1r_int;
  always_comb begin
    t1_readB = 0;
    t1_addrB = 0;
    for(t1r_int=0; t1r_int<NUMSEPT; t1r_int=t1r_int+1) begin
      t1_readB = t1_readB | (t1_readB_reg[t1r_int] << t1r_int*NUMVBNK);
      t1_addrB = t1_addrB | (t1_addrB_reg[t1r_int] << t1r_int*NUMVBNK*BITVROW);
    end
  end
  

  //
  // Reset Handling (need to clear out bits)
  //
  reg rst_start;
  reg [BITVROW-1:0] rst_row;
  always @(posedge clk) begin
    if(rst) begin 
      rst_start <= 1;
      rst_row <= 0;
    end
    else if(rst_start) begin
      if(rst_row == NUMVROW-1) rst_start <= 0;
      else rst_row <= rst_row+1;
    end
  end
  assign ready = !rst_start;
  
  //
  // Write to type1
  //
  reg [NUMVBNK-1:0] t1_writeA;
  reg [NUMVBNK*BITVROW-1:0] t1_addrA;
  reg [NUMVBNK*PHWIDTH-1:0] t1_dinA;
  integer upwr_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA=0;
    t1_dinA=0;
    if(!rst)
    if(!ready) begin
      t1_writeA = ~0;
      t1_addrA = {NUMVBNK{rst_row}};
      t1_dinA = 0;
    end
    else begin
      for(upwr_int =0; upwr_int<NUMVBNK; upwr_int=upwr_int+1) begin
        if(cpu_write_dly[PLINE_DELAY-1]) begin
          if(upwr_int == cpu_bnk_dly[PLINE_DELAY-1]) t1_writeA = t1_writeA | (1'b1 << upwr_int);
          t1_addrA = t1_addrA | (cpu_addr_dly[PLINE_DELAY-1] << upwr_int*BITVROW);
          t1_dinA = t1_dinA   | ( cpu_din_dly[PLINE_DELAY-1] << upwr_int* PHWIDTH);
        end
        else if(up_cur_hit) begin
          if(upwr_int == up_cur_bnk) t1_writeA = t1_writeA | (1'b1 << upwr_int);
          t1_addrA = t1_addrA | (up_hash_dly[upwr_int][PLINE_DELAY-1] << upwr_int*BITVROW);
          t1_dinA = t1_dinA | ({!cur_del, cur_dat, cur_key} << upwr_int* PHWIDTH);
        end
      end
    end
  end

  //
  // Search from Banks
  //
  reg sr_bnk_hit [0:NUMSEPT-1];
  reg [BITVBNK-1:0] sr_bnk [0:NUMSEPT-1];
  reg [NUMSEPT-1:0] sr_bnk_mhe ;
  
  reg [NUMVBNK-1:0] sr_bnk_match [0:NUMSEPT-1];
  reg [DTWIDTH*NUMVBNK-1:0] sr_bnk_data [0:NUMSEPT-1];
  integer srbm_pi, srbm_bi;
  always_comb
    for(srbm_pi=0; srbm_pi<NUMSEPT; srbm_pi=srbm_pi+1) begin
      sr_bnk_data[srbm_pi] = 0;
      for(srbm_bi=0; srbm_bi<NUMVBNK; srbm_bi = srbm_bi+1) begin
        sr_bnk_match[srbm_pi][srbm_bi] = t1_doutB_vld[srbm_pi][srbm_bi] && (t1_doutB_key[srbm_pi][srbm_bi] == (sr_key_dly[MEM_DELAY-1] >>  KYWIDTH*srbm_pi));
        sr_bnk_data[srbm_pi] = sr_bnk_data[srbm_pi] | (t1_doutB_data[srbm_pi][srbm_bi] << (DTWIDTH*srbm_bi));
      end
    end
  
  reg [DTWIDTH-1:0] sr_out_data [0:NUMSEPT-1];

  genvar srogen;
  generate for(srogen=0;srogen<NUMSEPT;srogen=srogen+1) begin
    priority_encode #(.NUMENTRY(NUMVBNK), .NUMDSIZE(DTWIDTH)) 
    pe_match (.global_en(!up_en_dly[MEM_DELAY-1] & sr_en_dly[MEM_DELAY-1][srogen]), .enables(sr_bnk_match[srogen]), .data(sr_bnk_data[srogen]), 
              .hit(sr_bnk_hit[srogen]), .dout(sr_out_data[srogen])); 
  end
  endgenerate

/*
  integer srp_int, srb_int;
  always_comb begin
    for(srp_int=0; srp_int<NUMSEPT; srp_int=srp_int+1) begin
      sr_bnk_mhe[srp_int] = 0; 
      sr_bnk_hit[srp_int]=0;
      sr_bnk[srp_int]=0;
    end
    if(!up_en_dly[MEM_DELAY-1])begin
      for(srp_int=0; srp_int<NUMSEPT; srp_int=srp_int+1) begin
        if(sr_en_dly[MEM_DELAY-1][srp_int]) begin
          for(srb_int =0; srb_int<NUMVBNK; srb_int=srb_int+1) begin
            if(t1_doutB_vld[srp_int][srb_int] && (t1_doutB_key[srp_int][srb_int] == (sr_key_dly[MEM_DELAY-1] >>  KYWIDTH*srp_int))) begin
              if(sr_bnk_hit[srp_int]) sr_bnk_mhe[srp_int] = 1'b1;
              else begin
                sr_bnk_hit[srp_int] = 1;
                sr_bnk[srp_int] = srb_int;
              end 
            end
          end
        end
      end
    end
  end
*/
  //
  // Search out Handling
  //
  reg [NUMSEPT*DTWIDTH-1:0] sr_dout;
  reg [NUMSEPT-1:0] sr_vld;
  reg [NUMSEPT-1:0] sr_match;
  reg [NUMSEPT-1:0] sr_mhe;
  integer srout_int;
  always_comb begin
    sr_vld = 0;
    sr_match = 0;
    sr_mhe =0;
    sr_dout =0;
    for(srout_int =0; srout_int <NUMSEPT; srout_int=srout_int+1)begin
      if(sr_en_dly[MEM_DELAY-1][srout_int]) sr_vld = sr_vld | (1 << srout_int);
      sr_match = sr_match | ((sr_found_dly[srout_int][MEM_DELAY-1] ? sr_match_dly[srout_int][MEM_DELAY-1] : sr_bnk_hit[srout_int]) << srout_int);
      sr_mhe = sr_mhe | (sr_bnk_mhe[srout_int] << srout_int);
      sr_dout = sr_dout | ( (sr_found_dly[srout_int][MEM_DELAY-1] ? sr_dout_dly[srout_int][MEM_DELAY-1] : sr_out_data[srout_int]) << srout_int*DTWIDTH);
      //sr_match = sr_match | ((sr_found_dly[srout_int][MEM_DELAY-1] ? sr_match_dly[srout_int][MEM_DELAY-1] : sr_bnk_hit[srout_int]) << srout_int);
      //sr_mhe = sr_mhe | (sr_bnk_mhe[srout_int] << srout_int);
      //sr_dout = sr_dout | ( (sr_found_dly[srout_int][MEM_DELAY-1] ? sr_dout_dly[srout_int][MEM_DELAY-1] : t1_doutB_data[srout_int][sr_bnk[srout_int]]) << srout_int*DTWIDTH);
    end
  end

  //
  //CPU out handling
  //
  assign cpu_vld = cpu_read_dly[MEM_DELAY-1];
  assign cpu_dout = cpu_fread_dly[MEM_DELAY-1] ? cpu_fdout_dly[MEM_DELAY-1] : t1_doutB_arr[0][cpu_bnk_dly[MEM_DELAY-1]];
endmodule
