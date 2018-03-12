module ip_top_sva_2_nr1w_2rw
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
  input [NUMVRPT-1:0] read2,
  input [NUMVRPT*BITADDR-1:0] addr2,
  input write1,
  input read1,
  input [BITADDR-1:0]  addr1,
  input [NUMPRPT*NUMVBNK-1:0] t1_readA,
  input [NUMPRPT*NUMVBNK-1:0] t1_writeA,
  input [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMPRPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMPRPT*NUMVBNK-1:0] t1_readB,
  input [NUMPRPT*NUMVBNK-1:0] t1_writeB,
  input [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMPRPT*NUMVBNK*WIDTH-1:0] t1_dinB,
  input [NUMPRPT-1:0] t2_readA,
  input [NUMPRPT-1:0] t2_writeA,
  input [NUMPRPT*BITVROW-1:0] t2_addrA,
  input [NUMPRPT*WIDTH-1:0] t2_dinA,
  input [NUMPRPT-1:0] t2_readB,
  input [NUMPRPT-1:0] t2_writeB,
  input [NUMPRPT*BITVROW-1:0] t2_addrB,
  input [NUMPRPT*WIDTH-1:0] t2_dinB
);

assert_rw1_check: assume property (@(posedge clk) disable iff (rst) !(write1 && read1));
assert_rw1_range_check: assume property (@(posedge clk) disable iff (rst) (write1 || read1) |-> (addr1 < NUMADDR));
genvar rd_int;
generate for (rd_int=0; rd_int<NUMVRPT; rd_int=rd_int+1) begin: rd_loop
  wire read_wire = read2 >> rd_int;
  wire [BITADDR-1:0] addr_wire = addr2 >> (rd_int*BITADDR);

  assert_rd2_range_check: assume property (@(posedge clk) disable iff (rst) read_wire |-> (addr_wire < NUMADDR));
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

    assert_t1A_1port_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA_wire && t1_writeA_wire));
    assert_t1A_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire || t1_writeA_wire) |-> (t1_addrA_wire < NUMVROW));
    assert_t1A_wr_same_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |->
					       (t1_writeA_0_wire && (t1_addrA_0_wire == t1_addrA_wire) && (t1_dinA_0_wire == t1_dinA_wire))); 

    wire t1_readB_wire = t1_readB >> (NUMPRPT*t1_vbnk_int+t1_prpt_int);
    wire t1_writeB_wire = t1_writeB >> (NUMPRPT*t1_vbnk_int+t1_prpt_int);
    wire [BITVROW-1:0] t1_addrB_wire = t1_addrB >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*BITVROW);

    assert_t1B_1port_check: assert property (@(posedge clk) disable iff (rst) !(t1_readB_wire && t1_writeB_wire));
    assert_t1B_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire || t1_writeB_wire) |-> (t1_addrB_wire < NUMVROW));
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

  assert_t2A_1port_check: assert property (@(posedge clk) disable iff (rst) !(t2_readA_wire && t2_writeA_wire));
  assert_t2A_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire || t2_writeA_wire) |-> (t2_addrA_wire < NUMVROW));
  assert_t2A_wr_same_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |->
					     (t2_writeA_0_wire && (t2_addrA_0_wire == t2_addrA_wire) && (t2_dinA_0_wire == t2_dinA_wire))); 

  wire t2_readB_wire = t2_readB >> t2_prpt_int;
  wire t2_writeB_wire = t2_writeB >> t2_prpt_int;
  wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2_prpt_int*BITVROW);

  assert_t2B_1port_check: assert property (@(posedge clk) disable iff (rst) !(t2_readB_wire && t2_writeB_wire));
  assert_t2B_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire || t2_writeB_wire) |-> (t2_addrB_wire < NUMVROW));
end
endgenerate

endmodule


module ip_top_sva_nr1w_2rw
  #(parameter
     WIDTH = 32,
     NUMVRPT = 2,
     NUMPRPT = 1,
     NUMADDR = 8192,
     BITADDR = 13,
     BITWDTH = 5,
     NUMVBNK = 8,
     BITVBNK = 3,
     BITPBNK = 4,
     NUMVROW = 8,
     BITVROW = 3,
     BITPADR = 15,
     SRAM_DELAY = 2,
     FLOPIN = 0,
     FLOPOUT = 0,
     MEM_DELAY = SRAM_DELAY+FLOPIN+FLOPOUT
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
  input [NUMPRPT*NUMVBNK-1:0] t1_serrA,
  input [NUMPRPT*NUMVBNK-1:0] t1_derrA,
  input [NUMPRPT*NUMVBNK*(BITPADR-BITPBNK-1)-1:0] t1_padrA,
  input [NUMPRPT*NUMVBNK-1:0] t1_readB,
  input [NUMPRPT*NUMVBNK-1:0] t1_writeB,
  input [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMPRPT*NUMVBNK*WIDTH-1:0] t1_dinB,
  input [NUMPRPT*NUMVBNK*WIDTH-1:0] t1_doutB,
  input [NUMPRPT*NUMVBNK-1:0] t1_serrB,
  input [NUMPRPT*NUMVBNK-1:0] t1_derrB,
  input [NUMPRPT*NUMVBNK*(BITPADR-BITPBNK-1)-1:0] t1_padrB,
  input [NUMPRPT-1:0] t2_readA,
  input [NUMPRPT-1:0] t2_writeA,
  input [NUMPRPT*BITVROW-1:0] t2_addrA,
  input [NUMPRPT*WIDTH-1:0] t2_dinA,
  input [NUMPRPT*WIDTH-1:0] t2_doutA,
  input [NUMPRPT-1:0] t2_serrA,
  input [NUMPRPT-1:0] t2_derrA,
  input [NUMPRPT*(BITPADR-BITPBNK-1)-1:0] t2_padrA,
  input [NUMPRPT-1:0] t2_readB,
  input [NUMPRPT-1:0] t2_writeB,
  input [NUMPRPT*BITVROW-1:0] t2_addrB,
  input [NUMPRPT*WIDTH-1:0] t2_dinB,
  input [NUMPRPT*WIDTH-1:0] t2_doutB,
  input [NUMPRPT-1:0] t2_serrB,
  input [NUMPRPT-1:0] t2_derrB,
  input [NUMPRPT*(BITPADR-BITPBNK-1)-1:0] t2_padrB,
  input write1,
  input read1,
  input [BITADDR-1:0] addr1,
  input [WIDTH-1:0] din1,
  input [WIDTH-1:0] rd1_dout,
  input rd1_serr,
  input rd1_derr,
  input [BITPADR-1:0] rd1_padr,
  input [NUMVRPT*BITADDR-1:0] addr2,
  input [NUMVRPT-1:0] read2,
  input [NUMVRPT-1:0] rd2_vld,
  input [NUMVRPT*WIDTH-1:0] rd2_dout,
  input [NUMVRPT-1:0] rd2_serr,
  input [NUMVRPT-1:0] rd2_derr,
  input [NUMVRPT*BITPADR-1:0] rd2_padr,
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

reg [BITPADR-BITPBNK-2:0] t1_padrA_sel [0:NUMPRPT-1];
reg [BITPADR-BITPBNK-2:0] t1_padrB_sel [0:NUMPRPT-1];
reg [BITPADR-BITPBNK-2:0] t2_padrA_sel [0:NUMPRPT-1];
reg [BITPADR-BITPBNK-2:0] t2_padrB_sel [0:NUMPRPT-1];
reg [BITPADR-BITPBNK-2:0] t1_padrA_sel_wire [0:NUMPRPT-1][0:16-1];
reg [BITPADR-BITPBNK-2:0] t1_padrB_sel_wire [0:NUMPRPT-1][0:16-1];
integer padr_int, padb_int;
always_comb
  for (padr_int=0; padr_int<NUMPRPT; padr_int=padr_int+1) begin
    t1_padrA_sel[padr_int] = t1_padrA >> ((NUMPRPT*select_bank+padr_int)*(BITPADR-BITPBNK-1));
    t1_padrB_sel[padr_int] = t1_padrB >> ((NUMPRPT*select_bank+padr_int)*(BITPADR-BITPBNK-1));
    t2_padrA_sel[padr_int] = t2_padrA >> (padr_int*(BITPADR-BITPBNK-1));
    t2_padrB_sel[padr_int] = t2_padrB >> (padr_int*(BITPADR-BITPBNK-1));
    for (padb_int=0; padb_int<16; padb_int=padb_int+1) begin
      t1_padrA_sel_wire[padr_int][padb_int] = t1_padrA >> ((NUMPRPT*padb_int+padr_int)*(BITPADR-BITPBNK-1));
      t1_padrB_sel_wire[padr_int][padb_int] = t1_padrB >> ((NUMPRPT*padb_int+padr_int)*(BITPADR-BITPBNK-1));
    end
  end

reg t1_readA_wire [0:NUMPRPT-1][0:NUMVBNK-1];
reg t1_writeA_wire [0:NUMVBNK-1];
reg [BITVROW-1:0] t1_addrA_wire [0:NUMPRPT-1][0:NUMVBNK-1];
reg [WIDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];
reg [WIDTH-1:0] t1_doutA_wire [0:NUMVBNK-1];
reg [BITPADR-BITPBNK-2:0] t1_padrA_wire [0:NUMVBNK-1];
reg t1_readB_wire [0:NUMPRPT-1][0:NUMVBNK-1];
reg t1_writeB_wire [0:NUMVBNK-1];
reg [BITVROW-1:0] t1_addrB_wire [0:NUMPRPT-1][0:NUMVBNK-1];
reg [WIDTH-1:0] t1_dinB_wire [0:NUMVBNK-1];
reg [WIDTH-1:0] t1_doutB_wire [0:NUMVBNK-1];
reg [BITPADR-BITPBNK-2:0] t1_padrB_wire [0:NUMVBNK-1];
integer t1_prpt_int, t1_vbnk_int;
always_comb
  for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin
    for (t1_prpt_int=0; t1_prpt_int<NUMPRPT; t1_prpt_int=t1_prpt_int+1) begin
      t1_readA_wire[t1_prpt_int][t1_vbnk_int] = t1_readA >> (NUMPRPT*t1_vbnk_int+t1_prpt_int);
      t1_addrA_wire[t1_prpt_int][t1_vbnk_int] = t1_addrA >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*BITVROW);
      t1_readB_wire[t1_prpt_int][t1_vbnk_int] = t1_readB >> (NUMPRPT*t1_vbnk_int+t1_prpt_int);
      t1_addrB_wire[t1_prpt_int][t1_vbnk_int] = t1_addrB >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*BITVROW);
    end
    t1_writeA_wire[t1_vbnk_int] = t1_writeA >> (NUMPRPT*t1_vbnk_int);
    t1_dinA_wire[t1_vbnk_int] = t1_dinA >> (NUMPRPT*t1_vbnk_int*WIDTH);
    t1_doutA_wire[t1_vbnk_int] = t1_doutA >> (NUMPRPT*t1_vbnk_int*WIDTH);
    t1_padrA_wire[t1_vbnk_int] = t1_padrA >> (NUMPRPT*t1_vbnk_int*(BITPADR-BITPBNK-1));
    t1_writeB_wire[t1_vbnk_int] = t1_writeB >> (NUMPRPT*t1_vbnk_int);
    t1_dinB_wire[t1_vbnk_int] = t1_dinB >> (NUMPRPT*t1_vbnk_int*WIDTH);
    t1_doutB_wire[t1_vbnk_int] = t1_doutB >> (NUMPRPT*t1_vbnk_int*WIDTH);
    t1_padrB_wire[t1_vbnk_int] = t1_padrB >> (NUMPRPT*t1_vbnk_int*(BITPADR-BITPBNK-1));
  end

reg t2_readA_wire [0:NUMPRPT-1];
reg [BITVROW-1:0] t2_addrA_wire [0:NUMPRPT-1];
reg t2_readB_wire [0:NUMPRPT-1];
reg [BITVROW-1:0] t2_addrB_wire [0:NUMPRPT-1];
integer t2_prpt_int;
always_comb
  for (t2_prpt_int=0; t2_prpt_int<NUMPRPT; t2_prpt_int=t2_prpt_int+1) begin
    t2_readA_wire[t2_prpt_int] = t2_readA >> t2_prpt_int;
    t2_addrA_wire[t2_prpt_int] = t2_addrA >> (t2_prpt_int*BITVROW);
    t2_readB_wire[t2_prpt_int] = t2_readB >> t2_prpt_int;
    t2_addrB_wire[t2_prpt_int] = t2_addrB >> (t2_prpt_int*BITVROW);
  end

wire [BITVBNK-1:0] wr_bnk1;
wire [BITVROW-1:0] wr_row1;
np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
           .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
           .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  wr_np2 (.vbadr(wr_bnk1), .vradr(wr_row1), .vaddr(addr1));

wire read2_wire [0:NUMVRPT-1];
wire [BITADDR-1:0] rd2_adr_wire [0:NUMVRPT-1];
wire [BITVBNK-1:0] rd2_bnk_wire [0:NUMVRPT-1];
wire [BITVROW-1:0] rd2_row_wire [0:NUMVRPT-1];
wire rd2_vld_wire [0:NUMVRPT-1];
wire [WIDTH-1:0] rd2_dout_wire [0:NUMVRPT-1];
wire rd2_dbit_wire [0:NUMVRPT-1];
wire rd2_serr_wire [0:NUMVRPT-1];
wire rd2_derr_wire [0:NUMVRPT-1];
wire [BITPADR-1:0] rd2_padr_wire [0:NUMVRPT-1];
genvar rd_int;
generate for (rd_int=0; rd_int<NUMVRPT; rd_int=rd_int+1) begin: rd_loop
  assign read2_wire[rd_int] = read2 >> rd_int;
  assign rd2_adr_wire[rd_int] = addr2 >> (rd_int*BITADDR);
  np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
             .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
             .NUMVROW (NUMVROW), .BITVROW (BITVROW))
      rd_np2 (.vbadr(rd2_bnk_wire[rd_int]), .vradr(rd2_row_wire[rd_int]), .vaddr(rd2_adr_wire[rd_int]));

  assign rd2_vld_wire[rd_int] = rd2_vld >> rd_int;
  assign rd2_dout_wire[rd_int] = rd2_dout >> (rd_int*WIDTH);
  assign rd2_dbit_wire[rd_int] = rd2_dout_wire[rd_int][select_bit];
  assign rd2_serr_wire[rd_int] = rd2_serr >> rd_int;
  assign rd2_derr_wire[rd_int] = rd2_derr >> rd_int;
  assign rd2_padr_wire[rd_int] = rd2_padr >> (rd_int*BITPADR);
end
endgenerate

wire [NUMVBNK-1:0] memA_nerr [0:NUMPRPT-1];
wire [NUMVBNK-1:0] memA_serr [0:NUMPRPT-1];
wire [NUMVBNK-1:0] memA_derr [0:NUMPRPT-1];
wire xmemA_nerr [0:NUMPRPT-1];
wire xmemA_serr [0:NUMPRPT-1];
wire xmemA_derr [0:NUMPRPT-1];
wire [NUMVBNK-1:0] memB_nerr [0:NUMPRPT-1];
wire [NUMVBNK-1:0] memB_serr [0:NUMPRPT-1];
wire [NUMVBNK-1:0] memB_derr [0:NUMPRPT-1];
wire xmemB_nerr [0:NUMPRPT-1];
wire xmemB_serr [0:NUMPRPT-1];
wire xmemB_derr [0:NUMPRPT-1];
genvar rerr_int, berr_int;
generate for (rerr_int=0; rerr_int<NUMPRPT; rerr_int=rerr_int+1) begin: rerr_loop
  for (berr_int=0; berr_int<NUMVBNK; berr_int=berr_int+1) begin: berr_loop
    if (rerr_int==0) begin: memA_loop
      assign memA_nerr[rerr_int][berr_int] = !memA_serr[rerr_int][berr_int] && !memA_derr[rerr_int][berr_int];
      assign memA_serr[rerr_int][berr_int] = 1'b0;
      assign memA_derr[rerr_int][berr_int] = 1'b0;

      assume_memA_err_check: assert property (@(posedge clk) disable iff (rst) (memA_nerr[rerr_int][berr_int] ||
                                                                               (memA_serr[rerr_int][berr_int] && !memA_derr[rerr_int][berr_int]) ||
                                                                               (memA_serr[rerr_int][berr_int] && memA_derr[rerr_int][berr_int])));
      assume_memA_nerr_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire[rerr_int][berr_int] && memA_nerr[rerr_int][berr_int]) |-> ##SRAM_DELAY
                                              !t1_serrA[berr_int*NUMPRPT+rerr_int] && !t1_derrA[berr_int*NUMPRPT+rerr_int]);
      assume_memA_serr_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire[rerr_int][berr_int] && memA_serr[rerr_int][berr_int]) |-> ##SRAM_DELAY
                                              t1_serrA[berr_int*NUMPRPT+rerr_int] && !t1_derrA[berr_int*NUMPRPT+rerr_int]);
      assume_memA_derr_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire[rerr_int][berr_int] && memA_derr[rerr_int][berr_int]) |-> ##SRAM_DELAY
                                              t1_serrA[berr_int*NUMPRPT+rerr_int] && t1_derrA[berr_int*NUMPRPT+rerr_int]);
    end

    assign memB_nerr[rerr_int][berr_int] = !memB_serr[rerr_int][berr_int] && !memB_derr[rerr_int][berr_int];
    assign memB_serr[rerr_int][berr_int] = 1'b0;
    assign memB_derr[rerr_int][berr_int] = 1'b0;

    assume_memB_err_check: assert property (@(posedge clk) disable iff (rst) (memB_nerr[rerr_int][berr_int] ||
                                                                             (memB_serr[rerr_int][berr_int] && !memB_derr[rerr_int][berr_int]) ||
                                                                             (memB_serr[rerr_int][berr_int] && memB_derr[rerr_int][berr_int])));
    assume_memB_nerr_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[rerr_int][berr_int] && memB_nerr[rerr_int][berr_int]) |-> ##SRAM_DELAY
                                            !t1_serrB[berr_int*NUMPRPT+rerr_int] && !t1_derrB[berr_int*NUMPRPT+rerr_int]);
    assume_memB_serr_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[rerr_int][berr_int] && memB_serr[rerr_int][berr_int]) |-> ##SRAM_DELAY
                                            t1_serrB[berr_int*NUMPRPT+rerr_int] && !t1_derrB[berr_int*NUMPRPT+rerr_int]);
    assume_memB_derr_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire[rerr_int][berr_int] && memB_derr[rerr_int][berr_int]) |-> ##SRAM_DELAY
                                            t1_serrB[berr_int*NUMPRPT+rerr_int] && t1_derrB[berr_int*NUMPRPT+rerr_int]);
  end
  if (rerr_int==0) begin: xmemA_loop
    assign xmemA_nerr[rerr_int] = !xmemA_serr[rerr_int] && !xmemA_derr[rerr_int];
    assign xmemA_serr[rerr_int] = 1'b0;
    assign xmemA_derr[rerr_int] = 1'b0;

    assume_xmemA_err_check: assert property (@(posedge clk) disable iff (rst) (xmemA_nerr[rerr_int] ||
                                                                              (xmemA_serr[rerr_int] && !xmemA_derr[rerr_int]) ||
                                                                              (xmemA_serr[rerr_int] && xmemA_derr[rerr_int])));
    assume_xmemA_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[rerr_int] && xmemA_nerr[rerr_int]) |-> ##SRAM_DELAY
                                              !t2_serrA[rerr_int] && !t2_derrA[rerr_int]);
    assume_xmemA_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[rerr_int] && xmemA_serr[rerr_int]) |-> ##SRAM_DELAY
                                              t2_serrA[rerr_int] && !t2_derrA[rerr_int]);
    assume_xmemA_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[rerr_int] && xmemA_derr[rerr_int]) |-> ##SRAM_DELAY
                                              t2_serrA[rerr_int] && t2_derrA[rerr_int]);
  end

  assign xmemB_nerr[rerr_int] = !xmemB_serr[rerr_int] && !xmemB_derr[rerr_int];
  assign xmemB_serr[rerr_int] = 1'b0;
  assign xmemB_derr[rerr_int] = 1'b0;

  assume_xmemB_err_check: assert property (@(posedge clk) disable iff (rst) (xmemB_nerr[rerr_int] ||
                                                                            (xmemB_serr[rerr_int] && !xmemB_derr[rerr_int]) ||
                                                                            (xmemB_serr[rerr_int] && xmemB_derr[rerr_int])));
  assume_xmemB_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[rerr_int] && xmemB_nerr[rerr_int]) |-> ##SRAM_DELAY
                                            !t2_serrB[rerr_int] && !t2_derrB[rerr_int]);
  assume_xmemB_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[rerr_int] && xmemB_serr[rerr_int]) |-> ##SRAM_DELAY
                                            t2_serrB[rerr_int] && !t2_derrB[rerr_int]);
  assume_xmemB_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[rerr_int] && xmemB_derr[rerr_int]) |-> ##SRAM_DELAY
                                            t2_serrB[rerr_int] && t2_derrB[rerr_int]);
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
integer vrdr_int, vrdb_int;
always_comb
  for (vrdr_int=1; vrdr_int<NUMVRPT; vrdr_int=vrdr_int+2) begin
    cflt[vrdr_int] = read2_wire[vrdr_int-1] && read2_wire[vrdr_int] && (rd2_bnk_wire[vrdr_int-1] == rd2_bnk_wire[vrdr_int]);
    cflt_serr[vrdr_int] = xmemB_serr[vrdr_int>>1];
    cflt_derr[vrdr_int] = 1'b0;
    cflt_pbnk[vrdr_int] = xmemB_serr[vrdr_int>>1] ? NUMVBNK : 0;
    for (vrdb_int=NUMVBNK-1; vrdb_int>=0; vrdb_int=vrdb_int-1)
      if (vrdb_int != rd2_bnk_wire[vrdr_int])
        if (memB_serr[vrdr_int>>1][vrdb_int]) begin
          if (cflt_serr[vrdr_int])
	    cflt_derr[vrdr_int] = 1'b1;
          cflt_serr[vrdr_int] = 1'b1;
	  cflt_pbnk[vrdr_int] = vrdb_int;
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
      
reg xmem_inv;
reg xmeminv;
reg xmem;
always @(posedge clk)
  if (!ready) begin
    xmem_inv <= 1'b0;
    xmeminv <= 1'b0;
    xmem <= 0;
  end else if (t2_writeA && (t2_addrA_wire[0] == select_vrow)) begin
    xmem_inv <= core.xserr_req;
    xmeminv <= xwr_serr;
    xmem <= t2_dinA[select_bit];
  end

wire xor_mem = ^mem;

genvar memr_int, memb_int;
generate for (memr_int=0; memr_int<NUMPRPT; memr_int=memr_int+1) begin: memr_loop
  for (memb_int=0; memb_int<NUMVBNK; memb_int=memb_int+1) begin: memb_loop
    if (memr_int==0) begin: pdoutA_loop
      assert_pdoutA_check: assert property (@(posedge clk) disable iff (rst)
					    (t1_readA_wire[memr_int][memb_int] && (t1_addrA_wire[memr_int][memb_int] == select_vrow)) |-> ##SRAM_DELAY
                                            (t1_serrA[memb_int*NUMPRPT+memr_int] ||
					     (t1_doutA[(memb_int*NUMPRPT+memr_int)*WIDTH+select_bit] == $past(mem[memb_int],SRAM_DELAY))));
    end
    assert_pdoutB_check: assert property (@(posedge clk) disable iff (rst)
					  (t1_readB_wire[memr_int][memb_int] && (t1_addrB_wire[memr_int][memb_int] == select_vrow)) |-> ##SRAM_DELAY
                                          (t1_serrB[memb_int*NUMPRPT+memr_int] || ((memr_int>0) && ($past(meminv[memb_int],SRAM_DELAY))) ||
					   (t1_doutB[(memb_int*NUMPRPT+memr_int)*WIDTH+select_bit] == $past(mem[memb_int],SRAM_DELAY))));
  end
  if (memr_int==0) begin: xdoutA_loop
    assert_xdoutA_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[memr_int] && (t2_addrA_wire[memr_int] == select_vrow)) |-> ##SRAM_DELAY
                                          (t2_serrA[memr_int] ||
				           (t2_doutA[memr_int*WIDTH+select_bit] == $past(xmem,SRAM_DELAY))));
  end
  assert_xdoutB_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[memr_int] && (t2_addrB_wire[memr_int] == select_vrow)) |-> ##SRAM_DELAY
                                        (t2_serrB[memr_int] || ((memr_int>0) && ($past(xmeminv,SRAM_DELAY))) ||
				         (t2_doutB[memr_int*WIDTH+select_bit] == $past(xmem,SRAM_DELAY))));
end
endgenerate

genvar xorr_int;
generate for (xorr_int=0; xorr_int<NUMPRPT; xorr_int=xorr_int+1) begin: xorr_loop
  assert_xor_int_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[xorr_int] && (t2_addrB_wire[xorr_int] == select_vrow)) |-> ##SRAM_DELAY
				         (t2_serrB[xorr_int] || (core.xor_data[xorr_int][select_bit] == xmem)));

  assert_xor_more_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[xorr_int] && (t2_addrB_wire[xorr_int] == select_vrow)) |-> ##SRAM_DELAY
				          (xmem_inv || t2_serrB[xorr_int] || (core.xor_data[xorr_int][select_bit] == ($past(xor_mem,SRAM_DELAY)))));
end
endgenerate

  assert_xor_data_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##SRAM_DELAY
                                          (xmem_inv || (xmem == ($past(xor_mem,SRAM_DELAY)))));

reg fakexor_inv;
always @(posedge clk)
  if (!ready)
    fakexor_inv <= 1'b0;
  else if (write1 && (wr_row1 == select_vrow)) 
    fakexor_inv <= |memA_serr[0];

reg fakemem;
always @(posedge clk)
  if (!ready) 
    fakemem <= 1'b0;
  else if (write1 && (addr1 == select_addr))
    fakemem <= din1[select_bit];

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##FLOPIN ((FLOPIN ? $past(fakemem) : fakemem) == mem[select_bank]));

assert_dout1_nerr_check: assert property (@(posedge clk) disable iff (rst) (read1 && (addr1 == select_addr) && memA_nerr[0][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                          (rd1_dout[select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)));
assert_derr1_nerr_check: assert property (@(posedge clk) disable iff (rst) (read1 && (addr1 == select_addr) && memA_nerr[0][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                          (!rd1_serr && !rd1_derr));
assert_derr1_serr_check: assert property (@(posedge clk) disable iff (rst) (read1 && (addr1 == select_addr) && memA_serr[0][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					  (rd1_serr && !rd1_derr));
//assert_padr1_check: assert property (@(posedge clk) disable iff (rst) (read1 && (addr1 == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
//				     (rd1_padr == {select_bank,(FLOPOUT ? $past(t1_padrA_sel[0]) : t1_padrA_sel[0])}));

genvar doutr_int;
generate for (doutr_int=0; doutr_int<NUMVRPT; doutr_int=doutr_int+1) begin: doutr_loop

  assert_vld_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                     rd2_vld_wire[doutr_int]);

  if (doutr_int[0] == 1'b0) begin: even_loop
    assert_dout_nerr_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr) && memB_nerr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                             (rd2_dbit_wire[doutr_int] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)));

    assert_derr_nerr_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr) && memB_nerr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                             (!rd2_serr_wire[doutr_int] && !rd2_derr_wire[doutr_int]));
    assert_derr_serr_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr) && memB_serr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					     (rd2_serr_wire[doutr_int] && !rd2_derr_wire[doutr_int]));

    assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					(rd2_padr_wire[doutr_int] == {select_bank,(FLOPOUT ? $past(t1_padrB_sel[doutr_int>>1]) : t1_padrB_sel[doutr_int>>1])}));

  end else begin: odd_loop

    assert_dout_ncfl_nerr_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && memB_nerr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
						  (rd2_dbit_wire[doutr_int] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)));
    assert_dout_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && &(memB_nerr[doutr_int>>1] | (1'b1 << select_bank)) && xmemB_nerr[doutr_int>>1]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                                  ($past(fakexor_inv,FLOPIN+SRAM_DELAY+FLOPOUT) || (rd2_dbit_wire[doutr_int] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT))));
    assert_dout_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] && (memB_serr[doutr_int>>1] == (1'b1 << select_bank)) && xmemB_nerr[doutr_int>>1]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					          ($past(fakexor_inv,FLOPIN+SRAM_DELAY+FLOPOUT) || (rd2_dbit_wire[doutr_int] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT))));

    assert_derr_ncfl_nerr_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && memB_nerr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
						  (!rd2_serr_wire[doutr_int] && !rd2_derr_wire[doutr_int]));
    assert_derr_ncfl_serr_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int] && memB_serr[doutr_int>>1][select_bank]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					          (rd2_serr_wire[doutr_int] && !rd2_derr_wire[doutr_int]));
    assert_derr_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] &&
									             &memB_nerr[doutr_int>>1] && xmemB_nerr[doutr_int>>1]) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					           (!rd2_serr_wire[doutr_int] && !rd2_derr_wire[doutr_int]));
    assert_derr_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] &&
					                                             (|memB_serr[doutr_int>>1] || xmemB_serr[doutr_int>>1])) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
					          ((rd2_serr_wire[doutr_int] == ($past(cflt_serr[doutr_int],FLOPIN+SRAM_DELAY+FLOPOUT))) &&
					           (rd2_derr_wire[doutr_int] == ($past(cflt_derr[doutr_int],FLOPIN+SRAM_DELAY+FLOPOUT)))));

    assert_padr_ncfl_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr) && !cflt[doutr_int]) |-> ##MEM_DELAY
					     (rd2_padr_wire[doutr_int] == {select_bank,(FLOPOUT ? $past(t1_padrB_sel[doutr_int>>1]) : t1_padrB_sel[doutr_int>>1])}));
    assert_padr_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] &&
									             &memB_nerr[doutr_int>>1] && xmemB_nerr[doutr_int>>1]) |-> ##MEM_DELAY
					          (&rd2_padr_wire[doutr_int] || (rd2_padr_wire[doutr_int] == {NUMVBNK,(FLOPOUT ? $past(t2_padrB_sel[doutr_int>>1]) : t2_padrB_sel[doutr_int>>1])})));

    assert_padr_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read2_wire[doutr_int] && (rd2_adr_wire[doutr_int] == select_addr) && cflt[doutr_int] &&
					                                             (|memB_serr[doutr_int>>1] || xmemB_serr[doutr_int>>1])) |-> ##MEM_DELAY
						  ((!rd2_serr_wire[doutr_int] && !rd2_derr_wire[doutr_int]) ?
						   (&rd2_padr_wire[doutr_int] || (rd2_padr_wire[doutr_int] == {NUMVBNK,(FLOPOUT ? $past(t2_padrB_sel[doutr_int>>1]) : t2_padrB_sel[doutr_int>>1])})) :
						   (&rd2_padr_wire[doutr_int] ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==NUMVBNK) && (rd2_padr_wire[doutr_int] == ((NUMVBNK << (BITPADR-BITPBNK-1) | t2_padrB_sel[doutr_int>>1])))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==0) &&       (rd2_padr_wire[doutr_int] == ((0 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][0]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==1) &&       (rd2_padr_wire[doutr_int] == ((1 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][1]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==2) &&       (rd2_padr_wire[doutr_int] == ((2 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][2]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==3) &&       (rd2_padr_wire[doutr_int] == ((3 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][3]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==4) &&       (rd2_padr_wire[doutr_int] == ((4 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][4]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==5) &&       (rd2_padr_wire[doutr_int] == ((5 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][5]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==6) &&       (rd2_padr_wire[doutr_int] == ((6 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][6]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==7) &&       (rd2_padr_wire[doutr_int] == ((7 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][7]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==8) &&       (rd2_padr_wire[doutr_int] == ((8 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][8]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==9) &&       (rd2_padr_wire[doutr_int] == ((9 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][9]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==10) &&      (rd2_padr_wire[doutr_int] == ((10 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][10]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==11) &&      (rd2_padr_wire[doutr_int] == ((11 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][11]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==12) &&      (rd2_padr_wire[doutr_int] == ((12 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][12]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==13) &&      (rd2_padr_wire[doutr_int] == ((13 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][13]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==14) &&      (rd2_padr_wire[doutr_int] == ((14 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][14]))) ||
        (($past(cflt_pbnk[doutr_int],MEM_DELAY)==15) &&      (rd2_padr_wire[doutr_int] == ((15 << (BITPADR-BITPBNK-1)) | t1_padrB_sel_wire[doutr_int>>1][15]))))));
// (rd2_padr_wire[doutr_int] == {$past(cflt_pbnk[doutr_int],FLOPIN+SRAM_DELAY+FLOPOUT),(FLOPOUT ? $past(t2_padrB_sel[doutr_int>>1]) : t2_padrB_sel[doutr_int>>1])}))));
  end
end
endgenerate

endmodule


