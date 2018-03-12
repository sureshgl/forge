
module algo_2rw_base_top (clk, rst, ready,
                          read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                  t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA);
  
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

  input [2-1:0]                        read;
  input [2-1:0]                        write;
  input [2*BITADDR-1:0]                addr;
  input [2*WIDTH-1:0]                  din;
  output [2-1:0]                       rd_vld;
  output [2*WIDTH-1:0]                 rd_dout;
  output [2-1:0]                       rd_serr;
  output [2-1:0]                       rd_derr;
  output [2*BITPADR-1:0]               rd_padr;

  output                               ready;
  input                                clk, rst;

  output [2*NUMVBNK-1:0]               t1_readA;
  output [2*NUMVBNK-1:0]               t1_writeA;
  output [2*NUMVBNK*BITVROW-1:0]       t1_addrA;
  output [2*NUMVBNK*PHYWDTH-1:0]       t1_bwA;
  output [2*NUMVBNK*PHYWDTH-1:0]       t1_dinA;
  input [2*NUMVBNK*PHYWDTH-1:0]        t1_doutA;

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
reg [2*NUMVBNK*WIDTH-1:0] t1_doutA_a1;
reg [2*NUMVBNK-1:0] t1_fwrdA_a1;
reg [2*NUMVBNK-1:0] t1_serrA_a1;
reg [2*NUMVBNK-1:0] t1_derrA_a1;
reg [2*NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrA_a1;

generate if (1) begin: a1_loop

algo_2rw_base #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR-1),
                .SRAM_DELAY (SRAM_DELAY+FLOPMEM+FLOPECC), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    algo (.clk(clk), .rst(rst), .ready(ready),
          .read(read), .write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd({rd_padr[2*BITPADR-1],rd_padr[BITPADR-1]}), .rd_serr(rd_serr), .rd_derr(rd_derr),
          .rd_padr({rd_padr[2*BITPADR-2:BITPADR],rd_padr[BITPADR-2:0]}),
          .t1_readA(t1_readA_a1), .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_doutA(t1_doutA_a1), .t1_fwrdA(t1_fwrdA_a1), .t1_serrA(t1_serrA_a1), .t1_derrA(t1_derrA_a1), .t1_padrA(t1_padrA_a1),
	  .select_addr(select_addr), .select_bit(select_bit));

end
endgenerate

wire [2-1:0] t1_readA_wire [0:NUMVBNK-1];
wire [2-1:0] t1_writeA_wire [0:NUMVBNK-1];
wire [2*BITSROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
wire [2*NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMVBNK-1];
wire [2*NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];
wire [2*WIDTH-1:0] t1_doutA_a1_wire [0:NUMVBNK-1];
wire [2-1:0] t1_fwrdA_a1_wire [0:NUMVBNK-1];
wire [2-1:0] t1_serrA_a1_wire [0:NUMVBNK-1];
wire [2-1:0] t1_derrA_a1_wire [0:NUMVBNK-1];
wire [2*(BITSROW+BITWRDS)-1:0] t1_padrA_a1_wire [0:NUMVBNK-1];

genvar t1;
generate
  for (t1=0; t1<NUMVBNK; t1=t1+1) begin: t1_loop
    wire [2-1:0] t1_readA_a1_wire = t1_readA_a1 >> (2*t1);
    wire [2-1:0] t1_writeA_a1_wire = t1_writeA_a1 >> (2*t1);
    wire [2*BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (2*t1*BITVROW);
    wire [2*WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (2*t1*WIDTH);

    wire [NUMWRDS*MEMWDTH-1:0] t1_doutA_wire_0 = t1_doutA >> ((2*t1+0)*PHYWDTH);
    wire [NUMWRDS*MEMWDTH-1:0] t1_doutA_wire_1 = t1_doutA >> ((2*t1+1)*PHYWDTH);
    wire [2*NUMWRDS*MEMWDTH-1:0] t1_doutA_wire = {t1_doutA_wire_1,t1_doutA_wire_0};

    if (1) begin: align_loop
      infra_align_ecc_2rw #(.WIDTH (WIDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                            .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                            .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC))
        infra (.read(t1_readA_a1_wire), .write(t1_writeA_a1_wire), .addr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
               .rd_dout(t1_doutA_a1_wire[t1]), .rd_fwrd (t1_fwrdA_a1_wire[t1]),
               .rd_serr (t1_serrA_a1_wire[t1]), .rd_derr (t1_derrA_a1_wire[t1]), .rd_padr (t1_padrA_a1_wire[t1]),
               .mem_read(t1_readA_wire[t1]), .mem_write (t1_writeA_wire[t1]), .mem_addr(t1_addrA_wire[t1]),
               .mem_bw (t1_bwA_wire[t1]), .mem_din (t1_dinA_wire[t1]), .mem_dout (t1_doutA_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow));
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
  t1_doutA_a1 = 0;
  t1_fwrdA_a1 = 0;
  t1_serrA_a1 = 0;
  t1_derrA_a1 = 0;
  t1_padrA_a1 = 0;
  for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin
    t1_readA = t1_readA | (t1_readA_wire[t1_int] << (2*t1_int));
    t1_writeA = t1_writeA | (t1_writeA_wire[t1_int] << (2*t1_int));
    t1_addrA = t1_addrA | (t1_addrA_wire[t1_int] << (2*t1_int*BITSROW));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1_int] << (2*t1_int*PHYWDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1_int] << (2*t1_int*PHYWDTH));
    t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[t1_int] << (2*t1_int*WIDTH));
    t1_fwrdA_a1 = t1_fwrdA_a1 | (t1_fwrdA_a1_wire[t1_int] << (2*t1_int));
    t1_serrA_a1 = t1_serrA_a1 | (t1_serrA_a1_wire[t1_int] << (2*t1_int));
    t1_derrA_a1 = t1_derrA_a1 | (t1_derrA_a1_wire[t1_int] << (2*t1_int));
    t1_padrA_a1 = t1_padrA_a1 | (t1_padrA_a1_wire[t1_int] << (2*t1_int*(BITSROW+BITWRDS)));
  end
end

endmodule
