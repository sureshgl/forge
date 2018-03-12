module ip_top_sva_2_nrw_1r1w
  #(
parameter     WIDTH   = 32,
parameter     NUMRWPT = 2,
parameter     NUMPBNK = 4,
parameter     BITPBNK = 2,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13
   )
(
  input                       clk,
  input                       rst,
  input [NUMRWPT-1:0]         read,
  input [NUMRWPT-1:0]         write,
  input [NUMRWPT*BITADDR-1:0]         addr,
  input [NUMPBNK-1:0]         t1_writeA,
  input [NUMPBNK*BITADDR-1:0] t1_addrA,
  input [NUMPBNK-1:0]         t1_readB,
  input [NUMPBNK*BITADDR-1:0] t1_addrB
);

genvar rw_int;
generate for (rw_int=0; rw_int<NUMRWPT; rw_int=rw_int+1) begin: rw_loop
  wire read_wire = read >> rw_int;
  wire write_wire = write >> rw_int;
  wire [BITADDR-1:0] rw_adr_wire = addr >> (rw_int*BITADDR);

  assert_rw_check: assume property (@(posedge clk) disable iff (rst) !(read_wire && write_wire));
  assert_rw_range_check: assert property (@(posedge clk) disable iff (rst) (read_wire || write_wire) |-> (rw_adr_wire < NUMADDR));
end
endgenerate

genvar t1_int;
generate for (t1_int=0; t1_int<NUMPBNK; t1_int=t1_int+1) begin: t1_loop
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITADDR-1:0] t1_addrA_wire = t1_addrA >> (t1_int*BITADDR);

  assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMADDR));

  wire t1_readB_wire = t1_readB >> t1_int;
  wire [BITADDR-1:0] t1_addrB_wire = t1_addrB >> (t1_int*BITADDR);

  assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMADDR));
end
endgenerate

endmodule // ip_top_sva_2_nrw_1r1w

module ip_top_sva_nrw_1r1w
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMRWPT = 2,
parameter     NUMPBNK = 4,
parameter     BITPBNK = 1,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     BITPADR = 14,
parameter     SRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0
   )
(
  input                                 clk,
  input                                 rst,
  input                                 ready,
  input [NUMRWPT-1:0]                   read,
  input [NUMRWPT-1:0]                   write,
  input [NUMRWPT*BITADDR-1:0]           addr,
  input [NUMRWPT*WIDTH-1:0]             din,
  input [NUMRWPT-1:0]                   rd_vld,
  input [NUMRWPT*WIDTH-1:0]             rd_dout,
  input [NUMRWPT-1:0]                   rd_fwrd,
  input [NUMRWPT-1:0]                   rd_serr,
  input [NUMRWPT-1:0]                   rd_derr,
  input [NUMRWPT*BITPADR-1:0]           rd_padr,
  input [NUMPBNK-1:0]                   t1_writeA,
  input [NUMPBNK*BITADDR-1:0]           t1_addrA,
  input [NUMPBNK*WIDTH-1:0]             t1_dinA,
  input [NUMPBNK-1:0]                   t1_readB,
  input [NUMPBNK*BITADDR-1:0]           t1_addrB,
  input [NUMPBNK*WIDTH-1:0]             t1_doutB,
  input [NUMPBNK-1:0]                   t1_fwrdB,
  input [NUMPBNK-1:0]                   t1_serrB,
  input [NUMPBNK-1:0]                   t1_derrB,
  input [NUMPBNK*(BITPADR-BITPBNK)-1:0] t1_padrB,
  input [BITADDR-1:0]                   select_addr,
  input [BITWDTH-1:0]                   select_bit
);

  wire                                  read_wire [0:NUMRWPT-1];
  wire                                  write_wire [0:NUMRWPT-1];
  wire [BITADDR-1:0]                    addr_wire [0:NUMRWPT-1];
  wire [WIDTH-1:0]                      din_wire [0:NUMRWPT-1];
  wire                                  rd_vld_wire [0:NUMRWPT-1];
  wire [WIDTH-1:0]                      rd_dout_wire [0:NUMRWPT-1];
  wire                                  rd_fwrd_wire [0:NUMRWPT-1];
  wire                                  rd_serr_wire [0:NUMRWPT-1];
  wire                                  rd_derr_wire [0:NUMRWPT-1];
  wire [BITPADR-1:0]                    rd_padr_wire [0:NUMRWPT-1];
  genvar                                rw_int;
  generate for (rw_int=0; rw_int<NUMRWPT; rw_int=rw_int+1) begin: ct_loop
    assign read_wire[rw_int] = read >> rw_int;
    assign write_wire[rw_int] = write >> rw_int;
    assign addr_wire[rw_int] = addr >> (rw_int*BITADDR);
    assign din_wire[rw_int] = din >> (rw_int*WIDTH);
    assign rd_vld_wire[rw_int] = rd_vld >> rw_int;
    assign rd_dout_wire[rw_int] = rd_dout >> (rw_int*WIDTH);
    assign rd_fwrd_wire[rw_int] = rd_fwrd >> rw_int;
    assign rd_serr_wire[rw_int] = rd_serr >> rw_int;
    assign rd_derr_wire[rw_int] = rd_derr >> rw_int;
    assign rd_padr_wire[rw_int] = rd_padr >> (rw_int*BITPADR);
  end
  endgenerate

  reg               t1_writeA_wire  [0:NUMRWPT-1][0:NUMRWPT-1];
  reg [BITADDR-1:0] t1_addrA_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  reg [WIDTH-1:0]   t1_dinA_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  reg               t1_readB_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  reg [BITADDR-1:0] t1_addrB_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  reg [WIDTH-1:0]   t1_doutB_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  reg               t1_serrB_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  reg               t1_derrB_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  reg [BITPADR-BITPBNK-1:0] t1_padrB_wire [0:NUMRWPT-1][0:NUMRWPT-1];
  integer                   t1_prpp_int, t1_prpb_int;
  always_comb
    for (t1_prpp_int=0; t1_prpp_int<NUMRWPT; t1_prpp_int=t1_prpp_int+1) begin
      for (t1_prpb_int=0; t1_prpb_int<NUMRWPT; t1_prpb_int=t1_prpb_int+1) begin
        t1_writeA_wire[t1_prpp_int][t1_prpb_int] = t1_writeA >> (t1_prpb_int*NUMRWPT+t1_prpp_int);
        t1_addrA_wire[t1_prpp_int][t1_prpb_int]  = t1_addrA >> ((t1_prpb_int*NUMRWPT+t1_prpp_int)*BITADDR);
        t1_dinA_wire[t1_prpp_int][t1_prpb_int]   = t1_dinA >> ((t1_prpb_int*NUMRWPT+t1_prpp_int)*WIDTH);
        t1_readB_wire[t1_prpp_int][t1_prpb_int]  = t1_readB >> (t1_prpb_int*NUMRWPT+t1_prpp_int);
        t1_addrB_wire[t1_prpp_int][t1_prpb_int]  = t1_addrB >> ((t1_prpb_int*NUMRWPT+t1_prpp_int)*BITADDR);
        t1_doutB_wire[t1_prpp_int][t1_prpb_int]  = t1_doutB >> ((t1_prpb_int*NUMRWPT+t1_prpp_int)*WIDTH);
        t1_serrB_wire[t1_prpp_int][t1_prpb_int]  = t1_serrB >> (t1_prpb_int*NUMRWPT+t1_prpp_int);
        t1_derrB_wire[t1_prpp_int][t1_prpb_int]  = t1_derrB >> (t1_prpb_int*NUMRWPT+t1_prpp_int);
        t1_padrB_wire[t1_prpp_int][t1_prpb_int]  = t1_padrB >> ((t1_prpb_int*NUMRWPT+t1_prpp_int)*(BITPADR-BITPBNK));
      end
    end

  reg meminv [0:NUMRWPT-1];
  reg [WIDTH-1:0] mem [0:NUMRWPT-1];
  integer         mem_int;
  always @(posedge clk)
    for (mem_int=0; mem_int<NUMRWPT; mem_int=mem_int+1)
      if (rst) begin
        meminv[mem_int] <= 1'b0;
        mem[mem_int] <= 0;
      end else if (t1_writeA_wire[0][mem_int] && (t1_addrA_wire[0][mem_int] == select_addr)) begin
        meminv[mem_int] <= 1'b0;
        mem[mem_int] <= t1_dinA_wire[0][mem_int];
      end
  
  wire [WIDTH-1:0] mem_0 = mem[0];
  
  genvar           pdout_int, pdoutp_int;
  generate 
    for (pdout_int=0; pdout_int<NUMRWPT; pdout_int=pdout_int+1) begin : pdout_loop
      for (pdoutp_int=0; pdoutp_int<NUMRWPT; pdoutp_int=pdoutp_int+1) begin: pdoutp_loop
        
        assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[pdout_int][pdoutp_int] && (t1_addrB_wire[pdout_int][pdoutp_int] == select_addr)) |-> ##SRAM_DELAY
                                             ($past(meminv[pdoutp_int],SRAM_DELAY) || t1_derrB_wire[pdout_int][pdoutp_int] || (t1_doutB_wire[pdout_int][pdoutp_int] == $past(mem[pdoutp_int],SRAM_DELAY))));
      end
    end
  endgenerate
  
  genvar data_int, datap_int;
  generate 
    for (data_int=0; data_int<NUMRWPT; data_int=data_int+1) begin: data_loop
      for (datap_int=0; datap_int<NUMRWPT; datap_int=datap_int+1) begin: datap_loop
        assert_data_fwd_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[data_int][datap_int] && (t1_addrB_wire[data_int][datap_int] == select_addr)) |-> ##SRAM_DELAY
                                                (meminv[datap_int] || t1_derrB_wire[data_int][datap_int] || (core.data_out[data_int][datap_int] == mem[datap_int])));
      end
    end
    endgenerate

  wire data_derr [0:NUMRWPT-1][0:NUMRWPT-1];
  genvar             derr_int, derrp_int;
  generate
    for (derr_int=0; derr_int<NUMRWPT; derr_int=derr_int+1) begin: derr_loop
      for (derrp_int=0; derrp_int<NUMRWPT; derrp_int=derrp_int+1) begin: derrp_loop
        assign data_derr[derr_int][derrp_int] = 0;
        assume_data_derr_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire[derr_int][derrp_int] |-> ##SRAM_DELAY
                                                ($past(data_derr[derr_int][derrp_int],SRAM_DELAY) == t1_derrB_wire[derr_int][derrp_int]));
      end
    end
  endgenerate

  reg fakememinv;
  reg [WIDTH-1:0] fakemem;
  integer         fake_int;
  always @(posedge clk)
    if (rst) begin
      fakememinv <= 1'b0;
      fakemem <= 0;
    end else for (fake_int=0; fake_int<NUMRWPT; fake_int=fake_int+1)
      if (write_wire[fake_int] && (addr_wire[fake_int]==select_addr)) begin
        fakememinv <= 1'b0;
        fakemem <= din_wire[fake_int];
      end
  
  reg [WIDTH-1:0] mem_wire;
  integer         comb_int;
  always_comb begin
    mem_wire = 0;
    for (comb_int=0; comb_int<NUMRWPT; comb_int=comb_int+1)
      mem_wire = mem_wire ^ mem[comb_int];
  end
  
  assert_fakemem_check: assert property (@(posedge clk) disable iff (rst || !ready) 1'b1 |-> ##(FLOPIN+SRAM_DELAY)
                                         ($past(fakememinv,FLOPIN+SRAM_DELAY) || ($past(fakemem,FLOPIN+SRAM_DELAY) == mem_wire)));
  
  genvar dout_var;
  generate for (dout_var=0; dout_var<NUMRWPT; dout_var=dout_var+1) begin: cto_loop
    assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                        (rd_vld_wire[dout_var] && ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) || rd_derr_wire[dout_var] ||
                                                                   (rd_dout_wire[dout_var] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)))));

    reg [BITPBNK-1:0]         pbnk_tmp;
    reg [BITPADR-BITPBNK-1:0] padr_tmp;
    reg                       serr_tmp;
    reg                       derr_tmp;
    integer                   padr_int;
    always_comb begin
      serr_tmp = 0;
      derr_tmp = 0;
      pbnk_tmp = 0;
      padr_tmp = t1_padrB_wire[dout_var][0];
      for (padr_int=NUMRWPT-1; padr_int>=0; padr_int=padr_int-1) begin
        if (t1_serrB_wire[dout_var][padr_int] && !derr_tmp) begin
          serr_tmp = 1'b1;
          pbnk_tmp = padr_int;
          padr_tmp = t1_padrB_wire[dout_var][padr_int];
        end
        if (t1_derrB_wire[dout_var][padr_int]) begin
          derr_tmp = 1'b1;
          pbnk_tmp = padr_int;
          padr_tmp = t1_padrB_wire[dout_var][padr_int];
        end
      end
    end

    if (FLOPOUT) begin: eflp_loop
      assert_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                          (rd_serr_wire[dout_var] == $past(serr_tmp,FLOPOUT)));
      assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                          (rd_derr_wire[dout_var] == $past(derr_tmp,FLOPOUT)));
      assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                          (rd_padr_wire[dout_var] == $past({pbnk_tmp,padr_tmp},FLOPOUT)));
    end else begin: neflp_loop
      assert_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                          (rd_serr_wire[dout_var] == serr_tmp));
      assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                          (rd_derr_wire[dout_var] == derr_tmp));
      assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                          (rd_padr_wire[dout_var] == {pbnk_tmp,padr_tmp}));
    end
  end
  endgenerate
  
endmodule // ip_top_sva_nrw_1r1w
