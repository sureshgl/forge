
module algo_nr1w_1rw_rl_a682_top (clk, rst, ready,
                                  read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                                  t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA,
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
  parameter ECCBITS = 4;
  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 2;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;

  parameter BITPADR1 = BITSROW1+BITWRDS1;
  parameter BITPADR  = BITPBNK1+BITPADR1+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK1+1)+ECCBITS;
  parameter CDOUT_WIDTH = 2*WIDTH+ECCWDTH;
  parameter NUMCASH = NUMRDPT+NUMRWPT+NUMWRPT-1;

  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]            read;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]            write;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITADDR-1:0]    addr;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]      din;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]           rd_vld;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]     rd_dout;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]           rd_serr;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]           rd_derr;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0]  rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMVBNK1*NUMRDPT-1:0] t1_readA;
  output [NUMVBNK1*NUMRDPT-1:0] t1_writeA;
  output [NUMVBNK1*NUMRDPT*BITSROW1-1:0] t1_addrA;
  output [NUMVBNK1*NUMRDPT*PHYWDTH1-1:0] t1_bwA;
  output [NUMVBNK1*NUMRDPT*PHYWDTH1-1:0] t1_dinA;
  input [NUMVBNK1*NUMRDPT*PHYWDTH1-1:0] t1_doutA;

  output [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t2_writeA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t2_addrA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t2_bwA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t2_dinA;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] t2_addrB;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*SDOUT_WIDTH-1:0] t2_doutB;

  output [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*CDOUT_WIDTH-1:0] t3_bwA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*CDOUT_WIDTH-1:0] t3_dinA;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrB;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*CDOUT_WIDTH-1:0] t3_doutB;

`ifdef FORMAL 
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

wire [BITVROW1-1:0] select_addr_a2;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1),
  .NUMVROW (NUMVROW1), .BITVROW (BITVROW1))
  adr_a2 (.vbadr(), .vradr(select_addr_a2), .vaddr(select_addr));

`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW1-1:0] select_addr_a2 = 0;
`endif

wire [NUMRDPT+NUMRWPT+NUMWRPT-1:0] rd_fwrd_int;
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*(BITPADR-1)-1:0] rd_padr_int;
reg [BITPADR-2:0] rd_padr_tmp [0:NUMRDPT+NUMRWPT+NUMWRPT-1];
reg [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0] rd_padr;
integer padr_int;
always_comb begin
  rd_padr = 0;
  for (padr_int=0; padr_int<NUMRDPT+NUMRWPT+NUMWRPT; padr_int=padr_int+1) begin
    rd_padr_tmp[padr_int] = rd_padr_int >> (padr_int*(BITPADR-1));
    rd_padr = rd_padr | ({rd_fwrd_int[padr_int],rd_padr_tmp[padr_int]} << (padr_int*BITPADR));
  end
end

wire [2*NUMVBNK1-1:0] t1_readA_a1;
wire [2*NUMVBNK1-1:0] t1_writeA_a1;
wire [2*NUMVBNK1*BITVROW1-1:0] t1_addrA_a1;
wire [2*NUMVBNK1*WIDTH-1:0] t1_dinA_a1;
reg [2*NUMVBNK1*WIDTH-1:0] t1_doutA_a1;
reg [2*NUMVBNK1-1:0] t1_fwrdA_a1;
reg [2*NUMVBNK1-1:0] t1_serrA_a1;
reg [2*NUMVBNK1-1:0] t1_derrA_a1;
reg [2*NUMVBNK1*BITPADR1-1:0] t1_padrA_a1;

wire [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t2_writeA_a1;
wire [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrA_a1;
wire [NUMCASH*(NUMRWPT+NUMWRPT)*(BITVBNK1+1)-1:0] t2_dinA_a1;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB_a1;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t2_addrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*(BITVBNK1+1)-1:0] t2_doutB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_fwrdB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_serrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_derrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR1-1:0] t2_padrB_a1;

wire [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA_a1;
wire [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrA_a1;
wire [NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_dinA_a1;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB_a1;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW1-1:0] t3_addrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_doutB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_fwrdB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_serrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_derrB_a1;
reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR1-1:0] t3_padrB_a1;

wire [NUMVBNK1-1:0] t1_a2_ready;

generate if (1) begin: a1_loop

algo_mrnrwpw_1rw_rl_a682 #(.WIDTH(WIDTH), .BITWDTH(BITWDTH),  .ENAECC (ENAECC), .ENAPSDO (0), .NUMRDPT (NUMRDPT), .NUMRWPT (NUMRWPT), .NUMWRPT (NUMWRPT),
                           .NUMADDR(NUMADDR), .BITADDR(BITADDR), 
                           .NUMVBNK(NUMVBNK1), .BITVBNK(BITVBNK1), .NUMVROW(NUMVROW1), .BITVROW(BITVROW1), .BITPBNK(BITPBNK1), .BITPADR(BITPADR-1),
                           .SRAM_DELAY(SRAM_DELAY+FLOPCMD+FLOPMEM), .DRAM_DELAY(DRAM_DELAY+FLOPCMD+FLOPMEM),
                           .FLOPIN(FLOPIN1), .FLOPOUT(FLOPOUT1))
  algo (.ready(ready), .clk(clk), .rst (rst || !(&t1_a2_ready)),
        .refr (1'b0), .read(read),. write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout),
        .rd_fwrd(rd_fwrd_int), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr_int),
        .t1_readA(t1_readA_a1), .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1), .t1_doutA(t1_doutA_a1),
        .t1_fwrdA(t1_fwrdA_a1), .t1_serrA(t1_serrA_a1), .t1_derrA(t1_derrA_a1), .t1_padrA(t1_padrA_a1), .t1_refrB(),
        .t2_writeA(t2_writeA_a1), .t2_addrA(t2_addrA_a1), .t2_dinA(t2_dinA_a1), .t2_readB(t2_readB_a1), .t2_addrB(t2_addrB_a1),
        .t2_doutB(t2_doutB_a1), .t2_fwrdB(t2_fwrdB_a1), .t2_serrB(t2_serrB_a1), .t2_derrB(t2_derrB_a1), .t2_padrB(t2_padrB_a1),
        .t3_writeA(t3_writeA_a1), .t3_addrA(t3_addrA_a1), .t3_dinA(t3_dinA_a1), .t3_readB(t3_readB_a1), .t3_addrB(t3_addrB_a1),
        .t3_doutB(t3_doutB_a1), .t3_fwrdB(t3_fwrdB_a1), .t3_serrB(t3_serrB_a1), .t3_derrB(t3_derrB_a1), .t3_padrB(t3_padrB_a1),
    	.select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

reg [NUMRDPT-1:0] t1_readA_a1_wire [0:NUMVBNK1-1];
reg t1_writeA_a1_wire [0:NUMVBNK1-1];
reg [NUMRDPT*BITVROW1-1:0] t1_radrA_a1_wire [0:NUMVBNK1-1];
reg [BITVROW1-1:0] t1_wadrA_a1_wire [0:NUMVBNK1-1];
reg [WIDTH-1:0] t1_dinA_a1_wire [0:NUMVBNK1-1];
wire [NUMRDPT*WIDTH-1:0] t1_doutA_a1_wire [0:NUMVBNK1-1];
wire [NUMRDPT-1:0] t1_fwrdA_a1_wire [0:NUMVBNK1-1];
wire [NUMRDPT-1:0] t1_serrA_a1_wire [0:NUMVBNK1-1];
wire [NUMRDPT-1:0] t1_derrA_a1_wire [0:NUMVBNK1-1];
wire [NUMRDPT*BITPADR1-1:0] t1_padrA_a1_wire [0:NUMVBNK1-1];
integer a1_wire_int;
always_comb begin
  t1_doutA_a1 = 0;
  t1_fwrdA_a1 = 0;
  t1_serrA_a1 = 0;
  t1_derrA_a1 = 0;
  t1_padrA_a1 = 0;
  for (a1_wire_int=0; a1_wire_int<NUMVBNK1; a1_wire_int=a1_wire_int+1) begin
    t1_readA_a1_wire[a1_wire_int] = t1_readA_a1 >> (a1_wire_int*2);
    t1_writeA_a1_wire[a1_wire_int] = t1_writeA_a1 >> (a1_wire_int*2);
    t1_radrA_a1_wire[a1_wire_int] = t1_addrA_a1 >> (a1_wire_int*2*BITVROW1);
    t1_wadrA_a1_wire[a1_wire_int] = t1_addrA_a1 >> (a1_wire_int*2*BITVROW1);
    t1_dinA_a1_wire[a1_wire_int] = t1_dinA_a1 >> (a1_wire_int*2*WIDTH);
    t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[a1_wire_int] << (a1_wire_int*2*WIDTH));
    t1_fwrdA_a1 = t1_fwrdA_a1 | (t1_fwrdA_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_serrA_a1 = t1_serrA_a1 | (t1_serrA_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_derrA_a1 = t1_derrA_a1 | (t1_derrA_a1_wire[a1_wire_int] << a1_wire_int*2);
    t1_padrA_a1 = t1_padrA_a1 | (t1_padrA_a1_wire[a1_wire_int] << (a1_wire_int*2*BITPADR1));
  end
end

wire [NUMRDPT-1:0] t1_readA_a2 [0:NUMVBNK1-1];
wire [NUMRDPT-1:0] t1_writeA_a2 [0:NUMVBNK1-1];
wire [NUMRDPT*BITVROW1-1:0] t1_addrA_a2 [0:NUMVBNK1-1];
wire [NUMRDPT*WIDTH-1:0] t1_dinA_a2 [0:NUMVBNK1-1];
reg [NUMRDPT*WIDTH-1:0] t1_doutA_a2 [0:NUMVBNK1-1];
reg [NUMRDPT-1:0] t1_fwrdA_a2 [0:NUMVBNK1-1];
reg [NUMRDPT-1:0] t1_serrA_a2 [0:NUMVBNK1-1];
reg [NUMRDPT-1:0] t1_derrA_a2 [0:NUMVBNK1-1];
reg [NUMRDPT*(BITSROW1+BITWRDS1)-1:0] t1_padrA_a2 [0:NUMVBNK1-1];

genvar a2_int;
generate for (a2_int=0; a2_int<NUMVBNK1; a2_int=a2_int+1) begin: a2_loop

  algo_nror1w_dup #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1), .NUMRDPT (NUMRDPT),
                    .NUMVROW (NUMVROW1), .BITVROW (BITVROW1), .NUMVBNK (1), .BITVBNK (0), .BITPADR (BITPADR1),
                    .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPECC+FLOPMEM), .FLOPIN (0), .FLOPOUT (0))
    algo (.refr (1'b0), .clk (clk), .rst (rst), .ready (t1_a2_ready[a2_int]),
          .write (t1_writeA_a1_wire[a2_int]), .wr_adr (t1_wadrA_a1_wire[a2_int]), .din (t1_dinA_a1_wire[a2_int]),
          .read (t1_readA_a1_wire[a2_int]), .rd_adr (t1_radrA_a1_wire[a2_int]), .rd_vld (), .rd_dout (t1_doutA_a1_wire[a2_int]),
          .rd_fwrd (t1_fwrdA_a1_wire[a2_int]), .rd_serr (t1_serrA_a1_wire[a2_int]), .rd_derr (t1_derrA_a1_wire[a2_int]), .rd_padr (t1_padrA_a1_wire[a2_int]),
          .t1_readA (t1_readA_a2[a2_int]), .t1_writeA (t1_writeA_a2[a2_int]), .t1_addrA (t1_addrA_a2[a2_int]), .t1_dinA (t1_dinA_a2[a2_int]), .t1_doutA (t1_doutA_a2[a2_int]),
          .t1_fwrdA (t1_fwrdA_a2[a2_int]), .t1_serrA (t1_serrA_a2[a2_int]), .t1_derrA (t1_derrA_a2[a2_int]), .t1_padrA (t1_padrA_a2[a2_int]), .t1_refrB (),
          .select_addr (select_addr_a2), .select_bit (select_bit));

end
endgenerate

wire [WIDTH-1:0] t1_doutA_a2_wire [0:NUMVBNK1-1][0:NUMRDPT-1]; 
wire t1_fwrdA_a2_wire [0:NUMVBNK1-1][0:NUMRDPT-1];
wire t1_serrA_a2_wire [0:NUMVBNK1-1][0:NUMRDPT-1];
wire t1_derrA_a2_wire [0:NUMVBNK1-1][0:NUMRDPT-1];
wire [BITSROW1+BITWRDS1-1:0] t1_padrA_a2_wire [0:NUMVBNK1-1][0:NUMRDPT-1];
wire t1_readA_wire [0:NUMVBNK1-1][0:NUMRDPT-1];
wire t1_writeA_wire [0:NUMVBNK1-1][0:NUMRDPT-1];
wire [BITSROW1-1:0] t1_addrA_wire [0:NUMVBNK1-1][0:NUMRDPT-1];
wire [NUMWRDS1*MEMWDTH-1:0] t1_bwA_wire [0:NUMVBNK1-1][0:NUMRDPT-1];
wire [NUMWRDS1*MEMWDTH-1:0] t1_dinA_wire [0:NUMVBNK1-1][0:NUMRDPT-1];
genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMVBNK1; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMRDPT; t1b=t1b+1) begin: t1b_loop
      wire t1_readA_a2_wire = t1_readA_a2[t1r] >> t1b;
      wire t1_writeA_a2_wire = t1_writeA_a2[t1r] >> t1b;
      wire [BITVROW1-1:0] t1_addrA_a2_wire = t1_addrA_a2[t1r] >> (t1b*BITVROW1);
      wire [WIDTH-1:0] t1_dinA_a2_wire = t1_dinA_a2[t1r] >> (t1b*WIDTH);

      wire [NUMWRDS1*MEMWDTH-1:0] t1_doutA_wire = t1_doutA >> ((t1r*NUMRDPT+t1b)*PHYWDTH1);

      if (1) begin: align_loop
        infra_align_ecc_1rw #(.WIDTH (WIDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                              .NUMSROW (NUMSROW1), .BITSROW (BITSROW1), .NUMWRDS (NUMWRDS1), .BITWRDS (BITWRDS1), .BITPADR (BITSROW1+BITWRDS1),
                              .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPCMD(FLOPCMD), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC))
          infra (.write (t1_writeA_a2_wire), .wr_adr (t1_addrA_a2_wire), .din (t1_dinA_a2_wire),
                 .read (t1_readA_a2_wire), .rd_adr (t1_addrA_a2_wire), .rd_dout (t1_doutA_a2_wire[t1r][t1b]),
                 .rd_fwrd (t1_fwrdA_a2_wire[t1r][t1b]), .rd_serr (t1_serrA_a2_wire[t1r][t1b]), .rd_derr (t1_derrA_a2_wire[t1r][t1b]), .rd_padr (t1_padrA_a2_wire[t1r][t1b]),
                 .mem_read (t1_readA_wire[t1r][t1b]), .mem_write (t1_writeA_wire[t1r][t1b]), .mem_addr (t1_addrA_wire[t1r][t1b]),
                 .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]), .mem_dout (t1_doutA_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_addr_a2));
      end
    end
  end
endgenerate

reg [NUMVBNK1*NUMRDPT-1:0] t1_readA;
reg [NUMVBNK1*NUMRDPT-1:0] t1_writeA;
reg [NUMVBNK1*NUMRDPT*BITSROW1-1:0] t1_addrA;
reg [NUMVBNK1*NUMRDPT*PHYWDTH1-1:0] t1_bwA;
reg [NUMVBNK1*NUMRDPT*PHYWDTH1-1:0] t1_dinA;
integer t1r_int, t1b_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  for (t1r_int=0; t1r_int<NUMVBNK1; t1r_int=t1r_int+1) begin
    t1_doutA_a2[t1r_int] = 0;
    t1_fwrdA_a2[t1r_int] = 0;
    t1_serrA_a2[t1r_int] = 0;
    t1_derrA_a2[t1r_int] = 0;
    t1_padrA_a2[t1r_int] = 0;
    for (t1b_int=0; t1b_int<NUMRDPT; t1b_int=t1b_int+1) begin
      t1_readA = t1_readA | (t1_readA_wire[t1r_int][t1b_int] << (t1r_int*NUMRDPT+t1b_int));
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << (t1r_int*NUMRDPT+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*NUMRDPT+t1b_int)*BITSROW1));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*NUMRDPT+t1b_int)*PHYWDTH1));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*NUMRDPT+t1b_int)*PHYWDTH1));
      t1_doutA_a2[t1r_int] = t1_doutA_a2[t1r_int] | (t1_doutA_a2_wire[t1r_int][t1b_int] << (t1b_int*WIDTH));
      t1_fwrdA_a2[t1r_int] = t1_fwrdA_a2[t1r_int] | (t1_fwrdA_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_serrA_a2[t1r_int] = t1_serrA_a2[t1r_int] | (t1_serrA_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_derrA_a2[t1r_int] = t1_derrA_a2[t1r_int] | (t1_derrA_a2_wire[t1r_int][t1b_int] << t1b_int);
      t1_padrA_a2[t1r_int] = t1_padrA_a2[t1r_int] | (t1_padrA_a2_wire[t1r_int][t1b_int] << (t1b_int*(BITSROW1+BITWRDS1)));
    end
  end
end

wire [(NUMRDPT+NUMRWPT+NUMWRPT)*(BITVBNK1+1)-1:0] t2_doutB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_fwrdB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_serrB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_derrB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR1-1:0] t2_padrB_a1_wire [0:NUMCASH-1];
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
    wire [(NUMRWPT+NUMWRPT)*(BITVBNK1+1)-1:0] t2_dinA_a1_wire = t2_dinA_a1 >> (t2c*(NUMRWPT+NUMWRPT)*(BITVBNK1+1));
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
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR1-1:0] mem_rd_padr_t2c_wire;

    if (1) begin: align_loop
      infra_align_ecc_mrnw #(.WIDTH (BITVBNK1+1), .ENAPSDO (NUMWRDS1==1), .ENADEC (1), .ECCWDTH (ECCBITS),
                             .NUMRDPT (NUMRDPT+NUMRWPT+NUMWRPT), .NUMWRPT (NUMRWPT+NUMWRPT), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                             .NUMSROW (NUMSROW1), .BITSROW (BITSROW1), .NUMWRDS (NUMWRDS1), .BITWRDS (BITWRDS1), .BITPADR (BITPADR1),
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
                         .NUMWBNK (1), .BITWBNK (0), .NUMWROW (NUMSROW1), .BITWROW (BITSROW1), .BITPADR (BITPADR1),
                         .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (0), .FLOPMEM (FLOPMEM), .FLOPOUT (0), .RSTZERO (1))
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
    t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2c_int] << (t2c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*(BITVBNK1+1)));
    t2_fwrdB_a1 = t2_fwrdB_a1 | (t2_fwrdB_a1_wire[t2c_int] << (t2c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t2_serrB_a1 = t2_serrB_a1 | (t2_serrB_a1_wire[t2c_int] << (t2c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_wire[t2c_int] << (t2c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR1));
  end
end

wire [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_doutB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_fwrdB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_serrB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_derrB_a1_wire [0:NUMCASH-1];
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR1-1:0] t3_padrB_a1_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)-1:0] t3_writeA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*BITSROW1-1:0] t3_addrA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*CDOUT_WIDTH-1:0] t3_bwA_wire [0:NUMCASH-1];
wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*CDOUT_WIDTH-1:0] t3_dinA_wire [0:NUMCASH-1];
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

    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*CDOUT_WIDTH-1:0] t3_doutB_wire = t3_doutB >> (t3c*(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*CDOUT_WIDTH);

    wire [(NUMRWPT+NUMWRPT)-1:0] mem_write_t3c_wire;
    wire [(NUMRWPT+NUMWRPT)*BITSROW1-1:0] mem_wr_adr_t3c_wire;
    wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*CDOUT_WIDTH-1:0] mem_bw_t3c_wire;
    wire [(NUMRWPT+NUMWRPT)*NUMWRDS1*CDOUT_WIDTH-1:0] mem_din_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_read_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1-1:0] mem_rd_adr_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*NUMWRDS1*CDOUT_WIDTH-1:0] mem_rd_dout_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_fwrd_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_serr_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] mem_rd_derr_t3c_wire;
    wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR1-1:0] mem_rd_padr_t3c_wire;

    if (1) begin: align_loop
      infra_align_ecc_mrnw #(.WIDTH (WIDTH), .ENAPSDO (NUMWRDS1==1), .ENADEC (1), .ECCWDTH (ECCWDTH),
                             .NUMRDPT (NUMRDPT+NUMRWPT+NUMWRPT), .NUMWRPT (NUMRWPT+NUMWRPT), .NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                             .NUMSROW (NUMSROW1), .BITSROW (BITSROW1), .NUMWRDS (NUMWRDS1), .BITWRDS (BITWRDS1), .BITPADR (BITPADR1),
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
      infra_stack_mrnw #(.WIDTH (NUMWRDS1*CDOUT_WIDTH), .ENAPSDO (NUMWRDS1>1), .NUMRDPT (NUMRDPT+NUMRWPT+NUMWRPT), .NUMWRPT (NUMRWPT+NUMWRPT),
                         .NUMADDR (NUMSROW1), .BITADDR (BITSROW1),
                         .NUMWBNK (1), .BITWBNK (0), .NUMWROW (NUMSROW1), .BITWROW (BITSROW1), .BITPADR (BITPADR1),
                         .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (0), .FLOPMEM (FLOPMEM), .FLOPOUT (0), .RSTZERO (1))
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
reg [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*CDOUT_WIDTH-1:0] t3_bwA;
reg [NUMCASH*(NUMRWPT+NUMWRPT)*NUMWRDS1*CDOUT_WIDTH-1:0] t3_dinA;
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
    t3_bwA = t3_bwA | (t3_bwA_wire[t3c_int] << (t3c_int*(NUMRWPT+NUMWRPT)*NUMWRDS1*CDOUT_WIDTH));
    t3_dinA = t3_dinA | (t3_dinA_wire[t3c_int] << (t3c_int*(NUMRWPT+NUMWRPT)*NUMWRDS1*CDOUT_WIDTH));
    t3_readB = t3_readB | (t3_readB_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t3_addrB = t3_addrB | (t3_addrB_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*BITSROW1));
    t3_doutB_a1 = t3_doutB_a1 | (t3_doutB_a1_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH));
    t3_fwrdB_a1 = t3_fwrdB_a1 | (t3_fwrdB_a1_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t3_serrB_a1 = t3_serrB_a1 | (t3_serrB_a1_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)));
    t3_padrB_a1 = t3_padrB_a1 | (t3_padrB_a1_wire[t3c_int] << (t3c_int*(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR1));
  end
end

endmodule

