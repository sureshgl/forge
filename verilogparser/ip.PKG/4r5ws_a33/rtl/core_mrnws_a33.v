module core_mrnws_a33 (vwrite, vwraddr, vdin,
                       vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr, 
                       whfifo_oflw, wlfifo_oflw, rhfifo_oflw, rlfifo_oflw, rdrob_uflw,
                       t1_writeA, t1_addrA, t1_dinA, t1_writeB, t1_addrB, t1_dinB,
                       t1_readC, t1_addrC, t1_doutC, t1_fwrdC, t1_serrC, t1_derrC, t1_padrC, t1_cinC, t1_vldC, t1_coutC,
                       t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB, t2_cinB, t2_vldB, t2_coutB,
                       ready, clk, rst);

  parameter BITWDTH = 5;
  parameter WIDTH = 32;
  parameter NUMWRPT = 4;
  parameter BITWRPT = 2;
  parameter NUMRDPT = 4;
  parameter BITRDPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVBNK = 4;
  parameter BITVBNK = 2;
  parameter NUMVROW = 2048;
  parameter BITVROW = 11;
  parameter NUMCELL = 72;
  parameter BITCELL = 7;
  parameter NUMQUEU = NUMADDR/NUMCELL;
  parameter WFFOCNT = 16;
  parameter RFFOCNT = 16;
  parameter NUMHROW = 512;
  parameter BITHROW = 9;
  parameter BITHPDR = BITHROW+1; 
  parameter NUMLROW = 1536;
  parameter BITLROW = 11;
  parameter BITPADR = 14;
  parameter READ_DELAY = 30;
  parameter BITRDLY = 5;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter BITCTRL = BITRDPT+BITRDLY;

  input [NUMWRPT-1:0]           vwrite;
  input [NUMWRPT*BITADDR-1:0]   vwraddr;
  input [NUMWRPT*WIDTH-1:0]     vdin;

  input [NUMRDPT-1:0]           vread;
  input [NUMRDPT*BITADDR-1:0]   vrdaddr;
  output [NUMRDPT-1:0]          vread_vld;
  output [NUMRDPT*WIDTH-1:0]    vdout;
  output [NUMRDPT-1:0]          vread_fwrd;
  output [NUMRDPT-1:0]          vread_serr;
  output [NUMRDPT-1:0]          vread_derr;
  output [NUMRDPT*BITPADR-1:0]  vread_padr;

  output [NUMVBNK-1:0]          whfifo_oflw;
  output [NUMVBNK-1:0]          wlfifo_oflw;
  output [NUMVBNK-1:0]          rhfifo_oflw;
  output [NUMVBNK-1:0]          rlfifo_oflw;
  output [NUMRDPT-1:0]          rdrob_uflw;

  output [NUMVBNK-1:0]          t1_writeA;
  output [NUMVBNK*BITHROW-1:0]  t1_addrA;
  output [NUMVBNK*WIDTH-1:0]    t1_dinA;
  output [NUMVBNK-1:0]          t1_writeB;
  output [NUMVBNK*BITHROW-1:0]  t1_addrB;
  output [NUMVBNK*WIDTH-1:0]    t1_dinB;
  output [NUMVBNK-1:0]          t1_readC;
  output [NUMVBNK*BITHROW-1:0]  t1_addrC;
  input [NUMVBNK*WIDTH-1:0]     t1_doutC;
  input [NUMVBNK-1:0]           t1_fwrdC;
  input [NUMVBNK-1:0]           t1_serrC;
  input [NUMVBNK-1:0]           t1_derrC;
  input [NUMVBNK*BITHPDR-1:0]   t1_padrC;
  output [NUMVBNK*BITCTRL-1:0]  t1_cinC;
  input [NUMVBNK-1:0]           t1_vldC;
  input [NUMVBNK*BITCTRL-1:0]   t1_coutC;
  
  output [NUMVBNK-1:0]          t2_writeA;
  output [NUMVBNK*BITLROW-1:0]  t2_addrA;
  output [NUMVBNK*WIDTH-1:0]    t2_dinA;
  output [NUMVBNK-1:0]          t2_readB;
  output [NUMVBNK*BITLROW-1:0]  t2_addrB;
  input [NUMVBNK*WIDTH-1:0]     t2_doutB;
  input [NUMVBNK-1:0]           t2_fwrdB;
  input [NUMVBNK-1:0]           t2_serrB;
  input [NUMVBNK-1:0]           t2_derrB;
  input [NUMVBNK*BITLROW-1:0]   t2_padrB;
  output [NUMVBNK*BITCTRL-1:0]  t2_cinB;
  input [NUMVBNK-1:0]           t2_vldB;
  input [NUMVBNK*BITCTRL-1:0]   t2_coutB;
 
  output                        ready;
  input                         clk;
  input                         rst;
/*
  reg [BITVROW:0] rstaddr;
  wire rstvld = (rstaddr < NUMVROW);
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;
*/
  reg ready;
  always @(posedge clk)
    ready <= !rst;

  wire ready_wire;

  wire vread_wire [0:NUMRDPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMRDPT-1];
  wire [BITVBNK-1:0] vrdbadr_wire [0:NUMRDPT-1];
  wire [BITCELL-BITVBNK-1:0] vrdwadr_wire [0:NUMRDPT-1];
  wire [BITADDR-BITCELL-1:0] vrdradr_wire [0:NUMRDPT-1]; 
  wire [BITVROW-1:0] vrdladr_wire [0:NUMRDPT-1]; 

  wire vwrite_wire [0:NUMWRPT-1];
  wire [BITADDR-1:0] vwraddr_wire [0:NUMWRPT-1];
  wire [BITVBNK-1:0] vwrbadr_wire [0:NUMWRPT-1];
  wire [BITCELL-BITVBNK-1:0] vwrwadr_wire [0:NUMWRPT-1];
  wire [BITADDR-BITCELL-1:0] vwrradr_wire [0:NUMWRPT-1];
  wire [BITVROW-1:0] vwrladr_wire [0:NUMWRPT-1]; 
  wire [WIDTH-1:0] vdin_wire [0:NUMWRPT-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg [0:FLOPIN-1];
    reg [NUMRDPT-1:0] vread_reg [0:FLOPIN-1];
    reg [NUMRDPT*BITADDR-1:0] vrdaddr_reg [0:FLOPIN-1];
    reg [NUMWRPT-1:0] vwrite_reg [0:FLOPIN-1];
    reg [NUMWRPT*BITADDR-1:0] vwraddr_reg [0:FLOPIN-1];
    reg [NUMWRPT*WIDTH-1:0] vdin_reg [0:FLOPIN-1];
    integer reg_int;
    always @(posedge clk)
      for (reg_int=0; reg_int<FLOPIN; reg_int=reg_int+1)
        if (reg_int>0) begin
          ready_reg[reg_int] <= ready_reg[reg_int-1];
          vread_reg[reg_int] <= vread_reg[reg_int-1];
          vrdaddr_reg[reg_int] <= vrdaddr_reg[reg_int-1];
          vwrite_reg[reg_int] <= vwrite_reg[reg_int-1];
          vwraddr_reg[reg_int] <= vwraddr_reg[reg_int-1];
          vdin_reg[reg_int] <= vdin_reg[reg_int-1];
        end else begin
          ready_reg[reg_int] <= ready;
          vread_reg[reg_int] <= vread & {NUMRDPT{ready}};
          vrdaddr_reg[reg_int] <= vrdaddr;
          vwrite_reg[reg_int] <= vwrite & {NUMWRPT{ready}};
          vwraddr_reg[reg_int] <= vwraddr;
          vdin_reg[reg_int] <= vdin;
        end

    assign ready_wire = ready_reg[FLOPIN-1];
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_reg[FLOPIN-1] >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr_reg[FLOPIN-1] >> (np2_var*BITADDR);
      assign vrdbadr_wire[np2_var] = vrdaddr_wire[np2_var];
      assign vrdwadr_wire[np2_var] = vrdaddr_wire[np2_var] >> BITVBNK;
      assign vrdradr_wire[np2_var] = vrdaddr_wire[np2_var] >> BITCELL;
      assign vrdladr_wire[np2_var] = NUMQUEU*(vrdwadr_wire[np2_var]-1)+vrdradr_wire[np2_var];
    end
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite_reg[FLOPIN-1] >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr_reg[FLOPIN-1] >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin_reg[FLOPIN-1] >> (np2_var*WIDTH);
      assign vwrbadr_wire[np2_var] = vwraddr_wire[np2_var];
      assign vwrwadr_wire[np2_var] = vwraddr_wire[np2_var] >> BITVBNK;
      assign vwrradr_wire[np2_var] = vwraddr_wire[np2_var] >> BITCELL;
      assign vwrladr_wire[np2_var] = NUMQUEU*(vwrwadr_wire[np2_var]-1)+vwrradr_wire[np2_var];
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);
      assign vrdbadr_wire[np2_var] = vrdaddr_wire[np2_var];
      assign vrdwadr_wire[np2_var] = vrdaddr_wire[np2_var] >> BITVBNK;
      assign vrdradr_wire[np2_var] = vrdaddr_wire[np2_var] >> BITCELL;
      assign vrdladr_wire[np2_var] = NUMQUEU*(vrdwadr_wire[np2_var]-1)+vrdradr_wire[np2_var];
    end
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);
      assign vwrbadr_wire[np2_var] = vwraddr_wire[np2_var];
      assign vwrwadr_wire[np2_var] = vwraddr_wire[np2_var] >> BITVBNK;
      assign vwrradr_wire[np2_var] = vwraddr_wire[np2_var] >> BITCELL;
      assign vwrladr_wire[np2_var] = NUMQUEU*(vwrwadr_wire[np2_var]-1)+vwrradr_wire[np2_var];
    end
  end
  endgenerate

  wire vread_wire_0 = vread_wire[0];
  wire [BITADDR-1:0] vrdaddr_wire_0 = vrdaddr_wire[0];
  wire [BITVBNK-1:0] vrdbadr_wire_0 = vrdbadr_wire[0];
  wire [BITCELL-BITVBNK-1:0] vrdwadr_wire_0 = vrdwadr_wire[0];
  wire [BITADDR-BITCELL-1:0] vrdradr_wire_0 = vrdradr_wire[0];
  wire [BITVROW-1:0] vrdladr_wire_0 = vrdladr_wire[0];

  wire vread_wire_1 = vread_wire[1];
  wire [BITADDR-1:0] vrdaddr_wire_1 = vrdaddr_wire[1];
  wire [BITVBNK-1:0] vrdbadr_wire_1 = vrdbadr_wire[1];
  wire [BITCELL-BITVBNK-1:0] vrdwadr_wire_1 = vrdwadr_wire[1];
  wire [BITADDR-BITCELL-1:0] vrdradr_wire_1 = vrdradr_wire[1];
  wire [BITVROW-1:0] vrdladr_wire_1 = vrdladr_wire[1];

  wire vwrite_wire_0 = vwrite_wire[0];
  wire [BITADDR-1:0] vwraddr_wire_0 = vwraddr_wire[0];
  wire [BITVBNK-1:0] vwrbadr_wire_0 = vwrbadr_wire[0];
  wire [BITCELL-BITVBNK-1:0] vwrwadr_wire_0 = vwrwadr_wire[0];
  wire [BITADDR-BITCELL-1:0] vwrradr_wire_0 = vwrradr_wire[0];
  wire [BITVROW-1:0] vwrladr_wire_0 = vwrladr_wire[0];
  wire [WIDTH-1:0] vdin_wire_0 = vdin_wire[0];

  wire vwrite_wire_1 = vwrite_wire[1];
  wire [BITADDR-1:0] vwraddr_wire_1 = vwraddr_wire[1];
  wire [BITVBNK-1:0] vwrbadr_wire_1 = vwrbadr_wire[1];
  wire [BITCELL-BITVBNK-1:0] vwrwadr_wire_1 = vwrwadr_wire[1];
  wire [BITADDR-BITCELL-1:0] vwrradr_wire_1 = vwrradr_wire[1];
  wire [BITVROW-1:0] vwrladr_wire_1 = vwrladr_wire[1];
  wire [WIDTH-1:0] vdin_wire_1 = vdin_wire[1];
/*
  wire vwrite_wire_1 = vwrite_wire[1];
  wire [BITADDR-1:0] vwraddr_wire_1 = vwraddr_wire[1];
  wire [BITVBNK-1:0] vwrbadr_wire_1 = vwrbadr_wire[1];
  wire [BITVROW-1:0] vwrradr_wire_1 = vwrradr_wire[1];
  wire [WIDTH-1:0] vdin_wire_1 = vdin_wire[1];
  wire vwrite_wire_2 = vwrite_wire[2];
  wire [BITADDR-1:0] vwraddr_wire_2 = vwraddr_wire[2];
  wire [BITVBNK-1:0] vwrbadr_wire_2 = vwrbadr_wire[2];
  wire [BITVROW-1:0] vwrradr_wire_2 = vwrradr_wire[2];
  wire [WIDTH-1:0] vdin_wire_2 = vdin_wire[2];
  wire vwrite_wire_3 = vwrite_wire[3];
  wire [BITADDR-1:0] vwraddr_wire_3 = vwraddr_wire[3];
  wire [BITVBNK-1:0] vwrbadr_wire_3 = vwrbadr_wire[3];
  wire [BITVROW-1:0] vwrradr_wire_3 = vwrradr_wire[3];
  wire [WIDTH-1:0] vdin_wire_3 = vdin_wire[3];
*/
  reg [BITRDLY-1:0] read_ptr;
  always @(posedge clk)
    if (rst)
      read_ptr <= 0;
    else if (read_ptr==READ_DELAY-1)
      read_ptr <= 0;
    else
      read_ptr <= read_ptr + 1;

  reg                vread_reg [0:NUMRDPT-1][0:READ_DELAY];
//  reg [BITVBNK-1:0]  vrdbadr_reg [0:NUMRDPT-1][0:READ_DELAY];
//  reg [BITVROW-1:0]  vrdradr_reg [0:NUMRDPT-1][0:READ_DELAY];
  reg [BITRDLY-1:0]  vrdptr_reg [0:NUMRDPT-1][0:READ_DELAY];
  integer vdel_int, vprt_int;
  always @(posedge clk) 
    for (vdel_int=0; vdel_int<READ_DELAY; vdel_int=vdel_int+1)
      if (vdel_int>0)
        for (vprt_int=0; vprt_int<NUMRDPT; vprt_int=vprt_int+1) begin
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
//          vrdbadr_reg[vprt_int][vdel_int] <= vrdbadr_reg[vprt_int][vdel_int-1];
//          vrdradr_reg[vprt_int][vdel_int] <= vrdradr_reg[vprt_int][vdel_int-1];
          vrdptr_reg[vprt_int][vdel_int] <= vrdptr_reg[vprt_int][vdel_int-1];
        end
      else
        for (vprt_int=0; vprt_int<NUMRDPT; vprt_int=vprt_int+1) begin
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
//          vrdbadr_reg[vprt_int][vdel_int] <= vrdbadr_wire[vprt_int];
//          vrdradr_reg[vprt_int][vdel_int] <= vrdradr_wire[vprt_int];
          vrdptr_reg[vprt_int][vdel_int] <= read_ptr;
        end

  reg               vread_out [0:NUMRDPT-1];
//  reg [BITVBNK-1:0] vrdbadr_out [0:NUMRDPT-1];
//  reg [BITVROW-1:0] vrdradr_out [0:NUMRDPT-1];
  reg [BITRDLY-1:0] vrdptr_out [0:NUMRDPT-1];
  integer vout_int;
  always_comb
    for (vout_int=0; vout_int<NUMRDPT; vout_int=vout_int+1) begin
      vread_out[vout_int] = vread_reg[vout_int][READ_DELAY-1];
//      vrdbadr_out[vout_int] = vrdbadr_reg[vout_int][READ_DELAY-1];
//      vrdradr_out[vout_int] = vrdradr_reg[vout_int][READ_DELAY-1];
      vrdptr_out[vout_int] = vrdptr_reg[vout_int][READ_DELAY-1];
    end

  reg [1:0] rate_limit;
  always @(posedge clk)
    if (rst)
      rate_limit <= 0;
    else if (rate_limit==2)
      rate_limit <= 0;
    else
      rate_limit <= rate_limit + 1;

  reg [4:0]          wrfifo_cnt [0:1][0:NUMVBNK-1];
  reg                wrfifo_new_vld [0:1][0:NUMVBNK-1][0:WFFOCNT-1];
  reg [BITVROW-1:0]  wrfifo_new_row [0:1][0:NUMVBNK-1][0:WFFOCNT-1];
  //reg [WIDTH-1:0]    wrfifo_new_dat [0:1][0:NUMVBNK-1][0:WFFOCNT-1];
  //wire [WIDTH-1:0]    wrfifo_new_dat_out [0:1][0:NUMVBNK-1][0:WFFOCNT-1];
   wire [WIDTH-1:0]  wrfifo_new_dat_out_0 [0:NUMVBNK-1];
   wire [WIDTH-1:0]  wrfifo_new_dat_out_1 [0:NUMVBNK-1];
   wire [WIDTH-1:0]  wrfifo_new_dat_out_2 [0:NUMVBNK-1];
   wire [WIDTH-1:0]  wrfifo_vwrite_dat_wire [0:1][0:NUMVBNK-1][0:WFFOCNT-1];
   wire [WIDTH-1:0]  wrfifo_vwrite_dat [0:1][0:NUMVBNK-1][0:WFFOCNT-1];
   
      
  //wire [3*WIDTH-1:0] wrfifo_new_dat_in [0:1][0:NUMVBNK-1][0:WFFOCNT-1];
  wire [3-1:0] wrfifo_new_dat_sel [0:1][0:NUMVBNK-1][0:WFFOCNT-1];
  wire [3:0] wrfifo_dcnt_wire [0:1][0:NUMVBNK-1][0:WFFOCNT-1];  

  wire [4:0] wrfifo_cnt_0_0 = wrfifo_cnt[0][0];
  wire wrfifo_cnt_0_0_gt_1 = (wrfifo_cnt_0_0 > 1);
  wire wrfifo_cnt_0_0_gt_2 = (wrfifo_cnt_0_0 > 2);
  wire wrfifo_cnt_0_0_gt_3 = (wrfifo_cnt_0_0 > 3);
  wire wrfifo_cnt_0_0_gt_4 = (wrfifo_cnt_0_0 > 4);

  wire [4:0] wrfifo_cnt_1_0 = wrfifo_cnt[1][0];
  wire wrfifo_cnt_1_0_gt_1 = (wrfifo_cnt_1_0 > 1);
  wire wrfifo_cnt_1_0_gt_2 = (wrfifo_cnt_1_0 > 2);
  wire wrfifo_cnt_1_0_gt_3 = (wrfifo_cnt_1_0 > 3);

  wire [4:0] wrfifo_cnt_1_1 = wrfifo_cnt[1][1];
  wire [4:0] wrfifo_cnt_1_2 = wrfifo_cnt[1][2];
  wire [4:0] wrfifo_cnt_1_3 = wrfifo_cnt[1][3];

  wire [NUMVBNK-1:0] whfifo_oflw_tmp;
  wire [NUMVBNK-1:0] wlfifo_oflw_tmp;
  wire [NUMVBNK-1:0] rhfifo_oflw_tmp;
  wire [NUMVBNK-1:0] rlfifo_oflw_tmp;


  genvar wffo_int, wffh_int, wffb_int;
  generate for (wffb_int=0; wffb_int<NUMVBNK; wffb_int=wffb_int+1) begin: wffb_loop

    assign whfifo_oflw_tmp[wffb_int] = (wrfifo_cnt[0][wffb_int] > WFFOCNT);
    assign wlfifo_oflw_tmp[wffb_int] = (wrfifo_cnt[1][wffb_int] > WFFOCNT);

    for (wffh_int=0; wffh_int<2; wffh_int=wffh_int+1) begin: wffh_loop
      reg [BITWRPT-1:0] vwr_bnk_sel;
      reg vwrite_bnk_nxt [0:NUMWRPT-1];
      reg [BITVROW-1:0] vwrite_row_nxt [0:NUMWRPT-1];
      reg [WIDTH-1:0] vwrite_dat_nxt [0:NUMWRPT-1];
      integer vwrn_int;
      always_comb begin
        for (vwrn_int=0; vwrn_int<NUMWRPT; vwrn_int=vwrn_int+1) begin
          vwrite_bnk_nxt[vwrn_int] = 0;
          vwrite_row_nxt[vwrn_int] = 0;
          vwrite_dat_nxt[vwrn_int] = 0;
        end
        vwr_bnk_sel = 0;
        for (vwrn_int=0; vwrn_int<NUMWRPT; vwrn_int=vwrn_int+1)
          if (vwrite_wire[vwrn_int] && (vwrbadr_wire[vwrn_int]==wffb_int) && (wffh_int ? |vwrwadr_wire[vwrn_int] : !(|vwrwadr_wire[vwrn_int]))) begin
            vwrite_bnk_nxt[vwr_bnk_sel] = 1'b1;
            vwrite_row_nxt[vwr_bnk_sel] = wffh_int ? vwrladr_wire[vwrn_int] : vwrradr_wire[vwrn_int];
            vwrite_dat_nxt[vwr_bnk_sel] = vdin_wire[vwrn_int];
            vwr_bnk_sel = vwr_bnk_sel + 1;
          end
      end

      reg vwrite_bnk [0:NUMWRPT-1];
      reg [BITVROW-1:0] vwrite_row [0:NUMWRPT-1];
      reg [WIDTH-1:0] vwrite_dat [0:NUMWRPT-1];
      integer vwrb_int;
      always @(posedge clk)
        for (vwrb_int=0; vwrb_int<NUMWRPT; vwrb_int=vwrb_int+1) begin
          vwrite_bnk[vwrb_int] <= vwrite_bnk_nxt[vwrb_int];
          vwrite_row[vwrb_int] <= vwrite_row_nxt[vwrb_int];
          vwrite_dat[vwrb_int] <= vwrite_dat_nxt[vwrb_int];
        end

      reg [3:0] wrfifo_dcnt;
      reg [3:0] wrfifo_ecnt;
      integer wffc_int;
      always_comb begin
        wrfifo_dcnt = wffh_int ? |rate_limit : 2;
        wrfifo_dcnt = (wrfifo_cnt[wffh_int][wffb_int] > wrfifo_dcnt) ? wrfifo_dcnt : wrfifo_cnt[wffh_int][wffb_int]; 
        wrfifo_ecnt = 0;
        for (wffc_int=0; wffc_int<NUMWRPT; wffc_int=wffc_int+1)
          wrfifo_ecnt = wrfifo_ecnt + vwrite_bnk[wffc_int];
      end

      always @(posedge clk)
        if (rst)
          wrfifo_cnt[wffh_int][wffb_int] <= 0;
        else
          wrfifo_cnt[wffh_int][wffb_int] <= wrfifo_cnt[wffh_int][wffb_int] + wrfifo_ecnt - wrfifo_dcnt;

      for (wffo_int=0; wffo_int<WFFOCNT; wffo_int=wffo_int+1) begin: wffo_loop
        reg [3:0] vwr_sel;
        reg [3:0] fifo_cnt_temp;

        integer fcnt_int;
        always_comb begin
          vwr_sel = NUMWRPT;
          for (fcnt_int=0; fcnt_int<NUMWRPT; fcnt_int=fcnt_int+1)
            if (vwrite_bnk[fcnt_int] && (wffo_int == (wrfifo_cnt[wffh_int][wffb_int] - wrfifo_dcnt + fcnt_int)))
              vwr_sel = fcnt_int;
/*
          fifo_cnt_temp = wrfifo_cnt[wffh_int][wffb_int] - wrfifo_dcnt;
          if (wffo_int < fifo_cnt_temp)
            vwr_sel = NUMWRPT;
          else begin 
            vwr_sel = 0;
            for (fcnt_int=0; fcnt_int<NUMWRPT; fcnt_int=fcnt_int+1)
              if (fifo_cnt_temp <= wffo_int) begin
                if (vwrite_bnk[fcnt_int] && (fifo_cnt_temp == wffo_int))
                  vwr_sel = vwr_sel;
                else
                  vwr_sel = vwr_sel + 1;
                fifo_cnt_temp = fifo_cnt_temp + vwrite_bnk[fcnt_int];
              end
          end
*/
        end

        reg               wrfifo_new_vld_next;
        reg [BITVROW-1:0] wrfifo_new_row_next;
        //reg [WIDTH-1:0]   wrfifo_new_dat_next;
	



         //assign wrfifo_new_dat_in [wffh_int][wffb_int][wffo_int] = {wrfifo_new_dat_out[wffh_int][wffb_int][wffo_int], wrfifo_new_dat_out[wffh_int][wffb_int][wffo_int+wrfifo_dcnt],vwrite_dat[vwr_sel]};
	 assign wrfifo_new_dat_sel [wffh_int][wffb_int][wffo_int] = (((vwr_sel != NUMWRPT) && vwrite_bnk[vwr_sel])? 3'b001 : (|wrfifo_dcnt && (wffo_int<WFFOCNT-wrfifo_dcnt))? 3'b010 :
								     3'b100);
	 assign wrfifo_dcnt_wire [wffh_int][wffb_int][wffo_int] = wrfifo_dcnt;
	 assign wrfifo_vwrite_dat [wffh_int][wffb_int][wffo_int] = vwrite_dat[vwr_sel];
	 	 	  
        always_comb
          if ((vwr_sel != NUMWRPT) && vwrite_bnk[vwr_sel]) begin
            wrfifo_new_vld_next = 1'b1;
            wrfifo_new_row_next = vwrite_row[vwr_sel];
            //wrfifo_new_dat_next = vwrite_dat[vwr_sel];
//            wrfifo_new_row_next = wffh_int ? (NUMCELL/NUMVBNK-1)*vwrradr_wire[vwr_sel]+(vwrwadr_wire[vwr_sel]-1) : vwrradr_wire[vwr_sel];
//            wrfifo_new_row_next = wffh_int ? NUMQUEU*(vwrwadr_wire[vwr_sel]-1)+vwrradr_wire[vwr_sel] : vwrradr_wire[vwr_sel];
//            wrfifo_new_row_next = wffh_int ? vwrladr_wire[vwr_sel] : vwrradr_wire[vwr_sel];
//            wrfifo_new_dat_next = vdin_wire[vwr_sel];
          end else if (|wrfifo_dcnt && (wffo_int<WFFOCNT-wrfifo_dcnt)) begin
            wrfifo_new_vld_next = wrfifo_new_vld[wffh_int][wffb_int][wffo_int+wrfifo_dcnt];
            wrfifo_new_row_next = wrfifo_new_row[wffh_int][wffb_int][wffo_int+wrfifo_dcnt];
            //wrfifo_new_dat_next = wrfifo_new_dat[wffh_int][wffb_int][wffo_int+wrfifo_dcnt];
          end else begin
            wrfifo_new_vld_next = wrfifo_new_vld[wffh_int][wffb_int][wffo_int];
            wrfifo_new_row_next = wrfifo_new_row[wffh_int][wffb_int][wffo_int];
            //wrfifo_new_dat_next = wrfifo_new_dat[wffh_int][wffb_int][wffo_int];
          end

        always @(posedge clk) begin
          wrfifo_new_vld[wffh_int][wffb_int][wffo_int] <= wrfifo_new_vld_next;
          wrfifo_new_row[wffh_int][wffb_int][wffo_int] <= wrfifo_new_row_next;
          //wrfifo_new_dat[wffh_int][wffb_int][wffo_int] <= wrfifo_new_dat_next;
        end
	 
      end // block: wffo_loop
    end
  end
  endgenerate

  f32_wrfifo_array #(.WIDTH(WIDTH), .NUMWRPT(3), .NUMVBNK(NUMVBNK), .WFFOCNT(WFFOCNT)) wrfifo_array_inst 
    (.clk(clk), .wrfifo_new_dat_out_0(wrfifo_new_dat_out_0), .wrfifo_new_dat_out_1(wrfifo_new_dat_out_1), 
     .wrfifo_new_dat_out_2(wrfifo_new_dat_out_2), .wrfifo_vwrite_dat(wrfifo_vwrite_dat), .wrfifo_dcnt(wrfifo_dcnt_wire), .wrfifo_new_dat_sel(wrfifo_new_dat_sel));
   

  reg [4:0]          rdfifo_cnt [0:1][0:NUMVBNK-1];
  reg                rdfifo_new_vld [0:1][0:NUMVBNK-1][0:RFFOCNT-1];
  reg [BITVROW-1:0]  rdfifo_new_row [0:1][0:NUMVBNK-1][0:RFFOCNT-1];
  reg [BITRDPT-1:0]  rdfifo_new_prt [0:1][0:NUMVBNK-1][0:RFFOCNT-1];
  reg [BITRDLY-1:0]  rdfifo_new_ptr [0:1][0:NUMVBNK-1][0:RFFOCNT-1];

  wire [4:0] rdfifo_cnt_0_0 = rdfifo_cnt[0][0];
  wire rdfifo_cnt_0_0_gt_1 = (rdfifo_cnt_0_0 > 1);
  wire rdfifo_cnt_0_0_gt_2 = (rdfifo_cnt_0_0 > 2);
  wire rdfifo_cnt_0_0_gt_3 = (rdfifo_cnt_0_0 > 3);
  wire rdfifo_cnt_0_0_gt_4 = (rdfifo_cnt_0_0 > 4);

  wire [4:0] rdfifo_cnt_1_0 = rdfifo_cnt[1][0];
  wire rdfifo_cnt_1_0_gt_1 = (rdfifo_cnt_1_0 > 1);
  wire rdfifo_cnt_1_0_gt_2 = (rdfifo_cnt_1_0 > 2);
  wire rdfifo_cnt_1_0_gt_3 = (rdfifo_cnt_1_0 > 3);
  wire rdfifo_cnt_1_0_gt_4 = (rdfifo_cnt_1_0 > 4);

  wire [4:0] rdfifo_cnt_1_1 = rdfifo_cnt[1][1];
  wire [4:0] rdfifo_cnt_1_2 = rdfifo_cnt[1][2];

  genvar rffo_int, rffh_int, rffb_int;
  generate for (rffb_int=0; rffb_int<NUMVBNK; rffb_int=rffb_int+1) begin: rffb_loop

    assign rhfifo_oflw_tmp[rffb_int] = (rdfifo_cnt[0][rffb_int] > RFFOCNT);
    assign rlfifo_oflw_tmp[rffb_int] = (rdfifo_cnt[1][rffb_int] > RFFOCNT);

    for (rffh_int=0; rffh_int<2; rffh_int=rffh_int+1) begin: rffh_loop
      reg [BITRDPT-1:0] vrd_bnk_sel;
      reg vread_bnk_nxt [0:NUMRDPT-1];
      reg [BITVROW-1:0] vread_row_nxt [0:NUMRDPT-1];
      reg [BITRDPT-1:0] vread_prt_nxt [0:NUMRDPT-1];
      integer vrdn_int;
      always_comb begin
        for (vrdn_int=0; vrdn_int<NUMRDPT; vrdn_int=vrdn_int+1) begin
          vread_bnk_nxt[vrdn_int] = 0;
          vread_row_nxt[vrdn_int] = 0;
          vread_prt_nxt[vrdn_int] = 0;
        end
        vrd_bnk_sel = 0;
        for (vrdn_int=0; vrdn_int<NUMRDPT; vrdn_int=vrdn_int+1)
          if (vread_wire[vrdn_int] && (vrdbadr_wire[vrdn_int]==rffb_int) && (rffh_int ? |vrdwadr_wire[vrdn_int] : !(|vrdwadr_wire[vrdn_int]))) begin
            vread_bnk_nxt[vrd_bnk_sel] = 1'b1;
            vread_row_nxt[vrd_bnk_sel] = rffh_int ? vrdladr_wire[vrdn_int] : vrdradr_wire[vrdn_int];
            vread_prt_nxt[vrd_bnk_sel] = vrdn_int;
            vrd_bnk_sel = vrd_bnk_sel + 1;
          end
      end

      reg vread_bnk [0:NUMRDPT-1];
      reg [BITVROW-1:0] vread_row [0:NUMRDPT-1];
      reg [BITRDPT-1:0] vread_prt [0:NUMRDPT-1];
      reg [BITRDLY-1:0] vread_ptr [0:NUMRDPT-1];
      integer vrdb_int;
      always @(posedge clk)
        for (vrdb_int=0; vrdb_int<NUMRDPT; vrdb_int=vrdb_int+1) begin
          vread_bnk[vrdb_int] <= vread_bnk_nxt[vrdb_int];
          vread_row[vrdb_int] <= vread_row_nxt[vrdb_int];
          vread_prt[vrdb_int] <= vread_prt_nxt[vrdb_int];
          vread_ptr[vrdb_int] <= read_ptr;
        end

      reg [3:0] rdfifo_dcnt;
      reg [3:0] rdfifo_ecnt;
      integer rffc_int;
      always_comb begin
        rdfifo_dcnt = rffh_int ? |rate_limit : 1;
        rdfifo_dcnt = (rdfifo_cnt[rffh_int][rffb_int] > rdfifo_dcnt) ? rdfifo_dcnt : rdfifo_cnt[rffh_int][rffb_int]; 
        rdfifo_ecnt = 0;
        for (rffc_int=0; rffc_int<NUMRDPT; rffc_int=rffc_int+1)
          rdfifo_ecnt = rdfifo_ecnt + vread_bnk[rffc_int];
      end

      always @(posedge clk)
        if (rst)
          rdfifo_cnt[rffh_int][rffb_int] <= 0;
        else
          rdfifo_cnt[rffh_int][rffb_int] <= rdfifo_cnt[rffh_int][rffb_int] + rdfifo_ecnt - rdfifo_dcnt;

      for (rffo_int=0; rffo_int<RFFOCNT; rffo_int=rffo_int+1) begin: rffo_loop
        reg [3:0] vrd_sel;
        reg [3:0] fifo_cnt_temp;

        integer fcnt_int;
        always_comb begin
          vrd_sel = NUMRDPT;
          for (fcnt_int=0; fcnt_int<NUMRDPT; fcnt_int=fcnt_int+1)
            if (vread_bnk[fcnt_int] && (rffo_int == (rdfifo_cnt[rffh_int][rffb_int] - rdfifo_dcnt + fcnt_int)))
              vrd_sel = fcnt_int;
/*
          fifo_cnt_temp = rdfifo_cnt[rffh_int][rffb_int] - rdfifo_dcnt;
          if (rffo_int < fifo_cnt_temp)
            vrd_sel = NUMRDPT;
          else begin 
            vrd_sel = 0;
            for (fcnt_int=0; fcnt_int<NUMRDPT; fcnt_int=fcnt_int+1)
              if (fifo_cnt_temp <= rffo_int) begin
                if (vread_bnk[fcnt_int] && (fifo_cnt_temp == rffo_int))
                  vrd_sel = vrd_sel;
                else
                  vrd_sel = vrd_sel + 1;
                fifo_cnt_temp = fifo_cnt_temp + vread_bnk[fcnt_int];
              end
          end
*/
        end

      reg               rdfifo_new_vld_next;
      reg [BITVROW-1:0] rdfifo_new_row_next;
      reg [BITRDPT-1:0] rdfifo_new_prt_next;
      reg [BITRDLY-1:0] rdfifo_new_ptr_next;
      always_comb
        if ((vrd_sel != NUMRDPT) && vread_bnk[vrd_sel]) begin
          rdfifo_new_vld_next = 1'b1;
          rdfifo_new_row_next = vread_row[vrd_sel];
          rdfifo_new_prt_next = vread_prt[vrd_sel];
          rdfifo_new_ptr_next = vread_ptr[vrd_sel];
//          rdfifo_new_row_next = rffh_int ? (NUMCELL/NUMVBNK-1)*vrdradr_wire[vrd_sel]+(vrdwadr_wire[vrd_sel]-1) : vrdradr_wire[vrd_sel];
//          rdfifo_new_row_next = rffh_int ? NUMQUEU*(vrdwadr_wire[vrd_sel]-1)+vrdradr_wire[vrd_sel] : vrdradr_wire[vrd_sel];
//          rdfifo_new_row_next = rffh_int ? vrdladr_wire[vrd_sel] : vrdradr_wire[vrd_sel];
//          rdfifo_new_prt_next = vrd_sel;
//          rdfifo_new_ptr_next = read_ptr;
        end else if (|rdfifo_dcnt && (rffo_int<RFFOCNT-rdfifo_dcnt)) begin
          rdfifo_new_vld_next = rdfifo_new_vld[rffh_int][rffb_int][rffo_int+rdfifo_dcnt];
          rdfifo_new_row_next = rdfifo_new_row[rffh_int][rffb_int][rffo_int+rdfifo_dcnt];
          rdfifo_new_prt_next = rdfifo_new_prt[rffh_int][rffb_int][rffo_int+rdfifo_dcnt];
          rdfifo_new_ptr_next = rdfifo_new_ptr[rffh_int][rffb_int][rffo_int+rdfifo_dcnt];
        end else begin
          rdfifo_new_vld_next = rdfifo_new_vld[rffh_int][rffb_int][rffo_int];
          rdfifo_new_row_next = rdfifo_new_row[rffh_int][rffb_int][rffo_int];
          rdfifo_new_prt_next = rdfifo_new_prt[rffh_int][rffb_int][rffo_int];
          rdfifo_new_ptr_next = rdfifo_new_ptr[rffh_int][rffb_int][rffo_int];
        end

        always @(posedge clk) begin
          rdfifo_new_vld[rffh_int][rffb_int][rffo_int] <= rdfifo_new_vld_next;
          rdfifo_new_row[rffh_int][rffb_int][rffo_int] <= rdfifo_new_row_next;
          rdfifo_new_prt[rffh_int][rffb_int][rffo_int] <= rdfifo_new_prt_next;
          rdfifo_new_ptr[rffh_int][rffb_int][rffo_int] <= rdfifo_new_ptr_next;
        end
      end
    end
  end
  endgenerate

  reg [NUMVBNK-1:0] t1_writeA;
  reg [NUMVBNK*BITHROW-1:0] t1_addrA;
  reg [NUMVBNK*WIDTH-1:0] t1_dinA;
  reg [NUMVBNK-1:0] t1_writeB;
  reg [NUMVBNK*BITHROW-1:0] t1_addrB;
  reg [NUMVBNK*WIDTH-1:0] t1_dinB;
  integer t1wb_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (t1wb_int=0; t1wb_int<NUMVBNK; t1wb_int=t1wb_int+1)
      if (wrfifo_cnt[0][t1wb_int]>0) begin
        t1_writeA = t1_writeA | (1'b1 << t1wb_int);
        t1_addrA = t1_addrA | (wrfifo_new_row[0][t1wb_int][0] << (t1wb_int*BITHROW));
        t1_dinA = t1_dinA | (/*wrfifo_new_dat_out[0][t1wb_int][0]*/wrfifo_new_dat_out_0[t1wb_int] << (t1wb_int*WIDTH));
      end
    t1_writeB = 0;
    t1_addrB = 0;
    t1_dinB = 0;
    for (t1wb_int=0; t1wb_int<NUMVBNK; t1wb_int=t1wb_int+1)
      if (wrfifo_cnt[0][t1wb_int]>1) begin
        t1_writeB = t1_writeB | (1'b1 << t1wb_int);
        t1_addrB = t1_addrB | (wrfifo_new_row[0][t1wb_int][1] << (t1wb_int*BITHROW));
        t1_dinB = t1_dinB | (/*wrfifo_new_dat wrfifo_new_dat_out[0][t1wb_int][1]*/wrfifo_new_dat_out_1[t1wb_int] << (t1wb_int*WIDTH));
      end
  end

  reg [NUMVBNK-1:0] t1_readC;
  reg [NUMVBNK*BITHROW-1:0] t1_addrC;
  reg [NUMVBNK*BITCTRL-1:0] t1_cinC;
  integer t1rb_int;
  always_comb begin
    t1_readC = 0;
    t1_addrC = 0;
    t1_cinC = 0;
    for (t1rb_int=0; t1rb_int<NUMVBNK; t1rb_int=t1rb_int+1)
      if (|rdfifo_cnt[0][t1rb_int]) begin
        t1_readC = t1_readC | (1'b1 << t1rb_int);
        t1_addrC = t1_addrC | (rdfifo_new_row[0][t1rb_int][0] << (t1rb_int*BITHROW));
        t1_cinC = t1_cinC | ({rdfifo_new_prt[0][t1rb_int][0],rdfifo_new_ptr[0][t1rb_int][0]} << (t1rb_int*BITCTRL));
      end
  end

  reg [NUMVBNK-1:0] t2_writeA;
  reg [NUMVBNK*BITLROW-1:0] t2_addrA;
  reg [NUMVBNK*WIDTH-1:0] t2_dinA;
  integer t2wb_int;
  always_comb begin
    t2_writeA = 0;
    t2_addrA = 0;
    t2_dinA = 0;
    for (t2wb_int=0; t2wb_int<NUMVBNK; t2wb_int=t2wb_int+1)
      if (|rate_limit && (wrfifo_cnt[1][t2wb_int]>0)) begin
        t2_writeA = t2_writeA | (1'b1 << t2wb_int);
        t2_addrA = t2_addrA | (wrfifo_new_row[1][t2wb_int][0] << (t2wb_int*BITLROW));
        t2_dinA = t2_dinA | (/*wrfifo_new_dat*//*wrfifo_new_dat_out[1][t2wb_int][0]*/wrfifo_new_dat_out_2[t2wb_int] << (t2wb_int*WIDTH));
      end
  end

  reg [NUMVBNK-1:0] t2_readB;
  reg [NUMVBNK*BITLROW-1:0] t2_addrB;
  reg [NUMVBNK*BITCTRL-1:0] t2_cinB;
  integer t2rb_int;
  always_comb begin
    t2_readB = 0;
    t2_addrB = 0;
    t2_cinB = 0;
    for (t2rb_int=0; t2rb_int<NUMVBNK; t2rb_int=t2rb_int+1)
      if (|rate_limit && |rdfifo_cnt[1][t2rb_int]) begin
        t2_readB = t2_readB | (1'b1 << t2rb_int);
        t2_addrB = t2_addrB | (rdfifo_new_row[1][t2rb_int][0] << (t2rb_int*BITLROW));
        t2_cinB = t2_cinB | ({rdfifo_new_prt[1][t2rb_int][0],rdfifo_new_ptr[1][t2rb_int][0]} << (t2rb_int*BITCTRL));
      end
  end

  reg [WIDTH-1:0] t1_doutC_wire [0:NUMVBNK-1]; 
  reg t1_fwrdC_wire [0:NUMVBNK-1];
  reg t1_serrC_wire [0:NUMVBNK-1];
  reg t1_derrC_wire [0:NUMVBNK-1];
  reg [BITHPDR-1:0] t1_padrC_wire [0:NUMVBNK-1];
  reg t1_vldC_wire [0:NUMVBNK-1];
  reg [BITCTRL-1:0] t1_coutC_wire [0:NUMVBNK-1];
  reg [BITRDPT-1:0] t1_prtC_wire [0:NUMVBNK-1];
  reg [BITRDLY-1:0] t1_ptrC_wire [0:NUMVBNK-1];
  reg [WIDTH-1:0] t2_doutB_wire [0:NUMVBNK-1]; 
  reg t2_fwrdB_wire [0:NUMVBNK-1];
  reg t2_serrB_wire [0:NUMVBNK-1];
  reg t2_derrB_wire [0:NUMVBNK-1];
  reg [BITLROW-1:0] t2_padrB_wire [0:NUMVBNK-1];
  reg t2_vldB_wire [0:NUMVBNK-1];
  reg [BITCTRL-1:0] t2_coutB_wire [0:NUMVBNK-1];
  reg [BITRDPT-1:0] t2_prtB_wire [0:NUMVBNK-1];
  reg [BITRDLY-1:0] t2_ptrB_wire [0:NUMVBNK-1];
  integer tout_int;
  always_comb
    for (tout_int=0; tout_int<NUMVBNK; tout_int=tout_int+1) begin
      t1_doutC_wire[tout_int] = t1_doutC >> (tout_int*WIDTH); 
      t1_fwrdC_wire[tout_int] = t1_fwrdC >> tout_int; 
      t1_serrC_wire[tout_int] = t1_serrC >> tout_int; 
      t1_derrC_wire[tout_int] = t1_derrC >> tout_int; 
      t1_padrC_wire[tout_int] = t1_padrC >> (tout_int*BITHPDR); 
      t1_vldC_wire[tout_int] = t1_vldC >> tout_int; 
      t1_coutC_wire[tout_int] = t1_coutC >> (tout_int*BITCTRL); 
      t1_prtC_wire[tout_int] = t1_coutC_wire[tout_int] >> BITRDLY;
      t1_ptrC_wire[tout_int] = t1_coutC_wire[tout_int];
      t2_doutB_wire[tout_int] = t2_doutB >> (tout_int*WIDTH); 
      t2_fwrdB_wire[tout_int] = t2_fwrdB >> tout_int; 
      t2_serrB_wire[tout_int] = t2_serrB >> tout_int; 
      t2_derrB_wire[tout_int] = t2_derrB >> tout_int; 
      t2_padrB_wire[tout_int] = t2_padrB >> (tout_int*BITLROW); 
      t2_vldB_wire[tout_int] = t2_vldB >> tout_int; 
      t2_coutB_wire[tout_int] = t2_coutB >> (tout_int*BITCTRL); 
      t2_prtB_wire[tout_int] = t2_coutB_wire[tout_int] >> BITRDLY;
      t2_ptrB_wire[tout_int] = t2_coutB_wire[tout_int];
    end

  //reg [WIDTH-1:0]   vrddata_reg [0:NUMRDPT-1][0:READ_DELAY-1];
  reg               vrdfwrd_reg [0:NUMRDPT-1][0:READ_DELAY-1];
  reg               vrdserr_reg [0:NUMRDPT-1][0:READ_DELAY-1];
  reg               vrdderr_reg [0:NUMRDPT-1][0:READ_DELAY-1];
  reg [BITPADR-1:0] vrdpadr_reg [0:NUMRDPT-1][0:READ_DELAY-1];
  integer vrdh_int, vrdb_int;
  always @(posedge clk)
    for (vrdb_int=0; vrdb_int<NUMVBNK; vrdb_int=vrdb_int+1) begin
      if (t2_vldB_wire[vrdb_int]) begin
        //vrddata_reg[t2_prtB_wire[vrdb_int]][t2_ptrB_wire[vrdb_int]] <= t2_doutB_wire[vrdb_int];
        vrdfwrd_reg[t2_prtB_wire[vrdb_int]][t2_ptrB_wire[vrdb_int]] <= t2_fwrdB_wire[vrdb_int];
        vrdserr_reg[t2_prtB_wire[vrdb_int]][t2_ptrB_wire[vrdb_int]] <= t2_serrB_wire[vrdb_int];
        vrdderr_reg[t2_prtB_wire[vrdb_int]][t2_ptrB_wire[vrdb_int]] <= t2_derrB_wire[vrdb_int];
        vrdpadr_reg[t2_prtB_wire[vrdb_int]][t2_ptrB_wire[vrdb_int]] <= ({BITPADR{1'b0}}) | {1'b1,vrdb_int[1:0],t2_padrB_wire[vrdb_int]};
      end
      if (t1_vldC_wire[vrdb_int]) begin
        //vrddata_reg[t1_prtC_wire[vrdb_int]][t1_ptrC_wire[vrdb_int]] <= t1_doutC_wire[vrdb_int];
        vrdfwrd_reg[t1_prtC_wire[vrdb_int]][t1_ptrC_wire[vrdb_int]] <= t1_fwrdC_wire[vrdb_int];
        vrdserr_reg[t1_prtC_wire[vrdb_int]][t1_ptrC_wire[vrdb_int]] <= t1_serrC_wire[vrdb_int];
        vrdderr_reg[t1_prtC_wire[vrdb_int]][t1_ptrC_wire[vrdb_int]] <= t1_derrC_wire[vrdb_int];
        vrdpadr_reg[t1_prtC_wire[vrdb_int]][t1_ptrC_wire[vrdb_int]] <= ({BITPADR{1'b0}}) | {vrdb_int[1:0],t1_padrC_wire[vrdb_int]};
      end
    end // for (vrdb_int=0; vrdb_int<NUMVBNK; vrdb_int=vrdb_int+1)

  reg  vrddvld_reg [0:NUMRDPT-1][0:READ_DELAY-1];
  reg  vrddvld_reg_nxt [0:NUMRDPT-1][0:READ_DELAY-1];
  always_comb begin
    for (integer j=0; j<NUMRDPT; j++)
      for (integer i=0; i<READ_DELAY; i++)
        vrddvld_reg_nxt[j][i] = rst ? 1'b0 : vrddvld_reg[j][i];
    for (integer j=0; j<NUMRDPT; j++)
      vrddvld_reg_nxt[j][read_ptr] = 1'b0;
    for (integer b=0; b<NUMVBNK; b=b+1) begin
      if (t2_vldB_wire[b]) 
        vrddvld_reg_nxt[t2_prtB_wire[b]][t2_ptrB_wire[b]] = 1'b1; 
      if (t1_vldC_wire[b])
        vrddvld_reg_nxt[t1_prtC_wire[b]][t1_ptrC_wire[b]] = 1'b1;
    end
  end

  always @(posedge clk)
    for (integer j=0; j<NUMRDPT; j++)
      for (integer i=0; i<READ_DELAY; i++)
        vrddvld_reg[j][i] <= vrddvld_reg_nxt[j][i];

  reg [2*WIDTH-1:0] vrddata_array_din [0:NUMVBNK-1];
  reg [2:0] vrddata_array_sel [0:NUMVBNK-1];
  reg [2*BITRDPT-1:0] vrddata_array_prt [0:NUMVBNK-1];
  reg [2*BITRDLY-1:0] vrddata_array_ptr [0:NUMVBNK-1];
  
  always_comb begin
    for(int i=0; i<NUMVBNK; i++) begin
      vrddata_array_din[i] = {t1_doutC_wire[i],t2_doutB_wire[i]};
      vrddata_array_sel[i] = ((t2_vldB_wire[i] & t1_vldC_wire[i])? 3'b100 : t2_vldB_wire[i]? 3'b001 : t1_vldC_wire[i]? 3'b010 : 3'b000);//(t2_vldB_wire[i]? 3'b001 : t1_vldC_wire[i]? 3'b010 : 3'b100);
      vrddata_array_prt[i] = {t1_prtC_wire[i],t2_prtB_wire[i]}; //(t2_vldB_wire[i]? t2_prtB_wire[i] : t1_vldC_wire[i]? t1_prtC_wire[i] : {BITRDPT{1'b0}});
      vrddata_array_ptr[i] = {t1_ptrC_wire[i],t2_ptrB_wire[i]};//t2_vldB_wire[i]? t2_ptrB_wire[i] : t1_vldC_wire[i]? t1_ptrC_wire[i] : {BITRDLY{1'b0}};
    end
  end
  
  wire [WIDTH-1:0]  vrddata_reg_dout [0:NUMRDPT-1][0:READ_DELAY-1];
      
  f32_vrddata_array #(.WIDTH(WIDTH), .NUMRDPT(NUMRDPT), .NUMVBNK(NUMVBNK), .BITRDPT(BITRDPT), .BITRDLY(BITRDLY), .READ_DELAY(READ_DELAY))  f32_vrddata_array_int 
    (.clk(clk), .din(vrddata_array_din), .dout(vrddata_reg_dout), .sel(vrddata_array_sel), .prt(vrddata_array_prt), .ptr(vrddata_array_ptr));
   
   

  wire               t1_vldC_wire_0 = t1_vldC_wire[0];
  wire [BITRDPT-1:0] t1_prtC_wire_0 = t1_prtC_wire[0];
  wire [BITRDLY-1:0] t1_ptrC_wire_0 = t1_ptrC_wire[0];
  wire [WIDTH-1:0]   t1_doutC_wire_0 = t1_doutC_wire[0];
  wire [WIDTH-1:0] vrddata_reg_C = vrddata_reg_dout[0]['hC];
  wire [WIDTH-1:0] vrddata_reg_D = vrddata_reg_dout[0]['hD];

  wire vread_vld_wire [0:NUMRDPT-1];
  wire [WIDTH-1:0] vdout_wire [0:NUMRDPT-1];
  wire vread_fwrd_wire [0:NUMRDPT-1];
  wire vread_serr_wire [0:NUMRDPT-1];
  wire vread_derr_wire [0:NUMRDPT-1];
  wire vread_uflw_wire [0:NUMRDPT-1];
  wire [BITPADR-1:0] vread_padr_wire [0:NUMRDPT-1];
  genvar vmap_int;
  generate for (vmap_int=0; vmap_int<NUMRDPT; vmap_int=vmap_int+1) begin: vdo_loop
    assign vread_vld_wire[vmap_int]  = vread_out[vmap_int];
    assign vdout_wire[vmap_int]      = vrddata_reg_dout[vmap_int][vrdptr_out[vmap_int]];
    assign vread_fwrd_wire[vmap_int] = vrdfwrd_reg[vmap_int][vrdptr_out[vmap_int]];
    assign vread_serr_wire[vmap_int] = vrdserr_reg[vmap_int][vrdptr_out[vmap_int]];
    assign vread_derr_wire[vmap_int] = vrdderr_reg[vmap_int][vrdptr_out[vmap_int]];
    assign vread_padr_wire[vmap_int] = vrdpadr_reg[vmap_int][vrdptr_out[vmap_int]];
    assign vread_uflw_wire[vmap_int] = vread_out[vmap_int] && !vrddvld_reg[vmap_int][vrdptr_out[vmap_int]];
  end
  endgenerate

  reg [NUMRDPT-1:0] vread_vld_tmp;
  reg [NUMRDPT*WIDTH-1:0] vdout_tmp;
  reg [NUMRDPT-1:0] vread_fwrd_tmp;
  reg [NUMRDPT-1:0] vread_serr_tmp;
  reg [NUMRDPT-1:0] vread_derr_tmp;
  reg [NUMRDPT*BITPADR-1:0] vread_padr_tmp;
  reg [NUMRDPT-1:0] vread_uflw_tmp;
  integer vdo_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_fwrd_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    vread_uflw_tmp = 0;
    for (vdo_int=0; vdo_int<NUMRDPT; vdo_int=vdo_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_vld_wire[vdo_int] << vdo_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vdo_int] << (vdo_int*WIDTH));
      vread_fwrd_tmp = vread_fwrd_tmp | (vread_fwrd_wire[vdo_int] << vdo_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vdo_int] << vdo_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vdo_int] << vdo_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vdo_int] << (vdo_int*BITPADR));
      vread_uflw_tmp = vread_uflw_tmp | (vread_uflw_wire[vdo_int] << vdo_int);
    end
  end

  reg [NUMRDPT-1:0] vread_vld_reg [0:FLOPOUT];
  reg [NUMRDPT*WIDTH-1:0] vdout_reg [0:FLOPOUT];
  reg [NUMRDPT-1:0] vread_fwrd_reg [0:FLOPOUT];
  reg [NUMRDPT-1:0] vread_serr_reg [0:FLOPOUT];
  reg [NUMRDPT-1:0] vread_derr_reg [0:FLOPOUT];
  reg [NUMRDPT*BITPADR-1:0] vread_padr_reg [0:FLOPOUT];
  reg [NUMVBNK-1:0] vread_uflw_reg [0:FLOPOUT];
  reg [NUMVBNK-1:0] whfifo_oflw_reg [0:FLOPOUT];
  reg [NUMVBNK-1:0] rhfifo_oflw_reg [0:FLOPOUT];
  reg [NUMVBNK-1:0] wlfifo_oflw_reg [0:FLOPOUT];
  reg [NUMVBNK-1:0] rlfifo_oflw_reg [0:FLOPOUT];
  genvar vdo_var;
  generate for (vdo_var=0; vdo_var<=FLOPOUT; vdo_var=vdo_var+1) begin: vreg_loop
    if (vdo_var>0) begin: flp_loop
      always @(posedge clk) begin
        vread_vld_reg[vdo_var] <= vread_vld_reg[vdo_var-1];
        vdout_reg[vdo_var] <= vdout_reg[vdo_var-1];
        vread_fwrd_reg[vdo_var] <= vread_fwrd_reg[vdo_var-1];
        vread_serr_reg[vdo_var] <= vread_serr_reg[vdo_var-1];
        vread_derr_reg[vdo_var] <= vread_derr_reg[vdo_var-1];
        vread_padr_reg[vdo_var] <= vread_padr_reg[vdo_var-1];
        vread_uflw_reg[vdo_var] <= vread_uflw_reg[vdo_var-1];
        whfifo_oflw_reg[vdo_var] <= whfifo_oflw_reg[vdo_var-1];
        rhfifo_oflw_reg[vdo_var] <= rhfifo_oflw_reg[vdo_var-1];
        wlfifo_oflw_reg[vdo_var] <= wlfifo_oflw_reg[vdo_var-1];
        rlfifo_oflw_reg[vdo_var] <= rlfifo_oflw_reg[vdo_var-1];
      end
    end else begin: nflp_loop
      always_comb begin
        vread_vld_reg[vdo_var] = vread_vld_tmp;
        vdout_reg[vdo_var] = vdout_tmp;
        vread_fwrd_reg[vdo_var] = vread_fwrd_tmp;
        vread_serr_reg[vdo_var] = vread_serr_tmp;
        vread_derr_reg[vdo_var] = vread_derr_tmp;
        vread_padr_reg[vdo_var] = vread_padr_tmp;
        vread_uflw_reg[vdo_var] = vread_uflw_tmp;
        whfifo_oflw_reg[vdo_var] = whfifo_oflw_tmp;
        rhfifo_oflw_reg[vdo_var] = rhfifo_oflw_tmp;
        wlfifo_oflw_reg[vdo_var] = wlfifo_oflw_tmp;
        rlfifo_oflw_reg[vdo_var] = rlfifo_oflw_tmp;
      end
    end
  end
  endgenerate

  assign vread_vld = vread_vld_reg[FLOPOUT];
  assign vdout = vdout_reg[FLOPOUT];
  assign vread_fwrd = vread_fwrd_reg[FLOPOUT];
  assign vread_serr = vread_serr_reg[FLOPOUT];
  assign vread_derr = vread_derr_reg[FLOPOUT];
  assign vread_padr = vread_padr_reg[FLOPOUT];
  assign rdrob_uflw = vread_uflw_reg[FLOPOUT];
  assign whfifo_oflw = whfifo_oflw_reg[FLOPOUT];
  assign rhfifo_oflw = rhfifo_oflw_reg[FLOPOUT];
  assign wlfifo_oflw = wlfifo_oflw_reg[FLOPOUT];
  assign rlfifo_oflw = rlfifo_oflw_reg[FLOPOUT];

endmodule // core_mrnws_a33


