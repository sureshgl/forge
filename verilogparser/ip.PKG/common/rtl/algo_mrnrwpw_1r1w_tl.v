
module algo_mrnrwpw_1r1w_tl (refr, read, write, addr, din, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                             t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_serrA, t1_derrA, t1_padrA, t1_refrB,
	                     t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
	                     t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB,
	                     clk, rst, ready,
	                     select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;

  parameter NUMRDPT = 1;
  parameter NUMRWPT = 1;
  parameter NUMWRPT = 2;

  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 15;

  parameter REFRESH = 0;
  parameter ECCBITS = 4;

  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 1;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;
  parameter NUMCASH = 2*(NUMRDPT+NUMRWPT+NUMWRPT-1)-1;

  input                                          refr;

  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]          read;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]          write;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*BITADDR-1:0]  addr;
  input [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]    din;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]         rd_vld;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]   rd_dout;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]         rd_serr;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]         rd_derr;
  output [(NUMRDPT+NUMRWPT+NUMWRPT)*BITPADR-1:0] rd_padr;

  output                       ready;
  input                        clk;
  input                        rst;

  input [BITADDR-1:0]          select_addr;
  input [BITWDTH-1:0]          select_bit;

  output [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_readA;
  output [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_writeA;
  output [(NUMRDPT+NUMRWPT)*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [(NUMRDPT+NUMRWPT)*NUMVBNK*WIDTH-1:0] t1_dinA;
  input [(NUMRDPT+NUMRWPT)*NUMVBNK*WIDTH-1:0] t1_doutA;
  input [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_serrA;
  input [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_derrA;
  input [(NUMRDPT+NUMRWPT)*NUMVBNK*(BITPADR-BITPBNK-1)-1:0] t1_padrA;
  output [(NUMRDPT+NUMRWPT)*NUMVBNK-1:0] t1_refrB;

  output [NUMCASH*(NUMRWPT+NUMWRPT)-1:0] t2_writeA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrA;
  output [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_dinA;

  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t2_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t2_addrB;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0] t2_doutB;

  output [NUMCASH-1:0] t3_writeA;
  output [NUMCASH*BITVROW-1:0] t3_addrA;
  output [NUMCASH*WIDTH-1:0] t3_dinA;

  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0] t3_readB;
  output [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0] t3_addrB;
  input [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0] t3_doutB;

wire [(NUMRWPT+NUMWRPT)-1:0]                         pwrite;
wire [(NUMRWPT+NUMWRPT)*BITVBNK-1:0]                 pwrbadr;
wire [(NUMRWPT+NUMWRPT)*BITVROW-1:0]                 pwrradr;
wire [(NUMRWPT+NUMWRPT)*WIDTH-1:0]                   pdin;
wire [(NUMRDPT+NUMRWPT)-1:0]                         pread;
wire [(NUMRDPT+NUMRWPT)*BITVBNK-1:0]                 prdbadr;
wire [(NUMRDPT+NUMRWPT)*BITVROW-1:0]                 prdradr;
wire [(NUMRDPT+NUMRWPT)*WIDTH-1:0]                   pdout;
wire [(NUMRDPT+NUMRWPT)-1:0]                         pdout_serr;
wire [(NUMRDPT+NUMRWPT)-1:0]                         pdout_derr;
wire [(NUMRDPT+NUMRWPT)*(BITPADR-BITPBNK-1)-1:0]     pdout_padr; 
wire [NUMCASH*(NUMRWPT+NUMWRPT)-1:0]                 swrite;
wire [NUMCASH*(NUMRWPT+NUMWRPT)*BITVROW-1:0]         swrradr;
wire [NUMCASH*(NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0]     sdin;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]                 sread;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0]         srdradr;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*SDOUT_WIDTH-1:0]     sdout;
wire [NUMCASH-1:0]                 cwrite;
wire [NUMCASH*BITVROW-1:0]         cwrradr;
wire [NUMCASH*WIDTH-1:0]           cdin;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)-1:0]                 cread;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*BITVROW-1:0]         crdradr;
wire [NUMCASH*(NUMRDPT+NUMRWPT+NUMWRPT)*WIDTH-1:0]           cdout;

core_mrnrwpw_1r1w_tl #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .NUMRDPT (NUMRDPT), .NUMRWPT (NUMRWPT), .NUMWRPT (NUMWRPT),
                       .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITPADR),
                       .REFRESH (REFRESH), .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .ECCBITS (ECCBITS))
    core (.vrefr (refr), .vread (read), .vwrite (write), .vaddr (addr), .vdin (din),
          .vread_vld (rd_vld), .vdout (rd_dout), .vread_serr (rd_serr), .vread_derr (rd_derr), .vread_padr (rd_padr),
          .prefr (prefr), .pwrite (pwrite), .pwrbadr (pwrbadr), .pwrradr (pwrradr), .pdin (pdin),
          .pread (pread), .prdbadr (prdbadr), .prdradr (prdradr), .pdout (pdout), .pdout_serr (pdout_serr), .pdout_derr (pdout_derr), .pdout_padr (pdout_padr),
          .swrite (swrite), .swrradr (swrradr), .sdin (sdin),
          .sread (sread), .srdradr (srdradr), .sdout (sdout),
          .cwrite (cwrite), .cwrradr (cwrradr), .cdin (cdin),
          .cread (cread), .crdradr (crdradr), .cdout (cdout),
          .ready (ready), .clk (clk), .rst (rst),
          .select_addr (select_addr), .select_bit (select_bit));

mux_mrnrwpw_1r1w_tl #(.WIDTH (WIDTH), .NUMRDPT (NUMRDPT), .NUMRWPT (NUMRWPT), .NUMWRPT (NUMWRPT),
                      .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .NUMVROW (NUMVROW), .BITVROW (BITVROW), .BITPADR (BITPADR-BITPBNK-1),
                      .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .ECCBITS (ECCBITS))
    mux (.clk(clk), .rst(rst),
         .prefr (prefr), .pwrite(pwrite), .pwrbadr(pwrbadr), .pwrradr(pwrradr), .pdin(pdin),
         .pread(pread), .prdbadr(prdbadr), .prdradr(prdradr), .pdout(pdout), .pdout_serr(pdout_serr), .pdout_derr(pdout_derr), .pdout_padr (pdout_padr),
         .swrite(swrite), .swrradr(swrradr), .sdin(sdin),
         .sread(sread), .srdradr(srdradr), .sdout(sdout),
         .cwrite(cwrite), .cwrradr(cwrradr), .cdin(cdin),
         .cread(cread), .crdradr(crdradr), .cdout(cdout),
         .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA),
         .t1_doutA(t1_doutA), .t1_serrA(t1_serrA), .t1_derrA(t1_derrA), .t1_padrA(t1_padrA),
         .t1_refrB(t1_refrB),
         .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA),
         .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB),
         .t3_writeA(t3_writeA), .t3_addrA(t3_addrA), .t3_dinA(t3_dinA),
         .t3_readB(t3_readB), .t3_addrB(t3_addrB), .t3_doutB(t3_doutB));

`ifdef FORMAL

//wire [BITADDR-1:0] select_addr;
//wire [BITWDTH-1:0] select_bit;
//assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr==0));
//assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit==0));
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_mrnrwpw_1r1w_tl #(
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
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .REFRESH     (REFRESH),
     .ECCBITS     (ECCBITS),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);


ip_top_sva_2_mrnrwpw_1r1w_tl #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRDPT     (NUMRDPT),
     .NUMRWPT     (NUMRWPT),
     .NUMWRPT     (NUMWRPT),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .REFRESH     (REFRESH),
     .ECCBITS     (ECCBITS))
ip_top_sva_2 (.*);


`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
  wire [BITWDTH-1:0] help_bit = sva_int;
ip_top_sva_mrnrwpw_1r1w_tl #(
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
     .BITPBNK     (BITPBNK),
     .BITPADR     (BITPADR),
     .REFRESH     (REFRESH),
     .ECCBITS     (ECCBITS),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);

ip_top_sva_2_mrnrwpw_1r1w_tl #(
     .WIDTH       (WIDTH),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMRDPT     (NUMRDPT),
     .NUMRWPT     (NUMRWPT),
     .NUMWRPT     (NUMWRPT),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .REFRESH     (REFRESH),
     .ECCBITS     (ECCBITS))
ip_top_sva_2 (.select_addr(help_addr), .*);

end
endgenerate

`endif
endmodule
