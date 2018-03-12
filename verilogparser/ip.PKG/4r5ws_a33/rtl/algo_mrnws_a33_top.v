module algo_mrnws_a33_top (lclk, clk, rst, rst_l, ready,
                           write, wr_adr, din,
                           read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                           whfifo_oflw, wlfifo_oflw, rhfifo_oflw, rlfifo_oflw, 
                           rdrob_uflw, faf_full, raf_full,
                           t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
                           t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                           t3_writeA, t3_addrA, t3_bwA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
                           t4_writeA, t4_addrA, t4_bwA, t4_dinA, t4_readB, t4_addrB, t4_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ENAHEC = 0;
  parameter ENAQEC = 0;
  parameter ECCWDTH = 7;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENAHEC ? WIDTH+2*ECCWDTH : ENAQEC ? WIDTH+4*ECCWDTH : WIDTH;
  parameter NUMWRPT = 2;
  parameter BITWRPT = 2;
  parameter NUMRDPT = 4;
  parameter BITRDPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 2048;
  parameter BITVROW = 10;
  parameter NUMVBNK = 4;
  parameter BITVBNK = 2;
  parameter NUMCELL = 72;
  parameter BITCELL = 7;
  parameter NUMQUEU = NUMADDR/NUMCELL;
  parameter NUMHROW = 512;
  parameter BITHROW = 9;
  parameter NUMHVRW = 128;
  parameter BITHVRW = 7;
  parameter NUMHVBK = 4;
  parameter BITHVBK = 2;
  parameter BITHPBK = 3;
  parameter BITHPDR = BITHPBK+BITHVRW;
  parameter NUMLVBK = 20;
  parameter BITLVBK = 5;
  parameter NUMLVRW = 8192;
  parameter BITLVRW = 13;
  parameter BITLPBK = 6;
  parameter ECCBITS = 4;
  parameter NUMLROW = 1536;
  parameter BITLROW = 11;
  parameter PHYWDTH = WIDTH;

  parameter SRAM_DELAY = 2;
  parameter READ_DELAY = 2;
  parameter BITRDLY = 4;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;

  parameter BITCTRL = BITRDPT+BITRDLY;
  parameter SDOUT_WIDTH = 2*(BITHVBK+1)+ECCBITS;
  parameter BITPADR = BITLROW+4;

  localparam A2FLPEC1 = 1;
  localparam A2FLPEC2 = 1;

  input [NUMWRPT-1:0]                 write;
  input [NUMWRPT*BITADDR-1:0]         wr_adr;
  input [NUMWRPT*WIDTH-1:0]           din;

  input [NUMRDPT-1:0]                 read;
  input [NUMRDPT*BITADDR-1:0]         rd_adr;
  output [NUMRDPT-1:0]                rd_vld;
  output [NUMRDPT*WIDTH-1:0]          rd_dout;
  output [NUMRDPT-1:0]                rd_serr;
  output [NUMRDPT-1:0]                rd_derr;
  output [NUMRDPT*BITPADR-1:0]        rd_padr;

  output [NUMVBNK-1:0]                whfifo_oflw;
  output [NUMVBNK-1:0]                wlfifo_oflw;
  output [NUMVBNK-1:0]                rhfifo_oflw;
  output [NUMVBNK-1:0]                rlfifo_oflw;
  output [NUMRDPT-1:0]                rdrob_uflw;
  output [NUMVBNK-1:0]                faf_full;
  output [NUMVBNK-1:0]                raf_full;

  output                              ready;
  input                               lclk, clk, rst, rst_l;

  output [NUMVBNK*NUMHVBK-1:0] t1_writeA;
  output [NUMVBNK*NUMHVBK*BITHVRW-1:0] t1_addrA;
  output [NUMVBNK*NUMHVBK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*NUMHVBK*PHYWDTH-1:0] t1_dinA;
  output [NUMVBNK*NUMHVBK-1:0] t1_readB;
  output [NUMVBNK*NUMHVBK*BITHVRW-1:0] t1_addrB; 
  input [NUMVBNK*NUMHVBK*PHYWDTH-1:0] t1_doutB;

  output [2*NUMVBNK-1:0] t2_writeA;
  output [2*NUMVBNK*BITHVRW-1:0] t2_addrA;
  output [2*NUMVBNK*PHYWDTH-1:0] t2_bwA;
  output [2*NUMVBNK*PHYWDTH-1:0] t2_dinA;
  output [2*NUMVBNK-1:0] t2_readB;
  output [2*NUMVBNK*BITHVRW-1:0] t2_addrB; 
  input [2*NUMVBNK*PHYWDTH-1:0] t2_doutB;

  output [3*NUMVBNK-1:0] t3_writeA;
  output [3*NUMVBNK*BITHVRW-1:0] t3_addrA;
  output [3*NUMVBNK*SDOUT_WIDTH-1:0] t3_bwA;
  output [3*NUMVBNK*SDOUT_WIDTH-1:0] t3_dinA;
  output [3*NUMVBNK-1:0] t3_readB;
  output [3*NUMVBNK*BITHVRW-1:0] t3_addrB; 
  input [3*NUMVBNK*SDOUT_WIDTH-1:0] t3_doutB;

  output [NUMVBNK*NUMLVBK-1:0] t4_writeA;
  output [NUMVBNK*NUMLVBK*BITLVRW-1:0] t4_addrA;
  output [NUMVBNK*NUMLVBK*PHYWDTH-1:0] t4_bwA;
  output [NUMVBNK*NUMLVBK*PHYWDTH-1:0] t4_dinA;

  output [NUMVBNK*NUMLVBK-1:0] t4_readB;
  output [NUMVBNK*NUMLVBK*BITLVRW-1:0] t4_addrB;
  input [NUMVBNK*NUMLVBK*PHYWDTH-1:0] t4_doutB;
  
  localparam LPBKHDL = SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC+A2FLPEC1+A2FLPEC2+1+1;
  localparam LPBKLDL = 3+FLOPCMD+SRAM_DELAY+FLOPMEM+1+FLOPECC+1+3; // for proving control return path - sync delay ONLY
  localparam SLOWDLA = 3*(4+FLOPCMD+SRAM_DELAY+FLOPMEM+1+FLOPECC+1);
  localparam SLOWDLB = (SLOWDLA>>1) + SLOWDLA[0];  // slow clock is 1.5x (mul by 3 and div by 2)
  localparam LPBKADL = SLOWDLB+4; // 4 is return async FIFO delay

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) ((select_addr[BITADDR-1:BITCELL] < NUMQUEU) && (select_addr[BITCELL-1:0] < NUMCELL)));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

wire [BITCELL-BITVBNK-1:0] select_vwrd = select_addr >> BITVBNK;
wire [BITADDR-BITCELL-1:0] select_vrow = select_addr >> BITCELL;
wire [BITHROW-1:0]         select_hrow = select_vrow;
wire [BITLROW-1:0]         select_lrow = NUMQUEU*(select_vwrd-1)+select_vrow;
wire [BITVBNK-1:0]         select_bnk  = select_addr[BITVBNK-1:0];
wire                       select_prio = |select_vwrd;
wire [BITHVRW-1:0]         select_hvrw;
wire [BITLVRW-1:0]         select_lvrw;
wire [BITHVBK-1:0]         select_hbnk;
wire [BITLVBK-1:0]         select_lbnk;
np2_addr #(
  .NUMADDR (NUMHROW), .BITADDR (BITHROW),
  .NUMVBNK (NUMHVBK), .BITVBNK (BITHVBK),
  .NUMVROW (NUMHVRW), .BITVROW (BITHVRW))
  hvrw_inst (.vbadr(select_hbnk), .vradr(select_hvrw), .vaddr(select_hrow));
np2_addr #(
  .NUMADDR (NUMLVBK*(1<<BITLVRW)), .BITADDR (BITLVBK+BITLVRW),
  .NUMVBNK (NUMLVBK), .BITVBNK (BITLVBK),
  .NUMVROW (NUMLVRW), .BITVROW (BITLVRW))
  lvrw_inst (.vbadr(select_lbnk), .vradr(select_lvrw), .vaddr(select_lrow));
`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITCELL-BITVBNK-1:0] select_vwrd = 0;
wire [BITADDR-BITCELL-1:0] select_vrow = 0;
wire [BITHROW-1:0] select_hrow = 0;
wire [BITLROW-1:0] select_lrow = 0;
wire [BITVBNK-1:0] select_bnk = 0;
wire select_prio = 0; 
wire [BITHVRW-1:0] select_hvrw = 0;
wire [BITLVRW-1:0] select_lvrw = 0;
`endif

wire [NUMVBNK-1:0] t1_writeA_a1;
wire [NUMVBNK*BITHROW-1:0] t1_addrA_a1;
wire [NUMVBNK*WIDTH-1:0] t1_dinA_a1;
wire [NUMVBNK-1:0] t1_writeB_a1;
wire [NUMVBNK*BITHROW-1:0] t1_addrB_a1;
wire [NUMVBNK*WIDTH-1:0] t1_dinB_a1;
wire [NUMVBNK-1:0] t1_readC_a1;
wire [NUMVBNK*BITHROW-1:0] t1_addrC_a1;
wire [NUMVBNK*BITCTRL-1:0] t1_cinC_a1;
wire [WIDTH-1:0] t1_doutC_a1_wire [0:NUMVBNK-1];
wire t1_fwrdC_a1_wire [0:NUMVBNK-1];
wire t1_serrC_a1_wire [0:NUMVBNK-1];
wire t1_derrC_a1_wire [0:NUMVBNK-1];
wire [BITHPBK+BITHVRW-1:0] t1_padrC_a1_wire [0:NUMVBNK-1];
wire t1_vldC_a1_wire [0:NUMVBNK-1];
wire [BITCTRL-1:0] t1_coutC_a1_wire [0:NUMVBNK-1];

wire [NUMVBNK-1:0] t2_writeA_a1;
wire [NUMVBNK*BITLROW-1:0] t2_addrA_a1;
wire [NUMVBNK*WIDTH-1:0] t2_dinA_a1;
wire [NUMVBNK-1:0] t2_readB_a1;
wire [NUMVBNK*BITLROW-1:0] t2_addrB_a1;
wire [NUMVBNK*BITCTRL-1:0] t2_cinB_a1;
wire [WIDTH-1:0] t2_doutB_a1_wire [0:NUMVBNK-1];
wire t2_fwrdB_a1_wire [0:NUMVBNK-1];
wire t2_serrB_a1_wire [0:NUMVBNK-1];
wire t2_derrB_a1_wire [0:NUMVBNK-1];
wire [BITLROW-1:0] t2_padrB_a1_wire [0:NUMVBNK-1];
wire t2_vldB_a1_wire [0:NUMVBNK-1];
wire [BITCTRL-1:0] t2_coutB_a1_wire [0:NUMVBNK-1];
reg [WIDTH-1:0] t2_doutB_a1_reg [0:NUMVBNK-1];
reg t2_fwrdB_a1_reg [0:NUMVBNK-1];
reg t2_serrB_a1_reg [0:NUMVBNK-1];
reg t2_derrB_a1_reg [0:NUMVBNK-1];
reg [BITLROW-1:0] t2_padrB_a1_reg [0:NUMVBNK-1];
reg t2_vldB_a1_reg [0:NUMVBNK-1];
reg [BITCTRL-1:0] t2_coutB_a1_reg [0:NUMVBNK-1];

wire [NUMVBNK-1:0] a2_ready;

generate if (1) begin: a1_loop

  reg [NUMVBNK*WIDTH-1:0] t1_doutC_a1;
  reg [NUMVBNK-1:0] t1_fwrdC_a1;
  reg [NUMVBNK-1:0] t1_serrC_a1;
  reg [NUMVBNK-1:0] t1_derrC_a1;
  reg [NUMVBNK*BITHPDR-1:0] t1_padrC_a1;
  reg [NUMVBNK-1:0] t1_vldC_a1;
  reg [NUMVBNK*BITCTRL-1:0] t1_coutC_a1;
  reg [NUMVBNK*WIDTH-1:0] t2_doutB_a1;
  reg [NUMVBNK-1:0] t2_fwrdB_a1;
  reg [NUMVBNK-1:0] t2_serrB_a1;
  reg [NUMVBNK-1:0] t2_derrB_a1;
  reg [NUMVBNK*BITLROW-1:0] t2_padrB_a1;
  reg [NUMVBNK-1:0] t2_vldB_a1;
  reg [NUMVBNK*BITCTRL-1:0] t2_coutB_a1;
  integer t_int;
  always_comb begin
    t1_doutC_a1 = 0;
    t1_fwrdC_a1 = 0;
    t1_serrC_a1 = 0;
    t1_derrC_a1 = 0;
    t1_padrC_a1 = 0;
    t1_vldC_a1 = 0;

    t1_coutC_a1 = 0;
    for (t_int=0; t_int<NUMVBNK; t_int=t_int+1) begin
      t1_doutC_a1 = t1_doutC_a1 | (t1_doutC_a1_wire[t_int] << (t_int*WIDTH));
      t1_fwrdC_a1 = t1_fwrdC_a1 | (t1_fwrdC_a1_wire[t_int] << t_int);
      t1_serrC_a1 = t1_serrC_a1 | (t1_serrC_a1_wire[t_int] << t_int);
      t1_derrC_a1 = t1_derrC_a1 | (t1_derrC_a1_wire[t_int] << t_int);
      t1_padrC_a1 = t1_padrC_a1 | (t1_padrC_a1_wire[t_int] << (t_int*BITHPDR));
      t1_vldC_a1 = t1_vldC_a1 | (t1_vldC_a1_wire[t_int] << t_int);
      t1_coutC_a1 = t1_coutC_a1 | (t1_coutC_a1_wire[t_int] << (t_int*BITCTRL));
    end
    t2_doutB_a1 = 0;
    t2_fwrdB_a1 = 0;
    t2_serrB_a1 = 0;
    t2_derrB_a1 = 0;
    t2_padrB_a1 = 0;
    t2_vldB_a1 = 0;
    t2_coutB_a1 = 0;
    for (t_int=0; t_int<NUMVBNK; t_int=t_int+1) begin
      t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_reg[t_int] << (t_int*WIDTH));
      t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_reg[t_int] << t_int);
      t2_serrB_a1 = t2_serrB_a1 | (t2_serrB_a1_reg[t_int] << t_int);
      t2_derrB_a1 = t2_derrB_a1 | (t2_derrB_a1_reg[t_int] << t_int);
      t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_reg[t_int] << (t_int*BITLROW));
      t2_vldB_a1 = t2_vldB_a1   | (t2_vldB_a1_reg[t_int]  << t_int);
      t2_coutB_a1 = t2_coutB_a1 | (t2_coutB_a1_reg[t_int] << (t_int*BITCTRL));
    end
  end

  algo_mrnws_a33 #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMRDPT (NUMRDPT), .BITRDPT (BITRDPT), .NUMWRPT (NUMWRPT), .BITWRPT (BITWRPT),
                   .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMCELL (NUMCELL), .BITCELL (BITCELL), .NUMQUEU(NUMQUEU),
                   .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR-1), .BITHPDR(BITHPDR),
                   .NUMHROW (NUMHROW), .BITHROW (BITHROW), .NUMLROW (NUMLROW), .BITLROW (BITLROW), .BITHVRW (BITHVRW),
                   .READ_DELAY (READ_DELAY), .BITRDLY (BITRDLY), .FLOPIN(FLOPIN), .FLOPOUT(FLOPOUT),
                   .LPBKHDL (LPBKHDL), .LPBKLDL (LPBKLDL), .LPBKADL(LPBKADL)
                  )
    algo (.clk(clk), .rst(rst || !(|a2_ready)), .ready(ready),
          .write(write), .wr_adr(wr_adr), .din(din),
          .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), 
          .rd_fwrd({rd_padr[4*BITPADR-1],rd_padr[3*BITPADR-1],rd_padr[2*BITPADR-1],rd_padr[BITPADR-1]}), .rd_serr(rd_serr), .rd_derr(rd_derr),
          .rd_padr({rd_padr[4*BITPADR-2:3*BITPADR],rd_padr[3*BITPADR-2:2*BITPADR],rd_padr[2*BITPADR-2:BITPADR],rd_padr[BITPADR-2:0]}),
          .whfifo_oflw(whfifo_oflw), .wlfifo_oflw(wlfifo_oflw), .rhfifo_oflw(rhfifo_oflw), .rlfifo_oflw(rlfifo_oflw), .rdrob_uflw(rdrob_uflw),
          .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_writeB(t1_writeB_a1), .t1_addrB(t1_addrB_a1), .t1_dinB(t1_dinB_a1),
          .t1_readC(t1_readC_a1), .t1_addrC(t1_addrC_a1), .t1_doutC(t1_doutC_a1),
          .t1_fwrdC(t1_fwrdC_a1), .t1_serrC(t1_serrC_a1), .t1_derrC(t1_derrC_a1), .t1_padrC(t1_padrC_a1),
          .t1_cinC(t1_cinC_a1), .t1_vldC(t1_vldC_a1), .t1_coutC(t1_coutC_a1),
          .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1),
          .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1), .t2_doutB(t2_doutB_a1),
          .t2_fwrdB(t2_fwrdB_a1), .t2_serrB(t2_serrB_a1), .t2_derrB(t2_derrB_a1), .t2_padrB(t2_padrB_a1),
          .t2_cinB(t2_cinB_a1), .t2_vldB(t2_vldB_a1), .t2_coutB(t2_coutB_a1),
          .select_addr(select_addr), .select_bit(select_bit), .select_bnk(select_bnk), .select_prio(select_prio), .select_vwrd(select_vwrd), 
          .select_vrow(select_vrow), .select_hrow(select_hrow), .select_hvrw(select_hvrw), .select_lrow(select_lrow));

end
endgenerate

wire [NUMHVBK-1:0] t1_writeA_a2 [0:NUMVBNK-1];
wire [NUMHVBK*BITHVRW-1:0] t1_addrA_a2 [0:NUMVBNK-1];
wire [NUMHVBK*MEMWDTH-1:0] t1_dinA_a2 [0:NUMVBNK-1];
wire [NUMHVBK-1:0] t1_readB_a2 [0:NUMVBNK-1];
wire [NUMHVBK*BITHVRW-1:0] t1_addrB_a2 [0:NUMVBNK-1];
wire [MEMWDTH-1:0] t1_doutB_a2_wire [0:NUMVBNK-1][0:NUMHVBK-1];
wire t1_fwrdB_a2_wire [0:NUMVBNK-1][0:NUMHVBK-1];
wire t1_serrB_a2_wire [0:NUMVBNK-1][0:NUMHVBK-1];
wire t1_derrB_a2_wire [0:NUMVBNK-1][0:NUMHVBK-1];
wire [BITHVRW-1:0] t1_padrB_a2_wire [0:NUMVBNK-1][0:NUMHVBK-1];

wire [2-1:0] t2_writeA_a2 [0:NUMVBNK-1];
wire [2*BITHVRW-1:0] t2_addrA_a2 [0:NUMVBNK-1];
wire [2*MEMWDTH-1:0] t2_dinA_a2 [0:NUMVBNK-1];
wire [2-1:0] t2_readB_a2 [0:NUMVBNK-1];
wire [2*BITHVRW-1:0] t2_addrB_a2 [0:NUMVBNK-1];
wire [MEMWDTH-1:0] t2_doutB_a2_wire [0:NUMVBNK-1][0:2-1];
wire t2_fwrdB_a2_wire [0:NUMVBNK-1][0:2-1];
wire t2_serrB_a2_wire [0:NUMVBNK-1][0:2-1];
wire t2_derrB_a2_wire [0:NUMVBNK-1][0:2-1];
wire [BITHVRW-1:0] t2_padrB_a2_wire [0:NUMVBNK-1][0:2-1];

wire [3-1:0] t3_writeA_a2 [0:NUMVBNK-1];
wire [3*BITHVRW-1:0] t3_addrA_a2 [0:NUMVBNK-1];
wire [3*(BITHVBK+1)-1:0] t3_dinA_a2 [0:NUMVBNK-1];
wire [3-1:0] t3_readB_a2 [0:NUMVBNK-1];
wire [3*BITHVRW-1:0] t3_addrB_a2 [0:NUMVBNK-1];
wire [(BITHVBK+1)-1:0] t3_doutB_a2_wire [0:NUMVBNK-1][0:3-1];
wire t3_fwrdB_a2_wire [0:NUMVBNK-1][0:3-1];
wire t3_serrB_a2_wire [0:NUMVBNK-1][0:3-1];
wire t3_derrB_a2_wire [0:NUMVBNK-1][0:3-1];
wire [BITHVRW-1:0] t3_padrB_a2_wire [0:NUMVBNK-1][0:3-1];

genvar a2_var;
generate for (a2_var=0; a2_var<NUMVBNK; a2_var=a2_var+1) begin: a2_loop

  wire t1_writeA_a1_wire = t1_writeA_a1 >> a2_var;
  wire [BITHROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (a2_var*BITHROW);
  wire [WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (a2_var*WIDTH);
  wire t1_writeB_a1_wire = t1_writeB_a1 >> a2_var;
  wire [BITHROW-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> (a2_var*BITHROW);
  wire [WIDTH-1:0] t1_dinB_a1_wire = t1_dinB_a1 >> (a2_var*WIDTH);
  wire t1_readC_a1_wire = t1_readC_a1 >> a2_var;
  wire [BITHROW-1:0] t1_addrC_a1_wire = t1_addrC_a1 >> (a2_var*BITHROW);
  wire [BITCTRL-1:0] t1_cinC_a1_wire = t1_cinC_a1 >> (a2_var*BITCTRL);

  reg t1_vldC_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC+A2FLPEC1+A2FLPEC2+1];
  reg [BITCTRL-1:0] t1_coutC_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC+A2FLPEC1+A2FLPEC2+1];
  integer cout_int;
  always @(posedge clk)
    for (cout_int=0; cout_int<SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC+A2FLPEC1+A2FLPEC2+1+1; cout_int=cout_int+1)
      if (cout_int>0) begin
        t1_vldC_reg[cout_int] <= t1_vldC_reg[cout_int-1];
        t1_coutC_reg[cout_int] <= t1_coutC_reg[cout_int-1];
      end else begin
        t1_vldC_reg[cout_int] <= t1_readC_a1_wire;
        t1_coutC_reg[cout_int] <= t1_cinC_a1_wire;
      end

  assign t1_vldC_a1_wire[a2_var] = t1_vldC_reg[SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC+A2FLPEC1+A2FLPEC2+1];
  assign t1_coutC_a1_wire[a2_var] = t1_coutC_reg[SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC+A2FLPEC1+A2FLPEC2+1];

  reg [NUMHVBK*MEMWDTH-1:0] t1_doutB_a2;
  reg [NUMHVBK-1:0] t1_fwrdB_a2;
  reg [NUMHVBK-1:0] t1_serrB_a2;
  reg [NUMHVBK-1:0] t1_derrB_a2;
  reg [NUMHVBK*BITHVRW-1:0] t1_padrB_a2;
  reg [2*MEMWDTH-1:0] t2_doutB_a2;
  reg [2-1:0] t2_fwrdB_a2;
  reg [2-1:0] t2_serrB_a2;
  reg [2-1:0] t2_derrB_a2;
  reg [2*BITHVRW-1:0] t2_padrB_a2;
  reg [3*(BITHVBK+1)-1:0] t3_doutB_a2;
  reg [3-1:0] t3_fwrdB_a2;
  reg [3-1:0] t3_serrB_a2;
  reg [3-1:0] t3_derrB_a2;
  reg [3*BITHVRW-1:0] t3_padrB_a2;
  integer t_int;
  always_comb begin
    t1_doutB_a2 = 0;
    t1_fwrdB_a2 = 0;
    t1_serrB_a2 = 0;
    t1_derrB_a2 = 0;
    t1_padrB_a2 = 0;
    for (t_int=0; t_int<NUMHVBK; t_int=t_int+1) begin
      t1_doutB_a2 = t1_doutB_a2 | (t1_doutB_a2_wire[a2_var][t_int] << (t_int*MEMWDTH));
      t1_fwrdB_a2 = t1_fwrdB_a2 | (t1_fwrdB_a2_wire[a2_var][t_int] << t_int);
      t1_serrB_a2 = t1_serrB_a2 | (t1_serrB_a2_wire[a2_var][t_int] << t_int);
      t1_derrB_a2 = t1_derrB_a2 | (t1_derrB_a2_wire[a2_var][t_int] << t_int);
      t1_padrB_a2 = t1_padrB_a2 | (t1_padrB_a2_wire[a2_var][t_int] << (t_int*BITHVRW));
    end
    t2_doutB_a2 = 0;
    t2_fwrdB_a2 = 0;
    t2_serrB_a2 = 0;
    t2_derrB_a2 = 0;
    t2_padrB_a2 = 0;
    for (t_int=0; t_int<2; t_int=t_int+1) begin
      t2_doutB_a2 = t2_doutB_a2 | (t2_doutB_a2_wire[a2_var][t_int] << (t_int*MEMWDTH));
      t2_fwrdB_a2 = t2_fwrdB_a2 | (t2_fwrdB_a2_wire[a2_var][t_int] << t_int);
      t2_serrB_a2 = t2_serrB_a2 | (t2_serrB_a2_wire[a2_var][t_int] << t_int);
      t2_derrB_a2 = t2_derrB_a2 | (t2_derrB_a2_wire[a2_var][t_int] << t_int);
      t2_padrB_a2 = t2_padrB_a2 | (t2_padrB_a2_wire[a2_var][t_int] << (t_int*BITHVRW));
    end
    t3_doutB_a2 = 0;
    t3_fwrdB_a2 = 0;
    t3_serrB_a2 = 0;
    t3_derrB_a2 = 0;
    t3_padrB_a2 = 0;
    for (t_int=0; t_int<3; t_int=t_int+1) begin
      t3_doutB_a2 = t3_doutB_a2 | (t3_doutB_a2_wire[a2_var][t_int] << (t_int*(BITVBNK+1)));
      t3_fwrdB_a2 = t3_fwrdB_a2 | (t3_fwrdB_a2_wire[a2_var][t_int] << t_int);
      t3_serrB_a2 = t3_serrB_a2 | (t3_serrB_a2_wire[a2_var][t_int] << t_int);
      t3_derrB_a2 = t3_derrB_a2 | (t3_derrB_a2_wire[a2_var][t_int] << t_int);
      t3_padrB_a2 = t3_padrB_a2 | (t3_padrB_a2_wire[a2_var][t_int] << (t_int*BITHVRW));
    end
  end

  algo_nr2w_ecc_1r1w #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .ENAPSDO (0), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ENAQEC(ENAQEC), .ENAHEC(ENAHEC),
                   .FLOPECC1(A2FLPEC1), .FLOPECC2(A2FLPEC2), .ECCWDTH(ECCWDTH), .NUMRDPT (1),
                   .NUMADDR (NUMHROW), .BITADDR (BITHROW),
                   .NUMVROW (NUMHVRW), .BITVROW (BITHVRW), .NUMVBNK (NUMHVBK), .BITVBNK (BITHVBK), .BITPBNK (BITHPBK), .BITPADR (BITHPBK+BITHVRW),
                   .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM+1), .FLOPIN(0), .FLOPOUT(1))
    algo (.clk(clk), .rst(rst), .ready(a2_ready[a2_var]),
          .write({t1_writeB_a1_wire,t1_writeA_a1_wire}), .wr_adr({t1_addrB_a1_wire,t1_addrA_a1_wire}), .din({t1_dinB_a1_wire,t1_dinA_a1_wire}),
          .read(t1_readC_a1_wire), .rd_adr(t1_addrC_a1_wire), .rd_vld(), .rd_dout(t1_doutC_a1_wire[a2_var]),
          .rd_fwrd(t1_fwrdC_a1_wire[a2_var]), .rd_serr(t1_serrC_a1_wire[a2_var]), .rd_derr(t1_derrC_a1_wire[a2_var]), .rd_padr(t1_padrC_a1_wire[a2_var]),
          .t1_writeA(t1_writeA_a2[a2_var]), .t1_addrA(t1_addrA_a2[a2_var]), .t1_dinA(t1_dinA_a2[a2_var]),
          .t1_readB(t1_readB_a2[a2_var]), .t1_addrB(t1_addrB_a2[a2_var]), .t1_doutB(t1_doutB_a2),
          .t1_fwrdB(t1_fwrdB_a2), .t1_serrB(t1_serrB_a2), .t1_derrB(t1_derrB_a2), .t1_padrB(t1_padrB_a2),
          .t2_writeA(t2_writeA_a2[a2_var]), .t2_addrA(t2_addrA_a2[a2_var]), .t2_dinA(t2_dinA_a2[a2_var]),
          .t2_readB(t2_readB_a2[a2_var]), .t2_addrB(t2_addrB_a2[a2_var]), .t2_doutB(t2_doutB_a2),
          .t2_fwrdB(t2_fwrdB_a2), .t2_serrB(t2_serrB_a2), .t2_derrB(t2_derrB_a2), .t2_padrB(t2_padrB_a2),
          .t3_writeA(t3_writeA_a2[a2_var]), .t3_addrA(t3_addrA_a2[a2_var]), .t3_dinA(t3_dinA_a2[a2_var]),
          .t3_readB(t3_readB_a2[a2_var]), .t3_addrB(t3_addrB_a2[a2_var]), .t3_doutB(t3_doutB_a2),
          .t3_fwrdB(t3_fwrdB_a2), .t3_serrB(t3_serrB_a2), .t3_derrB(t3_derrB_a2), .t3_padrB(t3_padrB_a2),
          .select_addr(select_hrow), .select_bit(select_bit));

end
endgenerate

wire               t1_writeA_wire [0:NUMVBNK-1][0:NUMHVBK-1];
wire [BITHVRW-1:0] t1_addrA_wire  [0:NUMVBNK-1][0:NUMHVBK-1];
wire [MEMWDTH-1:0] t1_bwA_wire    [0:NUMVBNK-1][0:NUMHVBK-1];
wire [MEMWDTH-1:0] t1_dinA_wire   [0:NUMVBNK-1][0:NUMHVBK-1];
wire               t1_readB_wire  [0:NUMVBNK-1][0:NUMHVBK-1];
wire [BITHVRW-1:0] t1_addrB_wire  [0:NUMVBNK-1][0:NUMHVBK-1];

genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMVBNK; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMHVBK; t1b=t1b+1) begin: t1b_loop
      wire t1_writeA_a2_wire = t1_writeA_a2[t1r] >> t1b;
      wire [BITHVRW-1:0] t1_addrA_a2_wire = t1_addrA_a2[t1r] >> (t1b*BITHVRW);
      wire [MEMWDTH-1:0] t1_dinA_a2_wire = t1_dinA_a2[t1r] >> (t1b*MEMWDTH);
      wire t1_readB_a2_wire = t1_readB_a2[t1r] >> t1b;
      wire [BITHVRW-1:0] t1_addrB_a2_wire = t1_addrB_a2[t1r] >> (t1b*BITHVRW);

      wire [MEMWDTH-1:0] t1_doutB_wire = t1_doutB >> ((t1r*NUMHVBK+t1b)*PHYWDTH);

      wire mem_write_wire;
      wire [BITHVRW-1:0] mem_wr_adr_wire;
      wire [MEMWDTH-1:0] mem_bw_wire;
      wire [MEMWDTH-1:0] mem_din_wire;
      wire mem_read_wire;
      wire [BITHVRW-1:0] mem_rd_adr_wire;
      wire [MEMWDTH-1:0] mem_rd_dout_wire;
      wire mem_rd_fwrd_wire;
      wire mem_rd_serr_wire;
      wire mem_rd_derr_wire;
      wire [BITHVRW-1:0] mem_rd_padr_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH(MEMWDTH), .ENAPSDO(1), .ENAPAR(0), .ENAECC(0), .ENAHEC(0), .ENAQEC(0), .ECCWDTH(0),
                               .ENAPADR(1),
                               .NUMADDR (NUMHVRW), .BITADDR (BITHVRW),
                               .NUMSROW (NUMHVRW), .BITSROW (BITHVRW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITHVRW),
                               .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (1), .FLOPECC1(0), .FLOPECC2(0))
          infra (.write(t1_writeA_a2_wire), .wr_adr(t1_addrA_a2_wire), .din(t1_dinA_a2_wire),
                 .read(t1_readB_a2_wire), .rd_adr(t1_addrB_a2_wire),
                 .rd_dout(t1_doutB_a2_wire[t1r][t1b]), .rd_fwrd(t1_fwrdB_a2_wire[t1r][t1b]),
                 .rd_serr(t1_serrB_a2_wire[t1r][t1b]), .rd_derr(t1_derrB_a2_wire[t1r][t1b]), .rd_padr(t1_padrB_a2_wire[t1r][t1b]),
                 .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
                 .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_hvrw));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (MEMWDTH), .ENAPSDO (0), .NUMADDR (NUMHVRW), .BITADDR (BITHVRW),
                           .NUMWROW (NUMHVRW), .BITWROW (BITHVRW), .NUMWBNK (1), .BITWBNK (0),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
          infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
                 .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
                 .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
                 .mem_write (t1_writeA_wire[t1r][t1b]), .mem_wr_adr(t1_addrA_wire[t1r][t1b]),
                 .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]),
                 .mem_read (t1_readB_wire[t1r][t1b]), .mem_rd_adr(t1_addrB_wire[t1r][t1b]), .mem_rd_dout (t1_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_hvrw));
      end
    end
  end
endgenerate

reg [NUMVBNK*NUMHVBK-1:0] t1_writeA;
reg [NUMVBNK*NUMHVBK*BITHVRW-1:0] t1_addrA;
reg [NUMVBNK*NUMHVBK*PHYWDTH-1:0] t1_bwA;
reg [NUMVBNK*NUMHVBK*PHYWDTH-1:0] t1_dinA;
reg [NUMVBNK*NUMHVBK-1:0] t1_readB;
reg [NUMVBNK*NUMHVBK*BITHVRW-1:0] t1_addrB;
integer t1r_int, t1b_int;
always_comb begin
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_readB = 0;
  t1_addrB = 0;
  for (t1r_int=0; t1r_int<NUMVBNK; t1r_int=t1r_int+1) begin
    for (t1b_int=0; t1b_int<NUMHVBK; t1b_int=t1b_int+1) begin
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << (t1r_int*NUMHVBK+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*NUMHVBK+t1b_int)*BITHVRW));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*NUMHVBK+t1b_int)*PHYWDTH));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*NUMHVBK+t1b_int)*PHYWDTH));
      t1_readB = t1_readB | (t1_readB_wire[t1r_int][t1b_int] << (t1r_int*NUMHVBK+t1b_int));
      t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int][t1b_int] << ((t1r_int*NUMHVBK+t1b_int)*BITHVRW));
    end
  end
end

wire t2_writeA_wire [0:NUMVBNK-1][0:2-1];
wire [BITHVRW-1:0] t2_addrA_wire [0:NUMVBNK-1][0:2-1];
wire [MEMWDTH-1:0] t2_bwA_wire [0:NUMVBNK-1][0:2-1];
wire [MEMWDTH-1:0] t2_dinA_wire [0:NUMVBNK-1][0:2-1];
wire t2_readB_wire [0:NUMVBNK-1][0:2-1];
wire [BITHVRW-1:0] t2_addrB_wire [0:NUMVBNK-1][0:2-1];

genvar t2r, t2b;
generate
  for (t2r=0; t2r<NUMVBNK; t2r=t2r+1) begin: t2r_loop
    for (t2b=0; t2b<2; t2b=t2b+1) begin: t2b_loop
      wire t2_writeA_a2_wire = t2_writeA_a2[t2r] >> t2b;
      wire [BITHVRW-1:0] t2_addrA_a2_wire = t2_addrA_a2[t2r] >> (t2b*BITHVRW);
      wire [MEMWDTH-1:0] t2_dinA_a2_wire = t2_dinA_a2[t2r] >> (t2b*MEMWDTH);
      wire t2_readB_a2_wire = t2_readB_a2[t2r] >> t2b;
      wire [BITHVRW-1:0] t2_addrB_a2_wire = t2_addrB_a2[t2r] >> (t2b*BITHVRW);

      wire [MEMWDTH-1:0] t2_doutB_wire = t2_doutB >> ((t2r*2+t2b)*PHYWDTH);

      wire mem_write_wire;
      wire [BITHVRW-1:0] mem_wr_adr_wire;
      wire [MEMWDTH-1:0] mem_bw_wire;
      wire [MEMWDTH-1:0] mem_din_wire;
      wire mem_read_wire;
      wire [BITHVRW-1:0] mem_rd_adr_wire;
      wire [MEMWDTH-1:0] mem_rd_dout_wire;
      wire mem_rd_fwrd_wire;
      wire mem_rd_serr_wire;
      wire mem_rd_derr_wire;
      wire [BITHVRW-1:0] mem_rd_padr_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH(MEMWDTH), .ENAPSDO(1), .ENAPAR(0), .ENAECC(0), .ENAHEC(0), .ENAQEC(0), .ECCWDTH(ECCWDTH),
                               .ENAPADR(1),
                               .NUMADDR (NUMHVRW), .BITADDR (BITHVRW),
                               .NUMSROW (NUMHVRW), .BITSROW (BITHVRW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITHVRW),
                               .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (1), .RSTZERO(1), .FLOPECC1(0), .FLOPECC2(0)) 
          infra (.write(t2_writeA_a2_wire), .wr_adr(t2_addrA_a2_wire), .din(t2_dinA_a2_wire),
                 .read(t2_readB_a2_wire), .rd_adr(t2_addrB_a2_wire),
                 .rd_dout(t2_doutB_a2_wire[t2r][t2b]), .rd_fwrd(t2_fwrdB_a2_wire[t2r][t2b]),
                 .rd_serr(t2_serrB_a2_wire[t2r][t2b]), .rd_derr(t2_derrB_a2_wire[t2r][t2b]), .rd_padr(t2_padrB_a2_wire[t2r][t2b]),
                 .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
                 .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_hvrw));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (MEMWDTH), .ENAPSDO (0), .NUMADDR (NUMHVRW), .BITADDR (BITHVRW),
                           .NUMWROW (NUMHVRW), .BITWROW (BITHVRW), .NUMWBNK (1), .BITWBNK (0),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
          infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
                 .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
                 .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
                 .mem_write (t2_writeA_wire[t2r][t2b]), .mem_wr_adr(t2_addrA_wire[t2r][t2b]),
                 .mem_bw (t2_bwA_wire[t2r][t2b]), .mem_din (t2_dinA_wire[t2r][t2b]),
                 .mem_read (t2_readB_wire[t2r][t2b]), .mem_rd_adr(t2_addrB_wire[t2r][t2b]), .mem_rd_dout (t2_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_hvrw));
      end
    end
  end
endgenerate

reg [2*NUMVBNK-1:0] t2_writeA;
reg [2*NUMVBNK*BITHVRW-1:0] t2_addrA;
reg [2*NUMVBNK*PHYWDTH-1:0] t2_bwA;
reg [2*NUMVBNK*PHYWDTH-1:0] t2_dinA;
reg [2*NUMVBNK-1:0] t2_readB;
reg [2*NUMVBNK*BITHVRW-1:0] t2_addrB;
integer t2r_int, t2b_int;
always_comb begin
  t2_writeA = 0;
  t2_addrA = 0;
  t2_bwA = 0;
  t2_dinA = 0;
  t2_readB = 0;
  t2_addrB = 0;
  for (t2r_int=0; t2r_int<NUMVBNK; t2r_int=t2r_int+1) begin
    for (t2b_int=0; t2b_int<2; t2b_int=t2b_int+1) begin
      t2_writeA = t2_writeA | (t2_writeA_wire[t2r_int][t2b_int] << (t2r_int*2+t2b_int));
      t2_addrA = t2_addrA | (t2_addrA_wire[t2r_int][t2b_int] << ((t2r_int*2+t2b_int)*BITHVRW));
      t2_bwA = t2_bwA | (t2_bwA_wire[t2r_int][t2b_int] << ((t2r_int*2+t2b_int)*PHYWDTH));
      t2_dinA = t2_dinA | (t2_dinA_wire[t2r_int][t2b_int] << ((t2r_int*2+t2b_int)*PHYWDTH));
      t2_readB = t2_readB | (t2_readB_wire[t2r_int][t2b_int] << (t2r_int*2+t2b_int));
      t2_addrB = t2_addrB | (t2_addrB_wire[t2r_int][t2b_int] << ((t2r_int*2+t2b_int)*BITHVRW));
    end
  end
end

wire t3_writeA_wire [0:NUMVBNK-1][0:3-1];
wire [BITHVRW-1:0] t3_addrA_wire [0:NUMVBNK-1][0:3-1];
wire [SDOUT_WIDTH-1:0] t3_bwA_wire [0:NUMVBNK-1][0:3-1];
wire [SDOUT_WIDTH-1:0] t3_dinA_wire [0:NUMVBNK-1][0:3-1];
wire t3_readB_wire [0:NUMVBNK-1][0:3-1];
wire [BITHVRW-1:0] t3_addrB_wire [0:NUMVBNK-1][0:3-1];

genvar t3r, t3b;
generate
  for (t3r=0; t3r<NUMVBNK; t3r=t3r+1) begin: t3r_loop
    for (t3b=0; t3b<3; t3b=t3b+1) begin: t3b_loop
      wire t3_writeA_a2_wire = t3_writeA_a2[t3r] >> t3b;
      wire [BITHVRW-1:0] t3_addrA_a2_wire = t3_addrA_a2[t3r] >> (t3b*BITHVRW);
      wire [(BITHVBK+1)-1:0] t3_dinA_a2_wire = t3_dinA_a2[t3r] >> (t3b*(BITHVBK+1));
      wire t3_readB_a2_wire = t3_readB_a2[t3r] >> t3b;
      wire [BITHVRW-1:0] t3_addrB_a2_wire = t3_addrB_a2[t3r] >> (t3b*BITHVRW);

      wire [SDOUT_WIDTH-1:0] t3_doutB_wire = t3_doutB >> ((t3r*3+t3b)*SDOUT_WIDTH);

      wire mem_write_wire;
      wire [BITHVRW-1:0] mem_wr_adr_wire;
      wire [SDOUT_WIDTH-1:0] mem_bw_wire;
      wire [SDOUT_WIDTH-1:0] mem_din_wire;
      wire mem_read_wire;
      wire [BITHVRW-1:0] mem_rd_adr_wire;
      wire [SDOUT_WIDTH-1:0] mem_rd_dout_wire;
      wire mem_rd_fwrd_wire;
      wire mem_rd_serr_wire;
      wire mem_rd_derr_wire;
      wire [BITHVRW-1:0] mem_rd_padr_wire;

      if (1) begin: align_loop
        infra_align_ecc_1r1w #(.WIDTH (BITHVBK+1), .ENAPSDO (1), .ENAPAR (0), .ENAECC (0), .ENADEC (1), .ECCWDTH (ECCBITS), .ENAPADR (1),
                               .NUMADDR (NUMHVRW), .BITADDR (BITHVRW),
                               .NUMSROW (NUMHVRW), .BITSROW (BITHVRW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITHVRW),
                               .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (1), .RSTZERO(1), .FLOPECC1(0), .FLOPECC2(0))
          infra (.write(t3_writeA_a2_wire), .wr_adr(t3_addrA_a2_wire), .din(t3_dinA_a2_wire),
                 .read(t3_readB_a2_wire), .rd_adr(t3_addrB_a2_wire),
                 .rd_dout(t3_doutB_a2_wire[t3r][t3b]), .rd_fwrd(t3_fwrdB_a2_wire[t3r][t3b]),
                 .rd_serr(t3_serrB_a2_wire[t3r][t3b]), .rd_derr(t3_derrB_a2_wire[t3r][t3b]), .rd_padr(t3_padrB_a2_wire[t3r][t3b]),
                 .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
                 .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_hvrw));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (SDOUT_WIDTH), .ENAPSDO (0), .NUMADDR (NUMHVRW), .BITADDR (BITHVRW),
                           .NUMWROW (NUMHVRW), .BITWROW (BITHVRW), .NUMWBNK (1), .BITWBNK (0),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
          infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
                 .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
                 .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
                 .mem_write (t3_writeA_wire[t3r][t3b]), .mem_wr_adr(t3_addrA_wire[t3r][t3b]),
                 .mem_bw (t3_bwA_wire[t3r][t3b]), .mem_din (t3_dinA_wire[t3r][t3b]),
                 .mem_read (t3_readB_wire[t3r][t3b]), .mem_rd_adr(t3_addrB_wire[t3r][t3b]), .mem_rd_dout (t3_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr (select_hvrw));
      end
    end
  end
endgenerate

reg [3*NUMVBNK-1:0] t3_writeA;
reg [3*NUMVBNK*BITHVRW-1:0] t3_addrA;
reg [3*NUMVBNK*SDOUT_WIDTH-1:0] t3_bwA;
reg [3*NUMVBNK*SDOUT_WIDTH-1:0] t3_dinA;
reg [3*NUMVBNK-1:0] t3_readB;
reg [3*NUMVBNK*BITHVRW-1:0] t3_addrB;
integer t3r_int, t3b_int;
always_comb begin
  t3_writeA = 0;
  t3_addrA = 0;
  t3_bwA = 0;
  t3_dinA = 0;
  t3_readB = 0;
  t3_addrB = 0;
  for (t3r_int=0; t3r_int<NUMVBNK; t3r_int=t3r_int+1) begin
    for (t3b_int=0; t3b_int<3; t3b_int=t3b_int+1) begin
      t3_writeA = t3_writeA | (t3_writeA_wire[t3r_int][t3b_int] << (t3r_int*3+t3b_int));
      t3_addrA = t3_addrA | (t3_addrA_wire[t3r_int][t3b_int] << ((t3r_int*3+t3b_int)*BITHVRW));
      t3_bwA = t3_bwA | (t3_bwA_wire[t3r_int][t3b_int] << ((t3r_int*3+t3b_int)*SDOUT_WIDTH));
      t3_dinA = t3_dinA | (t3_dinA_wire[t3r_int][t3b_int] << ((t3r_int*3+t3b_int)*SDOUT_WIDTH));
      t3_readB = t3_readB | (t3_readB_wire[t3r_int][t3b_int] << (t3r_int*3+t3b_int));
      t3_addrB = t3_addrB | (t3_addrB_wire[t3r_int][t3b_int] << ((t3r_int*3+t3b_int)*BITHVRW));
    end
  end
end

wire [NUMLVBK-1:0]         t4_writeA_wire [0:NUMVBNK-1];
wire [NUMLVBK*BITLVRW-1:0] t4_addrA_wire  [0:NUMVBNK-1];
wire [NUMLVBK*MEMWDTH-1:0] t4_bwA_wire    [0:NUMVBNK-1];
wire [NUMLVBK*MEMWDTH-1:0] t4_dinA_wire   [0:NUMVBNK-1];
wire [NUMLVBK-1:0]         t4_readB_wire  [0:NUMVBNK-1];
wire [NUMLVBK*BITLVRW-1:0] t4_addrB_wire  [0:NUMVBNK-1];
wire [NUMVBNK-1:0]         raf_full_l;
genvar t4r;
generate
for (t4r=0; t4r<NUMVBNK; t4r=t4r+1) begin: t4r_loop 
 
  wire               t2_writeA_a1_wire = t2_writeA_a1 >> t4r;
  wire [BITLROW-1:0] t2_addrA_a1_wire  = t2_addrA_a1  >> (t4r*BITLROW);
  wire [WIDTH-1:0]   t2_dinA_a1_wire   = t2_dinA_a1   >> (t4r*WIDTH);
  wire               t2_readB_a1_wire  = t2_readB_a1  >> t4r;
  wire [BITLROW-1:0] t2_addrB_a1_wire  = t2_addrB_a1  >> (t4r*BITLROW);
  wire [BITCTRL-1:0] t2_cinB_a1_wire   = t2_cinB_a1   >> (t4r*BITCTRL);

  wire mt_lclk;
  wire t2_writeA_a1_lclk;
  wire [BITLROW-1:0] t2_addrA_a1_lclk;
  wire [WIDTH-1:0] t2_dinA_a1_lclk;
  wire t2_readB_a1_lclk;
  wire [BITLROW-1:0] t2_addrB_a1_lclk;
  wire [BITCTRL-1:0] t2_cinB_a1_lclk;

  ip_async_fifo2 #(.FIFO_WIDTH (1+BITLROW+WIDTH+1+BITLROW+BITCTRL), .FIFO_DEPTH (16))
  lclk_inst (.w_rst(rst), .w_clk(clk), .wr_en(t2_writeA_a1_wire || t2_readB_a1_wire),
    .data_in ({t2_writeA_a1_wire,t2_addrA_a1_wire,t2_dinA_a1_wire,t2_readB_a1_wire,t2_addrB_a1_wire,t2_cinB_a1_wire}),
    .af_alm_full(faf_full[t4r]), .af_thrsh(4'h0), .af_set_intr_p(), .af_cnt(),
    .r_rst(rst_l), .r_clk(lclk), .rd_en(!mt_lclk),
    .data_out ({t2_writeA_a1_lclk,t2_addrA_a1_lclk,t2_dinA_a1_lclk,t2_readB_a1_lclk,t2_addrB_a1_lclk,t2_cinB_a1_lclk}),
    .af_empty(mt_lclk));

  reg t2_vldB_reg_lclk [0:SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC];
  reg [BITCTRL-1:0] t2_coutB_reg_lclk [0:SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC];
  integer cout_int;
  always @(posedge lclk)
    for (cout_int=0; cout_int<SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC+1; cout_int=cout_int+1)
      if (cout_int>0) begin
        t2_vldB_reg_lclk[cout_int] <= t2_vldB_reg_lclk[cout_int-1];
        t2_coutB_reg_lclk[cout_int] <= t2_coutB_reg_lclk[cout_int-1];
      end else begin
        t2_vldB_reg_lclk[cout_int] <= t2_readB_a1_lclk;
        t2_coutB_reg_lclk[cout_int] <= t2_cinB_a1_lclk;
      end

  wire [WIDTH-1:0] t2_doutB_a1_lclk;
  wire t2_fwrdB_a1_lclk;
  wire t2_serrB_a1_lclk;
  wire t2_derrB_a1_lclk;
  wire [BITLROW-1:0] t2_padrB_a1_lclk;
  wire t2_vldB_a1_lclk = t2_vldB_reg_lclk[SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC];
  wire [BITCTRL-1:0] t2_coutB_a1_lclk = t2_coutB_reg_lclk[SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC];

  wire mt_clk;
  ip_async_fifo2 #(.FIFO_WIDTH (WIDTH+1+1+1+1+BITLROW+BITCTRL), .FIFO_DEPTH (8))
  clk_inst (.w_rst(rst_l), .w_clk(lclk), .wr_en(t2_vldB_a1_lclk),
    .data_in ({t2_vldB_a1_lclk,t2_doutB_a1_lclk,t2_fwrdB_a1_lclk,t2_serrB_a1_lclk,t2_derrB_a1_lclk,t2_padrB_a1_lclk,t2_coutB_a1_lclk}),
    .af_alm_full(raf_full_l[t4r]), .af_thrsh(3'h0), .af_set_intr_p(), .af_cnt(),
    .r_rst(rst), .r_clk(clk), .rd_en(!mt_clk),
    .data_out ({t2_vldB_a1_wire[t4r],t2_doutB_a1_wire[t4r],t2_fwrdB_a1_wire[t4r],t2_serrB_a1_wire[t4r],t2_derrB_a1_wire[t4r],t2_padrB_a1_wire[t4r],t2_coutB_a1_wire[t4r]}),
    .af_empty(mt_clk));

  f32_pulse_sync psync_inst (.src_clk(lclk), .src_pulse(raf_full_l[t4r]), .dest_clk(clk), .dest_rst(rst), .dest_pulse(raf_full[t4r]));

  always @(posedge clk)
    {t2_vldB_a1_reg[t4r],t2_doutB_a1_reg[t4r],t2_fwrdB_a1_reg[t4r],t2_serrB_a1_reg[t4r],t2_derrB_a1_reg[t4r],t2_padrB_a1_reg[t4r],t2_coutB_a1_reg[t4r]} <= {t2_vldB_a1_wire[t4r],t2_doutB_a1_wire[t4r],t2_fwrdB_a1_wire[t4r],t2_serrB_a1_wire[t4r],t2_derrB_a1_wire[t4r],t2_padrB_a1_wire[t4r],t2_coutB_a1_wire[t4r]};
    
    wire [PHYWDTH*NUMLVBK-1:0] t4_doutB_wire = t4_doutB >> (t4r*PHYWDTH*NUMLVBK);
    
    wire mem_write_wire;
    wire [BITLROW-1:0] mem_wr_adr_wire;
    wire [MEMWDTH-1:0] mem_bw_wire;
    wire [MEMWDTH-1:0] mem_din_wire;
    wire mem_read_wire;
    wire [BITLROW-1:0] mem_rd_adr_wire;
    wire [MEMWDTH-1:0] mem_rd_dout_wire;
    wire mem_rd_fwrd_wire;
    wire mem_rd_serr_wire;
    wire mem_rd_derr_wire;
    wire [BITLROW-1:0] mem_rd_padr_wire;

    if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH(WIDTH), .ENAPSDO(1), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ENAHEC(ENAHEC), .ENAQEC(ENAQEC), .ECCWDTH(ECCWDTH),
                             .ENAPADR(1),
                             .NUMADDR (NUMLROW), .BITADDR (BITLROW),
                             .NUMSROW (NUMLROW), .BITSROW (BITLROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITLROW),
                             .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM+1), .FLOPGEN (0), .FLOPMEM (0), .FLOPOUT (FLOPECC))
        infra (.write(t2_writeA_a1_lclk), .wr_adr(t2_addrA_a1_lclk), .din(t2_dinA_a1_lclk),
               .read(t2_readB_a1_lclk), .rd_adr(t2_addrB_a1_lclk),
               .rd_dout(t2_doutB_a1_lclk), .rd_fwrd(t2_fwrdB_a1_lclk),
               .rd_serr(t2_serrB_a1_lclk), .rd_derr(t2_derrB_a1_lclk), .rd_padr(t2_padrB_a1_lclk),
               .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
               .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
               .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
               .clk (lclk), .rst (rst_l),
               .select_addr (select_lrow));
    end

    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (MEMWDTH), .ENAPSDO (0), .NUMADDR (NUMLVBK*(1<<BITLVRW)), .BITADDR (BITLVBK+BITLVRW),
                         .NUMWROW ((1<<BITLVRW)), .BITWROW (BITLVRW), .NUMWBNK (NUMLVBK), .BITWBNK (BITLVBK),
                         .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT(1))
        infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
               .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
               .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
               .mem_write (t4_writeA_wire[t4r]), .mem_wr_adr(t4_addrA_wire[t4r]),
               .mem_bw (t4_bwA_wire[t4r]), .mem_din (t4_dinA_wire[t4r]),
               .mem_read (t4_readB_wire[t4r]), .mem_rd_adr(t4_addrB_wire[t4r]), .mem_rd_dout (t4_doutB_wire),
               .clk (lclk), .rst(rst_l),
               .select_addr (select_lrow));
    end


`ifdef FORMAL
    assert_clk_to_lclk_writeA_check: assert property (@(posedge clk) disable iff (rst || !ready) (!faf_full & (t2_writeA_a1_wire || t2_readB_a1_wire)) |-> ##4 (t2_writeA_a1_lclk == $past(t2_writeA_a1_wire,4)));
    assert_clk_to_lclk_addrA_check : assert property (@(posedge clk) disable iff (rst || !ready) (!faf_full & (t2_writeA_a1_wire || t2_readB_a1_wire)) |-> ##4 (t2_addrA_a1_lclk  == $past(t2_addrA_a1_wire,4)));
    assert_clk_to_lclk_dinA_check  : assert property (@(posedge clk) disable iff (rst || !ready) (!faf_full & (t2_writeA_a1_wire || t2_readB_a1_wire)) |-> ##4 (t2_dinA_a1_lclk   == $past(t2_dinA_a1_wire,4)));
    assert_clk_to_lclk_readB_check : assert property (@(posedge clk) disable iff (rst || !ready) (!faf_full & (t2_writeA_a1_wire || t2_readB_a1_wire)) |-> ##4 (t2_readB_a1_lclk  == $past(t2_readB_a1_wire,4)));
    assert_clk_to_lclk_addrB_check : assert property (@(posedge clk) disable iff (rst || !ready) (!faf_full & (t2_writeA_a1_wire || t2_readB_a1_wire)) |-> ##4 (t2_addrB_a1_lclk  == $past(t2_addrB_a1_wire,4)));
    assert_clk_to_lclk_cinB_check  : assert property (@(posedge clk) disable iff (rst || !ready) (!faf_full & (t2_writeA_a1_wire || t2_readB_a1_wire)) |-> ##4 (t2_cinB_a1_lclk   == $past(t2_cinB_a1_wire,4)));

    wire [WIDTH-1:0]     t2_f_doutB_wire = a1_loop.algo.t2_doutB >> (WIDTH*t4r);
    wire                 t2_f_fwrdB_wire = a1_loop.algo.t2_fwrdB >> t4r;
    wire                 t2_f_serrB_wire = a1_loop.algo.t2_serrB >> t4r;
    wire                 t2_f_derrB_wire = a1_loop.algo.t2_derrB >> t4r;
    wire [BITLROW-1:0]   t2_f_padrB_wire = a1_loop.algo.t2_padrB >> (BITLROW*t4r);
    wire [BITCTRL-1:0]   t2_f_cinB_wire  = a1_loop.algo.t2_cinB  >> (BITCTRL*t4r);
    wire                 t2_f_vldB_wire  = a1_loop.algo.t2_vldB  >> t4r;
    wire [BITCTRL-1:0]   t2_f_coutB_wire = a1_loop.algo.t2_coutB >> (BITCTRL*t4r);
 
    assert_lclk_to_clk_vldB_check   : assert property (@(posedge clk) disable iff (rst || !ready) (!raf_full & t2_vldB_a1_lclk) |-> ##5 (t2_f_vldB_wire  == $past(t2_vldB_a1_lclk, 5)));
    assert_lclk_to_clk_doutB_check  : assert property (@(posedge clk) disable iff (rst || !ready) (!raf_full & t2_vldB_a1_lclk) |-> ##5 (t2_f_doutB_wire == $past(t2_doutB_a1_lclk,5)));
    assert_lclk_to_clk_fwrdB_check  : assert property (@(posedge clk) disable iff (rst || !ready) (!raf_full & t2_vldB_a1_lclk) |-> ##5 (t2_f_fwrdB_wire == $past(t2_fwrdB_a1_lclk,5)));
    assert_lclk_to_clk_serrB_check  : assert property (@(posedge clk) disable iff (rst || !ready) (!raf_full & t2_vldB_a1_lclk) |-> ##5 (t2_f_serrB_wire == $past(t2_serrB_a1_lclk,5)));
    assert_lclk_to_clk_derrB_check  : assert property (@(posedge clk) disable iff (rst || !ready) (!raf_full & t2_vldB_a1_lclk) |-> ##5 (t2_f_derrB_wire == $past(t2_derrB_a1_lclk,5)));
    assert_lclk_to_clk_padrB_check  : assert property (@(posedge clk) disable iff (rst || !ready) (!raf_full & t2_vldB_a1_lclk) |-> ##5 (t2_f_padrB_wire == $past(t2_padrB_a1_lclk,5)));
    assert_lclk_to_clk_coutB_check  : assert property (@(posedge clk) disable iff (rst || !ready) (!raf_full & t2_vldB_a1_lclk) |-> ##5 (t2_f_coutB_wire == $past(t2_coutB_a1_lclk,5)));

`endif
  end
  endgenerate

wire [NUMVBNK*NUMLVBK-1:0]         t4_writeA;
wire [NUMVBNK*NUMLVBK*BITLVRW-1:0] t4_addrA;
wire [NUMVBNK*NUMLVBK*PHYWDTH-1:0] t4_bwA;
wire [NUMVBNK*NUMLVBK*PHYWDTH-1:0] t4_dinA;
wire [NUMVBNK*NUMLVBK-1:0]         t4_readB;
wire [NUMVBNK*NUMLVBK*BITLVRW-1:0] t4_addrB;
genvar t4r_gia;
generate for (t4r_gia=0; t4r_gia<NUMVBNK; t4r_gia++) begin

  assign t4_writeA[(t4r_gia+1)*NUMLVBK-1        :t4r_gia*NUMLVBK]         = t4_writeA_wire[t4r_gia];
  assign t4_addrA [(t4r_gia+1)*NUMLVBK*BITLVRW-1:t4r_gia*NUMLVBK*BITLVRW] = t4_addrA_wire[t4r_gia];
  assign t4_bwA   [(t4r_gia+1)*NUMLVBK*PHYWDTH-1:t4r_gia*NUMLVBK*PHYWDTH] = t4_bwA_wire[t4r_gia];
  assign t4_dinA  [(t4r_gia+1)*NUMLVBK*PHYWDTH-1:t4r_gia*NUMLVBK*PHYWDTH] = t4_dinA_wire[t4r_gia];
  assign t4_readB [(t4r_gia+1)*NUMLVBK-1        :t4r_gia*NUMLVBK]         = t4_readB_wire[t4r_gia];
  assign t4_addrB [(t4r_gia+1)*NUMLVBK*BITLVRW-1:t4r_gia*NUMLVBK*BITLVRW] = t4_addrB_wire[t4r_gia];

end
endgenerate

endmodule // algo_mrnws_a33_top

