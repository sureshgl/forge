/*
*
  * 663552 addressable locations of 32B (+ECC) each
  * 663552/9216 queues = 72 cells/queue; 72 cells/4 banks = 18 cells/bank
  * 14-bit queue ID + 5 cell ID + 2 bank ID = 21-bit external address
  *
*/
module ip_top_sva_2_mrnws_a33
#(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMRDPT = 4,
parameter     BITRDPT = 2,
parameter     NUMWRPT = 4,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVBNK = 4,
parameter     BITVBNK = 2,
parameter     NUMVROW = 2048,
parameter     BITVROW = 11,
parameter     NUMHROW = 512,
parameter     BITHROW = 9,
parameter     NUMLROW = 1536,
parameter     BITLROW = 11,
parameter     BITHVRW = 7,
parameter     NUMCELL = 80,
parameter     BITCELL = 7,
parameter     NUMQUEU = 9216,
parameter     RFFOCNT = 16,
parameter     WFFOCNT = 16
)
(
input                       clk,
input                       rst,
input                       ready,
input [NUMWRPT-1:0]         write,
input [NUMWRPT*BITADDR-1:0] wr_adr,
input [NUMWRPT*WIDTH-1:0]   din,
input [NUMRDPT-1:0]         read,
input [NUMRDPT*BITADDR-1:0] rd_adr,
input [NUMVBNK-1:0]         whfifo_oflw,
input [NUMVBNK-1:0]         wlfifo_oflw,
input [NUMVBNK-1:0]         rhfifo_oflw,
input [NUMVBNK-1:0]         rlfifo_oflw,
input [BITADDR-1:0]         select_addr,
input [BITWDTH-1:0]         select_bit,
input [BITVBNK-1:0]         select_bnk,
input                       select_prio,
input [BITCELL-BITVBNK-1:0] select_vwrd,
input [BITADDR-BITCELL-1:0] select_vrow,
input [BITHROW-1:0]         select_hrow,
input [BITLROW-1:0]         select_lrow,
input [BITHVRW-1:0]         select_hvrw
);

localparam     BITQUEU = BITADDR-BITCELL;
localparam     NUMPRIO = 2;
localparam     HI_PRIO  = 0;
localparam     LO_PRIO  = 1;
localparam     WARHAZ   = 34;
localparam     RAWHAZ   = 34;

localparam     RHOPCNT  = 4;
localparam     RHPWSIZ  = 4; 
localparam     RLOPCNT  = 4;
localparam     RLPWSIZ  = 6; 
localparam     RCNTBIT  = 4;

localparam     WMOPCNT  = 4;
localparam     WHPWSIZ  = 12;
localparam     WLPWSIZ  = 26;
localparam     WCOPCNT  = 1;
localparam     WCPWSIZ  = 26;
localparam     WCNTBIT  = 5;

/* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
read HP r0-r3 4-in-4  across four ports
read LP r0-r3 4-in-6  across four ports

write HP w0-w3 4-in-12 per port to same bank
write HP w4    1-in-26 
write LP w0-w3 4-in-26 per port
write LP w4    1-in-26

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< */

reg [BITADDR-1:0] write_addr [0:NUMWRPT-1]; 
reg [BITVBNK-1:0] write_bank [0:NUMWRPT-1]; 
reg [BITCELL-1:0] write_cell [0:NUMWRPT-1]; 
reg [BITQUEU-1:0] write_queu [0:NUMWRPT-1]; 
reg               write_prio [0:NUMWRPT-1]; 
always_comb begin : wrxf
  integer wi;
  for (wi=0;wi<NUMWRPT;wi=wi+1) begin
    write_addr[wi] = wr_adr >> (wi*BITADDR);
    write_bank[wi] = write_addr[wi][BITVBNK-1:0];
    write_cell[wi] = write_addr[wi][BITCELL-1:0];
    write_queu[wi] = write_addr[wi][BITADDR-1:BITCELL];
    write_prio[wi] = |(write_addr[wi][BITCELL-1:BITVBNK]);
  end  
end

reg [BITADDR-1:0] read_addr [0:NUMRDPT-1]; 
reg [BITVBNK-1:0] read_bank [0:NUMRDPT-1]; 
reg [BITCELL-1:0] read_cell [0:NUMRDPT-1]; 
reg [BITQUEU-1:0] read_queu [0:NUMRDPT-1]; 
reg               read_prio [0:NUMRDPT-1]; 
always_comb begin : rdxf
  integer ri;
  for (ri=0;ri<NUMRDPT;ri=ri+1) begin
    read_addr[ri] = rd_adr >> (ri*BITADDR);
    read_bank[ri] = read_addr[ri][BITVBNK-1:0];
    read_cell[ri] = read_addr[ri][BITCELL-1:0];
    read_queu[ri] = read_addr[ri][BITADDR-1:BITCELL];
    read_prio[ri] = |(read_addr[ri][BITCELL-1:BITVBNK]);
  end
end

genvar rd_var;
generate for (rd_var=0; rd_var<NUMRDPT; rd_var=rd_var+1) begin: rd_loop
  assume_rd_range_check      : assert property (@(posedge clk) disable iff (rst) read[rd_var] |-> ((read_queu[rd_var] < NUMQUEU) && (read_cell[rd_var] < NUMCELL)));
//  assume_rd_hp_range_check   : assert property (@(posedge clk) disable iff (rst) read[rd_var] |-> ((read_queu[rd_var] < NUMQUEU) && (read_cell[rd_var] < NUMCELL) && (read_prio[rd_var]==HI_PRIO)));
//  assume_rd_lp_range_check   : assert property (@(posedge clk) disable iff (rst) read[rd_var] |-> ((read_queu[rd_var] < NUMQUEU) && (read_cell[rd_var] < NUMCELL) && (read_prio[rd_var]==LO_PRIO)));
end
endgenerate

genvar wr_var;
generate for (wr_var=0; wr_var<NUMWRPT; wr_var=wr_var+1) begin: wr_loop
  assume_wr_range_check      : assert property (@(posedge clk) disable iff (rst) write[wr_var] |-> ((write_queu[wr_var] < NUMQUEU) && (write_cell[wr_var] < NUMCELL)));
//  assume_wr_hp_range_check   : assert property (@(posedge clk) disable iff (rst) write[wr_var] |-> ((write_queu[wr_var] < NUMQUEU) && (write_cell[wr_var] < NUMCELL) && (write_prio[wr_var]==HI_PRIO)));
//  assume_wr_lp_range_check   : assert property (@(posedge clk) disable iff (rst) write[wr_var] |-> ((write_queu[wr_var] < NUMQUEU) && (write_cell[wr_var] < NUMCELL) && (write_prio[wr_var]==LO_PRIO)));
end
endgenerate

genvar wp_int, wi;
reg  [BITADDR-1:0] write_addr_pipe [0:NUMWRPT-1][0:RAWHAZ];
reg                write_vld_pipe  [0:NUMWRPT-1][0:RAWHAZ];
generate for (wp_int=0;wp_int<RAWHAZ;wp_int++) begin : wp_loop
  for (wi=0;wi<NUMWRPT;wi++) begin : wi
    if (wp_int>0)
      always @(posedge clk) begin
        write_addr_pipe[wi][wp_int] <= write_addr_pipe[wi][wp_int-1];
        write_vld_pipe[wi][wp_int]  <= write_vld_pipe[wi][wp_int-1];
      end
    else
      always_comb begin
        write_addr_pipe[wi][wp_int] = write_addr[wi];
        write_vld_pipe[wi][wp_int]  = write[wi];
      end
  end
end
endgenerate
genvar rp_int, ri;
reg  [BITADDR-1:0] read_addr_pipe [0:NUMRDPT-1][0:WARHAZ];
reg                read_vld_pipe  [0:NUMRDPT-1][0:WARHAZ];
generate for (rp_int=0;rp_int<WARHAZ;rp_int++) begin : rp_loop
  for (ri=0;ri<NUMRDPT;ri++) begin : ri
    if (rp_int>0)
      always @(posedge clk) begin
        read_addr_pipe[ri][rp_int] <= read_addr_pipe[ri][rp_int-1];
        read_vld_pipe[ri][rp_int]  <= read_vld_pipe[ri][rp_int-1];
      end
    else
      always_comb begin
        read_addr_pipe[ri][rp_int] = read_addr[ri];
        read_vld_pipe[ri][rp_int]  = read[ri];
      end
  end
end
endgenerate
reg [NUMRDPT-1:0] raw_hazard;
always_comb begin : raw_c
  for (integer rp_int=0;rp_int<NUMRDPT;rp_int++) begin : rp_loop
    raw_hazard[rp_int] = 1'b0;
    for (integer wp_int=0;wp_int<NUMWRPT;wp_int++) begin : wp_loop
      for (integer p_int=0;p_int<RAWHAZ;p_int++) begin : p_loop
        if (read[rp_int] && (read_addr[rp_int] == write_addr_pipe[wp_int][p_int]) && write_vld_pipe[wp_int][p_int])
          raw_hazard[rp_int] = 1'b1;
      end
    end
  end
end

reg [NUMWRPT-1:0] war_hazard;
always_comb begin : war_c
  for (integer wp_int=0;wp_int<NUMWRPT;wp_int++) begin : wp_loop
    war_hazard[wp_int] = 1'b0;
    for (integer rp_int=0;rp_int<NUMRDPT;rp_int++) begin : rp_loop
      for (integer p_int=0;p_int<WARHAZ;p_int++) begin : p_loop
        if (write[wp_int] && (write_addr[wp_int] == read_addr_pipe[rp_int][p_int]) && read_vld_pipe[rp_int][p_int])
          war_hazard[wp_int] = 1'b1;
      end
    end
  end
end

assume_raw_hazard_check: assert property (@(posedge clk) disable iff (!ready) !(|raw_hazard))
  else $display("[ERROR:memoir:%m:%0t] raw hazard detected", $time);

assume_war_hazard_check: assert property (@(posedge clk) disable iff (!ready) !(|war_hazard))
  else $display("[ERROR:memoir:%m:%0t] war hazard detected", $time);


reg               rd_op     [0:NUMRDPT-1][0:NUMVBNK-1][0:NUMPRIO-1][0:RLPWSIZ-1];
reg [RCNTBIT-1:0] rd_op_cnt [0:NUMRDPT-1][0:NUMVBNK-1][0:NUMPRIO-1];
genvar rf_p, rf_b, rf_h, rf_w;
generate for (rf_p=0;rf_p<NUMRDPT;rf_p=rf_p+1) begin : rop_cnt
  for (rf_b=0;rf_b<NUMVBNK;rf_b=rf_b+1) begin : rf_bl
    for (rf_h=0;rf_h<NUMPRIO;rf_h=rf_h+1) begin : rf_hl
      wire new_rd_op = (read[rf_p] & (read_bank[rf_p] == rf_b) & (read_prio[rf_p] == rf_h));
      for (rf_w=0;rf_w<RLPWSIZ;rf_w=rf_w+1) begin : rf_wl

        always @(posedge clk) begin: r_pipe
          if (rst)
            rd_op[rf_p][rf_b][rf_h][rf_w] <= 1'b0;
          else if (rf_w>0)
            rd_op[rf_p][rf_b][rf_h][rf_w] <= rd_op[rf_p][rf_b][rf_h][rf_w-1];
          else
            rd_op[rf_p][rf_b][rf_h][rf_w] <= new_rd_op;
        end

      end

      always @(posedge clk) begin: r_cnt
        if (rst)
          rd_op_cnt[rf_p][rf_b][rf_h] <= {RCNTBIT{1'b0}};
        else 
          if (rf_h) 
            rd_op_cnt[rf_p][rf_b][rf_h] <= rd_op_cnt[rf_p][rf_b][rf_h] + new_rd_op - rd_op[rf_p][rf_b][rf_h][RLPWSIZ-1];
          else
            rd_op_cnt[rf_p][rf_b][rf_h] <= rd_op_cnt[rf_p][rf_b][rf_h] + new_rd_op - rd_op[rf_p][rf_b][rf_h][RHPWSIZ-1];
      end
 
    end
  end
end
endgenerate

genvar bb;
generate begin : rrate_loop
  reg [RCNTBIT+BITRDPT:0] rd_lop_cnt [0:NUMVBNK-1];
  reg [RCNTBIT+BITRDPT:0] rd_lmx_cnt [0:NUMVBNK-1];
  reg [RCNTBIT+BITRDPT:0] rd_hop_cnt [0:NUMVBNK-1];
  reg [RCNTBIT+BITRDPT:0] rd_hmx_cnt [0:NUMVBNK-1];
  for (bb=0;bb<NUMVBNK;bb=bb+1) begin : bb_l

    always_comb begin
      rd_lmx_cnt[bb] = RLOPCNT;
      rd_lop_cnt[bb] = 0;
      rd_hmx_cnt[bb] = RHOPCNT;
      rd_hop_cnt[bb] = 0;
      for (integer pb=0;pb<NUMRDPT;pb++) begin
        rd_lop_cnt[bb] = rd_op_cnt[pb][bb][LO_PRIO] + rd_lop_cnt[bb];
        rd_hop_cnt[bb] = rd_op_cnt[pb][bb][HI_PRIO] + rd_hop_cnt[bb];
      end
    end

    assume_read_lp_rate: assert property (@(posedge clk) disable iff (rst || !ready) (rd_lop_cnt[bb] <= rd_lmx_cnt[bb]))
      else $display("[ERROR:memoir:%m:%0t] LP read rate exceeded bank=%0d cnt=%0d max=%0d win=%0d", $time, bb, rd_lop_cnt[bb], rd_lmx_cnt[bb], RLPWSIZ);
    assume_read_hp_rate: assert property (@(posedge clk) disable iff (rst || !ready) (rd_hop_cnt[bb] <= rd_hmx_cnt[bb]))
      else $display("[ERROR:memoir:%m:%0t] HP read rate exceeded bank=%0d cnt=%0d max=%0d win=%0d", $time, bb, rd_hop_cnt[bb], rd_hmx_cnt[bb], RHPWSIZ);
  end
end
endgenerate

reg               wr_op     [0:NUMWRPT-1][0:NUMVBNK-1][0:NUMPRIO-1][0:WLPWSIZ-1];
reg [WCNTBIT-1:0] wr_op_cnt [0:NUMWRPT-1][0:NUMVBNK-1][0:NUMPRIO-1];
genvar wf_p, wf_b, wf_h, wf_w;
generate for (wf_p=0;wf_p<NUMWRPT;wf_p=wf_p+1) begin: wop_cnt
  for (wf_b=0;wf_b<NUMVBNK;wf_b=wf_b+1) begin : wf_bl
    for (wf_h=0;wf_h<NUMPRIO;wf_h=wf_h+1) begin : wf_hl
      wire new_wr_op = (write[wf_p] & (write_bank[wf_p] == wf_b) & (write_prio[wf_p] == wf_h));
      for (wf_w=0;wf_w<WLPWSIZ;wf_w=wf_w+1) begin : wf_wl

        always @(posedge clk) begin: w_pipe
          if (rst)
            wr_op[wf_p][wf_b][wf_h][wf_w] <= 1'b0;
          else if (wf_w>0)
            wr_op[wf_p][wf_b][wf_h][wf_w] <= wr_op[wf_p][wf_b][wf_h][wf_w-1];
          else
            wr_op[wf_p][wf_b][wf_h][wf_w] <= new_wr_op;
        end

      end
      
      always @(posedge clk) begin: w_cnt
        if (rst)
          wr_op_cnt[wf_p][wf_b][wf_h] <= {WCNTBIT{1'b0}};
        else
          if (wf_p==(NUMWRPT-1))
            wr_op_cnt[wf_p][wf_b][wf_h] <= wr_op_cnt[wf_p][wf_b][wf_h] + new_wr_op - wr_op[wf_p][wf_b][wf_h][WCPWSIZ-1];
          else 
            if (wf_h)
              wr_op_cnt[wf_p][wf_b][wf_h] <= wr_op_cnt[wf_p][wf_b][wf_h] + new_wr_op - wr_op[wf_p][wf_b][wf_h][WLPWSIZ-1];
            else
              wr_op_cnt[wf_p][wf_b][wf_h] <= wr_op_cnt[wf_p][wf_b][wf_h] + new_wr_op - wr_op[wf_p][wf_b][wf_h][WHPWSIZ-1];
      end

    end
  end
end
endgenerate

genvar pa, ba;
generate begin : wrate_loop
  reg [WCNTBIT-1:0] wr_lop_cnt [0:NUMWRPT-1][0:NUMVBNK-1];
  reg [WCNTBIT-1:0] wr_hop_cnt [0:NUMWRPT-1][0:NUMVBNK-1];
  reg [WCNTBIT-1:0] wr_max_cnt [0:NUMWRPT-1][0:NUMVBNK-1];
  for (pa=0;pa<NUMWRPT;pa=pa+1) begin : pa_l
    for (ba=0;ba<NUMVBNK;ba=ba+1) begin : ba_l

      always_comb begin : w_c
        wr_max_cnt[pa][ba] = (pa < (NUMWRPT-1)) ? WMOPCNT : WCOPCNT;
        wr_lop_cnt[pa][ba] = wr_op_cnt[pa][ba][LO_PRIO];
        wr_hop_cnt[pa][ba] = wr_op_cnt[pa][ba][HI_PRIO];
      end

      assume_write_hp_rate: assert property (@(posedge clk) disable iff (rst || !ready) (wr_hop_cnt[pa][ba] <= wr_max_cnt[pa][ba]))
        else $display("[ERROR:memoir:%m:%0t] hi-priority write rate exceeded cnt=%0d max=%0d", $time, wr_hop_cnt[pa][ba], wr_max_cnt[pa][ba]);
      assume_write_lp_rate: assert property (@(posedge clk) disable iff (rst || !ready) (wr_lop_cnt[pa][ba] <= wr_max_cnt[pa][ba]))
        else $display("[ERROR:memoir:%m:%0t] lo-priority write rate exceeded cnt=%0d max=%0d", $time, wr_lop_cnt[pa][ba], wr_max_cnt[pa][ba]);
    end
  end
end
endgenerate

genvar bi;
generate for (bi=0; bi<NUMVBNK; bi=bi+1) begin: oflw_loop
    assert_hp_rdfifo_overflow_ifc_check: assert property (@(posedge clk) disable iff (rst || !ready) !rhfifo_oflw[bi])
      else $display("[ERROR:memoir:%m:%0t] HP Read-FIFO overflow asserted bank=%0d", $time, bi);
    assert_lp_rdfifo_overflow_ifc_check: assert property (@(posedge clk) disable iff (rst || !ready) !rlfifo_oflw[bi])
      else $display("[ERROR:memoir:%m:%0t] LP Read-FIFO overflow asserted bank=%0d", $time, bi);
    assert_hp_wrfifo_overflow_ifc_check: assert property (@(posedge clk) disable iff (rst || !ready) !whfifo_oflw[bi])
      else $display("[ERROR:memoir:%m:%0t] HP Write-FIFO overflow asserted bank=%0d", $time, bi);
    assert_lp_wrfifo_overflow_ifc_check: assert property (@(posedge clk) disable iff (rst || !ready) !wlfifo_oflw[bi])
      else $display("[ERROR:memoir:%m:%0t] LP Write-FIFO overflow asserted bank=%0d", $time, bi);
end
endgenerate

endmodule

module ip_top_sva_mrnws_a33
#(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMRDPT = 1,
parameter     BITRDPT = 2,
parameter     NUMWRPT = 2,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 2048,
parameter     BITVROW = 11,
parameter     NUMVBNK = 4,
parameter     BITVBNK = 2,
parameter     BITPADR = 14,
parameter     NUMHROW = 512,
parameter     BITHROW = 9,
parameter     NUMLROW = 1536,
parameter     BITLROW = 11,
parameter     BITHVRW = 7,
parameter     NUMCELL = 80,
parameter     BITCELL = 7,
parameter     NUMQUEU = 9216,
parameter     RFFOCNT = 16,
parameter     WFFOCNT = 16,
parameter     READ_DELAY = 20,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     BITCTRL = 10,
parameter     BITRDLY = 5,
parameter     LPBKHDL = 8,
parameter     LPBKLDL = 12,
parameter     LPBKADL = 14
)
(
input                       clk,
input                       rst,
input                       ready,
input [NUMWRPT-1:0]         write,
input [NUMWRPT*BITADDR-1:0] wr_adr,
input [NUMWRPT*WIDTH-1:0]   din,
input [NUMRDPT-1:0]         read,
input [NUMRDPT*BITADDR-1:0] rd_adr,
input [NUMRDPT-1:0]         rd_vld,
input [NUMRDPT*WIDTH-1:0]   rd_dout,
input [NUMRDPT-1:0]         rd_fwrd,
input [NUMRDPT-1:0]         rd_serr,
input [NUMRDPT-1:0]         rd_derr,
input [NUMRDPT*BITPADR-1:0] rd_padr,
input [NUMVBNK-1:0]         whfifo_oflw,
input [NUMVBNK-1:0]         wlfifo_oflw,
input [NUMVBNK-1:0]         rhfifo_oflw,
input [NUMVBNK-1:0]         rlfifo_oflw,
input [NUMVBNK-1:0]         t1_writeA,
input [NUMVBNK*BITHROW-1:0] t1_addrA,
input [NUMVBNK*WIDTH-1:0]   t1_dinA,
input [NUMVBNK-1:0]         t1_writeB,
input [NUMVBNK*BITHROW-1:0] t1_addrB,
input [NUMVBNK*WIDTH-1:0]   t1_dinB,
input [NUMVBNK-1:0]         t1_readC,
input [NUMVBNK*BITHROW-1:0] t1_addrC,
input [NUMVBNK*WIDTH-1:0]   t1_doutC,
input [NUMVBNK-1:0]         t1_fwrdC,
input [NUMVBNK-1:0]         t1_serrC,
input [NUMVBNK-1:0]         t1_derrC,
input [NUMVBNK*BITHROW-1:0] t1_padrC,
input [NUMVBNK*BITCTRL-1:0] t1_cinC,
input [NUMVBNK-1:0]         t1_vldC,
input [NUMVBNK*BITCTRL-1:0] t1_coutC,
input [NUMVBNK-1:0]         t2_writeA,
input [NUMVBNK*BITLROW-1:0] t2_addrA,
input [NUMVBNK*WIDTH-1:0]   t2_dinA,
input [NUMVBNK-1:0]         t2_readB,
input [NUMVBNK*BITCTRL-1:0] t2_cinB,
input [NUMVBNK-1:0]         t2_vldB,
input [NUMVBNK*BITCTRL-1:0] t2_coutB,
input [NUMVBNK*BITLROW-1:0] t2_addrB,
input [NUMVBNK*WIDTH-1:0]   t2_doutB,
input [NUMVBNK-1:0]         t2_fwrdB,
input [NUMVBNK-1:0]         t2_serrB,
input [NUMVBNK-1:0]         t2_derrB,
input [NUMVBNK*BITLROW-1:0] t2_padrB,
input [BITADDR-1:0]         select_addr,
input [BITWDTH-1:0]         select_bit,
input [BITVBNK-1:0]         select_bnk,
input                       select_prio,
input [BITCELL-BITVBNK-1:0] select_vwrd,
input [BITADDR-BITCELL-1:0] select_vrow,
input [BITHROW-1:0]         select_hrow,
input [BITLROW-1:0]         select_lrow,
input [BITHVRW-1:0]         select_hvrw
);

localparam     BITQUEU = BITADDR-BITCELL;
localparam     NUMPRIO = 2;
localparam     HI_PRIO  = 0;
localparam     LO_PRIO  = 1;

localparam     RHOPCNT  = 4;
localparam     RHPWSIZ  = 4; 
localparam     RLOPCNT  = 4; 
localparam     RLPWSIZ  = 6;

localparam     HPW1INM  = 2;
localparam     HPWWIN   = 1;
localparam     WFHMXDL  = WFFOCNT*HPWWIN/HPW1INM;
localparam     LPW1INM  = 2;
localparam     LPWWIN   = 3;
localparam     WFLMXDL  = WFFOCNT*LPWWIN/LPW1INM;

reg [BITADDR-1:0] write_addr [0:NUMWRPT-1]; 
reg [BITVBNK-1:0] write_bank [0:NUMWRPT-1]; 
reg [BITCELL-1:0] write_cell [0:NUMWRPT-1]; 
reg [BITQUEU-1:0] write_queu [0:NUMWRPT-1]; 
reg               write_prio [0:NUMWRPT-1]; 
reg [WIDTH-1:0]   write_din  [0:NUMWRPT-1];
always_comb begin : wrxf
  integer wi;
  for (wi=0;wi<NUMWRPT;wi=wi+1) begin
    write_addr[wi] = wr_adr >> (wi*BITADDR);
    write_bank[wi] = write_addr[wi][BITVBNK-1:0];
    write_cell[wi] = write_addr[wi][BITCELL-1:0];
    write_queu[wi] = write_addr[wi][BITADDR-1:BITCELL];
    write_prio[wi] = |(write_addr[wi][BITCELL-1:BITVBNK]);
    write_din[wi]  = din >> (wi*WIDTH);
  end  
end

reg [BITADDR-1:0] read_addr [0:NUMRDPT-1]; 
reg [BITVBNK-1:0] read_bank [0:NUMRDPT-1]; 
reg [BITCELL-1:0] read_cell [0:NUMRDPT-1]; 
reg [BITQUEU-1:0] read_queu [0:NUMRDPT-1]; 
reg               read_prio [0:NUMRDPT-1]; 
always_comb begin : rdxf
  integer ri;
  for (ri=0;ri<NUMRDPT;ri=ri+1) begin
    read_addr[ri] = rd_adr >> (ri*BITADDR);
    read_bank[ri] = read_addr[ri][BITVBNK-1:0];
    read_cell[ri] = read_addr[ri][BITCELL-1:0];
    read_queu[ri] = read_addr[ri][BITADDR-1:BITCELL];
    read_prio[ri] = |(read_addr[ri][BITCELL-1:BITVBNK]);
  end
end

`ifdef FORMAL
genvar rffb_int, rffh_int;
generate for (rffb_int=0; rffb_int<NUMVBNK; rffb_int=rffb_int+1) begin: rffb_loop
  for (rffh_int=0; rffh_int<NUMPRIO; rffh_int=rffh_int+1) begin: rffh_loop
    assert_rdfifo_overflow_check: assert property (@(posedge clk) disable iff (!ready) (core.rdfifo_cnt[rffh_int][rffb_int] <= RFFOCNT))
      else $display("[ERROR:memoir:%m:%0t] Read-FIFO overflow bank=%0d prio=%0d", $time, rffb_int, rffh_int);
    if (rffh_int == HI_PRIO) begin : hp 
      assert_rdfifo_overflow_ifc_check: assert property (@(posedge clk) disable iff (!ready) 1'b1 |-> ##FLOPOUT (rhfifo_oflw[rffb_int] == ($past(core.rdfifo_cnt[HI_PRIO][rffb_int],FLOPOUT) > RFFOCNT)))
        else $display("[ERROR:memoir:%m:%0t] HP Read-FIFO overflow asserted bank=%0d", $time, rffb_int);
    end else begin : lp
      assert_rdfifo_overflow_ifc_check: assert property (@(posedge clk) disable iff (!ready) 1'b1 |-> ##FLOPOUT (rlfifo_oflw[rffb_int] == ($past(core.rdfifo_cnt[LO_PRIO][rffb_int],FLOPOUT) > RFFOCNT)))
        else $display("[ERROR:memoir:%m:%0t] LP Read-FIFO overflow asserted bank=%0d", $time, rffb_int);
    end
  end
end 
endgenerate
`endif 

`ifdef FORMAL
genvar             wffb_int, wffh_int;
generate for (wffb_int=0; wffb_int<NUMVBNK; wffb_int=wffb_int+1) begin: wffb_loop
  for (wffh_int=0; wffh_int<NUMPRIO; wffh_int=wffh_int+1) begin: wffh_loop
    assert_wrfifo_overflow_check: assert property (@(posedge clk) disable iff (!ready) (core.wrfifo_cnt[wffh_int][wffb_int] <= WFFOCNT))
      else $display("[ERROR:memoir:%m:%0t] Write-FIFO overflow bank=%0d prio=%0d", $time, wffb_int, wffh_int);
    if (wffh_int == HI_PRIO) begin : hp 
      assert_wrfifo_overflow_ifc_check: assert property (@(posedge clk) disable iff (!ready) 1'b1 |-> ##FLOPOUT (whfifo_oflw[wffb_int] == ($past(core.wrfifo_cnt[HI_PRIO][wffb_int],FLOPOUT) > WFFOCNT)))
        else $display("[ERROR:memoir:%m:%0t] HP Write-FIFO overflow asserted bank=%0d", $time, wffb_int);
    end else begin : lp
      assert_wrfifo_overflow_ifc_check: assert property (@(posedge clk) disable iff (!ready) 1'b1 |-> ##FLOPOUT (wlfifo_oflw[wffb_int] == ($past(core.wrfifo_cnt[LO_PRIO][wffb_int],FLOPOUT) > WFFOCNT)))
        else $display("[ERROR:memoir:%m:%0t] LP Write-FIFO overflow asserted bank=%0d", $time, wffb_int);
    end
  end
end 
endgenerate
`endif

genvar t1i, r1i, w1i, t1p;
generate begin: hp_ctrl
  for (t1i=0;t1i<NUMVBNK;t1i=t1i+1) begin : bank
    wire               t1_readC_wire  = t1_readC[t1i];
    wire [BITHROW-1:0] t1_addrC_wire  = t1_addrC >> (BITHROW*t1i);
    wire [BITCTRL-1:0] t1_cinC_wire   = t1_cinC >> (t1i*BITCTRL);
    wire               t1_vldC_wire   = t1_vldC[t1i];
    wire [BITCTRL-1:0] t1_coutC_wire  = t1_coutC >> (t1i*BITCTRL);
    wire [WIDTH-1:0]   t1_doutC_wire  = t1_doutC >> (WIDTH*t1i);
    wire               t1_fwrdC_wire  = t1_fwrdC[t1i];
    wire               t1_serrC_wire  = t1_serrC[t1i];
    wire               t1_derrC_wire  = t1_derrC[t1i];
    wire [BITHROW-1:0] t1_padrC_wire  = t1_padrC >> (BITHROW*t1i);

    wire               t1_writeA_wire = t1_writeA[t1i];
    wire [BITHROW-1:0] t1_addrA_wire  = t1_addrA >> (BITHROW*t1i);
    wire [WIDTH-1:0]   t1_dinA_wire   = t1_dinA >> (WIDTH*t1i);
    wire               t1_writeB_wire = t1_writeB[t1i];
    wire [BITHROW-1:0] t1_addrB_wire  = t1_addrB >> (BITHROW*t1i);
    wire [WIDTH-1:0]   t1_dinB_wire   = t1_dinB >> (WIDTH*t1i);


    assert_t1_wrA_range_check: assert property (@(posedge clk) disable iff (!ready) t1_writeA_wire |-> (t1_addrA_wire < NUMHROW));
    assert_t1_wrB_range_check: assert property (@(posedge clk) disable iff (!ready) t1_writeB_wire |-> (t1_addrB_wire < NUMHROW));
    assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (!ready) t1_readC_wire  |-> (t1_addrC_wire < NUMHROW));

    reg [BITCTRL-1:0]  t1_cinC_pipe [0:READ_DELAY-1];
    reg                t1_readC_pipe [0:READ_DELAY-1];
    for (t1p=0;t1p<READ_DELAY;t1p++) begin : t1p_loop
      if (t1p>0)
        always @(posedge clk) begin
          t1_readC_pipe[t1p] <= ready ? t1_readC_pipe[t1p-1] : 0;
          t1_cinC_pipe[t1p]  <= ready ? t1_cinC_pipe[t1p-1]  : 0;
        end
      else
        always @(posedge clk) begin
          t1_readC_pipe[t1p] <= ready ? t1_readC_wire : 0;
          t1_cinC_pipe[t1p]  <= ready ? t1_cinC_wire  : 0;
        end
    end

    reg dup_id;
    always_comb begin : dup_c
      dup_id = 1'b0;
      for (integer rp=0;rp<READ_DELAY-RHPWSIZ;rp++) begin // RHPWSIZ as well as read rate
        if (t1_readC_wire && t1_readC_pipe[rp] && (t1_cinC_wire == t1_cinC_pipe[rp]))
          dup_id = 1'b1;
      end
    end

    // Duplicate ID - for 4-in-4, duplicate check window is reduced by
    // 4 because four ports can send an op to the same bank in one cycle
    // which take four cycles to enter the memory subsystem.
    assert_duplicate_read_id: assert property (@(posedge clk) disable iff (!ready) (!dup_id && (RHOPCNT==4) && (RHPWSIZ==4)))
      else $display ("[ERROR:memoir:%m:%0t] duplicate read ID", $time);

    for (r1i=0;r1i<NUMRDPT;r1i++) begin : rport
      assert_t1_rd_vld_del_check : assert property (@(posedge clk) disable iff (!ready) (read[r1i] && (read_addr[r1i] == select_addr) && (select_bnk == t1i) && (select_prio==HI_PRIO)) |-> ##[1:READ_DELAY-LPBKHDL]
                                                                                         (t1_readC_wire && (t1_addrC_wire == select_hrow)));
    end
    for (w1i=0;w1i<NUMWRPT;w1i++) begin : wport
      assert_t1_wr_vld_del_check : assert property (@(posedge clk) disable iff (!ready) (write[w1i] && (write_addr[w1i] == select_addr) && (select_bnk == t1i) && (select_prio==HI_PRIO)) |-> ##[1:WFHMXDL+FLOPIN]
                                                                                         ((t1_writeA_wire && (t1_addrA_wire == select_hrow)) ||
                                                                                          (t1_writeB_wire && (t1_addrB_wire == select_hrow))));
    end

    assert_t1_ctrl_return_loop: assert property (@(posedge clk) disable iff (!ready) t1_readC_wire  |-> ##LPBKHDL
                                                                                      (    (t1_vldC_wire  == $past(t1_readC_wire, LPBKHDL))
                                                                                        && (t1_coutC_wire == $past(t1_cinC_wire,  LPBKHDL))
                                                                                      ));
    // TBD change below
    assert_t1_padr_return_loop: assert property (@(posedge clk) disable iff (!ready) t1_readC_wire  |-> ##LPBKHDL
                                                                                      (    (t1_vldC_wire  == $past(t1_readC_wire, LPBKHDL))
                                                                                        && (t1_padrC_wire == $past(t1_addrC_wire, LPBKHDL))
                                                                                      ));

    reg t1_refmem;
    reg t1_refinv;
    reg t1_refmem_nxt;
    reg t1_refinv_nxt;
    always_comb begin
      t1_refmem_nxt = rst ? 1'b0 : t1_refmem;
      t1_refinv_nxt = rst ? 1'b1 : t1_refinv;
      if (t1_writeA_wire && (t1_addrA_wire == select_hrow) && (select_bnk == t1i)) begin
        t1_refmem_nxt = t1_dinA_wire[select_bit];
        t1_refinv_nxt = 1'b0;
      end
      if (t1_writeB_wire && (t1_addrB_wire == select_hrow) && (select_bnk == t1i)) begin
        t1_refmem_nxt = t1_dinB_wire[select_bit];
        t1_refinv_nxt = 1'b0;
      end
    end

    always @(posedge clk) begin
      t1_refmem <= t1_refmem_nxt;
      t1_refinv <= t1_refinv_nxt;
    end

    assert_t1_data_return_loop: assert property (@(posedge clk) disable iff (!ready) (t1_readC_wire && (t1_addrC_wire == select_hrow) && (select_bnk == t1i))  |-> ##LPBKHDL
                                                                                      ($past(t1_refinv,LPBKHDL) ||
                                                                                       (
                                                                                           (t1_doutC_wire[select_bit] == $past(t1_refmem,LPBKHDL))
                                                                                        && (t1_fwrdC_wire             == $past(t1_refmem,LPBKHDL))
                                                                                        && (t1_serrC_wire             == $past(t1_refmem,LPBKHDL))
                                                                                        && (t1_derrC_wire             == $past(t1_refmem,LPBKHDL))
                                                                                      )));
  end
end
endgenerate

genvar t2i, r2i, w2i, t2p;
generate begin: lp_ctrl
  for (t2i=0;t2i<NUMVBNK;t2i=t2i+1) begin : bank
    wire               t2_readB_wire  = t2_readB[t2i];
    wire [BITLROW-1:0] t2_addrB_wire  = t2_addrB >> (BITLROW*t2i);
    wire [BITCTRL-1:0] t2_cinB_wire   = t2_cinB >> (t2i*BITCTRL);
    wire               t2_vldB_wire   = t2_vldB[t2i];
    wire [BITCTRL-1:0] t2_coutB_wire  = t2_coutB >> (t2i*BITCTRL);
    wire [WIDTH-1:0]   t2_doutB_wire  = t2_doutB >> (WIDTH*t2i);
    wire               t2_fwrdB_wire  = t2_fwrdB[t2i];
    wire               t2_serrB_wire  = t2_serrB[t2i];
    wire               t2_derrB_wire  = t2_derrB[t2i];
    wire [BITLROW-1:0] t2_padrB_wire  = t2_padrB >> (BITLROW*t2i);

    wire               t2_writeA_wire = t2_writeA[t2i];
    wire [BITLROW-1:0] t2_addrA_wire  = t2_addrA >> (BITLROW*t2i);
    wire [WIDTH-1:0]   t2_dinA_wire   = t2_dinA >> (WIDTH*t2i);


    assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (!ready) t2_writeA_wire |-> (t2_addrA_wire < NUMLROW));
    assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (!ready) t2_readB_wire  |-> (t2_addrB_wire < NUMLROW));

    reg [BITCTRL-1:0]  t2_cinB_pipe [0:READ_DELAY-1];
    reg                t2_readB_pipe [0:READ_DELAY-1];
    for (t2p=0;t2p<READ_DELAY;t2p++) begin : t2p_loop
      if (t2p>0)
        always @(posedge clk) begin
          t2_readB_pipe[t2p] <= ready ? t2_readB_pipe[t2p-1] : 0;
          t2_cinB_pipe[t2p]  <= ready ? t2_cinB_pipe[t2p-1]  : 0;
        end
      else
        always @(posedge clk) begin
          t2_readB_pipe[t2p] <= ready ? t2_readB_wire : 0;
          t2_cinB_pipe[t2p]  <= ready ? t2_cinB_wire  : 0;
        end
    end

    reg dup_id;
    always_comb begin : dup_c
      dup_id = 1'b0;
      for (integer rp=0;rp<READ_DELAY-6;rp++) begin // 6 is RLPWSIZ as well as read rate
        if (t2_readB_wire && t2_readB_pipe[rp] && (t2_cinB_wire == t2_cinB_pipe[rp]))
          dup_id = 1'b1;
      end
    end

    // Duplicate ID - for 4-in-6, duplicate check window is reduced by
    // 6 because four ports can send an op to the same bank in one cycle
    // which take six cycles to enter the memory subsystem.
    assert_duplicate_read_id: assert property (@(posedge clk) disable iff (!ready) (!dup_id && (RLOPCNT==4) && (RLPWSIZ==6)))
      else $display ("[ERROR:memoir:%m:%0t] duplicate read ID", $time);

    for (r2i=0;r2i<NUMRDPT;r2i++) begin : rport
      assert_t2_rd_vld_del_check : assert property (@(posedge clk) disable iff (!ready) (read[r2i] && (read_addr[r2i] == select_addr) && (select_bnk == t2i) && (select_prio==LO_PRIO)) |-> ##[1:READ_DELAY-LPBKADL]
                                                                                         (t2_readB_wire && (t2_addrB_wire == select_lrow)));
    end
    for (w2i=0;w2i<NUMWRPT;w2i++) begin : wport
      assert_t2_wr_vld_del_check : assert property (@(posedge clk) disable iff (!ready) (write[w2i] && (write_addr[w2i] == select_addr) && (select_bnk == t2i) && (select_prio==LO_PRIO)) |-> ##[1:WFLMXDL+FLOPIN]
                                                                                         (t2_writeA_wire && (t2_addrA_wire == select_lrow)));
    end

    assert_t2_ctrl_return_loop: assert property (@(posedge clk) disable iff (!ready) t2_readB_wire  |-> ##LPBKLDL
                                                                                      (    (t2_vldB_wire  == $past(t2_readB_wire, LPBKLDL))
                                                                                        && (t2_coutB_wire == $past(t2_cinB_wire,  LPBKLDL))
                                                                                      ));

    assert_t2_padr_return_loop: assert property (@(posedge clk) disable iff (!ready) t2_readB_wire  |-> ##LPBKLDL
                                                                                      (    (t2_vldB_wire  == $past(t2_readB_wire, LPBKLDL))
                                                                                        && (t2_padrB_wire == $past(t2_addrB_wire, LPBKLDL))
                                                                                      ));

    reg t2_refmem;
    reg t2_refinv;
    always @(posedge clk)
      if (rst) begin
        t2_refmem <= 1'b0;
        t2_refinv <= 1'b1;
      end else if (t2_writeA_wire && (t2_addrA_wire == select_lrow) && (select_bnk == t2i)) begin
        t2_refmem <= t2_dinA_wire[select_bit];
        t2_refinv <= 1'b0;
      end

    assert_t2_data_return_loop: assert property (@(posedge clk) disable iff (!ready) (t2_readB_wire && (t2_addrB_wire == select_lrow) && (select_bnk == t2i))  |-> ##LPBKLDL
                                                                                      ($past(t2_refinv,LPBKLDL) ||
                                                                                       (
                                                                                           (t2_doutB_wire[select_bit] == $past(t2_refmem,LPBKLDL))
                                                                                        && (t2_fwrdB_wire             == $past(t2_refmem,LPBKLDL))
                                                                                        && (t2_serrB_wire             == $past(t2_refmem,LPBKLDL))
                                                                                        && (t2_derrB_wire             == $past(t2_refmem,LPBKLDL))
                                                                                      )));
  end
end
endgenerate

reg refmem;
reg refmeminv;
always @(posedge clk) begin: rm
  integer wvid;
  if (!ready)
    refmeminv <= 1'b1;
  else
    for (wvid=0;wvid<NUMWRPT;wvid=wvid+1)
      if (write[wvid] &&  (write_addr[wvid] == select_addr)) begin
        refmeminv <= 1'b0;
        refmem <= write_din[wvid][select_bit];
      end
end

genvar rvid, wvid;
generate begin: rw_p
  for (rvid=0;rvid<NUMRDPT;rvid=rvid+1) begin : rd_p
    wire [WIDTH-1:0] rd_dout_wire = rd_dout >> (WIDTH*rvid);
    wire [BITADDR-1:0] rd_adr_wire = read_addr[rvid];
    wire rd_fwrd_wire = rd_fwrd[rvid];
    wire rd_serr_wire = rd_serr[rvid];
    wire rd_derr_wire = rd_derr[rvid];
    wire [BITPADR-1:0] rd_padr_wire = rd_padr >> (BITPADR*rvid);
    assert_rd_vld_chk : assert property (@(posedge clk) disable iff (!ready) (read[rvid] && (rd_adr_wire == select_addr)) |-> ##(READ_DELAY+FLOPIN+FLOPOUT) rd_vld[rvid]);
    assert_rd_dout_chk: assert property (@(posedge clk) disable iff (!ready) (read[rvid] && (rd_adr_wire == select_addr)) |-> ##(READ_DELAY+FLOPIN+FLOPOUT)
                                                                                      (rd_vld[rvid] && ($past(refmeminv,READ_DELAY+FLOPIN+FLOPOUT) ||
                                                                                       (
                                                                                           (rd_dout_wire[select_bit] == $past(refmem,READ_DELAY+FLOPIN+FLOPOUT))
                                                                                        && (rd_fwrd_wire             == $past(refmem,READ_DELAY+FLOPIN+FLOPOUT))
                                                                                        && (rd_serr_wire             == $past(refmem,READ_DELAY+FLOPIN+FLOPOUT))
                                                                                        && (rd_derr_wire             == $past(refmem,READ_DELAY+FLOPIN+FLOPOUT))
// TBD                                                                                  && (rd_padr_wire                    == {rd_fwrd_wire,select_bnk,select_lrow})
                                                                                      ))));
  end
end
endgenerate

endmodule

