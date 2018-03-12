module ip_top_sva_2_nr1rw_1r1w
  #(parameter
     WIDTH = 8,
     NUMADDR = 8192,
     BITADDR = 13,
     NUMVRPT = 2,
     NUMPRPT = 1,
     NUMVROW = 1024,
     BITVROW = 10,
     NUMVBNK = 8,
     BITVBNK = 3)
(
  input clk,
  input rst,
  input ready,
  input [NUMVRPT-1:0] read,
  input [NUMVRPT*BITADDR-1:0] rd_adr,
  input write,
  input [BITADDR-1:0]  wr_adr,
  input [NUMPRPT*NUMVBNK-1:0] t1_writeA,
  input [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMPRPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMPRPT*NUMVBNK-1:0] t1_readB,
  input [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMPRPT-1:0] t2_writeA,
  input [NUMPRPT*BITVROW-1:0] t2_addrA,
  input [NUMPRPT*WIDTH-1:0] t2_dinA,
  input [NUMPRPT-1:0] t2_readB,
  input [NUMPRPT*BITVROW-1:0] t2_addrB
);

assert_rd_wr_check: assume property (@(posedge clk) disable iff (rst) !(write && read[NUMVRPT-1]));
assert_wr_range_check: assume property (@(posedge clk) disable iff (rst) write |-> (wr_adr < NUMADDR));
genvar rd_int;
generate for (rd_int=0; rd_int<NUMVRPT; rd_int=rd_int+1) begin: rd_loop
  wire read_wire = read >> rd_int;
  wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (rd_int*BITADDR);

  assert_rd_range_check: assume property (@(posedge clk) disable iff (rst) read_wire |-> (rd_adr_wire < NUMADDR));
end
endgenerate

genvar t1_vbnk_int, t1_prpt_int;
generate for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin: t1_vbnk_loop
  for (t1_prpt_int=0; t1_prpt_int<NUMPRPT; t1_prpt_int=t1_prpt_int+1) begin: t1_prpt_loop
    wire t1_writeA_wire = t1_writeA >> (NUMPRPT*t1_vbnk_int+t1_prpt_int);
    wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*BITVROW);
    wire [WIDTH-1:0] t1_dinA_wire = t1_dinA >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*WIDTH);

    wire t1_readB_wire = t1_readB >> (NUMPRPT*t1_vbnk_int+t1_prpt_int);
    wire [BITVROW-1:0] t1_addrB_wire = t1_addrB >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*BITVROW);

    wire t1_writeA_0_wire = t1_writeA >> (NUMPRPT*t1_vbnk_int);
    wire [BITVROW-1:0] t1_addrA_0_wire = t1_addrA >> (NUMPRPT*t1_vbnk_int*BITVROW);
    wire [WIDTH-1:0] t1_dinA_0_wire = t1_dinA >> (NUMPRPT*t1_vbnk_int*WIDTH);

    assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMVROW));
    assert_t1_rw_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVROW));
//    assert_t1_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire && t1_writeA_wire) |-> (t1_addrA_wire != t1_addrB_wire));
    assert_t1_wr_same_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |->
					      (t1_writeA_0_wire && (t1_addrA_0_wire == t1_addrA_wire) && (t1_dinA_0_wire == t1_dinA_wire))); 
  end
end
endgenerate

genvar t2_prpt_int;
generate for (t2_prpt_int=0; t2_prpt_int<NUMPRPT; t2_prpt_int=t2_prpt_int+1) begin: t2_prpt_loop
  wire t2_writeA_wire = t2_writeA >> t2_prpt_int;
  wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> (t2_prpt_int*BITVROW);
  wire [WIDTH-1:0] t2_dinA_wire = t2_dinA >> (t2_prpt_int*WIDTH);

  wire t2_readB_wire = t2_readB >> t2_prpt_int;
  wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2_prpt_int*BITVROW);

  wire t2_writeA_0_wire = t2_writeA;
  wire [BITVROW-1:0] t2_addrA_0_wire = t2_addrA;
  wire [WIDTH-1:0] t2_dinA_0_wire = t2_dinA;

  assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
  assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));
//  assert_t2_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire && t2_writeA_wire) |-> (t2_addrA_wire != t2_addrB_wire));
  assert_t2_wr_same_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |->
					    (t2_writeA_0_wire && (t2_addrA_0_wire == t2_addrA_wire) && (t2_dinA_0_wire == t2_dinA_wire))); 
end
endgenerate

endmodule


module ip_top_sva_nr1rw_1r1w
  #(parameter
     WIDTH = 32,
     NUMVRPT = 2,
     NUMPRPT = 1,
     ENAPAR = 0,
     ENAECC = 0,
     NUMADDR = 8192,
     BITADDR = 13,
     BITWDTH = 5,
     NUMVBNK = 8,
     BITVBNK = 3,
     BITPBNK = 4,
     NUMVROW = 1024,
     BITVROW = 10,
     BITPADR = 14,
     SRAM_DELAY = 2,
     FLOPIN = 0,
     FLOPOUT = 0
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMPRPT*NUMVBNK-1:0] t1_writeA,
  input [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMPRPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMPRPT*NUMVBNK-1:0] t1_readB,
  input [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMPRPT*NUMVBNK*WIDTH-1:0] t1_doutB,
  input [NUMPRPT*NUMVBNK-1:0] t1_fwrdB,
  input [NUMPRPT*NUMVBNK-1:0] t1_serrB,
  input [NUMPRPT*NUMVBNK-1:0] t1_derrB,
  input [NUMPRPT*NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB,
  input [NUMPRPT-1:0] t2_writeA,
  input [NUMPRPT*BITVROW-1:0] t2_addrA,
  input [NUMPRPT*WIDTH-1:0] t2_dinA,
  input [NUMPRPT-1:0] t2_readB,
  input [NUMPRPT*BITVROW-1:0] t2_addrB,
  input [NUMPRPT*WIDTH-1:0] t2_doutB,
  input [NUMPRPT-1:0] t2_fwrdB,
  input [NUMPRPT-1:0] t2_serrB,
  input [NUMPRPT-1:0] t2_derrB,
  input [NUMPRPT*(BITPADR-BITPBNK)-1:0] t2_padrB,
  input write,
  input [BITADDR-1:0]  wr_adr,
  input [WIDTH-1:0] din,
  input [NUMVRPT*BITADDR-1:0] rd_adr,
  input [NUMVRPT-1:0] read,
  input [NUMVRPT-1:0] rd_vld,
  input [NUMVRPT*WIDTH-1:0] rd_dout,
  input [NUMVRPT-1:0] rd_fwrd,
  input [NUMVRPT-1:0] rd_serr,
  input [NUMVRPT-1:0] rd_derr,
  input [NUMVRPT*BITPADR-1:0] rd_padr,
  input [BITADDR-1:0] select_addr,
  input [BITWDTH-1:0] select_bit
);

wire [BITVBNK-1:0] select_bank;
wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  sel_np2 (.vbadr(select_bank), .vradr(select_vrow), .vaddr(select_addr));

reg [BITPADR-BITPBNK-1:0] t1_padrB_sel [0:NUMPRPT-1];
reg [BITPADR-BITPBNK-1:0] t2_padrB_sel [0:NUMPRPT-1];
reg [NUMVBNK-1:0] t1_serrB_sel_wire [0:NUMPRPT-1];
reg [NUMVBNK-1:0] t1_derrB_sel_wire [0:NUMPRPT-1];
reg [NUMVBNK-1:0] t1_fwrdB_sel_wire [0:NUMPRPT-1];
reg t1_fwrdB_sel [0:NUMPRPT-1];
reg t2_fwrdB_sel [0:NUMPRPT-1];
reg xor_fwd_data_sel [0:NUMPRPT-1];
integer padr_int, padb_int;
always_comb
  for (padr_int=0; padr_int<NUMPRPT; padr_int=padr_int+1) begin
    t1_padrB_sel[padr_int] = t1_padrB >> ((NUMPRPT*select_bank+padr_int)*(BITPADR-BITPBNK));
    t2_padrB_sel[padr_int] = t2_padrB >> (padr_int*(BITPADR-BITPBNK));
    t1_fwrdB_sel[padr_int] = t1_fwrdB >> (NUMPRPT*select_bank+padr_int);
    t2_fwrdB_sel[padr_int] = t2_fwrdB >> padr_int;
    for (padb_int=0; padb_int<NUMVBNK; padb_int=padb_int+1) begin
      t1_serrB_sel_wire[padr_int][padb_int] = t1_serrB >> (NUMPRPT*padb_int+padr_int);
      t1_derrB_sel_wire[padr_int][padb_int] = t1_derrB >> (NUMPRPT*padb_int+padr_int);
      t1_fwrdB_sel_wire[padr_int][padb_int] = t1_fwrdB >> (NUMPRPT*padb_int+padr_int);
    end
    xor_fwd_data_sel[padr_int] = core.xor_fwd_data[padr_int];
  end

reg t1_writeA_wire [0:NUMVBNK-1];
reg [BITVROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
reg [WIDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];
reg t1_readB_wire [0:NUMPRPT-1][0:NUMVBNK-1];
reg [BITVROW-1:0] t1_addrB_wire [0:NUMPRPT-1][0:NUMVBNK-1];
integer t1_prpt_int, t1_vbnk_int;
always_comb
  for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin
    for (t1_prpt_int=0; t1_prpt_int<NUMPRPT; t1_prpt_int=t1_prpt_int+1) begin
      t1_readB_wire[t1_prpt_int][t1_vbnk_int] = t1_readB >> (NUMPRPT*t1_vbnk_int+t1_prpt_int);
      t1_addrB_wire[t1_prpt_int][t1_vbnk_int] = t1_addrB >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*BITVROW);
    end
    t1_writeA_wire[t1_vbnk_int] = t1_writeA >> (NUMPRPT*t1_vbnk_int);
    t1_addrA_wire[t1_vbnk_int] = t1_addrA >> (NUMPRPT*t1_vbnk_int*BITVROW);
    t1_dinA_wire[t1_vbnk_int] = t1_dinA >> (NUMPRPT*t1_vbnk_int*WIDTH);
  end

reg t2_writeA_wire;
reg [BITVROW-1:0] t2_addrA_wire;
reg [WIDTH-1:0] t2_dinA_wire;
reg t2_readB_wire [0:NUMPRPT-1];
reg [BITVROW-1:0] t2_addrB_wire [0:NUMPRPT-1];
integer t2_prpt_int;
always_comb begin
  for (t2_prpt_int=0; t2_prpt_int<NUMPRPT; t2_prpt_int=t2_prpt_int+1) begin
    t2_readB_wire[t2_prpt_int] = t2_readB >> t2_prpt_int;
    t2_addrB_wire[t2_prpt_int] = t2_addrB >> (t2_prpt_int*BITVROW);
  end
  t2_writeA_wire = t2_writeA;
  t2_addrA_wire = t2_addrA;
  t2_dinA_wire = t2_dinA;
end

wire [BITPBNK-1:0] wr_bnk;
wire [BITVROW-1:0] wr_row;
np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
           .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK),
           .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  wr_np2 (.vbadr(wr_bnk), .vradr(wr_row), .vaddr(wr_adr));

wire read_wire [0:NUMVRPT-1];
wire [BITADDR-1:0] rd_adr_wire [0:NUMVRPT-1];
wire [BITVBNK-1:0] rd_bnk_wire [0:NUMVRPT-1];
wire [BITVROW-1:0] rd_row_wire [0:NUMVRPT-1];
wire rd_vld_wire [0:NUMVRPT-1];
wire [WIDTH-1:0] rd_dout_wire [0:NUMVRPT-1];
wire rd_dbit_wire [0:NUMVRPT-1];
wire rd_fwrd_wire [0:NUMVRPT-1];
wire rd_serr_wire [0:NUMVRPT-1];
wire rd_derr_wire [0:NUMVRPT-1];
wire [BITPADR-1:0] rd_padr_wire [0:NUMVRPT-1];
genvar rd_int;
generate for (rd_int=0; rd_int<NUMVRPT; rd_int=rd_int+1) begin: rd_loop
  assign read_wire[rd_int] = read >> rd_int;
  assign rd_adr_wire[rd_int] = rd_adr >> (rd_int*BITADDR);
  np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
             .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
             .NUMVROW (NUMVROW), .BITVROW (BITVROW))
      rd_np2 (.vbadr(rd_bnk_wire[rd_int]), .vradr(rd_row_wire[rd_int]), .vaddr(rd_adr_wire[rd_int]));

  assign rd_vld_wire[rd_int] = rd_vld >> rd_int;
  assign rd_dout_wire[rd_int] = rd_dout >> (rd_int*WIDTH);
  assign rd_dbit_wire[rd_int] = rd_dout_wire[rd_int][select_bit];
  assign rd_fwrd_wire[rd_int] = rd_fwrd >> rd_int;
  assign rd_serr_wire[rd_int] = rd_serr >> rd_int;
  assign rd_derr_wire[rd_int] = rd_derr >> rd_int;
  assign rd_padr_wire[rd_int] = rd_padr >> (rd_int*BITPADR);
end
endgenerate

wire [NUMVBNK-1:0] mem_nerr [0:NUMPRPT-1];
wire [NUMVBNK-1:0] mem_serr [0:NUMPRPT-1];
wire [NUMVBNK-1:0] mem_derr [0:NUMPRPT-1];
wire xmem_nerr [0:NUMPRPT-1];
wire xmem_serr [0:NUMPRPT-1];
wire xmem_derr [0:NUMPRPT-1];
genvar rerr_int, berr_int;
generate for (rerr_int=0; rerr_int<NUMPRPT; rerr_int=rerr_int+1) begin: rerr_loop
  for (berr_int=0; berr_int<NUMVBNK; berr_int=berr_int+1) begin: berr_loop
    assign mem_nerr[rerr_int][berr_int] = !mem_serr[rerr_int][berr_int] && !mem_derr[rerr_int][berr_int];
    assign mem_serr[rerr_int][berr_int] = 1'b0;
    assign mem_derr[rerr_int][berr_int] = 1'b0;

    assume_mem_err_check: assert property (@(posedge clk) disable iff (rst) (mem_nerr[rerr_int][berr_int] ||
                                                                             (mem_serr[rerr_int][berr_int] && !mem_derr[rerr_int][berr_int]) ||
                                                                             (!mem_serr[rerr_int][berr_int] && mem_derr[rerr_int][berr_int])));

    reg mem_nerr_tmp;
    reg mem_serr_tmp;
    reg mem_derr_tmp;
    if (FLOPIN) begin: flpi_loop
      always @(posedge clk) begin
        mem_nerr_tmp <= mem_nerr[rerr_int][berr_int];
        mem_serr_tmp <= mem_serr[rerr_int][berr_int];
        mem_derr_tmp <= mem_derr[rerr_int][berr_int];
      end
    end else begin: noflpi_loop
      always_comb begin
        mem_nerr_tmp = mem_nerr[rerr_int][berr_int];
        mem_serr_tmp = mem_serr[rerr_int][berr_int];
        mem_derr_tmp = mem_derr[rerr_int][berr_int];
      end
    end

    assume_mem_nerr_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[rerr_int][berr_int] && mem_nerr_tmp) |-> ##SRAM_DELAY
                                            !t1_serrB[berr_int*NUMPRPT+rerr_int] && !t1_derrB[berr_int*NUMPRPT+rerr_int]);
    assume_mem_serr_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[rerr_int][berr_int] && mem_serr_tmp) |-> ##SRAM_DELAY
                                            t1_serrB[berr_int*NUMPRPT+rerr_int] && !t1_derrB[berr_int*NUMPRPT+rerr_int]);
    assume_mem_derr_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[rerr_int][berr_int] && mem_derr_tmp) |-> ##SRAM_DELAY
                                            ENAPAR ? t1_serrB[berr_int*NUMPRPT+rerr_int] && t1_derrB[berr_int*NUMPRPT+rerr_int] :
                                            ENAECC ? t1_derrB[berr_int*NUMPRPT+rerr_int] : 1'b0);
  end
  assign xmem_nerr[rerr_int] = !xmem_serr[rerr_int] && !xmem_derr[rerr_int];
  assign xmem_serr[rerr_int] = 1'b0;
  assign xmem_derr[rerr_int] = 1'b0;

  assume_xmem_err_check: assert property (@(posedge clk) disable iff (rst) (xmem_nerr[rerr_int] ||
                                                                            (xmem_serr[rerr_int] && !xmem_derr[rerr_int]) ||
                                                                            (!xmem_serr[rerr_int] && xmem_derr[rerr_int])));

  reg xmem_nerr_tmp;
  reg xmem_serr_tmp;
  reg xmem_derr_tmp;
  if (FLOPIN) begin: flpi_loop
    always @(posedge clk) begin
      xmem_nerr_tmp <= xmem_nerr[rerr_int];
      xmem_serr_tmp <= xmem_serr[rerr_int];
      xmem_derr_tmp <= xmem_derr[rerr_int];
    end
  end else begin: noflpi_loop
    always_comb begin
      xmem_nerr_tmp = xmem_nerr[rerr_int];
      xmem_serr_tmp = xmem_serr[rerr_int];
      xmem_derr_tmp = xmem_derr[rerr_int];
    end
  end

  assume_xmem_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[rerr_int] && xmem_nerr_tmp) |-> ##SRAM_DELAY
                                           !t2_serrB[rerr_int] && !t2_derrB[rerr_int]);
  assume_xmem_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[rerr_int] && xmem_serr_tmp) |-> ##SRAM_DELAY
                                           t2_serrB[rerr_int] && !t2_derrB[rerr_int]);
  assume_xmem_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[rerr_int] && xmem_derr_tmp) |-> ##SRAM_DELAY
                                           ENAPAR ? t2_serrB[rerr_int] && t2_derrB[rerr_int] :
                                           ENAECC ? t2_derrB[rerr_int] : 1'b0);
end
endgenerate

reg cflt [0:NUMVRPT-1];
reg cflt_serr [0:NUMVRPT-1];
reg cflt_derr [0:NUMVRPT-1];
reg [BITPBNK-1:0] cflt_pbnk [0:NUMVRPT-1];
integer vrdr_int, vrdb_int;
always_comb
  for (vrdr_int=1; vrdr_int<NUMVRPT; vrdr_int=vrdr_int+2) begin
    cflt[vrdr_int] = read_wire[vrdr_int-1] && read_wire[vrdr_int] && (rd_bnk_wire[vrdr_int-1] == rd_bnk_wire[vrdr_int]);
    cflt_serr[vrdr_int] = ENAPAR ? xmem_serr[vrdr_int>>1] || xmem_derr[vrdr_int>>1] : xmem_serr[vrdr_int>>1];
    cflt_derr[vrdr_int] = xmem_derr[vrdr_int>>1];
    cflt_pbnk[vrdr_int] = (xmem_serr[vrdr_int>>1] || xmem_derr[vrdr_int>>1]) ? NUMVBNK : 0;
    for (vrdb_int=NUMVBNK-1; vrdb_int>=0; vrdb_int=vrdb_int-1)
      if (vrdb_int != rd_bnk_wire[vrdr_int])
        if (ENAPAR) begin
          if (mem_derr[vrdr_int>>1][vrdb_int] || (mem_serr[vrdr_int>>1][vrdb_int] && cflt_serr[vrdr_int])) begin
	    cflt_serr[vrdr_int] = 1'b1;
	    cflt_derr[vrdr_int] = 1'b1;
	    cflt_pbnk[vrdr_int] = vrdb_int;
          end
          if (mem_serr[vrdr_int>>1][vrdb_int]) begin
            cflt_serr[vrdr_int] = 1'b1;
	    cflt_pbnk[vrdr_int] = vrdb_int;
          end
        end else if (ENAECC) begin
          if (mem_derr[vrdr_int>>1][vrdb_int]) begin
	    cflt_derr[vrdr_int] = 1'b1;
	    cflt_pbnk[vrdr_int] = vrdb_int;
          end
          if (mem_serr[vrdr_int>>1][vrdb_int]) begin
            cflt_serr[vrdr_int] = 1'b1;
            if (!cflt_derr[vrdr_int])
	      cflt_pbnk[vrdr_int] = vrdb_int;
          end
        end
  end

reg [NUMVBNK-1:0] mem;
integer mem_int;
always @(posedge clk)
  for (mem_int=0; mem_int<NUMVBNK; mem_int=mem_int+1)
    if (!ready)
      mem[mem_int] <= 0;
    else if (t1_writeA_wire[mem_int] && (t1_addrA_wire[mem_int] == select_vrow))
      mem[mem_int] <= t1_dinA_wire[mem_int][select_bit];
      
reg xmem_inv;
reg xmem;
always @(posedge clk)
  if (!ready) begin
    xmem_inv <= 1'b0;
    xmem <= 0;
  end else if (t2_writeA_wire && (t2_addrA_wire == select_vrow)) begin
    xmem_inv <= core.xclr_req ? (ENAPAR ? core.xserr_req : ENAECC ? core.xderr_req : 1'b0) :
                                xmem_inv || (ENAPAR ? core.xserr_req : ENAECC ? core.xderr_req : 1'b0);
    xmem <= t2_dinA_wire[select_bit];
  end

wire xor_mem = ^mem;

genvar memr_int, memb_int;
generate for (memr_int=0; memr_int<NUMPRPT; memr_int=memr_int+1) begin: memr_loop
  for (memb_int=0; memb_int<NUMVBNK; memb_int=memb_int+1) begin: memb_loop
    assert_pdout_check: assert property (@(posedge clk) disable iff (rst)
					 (t1_readB_wire[memr_int][memb_int] && (t1_addrB_wire[memr_int][memb_int] == select_vrow)) |-> ##SRAM_DELAY
//					 (t1_doutA[(memb_int*NUMPRPT+memr_int)*WIDTH+select_bit] == $past(mem[memb_int],SRAM_DELAY)));
                                         ((!t1_fwrdB[memb_int*NUMPRPT+memr_int] && (ENAPAR ? t1_serrB[memb_int*NUMPRPT+memr_int] :
                                                                                    ENAECC ? t1_derrB[memb_int*NUMPRPT+memr_int] : 1'b0)) ||
					  (t1_doutB[(memb_int*NUMPRPT+memr_int)*WIDTH+select_bit] == $past(mem[memb_int],SRAM_DELAY))));
  end
  assert_xdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[memr_int] && (t2_addrB_wire[memr_int] == select_vrow)) |-> ##SRAM_DELAY
//                                       (t2_doutA[memr_int*WIDTH+select_bit] == $past(xmem,SRAM_DELAY)));
                                       ((!t2_fwrdB[memr_int] && (ENAPAR ? t2_serrB[memr_int] : ENAECC ? t2_derrB[memr_int] : 1'b0)) ||
					(t2_doutB[memr_int*WIDTH+select_bit] == $past(xmem,SRAM_DELAY))));
end
endgenerate

genvar xorr_int;
generate for (xorr_int=0; xorr_int<NUMPRPT; xorr_int=xorr_int+1) begin: xorr_loop
//  assert_xmem_req_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[xorr_int] && (t2_addrB_wire[xorr_int] == select_vrow)) |-> ##1
//				          (xmem_req == (core.xrd_srch_flag[xorr_int] ? core.xrd_srch_data[xorr_int][select_bit] : xmem)));

  assert_xor_int_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[xorr_int] && (t2_addrB_wire[xorr_int] == select_vrow)) |-> ##SRAM_DELAY
				         ((!t2_fwrdB[xorr_int] && !core.xor_fwd_data[xorr_int] && (ENAPAR ? t2_serrB[xorr_int] : ENAECC ? t2_derrB[xorr_int] : 1'b0)) ||
                                          (core.xor_data[xorr_int][select_bit] == xmem)));

  assert_xor_more_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[xorr_int] && (t2_addrB_wire[xorr_int] == select_vrow)) |-> ##SRAM_DELAY
				          (xmem_inv || (!t2_fwrdB[xorr_int] && !core.xor_fwd_data[xorr_int] && (ENAPAR ? t2_serrB[xorr_int] : ENAECC ? t2_derrB[xorr_int] : 1'b0)) ||
                                           (core.xor_data[xorr_int][select_bit] == ($past(xor_mem,SRAM_DELAY)))));
end
endgenerate

  assert_xor_data_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##SRAM_DELAY
                                          (xmem_inv || (xmem == ($past(xor_mem,SRAM_DELAY)))));

reg fakexor_inv;
always @(posedge clk)
  if (!ready)
    fakexor_inv <= 1'b0;
  else if (write && (wr_row == select_vrow) && (wr_bnk < NUMVBNK)) 
    if (NUMVRPT[0])
      fakexor_inv <= ENAPAR ? |mem_serr[0] || |mem_derr[0] : ENAECC ? |mem_derr[0] : 1'b0;
    else
      fakexor_inv <= (read_wire[0] && (rd_bnk_wire[0] == wr_bnk)) ?
                     (ENAPAR ? |mem_serr[0] || xmem_serr[0] || |mem_derr[0] || xmem_derr[0] : ENAECC ? |mem_derr[0] || xmem_derr[0] : 1'b0) :
                     (fakexor_inv || (ENAPAR ? mem_serr[0][wr_bnk] || xmem_serr[0] || mem_derr[0][wr_bnk] || xmem_derr[0] :
                                      ENAECC ? mem_derr[0][wr_bnk] || xmem_derr[0] : 1'b0));

reg fakemem;
always @(posedge clk)
  if (!ready) 
    fakemem <= 1'b0;
  else if (write && (wr_adr == select_addr))
    fakemem <= din[select_bit];

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##FLOPIN ((FLOPIN ? $past(fakemem) : fakemem) == mem[select_bank]));

genvar doutr_int;
generate for (doutr_int=0; doutr_int<NUMVRPT; doutr_int=doutr_int+1) begin: doutr_loop

  assert_vld_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                     rd_vld_wire[doutr_int]);

  if (doutr_int[0] == 1'b0) begin: even_loop
    assert_dout_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && mem_nerr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                             (rd_dbit_wire[doutr_int] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)));
    assert_dout_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && mem_serr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                             ((ENAPAR && !rd_fwrd_wire[doutr_int]) || (rd_dbit_wire[doutr_int] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT))));
    assert_dout_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && mem_derr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                             !rd_fwrd_wire[doutr_int] || (rd_dbit_wire[doutr_int] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)));

    assert_derr_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && mem_nerr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                             (!rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_derr_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && mem_serr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					     (rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_derr_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && mem_derr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					     ENAPAR ? rd_serr_wire[doutr_int] && rd_derr_wire[doutr_int] : rd_derr_wire[doutr_int]);

    assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					(rd_fwrd_wire[doutr_int] == (FLOPOUT ? $past(t1_fwrdB_sel[doutr_int>>1]) : t1_fwrdB_sel[doutr_int>>1])));
    assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					(rd_padr_wire[doutr_int] == {select_bank,(FLOPOUT ? $past(t1_padrB_sel[doutr_int>>1]) : t1_padrB_sel[doutr_int>>1])}));

  end else begin: odd_loop

    assert_dout_ncfl_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && mem_nerr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
						  (rd_dbit_wire[doutr_int] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)));
    assert_dout_ncfl_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && mem_serr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
						  ((ENAPAR && !rd_fwrd_wire[doutr_int]) || (rd_dbit_wire[doutr_int] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT))));
    assert_dout_ncfl_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && mem_derr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
						  !rd_fwrd_wire[doutr_int] || (rd_dbit_wire[doutr_int] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)));

    assert_derr_ncfl_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && mem_nerr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
						  (!rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_derr_ncfl_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && mem_serr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					          (rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_derr_ncfl_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && mem_derr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					          ENAPAR ? rd_serr_wire[doutr_int] && rd_derr_wire[doutr_int] : rd_derr_wire[doutr_int]);

    assert_fwrd_ncfl_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                             (rd_fwrd_wire[doutr_int] == (FLOPOUT ? $past(t1_fwrdB_sel[doutr_int>>1]) : t1_fwrdB_sel[doutr_int>>1])));
    assert_padr_ncfl_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					     (rd_padr_wire[doutr_int] == {select_bank,(FLOPOUT ? $past(t1_padrB_sel[doutr_int>>1]) : t1_padrB_sel[doutr_int>>1])}));

    assert_dout_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && &(mem_nerr[doutr_int>>1] | (1'b1 << select_bank)) && xmem_nerr[doutr_int>>1]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                                  ($past(fakexor_inv,FLOPIN+SRAM_DELAY+FLOPOUT) || (rd_dbit_wire[doutr_int] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT))));
    assert_dout_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|(mem_serr[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_serr[doutr_int>>1]) && !(|(mem_derr[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_derr[doutr_int>>1])) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					          ($past(fakexor_inv,FLOPIN+SRAM_DELAY+FLOPOUT) || (ENAPAR && !rd_fwrd_wire[doutr_int]) || (rd_dbit_wire[doutr_int] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT))));
    assert_dout_cflt_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|(mem_derr[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_derr[doutr_int>>1])) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					          ($past(fakexor_inv,FLOPIN+SRAM_DELAY+FLOPOUT) || !rd_fwrd_wire[doutr_int] || (rd_dbit_wire[doutr_int] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT))));

    assert_derr_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && &(mem_nerr[doutr_int>>1] | (1'b1 << select_bank)) && xmem_nerr[doutr_int>>1]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					           (!rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_derr_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|(mem_serr[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_serr[doutr_int>>1]) && !(|(mem_derr[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_derr[doutr_int>>1])) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					          ((rd_serr_wire[doutr_int] == ($past(cflt_serr[doutr_int],FLOPIN+SRAM_DELAY+FLOPOUT))) &&
					           (rd_derr_wire[doutr_int] == ($past(cflt_derr[doutr_int],FLOPIN+SRAM_DELAY+FLOPOUT)))));
    assert_derr_cflt_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|(mem_derr[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_derr[doutr_int>>1])) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					          ((ENAECC || (rd_serr_wire[doutr_int] == ($past(cflt_serr[doutr_int],FLOPIN+SRAM_DELAY+FLOPOUT)))) &&
					           (rd_derr_wire[doutr_int] == ($past(cflt_derr[doutr_int],FLOPIN+SRAM_DELAY+FLOPOUT)))));

    assert_fwrd_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && &(mem_nerr[doutr_int>>1] | (1'b1 << select_bank)) && xmem_nerr[doutr_int>>1]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                                  (rd_fwrd_wire[doutr_int] == (FLOPOUT ? $past(|(t1_fwrdB_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || t2_fwrdB_sel[doutr_int>>1] || xor_fwd_data_sel[doutr_int>>1]) :
                                                                                         (|(t1_fwrdB_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || t2_fwrdB_sel[doutr_int>>1] || xor_fwd_data_sel[doutr_int>>1])))); 
    assert_fwrd_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|mem_serr[doutr_int>>1] || xmem_serr[doutr_int>>1])) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
         (rd_fwrd_wire[doutr_int] == (FLOPOUT ? $past((|(t1_fwrdB_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) ||
                                                       t2_fwrdB_sel[doutr_int>>1] || xor_fwd_data_sel[doutr_int>>1]) &&
                                                      !(|(~t1_fwrdB_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}} &
                                                          (ENAPAR ? t1_serrB_sel_wire[doutr_int>>1] | t1_derrB_sel_wire[doutr_int>>1] :
                                                                    t1_derrB_sel_wire[doutr_int>>1])) ||
                                                         (!t2_fwrdB_sel[doutr_int>>1] && !xor_fwd_data_sel[doutr_int>>1] &&
                                                          ((ENAPAR && t2_serrB[doutr_int>>1]) || t2_derrB[doutr_int>>1])))) :
                                                ((|(t1_fwrdB_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) ||
                                                    t2_fwrdB_sel[doutr_int>>1] || xor_fwd_data_sel[doutr_int>>1]) &&
                                                    !(|(~t1_fwrdB_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}} &
                                                        (ENAPAR ? t1_serrB_sel_wire[doutr_int>>1] | t1_derrB_sel_wire[doutr_int>>1] :
                                                                  t1_derrB_sel_wire[doutr_int>>1])) ||
                                                       (!t2_fwrdB_sel[doutr_int>>1] && !xor_fwd_data_sel[doutr_int>>1] &&
                                                        ((ENAPAR && t2_serrB[doutr_int>>1]) || t2_derrB[doutr_int>>1])))))));
    assert_fwrd_cflt_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|mem_derr[doutr_int>>1] || xmem_derr[doutr_int>>1])) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
         (rd_fwrd_wire[doutr_int] == (FLOPOUT ? $past((|(t1_fwrdB_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) ||
                                                       t2_fwrdB_sel[doutr_int>>1] || xor_fwd_data_sel[doutr_int>>1]) &&
                                                      !(|(~t1_fwrdB_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}} &
                                                          (ENAPAR ? t1_serrB_sel_wire[doutr_int>>1] | t1_derrB_sel_wire[doutr_int>>1] :
                                                                    t1_derrB_sel_wire[doutr_int>>1])) ||
                                                         (!t2_fwrdB_sel[doutr_int>>1] && !xor_fwd_data_sel[doutr_int>>1] &&
                                                          ((ENAPAR && t2_serrB[doutr_int>>1]) || t2_derrB[doutr_int>>1])))) :
                                                ((|(t1_fwrdB_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) ||
                                                    t2_fwrdB_sel[doutr_int>>1] || xor_fwd_data_sel[doutr_int>>1]) &&
                                                    !(|(~t1_fwrdB_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}} &
                                                        (ENAPAR ? t1_serrB_sel_wire[doutr_int>>1] | t1_derrB_sel_wire[doutr_int>>1] :
                                                                  t1_derrB_sel_wire[doutr_int>>1])) ||
                                                       (!t2_fwrdB_sel[doutr_int>>1] && !xor_fwd_data_sel[doutr_int>>1] &&
                                                        ((ENAPAR && t2_serrB[doutr_int>>1]) || t2_derrB[doutr_int>>1])))))));
    assert_padr_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] &&
									             &(mem_nerr[doutr_int>>1] | (1'b1 << select_bank)) && xmem_nerr[doutr_int>>1]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
						  (rd_padr_wire[doutr_int] == {NUMVBNK,(FLOPOUT ? $past(t2_padrB) : t2_padrB)}));
    assert_padr_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] &&
					                                            (|(mem_serr[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_serr[doutr_int>>1]) && !(|(mem_derr[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_derr[doutr_int>>1])) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
						  (rd_padr_wire[doutr_int] == {$past(cflt_pbnk[doutr_int],FLOPIN+SRAM_DELAY+FLOPOUT),(FLOPOUT ? $past(t2_padrB) : t2_padrB)}));
    assert_padr_cflt_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] &&
					                                            (|(mem_derr[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_derr[doutr_int>>1])) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
						  (rd_padr_wire[doutr_int] == {$past(cflt_pbnk[doutr_int],FLOPIN+SRAM_DELAY+FLOPOUT),(FLOPOUT ? $past(t2_padrB) : t2_padrB)}));
  end
end
endgenerate

endmodule


