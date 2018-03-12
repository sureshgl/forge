
module  algo_nbor1hu_1r1w_nocam_top (
  clk, rst, ready, disp_en, freeze,
  cpu_read, cpu_write, cpu_bnk, cpu_addr, cpu_din, cpu_dout, cpu_vld,
  sr_en, sr_key, sr_dout, sr_vld, sr_match, sr_mhe, sr_serr, sr_derr, sr_padr,
  up_en, up_key, up_din, up_del, up_bp, 
  t1_readB, t1_addrB, t1_doutB,
  t1_writeA, t1_addrA, t1_dinA, t1_bwA
);
  parameter NUMSEPT = 1;

  parameter KYWIDTH = 32;
  parameter DTWIDTH = 16;
  parameter LG_DTWIDTH = 4;
  
  parameter NUMVROW = 4;
  parameter BITVROW = 2;
  parameter NUMVBNK = 2;
  parameter BITVBNK = 1;
  parameter NUMWRDS = 4;       // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  
  parameter MEM_DELAY = 1;
  parameter FLOPCRC = 0;

  parameter QSIZE = 32;
  parameter LG_QSIZE = 5;

  parameter SLOTWIDTH = KYWIDTH+DTWIDTH+1;
  parameter PLINE_DELAY = MEM_DELAY + FLOPCRC;
 
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  
  parameter NUMWROW = NUMSROW; // STACK Parameters
  parameter BITWROW = BITSROW;
  parameter NUMWBNK = 1;
  parameter BITWBNK = 1;
  parameter BITPBNK = BITVBNK+1;

  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;

  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;
  parameter MEMWDTH = ENAPAR ? SLOTWIDTH+1 : ENAECC ? SLOTWIDTH+ECCWDTH : SLOTWIDTH;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  
  input clk, rst, disp_en, freeze;
  output ready;

  input cpu_read;
  input cpu_write;
  input [BITPBNK-1:0]   cpu_bnk;
  input [BITVROW-1:0]   cpu_addr;
  input [SLOTWIDTH-1:0] cpu_din;
  output[SLOTWIDTH-1:0] cpu_dout;
  output                cpu_vld;

  input  [NUMSEPT-1:0] sr_en;
  input  [NUMSEPT*KYWIDTH-1:0] sr_key;
  output [NUMSEPT*DTWIDTH-1:0] sr_dout;
  output [NUMSEPT-1:0] sr_vld;
  output [NUMSEPT-1:0] sr_match;
  output [NUMSEPT-1:0] sr_mhe;
  output [NUMSEPT-1:0] sr_serr;
  output [NUMSEPT-1:0] sr_derr;
  output [NUMSEPT*BITPADR-1:0] sr_padr;

  assign sr_serr = 0;
  assign sr_derr = 0;
  assign sr_padr = 0;

  input  up_en;
  input  [KYWIDTH-1:0] up_key;
  input  [DTWIDTH-1:0] up_din;
  input  up_del;
  output up_bp;

  output [NUMSEPT*NUMVBNK-1:0] t1_readB;
  output [NUMSEPT*NUMVBNK*BITSROW-1:0] t1_addrB;
  input  [NUMSEPT*NUMVBNK*PHYWDTH-1:0] t1_doutB;

  output [NUMSEPT*NUMVBNK-1:0] t1_writeA;
  output [NUMSEPT*NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMSEPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
  output [NUMSEPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;

`ifdef FORMAL
`else
`endif

wire [NUMSEPT-1:0] rd_fwrd_int;
wire [NUMSEPT*(BITPADR-1)-1:0] rd_padr_int;
reg [BITPADR-2:0] rd_padr_tmp [0:NUMSEPT-1];
reg [NUMSEPT*BITPADR-1:0] rd_padr;
integer padr_int;
always_comb begin
  rd_padr = 0;
  for (padr_int=0; padr_int<NUMSEPT; padr_int=padr_int+1) begin
    rd_padr_tmp[padr_int] = rd_padr_int >> (padr_int*(BITPADR-1));
    rd_padr = rd_padr | ({rd_fwrd_int[padr_int],rd_padr_tmp[padr_int]} << (padr_int*BITPADR));
  end
end

wire [NUMSEPT*NUMVBNK-1:0] t1_writeA_a1;
wire [NUMSEPT*NUMVBNK*BITVROW-1:0] t1_addrA_a1;
wire [NUMSEPT*NUMVBNK*SLOTWIDTH-1:0] t1_dinA_a1;
wire [NUMSEPT*NUMVBNK-1:0] t1_readB_a1;
wire [NUMSEPT*NUMVBNK*BITVROW-1:0] t1_addrB_a1;
reg [NUMSEPT*NUMVBNK*SLOTWIDTH-1:0] t1_doutB_a1;
reg [NUMSEPT*NUMVBNK-1:0] t1_fwrdB_a1; 
reg [NUMSEPT*NUMVBNK-1:0] t1_serrB_a1; 
reg [NUMSEPT*NUMVBNK-1:0] t1_derrB_a1; 
reg [NUMSEPT*NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrB_a1;

generate if (1) begin: a1_loop
 algo_nbor1u_1r1w_nocam
  #(.NUMSEPT(NUMSEPT), .KYWIDTH(KYWIDTH), .DTWIDTH(DTWIDTH), .NUMVROW(NUMVROW), .BITVROW(BITVROW),
  .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK), .BITPBNK(BITPBNK), .MEM_DELAY(MEM_DELAY+FLOPCMD+FLOPMEM), .FLOPCRC(FLOPCRC),
  .QSIZE(QSIZE), .LG_QSIZE(LG_QSIZE))
  algo (.clk(clk), .rst(rst), .ready(ready), .disp_en(disp_en), .freeze(freeze),
  .cpu_read(cpu_read), .cpu_write(cpu_write), .cpu_bnk(cpu_bnk), .cpu_addr(cpu_addr), .cpu_din(cpu_din), .cpu_dout(cpu_dout), .cpu_vld(cpu_vld),
  .sr_en(sr_en), .sr_key(sr_key), .sr_dout(sr_dout), .sr_vld(sr_vld), .sr_match(sr_match), .sr_mhe(sr_mhe),
  .up_en(up_en), .up_key(up_key), .up_din(up_din), .up_del(up_del), .up_bp(up_bp), 
  .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
  //.t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1), 
  .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
  .select_key(), .select_bit());

/*algo_nr1w_dup #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMSEPT (NUMSEPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR-1), .NUMCOLS (NUMCOLS), .BITCOLS (BITCOLS),
		.SRAM_DELAY (SRAM_DELAY+FLOPMEM+FLOPCMD), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))
    algo (.clk(clk), .rst(rst), .ready(ready),
          .write(write), .wr_adr(wr_adr), .din(din),
	  .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout),
          .rd_fwrd(rd_fwrd_int), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr_int),
          .t1_writeA(t1_writeA_a1), .t1_addrA(t1_addrA_a1), .t1_dinA(t1_dinA_a1),
          .t1_readB(t1_readB_a1), .t1_addrB(t1_addrB_a1), .t1_doutB(t1_doutB_a1),
          .t1_fwrdB(t1_fwrdB_a1), .t1_serrB(t1_serrB_a1), .t1_derrB(t1_derrB_a1), .t1_padrB(t1_padrB_a1), 
	  .select_addr(select_addr), .select_bit(select_bit));
*/
end
endgenerate

wire t1_writeA_wire [0:NUMSEPT-1][0:NUMVBNK-1];
wire [BITWROW-1:0] t1_addrA_wire [0:NUMSEPT-1][0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMSEPT-1][0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMSEPT-1][0:NUMVBNK-1];
wire t1_readB_wire [0:NUMSEPT-1][0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrB_wire [0:NUMSEPT-1][0:NUMVBNK-1];
wire [SLOTWIDTH-1:0] t1_doutB_a1_wire [0:NUMSEPT-1][0:NUMVBNK-1];
wire t1_fwrdB_a1_wire [0:NUMSEPT-1][0:NUMVBNK-1];
wire t1_serrB_a1_wire [0:NUMSEPT-1][0:NUMVBNK-1];
wire t1_derrB_a1_wire [0:NUMSEPT-1][0:NUMVBNK-1];
wire [BITSROW+BITWRDS:0] t1_padrB_a1_wire [0:NUMSEPT-1][0:NUMVBNK-1];

genvar t1r, t1b;
generate
  for (t1r=0; t1r<NUMSEPT; t1r=t1r+1) begin: t1r_loop
    for (t1b=0; t1b<NUMVBNK; t1b=t1b+1) begin: t1b_loop
      wire t1_writeA_a1_wire = t1_writeA_a1 >> (t1r*NUMVBNK+t1b);
      wire [BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> ((t1r*NUMVBNK+t1b)*BITVROW);
      wire [SLOTWIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> ((t1r*NUMVBNK+t1b)*SLOTWIDTH);
      wire t1_readB_a1_wire = t1_readB_a1 >> (t1r*NUMVBNK+t1b);
      wire [BITVROW-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> ((t1r*NUMVBNK+t1b)*BITVROW);

      wire [NUMWRDS*MEMWDTH-1:0] t1_doutB_wire = t1_doutB >> ((t1r*NUMVBNK+t1b)*PHYWDTH);

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
        infra_align_ecc_1r1w #(.WIDTH (SLOTWIDTH), .ENAPSDO (NUMWRDS==1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .ENAPADR (1),
                               .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                               .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITWBNK+BITWROW),
                               .SRAM_DELAY (MEM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
         infra (.write(t1_writeA_a1_wire), .wr_adr(t1_addrA_a1_wire), .din(t1_dinA_a1_wire),
                 .read(t1_readB_a1_wire), .rd_adr(t1_addrB_a1_wire),
                 .rd_dout(t1_doutB_a1_wire[t1r][t1b]), .rd_fwrd(t1_fwrdB_a1_wire[t1r][t1b]),
                 .rd_serr(t1_serrB_a1_wire[t1r][t1b]), .rd_derr(t1_derrB_a1_wire[t1r][t1b]), .rd_padr(t1_padrB_a1_wire[t1r][t1b]),
                 .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
                 .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
                 .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
                 .clk (clk), .rst (rst),
                 .select_addr());//.select_addr (select_vrow));
      end

      if (1) begin: stack_loop
        infra_stack_1r1w #(.WIDTH (NUMWRDS*MEMWDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                           .NUMWROW (NUMWROW), .BITWROW (BITWROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
                           .SRAM_DELAY (MEM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
          infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
                 .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
                 .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
                 .mem_write (t1_writeA_wire[t1r][t1b]), .mem_wr_adr(t1_addrA_wire[t1r][t1b]),
                 .mem_bw (t1_bwA_wire[t1r][t1b]), .mem_din (t1_dinA_wire[t1r][t1b]),
                 .mem_read (t1_readB_wire[t1r][t1b]), .mem_rd_adr(t1_addrB_wire[t1r][t1b]), .mem_rd_dout (t1_doutB_wire),
                 .clk (clk), .rst(rst),
                 .select_addr());//.select_addr (select_srow));
      end
    end
  end
endgenerate

reg [NUMSEPT*NUMVBNK-1:0] t1_writeA;
reg [NUMSEPT*NUMVBNK*BITSROW-1:0] t1_addrA;
reg [NUMSEPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMSEPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
reg [NUMSEPT*NUMVBNK-1:0] t1_readB;
reg [NUMSEPT*NUMVBNK*BITSROW-1:0] t1_addrB;
integer t1r_int, t1b_int;
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
  for (t1r_int=0; t1r_int<NUMSEPT; t1r_int=t1r_int+1) begin
    for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1) begin
      t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*BITSROW));
      t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*PHYWDTH));
      t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*PHYWDTH));
      t1_readB = t1_readB | (t1_readB_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*BITSROW));
      t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*SLOTWIDTH));
      t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1r_int][t1b_int] << (t1r_int*NUMVBNK+t1b_int));
      t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*(BITSROW+BITWRDS)));
    end
  end
end

endmodule

