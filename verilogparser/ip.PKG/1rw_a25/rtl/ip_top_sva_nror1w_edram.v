module ip_top_sva_2_nror1w_edram
  #(parameter
     WIDTH = 8,
     NUMADDR = 8192,
     BITADDR = 13,
     NUMVRPT = 2,
     NUMPRPT = 1,
     NUMVROW = 1024,
     BITVROW = 10,
     NUMVBNK = 8,
     BITVBNK = 3,
     NUMRBNK = 8,
     BITRBNK = 3,
     REFRESH = 10,
     REFFREQ = 16)
(
  input clk,
  input rst,
  input ready,
  input refr,
  input [BITRBNK-1:0] rf_bnk,
  input [BITADDR-1:0] rf_adr,
  input [NUMVRPT-1:0] read,
  input [NUMVRPT*BITRBNK-1:0] rd_bnk, 
  input [NUMVRPT*BITADDR-1:0] rd_adr,
  input write,
  input [BITRBNK-1:0] wr_bnk,
  input [BITADDR-1:0] wr_adr,
  input [NUMPRPT*NUMVBNK-1:0] t1_readA,
  input [NUMPRPT*NUMVBNK-1:0] t1_writeA,
  input [NUMPRPT*NUMVBNK*BITRBNK-1:0] t1_bankA,
  input [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMPRPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMPRPT*NUMVBNK-1:0] t1_refrB,
  input [NUMPRPT-1:0] t2_readA,
  input [NUMPRPT-1:0] t2_writeA,
  input [NUMPRPT*BITRBNK-1:0] t2_bankA,
  input [NUMPRPT*BITVROW-1:0] t2_addrA,
  input [NUMPRPT*WIDTH-1:0] t2_dinA,
  input [NUMPRPT-1:0] t2_refrB
);

assert_refr_check: assert property (@(posedge clk) disable iff (!ready) (REFRESH && !refr) |-> ##[1:REFFREQ-1] refr);
assert_refr_noacc_check: assume property (@(posedge clk) disable iff (rst) REFRESH |-> !(refr && (write || |read)));
assert_rf_range_check: assume property (@(posedge clk) disable iff (rst) refr |-> (rf_bnk < NUMRBNK) && (rf_adr < NUMADDR));
assert_rd_wr_check: assume property (@(posedge clk) disable iff (rst) !(write && |read));
assert_wr_range_check: assume property (@(posedge clk) disable iff (rst) write |-> (wr_bnk < NUMRBNK) && (wr_adr < NUMADDR));
genvar rd_int;
generate for (rd_int=0; rd_int<NUMVRPT; rd_int=rd_int+1) begin: rd_loop
  wire read_wire = read >> rd_int;
  wire [BITRBNK-1:0] rd_bnk_wire = rd_bnk >> (rd_int*BITRBNK);
  wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (rd_int*BITADDR);

  assert_rd_range_check: assume property (@(posedge clk) disable iff (rst) read_wire |-> (rd_bnk_wire < NUMRBNK) && (rd_adr_wire < NUMADDR));
end
endgenerate

genvar t1_vbnk_int, t1_prpt_int;
generate for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin: t1_vbnk_loop
  for (t1_prpt_int=0; t1_prpt_int<NUMPRPT; t1_prpt_int=t1_prpt_int+1) begin: t1_prpt_loop
    wire t1_readA_wire = t1_readA >> (NUMPRPT*t1_vbnk_int+t1_prpt_int);
    wire t1_writeA_wire = t1_writeA >> (NUMPRPT*t1_vbnk_int+t1_prpt_int);
    wire [BITRBNK-1:0] t1_bankA_wire = t1_bankA >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*BITRBNK);
    wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*BITVROW);
    wire [WIDTH-1:0] t1_dinA_wire = t1_dinA >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*WIDTH);

    wire t1_writeA_0_wire = t1_writeA >> (NUMPRPT*t1_vbnk_int);
    wire [BITRBNK-1:0] t1_bankA_0_wire = t1_bankA >> (NUMPRPT*t1_vbnk_int*BITRBNK);
    wire [BITVROW-1:0] t1_addrA_0_wire = t1_addrA >> (NUMPRPT*t1_vbnk_int*BITVROW);
    wire [WIDTH-1:0] t1_dinA_0_wire = t1_dinA >> (NUMPRPT*t1_vbnk_int*WIDTH);

    assert_t1_1port_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA_wire && t1_writeA_wire));
    assert_t1_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire || t1_writeA_wire) |->
					       (t1_bankA_wire < NUMRBNK) && (t1_addrA_wire < NUMVROW));
    assert_t1_wr_same_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |->
					      (t1_writeA_0_wire && (t1_bankA_0_wire == t1_bankA_wire) && (t1_addrA_0_wire == t1_addrA_wire) &&
					       (t1_dinA_0_wire == t1_dinA_wire))); 
  end
end
endgenerate

genvar t2_prpt_int;
generate for (t2_prpt_int=0; t2_prpt_int<NUMPRPT; t2_prpt_int=t2_prpt_int+1) begin: t2_prpt_loop
  wire t2_readA_wire = t2_readA >> t2_prpt_int;
  wire t2_writeA_wire = t2_writeA >> t2_prpt_int;
  wire [BITRBNK-1:0] t2_bankA_wire = t2_bankA >> (t2_prpt_int*BITRBNK);
  wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> (t2_prpt_int*BITVROW);
  wire [WIDTH-1:0] t2_dinA_wire = t2_dinA >> (t2_prpt_int*WIDTH);

  wire t2_writeA_0_wire = t2_writeA;
  wire [BITRBNK-1:0] t2_bankA_0_wire = t2_bankA;
  wire [BITVROW-1:0] t2_addrA_0_wire = t2_addrA;
  wire [WIDTH-1:0] t2_dinA_0_wire = t2_dinA;

  assert_t2_1port_check: assert property (@(posedge clk) disable iff (rst) !(t2_readA_wire && t2_writeA_wire));
  assert_t2_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire || t2_writeA_wire) |->
					     (t2_bankA_wire < NUMRBNK) && (t2_addrA_wire < NUMVROW));
  assert_t2_wr_same_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |->
					    (t2_writeA_0_wire && (t2_bankA_0_wire == t2_bankA_wire) && (t2_addrA_0_wire == t2_addrA_wire) &&
					     (t2_dinA_0_wire == t2_dinA_wire))); 
end
endgenerate

endmodule


module ip_top_sva_nror1w_edram
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
     NUMRBNK = 4,
     BITRBNK = 2,
     SRAM_DELAY = 2,
     FLOPOUT = 0
   )
(
  input clk,
  input rst,
  input ready,
  input [NUMPRPT*NUMVBNK-1:0] t1_readA,
  input [NUMPRPT*NUMVBNK-1:0] t1_writeA,
  input [NUMPRPT*NUMVBNK*BITRBNK-1:0] t1_bankA,
  input [NUMPRPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMPRPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMPRPT*NUMVBNK*WIDTH-1:0] t1_doutA,
  input [NUMPRPT*NUMVBNK-1:0] t1_serrA,
  input [NUMPRPT*NUMVBNK-1:0] t1_derrA,
  input [NUMPRPT*NUMVBNK*(BITPADR-BITPBNK-1)-1:0] t1_padrA,
  input [NUMPRPT-1:0] t2_readA,
  input [NUMPRPT-1:0] t2_writeA,
  input [NUMPRPT*BITRBNK-1:0] t2_bankA,
  input [NUMPRPT*BITVROW-1:0] t2_addrA,
  input [NUMPRPT*WIDTH-1:0] t2_dinA,
  input [NUMPRPT*WIDTH-1:0] t2_doutA,
  input [NUMPRPT-1:0] t2_serrA,
  input [NUMPRPT-1:0] t2_derrA,
  input [NUMPRPT*(BITPADR-BITPBNK-1)-1:0] t2_padrA,
  input refr,
  input [BITRBNK-1:0] rf_bnk,
  input [BITADDR-1:0] rf_adr,
  input write,
  input [BITRBNK-1:0] wr_bnk,
  input [BITADDR-1:0]  wr_adr,
  input [WIDTH-1:0] din,
  input [NUMVRPT-1:0] read,
  input [NUMVRPT*BITRBNK-1:0] rd_bnk,
  input [NUMVRPT*BITADDR-1:0] rd_adr,
  input [NUMVRPT-1:0] rd_vld,
  input [NUMVRPT*WIDTH-1:0] rd_dout,
  input [NUMVRPT-1:0] rd_serr,
  input [NUMVRPT-1:0] rd_derr,
  input [NUMVRPT*BITPADR-1:0] rd_padr,
  input [BITRBNK-1:0] select_rbnk,
  input [BITADDR-1:0] select_addr,
  input [BITWDTH-1:0] select_bit
);

wire [BITVBNK-1:0] select_mbnk;
wire [BITVROW-1:0] select_radr;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  sel_np2 (.vbadr(select_mbnk), .vradr(select_radr), .vaddr(select_addr));

wire [BITPADR-BITPBNK-2:0] t1_padrA_sel = t1_padrA >> (NUMPRPT*select_mbnk*(BITPADR-BITPBNK-1));

reg t1_readA_wire [0:NUMPRPT-1][0:NUMVBNK-1];
reg t1_writeA_wire [0:NUMVBNK-1];
reg [BITRBNK-1:0] t1_bankA_wire [0:NUMPRPT-1][0:NUMVBNK-1];
reg [BITVROW-1:0] t1_addrA_wire [0:NUMPRPT-1][0:NUMVBNK-1];
reg [WIDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];
reg [WIDTH-1:0] t1_doutA_wire [0:NUMVBNK-1];
reg [BITPADR-BITPBNK-2:0] t1_padrA_wire [0:NUMVBNK-1];
integer t1_prpt_int, t1_vbnk_int;
always_comb
  for (t1_vbnk_int=0; t1_vbnk_int<NUMVBNK; t1_vbnk_int=t1_vbnk_int+1) begin
    for (t1_prpt_int=0; t1_prpt_int<NUMPRPT; t1_prpt_int=t1_prpt_int+1) begin
      t1_readA_wire[t1_prpt_int][t1_vbnk_int] = t1_readA >> (NUMPRPT*t1_vbnk_int+t1_prpt_int);
      t1_bankA_wire[t1_prpt_int][t1_vbnk_int] = t1_bankA >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*BITRBNK);
      t1_addrA_wire[t1_prpt_int][t1_vbnk_int] = t1_addrA >> ((NUMPRPT*t1_vbnk_int+t1_prpt_int)*BITVROW);
    end
    t1_writeA_wire[t1_vbnk_int] = t1_writeA >> (NUMPRPT*t1_vbnk_int);
    t1_dinA_wire[t1_vbnk_int] = t1_dinA >> (NUMPRPT*t1_vbnk_int*WIDTH);
    t1_doutA_wire[t1_vbnk_int] = t1_doutA >> (NUMPRPT*t1_vbnk_int*WIDTH);
    t1_padrA_wire[t1_vbnk_int] = t1_padrA >> (NUMPRPT*t1_vbnk_int*(BITPADR-BITPBNK-1));
  end

reg t2_readA_wire [0:NUMPRPT-1];
reg [BITRBNK-1:0] t2_bankA_wire [0:NUMPRPT-1];
reg [BITVROW-1:0] t2_addrA_wire [0:NUMPRPT-1];
integer t2_prpt_int;
always_comb
  for (t2_prpt_int=0; t2_prpt_int<NUMPRPT; t2_prpt_int=t2_prpt_int+1) begin
    t2_readA_wire[t2_prpt_int] = t2_readA >> t2_prpt_int;
    t2_bankA_wire[t2_prpt_int] = t2_bankA >> (t2_prpt_int*BITRBNK);
    t2_addrA_wire[t2_prpt_int] = t2_addrA >> (t2_prpt_int*BITVROW);
  end

wire [BITRBNK-1:0] wr_rbnk = wr_bnk;
wire [BITVBNK-1:0] wr_mbnk;
wire [BITVROW-1:0] wr_radr;
np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
           .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
           .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  wr_np2 (.vbadr(wr_mbnk), .vradr(wr_radr), .vaddr(wr_adr));

wire [BITRBNK-1:0] rf_rbnk = rf_bnk;
wire [BITVBNK-1:0] rf_mbnk;
wire [BITVROW-1:0] rf_radr;
np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
           .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
           .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  rf_np2 (.vbadr(rf_mbnk), .vradr(rf_radr), .vaddr(rf_adr));

wire read_wire [0:NUMVRPT-1];
wire [BITADDR-1:0] rd_adr_wire [0:NUMVRPT-1];
wire [BITRBNK-1:0] rd_rbnk_wire [0:NUMVRPT-1];
wire [BITVBNK-1:0] rd_mbnk_wire [0:NUMVRPT-1];
wire [BITVROW-1:0] rd_radr_wire [0:NUMVRPT-1];
wire rd_vld_wire [0:NUMVRPT-1];
wire [WIDTH-1:0] rd_dout_wire [0:NUMVRPT-1];
wire rd_dbit_wire [0:NUMVRPT-1];
wire rd_serr_wire [0:NUMVRPT-1];
wire rd_derr_wire [0:NUMVRPT-1];
wire [BITPADR-1:0] rd_padr_wire [0:NUMVRPT-1];
genvar rd_int;
generate for (rd_int=0; rd_int<NUMVRPT; rd_int=rd_int+1) begin: rd_loop
  assign read_wire[rd_int] = read >> rd_int;
  assign rd_rbnk_wire[rd_int] = rd_bnk >> (rd_int*BITRBNK);
  assign rd_adr_wire[rd_int] = rd_adr >> (rd_int*BITADDR);
  np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
             .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
             .NUMVROW (NUMVROW), .BITVROW (BITVROW))
      rd_np2 (.vbadr(rd_mbnk_wire[rd_int]), .vradr(rd_radr_wire[rd_int]), .vaddr(rd_adr_wire[rd_int]));

  assign rd_vld_wire[rd_int] = rd_vld >> rd_int;
  assign rd_dout_wire[rd_int] = rd_dout >> (rd_int*WIDTH);
  assign rd_dbit_wire[rd_int] = rd_dout_wire[rd_int][select_bit];
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
                                                                             (mem_serr[rerr_int][berr_int] && mem_derr[rerr_int][berr_int])));
    assume_mem_nerr_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire[rerr_int][berr_int] && mem_nerr[rerr_int][berr_int]) |-> ##SRAM_DELAY
                                            !t1_serrA[berr_int*NUMPRPT+rerr_int] && !t1_derrA[berr_int*NUMPRPT+rerr_int]);
    assume_mem_serr_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire[rerr_int][berr_int] && mem_serr[rerr_int][berr_int]) |-> ##SRAM_DELAY
                                            t1_serrA[berr_int*NUMPRPT+rerr_int] && !t1_derrA[berr_int*NUMPRPT+rerr_int]);
    assume_mem_derr_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire[rerr_int][berr_int] && mem_derr[rerr_int][berr_int]) |-> ##SRAM_DELAY
                                            t1_serrA[berr_int*NUMPRPT+rerr_int] && t1_derrA[berr_int*NUMPRPT+rerr_int]);
  end
  assign xmem_nerr[rerr_int] = !xmem_serr[rerr_int] && !xmem_derr[rerr_int];
  assign xmem_serr[rerr_int] = 1'b0;
  assign xmem_derr[rerr_int] = 1'b0;

  assume_xmem_err_check: assert property (@(posedge clk) disable iff (rst) (xmem_nerr[rerr_int] ||
                                                                            (xmem_serr[rerr_int] && !xmem_derr[rerr_int]) ||
                                                                            (xmem_serr[rerr_int] && xmem_derr[rerr_int])));
  assume_xmem_nerr_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[rerr_int] && xmem_nerr[rerr_int]) |-> ##SRAM_DELAY
                                           !t2_serrA[rerr_int] && !t2_derrA[rerr_int]);
  assume_xmem_serr_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[rerr_int] && xmem_serr[rerr_int]) |-> ##SRAM_DELAY
                                           t2_serrA[rerr_int] && !t2_derrA[rerr_int]);
  assume_xmem_derr_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[rerr_int] && xmem_derr[rerr_int]) |-> ##SRAM_DELAY
                                           t2_serrA[rerr_int] && t2_derrA[rerr_int]);
end
endgenerate

reg cflt [0:NUMVRPT-1];
reg cflt_serr [0:NUMVRPT-1];
reg cflt_derr [0:NUMVRPT-1];
reg [BITPBNK-1:0] cflt_pbnk [0:NUMVRPT-1];
integer vrdr_int, vrdb_int;
always_comb
  for (vrdr_int=1; vrdr_int<NUMVRPT; vrdr_int=vrdr_int+2) begin
    cflt[vrdr_int] = read_wire[vrdr_int] && ((read_wire[vrdr_int-1] && (rd_mbnk_wire[vrdr_int-1] == rd_mbnk_wire[vrdr_int])) ||
					     (refr && (rf_rbnk == rd_rbnk_wire[vrdr_int]) && (rf_mbnk == rd_mbnk_wire[vrdr_int])));
    cflt_serr[vrdr_int] = xmem_serr[vrdr_int>>1];
    cflt_derr[vrdr_int] = 1'b0;
    cflt_pbnk[vrdr_int] = xmem_serr[vrdr_int>>1] ? NUMVBNK : 0;
    for (vrdb_int=NUMVBNK-1; vrdb_int>=0; vrdb_int=vrdb_int-1)
      if (vrdb_int != rd_mbnk_wire[vrdr_int])
        if (mem_serr[vrdr_int>>1][vrdb_int]) begin
          if (cflt_serr[vrdr_int])
	    cflt_derr[vrdr_int] = 1'b1;
          cflt_serr[vrdr_int] = 1'b1;
	  cflt_pbnk[vrdr_int] = vrdb_int;
        end
  end

reg [NUMVBNK-1:0] mem;
integer mem_int;
always @(posedge clk)
  for (mem_int=0; mem_int<NUMVBNK; mem_int=mem_int+1)
    if (!ready)
      mem[mem_int] <= 0;
    else if (t1_writeA_wire[mem_int] && (t1_bankA_wire[0][mem_int] == select_rbnk) && (t1_addrA_wire[0][mem_int] == select_radr))
      mem[mem_int] <= t1_dinA_wire[mem_int][select_bit];
      
reg xmem;
always @(posedge clk)
  if (!ready)
    xmem <= 0;
  else if (t2_writeA && (t2_bankA_wire[0] == select_rbnk) && (t2_addrA_wire[0] == select_radr))
    xmem <= t2_dinA[select_bit];

wire xor_mem = ^mem;

genvar memr_int, memb_int;
generate for (memr_int=0; memr_int<NUMPRPT; memr_int=memr_int+1) begin: memr_loop
  for (memb_int=0; memb_int<NUMVBNK; memb_int=memb_int+1) begin: memb_loop
    assert_pdout_check: assert property (@(posedge clk) disable iff (rst)
					 (t1_readA_wire[memr_int][memb_int] &&
					  (t1_bankA_wire[memr_int][memb_int] == select_rbnk) &&  (t1_addrA_wire[memr_int][memb_int] == select_radr)) |-> ##SRAM_DELAY
//					 (t1_doutA[(memb_int*NUMPRPT+memr_int)*WIDTH+select_bit] == $past(mem[memb_int],SRAM_DELAY)));
                                         (t1_serrA[memb_int*NUMPRPT+memr_int] ||
					  (t1_doutA[(memb_int*NUMPRPT+memr_int)*WIDTH+select_bit] == $past(mem[memb_int],SRAM_DELAY))));
  end
  assert_xdout_check: assert property (@(posedge clk) disable iff (rst)
				       (t2_readA_wire[memr_int] && (t2_bankA_wire[memr_int] == select_rbnk) && (t2_addrA_wire[memr_int] == select_radr)) |-> ##SRAM_DELAY
//                                       (t2_doutA[memr_int*WIDTH+select_bit] == $past(xmem,SRAM_DELAY)));
                                       (t2_serrA[memr_int] ||
					(t2_doutA[memr_int*WIDTH+select_bit] == $past(xmem,SRAM_DELAY))));
end
endgenerate

assert_xwrite_req_check: assert property (@(posedge clk) disable iff (!ready) !write |-> ##SRAM_DELAY !core.xwrite_req);
reg xmem_req_inv;
reg xmem_req;
always @(posedge clk)
  if (!ready) begin
    xmem_req_inv <= 1'b0;
    xmem_req <= 0;
  end else if (core.xwrite_req && (core.xwrrbnk_req == select_rbnk) && (core.xwrradr_req == select_radr)) begin
    xmem_req_inv <= core.xserr_req;
    xmem_req <= core.xdin_req[select_bit];
  end

genvar xorr_int;
generate for (xorr_int=0; xorr_int<NUMPRPT; xorr_int=xorr_int+1) begin: xorr_loop
  assert_xmem_req_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[xorr_int] &&
									    (t2_bankA_wire[xorr_int] == select_rbnk) &&
									    (t2_addrA_wire[xorr_int] == select_radr)) |-> ##1
				          (xmem_req == (core.xrd_srch_flag[xorr_int] ? core.xrd_srch_dbit[xorr_int] : xmem)));

  assert_xor_int_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[xorr_int] &&
									   (t2_bankA_wire[xorr_int] == select_rbnk) &&
									   (t2_addrA_wire[xorr_int] == select_radr)) |-> ##SRAM_DELAY
				         (t2_serrA[xorr_int] || (core.xor_data[xorr_int][select_bit] == xmem_req)));

  assert_xor_more_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire[xorr_int] &&
									    (t2_bankA_wire[xorr_int] == select_rbnk) &&
									    (t2_addrA_wire[xorr_int] == select_radr)) |-> ##SRAM_DELAY
				          (xmem_req_inv || t2_serrA[xorr_int] || (core.xor_data[xorr_int][select_bit] == ($past(xor_mem,SRAM_DELAY)))));
end
endgenerate

  assert_xor_data_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##SRAM_DELAY
                                          (xmem_req_inv || (xmem_req == ($past(xor_mem,SRAM_DELAY)))));

reg fakexor_inv;
always @(posedge clk)
  if (!ready)
    fakexor_inv <= 1'b0;
  else if (write && (wr_rbnk == select_rbnk) && (wr_radr == select_radr)) 
    fakexor_inv <= |mem_serr[0];

reg fakemem;
always @(posedge clk)
  if (!ready) 
    fakemem <= 1'b0;
  else if (write && (wr_bnk == select_rbnk) && (wr_adr == select_addr))
    fakemem <= din[select_bit];

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) (fakemem == mem[select_mbnk]));

genvar doutr_int;
generate for (doutr_int=0; doutr_int<NUMVRPT; doutr_int=doutr_int+1) begin: doutr_loop

  assert_vld_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] &&
								       (rd_rbnk_wire[doutr_int] == select_rbnk) &&
								       (rd_adr_wire[doutr_int] == select_addr)) |-> ##(SRAM_DELAY+FLOPOUT) rd_vld_wire[doutr_int]);

  if (doutr_int[0] == 1'b0) begin: even_loop
    assert_dout_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && mem_nerr[doutr_int>>1][select_mbnk] &&
									       (rd_rbnk_wire[doutr_int] == select_rbnk) &&
									       (rd_adr_wire[doutr_int] == select_addr)) |-> ##(SRAM_DELAY+FLOPOUT)
                                             (rd_dbit_wire[doutr_int] == $past(fakemem,SRAM_DELAY+FLOPOUT)));
    assert_derr_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && mem_nerr[doutr_int>>1][select_mbnk] &&
									       (rd_rbnk_wire[doutr_int] == select_rbnk) &&
									       (rd_adr_wire[doutr_int] == select_addr)) |-> ##(SRAM_DELAY+FLOPOUT)
                                             (!rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_derr_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && mem_serr[doutr_int>>1][select_mbnk] &&
									       (rd_rbnk_wire[doutr_int] == select_rbnk) &&
									       (rd_adr_wire[doutr_int] == select_addr)) |-> ##(SRAM_DELAY+FLOPOUT)
					     (rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] &&
									  (rd_rbnk_wire[doutr_int] == select_rbnk) &&
									  (rd_adr_wire[doutr_int] == select_addr)) |-> ##(SRAM_DELAY+FLOPOUT)
                                        (rd_padr_wire[doutr_int] == {select_mbnk,(FLOPOUT ? $past(t1_padrA_sel) : t1_padrA_sel)}));

  end else begin: odd_loop

    assert_dout_ncfl_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && !cflt[doutr_int] && mem_nerr[doutr_int>>1][select_mbnk] &&
	 									    (rd_rbnk_wire[doutr_int] == select_rbnk) &&
										    (rd_adr_wire[doutr_int] == select_addr)) |-> ##(SRAM_DELAY+FLOPOUT)
						  (rd_dbit_wire[doutr_int] == $past(fakemem,SRAM_DELAY+FLOPOUT)));
    assert_dout_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && cflt[doutr_int] &&
										    &(mem_nerr[doutr_int>>1] | (1'b1 << select_mbnk)) && xmem_nerr[doutr_int>>1] &&
	 									    (rd_rbnk_wire[doutr_int] == select_rbnk) &&
										    (rd_adr_wire[doutr_int] == select_addr)) |-> ##(SRAM_DELAY+FLOPOUT)
                                                  ($past(fakexor_inv,SRAM_DELAY+FLOPOUT) || (rd_dbit_wire[doutr_int] == $past(fakemem,SRAM_DELAY+FLOPOUT))));
    assert_dout_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && cflt[doutr_int] &&
										    (mem_serr[doutr_int>>1] == (1'b1 << select_mbnk)) && xmem_nerr[doutr_int>>1] &&
	 									    (rd_rbnk_wire[doutr_int] == select_rbnk) &&
										    (rd_adr_wire[doutr_int] == select_addr)) |-> ##(SRAM_DELAY+FLOPOUT)
					          ($past(fakexor_inv,SRAM_DELAY+FLOPOUT) || (rd_dbit_wire[doutr_int] == $past(fakemem,SRAM_DELAY+FLOPOUT))));

    assert_derr_ncfl_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && !cflt[doutr_int] && mem_nerr[doutr_int>>1][select_mbnk] &&
	 									    (rd_rbnk_wire[doutr_int] == select_rbnk) &&
										    (rd_adr_wire[doutr_int] == select_addr)) |-> ##(SRAM_DELAY+FLOPOUT)
						  (!rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_derr_ncfl_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && !cflt[doutr_int] && mem_serr[doutr_int>>1][select_mbnk] &&
	 									    (rd_rbnk_wire[doutr_int] == select_rbnk) &&
										    (rd_adr_wire[doutr_int] == select_addr)) |-> ##(SRAM_DELAY+FLOPOUT)
					          (rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_derr_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && cflt[doutr_int] &&
									            &mem_nerr[doutr_int>>1] && xmem_nerr[doutr_int>>1] &&
	 									    (rd_rbnk_wire[doutr_int] == select_rbnk) &&
										    (rd_adr_wire[doutr_int] == select_addr)) |-> ##(SRAM_DELAY+FLOPOUT)
					           (!rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]));
    assert_derr_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && cflt[doutr_int] &&
					                                            (|mem_serr[doutr_int>>1] || xmem_serr[doutr_int>>1]) &&
	 									    (rd_rbnk_wire[doutr_int] == select_rbnk) &&
										    (rd_adr_wire[doutr_int] == select_addr)) |-> ##(SRAM_DELAY+FLOPOUT)
					          ((rd_serr_wire[doutr_int] == ($past(cflt_serr[doutr_int],SRAM_DELAY+FLOPOUT))) &&
					           (rd_derr_wire[doutr_int] == ($past(cflt_derr[doutr_int],SRAM_DELAY+FLOPOUT)))));

    assert_padr_ncfl_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && !cflt[doutr_int] &&
	 								       (rd_rbnk_wire[doutr_int] == select_rbnk) &&
									       (rd_adr_wire[doutr_int] == select_addr)) |-> ##(SRAM_DELAY+FLOPOUT)
                                             (rd_padr_wire[doutr_int] == {select_mbnk,(FLOPOUT ? $past(t1_padrA_sel) : t1_padrA_sel)}));
    assert_padr_cflt_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && cflt[doutr_int] &&
									            &mem_nerr[doutr_int>>1] && xmem_nerr[doutr_int>>1] &&
	 								            (rd_rbnk_wire[doutr_int] == select_rbnk) &&
									            (rd_adr_wire[doutr_int] == select_addr)) |-> ##(SRAM_DELAY+FLOPOUT)
                                                  (&rd_padr_wire[doutr_int] || (rd_padr_wire[doutr_int] == {NUMVBNK,(FLOPOUT ? $past(t2_padrA) : t2_padrA)})));
    assert_padr_cflt_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[doutr_int] && cflt[doutr_int] &&
					                                            (|mem_serr[doutr_int>>1] || xmem_serr[doutr_int>>1]) &&
	 								            (rd_rbnk_wire[doutr_int] == select_rbnk) &&
									            (rd_adr_wire[doutr_int] == select_addr)) |-> ##SRAM_DELAY
						  ((!rd_serr_wire[doutr_int] && !rd_derr_wire[doutr_int]) ?
                                                   (&rd_padr_wire[doutr_int] || (rd_padr_wire[doutr_int] == {NUMVBNK,(FLOPOUT ? $past(t2_padrA) : t2_padrA)})) :
                                                   (&rd_padr_wire[doutr_int] || (rd_padr_wire[doutr_int] == {$past(cflt_pbnk[doutr_int],SRAM_DELAY+FLOPOUT),(FLOPOUT ? $past(t2_padrA) : t2_padrA)}))));
  end
end
endgenerate

endmodule


