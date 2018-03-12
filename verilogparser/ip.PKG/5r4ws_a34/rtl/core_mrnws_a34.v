module core_mrnws_a34 (vwrite, vwraddr, vdin,
                       vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                       wrfifo_oflw, rdfifo_oflw, rdrob_uflw,
                       t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB, t1_cinB, t1_vldB, t1_coutB,
                       ready, clk, rst);

  parameter BITWDTH = 5;
  parameter WIDTH = 32;
  parameter NUMWRPT = 5;
  parameter BITWRPT = 3;
  parameter NUMRDPT = 4;
  parameter BITRDPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVBNK = 4;
  parameter BITVBNK = 2;
  parameter NUMVROW = 2048;
  parameter BITVROW = 11;
  parameter NUMCELL = 80;
  parameter BITCELL = 7;
  parameter NUMQUEU = 1696;
  parameter BITQUEU = 10;
  parameter WFFOCNT = 16;
  parameter RFFOCNT = 16;
  parameter BITWFFO = 4;
  parameter BITRFFO = 4;
  parameter BITPADR = 14;
  parameter READ_DELAY = 8;
  parameter BITRDLY = 4;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter BITCTRL = BITRDPT+BITRDLY;

  parameter BITLROW = 13;

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

  output [NUMVBNK-1:0]          wrfifo_oflw;
  output [NUMVBNK-1:0]          rdfifo_oflw;
  output [NUMRDPT-1:0]          rdrob_uflw;

  output [NUMVBNK-1:0]          t1_writeA;
  output [NUMVBNK*BITLROW-1:0]  t1_addrA;
  output [NUMVBNK*WIDTH-1:0]    t1_dinA;
  output [NUMVBNK-1:0]          t1_readB;
  output [NUMVBNK*BITLROW-1:0]  t1_addrB;
  input [NUMVBNK*WIDTH-1:0]     t1_doutB;
  input [NUMVBNK-1:0]           t1_fwrdB;
  input [NUMVBNK-1:0]           t1_serrB;
  input [NUMVBNK-1:0]           t1_derrB;
  input [NUMVBNK*BITLROW-1:0]   t1_padrB;
  output [NUMVBNK*BITCTRL-1:0]  t1_cinB;
  input [NUMVBNK-1:0]           t1_vldB;
  input [NUMVBNK*BITCTRL-1:0]   t1_coutB;
 
  output                        ready;
  input                         clk;
  input                         rst;
  
  reg ready;
  always @(posedge clk)
    ready <= !rst;

  wire ready_wire;

  wire vread_wire [0:NUMRDPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMRDPT-1];
  wire [BITVBNK-1:0] vrdbadr_wire [0:NUMRDPT-1];
  wire [BITCELL-1:0] vrdwadr_wire [0:NUMRDPT-1];
  wire [BITADDR-BITCELL-BITVBNK-1:0] vrdradr_wire [0:NUMRDPT-1]; 
  wire [BITVROW-1:0] vrdladr_wire [0:NUMRDPT-1]; 

  wire vwrite_wire [0:NUMWRPT-1];
  wire [BITADDR-1:0] vwraddr_wire [0:NUMWRPT-1];
  wire [BITVBNK-1:0] vwrbadr_wire [0:NUMWRPT-1];
  wire [BITCELL-1:0] vwrwadr_wire [0:NUMWRPT-1];
  wire [BITADDR-BITCELL-BITVBNK-1:0] vwrradr_wire [0:NUMWRPT-1];
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
      assign vrdradr_wire[np2_var] = vrdaddr_wire[np2_var] >> (BITCELL+BITVBNK);
      assign vrdladr_wire[np2_var] = NUMQUEU*vrdwadr_wire[np2_var]+vrdradr_wire[np2_var];
    end
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite_reg[FLOPIN-1] >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr_reg[FLOPIN-1] >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin_reg[FLOPIN-1] >> (np2_var*WIDTH);
      assign vwrbadr_wire[np2_var] = vwraddr_wire[np2_var];
      assign vwrwadr_wire[np2_var] = vwraddr_wire[np2_var] >> BITVBNK;
      assign vwrradr_wire[np2_var] = vwraddr_wire[np2_var] >> (BITCELL+BITVBNK);
      assign vwrladr_wire[np2_var] = NUMQUEU*vwrwadr_wire[np2_var]+vwrradr_wire[np2_var];
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);
      assign vrdbadr_wire[np2_var] = vrdaddr_wire[np2_var];
      assign vrdwadr_wire[np2_var] = vrdaddr_wire[np2_var] >> BITVBNK;
      assign vrdradr_wire[np2_var] = vrdaddr_wire[np2_var] >> (BITCELL+BITVBNK);
      assign vrdladr_wire[np2_var] = NUMQUEU*vrdwadr_wire[np2_var]+vrdradr_wire[np2_var];
    end
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);
      assign vwrbadr_wire[np2_var] = vwraddr_wire[np2_var];
      assign vwrwadr_wire[np2_var] = vwraddr_wire[np2_var] >> BITVBNK;
      assign vwrradr_wire[np2_var] = vwraddr_wire[np2_var] >> (BITCELL+BITVBNK);
      assign vwrladr_wire[np2_var] = NUMQUEU*vwrwadr_wire[np2_var]+vwrradr_wire[np2_var];
    end
  end
  endgenerate

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

  reg [BITWFFO:0]    wrfifo_cnt [0:NUMVBNK-1];
  reg                wrfifo_new_vld [0:NUMVBNK-1][0:WFFOCNT-1];
  reg [BITVROW-1:0]  wrfifo_new_row [0:NUMVBNK-1][0:WFFOCNT-1];
  //reg [WIDTH-1:0]    wrfifo_new_dat [0:NUMVBNK-1][0:WFFOCNT-1];
  
   wire [WIDTH-1:0]  wrfifo_new_dat_out_0 [0:NUMVBNK-1];
   //wire [WIDTH-1:0]  wrfifo_vwrite_dat_wire [0:1][0:NUMVBNK-1][0:WFFOCNT-1];
   wire [WIDTH-1:0]  wrfifo_vwrite_dat [0:NUMVBNK-1][0:WFFOCNT-1];
   wire [3-1:0]      wrfifo_new_dat_sel [0:NUMVBNK-1][0:WFFOCNT-1];
   wire [3:0] 	     wrfifo_dcnt_wire [0:NUMVBNK-1][0:WFFOCNT-1];  

  wire [NUMVBNK-1:0] wrfifo_oflw_tmp;
  wire [NUMVBNK-1:0] rdfifo_oflw_tmp;

  genvar wffo_int, wffb_int;
  generate for (wffb_int=0; wffb_int<NUMVBNK; wffb_int=wffb_int+1) begin: wffb_loop

    assign wrfifo_oflw_tmp[wffb_int] = (wrfifo_cnt[wffb_int] > WFFOCNT);

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
        if (vwrite_wire[vwrn_int] && (vwrbadr_wire[vwrn_int]==wffb_int)) begin
          vwrite_bnk_nxt[vwr_bnk_sel] = 1'b1;
          vwrite_row_nxt[vwr_bnk_sel] = vwrladr_wire[vwrn_int];
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
      wrfifo_dcnt = |rate_limit;
      wrfifo_dcnt = (wrfifo_cnt[wffb_int] > wrfifo_dcnt) ? wrfifo_dcnt : wrfifo_cnt[wffb_int]; 
      wrfifo_ecnt = 0;
      for (wffc_int=0; wffc_int<NUMWRPT; wffc_int=wffc_int+1)
        wrfifo_ecnt = wrfifo_ecnt + vwrite_bnk[wffc_int];
    end

    always @(posedge clk)
      if (rst)
        wrfifo_cnt[wffb_int] <= 0;
      else
        wrfifo_cnt[wffb_int] <= wrfifo_cnt[wffb_int] + wrfifo_ecnt - wrfifo_dcnt;

    for (wffo_int=0; wffo_int<WFFOCNT; wffo_int=wffo_int+1) begin: wffo_loop
      reg [3:0] vwr_sel;
      reg [3:0] fifo_cnt_temp;

      integer 	fcnt_int;
      always_comb begin
        vwr_sel = NUMWRPT;
        for (fcnt_int=0; fcnt_int<NUMWRPT; fcnt_int=fcnt_int+1)
          if (vwrite_bnk[fcnt_int] && (wffo_int == (wrfifo_cnt[wffb_int] - wrfifo_dcnt + fcnt_int)))
            vwr_sel = fcnt_int;

        fifo_cnt_temp = wrfifo_cnt[wffb_int] - wrfifo_dcnt;
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
        end // else: !if(wffo_int < fifo_cnt_temp)
      end // always_comb

       assign wrfifo_new_dat_sel [wffb_int][wffo_int] = (((vwr_sel != NUMWRPT) && vwrite_bnk[vwr_sel])? 3'b001 : (|wrfifo_dcnt && (wffo_int<WFFOCNT-wrfifo_dcnt))? 3'b010 : 3'b100);
       assign wrfifo_dcnt_wire [wffb_int][wffo_int] = wrfifo_dcnt;
       assign wrfifo_vwrite_dat [wffb_int][wffo_int] = vwrite_dat[vwr_sel] ;
       
      reg               wrfifo_new_vld_next;
      reg [BITVROW-1:0] wrfifo_new_row_next;
      //reg [WIDTH-1:0]   wrfifo_new_dat_next;
      always_comb
        if ((vwr_sel != NUMWRPT) && vwrite_bnk[vwr_sel]) begin
          wrfifo_new_vld_next = 1'b1;
          wrfifo_new_row_next = vwrite_row[vwr_sel];
          //wrfifo_new_dat_next = vwrite_dat[vwr_sel];
        end else if (|wrfifo_dcnt && (wffo_int<WFFOCNT-wrfifo_dcnt)) begin
          wrfifo_new_vld_next = wrfifo_new_vld[wffb_int][wffo_int+wrfifo_dcnt];
          wrfifo_new_row_next = wrfifo_new_row[wffb_int][wffo_int+wrfifo_dcnt];
          //wrfifo_new_dat_next = wrfifo_new_dat[wffb_int][wffo_int+wrfifo_dcnt];
        end else begin
          wrfifo_new_vld_next = wrfifo_new_vld[wffb_int][wffo_int];
          wrfifo_new_row_next = wrfifo_new_row[wffb_int][wffo_int];
          //wrfifo_new_dat_next = wrfifo_new_dat[wffb_int][wffo_int];
        end

      always @(posedge clk) begin
        wrfifo_new_vld[wffb_int][wffo_int] <= wrfifo_new_vld_next;
        wrfifo_new_row[wffb_int][wffo_int] <= wrfifo_new_row_next;
        //wrfifo_new_dat[wffb_int][wffo_int] <= wrfifo_new_dat_next;
      end
    end
  end
  endgenerate

   f32_wrfifo_array2 #(.WIDTH(WIDTH), .NUMWRPT(3), .NUMVBNK(NUMVBNK), .WFFOCNT(WFFOCNT)) wrfifo_array_inst 
    (.clk(clk), .wrfifo_new_dat_out_0(wrfifo_new_dat_out_0), .wrfifo_vwrite_dat(wrfifo_vwrite_dat), .wrfifo_dcnt(wrfifo_dcnt_wire), .wrfifo_new_dat_sel(wrfifo_new_dat_sel));

  reg [BITRFFO:0]    rdfifo_cnt [0:NUMVBNK-1];
  reg                rdfifo_new_vld [0:NUMVBNK-1][0:RFFOCNT-1];
  reg [BITVROW-1:0]  rdfifo_new_row [0:NUMVBNK-1][0:RFFOCNT-1];
  reg [BITRDPT-1:0]  rdfifo_new_prt [0:NUMVBNK-1][0:RFFOCNT-1];
  reg [BITRDLY-1:0]  rdfifo_new_ptr [0:NUMVBNK-1][0:RFFOCNT-1];

  genvar rffo_int, rffb_int;
  generate for (rffb_int=0; rffb_int<NUMVBNK; rffb_int=rffb_int+1) begin: rffb_loop

    assign rdfifo_oflw_tmp[rffb_int] = (rdfifo_cnt[rffb_int] > RFFOCNT);

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
        if (vread_wire[vrdn_int] && (vrdbadr_wire[vrdn_int]==rffb_int)) begin
          vread_bnk_nxt[vrd_bnk_sel] = 1'b1;
          vread_row_nxt[vrd_bnk_sel] = vrdladr_wire[vrdn_int];
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
      rdfifo_dcnt = |rate_limit;
      rdfifo_dcnt = (rdfifo_cnt[rffb_int] > rdfifo_dcnt) ? rdfifo_dcnt : rdfifo_cnt[rffb_int]; 
      rdfifo_ecnt = 0;
      for (rffc_int=0; rffc_int<NUMRDPT; rffc_int=rffc_int+1)
        rdfifo_ecnt = rdfifo_ecnt + vread_bnk[rffc_int];
    end

    always @(posedge clk)
      if (rst)
        rdfifo_cnt[rffb_int] <= 0;
      else
        rdfifo_cnt[rffb_int] <= rdfifo_cnt[rffb_int] + rdfifo_ecnt - rdfifo_dcnt;

    for (rffo_int=0; rffo_int<RFFOCNT; rffo_int=rffo_int+1) begin: rffo_loop
      reg [3:0] vrd_sel;
      reg [3:0] fifo_cnt_temp;

      integer fcnt_int;
      always_comb begin
        vrd_sel = NUMRDPT;
        for (fcnt_int=0; fcnt_int<NUMRDPT; fcnt_int=fcnt_int+1)
          if (vread_bnk[fcnt_int] && (rffo_int == (rdfifo_cnt[rffb_int] - rdfifo_dcnt + fcnt_int)))
            vrd_sel = fcnt_int;

        fifo_cnt_temp = rdfifo_cnt[rffb_int] - rdfifo_dcnt;
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
      end else if (|rdfifo_dcnt && (rffo_int<RFFOCNT-rdfifo_dcnt)) begin
        rdfifo_new_vld_next = rdfifo_new_vld[rffb_int][rffo_int+rdfifo_dcnt];
        rdfifo_new_row_next = rdfifo_new_row[rffb_int][rffo_int+rdfifo_dcnt];
        rdfifo_new_prt_next = rdfifo_new_prt[rffb_int][rffo_int+rdfifo_dcnt];
        rdfifo_new_ptr_next = rdfifo_new_ptr[rffb_int][rffo_int+rdfifo_dcnt];
      end else begin
        rdfifo_new_vld_next = rdfifo_new_vld[rffb_int][rffo_int];
        rdfifo_new_row_next = rdfifo_new_row[rffb_int][rffo_int];
        rdfifo_new_prt_next = rdfifo_new_prt[rffb_int][rffo_int];
        rdfifo_new_ptr_next = rdfifo_new_ptr[rffb_int][rffo_int];
      end

      always @(posedge clk) begin
        rdfifo_new_vld[rffb_int][rffo_int] <= rdfifo_new_vld_next;
        rdfifo_new_row[rffb_int][rffo_int] <= rdfifo_new_row_next;
        rdfifo_new_prt[rffb_int][rffo_int] <= rdfifo_new_prt_next;
        rdfifo_new_ptr[rffb_int][rffo_int] <= rdfifo_new_ptr_next;
      end
    end
  end
  endgenerate

  reg [NUMVBNK-1:0] t1_writeA;
  reg [NUMVBNK*BITLROW-1:0] t1_addrA;
  reg [NUMVBNK*WIDTH-1:0] t1_dinA;
  integer t1wb_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (t1wb_int=0; t1wb_int<NUMVBNK; t1wb_int=t1wb_int+1)
      if (|rate_limit && (wrfifo_cnt[t1wb_int]>0)) begin
        t1_writeA = t1_writeA | (1'b1 << t1wb_int);
        t1_addrA = t1_addrA | (wrfifo_new_row[t1wb_int][0] << (t1wb_int*BITLROW));
        t1_dinA = t1_dinA | (/*wrfifo_new_dat[t1wb_int][0]*/wrfifo_new_dat_out_0[t1wb_int] << (t1wb_int*WIDTH));
      end
  end

  reg [NUMVBNK-1:0] t1_readB;
  reg [NUMVBNK*BITLROW-1:0] t1_addrB;
  reg [NUMVBNK*BITCTRL-1:0] t1_cinB;
  integer t1rb_int;
  always_comb begin
    t1_readB = 0;
    t1_addrB = 0;
    t1_cinB = 0;
    for (t1rb_int=0; t1rb_int<NUMVBNK; t1rb_int=t1rb_int+1)
      if (|rate_limit && |rdfifo_cnt[t1rb_int]) begin
        t1_readB = t1_readB | (1'b1 << t1rb_int);
        t1_addrB = t1_addrB | (rdfifo_new_row[t1rb_int][0] << (t1rb_int*BITLROW));
        t1_cinB = t1_cinB | ({rdfifo_new_prt[t1rb_int][0],rdfifo_new_ptr[t1rb_int][0]} << (t1rb_int*BITCTRL));
      end
  end

  reg [WIDTH-1:0] t1_doutB_wire [0:NUMVBNK-1]; 
  reg t1_fwrdB_wire [0:NUMVBNK-1];
  reg t1_serrB_wire [0:NUMVBNK-1];
  reg t1_derrB_wire [0:NUMVBNK-1];
  reg [BITVROW-1:0] t1_padrB_wire [0:NUMVBNK-1];
  reg t1_vldB_wire [0:NUMVBNK-1];
  reg [BITCTRL-1:0] t1_coutB_wire [0:NUMVBNK-1];
  reg [BITRDPT-1:0] t1_prtB_wire [0:NUMVBNK-1];
  reg [BITRDLY-1:0] t1_ptrB_wire [0:NUMVBNK-1];
  integer tout_int;
  always_comb
    for (tout_int=0; tout_int<NUMVBNK; tout_int=tout_int+1) begin
      t1_doutB_wire[tout_int] = t1_doutB >> (tout_int*WIDTH); 
      t1_fwrdB_wire[tout_int] = t1_fwrdB >> tout_int; 
      t1_serrB_wire[tout_int] = t1_serrB >> tout_int; 
      t1_derrB_wire[tout_int] = t1_derrB >> tout_int; 
      t1_padrB_wire[tout_int] = t1_padrB >> (tout_int*BITVROW); 
      t1_vldB_wire[tout_int] = t1_vldB >> tout_int; 
      t1_coutB_wire[tout_int] = t1_coutB >> (tout_int*BITCTRL); 
      t1_prtB_wire[tout_int] = t1_coutB_wire[tout_int] >> BITRDLY;
      t1_ptrB_wire[tout_int] = t1_coutB_wire[tout_int];
    end

  reg  vrddvld_reg [0:NUMRDPT-1][0:READ_DELAY-1];
  reg  vrddvld_reg_nxt [0:NUMRDPT-1][0:READ_DELAY-1];
  always_comb begin
    for (integer j=0; j<NUMRDPT; j++)
      for (integer i=0; i<READ_DELAY; i++)
        vrddvld_reg_nxt[j][i] = rst ? 1'b0 : vrddvld_reg[j][i];
    for (integer j=0; j<NUMRDPT; j++) 
      vrddvld_reg_nxt[j][read_ptr] = 1'b0;
    for (integer b=0; b<NUMVBNK; b=b+1) begin
      if (t1_vldB_wire[b]) 
        vrddvld_reg_nxt[t1_prtB_wire[b]][t1_ptrB_wire[b]] = 1'b1;
    end
  end
  
  always @(posedge clk)
    for (integer j=0; j<NUMRDPT; j++)
      for (integer i=0; i<READ_DELAY; i++)
        vrddvld_reg[j][i] <= vrddvld_reg_nxt[j][i];

  reg [WIDTH-1:0]   vrddata_reg [0:NUMRDPT-1][0:READ_DELAY-1];
  reg               vrdfwrd_reg [0:NUMRDPT-1][0:READ_DELAY-1];
  reg               vrdserr_reg [0:NUMRDPT-1][0:READ_DELAY-1];
  reg               vrdderr_reg [0:NUMRDPT-1][0:READ_DELAY-1];
  reg [BITPADR-1:0] vrdpadr_reg [0:NUMRDPT-1][0:READ_DELAY-1];
  integer vrdh_int, vrdb_int;
  always @(posedge clk)
    for (vrdb_int=0; vrdb_int<NUMVBNK; vrdb_int=vrdb_int+1) begin
      if (t1_vldB_wire[vrdb_int]) begin
        vrddata_reg[t1_prtB_wire[vrdb_int]][t1_ptrB_wire[vrdb_int]] <= t1_doutB_wire[vrdb_int];
        vrdfwrd_reg[t1_prtB_wire[vrdb_int]][t1_ptrB_wire[vrdb_int]] <= t1_fwrdB_wire[vrdb_int];
        vrdserr_reg[t1_prtB_wire[vrdb_int]][t1_ptrB_wire[vrdb_int]] <= t1_serrB_wire[vrdb_int];
        vrdderr_reg[t1_prtB_wire[vrdb_int]][t1_ptrB_wire[vrdb_int]] <= t1_derrB_wire[vrdb_int];
        vrdpadr_reg[t1_prtB_wire[vrdb_int]][t1_ptrB_wire[vrdb_int]] <= {vrdb_int[1:0],t1_padrB_wire[vrdb_int]};
      end
    end

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
    assign vdout_wire[vmap_int]      = vrddata_reg[vmap_int][vrdptr_out[vmap_int]];
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
    vread_vld_tmp  = 0;
    vdout_tmp      = 0;
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
  reg [NUMRDPT-1:0] vread_uflw_reg [0:FLOPOUT];
  reg [NUMVBNK-1:0] wrfifo_oflw_reg [0:FLOPOUT];
  reg [NUMVBNK-1:0] rdfifo_oflw_reg [0:FLOPOUT];
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
        wrfifo_oflw_reg[vdo_var] <= wrfifo_oflw_reg[vdo_var-1];
        rdfifo_oflw_reg[vdo_var] <= rdfifo_oflw_reg[vdo_var-1];
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
        wrfifo_oflw_reg[vdo_var] = wrfifo_oflw_tmp;
        rdfifo_oflw_reg[vdo_var] = rdfifo_oflw_tmp;
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
  assign wrfifo_oflw = wrfifo_oflw_reg[FLOPOUT];
  assign rdfifo_oflw = rdfifo_oflw_reg[FLOPOUT];

endmodule


