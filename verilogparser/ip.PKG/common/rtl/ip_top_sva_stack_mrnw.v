module ip_top_sva_2_stack_mrnw
  #(
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMRDPT = 2,
parameter     NUMWRPT = 2,
parameter     NUMWBNK = 4,
parameter     BITWBNK = 2,
parameter     NUMWROW = 256,
parameter     BITWROW = 8)
(
  input clk,
  input rst,
  input [NUMWRPT-1:0] write,
  input [NUMWRPT*BITADDR-1:0] wr_adr,
  input [NUMRDPT-1:0] read,
  input [NUMRDPT*BITADDR-1:0] rd_adr,
  input [NUMWRPT*NUMWBNK-1:0] mem_write,
  input [NUMWRPT*NUMWBNK*BITWROW-1:0] mem_wr_adr,
  input [NUMRDPT*NUMWBNK-1:0] mem_read,
  input [NUMRDPT*NUMWBNK*BITWROW-1:0] mem_rd_adr
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

genvar mwp_var, mwb_var, mws_var;
generate
  for (mwb_var=0; mwb_var<NUMWBNK; mwb_var=mwb_var+1) begin: mwb_loop
    for (mwp_var=0; mwp_var<NUMWRPT; mwp_var=mwp_var+1) begin: mwp_loop
      wire mem_write_wire = mem_write >> (mwb_var*NUMWRPT+mwp_var);
      wire [BITWROW-1:0] mem_wr_adr_wire = mem_wr_adr >> ((mwb_var*NUMWRPT+mwp_var)*BITWROW);

      assert_mem_wr_range_check: assert property (@(posedge clk) disable iff (rst) mem_write_wire |-> (mem_wr_adr_wire < NUMWROW));

      for (mws_var=0; mws_var<NUMWRPT; mws_var=mws_var+1) begin: psdwr_loop
        wire mem_write_psd_wire = mem_write >> (mwb_var*NUMWRPT+mws_var);
        wire [BITWROW-1:0] mem_wr_adr_psd_wire = mem_wr_adr >> ((mwb_var*NUMWRPT+mws_var)*BITWROW);

        assert_mem_wr_pseudo_check: assert property (@(posedge clk) disable iff (rst) (mem_write_wire && mem_write_psd_wire) |->
                                                     (mws_var==mwp_var) || (mem_wr_adr_wire != mem_wr_adr_psd_wire));
      end
//      for (mws_var=0; mws_var<NUMRDPT; mws_var=mws_var+1) begin: psdrd_loop
//        wire mem_read_psd_wire = mem_read >> (mwb_var*NUMRDPT+mws_var);
//        wire [BITWROW-1:0] mem_rd_adr_psd_wire = mem_rd_adr >> ((mwb_var*NUMRDPT+mws_var)*BITWROW);
//
//        assert_mem_rd_pseudo_check: assume property (@(posedge clk) disable iff (rst) (mem_write_wire && mem_read_psd_wire) |->
//                                                     (mem_wr_adr_wire != mem_rd_adr_psd_wire));
//      end
    end
  end
endgenerate

genvar mrp_var, mrb_var, mrs_var;
generate
  for (mrb_var=0; mrb_var<NUMWBNK; mrb_var=mrb_var+1) begin: mrb_loop
    for (mrp_var=0; mrp_var<NUMRDPT; mrp_var=mrp_var+1) begin: mrp_loop
      wire mem_read_wire = mem_read >> (mrb_var*NUMRDPT+mrp_var);
      wire [BITWROW-1:0] mem_rd_adr_wire = mem_rd_adr >> ((mrb_var*NUMWRPT+mrp_var)*BITWROW);

      assert_mem_rd_range_check: assert property (@(posedge clk) disable iff (rst) mem_read_wire |-> (mem_rd_adr_wire < NUMWROW));

      for (mrs_var=0; mrs_var<NUMWRPT; mrs_var=mrs_var+1) begin: psdwr_loop
        wire mem_write_wire = mem_write >> (mrb_var*NUMWRPT+mrs_var);
        wire [BITWROW-1:0] mem_wr_adr_wire = mem_wr_adr >> ((mrb_var*NUMWRPT+mrs_var)*BITWROW);

        assert_mem_wr_pseudo_check: assert property (@(posedge clk) disable iff (rst) (mem_read_wire && mem_write_wire) |->
                                                     (mem_rd_adr_wire != mem_wr_adr_wire));
      end
    end
  end
endgenerate

endmodule


module ip_top_sva_stack_mrnw
  #(
parameter     WIDTH   = 32,
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMRDPT = 2,
parameter     NUMWRPT = 2,
parameter     NUMWBNK = 4,
parameter     BITWBNK = 2,
parameter     NUMWROW = 256,
parameter     BITWROW = 8,
parameter     BITPADR = 10,
parameter     SRAM_DELAY = 2,
parameter     FLOPCMD = 0,
parameter     FLOPMEM = 0,
parameter     FLOPOUT = 0,
parameter     RSTZERO = 0
   )
(
  input clk,
  input rst,
  input [NUMWRPT-1:0] write,
  input [NUMWRPT*BITADDR-1:0] wr_adr,
  input [NUMWRPT*WIDTH-1:0] bw,
  input [NUMWRPT*WIDTH-1:0] din,
  input [NUMRDPT-1:0] read,
  input [NUMRDPT*BITADDR-1:0] rd_adr,
  input [NUMRDPT*WIDTH-1:0] rd_dout,
  input [NUMRDPT-1:0] rd_fwrd,
  input [NUMRDPT-1:0] rd_serr,
  input [NUMRDPT-1:0] rd_derr,
  input [NUMRDPT*BITPADR-1:0] rd_padr,
  input [NUMWRPT*NUMWBNK-1:0] mem_write,
  input [NUMWRPT*NUMWBNK*BITWROW-1:0] mem_wr_adr,
  input [NUMWRPT*NUMWBNK*WIDTH-1:0] mem_bw,
  input [NUMWRPT*NUMWBNK*WIDTH-1:0] mem_din,
  input [NUMRDPT*NUMWBNK-1:0] mem_read,
  input [NUMRDPT*NUMWBNK*BITWROW-1:0] mem_rd_adr,
  input [NUMRDPT*NUMWBNK*WIDTH-1:0] mem_rd_dout,
  input [BITADDR-1:0] select_addr
);

wire [BITWBNK-1:0] select_bank;
wire [BITWROW-1:0] select_wrow;
generate if (BITWBNK>0) begin: np2_loop
  np2_addr #(
    .NUMADDR (NUMADDR), .BITADDR (BITADDR),
    .NUMVBNK (NUMWBNK), .BITVBNK (BITWBNK),
    .NUMVROW (NUMWROW), .BITVROW (BITWROW))
    sel_adr (.vbadr(select_bank), .vradr(select_wrow), .vaddr(select_addr));
  end else begin: no_np2_loop
    assign select_bank = 0;
    assign select_wrow = select_addr;
  end
endgenerate

reg write_wire [0:NUMWRPT-1];
reg [BITADDR-1:0] wr_adr_wire [0:NUMWRPT-1];
reg [WIDTH-1:0] bw_wire [0:NUMWRPT-1];
reg [WIDTH-1:0] din_wire [0:NUMWRPT-1];
reg read_wire [0:NUMRDPT-1];
reg [BITADDR-1:0] rd_adr_wire [0:NUMRDPT-1];
reg [WIDTH-1:0] rd_dout_wire [0:NUMRDPT-1];
reg rd_fwrd_wire [0:NUMRDPT-1];
reg rd_serr_wire [0:NUMRDPT-1];
reg rd_derr_wire [0:NUMRDPT-1];
reg [BITPADR-1:0] rd_padr_wire [0:NUMRDPT-1];
integer prt_int;
always_comb begin
  for (prt_int=0; prt_int<NUMWRPT; prt_int=prt_int+1) begin
    write_wire[prt_int] = write >> prt_int;
    wr_adr_wire[prt_int] = wr_adr >> (prt_int*BITADDR);
    bw_wire[prt_int] = bw >> (prt_int*WIDTH);
    din_wire[prt_int] = din >> (prt_int*WIDTH);
  end
  for (prt_int=0; prt_int<NUMRDPT; prt_int=prt_int+1) begin
    read_wire[prt_int] = read >> prt_int;
    rd_adr_wire[prt_int] = rd_adr >> (prt_int*BITADDR);
    rd_dout_wire[prt_int] = rd_dout >> (prt_int*WIDTH);
    rd_fwrd_wire[prt_int] = rd_fwrd >> prt_int;
    rd_serr_wire[prt_int] = rd_serr >> prt_int;
    rd_derr_wire[prt_int] = rd_derr >> prt_int;
    rd_padr_wire[prt_int] = rd_padr >> (prt_int*BITPADR);
  end
end

reg mem_write_sel_wire [0:NUMWRPT-1];
reg [BITWROW-1:0] mem_wr_adr_sel_wire [0:NUMWRPT-1];
reg [WIDTH-1:0] mem_bw_sel_wire [0:NUMWRPT-1];
reg [WIDTH-1:0] mem_din_sel_wire [0:NUMWRPT-1];
reg mem_read_sel_wire [0:NUMRDPT-1];
reg [BITWROW-1:0] mem_rd_adr_sel_wire [0:NUMRDPT-1];
reg [WIDTH-1:0] mem_rd_dout_sel_wire [0:NUMRDPT-1];
integer memw_int;
always_comb begin
  for (memw_int=0; memw_int<NUMWRPT; memw_int=memw_int+1) begin
    mem_write_sel_wire[memw_int] = mem_write >> (select_bank*NUMWRPT+memw_int);
    mem_wr_adr_sel_wire[memw_int] = mem_wr_adr >> ((select_bank*NUMWRPT+memw_int)*BITWROW);
    mem_bw_sel_wire[memw_int] = mem_bw >> ((select_bank*NUMWRPT+memw_int)*WIDTH);
    mem_din_sel_wire[memw_int] = mem_din >> ((select_bank*NUMWRPT+memw_int)*WIDTH);
  end
  for (memw_int=0; memw_int<NUMRDPT; memw_int=memw_int+1) begin
    mem_read_sel_wire[memw_int] = mem_read >> (select_bank*NUMRDPT+memw_int);
    mem_rd_adr_sel_wire[memw_int] = mem_rd_adr >> ((select_bank*NUMRDPT+memw_int)*BITWROW);
    mem_rd_dout_sel_wire[memw_int] = mem_rd_dout >> ((select_bank*NUMRDPT+memw_int)*WIDTH);
  end
end

reg meminv;
reg [WIDTH-1:0] mem;
reg meminv_next;
reg [WIDTH-1:0] mem_next;
integer mem_int;
always_comb begin
  meminv_next = meminv;
  mem_next = mem;
  if (rst) begin
    meminv_next = 1'b1;
    mem_next = RSTZERO ? 0 : 'hx;
  end else for (mem_int=0; mem_int<NUMWRPT; mem_int=mem_int+1)
    if (mem_write_sel_wire[mem_int] && (mem_wr_adr_sel_wire[mem_int] == select_wrow)) begin
      meminv_next = 1'b0;
      mem_next = ((mem_din_sel_wire[mem_int] & mem_bw_sel_wire[mem_int]) | (mem_next & ~mem_bw_sel_wire[mem_int]));
    end
end
  
always @(posedge clk) begin
  meminv <= meminv_next;
  mem <= mem_next;
end

genvar mem_var;
generate for (mem_var=0; mem_var<NUMRDPT; mem_var=mem_var+1) begin: rd_loop
  assert_mem_check: assert property (@(posedge clk) disable iff (rst) (mem_read_sel_wire[mem_var] && (mem_rd_adr_sel_wire[mem_var] == select_wrow)) |-> ##SRAM_DELAY
                                     ($past(!RSTZERO && meminv,SRAM_DELAY) || (mem_rd_dout_sel_wire[mem_var] == $past(mem,SRAM_DELAY))));
end
endgenerate

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
      fakemem_next = (din_wire[fake_int] & bw_wire[fake_int]) | (fakemem_next & ~bw_wire[fake_int]);
    end
end

always @(posedge clk) begin
  fakememinv <= fakememinv_next;
  fakemem <= fakemem_next;
end

genvar dout_var;
generate for (dout_var=0; dout_var<NUMRDPT; dout_var=dout_var+1) begin: dout_loop
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                      ($past(!RSTZERO && fakememinv,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT) ||
                                       (rd_dout_wire[dout_var] == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT))));
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var] == select_addr)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                      !rd_serr_wire[dout_var] && !rd_derr_wire[dout_var]);
  assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var]==select_addr)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                      (rd_fwrd_wire[dout_var] == $past(core.forward_read[dout_var],SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (rd_adr_wire[dout_var]==select_addr)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                      (rd_padr_wire[dout_var] == {select_bank,select_wrow}));

end
endgenerate

endmodule
