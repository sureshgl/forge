module ip_top_sva_2_nrw_cache_1r1w
#(
parameter     WIDTH = 32,
parameter     BITWDTH = 5,
parameter     NUMRWPT = 1,
parameter     NUMSEQN = 256,
parameter     BITSEQN = 8,
parameter     NUMBEAT = 2,
parameter     BITBEAT = 1,
parameter     NUMADDR = 65536,
parameter     BITADDR = 16,
parameter     NUMVROW = 256, 
parameter     BITVROW = 8,
parameter     NUMVTAG = NUMVROW/NUMBEAT,
parameter     BITVTAG = BITVROW-BITBEAT
   )
(
  input                       clk,
  input                       rst,
  input [NUMRWPT-1:0]         read,
  input [NUMRWPT-1:0]         write,
  input [NUMRWPT-1:0]         flush,
  input [NUMRWPT-1:0]         invld,
  input [NUMRWPT-1:0]         sidx,
  input [NUMRWPT-1:0]         ucach,
  input [NUMRWPT*BITSEQN-1:0] sqin,
  input [NUMRWPT*BITADDR-1:0] addr,
  input [NUMRWPT-1:0]         t1_writeA,
  input [NUMRWPT*BITVTAG-1:0] t1_addrA,
  input [NUMRWPT-1:0]         t1_readB,
  input [NUMRWPT*BITVTAG-1:0] t1_addrB,
  input [NUMRWPT-1:0]         t2_writeA,
  input [NUMRWPT*BITVROW-1:0] t2_addrA,
  input [NUMRWPT-1:0]         t2_readB,
  input [NUMRWPT*BITVROW-1:0] t2_addrB,
  input [NUMRWPT-1:0]         t3_readA,
  input [NUMRWPT*BITSEQN-1:0] t3_sqinA,
  input [NUMRWPT*BITADDR-1:0] t3_addrA
);

wire [BITADDR:0] num_addr_wire = 1<<BITADDR;

genvar rw_int;
generate for (rw_int=0; rw_int<NUMRWPT; rw_int=rw_int+1) begin: rw_loop
  wire read_wire = read >> rw_int;
  wire write_wire = write >> rw_int;
  wire flush_wire = flush >> rw_int;
  wire invld_wire = invld >> rw_int;
  wire ucach_wire = ucach >> rw_int;
  wire sidx_wire = sidx >> rw_int;
  wire [BITSEQN-1:0] sqin_wire = sqin >> (rw_int*BITSEQN);
  wire [BITADDR-1:0] rd_adr_wire = addr >> (rw_int*BITADDR);
  wire [BITBEAT-1:0] rw_bea_wire = rd_adr_wire;

  wire cache_op = !ucach_wire && (read_wire || write_wire || flush_wire || invld_wire);

  //assert_rw_check: assert property (@(posedge clk) disable iff (rst) !(read_wire && invld_wire));
  assert_rw_one_op_check: assert property (@(posedge clk) disable iff (rst) $onehot({read_wire,write_wire,flush_wire,invld_wire}));
  assert_rw_sidx_check: assert property (@(posedge clk) disable iff (rst) sidx_wire |-> (flush_wire || invld_wire));
  assert_rw_uc_check: assert property (@(posedge clk) disable iff (rst) ucach_wire |-> read_wire);
//  assert_rw_uc_adr_check: assert property (@(posedge clk) disable iff (rst) cache_op |-> (ucpfx==0));
end
endgenerate

genvar t1_int;
generate for (t1_int=0; t1_int<NUMRWPT; t1_int=t1_int+1) begin: t1_loop
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITVTAG-1:0] t1_addrA_wire = t1_addrA >> (t1_int*BITVTAG);

  assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVTAG));

  wire t1_readB_wire = t1_readB >> t1_int;
  wire [BITVTAG-1:0] t1_addrB_wire = t1_addrB >> (t1_int*BITVTAG);

  assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMVTAG));
end
endgenerate

genvar t2_int;
generate for (t2_int=0; t2_int<NUMRWPT; t2_int=t2_int+1) begin: t2_loop
  wire t2_writeA_wire = t2_writeA >> t2_int;
  wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> (t2_int*BITVROW);

  assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));

  wire t2_readB_wire = t2_readB >> t2_int;
  wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2_int*BITVROW);

  assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
end
endgenerate

genvar t3_int;
generate for (t3_int=0; t3_int<NUMRWPT; t3_int=t3_int+1) begin: t3_loop
  wire t3_readA_wire = t3_readA >> t3_int;
  wire [BITSEQN-1:0] t3_sqinA_wire = t3_sqinA >> (t3_int*BITSEQN);
  wire [BITADDR-1:0] t3_addrA_wire = t3_addrA >> (t3_int*BITADDR);

  assert_t3_rd_range_check: assert property (@(posedge clk) disable iff (rst) t3_readA_wire |-> (t3_addrA_wire < num_addr_wire));
end
endgenerate

endmodule // ip_top_sva_2_nrw_cache_1r1w

module ip_top_sva_nrw_cache_1r1w
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     BYTWDTH = WIDTH/8,
parameter     NUMRWPT = 1,
parameter     NUMSEQN = 256,
parameter     BITSEQN = 8,
parameter     NUMBEAT = 1,
parameter     BITBEAT = 0,
parameter     NUMADDR = 65536,
parameter     BITADDR = 16,
parameter     NUMVROW = 256, 
parameter     BITVROW = 8,
parameter     NUMWRDS = 1,
parameter     BITWRDS = 0,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 4,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     FIFOCNT = 4,
parameter     BITFIFO = 2,
parameter     BITVTAG = BITVROW-BITBEAT,
parameter     BITDTAG = BITADDR-BITVROW,
parameter     BITTAGW = BITDTAG+BITWRDS+2
   )
(
  input                                 clk,
  input                                 rst,
  input                                 ready,
  input [NUMRWPT-1:0]                   read,
  input [NUMRWPT-1:0]                   write,
  input [NUMRWPT-1:0]                   flush,
  input [NUMRWPT-1:0]                   invld,
  input [NUMRWPT-1:0]                   sidx,
  input [NUMRWPT-1:0]                   ucach,
  input [NUMRWPT*BITSEQN-1:0]           sqin,
  input [NUMRWPT*BITADDR-1:0]           addr,
  input [NUMRWPT-1:0]                   rd_vld,
  input [NUMRWPT-1:0]                   rd_hit,
  input [NUMRWPT*BITSEQN-1:0]           rd_sqout,
  input [NUMRWPT*WIDTH-1:0]             rd_dout,
  input [NUMRWPT-1:0]                   t1_writeA,
  input [NUMRWPT*BITVTAG-1:0]           t1_addrA,
  input [NUMRWPT*NUMWRDS*BITTAGW-1:0]   t1_dinA,
  input [NUMRWPT-1:0]                   t1_readB,
  input [NUMRWPT*BITVTAG-1:0]           t1_addrB,
  input [NUMRWPT*NUMWRDS*BITTAGW-1:0]   t1_doutB,
  input [NUMRWPT-1:0]                   t2_writeA,
  input [NUMRWPT*BITVROW-1:0]           t2_addrA,
  input [NUMRWPT*NUMWRDS*WIDTH-1:0]     t2_dinA,
  input [NUMRWPT-1:0]                   t2_readB,
  input [NUMRWPT*BITVROW-1:0]           t2_addrB,
  input [NUMRWPT*NUMWRDS*WIDTH-1:0]     t2_doutB,
  input [NUMRWPT-1:0]                   t3_readA,
  input [NUMRWPT-1:0]                   t3_ucachA,
  input [NUMRWPT*BITSEQN-1:0]           t3_sqinA,
  input [NUMRWPT*BITADDR-1:0]           t3_addrA,
  input [NUMRWPT-1:0]                   t3_vldA,
  input [NUMRWPT*BITSEQN-1:0]           t3_sqoutA,
  input [NUMRWPT*WIDTH-1:0]             t3_doutA,
  input                                 t3_block,
  input [BITADDR-1:0]                   select_addr,
  input [BITWDTH-1:0]                   select_bit
);

  wire [BITVTAG-1:0] select_vtag = select_addr >> BITBEAT;
  wire [BITVROW-1:0] select_vrow = select_addr;
  wire [BITDTAG-1:0] select_dtag = select_addr >> BITVROW;
  wire [BITBEAT-1:0] select_beat = select_addr;
  wire               select_ucsh;

  assume_select_non_cacheable: assume property (@(posedge clk) disable iff (rst) (select_ucsh == 1'b1));
  assume_select_cacheable: assume property (@(posedge clk) disable iff (rst) (select_ucsh == 1'b0));
  assume_select_ucsh_stable: assume property (@(posedge clk)  disable iff (rst) $stable(select_ucsh));

  wire               read_wire [0:NUMRWPT-1];
  wire               write_wire [0:NUMRWPT-1];
  wire               flush_wire [0:NUMRWPT-1];
  wire               invld_wire [0:NUMRWPT-1];
  wire               sidx_wire [0:NUMRWPT-1];
  wire               ucach_wire [0:NUMRWPT-1];
  wire [BITSEQN-1:0] sqin_wire [0:NUMRWPT-1];
  wire [BITADDR-1:0] addr_wire [0:NUMRWPT-1];
  wire [WIDTH-1:0]   din_wire [0:NUMRWPT-1];
  wire               rd_vld_wire [0:NUMRWPT-1];
  wire               rd_hit_wire [0:NUMRWPT-1];
  wire [BITSEQN-1:0] rd_sqout_wire [0:NUMRWPT-1];
  wire [WIDTH-1:0]   rd_dout_wire [0:NUMRWPT-1];
  genvar rw_var;
  generate for (rw_var=0; rw_var<NUMRWPT; rw_var=rw_var+1) begin: rw_loop
    assign read_wire[rw_var] = read >> rw_var;
    assign write_wire[rw_var] = write >> rw_var;
    assign flush_wire[rw_var] = flush >> rw_var;
    assign invld_wire[rw_var] = invld >> rw_var;
    assign sidx_wire[rw_var] = sidx >> rw_var;
    assign ucach_wire[rw_var] = ucach >> rw_var;
    assign sqin_wire[rw_var] = sqin >> (rw_var*BITSEQN);
    assign addr_wire[rw_var] = addr >> (rw_var*BITADDR);
    assign rd_vld_wire[rw_var] = rd_vld >> rw_var;
    assign rd_hit_wire[rw_var] = rd_hit >> rw_var;
    assign rd_sqout_wire[rw_var] = rd_sqout >> (rw_var*BITSEQN);
    assign rd_dout_wire[rw_var] = rd_dout >> (rw_var*WIDTH);
  end
  endgenerate

  reg               ucach_del [0:NUMRWPT-1];
  reg [BITSEQN-1:0] sqin_del [0:NUMRWPT-1];
  reg [BITADDR-1:0] addr_del [0:NUMRWPT-1];
  integer del_int;
  always @(posedge clk)
    for (del_int=0; del_int<NUMRWPT; del_int=del_int+1) begin
      ucach_del[del_int] <= ucach_wire[del_int];
      sqin_del[del_int] <= sqin_wire[del_int];
      addr_del[del_int] <= addr_wire[del_int];
    end

  reg                       t1_writeA_wire [0:NUMRWPT-1];
  reg [BITVTAG-1:0]         t1_addrA_wire [0:NUMRWPT-1];
  reg [NUMWRDS*BITTAGW-1:0] t1_dinA_wire [0:NUMRWPT-1];
  reg                       t1_readB_wire [0:NUMRWPT-1];
  reg [BITVTAG-1:0]         t1_addrB_wire [0:NUMRWPT-1];
  reg [NUMWRDS*BITTAGW-1:0] t1_doutB_wire [0:NUMRWPT-1];
  integer t1_int;
  always_comb
    for (t1_int=0; t1_int<NUMRWPT; t1_int=t1_int+1) begin
      t1_writeA_wire[t1_int] = t1_writeA >> t1_int;
      t1_addrA_wire[t1_int] = t1_addrA >> (t1_int*BITVTAG);
      t1_dinA_wire[t1_int] = t1_dinA >> (t1_int*NUMWRDS*BITTAGW);
      t1_readB_wire[t1_int] = t1_readB >> t1_int;
      t1_addrB_wire[t1_int] = t1_addrB >> (t1_int*BITVTAG);
      t1_doutB_wire[t1_int] = t1_doutB >> (t1_int*NUMWRDS*BITTAGW);
    end

  reg                      t2_writeA_wire [0:NUMRWPT-1];
  reg [BITVROW-1:0]        t2_addrA_wire [0:NUMRWPT-1];
  reg [NUMWRDS*WIDTH-1:0]  t2_dinA_wire [0:NUMRWPT-1];
  reg                      t2_readB_wire [0:NUMRWPT-1];
  reg [BITVROW-1:0]        t2_addrB_wire [0:NUMRWPT-1];
  reg [NUMWRDS*WIDTH-1:0]  t2_doutB_wire [0:NUMRWPT-1];
  reg                      t2_doutB_selb [0:NUMRWPT-1][0:NUMWRDS-1];
  integer t2_int, t2w_int;
  always_comb
    for (t2_int=0; t2_int<NUMRWPT; t2_int=t2_int+1) begin
      t2_writeA_wire[t2_int] = t2_writeA >> t2_int;
      t2_addrA_wire[t2_int] = t2_addrA >> (t2_int*BITVROW);
      t2_dinA_wire[t2_int] = t2_dinA >> (t2_int*NUMWRDS*WIDTH);
      t2_readB_wire[t2_int] = t2_readB >> t2_int;
      t2_addrB_wire[t2_int] = t2_addrB >> (t2_int*BITVROW);
      t2_doutB_wire[t2_int] = t2_doutB >> (t2_int*NUMWRDS*WIDTH);
      for (t2w_int=0; t2w_int<NUMWRDS; t2w_int=t2w_int+1)
        t2_doutB_selb[t2_int][t2w_int] = t2_doutB_wire[t2_int] >> select_bit;
    end

  reg               t3_readA_wire [0:NUMRWPT-1];
  reg               t3_ucachA_wire [0:NUMRWPT-1];
  reg [BITSEQN-1:0] t3_sqinA_wire [0:NUMRWPT-1];
  reg [BITADDR-1:0] t3_addrA_wire [0:NUMRWPT-1];
  reg               t3_vldA_wire [0:NUMRWPT-1];
  reg [BITSEQN-1:0] t3_sqoutA_wire [0:NUMRWPT-1];
  reg [WIDTH-1:0]   t3_doutA_wire [0:NUMRWPT-1];
  integer t3_int;
  always_comb
    for (t3_int=0; t3_int<NUMRWPT; t3_int=t3_int+1) begin
      t3_readA_wire[t3_int] = t3_readA >> t3_int;
      t3_ucachA_wire[t3_int] = t3_ucachA >> t3_int;
      t3_sqinA_wire[t3_int]  = t3_sqinA >> (t3_int*BITSEQN);
      t3_addrA_wire[t3_int]  = t3_addrA >> (t3_int*BITADDR);
      t3_vldA_wire[t3_int] = t3_vldA >> t3_int;
      t3_sqoutA_wire[t3_int]  = t3_sqoutA >> (t3_int*BITSEQN);
      t3_doutA_wire[t3_int]  = t3_doutA >> (t3_int*WIDTH);
    end

  reg [NUMWRDS*BITTAGW-1:0] tag;
  integer tag_int;
  always @(posedge clk)
    if (rst)
      tag <= 0;
    else for (tag_int=0; tag_int<NUMRWPT; tag_int=tag_int+1)
//    if (t1_writeA_wire[tag_int] && (t1_addrA_wire[tag_int]==select_vtag))
//      tag <= t1_dinA_wire[tag_int];
      if (core.twrite_next [tag_int] && (core.twraddr_next[tag_int]==select_vtag))
        tag <= core.tdin_next[tag_int];

  reg datinv;
  reg [NUMWRDS*WIDTH-1:0] dat;
  integer dat_int, daw_int;
  always @(posedge clk)
    if (rst)
      datinv <= 1'b1;
    else for (dat_int=0; dat_int<NUMRWPT; dat_int=dat_int+1)
//    if (t2_writeA_wire[dat_int] && (t2_addrA_wire[dat_int]==select_vrow)) begin
//      datinv <= 1'b0;
//      dat <= t2_dinA_wire[dat_int];
//    end
      if (core.dwrite_next[dat_int] && (core.dwraddr_next[dat_int]==select_vrow)) begin
        datinv <= 1'b0;
        dat <= core.ddin_next[dat_int];
      end

  reg meminv;
  reg mem;
  integer mem_int;
  always @(posedge clk)
    if (rst) begin
      meminv <= 1'b0;
      mem <= 1'b1;
    end

  reg               rd_vld_reg [0:NUMRWPT-1][0:DRAM_DELAY+NUMBEAT-1];
  reg [BITSEQN-1:0] rd_sqout_reg [0:NUMRWPT-1][0:DRAM_DELAY+NUMBEAT-1];
  integer rdvp_int, rdvd_int;
  always @(posedge clk)
    for (rdvp_int=0; rdvp_int<NUMRWPT; rdvp_int=rdvp_int+1)
      for (rdvd_int=0; rdvd_int<DRAM_DELAY+NUMBEAT; rdvd_int=rdvd_int+1)
        if (rdvd_int>0) begin
          rd_vld_reg[rdvp_int][rdvd_int] <= rd_vld_reg[rdvp_int][rdvd_int-1];
          rd_sqout_reg[rdvp_int][rdvd_int] <= rd_sqout_reg[rdvp_int][rdvd_int-1];
        end else begin
          rd_vld_reg[rdvp_int][rdvd_int] <= rd_vld_wire[rdvp_int];
          rd_sqout_reg[rdvp_int][rdvd_int] <= rd_sqout_wire[rdvp_int];
        end

  reg [BITBEAT:0] seq_bmp [0:NUMSEQN-1];
  integer seq_int;
  always @(posedge clk)
    if (!ready)
      for (seq_int=0; seq_int<NUMSEQN; seq_int=seq_int+1)
        seq_bmp[seq_int] <= 0;
    else begin
      if (read_wire[0])
        seq_bmp[sqin_wire[0]] <= 1; 
      if (invld_wire[0])
        seq_bmp[sqin_wire[0]] <= 1;
      if (rd_vld_wire[0])
        seq_bmp[rd_sqout_wire[0]] <= seq_bmp[rd_sqout_wire[0]] - 1;
    end

  reg [BITBEAT:0] sqff_bmp [0:NUMSEQN-1];
  integer sqff_int;
  always @(posedge clk)
    if (!ready) begin
      for (sqff_int=0; sqff_int<NUMSEQN; sqff_int=sqff_int+1)
        sqff_bmp[sqff_int] <= 0;
    end else begin
      if (t3_readA_wire[0])
        sqff_bmp[t3_sqinA_wire[0]] <= NUMBEAT;
      if (t3_vldA_wire[0])
        sqff_bmp[t3_sqoutA_wire[0]] <= sqff_bmp[t3_sqoutA_wire[0]] - 1;
    end

  reg sqff_mid;
  reg [BITSEQN-1:0] sqff_msq;
  always @(posedge clk)
    if (!ready) begin
      sqff_mid <= 1'b0;
      sqff_msq <= 0;
    end else if (t3_vldA_wire[0]) begin
      sqff_mid <= (sqff_bmp[t3_sqoutA_wire[0]]!=1);
      sqff_msq <= t3_sqoutA_wire[0];
    end

  reg seq_mid;
  reg [BITSEQN-1:0] seq_msq;
  always @(posedge clk)
    if (!ready) begin
      seq_mid <= 1'b0;
      seq_msq <= 0;
    end else if (rd_vld_wire[0] && (core.vaddr_out[0][BITADDR-1:BITBEAT]==select_addr[BITADDR-1:BITBEAT])) begin
      seq_mid <= (seq_bmp[rd_sqout_wire[0]]!=1);
      seq_msq <= rd_sqout_wire[0];
    end

  genvar tdout_var, tdoux_var;
  generate for (tdout_var=0; tdout_var<NUMRWPT; tdout_var=tdout_var+1) begin: tdout_loop
    assert_tdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[tdout_var] && (t1_addrB_wire[tdout_var] == select_vtag)) |-> ##SRAM_DELAY
                                         (t1_doutB_wire[tdout_var] == $past(tag,SRAM_DELAY)));
    assert_ddout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[tdout_var] && (t2_addrB_wire[tdout_var] == select_vrow)) |-> ##SRAM_DELAY
                                         ($past(datinv,SRAM_DELAY) || (t2_doutB_wire[tdout_var] == $past(dat,SRAM_DELAY))));
//    for (tdoux_var=0; tdoux_var<NUMWRDS; tdoux_var=tdoux_var+1) begin: tdoux_loop                                     
//      assert_ddout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[tdout_var] && (t2_addrB_wire[tdout_var] == select_vrow)) |-> ##SRAM_DELAY
//                                           ($past(datinv,SRAM_DELAY) || (t2_doutB_selb[tdout_var][tdoux_var] == $past(dat[tdoux_var],SRAM_DELAY))));
//    end
  end
  endgenerate
  
  genvar fwrd_var, fwrx_var;
  generate for (fwrd_var=0; fwrd_var<NUMRWPT; fwrd_var=fwrd_var+1) begin: fwrd_loop
    assert_dtag_fwd_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[fwrd_var] && (t1_addrB_wire[fwrd_var] == select_vtag)) |-> ##SRAM_DELAY
                                            (core.dtag_out[fwrd_var] == tag));
    assert_data_fwd_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[fwrd_var] && (t2_addrB_wire[fwrd_var] == select_vrow)) |-> ##SRAM_DELAY
                                            (datinv || (core.data_out[fwrd_var] == dat)));
//    for (fwrx_var=0; fwrx_var<NUMWRDS; fwrx_var=fwrx_var+1) begin: fwrx_loop
//      assert_data_fwd_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[fwrd_var]&& (t2_addrB_wire[fwrd_var] == select_vrow)) |-> ##SRAM_DELAY
//                                              (datinv || (core.data_out[fwrd_var][fwrx_var*WIDTH+select_bit] == dat[fwrx_var])));
//    end
  end
  endgenerate

  genvar pdout_var;
  generate for (pdout_var=0; pdout_var<NUMRWPT; pdout_var=pdout_var+1) begin: pdout_loop
    property pdout_check;
    logic [BITSEQN-1:0] seqx;
    @(posedge clk) disable iff (rst) (t3_readA_wire[pdout_var] && (t3_addrA_wire[pdout_var][BITADDR-1:BITBEAT] == select_addr[BITADDR-1:BITBEAT]),seqx=t3_sqinA_wire[pdout_var]) |-> ##[1:DRAM_DELAY+NUMBEAT-1]
                                     (t3_vldA_wire[pdout_var] && (t3_sqoutA_wire[pdout_var]==seqx) && ((BITBEAT==0) || (sqff_bmp[seqx]==(NUMBEAT-(select_addr%NUMBEAT)))) &&
                                      (meminv || (t3_doutA_wire[pdout_var][select_bit]==mem)));
    endproperty
`ifndef SIM_SVA
    assert_pdout_check: assert property (pdout_check);
`endif

    property pdout_del_check;
    logic [BITSEQN-1:0] seqx;
    @(posedge clk) disable iff (rst) (t3_readA_wire[pdout_var] && (t3_addrA_wire[pdout_var][BITADDR-1:BITBEAT] == select_addr[BITADDR-1:BITBEAT]),seqx=t3_sqinA_wire[pdout_var]) |-> ##[1:DRAM_DELAY+NUMBEAT-1]
                                     (t3_vldA_wire[pdout_var] && (t3_sqoutA_wire[pdout_var]==seqx) && (sqff_bmp[seqx]==1));
    endproperty
`ifndef SIM_SVA
    assert_pdout_del_check: assert property (pdout_del_check);
`endif

    property beat_check;
    logic [BITSEQN-1:0] seqx;
    @(posedge clk) disable iff (rst) ((t3_vldA_wire[pdout_var] && (BITBEAT!=0) && (sqff_bmp[t3_sqoutA_wire[pdout_var]]==NUMBEAT)),seqx=t3_sqoutA_wire[pdout_var]) |-> ##[1:DRAM_DELAY+NUMBEAT-1]
                                      (t3_vldA_wire[pdout_var] && (t3_sqoutA_wire[pdout_var]==seqx) && (sqff_bmp[seqx]==1));
    endproperty
`ifndef SIM_SVA
    assert_beat_check: assert property (beat_check);
`endif
//    assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t3_readA_wire[pdout_var] && (t3_addrA_wire[pdout_var] == select_addr)) |-> ##DRAM_DELAY
//                                         (t3_vldA_wire[pdout_var] && (t3_sqoutA_wire[pdout_var]==$past(t3_sqinA_wire[pdout_var],DRAM_DELAY)) &&
//                                          (meminv || (t3_doutA_wire[pdout_var] == mem))));
    assert_t3_vld_check: assert property (@(posedge clk) disable iff (rst) !(t3_vldA_wire[pdout_var] && (!(|sqff_bmp[t3_sqoutA_wire[pdout_var]]) ||
                                                                                                         (sqff_mid && (t3_sqoutA_wire[pdout_var]!=sqff_msq)))));
  end
  endgenerate

`ifndef SIM_SVA // dont enable for sims  
  assert_t3_block_check: assert property (@(posedge clk) disable iff (!ready) t3_block |-> ##[1:2] !t3_block);
`endif
  assert_seq_check: assert property (@(posedge clk) disable iff (!ready) (read_wire[0] || invld_wire[0] || ucach_wire[0]) |-> !(|seq_bmp[sqin_wire[0]]));
  assert_sqfifo_cnt_check: assert property (@(posedge clk) disable iff (rst) (core.sqfifo_cnt <= FIFOCNT));
/*
  assert_rw_dq_check: assert property (@(posedge clk) disable iff (rst) !(core.sqfifo_deq[0] && (read_wire[0] || invld_wire[0] || ucach_wire[0])) &&
                                                                        !(core.sqfifo_deq[0] && core.vcirc_wire[0]) &&
                                                                        !(core.vcirc_wire[0] && (read_wire[0] || invld_wire[0] || ucach_wire[0])));
*/
  reg               tag_drt;
  reg               tag_vld;
  reg               tag_sam;
  reg [BITWRDS:0]   tag_cnt;
  reg [NUMWRDS-1:0] tag_bmp;
  reg [NUMWRDS-1:0] tag_lru;
  reg [BITTAGW-1:0] tag_wire [0:NUMWRDS-1];
  integer tdrw_int;
  always_comb begin
   for (tdrw_int=0; tdrw_int<NUMWRDS; tdrw_int=tdrw_int+1)
     tag_wire[tdrw_int] = tag >> (tdrw_int*BITTAGW);
   tag_drt = 1'b0;
   for (tdrw_int=0; tdrw_int<NUMWRDS; tdrw_int=tdrw_int+1)
     if (tag_wire[tdrw_int][BITTAGW-1] && tag_wire[tdrw_int][BITTAGW-2] && (tag_wire[tdrw_int][BITDTAG-1:0]==select_dtag))
       tag_drt = 1'b1;
   tag_vld = 1'b0;
   tag_sam = 1'b0;
   for (tdrw_int=0; tdrw_int<NUMWRDS; tdrw_int=tdrw_int+1)
     if (tag_wire[tdrw_int][BITTAGW-1] && (tag_wire[tdrw_int][BITDTAG-1:0]==select_dtag)) begin
       tag_sam = tag_sam || tag_vld;
       tag_vld = 1'b1;
     end
   tag_cnt = 0;
   for (tdrw_int=0; tdrw_int<NUMWRDS; tdrw_int=tdrw_int+1)
     if (tag_wire[tdrw_int][BITTAGW-1])
       tag_cnt = tag_cnt + 1;
   tag_bmp = ~0 << tag_cnt;
   tag_lru = 0;
   for (tdrw_int=0; tdrw_int<NUMWRDS; tdrw_int=tdrw_int+1)
     if (tag_wire[tdrw_int][BITTAGW-1])
       tag_lru = tag_lru | (1'b1 << tag_wire[tdrw_int][BITTAGW-3:BITTAGW-BITWRDS-2]);
  end

  assert_lru_check: assert property (@(posedge clk) disable iff (!ready) &(tag_bmp | tag_lru));

  reg fill_flag;
  integer fill_int;
  always_comb begin
    fill_flag = 0;
    for (fill_int=0; fill_int<FIFOCNT; fill_int=fill_int+1)
      if ((fill_int<core.sqfifo_cnt) && (core.sqfifo_adr[fill_int][BITADDR-1:BITBEAT]==select_addr[BITADDR-1:BITBEAT]) && core.sqfifo_fil[fill_int])
        fill_flag = 1'b1;
  end
`ifndef SIM_SVA // dont enable for sims
  assert_space_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] && (select_ucsh==ucach_wire[0]) && (addr_wire[0][BITADDR-1:BITBEAT]==select_addr[BITADDR-1:BITBEAT])) |-> ##1
                                       !(read_wire[0] && (select_ucsh==ucach_wire[0]) && (addr_wire[0][BITADDR-1:BITBEAT]==select_addr[BITADDR-1:BITBEAT])) [*3]);
`endif

  reg [BITFIFO:0] fifocnt_nxt;
  reg [BITFIFO:0] fifocnt;
  reg rd_fnd_wire [0:NUMRWPT-1];
  integer ffct_int;
  always_comb begin
    fifocnt_nxt = fifocnt;
    for (ffct_int=0; ffct_int<NUMRWPT; ffct_int=ffct_int+1) 
      if ((read_wire[ffct_int] || invld_wire[ffct_int]) && (addr_wire[ffct_int][BITADDR-1:BITBEAT]==select_addr[BITADDR-1:BITBEAT]))
        fifocnt_nxt = fifocnt_nxt + 1; 
    for (ffct_int=0; ffct_int<NUMRWPT; ffct_int=ffct_int+1) 
      if (rd_vld_wire[ffct_int] && rd_fnd_wire[ffct_int] && (seq_bmp[rd_sqout_wire[ffct_int]]==1))
        fifocnt_nxt = fifocnt_nxt - 1;
  end

  always @(posedge clk)
    if (!ready)
      fifocnt <= 0;
    else
      fifocnt <= fifocnt_nxt;

  reg [3:0] popcnt;
  integer popc_int;
  always_comb begin
    popcnt = 0;
    for (popc_int=0; popc_int<NUMRWPT; popc_int=popc_int+1)
      if (rd_vld_wire[popc_int] && rd_fnd_wire[popc_int] && (seq_bmp[rd_sqout_wire[popc_int]]==1))
        popcnt = popcnt + 1;
  end

  reg [3:0] push_sel [0:NUMRWPT-1];
  integer fifn_int;
  always_comb
    for (fifn_int=0; fifn_int<NUMRWPT; fifn_int=fifn_int+1) begin
      if (fifn_int>0)
        push_sel[fifn_int] = push_sel[fifn_int-1];
      else
        push_sel[fifn_int] = fifocnt-popcnt-1;
      if ((read_wire[fifn_int] || invld_wire[fifn_int]) && (addr_wire[fifn_int][BITADDR-1:BITBEAT]==select_addr[BITADDR-1:BITBEAT]))
        push_sel[fifn_int] = push_sel[fifn_int] + 1;
    end

  reg [BITSEQN-1:0] seqfifo [0:FIFOCNT-1];
  reg [BITSEQN-1:0] rdvfifo [0:FIFOCNT-1];
  reg [BITSEQN-1:0] invfifo [0:FIFOCNT-1];
  reg [BITSEQN-1:0] seqfifo_nxt [0:FIFOCNT-1];
  reg [BITSEQN-1:0] rdvfifo_nxt [0:FIFOCNT-1];
  reg [BITSEQN-1:0] invfifo_nxt [0:FIFOCNT-1];
  integer fifo_int, fifp_int;
  always_comb
    for (fifo_int=0; fifo_int<FIFOCNT; fifo_int=fifo_int+1) begin
      seqfifo_nxt[fifo_int] = seqfifo[fifo_int];
      rdvfifo_nxt[fifo_int] = rdvfifo[fifo_int];
      invfifo_nxt[fifo_int] = invfifo[fifo_int];
      if (fifo_int<(fifocnt-popcnt)) begin
        seqfifo_nxt[fifo_int] = seqfifo[fifo_int+popcnt];
        rdvfifo_nxt[fifo_int] = rdvfifo[fifo_int+popcnt];
        invfifo_nxt[fifo_int] = invfifo[fifo_int+popcnt];
      end
      if (fifo_int>=(fifocnt-popcnt))
        for (fifp_int=0; fifp_int<NUMRWPT; fifp_int=fifp_int+1)
          if ((read_wire[fifp_int] || invld_wire[fifp_int]) && (addr_wire[fifp_int][BITADDR-1:BITBEAT]==select_addr[BITADDR-1:BITBEAT])) begin
            seqfifo_nxt[fifo_int] = sqin_wire[fifp_int];
            rdvfifo_nxt[fifo_int] = read_wire[fifp_int];
            invfifo_nxt[fifo_int] = invld_wire[fifp_int];
          end
    end

  integer fiff_int;
  always @(posedge clk)
    for (fiff_int=0; fiff_int<FIFOCNT; fiff_int=fiff_int+1) begin
      seqfifo[fiff_int] <= seqfifo_nxt[fiff_int];
      rdvfifo[fiff_int] <= rdvfifo_nxt[fiff_int];
      invfifo[fiff_int] <= invfifo_nxt[fiff_int];
    end

  integer rdfd_int, rdff_int;
  always_comb
    for (rdfd_int=0; rdfd_int<NUMRWPT; rdfd_int=rdfd_int+1) begin
      rd_fnd_wire[rdfd_int] = 1'b0;
      for (rdff_int=FIFOCNT-1; rdff_int>=0; rdff_int=rdff_int-1)
        if ((rdff_int<fifocnt) && rd_vld_wire[rdfd_int] && (rd_sqout_wire[rdfd_int]==seqfifo[rdff_int]))
          rd_fnd_wire[rdfd_int] = 1'b1;
    end

  genvar dout_var;
  generate for (dout_var=0; dout_var<NUMRWPT; dout_var=dout_var+1) begin: dout_loop

    assert_sqout_check: assert property (@(posedge clk) disable iff (rst) 
                                         !(rd_vld_wire[dout_var] && (core.vaddr_out[dout_var][BITADDR-1:BITBEAT]==select_addr[BITADDR-1:BITBEAT]) &&
                                           (!(|seq_bmp[rd_sqout_wire[dout_var]]) || (seq_mid && (rd_sqout_wire[dout_var]!=seq_msq)))));

    assert_order_check: assert property (@(posedge clk) disable iff (rst) (rd_vld_wire[dout_var] && rd_fnd_wire[dout_var]) |-> (rd_sqout_wire[dout_var]==seqfifo[0]));
                                          

    property rd_dout_check;
    logic [BITSEQN-1:0] seqx;
    logic invx;
    logic datx;
    @(posedge clk) disable iff (rst) ((read_wire[dout_var] && (select_ucsh==ucach_wire[dout_var]) && (addr_wire[dout_var][BITADDR-1:BITBEAT]==select_addr[BITADDR-1:BITBEAT])),{seqx,invx,datx}={sqin_wire[dout_var],meminv,mem}) |-> ##[SRAM_DELAY:3*SRAM_DELAY+DRAM_DELAY+FIFOCNT*NUMBEAT+8] 
                                      // NUMBEAT=1, DRAM_DELAY=3, FIFOCNT=4, 3*SRAM_DELAY+DRAM_DELAY+FIFOCNT*NUMBEAT+16
                                      // NUMBEAT=1, DRAM_DELAY=2, FIFOCNT=4, 3*SRAM_DELAY+DRAM_DELAY+FIFOCNT*NUMBEAT+8
                                      // NUMBEAT=1, DRAM_DELAY=1, FIFOCNT=4, 3*SRAM_DELAY+DRAM_DELAY+FIFOCNT*NUMBEAT+6
                                     (rd_vld_wire[dout_var] && (rd_sqout_wire[dout_var]==seqx) &&
                                      (invx || (rd_dout_wire[dout_var][select_bit]==datx)) && (select_ucsh || (rd_hit_wire[dout_var]==tag_vld)));
    endproperty
`ifndef SIM_SVA
    assert_rd_dout_check: assert property (rd_dout_check);
`endif

    property rd_vld_check;
    logic [BITSEQN-1:0] seqx;
    @(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var][BITADDR-1:BITBEAT]==select_addr[BITADDR-1:BITBEAT]),seqx=sqin_wire[dout_var]) |-> ##(SRAM_DELAY+2)
                                     (fill_flag || core.vld_flag[seqx] || $past(!core.vsqwr_nxt[dout_var]));
    endproperty
`ifndef SIM_SVA
    assert_rd_vld_check: assert property (rd_vld_check);
`endif

    property vr_vld_check;
    logic [BITSEQN-1:0] seqx;
    @(posedge clk) disable iff (rst) (core.srdwr_out[dout_var] && core.vread_out[dout_var] && (core.vaddr_out[dout_var][BITADDR-1:BITBEAT]==select_addr[BITADDR-1:BITBEAT]),seqx=core.vsqin_out[dout_var]) |-> ##2
                                     (fill_flag || core.vld_flag[seqx] || $past(core.vfill_out[dout_var] || core.sqfifo_pop[dout_var],2));
    endproperty
`ifndef SIM_SVA  // dont enable for sims
    assert_vr_vld_check: assert property (vr_vld_check);
`endif

    property vr_enq_check;
    logic [BITSEQN-1:0] seqx;
    logic [BITFIFO-1:0] pslx;
    @(posedge clk) disable iff (rst) (!core.srdwr_out[dout_var] && core.vread_out[dout_var] && !core.vucach_out[dout_var] && !core.cache_hit[dout_var] &&
                                      (core.vaddr_out[dout_var][BITADDR-1:BITBEAT]==select_addr[BITADDR-1:BITBEAT]),seqx=core.vsqin_out[dout_var]) |-> ##[1:21]
                                     (core.srdwr_out[dout_var] && core.vread_out[dout_var] && !core.vucach_out[dout_var] && (seqx==core.vsqin_out[dout_var]));
    endproperty
`ifndef SIM_SVA  // dont enable for sims
    assert_vr_enq_check: assert property (vr_enq_check);
`endif

    property vr_wire_check;
    logic [BITSEQN-1:0] seqx;
    logic [BITFIFO-1:0] pslx;
    @(posedge clk) disable iff (rst) (core.srdwr_out[dout_var] && core.vread_out[dout_var] && !core.vucach_out[dout_var] && !core.cache_hit[dout_var] &&
                                      !core.vfill_out[dout_var] && (core.vaddr_out[dout_var][BITADDR-1:BITBEAT]==select_addr[BITADDR-1:BITBEAT]),
                                      {seqx,pslx}={core.vsqin_out[dout_var],core.sqfifo_psl[dout_var]}) |-> ##[1:5]
                                     (core.srdwr_out[dout_var] && core.vread_out[dout_var] && !core.vucach_out[dout_var] &&
                                      (seqx==core.vsqin_out[dout_var]) && ((pslx>core.sqfifo_psl[dout_var]) || core.vfill_out[dout_var]));
    endproperty
`ifndef SIM_SVA  // dont enable for sims
    assert_vr_wire_check: assert property (vr_wire_check);
`endif
/*
    property vr_fill_check;
    logic [BITSEQN-1:0] seqx;
    logic [BITFIFO-1:0] pslx;
    @(posedge clk) disable iff (rst) (core.vread_out[dout_var] && !core.vucach_out[dout_var] && (core.cache_hit[dout_var] || core.vfill_out[dout_var]) &&
                                      (core.vaddr_out[dout_var][BITADDR-1:BITBEAT]==select_addr[BITADDR-1:BITBEAT]),seqx=core.vsqin_out[dout_var]) |-> ##[0:NUMBEAT]
                                     (rd_vld_wire[dout_var] && (rd_sqout_wire[dout_var]==seqx) && (rd_dout_wire[dout_var][select_bit]==fakemem));
    endproperty
    assert_vr_fill_check: assert property (vr_fill_check);
*/

    property in_dout_check;
    logic [BITSEQN-1:0] seqx;
    @(posedge clk) disable iff (rst) (invld_wire[dout_var] && (addr_wire[dout_var]==select_addr),seqx=sqin_wire[dout_var]) |-> ##[SRAM_DELAY+1:2*SRAM_DELAY+DRAM_DELAY+FIFOCNT+1]
                                     ($past(rd_vld_wire[dout_var]) && ($past(rd_sqout_wire[dout_var])==seqx) && !tag_vld);
    endproperty
`ifndef SIM_SVA
    assert_in_dout_check: assert property (in_dout_check);
`endif

    property uc_dout_check;
    logic [BITSEQN-1:0] seqx;
    @(posedge clk) disable iff (rst) (ucach_wire[dout_var] && (addr_wire[dout_var]==select_addr),seqx=sqin_wire[dout_var]) |-> ##[SRAM_DELAY:2*SRAM_DELAY+DRAM_DELAY+FIFOCNT]
                                     (rd_vld_wire[dout_var] && (rd_sqout_wire[dout_var]==seqx));
    endproperty
`ifndef SIM_SVA
    assert_uc_dout_check: assert property (uc_dout_check);
`endif

  end
  endgenerate

endmodule // ip_top_sva_nrw_cache_1r1w

