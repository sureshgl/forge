
module algo_1r1rwor5rp1wp_top (clk, rst, ready,
                               ena_rdacc,
                               writeA, wr_adrA, dinA,
                               readA, rd_adrA, rd_vldA, rd_doutA, rd_serrA, rd_derrA, rd_padrA,
                               writeB, wr_adrB, dinB,
                               readB, rd_adrB, rd_vldB, rd_doutB, rd_serrB, rd_derrB, rd_padrB,
	                       t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
	                       t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_readB, t2_addrB, t2_doutB);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPSDO = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ENAHEC = 0;
  parameter ENAQEC = 0;
  parameter ECCWDTH = 7;
  parameter NUMADDRA = 8192;
  parameter BITADDRA = 13;
  parameter NUMADDRB = 10240;
  parameter BITADDRB = 14;
  parameter NUMVROW = 2048;   // ALGO Parameters
  parameter BITVROW = 11;
  parameter NUMVBNK = 4;
  parameter BITVBNK = 2;
  parameter NUMPBNK = 5;
  parameter BITPBNK = 3;
  parameter NUMWRDS = 4;      // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENAHEC ? WIDTH+2*ECCWDTH : ENAQEC ? WIDTH+4*ECCWDTH : WIDTH;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter SRAM_DELAY = 2;
  parameter FLOPECC = 0;
  parameter FLOPCMD = 0;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  input                          writeA;
  input [BITADDRA-1:0]           wr_adrA;
  input [WIDTH-1:0]              dinA;

  input [2-1:0]                  readA;
  input [2*BITADDRA-1:0]         rd_adrA;
  output [2-1:0]                 rd_vldA;
  output [2*WIDTH-1:0]           rd_doutA;
  output [2-1:0]                 rd_serrA;
  output [2-1:0]                 rd_derrA;
  output [2*BITPADR-1:0]         rd_padrA;

  input                          writeB;
  input [BITADDRB-1:0]           wr_adrB;
  input [WIDTH-1:0]              dinB;

  input [5-1:0]                  readB;
  input [5*BITADDRB-1:0]         rd_adrB;
  output [5-1:0]                 rd_vldB;
  output [5*WIDTH-1:0]           rd_doutB;
  output [5-1:0]                 rd_serrB;
  output [5-1:0]                 rd_derrB;
  output [5*BITPADR-1:0]         rd_padrB;

  input                          ena_rdacc;
  output                         ready;
  input                          clk, rst;

  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  output [NUMVBNK-1:0] t1_readB;
  output [NUMVBNK*BITSROW-1:0] t1_addrB;
  input [NUMVBNK*PHYWDTH-1:0] t1_doutB;

  output [1-1:0] t2_writeA;
  output [1*BITSROW-1:0] t2_addrA;
  output [1*PHYWDTH-1:0] t2_bwA;
  output [1*PHYWDTH-1:0] t2_dinA;
  output [1-1:0] t2_readB;
  output [1*BITSROW-1:0] t2_addrB;
  input [1*PHYWDTH-1:0] t2_doutB;

`ifdef FORMAL
wire [BITADDRB-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) ena_rdacc ? (select_addr < NUMADDRA) : (select_addr < NUMADDRB));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDRB), .BITADDR (BITADDRB),
  .NUMVBNK (NUMPBNK), .BITVBNK (BITPBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  addr_inst (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));

wire [BITSROW-1:0] select_srow;
np2_addr #(
  .NUMADDR (NUMVROW), .BITADDR (BITVROW),
  .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
  .NUMVROW (NUMSROW), .BITVROW (BITSROW))
  vrow_inst (.vbadr(), .vradr(select_srow), .vaddr(select_vrow));

`else
wire [BITADDRB-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW-1:0] select_vrow = 0;
wire [BITSROW-1:0] select_srow = 0;
`endif

wire [NUMVBNK-1:0] t1_writeA_a1A;
wire [NUMVBNK*BITVROW-1:0] t1_addrA_a1A;
wire [NUMVBNK*WIDTH-1:0] t1_dinA_a1A;
wire [NUMVBNK-1:0] t1_readB_a1A;
wire [NUMVBNK*BITVROW-1:0] t1_addrB_a1A;
reg [NUMVBNK*WIDTH-1:0] t1_doutB_a1;
reg [NUMVBNK-1:0] t1_fwrdB_a1;
reg [NUMVBNK-1:0] t1_serrB_a1;
reg [NUMVBNK-1:0] t1_derrB_a1;
reg [NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrB_a1;
  
wire t2_writeA_a1A;
wire [BITVROW-1:0] t2_addrA_a1A;
wire [WIDTH-1:0] t2_dinA_a1A;
wire t2_readB_a1A;
wire [BITVROW-1:0] t2_addrB_a1A;
reg [WIDTH-1:0] t2_doutB_a1;
reg t2_fwrdB_a1;
reg t2_serrB_a1;
reg t2_derrB_a1;
reg [(BITSROW+BITWRDS)-1:0] t2_padrB_a1;

wire a1A_ready, a1B_ready;
assign ready = a1A_ready && a1B_ready;

generate if (1) begin: a1A_loop

algo_nr1rw_1r1w #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC || ENAHEC || ENAQEC), .NUMVRPT (2), .NUMPRPT (1),
                  .NUMADDR (NUMADDRA), .BITADDR (BITADDRA), .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK),
                  .BITPADR (BITPADR-1), .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    algo (.clk (clk), .rst (rst), .ready (a1A_ready),
          .write (writeA), .wr_adr (wr_adrA), .din (dinA),
	  .read (readA), .rd_adr (rd_adrA), .rd_vld (rd_vldA), .rd_dout (rd_doutA),
          .rd_fwrd ({rd_padrA[2*BITPADR-1],rd_padrA[BITPADR-1]}), .rd_serr (rd_serrA), .rd_derr (rd_derrA),
          .rd_padr ({rd_padrA[2*BITPADR-2:BITPADR],rd_padrA[BITPADR-2:0]}),
	  .t1_writeA (t1_writeA_a1A), .t1_addrA (t1_addrA_a1A), .t1_dinA (t1_dinA_a1A),
          .t1_readB (t1_readB_a1A), .t1_addrB (t1_addrB_a1A), .t1_doutB (t1_doutB_a1),
          .t1_fwrdB (t1_fwrdB_a1), .t1_serrB (t1_serrB_a1), .t1_derrB (t1_derrB_a1), .t1_padrB (t1_padrB_a1),
	  .t2_writeA (t2_writeA_a1A), .t2_addrA (t2_addrA_a1A), .t2_dinA (t2_dinA_a1A),
          .t2_readB (t2_readB_a1A), .t2_addrB (t2_addrB_a1A), .t2_doutB (t2_doutB_a1),
	  .t2_fwrdB (t2_fwrdB_a1), .t2_serrB (t2_serrB_a1), .t2_derrB (t2_derrB_a1), .t2_padrB (t2_padrB_a1),
	  .select_addr (select_addr[BITADDRA-1:0]), .select_bit (select_bit));

end
endgenerate

wire [5-1:0] rd_fwrdB_int;
wire [5*(BITPADR-1)-1:0] rd_padrB_int;
reg [BITPADR-2:0] rd_padrB_tmp [0:5-1];
reg [5*BITPADR-1:0] rd_padrB;
integer padrB_int;
always_comb begin
  rd_padrB = 0;
  for (padrB_int=0; padrB_int<5; padrB_int=padrB_int+1) begin
    rd_padrB_tmp[padrB_int] = rd_padrB_int << (padrB_int*(BITPADR-1));
    rd_padrB = rd_padrB | ({rd_fwrdB_int[padrB_int],rd_padrB_tmp[padrB_int]} << (padrB_int*BITPADR));
  end
end

wire [5-1:0] t1_writeA_a1B;
wire [5*BITVROW-1:0] t1_addrA_a1B;
wire [5*WIDTH-1:0] t1_dinA_a1B;
wire [5-1:0] t1_readB_a1B;
wire [5*BITVROW-1:0] t1_addrB_a1B;
//reg [5*WIDTH-1:0] t1_doutB_a1;
//reg [5-1:0] t1_fwrdB_a1;
//reg [5-1:0] t1_serrB_a1;
//reg [5-1:0] t1_derrB_a1;
//reg [5*(BITSROW+BITWRDS)-1:0] t1_padrB_a1;

generate if (1) begin: a1B_loop

  algo_mrpnwp_1r1w_base #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMRDPT (5), .NUMWRPT (1),
                          .NUMADDR (NUMADDRB), .BITADDR (BITADDRB), 
                          .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMPBNK), .BITVBNK (BITPBNK),
                          .BITPADR (BITPADR-1), .SRAM_DELAY (SRAM_DELAY+FLOPECC+FLOPMEM), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    algo (.clk (clk), .rst (rst), .ready (a1B_ready),
          .write (writeB), .wr_adr (wr_adrB), .din (dinB),
          .read (readB), .rd_adr (rd_adrB), .rd_vld (rd_vldB), .rd_dout (rd_doutB),
          .rd_fwrd (rd_fwrdB_int), .rd_serr (rd_serrB), .rd_derr (rd_derrB), .rd_padr (rd_padrB_int),
          .t1_writeA (t1_writeA_a1B), .t1_addrA (t1_addrA_a1B), .t1_dinA (t1_dinA_a1B),
          .t1_readB (t1_readB_a1B), .t1_addrB (t1_addrB_a1B), .t1_doutB ({t2_doutB_a1,t1_doutB_a1}),
          .t1_fwrdB ({t2_fwrdB_a1,t1_fwrdB_a1}), .t1_serrB ({t2_serrB_a1,t1_serrB_a1}), .t1_derrB ({t2_derrB_a1,t1_derrB_a1}), .t1_padrB ({t2_padrB_a1,t1_padrB_a1}),
          .select_addr (select_addr), .select_bit (select_bit));
/*
algo_nr1w_dup #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMRDPT (5), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (1), .BITVBNK (0), .BITPADR (BITPADRB-1), .NUMCOLS (1), .BITCOLS(0),
                .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    algo (.clk(clk), .rst(rst), .ready(a1B_ready),
          .write(writeB), .wr_adr(wr_adrB[BITVROW-1:0]), .din(dinB),
          .read(readB), .rd_adr({rd_adrB[4*BITADDR+BITVROW-1:4*BITADDR],rd_adrB[3*BITADDR+BITVROW-1:3*BITADDR],rd_adrB[2*BITADDR+BITVROW-1:2*BITADDR],
                                 rd_adrB[1*BITADDR+BITVROW-1:1*BITADDR],rd_adrB[0*BITADDR+BITVROW-1:0*BITADDR]}), .rd_vld(rd_vldB), .rd_dout(rd_doutB),
          .rd_fwrd(rd_fwrdB_int), .rd_serr(rd_serrB), .rd_derr(rd_derrB), .rd_padr(rd_padrB_int),
          .t1_writeA(t1_writeA_a1B), .t1_addrA(t1_addrA_a1B), .t1_dinA(t1_dinA_a1B),
          .t1_readB(t1_readB_a1B), .t1_addrB(t1_addrB_a1B),
          .t1_doutB({t2_doutB_a1,t1_doutB_a1}), .t1_fwrdB({t2_fwrdB_a1,t1_fwrdB_a1}),
          .t1_serrB({t2_serrB_a1,t1_serrB_a1}), .t1_derrB({t2_derrB_a1,t1_derrB_a1}), .t1_padrB({t2_padrB_a1,t1_padrB_a1}),
          .select_addr(select_vrow), .select_bit(select_bit));
*/
end
endgenerate


wire t1_writeA_wire [0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];
wire t1_readB_wire [0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrB_wire [0:NUMVBNK-1];
wire [WIDTH-1:0] t1_doutB_a1_wire [0:NUMVBNK-1];
wire t1_fwrdB_a1_wire [0:NUMVBNK-1];
wire t1_serrB_a1_wire [0:NUMVBNK-1];
wire t1_derrB_a1_wire [0:NUMVBNK-1];
wire [(BITSROW+BITWRDS)-1:0] t1_padrB_a1_wire [0:NUMVBNK-1];

genvar t1;
generate for (t1=0; t1<NUMVBNK; t1=t1+1) begin: t1_loop
  wire t1_writeA_a1_wire = (!ready || ena_rdacc) ? t1_writeA_a1A >> t1 : t1_writeA_a1B >> t1;
  wire [BITVROW-1:0] t1_addrA_a1_wire = (!ready || ena_rdacc) ? t1_addrA_a1A >> (t1*BITVROW) : t1_addrA_a1B >> (t1*BITVROW);
  wire [WIDTH-1:0] t1_dinA_a1_wire = (!ready || ena_rdacc) ? t1_dinA_a1A >> (t1*WIDTH) : t1_dinA_a1B >> (t1*WIDTH);

  wire t1_readB_a1_wire = (!ready || ena_rdacc) ? t1_readB_a1A >> t1 : t1_readB_a1B >> t1;
  wire [BITVROW-1:0] t1_addrB_a1_wire = (!ready || ena_rdacc) ? t1_addrB_a1A >> (t1*BITVROW) : t1_addrB_a1B >> (t1*BITVROW);
  wire [NUMWRDS*MEMWDTH-1:0] t1_doutB_wire = t1_doutB >> (t1*PHYWDTH);

  wire mem_write_t1_wire;
  wire [BITSROW-1:0] mem_wr_adr_t1_wire;
  wire [NUMWRDS*MEMWDTH-1:0] mem_bw_t1_wire;
  wire [NUMWRDS*MEMWDTH-1:0] mem_din_t1_wire;
  wire mem_read_t1_wire;
  wire [BITSROW-1:0] mem_rd_adr_t1_wire;
  wire [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_t1_wire;
  wire mem_rd_fwrd_t1_wire;
  wire mem_rd_serr_t1_wire;
  wire mem_rd_derr_t1_wire;
  wire [BITSROW-1:0] mem_rd_padr_t1_wire;

  if (1) begin: align_loop
    infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (ENAPSDO), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ENAHEC (ENAHEC), .ENAQEC (ENAQEC), .ECCWDTH (ECCWDTH), .ENAPADR (1),
                           .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITSROW),
                           .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
      infra (.write(t1_writeA_a1_wire), .wr_adr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
             .read(t1_readB_a1_wire), .rd_adr(t1_addrB_a1_wire), .rd_dout(t1_doutB_a1_wire[t1]),
             .rd_fwrd(t1_fwrdB_a1_wire[t1]), .rd_serr(t1_serrB_a1_wire[t1]), .rd_derr(t1_derrB_a1_wire[t1]), .rd_padr(t1_padrB_a1_wire[t1]),
             .mem_write (mem_write_t1_wire), .mem_wr_adr(mem_wr_adr_t1_wire), .mem_bw (mem_bw_t1_wire), .mem_din (mem_din_t1_wire),
             .mem_read (mem_read_t1_wire), .mem_rd_adr(mem_rd_adr_t1_wire), .mem_rd_dout (mem_rd_dout_t1_wire),
             .mem_rd_fwrd(mem_rd_fwrd_t1_wire), .mem_rd_padr(mem_rd_padr_t1_wire),
             .clk (clk), .rst (rst),
             .select_addr (select_vrow));
      end

  if (1) begin: stack_loop
    infra_stack_1r1w #(.WIDTH (NUMWRDS*MEMWDTH), .ENAPSDO (ENAPSDO), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                       .NUMWROW (NUMSROW), .BITWROW (BITSROW), .NUMWBNK (1), .BITWBNK (0),
                       .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
      infra (.write (mem_write_t1_wire), .wr_adr (mem_wr_adr_t1_wire), .bw (mem_bw_t1_wire), .din (mem_din_t1_wire),
             .read (mem_read_t1_wire), .rd_adr (mem_rd_adr_t1_wire), .rd_dout (mem_rd_dout_t1_wire),
             .rd_fwrd (mem_rd_fwrd_t1_wire), .rd_serr (mem_rd_serr_t1_wire), .rd_derr(mem_rd_derr_t1_wire), .rd_padr(mem_rd_padr_t1_wire),
             .mem_write (t1_writeA_wire[t1]), .mem_wr_adr(t1_addrA_wire[t1]), .mem_bw (t1_bwA_wire[t1]), .mem_din (t1_dinA_wire[t1]),
             .mem_read (t1_readB_wire[t1]), .mem_rd_adr(t1_addrB_wire[t1]), .mem_rd_dout (t1_doutB_wire),
             .clk (clk), .rst(rst),
             .select_addr (select_srow));
  end
end
endgenerate

reg [NUMVBNK-1:0] t1_writeA;
reg [NUMVBNK*BITSROW-1:0] t1_addrA;
reg [NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMVBNK*PHYWDTH-1:0] t1_dinA;
reg [NUMVBNK-1:0] t1_readB;
reg [NUMVBNK*BITSROW-1:0] t1_addrB;

integer t1_out_int;
always_comb begin
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_readB = 0;
  t1_addrB = 0;
  t1_doutB_a1 = 0;
  t1_fwrdB_a1 = 0;
  t1_serrB_a1 = 0;
  t1_derrB_a1 = 0;
  t1_padrB_a1 = 0;
  for (t1_out_int=0; t1_out_int<NUMVBNK; t1_out_int=t1_out_int+1) begin
    t1_writeA = t1_writeA | (t1_writeA_wire[t1_out_int] << t1_out_int);
    t1_addrA = t1_addrA | (t1_addrA_wire[t1_out_int] << (t1_out_int*BITSROW));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_readB = t1_readB | (t1_readB_wire[t1_out_int] << t1_out_int);
    t1_addrB = t1_addrB | (t1_addrB_wire[t1_out_int] << (t1_out_int*BITSROW));
    t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1_out_int] << (t1_out_int*WIDTH));
    t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[t1_out_int] << t1_out_int);
    t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1_out_int] << t1_out_int);
    t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1_out_int] << t1_out_int);
    t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1_out_int] << (t1_out_int*(BITSROW+BITWRDS)));
  end
end

wire t2_writeA_wire [0:1-1];
wire [BITSROW-1:0] t2_addrA_wire [0:1-1];
wire [NUMWRDS*MEMWDTH-1:0] t2_bwA_wire [0:1-1];
wire [NUMWRDS*MEMWDTH-1:0] t2_dinA_wire [0:1-1];
wire t2_readB_wire [0:1-1];
wire [BITSROW-1:0] t2_addrB_wire [0:1-1];
wire [WIDTH-1:0] t2_doutB_a1_wire [0:1-1];
wire t2_fwrdB_a1_wire [0:1-1];
wire t2_serrB_a1_wire [0:1-1];
wire t2_derrB_a1_wire [0:1-1];
wire [(BITSROW+BITWRDS)-1:0] t2_padrB_a1_wire [0:1-1];

genvar t2;
generate for (t2=0; t2<1; t2=t2+1) begin: t2_loop
  wire t2_writeA_a1_wire = (!ready || ena_rdacc) ? t2_writeA_a1A >> t2 : t1_writeA_a1B >> (t2+4);
  wire [BITVROW-1:0] t2_addrA_a1_wire = (!ready || ena_rdacc) ? t2_addrA_a1A >> (t2*BITVROW) : t1_addrA_a1B >> ((t2+4)*BITVROW);
  wire [WIDTH-1:0] t2_dinA_a1_wire = (!ready || ena_rdacc) ? t2_dinA_a1A >> (t2*WIDTH) : t1_dinA_a1B >> ((t2+4)*WIDTH);

  wire t2_readB_a1_wire = (!ready || ena_rdacc) ? t2_readB_a1A >> t2 : t1_readB_a1B >> (t2+4);
  wire [BITVROW-1:0] t2_addrB_a1_wire = (!ready || ena_rdacc) ? t2_addrB_a1A >> (t2*BITVROW) : t1_addrB_a1B >> ((t2+4)*BITVROW);
  wire [NUMWRDS*MEMWDTH-1:0] t2_doutB_wire = t2_doutB >> (t2*PHYWDTH);

  wire mem_write_t2_wire;
  wire [BITSROW-1:0] mem_wr_adr_t2_wire;
  wire [NUMWRDS*MEMWDTH-1:0] mem_bw_t2_wire;
  wire [NUMWRDS*MEMWDTH-1:0] mem_din_t2_wire;
  wire mem_read_t2_wire;
  wire [BITSROW-1:0] mem_rd_adr_t2_wire;
  wire [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_t2_wire;
  wire mem_rd_fwrd_t2_wire;
  wire mem_rd_serr_t2_wire;
  wire mem_rd_derr_t2_wire;
  wire [BITSROW-1:0] mem_rd_padr_t2_wire;

  if (1) begin: align_loop
    infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ENAHEC (ENAHEC), .ENAQEC (ENAQEC), .ECCWDTH (ECCWDTH), .ENAPADR (1),
                           .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITSROW),
                           .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
      infra (.write(t2_writeA_a1_wire), .wr_adr(t2_addrA_a1_wire), .din(t2_dinA_a1_wire),
             .read(t2_readB_a1_wire), .rd_adr(t2_addrB_a1_wire), .rd_dout(t2_doutB_a1_wire[t2]),
             .rd_fwrd(t2_fwrdB_a1_wire[t2]), .rd_serr(t2_serrB_a1_wire[t2]), .rd_derr(t2_derrB_a1_wire[t2]), .rd_padr(t2_padrB_a1_wire[t2]),
             .mem_write (mem_write_t2_wire), .mem_wr_adr(mem_wr_adr_t2_wire), .mem_bw (mem_bw_t2_wire), .mem_din (mem_din_t2_wire),
             .mem_read (mem_read_t2_wire), .mem_rd_adr(mem_rd_adr_t2_wire), .mem_rd_dout (mem_rd_dout_t2_wire),
             .mem_rd_fwrd(mem_rd_fwrd_t2_wire), .mem_rd_padr(mem_rd_padr_t2_wire),
             .clk (clk), .rst (rst),
             .select_addr (select_vrow));
      end

  if (1) begin: stack_loop
    infra_stack_1r1w #(.WIDTH (NUMWRDS*MEMWDTH), .ENAPSDO (0), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                       .NUMWROW (NUMSROW), .BITWROW (BITSROW), .NUMWBNK (1), .BITWBNK (0),
                       .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
      infra (.write (mem_write_t2_wire), .wr_adr (mem_wr_adr_t2_wire), .bw (mem_bw_t2_wire), .din (mem_din_t2_wire),
             .read (mem_read_t2_wire), .rd_adr (mem_rd_adr_t2_wire), .rd_dout (mem_rd_dout_t2_wire),
             .rd_fwrd (mem_rd_fwrd_t2_wire), .rd_serr (mem_rd_serr_t2_wire), .rd_derr(mem_rd_derr_t2_wire), .rd_padr(mem_rd_padr_t2_wire),
             .mem_write (t2_writeA_wire[t2]), .mem_wr_adr(t2_addrA_wire[t2]), .mem_bw (t2_bwA_wire[t2]), .mem_din (t2_dinA_wire[t2]),
             .mem_read (t2_readB_wire[t2]), .mem_rd_adr(t2_addrB_wire[t2]), .mem_rd_dout (t2_doutB_wire),
             .clk (clk), .rst(rst),
             .select_addr (select_srow));
  end
end
endgenerate

reg [1-1:0] t2_writeA;
reg [1*BITSROW-1:0] t2_addrA;
reg [1*PHYWDTH-1:0] t2_bwA;
reg [1*PHYWDTH-1:0] t2_dinA;
reg [1-1:0] t2_readB;
reg [1*BITSROW-1:0] t2_addrB;

integer t2_out_int;
always_comb begin
  t2_writeA = 0;
  t2_addrA = 0;
  t2_bwA = 0;
  t2_dinA = 0;
  t2_readB = 0;
  t2_addrB = 0;
  t2_doutB_a1 = 0;
  t2_fwrdB_a1 = 0;
  t2_serrB_a1 = 0;
  t2_derrB_a1 = 0;
  t2_padrB_a1 = 0;
  for (t2_out_int=0; t2_out_int<1; t2_out_int=t2_out_int+1) begin
    t2_writeA = t2_writeA | (t2_writeA_wire[t2_out_int] << t2_out_int);
    t2_addrA = t2_addrA | (t2_addrA_wire[t2_out_int] << (t2_out_int*BITSROW));
    t2_bwA = t2_bwA | (t2_bwA_wire[t2_out_int] << (t2_out_int*PHYWDTH));
    t2_dinA = t2_dinA | (t2_dinA_wire[t2_out_int] << (t2_out_int*PHYWDTH));
    t2_readB = t2_readB | (t2_readB_wire[t2_out_int] << t2_out_int);
    t2_addrB = t2_addrB | (t2_addrB_wire[t2_out_int] << (t2_out_int*BITSROW));
    t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2_out_int] << (t2_out_int*WIDTH));
    t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_wire[t2_out_int] << t2_out_int);
    t2_serrB_a1 = t2_serrB_a1 | (t2_serrB_a1_wire[t2_out_int] << t2_out_int);
    t2_derrB_a1 = t2_derrB_a1 | (t2_derrB_a1_wire[t2_out_int] << t2_out_int);
    t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_wire[t2_out_int] << (t2_out_int*(BITSROW+BITWRDS)));
  end
end

`ifdef FORMAL
genvar berr_int;
generate for (berr_int=0; berr_int<NUMVBNK; berr_int=berr_int+1) begin: berr_loop
  assume_mem_nerr_check: assert property (@(posedge clk) disable iff (rst)
					  (a1A_loop.algo.ip_top_sva.mem_nerr[0][berr_int] == t1_loop[berr_int].align_loop.infra.ip_top_sva.mem_nerr));
  assume_mem_serr_check: assert property (@(posedge clk) disable iff (rst)
					  (a1A_loop.algo.ip_top_sva.mem_serr[0][berr_int] == t1_loop[berr_int].align_loop.infra.ip_top_sva.mem_serr));
end
endgenerate

assume_xmem_nerr_check: assert property (@(posedge clk) disable iff (rst)
					 (a1A_loop.algo.ip_top_sva.xmem_nerr[0] == t2_loop[0].align_loop.infra.ip_top_sva.mem_nerr));
assume_xmem_serr_check: assert property (@(posedge clk) disable iff (rst)
					 (a1A_loop.algo.ip_top_sva.xmem_serr[0] == t2_loop[0].align_loop.infra.ip_top_sva.mem_serr));

genvar vrpt_int;
generate
  for (vrpt_int=1; vrpt_int<NUMPBNK; vrpt_int=vrpt_int+1) begin: vrpt_int_loop
    assume_1r1rw_check: assert property (@(posedge clk) disable iff (rst) (~readB[vrpt_int] || ~ena_rdacc));
  end
endgenerate

assume_ena_rdacc_check: assert property (@(posedge clk) disable iff (rst) $stable(ena_rdacc));

`endif

endmodule
