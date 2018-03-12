module ip_top_sva_2_nw1ru_1r1w
  #(
parameter     WIDTH   = 32,
parameter     NUMSTPT = 2,
parameter     NUMPBNK = 3,
parameter     BITPBNK = 2,
parameter     SRAM_DELAY = 2,
parameter     UPDT_DELAY = 1,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMSTPT-1:0] st_write,
  input [NUMSTPT*BITADDR-1:0] st_adr,
  input [NUMSTPT*WIDTH-1:0] st_din,
  input read,
  input write,
  input [BITADDR-1:0]  addr,
  input [WIDTH-1:0]  din,
  input [NUMPBNK-1:0] t1_writeA,
  input [NUMPBNK*BITADDR-1:0] t1_addrA,
  input [NUMPBNK-1:0] t1_readB,
  input [NUMPBNK*BITADDR-1:0] t1_addrB
);

genvar st_int;
generate for (st_int=0; st_int<NUMSTPT; st_int=st_int+1) begin: st_loop
  wire st_write_wire = st_write >> st_int;
  wire [BITADDR-1:0] st_adr_wire = st_adr >> (st_int*BITADDR);
  wire [WIDTH-1:0] st_din_wire = st_din >> (st_int*WIDTH);

  assert_st_range_check: assert property (@(posedge clk) disable iff (rst) st_write_wire |-> (st_adr_wire < NUMADDR));
end
endgenerate

genvar ru_int;
generate for (ru_int=0; ru_int<1; ru_int=ru_int+1) begin: ru_loop
  wire read_wire = read >> ru_int;
  wire write_wire = write >> ru_int;
  wire [WIDTH-1:0] din_wire = din >> (ru_int*WIDTH);
  wire [BITADDR-1:0] rd_adr_wire = addr >> (ru_int*BITADDR);

  assert_ru_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(SRAM_DELAY+FLOPOUT+UPDT_DELAY+FLOPIN) !($past(!read_wire,SRAM_DELAY+FLOPOUT+UPDT_DELAY+FLOPIN) && write_wire));
  assert_rd_range_check: assert property (@(posedge clk) disable iff (rst) read_wire |-> (rd_adr_wire < NUMADDR));
end
endgenerate

genvar t1_int;
generate for (t1_int=0; t1_int<NUMPBNK; t1_int=t1_int+1) begin: t1_loop
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITADDR-1:0] t1_addrA_wire = t1_addrA >> (t1_int*BITADDR);

  wire t1_readB_wire = t1_readB >> t1_int;
  wire [BITADDR-1:0] t1_addrB_wire = t1_addrB >> (t1_int*BITADDR);

  assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMADDR));
  assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMADDR));
end
endgenerate

endmodule

module ip_top_sva_nw1ru_1r1w
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMSTPT = 2,
parameter     NUMPBNK = 3,
parameter     BITPBNK = 2,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     BITPADR = 14,
parameter     SRAM_DELAY = 2,
parameter     UPDT_DELAY = 1,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     FLOPADD = 0
   )
(
  input clk,
  input rst,
  input ready,
  input read,
  input write,
  input [BITADDR-1:0] addr,
  input [WIDTH-1:0] din,
  input rd_vld,
  input [WIDTH-1:0] rd_dout,
  input rd_fwrd,
  input rd_serr,
  input rd_derr,
  input [BITPADR-1:0] rd_padr,
  input [NUMSTPT-1:0] st_write,
  input [NUMSTPT*BITADDR-1:0] st_adr,
  input [NUMSTPT*WIDTH-1:0] st_din,
  input [NUMPBNK-1:0] t1_writeA,
  input [NUMPBNK*BITADDR-1:0] t1_addrA,
  input [NUMPBNK*WIDTH-1:0] t1_dinA,
  input [NUMPBNK-1:0] t1_readB,
  input [NUMPBNK*BITADDR-1:0] t1_addrB,
  input [NUMPBNK*WIDTH-1:0] t1_doutB,
  input [NUMPBNK-1:0] t1_fwrdB,
  input [NUMPBNK-1:0] t1_serrB,
  input [NUMPBNK-1:0] t1_derrB,
  input [NUMPBNK*(BITPADR-BITPBNK)-1:0] t1_padrB,
  input [BITADDR-1:0] select_addr,
  input [BITWDTH-1:0] select_bit
);

wire st_write_wire [0:NUMSTPT-1];
wire [BITADDR-1:0] st_adr_wire [0:NUMSTPT-1];
wire [WIDTH-1:0] st_din_wire [0:NUMSTPT-1];
genvar st_int;
generate for (st_int=0; st_int<NUMSTPT; st_int=st_int+1) begin: st_loop
  assign st_write_wire[st_int] = st_write >> st_int;
  assign st_adr_wire[st_int] = st_adr >> (st_int*BITADDR);
  assign st_din_wire[st_int] = st_din >> (st_int*WIDTH);
end
endgenerate

reg t1_writeA_wire [0:NUMPBNK-1];
reg [BITADDR-1:0] t1_addrA_wire [0:NUMPBNK-1];
reg [WIDTH-1:0] t1_dinA_wire [0:NUMPBNK-1];
reg t1_readB_wire [0:NUMPBNK-1];
reg [BITADDR-1:0] t1_addrB_wire [0:NUMPBNK-1];
reg [WIDTH-1:0] t1_doutB_wire [0:NUMPBNK-1];
reg t1_serrB_wire [0:NUMPBNK-1];
reg t1_derrB_wire [0:NUMPBNK-1];
reg [BITPADR-BITPBNK-1:0] t1_padrB_wire [0:NUMPBNK-1];
integer t1_prpt_int;
always_comb
  for (t1_prpt_int=0; t1_prpt_int<NUMPBNK; t1_prpt_int=t1_prpt_int+1) begin
    t1_writeA_wire[t1_prpt_int] = t1_writeA >> t1_prpt_int;
    t1_addrA_wire[t1_prpt_int] = t1_addrA >> (t1_prpt_int*BITADDR);
    t1_dinA_wire[t1_prpt_int] = t1_dinA >> (t1_prpt_int*WIDTH);
    t1_readB_wire[t1_prpt_int] = t1_readB >> t1_prpt_int;
    t1_addrB_wire[t1_prpt_int] = t1_addrB >> (t1_prpt_int*BITADDR);
    t1_doutB_wire[t1_prpt_int] = t1_doutB >> (t1_prpt_int*WIDTH);
    t1_serrB_wire[t1_prpt_int] = t1_serrB >> t1_prpt_int;
    t1_derrB_wire[t1_prpt_int] = t1_derrB >> t1_prpt_int;
    t1_padrB_wire[t1_prpt_int] = t1_padrB >> (t1_prpt_int*(BITPADR-BITPBNK));
  end

reg read_reg [0:SRAM_DELAY+FLOPOUT+UPDT_DELAY+FLOPIN-1];
reg [BITADDR-1:0] addr_reg [0:SRAM_DELAY+UPDT_DELAY+FLOPIN-1];
reg ready_reg [0:SRAM_DELAY+FLOPOUT+UPDT_DELAY+FLOPIN-1];

integer adrd_int;
always @(posedge clk) 
  for (adrd_int=0; adrd_int<SRAM_DELAY+FLOPOUT+UPDT_DELAY+FLOPIN;adrd_int=adrd_int+1)
    if (adrd_int>0) begin
      ready_reg[adrd_int] <= ready_reg[adrd_int-1];
      addr_reg[adrd_int] <= addr_reg[adrd_int-1];
    end else begin
      ready_reg[adrd_int] <= ready;
      addr_reg[adrd_int] <= addr;
    end

reg meminv [0:NUMPBNK-1];
reg [WIDTH-1:0] mem [0:NUMPBNK-1];
integer mem_int;
always @(posedge clk)
  for (mem_int=0; mem_int<NUMPBNK; mem_int=mem_int+1)
    if (rst) begin
      meminv[mem_int] <= 1'b0;
      mem[mem_int] <= {WIDTH{1'b0}};
    end else if (t1_writeA_wire[mem_int] && (t1_addrA_wire[mem_int] == select_addr)) begin
      meminv[mem_int] <= 1'b0;
      mem[mem_int] <= t1_dinA_wire[mem_int];
    end

genvar t1_dout_int;
generate for (t1_dout_int=0; t1_dout_int<NUMPBNK; t1_dout_int=t1_dout_int+1) begin: pdout_loop
  assert_pdout_check: assert property (@(posedge clk) disable iff (rst ) (t1_readB_wire[t1_dout_int] && (t1_addrB_wire[t1_dout_int] == select_addr)) |-> ##SRAM_DELAY
                                       ($past(meminv[t1_dout_int],SRAM_DELAY) || t1_derrB_wire[t1_dout_int] || (t1_doutB_wire[t1_dout_int] == $past(mem[t1_dout_int],SRAM_DELAY))));
//  assert_pdout_sel_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[t1_dout_int] && (t1_addrB_wire[t1_dout_int] == select_addr)) |-> ##SRAM_DELAY
//                                           ($past(meminv[t1_dout_int],SRAM_DELAY) || t1_derrB_wire[t1_dout_int] ||
//                                            (t1_doutB_wire[t1_dout_int][select_bit] == $past(mem[t1_dout_int][select_bit],SRAM_DELAY))));
end
endgenerate

genvar cnt_int;
generate for (cnt_int=0; cnt_int<NUMPBNK; cnt_int=cnt_int+1) begin: cnt_loop
  assert_rdcnt_fwd_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(SRAM_DELAY+FLOPIN)
                                           (meminv[cnt_int] || t1_derrB_wire[cnt_int] || (core.rdcnt_out[cnt_int] == mem[cnt_int])));
end
endgenerate

reg cntmeminv;
reg [WIDTH-1:0] cntmem;
integer cmem_int;
always @(posedge clk) 
   if (!ready_reg[SRAM_DELAY+UPDT_DELAY+FLOPIN-1]) begin
     cntmeminv <= 1'b1;
     cntmem <= {WIDTH{1'b0}};
   end else if (write && (addr_reg[SRAM_DELAY+UPDT_DELAY+FLOPIN-1] == select_addr)) begin
     cntmeminv <= 1'b0;
     cntmem <= din;
   end else for (cmem_int=0; cmem_int<NUMSTPT;cmem_int=cmem_int+1) 
     if(st_write_wire[cmem_int] && (st_adr_wire[cmem_int] == select_addr)) begin
       cntmeminv <= 1'b0;
       cntmem <= st_din_wire[cmem_int];
     end


reg meminv_wire;
reg [WIDTH-1:0] mem_wire;
integer fake_int;
always_comb  begin
  meminv_wire = 1'b0;
  mem_wire = {WIDTH{1'b0}};
  for (fake_int=0; fake_int<NUMPBNK; fake_int=fake_int+1) begin
    meminv_wire = 1'b0;
    mem_wire =  |mem[fake_int] ? mem[fake_int] : mem_wire ;
  end
end

/*
generate if (FLOPIN) begin : flpi_loop
  assert_cntmem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(FLOPIN) (read && select_addr) |-> ##delay
                                        ($past(cntmeminv,FLOPIN) || ($past(cntmem,FLOPIN) == dout)));
end else begin : nflpi_loop
  assert_cntmem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> 
                                        (cntmeminv || (cntmem == mem_wire)));
end
endgenerate

wire ct_vld_wire [0:NUMSTPT-1];
wire [NUMPBNK-1:0] ct_serr [0:NUMSTPT-1];
wire [NUMPBNK-1:0] ct_derr [0:NUMSTPT-1];
genvar ct_var;
generate for (ct_var=0; ct_var<NUMSTPT; ct_var=ct_var+1) begin: cto_loop
  assert_ct_vld_check: assert property (@(posedge clk) disable iff (rst) (st_write_wire[ct_var] && (st_adr_wire[ct_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                        ct_vld_wire[ct_var]);
  if (FLOPADD || FLOPOUT) begin: flp_loop
    assert_ct_serr_check: assert property (@(posedge clk) disable iff (rst) (st_write_wire[ct_var] && (st_adr_wire[ct_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                           (ct_serr[ct_var] == $past(t1_serrB[ct_var],FLOPADD+FLOPOUT)));
    assert_ct_derr_check: assert property (@(posedge clk) disable iff (rst) (st_write_wire[ct_var] && (st_adr_wire[ct_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                           (ct_derr[ct_var] == $past(t1_derrB[ct_var],FLOPADD+FLOPOUT)));
  end else begin: nflp_loop
    assert_ct_serr_check: assert property (@(posedge clk) disable iff (rst) (st_write_wire[ct_var] && (st_adr_wire[ct_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                           (ct_serr[ct_var] == t1_serrB[ct_var]));
    assert_ct_derr_check: assert property (@(posedge clk) disable iff (rst) (st_write_wire[ct_var] && (st_adr_wire[ct_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                           (ct_derr[ct_var] == t1_derrB[ct_var]));
  end
end
endgenerate
*/
generate if(FLOPOUT>0) begin : dflp_loop
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                      (rd_vld && ($past(meminv_wire,FLOPOUT)) || |rd_derr ||
                                                 (rd_dout == $past(mem_wire,FLOPOUT))));
end
else begin :dnflp_loop
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                      (rd_vld && (meminv_wire || |rd_derr ||
                                                 (rd_dout == mem_wire))));
end
endgenerate

reg [BITPBNK-1:0] padr_tmp;
reg serr_tmp;
reg derr_tmp;
integer padr_int;
always_comb begin
  serr_tmp = 0;
  derr_tmp = 0;
  padr_tmp = 0;
  for (padr_int=NUMSTPT-1; padr_int>=0; padr_int=padr_int-1) begin
    if (t1_serrB[padr_int] && !derr_tmp) begin
      serr_tmp = 1'b1;
      padr_tmp = padr_int;
    end
    if (t1_derrB[padr_int]) begin
      derr_tmp = 1'b1;
      padr_tmp = padr_int;
    end
  end
end

generate if (FLOPADD || FLOPOUT) begin: eflp_loop
  assert_serr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                      (rd_serr == $past(|t1_serrB,FLOPADD+FLOPOUT)));
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                      (rd_derr == $past(|t1_derrB,FLOPADD+FLOPOUT)));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                      (rd_padr[BITPADR-1:BITPADR-BITPBNK] == $past(padr_tmp,FLOPADD+FLOPOUT)) &&
                                      (rd_padr[BITPADR-BITPBNK-1:0] == $past(t1_padrB_wire[padr_tmp],FLOPADD+FLOPOUT)));
end else begin: neflp_loop
  assert_serr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                      (rd_serr == |t1_serrB));
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                      (rd_derr == |t1_derrB));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (addr == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPADD+FLOPOUT)
                                      (rd_padr[BITPADR-1:BITPADR-BITPBNK] == padr_tmp) &&
                                      (rd_padr[BITPADR-BITPBNK-1:0] == t1_padrB_wire[padr_tmp]));
end
endgenerate

endmodule



