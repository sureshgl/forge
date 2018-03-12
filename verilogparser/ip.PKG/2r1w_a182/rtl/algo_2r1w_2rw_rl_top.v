
module algo_2r1w_2rw_rl_top (clk, rst, ready,
                             refr, read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                             t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA, t1_refrB, t1_ready,
                             t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                             t3_writeA, t3_addrA, t3_bwA, t3_dinA, t3_readB, t3_addrB, t3_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAEXT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMRDPT = 2;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 1;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW1 = 1024;  // ALGO1 Parameters
  parameter BITVROW1 = 10;
  parameter NUMVBNK1 = 8;
  parameter BITVBNK1 = 3;
  parameter BITPBNK1 = 4;
  parameter FLOPIN1 = 0;
  parameter FLOPOUT1 = 0;
  parameter NUMWRDS1 = 1;     // ALIGN Parameters
  parameter BITWRDS1 = 0;
  parameter NUMSROW1 = 1024;
  parameter BITSROW1 = 10;
  parameter PHYWDTH1 = NUMWRDS1*MEMWDTH;
  parameter NUMVROW2 = 256;   // ALGO2 Parameters
  parameter BITVROW2 = 8;
  parameter NUMVBNK2 = 4;
  parameter BITVBNK2 = 2;
  parameter BITPBNK2 = 3;
  parameter FLOPIN2 = 0;
  parameter FLOPOUT2 = 0;
  parameter NUMWRDS2 = 4;     // ALIGN Parameters
  parameter BITWRDS2 = 2;
  parameter NUMSROW2 = 64;
  parameter BITSROW2 = 6;
  parameter PHYWDTH2 = NUMWRDS2*MEMWDTH;
  parameter REFRESH = 0;      // REFRESH Parameters 
  parameter NUMRBNK = 8;
  parameter BITRBNK = 3;
  parameter BITWSPF = 0;
  parameter REFLOPW = 0;
  parameter NUMRROW = 16;
  parameter BITRROW = 4;
  parameter REFFREQ = 16;
  parameter REFFRHF = 0;
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
  parameter ECCBITS = 4;
  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 2;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;

  parameter BITPADR2 = BITPBNK2+BITSROW2+BITWRDS2;
  parameter BITPADR1 = BITPBNK1+BITPADR2+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK1+1)+ECCBITS;
  parameter NUMCASH = NUMRDPT+NUMRWPT+NUMWRPT-1;

  input                                            refr;

  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]            read;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]            write;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITADDR-1:0]    addr;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]      din;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]           rd_vld;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]     rd_dout;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]           rd_serr;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]           rd_derr;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR1-1:0]  rd_padr;

  output                         ready;
  input                          clk, rst;

  output [2*NUMVBNK1-1:0] t1_readA;
  output [2*NUMVBNK1-1:0] t1_writeA;
  output [2*NUMVBNK1*BITVROW1-1:0] t1_addrA;
  output [2*NUMVBNK1*WIDTH-1:0] t1_dinA;
  output [2*NUMVBNK1-1:0] t1_refrB;
  input [2*NUMVBNK1*WIDTH-1:0] t1_doutA;
  input [2*NUMVBNK1-1:0] t1_fwrdA;
  input [2*NUMVBNK1-1:0] t1_serrA;
  input [2*NUMVBNK1-1:0] t1_derrA;
  input [2*NUMVBNK1*BITPADR2-1:0] t1_padrA;
  input [NUMVBNK1-1:0] t1_ready;

  output [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t2_writeA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t2_addrA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t2_bwA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t2_dinA;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] t2_addrB;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t2_doutB;

  output [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*PHYWDTH1-1:0] t3_bwA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*PHYWDTH1-1:0] t3_dinA;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrB;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*PHYWDTH1-1:0] t3_doutB;

`ifdef FORMAL 
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
wire [BITRBNK-1:0] select_rbnk;
wire [BITRROW-1:0] select_rrow;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr == 0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit == 0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));
assume_select_rbnk_range: assume property (@(posedge clk) disable iff (rst) (select_rbnk < NUMRBNK));
assume_select_rbnk_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rbnk));
assume_select_rrow_range: assume property (@(posedge clk) disable iff (rst) (select_rrow < NUMRROW));
assume_select_rrow_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rrow));

wire [BITVROW1-1:0] select_addr_a2;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1),
  .NUMVROW (NUMVROW1), .BITVROW (BITVROW1))
  adr_a2 (.vbadr(), .vradr(select_addr_a2), .vaddr(select_addr));

wire [BITVROW2-1:0] select_vrow_a2;
np2_addr #(
  .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
  .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2),
  .NUMVROW (NUMVROW2), .BITVROW (BITVROW2))
  row_a2 (.vbadr(), .vradr(select_vrow_a2), .vaddr(select_addr_a2));

`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW1-1:0] select_addr_a2 = 0;
wire [BITVROW2-1:0] select_vrow_a2 = 0;
wire [BITRBNK-1:0] select_rbnk = 0;
wire [BITRROW-1:0] select_rrow = 0;
`endif

wire [NUMRDPT+NUMRWPT+NUMWRPT-1:0] rd_fwrd_int;
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*(BITPADR1-1)-1:0] rd_padr_int;
reg [BITPADR1-2:0] rd_padr_tmp [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR1-1:0] rd_padr;
integer padr_int;
always_comb begin
  rd_padr = 0;
  for (padr_int=0; padr_int<NUMRDPT+NUMRWPT+NUMWRPT; padr_int=padr_int+1) begin
    rd_padr_tmp[padr_int] = rd_padr_int << (padr_int*(BITPADR1-1));
    rd_padr = rd_padr | ({rd_fwrd_int[padr_int],rd_padr_tmp[padr_int]} << (padr_int*BITPADR1));
  end
end

wire [2*NUMVBNK1-1:0] t1_readA_a1;
wire [2*NUMVBNK1-1:0] t1_writeA_a1;
wire [2*NUMVBNK1*BITVROW1-1:0] t1_addrA_a1;
wire [2*NUMVBNK1*WIDTH-1:0] t1_dinA_a1;
wire [2*NUMVBNK1-1:0] t1_refrB_a1;
reg [2*NUMVBNK1*WIDTH-1:0] t1_doutA_a1;
reg [2*NUMVBNK1-1:0] t1_fwrdA_a1;
reg [2*NUMVBNK1-1:0] t1_serrA_a1;
reg [2*NUMVBNK1-1:0] t1_derrA_a1;
reg [2*NUMVBNK1*BITPADR2-1:0] t1_padrA_a1;

wire [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t2_writeA_a1;
wire [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrA_a1;
wire [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_dinA_a1;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB_a1;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_fwrdB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_serrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_derrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2-1:0] t2_padrB_a1;

wire [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA_a1;
wire [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrA_a1;
wire [NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_dinA_a1;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB_a1;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_doutB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_fwrdB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_serrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_derrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2-1:0] t3_padrB_a1;

generate if (1) begin: a1_loop

algo_mrnrwpw_1rw_rl #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPSDO (0), .NUMRDPT (NUMRDPT), .NUMRWPT (NUMRWPT), .NUMWRPT (NUMWRPT),
                      .NUMADDR(NUMADDR), .BITADDR(BITADDR),
                      .NUMVBNK(NUMVBNK1), .BITVBNK(BITVBNK1), .NUMVROW(NUMVROW1), .BITVROW(BITVROW1), .BITPBNK(BITPBNK1), .BITPADR(BITPADR1-1),
                      .REFRESH(REFRESH), .SRAM_DELAY(SRAM_DELAY+FLOPCMD+FLOPMEM), .DRAM_DELAY(DRAM_DELAY+FLOPIN2+FLOPOUT2+FLOPMEM),
                      .FLOPIN(FLOPIN1), .FLOPOUT(FLOPOUT1), .ECCBITS(ECCBITS))
  algo (.ready(ready), .clk(clk), .rst (rst || !(&t1_ready)),
        .refr (refr), .read(read),. write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout),
        .rd_fwrd(rd_fwrd_int), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr_int),
        .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
        .t1_fwrdA(t1_fwrdA), .t1_serrA(t1_serrA), .t1_derrA(t1_derrA), .t1_padrA(t1_padrA),
        .t1_refrB(t1_refrB),
        .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1), .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1),
        .t2_doutB(t2_doutB_a1), .t2_fwrdB(t2_fwrdB_a1), .t2_serrB(t2_serrB_a1), .t2_derrB(t2_derrB_a1), .t2_padrB(t2_padrB_a1),
        .t3_writeA(t3_writeA_a1), .t3_addrA(t3_addrA_a1), .t3_dinA(t3_dinA_a1), .t3_readB(t3_readB_a1), .t3_addrB(t3_addrB_a1),
        .t3_doutB(t3_doutB_a1), .t3_fwrdB(t3_fwrdB_a1), .t3_serrB(t3_serrB_a1), .t3_derrB(t3_derrB_a1), .t3_padrB(t3_padrB_a1),
	.select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

wire [(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_fwrdB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_serrB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_derrB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2-1:0] t2_padrB_a1_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)-1:0] t2_writeA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t2_addrA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t2_bwA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t2_dinA_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] t2_addrB_wire [0:NUMCASH-1];

genvar t2c;
generate
  for (t2c=0; t2c<NUMCASH; t2c=t2c+1) begin: t2c_loop
    wire [(NUMRWPT+NUMWRPT)-1:0] t2_writeA_a1_wire = t2_writeA_a1 >> (t2c*(NUMRWPT+NUMWRPT));
    wire [(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> (t2c*(NUMRWPT+NUMWRPT)*BITVROW1);
    wire [(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_dinA_a1_wire = t2_dinA_a1 >> (t2c*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH);
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB_a1_wire = t2_readB_a1 >> (t2c*(NUMRDPT+NUMRWPT+NUMWRPT));
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrB_a1_wire = t2_addrB_a1 >> (t2c*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1);

    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t2_doutB_wire = t2_doutB >> (t2c*(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH);

    wire [(NUMRWPT+NUMWRPT)-1:0] mem_write_t2c_wire;
    wire [(NUMRWPT+NUMWRPT)*BITSROW1-1:0] mem_wr_adr_t2c_wire;
    wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] mem_bw_t2c_wire;
    wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] mem_din_t2c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_read_t2c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] mem_rd_adr_t2c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] mem_rd_dout_t2c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_fwrd_t2c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_serr_t2c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_derr_t2c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2-1:0] mem_rd_padr_t2c_wire;

    if (1) begin: align_loop
      infra_align_ecc_mrnw #(.WIDTH (SDOUT_WIDTH), .ENAPSDO (NUMWRDS1==1), .ENAPAR (0), .ENAECC (0), .ECCWDTH (ECCWDTH),
                             .NUMRDPT (NUMRDPT+NUMRWPT+NUMWRPT), .NUMWRPT (NUMRWPT+NUMWRPT), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                             .NUMSROW (NUMSROW1), .BITSROW (BITSROW1), .NUMWRDS (NUMWRDS1), .BITWRDS (BITWRDS1), .BITPADR (BITPADR2),
                             .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .ENAPADR (1), .RSTZERO (1))
        infra (.write(t2_writeA_a1_wire), .wr_adr(t2_addrA_a1_wire), .din(t2_dinA_a1_wire),
               .read(t2_readB_a1_wire), .rd_adr(t2_addrB_a1_wire),
               .rd_vld(), .rd_dout(t2_doutB_a1_wire[t2c]), .rd_fwrd(t2_fwrdB_a1_wire[t2c]),
               .rd_serr(t2_serrB_a1_wire[t2c]), .rd_derr(t2_derrB_a1_wire[t2c]), .rd_padr(t2_padrB_a1_wire[t2c]),
               .mem_write (mem_write_t2c_wire), .mem_wr_adr(mem_wr_adr_t2c_wire), .mem_bw (mem_bw_t2c_wire), .mem_din (mem_din_t2c_wire),
               .mem_read (mem_read_t2c_wire), .mem_rd_adr(mem_rd_adr_t2c_wire), .mem_rd_dout (mem_rd_dout_t2c_wire),
               .mem_rd_fwrd(mem_rd_fwrd_t2c_wire), .mem_rd_padr(mem_rd_padr_t2c_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_addr_a2));
    end
    if (1) begin: stack_loop
      infra_stack_mrnw #(.WIDTH (NUMWRDS1*SDOUT_WIDTH), .ENAPSDO (NUMWRDS1>1), .NUMRDPT (NUMRDPT+NUMRWPT+NUMWRPT), .NUMWRPT (NUMRWPT+NUMWRPT),
                         .NUMADDR (NUMSROW1), .BITADDR (BITSROW1),
                         .NUMWBNK (1), .BITWBNK (0), .NUMWROW (NUMSROW1), .BITWROW (BITSROW1), .BITPADR (BITPADR2),
                         .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (0), .RSTZERO (1))
        infra (.write (mem_write_t2c_wire), .wr_adr (mem_wr_adr_t2c_wire), .bw (mem_bw_t2c_wire), .din (mem_din_t2c_wire),
               .read (mem_read_t2c_wire), .rd_adr (mem_rd_adr_t2c_wire), .rd_dout (mem_rd_dout_t2c_wire),
               .rd_fwrd (mem_rd_fwrd_t2c_wire), .rd_serr (mem_rd_serr_t2c_wire), .rd_derr (mem_rd_derr_t2c_wire), .rd_padr (mem_rd_padr_t2c_wire),
               .mem_write (t2_writeA_wire[t2c]), .mem_wr_adr(t2_addrA_wire[t2c]), .mem_bw (t2_bwA_wire[t2c]), .mem_din (t2_dinA_wire[t2c]),
               .mem_read (t2_readB_wire[t2c]), .mem_rd_adr(t2_addrB_wire[t2c]), .mem_rd_dout (t2_doutB_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_addr_a2));
    end
  end
endgenerate

reg [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t2_writeA;
reg [NUMCASH*(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t2_addrA;
reg [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t2_bwA;
reg [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t2_dinA;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] t2_addrB;

integer t2c_int;
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
  for (t2c_int=0; t2c_int<NUMCASH; t2c_int=t2c_int+1) begin
    t2_writeA = t2_writeA | (t2_writeA_wire[t2c_int] << (t2c_int*(NUMRWPT+NUMWRPT)));
    t2_addrA = t2_addrA | (t2_addrA_wire[t2c_int] << (t2c_int*(NUMRWPT+NUMWRPT)*BITSROW1));
    t2_bwA = t2_bwA | (t2_bwA_wire[t2c_int] << (t2c_int*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH));
    t2_dinA = t2_dinA | (t2_dinA_wire[t2c_int] << (t2c_int*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH));
    t2_readB = t2_readB | (t2_readB_wire[t2c_int] << (t2c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t2_addrB = t2_addrB | (t2_addrB_wire[t2c_int] << (t2c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1));
    t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2c_int] << (t2c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH));
    t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_wire[t2c_int] << (t2c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t2_serrB_a1 = t2_serrB_a1 | (t2_serrB_a1_wire[t2c_int] << (t2c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_wire[t2c_int] << (t2c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2));
  end
end

wire [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_doutB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_fwrdB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_serrB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_derrB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2-1:0] t3_padrB_a1_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)-1:0] t3_writeA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] t3_bwA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] t3_dinA_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrB_wire [0:NUMCASH-1];

genvar t3c;
generate
  for (t3c=0; t3c<NUMCASH; t3c=t3c+1) begin: t3c_loop
    wire [(NUMRWPT+NUMWRPT)-1:0] t3_writeA_a1_wire = t3_writeA_a1 >> (t3c*(NUMRWPT+NUMWRPT));
    wire [(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrA_a1_wire = t3_addrA_a1 >> (t3c*(NUMRWPT+NUMWRPT)*BITVROW1);
    wire [(NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_dinA_a1_wire = t3_dinA_a1 >> (t3c*(NUMRWPT+NUMWRPT)*WIDTH);
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB_a1_wire = t3_readB_a1 >> (t3c*(NUMRDPT+NUMRWPT+NUMWRPT));
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB_a1_wire = t3_addrB_a1 >> (t3c*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1);

    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] t3_doutB_wire = t3_doutB >> (t3c*(NUMRDPT+NUMRWPT+NUMWRPT)*PHYWDTH1);

    wire [(NUMRWPT+NUMWRPT)-1:0] mem_write_t3c_wire;
    wire [(NUMRWPT+NUMWRPT)*BITSROW1-1:0] mem_wr_adr_t3c_wire;
    wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] mem_bw_t3c_wire;
    wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] mem_din_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_read_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] mem_rd_adr_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] mem_rd_dout_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_fwrd_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_serr_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_derr_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2-1:0] mem_rd_padr_t3c_wire;

    if (1) begin: align_loop
      infra_align_ecc_mrnw #(.WIDTH (WIDTH), .ENAPSDO (NUMWRDS1==1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                             .NUMRDPT (NUMRDPT+NUMRWPT+NUMWRPT), .NUMWRPT (NUMRWPT+NUMWRPT), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                             .NUMSROW (NUMSROW1), .BITSROW (BITSROW1), .NUMWRDS (NUMWRDS1), .BITWRDS (BITWRDS1), .BITPADR (BITPADR2),
                             .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .RSTZERO (1), .ENAPADR (1))
        infra (.write(t3_writeA_a1_wire), .wr_adr(t3_addrA_a1_wire), .din(t3_dinA_a1_wire),
               .read(t3_readB_a1_wire), .rd_adr(t3_addrB_a1_wire),
               .rd_vld(), .rd_dout(t3_doutB_a1_wire[t3c]), .rd_fwrd(t3_fwrdB_a1_wire[t3c]),
               .rd_serr(t3_serrB_a1_wire[t3c]), .rd_derr(t3_derrB_a1_wire[t3c]), .rd_padr(t3_padrB_a1_wire[t3c]),
               .mem_write (mem_write_t3c_wire), .mem_wr_adr(mem_wr_adr_t3c_wire), .mem_bw (mem_bw_t3c_wire), .mem_din (mem_din_t3c_wire),
               .mem_read (mem_read_t3c_wire), .mem_rd_adr(mem_rd_adr_t3c_wire), .mem_rd_dout (mem_rd_dout_t3c_wire),
               .mem_rd_fwrd(mem_rd_fwrd_t3c_wire), .mem_rd_padr(mem_rd_padr_t3c_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_addr_a2));
    end
    if (1) begin: stack_loop
      infra_stack_mrnw #(.WIDTH (NUMWRDS1*MEMWDTH), .ENAPSDO (NUMWRDS1>1), .NUMRDPT (NUMRDPT+NUMRWPT+NUMWRPT), .NUMWRPT (NUMRWPT+NUMWRPT),
                         .NUMADDR (NUMSROW1), .BITADDR (BITSROW1),
                         .NUMWBNK (1), .BITWBNK (0), .NUMWROW (NUMSROW1), .BITWROW (BITSROW1), .BITPADR (BITPADR2),
                         .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (0), .RSTZERO (1))
        infra (.write (mem_write_t3c_wire), .wr_adr (mem_wr_adr_t3c_wire), .bw (mem_bw_t3c_wire), .din (mem_din_t3c_wire),
               .read (mem_read_t3c_wire), .rd_adr (mem_rd_adr_t3c_wire), .rd_dout (mem_rd_dout_t3c_wire),
               .rd_fwrd (mem_rd_fwrd_t3c_wire), .rd_serr (mem_rd_serr_t3c_wire), .rd_derr (mem_rd_derr_t3c_wire), .rd_padr (mem_rd_padr_t3c_wire),
               .mem_write (t3_writeA_wire[t3c]), .mem_wr_adr(t3_addrA_wire[t3c]), .mem_bw (t3_bwA_wire[t3c]), .mem_din (t3_dinA_wire[t3c]),
               .mem_read (t3_readB_wire[t3c]), .mem_rd_adr(t3_addrB_wire[t3c]), .mem_rd_dout (t3_doutB_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_addr_a2));
    end
  end
endgenerate

reg [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA;
reg [NUMCASH*(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrA;
reg [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] t3_bwA;
reg [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*MEMWDTH-1:0] t3_dinA;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrB;

integer t3c_int;
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
  for (t3c_int=0; t3c_int<NUMCASH; t3c_int=t3c_int+1) begin
    t3_writeA = t3_writeA | (t3_writeA_wire[t3c_int] << (t3c_int*(NUMRWPT+NUMWRPT)));
    t3_addrA = t3_addrA | (t3_addrA_wire[t3c_int] << (t3c_int*(NUMRWPT+NUMWRPT)*BITSROW1));
    t3_bwA = t3_bwA | (t3_bwA_wire[t3c_int] << (t3c_int*(NUMRWPT+NUMWRPT)*PHYWDTH1));
    t3_dinA = t3_dinA | (t3_dinA_wire[t3c_int] << (t3c_int*(NUMRWPT+NUMWRPT)*PHYWDTH1));
    t3_readB = t3_readB | (t3_readB_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t3_addrB = t3_addrB | (t3_addrB_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1));
    t3_doutB_a1 = t3_doutB_a1 | (t3_doutB_a1_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH));
    t3_fwrdB_a1 = t3_fwrdB_a1 | (t3_fwrdB_a1_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t3_serrB_a1 = t3_serrB_a1 | (t3_serrB_a1_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t3_padrB_a1 = t3_padrB_a1 | (t3_padrB_a1_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR2));
  end
end

endmodule
