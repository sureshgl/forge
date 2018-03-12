
module algo_2rw_1rw_a56_top (clk, rst, ready,
                             read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                             t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA,
                             t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                             t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAEXT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter NUMWRDS = 1;      // ALIGN Parameters
  parameter BITWRDS = 0;
  parameter NUMSROW = 1024;
  parameter BITSROW = 10;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 2;
  parameter ECCBITS = 4;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  parameter CDOUT_WIDTH = 2*WIDTH+ECCWDTH;

  input [2-1:0]                  read;
  input [2-1:0]                  write;
  input [2*BITADDR-1:0]          addr;
  input [2*WIDTH-1:0]            din;
  output [2-1:0]                 rd_vld;
  output [2*WIDTH-1:0]           rd_dout;
  output [2-1:0]                 rd_serr;
  output [2-1:0]                 rd_derr;
  output [2*BITPADR-1:0]         rd_padr;

  output                         ready;
  input                          clk, rst;

  output [2*NUMVBNK-1:0] t1_readA;
  output [2*NUMVBNK-1:0] t1_writeA;
  output [2*NUMVBNK*BITSROW-1:0] t1_addrA;
  output [2*NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [2*NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [2*NUMVBNK*PHYWDTH-1:0] t1_doutA;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*SDOUT_WIDTH-1:0] t2_dinA;
  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*SDOUT_WIDTH-1:0] t2_doutB;

  output [2-1:0] t3_writeA;
  output [2*BITVROW-1:0] t3_addrA;
  output [2*CDOUT_WIDTH-1:0] t3_dinA;
  output [2-1:0] t3_readB;
  output [2*BITVROW-1:0] t3_addrB;
  input [2*CDOUT_WIDTH-1:0] t3_doutB;

`ifdef FORMAL 
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr==0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit==0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));
  
wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  adr_a2 (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));

`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW-1:0] select_vrow = 0;
`endif

wire [NUMVBNK-1:0] t1_writeA_a1;
wire [NUMVBNK*BITVROW-1:0] t1_addrA_a1;
wire [NUMVBNK*WIDTH-1:0] t1_dinA_a1;

wire [NUMVBNK-1:0] t1_readB_a1;
wire [NUMVBNK*BITVROW-1:0] t1_addrB_a1;
reg [NUMVBNK*WIDTH-1:0] t1_doutB_a1;
reg [NUMVBNK-1:0] t1_fwrdB_a1;
reg [NUMVBNK-1:0] t1_serrB_a1;
reg [NUMVBNK-1:0] t1_derrB_a1;
reg [NUMVBNK*(BITWRDS+BITSROW)-1:0] t1_padrB_a1;

wire [NUMVBNK-1:0] t1_readC_a1;
wire [NUMVBNK*BITVROW-1:0] t1_addrC_a1;
reg [NUMVBNK*WIDTH-1:0] t1_doutC_a1;
reg [NUMVBNK-1:0] t1_fwrdC_a1;
reg [NUMVBNK-1:0] t1_serrC_a1;
reg [NUMVBNK-1:0] t1_derrC_a1;
reg [NUMVBNK*(BITWRDS+BITSROW)-1:0] t1_padrC_a1;

wire [2-1:0] t2_writeA_a1;
wire [2*BITVROW-1:0] t2_addrA_a1;
wire [2*(BITVBNK+1)-1:0] t2_dinA_a1;
wire [2-1:0] t2_readB_a1;
wire [2*BITVROW-1:0] t2_addrB_a1;
reg [2*(BITVBNK+1)-1:0] t2_doutB_a1;
reg [2-1:0] t2_fwrdB_a1;
reg [2-1:0] t2_serrB_a1;
reg [2-1:0] t2_derrB_a1;
reg [2*(BITWRDS+BITSROW)-1:0] t2_padrB_a1;

wire [2-1:0] t3_writeA_a1;
wire [2*BITVROW-1:0] t3_addrA_a1;
wire [2*WIDTH-1:0] t3_dinA_a1;
wire [2-1:0] t3_readB_a1;
wire [2*BITVROW-1:0] t3_addrB_a1;
reg [2*WIDTH-1:0] t3_doutB_a1;
reg [2-1:0] t3_fwrdB_a1;
reg [2-1:0] t3_serrB_a1;
reg [2-1:0] t3_derrB_a1;
reg [2*(BITWRDS+BITSROW)-1:0] t3_padrB_a1;

generate if (1) begin: a1_loop

  algo_2rw_2ror1w_a56 #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
                        .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .BITPBNK(BITPBNK), .BITPADR(BITPADR-1),
                        .SRAM_DELAY(SRAM_DELAY+FLOPMEM), .DRAM_DELAY(DRAM_DELAY+FLOPMEM),
                        .FLOPIN(FLOPIN), .FLOPOUT(FLOPOUT))
    algo (.refr(1'b0), .ready(ready), .clk(clk), .rst (rst),
          .read(read),. write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd({rd_padr[2*BITPADR-1],rd_padr[BITPADR-1]}), .rd_serr(rd_serr), .rd_derr(rd_derr),
          .rd_padr({rd_padr[2*BITPADR-2:BITPADR],rd_padr[BITPADR-2:0]}),
          .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
          .t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1),
          .t1_readC(t1_readC_a1), .t1_addrC(t1_addrC_a1), .t1_doutC(t1_doutC_a1), 
          .t1_fwrdC(t1_fwrdC_a1), .t1_serrC(t1_serrC_a1), .t1_derrC(t1_derrC_a1), .t1_padrC(t1_padrC_a1),
          .t1_refrD(),
          .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1),
          .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1), .t2_doutB(t2_doutB_a1),
          .t3_writeA(t3_writeA_a1), .t3_addrA(t3_addrA_a1), .t3_dinA(t3_dinA_a1),
          .t3_readB(t3_readB_a1), .t3_addrB(t3_addrB_a1), .t3_doutB(t3_doutB_a1),
          .t3_fwrdB(t3_fwrdB_a1), .t3_serrB(t3_serrB_a1), .t3_derrB(t3_derrB_a1), .t3_padrB(t3_padrB_a1),
          .select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

wire t1_readA_wire [0:2*NUMVBNK-1];
wire t1_writeA_wire [0:2*NUMVBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:2*NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:2*NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:2*NUMVBNK-1];

wire [WIDTH-1:0] t1_doutB_a1_wire [0:NUMVBNK-1];
wire t1_fwrdB_a1_wire [0:NUMVBNK-1];
wire t1_serrB_a1_wire [0:NUMVBNK-1];
wire t1_derrB_a1_wire [0:NUMVBNK-1];
wire [BITWRDS+BITSROW-1:0] t1_padrB_a1_wire [0:NUMVBNK-1];
wire [WIDTH-1:0] t1_doutC_a1_wire [0:NUMVBNK-1];
wire t1_fwrdC_a1_wire [0:NUMVBNK-1];
wire t1_serrC_a1_wire [0:NUMVBNK-1];
wire t1_derrC_a1_wire [0:NUMVBNK-1];
wire [BITWRDS+BITSROW-1:0] t1_padrC_a1_wire [0:NUMVBNK-1];

genvar t1;
generate
  for (t1=0; t1<NUMVBNK; t1=t1+1) begin: t1_loop
    wire t1_writeA_a1_wire = t1_writeA_a1 >> t1;
    wire [BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (t1*BITVROW);
    wire [WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (t1*WIDTH);

    wire t1_readB_a1_wire = t1_readB_a1 >> t1;
    wire [BITVROW-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> (t1*BITVROW);
    wire [NUMWRDS*MEMWDTH-1:0] t1_doutB_wire = t1_doutA >> (2*t1*PHYWDTH);

    wire t1_readC_a1_wire = t1_readC_a1 >> t1;
    wire [BITVROW-1:0] t1_addrC_a1_wire = t1_addrC_a1 >> (t1*BITVROW);
    wire [NUMWRDS*MEMWDTH-1:0] t1_doutC_wire = t1_doutA >> ((2*t1+1)*PHYWDTH);

    if (1) begin: align_B_loop
      infra_align_ecc_1rw #(.WIDTH (WIDTH), .NUMADDR (NUMVROW), .BITADDR (BITVROW), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                            .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                            .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (0), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
        infra (.write (t1_writeA_a1_wire), .wr_adr (t1_addrA_a1_wire), .din (t1_dinA_a1_wire),
               .read (t1_readB_a1_wire), .rd_adr (t1_addrB_a1_wire), .rd_dout (t1_doutB_a1_wire[t1]), .rd_fwrd (t1_fwrdB_a1_wire[t1]),
               .rd_serr (t1_serrB_a1_wire[t1]), .rd_derr (t1_derrB_a1_wire[t1]), .rd_padr (t1_padrB_a1_wire[t1]),
               .mem_read (t1_readA_wire[2*t1]), .mem_write (t1_writeA_wire[2*t1]), .mem_addr (t1_addrA_wire[2*t1]),
               .mem_bw (t1_bwA_wire[2*t1]), .mem_din (t1_dinA_wire[2*t1]), .mem_dout (t1_doutB_wire),
               .select_addr (select_vrow),
               .clk (clk), .rst (rst));
    end

    if (1) begin: align_C_loop
      infra_align_ecc_1rw #(.WIDTH (WIDTH), .NUMADDR (NUMVROW), .BITADDR (BITVROW), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                            .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                            .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (0), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
        infra (.write (t1_writeA_a1_wire), .wr_adr (t1_addrA_a1_wire), .din (t1_dinA_a1_wire),
               .read (t1_readC_a1_wire), .rd_adr (t1_addrC_a1_wire), .rd_dout (t1_doutC_a1_wire[t1]), .rd_fwrd (t1_fwrdC_a1_wire[t1]),
               .rd_serr (t1_serrC_a1_wire[t1]), .rd_derr (t1_derrC_a1_wire[t1]), .rd_padr (t1_padrC_a1_wire[t1]),
               .mem_read (t1_readA_wire[2*t1+1]), .mem_write (t1_writeA_wire[2*t1+1]), .mem_addr (t1_addrA_wire[2*t1+1]),
               .mem_bw (t1_bwA_wire[2*t1+1]), .mem_din (t1_dinA_wire[2*t1+1]), .mem_dout (t1_doutC_wire),
               .select_addr (select_vrow),
               .clk (clk), .rst (rst));
    end
  end
endgenerate

reg [2*NUMVBNK-1:0] t1_readA;
reg [2*NUMVBNK-1:0] t1_writeA;
reg [2*NUMVBNK*BITSROW-1:0] t1_addrA;
reg [2*NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [2*NUMVBNK*PHYWDTH-1:0] t1_dinA;

integer t1_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_doutB_a1 = 0;
  t1_fwrdB_a1 = 0;
  t1_serrB_a1 = 0;
  t1_derrB_a1 = 0;
  t1_padrB_a1 = 0;
  t1_doutC_a1 = 0;
  t1_fwrdC_a1 = 0;
  t1_serrC_a1 = 0;
  t1_derrC_a1 = 0;
  t1_padrC_a1 = 0;
  for (t1_int=0; t1_int<2*NUMVBNK; t1_int=t1_int+1) begin
    t1_readA = t1_readA | (t1_readA_wire[t1_int] << t1_int);
    t1_writeA = t1_writeA | (t1_writeA_wire[t1_int] << t1_int);
    t1_addrA = t1_addrA | (t1_addrA_wire[t1_int] << (t1_int*BITSROW));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1_int] << (t1_int*PHYWDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1_int] << (t1_int*PHYWDTH));
  end
  for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin
    t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1_int] << (t1_int*WIDTH));
    t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[t1_int] << t1_int);
    t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1_int] << t1_int);
    t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1_int] << t1_int);
    t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1_int] << (t1_int*(BITWRDS+BITSROW)));
    t1_doutC_a1 = t1_doutC_a1 | (t1_doutC_a1_wire[t1_int] << (t1_int*WIDTH)); 
    t1_fwrdC_a1 = t1_fwrdC_a1 | (t1_fwrdC_a1_wire[t1_int] << t1_int);
    t1_serrC_a1 = t1_serrC_a1 | (t1_serrC_a1_wire[t1_int] << t1_int);
    t1_derrC_a1 = t1_derrC_a1 | (t1_derrC_a1_wire[t1_int] << t1_int);
    t1_padrC_a1 = t1_padrC_a1 | (t1_padrC_a1_wire[t1_int] << (t1_int*(BITWRDS+BITSROW)));
  end
end

wire [BITVBNK:0] t2_doutB_a1_wire [0:2-1];
wire t2_fwrdB_a1_wire [0:2-1];
wire t2_serrB_a1_wire [0:2-1];
wire t2_derrB_a1_wire [0:2-1];
wire [BITVROW-1:0] t2_padrB_a1_wire [0:2-1];
wire t2_writeA_wire [0:2-1];
wire [BITVROW-1:0] t2_addrA_wire [0:2-1];
wire [SDOUT_WIDTH-1:0] t2_bwA_wire [0:2-1];
wire [SDOUT_WIDTH-1:0] t2_dinA_wire [0:2-1];
wire t2_readB_wire [0:2-1];
wire [BITVROW-1:0] t2_addrB_wire [0:2-1];

genvar t2;
generate
  for (t2=0; t2<2; t2=t2+1) begin: t2_loop
    wire t2_writeA_a1_wire = t2_writeA_a1 >> t2;
    wire [BITVROW-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> (t2*BITVROW);
    wire [BITVBNK:0] t2_dinA_a1_wire = t2_dinA_a1 >> (t2*(BITVBNK+1));
    wire t2_readB_a1_wire = t2_readB_a1 >> t2;
    wire [BITVROW-1:0] t2_addrB_a1_wire = t2_addrB_a1 >> (t2*BITVROW);

    wire [SDOUT_WIDTH-1:0] t2_doutB_wire = t2_doutB >> (t2*SDOUT_WIDTH);

    wire mem_write_t2_wire;
    wire [BITVROW-1:0] mem_wr_adr_t2_wire;
    wire [SDOUT_WIDTH-1:0] mem_bw_t2_wire;
    wire [SDOUT_WIDTH-1:0] mem_din_t2_wire;
    wire mem_read_t2_wire;
    wire [BITVROW-1:0] mem_rd_adr_t2_wire;
    wire [SDOUT_WIDTH-1:0] mem_rd_dout_t2_wire;
    wire mem_rd_fwrd_t2_wire;
    wire mem_rd_serr_t2_wire;
    wire mem_rd_derr_t2_wire;
    wire [BITVROW-1:0] mem_rd_padr_t2_wire;

    if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (BITVBNK+1), .ENAPSDO (1), .ENADEC (1), .ECCWDTH (ECCBITS),
                             .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                             .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITVROW),
                             .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .RSTZERO (1), .ENAPADR (1))
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
      infra_stack_1r1w #(.WIDTH (SDOUT_WIDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                         .NUMWBNK (1), .BITWBNK (0), .NUMWROW (NUMVROW), .BITWROW (BITVROW),
                         .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (0), .FLOPMEM (FLOPMEM), .FLOPOUT (0), .RSTZERO (1))
        infra (.write (mem_write_t2_wire), .wr_adr (mem_wr_adr_t2_wire), .bw (mem_bw_t2_wire), .din (mem_din_t2_wire),
               .read (mem_read_t2_wire), .rd_adr (mem_rd_adr_t2_wire), .rd_dout (mem_rd_dout_t2_wire),
               .rd_fwrd (mem_rd_fwrd_t2_wire), .rd_serr (mem_rd_serr_t2_wire), .rd_derr (mem_rd_derr_t2_wire), .rd_padr (mem_rd_padr_t2_wire),
               .mem_write (t2_writeA_wire[t2]), .mem_wr_adr(t2_addrA_wire[t2]), .mem_bw (t2_bwA_wire[t2]), .mem_din (t2_dinA_wire[t2]),
               .mem_read (t2_readB_wire[t2]), .mem_rd_adr(t2_addrB_wire[t2]), .mem_rd_dout (t2_doutB_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow));
    end
  end
endgenerate

reg [2-1:0] t2_writeA;
reg [2*BITVROW-1:0] t2_addrA;
reg [2*SDOUT_WIDTH-1:0] t2_bwA;
reg [2*SDOUT_WIDTH-1:0] t2_dinA;
reg [2-1:0] t2_readB;
reg [2*BITVROW-1:0] t2_addrB;

integer t2_int;
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
  for (t2_int=0; t2_int<2; t2_int=t2_int+1) begin
    t2_writeA = t2_writeA | (t2_writeA_wire[t2_int] << t2_int);
    t2_addrA = t2_addrA | (t2_addrA_wire[t2_int] << (t2_int*BITVROW));
    t2_bwA = t2_bwA | (t2_bwA_wire[t2_int] << (t2_int*SDOUT_WIDTH));
    t2_dinA = t2_dinA | (t2_dinA_wire[t2_int] << (t2_int*SDOUT_WIDTH));
    t2_readB = t2_readB | (t2_readB_wire[t2_int] << t2_int);
    t2_addrB = t2_addrB | (t2_addrB_wire[t2_int] << (t2_int*BITVROW));
    t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2_int] << (t2_int*(BITVBNK+1)));
    t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_wire[t2_int] << t2_int);
    t2_serrB_a1 = t2_serrB_a1 | (t2_serrB_a1_wire[t2_int] << t2_int);
    t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_wire[t2_int] << (t2_int*(BITWRDS+BITSROW)));
  end
end

wire [WIDTH-1:0] t3_doutB_a1_wire [0:2-1];
wire t3_fwrdB_a1_wire [0:2-1];
wire t3_serrB_a1_wire [0:2-1];
wire t3_derrB_a1_wire [0:2-1];
wire [BITVROW-1:0] t3_padrB_a1_wire [0:2-1];
wire t3_writeA_wire [0:2-1];
wire [BITVROW-1:0] t3_addrA_wire [0:2-1];
wire [CDOUT_WIDTH-1:0] t3_bwA_wire [0:2-1];
wire [CDOUT_WIDTH-1:0] t3_dinA_wire [0:2-1];
wire t3_readB_wire [0:2-1];
wire [BITVROW-1:0] t3_addrB_wire [0:2-1];

genvar t3;
generate
  for (t3=0; t3<2; t3=t3+1) begin: t3_loop
    wire t3_writeA_a1_wire = t3_writeA_a1 >> t3;
    wire [BITVROW-1:0] t3_addrA_a1_wire = t3_addrA_a1 >> (t3*BITVROW);
    wire [WIDTH-1:0] t3_dinA_a1_wire = t3_dinA_a1 >> (t3*WIDTH);
    wire t3_readB_a1_wire = t3_readB_a1 >> t3;
    wire [BITVROW-1:0] t3_addrB_a1_wire = t3_addrB_a1 >> (t3*BITVROW);

    wire [CDOUT_WIDTH-1:0] t3_doutB_wire = t3_doutB >> (t3*CDOUT_WIDTH);

    wire mem_write_t3_wire;
    wire [BITVROW-1:0] mem_wr_adr_t3_wire;
    wire [CDOUT_WIDTH-1:0] mem_bw_t3_wire;
    wire [CDOUT_WIDTH-1:0] mem_din_t3_wire;
    wire mem_read_t3_wire;
    wire [BITVROW-1:0] mem_rd_adr_t3_wire;
    wire [CDOUT_WIDTH-1:0] mem_rd_dout_t3_wire;
    wire mem_rd_fwrd_t3_wire;
    wire mem_rd_serr_t3_wire;
    wire mem_rd_derr_t3_wire;
    wire [BITVROW-1:0] mem_rd_padr_t3_wire;

    if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (1), .ENADEC (1), .ECCWDTH (ECCWDTH),
                             .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                             .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITVROW),
                             .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .RSTZERO (1), .ENAPADR (1))
        infra (.write(t3_writeA_a1_wire), .wr_adr(t3_addrA_a1_wire), .din(t3_dinA_a1_wire),
               .read(t3_readB_a1_wire), .rd_adr(t3_addrB_a1_wire), .rd_dout(t3_doutB_a1_wire[t3]),
               .rd_fwrd(t3_fwrdB_a1_wire[t3]), .rd_serr(t3_serrB_a1_wire[t3]), .rd_derr(t3_derrB_a1_wire[t3]), .rd_padr(t3_padrB_a1_wire[t3]),
               .mem_write (mem_write_t3_wire), .mem_wr_adr(mem_wr_adr_t3_wire), .mem_bw (mem_bw_t3_wire), .mem_din (mem_din_t3_wire),
               .mem_read (mem_read_t3_wire), .mem_rd_adr(mem_rd_adr_t3_wire), .mem_rd_dout (mem_rd_dout_t3_wire),
               .mem_rd_fwrd(mem_rd_fwrd_t3_wire), .mem_rd_padr(mem_rd_padr_t3_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow));
    end
    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (CDOUT_WIDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                         .NUMWBNK (1), .BITWBNK (0), .NUMWROW (NUMVROW), .BITWROW (BITVROW),
                         .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (0), .FLOPMEM (FLOPMEM), .FLOPOUT (0), .RSTZERO (1))
        infra (.write (mem_write_t3_wire), .wr_adr (mem_wr_adr_t3_wire), .bw (mem_bw_t3_wire), .din (mem_din_t3_wire),
               .read (mem_read_t3_wire), .rd_adr (mem_rd_adr_t3_wire), .rd_dout (mem_rd_dout_t3_wire),
               .rd_fwrd (mem_rd_fwrd_t3_wire), .rd_serr (mem_rd_serr_t3_wire), .rd_derr (mem_rd_derr_t3_wire), .rd_padr (mem_rd_padr_t3_wire),
               .mem_write (t3_writeA_wire[t3]), .mem_wr_adr(t3_addrA_wire[t3]), .mem_bw (t3_bwA_wire[t3]), .mem_din (t3_dinA_wire[t3]),
               .mem_read (t3_readB_wire[t3]), .mem_rd_adr(t3_addrB_wire[t3]), .mem_rd_dout (t3_doutB_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow));
    end
  end
endgenerate

reg [2-1:0] t3_writeA;
reg [2*BITVROW-1:0] t3_addrA;
reg [2*CDOUT_WIDTH-1:0] t3_bwA;
reg [2*CDOUT_WIDTH-1:0] t3_dinA;
reg [2-1:0] t3_readB;
reg [2*BITVROW-1:0] t3_addrB;

integer t3_int;
always_comb begin
  t3_writeA = 0;
  t3_addrA = 0;
  t3_bwA = 0;
  t3_dinA = 0;
  t3_readB = 0;
  t3_addrB = 0;
  t3_doutB_a1 = 0;
  t3_fwrdB_a1 = 0;
  t3_serrB_a1 = 0;
  t3_derrB_a1 = 0;
  t3_padrB_a1 = 0;
  for (t3_int=0; t3_int<2; t3_int=t3_int+1) begin
    t3_writeA = t3_writeA | (t3_writeA_wire[t3_int] << t3_int);
    t3_addrA = t3_addrA | (t3_addrA_wire[t3_int] << (t3_int*BITVROW));
    t3_bwA = t3_bwA | (t3_bwA_wire[t3_int] << (t3_int*CDOUT_WIDTH));
    t3_dinA = t3_dinA | (t3_dinA_wire[t3_int] << (t3_int*CDOUT_WIDTH));
    t3_readB = t3_readB | (t3_readB_wire[t3_int] << t3_int);
    t3_addrB = t3_addrB | (t3_addrB_wire[t3_int] << (t3_int*BITVROW));
    t3_doutB_a1 = t3_doutB_a1 | (t3_doutB_a1_wire[t3_int] << (t3_int*WIDTH));
    t3_fwrdB_a1 = t3_fwrdB_a1 | (t3_fwrdB_a1_wire[t3_int] << t3_int);
    t3_serrB_a1 = t3_serrB_a1 | (t3_serrB_a1_wire[t3_int] << t3_int);
    t3_padrB_a1 = t3_padrB_a1 | (t3_padrB_a1_wire[t3_int] << (t3_int*(BITWRDS+BITSROW)));
  end
end

endmodule
