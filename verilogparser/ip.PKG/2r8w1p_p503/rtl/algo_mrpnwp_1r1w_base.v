
module algo_mrpnwp_1r1w_base (clk, rst, ready,
                              write, wr_adr, din,
                              read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                              pwrite, pwrbadr, pwrradr, pdin,
                              pread, prdbadr, prdradr,
	                      t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, // t1_padrB,
			      vread_vld_bus, vread_padr_bus,
	                      select_addr, select_bit);
  
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter NUMRDPT = 2;
  parameter NUMWRPT = 3;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPADR = 13;
  parameter WRBUSRED = 1;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter BITDMUX = 0;

  input [NUMWRPT-1:0]                   write;
  input [NUMWRPT*BITADDR-1:0]           wr_adr;
  input [(NUMWRPT/WRBUSRED)*WIDTH-1:0]  din;

  input [NUMRDPT-1:0]                   read;
  input [NUMRDPT*BITADDR-1:0]           rd_adr;
  output [NUMRDPT-1:0]                  rd_vld;
  output [NUMRDPT*WIDTH-1:0]            rd_dout;
  output [NUMRDPT-1:0]                  rd_fwrd;
  output [NUMRDPT-1:0]                  rd_serr;
  output [NUMRDPT-1:0]                  rd_derr;
  output [NUMRDPT*BITPADR-1:0]          rd_padr;

  output                                ready;
  input                                 clk, rst;

  input [BITADDR-1:0]                   select_addr;
  input [BITWDTH-1:0]                   select_bit;

  input [NUMRDPT*WIDTH-1:0]             t1_doutB;
  input [NUMRDPT-1:0] 			vread_vld_bus;
  input [(BITPADR*NUMRDPT)-1:0] 	vread_padr_bus;

  input [NUMVBNK-1:0]                   t1_fwrdB;
  input [NUMVBNK-1:0]                   t1_serrB;
  input [NUMVBNK-1:0]                   t1_derrB;

  output [NUMWRPT-1:0] pwrite;
  output [(BITVBNK*NUMWRPT)-1:0] pwrbadr;
  output [(BITVROW*NUMWRPT)-1:0] pwrradr;
  output [(WIDTH*(NUMWRPT/WRBUSRED))-1:0]   pdin;
  output [NUMRDPT-1:0] pread;
  output [(BITVBNK*NUMRDPT)-1:0] prdbadr;
  output [(BITVROW*NUMRDPT)-1:0] prdradr;



  core_mrpnwp_1r1w_base #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                          .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR), .WRBUSRED(WRBUSRED),
                          .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .BITDMUX (BITDMUX))
      core (.vwrite(write), .vwraddr(), .vdin(din),
	    .vread(read), .vrdaddr(), .vread_vld(rd_vld), .vdout(rd_dout), 
            .vread_fwrd(rd_fwrd), .vread_serr(rd_serr), .vread_derr(rd_derr), .vread_padr(rd_padr),
	    .pwrite(pwrite), .pwrbadr(), .pwrradr(), .pdin(pdin), 
	    .pread(pread), .prdbadr(), .prdradr(),
            .t1_doutB(t1_doutB), .t1_fwrdB(t1_fwrdB), .t1_serrB(t1_serrB), .t1_derrB(t1_derrB), //.t1_padrB(t1_padrB),
	    .vread_vld_bus(vread_vld_bus), .vread_padr_bus(vread_padr_bus),
	    .ready (ready), .clk (clk), .rst (rst));


`ifdef FORMAL
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
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
     .BITDMUX     (BITDMUX))

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
     .BITVBNK     (BITVBNK))

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
     .FLOPOUT     (FLOPOUT))
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
     .BITVBNK     (BITVBNK))
ip_top_sva_2 (.*);

`endif

endmodule

