module ip_top_sva_2_nror1w
  #(
parameter     WIDTH = 8,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVRPT = 2,
parameter     NUMPRPT = 1,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     REFRESH = 10,
parameter     REFFREQ = 16)
(
  input clk,
  input rst,
  input ready,
  input refr,
  input [NUMVRPT-1:0] read,
  input [NUMVRPT*BITADDR-1:0] rd_adr,
  input write,
  input [BITADDR-1:0]  wr_adr,
  input [NUMPRPT*NUMVBNK-1:0] t1_readA,
  input [NUMPRPT*NUMVBNK-1:0] t1_writeA,
  input [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMPRPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMPRPT*NUMVBNK-1:0] t1_refrB,
  input [NUMPRPT-1:0] t2_readA,
  input [NUMPRPT-1:0] t2_writeA,
  input [NUMPRPT*BITVROW-1:0] t2_addrA,
  input [NUMPRPT*WIDTH-1:0] t2_dinA,
  input [NUMPRPT-1:0] t2_refrB
);

generate if (REFRESH) begin: refr_loop
assert_refr_check: assert property (@(posedge clk) disable iff (!ready) !refr |-> ##[1:REFFREQ-1] refr);
assert_refr_noacc_check: assume property (@(posedge clk) disable iff (rst) !(refr && (write || |read)));
end
endgenerate

assert_rd_wr_check: assume property (@(posedge clk) disable iff (rst) !(write && |read));
assert_wr_range_check: assume property (@(posedge clk) disable iff (rst) write |-> (wr_adr < NUMADDR));
genvar rd_int;
generate for (rd_int=0; rd_int<NUMVRPT; rd_int=rd_int+1) begin: rd_loop
  wire read_wire = read >> rd_int;
  wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (rd_int*BITADDR);

//  assert_rd_range_check: assume property (@(posedge clk) disable iff (rst) read_wire |-> (rd_adr_wire < NUMADDR));
end
endgenerate

genvar t1_vbnk_int, t1_prpt_int;
generate for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin: t1_vbnk_loop
  for (t1_prpt_int=0; t1_prpt_int<NUMPRPT; t1_prpt_int=t1_prpt_int+1) begin: t1_prpt_loop
    wire t1_readA_wire = t1_readA >> (NUMPRPT*t1_vbnk_int+t1_prpt_int);
    wire t1_writeA_wire = t1_writeA >> (NUMPRPT*t1_vbnk_int+t1_prpt_int);
    wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*BITVROW);
    wire [WIDTH-1:0] t1_dinA_wire = t1_dinA >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*WIDTH);

    wire t1_writeA_0_wire = t1_writeA >> (NUMPRPT*t1_vbnk_int);
    wire [BITVROW-1:0] t1_addrA_0_wire = t1_addrA >> (NUMPRPT*t1_vbnk_int*BITVROW);
    wire [WIDTH-1:0] t1_dinA_0_wire = t1_dinA >> (NUMPRPT*t1_vbnk_int*WIDTH);

    assert_t1_1port_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA_wire && t1_writeA_wire));
//    assert_t1_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire || t1_writeA_wire) |-> (t1_addrA_wire < NUMVROW));
    assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVROW));
    assert_t1_wr_same_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |->
					      (t1_writeA_0_wire && (t1_addrA_0_wire == t1_addrA_wire) && (t1_dinA_0_wire == t1_dinA_wire))); 
  end
end
endgenerate

genvar t2_prpt_int;
generate for (t2_prpt_int=0; t2_prpt_int<NUMPRPT; t2_prpt_int=t2_prpt_int+1) begin: t2_prpt_loop
  wire t2_readA_wire = t2_readA >> t2_prpt_int;
  wire t2_writeA_wire = t2_writeA >> t2_prpt_int;
  wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> (t2_prpt_int*BITVROW);
  wire [WIDTH-1:0] t2_dinA_wire = t2_dinA >> (t2_prpt_int*WIDTH);

  wire t2_writeA_0_wire = t2_writeA;
  wire [BITVROW-1:0] t2_addrA_0_wire = t2_addrA;
  wire [WIDTH-1:0] t2_dinA_0_wire = t2_dinA;

  assert_t2_1port_check: assert property (@(posedge clk) disable iff (rst) !(t2_readA_wire && t2_writeA_wire));
//  assert_t2_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire || t2_writeA_wire) |-> (t2_addrA_wire < NUMVROW));
  assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));
  assert_t2_wr_same_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |->
					    (t2_writeA_0_wire && (t2_addrA_0_wire == t2_addrA_wire) && (t2_dinA_0_wire == t2_dinA_wire))); 
end
endgenerate

endmodule


module ip_top_sva_nror1w
  #(
parameter     WIDTH = 32,
parameter     BITWDTH = 5,
parameter     ENAPAR = 0,
parameter     ENAECC = 0,
parameter     NUMVRPT = 2,
parameter     NUMPRPT = 1,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     BITPBNK = 4,
parameter     NUMVROW = 8,
parameter     BITVROW = 3,
parameter     BITPADR = 14,
parameter     SRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     MEM_DELAY = SRAM_DELAY+FLOPIN+FLOPOUT
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMPRPT*NUMVBNK-1:0] t1_readA,
  input [NUMPRPT*NUMVBNK-1:0] t1_writeA,
  input [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMPRPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMPRPT*NUMVBNK*WIDTH-1:0] t1_doutA,
  input [NUMPRPT*NUMVBNK-1:0] t1_fwrdA,
  input [NUMPRPT*NUMVBNK-1:0] t1_serrA,
  input [NUMPRPT*NUMVBNK-1:0] t1_derrA,
  input [NUMPRPT*NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrA,
  input [NUMPRPT-1:0] t2_readA,
  input [NUMPRPT-1:0] t2_writeA,
  input [NUMPRPT*BITVROW-1:0] t2_addrA,
  input [NUMPRPT*WIDTH-1:0] t2_dinA,
  input [NUMPRPT*WIDTH-1:0] t2_doutA,
  input [NUMPRPT-1:0] t2_fwrdA,
  input [NUMPRPT-1:0] t2_serrA,
  input [NUMPRPT-1:0] t2_derrA,
  input [NUMPRPT*(BITPADR-BITPBNK)-1:0] t2_padrA,
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

reg [BITPADR-BITPBNK-1:0] t1_padrA_sel_wire [0:NUMPRPT-1][0:16-1];
reg [BITPADR-BITPBNK-1:0] t1_padrA_sel [0:NUMPRPT-1];
reg [BITPADR-BITPBNK-1:0] t2_padrA_sel [0:NUMPRPT-1];
reg [NUMVBNK-1:0] t1_serrA_sel_wire [0:NUMPRPT-1];
reg [NUMVBNK-1:0] t1_derrA_sel_wire [0:NUMPRPT-1];
reg [NUMVBNK-1:0] t1_fwrdA_sel_wire [0:NUMPRPT-1];
reg t1_fwrdA_sel [0:NUMPRPT-1];
reg t2_fwrdA_sel [0:NUMPRPT-1];
reg xor_fwd_data_sel [0:NUMPRPT-1];
integer padr_int, padb_int;
always_comb
  for (padr_int=0; padr_int<NUMPRPT; padr_int=padr_int+1) begin
    t1_padrA_sel[padr_int] = t1_padrA >> ((NUMPRPT*select_bank+padr_int)*(BITPADR-BITPBNK));
    t2_padrA_sel[padr_int] = t2_padrA >> (padr_int*(BITPADR-BITPBNK));
    for (padb_int=0; padb_int<16; padb_int=padb_int+1) begin
      t1_padrA_sel_wire[padr_int][padb_int] = t1_padrA >> ((NUMPRPT*padb_int+padr_int)*(BITPADR-BITPBNK));
    end
    t1_fwrdA_sel[padr_int] = t1_fwrdA >> (NUMPRPT*select_bank+padr_int);
    t2_fwrdA_sel[padr_int] = t2_fwrdA >> padr_int;
    for (padb_int=0; padb_int<NUMVBNK; padb_int=padb_int+1) begin
      t1_serrA_sel_wire[padr_int][padb_int] = t1_serrA >> (NUMPRPT*padb_int+padr_int);
      t1_derrA_sel_wire[padr_int][padb_int] = t1_derrA >> (NUMPRPT*padb_int+padr_int);
      t1_fwrdA_sel_wire[padr_int][padb_int] = t1_fwrdA >> (NUMPRPT*padb_int+padr_int);
    end
    xor_fwd_data_sel[padr_int] = core.xor_fwd_data[padr_int];
  end

reg t1_readA_wire [0:NUMPRPT-1][0:NUMVBNK-1];
reg t1_writeA_wire [0:NUMVBNK-1];
reg [BITVROW-1:0] t1_addrA_wire [0:NUMPRPT-1][0:NUMVBNK-1];
reg [WIDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];
reg [WIDTH-1:0] t1_doutA_wire [0:NUMVBNK-1];
reg [BITPADR-BITPBNK-1:0] t1_padrA_wire [0:NUMVBNK-1];
integer t1_prpt_int, t1_vbnk_int;
always_comb
  for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin
    for (t1_prpt_int=0; t1_prpt_int<NUMPRPT; t1_prpt_int=t1_prpt_int+1) begin
      t1_readA_wire[t1_prpt_int][t1_vbnk_int] = t1_readA >> (NUMPRPT*t1_vbnk_int+t1_prpt_int);
      t1_addrA_wire[t1_prpt_int][t1_vbnk_int] = t1_addrA >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*BITVROW);
    end
    t1_writeA_wire[t1_vbnk_int] = t1_writeA >> (NUMPRPT*t1_vbnk_int);
    t1_dinA_wire[t1_vbnk_int] = t1_dinA >> (NUMPRPT*t1_vbnk_int*WIDTH);
    t1_doutA_wire[t1_vbnk_int] = t1_doutA >> (NUMPRPT*t1_vbnk_int*WIDTH);
    t1_padrA_wire[t1_vbnk_int] = t1_padrA >> (NUMPRPT*t1_vbnk_int*(BITPADR-BITPBNK));
  end

reg t2_readA_wire [0:NUMPRPT-1];
reg [BITVROW-1:0] t2_addrA_wire [0:NUMPRPT-1];
integer t2_prpt_int;
always_comb
  for (t2_prpt_int=0; t2_prpt_int<NUMPRPT; t2_prpt_int=t2_prpt_int+1) begin
    t2_readA_wire[t2_prpt_int] = t2_readA >> t2_prpt_int;
    t2_addrA_wire[t2_prpt_int] = t2_addrA >> (t2_prpt_int*BITVROW);
  end

wire [BITVBNK-1:0] wr_bnk;
wire [BITVROW-1:0] wr_row;
np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
           .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
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
wire [NUMVBNK-1:0] mem_nerr_wire [0:NUMPRPT-1];
wire [NUMVBNK-1:0] mem_serr_wire [0:NUMPRPT-1];
wire [NUMVBNK-1:0] mem_derr_wire [0:NUMPRPT-1];
wire xmem_nerr [0:NUMPRPT-1];
wire xmem_serr [0:NUMPRPT-1];
wire xmem_derr [0:NUMPRPT-1];
wire xmem_nerr_wire [0:NUMPRPT-1];
wire xmem_serr_wire [0:NUMPRPT-1];
wire xmem_derr_wire [0:NUMPRPT-1];
genvar rerr_int, berr_int;
generate for (rerr_int=0; rerr_int<NUMPRPT; rerr_int=rerr_int+1) begin: rerr_loop
  for (berr_int=0; berr_int<NUMVBNK; berr_int=berr_int+1) begin: berr_loop
    assign mem_nerr[rerr_int][berr_int] = !mem_serr[rerr_int][berr_int] && !mem_derr[rerr_int][berr_int];
    assign mem_serr[rerr_int][berr_int] = 1'b0;
    assign mem_derr[rerr_int][berr_int] = 1'b0;

    assign mem_nerr_wire[rerr_int][berr_int] = !mem_serr_wire[rerr_int][berr_int] && !mem_derr_wire[rerr_int][berr_int];
    assign mem_serr_wire[rerr_int][berr_int] = mem_serr[rerr_int][berr_int] && (ENAPAR || ENAECC);
    assign mem_derr_wire[rerr_int][berr_int] = mem_derr[rerr_int][berr_int] && (ENAPAR || ENAECC);

    assume_mem_err_check: assert property (@(posedge clk) disable iff (rst) (mem_nerr[rerr_int][berr_int] ||
                                                                             (mem_serr[rerr_int][berr_int] && !mem_derr[rerr_int][berr_int]) ||
                                                                             (!mem_serr[rerr_int][berr_int] && mem_derr[rerr_int][berr_int])));
    reg mem_nerr_tmp;
    reg mem_serr_tmp;
    reg mem_derr_tmp;
    if (FLOPIN) begin: flpi_loop
      always @(posedge clk) begin
        mem_nerr_tmp <= mem_nerr_wire[rerr_int][berr_int];
        mem_serr_tmp <= mem_serr_wire[rerr_int][berr_int];
        mem_derr_tmp <= mem_derr_wire[rerr_int][berr_int];
      end
    end else begin: noflpi_loop
      always_comb begin
        mem_nerr_tmp = mem_nerr_wire[rerr_int][berr_int];
        mem_serr_tmp = mem_serr_wire[rerr_int][berr_int];
        mem_derr_tmp = mem_derr_wire[rerr_int][berr_int];
      end
    end

    assume_mem_nerr_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire[rerr_int][berr_int] && mem_nerr_tmp) |-> ##SRAM_DELAY
                                            !t1_serrA[berr_int*NUMPRPT+rerr_int] && !t1_derrA[berr_int*NUMPRPT+rerr_int]);
    assume_mem_serr_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire[rerr_int][berr_int] && mem_serr_tmp) |-> ##SRAM_DELAY
                                            t1_serrA[berr_int*NUMPRPT+rerr_int] && !t1_derrA[berr_int*NUMPRPT+rerr_int]);
    assume_mem_derr_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire[rerr_int][berr_int] && mem_derr_tmp) |-> ##SRAM_DELAY
                                            ENAPAR ? t1_serrA[berr_int*NUMPRPT+rerr_int] && t1_derrA[berr_int*NUMPRPT+rerr_int] :
                                            ENAECC ? t1_derrA[berr_int*NUMPRPT+rerr_int] : 1'b0);
  end

  assign xmem_nerr[rerr_int] = !xmem_serr[rerr_int] && !xmem_derr[rerr_int];
  assign xmem_serr[rerr_int] = 1'b0;
  assign xmem_derr[rerr_int] = 1'b0;

  assign xmem_nerr_wire[rerr_int] = !xmem_serr_wire[rerr_int] && !xmem_derr_wire[rerr_int];
  assign xmem_serr_wire[rerr_int] = mem_serr_wire[rerr_int] && (ENAPAR || ENAECC);
  assign xmem_derr_wire[rerr_int] = mem_derr_wire[rerr_int] && (ENAPAR || ENAECC);

  reg xmem_nerr_tmp;
  reg xmem_serr_tmp;
  reg xmem_derr_tmp;
  if (FLOPIN) begin: flpi_loop
    always @(posedge clk) begin
      xmem_nerr_tmp <= xmem_nerr_wire[rerr_int];
      xmem_serr_tmp <= xmem_serr_wire[rerr_int];
      xmem_derr_tmp <= xmem_derr_wire[rerr_int];
    end
  end else begin: noflpi_loop
    always_comb begin
      xmem_nerr_tmp = xmem_nerr_wire[rerr_int];
      xmem_serr_tmp = xmem_serr_wire[rerr_int];
      xmem_derr_tmp = xmem_derr_wire[rerr_int];
    end
  end

  assume_xmem_err_check: assert property (@(posedge clk) disable iff (rst) (xmem_nerr[rerr_int] ||
                                                                            (xmem_serr[rerr_int] && !xmem_derr[rerr_int]) ||
                                                                            (!xmem_serr[rerr_int] && xmem_derr[rerr_int])));
  assume_xmem_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[rerr_int] && xmem_nerr_tmp) |-> ##SRAM_DELAY
                                           !t2_serrA[rerr_int] && !t2_derrA[rerr_int]);
  assume_xmem_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[rerr_int] && xmem_serr_tmp) |-> ##SRAM_DELAY
                                           t2_serrA[rerr_int] && !t2_derrA[rerr_int]);
  assume_xmem_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[rerr_int] && xmem_derr_tmp) |-> ##SRAM_DELAY
                                           ENAPAR ? t2_serrA[rerr_int] && t2_derrA[rerr_int] :
                                           ENAECC ? t2_derrA[rerr_int] : 1'b0);
end
endgenerate

wire [NUMVBNK-1:0] wr_nerr;
wire [NUMVBNK-1:0] wr_serr;
genvar werr_int;
generate for (werr_int=0; werr_int<NUMVBNK; werr_int=werr_int+1) begin: werr_loop
  assign wr_nerr[werr_int] = !wr_serr[werr_int];
  assign wr_serr[werr_int] = 1'b0;
end
endgenerate

wire xwr_serr = 1'b0;
wire xwr_nerr = !xwr_serr;

reg cflt [0:NUMVRPT-1];
reg cflt_serr [0:NUMVRPT-1];
reg cflt_derr [0:NUMVRPT-1];
reg [BITPBNK-1:0] cflt_pbnk [0:NUMVRPT-1];
reg [31:0] cflt_pbnk_wire [0:NUMVRPT-1];
integer vrdr_int, vrdb_int;
always_comb
  for (vrdr_int=1; vrdr_int<NUMVRPT; vrdr_int=vrdr_int+2) begin
    cflt[vrdr_int] = read_wire[vrdr_int-1] && read_wire[vrdr_int] && (rd_bnk_wire[vrdr_int-1] == rd_bnk_wire[vrdr_int]);
    cflt_serr[vrdr_int] = ENAPAR ? xmem_serr_wire[vrdr_int>>1] || xmem_derr_wire[vrdr_int>>1] : xmem_serr_wire[vrdr_int>>1];
    cflt_derr[vrdr_int] = xmem_derr_wire[vrdr_int>>1];
    cflt_pbnk[vrdr_int] = (xmem_serr_wire[vrdr_int>>1] || xmem_derr_wire[vrdr_int>>1]) ? NUMVBNK : 0;
    for (vrdb_int=NUMVBNK-1; vrdb_int>=0; vrdb_int=vrdb_int-1)
      if (vrdb_int != rd_bnk_wire[vrdr_int])
        if (ENAPAR) begin
          if (mem_derr_wire[vrdr_int>>1][vrdb_int] || (mem_serr_wire[vrdr_int>>1][vrdb_int] && cflt_serr[vrdr_int])) begin
            cflt_serr[vrdr_int] = 1'b1;
            cflt_derr[vrdr_int] = 1'b1;
            cflt_pbnk[vrdr_int] = vrdb_int;
          end
          if (mem_serr_wire[vrdr_int>>1][vrdb_int]) begin
            cflt_serr[vrdr_int] = 1'b1;
            cflt_pbnk[vrdr_int] = vrdb_int;
          end
        end else if (ENAECC) begin
          if (mem_derr_wire[vrdr_int>>1][vrdb_int]) begin
            cflt_derr[vrdr_int] = 1'b1;
            cflt_pbnk[vrdr_int] = vrdb_int;
          end
          if (mem_serr_wire[vrdr_int>>1][vrdb_int]) begin
            cflt_serr[vrdr_int] = 1'b1;
            if (!cflt_derr[vrdr_int])
              cflt_pbnk[vrdr_int] = vrdb_int;
          end
        end
  end

reg [NUMVBNK-1:0] meminv;
reg [NUMVBNK-1:0] mem;
integer mem_int;
always @(posedge clk)
  for (mem_int=0; mem_int<NUMVBNK; mem_int=mem_int+1)
    if (!ready) begin
      meminv[mem_int] <= 1'b0;
      mem[mem_int] <= 0;
    end else if (t1_writeA_wire[mem_int] && (t1_addrA_wire[0][mem_int] == select_vrow)) begin
      meminv[mem_int] <= wr_serr[mem_int];
      mem[mem_int] <= t1_dinA_wire[mem_int][select_bit];
    end
      
reg xmeminv;
reg xmem;
always @(posedge clk)
  if (!ready) begin
    xmeminv <= 1'b0;
    xmem <= 0;
  end else if (t2_writeA && (t2_addrA_wire[0] == select_vrow)) begin
    xmeminv <= xwr_serr;
    xmem <= t2_dinA[select_bit];
  end

wire xor_mem = ^mem;

genvar memr_int, memb_int;
generate for (memr_int=0; memr_int<NUMPRPT; memr_int=memr_int+1) begin: memr_loop
  for (memb_int=0; memb_int<NUMVBNK; memb_int=memb_int+1) begin: memb_loop
    assert_pdout_check: assert property (@(posedge clk) disable iff (rst)
					 (t1_readA_wire[memr_int][memb_int] && (t1_addrA_wire[memr_int][memb_int] == select_vrow)) |-> ##SRAM_DELAY
//					 (t1_doutA[(memb_int*NUMPRPT+memr_int)*WIDTH+select_bit] == $past(mem[memb_int],SRAM_DELAY)));
                                         ((!t1_fwrdA[memb_int*NUMPRPT+memr_int] && (ENAPAR ? t1_serrA[memb_int*NUMPRPT+memr_int] :
                                                                                    ENAECC ? t1_derrA[memb_int*NUMPRPT+memr_int] : 1'b0)) ||
                                          ((memr_int>0) && ($past(meminv[memb_int],SRAM_DELAY))) ||
					  (t1_doutA[(memb_int*NUMPRPT+memr_int)*WIDTH+select_bit] == $past(mem[memb_int],SRAM_DELAY))));
  end
  assert_xdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[memr_int] && (t2_addrA_wire[memr_int] == select_vrow)) |-> ##SRAM_DELAY
//                                       (t2_doutA[memr_int*WIDTH+select_bit] == $past(xmem,SRAM_DELAY)));
                                       ((!t2_fwrdA[memr_int] && (ENAPAR ? t2_serrA[memr_int] : ENAECC ? t2_derrA[memr_int] : 1'b0)) ||
                                        ((memr_int>0) && ($past(xmeminv,SRAM_DELAY))) ||
					(t2_doutA[memr_int*WIDTH+select_bit] == $past(xmem,SRAM_DELAY))));
end
endgenerate

assert_xwrite_req_check: assert property (@(posedge clk) disable iff (!ready) 1'b1 |-> ##(SRAM_DELAY+FLOPIN)
                                          ($past((write && (wr_adr < NUMADDR)),SRAM_DELAY+FLOPIN) == core.xwrite_req));
reg xmem_req_inv;
reg xmem_req;
always @(posedge clk)
  if (!ready) begin
    xmem_req_inv <= 1'b0;
    xmem_req <= 0;
  end else if (core.xwrite_req && (core.xwrradr_req == select_vrow)) begin
    xmem_req_inv <= ENAPAR ? core.xserr_req : ENAECC ? core.xderr_req : 1'b0;
    xmem_req <= core.xdin_req[select_bit];
  end

genvar xorr_int;
generate for (xorr_int=0; xorr_int<NUMPRPT; xorr_int=xorr_int+1) begin: xorr_loop
  assert_xmem_req_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[xorr_int] && (t2_addrA_wire[xorr_int] == select_vrow)) |-> ##1
				          (xmem_req == (core.xrd_srch_flag[xorr_int] ? core.xrd_srch_data[xorr_int][select_bit] : xmem)));

  assert_xor_int_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[xorr_int] && (t2_addrA_wire[xorr_int] == select_vrow)) |-> ##SRAM_DELAY
				         ((!t2_fwrdA[xorr_int] && !core.xor_fwd_data[xorr_int] && (ENAPAR ? t2_serrA[xorr_int] : ENAECC ? t2_derrA[xorr_int] : 1'b0)) ||
                                          (core.xor_data[xorr_int][select_bit] == xmem_req)));

  assert_xor_more_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[xorr_int] && (t2_addrA_wire[xorr_int] == select_vrow)) |-> ##SRAM_DELAY
				          (xmem_req_inv ||
                                           (!t2_fwrdA[xorr_int] && !core.xor_fwd_data[xorr_int] && (ENAPAR ? t2_serrA[xorr_int] : ENAECC ? t2_derrA[xorr_int] : 1'b0)) ||
                                           (core.xor_data[xorr_int][select_bit] == ($past(xor_mem,SRAM_DELAY)))));
end
endgenerate

  assert_xor_data_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##SRAM_DELAY
                                          (xmem_req_inv || (xmem_req == ($past(xor_mem,SRAM_DELAY)))));

reg fakexor_inv;
always @(posedge clk)
  if (!ready)
    fakexor_inv <= 1'b0;
  else if (write && (wr_adr < NUMADDR) && (wr_row == select_vrow)) 
    fakexor_inv <= ENAPAR ? (|mem_serr_wire[0] || |mem_derr_wire[0]) : ENAECC ? |mem_derr_wire[0] : 1'b0;

reg fakemem;
always @(posedge clk)
  if (!ready)
    fakemem <= 1'b0;
  else if (write && (wr_adr == select_addr))
    fakemem <= din[select_bit];

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##FLOPIN ((FLOPIN ? $past(fakemem) : fakemem) == mem[select_bank]));

genvar doutr_int;
generate for (doutr_int=0; doutr_int<NUMVRPT; doutr_int=doutr_int+1) begin: doutr_loop

  assert_vld_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##MEM_DELAY
                                     rd_vld_wire[doutr_int]);

  if (doutr_int[0] == 1'b0) begin: even_loop
    assert_dout_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && mem_nerr_wire[doutr_int>>1][select_bank]) |-> ##MEM_DELAY
                                             (rd_dbit_wire[doutr_int] == $past(fakemem,MEM_DELAY)));
    assert_dout_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && mem_serr_wire[doutr_int>>1][select_bank]) |-> ##MEM_DELAY
                                             ((ENAPAR && !rd_fwrd_wire[doutr_int]) || (rd_dbit_wire[doutr_int] == $past(fakemem,MEM_DELAY))));
    assert_dout_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && mem_derr_wire[doutr_int>>1][select_bank]) |-> ##MEM_DELAY
                                             (!rd_fwrd_wire[doutr_int] || (rd_dbit_wire[doutr_int] == $past(fakemem,MEM_DELAY))));

    assert_derr_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && mem_nerr_wire[doutr_int>>1][select_bank]) |-> ##MEM_DELAY
                                             (!rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_derr_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && mem_serr_wire[doutr_int>>1][select_bank]) |-> ##MEM_DELAY
					     (rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_derr_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && mem_derr_wire[doutr_int>>1][select_bank]) |-> ##MEM_DELAY
					     ENAPAR ? rd_serr_wire[doutr_int] && rd_derr_wire[doutr_int] : rd_derr_wire[doutr_int]);

    if (FLOPOUT) begin: flp_loop
      assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##MEM_DELAY
					  (rd_fwrd_wire[doutr_int] == $past(t1_fwrdA_sel[doutr_int>>1])));
      assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##MEM_DELAY
					  (rd_padr_wire[doutr_int] == {select_bank,$past(t1_padrA_sel[doutr_int>>1])}));
    end else begin: noflp_loop
      assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##MEM_DELAY
					  (rd_fwrd_wire[doutr_int] == t1_fwrdA_sel[doutr_int>>1]));
      assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr)) |-> ##MEM_DELAY
					  (rd_padr_wire[doutr_int] == {select_bank,t1_padrA_sel[doutr_int>>1]}));
    end

  end else begin: odd_loop

    assert_dout_ncfl_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && mem_nerr_wire[doutr_int>>1][select_bank]) |-> ##MEM_DELAY
						  (rd_dbit_wire[doutr_int] == $past(fakemem,MEM_DELAY)));
    assert_dout_ncfl_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && mem_serr_wire[doutr_int>>1][select_bank]) |-> ##MEM_DELAY
						  ((ENAPAR && !rd_fwrd_wire[doutr_int]) || (rd_dbit_wire[doutr_int] == $past(fakemem,MEM_DELAY))));
    assert_dout_ncfl_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && mem_derr_wire[doutr_int>>1][select_bank]) |-> ##MEM_DELAY
						  (!rd_fwrd_wire[doutr_int] || (rd_dbit_wire[doutr_int] == $past(fakemem,MEM_DELAY))));

    assert_derr_ncfl_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && mem_nerr_wire[doutr_int>>1][select_bank]) |-> ##MEM_DELAY
						  (!rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_derr_ncfl_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && mem_serr_wire[doutr_int>>1][select_bank]) |-> ##MEM_DELAY
					          (rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_derr_ncfl_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && mem_derr_wire[doutr_int>>1][select_bank]) |-> ##MEM_DELAY
					          ENAPAR ? rd_serr_wire[doutr_int] && rd_derr_wire[doutr_int] : rd_derr_wire[doutr_int]);

    assert_dout_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && &(mem_nerr_wire[doutr_int>>1] | (1'b1 << select_bank)) && xmem_nerr_wire[doutr_int>>1]) |-> ##MEM_DELAY
                                                  ($past(fakexor_inv,MEM_DELAY) || (rd_dbit_wire[doutr_int] == $past(fakemem,MEM_DELAY))));
    assert_dout_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|(mem_serr_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_serr_wire[doutr_int>>1]) && !(|(mem_derr_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_derr_wire[doutr_int>>1])) |-> ##MEM_DELAY
					          ($past(fakexor_inv,MEM_DELAY) || (ENAPAR && !rd_fwrd_wire[doutr_int]) || (rd_dbit_wire[doutr_int] == $past(fakemem,MEM_DELAY))));
    assert_dout_cflt_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|(mem_derr_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_derr_wire[doutr_int>>1])) |-> ##MEM_DELAY
					          ($past(fakexor_inv,MEM_DELAY) || !rd_fwrd_wire[doutr_int] || (rd_dbit_wire[doutr_int] == $past(fakemem,MEM_DELAY))));

    assert_derr_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && &(mem_nerr_wire[doutr_int>>1] | (1'b1 << select_bank)) && xmem_nerr_wire[doutr_int>>1]) |-> ##MEM_DELAY
					           (!rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_derr_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|(mem_serr_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_serr_wire[doutr_int>>1]) && ~(|(mem_derr_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_derr_wire[doutr_int>>1])) |-> ##MEM_DELAY
					          ((rd_serr_wire[doutr_int] == ($past(cflt_serr[doutr_int],MEM_DELAY))) &&
					           (rd_derr_wire[doutr_int] == ($past(cflt_derr[doutr_int],MEM_DELAY)))));
    assert_derr_cflt_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|(mem_derr_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_derr_wire[doutr_int>>1])) |-> ##MEM_DELAY
					          ((ENAECC || (rd_serr_wire[doutr_int] == ($past(cflt_serr[doutr_int],MEM_DELAY)))) &&
					           (rd_derr_wire[doutr_int] == ($past(cflt_derr[doutr_int],MEM_DELAY)))));

    if (FLOPOUT) begin: flp_loop
      assert_fwrd_ncfl_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int]) |-> ##MEM_DELAY
					       (rd_fwrd_wire[doutr_int] == $past(t1_fwrdA_sel[doutr_int>>1],FLOPOUT)));
      assert_fwrd_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && &(mem_nerr_wire[doutr_int>>1] | (1'b1 << select_bank)) && xmem_nerr_wire[doutr_int>>1]) |-> ##MEM_DELAY
				                    (rd_fwrd_wire[doutr_int] == $past(|(t1_fwrdA_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) ||
                                                                                      t2_fwrdA_sel[doutr_int>>1] || xor_fwd_data_sel[doutr_int>>1])));
      assert_fwrd_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|mem_serr_wire[doutr_int>>1] || xmem_serr_wire[doutr_int>>1])) |-> ##MEM_DELAY
						    (rd_fwrd_wire[doutr_int] == $past((|(t1_fwrdA_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) ||
                                                                                       t2_fwrdA_sel[doutr_int>>1] || xor_fwd_data_sel[doutr_int>>1]) &&
                                                                                      !(|(~t1_fwrdA_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}} &
                                                                                          (ENAPAR ? t1_serrA_sel_wire[doutr_int>>1] | t1_derrA_sel_wire[doutr_int>>1] :
                                                                                                    t1_derrA_sel_wire[doutr_int>>1])) ||
                                                                                        (!t2_fwrdA_sel[doutr_int>>1] && !xor_fwd_data_sel[doutr_int>>1] &&
                                                                                         ((ENAPAR && t2_serrA[doutr_int>>1]) || t2_derrA[doutr_int>>1]))))));
      assert_fwrd_cflt_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|mem_derr_wire[doutr_int>>1] || xmem_derr_wire[doutr_int>>1])) |-> ##MEM_DELAY
						    (rd_fwrd_wire[doutr_int] == $past((|(t1_fwrdA_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) ||
                                                                                       t2_fwrdA_sel[doutr_int>>1] || xor_fwd_data_sel[doutr_int>>1]) &&
                                                                                      !(|(~t1_fwrdA_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}} &
                                                                                          (ENAPAR ? t1_serrA_sel_wire[doutr_int>>1] | t1_derrA_sel_wire[doutr_int>>1] :
                                                                                                    t1_derrA_sel_wire[doutr_int>>1])) ||
                                                                                        (!t2_fwrdA_sel[doutr_int>>1] && !xor_fwd_data_sel[doutr_int>>1] &&
                                                                                         ((ENAPAR && t2_serrA[doutr_int>>1]) || t2_derrA[doutr_int>>1]))))));
      assert_padr_ncfl_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int]) |-> ##MEM_DELAY
					       (rd_padr_wire[doutr_int] == {select_bank,$past(t1_padrA_sel[doutr_int>>1],FLOPOUT)}));
      assert_padr_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && &(mem_nerr_wire[doutr_int>>1] | (1'b1 << select_bank)) && xmem_nerr_wire[doutr_int>>1]) |-> ##MEM_DELAY
						    (rd_padr_wire[doutr_int] == {NUMVBNK,$past(t2_padrA_sel[doutr_int>>1],FLOPOUT)}));
      assert_padr_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|(mem_serr_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_serr_wire[doutr_int>>1]) && !(|(mem_derr_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_derr_wire[doutr_int>>1])) |-> ##MEM_DELAY
       ((($past(cflt_pbnk[doutr_int],MEM_DELAY)==NUMVBNK) && (rd_padr_wire[doutr_int] == ((NUMVBNK << (BITPADR-BITPBNK) | $past(t2_padrA_sel[doutr_int>>1],FLOPOUT))))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==0) &&       (rd_padr_wire[doutr_int] == ((0 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][0],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==1) &&       (rd_padr_wire[doutr_int] == ((1 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][1],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==2) &&       (rd_padr_wire[doutr_int] == ((2 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][2],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==3) &&       (rd_padr_wire[doutr_int] == ((3 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][3],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==4) &&       (rd_padr_wire[doutr_int] == ((4 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][4],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==5) &&       (rd_padr_wire[doutr_int] == ((5 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][5],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==6) &&       (rd_padr_wire[doutr_int] == ((6 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][6],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==7) &&       (rd_padr_wire[doutr_int] == ((7 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][7],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==8) &&       (rd_padr_wire[doutr_int] == ((8 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][8],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==9) &&       (rd_padr_wire[doutr_int] == ((9 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][9],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==10) &&      (rd_padr_wire[doutr_int] == ((10 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][10],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==11) &&      (rd_padr_wire[doutr_int] == ((11 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][11],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==12) &&      (rd_padr_wire[doutr_int] == ((12 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][12],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==13) &&      (rd_padr_wire[doutr_int] == ((13 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][13],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==14) &&      (rd_padr_wire[doutr_int] == ((14 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][14],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==15) &&      (rd_padr_wire[doutr_int] == ((15 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][15],FLOPOUT))))));
//                                                                                    (($past(cflt_pbnk[doutr_int],MEM_DELAY)==NUMVBNK) ?
//                                                                                     $past(t2_padrA_sel[doutr_int>>1],FLOPOUT) :
//                                                                                     $past(t1_padrA_sel_wire[doutr_int>>1][$past(cflt_pbnk[doutr_int],MEM_DELAY)],FLOPOUT))}))));
      assert_padr_cflt_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|(mem_derr_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_derr_wire[doutr_int>>1])) |-> ##MEM_DELAY
       ((($past(cflt_pbnk[doutr_int],MEM_DELAY)==NUMVBNK) && (rd_padr_wire[doutr_int] == ((NUMVBNK << (BITPADR-BITPBNK) | $past(t2_padrA_sel[doutr_int>>1],FLOPOUT))))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==0) &&       (rd_padr_wire[doutr_int] == ((0 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][0],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==1) &&       (rd_padr_wire[doutr_int] == ((1 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][1],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==2) &&       (rd_padr_wire[doutr_int] == ((2 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][2],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==3) &&       (rd_padr_wire[doutr_int] == ((3 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][3],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==4) &&       (rd_padr_wire[doutr_int] == ((4 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][4],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==5) &&       (rd_padr_wire[doutr_int] == ((5 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][5],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==6) &&       (rd_padr_wire[doutr_int] == ((6 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][6],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==7) &&       (rd_padr_wire[doutr_int] == ((7 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][7],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==8) &&       (rd_padr_wire[doutr_int] == ((8 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][8],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==9) &&       (rd_padr_wire[doutr_int] == ((9 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][9],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==10) &&      (rd_padr_wire[doutr_int] == ((10 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][10],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==11) &&      (rd_padr_wire[doutr_int] == ((11 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][11],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==12) &&      (rd_padr_wire[doutr_int] == ((12 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][12],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==13) &&      (rd_padr_wire[doutr_int] == ((13 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][13],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==14) &&      (rd_padr_wire[doutr_int] == ((14 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][14],FLOPOUT)))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==15) &&      (rd_padr_wire[doutr_int] == ((15 << (BITPADR-BITPBNK)) | $past(t1_padrA_sel_wire[doutr_int>>1][15],FLOPOUT))))));
//                                                                                    (($past(cflt_pbnk[doutr_int],MEM_DELAY)==NUMVBNK) ?
//                                                                                     $past(t2_padrA_sel[doutr_int>>1],FLOPOUT) :
//                                                                                     $past(t1_padrA_sel_wire[doutr_int>>1][$past(cflt_pbnk[doutr_int],MEM_DELAY)],FLOPOUT))}))));
    end else begin: noflp_loop
      assert_fwrd_ncfl_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int]) |-> ##MEM_DELAY
					       (rd_fwrd_wire[doutr_int] == t1_fwrdA_sel[doutr_int>>1]));
      assert_fwrd_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && &(mem_nerr_wire[doutr_int>>1] | (1'b1 << select_bank)) && xmem_nerr_wire[doutr_int>>1]) |-> ##MEM_DELAY
						    (rd_fwrd_wire[doutr_int] == (|(t1_fwrdA_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) ||
                                                                                 t2_fwrdA_sel[doutr_int>>1] || xor_fwd_data_sel[doutr_int>>1])));
      assert_fwrd_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|mem_serr_wire[doutr_int>>1] || xmem_serr_wire[doutr_int>>1])) |-> ##MEM_DELAY
						    (rd_fwrd_wire[doutr_int] == ((|(t1_fwrdA_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) ||
                                                                                  t2_fwrdA_sel[doutr_int>>1] || xor_fwd_data_sel[doutr_int>>1]) &&
                                                                                 !(|(~t1_fwrdA_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}} &
                                                                                     (ENAPAR ? t1_serrA_sel_wire[doutr_int>>1] | t1_derrA_sel_wire[doutr_int>>1] :
                                                                                               t1_derrA_sel_wire[doutr_int>>1])) ||
                                                                                   (!t2_fwrdA_sel[doutr_int>>1] && !xor_fwd_data_sel[doutr_int>>1] &&
                                                                                    ((ENAPAR && t2_serrA[doutr_int>>1]) || t2_derrA[doutr_int>>1]))))));
      assert_fwrd_cflt_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|mem_derr_wire[doutr_int>>1] || xmem_derr_wire[doutr_int>>1])) |-> ##MEM_DELAY
						    (rd_fwrd_wire[doutr_int] == ((|(t1_fwrdA_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) ||
                                                                                  t2_fwrdA_sel[doutr_int>>1] || xor_fwd_data_sel[doutr_int>>1]) &&
                                                                                 !(|(~t1_fwrdA_sel_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}} &
                                                                                     (ENAPAR ? t1_serrA_sel_wire[doutr_int>>1] | t1_derrA_sel_wire[doutr_int>>1] :
                                                                                               t1_derrA_sel_wire[doutr_int>>1])) ||
                                                                                   (!t2_fwrdA_sel[doutr_int>>1] && !xor_fwd_data_sel[doutr_int>>1] &&
                                                                                    ((ENAPAR && t2_serrA[doutr_int>>1]) || t2_derrA[doutr_int>>1]))))));
      assert_padr_ncfl_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int]) |-> ##MEM_DELAY
					       (rd_padr_wire[doutr_int] == {select_bank,t1_padrA_sel[doutr_int>>1]}));
      assert_padr_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && &(mem_nerr_wire[doutr_int>>1] | (1'b1 << select_bank)) && xmem_nerr_wire[doutr_int>>1]) |-> ##MEM_DELAY
						    (rd_padr_wire[doutr_int] == {NUMVBNK,t2_padrA_sel[doutr_int>>1]}));
      assert_padr_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|(mem_serr_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_serr_wire[doutr_int>>1]) && !(|(mem_derr_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_derr_wire[doutr_int>>1])) |-> ##MEM_DELAY
       ((($past(cflt_pbnk[doutr_int],MEM_DELAY)==NUMVBNK) && (rd_padr_wire[doutr_int] == ((NUMVBNK << (BITPADR-BITPBNK) | t2_padrA_sel[doutr_int>>1])))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==0) &&       (rd_padr_wire[doutr_int] == ((0 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][0]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==1) &&       (rd_padr_wire[doutr_int] == ((1 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][1]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==2) &&       (rd_padr_wire[doutr_int] == ((2 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][2]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==3) &&       (rd_padr_wire[doutr_int] == ((3 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][3]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==4) &&       (rd_padr_wire[doutr_int] == ((4 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][4]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==5) &&       (rd_padr_wire[doutr_int] == ((5 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][5]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==6) &&       (rd_padr_wire[doutr_int] == ((6 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][6]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==7) &&       (rd_padr_wire[doutr_int] == ((7 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][7]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==8) &&       (rd_padr_wire[doutr_int] == ((8 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][8]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==9) &&       (rd_padr_wire[doutr_int] == ((9 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][9]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==10) &&      (rd_padr_wire[doutr_int] == ((10 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][10]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==11) &&      (rd_padr_wire[doutr_int] == ((11 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][11]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==12) &&      (rd_padr_wire[doutr_int] == ((12 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][12]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==13) &&      (rd_padr_wire[doutr_int] == ((13 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][13]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==14) &&      (rd_padr_wire[doutr_int] == ((14 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][14]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==15) &&      (rd_padr_wire[doutr_int] == ((15 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][15])))));
//                                                                                    (($past(cflt_pbnk[doutr_int],MEM_DELAY)==NUMVBNK) ?
//                                                                                     t2_padrA_sel[doutr_int>>1] :
//                                                                                     t1_padrA_sel_wire[doutr_int>>1][$past(cflt_pbnk[doutr_int],MEM_DELAY)])}))));
      assert_padr_cflt_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && (rd_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (|(mem_derr_wire[doutr_int>>1] & ~(1'b1 << select_bank) & {NUMVBNK{1'b1}}) || xmem_derr_wire[doutr_int>>1])) |-> ##MEM_DELAY
       ((($past(cflt_pbnk[doutr_int],MEM_DELAY)==NUMVBNK) && (rd_padr_wire[doutr_int] == ((NUMVBNK << (BITPADR-BITPBNK) | t2_padrA_sel[doutr_int>>1])))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==0) &&       (rd_padr_wire[doutr_int] == ((0 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][0]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==1) &&       (rd_padr_wire[doutr_int] == ((1 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][1]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==2) &&       (rd_padr_wire[doutr_int] == ((2 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][2]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==3) &&       (rd_padr_wire[doutr_int] == ((3 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][3]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==4) &&       (rd_padr_wire[doutr_int] == ((4 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][4]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==5) &&       (rd_padr_wire[doutr_int] == ((5 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][5]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==6) &&       (rd_padr_wire[doutr_int] == ((6 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][6]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==7) &&       (rd_padr_wire[doutr_int] == ((7 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][7]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==8) &&       (rd_padr_wire[doutr_int] == ((8 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][8]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==9) &&       (rd_padr_wire[doutr_int] == ((9 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][9]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==10) &&      (rd_padr_wire[doutr_int] == ((10 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][10]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==11) &&      (rd_padr_wire[doutr_int] == ((11 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][11]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==12) &&      (rd_padr_wire[doutr_int] == ((12 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][12]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==13) &&      (rd_padr_wire[doutr_int] == ((13 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][13]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==14) &&      (rd_padr_wire[doutr_int] == ((14 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][14]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==15) &&      (rd_padr_wire[doutr_int] == ((15 << (BITPADR-BITPBNK)) | t1_padrA_sel_wire[doutr_int>>1][15])))));
//                                                                                    (($past(cflt_pbnk[doutr_int],MEM_DELAY)==NUMVBNK) ?
//                                                                                     t2_padrA_sel[doutr_int>>1] :
//                                                                                     t1_padrA_sel_wire[doutr_int>>1][$past(cflt_pbnk[doutr_int],MEM_DELAY)])}))));
    end
  end
end
endgenerate

endmodule


