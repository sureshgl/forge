
module algo_2r1w_xr_top (clk, rst, ready,
                         write, wr_adr, din,
                         read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                 t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA,
	                 t1_readB, t1_writeB, t1_addrB, t1_bwB, t1_dinB, t1_doutB,
	                 t2_readA, t2_writeA, t2_addrA, t2_bwA, t2_dinA, t2_doutA,
	                 t2_readB, t2_writeB, t2_addrB, t2_bwB, t2_dinB, t2_doutB);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
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
  parameter PARITY = 1;       // PARITY Parameters
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;
  parameter PHYWDTH = 260;

  parameter MEMWDTH = WIDTH+PARITY;
  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  input                          write;
  input [BITADDR-1:0]            wr_adr;
  input [WIDTH-1:0]              din;

  input [2-1:0]                  read;
  input [2*BITADDR-1:0]          rd_adr;
  output [2-1:0]                 rd_vld;
  output [2*WIDTH-1:0]           rd_dout;
  output [2-1:0]                 rd_serr;
  output [2-1:0]                 rd_derr;
  output [2*BITPADR-1:0]         rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMVBNK*PHYWDTH-1:0] t1_doutA;

  output [NUMVBNK-1:0] t1_readB;
  output [NUMVBNK-1:0] t1_writeB;
  output [NUMVBNK*BITSROW-1:0] t1_addrB;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwB;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinB;
  input [NUMVBNK*PHYWDTH-1:0] t1_doutB;

  output [1-1:0] t2_readA;
  output [1-1:0] t2_writeA;
  output [1*BITSROW-1:0] t2_addrA;
  output [1*PHYWDTH-1:0] t2_bwA;
  output [1*PHYWDTH-1:0] t2_dinA;
  input [1*PHYWDTH-1:0] t2_doutA;

  output [1-1:0] t2_readB;
  output [1-1:0] t2_writeB;
  output [1*BITSROW-1:0] t2_addrB;
  output [1*PHYWDTH-1:0] t2_bwB;
  output [1*PHYWDTH-1:0] t2_dinB;
  input [1*PHYWDTH-1:0] t2_doutB;

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr == 0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit == 0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
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

wire [NUMVBNK-1:0] t1_readA_a1;
wire [NUMVBNK-1:0] t1_writeA_a1;
wire [NUMVBNK*BITVROW-1:0] t1_addrA_a1;
wire [NUMVBNK*WIDTH-1:0] t1_dinA_a1;
reg [NUMVBNK*WIDTH-1:0] t1_doutA_a1;
reg [NUMVBNK-1:0] t1_serrA_a1;
reg [NUMVBNK-1:0] t1_derrA_a1;
reg [NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrA_a1;
  
wire [NUMVBNK-1:0] t1_readB_a1;
wire [NUMVBNK-1:0] t1_writeB_a1;
wire [NUMVBNK*BITVROW-1:0] t1_addrB_a1;
wire [NUMVBNK*WIDTH-1:0] t1_dinB_a1;
reg [NUMVBNK*WIDTH-1:0] t1_doutB_a1;
reg [NUMVBNK-1:0] t1_serrB_a1;
reg [NUMVBNK-1:0] t1_derrB_a1;
reg [NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrB_a1;
  
wire t2_readA_a1;
wire t2_writeA_a1;
wire [BITVROW-1:0] t2_addrA_a1;
wire [WIDTH-1:0] t2_dinA_a1;
reg [WIDTH-1:0] t2_doutA_a1;
reg t2_serrA_a1;
reg t2_derrA_a1;
reg [(BITSROW+BITWRDS)-1:0] t2_padrA_a1;

wire t2_readB_a1;
wire t2_writeB_a1;
wire [BITVROW-1:0] t2_addrB_a1;
wire [WIDTH-1:0] t2_dinB_a1;
reg [WIDTH-1:0] t2_doutB_a1;
reg t2_serrB_a1;
reg t2_derrB_a1;
reg [(BITSROW+BITWRDS)-1:0] t2_padrB_a1;

generate if (1) begin: a1_loop

algo_nr1w_2rw #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMVRPT (2), .NUMPRPT (1),
                .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK),
                .BITPADR (BITPADR), .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    algo (.clk (clk), .rst (rst), .ready (ready),
          .write1 (write), .read1 (1'b0), .addr1 (wr_adr), .din1 (din), .rd1_dout (), .rd1_serr (), .rd1_derr (), .rd1_padr (),
          .read2 (read), .addr2 (rd_adr), .rd2_vld (rd_vld), .rd2_dout (rd_dout), .rd2_serr (rd_serr), .rd2_derr (rd_derr), .rd2_padr (rd_padr),
          .t1_readA (t1_readA_a1), .t1_writeA (t1_writeA_a1), .t1_addrA (t1_addrA_a1), .t1_dinA (t1_dinA_a1),
          .t1_doutA (t1_doutA_a1), .t1_serrA (t1_serrA_a1), .t1_derrA (t1_derrA_a1), .t1_padrA (t1_padrA_a1),
          .t1_readB (t1_readB_a1), .t1_writeB (t1_writeB_a1), .t1_addrB (t1_addrB_a1), .t1_dinB (t1_dinB_a1),
          .t1_doutB (t1_doutB_a1), .t1_serrB (t1_serrB_a1), .t1_derrB (t1_derrB_a1), .t1_padrB (t1_padrB_a1),
          .t2_readA (t2_readA_a1), .t2_writeA (t2_writeA_a1), .t2_addrA (t2_addrA_a1), .t2_dinA (t2_dinA_a1),
          .t2_doutA (t2_doutA_a1), .t2_serrA (t2_serrA_a1), .t2_derrA (t2_derrA_a1), .t2_padrA (t2_padrA_a1),
          .t2_readB (t2_readB_a1), .t2_writeB (t2_writeB_a1), .t2_addrB (t2_addrB_a1), .t2_dinB (t2_dinB_a1),
          .t2_doutB (t2_doutB_a1), .t2_serrB (t2_serrB_a1), .t2_derrB (t2_derrB_a1), .t2_padrB (t2_padrB_a1),
          .select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

wire [WIDTH-1:0] t1_doutA_a1_wire [0:NUMVBNK-1];
wire t1_serrA_a1_wire [0:NUMVBNK-1];
wire t1_derrA_a1_wire [0:NUMVBNK-1];
wire [(BITSROW+BITWRDS)-1:0] t1_padrA_a1_wire [0:NUMVBNK-1];
wire t1_readA_wire [0:NUMVBNK-1];
wire t1_writeA_wire [0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];

wire [WIDTH-1:0] t1_doutB_a1_wire [0:NUMVBNK-1];
wire t1_serrB_a1_wire [0:NUMVBNK-1];
wire t1_derrB_a1_wire [0:NUMVBNK-1];
wire [(BITSROW+BITWRDS)-1:0] t1_padrB_a1_wire [0:NUMVBNK-1];
wire t1_readB_wire [0:NUMVBNK-1];
wire t1_writeB_wire [0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrB_wire [0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwB_wire [0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinB_wire [0:NUMVBNK-1];

genvar t1;
generate for (t1=0; t1<NUMVBNK; t1=t1+1) begin: t1_loop
  wire t1_readA_a1_wire = t1_readA_a1 >> t1;
  wire t1_writeA_a1_wire = t1_writeA_a1 >> t1;
  wire [BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (t1*BITVROW);
  wire [WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (t1*WIDTH);

  wire t1_readB_a1_wire = t1_readB_a1 >> t1;
  wire t1_writeB_a1_wire = t1_writeB_a1 >> t1;
  wire [BITVROW-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> (t1*BITVROW);
  wire [WIDTH-1:0] t1_dinB_a1_wire = t1_dinB_a1 >> (t1*WIDTH);

  wire [NUMWRDS*MEMWDTH-1:0] t1_doutA_wire = t1_doutA >> (t1*PHYWDTH);
  wire [NUMWRDS*MEMWDTH-1:0] t1_doutB_wire = t1_doutB >> (t1*PHYWDTH);

  if (1) begin: align_loop
    infra_align_2rw #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                      .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                      .SRAM_DELAY (SRAM_DELAY), .FLOPMEM (FLOPMEM), .RSTZERO (1))
        infra (.read ({t1_readB_a1_wire,t1_readA_a1_wire}), .write ({t1_writeB_a1_wire,t1_writeA_a1_wire}), .addr ({t1_addrB_a1_wire,t1_addrA_a1_wire}),
               .din ({t1_dinB_a1_wire,t1_dinA_a1_wire}), .dout ({t1_doutB_a1_wire[t1],t1_doutA_a1_wire[t1]}),
               .serr ({t1_serrB_a1_wire[t1],t1_serrA_a1_wire[t1]}), .padr ({t1_padrB_a1_wire[t1],t1_padrA_a1_wire[t1]}),
               .mem_read ({t1_readB_wire[t1],t1_readA_wire[t1]}), .mem_write ({t1_writeB_wire[t1],t1_writeA_wire[t1]}),
               .mem_addr ({t1_addrB_wire[t1],t1_addrA_wire[t1]}), .mem_bw ({t1_bwB_wire[t1],t1_bwA_wire[t1]}),
               .mem_din ({t1_dinB_wire[t1],t1_dinA_wire[t1]}), .mem_dout ({t1_doutB_wire,t1_doutA_wire}),
	       .select_addr (select_vrow),
               .clk (clk), .rst (rst));
    assign t1_derrA_a1_wire[t1] = 1'b0;
    assign t1_derrB_a1_wire[t1] = 1'b0;
  end
end
endgenerate

reg [NUMVBNK-1:0] t1_readA;
reg [NUMVBNK-1:0] t1_writeA;
reg [NUMVBNK*BITSROW-1:0] t1_addrA;
reg [NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMVBNK*PHYWDTH-1:0] t1_dinA;
reg [NUMVBNK-1:0] t1_readB;
reg [NUMVBNK-1:0] t1_writeB;
reg [NUMVBNK*BITSROW-1:0] t1_addrB;
reg [NUMVBNK*PHYWDTH-1:0] t1_bwB;
reg [NUMVBNK*PHYWDTH-1:0] t1_dinB;

integer t1_out_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_readB = 0;
  t1_writeB = 0;
  t1_addrB = 0;
  t1_bwB = 0;
  t1_dinB = 0;
  t1_doutA_a1 = 0;
  t1_serrA_a1 = 0;
  t1_derrA_a1 = 0;
  t1_padrA_a1 = 0;
  t1_doutB_a1 = 0;
  t1_serrB_a1 = 0;
  t1_derrB_a1 = 0;
  t1_padrB_a1 = 0;
  for (t1_out_int=0; t1_out_int<NUMVBNK; t1_out_int=t1_out_int+1) begin
    t1_readA = t1_readA | (t1_readA_wire[t1_out_int] << t1_out_int);
    t1_writeA = t1_writeA | (t1_writeA_wire[t1_out_int] << t1_out_int);
    t1_addrA = t1_addrA | (t1_addrA_wire[t1_out_int] << (t1_out_int*BITSROW));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_readB = t1_readB | (t1_readB_wire[t1_out_int] << t1_out_int);
    t1_writeB = t1_writeB | (t1_writeB_wire[t1_out_int] << t1_out_int);
    t1_addrB = t1_addrB | (t1_addrB_wire[t1_out_int] << (t1_out_int*BITSROW));
    t1_bwB = t1_bwB | (t1_bwB_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_dinB = t1_dinB | (t1_dinB_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[t1_out_int] << (t1_out_int*WIDTH));
    t1_serrA_a1 = t1_serrA_a1 | (t1_serrA_a1_wire[t1_out_int] << t1_out_int);
    t1_derrA_a1 = t1_derrA_a1 | (t1_derrA_a1_wire[t1_out_int] << t1_out_int);
    t1_padrA_a1 = t1_padrA_a1 | (t1_padrA_a1_wire[t1_out_int] << (t1_out_int*(BITSROW+BITWRDS)));
    t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1_out_int] << (t1_out_int*WIDTH));
    t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1_out_int] << t1_out_int);
    t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1_out_int] << t1_out_int);
    t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1_out_int] << (t1_out_int*(BITSROW+BITWRDS)));
  end
end

wire [WIDTH-1:0] t2_doutA_a1_wire [0:1-1];
wire t2_serrA_a1_wire [0:1-1];
wire t2_derrA_a1_wire [0:1-1];
wire [(BITSROW+BITWRDS)-1:0] t2_padrA_a1_wire [0:1-1];
wire t2_readA_wire [0:1-1];
wire t2_writeA_wire [0:1-1];
wire [BITSROW-1:0] t2_addrA_wire [0:1-1];
wire [NUMWRDS*MEMWDTH-1:0] t2_bwA_wire [0:1-1];
wire [NUMWRDS*MEMWDTH-1:0] t2_dinA_wire [0:1-1];

wire [WIDTH-1:0] t2_doutB_a1_wire [0:1-1];
wire t2_serrB_a1_wire [0:1-1];
wire t2_derrB_a1_wire [0:1-1];
wire [(BITSROW+BITWRDS)-1:0] t2_padrB_a1_wire [0:1-1];
wire t2_readB_wire [0:1-1];
wire t2_writeB_wire [0:1-1];
wire [BITSROW-1:0] t2_addrB_wire [0:1-1];
wire [NUMWRDS*MEMWDTH-1:0] t2_bwB_wire [0:1-1];
wire [NUMWRDS*MEMWDTH-1:0] t2_dinB_wire [0:1-1];

genvar t2;
generate for (t2=0; t2<1; t2=t2+1) begin: t2_loop
  wire t2_readA_a1_wire = t2_readA_a1 >> t2;
  wire t2_writeA_a1_wire = t2_writeA_a1 >> t2;
  wire [BITVROW-1:0] t2_addrA_a1_wire = t2_addrA_a1 >> (t2*BITVROW);
  wire [WIDTH-1:0] t2_dinA_a1_wire = t2_dinA_a1 >> (t2*WIDTH);

  wire t2_readB_a1_wire = t2_readB_a1 >> t2;
  wire t2_writeB_a1_wire = t2_writeB_a1 >> t2;
  wire [BITVROW-1:0] t2_addrB_a1_wire = t2_addrB_a1 >> (t2*BITVROW);
  wire [WIDTH-1:0] t2_dinB_a1_wire = t2_dinB_a1 >> (t2*WIDTH);

  wire [NUMWRDS*MEMWDTH-1:0] t2_doutA_wire = t2_doutA >> (t2*PHYWDTH);
  wire [NUMWRDS*MEMWDTH-1:0] t2_doutB_wire = t2_doutB >> (t2*PHYWDTH);

  if (1) begin: align_loop
    infra_align_2rw #(.WIDTH (WIDTH), .PARITY (PARITY), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                      .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                      .SRAM_DELAY (SRAM_DELAY), .FLOPMEM (FLOPMEM), .RSTZERO (1))
        infra (.read ({t2_readB_a1_wire,t2_readA_a1_wire}), .write ({t2_writeB_a1_wire,t2_writeA_a1_wire}), .addr ({t2_addrB_a1_wire,t2_addrA_a1_wire}),
               .din ({t2_dinB_a1_wire,t2_dinA_a1_wire}), .dout ({t2_doutB_a1_wire[t2],t2_doutA_a1_wire[t2]}), .serr ({t2_serrB_a1_wire[t2],t2_serrA_a1_wire[t2]}),
               .padr ({t2_padrB_a1_wire[t2],t2_padrA_a1_wire[t2]}),
               .mem_read ({t2_readB_wire[t2],t2_readA_wire[t2]}), .mem_write ({t2_writeB_wire[t2],t2_writeA_wire[t2]}),
               .mem_addr ({t2_addrB_wire[t2],t2_addrA_wire[t2]}), .mem_bw ({t2_bwB_wire[t2],t2_bwA_wire[t2]}), .mem_din ({t2_dinB_wire[t2],t2_dinA_wire[t2]}),
               .mem_dout ({t2_doutB_wire,t2_doutA_wire}),
	       .select_addr (select_vrow),
               .clk (clk), .rst (rst));
    assign t2_derrA_a1_wire[t2] = 1'b0;
    assign t2_derrB_a1_wire[t2] = 1'b0;
  end
end
endgenerate

reg [1-1:0] t2_readA;
reg [1-1:0] t2_writeA;
reg [1*BITSROW-1:0] t2_addrA;
reg [1*PHYWDTH-1:0] t2_bwA;
reg [1*PHYWDTH-1:0] t2_dinA;
reg [1-1:0] t2_readB;
reg [1-1:0] t2_writeB;
reg [1*BITSROW-1:0] t2_addrB;
reg [1*PHYWDTH-1:0] t2_bwB;
reg [1*PHYWDTH-1:0] t2_dinB;

integer t2_out_int;
always_comb begin
  t2_readA = 0;
  t2_writeA = 0;
  t2_addrA = 0;
  t2_bwA = 0;
  t2_dinA = 0;
  t2_readB = 0;
  t2_writeB = 0;
  t2_addrB = 0;
  t2_bwB = 0;
  t2_dinB = 0;
  t2_doutA_a1 = 0;
  t2_serrA_a1 = 0;
  t2_derrA_a1 = 0;
  t2_padrA_a1 = 0;
  t2_doutB_a1 = 0;
  t2_serrB_a1 = 0;
  t2_derrB_a1 = 0;
  t2_padrB_a1 = 0;
  for (t2_out_int=0; t2_out_int<1; t2_out_int=t2_out_int+1) begin
    t2_readA = t2_readA | (t2_readA_wire[t2_out_int] << t2_out_int);
    t2_writeA = t2_writeA | (t2_writeA_wire[t2_out_int] << t2_out_int);
    t2_addrA = t2_addrA | (t2_addrA_wire[t2_out_int] << (t2_out_int*BITSROW));
    t2_bwA = t2_bwA | (t2_bwA_wire[t2_out_int] << (t2_out_int*PHYWDTH));
    t2_dinA = t2_dinA | (t2_dinA_wire[t2_out_int] << (t2_out_int*PHYWDTH));
    t2_readB = t2_readB | (t2_readB_wire[t2_out_int] << t2_out_int);
    t2_writeB = t2_writeB | (t2_writeB_wire[t2_out_int] << t2_out_int);
    t2_addrB = t2_addrB | (t2_addrB_wire[t2_out_int] << (t2_out_int*BITSROW));
    t2_bwB = t2_bwB | (t2_bwB_wire[t2_out_int] << (t2_out_int*PHYWDTH));
    t2_dinB = t2_dinB | (t2_dinB_wire[t2_out_int] << (t2_out_int*PHYWDTH));
    t2_doutA_a1 = t2_doutA_a1 | (t2_doutA_a1_wire[t2_out_int] << (t2_out_int*WIDTH));
    t2_serrA_a1 = t2_serrA_a1 | (t2_serrA_a1_wire[t2_out_int] << t2_out_int);
    t2_derrA_a1 = t2_derrA_a1 | (t2_derrA_a1_wire[t2_out_int] << t2_out_int);
    t2_padrA_a1 = t2_padrA_a1 | (t2_padrA_a1_wire[t2_out_int] << (t2_out_int*(BITSROW+BITWRDS)));
    t2_doutB_a1 = t2_doutB_a1 | (t2_doutB_a1_wire[t2_out_int] << (t2_out_int*WIDTH));
    t2_serrB_a1 = t2_serrB_a1 | (t2_serrB_a1_wire[t2_out_int] << t2_out_int);
    t2_derrB_a1 = t2_derrB_a1 | (t2_derrB_a1_wire[t2_out_int] << t2_out_int);
    t2_padrB_a1 = t2_padrB_a1 | (t2_padrB_a1_wire[t2_out_int] << (t2_out_int*(BITSROW+BITWRDS)));
  end
end
/*
`ifdef FORMAL
genvar berr_var;
generate 
  for (berr_var=0; berr_var<NUMVBNK; berr_var=berr_var+1) begin: berr_loop
    assume_memA_nerr_check: assert property (@(posedge clk) disable iff (rst)
                                             (a1_loop.algo.ip_top_sva.memA_nerr[0][berr_var] == t1_loop[berr_var].align_loop.infra.ip_top_sva.mem_nerr[0]));
    assume_memA_serr_check: assert property (@(posedge clk) disable iff (rst)
                                             (a1_loop.algo.ip_top_sva.memA_serr[0][berr_var] == t1_loop[berr_var].align_loop.infra.ip_top_sva.mem_serr[0]));
    assume_memB_nerr_check: assert property (@(posedge clk) disable iff (rst)
                                             (a1_loop.algo.ip_top_sva.memB_nerr[0][berr_var] == t1_loop[berr_var].align_loop.infra.ip_top_sva.mem_nerr[1]));
    assume_memB_serr_check: assert property (@(posedge clk) disable iff (rst)
                                             (a1_loop.algo.ip_top_sva.memB_serr[0][berr_var] == t1_loop[berr_var].align_loop.infra.ip_top_sva.mem_serr[1]));
  end
  assume_xmemA_nerr_check: assert property (@(posedge clk) disable iff (rst)
                                            (a1_loop.algo.ip_top_sva.xmemA_nerr[0] == t2_loop[0].align_loop.infra.ip_top_sva.mem_nerr[0]));
  assume_xmemA_serr_check: assert property (@(posedge clk) disable iff (rst)
                                            (a1_loop.algo.ip_top_sva.xmemA_serr[0] == t2_loop[0].align_loop.infra.ip_top_sva.mem_serr[0]));
  assume_xmemB_nerr_check: assert property (@(posedge clk) disable iff (rst)
                                            (a1_loop.algo.ip_top_sva.xmemB_nerr[0] == t2_loop[0].align_loop.infra.ip_top_sva.mem_nerr[1]));
  assume_xmemB_serr_check: assert property (@(posedge clk) disable iff (rst)
                                            (a1_loop.algo.ip_top_sva.xmemB_serr[0] == t2_loop[0].align_loop.infra.ip_top_sva.mem_serr[1]));
end
endgenerate
`endif
*/

endmodule
