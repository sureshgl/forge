
module algo_1r1we_rl2_pseudo_top (clk, rst, ready,
                                  write, wr_adr, wren, din,
                                  read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                          t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA,
	                          t2_writeA, t2_addrA, t2_readB, t2_addrB, t2_bwA, t2_dinA, t2_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMWREN = 8;
  parameter BITWREN = 3;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;   // ALGO Parameters
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter NUMWRDS = 4;      // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter NUMWBNK = 1;      // T2PCK Parameters
  parameter BITWBNK = 0;
  parameter NUMWROW = NUMSROW;
  parameter BITWROW = BITSROW;

  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;
  parameter PHYWDTH = NUMWRDS*NUMWREN*WIDTH;
  parameter ECCBITS = 5;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;
  parameter SDOUT_WIDTH = 2*(NUMWREN+BITVBNK)+ECCBITS;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [NUMWREN-1:0]                  wren;
  input [NUMWREN*WIDTH-1:0]            din;

  input                                read;
  input [BITADDR-1:0]                  rd_adr;
  output                               rd_vld;
  output [NUMWREN*WIDTH-1:0]           rd_dout;
  output                               rd_serr;
  output                               rd_derr;
  output [BITPADR-1:0]                 rd_padr;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMVBNK*PHYWDTH-1:0] t1_doutA;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*(SDOUT_WIDTH+NUMWREN*WIDTH)-1:0] t2_bwA;
  output [2*(SDOUT_WIDTH+NUMWREN*WIDTH)-1:0] t2_dinA;

  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*(SDOUT_WIDTH+NUMWREN*WIDTH)-1:0] t2_doutB;

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH+BITWREN-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < NUMWREN*WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

wire [BITVBNK-1:0] select_bank;
wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  vrow_inst (.vbadr(select_bank), .vradr(select_vrow), .vaddr(select_addr));

wire [BITSROW-1:0] select_srow;
np2_addr #(
  .NUMADDR (NUMVROW), .BITADDR (BITVROW),
  .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
  .NUMVROW (NUMSROW), .BITVROW (BITSROW))
  srow_inst (.vbadr(), .vradr(select_srow), .vaddr(select_vrow));

`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH+BITWREN-1:0] select_bit = 0;
wire [BITVBNK-1:0] select_bank = 0;
wire [BITVROW-1:0] select_vrow = 0;
wire [BITSROW-1:0] select_srow = 0;
`endif

wire t1_writeA_a1;
wire [BITVBNK-1:0] t1_bankA_a1;
wire [BITVROW-1:0] t1_addrA_a1;
wire [NUMWREN*WIDTH-1:0] t1_bwA_a1;
wire [NUMWREN*WIDTH-1:0] t1_dinA_a1;
wire t1_readB_a1;
wire [BITVBNK-1:0] t1_bankB_a1;
wire [BITVROW-1:0] t1_addrB_a1;
reg [NUMWREN*WIDTH-1:0] t1_doutB_a1;
reg t1_fwrdB_a1;
reg t1_serrB_a1;
reg t1_derrB_a1;
reg [BITSROW+BITWRDS-1:0] t1_padrB_a1;

wire [2-1:0] t2_writeA_a1;
wire [2*BITVROW-1:0] t2_addrA_a1;
wire [2*(NUMWREN*WIDTH+BITVBNK+NUMWREN*WIDTH)-1:0] t2_bwA_a1;
wire [2*(NUMWREN*WIDTH+BITVBNK+NUMWREN*WIDTH)-1:0] t2_dinA_a1;
wire [2-1:0] t2_readB_a1;
wire [2*BITVROW-1:0] t2_addrB_a1;
reg [2*(NUMWREN+BITVBNK+NUMWREN*WIDTH)-1:0] t2_doutB_a1;
reg [2-1:0] t2_fwrdB_a1;
reg [2*(BITSROW+BITWRDS)-1:0] t2_padrB_a1;

reg [NUMWREN*WIDTH-1:0] bw;
integer bw_int, bwd_int;
always_comb
  for (bw_int=0; bw_int<NUMWREN; bw_int=bw_int+1)
    for (bwd_int=0; bwd_int<WIDTH; bwd_int=bwd_int+1)
      bw[bw_int*WIDTH+bwd_int] = wren[bw_int];

generate if (1) begin: a1_loop

  reg [NUMWREN*WIDTH-1:0] t2_datB_a1_wire [0:2-1];
  reg [BITVBNK-1:0]       t2_mapB_a1_wire [0:2-1];
  reg [NUMWREN*WIDTH-1:0] t2_vldB_a1_wire [0:2-1];
  reg [NUMWREN*WIDTH+BITVBNK+NUMWREN*WIDTH-1:0] t2_doutB_a1_temp [0:2-1];
  integer t2o_int, t2od_int, t2ow_int;
  always_comb
    for (t2o_int=0; t2o_int<2; t2o_int=t2o_int+1) begin
      for (t2od_int=0; t2od_int<NUMWREN*WIDTH; t2od_int=t2od_int+1)
        t2_datB_a1_wire[t2o_int][t2od_int] = t2_doutB_a1[t2o_int*(NUMWREN+BITVBNK+NUMWREN*WIDTH)+t2od_int];
      for (t2od_int=0; t2od_int<BITVBNK; t2od_int=t2od_int+1)
        t2_mapB_a1_wire[t2o_int][t2od_int] = t2_doutB_a1[t2o_int*(NUMWREN+BITVBNK+NUMWREN*WIDTH)+NUMWREN*WIDTH+t2od_int];
      for (t2od_int=0; t2od_int<NUMWREN; t2od_int=t2od_int+1)
        for (t2ow_int=0; t2ow_int<WIDTH; t2ow_int=t2ow_int+1)
          t2_vldB_a1_wire[t2o_int][t2od_int*WIDTH+t2ow_int] = t2_doutB_a1[t2o_int*(NUMWREN+BITVBNK+NUMWREN*WIDTH)+NUMWREN*WIDTH+BITVBNK+t2od_int];
      t2_doutB_a1_temp[t2o_int] = {t2_vldB_a1_wire[t2o_int],t2_mapB_a1_wire[t2o_int],t2_datB_a1_wire[t2o_int]};
    end

  algo_1r1we_rl2_pseudo #(.WIDTH (NUMWREN*WIDTH), .BITWDTH (BITWDTH+BITWREN), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                          .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                          .BITPBNK (BITPBNK), .BITPADR (BITPADR-1),
		          .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .DRAM_DELAY (DRAM_DELAY+FLOPCMD+FLOPMEM),
                          .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    algo (.clk(clk), .rst(rst), .ready(ready), .refr (),
          .write(write), .wr_adr(wr_adr), .bw(bw), .din(din),
          .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd(rd_padr[BITPADR-1]), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr[BITPADR-2:0]),
          .t1_writeA(t1_writeA_a1), .t1_bankA(t1_bankA_a1), .t1_addrA(t1_addrA_a1), .t1_bwA(t1_bwA_a1), .t1_dinA(t1_dinA_a1),
          .t1_readB(t1_readB_a1), .t1_bankB(t1_bankB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1), .t1_padrB(t1_padrB_a1),
          .t1_refrC(),
          .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_bwA(t2_bwA_a1), .t2_dinA(t2_dinA_a1),
          .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1), .t2_doutB({t2_doutB_a1_temp[1],t2_doutB_a1_temp[0]}),
          .select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

parameter NUMXBNK = NUMVBNK/4;

wire [4-1:0] t1_readA_wire [0:NUMXBNK-1];
wire [4-1:0] t1_writeA_wire [0:NUMXBNK-1];
wire [4*BITSROW-1:0] t1_addrA_wire [0:NUMXBNK-1];
wire [4*NUMWRDS*NUMWREN*WIDTH-1:0] t1_bwA_wire [0:NUMXBNK-1];
wire [4*NUMWRDS*NUMWREN*WIDTH-1:0] t1_dinA_wire [0:NUMXBNK-1];
wire [4*NUMWRDS*NUMWREN*WIDTH-1:0] t1_doutA_wire [0:NUMXBNK-1];
  
genvar t1b;
generate if (1) begin: t1_loop
  wire mem_write_wire;
  wire [BITVBNK-1:0] mem_wr_bnk_wire;
  wire [BITSROW-1:0] mem_wr_adr_wire;
  wire [NUMWRDS*NUMWREN*WIDTH-1:0] mem_bw_wire;
  wire [NUMWRDS*NUMWREN*WIDTH-1:0] mem_din_wire;
  wire mem_read_wire;
  wire [BITVBNK-1:0] mem_rd_bnk_wire;
  wire [BITSROW-1:0] mem_rd_adr_wire;
  wire [NUMWRDS*NUMWREN*WIDTH-1:0] mem_dout_wire;

  if (1) begin: align_loop
    infra_align_bw_pseudo #(.WIDTH (NUMWREN*WIDTH),
                          .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                          .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITSROW),
                          .SRAM_DELAY (DRAM_DELAY+FLOPMEM), .FLOPGEN (0), .FLOPMEM (0))
        infra (.write(t1_writeA_a1), .wr_bnk(t1_bankA_a1), .wr_adr(t1_addrA_a1), .bw(t1_bwA_a1), .din(t1_dinA_a1),
               .read(t1_readB_a1), .rd_bnk(t1_bankB_a1), .rd_adr(t1_addrB_a1), .rd_dout(t1_doutB_a1),
               .rd_fwrd(t1_fwrdB_a1), .rd_serr(t1_serrB_a1), .rd_derr(t1_derrB_a1), .rd_padr (t1_padrB_a1),
               .mem_write(mem_write_wire), .mem_wr_bnk(mem_wr_bnk_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_wr_dwsn(),
               .mem_bw(mem_bw_wire), .mem_din(mem_din_wire),
               .mem_read(mem_read_wire), .mem_rd_bnk(mem_rd_bnk_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dwsn(),
               .mem_rd_dout(mem_dout_wire), .mem_rd_fwrd(1'b0), .mem_rd_padr(),
               .clk (clk), .rst (rst),
               .select_vrow (select_vrow));
  end

  wire [4-1:0] stk_write;
  wire [4*(BITSROW+2)-1:0] stk_wr_adr;
  wire [4*NUMWRDS*NUMWREN*WIDTH-1:0] stk_bw;
  wire [4*NUMWRDS*NUMWREN*WIDTH-1:0] stk_din;
  wire [4-1:0] stk_read;
  wire [4*(BITSROW+2)-1:0] stk_rd_adr;
  wire [NUMWRDS*NUMWREN*WIDTH-1:0] stk_dout_wire [0:4-1];

  reg [4*NUMWRDS*NUMWREN*WIDTH-1:0] stk_dout;
  integer stk_int;
  always_comb begin
    stk_dout = 0;
    for (stk_int=0; stk_int<4; stk_int=stk_int+1)
      stk_dout = stk_dout | (stk_dout_wire[stk_int] << (stk_int*NUMWRDS*NUMWREN*WIDTH));
  end

  if (1) begin: stack_1_loop
    infra_stack_1r1w #(.WIDTH (NUMWRDS*NUMWREN*WIDTH), .ENAPSDO (0), .NUMADDR (NUMVBNK*NUMSROW), .BITADDR (BITVBNK+BITSROW),
                       .NUMWROW (4*NUMSROW), .BITWROW (BITSROW+2), .NUMWBNK (4), .BITWBNK (2),
                       .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (0), .FLOPMEM (0))
      infra (.write (mem_write_wire), .wr_adr ({mem_wr_bnk_wire,mem_wr_adr_wire}), .bw (mem_bw_wire), .din (mem_din_wire),
             .read (mem_read_wire), .rd_adr ({mem_rd_bnk_wire,mem_rd_adr_wire}), .rd_dout (mem_dout_wire),
             .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(),
             .mem_write (stk_write), .mem_wr_adr (stk_wr_adr), .mem_bw(stk_bw), .mem_din (stk_din),
             .mem_read (stk_read), .mem_rd_adr (stk_rd_adr), .mem_rd_dout (stk_dout),
             .clk (clk), .rst(rst),
             .select_addr ({select_bank,select_srow}));
  end

  for (t1b=0; t1b<NUMXBNK; t1b=t1b+1) begin: stack_2_loop
    wire stk_write_wire = stk_write >> t1b;
    wire [BITSROW+2-1:0] stk_wr_adr_wire = stk_wr_adr >> (t1b*(BITSROW+2));
    wire [NUMWRDS*NUMWREN*WIDTH-1:0] stk_bw_wire = stk_bw >> (t1b*NUMWRDS*NUMWREN*WIDTH);
    wire [NUMWRDS*NUMWREN*WIDTH-1:0] stk_din_wire = stk_din >> (t1b*NUMWRDS*NUMWREN*WIDTH);
    wire stk_read_wire = stk_read >> t1b;
    wire [BITSROW+2-1:0] stk_rd_adr_wire = stk_rd_adr >> (t1b*(BITSROW+2));
    
    wire [4*NUMWRDS*NUMWREN*WIDTH-1:0] t1_doutA_wire = t1_doutA >> (t1b*4*PHYWDTH);

    infra_stack_pseudo #(.WIDTH (NUMWRDS*NUMWREN*WIDTH), .NUMADDR (4*NUMSROW), .BITADDR (BITSROW+2),
                         .NUMWBNK (4), .BITWBNK (2), .NUMWROW (NUMSROW), .BITWROW (BITSROW),
                         .SRAM_DELAY (DRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
      infra (.write (stk_write_wire), .wr_adr (stk_wr_adr_wire), .bw (stk_bw_wire), .din (stk_din_wire),
             .read (stk_read_wire), .rd_adr (stk_rd_adr_wire), .rd_dout(stk_dout_wire[t1b]),
             .rd_fwrd(), .rd_serr(), .rd_derr(), .rd_padr(),
             .mem_read (t1_readA_wire[t1b]), .mem_write (t1_writeA_wire[t1b]), .mem_addr (t1_addrA_wire[t1b]),
             .mem_bw (t1_bwA_wire[t1b]), .mem_din (t1_dinA_wire[t1b]), .mem_dout (t1_doutA_wire),
             .clk (clk), .rst (rst),
             .select_addr ({select_bank[1:0],select_srow}));
  end

end
endgenerate
    
reg [NUMVBNK-1:0] t1_readA;
reg [NUMVBNK-1:0] t1_writeA;
reg [NUMVBNK*BITSROW-1:0] t1_addrA;
reg [NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMVBNK*PHYWDTH-1:0] t1_dinA;
integer t1_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  for (t1_int=0; t1_int<NUMXBNK; t1_int=t1_int+1) begin
    t1_readA = t1_readA | (t1_readA_wire[t1_int] << 4*t1_int);
    t1_writeA = t1_writeA | (t1_writeA_wire[t1_int] << 4*t1_int);
    t1_addrA = t1_addrA | (t1_addrA_wire[t1_int] << (4*t1_int*BITSROW));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1_int] << (4*t1_int*NUMWRDS*NUMWREN*WIDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1_int] << (4*t1_int*NUMWRDS*NUMWREN*WIDTH));
  end
end

reg [BITVBNK-1:0]       t2_mapA_a1_wire [0:2-1];
reg [NUMWREN-1:0]       t2_vldA_a1_wire [0:2-1];
reg [NUMWREN*WIDTH-1:0] t2_bweA_a1_wire [0:2-1];
reg [NUMWREN*WIDTH-1:0] t2_datA_a1_wire [0:2-1];
reg [NUMWREN+BITVBNK+NUMWREN*WIDTH-1:0] t2_bwA_a1_temp [0:2-1];
reg [NUMWREN+BITVBNK+NUMWREN*WIDTH-1:0] t2_dinA_a1_temp [0:2-1];
integer t2_int, t2d_int;
always_comb
  for (t2_int=0; t2_int<2; t2_int=t2_int+1) begin
    for (t2d_int=0; t2d_int<NUMWREN*WIDTH; t2d_int=t2d_int+1)
      t2_bweA_a1_wire[t2_int][t2d_int] = t2_bwA_a1[t2_int*(NUMWREN*WIDTH+BITVBNK+NUMWREN*WIDTH)+t2d_int];
    for (t2d_int=0; t2d_int<NUMWREN*WIDTH; t2d_int=t2d_int+1)
      t2_datA_a1_wire[t2_int][t2d_int] = t2_dinA_a1[t2_int*(NUMWREN*WIDTH+BITVBNK+NUMWREN*WIDTH)+t2d_int];
    for (t2d_int=0; t2d_int<BITVBNK; t2d_int=t2d_int+1)
      t2_mapA_a1_wire[t2_int][t2d_int] = t2_dinA_a1[t2_int*(NUMWREN*WIDTH+BITVBNK+NUMWREN*WIDTH)+NUMWREN*WIDTH+t2d_int];
    for (t2d_int=0; t2d_int<NUMWREN; t2d_int=t2d_int+1)
      t2_vldA_a1_wire[t2_int][t2d_int] = t2_dinA_a1[t2_int*(NUMWREN*WIDTH+BITVBNK+NUMWREN*WIDTH)+NUMWREN*WIDTH+BITVBNK+t2d_int*WIDTH];
    t2_bwA_a1_temp[t2_int] = {{(NUMWREN+BITVBNK){1'b1}},t2_bweA_a1_wire[t2_int]};
    t2_dinA_a1_temp[t2_int] = {t2_vldA_a1_wire[t2_int],t2_mapA_a1_wire[t2_int],t2_datA_a1_wire[t2_int]};
  end

wire [NUMWREN+BITVBNK+NUMWREN*WIDTH-1:0] t2_doutB_a1_wire [0:2-1];
wire t2_fwrdB_a1_wire [0:2-1];
wire [BITWROW+BITWBNK-1:0] t2_padrB_a1_wire [0:2-1];
wire [NUMWBNK-1:0] t2_writeA_wire [0:2-1];
wire [NUMWBNK*BITWROW-1:0] t2_addrA_wire [0:2-1];
wire [NUMWBNK*(SDOUT_WIDTH+NUMWREN*WIDTH)-1:0] t2_bwA_wire [0:2-1];
wire [NUMWBNK*(SDOUT_WIDTH+NUMWREN*WIDTH)-1:0] t2_dinA_wire [0:2-1];
wire [NUMWBNK-1:0] t2_readB_wire [0:2-1];
wire [NUMWBNK*BITWROW-1:0] t2_addrB_wire [0:2-1];

genvar t2s;
generate for (t2s=0; t2s<2; t2s=t2s+1) begin: t2s_loop
  wire t2_writeA_a1_wire = t2_writeA_a1 >> t2s;
  wire [BITVROW-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> (t2s*BITVROW);
  wire [NUMWREN+BITVBNK-1:0] t2_dinA_a1_wire = t2_dinA_a1_temp[t2s][NUMWREN+BITVBNK+NUMWREN*WIDTH-1:NUMWREN*WIDTH];

  wire t2_readB_a1_wire = t2_readB_a1 >> t2s;
  wire [BITVROW-1:0] t2_addrB_a1_wire = t2_addrB_a1 >> (t2s*BITVROW);

  wire [NUMWBNK*(SDOUT_WIDTH+NUMWREN*WIDTH)-1:0] t2_doutB_temp = t2_doutB >> (t2s*NUMWBNK*(SDOUT_WIDTH+NUMWREN*WIDTH));
  reg [NUMWBNK*SDOUT_WIDTH-1:0] t2_doutB_wire;
  integer t2w_int, t2wd_int;
  always_comb
    for (t2w_int=0; t2w_int<NUMWBNK; t2w_int=t2w_int+1)
      for (t2wd_int=0; t2wd_int<SDOUT_WIDTH; t2wd_int=t2wd_int+1)
        t2_doutB_wire[t2w_int*SDOUT_WIDTH+t2wd_int] = t2_doutB_temp[t2w_int*(SDOUT_WIDTH+NUMWREN*WIDTH)+NUMWREN*WIDTH+t2wd_int];

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
    infra_align_ecc_1r1w #(.WIDTH (NUMWREN+BITVBNK), .ENAPSDO(0), .ENADEC(1), .ECCWDTH(ECCBITS), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITWBNK+BITWROW),
                           .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (0), .FLOPMEM (0), .ENAPADR (1), .RSTZERO (1))
      infra (.write (t2_writeA_a1_wire), .wr_adr (t2_addrA_a1_wire), .din (t2_dinA_a1_wire),
             .read (t2_readB_a1_wire), .rd_adr (t2_addrB_a1_wire), .rd_dout (t2_doutB_a1_wire[t2s][NUMWREN+BITVBNK+NUMWREN*WIDTH-1:NUMWREN*WIDTH]),
             .rd_fwrd (t2_fwrdB_a1_wire[t2s]), .rd_serr(), .rd_derr(), .rd_padr(t2_padrB_a1_wire[t2s]),
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
             .mem_write (t2_writeA_wire[t2s]), .mem_wr_adr (t2_addrA_wire[t2s]),
             .mem_bw(t2_bwA_wire[t2s][SDOUT_WIDTH+NUMWREN*WIDTH-1:NUMWREN*WIDTH]), .mem_din (t2_dinA_wire[t2s][SDOUT_WIDTH+NUMWREN*WIDTH-1:NUMWREN*WIDTH]),
             .mem_read (t2_readB_wire[t2s]), .mem_rd_adr (t2_addrB_wire[t2s]), .mem_rd_dout (t2_doutB_wire),
             .clk (clk), .rst(rst),
             .select_addr (select_vrow));
  end
end
endgenerate

genvar t2d;
generate for (t2d=0; t2d<2; t2d=t2d+1) begin: t2d_loop
  wire t2_writeA_a1_wire = t2_writeA_a1 >> t2d;
  wire [BITVROW-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> (t2d*BITVROW);
  wire [NUMWREN*WIDTH-1:0] t2_bwA_a1_wire = t2_bwA_a1_temp[t2d][NUMWREN*WIDTH-1:0];
  wire [NUMWREN*WIDTH-1:0] t2_dinA_a1_wire = t2_dinA_a1_temp[t2d][NUMWREN*WIDTH-1:0];

  wire t2_readB_a1_wire = t2_readB_a1 >> t2d;
  wire [BITVROW-1:0] t2_addrB_a1_wire = t2_addrB_a1 >> (t2d*BITVROW);

  wire [NUMWBNK*(SDOUT_WIDTH+NUMWREN*WIDTH)-1:0] t2_doutB_temp = t2_doutB >> (t2d*NUMWBNK*(SDOUT_WIDTH+NUMWREN*WIDTH));
  reg [NUMWBNK*NUMWREN*WIDTH-1:0] t2_doutB_wire;
  integer t2w_int, t2wd_int;
  always_comb
    for (t2w_int=0; t2w_int<NUMWBNK; t2w_int=t2w_int+1)
      for (t2wd_int=0; t2wd_int<NUMWREN*WIDTH; t2wd_int=t2wd_int+1)
        t2_doutB_wire[t2w_int*NUMWREN*WIDTH+t2wd_int] = t2_doutB_temp[t2w_int*(SDOUT_WIDTH+NUMWREN*WIDTH)+t2wd_int];

  wire mem_write_wire;
  wire [BITVROW-1:0] mem_wr_adr_wire;
  wire [NUMWREN*WIDTH-1:0] mem_bw_wire;
  wire [NUMWREN*WIDTH-1:0] mem_din_wire;
  wire mem_read_wire;
  wire [BITVROW-1:0] mem_rd_adr_wire;
  wire [NUMWREN*WIDTH-1:0] mem_rd_dout_wire;
  wire mem_rd_fwrd_wire;
  wire mem_rd_serr_wire;
  wire mem_rd_derr_wire;
  wire [(BITWBNK+BITWROW)-1:0] mem_rd_padr_wire;

  if (1) begin: align_loop
    infra_align_bw_1r1w #(.WIDTH (NUMWREN*WIDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                          .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITWBNK+BITWROW),
                          .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (0), .FLOPMEM (0), .ENAPADR (1), .RSTZERO (1))
      infra (.write (t2_writeA_a1_wire), .wr_adr (t2_addrA_a1_wire), .bw (t2_bwA_a1_wire), .din (t2_dinA_a1_wire),
             .read (t2_readB_a1_wire), .rd_adr (t2_addrB_a1_wire), .rd_dout (t2_doutB_a1_wire[t2d][NUMWREN*WIDTH-1:0]),
             .rd_fwrd (t2_fwrdB_a1_wire[t2d]), .rd_serr(), .rd_derr(), .rd_padr(t2_padrB_a1_wire[t2d]),
             .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
             .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
             .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
             .clk (clk), .rst (rst),
             .select_addr (select_vrow));
  end

  if (1) begin: stack_loop
    infra_stack_1r1w #(.WIDTH (NUMWREN*WIDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                       .NUMWROW (NUMWROW), .BITWROW (BITWROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                       .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
      infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
             .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
             .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
             .mem_write (/*t2_writeA_wire[t2d]*/), .mem_wr_adr (/*t2_addrA_wire[t2d]*/),
             .mem_bw(t2_bwA_wire[t2d][NUMWREN*WIDTH-1:0]), .mem_din (t2_dinA_wire[t2d][NUMWREN*WIDTH-1:0]),
             .mem_read (/*t2_readB_wire[t2d]*/), .mem_rd_adr (/*t2_addrB_wire[t2d]*/), .mem_rd_dout (t2_doutB_wire),
             .clk (clk), .rst(rst),
             .select_addr (select_vrow));
  end
end
endgenerate

reg [2*NUMWBNK-1:0] t2_writeA;
reg [2*NUMWBNK*BITWROW-1:0] t2_addrA;
reg [2*NUMWBNK*(SDOUT_WIDTH+NUMWREN*WIDTH)-1:0] t2_bwA;
reg [2*NUMWBNK*(SDOUT_WIDTH+NUMWREN*WIDTH)-1:0] t2_dinA;
reg [2*NUMWBNK-1:0] t2_readB;
reg [2*NUMWBNK*BITWROW-1:0] t2_addrB;

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
  t2_padrB_a1 = 0;
  for (t2_out_int=0; t2_out_int<2; t2_out_int=t2_out_int+1) begin
    t2_writeA = t2_writeA | (t2_writeA_wire[t2_out_int] << t2_out_int*NUMWBNK);
    t2_addrA = t2_addrA | (t2_addrA_wire[t2_out_int] << (t2_out_int*NUMWBNK*BITWROW));
    t2_bwA = t2_bwA | (t2_bwA_wire[t2_out_int] << (t2_out_int*NUMWBNK*(SDOUT_WIDTH+NUMWREN*WIDTH)));
    t2_dinA = t2_dinA | (t2_dinA_wire[t2_out_int] << (t2_out_int*NUMWBNK*(SDOUT_WIDTH+NUMWREN*WIDTH)));
    t2_readB = t2_readB | (t2_readB_wire[t2_out_int] << t2_out_int*NUMWBNK);
    t2_addrB = t2_addrB | (t2_addrB_wire[t2_out_int] << (t2_out_int*NUMWBNK*BITWROW));
    t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2_out_int] << (t2_out_int*(NUMWREN+BITVBNK+NUMWREN*WIDTH)));
    t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_wire[t2_out_int] << t2_out_int);
    t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_wire[t2_out_int] << (t2_out_int*(BITSROW+BITWRDS)));
  end
end

`ifdef FORMAL
`ifdef SREE_COMMENTED_THIS_OUT
generate if (REFRESH) begin: refr_loop
  assert_refr_check: assert property (@(posedge clk) disable iff (!ready) !refr |-> ##[1:REFFREQ-1] refr);
  assert_refr_half_check: assert property (@(posedge clk) disable iff (!ready) refr ##(REFFREQ+REFFRHF) refr |-> ##REFFREQ (!REFFRHF || refr));
  assert_refr_noacc_check: assume property (@(posedge clk) disable iff (!ready) !(refr && (|write || |read)));
end
endgenerate

`endif
`endif

endmodule
