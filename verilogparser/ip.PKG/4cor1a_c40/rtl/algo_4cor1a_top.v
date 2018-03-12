module algo_4cor1a_top (clk, rst, ready,
                        cnt, ct_adr, imm, ct_vld, ct_serr, ct_derr,
                        read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
			t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMCTPT = 4;
  parameter BITCTPT = 2;
  parameter NUMWRDS = 4;      // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = NUMWRDS*(MEMWDTH);
  parameter NUMWROW = NUMSROW; // STACK Parameters
  parameter BITWROW = BITSROW;
  parameter NUMWBNK = 1;
  parameter BITWBNK = 0;
  parameter SRAM_DELAY = 2;
  parameter FLOPADD = 0;
  parameter FLOPECC = 0;
  parameter FLOPCMD = 0;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  parameter BITPADR = BITCTPT+BITSROW+BITWRDS+1;

  input [NUMCTPT-1:0]                  cnt;
  input [NUMCTPT*BITADDR-1:0]          ct_adr;
  input [NUMCTPT*WIDTH-1:0]            imm;
  output [NUMCTPT-1:0]                 ct_vld;
  output [NUMCTPT-1:0]                 ct_serr;
  output [NUMCTPT-1:0]                 ct_derr;

  input                                read;
  input                                write;
  input [BITADDR-1:0]                  addr;
  input [WIDTH-1:0]                    din;
  output                               rd_vld;
  output [WIDTH-1:0]                   rd_dout;
  output                               rd_serr;
  output                               rd_derr;
  output [BITPADR-1:0]                 rd_padr;

  output                               ready;
  input                                clk, rst;

  output [NUMCTPT-1:0] t1_writeA;
  output [NUMCTPT*BITSROW-1:0] t1_addrA;
  output [NUMCTPT*PHYWDTH-1:0] t1_bwA;
  output [NUMCTPT*PHYWDTH-1:0] t1_dinA;

  output [NUMCTPT-1:0] t1_readB;
  output [NUMCTPT*BITSROW-1:0] t1_addrB;
  input [NUMCTPT*PHYWDTH-1:0] t1_doutB;

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));

wire [BITSROW-1:0] select_srow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
  .NUMVROW (NUMSROW), .BITVROW (BITSROW))
  vrow_inst (.vbadr(), .vradr(select_srow), .vaddr(select_addr));
`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITSROW-1:0] select_srow = 0;
`endif

wire [NUMCTPT-1:0] t1_writeA_a1;
wire [NUMCTPT*BITADDR-1:0] t1_addrA_a1;
wire [NUMCTPT*WIDTH-1:0] t1_dinA_a1;
wire [NUMCTPT-1:0] t1_readB_a1;
wire [NUMCTPT*BITADDR-1:0] t1_addrB_a1;
reg [NUMCTPT*WIDTH-1:0] t1_doutB_a1;
reg [NUMCTPT-1:0] t1_fwrdB_a1;
reg [NUMCTPT-1:0] t1_serrB_a1;
reg [NUMCTPT-1:0] t1_derrB_a1;
reg [NUMCTPT*(BITSROW+BITWRDS)-1:0] t1_padrB_a1;

generate if (1) begin: a1_loop

algo_ncor1a_1r1w #(.BITWDTH (BITWDTH), .WIDTH (WIDTH), .NUMCTPT (NUMCTPT), .BITCTPT (BITCTPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITPADR (BITPADR-1),
                   .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPECC), .FLOPADD (FLOPADD), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
  algo (.clk(clk), .rst(rst), .ready(ready),
        .cnt(cnt), .ct_adr(ct_adr), .imm(imm), .ct_vld(ct_vld), .ct_serr(ct_serr), .ct_derr(ct_derr),
        .read(read), .write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout),
        .rd_fwrd(rd_padr[BITPADR-1]), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr[BITPADR-2:0]),
	.t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
        .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
        .t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1),
	.select_addr(select_addr), .select_bit({BITWDTH{1'b0}}));
end
endgenerate

wire t1_writeA_wire [0:NUMCTPT-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMCTPT-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMCTPT-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMCTPT-1];
wire t1_readB_wire [0:NUMCTPT-1];
wire [BITSROW-1:0] t1_addrB_wire [0:NUMCTPT-1];
wire [WIDTH-1:0] t1_doutB_a1_wire [0:NUMCTPT-1];
wire t1_fwrdB_a1_wire [0:NUMCTPT-1];
wire t1_serrB_a1_wire [0:NUMCTPT-1];
wire t1_derrB_a1_wire [0:NUMCTPT-1];
wire [BITSROW+BITWRDS-1:0] t1_padrB_a1_wire [0:NUMCTPT-1];

genvar t1c;
generate
  for (t1c=0; t1c<NUMCTPT; t1c=t1c+1) begin: t1c_loop
    wire t1_writeA_a1_wire = t1_writeA_a1 >> t1c;
    wire [BITADDR-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (t1c*BITADDR);
    wire [WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (t1c*WIDTH);
    wire t1_readB_a1_wire = t1_readB_a1 >> t1c;
    wire [BITADDR-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> (t1c*BITADDR);

    wire [NUMWRDS*MEMWDTH-1:0] t1_doutB_wire = t1_doutB >> (t1c*PHYWDTH);

    wire mem_write_wire;
    wire [BITSROW-1:0] mem_wr_adr_wire;
    wire [NUMWRDS*MEMWDTH-1:0] mem_bw_wire;
    wire [NUMWRDS*MEMWDTH-1:0] mem_din_wire;
    wire mem_read_wire;
    wire [BITSROW-1:0] mem_rd_adr_wire;
    wire [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_wire;
    wire mem_rd_fwrd_wire;
    wire mem_rd_serr_wire;
    wire mem_rd_derr_wire;
    wire [(BITWBNK+BITWROW)-1:0] mem_rd_padr_wire;

    if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (NUMWRDS==1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .ENAPADR (1),
                             .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                             .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITWBNK+BITWROW),
                             .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (FLOPECC), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (0))
        infra (.write(t1_writeA_a1_wire), .wr_adr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
               .read(t1_readB_a1_wire), .rd_adr(t1_addrB_a1_wire), .rd_dout(t1_doutB_a1_wire[t1c]),
               .rd_fwrd(t1_fwrdB_a1_wire[t1c]), .rd_serr(t1_serrB_a1_wire[t1c]), .rd_derr(t1_derrB_a1_wire[t1c]), .rd_padr(t1_padrB_a1_wire[t1c]),
               .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
               .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
               .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_addr));
    end

    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (NUMWRDS*MEMWDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                         .NUMWROW (NUMWROW), .BITWROW (BITWROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                         .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (0))
        infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
               .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
               .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
               .mem_write (t1_writeA_wire[t1c]), .mem_wr_adr(t1_addrA_wire[t1c]), .mem_bw (t1_bwA_wire[t1c]), .mem_din (t1_dinA_wire[t1c]),
               .mem_read (t1_readB_wire[t1c]), .mem_rd_adr(t1_addrB_wire[t1c]), .mem_rd_dout (t1_doutB_wire),
               .clk (clk), .rst(rst),
               .select_addr (select_srow));
    end
  end
endgenerate

reg [NUMCTPT-1:0] t1_writeA;
reg [NUMCTPT*BITSROW-1:0] t1_addrA;
reg [NUMCTPT*PHYWDTH-1:0] t1_bwA;
reg [NUMCTPT*PHYWDTH-1:0] t1_dinA;
reg [NUMCTPT-1:0] t1_readB;
reg [NUMCTPT*BITSROW-1:0] t1_addrB;
integer t1c_int;
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
  for (t1c_int=0; t1c_int<NUMCTPT; t1c_int=t1c_int+1) begin
    t1_writeA = t1_writeA | (t1_writeA_wire[t1c_int] << t1c_int);
    t1_addrA = t1_addrA | (t1_addrA_wire[t1c_int] << (t1c_int*BITSROW));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1c_int] << (t1c_int*PHYWDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1c_int] << (t1c_int*PHYWDTH));
    t1_readB = t1_readB | (t1_readB_wire[t1c_int] << t1c_int);
    t1_addrB = t1_addrB | (t1_addrB_wire[t1c_int] << (t1c_int*BITSROW));
    t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1c_int] << (t1c_int*WIDTH));
    t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[t1c_int] << t1c_int);
    t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1c_int] << t1c_int);
    t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1c_int] << t1c_int);
    t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1c_int] << (t1c_int*(BITSROW+BITWRDS)));
  end
end

endmodule

