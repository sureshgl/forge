
module algo_mrnw1p_1rw_base_top (clk, rst, ready, refr,
                                 write, wr_adr, din,
                                 read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                         t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dwsnA, t1_dinA, t1_doutA, t1_serrA, t1_refrB, t1_bankB);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAEXT = 0;
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

  parameter SRAM_DELAY = 2;
  parameter FLOPECC = 0;
  parameter FLOPIN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;
  parameter MEMWDTH = ENAEXT ? WIDTH : ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;

  parameter NUMRDPT = 2;
  parameter NUMWRPT = 3;
  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;

  input                          refr;

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

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*BITDWSN-1:0] t1_dwsnA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMVBNK*PHYWDTH-1:0] t1_doutA;
  input [NUMVBNK-1:0] t1_serrA;

  output [NUMVBNK-1:0] t1_refrB;
  output [NUMVBNK*BITRBNK-1:0] t1_bankB;

`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
wire [BITRBNK-1:0] select_rbnk;
wire [BITRROW-1:0] select_rrow;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));
assume_select_rbnk_range: assume property (@(posedge clk) disable iff (rst) (select_rbnk < NUMRBNK));
assume_select_rbnk_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rbnk));
assume_select_rrow_range: assume property (@(posedge clk) disable iff (rst) (select_rrow < NUMRROW));
assume_select_rrow_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rrow));

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
wire [BITRBNK-1:0] select_rbnk = 0;
wire [BITRROW-1:0] select_rrow = 0;
`endif

wire [NUMVBNK-1:0] t1_readA_a1;
wire [NUMVBNK-1:0] t1_writeA_a1;
wire [NUMVBNK*BITVROW-1:0] t1_addrA_a1;
wire [NUMVBNK*WIDTH-1:0] t1_dinA_a1;
wire [NUMVBNK-1:0] t1_refrB_a1;
reg [NUMVBNK*WIDTH-1:0] t1_doutA_a1;
reg [NUMVBNK-1:0] t1_fwrdA_a1;
reg [NUMVBNK-1:0] t1_serrA_a1;
reg [NUMVBNK-1:0] t1_derrA_a1;
reg [NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrA_a1;

reg [BITPADR-1:0] rd_padr;
  
wire [NUMRDPT-1:0] rd_fwrd_wire;
wire [NUMRDPT*(BITPADR-1)-1:0] rd_padr_wire;

integer fwrd_int;
reg rd_fwrd_tmp;
reg [BITPADR-2:0] rd_padr_tmp;
always_comb begin
  rd_fwrd_tmp = 0;
  rd_padr_tmp = 0;
  rd_padr = 0;
  for (fwrd_int=0; fwrd_int<NUMRDPT; fwrd_int=fwrd_int+1) begin
    rd_fwrd_tmp = rd_fwrd_wire >> fwrd_int;
    rd_padr_tmp = rd_padr_wire >> (fwrd_int*(BITPADR-1));
    rd_padr = rd_padr | ({rd_fwrd_tmp,rd_padr_tmp} << (fwrd_int*BITPADR));
  end
end

generate if (1) begin: a1_loop
  algo_mrnw1p_1rw_base #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT),
                         .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                         .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                         .BITPADR (BITPADR-1), .SRAM_DELAY (SRAM_DELAY+FLOPECC+FLOPMEM), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    algo (.clk (clk), .rst (rst), .ready (ready), .refr (refr),
          .write (write), .wr_adr (wr_adr), .din (din),
	  .read (read), .rd_adr (rd_adr), .rd_vld (rd_vld), .rd_dout (rd_dout),
	  .rd_fwrd (rd_fwrd_wire), .rd_serr (rd_serr), .rd_derr (rd_derr), .rd_padr (rd_padr_wire),
          .t1_readA (t1_readA_a1), .t1_writeA (t1_writeA_a1), .t1_addrA (t1_addrA_a1), .t1_dinA (t1_dinA_a1), .t1_doutA (t1_doutA_a1),
	  .t1_fwrdA (t1_fwrdA_a1), .t1_serrA (t1_serrA_a1), .t1_derrA (t1_derrA_a1), .t1_padrA (t1_padrA_a1), .t1_refrB (t1_refrB_a1),
	  .select_addr (select_addr), .select_bit (select_bit));
end
endgenerate

wire [WIDTH-1:0] t1_doutA_a1_wire [0:NUMVBNK-1];
wire t1_fwrdA_a1_wire [0:NUMVBNK-1];
wire t1_serrA_a1_wire [0:NUMVBNK-1];
wire t1_derrA_a1_wire [0:NUMVBNK-1];
wire [(BITSROW+BITWRDS)-1:0] t1_padrA_a1_wire [0:NUMVBNK-1];
wire t1_readA_wire [0:NUMVBNK-1];
wire t1_writeA_wire [0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMVBNK-1];
wire [BITDWSN-1:0] t1_dwsnA_wire [0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];
wire t1_refrB_wire [0:NUMVBNK-1];
wire [BITRBNK-1:0] t1_bankB_wire [0:NUMVBNK-1];

genvar t1;
generate for (t1=0; t1<NUMVBNK; t1=t1+1) begin: t1_loop
  wire t1_readA_a1_wire = t1_readA_a1 >> t1;
  wire t1_writeA_a1_wire = t1_writeA_a1 >> t1;
  wire [BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (t1*BITVROW);
  wire [WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (t1*WIDTH);
  wire t1_refrB_a1_wire = t1_refrB_a1 >> t1;

  wire [NUMWRDS*MEMWDTH-1:0] t1_doutA_wire = t1_doutA >> (t1*PHYWDTH);
  wire [NUMWRDS-1:0] t1_serrA_wire = t1_serrA >> t1;

  if (1) begin: align_loop
    infra_align_ecc_dwsn #(.WIDTH (WIDTH), .ENAEXT (ENAEXT), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH),
                           .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                           .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                           .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                           .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                           .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                           .SRAM_DELAY (SRAM_DELAY), .FLOPGEN (FLOPECC), .FLOPMEM (FLOPMEM), .FLOPOUT (FLOPECC))
      infra (.read (t1_readA_a1_wire), .write (t1_writeA_a1_wire), .addr (t1_addrA_a1_wire), .din (t1_dinA_a1_wire),
             .rd_dout (t1_doutA_a1_wire[t1]), .rd_fwrd (t1_fwrdA_a1_wire[t1]),
             .rd_serr (t1_serrA_a1_wire[t1]), .rd_derr (t1_derrA_a1_wire[t1]), .rd_padr (t1_padrA_a1_wire[t1]),
             .mem_read (t1_readA_wire[t1]), .mem_write (t1_writeA_wire[t1]), .mem_addr (t1_addrA_wire[t1]),
             .mem_bw (t1_bwA_wire[t1]), .mem_dwsn (t1_dwsnA_wire[t1]), .mem_din (t1_dinA_wire[t1]),
             .mem_dout (t1_doutA_wire), .mem_serr (t1_serrA_wire),
             .select_addr (select_vrow),
             .clk (clk), .rst (rst));
  end

  wire [BITRBNK-1:0] t1_bankA_wire = t1_addrA_wire[t1] >> (BITSROW-BITRBNK-BITWSPF);

  if (REFRESH==1) begin: refr_loop
    infra_refr_1stage #(.NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .REFLOPW (REFLOPW),
                        .NUMRROW (NUMRROW), .BITRROW (BITRROW), .REFFREQ (REFFREQ), .REFFRHF (REFFRHF))
      infra (.clk (clk), .rst (rst),
             .pref (t1_refrB_a1_wire), .pacc (t1_readA_wire[t1] || t1_writeA_wire[t1]), .pacbadr (t1_bankA_wire),
             .prefr (t1_refrB_wire[t1]), .prfbadr (t1_bankB_wire[t1]),
             .select_rbnk (select_rbnk), .select_rrow (select_rrow));
  end else begin: no_refr_loop
    assign t1_refrB_wire[t1] = 1'b0;
    assign t1_bankB_wire[t1] = 0;
  end
end
endgenerate

reg [NUMVBNK-1:0] t1_readA;
reg [NUMVBNK-1:0] t1_writeA;
reg [NUMVBNK*BITSROW-1:0] t1_addrA;
reg [NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMVBNK*BITDWSN-1:0] t1_dwsnA;
reg [NUMVBNK*PHYWDTH-1:0] t1_dinA;
reg [NUMVBNK-1:0] t1_refrB;
reg [NUMVBNK*BITRBNK-1:0] t1_bankB;

integer t1_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dwsnA = 0;
  t1_dinA = 0;
  t1_refrB = 0;
  t1_bankB = 0;
  t1_doutA_a1 = 0;
  t1_fwrdA_a1 = 0;
  t1_serrA_a1 = 0;
  t1_derrA_a1 = 0;
  t1_padrA_a1 = 0;
  for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin
    t1_readA = t1_readA | (t1_readA_wire[t1_int] << t1_int);
    t1_writeA = t1_writeA | (t1_writeA_wire[t1_int] << t1_int);
    t1_addrA = t1_addrA | (t1_addrA_wire[t1_int] << (t1_int*BITSROW));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1_int] << (t1_int*PHYWDTH));
    t1_dwsnA = t1_dwsnA | (t1_dwsnA_wire[t1_int] << (t1_int*BITDWSN));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1_int] << (t1_int*PHYWDTH));
    t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[t1_int] << (t1_int*WIDTH));
    t1_fwrdA_a1 = t1_fwrdA_a1 | (t1_fwrdA_a1_wire[t1_int] << t1_int);
    t1_serrA_a1 = t1_serrA_a1 | (t1_serrA_a1_wire[t1_int] << t1_int);
    t1_derrA_a1 = t1_derrA_a1 | (t1_derrA_a1_wire[t1_int] << t1_int);
    t1_padrA_a1 = t1_padrA_a1 | (t1_padrA_a1_wire[t1_int] << (t1_int*(BITSROW+BITWRDS)));
    t1_refrB = t1_refrB | (t1_refrB_wire[t1_int] << t1_int);
    t1_bankB = t1_bankB | (t1_bankB_wire[t1_int] << (t1_int*BITRBNK));
  end
end

`ifdef FORMAL

generate if (REFRESH) begin: refr_loop
  assert_refr_check: assert property (@(posedge clk) disable iff (!ready) !refr |-> ##[1:REFFREQ-1] refr);
  assert_refr_half_check: assert property (@(posedge clk) disable iff (!ready) refr ##(REFFREQ+REFFRHF) refr |-> ##REFFREQ (!REFFRHF || refr));
  assert_refr_noacc_check: assume property (@(posedge clk) disable iff (!ready) !(refr && (write || |read)));
end
endgenerate

`endif

endmodule
