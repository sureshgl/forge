
module algo_mrnrwpw_1rw_mt (refr, read, write, addr, din, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	                    t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA, t1_refrB,
	                    t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, 
	                    clk, rst, ready,
	                    select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;

  parameter NUMRDPT = 1;
  parameter NUMRWPT = 1;
  parameter NUMWRPT = 2;

  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMPBNK = 11;
  parameter BITPBNK = 4;
  parameter BITPADR = 14;

  parameter REFRESH = 0;
  parameter ECCBITS = 8;

  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 1;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter DISCORR = 0;

  parameter BITMAPT = BITPBNK*NUMPBNK;
  parameter SDOUT_WIDTH = 2*BITMAPT+ECCBITS;

  input                                          refr;

  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]          read;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]          write;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITADDR-1:0]  addr;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]    din;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]         rd_vld;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]   rd_dout;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]         rd_fwrd;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]         rd_serr;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]         rd_derr;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0] rd_padr;

  output                       ready;
  input                        clk;
  input                        rst;

  input [BITADDR-1:0]          select_addr;
  input [BITWDTH-1:0]          select_bit;

  output [(NUMRDPT+NUMRWPT)*NUMPBNK-1:0] t1_readA;
  output [(NUMRDPT+NUMRWPT)*NUMPBNK-1:0] t1_writeA;
  output [(NUMRDPT+NUMRWPT)*NUMPBNK*BITVROW-1:0] t1_addrA;
  output [(NUMRDPT+NUMRWPT)*NUMPBNK*WIDTH-1:0] t1_dinA;
  input [(NUMRDPT+NUMRWPT)*NUMPBNK*WIDTH-1:0] t1_doutA;
  input [(NUMRDPT+NUMRWPT)*NUMPBNK-1:0] t1_fwrdA;
  input [(NUMRDPT+NUMRWPT)*NUMPBNK-1:0] t1_serrA;
  input [(NUMRDPT+NUMRWPT)*NUMPBNK-1:0] t1_derrA;
  input [(NUMRDPT+NUMRWPT)*NUMPBNK*(BITPADR-BITPBNK)-1:0] t1_padrA;
  output [(NUMRDPT+NUMRWPT)*NUMPBNK-1:0] t1_refrB;

  output [(NUMRWPT+NUMWRPT-!NUMRDPT)-1:0] t2_writeA;
  output [(NUMRWPT+NUMWRPT-!NUMRDPT)*BITVROW-1:0] t2_addrA;
  output [(NUMRWPT+NUMWRPT-!NUMRDPT)*SDOUT_WIDTH-1:0] t2_dinA;

  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrB;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB;

wire                                                 prefr;
wire [(NUMRWPT+NUMWRPT)-1:0]                         pwrite;
wire [(NUMRWPT+NUMWRPT)*BITPBNK-1:0]                 pwrbadr;
wire [(NUMRWPT+NUMWRPT)*BITVROW-1:0]                 pwrradr;
wire [(NUMRWPT+NUMWRPT)*WIDTH-1:0]                   pdin;
wire [(NUMRDPT+NUMRWPT)-1:0]                         pread;
wire [(NUMRDPT+NUMRWPT)*BITPBNK-1:0]                 prdbadr;
wire [(NUMRDPT+NUMRWPT)*BITVROW-1:0]                 prdradr;
wire [(NUMRDPT+NUMRWPT)*WIDTH-1:0]                   pdout;
wire [(NUMRDPT+NUMRWPT)-1:0]                         pdout_fwrd;
wire [(NUMRDPT+NUMRWPT)-1:0]                         pdout_serr;
wire [(NUMRDPT+NUMRWPT)-1:0]                         pdout_derr;
wire [(NUMRDPT+NUMRWPT)*BITPADR-1:0]                 pdout_padr;
wire [(NUMRWPT+NUMWRPT-!NUMRDPT)-1:0]                swrite;
wire [(NUMRWPT+NUMWRPT-!NUMRDPT)*BITVROW-1:0]        swrradr;
wire [(NUMRWPT+NUMWRPT-!NUMRDPT)*SDOUT_WIDTH-1:0]    sdin;
wire [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]                 sread;
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0]         srdradr;
wire [(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0]     sdout;

core_mrnrwpw_1rw_mt #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMRDPT (NUMRDPT), .NUMRWPT (NUMRWPT), .NUMWRPT (NUMWRPT),
                      .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .NUMPBNK (NUMPBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR),
                      .REFRESH (REFRESH), .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT),
                      .DISCORR (DISCORR), .ECCBITS (ECCBITS))
    core (.vrefr (refr), .vread (read), .vwrite (write), .vaddr (addr), .vdin (din),
	  .vread_vld (rd_vld), .vdout (rd_dout), .vread_fwrd (rd_fwrd), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
          .prefr (prefr), .pwrite (pwrite), .pwrbadr (pwrbadr), .pwrradr (pwrradr), .pdin (pdin),
          .pread (pread), .prdbadr (prdbadr), .prdradr (prdradr), .pdout (pdout),
          .pdout_fwrd (pdout_fwrd), .pdout_serr (pdout_serr), .pdout_derr (pdout_derr), .pdout_padr (pdout_padr),
          .swrite (swrite), .swrradr (swrradr), .sdin (sdin),
          .sread (sread), .srdradr (srdradr), .sdout (sdout),
          .ready (ready), .clk (clk), .rst (rst),
	  .select_addr (select_addr), .select_bit (select_bit));

mux_mrnrwpw_1rw_mt #(.WIDTH (WIDTH), .NUMRDPT (NUMRDPT), .NUMRWPT (NUMRWPT), .NUMWRPT (NUMWRPT),
	     	     .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMPBNK (NUMPBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR),
                     .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .ECCBITS (ECCBITS))
    mux (.clk(clk), .rst(rst), 
         .prefr (prefr), .pwrite(pwrite), .pwrbadr(pwrbadr), .pwrradr(pwrradr), .pdin(pdin),
         .pread(pread), .prdbadr(prdbadr), .prdradr(prdradr), .pdout(pdout),
         .pdout_fwrd(pdout_fwrd), .pdout_serr(pdout_serr), .pdout_derr(pdout_derr), .pdout_padr (pdout_padr),
         .swrite(swrite), .swrradr(swrradr), .sdin(sdin),
         .sread(sread), .srdradr(srdradr), .sdout(sdout),
         .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
         .t1_doutA(t1_doutA), .t1_fwrdA(t1_fwrdA), .t1_serrA(t1_serrA), .t1_derrA(t1_derrA), .t1_padrA(t1_padrA),
         .t1_refrB(t1_refrB),
         .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA),
         .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB));


`ifdef FORMAL

//wire [BITADDR-1:0] select_addr;
//wire [BITWDTH-1:0] select_bit;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr==0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit==0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_mrnrwpw_1rw_mt #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRDPT     (NUMRDPT),
     .NUMRWPT     (NUMRWPT),
     .NUMWRPT     (NUMWRPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .ECCBITS     (ECCBITS),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);


ip_top_sva_2_mrnrwpw_1rw_mt #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRDPT     (NUMRDPT),
     .NUMRWPT     (NUMRWPT),
     .NUMWRPT     (NUMWRPT),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .ECCBITS     (ECCBITS))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_mrnrwpw_1rw_mt #(
     .WIDTH       (WIDTH),
     .BITWDTH     (BITWDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRDPT     (NUMRDPT),
     .NUMRWPT     (NUMRWPT),
     .NUMWRPT     (NUMWRPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .ECCBITS     (ECCBITS),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_mrnrwpw_1rw_mt #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRDPT     (NUMRDPT),
     .NUMRWPT     (NUMRWPT),
     .NUMWRPT     (NUMWRPT),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMPBNK     (NUMPBNK),
     .BITPBNK     (BITPBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .ECCBITS     (ECCBITS))
ip_top_sva_2 (.*);

`endif

endmodule
