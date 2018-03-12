module ip_top_sva_2_2nr4w_2r2w
  #(
parameter     WIDTH   = 32,
parameter     NUMDUPL = 1,
parameter     NUMRDPT = 2,
parameter     NUMWRPT = 2,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     ECCBITS = 4,
parameter     SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS
   )
(
  input clk,
  input rst,
  input [NUMDUPL*NUMRDPT-1:0] read,
  input [NUMDUPL*NUMRDPT*BITADDR-1:0] rd_adr,
  input [2*NUMWRPT-1:0] write,
  input [2*NUMWRPT*BITADDR-1:0]  wr_adr,
  input [NUMWRPT*NUMVBNK-1:0] t1_writeA,
  input [NUMWRPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMDUPL*NUMRDPT*NUMVBNK-1:0] t1_readB,
  input [NUMDUPL*NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMWRPT-1:0] t2_writeA,
  input [NUMWRPT*BITVROW-1:0] t2_addrA,
  input [(NUMDUPL*NUMRDPT+NUMWRPT)-1:0] t2_readB,
  input [(NUMDUPL*NUMRDPT+NUMWRPT)*BITVROW-1:0] t2_addrB,
  input [NUMWRPT-1:0] t3_writeA,
  input [NUMWRPT*BITVROW-1:0] t3_addrA,
  input [(NUMDUPL*NUMRDPT+2*NUMWRPT)-1:0] t3_readB,
  input [(NUMDUPL*NUMRDPT+2*NUMWRPT)*BITVROW-1:0] t3_addrB
);

genvar rd_int;
generate for (rd_int=0; rd_int<NUMDUPL*NUMRDPT; rd_int=rd_int+1) begin: rd_loop
  wire read_wire = read >> rd_int;
  wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (rd_int*BITADDR);

  assert_rd_range_check: assert property (@(posedge clk) disable iff (rst) read_wire |-> (rd_adr_wire < NUMADDR));
end
endgenerate

genvar wr_int;
generate for (wr_int=0; wr_int<2*NUMWRPT; wr_int=wr_int+1) begin: wr_loop
  wire write_wire = write >> wr_int;
  wire [BITADDR-1:0] wr_adr_wire = wr_adr >> (wr_int*BITADDR);

  assert_wr_range_check: assert property (@(posedge clk) disable iff (rst) write_wire |-> (wr_adr_wire < NUMADDR));
end
endgenerate

genvar t1rb_int, t1r_int, t1rp_int;
generate for (t1rb_int=0; t1rb_int<NUMVBNK; t1rb_int=t1rb_int+1) begin: t1_rb_loop
  for (t1r_int=0; t1r_int<NUMDUPL*NUMRDPT; t1r_int=t1r_int+1) begin: t1_rd_loop
    wire t1_readB_wire = t1_readB >> (NUMDUPL*NUMRDPT*t1rb_int+t1r_int);
    wire [BITVROW-1:0] t1_addrB_wire = t1_addrB >> ((NUMDUPL*NUMRDPT*t1rb_int+t1r_int)*BITVROW);

    assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMVROW));

    for (t1rp_int=0; t1rp_int<NUMWRPT; t1rp_int=t1rp_int+1) begin: t1_rw_loop
      wire t1_writeP_wire = t1_writeA >> (NUMWRPT*t1rb_int+t1rp_int);
      wire [BITVROW-1:0] t1_addrP_wire = t1_addrA >> ((NUMWRPT*t1rb_int+t1rp_int)*BITVROW);

      assert_t1_rd_pseudo_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> !(t1_writeP_wire && (t1_addrB_wire == t1_addrP_wire)));
    end
  end
end
endgenerate

genvar t1wb_int, t1w_int, t1wp_int;
generate for (t1wb_int=0; t1wb_int<NUMVBNK; t1wb_int=t1wb_int+1) begin: t1_wb_loop
  for (t1w_int=0; t1w_int<NUMWRPT; t1w_int=t1w_int+1) begin: t1_wr_loop
    wire t1_writeA_wire = t1_writeA >> (NUMWRPT*t1wb_int+t1w_int);
    wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> ((NUMWRPT*t1wb_int+t1w_int)*BITVROW);

    assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVROW));

    for (t1wp_int=t1w_int+1; t1wp_int<NUMWRPT; t1wp_int=t1wp_int+1) begin: t1_wp_loop
      wire t1_writeP_wire = t1_writeA >> (NUMWRPT*t1wb_int+t1wp_int);
      wire [BITVROW-1:0] t1_addrP_wire = t1_addrA >> ((NUMWRPT*t1wb_int+t1wp_int)*BITVROW);

      assert_t1_wr_diff_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> !(t1_writeP_wire && (t1_addrA_wire == t1_addrP_wire)));
    end
  end
end
endgenerate

genvar t2r_int, t2rp_int;
generate for (t2r_int=0; t2r_int<NUMDUPL*NUMRDPT+NUMWRPT; t2r_int=t2r_int+1) begin: t2_rd_loop
  wire t2_readB_wire = t2_readB >> t2r_int;
  wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2r_int*BITVROW);

  assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));

  for (t2rp_int=0; t2rp_int<NUMWRPT; t2rp_int=t2rp_int+1) begin: t2_rw_loop
    wire t2_writeP_wire = t2_writeA >> t2rp_int;
    wire [BITVROW-1:0] t2_addrP_wire = t2_addrA >> (t2rp_int*BITVROW);

    assert_t2_rd_pseudo_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> !(t2_writeP_wire && (t2_addrB_wire == t2_addrP_wire)));
  end
end
endgenerate

genvar t2w_int, t2wp_int;
generate for (t2w_int=0; t2w_int<NUMWRPT; t2w_int=t2w_int+1) begin: t2_wr_loop
  wire t2_writeA_wire = t2_writeA >> t2w_int;
  wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> (t2w_int*BITVROW);

  assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));

  for (t2wp_int=t2w_int+1; t2wp_int<NUMWRPT; t2wp_int=t2wp_int+1) begin: t2_wp_loop
    wire t2_writeP_wire = t2_writeA >> t2wp_int;
    wire [BITVROW-1:0] t2_addrP_wire = t2_addrA >> (t2wp_int*BITVROW);

    assert_t2_wr_diff_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> !(t2_writeP_wire && (t2_addrA_wire == t2_addrP_wire)));
  end
end
endgenerate

genvar t3r_int, t3rp_int;
generate for (t3r_int=0; t3r_int<NUMDUPL*NUMRDPT+2*NUMWRPT; t3r_int=t3r_int+1) begin: t3_rd_loop
  wire t3_readB_wire = t3_readB >> t3r_int;
  wire [BITVROW-1:0] t3_addrB_wire = t3_addrB >> (t3r_int*BITVROW);

  assert_t3_rd_range_check: assert property (@(posedge clk) disable iff (rst) t3_readB_wire |-> (t3_addrB_wire < NUMVROW));

  for (t3rp_int=0; t3rp_int<NUMWRPT; t3rp_int=t3rp_int+1) begin: t3_rw_loop
    wire t3_writeP_wire = t3_writeA >> t3rp_int;
    wire [BITVROW-1:0] t3_addrP_wire = t3_addrA >> (t3rp_int*BITVROW);

    assert_t3_rd_pseudo_check: assert property (@(posedge clk) disable iff (rst) t3_readB_wire |-> !(t3_writeP_wire && (t3_addrB_wire == t3_addrP_wire)));
  end
end
endgenerate

genvar t3w_int, t3wp_int;
generate for (t3w_int=0; t3w_int<NUMWRPT; t3w_int=t3w_int+1) begin: t3_wr_loop
  wire t3_writeA_wire = t3_writeA >> t3w_int;
  wire [BITVROW-1:0] t3_addrA_wire = t3_addrA >> (t3w_int*BITVROW);

  assert_t3_wr_range_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_addrA_wire < NUMVROW));

  for (t3wp_int=t3w_int+1; t3wp_int<NUMWRPT; t3wp_int=t3wp_int+1) begin: t3_wp_loop
    wire t3_writeP_wire = t3_writeA >> t3wp_int;
    wire [BITVROW-1:0] t3_addrP_wire = t3_addrA >> (t3wp_int*BITVROW);

    assert_t3_wr_diff_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> !(t3_writeP_wire && (t3_addrA_wire == t3_addrP_wire)));
  end
end
endgenerate

endmodule

module ip_top_sva_2nr4w_2r2w
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     NUMDUPL = 1,
parameter     NUMRDPT = 2,
parameter     NUMWRPT = 2,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     BITPBNK = 4,
parameter     BITPADR = 14,
parameter     ECCBITS = 4,
parameter     SRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS
   )
(
  input clk,
  input rst,
  input [2*NUMWRPT-1:0] write,
  input [2*NUMWRPT*BITADDR-1:0]  wr_adr,
  input [2*NUMWRPT*WIDTH-1:0] din,
  input [NUMDUPL*NUMRDPT-1:0] read,
  input [NUMDUPL*NUMRDPT*BITADDR-1:0] rd_adr,
  input [NUMDUPL*NUMRDPT-1:0] rd_vld,
  input [NUMDUPL*NUMRDPT*WIDTH-1:0] rd_dout,
  input [NUMDUPL*NUMRDPT-1:0] rd_fwrd,
  input [NUMDUPL*NUMRDPT-1:0] rd_serr,
  input [NUMDUPL*NUMRDPT-1:0] rd_derr,
  input [NUMDUPL*NUMRDPT*BITPADR-1:0] rd_padr,
  input [NUMWRPT*NUMVBNK-1:0] t1_writeA,
  input [NUMWRPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMWRPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMDUPL*NUMRDPT*NUMVBNK-1:0] t1_readB,
  input [NUMDUPL*NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMDUPL*NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutB,
  input [NUMDUPL*NUMRDPT*NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB,
  input [NUMWRPT-1:0] t2_writeA,
  input [NUMWRPT*BITVROW-1:0] t2_addrA,
  input [NUMWRPT*WIDTH-1:0] t2_dinA,
  input [(NUMDUPL*NUMRDPT+NUMWRPT)-1:0] t2_readB,
  input [(NUMDUPL*NUMRDPT+NUMWRPT)*BITVROW-1:0] t2_addrB,
  input [(NUMDUPL*NUMRDPT+NUMWRPT)*WIDTH-1:0] t2_doutB,
  input [NUMWRPT-1:0] t3_writeA,
  input [NUMWRPT*BITVROW-1:0] t3_addrA,
  input [NUMWRPT*SDOUT_WIDTH-1:0] t3_dinA,
  input [(NUMDUPL*NUMRDPT+2*NUMWRPT)-1:0] t3_readB,
  input [(NUMDUPL*NUMRDPT+2*NUMWRPT)*BITVROW-1:0] t3_addrB,
  input [(NUMDUPL*NUMRDPT+2*NUMWRPT)*SDOUT_WIDTH-1:0] t3_doutB,
  input [BITADDR-1:0] select_addr,
  input [BITWDTH-1:0] select_bit
);

wire [BITVBNK-1:0] select_bank;
wire [BITVROW-1:0] select_row;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  sel_adr (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));

//assert_rw_wr_np2_check: assert property (@(posedge clk) disable iff (rst) (read_0 && write_1) |->
//					 ((rd_adr_0 == wr_adr_1) == ((core.vrdbadr == core.vwrbadr) && (core.vrdradr == core.vwrradr))));

genvar np2_int;
generate begin: np2_loop
  assert_sl_np2_range_check: assert property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR) |->
					      ((select_bank < NUMVBNK) && (select_row < NUMVROW))); 

  for (np2_int=0; np2_int<2*NUMWRPT; np2_int=np2_int+1) begin: wr_loop
    wire write_wire = write >> np2_int;

    assert_wr_sl_np2_check: assert property (@(posedge clk) disable iff (rst) write_wire |-> ##FLOPIN
					     ((core.vwraddr_wire[np2_int] == select_addr) == ((core.vwrbadr_wire[np2_int] == select_bank) && (core.vwrradr_wire[np2_int] == select_row)))); 
    assert_wr_np2_range_check: assert property (@(posedge clk) disable iff (rst) write_wire |-> ##FLOPIN
					        ((core.vwrbadr_wire[np2_int] < NUMVBNK) && (core.vwrradr_wire[np2_int] < NUMVROW)));
  end

  for (np2_int=0; np2_int<NUMDUPL*NUMRDPT; np2_int=np2_int+1) begin: rd_loop
    wire read_wire = read >> np2_int;

    assert_rd_sl_np2_check: assert property (@(posedge clk) disable iff (rst) read_wire |-> ##FLOPIN
					     ((core.vrdaddr_wire[np2_int] == select_addr) == ((core.vrdbadr_wire[np2_int] == select_bank) && (core.vrdradr_wire[np2_int] == select_row)))); 
    assert_rd_np2_range_check: assert property (@(posedge clk) disable iff (rst) read_wire |-> ##FLOPIN
					        ((core.vrdbadr_wire[np2_int] < NUMVBNK) && (core.vrdradr_wire[np2_int] < NUMVROW)));
  end
end
endgenerate

reg write_wire [0:2*NUMWRPT-1];
reg [BITADDR-1:0] wr_adr_wire [0:2*NUMWRPT-1];
reg [WIDTH-1:0] din_wire [0:2*NUMWRPT-1];

reg read_wire [0:NUMDUPL*NUMRDPT-1];
reg [BITADDR-1:0] rd_adr_wire [0:NUMDUPL*NUMRDPT-1];
reg rd_vld_wire [0:NUMDUPL*NUMRDPT-1];
reg [WIDTH-1:0] rd_dout_wire [0:NUMDUPL*NUMRDPT-1];
reg rd_fwrd_wire [0:NUMDUPL*NUMRDPT-1];
reg rd_serr_wire [0:NUMDUPL*NUMRDPT-1];
reg rd_derr_wire [0:NUMDUPL*NUMRDPT-1]; 
reg [BITPADR-1:0] rd_padr_wire [0:NUMDUPL*NUMRDPT-1];

integer wr_int;
always_comb
  for (wr_int=0; wr_int<2*NUMWRPT; wr_int=wr_int+1) begin
    write_wire[wr_int] = write >> wr_int;
    wr_adr_wire[wr_int] = wr_adr >> (wr_int*BITADDR);
    din_wire[wr_int] = din >> (wr_int*WIDTH);
  end

integer rd_int;
always_comb
  for (rd_int=0; rd_int<NUMDUPL*NUMRDPT; rd_int=rd_int+1) begin
    read_wire[rd_int] = read >> rd_int;
    rd_adr_wire[rd_int] = rd_adr >> (rd_int*BITADDR);
    rd_vld_wire[rd_int] = rd_vld >> rd_int;
    rd_dout_wire[rd_int] = rd_dout >> (rd_int*WIDTH);
    rd_fwrd_wire[rd_int] = rd_fwrd >> rd_int;
    rd_serr_wire[rd_int] = rd_serr >> rd_int;
    rd_derr_wire[rd_int] = rd_derr >> rd_int; 
    rd_padr_wire[rd_int] = rd_padr >> (rd_int*BITPADR);
  end

wire t1_writeA_sel_wire [0:NUMWRPT-1];
wire [BITVROW-1:0] t1_addrA_sel_wire [0:NUMWRPT-1];
wire [WIDTH-1:0] t1_dinA_sel_wire [0:NUMWRPT-1];

wire t1_readB_sel_wire [0:NUMDUPL*NUMRDPT-1];
wire [BITVROW-1:0] t1_addrB_sel_wire [0:NUMDUPL*NUMRDPT-1];
wire [WIDTH-1:0] t1_doutB_sel_wire [0:NUMDUPL*NUMRDPT-1];
wire t1_doutB_sel_sel_wire [0:NUMDUPL*NUMRDPT-1];
wire [BITPADR-BITPBNK-1:0] t1_padrB_sel_wire [0:NUMDUPL*NUMRDPT-1];

genvar t1w_int;
generate for (t1w_int=0; t1w_int<NUMWRPT; t1w_int=t1w_int+1) begin: t1w_loop
  assign t1_writeA_sel_wire[t1w_int] = t1_writeA >> (NUMWRPT*select_bank+t1w_int);
  assign t1_addrA_sel_wire[t1w_int] = t1_addrA >> ((NUMWRPT*select_bank+t1w_int)*BITVROW);
  assign t1_dinA_sel_wire[t1w_int] = t1_dinA >> ((NUMWRPT*select_bank+t1w_int)*WIDTH);
end
endgenerate

genvar t1r_int, t1rd_int;
generate for (t1rd_int=0; t1rd_int<NUMDUPL; t1rd_int=t1rd_int+1) begin: t1rd_loop
  for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin: t1r_loop
    assign t1_readB_sel_wire[t1rd_int*NUMRDPT+t1r_int] = t1_readB >> (NUMDUPL*NUMRDPT*select_bank+NUMRDPT*t1rd_int+t1r_int);
    assign t1_addrB_sel_wire[t1rd_int*NUMRDPT+t1r_int] = t1_addrB >> ((NUMDUPL*NUMRDPT*select_bank+NUMRDPT*t1rd_int+t1r_int)*BITVROW);
    assign t1_doutB_sel_wire[t1rd_int*NUMRDPT+t1r_int] = t1_doutB >> ((NUMDUPL*NUMRDPT*select_bank+NUMRDPT*t1rd_int+t1r_int)*WIDTH);
    assign t1_padrB_sel_wire[t1rd_int*NUMRDPT+t1r_int] = t1_padrB >> ((NUMDUPL*NUMRDPT*select_bank+NUMRDPT*t1rd_int+t1r_int)*(BITPADR-BITPBNK));
    assign t1_doutB_sel_sel_wire[t1rd_int*NUMRDPT+t1r_int] = t1_doutB >> ((NUMDUPL*NUMRDPT*select_bank+NUMRDPT*t1rd_int+t1r_int)*WIDTH+select_bit);
  end
end
endgenerate

wire t2_writeA_wire [0:NUMWRPT-1];
wire [BITVROW-1:0] t2_addrA_wire [0:NUMWRPT-1];
wire [WIDTH-1:0] t2_dinA_wire [0:NUMWRPT-1];

wire t2_readB_wire [0:NUMDUPL*NUMRDPT+NUMWRPT-1];
wire [BITVROW-1:0] t2_addrB_wire [0:NUMDUPL*NUMRDPT+NUMWRPT-1];
wire [WIDTH-1:0] t2_doutB_wire [0:NUMDUPL*NUMRDPT+NUMWRPT-1];
wire t2_doutB_sel_wire [0:NUMDUPL*NUMRDPT+NUMWRPT-1];

genvar t2w_int;
generate for (t2w_int=0; t2w_int<NUMWRPT; t2w_int=t2w_int+1) begin: t2w_loop
  assign t2_writeA_wire[t2w_int] = t2_writeA >> t2w_int;
  assign t2_addrA_wire[t2w_int] = t2_addrA >> (t2w_int*BITVROW);
  assign t2_dinA_wire[t2w_int] = t2_dinA >> (t2w_int*WIDTH);
end
endgenerate

genvar t2r_int;
generate for (t2r_int=0; t2r_int<NUMDUPL*NUMRDPT+NUMWRPT; t2r_int=t2r_int+1) begin: t2r_loop
  assign t2_readB_wire[t2r_int] = t2_readB >> t2r_int;
  assign t2_addrB_wire[t2r_int] = t2_addrB >> (t2r_int*BITVROW);
  assign t2_doutB_wire[t2r_int] = t2_doutB >> (t2r_int*WIDTH);
  assign t2_doutB_sel_wire[t2r_int] = t2_doutB >> (t2r_int*WIDTH+select_bit);
end
endgenerate

wire t3_writeA_wire [0:NUMWRPT-1];
wire [BITVROW-1:0] t3_addrA_wire [0:NUMWRPT-1];
wire [SDOUT_WIDTH-1:0] t3_dinA_wire [0:NUMWRPT-1];

wire t3_readB_wire [0:NUMDUPL*NUMRDPT+2*NUMWRPT-1];
wire [BITVROW-1:0] t3_addrB_wire [0:NUMDUPL*NUMRDPT+2*NUMWRPT-1];
wire [SDOUT_WIDTH-1:0] t3_doutB_wire [0:NUMDUPL*NUMRDPT+2*NUMWRPT-1];

genvar t3w_int;
generate for (t3w_int=0; t3w_int<NUMWRPT; t3w_int=t3w_int+1) begin: t3w_loop
  assign t3_writeA_wire[t3w_int] = t3_writeA >> t3w_int;
  assign t3_addrA_wire[t3w_int] = t3_addrA >> (t3w_int*BITVROW);
  assign t3_dinA_wire[t3w_int] = t3_dinA >> (t3w_int*SDOUT_WIDTH);
end
endgenerate

genvar t3r_int;
generate for (t3r_int=0; t3r_int<NUMDUPL*NUMRDPT+2*NUMWRPT; t3r_int=t3r_int+1) begin: t3r_loop
  assign t3_readB_wire[t3r_int] = t3_readB >> t3r_int;
  assign t3_addrB_wire[t3r_int] = t3_addrB >> (t3r_int*BITVROW);
  assign t3_doutB_wire[t3r_int] = t3_doutB >> (t3r_int*SDOUT_WIDTH);
end
endgenerate

reg pmeminv;
reg pmem;
integer pmem_int;
always @(posedge clk)
  if (rst)
    pmeminv <= 1'b1;
  else for (pmem_int=0; pmem_int<NUMWRPT; pmem_int=pmem_int+1)
    if (t1_writeA_sel_wire[pmem_int] && (t1_addrA_sel_wire[pmem_int] == select_row)) begin
      pmeminv <= 1'b0;
      pmem <= t1_dinA_sel_wire[pmem_int][select_bit];
    end

reg [SDOUT_WIDTH-1:0] smem;
integer smem_int;
always @(posedge clk)
  if (rst)
    smem <= 0;
  else for (smem_int=0; smem_int<NUMWRPT; smem_int=smem_int+1)
    if (t3_writeA_wire[smem_int] && (t3_addrA_wire[smem_int] == select_row))
      smem <= t3_dinA_wire[smem_int];

wire [ECCBITS-1:0] smem_ecc;
ecc_calc   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
    ecc_calc_inst (.din(smem[BITVBNK:0]), .eccout(smem_ecc));

reg cmem;
integer cmem_int;
always @(posedge clk)
  if (rst)
    cmem <= 0;
  else for (cmem_int=0; cmem_int<NUMWRPT; cmem_int=cmem_int+1)
    if (t2_writeA_wire[cmem_int] && (t2_addrA_wire[cmem_int] == select_row))
      cmem <= t2_dinA_wire[cmem_int][select_bit];

wire mem_wire = (smem[BITVBNK] && (smem[BITVBNK-1:0] == select_bank)) ? cmem : pmem;

assert_smem_ecc_check: assert property (@(posedge clk) disable iff (rst) (smem == {smem[BITVBNK:0],smem_ecc,smem[BITVBNK:0]}));

genvar pdout_int;
generate for (pdout_int=0; pdout_int<NUMDUPL*NUMRDPT; pdout_int=pdout_int+1) begin: pdout_loop
  assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_sel_wire[pdout_int] && (t1_addrB_sel_wire[pdout_int] == select_row)) |-> ##SRAM_DELAY
                                       ($past(pmeminv,SRAM_DELAY) || (t1_doutB_sel_wire[pdout_int][select_bit] == $past(pmem,SRAM_DELAY))));
end
endgenerate

genvar cdout_int;
generate for (cdout_int=0; cdout_int<NUMDUPL*NUMRDPT+NUMWRPT; cdout_int=cdout_int+1) begin: cdout_loop
  assert_cdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[cdout_int] && (t2_addrB_wire[cdout_int] == select_row)) |-> ##SRAM_DELAY
                                       (t2_doutB_wire[cdout_int][select_bit] == $past(cmem,SRAM_DELAY)));
end
endgenerate

genvar sdout_int;
generate for (sdout_int=0; sdout_int<NUMDUPL*NUMRDPT+2*NUMWRPT; sdout_int=sdout_int+1) begin: sdout_loop
  assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (t3_readB_wire[sdout_int] && (t3_addrB_wire[sdout_int] == select_row)) |-> ##SRAM_DELAY
                                       (t3_doutB_wire[sdout_int] == $past(smem,SRAM_DELAY)));

  assert_sdout_ecc_check: assert property (@(posedge clk) disable iff (rst) (t3_readB_wire[sdout_int] && (t3_addrB_wire[sdout_int] == select_row)) |-> ##SRAM_DELAY
                                           (core.sdout_final[sdout_int] == $past(smem[BITVBNK:0],SRAM_DELAY)));
end
endgenerate

genvar serr_int;
generate for (serr_int=0; serr_int<NUMDUPL*NUMRDPT+2*NUMWRPT; serr_int=serr_int+1) begin: st_err_loop
  wire sdout_serr = core.schk_loop[serr_int].sdout_serr;
  wire sdout_derr = core.schk_loop[serr_int].sdout_derr;
  wire sdout_sec_err_wire = core.schk_loop[serr_int].sdout_sec_err_wire;
  wire sdout_ded_err_wire = core.schk_loop[serr_int].sdout_ded_err_wire;
  wire [BITVBNK:0] sdout_dup_data_wire = core.schk_loop[serr_int].sdout_dup_data_wire;
  wire [BITVBNK:0] sdout_post_ecc_wire = core.schk_loop[serr_int].sdout_post_ecc_wire;

  wire state_serr = 0;
  wire state_derr = 0;
  wire state_nerr = !state_serr && !state_derr;

  assume_state_err_check: assert property (@(posedge clk) disable iff (rst) !(state_serr && state_derr));
  assume_state_serr_check: assert property (@(posedge clk) disable iff (rst) state_serr |-> ##SRAM_DELAY sdout_serr && !sdout_derr);
  assume_state_derr_check: assert property (@(posedge clk) disable iff (rst) state_derr |-> ##SRAM_DELAY !sdout_serr && sdout_derr);
  assume_state_nerr_check: assert property (@(posedge clk) disable iff (rst) state_nerr |-> ##SRAM_DELAY !sdout_serr && !sdout_derr);

  assert_sdout_nerr_check: assert property (@(posedge clk) disable iff (rst) (t3_readB_wire[serr_int] && (t3_addrB_wire[serr_int] == select_row) && state_nerr) |-> ##SRAM_DELAY
					    !sdout_ded_err_wire && !sdout_sec_err_wire && (sdout_dup_data_wire == sdout_post_ecc_wire));

  assert_sdout_serr_check: assert property (@(posedge clk) disable iff (rst) (t3_readB_wire[serr_int] && (t3_addrB_wire[serr_int] == select_row) && state_serr) |-> ##SRAM_DELAY
					    !sdout_ded_err_wire && (sdout_sec_err_wire ? (sdout_dup_data_wire == sdout_post_ecc_wire) :
											 (sdout_dup_data_wire != sdout_post_ecc_wire)));

  assert_sdout1_derr_check: assert property (@(posedge clk) disable iff (rst) (t3_readB_wire[serr_int] && (t3_addrB_wire[serr_int] == select_row) && state_derr) |-> ##SRAM_DELAY
					     sdout_ded_err_wire ? !sdout_sec_err_wire :
					     sdout_sec_err_wire ? !sdout_ded_err_wire && (sdout_dup_data_wire != sdout_post_ecc_wire) :
					                          (sdout_dup_data_wire != sdout_post_ecc_wire));
end
endgenerate

reg fakemem;
reg fakememinv;
integer fmem_int;
always @(posedge clk)
  if (rst)
    fakememinv <= 1'b1;
  else for (fmem_int=0; fmem_int<2*NUMWRPT; fmem_int=fmem_int+1)
    if (write_wire[fmem_int] && (wr_adr_wire[fmem_int] == select_addr)) begin
      fakememinv <= 1'b0;
      fakemem <= din_wire[fmem_int][select_bit];
    end

genvar wrm_int;
generate for (wrm_int=0; wrm_int<2*NUMWRPT; wrm_int=wrm_int+1) begin: wrm_loop
  assert_wrmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[wrm_int] && (core.vwrradr_wire[wrm_int] == select_row)) |-> ##(SRAM_DELAY+1)
                                           (core.wrmap_out[wrm_int] == smem[BITVBNK:0]));
end
endgenerate

genvar wrc_int;
generate for (wrc_int=1; wrc_int<2*NUMWRPT; wrc_int=wrc_int+2) begin: wrc_loop
  assert_wcdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[wrc_int] && (core.vwrradr_wire[wrc_int] == select_row)) |-> ##(SRAM_DELAY+1)
                                           (core.wcdat_out[wrc_int][select_bit] == cmem));
end
endgenerate

genvar rdm_int;
generate for (rdm_int=0; rdm_int<NUMDUPL*NUMWRPT; rdm_int=rdm_int+1) begin: rdm_loop
  assert_rdmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[rdm_int] && (core.vrdradr_wire[rdm_int] == select_row)) |-> ##SRAM_DELAY
                                           (core.vdo_loop[rdm_int].rdmap_out == smem[BITVBNK:0]));
  assert_rcdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[rdm_int] && (core.vrdradr_wire[rdm_int] == select_row)) |-> ##SRAM_DELAY
                                           (core.vdo_loop[rdm_int].rcdat_out[select_bit] == cmem));
  assert_rpdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[rdm_int] && (core.vrdbadr_wire[rdm_int] == select_bank) && (core.vrdradr_wire[rdm_int] == select_row)) |-> ##SRAM_DELAY
                                           (pmeminv || (core.vdo_loop[rdm_int].rpdat_out[select_bit] == pmem)));
end
endgenerate

reg rmeminv;
reg rmem;
integer rmem_int;
always @(posedge clk)
  if (rst) begin
    rmeminv <= 1'b1;
  end else for (rmem_int=0; rmem_int<2*NUMWRPT; rmem_int=rmem_int+1)
    if (core.vwrite_out[rmem_int] && (core.vwrbadr_out[rmem_int] == select_bank) && (core.vwrradr_out[rmem_int] == select_row)) begin
      rmeminv <= 1'b0;
      rmem <= core.vdin_out[rmem_int][select_bit];
    end

assert_rmem_check: assert property (@(posedge clk) disable iff (rst) (rmeminv || (mem_wire == rmem)));

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(FLOPIN+SRAM_DELAY+1)
				       ($past(fakememinv,FLOPIN+SRAM_DELAY+1) || ($past(fakemem,FLOPIN+SRAM_DELAY+1) == mem_wire)));

genvar vdout_int;
generate for (vdout_int=0; vdout_int<NUMRDPT; vdout_int=vdout_int+1) begin: vdout_loop
  assert_vdout_int_check: assert property (@(posedge clk) disable iff (rst) (read_wire[vdout_int] && (rd_adr_wire[vdout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY)
                                           (rmeminv || (core.vdout_int[vdout_int][select_bit] == rmem)));
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire[vdout_int] && (rd_adr_wire[vdout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_vld_wire[vdout_int] && ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                                                  (rd_dout_wire[vdout_int][select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)))));
  assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[vdout_int] && (rd_adr_wire[vdout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_fwrd_wire[vdout_int] || ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT)) ||
                                       ((rd_padr_wire[vdout_int][BITPADR-1:BITPADR-BITPBNK] != NUMVBNK) &&
                                        (rd_dout_wire[vdout_int][select_bit] == (FLOPOUT ? $past(t1_doutB_sel_sel_wire[vdout_int]) : t1_doutB_sel_sel_wire[vdout_int]))) ||
                                       ((rd_padr_wire[vdout_int][BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) &&
                                        (rd_dout_wire[vdout_int][select_bit] == (FLOPOUT ? $past(t2_doutB_sel_wire[vdout_int]) : t2_doutB_sel_wire[vdout_int])))));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[vdout_int] && (rd_adr_wire[vdout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (rd_padr_wire[vdout_int] == ((NUMVBNK << (BITPADR-BITPBNK)) | select_row)) ||
                                      (rd_padr_wire[vdout_int] == {select_bank,(FLOPOUT ? $past(t1_padrB_sel_wire[vdout_int]) : t1_padrB_sel_wire[vdout_int])}));

end
endgenerate

endmodule


