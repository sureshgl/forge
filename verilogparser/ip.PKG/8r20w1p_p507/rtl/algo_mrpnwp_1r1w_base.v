
module algo_mrpnwp_1r1w_base (clk, rst, ready,
                              write, din,
                              read, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
                              pwrite, pdin,
                              pread, 
	                      t1_doutB,
			      vread_vld_bus, vread_padr_bus);
  
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
  input [(4+16/WRBUSRED)*WIDTH-1:0]  din;

  input [NUMRDPT-1:0]                   read;
  output [NUMRDPT-1:0]                  rd_vld;
  output [NUMRDPT*WIDTH-1:0]            rd_dout;
  output [NUMRDPT-1:0]                  rd_fwrd;
  output [NUMRDPT-1:0]                  rd_serr;
  output [NUMRDPT-1:0]                  rd_derr;
  output [NUMRDPT*BITPADR-1:0]          rd_padr;

  output                                ready;
  input                                 clk, rst;

  input [NUMRDPT*WIDTH-1:0]             t1_doutB;
  input [NUMRDPT-1:0] 			vread_vld_bus;
  input [(BITPADR*NUMRDPT)-1:0] 	vread_padr_bus;

  output [NUMWRPT-1:0] pwrite;
  output [(WIDTH*(4+16/WRBUSRED))-1:0]   pdin;
  output [NUMRDPT-1:0] pread;



  core_mrpnwp_1r1w_base #(.WIDTH (WIDTH), .BITWDTH (BITWDTH), .NUMRDPT (NUMRDPT), .NUMWRPT (NUMWRPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                          .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPADR (BITPADR), .WRBUSRED(WRBUSRED),
                          .SRAM_DELAY (SRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT), .BITDMUX (BITDMUX))
      core (.vwrite(write), .vdin(din),
	    .vread(read), .vread_vld(rd_vld), .vdout(rd_dout), 
            .vread_fwrd(rd_fwrd), .vread_serr(rd_serr), .vread_derr(rd_derr), .vread_padr(rd_padr),
	    .pwrite(pwrite), .pdin(pdin), 
	    .pread(pread), 
            .t1_doutB(t1_doutB), 
	    .vread_vld_bus(vread_vld_bus), .vread_padr_bus(vread_padr_bus),
	    .ready (ready), .clk (clk), .rst (rst));




endmodule


