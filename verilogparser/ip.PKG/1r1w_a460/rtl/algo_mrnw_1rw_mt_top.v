
module algo_mrnw_1rw_mt_top (clk, rst, ready,
                             write, wr_adr, din,
                             read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                             t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA,
                             t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMRDPT = 4;
  parameter NUMWRPT = 4;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;  // ALGO1 Parameters
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMPBNK = 11;
  parameter BITPBNK = 4;
  parameter NUMWRDS = 4;     // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 64;
  parameter BITSROW = 6;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter NUMWROW = NUMSROW; // STACK Parameters
  parameter BITWROW = BITSROW;
  parameter NUMWBNK = 1;
  parameter BITWBNK = 0;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter BITMAPT = BITPBNK*NUMVBNK;

  input [NUMWRPT-1:0]            write;
  input [NUMWRPT*BITADDR-1:0]    wr_adr;
  input [NUMWRPT*WIDTH-1:0]      din;
  input [NUMRDPT-1:0]            read;
  input [NUMRDPT*BITADDR-1:0]    rd_adr;
  output [NUMRDPT-1:0]           rd_vld;
  output [NUMRDPT*WIDTH-1:0]     rd_dout;
  output [NUMRDPT-1:0]           rd_serr;
  output [NUMRDPT-1:0]           rd_derr;
  output [NUMRDPT*BITPADR-1:0]   rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMRDPT*NUMPBNK-1:0] t1_readA;
  output [NUMRDPT*NUMPBNK-1:0] t1_writeA;
  output [NUMRDPT*NUMPBNK*BITSROW-1:0] t1_addrA;
  output [NUMRDPT*NUMPBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMRDPT*NUMPBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMRDPT*NUMPBNK*PHYWDTH-1:0] t1_doutA;

  output [NUMWRPT-1:0] t2_writeA;
  output [NUMWRPT*BITVROW-1:0] t2_addrA;
  output [NUMWRPT*BITMAPT-1:0] t2_dinA;
  output [(NUMRDPT+NUMWRPT)-1:0] t2_readB;
  output [(NUMRDPT+NUMWRPT)*BITVROW-1:0] t2_addrB;
  input [(NUMRDPT+NUMWRPT)*BITMAPT-1:0] t2_doutB;

`ifdef FORMAL 
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  adr_a2 (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));
  
wire [BITSROW-1:0] select_srow;
np2_addr #(
  .NUMADDR (NUMVROW), .BITADDR (BITVROW),
  .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
  .NUMVROW (NUMSROW), .BITVROW (BITSROW))
  vrow_inst (.vbadr(), .vradr(select_srow), .vaddr(select_vrow));

`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW-1:0] select_vrow = 0;
wire [BITSROW-1:0] select_srow = 0;
`endif

wire [NUMRDPT-1:0] rd_fwrd_int;
wire [NUMRDPT*(BITPADR-1)-1:0] rd_padr_int;
reg [BITPADR-2:0] rd_padr_tmp [0:NUMRDPT-1];
reg [NUMRDPT*BITPADR-1:0] rd_padr;
integer padr_int;
always_comb begin
  rd_padr = 0;
  for (padr_int=0; padr_int<NUMRDPT; padr_int=padr_int+1) begin
    rd_padr_tmp[padr_int] = rd_padr_int << (padr_int*(BITPADR-1));
    rd_padr = rd_padr | ({rd_fwrd_int[padr_int],rd_padr_tmp[padr_int]} << (padr_int*BITPADR));
  end
end

wire [NUMRDPT*NUMPBNK-1:0] t1_readA_a1;
wire [NUMRDPT*NUMPBNK-1:0] t1_writeA_a1;
wire [NUMRDPT*NUMPBNK*BITVROW-1:0] t1_addrA_a1;
wire [NUMRDPT*NUMPBNK*MEMWDTH-1:0] t1_dinA_a1;
reg [NUMRDPT*NUMPBNK*MEMWDTH-1:0] t1_doutA_a1;
reg [NUMRDPT*NUMPBNK-1:0] t1_fwrdA_a1;
reg [NUMRDPT*NUMPBNK-1:0] t1_serrA_a1;
reg [NUMRDPT*NUMPBNK-1:0] t1_derrA_a1;
reg [NUMRDPT*NUMPBNK*(BITSROW+BITWRDS)-1:0] t1_padrA_a1;

wire [(NUMRDPT+NUMWRPT)*BITMAPT-1:0] t2_doutB_a1;

generate if (1) begin: a1_loop

  algo_mrnw_1rw_mt #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                     .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
                     .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMPBNK(NUMPBNK), .BITPBNK(BITPBNK), .BITPADR(BITPADR-1),
                     .SRAM_DELAY(SRAM_DELAY+FLOPMEM), .DRAM_DELAY(DRAM_DELAY), .FLOPIN (FLOPIN), .FLOPWRM (0), .FLOPPWR (0), .FLOPOUT(FLOPOUT))
    algo (.ready(ready), .clk(clk), .rst (rst),
          .write(write), .wr_adr(wr_adr), .din(din),
          .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd(rd_fwrd_int), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr_int),
          .t1_readA(t1_readA_a1), .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1), .t1_doutA(t1_doutA_a1),
          .t1_fwrdA(t1_fwrdA_a1), .t1_serrA(t1_serrA_a1), .t1_derrA(t1_derrA_a1), .t1_padrA(t1_padrA_a1),
          .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB_a1),
          .select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

wire [MEMWDTH-1:0] t1_doutA_a1_wire [0:NUMRDPT-1][0:NUMPBNK-1];
wire t1_fwrdA_a1_wire [0:NUMRDPT-1][0:NUMPBNK-1];
wire t1_serrA_a1_wire [0:NUMRDPT-1][0:NUMPBNK-1];
wire t1_derrA_a1_wire [0:NUMRDPT-1][0:NUMPBNK-1];
wire [BITSROW+BITWRDS-1:0] t1_padrA_a1_wire [0:NUMRDPT-1][0:NUMPBNK-1];
wire t1_readA_wire [0:NUMRDPT-1][0:NUMPBNK-1];
wire t1_writeA_wire [0:NUMRDPT-1][0:NUMPBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMRDPT-1][0:NUMPBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMRDPT-1][0:NUMPBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMRDPT-1][0:NUMPBNK-1];

genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMRDPT; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMPBNK; t1b=t1b+1) begin: t1b_loop
      wire t1_readA_a1_wire = t1_readA_a1 >> (t1r*NUMPBNK+t1b);
      wire t1_writeA_a1_wire = t1_writeA_a1 >> (t1r*NUMPBNK+t1b);
      wire [BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> ((t1r*NUMPBNK+t1b)*BITVROW);
      wire [MEMWDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> ((t1r*NUMPBNK+t1b)*MEMWDTH); 

      wire [NUMWRDS*MEMWDTH-1:0] t1_doutA_wire = t1_doutA >> ((t1r*NUMPBNK+t1b)*PHYWDTH);

      if (1) begin: align_loop
        infra_align_ecc_1rw #(.WIDTH (MEMWDTH), .ENAPAR (0), .ENAECC (0), .ECCWDTH (ECCWDTH),
                              .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                              .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITWBNK+BITWROW),
                              .SRAM_DELAY (DRAM_DELAY), .FLOPGEN (0), .FLOPMEM (0), .FLOPOUT (FLOPECC))
          infra (.write(t1_writeA_a1_wire), .wr_adr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
                 .read(t1_readA_a1_wire), .rd_adr(t1_addrA_a1_wire), .rd_dout(t1_doutA_a1_wire[t1r][t1b]), .rd_fwrd(t1_fwrdA_a1_wire[t1r][t1b]),
                 .rd_serr(t1_serrA_a1_wire[t1r][t1b]), .rd_derr(t1_derrA_a1_wire[t1r][t1b]), .rd_padr(t1_padrA_a1_wire[t1r][t1b]),
                 .mem_read (t1_readA_wire[t1r][t1b]), .mem_write (t1_writeA_wire[t1r][t1b]), .mem_addr(t1_addrA_wire[t1r][t1b]),
                 .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]), .mem_dout (t1_doutA_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
      end
    end
  end
endgenerate

reg [NUMRDPT*NUMPBNK-1:0] t1_readA;
reg [NUMRDPT*NUMPBNK-1:0] t1_writeA;
reg [NUMRDPT*NUMPBNK*BITSROW-1:0] t1_addrA;
reg [NUMRDPT*NUMPBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMRDPT*NUMPBNK*PHYWDTH-1:0] t1_dinA;
integer t1r_int, t1b_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_doutA_a1 = 0;
  t1_fwrdA_a1 = 0;
  t1_serrA_a1 = 0;
  t1_derrA_a1 = 0;
  t1_padrA_a1 = 0;
  for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
    for (t1b_int=0; t1b_int<NUMPBNK; t1b_int=t1b_int+1) begin
      t1_readA = t1_readA | (t1_readA_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*BITSROW));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*PHYWDTH));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*PHYWDTH));
      t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*MEMWDTH));
      t1_fwrdA_a1 = t1_fwrdA_a1 | (t1_fwrdA_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_serrA_a1 = t1_serrA_a1 | (t1_serrA_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_derrA_a1 = t1_derrA_a1 | (t1_derrA_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMPBNK+t1b_int));
      t1_padrA_a1 = t1_padrA_a1 | (t1_padrA_a1_wire[t1r_int][t1b_int] << ((t1r_int*NUMPBNK+t1b_int)*(BITSROW+BITWRDS)));
    end
  end
end

generate if (FLOPMEM) begin: t2_flp_loop
  reg [(NUMRDPT+NUMWRPT)*BITMAPT-1:0] t2_doutB_reg;
  always @(posedge clk) begin
    t2_doutB_reg <= t2_doutB;
  end

  assign t2_doutB_a1 = t2_doutB_reg;
end else begin: t2_noflp_loop
  assign t2_doutB_a1 = t2_doutB;
end
endgenerate

endmodule
