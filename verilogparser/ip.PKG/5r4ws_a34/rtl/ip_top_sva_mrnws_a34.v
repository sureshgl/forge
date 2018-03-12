/*
*
  * 126720 addressable locations of 32B (+ECC) each
  * 126720/880 queues = 144 cells/queue; 144 cells/4 banks = 36 cells/bank
  * 10-bit queue ID + 6 cell ID + 2 bank ID = 18-bit external address
  *
*/
module ip_top_sva_2_mrnws_a34
#(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMRDPT = 4,
parameter     BITRDPT = 2,
parameter     NUMWRPT = 4,
parameter     BITWRPT = 2,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVBNK = 4,
parameter     BITVBNK = 2,
parameter     NUMVROW = 2048,
parameter     BITVROW = 11,
parameter     NUMLROW = 1536,
parameter     BITLROW = 11,
parameter     NUMCELL = 80,
parameter     BITCELL = 7,
parameter     NUMQUEU = 9216,
parameter     BITQUEU = 10,
parameter     RFFOCNT = 16,
parameter     WFFOCNT = 16,
parameter     BITCTRL = 10,
parameter     BITRDLY = 5
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
input [NUMVBNK-1:0]         wrfifo_oflw,
input [NUMVBNK-1:0]         rdfifo_oflw,
input [BITADDR-1:0]         select_addr,
input [BITWDTH-1:0]         select_bit,
input [BITVBNK-1:0]         select_bnk,
input [BITCELL-1:0] select_vwrd,
input [BITADDR-BITCELL-BITVBNK-1:0] select_vrow,
input [BITLROW-1:0]         select_lrow
);

localparam     WARHAZ   = 34;
localparam     RAWHAZ   = 34;

localparam     RLOPCNT  = 4; // 4-in-6 across five ports
localparam     RLPWSIZ  = 6; 
localparam     RCNTBIT  = 3;

localparam     WLOPCNT  = 1;
localparam     WLPWSIZ  = 6;
localparam     WCNTBIT  = 3;
 
reg [BITADDR-1:0] write_addr [0:NUMWRPT-1]; 
reg [BITVBNK-1:0] write_bank [0:NUMWRPT-1]; 
reg [BITCELL-1:0] write_cell [0:NUMWRPT-1]; 
reg [BITQUEU-1:0] write_queu [0:NUMWRPT-1]; 
always_comb begin : wrxf
  integer wi;
  for (wi=0;wi<NUMWRPT;wi=wi+1) begin
    write_addr[wi] = wr_adr >> (wi*BITADDR);
    write_bank[wi] = write_addr[wi][BITVBNK-1:0];
    write_cell[wi] = write_addr[wi][BITCELL+BITVBNK-1:BITVBNK];
    write_queu[wi] = write_addr[wi][BITADDR-1:BITCELL+BITVBNK];
  end  
end

reg [BITADDR-1:0] read_addr [0:NUMRDPT-1]; 
reg [BITVBNK-1:0] read_bank [0:NUMRDPT-1]; 
reg [BITCELL-1:0] read_cell [0:NUMRDPT-1]; 
reg [BITQUEU-1:0] read_queu [0:NUMRDPT-1]; 
always_comb begin : rdxf
  integer ri;
  for (ri=0;ri<NUMRDPT;ri=ri+1) begin
    read_addr[ri] = rd_adr >> (ri*BITADDR);
    read_bank[ri] = read_addr[ri][BITVBNK-1:0];
    read_cell[ri] = read_addr[ri][BITCELL+BITVBNK-1:BITVBNK];
    read_queu[ri] = read_addr[ri][BITADDR-1:BITCELL+BITVBNK];
  end
end

genvar rd_var;
generate for (rd_var=0; rd_var<NUMRDPT; rd_var=rd_var+1) begin: rd_loop
  assume_rd_range_check   : assert property (@(posedge clk) disable iff (rst) read[rd_var] |-> ((read_queu[rd_var] < NUMQUEU) && (read_cell[rd_var] < NUMCELL)));
end
endgenerate

genvar wr_var;
generate for (wr_var=0; wr_var<NUMWRPT; wr_var=wr_var+1) begin: wr_loop
  assume_wr_range_check   : assert property (@(posedge clk) disable iff (rst) write[wr_var] |-> ((write_queu[wr_var] < NUMQUEU) && (write_cell[wr_var] < NUMCELL)));
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

reg               rd_op     [0:NUMRDPT-1][0:NUMVBNK-1][0:RLPWSIZ-1];
reg [RCNTBIT-1:0] rd_op_cnt [0:NUMRDPT-1][0:NUMVBNK-1];
genvar rf_p, rf_b, rf_w;
generate for (rf_p=0;rf_p<NUMRDPT;rf_p=rf_p+1) begin : rop_cnt
  for (rf_b=0;rf_b<NUMVBNK;rf_b=rf_b+1) begin : rf_bl
    wire new_rd_op = (read[rf_p] && (read_bank[rf_p] == rf_b));
    for (rf_w=0;rf_w<RLPWSIZ;rf_w=rf_w+1) begin : rf_wl

      always @(posedge clk) begin: r_pipe
        if (!ready)
          rd_op[rf_p][rf_b][rf_w] <= 1'b0;
        else if (rf_w>0)
          rd_op[rf_p][rf_b][rf_w] <= rd_op[rf_p][rf_b][rf_w-1];
        else
          rd_op[rf_p][rf_b][rf_w] <= new_rd_op;
      end

    end

    always @(posedge clk) begin: r_cnt
      if (!ready)
        rd_op_cnt[rf_p][rf_b] <= {RCNTBIT{1'b0}};
      else
        rd_op_cnt[rf_p][rf_b] <= rd_op_cnt[rf_p][rf_b] + new_rd_op - rd_op[rf_p][rf_b][RLPWSIZ-1];
    end

  end
end
endgenerate

reg [RCNTBIT+BITRDPT:0] rd_lop_cnt [0:NUMVBNK-1];
reg [RCNTBIT+BITRDPT:0] rd_max_cnt [0:NUMVBNK-1];
genvar bb;
generate begin : rrate_loop
  for (bb=0;bb<NUMVBNK;bb=bb+1) begin : bb_l

    always_comb begin
      rd_max_cnt[bb] = RLOPCNT;
      rd_lop_cnt[bb] = 0;
      for (integer pb=0;pb<NUMRDPT;pb++) 
        rd_lop_cnt[bb] = rd_op_cnt[pb][bb] + rd_lop_cnt[bb];
    end

    assume_read_rate: assert property (@(posedge clk) disable iff (rst || !ready) (rd_lop_cnt[bb] <= rd_max_cnt[bb]))
      else $display("[ERROR:memoir:%m:%0t] read rate exceeded bank=%0d cnt=%0d max=%0d win=%0d", $time, bb, rd_lop_cnt[bb], rd_max_cnt[bb], RLPWSIZ);
  end
end
endgenerate

reg               wr_op     [0:NUMWRPT-1][0:NUMVBNK-1][0:WLPWSIZ-1];
reg [WCNTBIT-1:0] wr_op_cnt [0:NUMWRPT-1][0:NUMVBNK-1];
genvar wf_p, wf_b, wf_w;
generate for (wf_p=0;wf_p<NUMWRPT;wf_p=wf_p+1) begin: wop_cnt
  for (wf_b=0;wf_b<NUMVBNK;wf_b=wf_b+1) begin : wf_bl
    wire new_wr_op = (write[wf_p] && (write_bank[wf_p] == wf_b));
    for (wf_w=0;wf_w<WLPWSIZ;wf_w=wf_w+1) begin : wf_wl

      always @(posedge clk) begin: w_pipe
        if (!ready)
          wr_op[wf_p][wf_b][wf_w] <= 1'b0;
        else if (wf_w>0)
          wr_op[wf_p][wf_b][wf_w] <= wr_op[wf_p][wf_b][wf_w-1];
        else
          wr_op[wf_p][wf_b][wf_w] <= new_wr_op;
      end

    end
      
    always @(posedge clk) begin: w_cnt
      if (!ready)
        wr_op_cnt[wf_p][wf_b] <= {WCNTBIT{1'b0}};
      else
        wr_op_cnt[wf_p][wf_b] <= wr_op_cnt[wf_p][wf_b] + new_wr_op - wr_op[wf_p][wf_b][WLPWSIZ-1];
    end
    
  end
end
endgenerate

reg [WCNTBIT+BITWRPT:0] wr_lop_cnt [0:NUMWRPT-1][0:NUMVBNK-1];
reg [WCNTBIT+BITWRPT:0] wr_max_cnt [0:NUMWRPT-1][0:NUMVBNK-1];
genvar pa, ba;
generate begin : wrate_loop
  for (pa=0;pa<NUMWRPT;pa=pa+1) begin : pa_l
    for (ba=0;ba<NUMVBNK;ba=ba+1) begin : ba_l

      always_comb begin : w_c
        wr_max_cnt[pa][ba] = WLOPCNT;
        wr_lop_cnt[pa][ba] = wr_op_cnt[pa][ba];
      end

      assume_write_rate: assert property (@(posedge clk) disable iff (rst || !ready) (wr_lop_cnt[pa][ba] <= wr_max_cnt[pa][ba]))
        else $display("[ERROR:memoir:%m:%0t] write rate exceeded port=%0d bank=%0d cnt=%0d max=%0d win=%0d", $time, pa, ba, wr_lop_cnt[pa][ba], wr_max_cnt[pa][ba], WLPWSIZ);
    end
  end
end
endgenerate

genvar bi;
generate for (bi=0; bi<NUMVBNK; bi=bi+1) begin: oflw_loop
    assert_rdfifo_overflow_ifc_check: assert property (@(posedge clk) disable iff (rst || !ready) !rdfifo_oflw[bi])
      else $display("[ERROR:memoir:%m:%0t] Read-FIFO overflow asserted bank=%0d", $time, bi);
    assert_wrfifo_overflow_ifc_check: assert property (@(posedge clk) disable iff (rst || !ready) !wrfifo_oflw[bi])
      else $display("[ERROR:memoir:%m:%0t] Write-FIFO overflow asserted bank=%0d", $time, bi);
end
endgenerate

endmodule

module ip_top_sva_mrnws_a34
#(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMRDPT = 1,
parameter     BITRDPT = 2,
parameter     NUMWRPT = 2,
parameter     BITWRPT = 2,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 2048,
parameter     BITVROW = 11,
parameter     NUMVBNK = 4,
parameter     BITVBNK = 2,
parameter     BITPADR = 14,
parameter     NUMLROW = 1536,
parameter     BITLROW = 11,
parameter     NUMCELL = 80,
parameter     BITCELL = 7,
parameter     NUMQUEU = 9216,
parameter     BITQUEU = 10,
parameter     RFFOCNT = 16,
parameter     WFFOCNT = 16,
parameter     READ_DELAY = 25,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     BITCTRL = 10,
parameter     BITRDLY = 5,
parameter     LPBKDEL = 12,
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
input [NUMVBNK-1:0]         t1_writeA,
input [NUMVBNK*BITLROW-1:0] t1_addrA,
input [NUMVBNK*WIDTH-1:0]   t1_dinA,
input [NUMVBNK-1:0]         t1_readB,
input [NUMVBNK*BITCTRL-1:0] t1_cinB,
input [NUMVBNK-1:0]         t1_vldB,
input [NUMVBNK*BITCTRL-1:0] t1_coutB,
input [NUMVBNK*BITLROW-1:0] t1_addrB,
input [NUMVBNK*WIDTH-1:0]   t1_doutB,
input [NUMVBNK-1:0]         t1_fwrdB,
input [NUMVBNK-1:0]         t1_serrB,
input [NUMVBNK-1:0]         t1_derrB,
input [NUMVBNK*BITLROW-1:0] t1_padrB,
input [NUMVBNK-1:0]         wrfifo_oflw,
input [NUMVBNK-1:0]         rdfifo_oflw,
input [BITADDR-1:0]         select_addr,
input [BITWDTH-1:0]         select_bit,
input [BITVBNK-1:0]         select_bnk,
input [BITCELL-1:0] select_vwrd,
input [BITADDR-BITCELL-BITVBNK-1:0] select_vrow,
input [BITLROW-1:0]         select_lrow
);


localparam     RLOPCNT  = 4;
localparam     RLPWSIZ  = 6; 

reg [BITADDR-1:0] write_addr [0:NUMWRPT-1]; 
reg [BITVBNK-1:0] write_bank [0:NUMWRPT-1]; 
reg [BITCELL-1:0] write_cell [0:NUMWRPT-1]; 
reg [BITQUEU-1:0] write_queu [0:NUMWRPT-1]; 
reg [WIDTH-1:0]   write_din  [0:NUMWRPT-1];
always_comb begin : wrxf
  integer wi;
  for (wi=0;wi<NUMWRPT;wi=wi+1) begin
    write_addr[wi] = wr_adr >> (wi*BITADDR);
    write_bank[wi] = write_addr[wi][BITVBNK-1:0];
    write_cell[wi] = write_addr[wi][BITCELL+BITVBNK-1:BITVBNK];
    write_queu[wi] = write_addr[wi][BITADDR-1:BITCELL+BITVBNK];
    write_din[wi]  = din >> (wi*WIDTH);
  end  
end

reg [BITADDR-1:0] read_addr [0:NUMRDPT-1]; 
reg [BITVBNK-1:0] read_bank [0:NUMRDPT-1]; 
reg [BITCELL-1:0] read_cell [0:NUMRDPT-1]; 
reg [BITQUEU-1:0] read_queu [0:NUMRDPT-1]; 
always_comb begin : rdxf
  integer ri;
  for (ri=0;ri<NUMRDPT;ri=ri+1) begin
    read_addr[ri] = rd_adr >> (ri*BITADDR);
    read_bank[ri] = read_addr[ri][BITVBNK-1:0];
    read_cell[ri] = read_addr[ri][BITCELL+BITVBNK-1:BITVBNK];
    read_queu[ri] = read_addr[ri][BITADDR-1:BITCELL+BITVBNK];
  end
end

genvar             rffb_int;
generate for (rffb_int=0; rffb_int<NUMVBNK; rffb_int=rffb_int+1) begin: rffb_loop
  `ifdef FORMAL
    assert_rdfifo_overflow_check: assert property (@(posedge clk) disable iff (!ready) (core.rdfifo_cnt[rffb_int] <= RFFOCNT))
      else $display("[ERROR:memoir:%m:%0t] Read-FIFO overflow bank=%0d", $time, rffb_int);
    assert_rdfifo_overflow_ifc_check: assert property (@(posedge clk) disable iff (!ready) 1'b1 |-> ##FLOPOUT (rdfifo_oflw[rffb_int] == ($past(core.rdfifo_cnt[rffb_int],FLOPOUT) > RFFOCNT)))
      else $display("[ERROR:memoir:%m:%0t] Read-FIFO overflow asserted bank=%0d", $time, rffb_int);
  `endif
end
endgenerate

genvar             wffb_int;
generate for (wffb_int=0; wffb_int<NUMVBNK; wffb_int=wffb_int+1) begin: wffb_loop
  `ifdef FORMAL
    assert_wrfifo_overflow_check: assert property (@(posedge clk) disable iff (!ready) (core.wrfifo_cnt[wffb_int] <= WFFOCNT))
      else $display("[ERROR:memoir:%m:%0t] Write-FIFO overflow bank=%0d", $time, wffb_int);
    assert_wrfifo_overflow_ifc_check: assert property (@(posedge clk) disable iff (!ready) 1'b1 |-> ##FLOPOUT (wrfifo_oflw[wffb_int] == ($past(core.wrfifo_cnt[wffb_int],FLOPOUT) > WFFOCNT)))
      else $display("[ERROR:memoir:%m:%0t] Write-FIFO overflow asserted bank=%0d", $time, wffb_int);
  `endif
end
endgenerate

genvar t1i, rpi, wpi, t1p;
generate begin: lp_ctrl
  for (t1i=0;t1i<NUMVBNK;t1i=t1i+1) begin : bank
    wire               t1_readB_wire  = t1_readB[t1i];
    wire [BITLROW-1:0] t1_addrB_wire  = t1_addrB >> (BITLROW*t1i);
    wire [BITCTRL-1:0] t1_cinB_wire   = t1_cinB >> (t1i*BITCTRL);
    wire               t1_vldB_wire   = t1_vldB[t1i];
    wire [BITCTRL-1:0] t1_coutB_wire  = t1_coutB >> (t1i*BITCTRL);
    wire [WIDTH-1:0]   t1_doutB_wire  = t1_doutB >> (WIDTH*t1i);
    wire               t1_fwrdB_wire  = t1_fwrdB[t1i];
    wire               t1_serrB_wire  = t1_serrB[t1i];
    wire               t1_derrB_wire  = t1_derrB[t1i];
    wire [BITLROW-1:0] t1_padrB_wire  = t1_padrB >> (BITLROW*t1i);

    wire               t1_writeA_wire = t1_writeA[t1i];
    wire [BITLROW-1:0] t1_addrA_wire  = t1_addrA >> (BITLROW*t1i);
    wire [WIDTH-1:0]   t1_dinA_wire   = t1_dinA >> (WIDTH*t1i);
 

    assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (!ready) t1_writeA_wire |-> (t1_addrA_wire < NUMLROW));
    assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (!ready) t1_readB_wire  |-> (t1_addrB_wire < NUMLROW));

    reg [BITCTRL-1:0]  t1_cinB_pipe [0:READ_DELAY-1];
    reg                t1_readB_pipe [0:READ_DELAY-1];
    for (t1p=0;t1p<READ_DELAY;t1p++) begin : t1p_loop
      if (t1p>0)
        always @(posedge clk) begin
          t1_readB_pipe[t1p] <= ready ? t1_readB_pipe[t1p-1] : 0;
          t1_cinB_pipe[t1p]  <= ready ? t1_cinB_pipe[t1p-1]  : 0;
        end
      else
        always @(posedge clk) begin
          t1_readB_pipe[t1p] <= ready ? t1_readB_wire : 0;
          t1_cinB_pipe[t1p]  <= ready ? t1_cinB_wire  : 0;
        end
    end

    reg dup_id;
    always_comb begin : dup_c
      dup_id = 1'b0;
      for (integer rp=0;rp<READ_DELAY-6;rp++) begin // 6 is RLPWSIZ as well as read rate
        if (t1_readB_wire && t1_readB_pipe[rp] && (t1_cinB_wire == t1_cinB_pipe[rp]))
          dup_id = 1'b1;
      end
    end

    // Duplicate ID - for 4-in-6, duplicate check window is reduced by
    // 6 because four ports can send an op to the same bank in one cycle
    // which take six cycles to enter the memory subsystem.
    assert_duplicate_read_id: assert property (@(posedge clk) disable iff (!ready) (!dup_id && (RLOPCNT==4) && (RLPWSIZ==6)))
      else $display ("[ERROR:memoir:%m:%0t] duplicate read ID", $time);

    for (rpi=0;rpi<NUMRDPT;rpi++) begin : rport
      assert_t1_rd_vld_del_check : assert property (@(posedge clk) disable iff (!ready) (read[rpi] && (read_addr[rpi] == select_addr) && (select_bnk == t1i)) |-> ##[1:READ_DELAY-LPBKADL]
                                                                                         (t1_readB_wire && (t1_addrB_wire == select_lrow)));
    end
    for (wpi=0;wpi<NUMWRPT;wpi++) begin : wport
      assert_t1_wr_vld_del_check : assert property (@(posedge clk) disable iff (!ready) (write[wpi] && (write_addr[wpi] == select_addr) && (select_bnk == t1i)) |-> ##[1:READ_DELAY-LPBKADL]
                                                                                         (t1_writeA_wire && (t1_addrA_wire == select_lrow)));
    end

    assert_t1_ctrl_return_loop: assert property (@(posedge clk) disable iff (!ready) t1_readB_wire  |-> ##LPBKDEL
                                                                                      (    (t1_vldB_wire  == $past(t1_readB_wire, LPBKDEL))
                                                                                        && (t1_coutB_wire == $past(t1_cinB_wire,  LPBKDEL))
                                                                                      ));

    assert_t1_padr_return_loop: assert property (@(posedge clk) disable iff (!ready) t1_readB_wire  |-> ##LPBKDEL
                                                                                      (    (t1_vldB_wire  == $past(t1_readB_wire, LPBKDEL))
                                                                                        && (t1_padrB_wire == $past(t1_addrB_wire, LPBKDEL))
                                                                                      ));
    reg t1_refmem;
    reg t1_refinv;
    always @(posedge clk)
      if (rst) begin
        t1_refmem <= 1'b0;
        t1_refinv <= 1'b1;
      end else if (t1_writeA_wire && (t1_addrA_wire == select_lrow) && (select_bnk == t1i)) begin
        t1_refmem <= t1_dinA_wire[select_bit];
        t1_refinv <= 1'b0;
      end

    assert_t1_data_return_loop: assert property (@(posedge clk) disable iff (!ready) (t1_readB_wire && (t1_addrB_wire == select_lrow) && (select_bnk == t1i))  |-> ##LPBKDEL
                                                                                      ($past(t1_refinv,LPBKDEL) || 
                                                                                       (
                                                                                           (t1_doutB_wire[select_bit] == $past(t1_refmem,LPBKDEL))
                                                                                        && (t1_fwrdB_wire             == $past(t1_refmem,LPBKDEL))
                                                                                        && (t1_serrB_wire             == $past(t1_refmem,LPBKDEL))
                                                                                        && (t1_derrB_wire             == $past(t1_refmem,LPBKDEL))
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

