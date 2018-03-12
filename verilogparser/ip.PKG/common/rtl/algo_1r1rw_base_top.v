module algo_1r1rw_base_top (clk, rst, ready,
  rw_read, rw_write, rw_addr, rw_din, rw_vld, rw_dout, rw_serr, rw_derr, rw_padr,
  read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
  t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA,
  t2_readB, t2_writeA, t2_addrA, t2_addrB, t2_bwA, t2_dinA, t2_doutB
);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;   // ALGO Parameters
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMWRDS = 4;      // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;

  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;

  parameter NUMRDPT = 1;

  input  [1-1:0]                       rw_read;
  input  [1-1:0]                       rw_write;
  input  [1*BITADDR-1:0]               rw_addr;
  input  [1*WIDTH-1:0]                 rw_din;
  output [1-1:0]                       rw_vld;
  output [1*WIDTH-1:0]                 rw_dout;
  output [1-1:0]                       rw_serr;
  output [1-1:0]                       rw_derr;
  output [1*BITPADR-1:0]               rw_padr;


  input  [NUMRDPT-1:0]                 read;
  input  [NUMRDPT*BITADDR-1:0]         rd_adr;
  output [NUMRDPT-1:0]                 rd_vld;
  output [NUMRDPT*WIDTH-1:0]           rd_dout;
  output [NUMRDPT-1:0]                 rd_serr;
  output [NUMRDPT-1:0]                 rd_derr;
  output [NUMRDPT*BITPADR-1:0]         rd_padr;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK-1:0]                       t1_readA;
  output [NUMVBNK-1:0]                       t1_writeA;
  output [NUMVBNK*BITVROW-1:0]               t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0]               t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0]               t1_dinA;
  input  [NUMVBNK*PHYWDTH-1:0]               t1_doutA;

  output [NUMRDPT*NUMVBNK-1:0]               t2_writeA;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0]       t2_addrA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]       t2_bwA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]       t2_dinA;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0]       t2_addrB;
  output [NUMRDPT*NUMVBNK-1:0]               t2_readB;
  input  [NUMRDPT*NUMVBNK*PHYWDTH-1:0]       t2_doutB;

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr == 0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit == 0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

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
`endif

wire [2*NUMVBNK-1:0] t1_readA_a1;
wire [2*NUMVBNK-1:0] t1_writeA_a1;
wire [2*NUMVBNK*BITVROW-1:0] t1_addrA_a1;
wire [2*NUMVBNK*WIDTH-1:0] t1_dinA_a1;
reg  [2*NUMVBNK*WIDTH-1:0] t1_doutA_a1;
reg  [2*NUMVBNK-1:0] t1_fwrdA_a1;
reg  [2*NUMVBNK-1:0] t1_serrA_a1;
reg  [2*NUMVBNK-1:0] t1_derrA_a1;
reg  [2*NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrA_a1;

  wire [NUMRDPT+1-1:0]                 rd_vld_wire;
  wire [(NUMRDPT+1)*WIDTH-1:0]         rd_dout_wire;
  wire [NUMRDPT+1-1:0]                 rd_serr_wire;
  wire [NUMRDPT+1-1:0]                 rd_derr_wire;
  wire [NUMRDPT+1-1:0]                 rd_fwrd_wire;
  wire [(NUMRDPT+1)*(BITPADR-1)-1:0]   rd_padr_wire;
 
  wire [NUMRDPT+1-1:0]                 read_wire  = {read,rw_read};
  wire [NUMRDPT+1-1:0]                 write_wire = {{NUMRDPT{1'b0}},rw_write};
  wire [(NUMRDPT+1)*BITADDR-1:0]         addr_wire  = {rd_adr,rw_addr};
  wire [(NUMRDPT+1)*WIDTH-1:0]           din_wire   = {{NUMRDPT*WIDTH{1'b0}},rw_din};
  assign {rd_vld,rw_vld}   = rd_vld_wire;
  assign {rd_dout,rw_dout} = rd_dout_wire;
  assign {rd_serr,rw_serr} = rd_serr_wire;
  assign {rd_derr,rw_derr} = rd_derr_wire;
  assign {rd_padr,rw_padr} = {rd_fwrd_wire[1],rd_padr_wire[2*(BITPADR-1)-1:1*BITPADR-1],rd_fwrd_wire[0],rd_padr_wire[BITPADR-2:0]};

generate if (1) begin: a1_loop

  algo_2rw_base #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
    .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR-1),
    .SRAM_DELAY (SRAM_DELAY+FLOPMEM+FLOPECC), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
  algo (
    .clk(clk), .rst(rst), .ready(ready),
    .read(read_wire), .write(write_wire), .addr(addr_wire), .din(din_wire), .rd_vld(rd_vld_wire), .rd_dout(rd_dout_wire),
    .rd_fwrd(rd_fwrd_wire), .rd_serr(rd_serr_wire), .rd_derr(rd_derr_wire), .rd_padr(rd_padr_wire),
    .t1_readA(t1_readA_a1), .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
    .t1_doutA(t1_doutA_a1), .t1_fwrdA(t1_fwrdA_a1), .t1_serrA(t1_serrA_a1), .t1_derrA(t1_derrA_a1), .t1_padrA(t1_padrA_a1),
    .select_addr(select_addr), .select_bit(select_bit));

end
endgenerate

wire [1-1:0] t1_readA_wire [0:NUMVBNK-1];
wire [1-1:0] t1_writeA_wire [0:NUMVBNK-1];
wire [1*BITSROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
wire [1*NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMVBNK-1];
wire [1*NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];
wire [1*WIDTH-1:0] t1_doutA_wire [0:NUMVBNK-1];
wire [1-1:0] t1_fwrdA_wire [0:NUMVBNK-1];
wire [1-1:0] t1_serrA_wire [0:NUMVBNK-1];
wire [1-1:0] t1_derrA_wire [0:NUMVBNK-1];
wire [1*(BITSROW+BITWRDS)-1:0] t1_padrA_wire [0:NUMVBNK-1];

genvar t1;
generate
  for (t1=0; t1<NUMVBNK; t1=t1+1) begin: t1_loop
    wire [1-1:0] t1_readA_a1_wire = t1_readA_a1 >> (2*t1);
    wire [1-1:0] t1_writeA_a1_wire = t1_writeA_a1 >> (2*t1);
    wire [1*BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (2*t1*BITVROW);
    wire [1*WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (2*t1*WIDTH);

    wire [NUMWRDS*MEMWDTH-1:0] mem_doutA_wire = t1_doutA >> ((1*t1+0)*PHYWDTH);

    if (1) begin: align_loop
      infra_align_ecc_1rw #(.WIDTH (WIDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                            .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                            .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC))
        infra (.read(t1_readA_a1_wire), .write(t1_writeA_a1_wire), .wr_adr(t1_addrA_a1_wire), .rd_adr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
               .rd_dout(t1_doutA_wire[t1]), .rd_fwrd (t1_fwrdA_wire[t1]),
               .rd_serr (t1_serrA_wire[t1]), .rd_derr (t1_derrA_wire[t1]), .rd_padr (t1_padrA_wire[t1]),
               .mem_read(t1_readA_wire[t1]), .mem_write (t1_writeA_wire[t1]), .mem_addr(t1_addrA_wire[t1]),
               .mem_bw (t1_bwA_wire[t1]), .mem_din (t1_dinA_wire[t1]), .mem_dout (mem_doutA_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow));
    end
  end
endgenerate

reg [1*NUMVBNK-1:0] t1_readA;
reg [1*NUMVBNK-1:0] t1_writeA;
reg [1*NUMVBNK*BITSROW-1:0] t1_addrA;
reg [1*NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [1*NUMVBNK*PHYWDTH-1:0] t1_dinA;
integer t1_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin
    t1_readA = t1_readA | (t1_readA_wire[t1_int] << (1*t1_int));
    t1_writeA = t1_writeA | (t1_writeA_wire[t1_int] << (1*t1_int));
    t1_addrA = t1_addrA | (t1_addrA_wire[t1_int] << (1*t1_int*BITSROW));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1_int] << (1*t1_int*PHYWDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1_int] << (1*t1_int*PHYWDTH));
  end
end

wire [1-1:0] t2_readB_wire [0:NUMVBNK-1];
wire [1-1:0] t2_writeA_wire [0:NUMVBNK-1];
wire [1*BITSROW-1:0] t2_addrB_wire [0:NUMVBNK-1];
wire [1*BITSROW-1:0] t2_addrA_wire [0:NUMVBNK-1];
wire [1*NUMWRDS*MEMWDTH-1:0] t2_bwA_wire [0:NUMVBNK-1];
wire [1*NUMWRDS*MEMWDTH-1:0] t2_dinA_wire [0:NUMVBNK-1];
wire [1*WIDTH-1:0] t2_doutB_wire [0:NUMVBNK-1];
wire [1-1:0] t2_fwrdB_wire [0:NUMVBNK-1];
wire [1-1:0] t2_serrB_wire [0:NUMVBNK-1];
wire [1-1:0] t2_derrB_wire [0:NUMVBNK-1];
wire [1*(BITSROW+BITWRDS)-1:0] t2_padrB_wire [0:NUMVBNK-1];

genvar t2;
generate
  for (t2=0; t2<NUMVBNK; t2=t2+1) begin: t2_loop
    wire [1-1:0] t2_readB_a1_wire = t1_readA_a1 >> (2*t2+1);
    wire [1*BITVROW-1:0] t2_addrB_a1_wire = t1_addrA_a1 >> ((2*t2+1)*BITVROW);
    wire [1-1:0] t2_writeA_a1_wire = t1_writeA_a1 >> (2*t2);  // copy writes to t2
    wire [1*BITVROW-1:0] t2_addrA_a1_wire = t1_addrA_a1 >> (2*t2*BITVROW);
    wire [1*WIDTH-1:0] t2_dinA_a1_wire = t1_dinA_a1 >> (2*t2*WIDTH);

    wire [NUMWRDS*MEMWDTH-1:0] mem_doutB_wire = t2_doutB >> ((1*t2+0)*PHYWDTH);

    if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                            .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                            .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC))
        infra (.read(t2_readB_a1_wire), .write(t2_writeA_a1_wire), .wr_adr(t2_addrA_a1_wire), .rd_adr(t2_addrB_a1_wire), .din(t2_dinA_a1_wire),
               .rd_dout(t2_doutB_wire[t2]), .rd_fwrd (t2_fwrdB_wire[t2]),
               .rd_serr (t2_serrB_wire[t2]), .rd_derr (t2_derrB_wire[t2]), .rd_padr (t2_padrB_wire[t2]),
               .mem_read(t2_readB_wire[t2]), .mem_write (t2_writeA_wire[t2]), .mem_wr_adr(t2_addrA_wire[t2]), .mem_rd_adr(t2_addrB_wire[t2]),
               .mem_bw (t2_bwA_wire[t2]), .mem_din (t2_dinA_wire[t2]), .mem_rd_dout (mem_doutB_wire), .mem_rd_fwrd(1'b0), .mem_rd_padr({(BITSROW+BITWRDS){1'b0}}),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow));
    end
  end
endgenerate


reg [1*NUMVBNK-1:0] t2_readB;
reg [1*NUMVBNK*BITSROW-1:0] t2_addrB;
reg [1*NUMVBNK-1:0] t2_writeA;
reg [1*NUMVBNK*BITSROW-1:0] t2_addrA;
reg [1*NUMVBNK*PHYWDTH-1:0] t2_bwA;
reg [1*NUMVBNK*PHYWDTH-1:0] t2_dinA;
integer t2_int;
always_comb begin
  t2_readB = 0;
  t2_writeA = 0;
  t2_addrA = 0;
  t2_addrB = 0;
  t2_bwA = 0;
  t2_dinA = 0;
  for (t2_int=0; t2_int<NUMVBNK; t2_int=t2_int+1) begin
    t2_readB = t2_readB | (t2_readB_wire[t2_int] << (1*t2_int));
    t2_writeA = t2_writeA | (t2_writeA_wire[t2_int] << (1*t2_int));
    t2_addrA = t2_addrA | (t2_addrA_wire[t2_int] << (1*t2_int*BITSROW));
    t2_addrB = t2_addrB | (t2_addrB_wire[t2_int] << (1*t2_int*BITSROW));
    t2_bwA = t2_bwA | (t2_bwA_wire[t2_int] << (1*t2_int*PHYWDTH));
    t2_dinA = t2_dinA | (t2_dinA_wire[t2_int] << (1*t2_int*PHYWDTH));
  end
end

always_comb begin
  integer t1a1_int;
  t1_doutA_a1 = 0;
  t1_fwrdA_a1 = 0;
  t1_serrA_a1 = 0;
  t1_derrA_a1 = 0;
  t1_padrA_a1 = 0;
  for (t1a1_int=0; t1a1_int<NUMVBNK; t1a1_int=t1a1_int+1) begin
    t1_doutA_a1 = t1_doutA_a1 | ({t2_doutB_wire[t1a1_int],t1_doutA_wire[t1a1_int]} << (2*t1a1_int*WIDTH));
    t1_fwrdA_a1 = t1_fwrdA_a1 | ({t2_fwrdB_wire[t1a1_int],t1_fwrdA_wire[t1a1_int]} << (2*t1a1_int*1));
    t1_derrA_a1 = t1_derrA_a1 | ({t2_serrB_wire[t1a1_int],t1_serrA_wire[t1a1_int]} << (2*t1a1_int*1));
    t1_serrA_a1 = t1_serrA_a1 | ({t2_derrB_wire[t1a1_int],t1_derrA_wire[t1a1_int]} << (2*t1a1_int*1));
    t1_padrA_a1 = t1_padrA_a1 | ({t2_padrB_wire[t1a1_int],t1_padrA_wire[t1a1_int]} << (2*t1a1_int*(BITSROW+BITWRDS)));
   end
end


endmodule // algo_1r1rw_base_top
