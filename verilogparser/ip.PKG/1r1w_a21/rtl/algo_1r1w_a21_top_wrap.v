/*
 * Copyright (C) 2011 Memoir Systems Inc. These coded instructions, statements, and computer programs are
 * Confidential Proprietary Information of Memoir Systems Inc. and may not be disclosed to third parties
 * or copied in any form, in whole or in part, without the prior written consent of Memoir Systems Inc.
 * */

module algo_1r1w_a21_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAEXT = 0, parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 48, parameter T1_NUMVBNK = 8, parameter T1_BITVBNK = 3, parameter T1_DELAY = 2, parameter T1_NUMVROW = 4096, parameter T1_BITVROW = 12,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 2, parameter T1_BITWRDS = 1, parameter T1_NUMSROW = 2048, parameter T1_BITSROW = 11, parameter T1_PHYWDTH = 96,
parameter T1_NUMRBNK = 2, parameter T1_BITRBNK = 1, parameter T1_NUMRROW = 256, parameter T1_BITRROW = 8, parameter T1_NUMPROW = 4096, parameter T1_BITPROW = 12,
parameter T1_BITDWSN = 8, 
parameter T1_NUMDWS0 = 0, parameter T1_NUMDWS1 = 0, parameter T1_NUMDWS2 = 0, parameter T1_NUMDWS3 = 0,
parameter T1_NUMDWS4 = 0, parameter T1_NUMDWS5 = 0, parameter T1_NUMDWS6 = 0, parameter T1_NUMDWS7 = 0,
parameter T1_NUMDWS8 = 0, parameter T1_NUMDWS9 = 0, parameter T1_NUMDWS10 = 0, parameter T1_NUMDWS11 = 0,
parameter T1_NUMDWS12 = 0, parameter T1_NUMDWS13 = 0, parameter T1_NUMDWS14 = 0, parameter T1_NUMDWS15 = 0,

parameter T2_WIDTH = 60, parameter T2_NUMVBNK = 2, parameter T2_BITVBNK = 1, parameter T2_DELAY = 2, parameter T2_NUMVROW = 4096, parameter T2_BITVROW = 12, 
parameter T2_BITWSPF = 0, parameter T2_NUMWRDS = 1, parameter T2_BITWRDS = 0, parameter T2_NUMSROW = 4096, parameter T2_BITSROW = 12, parameter T2_PHYWDTH = 60
)
(clk, rst, ready, refr,
  write, wr_adr, din,
  read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
  t1_readA, t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_doutA, t1_dwsnA, t1_refrB, t1_bankB,
  t2_writeA, t2_addrA, t2_readB, t2_addrB, t2_bwA, t2_dinA, t2_doutB);

// MEMOIR_TRANSLATE_OFF
  
  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAEXT = IP_ENAEXT;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;   // ALGO Parameters
  parameter BITVROW = T1_BITVROW;
  parameter BITPROW = T1_BITPROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter BITPBNK = IP_BITPBNK;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;
  parameter REFRESH = IP_REFRESH;      // REFRESH Parameters
  parameter NUMRBNK = T1_NUMRBNK;
  parameter BITWSPF = T1_BITWSPF;
  parameter BITRBNK = T1_BITRBNK;
  parameter NUMRROW = T1_NUMRROW;
  parameter BITRROW = T1_BITRROW;
  parameter REFFREQ = IP_REFFREQ;
  parameter REFFRHF = IP_REFFRHF;
  parameter SRAM_DELAY = T2_DELAY;
  parameter DRAM_DELAY = T1_DELAY;
  parameter PHYWDTH = T1_PHYWDTH;
  parameter ECCBITS = IP_SECCBITS;
  
  parameter BITDWSN = T1_BITDWSN;		//DWSN Parameters
  parameter NUMDWS0 = T1_NUMDWS0;
  parameter NUMDWS1 = T1_NUMDWS1;
  parameter NUMDWS2 = T1_NUMDWS2;
  parameter NUMDWS3 = T1_NUMDWS3;
  parameter NUMDWS4 = T1_NUMDWS4;
  parameter NUMDWS5 = T1_NUMDWS5;
  parameter NUMDWS6 = T1_NUMDWS6;
  parameter NUMDWS7 = T1_NUMDWS7;
  parameter NUMDWS8 = T1_NUMDWS8;
  parameter NUMDWS9 = T1_NUMDWS9;
  parameter NUMDWS10 = T1_NUMDWS10;
  parameter NUMDWS11 = T1_NUMDWS11;
  parameter NUMDWS12 = T1_NUMDWS12;
  parameter NUMDWS13 = T1_NUMDWS13;
  parameter NUMDWS14 = T1_NUMDWS14;
  parameter NUMDWS15 = T1_NUMDWS15;

  parameter BITPADR = BITPBNK+BITSROW+BITWRDS+1;
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input                                refr;

  input                                write;
  input [BITADDR-1:0]                  wr_adr;
  input [WIDTH-1:0]                    din;

  input                                read;
  input [BITADDR-1:0]                  rd_adr;
  output                               rd_vld;
  output [WIDTH-1:0]                   rd_dout;
  output                               rd_serr;
  output                               rd_derr;
  output [BITPADR-1:0]                 rd_padr;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITSROW-1:0] t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  output [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input  [NUMVBNK*PHYWDTH-1:0] t1_doutA;
  output [NUMVBNK*BITDWSN-1:0] t1_dwsnA;

  output [NUMVBNK-1:0] t1_refrB;
  output [NUMVBNK*BITRBNK-1:0] t1_bankB;

  output [2-1:0] t2_writeA;
  output [2*BITVROW-1:0] t2_addrA;
  output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_bwA;
  output [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

  output [2-1:0] t2_readB;
  output [2*BITVROW-1:0] t2_addrB;
  input [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB;
/*
`ifdef AMP_REF
  wire                               rd_vld_rtl;
  wire [WIDTH-1:0]                   rd_dout_rtl;
  wire                               rd_serr_rtl;
  wire                               rd_derr_rtl;
  wire [BITPADR-1:0]                 rd_padr_rtl;

  task Write;
  input [BITADDR-1:0] addr;
  input [WIDTH-1:0] din;
  begin
    algo_ref.bdw_flag[addr] = 1'b1;
    algo_ref.mem[addr] = din;
  end
  endtask
  
  task Read;
  input [BITADDR-1:0] addr;
  output [WIDTH-1:0] dout;
  begin
`ifdef SUPPORTED
    if (algo_ref.mem.exists(addr))
      dout = algo_ref.mem[addr];
    else
      dout = {WIDTH{1'bx}};
`else
    dout = algo_ref.mem[addr];
`endif
  end
  endtask

  task DumpMem;
  begin
    integer file, i;
    file = $fopen ("mem_dump.txt", "w");
    for (i = 0; i < NUMADDR; i = i + 1)
      $fwrite (file, "0x%x 0x%x\n", i, algo_ref.mem[i]);
  end
  endtask

  algo_1r1w_ref #(
    .WIDTH(WIDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .MEM_DELAY(T1_DELAY+FLOPIN+FLOPMEM+FLOPOUT),
    .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
    .NUMSROW(NUMSROW), .BITSROW(BITSROW), .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS),
    .BITPADR(BITPADR)) algo_ref (
    .read_0(read), .addr_0(rd_adr), .read_vld_0(rd_vld), .dout_0(rd_dout),
    .read_serr_0(rd_serr), .read_derr_0(rd_derr), .read_padr_0(rd_padr),
    .write_1(write), .addr_1(wr_adr), .din_1(din), .clk(clk), .rst(rst));
`endif
*/

reg H2O_AMP1R1WA21_001_00;
always @(posedge clk)
  H2O_AMP1R1WA21_001_00 <= rst;
wire rst_int = H2O_AMP1R1WA21_001_00 && rst;
/*
  wire [NUMVBNK-1:0] t1_readA_algo;
  wire [NUMVBNK-1:0] t1_writeA_algo;
  wire [NUMVBNK*BITSROW-1:0] t1_addrA_algo;
  wire [NUMVBNK*PHYWDTH-1:0] t1_bwA_algo;
  wire [NUMVBNK*PHYWDTH-1:0] t1_dinA_algo;
  wire [NUMVBNK*PHYWDTH-1:0] t1_doutA_algo = t1_doutA;
  wire [NUMVBNK*BITDWSN-1:0] t1_dwsnA_algo;

  wire [NUMVBNK-1:0] t1_refrB_algo;
  wire [NUMVBNK*BITRBNK-1:0] t1_bankB_algo;

  wire [2-1:0] t2_writeA_algo;
  wire [2*BITVROW-1:0] t2_addrA_algo;
  wire [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_bwA_algo;
  wire [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA_algo;

  wire [2-1:0] t2_readB_algo;
  wire [2*BITVROW-1:0] t2_addrB_algo;
  wire [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB_algo = t2_doutB;
*/

assign t2_bwA = ~0;

algo_1r1w_rl2_top
			  #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR),
				.NUMVROW(NUMVROW),  .BITVROW(BITVROW),  .NUMVBNK(NUMVBNK),   .BITVBNK(BITVBNK),
				.BITPBNK(BITPBNK),  .NUMWRDS(NUMWRDS),  .BITWRDS(BITWRDS),
				.NUMSROW(NUMSROW),  .BITSROW(BITSROW),  .BITPROW(BITPROW),  .REFRESH(REFRESH),
				.NUMRBNK(NUMRBNK),  .BITWSPF(BITWSPF),  .BITRBNK(BITRBNK),
				.NUMRROW(NUMRROW),  .BITRROW(BITRROW),  .REFFREQ(REFFREQ),  .REFFRHF(REFFRHF),
				.SRAM_DELAY(SRAM_DELAY),  .DRAM_DELAY(DRAM_DELAY),  .FLOPIN(FLOPIN),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT),
				.PHYWDTH(PHYWDTH),  .ECCBITS(ECCBITS),
				.NUMDWS0 (NUMDWS0), .NUMDWS1 (NUMDWS1), .NUMDWS2 (NUMDWS2), .NUMDWS3 (NUMDWS3),
				.NUMDWS4 (NUMDWS4), .NUMDWS5 (NUMDWS5), .NUMDWS6 (NUMDWS6), .NUMDWS7 (NUMDWS7),
				.NUMDWS8 (NUMDWS8), .NUMDWS9 (NUMDWS9), .NUMDWS10 (NUMDWS10), .NUMDWS11 (NUMDWS11),
				.NUMDWS12 (NUMDWS12), .NUMDWS13 (NUMDWS13), .NUMDWS14 (NUMDWS14), .NUMDWS15 (NUMDWS15),
				.BITDWSN (BITDWSN))
		algo_top	  
			(.clk(clk), .rst(rst_int), .ready(ready), .refr(refr),
			 .write(write), .wr_adr(wr_adr), .din(din),
                         .read(read), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr),
			 .t1_readA(t1_readA), .t1_writeA(t1_writeA), .t1_addrA(t1_addrA),
                         .t1_bwA(t1_bwA), .t1_dwsnA(t1_dwsnA), .t1_dinA(t1_dinA), .t1_doutA(t1_doutA),
			 .t1_refrB(t1_refrB), .t1_bankB(t1_bankB),
			 .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA),
                         .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB));
 

/*
  reg [NUMVBNK-1:0] t1_readA;
  reg [NUMVBNK-1:0] t1_writeA;
  reg [NUMVBNK*BITSROW-1:0] t1_addrA;
  reg [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  reg [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  reg [NUMVBNK*BITDWSN-1:0] t1_dwsnA;
  reg [NUMVBNK-1:0] t1_dbg_readA;

  reg [NUMVBNK-1:0] t1_refrB;
  reg [NUMVBNK*BITRBNK-1:0] t1_bankB;

  reg [2-1:0] t2_writeA;
  reg [2*BITVROW-1:0] t2_addrA;
  reg [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_bwA;
  reg [2*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

  reg [2-1:0] t2_readB;
  reg [2*BITVROW-1:0] t2_addrB;
  reg [2-1:0] t2_dbg_readB;

  always_comb begin
    t1_readA = t1_readA_algo;
    t1_writeA = t1_writeA_algo;
    t1_addrA = t1_addrA_algo;
    t1_bwA = t1_bwA_algo;
    t1_dinA = t1_dinA_algo;
    t1_dwsnA = t1_dwsnA_algo;
    t1_dbg_readA = 0;
    t1_refrB = t1_refrB_algo;
    t1_bankB = t1_bankB_algo;
    t2_writeA = t2_writeA_algo;
    t2_addrA = t2_addrA_algo;
    t2_bwA = ~0;
    t2_dinA = t2_dinA_algo;
    t2_readB = t2_readB_algo;
    t2_addrB = t2_addrB_algo;
    t2_dbg_readB = 0;
    if ((dbg_bank<T1_NUMVBNK) && (dbg_read || dbg_write)) begin
      t1_readA = dbg_read << dbg_bank;
      t1_writeA = dbg_write << dbg_bank;
      t1_addrA = dbg_addr << (dbg_bank*T1_BITSROW);
      t1_bwA = ~0;
      t1_dwsnA = 0;
      t1_dinA = dbg_din << (dbg_bank*T1_PHYWDTH);
      t1_dbg_readA = dbg_read << dbg_bank;
      t1_refrB = 0;
    end else if ((dbg_bank>=T1_NUMVBNK) && (dbg_bank<T1_NUMVBNK+T2_NUMVBNK) && (dbg_read || dbg_write)) begin
      t2_writeA = dbg_write << (dbg_bank-T1_NUMVBNK);
      t2_addrA = dbg_addr << ((dbg_bank-T1_NUMVBNK)*T2_BITSROW);    
      t2_bwA = ~0;
      t2_dinA = dbg_din << ((dbg_bank-T1_NUMVBNK)*T2_PHYWDTH);
      t2_readB = dbg_read << (dbg_bank-T1_NUMVBNK);
      t2_addrB = dbg_addr << ((dbg_bank-T1_NUMVBNK)*T2_BITSROW);    
      t2_readB = dbg_read << (dbg_bank-T1_NUMVBNK);
      t2_dbg_readB = dbg_read << (dbg_bank-T1_NUMVBNK);
    end
  end

  reg [NUMVBNK-1:0] t1_dbg_readA_reg [0:T1_DELAY-1];
  integer t1d_int;
  always @(posedge clk)
    for (t1d_int=0; t1d_int<T1_DELAY; t1d_int=t1d_int+1)
      if (t1d_int>0)
        t1_dbg_readA_reg[t1d_int] <= t1_dbg_readA_reg[t1d_int-1];
      else
        t1_dbg_readA_reg[t1d_int] <= t1_dbg_readA;
    
  reg [2-1:0] t2_dbg_readB_reg [0:T2_DELAY-1];
  integer t2d_int;
  always @(posedge clk)
    for (t2d_int=0; t2d_int<T2_DELAY; t2d_int=t2d_int+1)
      if (t2d_int>0)
        t2_dbg_readB_reg[t2d_int] <= t2_dbg_readB_reg[t2d_int-1];
      else
        t2_dbg_readB_reg[t2d_int] <= t2_dbg_readB;

  reg dbg_vld;
  reg [DBGWDTH-1:0] dbg_dout;
  integer dbg_int;
  always_comb begin
    dbg_vld = 0;
    dbg_dout = 0;
    for (dbg_int=0; dbg_int<NUMDBNK; dbg_int=dbg_int+1)
      if ((dbg_int<T1_NUMVBNK) && t1_dbg_readA_reg[T1_DELAY-1][dbg_int]) begin
        dbg_vld = 1'b1;
        dbg_dout = (t1_doutA >> (dbg_int*T1_PHYWDTH)) & {T1_PHYWDTH{1'b1}};
      end else if ((dbg_int>=T1_NUMVBNK) && (dbg_int<T1_NUMVBNK+T2_NUMVBNK) && t2_dbg_readB_reg[T2_DELAY-1][dbg_int-T1_NUMVBNK]) begin
        dbg_vld = 1'b1;
        dbg_dout = (t2_doutB >> ((dbg_int-T1_NUMVBNK)*T2_PHYWDTH)) & {T2_PHYWDTH{1'b1}};
      end
  end
*/
// MEMOIR_TRANSLATE_ON
endmodule    //algo_1r1w_a21_top_wrap
