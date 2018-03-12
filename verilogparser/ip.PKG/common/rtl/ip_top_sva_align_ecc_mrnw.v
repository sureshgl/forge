module ip_top_sva_2_align_ecc_mrnw
  #(
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMRDPT = 2,
parameter     NUMWRPT = 2,
parameter     NUMSROW = 256,
parameter     BITSROW = 8)
(
  input clk,
  input rst,
  input [NUMWRPT-1:0] write,
  input [NUMWRPT*BITADDR-1:0] wr_adr,
  input [NUMRDPT-1:0] read,
  input [NUMRDPT*BITADDR-1:0] rd_adr,
  input [NUMWRPT-1:0] mem_write,
  input [NUMWRPT*BITSROW-1:0] mem_wr_adr,
  input [NUMRDPT-1:0] mem_read,
  input [NUMRDPT*BITSROW-1:0] mem_rd_adr
);

genvar wr_var;
generate for (wr_var=0; wr_var<NUMWRPT; wr_var=wr_var+1) begin: wr_loop
  wire write_wire = write >> wr_var;
  wire [BITADDR-1:0] wr_adr_wire = wr_adr >> (wr_var*BITADDR);

  assert_wr_range_check: assume property (@(posedge clk) disable iff (rst) write_wire |-> (wr_adr_wire < NUMADDR));
end
endgenerate

genvar rd_var;
generate for (rd_var=0; rd_var<NUMWRPT; rd_var=rd_var+1) begin: rd_loop
  wire read_wire = read >> rd_var;
  wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (rd_var*BITADDR);

  assert_rd_range_check: assume property (@(posedge clk) disable iff (rst) read_wire |-> (rd_adr_wire < NUMADDR));
end
endgenerate

genvar mwr_var;
generate for (mwr_var=0; mwr_var<NUMWRPT; mwr_var=mwr_var+1) begin: mwr_loop
  wire mem_write_wire = mem_write >> mwr_var;
  wire [BITSROW-1:0] mem_wr_adr_wire = mem_wr_adr >> (mwr_var*BITSROW);

  assert_mem_wr_range_check: assume property (@(posedge clk) disable iff (rst) mem_write_wire |-> (mem_wr_adr_wire < NUMSROW));
end
endgenerate

genvar mrd_var;
generate for (mrd_var=0; mrd_var<NUMRDPT; mrd_var=mrd_var+1) begin: mrd_loop
  wire mem_read_wire = mem_read >> mrd_var;
  wire [BITSROW-1:0] mem_rd_adr_wire = mem_rd_adr >> (mrd_var*BITSROW);

  assert_mem_rd_range_check: assume property (@(posedge clk) disable iff (rst) mem_read_wire |-> (mem_rd_adr_wire < NUMSROW));
end
endgenerate

endmodule


module ip_top_sva_align_ecc_mrnw
  #(
parameter     WIDTH   = 32,
parameter     ENAPSDO = 0,
parameter     ENAPAR  = 0,
parameter     ENAECC  = 0,
parameter     ENADEC  = 0,
parameter     ECCWDTH = 7,
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMRDPT = 2,
parameter     NUMWRPT = 2,
parameter     NUMWRDS = 4,
parameter     BITWRDS = 2,
parameter     NUMSROW = 256,
parameter     BITSROW = 8,
parameter     SRAM_DELAY = 2,
parameter     FLOPGEN = 0,
parameter     FLOPMEM = 0,
parameter     FLOPOUT = 0,
parameter     RSTZERO = 0,
parameter     ENAPADR = 0,
parameter     BITPADR = 10,
parameter     MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENADEC ? 2*WIDTH+ECCWDTH : WIDTH
   )
(
  input clk,
  input rst,
  input [NUMWRPT-1:0] write,
  input [NUMWRPT*BITADDR-1:0] wr_adr,
  input [NUMWRPT*WIDTH-1:0] din,
  input [NUMRDPT-1:0] read,
  input [NUMRDPT*BITADDR-1:0] rd_adr,
  input [NUMRDPT*WIDTH-1:0] rd_dout,
  input [NUMRDPT-1:0] rd_fwrd,
  input [NUMRDPT-1:0] rd_serr,
  input [NUMRDPT-1:0] rd_derr,
  input [NUMRDPT*BITPADR-1:0] rd_padr,
  input [NUMWRPT-1:0] mem_write,
  input [NUMWRPT*BITSROW-1:0] mem_wr_adr,
  input [NUMWRPT*NUMWRDS*MEMWDTH-1:0] mem_bw,
  input [NUMWRPT*NUMWRDS*MEMWDTH-1:0] mem_din,
  input [NUMRDPT-1:0] mem_read,
  input [NUMRDPT*BITSROW-1:0] mem_rd_adr,
  input [NUMRDPT-1:0] mem_rd_fwrd,
  input [NUMRDPT*NUMWRDS*MEMWDTH-1:0] mem_rd_dout,
  input [NUMRDPT*(BITPADR-BITWRDS)-1:0] mem_rd_padr,
  input [BITADDR-1:0] select_addr
);

wire [BITWRDS-1:0] select_word;
wire [BITSROW-1:0] select_srow;
generate if (BITWRDS>0) begin: np2_loop
  np2_addr #(
    .NUMADDR (NUMADDR), .BITADDR (BITADDR),
    .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
    .NUMVROW (NUMSROW), .BITVROW (BITSROW))
    sel_adr (.vbadr(select_word), .vradr(select_srow), .vaddr(select_addr));
  end else begin: no_np2_loop
    assign select_word = 0;
    assign select_srow = select_addr;
  end
endgenerate

reg write_wire [0:NUMWRPT-1];
reg [BITADDR-1:0] wr_adr_wire [0:NUMWRPT-1];
reg [WIDTH-1:0] din_wire [0:NUMWRPT-1];
reg mem_write_wire [0:NUMWRPT-1];
reg [BITSROW-1:0] mem_wr_adr_wire [0:NUMWRPT-1];
reg [NUMWRDS*MEMWDTH-1:0] mem_bw_wire [0:NUMWRPT-1];
reg [MEMWDTH-1:0] mem_bw_sel_wire [0:NUMWRPT-1];
reg [NUMWRDS*MEMWDTH-1:0] mem_din_wire [0:NUMWRPT-1];
integer wpt_int;
always_comb
  for (wpt_int=0; wpt_int<NUMWRPT; wpt_int=wpt_int+1) begin
    write_wire[wpt_int] = write >> wpt_int;
    wr_adr_wire[wpt_int] = wr_adr >> (wpt_int*BITADDR);
    din_wire[wpt_int] = din >> (wpt_int*WIDTH);
    mem_write_wire[wpt_int] = mem_write >> wpt_int;
    mem_wr_adr_wire[wpt_int] = mem_wr_adr >> (wpt_int*BITSROW);
    mem_bw_wire[wpt_int] = mem_bw >> (wpt_int*NUMWRDS*MEMWDTH);
    mem_bw_sel_wire[wpt_int] = mem_bw_wire[wpt_int] >> (select_word*MEMWDTH);
    mem_din_wire[wpt_int] = mem_din >> (wpt_int*NUMWRDS*MEMWDTH);
  end

reg write_reg [0:NUMWRPT-1];
reg [BITADDR-1:0] wr_adr_reg [0:NUMWRPT-1];
integer wreg_int;
always @(posedge clk)
  for (wreg_int=0; wreg_int<NUMWRPT; wreg_int=wreg_int+1) begin
    write_reg[wreg_int] <= write_wire[wreg_int];
    wr_adr_reg[wreg_int] <= wr_adr_wire[wreg_int];
  end

reg read_wire [0:NUMRDPT-1];
reg [BITADDR-1:0] rd_adr_wire [0:NUMRDPT-1];
reg [WIDTH-1:0] rd_dout_wire [0:NUMRDPT-1];
reg rd_fwrd_wire [0:NUMRDPT-1];
reg rd_serr_wire [0:NUMRDPT-1];
reg rd_derr_wire [0:NUMRDPT-1];
reg [BITPADR-1:0] rd_padr_wire [0:NUMRDPT-1];
reg mem_read_wire [0:NUMRDPT-1];
reg [BITSROW-1:0] mem_rd_adr_wire [0:NUMRDPT-1];
reg mem_rd_fwrd_wire [0:NUMRDPT-1];
reg [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_wire [0:NUMRDPT-1];
reg [BITPADR-BITWRDS-1:0] mem_rd_padr_wire [0:NUMRDPT-1];
integer rpt_int;
always_comb
  for (rpt_int=0; rpt_int<NUMRDPT; rpt_int=rpt_int+1) begin
    read_wire[rpt_int] = read >> rpt_int;
    rd_adr_wire[rpt_int] = rd_adr >> (rpt_int*BITADDR);
    rd_dout_wire[rpt_int] = rd_dout >> (rpt_int*WIDTH);
    rd_fwrd_wire[rpt_int] = rd_fwrd >> rpt_int;
    rd_serr_wire[rpt_int] = rd_serr >> rpt_int;
    rd_derr_wire[rpt_int] = rd_derr >> rpt_int;
    rd_padr_wire[rpt_int] = rd_padr >> (rpt_int*BITPADR);
    mem_read_wire[rpt_int] = mem_read >> rpt_int;
    mem_rd_adr_wire[rpt_int] = mem_rd_adr >> (rpt_int*BITSROW);
    mem_rd_fwrd_wire[rpt_int] = mem_rd_fwrd >> rpt_int;
    mem_rd_dout_wire[rpt_int] = mem_rd_dout >> (rpt_int*NUMWRDS*MEMWDTH);
    mem_rd_padr_wire[rpt_int] = mem_rd_padr >> (rpt_int*(BITPADR-BITWRDS));
  end

reg fwd_rd [0:NUMRDPT-1];
integer fwdr_int, fwdw_int;
always_comb
  for (fwdr_int=0; fwdr_int<NUMRDPT; fwdr_int=fwdr_int+1) begin
    fwd_rd[fwdr_int] = 0;
    for (fwdw_int=0; fwdw_int<NUMWRPT; fwdw_int=fwdw_int+1)
      if (FLOPGEN && read_wire[fwdr_int] && write_reg[fwdw_int] && (rd_adr_wire[fwdr_int] == wr_adr_reg[fwdw_int])) begin
        fwd_rd[fwdr_int] = 1'b1;
      end  
  end
/*
wire read_wire_0 = read_wire[0];
wire read_wire_1 = read_wire[1];
wire [BITADDR-1:0] rd_adr_wire_0 = rd_adr_wire[0];
wire [BITADDR-1:0] rd_adr_wire_1 = rd_adr_wire[1];
wire rd_serr_wire_0 = rd_serr_wire[0];
wire rd_serr_wire_1 = rd_serr_wire[1];
wire [WIDTH-1:0] rd_dout_wire_0 = rd_dout_wire[0];
wire [WIDTH-1:0] rd_dout_wire_1 = rd_dout_wire[1];
*/
reg meminv;
reg [MEMWDTH-1:0] mem;
reg meminv_next;
reg [MEMWDTH-1:0] mem_next;
integer mem_int;
always_comb begin
  meminv_next = meminv;
  mem_next = mem;
  if (rst) begin
    meminv_next = 1'b1;
    mem_next = RSTZERO ? 0 : 'hx;
  end else for (mem_int=0; mem_int<NUMWRPT; mem_int=mem_int+1)
    if (mem_write_wire[mem_int] && (mem_wr_adr_wire[mem_int] == select_srow)) begin
      meminv_next = meminv_next && !(|mem_bw_sel_wire[mem_int]);
      mem_next = ((mem_din_wire[mem_int] & mem_bw_wire[mem_int]) >> select_word*MEMWDTH) | (mem_next & ~(mem_bw_wire[mem_int] >> select_word*MEMWDTH));
    end
end
  
always @(posedge clk) begin
  meminv <= meminv_next;
  mem <= mem_next;
end

wire mem_serr [0:NUMRDPT-1];
wire mem_derr [0:NUMRDPT-1];
wire mem_nerr [0:NUMRDPT-1];
wire [MEMWDTH-1:0] dout_mask [0:NUMRDPT-1];
genvar err_var;
generate for (err_var=0; err_var<NUMRDPT; err_var=err_var+1) begin: err_loop
  assign mem_serr[err_var] = 0;
  assign mem_derr[err_var] = 0;
  assign mem_nerr[err_var] = !mem_serr[err_var] && !mem_derr[err_var];

  wire dout_bit1_err = 0;
  wire dout_bit2_err = 0;
  wire [15:0] dout_bit1_pos = 0;
  wire [15:0] dout_bit2_pos = 0;
  wire [MEMWDTH-1:0] dout_bit1_mask = (ENAPAR || ENAECC || ENADEC) ? dout_bit1_err << dout_bit1_pos : 0;
  wire [MEMWDTH-1:0] dout_bit2_mask = (ENAECC || ENADEC) ? dout_bit2_err << dout_bit2_pos : 0;
  assign dout_mask[err_var] = dout_bit1_mask ^ dout_bit2_mask;
  wire dout_serr = |dout_mask[err_var] && (|dout_bit1_mask ^ |dout_bit2_mask);
  wire dout_derr = |dout_mask[err_var] && |dout_bit1_mask && |dout_bit2_mask;

  assume_mem_nerr_check: assert property (@(posedge clk) disable iff (rst) mem_nerr[err_var] |-> ##(SRAM_DELAY+FLOPMEM) !dout_serr && !dout_derr);
  assume_mem_serr_check: assert property (@(posedge clk) disable iff (rst) mem_serr[err_var] |-> ##(SRAM_DELAY+FLOPMEM) dout_serr);
  assume_mem_derr_check: assert property (@(posedge clk) disable iff (rst) mem_derr[err_var] |-> ##(SRAM_DELAY+FLOPMEM) dout_derr);

end
endgenerate

genvar mem_var;
generate for (mem_var=0; mem_var<NUMRDPT; mem_var=mem_var+1) begin: rd_loop
  wire [MEMWDTH-1:0] mem_dout_wire = mem_rd_dout_wire[mem_var] >> select_word*MEMWDTH;
  wire [MEMWDTH-1:0] dout_mask_wire = mem_rd_fwrd_wire[mem_var] ? 0 : dout_mask[mem_var];

  assert_mem_check: assert property (@(posedge clk) disable iff (rst) (mem_read_wire[mem_var] && (mem_rd_adr_wire[mem_var] == select_srow)) |-> ##SRAM_DELAY
                                     ($past(!RSTZERO && meminv,SRAM_DELAY) || (mem_dout_wire == ($past(mem,SRAM_DELAY) ^ dout_mask_wire))));
end
endgenerate

wire [ECCWDTH-1:0] din_ecc;
generate if (ENAECC || ENADEC) begin: decc_loop
  ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
    ecc_calc_inst (.din(mem[WIDTH-1:0]), .eccout(din_ecc));
end
endgenerate

assert_mem_chk_check: assert property (@(posedge clk) disable iff (rst) ((!RSTZERO && meminv) ||
                                                                         (ENAPAR ? !(^mem) :
                                                                          ENAECC ? ({din_ecc,mem[WIDTH-1:0]}==mem) :
                                                                          ENADEC ? ({mem[WIDTH-1:0],din_ecc,mem[WIDTH-1:0]}==mem) : 1'b1)));

reg fakememinv;
reg [WIDTH-1:0] fakemem;
reg fakememinv_next;
reg [WIDTH-1:0] fakemem_next;
integer fake_int;
always_comb begin
  fakememinv_next = fakememinv;
  fakemem_next = fakemem;
  if (rst) begin
    fakememinv_next = 1'b1;
    fakemem_next = RSTZERO ? 0 : 'hx;
  end else for (fake_int=0; fake_int<NUMWRPT; fake_int=fake_int+1)
    if (write_wire[fake_int] && (wr_adr_wire[fake_int] == select_addr)) begin
      fakememinv_next = 1'b0;
      fakemem_next = din_wire[fake_int];
    end
end

always @(posedge clk) begin
  fakememinv <= fakememinv_next;
  fakemem <= fakemem_next;
end

genvar dout_var;
generate for (dout_var=0; dout_var<NUMRDPT; dout_var=dout_var+1) begin: dout_loop
  assert_dout_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr) && mem_nerr[dout_var]) |-> ##(SRAM_DELAY+FLOPMEM+FLOPOUT)
                                           ($past(!RSTZERO && fakememinv,SRAM_DELAY+FLOPMEM+FLOPOUT) ||
                                            (($past(!RSTZERO && meminv,SRAM_DELAY+FLOPMEM+FLOPOUT) ||
                                              rd_fwrd_wire[dout_var] || (!rd_serr_wire[dout_var] && !rd_derr_wire[dout_var])) &&
                                             (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT)))));
  assert_dout_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr) && mem_serr[dout_var]) |-> ##(SRAM_DELAY+FLOPMEM+FLOPOUT)
                                           ($past(!RSTZERO && fakememinv,SRAM_DELAY+FLOPMEM+FLOPOUT) ||
                                            ($past(!RSTZERO && meminv,SRAM_DELAY+FLOPMEM+FLOPOUT) ?
                                             (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT)) :
                                             (ENAPAR ? ((rd_serr_wire[dout_var] && !rd_derr_wire[dout_var]) ||
                                                        (FLOPOUT ? $past(mem_rd_fwrd_wire[dout_var]) : mem_rd_fwrd_wire[dout_var]) ||
                                                        (ENAPSDO && rd_fwrd_wire[dout_var] &&
                                                         !(FLOPOUT ? $past(mem_rd_fwrd_wire[dout_var]) : mem_rd_fwrd_wire[dout_var]))) &&
                                                       (!rd_fwrd_wire[dout_var] || (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT))) :
                                              ENAECC ? ((rd_serr_wire[dout_var] && !rd_derr_wire[dout_var]) ||
                                                        (FLOPOUT ? $past(mem_rd_fwrd_wire[dout_var]) : mem_rd_fwrd_wire[dout_var]) ||
                                                        (ENAPSDO && rd_fwrd_wire[dout_var] &&
                                                         !(FLOPOUT ? $past(mem_rd_fwrd_wire[dout_var]) : mem_rd_fwrd_wire[dout_var]))) &&
                                                        (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT)) :
                                              ENADEC ? ((rd_serr_wire[dout_var] && !rd_derr_wire[dout_var]) ||
                                                        (FLOPOUT ? $past(mem_rd_fwrd_wire[dout_var]) : mem_rd_fwrd_wire[dout_var]) ||
                                                        (ENAPSDO && rd_fwrd_wire[dout_var] &&
                                                         !(FLOPOUT ? $past(mem_rd_fwrd_wire[dout_var]) : mem_rd_fwrd_wire[dout_var]))) &&
                                                        (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT)) :
                                                       !rd_serr_wire[dout_var] && !rd_derr_wire[dout_var] &&
                                                       (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT))))));
  assert_dout_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr) && mem_derr[dout_var]) |-> ##(SRAM_DELAY+FLOPMEM+FLOPOUT)
                                           ($past(!RSTZERO && fakememinv,SRAM_DELAY+FLOPMEM+FLOPOUT) ||
                                            ($past(!RSTZERO && meminv,SRAM_DELAY+FLOPMEM+FLOPOUT) ?
                                             (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT)) :
                                             (ENAPAR ? ((!rd_serr_wire[dout_var] && !rd_derr_wire[dout_var]) ||
                                                        (FLOPOUT ? $past(mem_rd_fwrd_wire[dout_var]) : mem_rd_fwrd_wire[dout_var]) ||
                                                        (ENAPSDO && rd_fwrd_wire[dout_var] &&
                                                         !(FLOPOUT ? $past(mem_rd_fwrd_wire[dout_var]) : mem_rd_fwrd_wire[dout_var]))) &&
                                                       (!rd_fwrd_wire[dout_var] || (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT))) :
                                              ENAECC ? ((!rd_serr_wire[dout_var] && rd_derr_wire[dout_var]) ||
                                                        (FLOPOUT ? $past(mem_rd_fwrd_wire[dout_var]) : mem_rd_fwrd_wire[dout_var]) ||
                                                        (ENAPSDO && rd_fwrd_wire[dout_var] &&
                                                         !(FLOPOUT ? $past(mem_rd_fwrd_wire[dout_var]) : mem_rd_fwrd_wire[dout_var]))) &&
                                                       (!rd_fwrd_wire[dout_var] || (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT))) :
                                              ENADEC ? ((!rd_serr_wire[dout_var] && rd_derr_wire[dout_var]) ||
                                                        (FLOPOUT ? $past(mem_rd_fwrd_wire[dout_var]) : mem_rd_fwrd_wire[dout_var]) ||
                                                        (ENAPSDO && rd_fwrd_wire[dout_var] &&
                                                         !(FLOPOUT ? $past(mem_rd_fwrd_wire[dout_var]) : mem_rd_fwrd_wire[dout_var]))) &&
                                                        (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT)) :
                                                       !rd_serr_wire[dout_var] && !rd_derr_wire[dout_var] &&
                                                       (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT))))));
  assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var]==select_addr)) |-> ##(SRAM_DELAY+FLOPMEM+FLOPOUT)
                                      ($past(fakememinv,SRAM_DELAY+FLOPMEM+FLOPOUT) ||
                                       (rd_fwrd_wire[dout_var] == ((FLOPOUT ? $past(mem_rd_fwrd_wire[dout_var]) : mem_rd_fwrd_wire[dout_var]) ||
                                                                   $past(fwd_rd[dout_var],SRAM_DELAY+FLOPMEM+FLOPOUT)))));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var]==select_addr)) |-> ##(SRAM_DELAY+FLOPMEM+FLOPOUT)
                                      ((NUMWRDS>1) ? (rd_padr_wire[dout_var] == (ENAPADR ? {select_word,(FLOPOUT ? $past(mem_rd_padr_wire[dout_var]) : mem_rd_padr_wire[dout_var])} : {select_word,select_srow})) :
                                                     (rd_padr_wire[dout_var] == (ENAPADR ? (FLOPOUT ? $past(mem_rd_padr_wire[dout_var]) : mem_rd_padr_wire[dout_var]) : select_word)))); 

end
endgenerate

endmodule
