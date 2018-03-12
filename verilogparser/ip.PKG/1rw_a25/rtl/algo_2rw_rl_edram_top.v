
module algo_2rw_rl_edram_top (refr, read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                      ready, clk, rst, 
	                      t1_readA, t1_writeA, t1_bankA, t1_addrA, t1_bwA, t1_dinA, t1_doutA, t1_refrB, t1_bankB,
	                      t2_readA, t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_doutA,
	                      t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
	                      t4_writeA, t4_addrA, t4_dinA, t4_readB, t4_addrB, t4_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;

  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;

  parameter NUMMBNK = 4;
  parameter BITMBNK = 2;
  parameter BITPBNK = 3;
  parameter NUMMROW = 256;
  parameter BITMROW = 8;

  parameter NUMWRDS = 4; 
  parameter BITWRDS = 2;
  parameter NUMSROW = 64;
  parameter BITSROW = 6;

  parameter REFRESH = 1;
  parameter NUMRROW = 4;
  parameter BITRROW = 4;
  parameter REFFREQ = 8;
 
  parameter ECCBITS = 4;
  parameter PARITY = 0;
  parameter PHYWDTH = 32;

  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPOUT = 0;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  parameter MEMWDTH = WIDTH+PARITY;
  parameter BITPADR = BITPBNK+BITVBNK+BITWRDS+BITSROW+2;

  input                        refr;

  input                        read;
  input                        write;
  input [BITADDR-1:0]          addr;
  input [WIDTH-1:0]            din;
  output                       rd_vld;
  output [WIDTH-1:0]           rd_dout;
  output                       rd_serr;
  output                       rd_derr;
  output [BITPADR-1:0]         rd_padr;

  output                       ready;
  input                        clk;
  input                        rst;

  output [NUMMBNK-1:0] t1_readA;
  output [NUMMBNK-1:0] t1_writeA;
  output [NUMMBNK*BITVBNK-1:0] t1_bankA;
  output [NUMMBNK*BITSROW-1:0] t1_addrA;
  output [NUMMBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMMBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMMBNK*PHYWDTH-1:0] t1_doutA;

  output [NUMMBNK-1:0] t1_refrB;
  output [NUMMBNK*BITVBNK-1:0] t1_bankB;

  output [1-1:0] t2_readA;
  output [1-1:0] t2_writeA;
  output [1*(BITVBNK+BITSROW)-1:0] t2_addrA;
  output [1*PHYWDTH-1:0] t2_bwA;
  output [1*PHYWDTH-1:0] t2_dinA;
  input [1*PHYWDTH-1:0] t2_doutA;

  output [1-1:0] t3_writeA;
  output [1*BITVROW-1:0] t3_addrA;
  output [1*SDOUT_WIDTH-1:0] t3_dinA;

  output [1-1:0] t3_readB;
  output [1*BITVROW-1:0] t3_addrB;
  input [1*SDOUT_WIDTH-1:0] t3_doutB;

  output [1-1:0] t4_writeA;
  output [1*BITVROW-1:0] t4_addrA;
  output [1*WIDTH-1:0] t4_dinA;

  output [1-1:0] t4_readB;
  output [1*BITVROW-1:0] t4_addrB;
  input [1*WIDTH-1:0] t4_doutB;

wire                               pwrite;
wire [BITVBNK-1:0]                 pwrbadr;
wire [BITVROW-1:0]                 pwrradr;
wire [WIDTH-1:0]                   pdin;
wire                               pread1;
wire [BITVBNK-1:0]                 prdbadr1;
wire [BITVROW-1:0]                 prdradr1;
wire [WIDTH-1:0]                   pdout1;
wire                               pdout1_serr;
wire                               pdout1_derr;
wire [BITSROW+BITWRDS+BITVBNK+BITPBNK+1-1:0] pdout1_padr;
wire                               pread2;
wire [BITVBNK-1:0]                 prdbadr2;
wire [BITVROW-1:0]                 prdradr2;
wire [WIDTH-1:0]                   pdout2;
wire                               pdout2_serr;
wire                               pdout2_derr;
wire [BITSROW+BITWRDS+BITVBNK+BITPBNK+1-1:0] pdout2_padr;
wire                               prefr;
wire [BITVBNK-1:0]                 prfbadr;
wire [BITVROW-1:0]                 prfradr;
wire                               swrite;
wire [BITVROW-1:0]                 swrradr;
wire [SDOUT_WIDTH-1:0]             sdin;
wire                               sread;
wire [BITVROW-1:0]                 srdradr;
wire [SDOUT_WIDTH-1:0]             sdout;
wire                               cwrite;
wire [BITVROW-1:0]                 cwrradr;
wire [WIDTH-1:0]                   cdin;
wire                               cread;
wire [BITVROW-1:0]                 crdradr;
wire [WIDTH-1:0]                   cdout;
wire                               a2_ready;

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
wire [BITRROW-1:0] select_rrow;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));
assume_select_rrow_range: assume property (@(posedge clk) disable iff (rst) (select_rrow < NUMRROW));
assume_select_rrow_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rrow));

wire [BITVBNK-1:0] select_rbnk;
wire [BITVROW-1:0] select_vrow;
np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .NUMVROW (NUMVROW), .BITVROW (BITVROW))
    sel_a1_adr (.vbadr(select_rbnk), .vradr(select_vrow), .vaddr(select_addr));

wire [BITMBNK-1:0] select_mbnk;
wire [BITMROW-1:0] select_mrow;
np2_addr #(.NUMADDR (NUMVROW), .BITADDR (BITVROW), .NUMVBNK (NUMMBNK), .BITVBNK (BITMBNK), .NUMVROW (NUMMROW), .BITVROW (BITMROW))
    sel_a2_adr (.vbadr(select_mbnk), .vradr(select_mrow), .vaddr(select_vrow));
`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVBNK-1:0] select_rbnk = 0;
wire [BITVROW-1:0] select_vrow = 0;
wire [BITMBNK-1:0] select_mbnk = 0;
wire [BITMROW-1:0] select_mrow = 0;
wire [BITRROW-1:0] select_rrow = 0;
`endif

generate
  begin: a1_loop

    algo_2rw_rl_edram #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                        .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
			.REFRESH (REFRESH), .BITPADR (BITPADR),
                        .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .ECCBITS (ECCBITS), .FLOPOUT (FLOPOUT))
        algo (.vrefr (refr), .vread (read), .vwrite (write), .vaddr (addr), .vdin (din), .vread_vld (rd_vld), .vdout (rd_dout),
   	      .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
              .pwrite (pwrite), .pwrbadr (pwrbadr), .pwrradr (pwrradr), .pdin (pdin),
              .pread1 (pread1), .prdbadr1 (prdbadr1), .prdradr1 (prdradr1), .pdout1 (pdout1),
	      .pdout1_serr (pdout1_serr), .pdout1_derr (pdout1_derr), .pdout1_padr (pdout1_padr),
              .pread2 (pread2), .prdbadr2 (prdbadr2), .prdradr2 (prdradr2), .pdout2 (pdout2),
	      .pdout2_serr (pdout2_serr), .pdout2_derr (pdout2_derr), .pdout2_padr (pdout2_padr),
	      .prefr (prefr), .prfbadr (prfbadr), .prfradr (prfradr),
              .swrite (t3_writeA), .swrradr (t3_addrA), .sdin (t3_dinA),
              .sread (t3_readB), .srdradr (t3_addrB), .sdout (t3_doutB),
              .cwrite (t4_writeA), .cwrradr (t4_addrA), .cdin (t4_dinA),
              .cread (t4_readB), .crdradr (t4_addrB), .cdout (t4_doutB),
              .ready (ready), .clk (clk), .rst (rst || !a2_ready),
	      .select_addr (select_addr), .select_bit (select_bit));

  end
endgenerate

wire [NUMMBNK-1:0] t1_readA_a2;
wire [NUMMBNK-1:0] t1_writeA_a2;
wire [NUMMBNK*BITVBNK-1:0] t1_bankA_a2;
wire [NUMMBNK*BITMROW-1:0] t1_addrA_a2;
wire [NUMMBNK*WIDTH-1:0] t1_dinA_a2;
wire [NUMMBNK-1:0] t1_refrB_a2;
wire [NUMMBNK*BITVBNK-1:0] t1_bankB_a2;
reg [NUMMBNK*WIDTH-1:0] t1_doutA_a2;
reg [NUMMBNK-1:0] t1_serrA_a2;
reg [NUMMBNK-1:0] t1_derrA_a2;
reg [NUMMBNK*(BITSROW+BITWRDS+BITVBNK)-1:0] t1_padrA_a2;

wire t2_readA_a2;
wire t2_writeA_a2;
wire [BITVBNK-1:0] t2_bankA_a2;
wire [BITMROW-1:0] t2_addrA_a2;
wire [WIDTH-1:0] t2_dinA_a2;
reg [WIDTH-1:0] t2_doutA_a2;
reg t2_serrA_a2;
reg t2_derrA_a2;
reg [(BITSROW+BITWRDS+BITVBNK)-1:0] t2_padrA_a2;

generate
  begin: a2_loop

    algo_nror1w_edram #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .NUMADDR(NUMVROW), .BITADDR(BITVROW), .NUMVRPT(2), .NUMPRPT(1),
	                .NUMVROW(NUMMROW), .BITVROW(BITMROW), .NUMVBNK(NUMMBNK), .BITVBNK(BITMBNK),
	                .BITPBNK(BITPBNK), .BITPADR(BITPBNK+BITVBNK+BITWRDS+BITSROW+1), .NUMRBNK(NUMVBNK), .BITRBNK(BITVBNK),
                        .REFRESH(0), .SRAM_DELAY(DRAM_DELAY))
        algo (.clk (clk), .rst (rst), .ready (a2_ready),
              .refr (prefr), .rf_bnk (prfbadr), .rf_adr (prfradr),
              .write (pwrite), .wr_bnk (pwrbadr), .wr_adr (pwrradr), .din (pdin),
              .read ({pread2,pread1}), .rd_bnk ({prdbadr2,prdbadr1}), .rd_adr ({prdradr2,prdradr1}),
	      .rd_vld (), .rd_dout ({pdout2,pdout1}), .rd_serr ({pdout2_serr,pdout1_serr}), .rd_derr ({pdout2_derr,pdout1_derr}), .rd_padr ({pdout2_padr,pdout1_padr}),
              .t1_readA (t1_readA_a2), .t1_writeA (t1_writeA_a2), .t1_bankA (t1_bankA_a2), .t1_addrA (t1_addrA_a2), .t1_dinA (t1_dinA_a2),
	      .t1_doutA (t1_doutA_a2), .t1_serrA (t1_serrA_a2), .t1_derrA (t1_derrA_a2), .t1_padrA (t1_padrA_a2),
	      .t1_refrB (t1_refrB_a2), .t1_bankB (t1_bankB_a2),
              .t2_readA (t2_readA_a2), .t2_writeA (t2_writeA_a2), .t2_bankA (t2_bankA_a2), .t2_addrA (t2_addrA_a2), .t2_dinA (t2_dinA_a2),
	      .t2_doutA (t2_doutA_a2), .t2_serrA (t2_serrA_a2), .t2_derrA (t2_derrA_a2), .t2_padrA (t2_padrA_a2),
              .t2_refrB (), .t2_bankB (),
	      .select_rbnk (select_rbnk), .select_addr (select_vrow), .select_bit (select_bit));

  end
endgenerate

wire [WIDTH-1:0] t1_doutA_a2_wire [0:NUMMBNK-1];
wire t1_serrA_a2_wire [0:NUMMBNK-1];
wire t1_derrA_a2_wire [0:NUMMBNK-1];
wire [(BITSROW+BITWRDS+BITVBNK)-1:0] t1_padrA_a2_wire [0:NUMMBNK-1];
wire t1_readA_wire [0:NUMMBNK-1];
wire t1_writeA_wire [0:NUMMBNK-1];
wire [BITVBNK-1:0] t1_bankA_wire [0:NUMMBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMMBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMMBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMMBNK-1];
wire t1_refrB_wire [0:NUMMBNK-1];
wire [BITVBNK-1:0] t1_bankB_wire [0:NUMMBNK-1];

genvar t1;
generate for (t1=0; t1<NUMMBNK; t1=t1+1) begin: t1_loop
  wire t1_readA_a2_wire = t1_readA_a2 >> t1;
  wire t1_writeA_a2_wire = t1_writeA_a2 >> t1;
  wire [BITVBNK-1:0] t1_bankA_a2_wire = t1_bankA_a2 >> (t1*BITVBNK);
  wire [BITMROW-1:0] t1_addrA_a2_wire = t1_addrA_a2 >> (t1*BITMROW);
  wire [WIDTH-1:0] t1_dinA_a2_wire = t1_dinA_a2 >> (t1*WIDTH);
  wire t1_refrB_a2_wire = t1_refrB_a2 >> t1;
  wire [BITVBNK-1:0] t1_bankB_a2_wire = t1_bankB_a2 >> (t1*BITVBNK);

  wire [NUMWRDS*MEMWDTH-1:0] t1_doutA_wire = t1_doutA >> (t1*PHYWDTH);

  begin: align_loop
    infra_align_edram #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMMROW), .BITADDR (BITMROW), .NUMRBNK (NUMVBNK), .BITRBNK (BITVBNK),
                        .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS+BITVBNK),
                        .SRAM_DELAY (DRAM_DELAY))
        infra (.read (t1_readA_a2_wire), .write (t1_writeA_a2_wire), .badr (t1_bankA_a2_wire), .addr (t1_addrA_a2_wire),
               .din (t1_dinA_a2_wire), .dout (t1_doutA_a2_wire[t1]), .serr (t1_serrA_a2_wire[t1]), .padr (t1_padrA_a2_wire[t1]),
               .mem_read (t1_readA_wire[t1]), .mem_write (t1_writeA_wire[t1]), .mem_badr (t1_bankA_wire[t1]), .mem_addr (t1_addrA_wire[t1]),
               .mem_bw (t1_bwA_wire[t1]), .mem_din (t1_dinA_wire[t1]), .mem_dout (t1_doutA_wire),
               .clk (clk), .rst (rst),
               .select_rbnk (select_rbnk), .select_addr (select_mrow));
    assign t1_derrA_a2_wire[t1] = 1'b0;
    assign t1_refrB_wire[t1] = t1_refrB_a2_wire;
    assign t1_bankB_wire[t1] = t1_bankB_a2_wire;
  end
end
endgenerate

reg [NUMMBNK-1:0] t1_readA;
reg [NUMMBNK-1:0] t1_writeA;
reg [NUMMBNK*BITVBNK-1:0] t1_bankA;
reg [NUMMBNK*BITSROW-1:0] t1_addrA;
reg [NUMMBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMMBNK*PHYWDTH-1:0] t1_dinA;
reg [NUMMBNK-1:0] t1_refrB;
reg [NUMMBNK*BITVBNK-1:0] t1_bankB;

integer t1_out_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_bankA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_refrB = 0;
  t1_bankB = 0;
  t1_doutA_a2 = 0;
  t1_serrA_a2 = 0;
  t1_derrA_a2 = 0;
  t1_padrA_a2 = 0;
  for (t1_out_int=0; t1_out_int<NUMMBNK; t1_out_int=t1_out_int+1) begin
    t1_readA = t1_readA | (t1_readA_wire[t1_out_int] << t1_out_int);
    t1_writeA = t1_writeA | (t1_writeA_wire[t1_out_int] << t1_out_int);
    t1_bankA = t1_bankA | (t1_bankA_wire[t1_out_int] << (t1_out_int*BITVBNK));
    t1_addrA = t1_addrA | (t1_addrA_wire[t1_out_int] << (t1_out_int*BITSROW));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_doutA_a2 = t1_doutA_a2 | (t1_doutA_a2_wire[t1_out_int] << (t1_out_int*WIDTH));
    t1_serrA_a2 = t1_serrA_a2 | (t1_serrA_a2_wire[t1_out_int] << t1_out_int);
    t1_derrA_a2 = t1_derrA_a2 | (t1_derrA_a2_wire[t1_out_int] << t1_out_int);
    t1_padrA_a2 = t1_padrA_a2 | (t1_padrA_a2_wire[t1_out_int] << (t1_out_int*(BITSROW+BITWRDS+BITVBNK)));
    t1_refrB = t1_refrB | (t1_refrB_wire[t1_out_int] << t1_out_int);
    t1_bankB = t1_bankB | (t1_bankB_wire[t1_out_int] << (t1_out_int*BITVBNK));
  end
end

wire [WIDTH-1:0] t2_doutA_a2_wire [0:1-1];
wire t2_serrA_a2_wire [0:1-1];
wire t2_derrA_a2_wire [0:1-1];
wire [(BITSROW+BITWRDS+BITVBNK)-1:0] t2_padrA_a2_wire [0:1-1];
wire t2_readA_wire [0:1-1];
wire t2_writeA_wire [0:1-1];
wire [BITVBNK-1:0] t2_bankA_wire [0:1-1];
wire [BITSROW-1:0] t2_addrA_wire [0:1-1];
wire [NUMWRDS*MEMWDTH-1:0] t2_bwA_wire [0:1-1];
wire [NUMWRDS*MEMWDTH-1:0] t2_dinA_wire [0:1-1];

genvar t2;
generate for (t2=0; t2<1; t2=t2+1) begin: t2_loop
  wire t2_readA_a2_wire = t2_readA_a2 >> t2;
  wire t2_writeA_a2_wire = t2_writeA_a2 >> t2;
  wire [BITVBNK-1:0] t2_bankA_a2_wire = t2_bankA_a2 >> (t2*BITVBNK);
  wire [BITMROW-1:0] t2_addrA_a2_wire = t2_addrA_a2 >> (t2*BITMROW);
  wire [WIDTH-1:0] t2_dinA_a2_wire = t2_dinA_a2 >> (t2*WIDTH);

  wire [NUMWRDS*MEMWDTH-1:0] t2_doutA_wire = t2_doutA >> (t2*PHYWDTH);

  begin: align_loop
    infra_align_edram #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMMROW), .BITADDR (BITMROW), .NUMRBNK (NUMVBNK), .BITRBNK (BITVBNK),
                        .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS+BITVBNK),
                        .SRAM_DELAY (DRAM_DELAY))
        infra (.read (t2_readA_a2_wire), .write (t2_writeA_a2_wire), .badr (t2_bankA_a2_wire), .addr (t2_addrA_a2_wire),
	       .din (t2_dinA_a2_wire), .dout (t2_doutA_a2_wire[t2]), .serr (t2_serrA_a2_wire[t2]), .padr (t2_padrA_a2_wire[t2]),
               .mem_read (t2_readA_wire[t2]), .mem_write (t2_writeA_wire[t2]), .mem_badr (t2_bankA_wire[t2]), .mem_addr (t2_addrA_wire[t2]),
               .mem_bw (t2_bwA_wire[t2]), .mem_din (t2_dinA_wire[t2]), .mem_dout (t2_doutA_wire),
               .clk (clk), .rst (rst),
               .select_rbnk (select_rbnk), .select_addr (select_mrow));
    assign t2_derrA_a2_wire[t2] = 1'b0;
  end
end
endgenerate

reg [1-1:0] t2_readA;
reg [1-1:0] t2_writeA;
reg [1*(BITVBNK+BITSROW)-1:0] t2_addrA;
reg [1*PHYWDTH-1:0] t2_bwA;
reg [1*PHYWDTH-1:0] t2_dinA;

integer t2_out_int;
always_comb begin
  t2_readA = 0;
  t2_writeA = 0;
  t2_addrA = 0;
  t2_bwA = 0;
  t2_dinA = 0;
  t2_doutA_a2 = 0;
  t2_serrA_a2 = 0;
  t2_derrA_a2 = 0;
  t2_padrA_a2 = 0;
  for (t2_out_int=0; t2_out_int<1; t2_out_int=t2_out_int+1) begin
    t2_readA = t2_readA | (t2_readA_wire[t2_out_int] << t2_out_int);
    t2_writeA = t2_writeA | (t2_writeA_wire[t2_out_int] << t2_out_int);
    t2_addrA = t2_addrA | ({t2_bankA_wire[t2_out_int],t2_addrA_wire[t2_out_int]} << (t2_out_int*(BITVBNK+BITSROW)));
    t2_bwA = t2_bwA | (t2_bwA_wire[t2_out_int] << (t2_out_int*PHYWDTH));
    t2_dinA = t2_dinA | (t2_dinA_wire[t2_out_int] << (t2_out_int*PHYWDTH));
    t2_doutA_a2 = t2_doutA_a2 | (t2_doutA_a2_wire[t2_out_int] << (t2_out_int*WIDTH));
    t2_serrA_a2 = t2_serrA_a2 | (t2_serrA_a2_wire[t2_out_int] << t2_out_int);
    t2_derrA_a2 = t2_derrA_a2 | (t2_derrA_a2_wire[t2_out_int] << t2_out_int);
    t2_padrA_a2 = t2_padrA_a2 | (t2_padrA_a2_wire[t2_out_int] << (t2_out_int*(BITSROW+BITWRDS+BITVBNK)));
  end
end

`ifdef FORMAL
genvar berr_int;
generate for (berr_int=0; berr_int<NUMMBNK; berr_int=berr_int+1) begin: berr_loop
  assume_mem_nerr_check: assert property (@(posedge clk) disable iff (rst)
                                          (a2_loop.algo.ip_top_sva.mem_nerr[0][berr_int] == t1_loop[berr_int].align_loop.infra.ip_top_sva.mem_nerr));
  assume_mem_serr_check: assert property (@(posedge clk) disable iff (rst)
                                          (a2_loop.algo.ip_top_sva.mem_serr[0][berr_int] == t1_loop[berr_int].align_loop.infra.ip_top_sva.mem_serr));
  assume_mem_nowr_check: assert property (@(posedge clk) disable iff (rst)
					  !(pwrite && a2_loop.algo.ip_top_sva.mem_serr[0][berr_int]));
end
endgenerate

assume_xmem_nerr_check: assert property (@(posedge clk) disable iff (rst)
                                         (a2_loop.algo.ip_top_sva.xmem_nerr[0] == t2_loop[0].align_loop.infra.ip_top_sva.mem_nerr));
assume_xmem_serr_check: assert property (@(posedge clk) disable iff (rst)
                                         (a2_loop.algo.ip_top_sva.xmem_serr[0] == t2_loop[0].align_loop.infra.ip_top_sva.mem_serr));

ip_top_sva_2rw_rl_edram_top #(
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMMBNK     (NUMMBNK),
     .BITMBNK     (BITMBNK),
     .NUMRROW     (NUMRROW),
     .BITRROW     (BITRROW),
     .REFFREQ     (REFFREQ))
ip_top_sva (.*);


ip_top_sva_2_2rw_rl_edram_top #(
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMMBNK     (NUMMBNK),
     .BITMBNK     (BITMBNK),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .REFFREQ     (REFFREQ))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITRROW-1:0] help_rrow = sva_int;
  wire [BITVBNK-1:0] help_rbnk = sva_int;
ip_top_sva_2rw_rl_edram_top #(
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMMBNK     (NUMMBNK),
     .BITMBNK     (BITMBNK),
     .NUMRROW     (NUMRROW),
     .BITRROW     (BITRROW),
     .REFFREQ     (REFFREQ))
ip_top_sva (.select_rrow (help_rrow), .select_rbnk (help_rbnk), .*);
end
endgenerate

ip_top_sva_2_2rw_rl_edram_top #(
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMMBNK     (NUMMBNK),
     .BITMBNK     (BITMBNK),
     .NUMWRDS     (NUMWRDS),
     .BITWRDS     (BITWRDS),
     .NUMSROW     (NUMSROW),
     .BITSROW     (BITSROW),
     .REFFREQ     (REFFREQ))
ip_top_sva_2 (.*);

`endif

endmodule
