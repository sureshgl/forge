module algo_mrnws_a34_top (lclk, clk, rst, rst_l, ready,
                           write, wr_adr, din,
                           read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                           wrfifo_oflw, rdfifo_oflw, rdrob_uflw, faf_full, raf_full,
                           t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB);

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
  parameter NUMCELL = 36;
  parameter BITCELL = 6;
  parameter NUMQUEU = 880;
  parameter BITQUEU = 10;
  parameter NUMLROW = 1536;
  parameter BITLROW = 11;
  parameter NUMLVRW = 8192;
  parameter BITLVRW = 13;
  parameter NUMLVBK = 4;
  parameter BITLVBK = 2;
  parameter BITLPBK = 6;
  parameter ECCBITS = 4;
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
  parameter BITPADR = BITADDR;

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

  output [NUMVBNK-1:0]                wrfifo_oflw;
  output [NUMVBNK-1:0]                rdfifo_oflw;
  output [NUMRDPT-1:0]                rdrob_uflw;
  output [NUMVBNK-1:0]                faf_full;
  output [NUMVBNK-1:0]                raf_full;

  output                              ready;
  input                               lclk, clk, rst, rst_l;

  output [NUMVBNK*NUMLVBK-1:0]         t1_writeA;
  output [NUMVBNK*NUMLVBK*BITLVRW-1:0] t1_addrA;
  output [NUMVBNK*NUMLVBK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*NUMLVBK*PHYWDTH-1:0] t1_dinA;

  output [NUMVBNK*NUMLVBK-1:0]         t1_readB;
  output [NUMVBNK*NUMLVBK*BITLVRW-1:0] t1_addrB;
  input [NUMVBNK*NUMLVBK*PHYWDTH-1:0]  t1_doutB;

  localparam LPBKDEL = 3+FLOPCMD+SRAM_DELAY+FLOPMEM+1+FLOPECC+1+3; // for proving control return path - sync delay ONLY
  localparam SLOWDLA = 3*(4+FLOPCMD+SRAM_DELAY+FLOPMEM+1+FLOPECC+1);
  localparam SLOWDLB = (SLOWDLA>>1) + SLOWDLA[0];  // slow clock is 1.5x (mul by 3 and div by 2)
  localparam LPBKADL = SLOWDLB+4; // 4 is return async FIFO delay

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) ((select_addr[BITADDR-1:BITCELL+BITVBNK] < NUMQUEU) && (select_addr[BITCELL-1:BITVBNK] < NUMCELL)));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

wire [BITCELL-1:0] select_vwrd = select_addr >> BITVBNK;
wire [BITADDR-BITCELL-BITVBNK-1:0] select_vrow = select_addr >> (BITCELL+BITVBNK);
wire [BITLROW-1:0]         select_lrow = NUMQUEU*select_vwrd+select_vrow;
wire [BITVBNK-1:0]         select_bnk  = select_addr;
wire [BITLVRW-1:0]         select_lvrw;
wire [BITLVBK-1:0]         select_lbnk;
np2_addr #(
  .NUMADDR (NUMLVBK*(1<<BITLVRW)), .BITADDR (BITLVBK+BITLVRW),
  .NUMVBNK (NUMLVBK), .BITVBNK (BITLVBK),
  .NUMVROW (NUMLVRW), .BITVROW (BITLVRW))
  lvrw_inst (.vbadr(select_lbnk), .vradr(select_lvrw), .vaddr(select_lrow));
`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITCELL-1:0] select_vwrd = 0;
wire [BITADDR-BITCELL-BITVBNK-1:0] select_vrow = 0;
wire [BITLROW-1:0] select_lrow = 0;
wire [BITVBNK-1:0] select_bnk = 0;
wire [BITLVRW-1:0] select_lvrw = 0;
`endif

wire [NUMVBNK-1:0]         t1_writeA_a1;
wire [NUMVBNK*BITLROW-1:0] t1_addrA_a1;
wire [NUMVBNK*WIDTH-1:0]   t1_dinA_a1;
wire [NUMVBNK-1:0]         t1_readB_a1;
wire [NUMVBNK*BITLROW-1:0] t1_addrB_a1;
wire [NUMVBNK*BITCTRL-1:0] t1_cinB_a1;
wire [WIDTH-1:0]           t1_doutB_a1_wire [0:NUMVBNK-1];
wire                       t1_fwrdB_a1_wire [0:NUMVBNK-1];
wire                       t1_serrB_a1_wire [0:NUMVBNK-1];
wire                       t1_derrB_a1_wire [0:NUMVBNK-1];
wire [BITLROW-1:0]         t1_padrB_a1_wire [0:NUMVBNK-1];
wire                       t1_vldB_a1_wire [0:NUMVBNK-1];
wire [BITCTRL-1:0]         t1_coutB_a1_wire [0:NUMVBNK-1];
reg  [WIDTH-1:0]           t1_doutB_a1_reg [0:NUMVBNK-1];
reg                        t1_fwrdB_a1_reg [0:NUMVBNK-1];
reg                        t1_serrB_a1_reg [0:NUMVBNK-1];
reg                        t1_derrB_a1_reg [0:NUMVBNK-1];
reg  [BITLROW-1:0]         t1_padrB_a1_reg [0:NUMVBNK-1];
reg                        t1_vldB_a1_reg [0:NUMVBNK-1];
reg  [BITCTRL-1:0]         t1_coutB_a1_reg [0:NUMVBNK-1];

generate if (1) begin: a1_loop

  reg [NUMVBNK*WIDTH-1:0]   t1_doutB_a1;
  reg [NUMVBNK-1:0]         t1_fwrdB_a1;
  reg [NUMVBNK-1:0]         t1_serrB_a1;
  reg [NUMVBNK-1:0]         t1_derrB_a1;
  reg [NUMVBNK*BITLROW-1:0] t1_padrB_a1;
  reg [NUMVBNK-1:0]         t1_vldB_a1;
  reg [NUMVBNK*BITCTRL-1:0] t1_coutB_a1;
  integer t_int;
  always_comb begin
    t1_doutB_a1 = 0;
    t1_fwrdB_a1 = 0;
    t1_serrB_a1 = 0;
    t1_derrB_a1 = 0;
    t1_padrB_a1 = 0;
    t1_vldB_a1  = 0;
    t1_coutB_a1 = 0;
    for (t_int=0; t_int<NUMVBNK; t_int=t_int+1) begin
      t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_reg[t_int] << (t_int*WIDTH));
      t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_reg[t_int] << t_int);
      t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_reg[t_int] << t_int);
      t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_reg[t_int] << t_int);
      t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_reg[t_int] << (t_int*BITLROW));
      t1_vldB_a1  = t1_vldB_a1  | (t1_vldB_a1_reg[t_int]  << t_int);
      t1_coutB_a1 = t1_coutB_a1 | (t1_coutB_a1_reg[t_int] << (t_int*BITCTRL));
    end
  end

  algo_mrnws_a34 #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMRDPT (NUMRDPT), .BITRDPT (BITRDPT), .NUMWRPT (NUMWRPT), .BITWRPT (BITWRPT),
                   .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMCELL (NUMCELL), .BITCELL (BITCELL), .NUMQUEU(NUMQUEU), .BITQUEU(BITQUEU),
                   .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR-1),
                   .NUMLROW (NUMLROW), .BITLROW (BITLROW),
                   .READ_DELAY (READ_DELAY), .BITRDLY (BITRDLY), .FLOPIN(FLOPIN), .FLOPOUT(FLOPOUT),
                   .LPBKDEL (LPBKDEL), .LPBKADL(LPBKADL)
                 )
    algo (.clk(clk), .rst(rst), .ready(ready),
          .write(write), .wr_adr(wr_adr), .din(din),
          .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), 
          .rd_fwrd({rd_padr[5*BITPADR-1],rd_padr[4*BITPADR-1],rd_padr[3*BITPADR-1],rd_padr[2*BITPADR-1],rd_padr[BITPADR-1]}), .rd_serr(rd_serr), .rd_derr(rd_derr),
          .rd_padr({rd_padr[5*BITPADR-2:4*BITPADR],rd_padr[4*BITPADR-2:3*BITPADR],rd_padr[3*BITPADR-2:2*BITPADR],rd_padr[2*BITPADR-2:BITPADR],rd_padr[BITPADR-2:0]}),
          .wrfifo_oflw(wrfifo_oflw), .rdfifo_oflw(rdfifo_oflw), .rdrob_uflw(rdrob_uflw),
          .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
          .t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1),
          .t1_cinB(t1_cinB_a1), .t1_vldB(t1_vldB_a1), .t1_coutB(t1_coutB_a1),
          .select_addr(select_addr), .select_bit(select_bit), .select_bnk(select_bnk), .select_vwrd(select_vwrd), .select_vrow(select_vrow), .select_lrow(select_lrow));

end
endgenerate

wire [NUMLVBK-1:0]         t1_writeA_wire [0:NUMVBNK-1];
wire [NUMLVBK*BITLVRW-1:0] t1_addrA_wire  [0:NUMVBNK-1];
wire [NUMLVBK*MEMWDTH-1:0] t1_bwA_wire    [0:NUMVBNK-1];
wire [NUMLVBK*MEMWDTH-1:0] t1_dinA_wire   [0:NUMVBNK-1];
wire [NUMLVBK-1:0]         t1_readB_wire  [0:NUMVBNK-1];
wire [NUMLVBK*BITLVRW-1:0] t1_addrB_wire  [0:NUMVBNK-1];
wire [NUMVBNK-1:0]         raf_full_l;
genvar t1r;
generate
for (t1r=0; t1r<NUMVBNK; t1r=t1r+1) begin: t1r_loop
 
  wire               t1_writeA_a1_wire = t1_writeA_a1 >> t1r;
  wire [BITLROW-1:0] t1_addrA_a1_wire  = t1_addrA_a1  >> (t1r*BITLROW);
  wire [WIDTH-1:0]   t1_dinA_a1_wire   = t1_dinA_a1   >> (t1r*WIDTH);
  wire               t1_readB_a1_wire  = t1_readB_a1  >> t1r;
  wire [BITLROW-1:0] t1_addrB_a1_wire  = t1_addrB_a1  >> (t1r*BITLROW);
  wire [BITCTRL-1:0] t1_cinB_a1_wire   = t1_cinB_a1   >> (t1r*BITCTRL);

  wire t1_writeA_a1_lclk;
  wire [BITLROW-1:0] t1_addrA_a1_lclk;
  wire [WIDTH-1:0] t1_dinA_a1_lclk;
  wire t1_readB_a1_lclk;
  wire [BITLROW-1:0] t1_addrB_a1_lclk;
  wire [BITCTRL-1:0] t1_cinB_a1_lclk;

  wire mt_lclk;
  ip_async_fifo2 #(.FIFO_WIDTH (1+BITLROW+WIDTH+1+BITLROW+BITCTRL), .FIFO_DEPTH (16))
  lclk_inst (.w_rst(rst), .w_clk(clk), .wr_en(t1_writeA_a1_wire || t1_readB_a1_wire),
    .data_in ({t1_writeA_a1_wire,t1_addrA_a1_wire,t1_dinA_a1_wire,t1_readB_a1_wire,t1_addrB_a1_wire,t1_cinB_a1_wire}),
    .af_alm_full(faf_full[t1r]), .af_thrsh(4'h0), .af_set_intr_p(), .af_cnt(),
    .r_rst(rst_l), .r_clk(lclk), .rd_en(!mt_lclk),
    .data_out ({t1_writeA_a1_lclk,t1_addrA_a1_lclk,t1_dinA_a1_lclk,t1_readB_a1_lclk,t1_addrB_a1_lclk,t1_cinB_a1_lclk}),
    .af_empty(mt_lclk));

  reg t1_vldB_reg_lclk [0:SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC];
  reg [BITCTRL-1:0] t1_coutB_reg_lclk [0:SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC];
  integer cout_int;
  always @(posedge lclk)
    for (cout_int=0; cout_int<SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC+1; cout_int=cout_int+1)
      if (cout_int>0) begin
        t1_vldB_reg_lclk[cout_int] <= t1_vldB_reg_lclk[cout_int-1];
        t1_coutB_reg_lclk[cout_int] <= t1_coutB_reg_lclk[cout_int-1];
      end else begin
        t1_vldB_reg_lclk[cout_int] <= t1_readB_a1_lclk;
        t1_coutB_reg_lclk[cout_int] <= t1_cinB_a1_lclk;
      end

  wire [WIDTH-1:0] t1_doutB_a1_lclk;
  wire t1_fwrdB_a1_lclk;
  wire t1_serrB_a1_lclk;
  wire t1_derrB_a1_lclk;
  wire [BITLROW-1:0] t1_padrB_a1_lclk;
  wire t1_vldB_a1_lclk = t1_vldB_reg_lclk[SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC];
  wire [BITCTRL-1:0] t1_coutB_a1_lclk = t1_coutB_reg_lclk[SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC];

  wire mt_clk;
  ip_async_fifo2 #(.FIFO_WIDTH (WIDTH+1+1+1+1+BITLROW+BITCTRL), .FIFO_DEPTH (8))
  clk_inst (.w_rst(rst_l), .w_clk(lclk), .wr_en(t1_vldB_a1_lclk),
    .data_in ({t1_vldB_a1_lclk,t1_doutB_a1_lclk,t1_fwrdB_a1_lclk,t1_serrB_a1_lclk,t1_derrB_a1_lclk,t1_padrB_a1_lclk,t1_coutB_a1_lclk}),
    .af_alm_full(raf_full_l[t1r]), .af_thrsh(3'h0), .af_set_intr_p(), .af_cnt(),
    .r_rst(rst), .r_clk(clk), .rd_en(!mt_clk),
    .data_out ({t1_vldB_a1_wire[t1r],t1_doutB_a1_wire[t1r],t1_fwrdB_a1_wire[t1r],t1_serrB_a1_wire[t1r],t1_derrB_a1_wire[t1r],t1_padrB_a1_wire[t1r],t1_coutB_a1_wire[t1r]}),
    .af_empty(mt_clk));
 
  f32_pulse_sync psync_inst (.src_clk(lclk), .src_pulse(raf_full_l[t1r]), .dest_clk(clk), .dest_rst(rst), .dest_pulse(raf_full[t1r]));

  always @(posedge clk)
    {t1_vldB_a1_reg[t1r],t1_doutB_a1_reg[t1r],t1_fwrdB_a1_reg[t1r],t1_serrB_a1_reg[t1r],t1_derrB_a1_reg[t1r],t1_padrB_a1_reg[t1r],t1_coutB_a1_reg[t1r]} <= {t1_vldB_a1_wire[t1r],t1_doutB_a1_wire[t1r],t1_fwrdB_a1_wire[t1r],t1_serrB_a1_wire[t1r],t1_derrB_a1_wire[t1r],t1_padrB_a1_wire[t1r],t1_coutB_a1_wire[t1r]};
    
    wire [PHYWDTH*NUMLVBK-1:0] t1_doutB_wire = t1_doutB >> (t1r*PHYWDTH*NUMLVBK);
    
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
        infra (.write(t1_writeA_a1_lclk), .wr_adr(t1_addrA_a1_lclk), .din(t1_dinA_a1_lclk),
               .read(t1_readB_a1_lclk), .rd_adr(t1_addrB_a1_lclk),
               .rd_dout(t1_doutB_a1_lclk), .rd_fwrd(t1_fwrdB_a1_lclk),
               .rd_serr(t1_serrB_a1_lclk), .rd_derr(t1_derrB_a1_lclk), .rd_padr(t1_padrB_a1_lclk),
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
               .mem_write (t1_writeA_wire[t1r]), .mem_wr_adr(t1_addrA_wire[t1r]),
               .mem_bw (t1_bwA_wire[t1r]), .mem_din (t1_dinA_wire[t1r]),
               .mem_read (t1_readB_wire[t1r]), .mem_rd_adr(t1_addrB_wire[t1r]), .mem_rd_dout (t1_doutB_wire),
               .clk (lclk), .rst(rst_l),
               .select_addr (select_lrow));
    end

  end
  endgenerate

wire [NUMVBNK*NUMLVBK-1:0]         t1_writeA;
wire [NUMVBNK*NUMLVBK*BITLVRW-1:0] t1_addrA;
wire [NUMVBNK*NUMLVBK*PHYWDTH-1:0] t1_bwA;
wire [NUMVBNK*NUMLVBK*PHYWDTH-1:0] t1_dinA;
wire [NUMVBNK*NUMLVBK-1:0]         t1_readB;
wire [NUMVBNK*NUMLVBK*BITLVRW-1:0] t1_addrB;
genvar t1r_gia;
generate for (t1r_gia=0; t1r_gia<NUMVBNK; t1r_gia++) begin

  assign t1_writeA[(t1r_gia+1)*NUMLVBK-1        :t1r_gia*NUMLVBK]         = t1_writeA_wire[t1r_gia];
  assign t1_addrA [(t1r_gia+1)*NUMLVBK*BITLVRW-1:t1r_gia*NUMLVBK*BITLVRW] = t1_addrA_wire [t1r_gia];
  assign t1_bwA   [(t1r_gia+1)*NUMLVBK*PHYWDTH-1:t1r_gia*NUMLVBK*PHYWDTH] = t1_bwA_wire   [t1r_gia];
  assign t1_dinA  [(t1r_gia+1)*NUMLVBK*PHYWDTH-1:t1r_gia*NUMLVBK*PHYWDTH] = t1_dinA_wire  [t1r_gia];
  assign t1_readB [(t1r_gia+1)*NUMLVBK-1        :t1r_gia*NUMLVBK]         = t1_readB_wire [t1r_gia];
  assign t1_addrB [(t1r_gia+1)*NUMLVBK*BITLVRW-1:t1r_gia*NUMLVBK*BITLVRW] = t1_addrB_wire [t1r_gia];

end
endgenerate

endmodule // algo_mrnws_a34_top

