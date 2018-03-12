module algo_2ru_2nr2w_top (clk, rst, ready,
                           ru_write, ru_addr, ru_din,
                           ru_read, ru_vld, ru_dout, ru_serr, ru_derr, ru_padr,
	                   t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 2;
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
  parameter PHYWDTH = NUMWRDS*WIDTH;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;

  input [2-1:0]                        ru_write;
  input [2*BITADDR-1:0]                ru_addr;
  input [2*WIDTH-1:0]                  ru_din;

  input [2*NUMRDPT-1:0]                ru_read;
  output [2*NUMRDPT-1:0]               ru_vld;
  output [2*NUMRDPT*WIDTH-1:0]         ru_dout;
  output [2*NUMRDPT-1:0]               ru_serr;
  output [2*NUMRDPT-1:0]               ru_derr;
  output [2*NUMRDPT*BITPADR-1:0]       ru_padr;

  output                               ready;
  input                                clk, rst;

  output [2*NUMRDPT*NUMVBNK-1:0] t1_writeA;
  output [2*NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrA;
  output [2*NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [2*NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;

  output [2*NUMRDPT*NUMVBNK-1:0] t1_readB;
  output [2*NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrB;
  input [2*NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_doutB;

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

wire [NUMRDPT-1:0] rd_fwrd_int;
wire [NUMRDPT*(BITPADR-1)-1:0] ru_padr_int;
reg [BITPADR-2:0] ru_padr_tmp [0:NUMRDPT-1];
reg [NUMRDPT*BITPADR-1:0] ru_padr;
integer padr_int;
always_comb begin
  ru_padr = 0;
  for (padr_int=0; padr_int<NUMRDPT; padr_int=padr_int+1) begin
    ru_padr_tmp[padr_int] = ru_padr_int << (padr_int*(BITPADR-1));
    ru_padr = ru_padr | ({rd_fwrd_int[padr_int],ru_padr_tmp[padr_int]} << (padr_int*BITPADR));
  end
end


wire [2*NUMRDPT*NUMVBNK-1:0] t1_writeA_a1;
wire [2*NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA_a1;
wire [2*NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA_a1;
wire [2*NUMRDPT*NUMVBNK-1:0] t1_readB_a1;
wire [2*NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB_a1;
reg [2*NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutB_a1;
reg [2*NUMRDPT*NUMVBNK-1:0] t1_serrB_a1;
reg [2*NUMRDPT*NUMVBNK-1:0] t1_derrB_a1;
reg [2*NUMRDPT*NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrB_a1;

generate if (1) begin: a1_loop

algo_2ru_2nr2w #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMRDPT (NUMRDPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR),
                 .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    algo (.clk (clk), .rst (rst), .ready (ready),
          .ru_write (ru_write), .ru_addr (ru_addr), .ru_din (ru_din),
	  .ru_read (ru_read), .ru_vld (ru_vld), .ru_dout (ru_dout), .ru_fwrd(ru_fwrd_int), .ru_serr (ru_serr), .ru_derr (ru_derr), .ru_padr (ru_padr_int),
          .t1_writeA (t1_writeA_a1), .t1_addrA (t1_addrA_a1), .t1_dinA (t1_dinA_a1),
          .t1_readB (t1_readB_a1), .t1_addrB (t1_addrB_a1), .t1_doutB (t1_doutB_a1), .t1_serrB (t1_serrB_a1), .t1_derrB (t1_derrB_a1), .t1_padrB (t1_padrB_a1),
          .select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

wire [2-1:0] t1_writeA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [2*BITSROW-1:0] t1_addrA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [2*NUMWRDS*WIDTH-1:0] t1_bwA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [2*NUMWRDS*WIDTH-1:0] t1_dinA_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [2-1:0] t1_readB_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [2*BITSROW-1:0] t1_addrB_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [2*WIDTH-1:0] t1_doutB_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [2-1:0] t1_serrB_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [2-1:0] t1_derrB_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];
wire [2*(BITSROW+BITWRDS)-1:0] t1_padrB_a1_wire [0:NUMRDPT-1][0:NUMVBNK-1];

genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMRDPT; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMVBNK; t1b=t1b+1) begin: t1b_loop
      wire [2-1:0] t1_writeA_a1_wire = t1_writeA_a1 >> 2*(t1r*NUMVBNK+t1b);
      wire [2*BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> 2*((t1r*NUMVBNK+t1b)*BITVROW);
      wire [2*WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> 2*((t1r*NUMVBNK+t1b)*WIDTH);
      wire [2-1:0] t1_readB_a1_wire = t1_readB_a1 >> 2*(t1r*NUMVBNK+t1b);
      wire [2*BITVROW-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> 2*((t1r*NUMVBNK+t1b)*BITVROW);

      wire [2*NUMWRDS*WIDTH-1:0] t1_doutB_wire = t1_doutB >> 2*((t1r*NUMVBNK+t1b)*PHYWDTH);

      if (1) begin: align_loop
        infra_align_mrnw #(.WIDTH (WIDTH), .PARITY (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW), .NUMRDPT (2), .NUMWRPT (2),
                           .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPMEM (FLOPMEM))
          infra (.write(t1_writeA_a1_wire), .wr_adr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
                 .read(t1_readB_a1_wire), .rd_adr(t1_addrB_a1_wire),
                 .rd_dout(t1_doutB_a1_wire[t1r][t1b]), .rd_serr(t1_serrB_a1_wire[t1r][t1b]), .rd_padr(t1_padrB_a1_wire[t1r][t1b]),
                 .mem_write (t1_writeA_wire[t1r][t1b]), .mem_wr_adr(t1_addrA_wire[t1r][t1b]), .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]),
                 .mem_read (t1_readB_wire[t1r][t1b]), .mem_rd_adr(t1_addrB_wire[t1r][t1b]), .mem_rd_dout (t1_doutB_wire),
                 .clk (clk), .rst (rst),
                 .select_addr (select_vrow));
        assign t1_derrB_a1_wire[t1r][t1b] = 2'h0;
      end
    end
  end
endgenerate

reg [2*NUMRDPT*NUMVBNK-1:0] t1_writeA;
reg [2*NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrA;
reg [2*NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [2*NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
reg [2*NUMRDPT*NUMVBNK-1:0] t1_readB;
reg [2*NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrB;
integer t1r_int, t1b_int;
always_comb begin
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_readB = 0;
  t1_addrB = 0;
  t1_doutB_a1 = 0;
  t1_serrB_a1 = 0;
  t1_derrB_a1 = 0;
  t1_padrB_a1 = 0;
  for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
    for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1) begin
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << 2*(t1r_int*NUMVBNK+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << 2*((t1r_int*NUMVBNK+t1b_int)*BITSROW));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << 2*((t1r_int*NUMVBNK+t1b_int)*PHYWDTH));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << 2*((t1r_int*NUMVBNK+t1b_int)*PHYWDTH));
      t1_readB = t1_readB | (t1_readB_wire[t1r_int][t1b_int] << 2*(t1r_int*NUMVBNK+t1b_int));
      t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int][t1b_int] << 2*((t1r_int*NUMVBNK+t1b_int)*BITSROW));
      t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1r_int][t1b_int] << 2*((t1r_int*NUMVBNK+t1b_int)*WIDTH));
      t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1r_int][t1b_int] << 2*(t1r_int*NUMVBNK+t1b_int));
      t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1r_int][t1b_int] << 2*(t1r_int*NUMVBNK+t1b_int));
      t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1r_int][t1b_int] << 2*((t1r_int*NUMVBNK+t1b_int)*(BITSROW+BITWRDS)));
    end
  end
end

endmodule
