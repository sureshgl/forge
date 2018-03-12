
module algo_mrpnwp_1r1w_base_top (clk, rst, ready,
                                  write, wr_badr, wr_radr, din,
                                  read, rd_badr, rd_radr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                          t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_serrB);
  
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

 parameter NUMGRPW = 14;
 parameter GRPWDTH = 128;
 parameter NUMGRPF = 5;
 parameter NUMCMDL = 2;
 parameter BITCMDL = 1;
 parameter WRBUSRED = 1;

  parameter SRAM_DELAY = 2;
  parameter FLOPECC = 0;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;
  parameter BITDMUX = 0;
  parameter MEMWDTH = ENAEXT ? WIDTH : ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;

  parameter NUMRDPT = 2;
  parameter NUMWRPT = 3;
  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;

  input [NUMWRPT-1:0]            write;
//  input [NUMWRPT*BITADDR-1:0]    wr_adr;
  input [(NUMWRPT*BITVBNK)-1:0]    wr_badr;
  input [(NUMWRPT*BITVROW)-1:0]    wr_radr;
  input [(NUMWRPT/WRBUSRED)*WIDTH-1:0]      din;

  input [NUMRDPT-1:0]            read;
//  input [NUMRDPT*BITADDR-1:0]    rd_adr;
  input [(NUMRDPT*BITVBNK)-1:0]    rd_badr;
  input [(NUMRDPT*BITVROW)-1:0]    rd_radr;
  output [NUMRDPT-1:0]           rd_vld;
  output [NUMRDPT*WIDTH-1:0]     rd_dout;
  output [NUMRDPT-1:0]           rd_serr;
  output [NUMRDPT-1:0]           rd_derr;
  output [NUMRDPT*BITPADR-1:0]   rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMGRPW*NUMVBNK-1:0] t1_writeA;
  output [NUMGRPW*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  output [NUMGRPW*NUMVBNK-1:0] t1_readB;
  output [NUMGRPW*NUMVBNK*BITSROW-1:0] t1_addrB;
  input [NUMVBNK*PHYWDTH-1:0] t1_doutB;
  input [NUMVBNK-1:0] t1_serrB;

  wire [NUMWRPT-1:0] pwrite;
//  wire [(BITVBNK*NUMWRPT)-1:0] pwrbadr;
//  wire [(BITVROW*NUMWRPT)-1:0] pwrradr;
  wire [(WIDTH*(NUMWRPT/WRBUSRED))-1:0]   pdin;
  wire [NUMRDPT-1:0] pread;
//  wire [(BITVBNK*NUMRDPT)-1:0] prdbadr;
//  wire [(BITVROW*NUMRDPT)-1:0] prdradr;
  wire [WIDTH*NUMRDPT-1:0] pdobus_reg_bus;
  wire [NUMRDPT-1:0] vread_vld_bus;
  wire[(BITPADR*NUMRDPT)-1:0] vread_padr_bus;


`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  vrow_inst (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));

wire [BITSROW-1:0] select_srow;
np2_addr #(
  .NUMADDR (NUMVROW), .BITADDR (BITVROW),
  .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
  .NUMVROW (NUMSROW), .BITVROW (BITSROW))
  srow_inst (.vbadr(), .vradr(select_srow), .vaddr(select_vrow));

`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
wire [BITVROW-1:0] select_vrow = 0;
wire [BITSROW-1:0] select_srow = 0;
`endif

wire [NUMVBNK-1:0] t1_writeA_a1;
wire [NUMVBNK*BITVROW-1:0] t1_addrA_a1;
wire [NUMVBNK*WIDTH-1:0] t1_dinA_a1;

wire [NUMVBNK-1:0] t1_readB_a1;
wire [NUMVBNK*BITVROW-1:0] t1_addrB_a1;
reg [NUMVBNK*WIDTH-1:0] t1_doutB_a1;
reg [NUMVBNK-1:0] t1_fwrdB_a1;
reg [NUMVBNK-1:0] t1_serrB_a1;
reg [NUMVBNK-1:0] t1_derrB_a1;
// reg [NUMVBNK*(BITSROW+BITWRDS)-1:0] t1_padrB_a1;

reg [NUMRDPT*BITPADR-1:0] rd_padr;
  
wire [NUMRDPT-1:0] rd_fwrd_wire;
// wire [NUMRDPT*(BITPADR-1)-1:0] rd_padr_wire;
wire [NUMRDPT*BITPADR-1:0] rd_padr_wire;

integer fwrd_int;
reg rd_fwrd_tmp;
reg [BITPADR-2:0] rd_padr_tmp;
always_comb begin
  rd_fwrd_tmp = 0;
  rd_padr_tmp = 0;
  rd_padr = 0;
  for (fwrd_int=0; fwrd_int<NUMRDPT; fwrd_int=fwrd_int+1) begin
    rd_fwrd_tmp = rd_fwrd_wire >> fwrd_int;
//    rd_padr_tmp = rd_padr_wire >> (fwrd_int*(BITPADR-1));
//    rd_padr = rd_padr | ({rd_fwrd_tmp,rd_padr_tmp} << (fwrd_int*BITPADR));
    rd_padr = rd_padr | (rd_padr_wire << (fwrd_int*BITPADR));
  end
end

generate if (1) begin: a1_loop
  algo_mrpnwp_1r1w_base #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT),
                          .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                          .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .WRBUSRED(WRBUSRED),
                          .BITPADR (BITPADR), .SRAM_DELAY (SRAM_DELAY+FLOPECC+FLOPMEM), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .BITDMUX (BITDMUX))
    algo (.clk (clk), .rst (rst), .ready (ready),
          .write (write), 
	  .wr_adr (), 
	  .din (din),
	  .read (read), 
	  .rd_adr (), 
	  .rd_vld (rd_vld), .rd_dout (rd_dout), 
	  .rd_fwrd (rd_fwrd_wire),
	  .rd_serr (rd_serr), 
	  .rd_derr (rd_derr), 
	  .rd_padr (rd_padr_wire),
          .pwrite(pwrite), .pwrbadr(), .pwrradr(), .pdin(pdin),
          .pread(pread), .prdbadr(), .prdradr(),
	  .t1_doutB (pdobus_reg_bus), 
	  .vread_vld_bus(vread_vld_bus), 
	  .vread_padr_bus(vread_padr_bus),
//	  .t1_fwrdB (t1_fwrdB_a1), .t1_serrB (t1_serrB_a1), .t1_derrB (t1_derrB_a1), .t1_padrB (t1_padrB_a1),
	  .t1_fwrdB (t1_fwrdB_a1), .t1_serrB ({NUMVBNK{1'b0}}), .t1_derrB ({NUMVBNK{1'b0}}), //.t1_padrB (t1_padrB_a1),
	  .select_addr (select_addr), .select_bit (select_bit));
end
endgenerate

algo_mrpnwp_1r1w_base_twrap #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                           .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR),
			   .NUMGRPW(NUMGRPW), .GRPWDTH(GRPWDTH), .NUMGRPF(NUMGRPF), .NUMCMDL(NUMCMDL), .BITCMDL(BITCMDL), .WRBUSRED(WRBUSRED),
                          .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .BITDMUX (BITDMUX))
     twrap ( .pwrite(pwrite), .pwrbadr(wr_badr), .pwrradr(wr_radr), .pdin(pdin),
            .vread_bus(pread), .vrdbadr_bus(rd_badr), .vrdradr_bus(rd_radr),
	    .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
            .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
	    .pdobus_reg_bus(pdobus_reg_bus), .vread_vld_bus(vread_vld_bus), .vread_padr_bus(vread_padr_bus), 
            .clk (clk), .rst (rst));

wire [WIDTH-1:0] t1_doutB_a1_wire [0:NUMVBNK-1];
wire t1_fwrdB_a1_wire [0:NUMVBNK-1];
wire t1_serrB_a1_wire [0:NUMVBNK-1];
wire t1_derrB_a1_wire [0:NUMVBNK-1];
wire [(BITSROW+BITWRDS)-1:0] t1_padrB_a1_wire [0:NUMVBNK-1];
wire t1_writeA_wire [0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrA_wire [0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_bwA_wire [0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0] t1_dinA_wire [0:NUMVBNK-1];
wire t1_readB_wire [0:NUMVBNK-1];
wire [BITSROW-1:0] t1_addrB_wire [0:NUMVBNK-1];

assign t1_writeA_a1 = {NUMVBNK{1'b0}};
assign t1_readB_a1 = {NUMVBNK{1'b0}};
assign t1_addrA_a1 = {(NUMVBNK*BITVROW){1'b0}};
assign t1_addrB_a1 = {(NUMVBNK*BITVROW){1'b0}};
assign t1_dinA_a1 = {(NUMVBNK*WIDTH){1'b0}};

genvar t1;
generate for (t1=0; t1<NUMVBNK; t1=t1+1) begin: t1_loop
  wire t1_writeA_a1_wire = t1_writeA_a1 >> t1;
  wire [BITVROW-1:0] t1_addrA_a1_wire = t1_addrA_a1 >> (t1*BITVROW);
  wire [WIDTH-1:0] t1_dinA_a1_wire = t1_dinA_a1 >> (t1*WIDTH);

  wire t1_readB_a1_wire = t1_readB_a1 >> t1;
  wire [BITVROW-1:0] t1_addrB_a1_wire = t1_addrB_a1 >> (t1*BITVROW);

  wire [NUMWRDS*MEMWDTH-1:0] t1_doutB_wire = t1_doutB >> (t1*PHYWDTH);
  wire [NUMWRDS-1:0] t1_serrB_wire = t1_serrB >> t1;

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
  wire [BITSROW-1:0] mem_rd_padr_wire;
  
  if (1) begin: align_loop
    infra_align_ecc_1r1w #(.WIDTH (WIDTH), .ENAPSDO (1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
                           .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITSROW+BITWRDS),
                           .SRAM_DELAY (SRAM_DELAY+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .ENAPADR (1))
      infra (.write (t1_writeA_a1_wire), .wr_adr (t1_addrA_a1_wire), .din (t1_dinA_a1_wire),
             .read (t1_readB_a1_wire), .rd_adr (t1_addrB_a1_wire), .rd_dout (t1_doutB_a1_wire[t1]),
             .rd_fwrd (t1_fwrdB_a1_wire[t1]), .rd_serr(), .rd_derr(), .rd_padr(t1_padrB_a1_wire[t1]),
             .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
             .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
             .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
             .clk (clk), .rst (rst),
             .select_addr (select_vrow));
  end

  if (1) begin: stack_loop
    infra_stack_1r1w #(.WIDTH (NUMWRDS*MEMWDTH), .ENAPSDO (0), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
                       .NUMWROW (NUMSROW), .BITWROW (BITSROW), .NUMWBNK (1), .BITWBNK (0),
                       .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
      infra (.write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
             .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
             .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
             .mem_write (t1_writeA_wire[t1]), .mem_wr_adr (t1_addrA_wire[t1]), .mem_bw(t1_bwA_wire[t1]), .mem_din (t1_dinA_wire[t1]),
             .mem_read (t1_readB_wire[t1]), .mem_rd_adr (t1_addrB_wire[t1]), .mem_rd_dout (t1_doutB_wire),
             .clk (clk), .rst(rst),
             .select_addr (select_srow));
  end
end
endgenerate

//reg [NUMVBNK-1:0] t1_writeA;
//reg [NUMVBNK*BITSROW-1:0] t1_addrA;
reg [NUMVBNK*PHYWDTH-1:0] t1_bwA;
//reg [NUMVBNK*PHYWDTH-1:0] t1_dinA;
//reg [NUMVBNK-1:0] t1_readB;
//reg [NUMVBNK*BITSROW-1:0] t1_addrB;

integer t1_int;
always_comb begin
//  t1_writeA = 0;
//  t1_addrA = 0;
  t1_bwA = 0;
//  t1_dinA = 0;
//  t1_readB = 0;
//  t1_addrB = 0;
//  t1_doutB_a1 = 0;
  t1_fwrdB_a1 = 0;
  t1_serrB_a1 = 0;
  t1_derrB_a1 = 0;
//  t1_padrB_a1 = 0;
  for (t1_int=0; t1_int<NUMVBNK; t1_int=t1_int+1) begin
//    t1_writeA = t1_writeA | (t1_writeA_wire[t1_int] << t1_int);
//    t1_addrA = t1_addrA | (t1_addrA_wire[t1_int] << (t1_int*BITSROW));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1_int] << (t1_int*PHYWDTH));
//    t1_dinA = t1_dinA | (t1_dinA_wire[t1_int] << (t1_int*PHYWDTH));
//    t1_readB = t1_readB | (t1_readB_wire[t1_int] << t1_int);
//    t1_addrB = t1_addrB | (t1_addrB_wire[t1_int] << (t1_int*BITSROW));
//    t1_doutB_a1 = t1_doutB_a1 | (t1_doutB_a1_wire[t1_int] << (t1_int*WIDTH));
    t1_fwrdB_a1 = t1_fwrdB_a1 | (t1_fwrdB_a1_wire[t1_int] << t1_int);
    t1_serrB_a1 = t1_serrB_a1 | (t1_serrB_a1_wire[t1_int] << t1_int);
    t1_derrB_a1 = t1_derrB_a1 | (t1_derrB_a1_wire[t1_int] << t1_int);
//    t1_padrB_a1 = t1_padrB_a1 | (t1_padrB_a1_wire[t1_int] << (t1_int*(BITSROW+BITWRDS)));
  end
end

endmodule
