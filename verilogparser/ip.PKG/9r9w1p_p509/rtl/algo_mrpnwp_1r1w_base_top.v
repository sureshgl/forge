
module algo_mrpnwp_1r1w_base_top (clk, rst, ready,
                                  write, wr_badr, wr_radr, din,
                                  read, rd_badr, rd_radr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
	                          t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB);
  
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

  parameter SRAM_DELAY = 2;
  parameter FLOPECC = 0;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;
  parameter BITDMUX = 0;
  parameter MEMWDTH = ENAEXT ? WIDTH : ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;

  parameter NUMRDPT = 12;
  parameter NUMWRPT = 24;
  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;

  input [NUMWRPT-1:0]               write;
  input [(NUMWRPT*BITVBNK)-1:0]     wr_badr;
  input [(NUMWRPT*BITVROW)-1:0]     wr_radr;
  input [NUMWRPT*WIDTH-1:0] din;

  input [NUMRDPT-1:0]            read;
  input [(NUMRDPT*BITVBNK)-1:0]  rd_badr;
  input [(NUMRDPT*BITVROW)-1:0]  rd_radr;
  output [NUMRDPT-1:0]           rd_vld;
  output [NUMRDPT*WIDTH-1:0]     rd_dout;
  output [NUMRDPT-1:0]           rd_serr;
  output [NUMRDPT-1:0]           rd_derr;
  output [NUMRDPT*BITPADR-1:0]   rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMGRPW*NUMVBNK-1:0] 		t1_writeA;
  output [NUMGRPW*NUMVBNK*BITVROW-1:0] 	t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] 		t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] 		t1_dinA;
  output [NUMGRPW*NUMVBNK-1:0] 		t1_readB;
  output [NUMGRPW*NUMVBNK*BITSROW-1:0] 	t1_addrB;
  input [NUMVBNK*PHYWDTH-1:0] 		t1_doutB;

  wire [NUMWRPT-1:0] pwrite;
  wire [WIDTH*NUMWRPT-1:0]   pdin;
  wire [NUMRDPT-1:0] pread;
  wire [WIDTH*NUMRDPT-1:0] pdobus_reg_bus;
  wire [NUMRDPT-1:0] vread_vld_bus;
  wire[(BITPADR*NUMRDPT)-1:0] vread_padr_bus;


`ifdef FORMAL
wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
`else
wire [BITADDR-1:0] select_addr = 0;
wire [BITWDTH-1:0] select_bit = 0;
`endif

reg [NUMRDPT*BITPADR-1:0] rd_padr;
reg [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  
wire [NUMRDPT-1:0] rd_fwrd;
wire [NUMRDPT*BITPADR-1:0] rd_padr_wire;

integer fwrd_int;
always_comb begin
  t1_bwA = 0;
end

generate if (1) begin: a1_loop
  algo_mrpnwp_1r1w_base #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT),
                          .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                          .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), 
                          .BITPADR (BITPADR), .SRAM_DELAY (SRAM_DELAY+FLOPECC+FLOPMEM), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .BITDMUX (BITDMUX))
    algo (.clk (clk), .rst (rst), .ready (ready),
          .write (write), 
	  .din (din),
	  .read (read), 
	  .rd_vld (rd_vld), .rd_dout (rd_dout), 
	  .rd_fwrd (rd_fwrd),
	  .rd_serr (rd_serr), 
	  .rd_derr (rd_derr), 
//	  .rd_padr (rd_padr_wire),
	  .rd_padr (rd_padr),
          .pwrite(pwrite),
          .pdin(pdin),
          .pread(pread),
	  .t1_doutB (pdobus_reg_bus), 
	  .vread_vld_bus(vread_vld_bus), 
	  .vread_padr_bus(vread_padr_bus));
//	  .t1_fwrdB ({NUMVBNK{1'b0}}), .t1_serrB ({NUMVBNK{1'b0}}), .t1_derrB ({NUMVBNK{1'b0}}));
//	  .select_addr (select_addr), .select_bit (select_bit));
end
endgenerate

algo_mrpnwp_1r1w_base_twrap #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                           .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR),
			   .NUMGRPW(NUMGRPW), .GRPWDTH(GRPWDTH), .NUMGRPF(NUMGRPF), .NUMCMDL(NUMCMDL), .BITCMDL(BITCMDL), 
                          .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .BITDMUX (BITDMUX))
     twrap ( .pwrite(pwrite), .pwrbadr(wr_badr), .pwrradr(wr_radr), .pdin(pdin),
            .vread_bus(pread), .vrdbadr_bus(rd_badr), .vrdradr_bus(rd_radr),
	    .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
            .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
	    .pdobus_reg_bus(pdobus_reg_bus), .vread_vld_bus(vread_vld_bus), .vread_padr_bus(vread_padr_bus), 
            .clk (clk));


`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_mrpnwp_1r1w_base #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT),
     .BITDMUX     (BITDMUX),
     .NUMGRPW     (NUMGRPW),
     .GRPWDTH     (GRPWDTH),
     .NUMGRPF     (NUMGRPF),
     .NUMCMDL     (NUMCMDL),
     .BITCMDL     (BITCMDL))

ip_top_sva (.*);

ip_top_sva_2_mrpnwp_1r1w_base #(
     .WIDTH       (WIDTH),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMGRPW     (NUMGRPW))

ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_mrpnwp_1r1w_base #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .BITPADR     (BITPADR),
     .SRAM_DELAY  (SRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT),
     .NUMGRPW     (NUMGRPW),
     .GRPWDTH     (GRPWDTH),
     .NUMGRPF     (NUMGRPF),
     .NUMCMDL     (NUMCMDL),
     .BITCMDL     (BITCMDL))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_mrpnwp_1r1w_base #(
     .WIDTH       (WIDTH),
     .NUMRDPT     (NUMRDPT),
     .NUMWRPT     (NUMWRPT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMGRPW     (NUMGRPW))
ip_top_sva_2 (.*);

`endif

endmodule
