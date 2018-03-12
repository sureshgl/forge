
module algo_1r2w_1rw_rl_top (clk, rst, ready,
                             refr, read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                             t1_readA, t1_writeA, t1_addrA, t1_dwsnA, t1_bwA, t1_dinA, t1_doutA, t1_refrB, t1_bankB,
                             t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                             t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 1;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 2;
  parameter PARITY = 0;
  parameter MEMWDTH = WIDTH+PARITY;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;  // ALGO1 Parameters
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter NUMWRDS = 4;     // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 64;
  parameter BITSROW = 6;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter BITPROW = BITSROW;
  parameter REFRESH = 1;      // REFRESH Parameters 
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
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPMEM = 0;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
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
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0]  rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*BITDWSN-1:0] t1_dwsnA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMVBNK*PHYWDTH-1:0] t1_doutA;
  output [NUMVBNK-1:0] t1_refrB;
  output [NUMVBNK*BITRBNK-1:0] t1_bankB;

  output [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t2_writeA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_dinA;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrB;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB;

  output [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t3_writeA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW-1:0] t3_addrA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_dinA;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t3_addrB;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_doutB;

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

wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  adr_a2 (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));
  
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
reg [NUMVBNK-1:0] t1_serrA_a1;
reg [NUMVBNK-1:0] t1_derrA_a1;
reg [NUMVBNK*(BITPADR-BITPBNK-1)-1:0] t1_padrA_a1;

wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB_a1;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_doutB_a1;

generate if (1) begin: a1_loop

algo_mrnrwpw_1rw_rl #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMRDPT (NUMRDPT), .NUMRWPT (NUMRWPT), .NUMWRPT (NUMWRPT),
                      .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .BITPBNK(BITPBNK), .BITPADR(BITPADR),
                      .REFRESH(REFRESH), .SRAM_DELAY(SRAM_DELAY+FLOPMEM), .DRAM_DELAY(DRAM_DELAY+FLOPMEM), .FLOPIN(FLOPIN), .FLOPOUT(FLOPOUT), .ECCBITS(ECCBITS))
  algo (.ready(ready), .clk(clk), .rst (rst),
        .refr (refr), .read(read),. write(write), .addr(addr), .din(din), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
        .t1_readA(t1_readA_a1), .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
        .t1_doutA(t1_doutA_a1), .t1_serrA(t1_serrA_a1), .t1_derrA(t1_derrA_a1), .t1_padrA(t1_padrA_a1),
        .t1_refrB(t1_refrB_a1),
        .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB_a1),
        .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA), .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB_a1),
	.select_addr (select_addr), .select_bit (select_bit));

end
endgenerate

wire [WIDTH-1:0] t1_doutA_a1_wire [0:NUMVBNK-1];
wire t1_serrA_a1_wire [0:NUMVBNK-1];
wire t1_derrA_a1_wire [0:NUMVBNK-1];
wire [BITSROW+BITWRDS-1:0] t1_padrA_a1_wire [0:NUMVBNK-1];
wire t1_readA_wire [0:NUMVBNK-1];
wire t1_writeA_wire [0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
wire [BITDWSN-1:0] t1_dwsnA_wire [0:NUMVBNK-1];
wire [NUMWRDS*WIDTH-1:0] t1_bwA_wire [0:NUMVBNK-1];
wire [NUMWRDS*WIDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];
wire t1_refrB_wire [0:NUMVBNK-1];
wire [BITRBNK-1:0] t1_bankB_wire [0:NUMVBNK-1];

genvar t1;
generate for (t1=0; t1<NUMVBNK; t1=t1+1) begin: t1_loop
  wire t1_readA_a1_wire = t1_readA_a1 >> t1;
  wire t1_writeA_a1_wire = t1_writeA_a1 >> t1;
  wire [BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (t1*BITVROW);
  wire [WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (t1*WIDTH);
  wire t1_refrB_a1_wire = t1_refrB_a1 >> t1;

  wire [NUMWRDS*WIDTH-1:0] t1_doutA_wire = t1_doutA >> (t1*PHYWDTH);

  if (1) begin: align_loop
    infra_align_dwsn #(.WIDTH (WIDTH), .PARITY (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                       .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                       .NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
                       .NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
                       .NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
                       .NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15), .BITDWSN (BITDWSN),
                       .SRAM_DELAY (DRAM_DELAY), .FLOPMEM (FLOPMEM))
        infra (.read(t1_readA_a1_wire), .write(t1_writeA_a1_wire), .addr(t1_addrA_a1_wire),
               .din(t1_dinA_a1_wire), .dout(t1_doutA_a1_wire[t1]),
               .serr(), .padr (t1_padrA_a1_wire[t1]),
               .mem_read (t1_readA_wire[t1]), .mem_write (t1_writeA_wire[t1]), .mem_addr (t1_addrA_wire[t1]),
               .mem_bw (t1_bwA_wire[t1]), .mem_dwsn (t1_dwsnA_wire[t1]), .mem_din (t1_dinA_wire[t1]), .mem_dout (t1_doutA_wire),
               .clk (clk), .rst (rst),
               .select_addr (select_vrow));
    assign t1_serrA_a1_wire[t1] = 1'b0;
    assign t1_derrA_a1_wire[t1] = 1'b0;
  end

  wire [BITRBNK-1:0] t1_bankA_wire = t1_addrA_wire[t1] >> (BITPROW-BITRBNK-BITWSPF);

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
reg [NUMVBNK*BITDWSN-1:0] t1_dwsnA;
reg [NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMVBNK*PHYWDTH-1:0] t1_dinA;
reg [NUMVBNK-1:0] t1_refrB;
reg [NUMVBNK*BITRBNK-1:0] t1_bankB;
integer t1_out_int;
always_comb begin
  t1_readA = 0;
  t1_writeA = 0;
  t1_addrA = 0;
  t1_dwsnA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_refrB = 0;
  t1_bankB = 0; 
  t1_doutA_a1 = 0;
  t1_serrA_a1 = 0;
  t1_derrA_a1 = 0;
  t1_padrA_a1 = 0;
  for (t1_out_int=0; t1_out_int<NUMVBNK; t1_out_int=t1_out_int+1) begin
    t1_readA = t1_readA | (t1_readA_wire[t1_out_int] << t1_out_int);
    t1_writeA = t1_writeA | (t1_writeA_wire[t1_out_int] << t1_out_int);
    t1_addrA = t1_addrA | (t1_addrA_wire[t1_out_int] << (t1_out_int*BITSROW));
    t1_dwsnA = t1_dwsnA | (t1_dwsnA_wire[t1_out_int] << (t1_out_int*BITDWSN));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1_out_int] << (t1_out_int*PHYWDTH));
    t1_doutA_a1 = t1_doutA_a1 | (t1_doutA_a1_wire[t1_out_int] << (t1_out_int*WIDTH));
    t1_serrA_a1 = t1_serrA_a1 | (t1_serrA_a1_wire[t1_out_int] << t1_out_int);
    t1_derrA_a1 = t1_derrA_a1 | (t1_derrA_a1_wire[t1_out_int] << t1_out_int);
    t1_padrA_a1 = t1_padrA_a1 | (t1_padrA_a1_wire[t1_out_int] << (t1_out_int*(BITSROW+BITWRDS)));
    t1_refrB = t1_refrB | (t1_refrB_wire[t1_out_int] << t1_out_int);
    t1_bankB = t1_bankB | (t1_bankB_wire[t1_out_int] << (t1_out_int*BITRBNK));
  end
end

generate if (FLOPMEM) begin: t2_t3_flp_loop
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB_reg;
  reg [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_doutB_reg;
  always @(posedge clk) begin
    t2_doutB_reg <= t2_doutB;
    t3_doutB_reg <= t3_doutB;
  end

  assign t2_doutB_a1 = t2_doutB_reg;
  assign t3_doutB_a1 = t3_doutB_reg;
end else begin: t2_t3_noflp_loop
  assign t2_doutB_a1 = t2_doutB;
  assign t3_doutB_a1 = t3_doutB;
end
endgenerate

`ifdef FORMAL

generate if (REFRESH) begin: refr_loop
  assert_refr_check: assert property (@(posedge clk) disable iff (!ready) !refr |-> ##[1:REFFREQ-1] refr);
  assert_refr_half_check: assert property (@(posedge clk) disable iff (rst) refr ##1 !refr [*(REFFREQ+REFFRHF-1)] ##1 refr |-> ##[1:REFFREQ] (!REFFRHF || refr));
  assert_refr_noacc_check: assume property (@(posedge clk) disable iff (!ready) !(refr && (|write || |read)));
end
endgenerate

`endif

endmodule
