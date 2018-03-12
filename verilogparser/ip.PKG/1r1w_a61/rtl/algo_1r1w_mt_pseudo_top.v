
module algo_1r1w_mt_pseudo_top (clk, rst, ready, refr,
                                write, wr_adr, din,
                                read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                        t1_writeA, t1_bankA, t1_addrA, t1_dwsnA, t1_bwA, t1_dinA,
		                t1_readB, t1_bankB, t1_addrB, t1_dwsnB, t1_doutB,
			        t1_refrC, t1_bankC,
	                        t2_writeA, t2_addrA, t2_readB, t2_addrB, t2_dinA, t2_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAEXT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter MEMWDTH = ENAEXT ? WIDTH : ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;  // ALGO1 Parameters
  parameter BITVROW = 10;
  parameter BITPROW = BITVROW;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMPBNK = 9;
  parameter BITPBNK = 4;
  parameter NUMWRDS = 4;     // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 64; 
  parameter BITSROW = 6;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter NUMWBNK = 1;
  parameter BITWBNK = 0;
  parameter NUMWROW = NUMVROW;
  parameter BITWROW = BITVROW;
  parameter REFRESH = 1;      // REFRESH Parameters 
  parameter NUMRBNK = 8;
  parameter BITRBNK = 3;
  parameter BITWSPF = 0;
  parameter NUMRROW = 16;
  parameter BITRROW = 4;
  parameter REFFREQ = 16;
  parameter REFFRHF = 0;
  parameter REFLOPW = 0;
  parameter NUMDWS0 = 72;     // DWSN Parameters
  parameter NUMDWS1 = 72;
  parameter NUMDWS2 = 72;
  parameter NUMDWS3 = 72;
  parameter NUMDWS4 = 72;
  parameter NUMDWS5 = 72;
  parameter NUMDWS6 = 72;
  parameter NUMDWS7 = 72;
  parameter NUMDWS8 = 72;
  parameter NUMDWS9 = 72;
  parameter NUMDWS10 = 72;
  parameter NUMDWS11 = 72;
  parameter NUMDWS12 = 72;
  parameter NUMDWS13 = 72;
  parameter NUMDWS14 = 72;
  parameter NUMDWS15 = 72;
  parameter BITDWSN = 8;
  parameter DISCORR = 0;
  parameter ISDCR   = (NUMVBNK != NUMRBNK);
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;
  parameter ECCBITS = 7;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITMAPT = BITPBNK*NUMPBNK;
  parameter SDOUT_WIDTH = 2*BITMAPT+ECCBITS;

  input                                refr;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input                                read;
  input [BITADDR-1:0]                  rd_adr;
  output                               rd_vld;
  output                               rd_serr;
  output                               rd_derr;
  output [WIDTH-1:0]                   rd_dout;
  output [BITPADR-1:0]                 rd_padr;

  output                               ready;
  input                                clk, rst;

  output t1_writeA;
  output [BITPBNK-1:0] t1_bankA;
  output [BITSROW-1:0] t1_addrA;
  output [BITDWSN-1:0] t1_dwsnA;
  output [PHYWDTH-1:0] t1_bwA;
  output [PHYWDTH-1:0] t1_dinA;

  output t1_readB;
  output [BITPBNK-1:0] t1_bankB;
  output [BITSROW-1:0] t1_addrB;
  output [BITDWSN-1:0] t1_dwsnB;
  input [PHYWDTH-1:0] t1_doutB;

  output t1_refrC;
  output [BITRBNK-1:0] t1_bankC;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*SDOUT_WIDTH-1:0] t2_dinA;

  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*SDOUT_WIDTH-1:0] t2_doutB;

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
wire [BITRBNK-1:0] select_rbnk;
wire [BITRROW-1:0] select_rrow;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));
assume_select_rbnk_range: assume property (@(posedge clk) disable iff (rst) (select_rbnk < NUMRBNK));
assume_select_rbnk_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rbnk));
assume_select_rrow_range: assume property (@(posedge clk) disable iff (rst) (select_rrow < NUMRROW));
assume_select_rrow_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rrow));

wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  row_adr (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));

`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW-1:0] select_vrow = 0;
wire [BITRBNK-1:0] select_rbnk = 0;
wire [BITRROW-1:0] select_rrow = 0;
`endif

wire t1_writeA_a1;
wire [BITPBNK-1:0] t1_bankA_a1;
wire [BITVROW-1:0] t1_addrA_a1;
wire [WIDTH-1:0] t1_dinA_a1;
wire t1_readB_a1;
wire [BITPBNK-1:0] t1_bankB_a1;
wire [BITVROW-1:0] t1_addrB_a1;
reg [WIDTH-1:0] t1_doutB_a1;
reg t1_fwrdB_a1;
reg t1_serrB_a1;
reg t1_derrB_a1;
reg [(BITSROW+BITWRDS)-1:0] t1_padrB_a1;
wire t1_refrC_a1;

wire [2-1:0] t2_writeA_a1;
wire [2*BITVROW-1:0] t2_addrA_a1;
wire [2*SDOUT_WIDTH-1:0] t2_dinA_a1;
wire [2-1:0] t2_readB_a1;
wire [2*BITVROW-1:0] t2_addrB_a1;
reg [2*SDOUT_WIDTH-1:0] t2_doutB_a1;
reg [2-1:0] t2_fwrdB_a1;
reg [2-1:0] t2_serrB_a1;
reg [2-1:0] t2_derrB_a1;
reg [2*(BITSROW+BITWRDS)-1:0] t2_padrB_a1;

generate if (1) begin: a1_loop
  
algo_1r1w_mt_pseudo #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                      .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .NUMPBNK (NUMPBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR-1),
                      .REFRESH (REFRESH),
                      .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .DRAM_DELAY (DRAM_DELAY+FLOPMEM), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .ECCBITS (ECCBITS))
  algo (.clk(clk), .rst(rst), .ready(ready), .refr (refr),
        .write(write), .wr_adr(wr_adr), .din(din),
        .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout),
        .rd_fwrd(rd_padr[BITPADR-1]), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr[BITPADR-2:0]),
        .t1_writeA(t1_writeA_a1), .t1_bankA(t1_bankA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
	.t1_readB(t1_readB_a1), .t1_bankB(t1_bankB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
        .t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1),
        .t1_refrC(t1_refrC_a1),
        .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1), .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1), .t2_doutB(t2_doutB_a1),
        .t2_fwrdB(t2_fwrdB_a1), .t2_serrB(t2_serrB_a1), .t2_derrB(t2_derrB_a1), .t2_padrB(t2_padrB_a1),
        .select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

wire t1_writeA_wire;
wire [BITPBNK-1:0] t1_bankA_wire;
wire [BITSROW-1:0] t1_addrA_wire;
wire [BITDWSN-1:0] t1_dwsnA_wire;
wire [NUMWRDS*WIDTH-1:0] t1_bwA_wire;
wire [NUMWRDS*WIDTH-1:0] t1_dinA_wire;
wire t1_readB_wire;
wire [BITPBNK-1:0] t1_bankB_wire;
wire [BITSROW-1:0] t1_addrB_wire;
wire [BITDWSN-1:0] t1_dwsnB_wire;
wire t1_refrC_wire;
wire [BITRBNK-1:0] t1_bankC_wire;

generate if (1) begin: t1_loop
  if (1) begin: align_loop
    wire [NUMWRDS*WIDTH-1:0] t1_doutB_wire = t1_doutB;

    infra_align_ecc_pseudo #(.WIDTH (WIDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                             .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMPBNK), .BITVBNK (BITPBNK),
                             .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITSROW),
                             .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                             .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                             .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                             .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                             .SRAM_DELAY (DRAM_DELAY), .FLOPGEN (0), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC))
        infra (.write(t1_writeA_a1), .wr_bnk(t1_bankA_a1), .wr_adr(t1_addrA_a1), .din(t1_dinA_a1),
               .read(t1_readB_a1), .rd_bnk(t1_bankB_a1), .rd_adr(t1_addrB_a1), .rd_dout(t1_doutB_a1),
               .rd_fwrd(t1_fwrdB_a1), .rd_serr(t1_serrB_a1), .rd_derr(t1_derrB_a1), .rd_padr (t1_padrB_a1),
               .mem_write(t1_writeA_wire), .mem_wr_bnk(t1_bankA_wire), .mem_wr_adr(t1_addrA_wire),
               .mem_wr_dwsn(t1_dwsnA_wire), .mem_bw(t1_bwA_wire), .mem_din(t1_dinA_wire),
               .mem_read (t1_readB_wire), .mem_rd_bnk(t1_bankB_wire), .mem_rd_adr(t1_addrB_wire), .mem_rd_dwsn(t1_dwsnB_wire),
               .mem_rd_dout(t1_doutB_wire), .mem_rd_fwrd(1'b0), .mem_rd_padr(),
               .clk (clk), .rst (rst),
	       .select_vrow (select_vrow));
  end

  wire [BITRBNK-1:0] t1_bankA_wire_align =  t1_bankA_wire >> ISDCR;
  wire [BITRBNK-1:0] t1_bankB_wire_align =  t1_bankB_wire >> ISDCR;

  if (REFRESH==1) begin: refr_loop
    infra_refr_2stage #(.NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .REFLOPW (REFLOPW),
                        .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
        infra (.clk (clk), .rst (rst),
               .pref (t1_refrC_a1), .pacc1 (t1_writeA), .pacbadr1 (t1_bankA_wire_align), .pacc2 (t1_readB), .pacbadr2 (t1_bankB_wire_align),
               .prefr (t1_refrC_wire), .prfbadr (t1_bankC_wire),
               .select_rbnk (select_rbnk), .select_rrow (select_rrow));
  end else begin: no_refr_loop
    assign t1_refrC_wire = 1'b0;
    assign t1_bankC_wire = 0;
  end

end
endgenerate

assign t1_writeA = t1_writeA_wire;
assign t1_bankA = t1_bankA_wire;
assign t1_addrA = t1_addrA_wire;
assign t1_dwsnA = t1_dwsnA_wire;
assign t1_bwA = t1_bwA_wire;
assign t1_dinA = t1_dinA_wire;
assign t1_readB = t1_readB_wire;
assign t1_bankB = t1_bankB_wire;
assign t1_addrB = t1_addrB_wire;
assign t1_dwsnB = t1_dwsnB_wire;
assign t1_refrC = t1_refrC_wire;
assign t1_bankC = t1_bankC_wire;

wire [SDOUT_WIDTH-1:0] t2_doutB_a1_wire [0:2-1];
wire t2_fwrdB_a1_wire [0:2-1];
wire t2_serrB_a1_wire [0:2-1];
wire t2_derrB_a1_wire [0:2-1];
wire [BITWROW+BITWBNK-1:0] t2_padrB_a1_wire [0:2-1];
wire [NUMWBNK-1:0] t2_writeA_wire [0:2-1];
wire [NUMWBNK*BITWROW-1:0] t2_addrA_wire [0:2-1];
wire [NUMWBNK*SDOUT_WIDTH-1:0] t2_dinA_wire [0:2-1];
wire [NUMWBNK-1:0] t2_readB_wire [0:2-1];
wire [NUMWBNK*BITWROW-1:0] t2_addrB_wire [0:2-1];

genvar t2;
generate for (t2=0; t2<2; t2=t2+1) begin: t2_loop
  wire t2_writeA_a1_wire = t2_writeA_a1 >> t2;
  wire [BITVROW-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> (t2*BITVROW);
  wire [SDOUT_WIDTH-1:0] t2_dinA_a1_wire = t2_dinA_a1 >> (t2*SDOUT_WIDTH);

  wire t2_readB_a1_wire = t2_readB_a1 >> t2;
  wire [BITVROW-1:0] t2_addrB_a1_wire = t2_addrB_a1 >> (t2*BITVROW);

  wire [NUMWBNK*SDOUT_WIDTH-1:0] t2_doutB_wire = t2_doutB >> (t2*NUMWBNK*SDOUT_WIDTH);

  wire mem_write_wire;
  wire [BITVROW-1:0] mem_wr_adr_wire;
  wire [SDOUT_WIDTH-1:0] mem_bw_wire;
  wire [SDOUT_WIDTH-1:0] mem_din_wire;
  wire mem_read_wire;
  wire [BITVROW-1:0] mem_rd_adr_wire;
  wire [SDOUT_WIDTH-1:0] mem_rd_dout_wire;
  wire mem_rd_fwrd_wire;
  wire mem_rd_serr_wire;
  wire mem_rd_derr_wire;
  wire [(BITWBNK+BITWROW)-1:0] mem_rd_padr_wire;

  if (1) begin: align_loop
    infra_align_ecc_1r1w #(.WIDTH (SDOUT_WIDTH), .ENAPSDO (1), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITWBNK+BITWROW),
                           .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .ENAPADR (1), .RSTZERO (1))
      infra (.write (t2_writeA_a1_wire), .wr_adr (t2_addrA_a1_wire), .din (t2_dinA_a1_wire),
             .read (t2_readB_a1_wire), .rd_adr (t2_addrB_a1_wire), .rd_dout (t2_doutB_a1_wire[t2]),
             .rd_fwrd (t2_fwrdB_a1_wire[t2]), .rd_serr(t2_serrB_a1_wire[t2]), .rd_derr(t2_derrB_a1_wire[t2]), .rd_padr(t2_padrB_a1_wire[t2]),
             .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
             .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
             .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
             .clk (clk), .rst (rst),
             .select_addr (select_vrow));
  end

  if (1) begin: stack_loop
    infra_stack_1r1w #(.WIDTH (SDOUT_WIDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                       .NUMWROW (NUMWROW), .BITWROW (BITWROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                       .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
      infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
             .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
             .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
             .mem_write (t2_writeA_wire[t2]), .mem_wr_adr (t2_addrA_wire[t2]), .mem_bw(), .mem_din (t2_dinA_wire[t2]),
             .mem_read (t2_readB_wire[t2]), .mem_rd_adr (t2_addrB_wire[t2]), .mem_rd_dout (t2_doutB_wire),
             .clk (clk), .rst(rst),
             .select_addr (select_vrow));
  end
end
endgenerate

reg [2*NUMWBNK-1:0] t2_writeA;
reg [2*NUMWBNK*BITWROW-1:0] t2_addrA;
reg [2*NUMWBNK*SDOUT_WIDTH-1:0] t2_dinA;
reg [2*NUMWBNK-1:0] t2_readB;
reg [2*NUMWBNK*BITWROW-1:0] t2_addrB;

integer t2_out_int;
always_comb begin
  t2_writeA = 0;
  t2_addrA = 0;
  t2_dinA = 0;
  t2_readB = 0;
  t2_addrB = 0;
  t2_doutB_a1 = 0;
  t2_fwrdB_a1 = 0;
  t2_serrB_a1 = 0;
  t2_derrB_a1 = 0;
  t2_padrB_a1 = 0;
  for (t2_out_int=0; t2_out_int<2; t2_out_int=t2_out_int+1) begin
    t2_writeA = t2_writeA | (t2_writeA_wire[t2_out_int] << t2_out_int*NUMWBNK);
    t2_addrA = t2_addrA | (t2_addrA_wire[t2_out_int] << (t2_out_int*NUMWBNK*BITWROW));
    t2_dinA = t2_dinA | (t2_dinA_wire[t2_out_int] << (t2_out_int*NUMWBNK*SDOUT_WIDTH));
    t2_readB = t2_readB | (t2_readB_wire[t2_out_int] << t2_out_int*NUMWBNK);
    t2_addrB = t2_addrB | (t2_addrB_wire[t2_out_int] << (t2_out_int*NUMWBNK*BITWROW));
    t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2_out_int] << (t2_out_int*SDOUT_WIDTH));
    t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_wire[t2_out_int] << t2_out_int);
    t2_serrB_a1 = t2_serrB_a1 | (t2_serrB_a1_wire[t2_out_int] << t2_out_int);
    t2_derrB_a1 = t2_derrB_a1 | (t2_derrB_a1_wire[t2_out_int] << t2_out_int);
    t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_wire[t2_out_int] << (t2_out_int*(BITSROW+BITWRDS)));
  end
end

`ifdef FORMAL

generate if (REFRESH) begin: refr_loop
  assert_refr_check: assert property (@(posedge clk) disable iff (!ready) !refr |-> ##[1:REFFREQ-1] refr);
  assert_refr_half_check: assert property (@(posedge clk) disable iff (!ready) refr ##(REFFREQ+REFFRHF) refr |-> ##REFFREQ (!REFFRHF || refr));
  assert_refr_noacc_check: assume property (@(posedge clk) disable iff (!ready) !(refr && (write || |read)));
end
endgenerate

`endif

endmodule
