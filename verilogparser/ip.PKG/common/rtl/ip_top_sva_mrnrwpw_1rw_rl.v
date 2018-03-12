module ip_top_sva_2_mrnrwpw_1rw_rl
  #(
parameter     WIDTH   = 32,
parameter     ENAPSDO = 1,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMRDPT = 1,
parameter     NUMRWPT = 1,
parameter     NUMWRPT = 2,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     REFRESH = 0,
parameter     ECCBITS = 4,
parameter     NUMCASH = NUMRDPT+NUMRWPT+NUMWRPT-1,
parameter     SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS
   )
(
  input clk,
  input rst,
  input ready,
  input refr,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] read,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] write,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITADDR-1:0] addr,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] din,
  input [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_readA,
  input [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_writeA,
  input [(NUMRDPT+NUMRWPT)*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t2_writeA,
  input [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrA,
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB,
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrB,
  input [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA,
  input [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW-1:0] t3_addrA,
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB,
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t3_addrB,
  input [BITADDR-1:0] select_addr
);

wire [BITVBNK-1:0] select_bank;
wire [BITVROW-1:0] select_row;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  sel_adr (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));

generate if (REFRESH) begin: refr_loop
  assert_refr_noacc_check: assume property (@(posedge clk) disable iff (!ready) !(refr && (write || read)));
end
endgenerate

genvar prt_int;
generate for (prt_int=0; prt_int<NUMRDPT+NUMRWPT+NUMWRPT; prt_int=prt_int+1) begin: prt_loop
  wire read_wire = (prt_int<NUMRDPT+NUMRWPT) ? read >> prt_int : 1'b0;
  wire write_wire = (prt_int>=NUMRDPT) ? write >> prt_int : 1'b0;
  wire [BITADDR-1:0] addr_wire = addr >> (prt_int*BITADDR);

  assert_rw_1p_check: assert property (@(posedge clk) disable iff (!ready) !(read_wire && write_wire)); 
  assert_rw_range_check: assert property (@(posedge clk) disable iff (!ready) (read_wire || write_wire) |-> (addr_wire < NUMADDR));
end
endgenerate

genvar t1_int;
generate for (t1_int=0; t1_int<(NUMRDPT+NUMRWPT)*NUMVBNK; t1_int=t1_int+1) begin: t1_loop
  wire t1_readA_wire = t1_readA >> t1_int;
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> (t1_int*BITVROW);

  assert_t1_1p_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA_wire && t1_writeA_wire));
  assert_t1_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire || t1_writeA_wire) |-> (t1_addrA_wire < NUMVROW));
end
endgenerate

genvar t2_int, t2w_int, t2r_int;
generate
  for (t2_int=0; t2_int<NUMCASH; t2_int=t2_int+1) begin: t2_loop
    for (t2w_int=0; t2w_int<NUMRWPT+NUMWRPT; t2w_int=t2w_int+1) begin: t2w_loop
      wire t2_writeA_wire = t2_writeA >> t2_int*(NUMRWPT+NUMWRPT)+t2w_int;
      wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> ((t2_int*(NUMRWPT+NUMWRPT)+t2w_int)*BITVROW);
      assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));

      for (t2r_int=0; t2r_int<NUMRWPT+NUMWRPT; t2r_int=t2r_int+1)
        if (t2r_int != t2w_int) begin: t2wp_loop
          wire t2_writeA_wp_wire = t2_writeA >> t2_int*(NUMRWPT+NUMWRPT)+t2r_int;
          wire [BITVROW-1:0] t2_addrA_wp_wire = t2_addrA >> ((t2_int*(NUMRWPT+NUMWRPT)+t2r_int)*BITVROW);
          assert_t2_ww_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t2_writeA_wire && t2_writeA_wp_wire && (t2_addrA_wire == select_row)) |-> (t2_addrA_wire != t2_addrA_wp_wire));
        end

      for (t2r_int=0; t2r_int<NUMRDPT+NUMRWPT+NUMWRPT; t2r_int=t2r_int+1) begin: t2rp_loop
        wire t2_readB_wire = t2_readB >> (t2_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t2r_int);
        wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> ((t2_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t2r_int)*BITVROW);
        assert_t2_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && t2_writeA_wire && t2_readB_wire) |-> (t2_addrA_wire != t2_addrB_wire));
      end
    end

    for (t2r_int=0; t2r_int<NUMRDPT+NUMRWPT+NUMWRPT; t2r_int=t2r_int+1) begin: t2r_loop
      wire t2_readB_wire = t2_readB >> (t2_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t2r_int);
      wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> ((t2_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t2r_int)*BITVROW);
      assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
    end
  end
endgenerate

genvar t3_int, t3w_int, t3r_int;
generate
  for (t3_int=0; t3_int<NUMCASH; t3_int=t3_int+1) begin: t3_loop
    for (t3w_int=0; t3w_int<NUMRWPT+NUMWRPT; t3w_int=t3w_int+1) begin: t3w_loop
      wire t3_writeA_wire = t3_writeA >> t3_int*(NUMRWPT+NUMWRPT)+t3w_int;
      wire [BITVROW-1:0] t3_addrA_wire = t3_addrA >> ((t3_int*(NUMRWPT+NUMWRPT)+t3w_int)*BITVROW);
      assert_t3_wr_range_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_addrA_wire < NUMVROW));

      for (t3r_int=0; t3r_int<NUMRWPT+NUMWRPT; t3r_int=t3r_int+1)
        if (t3r_int != t3w_int) begin: t3wp_loop
          wire t3_writeA_wp_wire = t3_writeA >> t3_int*(NUMRWPT+NUMWRPT)+t3r_int;
          wire [BITVROW-1:0] t3_addrA_wp_wire = t3_addrA >> ((t3_int*(NUMRWPT+NUMWRPT)+t3r_int)*BITVROW);
          assert_t3_ww_pseudo_check: assert property (@(posedge clk) disable iff (rst) (t3_writeA_wire && t3_writeA_wp_wire) |-> (t3_addrA_wire != t3_addrA_wp_wire));
        end

      for (t3r_int=0; t3r_int<NUMRDPT+NUMRWPT+NUMWRPT; t3r_int=t3r_int+1) begin: t3rp_loop
        wire t3_readB_wire = t3_readB >> (t3_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t3r_int);
        wire [BITVROW-1:0] t3_addrB_wire = t3_addrB >> ((t3_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t3r_int)*BITVROW);
        assert_t3_rw_pseudo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && t3_writeA_wire && t3_readB_wire) |-> (t3_addrA_wire != t3_addrB_wire));
      end
    end

    for (t3r_int=0; t3r_int<NUMRDPT+NUMRWPT+NUMWRPT; t3r_int=t3r_int+1) begin: t3r_loop
      wire t3_readB_wire = t3_readB >> (t3_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t3r_int);
      wire [BITVROW-1:0] t3_addrB_wire = t3_addrB >> ((t3_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t3r_int)*BITVROW);
      assert_t3_rd_range_check: assert property (@(posedge clk) disable iff (rst) t3_readB_wire |-> (t3_addrB_wire < NUMVROW));
    end
  end
endgenerate

endmodule


module ip_top_sva_mrnrwpw_1rw_rl
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     ENAPAR  = 0,
parameter     ENAECC  = 0,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMRDPT = 1,
parameter     NUMRWPT = 1,
parameter     NUMWRPT = 2,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     BITPBNK = 4,
parameter     BITPADR = 14,
parameter     REFRESH = 0,
parameter     ECCBITS = 4,
parameter     SRAM_DELAY = 2,
parameter     DRAM_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0,
parameter     NUMCASH = NUMRDPT+NUMRWPT+NUMWRPT-1,
parameter     SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS,
parameter     FIFOCNT = REFRESH ? (NUMRWPT+NUMWRPT)*(SRAM_DELAY+REFRESH) : NUMRWPT+NUMWRPT
   )
(
  input clk,
  input rst,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] read,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] write,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITADDR-1:0] addr,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] din,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] rd_vld,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] rd_dout,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] rd_fwrd,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] rd_serr,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] rd_derr,
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0] rd_padr,
  input [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_readA,
  input [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_writeA,
  input [(NUMRDPT+NUMRWPT)*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [(NUMRDPT+NUMRWPT)*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [(NUMRDPT+NUMRWPT)*NUMVBNK*WIDTH-1:0] t1_doutA,
  input [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_fwrdA,
  input [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_serrA,
  input [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_derrA,
  input [(NUMRDPT+NUMRWPT)*NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrA,
  input [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t2_writeA,
  input [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrA,
  input [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_dinA,
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB,
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrB,
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB,
  input [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA,
  input [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW-1:0] t3_addrA,
  input [NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_dinA,
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB,
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t3_addrB,
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_doutB,
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_fwrdB,
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_serrB,
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_derrB,
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*(BITPADR-BITPBNK)-1:0] t3_padrB,
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

reg read_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg write_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg [BITADDR-1:0] addr_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg [WIDTH-1:0] din_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg rd_vld_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg [WIDTH-1:0] rd_dout_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg rd_fwrd_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg rd_serr_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg rd_derr_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg [BITPADR-1:0] rd_padr_wire [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
integer prt_int;
always_comb
  for (prt_int=0; prt_int<NUMRDPT+NUMRWPT+NUMWRPT; prt_int=prt_int+1) begin
    read_wire[prt_int] = read >> prt_int;
    write_wire[prt_int] = write >> prt_int;
    addr_wire[prt_int] = addr >> (prt_int*BITADDR);
    din_wire[prt_int] = din >> (prt_int*WIDTH);
    rd_vld_wire[prt_int] = rd_vld >> prt_int;
    rd_dout_wire[prt_int] = rd_dout >> (prt_int*WIDTH);
    rd_fwrd_wire[prt_int] = rd_fwrd >> prt_int;
    rd_serr_wire[prt_int] = rd_serr >> prt_int;
    rd_derr_wire[prt_int] = rd_derr >> prt_int;
    rd_padr_wire[prt_int] = rd_padr >> (prt_int*BITPADR);
  end

assert_rw1_rw2_np2_check: assert property (@(posedge clk) disable iff (rst) ((read_wire[0] || write_wire[0]) && (read_wire[1] || write_wire[1])) |-> ##FLOPIN
				       ((core.vaddr_wire[0] == core.vaddr_wire[1]) == ((core.vbadr_wire[0] == core.vbadr_wire[1]) && (core.vradr_wire[0] == core.vradr_wire[1]))));
assert_rw1_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] || write_wire[0]) |-> ##FLOPIN
					  ((core.vaddr_wire[0] == select_addr) == ((core.vbadr_wire[0] == select_bank) && (core.vradr_wire[0] == select_row)))); 
assert_rw2_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (read_wire[1] || write_wire[1]) |-> ##FLOPIN
					  ((core.vaddr_wire[1] == select_addr) == ((core.vbadr_wire[1] == select_bank) && (core.vradr_wire[1] == select_row)))); 

assert_rw1_np2_range_check: assert property (@(posedge clk) disable iff (rst) (read_wire[0] || write_wire[0]) |-> ##FLOPIN
					     ((core.vbadr_wire[0] < NUMVBNK) && (core.vradr_wire[0] < NUMVROW)));
assert_rw2_np2_range_check: assert property (@(posedge clk) disable iff (rst) (read_wire[1] || write_wire[1]) |-> ##FLOPIN
					     ((core.vbadr_wire[1] < NUMVBNK) && (core.vradr_wire[1] < NUMVROW)));
assert_sl_np2_range_check: assert property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR) |->
					    ((select_bank < NUMVBNK) && (select_row < NUMVROW))); 
/*
wire t1_readA_sel_wire = t1_readA >> select_bank;
wire t1_writeA_sel_wire = t1_writeA >> select_bank;
wire [BITVROW-1:0] t1_addrA_sel_wire = t1_addrA >> (select_bank*BITVROW);
wire [WIDTH-1:0] t1_dinA_sel_wire = t1_dinA >> (select_bank*WIDTH);
wire [WIDTH-1:0] t1_doutA_sel_wire = t1_doutA >> (select_bank*WIDTH);
wire t1_fwrdA_sel_wire = t1_fwrdA >> select_bank;
wire t1_serrA_sel_wire = t1_serrA >> select_bank;
wire t1_derrA_sel_wire = t1_derrA >> select_bank;
wire [BITPADR-BITPBNK-1:0] t1_padrA_sel_wire = t1_padrA >> (select_bank*(BITPADR-BITPBNK));
*/
wire t1_readA_sel_wire [0:NUMRDPT+NUMRWPT-1];
wire t1_writeA_sel_wire [0:NUMRDPT+NUMRWPT-1];
wire [BITVROW-1:0] t1_addrA_sel_wire [0:NUMRDPT+NUMRWPT-1];
wire [WIDTH-1:0] t1_dinA_sel_wire [0:NUMRDPT+NUMRWPT-1];
wire [WIDTH-1:0] t1_doutA_sel_wire [0:NUMRDPT+NUMRWPT-1];
wire t1_fwrdA_sel_wire [0:NUMRDPT+NUMRWPT-1];
wire t1_serrA_sel_wire [0:NUMRDPT+NUMRWPT-1];
wire t1_derrA_sel_wire [0:NUMRDPT+NUMRWPT-1];
wire [BITPADR-BITPBNK-1:0] t1_padrA_sel_wire [0:NUMRDPT+NUMRWPT-1];
genvar t1_int;
generate for (t1_int=0; t1_int<NUMRDPT+NUMRWPT; t1_int=t1_int+1) begin: t1_loop
  assign t1_readA_sel_wire[t1_int] = t1_readA >> ((NUMRDPT+NUMRWPT)*select_bank+t1_int);
  assign t1_writeA_sel_wire[t1_int] = t1_writeA >> ((NUMRDPT+NUMRWPT)*select_bank+t1_int);
  assign t1_addrA_sel_wire[t1_int] = t1_addrA >> (((NUMRDPT+NUMRWPT)*select_bank+t1_int)*BITVROW);
  assign t1_dinA_sel_wire[t1_int] = t1_dinA >> (((NUMRDPT+NUMRWPT)*select_bank+t1_int)*WIDTH);
  assign t1_doutA_sel_wire[t1_int] = t1_doutA >> (((NUMRDPT+NUMRWPT)*select_bank+t1_int)*WIDTH);
  assign t1_fwrdA_sel_wire[t1_int] = t1_fwrdA >> ((NUMRDPT+NUMRWPT)*select_bank+t1_int);
  assign t1_serrA_sel_wire[t1_int] = t1_serrA >> ((NUMRDPT+NUMRWPT)*select_bank+t1_int);
  assign t1_derrA_sel_wire[t1_int] = t1_derrA >> ((NUMRDPT+NUMRWPT)*select_bank+t1_int);
  assign t1_padrA_sel_wire[t1_int] = t1_padrA >> (((NUMRDPT+NUMRWPT)*select_bank+t1_int)*(BITPADR-BITPBNK));
end
endgenerate

wire t2_writeA_wire [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
wire [BITVROW-1:0] t2_addrA_wire [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
wire [SDOUT_WIDTH-1:0] t2_dinA_wire [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
wire t2_readB_wire [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
wire [BITVROW-1:0] t2_addrB_wire [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
wire [SDOUT_WIDTH-1:0] t2_doutB_wire [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
genvar t2_int, t2p_int;
generate for (t2_int=0; t2_int<NUMCASH; t2_int=t2_int+1) begin: t2_loop
  for (t2p_int=0; t2p_int<NUMRWPT+NUMWRPT; t2p_int=t2p_int+1) begin: wr_loop
    assign t2_writeA_wire[t2_int][t2p_int] = t2_writeA >> (t2_int*(NUMRWPT+NUMWRPT)+t2p_int);
    assign t2_addrA_wire[t2_int][t2p_int] = t2_addrA >> ((t2_int*(NUMRWPT+NUMWRPT)+t2p_int)*BITVROW);
    assign t2_dinA_wire[t2_int][t2p_int] = t2_dinA >> ((t2_int*(NUMRWPT+NUMWRPT)+t2p_int)*SDOUT_WIDTH);
  end
  for (t2p_int=0; t2p_int<NUMRDPT+NUMRWPT+NUMWRPT; t2p_int=t2p_int+1) begin: rd_loop
    assign t2_readB_wire[t2_int][t2p_int] = t2_readB >> (t2_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t2p_int);
    assign t2_addrB_wire[t2_int][t2p_int] = t2_addrB >> ((t2_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t2p_int)*BITVROW);
    assign t2_doutB_wire[t2_int][t2p_int] = t2_doutB >> ((t2_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t2p_int)*SDOUT_WIDTH); 
  end
end
endgenerate

wire t3_writeA_wire [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
wire [BITVROW-1:0] t3_addrA_wire [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
wire [WIDTH-1:0] t3_dinA_wire [0:NUMCASH-1][0:NUMRWPT+NUMWRPT-1];
wire t3_readB_wire [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
wire [BITVROW-1:0] t3_addrB_wire [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
wire [WIDTH-1:0] t3_doutB_wire [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
wire t3_fwrdB_wire [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
wire t3_serrB_wire [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
wire t3_derrB_wire [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
wire [BITPADR-BITPBNK-1:0] t3_padrB_wire [0:NUMCASH-1][0:NUMRDPT+NUMRWPT+NUMWRPT-1];
genvar t3_int, t3p_int;
generate for (t3_int=0; t3_int<NUMCASH; t3_int=t3_int+1) begin: t3_loop
  for (t3p_int=0; t3p_int<NUMRWPT+NUMWRPT; t3p_int=t3p_int+1) begin: wr_loop
    assign t3_writeA_wire[t3_int][t3p_int] = t3_writeA >> (t3_int*(NUMRWPT+NUMWRPT)+t3p_int);
    assign t3_addrA_wire[t3_int][t3p_int] = t3_addrA >> ((t3_int*(NUMRWPT+NUMWRPT)+t3p_int)*BITVROW);
    assign t3_dinA_wire[t3_int][t3p_int] = t3_dinA >> ((t3_int*(NUMRWPT+NUMWRPT)+t3p_int)*WIDTH);
  end
  for (t3p_int=0; t3p_int<NUMRDPT+NUMRWPT+NUMWRPT; t3p_int=t3p_int+1) begin: rd_loop
    assign t3_readB_wire[t3_int][t3p_int] = t3_readB >> (t3_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t3p_int);
    assign t3_addrB_wire[t3_int][t3p_int] = t3_addrB >> ((t3_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t3p_int)*BITVROW);
    assign t3_doutB_wire[t3_int][t3p_int] = t3_doutB >> ((t3_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t3p_int)*WIDTH); 
    assign t3_fwrdB_wire[t3_int][t3p_int] = t3_fwrdB >> (t3_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t3p_int);
    assign t3_serrB_wire[t3_int][t3p_int] = t3_serrB >> (t3_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t3p_int);
    assign t3_derrB_wire[t3_int][t3p_int] = t3_derrB >> (t3_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t3p_int);
    assign t3_padrB_wire[t3_int][t3p_int] = t3_padrB >> ((t3_int*(NUMRDPT+NUMRWPT+NUMWRPT)+t3p_int)*(BITPADR-BITPBNK)); 
  end
end
endgenerate

reg pmeminv;
reg pmem;
always @(posedge clk)
  if (rst)
    pmeminv <= 1'b1;
  else if (t1_writeA_sel_wire[0] && (t1_addrA_sel_wire[0] == select_row)) begin
    pmeminv <= 1'b0;
    pmem <= t1_dinA_sel_wire[0][select_bit];
  end

reg [SDOUT_WIDTH-1:0] smem [0:NUMCASH-1];
reg cmem [0:NUMCASH-1];
genvar mem_int;
generate for (mem_int=0; mem_int<NUMCASH; mem_int=mem_int+1) begin: mem_loop
  reg [SDOUT_WIDTH-1:0] smem_next;
  reg cmem_next;
  integer mwp_int;
  always_comb begin
    smem_next = smem[mem_int];
    cmem_next = cmem[mem_int];
    if (rst)
      smem_next = 0;
    else for (mwp_int=0; mwp_int<NUMRWPT+NUMWRPT; mwp_int=mwp_int+1)
      if (t2_writeA_wire[mem_int][mwp_int] && (t2_addrA_wire[mem_int][mwp_int] == select_row))
        smem_next = t2_dinA_wire[mem_int][mwp_int];
    if (rst)
      cmem_next = 0;
    else for (mwp_int=0; mwp_int<NUMRWPT+NUMWRPT; mwp_int=mwp_int+1)
      if (t3_writeA_wire[mem_int][mwp_int] && (t3_addrA_wire[mem_int][mwp_int] == select_row))
        cmem_next = t3_dinA_wire[mem_int][mwp_int][select_bit];
  end

  always @(posedge clk) begin
    smem[mem_int] <= smem_next;
    cmem[mem_int] <= cmem_next;
  end
end
endgenerate
/*
wire [SDOUT_WIDTH-1:0] smem_wire_0 = smem[0];
wire [SDOUT_WIDTH-1:0] smem_wire_1 = smem[1];
wire [SDOUT_WIDTH-1:0] smem_wire_2 = smem[2];
wire cmem_wire_0 = cmem[0];
wire cmem_wire_1 = cmem[1];
wire cmem_wire_2 = cmem[2];
*/
reg mem_wire;
integer mem_wire_int;
always_comb begin
  mem_wire = pmem;
  for (mem_wire_int=0; mem_wire_int<NUMCASH; mem_wire_int=mem_wire_int+1)
    if (smem[mem_wire_int][BITVBNK] && (smem[mem_wire_int][BITVBNK-1:0] == select_bank))
      mem_wire = cmem[mem_wire_int];
end

genvar esmem_int, esmem_int2;
generate for (esmem_int=0; esmem_int<NUMCASH; esmem_int=esmem_int+1) begin: esmem_loop
  wire [ECCBITS-1:0] smem_ecc;
  ecc_calc   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
    ecc_calc_inst (.din(smem[esmem_int][BITVBNK:0]), .eccout(smem_ecc));
  assert_smem_ecc_check: assert property (@(posedge clk) disable iff (rst) (smem[esmem_int] == {smem[esmem_int][BITVBNK:0],smem_ecc,smem[esmem_int][BITVBNK:0]}));
  for (esmem_int2=0; esmem_int2<NUMCASH; esmem_int2=esmem_int2+1) begin: esmem2_loop
    if (esmem_int!=esmem_int2)
      assert_smem_diff_check: assert property (@(posedge clk) disable iff (rst) !(smem[esmem_int][BITVBNK] && smem[esmem_int2][BITVBNK] &&
							                          (smem[esmem_int][BITVBNK-1:0] == smem[esmem_int2][BITVBNK-1:0])));	
  end
end
endgenerate

genvar pdout_int;
generate for (pdout_int=0; pdout_int<NUMRDPT+NUMRWPT; pdout_int=pdout_int+1) begin: pdout_loop
  assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_sel_wire[pdout_int] && (t1_addrA_sel_wire[pdout_int] == select_row)) |-> ##DRAM_DELAY
				       ($past(pmeminv,DRAM_DELAY) ||
                                        (!t1_fwrdA_sel_wire[pdout_int] && (ENAPAR ? t1_serrA_sel_wire[pdout_int] : ENAECC ? t1_derrA_sel_wire[pdout_int] : 0)) ||
                                        (t1_doutA_sel_wire[pdout_int][select_bit] == $past(pmem,DRAM_DELAY))));
end
endgenerate

genvar smem_gen, scsh_int;
generate for (smem_gen=0; smem_gen<NUMRDPT+NUMRWPT+NUMWRPT; smem_gen=smem_gen+1) begin: smem_loop
  for (scsh_int=0; scsh_int<NUMCASH; scsh_int=scsh_int+1) begin: scsh_loop
  assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[scsh_int][smem_gen] && (t2_addrB_wire[scsh_int][smem_gen] == select_row)) |-> ##SRAM_DELAY
				       (t2_doutB_wire[scsh_int][smem_gen] == $past(smem[scsh_int],SRAM_DELAY)));
  assert_cdout_check: assert property (@(posedge clk) disable iff (rst) (t3_readB_wire[scsh_int][smem_gen] && (t3_addrB_wire[scsh_int][smem_gen] == select_row)) |-> ##SRAM_DELAY
				       (t3_doutB_wire[scsh_int][smem_gen][select_bit] == $past(cmem[scsh_int],SRAM_DELAY)));
  assert_sdout_ecc_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[scsh_int][smem_gen] && (t2_addrB_wire[scsh_int][smem_gen] == select_row)) |-> ##SRAM_DELAY
				           (core.sdout_out[scsh_int][smem_gen] == $past(smem[scsh_int][BITVBNK:0],SRAM_DELAY)));
  end
end
endgenerate

genvar state_int, stcsh_int;
generate for (state_int=0; state_int<NUMRDPT+NUMRWPT+NUMWRPT; state_int=state_int+1) begin: state_loop
  for (stcsh_int=0; stcsh_int<NUMCASH; stcsh_int=stcsh_int+1) begin: scsh_loop
    wire state_serr = 0;
    wire state_derr = 0;
    wire state_nerr = !state_serr && !state_derr;
    assume_state_err_check: assert property (@(posedge clk) disable iff (rst) !(state_serr && state_derr));
    assume_state_serr_check: assert property (@(posedge clk) disable iff (rst) state_serr |-> ##SRAM_DELAY
  					      core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_serr && !core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_derr);
    assume_state_derr_check: assert property (@(posedge clk) disable iff (rst) state_derr |-> ##SRAM_DELAY
					      !core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_serr && core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_derr);
    assume_state_nerr_check: assert property (@(posedge clk) disable iff (rst) state_nerr |-> ##SRAM_DELAY
					      !core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_serr && !core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_derr);

    assert_sdout_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[stcsh_int][state_int] && (t2_addrB_wire[stcsh_int][state_int] == select_row) && state_nerr) |-> ##SRAM_DELAY
					      !core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_ded_err && !core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_sec_err &&
					      (core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_dup_data == core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_post_ecc));
    assert_sdout_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[stcsh_int][state_int] && (t2_addrB_wire[stcsh_int][state_int] == select_row) && state_serr) |-> ##SRAM_DELAY
					      !core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_ded_err && (core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_sec_err ?
					      (core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_dup_data == core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_post_ecc) :
					      (core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_dup_data != core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_post_ecc)));
    assert_sdout_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire[stcsh_int][state_int] && (t2_addrB_wire[stcsh_int][state_int] == select_row) && state_derr) |-> ##SRAM_DELAY
					      core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_ded_err ? !core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_sec_err :
					      core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_sec_err ?
					      !core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_ded_err && (core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_dup_data != core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_post_ecc) :
					      (core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_dup_data != core.csh_loop[stcsh_int].sdo_loop[state_int].sdout_post_ecc));
  end
end
endgenerate

genvar fwd_int, fcsh_int;
generate begin: fwd_loop
  for (fwd_int=0; fwd_int<NUMRDPT+NUMRWPT+NUMWRPT; fwd_int=fwd_int+1) begin: fwrm_loop
    for (fcsh_int=0; fcsh_int<NUMCASH; fcsh_int=fcsh_int+1) begin: fcsh_loop
      assert_mapw_fwd_check: assert property (@(posedge clk) disable iff (rst) ((core.vread_wire[fwd_int] || core.vwrite_wire[fwd_int]) && (core.vradr_wire[fwd_int] == select_row)) |-> ##SRAM_DELAY
                                              (core.mapw_out[fcsh_int][fwd_int] == smem[fcsh_int][BITVBNK:0]));
      assert_cdatw_fwd_check: assert property (@(posedge clk) disable iff (rst) ((core.vread_wire[fwd_int] || core.vwrite_wire[fwd_int]) && (core.vradr_wire[fwd_int] == select_row)) |-> ##SRAM_DELAY
                                               (core.cdatw_out[fcsh_int][fwd_int][select_bit] == cmem[fcsh_int]));
      if (SRAM_DELAY==DRAM_DELAY) begin: sym_loop
        assert_mapr_fwd_check: assert property (@(posedge clk) disable iff (rst) ((core.vread_wire[fwd_int] || core.vwrite_wire[fwd_int]) && (core.vradr_wire[fwd_int] == select_row)) |-> ##DRAM_DELAY
                                               (core.mapr_out[fcsh_int][fwd_int] == smem[fcsh_int][BITVBNK:0]));
        assert_cdatr_fwd_check: assert property (@(posedge clk) disable iff (rst) ((core.vread_wire[fwd_int] || core.vwrite_wire[fwd_int]) && (core.vradr_wire[fwd_int] == select_row)) |-> ##DRAM_DELAY
                                                 (core.cdatr_out[fcsh_int][fwd_int][select_bit] == cmem[fcsh_int]));
      end else begin: asym_loop
        assert_mapr_fwd_check: assert property (@(posedge clk) disable iff (rst) ((core.vread_wire[fwd_int] || core.vwrite_wire[fwd_int]) && (core.vradr_wire[fwd_int] == select_row)) |-> ##DRAM_DELAY
                                                (core.mapr_out[fcsh_int][fwd_int] == $past(smem[fcsh_int][BITVBNK:0],DRAM_DELAY-SRAM_DELAY)));
        assert_cdatr_fwd_check: assert property (@(posedge clk) disable iff (rst) ((core.vread_wire[fwd_int] || core.vwrite_wire[fwd_int]) && (core.vradr_wire[fwd_int] == select_row)) |-> ##DRAM_DELAY
                                                 (core.cdatr_out[fcsh_int][fwd_int][select_bit] == $past(cmem[fcsh_int],DRAM_DELAY-SRAM_DELAY)));
      end
    end
  end
  for (fwd_int=0; fwd_int<NUMRDPT+NUMRWPT; fwd_int=fwd_int+1) begin: frdm_loop
    if (SRAM_DELAY==DRAM_DELAY) begin: sym_loop
      assert_pdatr_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[fwd_int] && (core.vbadr_wire[fwd_int] == select_bank) && (core.vradr_wire[fwd_int] == select_row)) |-> ##DRAM_DELAY
                                               (pmeminv || (core.pdatr_out[fwd_int][select_bit] == pmem)));
    end else begin: asym_loop
      assert_pdatr_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[fwd_int] && (core.vbadr_wire[fwd_int] == select_bank) && (core.vradr_wire[fwd_int] == select_row)) |-> ##DRAM_DELAY
                                               ($past(pmeminv,DRAM_DELAY-SRAM_DELAY) || (core.pdatr_out[fwd_int][select_bit] == $past(pmem,DRAM_DELAY-SRAM_DELAY))));
    end
  end
end
endgenerate

genvar socs_int, sopt_int;
generate for (socs_int=0; socs_int<NUMCASH; socs_int=socs_int+1) begin: socs_loop
  for (sopt_int=0; sopt_int<NUMRWPT+NUMWRPT; sopt_int=sopt_int+1) begin: sopt_loop
    assert_sold_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.snew_vld[sopt_int] && (core.snew_row[sopt_int] == select_row)) |->
					    (({core.sold_vld[socs_int][sopt_int],core.sold_map[socs_int][sopt_int]} == smem[socs_int][BITVBNK:0]) &&
					     (core.sold_dat[socs_int][sopt_int][select_bit] == cmem[socs_int])));
  end
end
endgenerate

assert_wrfifo_check: assert property (@(posedge clk) disable iff (rst) (core.wrfifo_cnt <= FIFOCNT));

reg rmeminv;
reg rmeminv_next;
reg rmem;
reg rmem_next;
integer rmem_int;
always_comb begin
  rmeminv_next = rmeminv;
  rmem_next = rmem;
  if (rst)
    rmeminv_next = 1'b1;
  else for (rmem_int=0; rmem_int<NUMRWPT+NUMWRPT; rmem_int=rmem_int+1)
    if (core.snew_vld[rmem_int] && (core.snew_map[rmem_int] == select_bank) && (core.snew_row[rmem_int] == select_row)) begin
      rmeminv_next = 1'b0;
      rmem_next = core.snew_dat[rmem_int][select_bit];
    end
end

always @(posedge clk) begin
  rmeminv <= rmeminv_next;
  rmem <= rmem_next;
end

/*
reg rmeminv;
reg rmem;
integer rmem_int;
always @(posedge clk)
  if (rst)
    rmeminv <= 1'b1;
//  else for (rmem_int=0; rmem_int<NUMRWPT+NUMWRPT; rmem_int=rmem_int+1)
  else if (core.snew_vld_wire[1] && (core.snew_map_wire[2*BITVBNK-1:BITVBNK] == select_bank) && (core.snew_row_wire[2*BITVROW-1:BITVROW] == select_row)) begin
    rmeminv <= 1'b0;
    rmem <= core.snew_dat[1][select_bit];
  end else if (core.snew_vld_wire[0] && (core.snew_map_wire[BITVBNK-1:0] == select_bank) && (core.snew_row_wire[BITVROW-1:0] == select_row)) begin
    rmeminv <= 1'b0;
    rmem <= core.snew_dat[0][select_bit];
  end
*/
assert_rmem_check: assert property (@(posedge clk) disable iff (rst) (rmeminv || (mem_wire == rmem)));

genvar vdi_var;
generate for (vdi_var=0; vdi_var<NUMRDPT+NUMRWPT; vdi_var=vdi_var+1) begin: vdi_loop
  if (SRAM_DELAY==DRAM_DELAY) begin: sym_loop
    assert_vdout_int_check: assert property (@(posedge clk) disable iff (rst) (read_wire[vdi_var] && (addr_wire[vdi_var] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY)
                                             (rmeminv || (core.vdout_int[vdi_var][select_bit] == rmem)));
  end else begin: asym_loop
    assert_vdout_int_check: assert property (@(posedge clk) disable iff (rst) (read_wire[vdi_var] && (addr_wire[vdi_var] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY)
                                             ($past(rmeminv,FLOPIN+DRAM_DELAY-SRAM_DELAY-1) || (core.vdout_int[vdi_var][select_bit] == $past(rmem,FLOPIN+DRAM_DELAY-SRAM_DELAY-1))));
  end
end
endgenerate

reg vmeminv;
reg vmeminv_next;
reg vmem;
reg vmem_next;
integer vmem_int;
always_comb begin
  vmeminv_next = vmeminv;
  vmem_next = vmem;
  if (rst)
    vmeminv_next = 1'b1;
  else
 for (vmem_int=NUMRDPT; vmem_int<NUMRDPT+NUMRWPT+NUMWRPT; vmem_int=vmem_int+1)
    if (core.vwrite_out[vmem_int] && (core.vwrbadr_out[vmem_int] == select_bank) && (core.vwrradr_out[vmem_int] == select_row)) begin
      vmeminv_next = 1'b0;
      vmem_next = core.vdin_out[vmem_int] >> select_bit;
    end
end

always @(posedge clk) begin
  vmeminv <= vmeminv_next;
  vmem <= vmem_next;
end

/*
reg vmeminv;
reg vmem;
always @(posedge clk)
  if (rst)
    vmeminv <= 1'b1;
  else if (core.vwrite_out_wire_2 && (core.vwrbadr_out_wire_2 == select_bank) && (core.vwrradr_out_wire_2 == select_row)) begin
    vmeminv <= 1'b0;
    vmem <= core.vdin_out_wire_2[select_bit];
  end else if (core.vwrite_out_wire_1 && (core.vwrbadr_out_wire_1 == select_bank) && (core.vwrradr_out_wire_1 == select_row)) begin
    vmeminv <= 1'b0;
    vmem <= core.vdin_out_wire_1[select_bit];
  end
*/
assert_vmem_check: assert property (@(posedge clk) disable iff (rst) (vmeminv || ((core.wr_srch_flags ? core.wr_srch_datas[select_bit] : rmem) == vmem)));

genvar srch_var;
generate for (srch_var=0; srch_var<NUMRDPT+NUMRWPT; srch_var=srch_var+1) begin: srch_loop
  assert_srch_check: assert property (@(posedge clk) disable iff (rst) (read_wire[srch_var] && (addr_wire[srch_var] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY)
                                      (vmeminv || (rmeminv ? (core.wr_srch_flag[srch_var] && (core.wr_srch_data[srch_var][select_bit] == vmem)) :
                                                             ((core.wr_srch_flag[srch_var] ? core.wr_srch_data[srch_var][select_bit] : rmem) == vmem))));
end
endgenerate

reg fakemem;
reg fakememinv;
reg fakemem_next;
reg fakememinv_next;
integer fmem_int;
always_comb begin
  fakememinv_next = fakememinv;
  fakemem_next = fakemem;
  if (rst)
    fakememinv_next = 1'b1;
  else for (fmem_int=NUMRDPT; fmem_int<NUMRDPT+NUMRWPT+NUMWRPT; fmem_int=fmem_int+1)
    if (write_wire[fmem_int] && (addr_wire[fmem_int] == select_addr)) begin
      fakememinv_next = 1'b0;
      fakemem_next = din_wire[fmem_int][select_bit];
    end
end

always @(posedge clk) begin
  fakememinv <= fakememinv_next;
  fakemem <= fakemem_next;
end

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(FLOPIN+SRAM_DELAY)
				       ($past(fakememinv,FLOPIN+SRAM_DELAY) || ($past(fakemem,FLOPIN+SRAM_DELAY) == vmem)));

genvar dout_int;
generate for (dout_int=0; dout_int<NUMRDPT+NUMRWPT; dout_int=dout_int+1) begin: dout_loop
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_int] && (addr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
                                      (rd_vld_wire[dout_int] && ($past(fakememinv,FLOPIN+DRAM_DELAY+FLOPOUT) || (rd_dout_wire[dout_int][select_bit] == $past(fakemem,FLOPIN+DRAM_DELAY+FLOPOUT)))));
//  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_int] && (addr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
//                                      (rd_padr_wire[dout_int][BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) ?
//                                       ((rd_serr_wire[dout_int] == (FLOPOUT ? $past(t3_serrB_wire[0][dout_int]) : t3_serrB_wire[0][dout_int])) &&
//                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t3_derrB_wire[0][dout_int]) : t3_derrB_wire[0][dout_int]))) :
//                                      (rd_padr_wire[dout_int][BITPADR-1:BITPADR-BITPBNK] == (NUMVBNK+1)) ?
//                                       ((rd_serr_wire[dout_int] == (FLOPOUT ? $past(t3_serrB_wire[1][dout_int]) : t3_serrB_wire[1][dout_int])) &&
//                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t3_derrB_wire[1][dout_int]) : t3_derrB_wire[1][dout_int]))) :
//                                       ((rd_serr_wire[dout_int] == (FLOPOUT ? $past(t1_serrA_sel_wire[dout_int]) : t1_serrA_sel_wire[dout_int])) &&
//                                        (rd_derr_wire[dout_int] == (FLOPOUT ? $past(t1_derrA_sel_wire[dout_int]) : t1_derrA_sel_wire[dout_int]))));
//  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_int] && (addr_wire[dout_int] == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+FLOPOUT)
//                                      (&rd_padr_wire[dout_int] ||
//                                      (rd_padr_wire[dout_int] == ((NUMVBNK << (BITPADR-BITPBNK)) | select_row)) ||
//                                      (rd_padr_wire[dout_int] == (((NUMVBNK+1) << (BITPADR-BITPBNK)) | select_row)) ||
//                                      (rd_padr_wire[dout_int] == {select_bank,(FLOPOUT ? $past(t1_padrA_sel_wire[dout_int]) : t1_padrA_sel_wire[dout_int])})));

end
endgenerate

endmodule

