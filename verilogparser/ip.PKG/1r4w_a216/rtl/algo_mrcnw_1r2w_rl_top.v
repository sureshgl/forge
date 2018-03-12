module algo_mrcnw_1r2w_rl_top (
  clk, rst, ready,
  write, wr_adr, din,
  read, rd_clr, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
  t1_readB,   t1_addrB,  t1_doutB,  t1_writeA,  t1_addrA,  t1_dinA,  t1_bwA,
  t2_readB,   t2_addrB,  t2_doutB,  t2_writeA,  t2_addrA,  t2_dinA,  t2_bwA,
  t3_readB,   t3_addrB,  t3_doutB,  t3_writeA,  t3_addrA,  t3_dinA,  t3_bwA,
  t4_readB,   t4_addrB,  t4_doutB,  t4_writeA,  t4_addrA,  t4_dinA,  t4_bwA
);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMRDPT = 1;
  parameter NUMWRPT = 4;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVBNK = 4;
  parameter BITVBNK = 2;
  parameter BITPBNK = 3;
  parameter NUMVROW = 2048;
  parameter BITVROW = 11;
  parameter NUMWRDS = 4;     // ALIGN Parameters
  parameter BITWRDS = 2;
  parameter NUMSROW = 2048;
  parameter BITSROW = 11;
  parameter PHYWDTH = NUMWRDS*MEMWDTH;
  parameter NUMWROW = NUMSROW; // STACK Parameters
  parameter BITWROW = BITSROW;
  parameter NUMWBNK = 1;
  parameter BITWBNK = 0;
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 0;
  parameter FLOPOUT = 0;

  
  parameter NUMDBNK = NUMWRPT/2;
  parameter BITDBNK = 1;
  parameter BITPADR = 1+BITPBNK+BITSROW+BITWRDS+1;
  parameter BITDPDR = BITPBNK+BITSROW+BITWRDS+1;

  parameter ECCBITS = 4;
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  parameter NUMCBNK = 3;    // this is for a3 1ru2w_c35 algo
  parameter BITCBNK = 2;
  parameter NUMSTPT = 2;
  parameter NUMCWDS = 22;      // C35 ALIGN Parameters
  parameter BITCWDS = 5;
  parameter NUMCSRW = 2048;
  parameter BITCSRW = 11;
  parameter NUMCWRW = NUMCSRW; // C35 STACK Parameters
  parameter BITCWRW = BITCSRW;
  parameter PHCWDTH = NUMCWDS*2;
  parameter BITCPDR = BITCBNK+BITCSRW+BITCWDS+1;
  parameter UPDT_DELAY = 0;

  input  [NUMWRPT-1:0]           write;
  input  [NUMWRPT*BITADDR-1:0]   wr_adr;
  input  [NUMWRPT*WIDTH-1:0]     din;
         
  input  [NUMRDPT-1:0]           read;
  input  [NUMRDPT-1:0]           rd_clr;
  input  [NUMRDPT*BITADDR-1:0]   rd_adr;
  output [NUMRDPT-1:0]           rd_vld;
  output [NUMRDPT*WIDTH-1:0]     rd_dout;
  output [NUMRDPT-1:0]           rd_serr;
  output [NUMRDPT-1:0]           rd_derr;
  output [NUMRDPT*BITPADR:0]     rd_padr;

  output                         ready;
  input                          clk, rst;

  output [NUMDBNK*NUMRDPT*NUMVBNK*1-1:0]            t1_readB;
  output [NUMDBNK*NUMRDPT*NUMVBNK*BITSROW-1:0]      t1_addrB;
  input  [NUMDBNK*NUMRDPT*NUMVBNK*PHYWDTH-1:0]      t1_doutB;
  output [NUMDBNK*NUMRDPT*NUMVBNK*1-1:0]            t1_writeA;
  output [NUMDBNK*NUMRDPT*NUMVBNK*BITSROW-1:0]      t1_addrA;
  output [NUMDBNK*NUMRDPT*NUMVBNK*PHYWDTH-1:0]      t1_dinA;
  output [NUMDBNK*NUMRDPT*NUMVBNK*PHYWDTH-1:0]      t1_bwA;

  output [NUMDBNK*(NUMRDPT+1)*1-1:0]                t2_readB;
  output [NUMDBNK*(NUMRDPT+1)*BITVROW-1:0]          t2_addrB;
  input  [NUMDBNK*(NUMRDPT+1)*WIDTH-1:0]            t2_doutB;
  output [NUMDBNK*(NUMRDPT+1)*1-1:0]                t2_writeA;
  output [NUMDBNK*(NUMRDPT+1)*BITVROW-1:0]          t2_addrA;
  output [NUMDBNK*(NUMRDPT+1)*WIDTH-1:0]            t2_dinA;
  output [NUMDBNK*(NUMRDPT+1)*WIDTH-1:0]            t2_bwA;

  output [NUMDBNK*(NUMRDPT+2)*1-1:0]                t3_readB;
  output [NUMDBNK*(NUMRDPT+2)*BITVROW-1:0]          t3_addrB;
  input  [NUMDBNK*(NUMRDPT+2)*SDOUT_WIDTH-1:0]      t3_doutB;
  output [NUMDBNK*(NUMRDPT+2)*1-1:0]                t3_writeA;
  output [NUMDBNK*(NUMRDPT+2)*BITVROW-1:0]          t3_addrA;
  output [NUMDBNK*(NUMRDPT+2)*SDOUT_WIDTH-1:0]      t3_dinA;
  output [NUMDBNK*(NUMRDPT+2)*SDOUT_WIDTH-1:0]      t3_bwA;


  output [NUMDBNK*NUMCBNK*1-1:0]                    t4_readB;
  output [NUMDBNK*NUMCBNK*BITCSRW-1:0]              t4_addrB;
  input  [NUMDBNK*NUMCBNK*PHCWDTH-1:0]                    t4_doutB;
  output [NUMDBNK*NUMCBNK*1-1:0]                    t4_writeA;
  output [NUMDBNK*NUMCBNK*BITCSRW-1:0]              t4_addrA;
  output [NUMDBNK*NUMCBNK*PHCWDTH-1:0]                    t4_dinA;
  output [NUMDBNK*NUMCBNK*PHCWDTH-1:0]                    t4_bwA;


wire [NUMDBNK-1:0]                   ready_a2;
wire [NUMDBNK-1:0]                   ready_a3;

wire [BITADDR-1:0]          select_addr = 0;
wire [BITWDTH-1:0]          select_bit = 0;
wire [BITVROW-1:0]          select_vrow = 0;
wire [BITSROW-1:0]          select_srow = 0;
wire [BITCSRW-1:0]          select_csrw = 0;

wire [NUMDBNK*2*NUMRDPT*1-1:0]               t1_writeA_a1_wire;
wire [NUMDBNK*2*NUMRDPT*BITADDR-1:0]         t1_addrA_a1_wire;
wire [NUMDBNK*2*NUMRDPT*WIDTH-1:0]           t1_dinA_a1_wire;

wire [NUMDBNK*NUMRDPT*1-1:0]                 t1_readB_a1_wire;
wire [NUMDBNK*NUMRDPT*BITADDR-1:0]           t1_addrB_a1_wire;
reg  [NUMDBNK*NUMRDPT*WIDTH-1:0]             t1_doutB_a1_wire;
reg  [NUMDBNK*NUMRDPT*1-1:0]                 t1_fwrdB_a1_wire;
reg  [NUMDBNK*NUMRDPT*1-1:0]                 t1_serrB_a1_wire;
reg  [NUMDBNK*NUMRDPT*1-1:0]                 t1_derrB_a1_wire;
reg  [NUMDBNK*NUMRDPT*(BITPADR-BITDBNK)-1:0] t1_padrB_a1_wire;

wire [NUMDBNK*2*NUMRDPT*1-1:0]               t2_writeA_a1_wire;
wire [NUMDBNK*2*NUMRDPT*BITADDR-1:0]         t2_addrA_a1_wire;
wire [NUMDBNK*2*NUMRDPT*2-1:0]               t2_dinA_a1_wire;

wire [NUMDBNK*NUMRDPT*1-1:0]                 t2_readB_a1_wire;
wire [NUMDBNK*NUMRDPT*BITADDR-1:0]           t2_addrB_a1_wire;
reg  [NUMDBNK*NUMRDPT*2-1:0]                 t2_doutB_a1_wire;
wire [NUMDBNK*NUMRDPT*1-1:0]                 t2_writeB_a1_wire;
wire [NUMDBNK*NUMRDPT*2-1:0]                 t2_dinB_a1_wire;


generate if (1) begin : a1_loop
  algo_mrcnw_1r2w_rl #(
    .WIDTH     (WIDTH     ), .BITWDTH   (BITWDTH   ), .NUMRDPT   (NUMRDPT   ), .NUMWRPT   (NUMWRPT   ),
    .NUMADDR   (NUMADDR   ), .BITADDR   (BITADDR   ), .BITPADR   (BITPADR   ),
    .SRAM_DELAY(SRAM_DELAY), .DRAM_DELAY(DRAM_DELAY),
    .FLOPIN    (FLOPIN    ), .FLOPOUT   (FLOPOUT   ))
  algo (
    .write(write), .wr_adr(wr_adr), .din(din), .read(read), .rd_clr(rd_clr), .rd_adr(rd_adr), .rd_vld(rd_vld), .rd_dout(rd_dout), .rd_fwrd(rd_padr[BITPADR]), .rd_serr(rd_serr), .rd_derr(rd_derr), .rd_padr(rd_padr[BITPADR-1:0]),
    .t1_writeA(t1_writeA_a1_wire), .t1_addrA(t1_addrA_a1_wire), .t1_dinA(t1_dinA_a1_wire), 
    .t1_readB(t1_readB_a1_wire), .t1_addrB(t1_addrB_a1_wire), .t1_doutB(t1_doutB_a1_wire), .t1_fwrdB(t1_fwrdB_a1_wire), .t1_serrB(t1_serrB_a1_wire), .t1_derrB(t1_derrB_a1_wire), .t1_padrB(t1_padrB_a1_wire),
    .t2_writeA(t2_writeA_a1_wire), .t2_addrA(t2_addrA_a1_wire), .t2_dinA(t2_dinA_a1_wire), 
    .t2_readB(t2_readB_a1_wire), .t2_addrB(t2_addrB_a1_wire), .t2_doutB(t2_doutB_a1_wire), .t2_writeB(t2_writeB_a1_wire), .t2_dinB(t2_dinB_a1_wire),
    .clk(clk), .rst(rst || !(&ready_a2) || !(&ready_a3)), .ready(ready),
    .select_addr(select_addr), .select_bit(select_bit)
    );
end
endgenerate

reg  [2*NUMRDPT*1-1:0]               t1_writeA_a1[0:NUMDBNK-1];
reg  [2*NUMRDPT*BITADDR-1:0]         t1_addrA_a1 [0:NUMDBNK-1];
reg  [2*NUMRDPT*WIDTH-1:0]           t1_dinA_a1  [0:NUMDBNK-1];

reg  [NUMRDPT*1-1:0]                 t1_readB_a1 [0:NUMDBNK-1];
reg  [NUMRDPT*BITADDR-1:0]           t1_addrB_a1 [0:NUMDBNK-1];
wire [NUMRDPT*1-1:0]                 t1_vldB_a1  [0:NUMDBNK-1];
wire [NUMRDPT*WIDTH-1:0]             t1_doutB_a1 [0:NUMDBNK-1];
wire [NUMRDPT*1-1:0]                 t1_fwrdB_a1 [0:NUMDBNK-1];
wire [NUMRDPT*1-1:0]                 t1_serrB_a1 [0:NUMDBNK-1];
wire [NUMRDPT*1-1:0]                 t1_derrB_a1 [0:NUMDBNK-1];
wire [NUMRDPT*BITDPDR-1:0]           t1_padrB_a1 [0:NUMDBNK-1];

reg  [2*NUMRDPT*1-1:0]               t2_writeA_a1[0:NUMDBNK-1];
reg  [2*NUMRDPT*BITADDR-1:0]         t2_addrA_a1 [0:NUMDBNK-1];
reg  [2*NUMRDPT*2-1:0]               t2_dinA_a1  [0:NUMDBNK-1];

reg  [NUMRDPT*1-1:0]                 t2_readB_a1 [0:NUMDBNK-1];
reg  [NUMRDPT*BITADDR-1:0]           t2_addrB_a1 [0:NUMDBNK-1];
reg  [NUMRDPT*1-1:0]                 t2_writeB_a1[0:NUMDBNK-1];
reg  [NUMRDPT*2-1:0]                 t2_dinB_a1  [0:NUMDBNK-1];
wire [NUMRDPT*1-1:0]                 t2_vldB_a1  [0:NUMDBNK-1];
wire [NUMRDPT*2-1:0]                 t2_doutB_a1 [0:NUMDBNK-1];
wire [NUMRDPT*1-1:0]                 t2_fwrdB_a1 [0:NUMDBNK-1];
wire [NUMRDPT*1-1:0]                 t2_serrB_a1 [0:NUMDBNK-1];
wire [NUMRDPT*1-1:0]                 t2_derrB_a1 [0:NUMDBNK-1];
wire [NUMRDPT*BITCPDR-1:0]           t2_padrB_a1 [0:NUMDBNK-1];

always_comb begin
  integer a1t1p;
  t1_doutB_a1_wire = 0;
  t1_fwrdB_a1_wire = 0;
  t1_serrB_a1_wire = 0;
  t1_derrB_a1_wire = 0;   
  t1_padrB_a1_wire = 0;
  t2_doutB_a1_wire = 0;
  for (a1t1p=0;a1t1p<NUMDBNK;a1t1p=a1t1p+1) begin
    t1_writeA_a1[a1t1p] = t1_writeA_a1_wire >> (a1t1p*(2*NUMRDPT*1));
    t1_addrA_a1[a1t1p]  = t1_addrA_a1_wire  >> (a1t1p*(2*NUMRDPT*BITADDR));
    t1_dinA_a1[a1t1p]   = t1_dinA_a1_wire   >> (a1t1p*(2*NUMRDPT*WIDTH));
    t1_readB_a1[a1t1p]  = t1_readB_a1_wire  >> (a1t1p*(NUMRDPT*1));
    t1_addrB_a1[a1t1p]  = t1_addrB_a1_wire  >> (a1t1p*(NUMRDPT*BITADDR));

    t1_doutB_a1_wire    = t1_doutB_a1_wire | (t1_doutB_a1[a1t1p] << (a1t1p*NUMRDPT*WIDTH));
    t1_fwrdB_a1_wire    = t1_fwrdB_a1_wire | (t1_padrB_a1[a1t1p][BITDPDR-1] << (a1t1p*NUMRDPT*1));
    t1_serrB_a1_wire    = t1_serrB_a1_wire | (t1_serrB_a1[a1t1p] << (a1t1p*NUMRDPT*1));
    t1_derrB_a1_wire    = t1_derrB_a1_wire | (t1_derrB_a1[a1t1p] << (a1t1p*NUMRDPT*1));
    t1_padrB_a1_wire    = t1_padrB_a1_wire | (t1_padrB_a1[a1t1p] << (a1t1p*NUMRDPT*BITDPDR));

    t2_writeA_a1[a1t1p] = t2_writeA_a1_wire >> (a1t1p*(2*NUMRDPT*1));
    t2_addrA_a1[a1t1p]  = t2_addrA_a1_wire  >> (a1t1p*(2*NUMRDPT*BITADDR));
    t2_dinA_a1[a1t1p]   = t2_dinA_a1_wire   >> (a1t1p*(2*NUMRDPT*2));
    t2_readB_a1[a1t1p]  = t2_readB_a1_wire  >> (a1t1p*(NUMRDPT*1));
    t2_addrB_a1[a1t1p]  = t2_addrB_a1_wire  >> (a1t1p*(NUMRDPT*BITADDR));
    t2_writeB_a1[a1t1p] = t2_writeB_a1_wire >> (a1t1p*(NUMRDPT*1));
    t2_dinB_a1[a1t1p]   = t2_dinB_a1_wire   >> (a1t1p*(NUMRDPT*2));

    t2_doutB_a1_wire    = t2_doutB_a1_wire | (t2_doutB_a1[a1t1p] << (a1t1p*NUMRDPT*2));

  end
end


wire [NUMRDPT*NUMVBNK-1:0]                    t1_writeA_a2[0:NUMDBNK-1];
wire [NUMRDPT*NUMVBNK*BITVROW-1:0]            t1_addrA_a2 [0:NUMDBNK-1];
wire [NUMRDPT*NUMVBNK*WIDTH-1:0]              t1_dinA_a2  [0:NUMDBNK-1];
wire [NUMRDPT*NUMVBNK-1:0]                    t1_readB_a2 [0:NUMDBNK-1];
wire [NUMRDPT*NUMVBNK*BITVROW-1:0]            t1_addrB_a2 [0:NUMDBNK-1];
reg  [NUMRDPT*NUMVBNK*WIDTH-1:0]              t1_doutB_a2 [0:NUMDBNK-1];
reg  [NUMRDPT*NUMVBNK-1:0]                    t1_fwrdB_a2 [0:NUMDBNK-1];
reg  [NUMRDPT*NUMVBNK-1:0]                    t1_serrB_a2 [0:NUMDBNK-1];
reg  [NUMRDPT*NUMVBNK-1:0]                    t1_derrB_a2 [0:NUMDBNK-1];
reg  [NUMRDPT*NUMVBNK*(BITSROW+BITWRDS)-1:0]  t1_padrB_a2 [0:NUMDBNK-1];

wire [(NUMRDPT+1)-1:0]                        t2_writeA_a2[0:NUMDBNK-1];
wire [(NUMRDPT+1)*BITVROW-1:0]                t2_addrA_a2 [0:NUMDBNK-1];
wire [(NUMRDPT+1)*WIDTH-1:0]                  t2_dinA_a2  [0:NUMDBNK-1];
wire [(NUMRDPT+1)-1:0]                        t2_readB_a2 [0:NUMDBNK-1];
wire [(NUMRDPT+1)*BITVROW-1:0]                t2_addrB_a2 [0:NUMDBNK-1];
reg  [(NUMRDPT+1)*WIDTH-1:0]                  t2_doutB_a2 [0:NUMDBNK-1];
reg  [(NUMRDPT+1)-1:0]                        t2_fwrdB_a2 [0:NUMDBNK-1];
reg  [(NUMRDPT+1)-1:0]                        t2_serrB_a2 [0:NUMDBNK-1];
reg  [(NUMRDPT+1)-1:0]                        t2_derrB_a2 [0:NUMDBNK-1];
reg  [(NUMRDPT+1)*(BITSROW+BITWRDS)-1:0]      t2_padrB_a2 [0:NUMDBNK-1];

wire [(NUMRDPT+2)-1:0]                        t3_writeA_a2[0:NUMDBNK-1];
wire [(NUMRDPT+2)*BITVROW-1:0]                t3_addrA_a2 [0:NUMDBNK-1];
wire [(NUMRDPT+2)*(BITVBNK+1)-1:0]            t3_dinA_a2  [0:NUMDBNK-1];
wire [(NUMRDPT+2)-1:0]                        t3_readB_a2 [0:NUMDBNK-1];
wire [(NUMRDPT+2)*BITVROW-1:0]                t3_addrB_a2 [0:NUMDBNK-1];
reg  [(NUMRDPT+2)*(BITVBNK+1)-1:0]            t3_doutB_a2 [0:NUMDBNK-1];
reg  [(NUMRDPT+2)-1:0]                        t3_fwrdB_a2 [0:NUMDBNK-1];
reg  [(NUMRDPT+2)-1:0]                        t3_serrB_a2 [0:NUMDBNK-1];
reg  [(NUMRDPT+2)-1:0]                        t3_derrB_a2 [0:NUMDBNK-1];
reg  [(NUMRDPT+2)*(BITSROW+BITWRDS)-1:0]      t3_padrB_a2 [0:NUMDBNK-1]; 

genvar a2p;
generate for (a2p=0;a2p<NUMDBNK;a2p=a2p+1) begin: a2_loop

  algo_nr2w_1r1w #(
    .BITWDTH (BITWDTH), .WIDTH (WIDTH), .ENAPSDO (0), .ENAPAR (ENAPAR), .ENAECC (ENAECC),
    .NUMRDPT (NUMRDPT), .NUMADDR (NUMADDR), .BITADDR (BITADDR),
    .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK), .BITPADR (BITDPDR-1),
    .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPIN(0), .FLOPOUT(0))
    algo (
      .clk(clk), .rst(rst), .ready(ready_a2[a2p]),
      .write(t1_writeA_a1[a2p]), .wr_adr(t1_addrA_a1[a2p]), .din(t1_dinA_a1[a2p]),
      .read(t1_readB_a1[a2p]), .rd_adr(t1_addrB_a1[a2p]), .rd_vld(t1_vldB_a1[a2p]), .rd_dout(t1_doutB_a1[a2p]),
      .rd_fwrd(t1_padrB_a1[a2p][BITDPDR-1]), .rd_serr(t1_serrB_a1[a2p]), .rd_derr(t1_derrB_a1[a2p]), .rd_padr(t1_padrB_a1[a2p][BITDPDR-2:0]),
      .t1_writeA(t1_writeA_a2[a2p]), .t1_addrA(t1_addrA_a2[a2p]), .t1_dinA(t1_dinA_a2[a2p]),
      .t1_readB(t1_readB_a2[a2p]), .t1_addrB(t1_addrB_a2[a2p]), .t1_doutB(t1_doutB_a2[a2p]),
      .t1_fwrdB(t1_fwrdB_a2[a2p]), .t1_serrB(t1_serrB_a2[a2p]), .t1_derrB(t1_derrB_a2[a2p]), .t1_padrB(t1_padrB_a2[a2p]),
      .t2_writeA(t2_writeA_a2[a2p]), .t2_addrA(t2_addrA_a2[a2p]), .t2_dinA(t2_dinA_a2[a2p]),
      .t2_readB(t2_readB_a2[a2p]), .t2_addrB(t2_addrB_a2[a2p]), .t2_doutB(t2_doutB_a2[a2p]),
      .t2_fwrdB(t2_fwrdB_a2[a2p]), .t2_serrB(t2_serrB_a2[a2p]), .t2_derrB(t2_derrB_a2[a2p]), .t2_padrB(t2_padrB_a2[a2p]),
      .t3_writeA(t3_writeA_a2[a2p]), .t3_addrA(t3_addrA_a2[a2p]), .t3_dinA(t3_dinA_a2[a2p]),
      .t3_readB(t3_readB_a2[a2p]), .t3_addrB(t3_addrB_a2[a2p]), .t3_doutB(t3_doutB_a2[a2p]),
      .t3_fwrdB(t3_fwrdB_a2[a2p]), .t3_serrB(t3_serrB_a2[a2p]), .t3_derrB(t3_derrB_a2[a2p]), .t3_padrB(t3_padrB_a2[a2p]),
      .select_addr(select_addr), .select_bit(select_bit));

end
endgenerate

wire                            t1_writeA_wire   [0:NUMDBNK-1][0:NUMRDPT-1][0:NUMVBNK-1];
wire [BITWROW-1:0]              t1_addrA_wire    [0:NUMDBNK-1][0:NUMRDPT-1][0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0]      t1_bwA_wire      [0:NUMDBNK-1][0:NUMRDPT-1][0:NUMVBNK-1];
wire [NUMWRDS*MEMWDTH-1:0]      t1_dinA_wire     [0:NUMDBNK-1][0:NUMRDPT-1][0:NUMVBNK-1];
wire                            t1_readB_wire    [0:NUMDBNK-1][0:NUMRDPT-1][0:NUMVBNK-1];
wire [BITSROW-1:0]              t1_addrB_wire    [0:NUMDBNK-1][0:NUMRDPT-1][0:NUMVBNK-1];
wire [WIDTH-1:0]                t1_doutB_a2_wire [0:NUMDBNK-1][0:NUMRDPT-1][0:NUMVBNK-1];
wire                            t1_fwrdB_a2_wire [0:NUMDBNK-1][0:NUMRDPT-1][0:NUMVBNK-1];
wire                            t1_serrB_a2_wire [0:NUMDBNK-1][0:NUMRDPT-1][0:NUMVBNK-1];
wire                            t1_derrB_a2_wire [0:NUMDBNK-1][0:NUMRDPT-1][0:NUMVBNK-1];
wire [BITSROW+BITWRDS-1:0]      t1_padrB_a2_wire [0:NUMDBNK-1][0:NUMRDPT-1][0:NUMVBNK-1];

genvar t1p,t1r, t1b;
generate
  for (t1p=0; t1p<NUMDBNK; t1p=t1p+1) begin: t1p_loop
    for (t1r=0; t1r<NUMRDPT; t1r=t1r+1) begin: t1r_loop
      for (t1b=0; t1b<NUMVBNK; t1b=t1b+1) begin: t1b_loop
        wire               t1_writeA_a2_wire = t1_writeA_a2[t1p] >> (t1r*NUMVBNK+t1b);
        wire [BITVROW-1:0] t1_addrA_a2_wire  = t1_addrA_a2[t1p]  >> ((t1r*NUMVBNK+t1b)*BITVROW);
        wire [WIDTH-1:0]   t1_dinA_a2_wire   = t1_dinA_a2[t1p]   >> ((t1r*NUMVBNK+t1b)*WIDTH);
        wire               t1_readB_a2_wire  = t1_readB_a2[t1p]  >> (t1r*NUMVBNK+t1b);
        wire [BITVROW-1:0] t1_addrB_a2_wire  = t1_addrB_a2[t1p]  >> ((t1r*NUMVBNK+t1b)*BITVROW);

        wire [NUMWRDS*MEMWDTH-1:0] t1_doutB_wire = t1_doutB >> ((t1p*NUMRDPT*NUMVBNK+t1r*NUMVBNK+t1b)*PHYWDTH);

        wire mem_write_t1_wire;
        wire [BITSROW-1:0] mem_wr_adr_t1_wire;
        wire [NUMWRDS*MEMWDTH-1:0] mem_bw_t1_wire;
        wire [NUMWRDS*MEMWDTH-1:0] mem_din_t1_wire;
        wire mem_read_t1_wire;
        wire [BITSROW-1:0] mem_rd_adr_t1_wire;
        wire [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_t1_wire;
        wire mem_rd_fwrd_t1_wire;
        wire mem_rd_serr_t1_wire;
        wire mem_rd_derr_t1_wire;
        wire [(BITWBNK+BITWROW)-1:0] mem_rd_padr_t1_wire;

        if (1) begin: align_loop
          infra_align_ecc_1r1w #(
            .WIDTH (WIDTH), .ENAPSDO (NUMWRDS==1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .ENAPADR (1),
            .NUMADDR (NUMVROW), .BITADDR (BITVROW),
            .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITWBNK+BITWROW),
            .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
          infra (
            .write(t1_writeA_a2_wire), .wr_adr(t1_addrA_a2_wire), .din(t1_dinA_a2_wire),
            .read(t1_readB_a2_wire), .rd_adr(t1_addrB_a2_wire),
            .rd_dout(t1_doutB_a2_wire[t1p][t1r][t1b]), .rd_fwrd(t1_fwrdB_a2_wire[t1p][t1r][t1b]),
            .rd_serr(t1_serrB_a2_wire[t1p][t1r][t1b]), .rd_derr(t1_derrB_a2_wire[t1p][t1r][t1b]), .rd_padr(t1_padrB_a2_wire[t1p][t1r][t1b]),
            .mem_write (mem_write_t1_wire), .mem_wr_adr(mem_wr_adr_t1_wire), .mem_bw (mem_bw_t1_wire), .mem_din (mem_din_t1_wire),
            .mem_read (mem_read_t1_wire), .mem_rd_adr(mem_rd_adr_t1_wire), .mem_rd_dout (mem_rd_dout_t1_wire),
            .mem_rd_fwrd(mem_rd_fwrd_t1_wire), .mem_rd_padr(mem_rd_padr_t1_wire),
            .clk (clk), .rst (rst),
            .select_addr (select_vrow));
        end

        if (1) begin: stack_loop
          infra_stack_1r1w #(
            .WIDTH (NUMWRDS*MEMWDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
            .NUMWROW (NUMWROW), .BITWROW (BITWROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
            .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
          infra (
            .write (mem_write_t1_wire), .wr_adr (mem_wr_adr_t1_wire), .bw (mem_bw_t1_wire), .din (mem_din_t1_wire),
            .read (mem_read_t1_wire), .rd_adr (mem_rd_adr_t1_wire), .rd_dout (mem_rd_dout_t1_wire),
            .rd_fwrd (mem_rd_fwrd_t1_wire), .rd_serr (mem_rd_serr_t1_wire), .rd_derr(mem_rd_derr_t1_wire), .rd_padr(mem_rd_padr_t1_wire),
            .mem_write (t1_writeA_wire[t1p][t1r][t1b]), .mem_wr_adr(t1_addrA_wire[t1p][t1r][t1b]),
            .mem_bw (t1_bwA_wire[t1p][t1r][t1b]), .mem_din (t1_dinA_wire[t1p][t1r][t1b]),
            .mem_read (t1_readB_wire[t1p][t1r][t1b]), .mem_rd_adr(t1_addrB_wire[t1p][t1r][t1b]), .mem_rd_dout (t1_doutB_wire),
            .clk (clk), .rst(rst),
            .select_addr (select_srow));
        end
      end
    end
  end
endgenerate

reg [NUMDBNK*NUMRDPT*NUMVBNK-1:0]         t1_writeA;
reg [NUMDBNK*NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrA;
reg [NUMDBNK*NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_bwA;
reg [NUMDBNK*NUMRDPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
reg [NUMDBNK*NUMRDPT*NUMVBNK-1:0]         t1_readB;
reg [NUMDBNK*NUMRDPT*NUMVBNK*BITSROW-1:0] t1_addrB;
integer t1p_int, t1r_int, t1b_int;
always_comb begin
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_readB = 0;
  t1_addrB = 0;
  for (t1p_int=0; t1p_int<NUMDBNK; t1p_int=t1p_int+1) begin
    t1_doutB_a2[t1p_int] = 0;
    t1_fwrdB_a2[t1p_int] = 0;
    t1_serrB_a2[t1p_int] = 0;
    t1_derrB_a2[t1p_int] = 0;
    t1_padrB_a2[t1p_int] = 0;
    for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
      for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1) begin
        t1_writeA   = t1_writeA   | (  t1_writeA_wire[t1p_int][t1r_int][t1b_int] << ((t1p_int*NUMRDPT*NUMVBNK+t1r_int*NUMVBNK+t1b_int)*1));
        t1_addrA    = t1_addrA    | (   t1_addrA_wire[t1p_int][t1r_int][t1b_int] << ((t1p_int*NUMRDPT*NUMVBNK+t1r_int*NUMVBNK+t1b_int)*BITSROW));
        t1_bwA      = t1_bwA      | (     t1_bwA_wire[t1p_int][t1r_int][t1b_int] << ((t1p_int*NUMRDPT*NUMVBNK+t1r_int*NUMVBNK+t1b_int)*PHYWDTH));
        t1_dinA     = t1_dinA     | (    t1_dinA_wire[t1p_int][t1r_int][t1b_int] << ((t1p_int*NUMRDPT*NUMVBNK+t1r_int*NUMVBNK+t1b_int)*PHYWDTH));
        t1_readB    = t1_readB    | (   t1_readB_wire[t1p_int][t1r_int][t1b_int] << ((t1p_int*NUMRDPT*NUMVBNK+t1r_int*NUMVBNK+t1b_int)*1));
        t1_addrB    = t1_addrB    | (   t1_addrB_wire[t1p_int][t1r_int][t1b_int] << ((t1p_int*NUMRDPT*NUMVBNK+t1r_int*NUMVBNK+t1b_int)*BITSROW));
        t1_doutB_a2[t1p_int] = t1_doutB_a2[t1p_int] | (t1_doutB_a2_wire[t1p_int][t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*WIDTH));
        t1_fwrdB_a2[t1p_int] = t1_fwrdB_a2[t1p_int] | (t1_fwrdB_a2_wire[t1p_int][t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*1));
        t1_serrB_a2[t1p_int] = t1_serrB_a2[t1p_int] | (t1_serrB_a2_wire[t1p_int][t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*1));
        t1_derrB_a2[t1p_int] = t1_derrB_a2[t1p_int] | (t1_derrB_a2_wire[t1p_int][t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*1));
        t1_padrB_a2[t1p_int] = t1_padrB_a2[t1p_int] | (t1_padrB_a2_wire[t1p_int][t1r_int][t1b_int] << ((t1r_int*NUMVBNK+t1b_int)*(BITSROW+BITWRDS)));
      end
    end
  end
end

wire                       t2_writeA_wire   [0:NUMDBNK-1][0:(NUMRDPT+1)-1][0:1-1];
wire [BITSROW-1:0]         t2_addrA_wire    [0:NUMDBNK-1][0:(NUMRDPT+1)-1][0:1-1];
wire [NUMWRDS*MEMWDTH-1:0] t2_bwA_wire      [0:NUMDBNK-1][0:(NUMRDPT+1)-1][0:1-1];
wire [NUMWRDS*MEMWDTH-1:0] t2_dinA_wire     [0:NUMDBNK-1][0:(NUMRDPT+1)-1][0:1-1];
wire                       t2_readB_wire    [0:NUMDBNK-1][0:(NUMRDPT+1)-1][0:1-1];
wire [BITSROW-1:0]         t2_addrB_wire    [0:NUMDBNK-1][0:(NUMRDPT+1)-1][0:1-1];
wire [WIDTH-1:0]           t2_doutB_a2_wire [0:NUMDBNK-1][0:(NUMRDPT+1)-1][0:1-1];
wire                       t2_fwrdB_a2_wire [0:NUMDBNK-1][0:(NUMRDPT+1)-1][0:1-1];
wire                       t2_serrB_a2_wire [0:NUMDBNK-1][0:(NUMRDPT+1)-1][0:1-1];
wire                       t2_derrB_a2_wire [0:NUMDBNK-1][0:(NUMRDPT+1)-1][0:1-1];
wire [BITSROW+BITWRDS-1:0] t2_padrB_a2_wire [0:NUMDBNK-1][0:(NUMRDPT+1)-1][0:1-1];

genvar t2p, t2r, t2b;
generate
  for (t2p=0; t2p<NUMDBNK; t2p=t2p+1) begin: t2p_loop
    for (t2r=0; t2r<(NUMRDPT+1); t2r=t2r+1) begin: t2r_loop
      for (t2b=0; t2b<1; t2b=t2b+1) begin: t2b_loop
        wire               t2_writeA_a2_wire = t2_writeA_a2[t2p] >> ((t2r*1+t2b)*1);
        wire [BITVROW-1:0] t2_addrA_a2_wire  = t2_addrA_a2[t2p]  >> ((t2r*1+t2b)*BITVROW);
        wire [WIDTH-1:0]   t2_dinA_a2_wire   = t2_dinA_a2[t2p]   >> ((t2r*1+t2b)*WIDTH);
        wire               t2_readB_a2_wire  = t2_readB_a2[t2p]  >> ((t2r*1+t2b)*1);
        wire [BITVROW-1:0] t2_addrB_a2_wire  = t2_addrB_a2[t2p]  >> ((t2r*1+t2b)*BITVROW);

        wire [NUMWRDS*MEMWDTH-1:0] t2_doutB_wire = t2_doutB >> ((t2p*(NUMRDPT+1)*1+t2r*1+t2b)*PHYWDTH);

        wire mem_write_t2_wire;
        wire [BITSROW-1:0] mem_wr_adr_t2_wire;
        wire [NUMWRDS*MEMWDTH-1:0] mem_bw_t2_wire;
        wire [NUMWRDS*MEMWDTH-1:0] mem_din_t2_wire;
        wire mem_read_t2_wire;
        wire [BITSROW-1:0] mem_rd_adr_t2_wire;
        wire [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_t2_wire;
        wire mem_rd_fwrd_t2_wire;
        wire mem_rd_serr_t2_wire;
        wire mem_rd_derr_t2_wire;
        wire [(BITWBNK+BITWROW)-1:0] mem_rd_padr_t2_wire;

        if (1) begin: align_loop
          infra_align_ecc_1r1w #(
            .WIDTH (WIDTH), .ENAPSDO (NUMWRDS==1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .ENAPADR (1),
            .NUMADDR (NUMVROW), .BITADDR (BITVROW),
            .NUMSROW (NUMSROW), .BITSROW (BITSROW), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITWRDS+BITWBNK+BITWROW),
            .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
          infra (
            .write(t2_writeA_a2_wire), .wr_adr(t2_addrA_a2_wire), .din(t2_dinA_a2_wire),
            .read(t2_readB_a2_wire), .rd_adr(t2_addrB_a2_wire),
            .rd_dout(t2_doutB_a2_wire[t2p][t2r][t2b]), .rd_fwrd(t2_fwrdB_a2_wire[t2p][t2r][t2b]),
            .rd_serr(t2_serrB_a2_wire[t2p][t2r][t2b]), .rd_derr(t2_derrB_a2_wire[t2p][t2r][t2b]), .rd_padr(t2_padrB_a2_wire[t2p][t2r][t2b]),
            .mem_write (mem_write_t2_wire), .mem_wr_adr(mem_wr_adr_t2_wire), .mem_bw (mem_bw_t2_wire), .mem_din (mem_din_t2_wire),
            .mem_read (mem_read_t2_wire), .mem_rd_adr(mem_rd_adr_t2_wire), .mem_rd_dout (mem_rd_dout_t2_wire),
            .mem_rd_fwrd(mem_rd_fwrd_t2_wire), .mem_rd_padr(mem_rd_padr_t2_wire),
            .clk (clk), .rst (rst),
            .select_addr (select_vrow));
        end

        if (1) begin: stack_loop
          infra_stack_1r1w #(
            .WIDTH (NUMWRDS*MEMWDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMSROW), .BITADDR (BITSROW),
            .NUMWROW (NUMWROW), .BITWROW (BITWROW), .NUMWBNK (NUMWBNK), .BITWBNK (BITWBNK),
            .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
          infra (
            .write (mem_write_t2_wire), .wr_adr (mem_wr_adr_t2_wire), .bw (mem_bw_t2_wire), .din (mem_din_t2_wire),
            .read (mem_read_t2_wire), .rd_adr (mem_rd_adr_t2_wire), .rd_dout (mem_rd_dout_t2_wire),
            .rd_fwrd (mem_rd_fwrd_t2_wire), .rd_serr (mem_rd_serr_t2_wire), .rd_derr(mem_rd_derr_t2_wire), .rd_padr(mem_rd_padr_t2_wire),
            .mem_write (t2_writeA_wire[t2p][t2r][t2b]), .mem_wr_adr(t2_addrA_wire[t2p][t2r][t2b]),
            .mem_bw (t2_bwA_wire[t2p][t2r][t2b]), .mem_din (t2_dinA_wire[t2p][t2r][t2b]),
            .mem_read (t2_readB_wire[t2p][t2r][t2b]), .mem_rd_adr(t2_addrB_wire[t2p][t2r][t2b]), .mem_rd_dout (t2_doutB_wire),
            .clk (clk), .rst(rst),
            .select_addr (select_srow));
        end
      end
    end
  end
endgenerate

reg [NUMDBNK*(NUMRDPT+1)-1:0]         t2_writeA;
reg [NUMDBNK*(NUMRDPT+1)*BITSROW-1:0] t2_addrA;
reg [NUMDBNK*(NUMRDPT+1)*PHYWDTH-1:0] t2_bwA;
reg [NUMDBNK*(NUMRDPT+1)*PHYWDTH-1:0] t2_dinA;
reg [NUMDBNK*(NUMRDPT+1)-1:0]         t2_readB;
reg [NUMDBNK*(NUMRDPT+1)*BITSROW-1:0] t2_addrB;
integer t2p_int, t2r_int, t2b_int;
always_comb begin
  t2_writeA = 0;
  t2_addrA = 0;
  t2_bwA = 0;
  t2_dinA = 0;
  t2_readB = 0;
  t2_addrB = 0;
  for (t2p_int=0; t2p_int<NUMDBNK; t2p_int=t2p_int+1) begin
    t2_doutB_a2[t2p_int] = 0;
    t2_fwrdB_a2[t2p_int] = 0;
    t2_serrB_a2[t2p_int] = 0;
    t2_derrB_a2[t2p_int] = 0;
    t2_padrB_a2[t2p_int] = 0;
    for (t2r_int=0; t2r_int<NUMRDPT+1; t2r_int=t2r_int+1) begin
      for (t2b_int=0; t2b_int<1; t2b_int=t2b_int+1) begin
        t2_writeA   = t2_writeA   | (  t2_writeA_wire[t2p_int][t2r_int][t2b_int] << ((t2p_int*(NUMRDPT+1)*1+t2r_int*1+t2b_int)*1));
        t2_addrA    = t2_addrA    | (   t2_addrA_wire[t2p_int][t2r_int][t2b_int] << ((t2p_int*(NUMRDPT+1)*1+t2r_int*1+t2b_int)*BITSROW));
        t2_bwA      = t2_bwA      | (     t2_bwA_wire[t2p_int][t2r_int][t2b_int] << ((t2p_int*(NUMRDPT+1)*1+t2r_int*1+t2b_int)*PHYWDTH));
        t2_dinA     = t2_dinA     | (    t2_dinA_wire[t2p_int][t2r_int][t2b_int] << ((t2p_int*(NUMRDPT+1)*1+t2r_int*1+t2b_int)*PHYWDTH));
        t2_readB    = t2_readB    | (   t2_readB_wire[t2p_int][t2r_int][t2b_int] << ((t2p_int*(NUMRDPT+1)*1+t2r_int*1+t2b_int)*1));
        t2_addrB    = t2_addrB    | (   t2_addrB_wire[t2p_int][t2r_int][t2b_int] << ((t2p_int*(NUMRDPT+1)*1+t2r_int*1+t2b_int)*BITSROW));
        t2_doutB_a2[t2p_int] = t2_doutB_a2[t2p_int] | (t2_doutB_a2_wire[t2p_int][t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*WIDTH));
        t2_fwrdB_a2[t2p_int] = t2_fwrdB_a2[t2p_int] | (t2_fwrdB_a2_wire[t2p_int][t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*1));
        t2_serrB_a2[t2p_int] = t2_serrB_a2[t2p_int] | (t2_serrB_a2_wire[t2p_int][t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*1));
        t2_derrB_a2[t2p_int] = t2_derrB_a2[t2p_int] | (t2_derrB_a2_wire[t2p_int][t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*1));
        t2_padrB_a2[t2p_int] = t2_padrB_a2[t2p_int] | (t2_padrB_a2_wire[t2p_int][t2r_int][t2b_int] << ((t2r_int*1+t2b_int)*(BITSROW+BITWRDS)));
      end
    end
  end
end

wire                   t3_writeA_wire   [0:NUMDBNK-1][0:(NUMRDPT+2)-1][0:1-1];
wire [BITVROW-1:0]     t3_addrA_wire    [0:NUMDBNK-1][0:(NUMRDPT+2)-1][0:1-1];
wire [SDOUT_WIDTH-1:0] t3_bwA_wire      [0:NUMDBNK-1][0:(NUMRDPT+2)-1][0:1-1];
wire [SDOUT_WIDTH-1:0] t3_dinA_wire     [0:NUMDBNK-1][0:(NUMRDPT+2)-1][0:1-1];
wire                   t3_readB_wire    [0:NUMDBNK-1][0:(NUMRDPT+2)-1][0:1-1];
wire [BITVROW-1:0]     t3_addrB_wire    [0:NUMDBNK-1][0:(NUMRDPT+2)-1][0:1-1];
wire [(BITVBNK+1)-1:0] t3_doutB_a2_wire [0:NUMDBNK-1][0:(NUMRDPT+2)-1][0:1-1];
wire                   t3_fwrdB_a2_wire [0:NUMDBNK-1][0:(NUMRDPT+2)-1][0:1-1];
wire                   t3_serrB_a2_wire [0:NUMDBNK-1][0:(NUMRDPT+2)-1][0:1-1];
wire                   t3_derrB_a2_wire [0:NUMDBNK-1][0:(NUMRDPT+2)-1][0:1-1];
wire [BITVROW-1:0]     t3_padrB_a2_wire [0:NUMDBNK-1][0:(NUMRDPT+2)-1][0:1-1];

genvar t3p, t3r, t3b;
generate
  for (t3p=0; t3p<NUMDBNK; t3p=t3p+1) begin: t3p_loop
    for (t3r=0; t3r<NUMRDPT+2; t3r=t3r+1) begin: t3r_loop
      for (t3b=0; t3b<1; t3b=t3b+1) begin: t3b_loop
        wire                   t3_writeA_a2_wire = t3_writeA_a2[t3p] >> ((t3r*1+t3b)*1);
        wire [BITVROW-1:0]     t3_addrA_a2_wire  = t3_addrA_a2[t3p]  >> ((t3r*1+t3b)*BITVROW);
        wire [(BITVBNK+1)-1:0] t3_dinA_a2_wire   = t3_dinA_a2[t3p]   >> ((t3r*1+t3b)*(BITVBNK+1));
        wire                   t3_readB_a2_wire  = t3_readB_a2[t3p]  >> ((t3r*1+t3b)*1);
        wire [BITVROW-1:0]     t3_addrB_a2_wire  = t3_addrB_a2[t3p]  >> ((t3r*1+t3b)*BITVROW);

        wire [SDOUT_WIDTH-1:0] t3_doutB_wire = t3_doutB >> ((t3p*(NUMRDPT+2)*1+t3r*1+t3b)*SDOUT_WIDTH);

        wire mem_write_t3_wire;
        wire [BITVROW-1:0] mem_wr_adr_t3_wire;
        wire [SDOUT_WIDTH-1:0] mem_bw_t3_wire;
        wire [SDOUT_WIDTH-1:0] mem_din_t3_wire;
        wire mem_read_t3_wire;
        wire [BITVROW-1:0] mem_rd_adr_t3_wire;
        wire [SDOUT_WIDTH-1:0] mem_rd_dout_t3_wire;
        wire mem_rd_fwrd_t3_wire;
        wire mem_rd_serr_t3_wire;
        wire mem_rd_derr_t3_wire;
        wire [BITVROW-1:0] mem_rd_padr_t3_wire;

        if (1) begin: align_loop
          infra_align_ecc_1r1w_a63 #(
            .WIDTH (BITVBNK+1), .ENAPSDO (1), .ENADEC(1), .ECCWDTH (ECCBITS), .ENAPADR (1),
            .NUMADDR (NUMVROW), .BITADDR (BITVROW),
            .NUMSROW (NUMVROW), .BITSROW (BITVROW), .NUMWRDS (1), .BITWRDS (0), .BITPADR (BITVROW),
            .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (0), .RSTZERO (1))
          infra (
            .write(t3_writeA_a2_wire), .wr_adr(t3_addrA_a2_wire), .din(t3_dinA_a2_wire),
            .read(t3_readB_a2_wire), .rd_adr(t3_addrB_a2_wire),
            .rd_dout(t3_doutB_a2_wire[t3p][t3r][t3b]), .rd_fwrd(t3_fwrdB_a2_wire[t3p][t3r][t3b]),
            .rd_serr(t3_serrB_a2_wire[t3p][t3r][t3b]), .rd_derr(t3_derrB_a2_wire[t3p][t3r][t3b]), .rd_padr(t3_padrB_a2_wire[t3p][t3r][t3b]),
            .mem_write (mem_write_t3_wire), .mem_wr_adr(mem_wr_adr_t3_wire), .mem_bw (mem_bw_t3_wire), .mem_din (mem_din_t3_wire),
            .mem_read (mem_read_t3_wire), .mem_rd_adr(mem_rd_adr_t3_wire), .mem_rd_dout (mem_rd_dout_t3_wire),
            .mem_rd_fwrd(mem_rd_fwrd_t3_wire), .mem_rd_padr(mem_rd_padr_t3_wire),
            .clk (clk), .rst (rst),
            .select_addr (select_vrow));
        end

        if (1) begin: stack_loop
          infra_stack_1r1w #(
            .WIDTH (SDOUT_WIDTH), .ENAPSDO (0), .NUMADDR (NUMVROW), .BITADDR (BITVROW),
            .NUMWROW (NUMVROW), .BITWROW (BITVROW), .NUMWBNK (1), .BITWBNK (0),
            .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
          infra (
            .write (mem_write_t3_wire), .wr_adr (mem_wr_adr_t3_wire), .bw (mem_bw_t3_wire), .din (mem_din_t3_wire),
            .read (mem_read_t3_wire), .rd_adr (mem_rd_adr_t3_wire), .rd_dout (mem_rd_dout_t3_wire),
            .rd_fwrd (mem_rd_fwrd_t3_wire), .rd_serr (mem_rd_serr_t3_wire), .rd_derr(mem_rd_derr_t3_wire), .rd_padr(mem_rd_padr_t3_wire),
            .mem_write (t3_writeA_wire[t3p][t3r][t3b]), .mem_wr_adr(t3_addrA_wire[t3p][t3r][t3b]),
            .mem_bw (t3_bwA_wire[t3p][t3r][t3b]), .mem_din (t3_dinA_wire[t3p][t3r][t3b]),
            .mem_read (t3_readB_wire[t3p][t3r][t3b]), .mem_rd_adr(t3_addrB_wire[t3p][t3r][t3b]), .mem_rd_dout (t3_doutB_wire),
            .clk (clk), .rst(rst),
            .select_addr (select_vrow));
        end
      end
    end
  end
endgenerate

reg [NUMDBNK*(NUMRDPT+2)*1-1:0]           t3_writeA;
reg [NUMDBNK*(NUMRDPT+2)*BITVROW-1:0]     t3_addrA;
reg [NUMDBNK*(NUMRDPT+2)*SDOUT_WIDTH-1:0] t3_bwA;
reg [NUMDBNK*(NUMRDPT+2)*SDOUT_WIDTH-1:0] t3_dinA;
reg [NUMDBNK*(NUMRDPT+2)*1-1:0]           t3_readB;
reg [NUMDBNK*(NUMRDPT+2)*BITVROW-1:0]     t3_addrB;
integer t3p_int, t3r_int, t3b_int;
always_comb begin
  t3_writeA = 0;
  t3_addrA = 0;
  t3_bwA = 0;
  t3_dinA = 0;
  t3_readB = 0;
  t3_addrB = 0;
  for (t3p_int=0; t3p_int<NUMDBNK; t3p_int=t3p_int+1) begin
    t3_doutB_a2[t3p_int] = 0;
    t3_fwrdB_a2[t3p_int] = 0;
    t3_serrB_a2[t3p_int] = 0;
    t3_derrB_a2[t3p_int] = 0;
    t3_padrB_a2[t3p_int] = 0;
    for (t3r_int=0; t3r_int<NUMRDPT+2; t3r_int=t3r_int+1) begin
      for (t3b_int=0; t3b_int<1; t3b_int=t3b_int+1) begin
        t3_writeA   = t3_writeA   | (t3_writeA_wire[t3p_int][t3r_int][t3b_int]   << ((t3p_int*(NUMRDPT+2)*1+t3r_int*1+t3b_int)*1));
        t3_addrA    = t3_addrA    | ( t3_addrA_wire[t3p_int][t3r_int][t3b_int]   << ((t3p_int*(NUMRDPT+2)*1+t3r_int*1+t3b_int)*BITVROW));
        t3_bwA      = t3_bwA      | (   t3_bwA_wire[t3p_int][t3r_int][t3b_int]   << ((t3p_int*(NUMRDPT+2)*1+t3r_int*1+t3b_int)*SDOUT_WIDTH));
        t3_dinA     = t3_dinA     | (  t3_dinA_wire[t3p_int][t3r_int][t3b_int]   << ((t3p_int*(NUMRDPT+2)*1+t3r_int*1+t3b_int)*SDOUT_WIDTH));
        t3_readB    = t3_readB    | ( t3_readB_wire[t3p_int][t3r_int][t3b_int]   << ((t3p_int*(NUMRDPT+2)*1+t3r_int*1+t3b_int)*1));
        t3_addrB    = t3_addrB    | ( t3_addrB_wire[t3p_int][t3r_int][t3b_int]   << ((t3p_int*(NUMRDPT+2)*1+t3r_int*1+t3b_int)*BITVROW));
        t3_doutB_a2[t3p_int] = t3_doutB_a2[t3p_int] | (t3_doutB_a2_wire[t3p_int][t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*(BITVBNK+1)));
        t3_fwrdB_a2[t3p_int] = t3_fwrdB_a2[t3p_int] | (t3_fwrdB_a2_wire[t3p_int][t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*1));
        t3_serrB_a2[t3p_int] = t3_serrB_a2[t3p_int] | (t3_serrB_a2_wire[t3p_int][t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*1));
        t3_derrB_a2[t3p_int] = t3_derrB_a2[t3p_int] | (t3_derrB_a2_wire[t3p_int][t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*1));
        t3_padrB_a2[t3p_int] = t3_padrB_a2[t3p_int] | (t3_padrB_a2_wire[t3p_int][t3r_int][t3b_int] << ((t3r_int*1+t3b_int)*(BITSROW+BITWRDS)));
      end
    end
  end 
end


wire [NUMCBNK-1:0]                   t4_writeA_a3 [0:NUMDBNK-1];
wire [NUMCBNK*BITADDR-1:0]           t4_addrA_a3  [0:NUMDBNK-1];
wire [NUMCBNK*2-1:0]                 t4_dinA_a3   [0:NUMDBNK-1];
wire [NUMCBNK-1:0]                   t4_readB_a3  [0:NUMDBNK-1];
wire [NUMCBNK*BITADDR-1:0]           t4_addrB_a3  [0:NUMDBNK-1];
reg  [NUMCBNK*2-1:0]                 t4_doutB_a3  [0:NUMDBNK-1];
reg  [NUMCBNK-1:0]                   t4_fwrdB_a3  [0:NUMDBNK-1];
reg  [NUMCBNK-1:0]                   t4_serrB_a3  [0:NUMDBNK-1];
reg  [NUMCBNK-1:0]                   t4_derrB_a3  [0:NUMDBNK-1];
reg  [NUMCBNK*(BITCSRW+BITCWDS)-1:0] t4_padrB_a3  [0:NUMDBNK-1];

genvar a3p;
generate for (a3p=0;a3p<NUMDBNK;a3p=a3p+1) begin: a3_loop 

  algo_nw1ru_1r1w #(
    .BITWDTH (1), .WIDTH (2), .NUMSTPT (NUMSTPT), .NUMPBNK (NUMCBNK), .BITPBNK (BITCBNK),
    .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITPADR (BITCPDR-1),
    .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPECC), .UPDT_DELAY (UPDT_DELAY), .FLOPIN (0), .FLOPOUT (0))
  algo (
    .clk(clk), .rst(rst), .ready(ready_a3[a3p]),
    .st_write(t2_writeA_a1[a3p]), .st_adr(t2_addrA_a1[a3p]), .st_din(t2_dinA_a1[a3p]),
    .read(t2_readB_a1[a3p]), .write(t2_writeB_a1[a3p]), .addr(t2_addrB_a1[a3p]), .din(t2_dinB_a1[a3p]), .rd_vld(t2_vldB_a1[a3p]), .rd_dout(t2_doutB_a1[a3p]),
    .rd_fwrd(t2_padrB_a1[a3p][BITCPDR-1]), .rd_serr(t2_serrB_a1[a3p]), .rd_derr(t2_derrB_a1[a3p]), .rd_padr(t2_padrB_a1[a3p][BITCPDR-2:0]),
    .t1_writeA(t4_writeA_a3[a3p]), .t1_addrA(t4_addrA_a3[a3p]), .t1_dinA(t4_dinA_a3[a3p]),
    .t1_readB(t4_readB_a3[a3p]),   .t1_addrB(t4_addrB_a3[a3p]), .t1_doutB(t4_doutB_a3[a3p]),
    .t1_fwrdB(t4_fwrdB_a3[a3p]),   .t1_serrB(t4_serrB_a3[a3p]), .t1_derrB(t4_derrB_a3[a3p]), .t1_padrB(t4_padrB_a3[a3p]),
    .select_addr(select_addr), .select_bit({1{1'b0}}));
end
endgenerate

wire                       t4_writeA_wire   [0:NUMDBNK-1][0:NUMCBNK-1];
wire [BITCSRW-1:0]         t4_addrA_wire    [0:NUMDBNK-1][0:NUMCBNK-1];
wire [NUMCWDS*2-1:0]               t4_bwA_wire      [0:NUMDBNK-1][0:NUMCBNK-1];
wire [NUMCWDS*2-1:0]               t4_dinA_wire     [0:NUMDBNK-1][0:NUMCBNK-1];
wire                       t4_readB_wire    [0:NUMDBNK-1][0:NUMCBNK-1];
wire [BITCSRW-1:0]         t4_addrB_wire    [0:NUMDBNK-1][0:NUMCBNK-1];
wire [2-1:0]               t4_doutB_a3_wire [0:NUMDBNK-1][0:NUMCBNK-1];
wire                       t4_fwrdB_a3_wire [0:NUMDBNK-1][0:NUMCBNK-1];
wire                       t4_serrB_a3_wire [0:NUMDBNK-1][0:NUMCBNK-1];
wire                       t4_derrB_a3_wire [0:NUMDBNK-1][0:NUMCBNK-1];
wire [BITCSRW+BITCWDS-1:0]         t4_padrB_a3_wire [0:NUMDBNK-1][0:NUMCBNK-1];

genvar t4p, t4c;
generate
  for (t4p=0; t4p<NUMDBNK; t4p=t4p+1) begin: t4p_loop
    for (t4c=0; t4c<NUMCBNK; t4c=t4c+1) begin: t4c_loop
      wire t4_writeA_a3_wire = t4_writeA_a3[t4p] >> t4c;
      wire [BITADDR-1:0] t4_addrA_a3_wire = t4_addrA_a3[t4p] >> (t4c*BITADDR);
      wire [2-1:0] t4_dinA_a3_wire = t4_dinA_a3[t4p] >> (t4c*2);
      wire t4_readB_a3_wire = t4_readB_a3[t4p] >> t4c;
      wire [BITADDR-1:0] t4_addrB_a3_wire = t4_addrB_a3[t4p] >> (t4c*BITADDR);

      wire [NUMCWDS*2-1:0] t4_doutB_wire = t4_doutB >> ((t4p*NUMCBNK+t4c)*PHCWDTH);

      wire mem_write_wire;
      wire [BITCSRW-1:0] mem_wr_adr_wire;
      wire [NUMCWDS*2-1:0] mem_bw_wire;
      wire [NUMCWDS*2-1:0] mem_din_wire;
      wire mem_read_wire;
      wire [BITCSRW-1:0] mem_rd_adr_wire;
      wire [NUMCWDS*2-1:0] mem_rd_dout_wire;
      wire mem_rd_fwrd_wire;
      wire mem_rd_serr_wire;
      wire mem_rd_derr_wire;
      wire [(BITWBNK+BITWROW)-1:0] mem_rd_padr_wire;

    if (1) begin: align_loop
      infra_align_ecc_1r1w #(
        .WIDTH (2), .ENAPSDO (NUMCWDS==1), .ENAPAR (ENAPAR), .ENAECC (ENAECC), .ECCWDTH (ECCWDTH), .ENAPADR (1),
        .NUMADDR (NUMADDR), .BITADDR (BITADDR),
        .NUMSROW (NUMCSRW), .BITSROW (BITCSRW), .NUMWRDS (NUMCWDS), .BITWRDS (BITCWDS), .BITPADR (BITCWDS+BITWBNK+BITWROW),
        .SRAM_DELAY (SRAM_DELAY+FLOPCMD+FLOPMEM), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC), .RSTZERO (1))
      infra (
        .write(t4_writeA_a3_wire), .wr_adr(t4_addrA_a3_wire), .din(t4_dinA_a3_wire),
        .read(t4_readB_a3_wire), .rd_adr(t4_addrB_a3_wire), .rd_dout(t4_doutB_a3_wire[t4p][t4c]),
        .rd_fwrd(t4_fwrdB_a3_wire[t4p][t4c]), .rd_serr(t4_serrB_a3_wire[t4p][t4c]), .rd_derr(t4_derrB_a3_wire[t4p][t4c]), .rd_padr(t4_padrB_a3_wire[t4p][t4c]),
        .mem_write (mem_write_wire), .mem_wr_adr(mem_wr_adr_wire), .mem_bw (mem_bw_wire), .mem_din (mem_din_wire),
        .mem_read (mem_read_wire), .mem_rd_adr(mem_rd_adr_wire), .mem_rd_dout (mem_rd_dout_wire),
        .mem_rd_fwrd(mem_rd_fwrd_wire), .mem_rd_padr(mem_rd_padr_wire),
        .clk (clk), .rst (rst),
        .select_addr (select_addr));
    end

    if (1) begin: stack_loop
      infra_stack_1r1w #(
        .WIDTH (NUMCWDS*2), .ENAPSDO (NUMCWDS>1), .NUMADDR (NUMCSRW), .BITADDR (BITCSRW),
        .NUMWROW (NUMCWRW), .BITWROW (BITCWRW), .NUMWBNK (1), .BITWBNK (0),
        .SRAM_DELAY (SRAM_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM), .RSTZERO (1))
      infra (
        .write (mem_write_wire), .wr_adr (mem_wr_adr_wire), .bw (mem_bw_wire), .din (mem_din_wire),
        .read (mem_read_wire), .rd_adr (mem_rd_adr_wire), .rd_dout (mem_rd_dout_wire),
        .rd_fwrd (mem_rd_fwrd_wire), .rd_serr (mem_rd_serr_wire), .rd_derr(mem_rd_derr_wire), .rd_padr(mem_rd_padr_wire),
        .mem_write (t4_writeA_wire[t4p][t4c]), .mem_wr_adr(t4_addrA_wire[t4p][t4c]), .mem_bw (t4_bwA_wire[t4p][t4c]), .mem_din (t4_dinA_wire[t4p][t4c]),
        .mem_read (t4_readB_wire[t4p][t4c]), .mem_rd_adr(t4_addrB_wire[t4p][t4c]), .mem_rd_dout (t4_doutB_wire),
        .clk (clk), .rst(rst),
        .select_addr (select_csrw));
    end
  end
end
endgenerate

reg [NUMDBNK*NUMCBNK*1-1:0]       t4_writeA;
reg [NUMDBNK*NUMCBNK*BITCSRW-1:0] t4_addrA;
reg [NUMDBNK*NUMCBNK*PHCWDTH-1:0] t4_bwA;
reg [NUMDBNK*NUMCBNK*PHCWDTH-1:0] t4_dinA;
reg [NUMDBNK*NUMCBNK*1-1:0]       t4_readB;
reg [NUMDBNK*NUMCBNK*BITCSRW-1:0] t4_addrB;
integer t4p_int, t4c_int;
always_comb begin
  t4_writeA = 0;
  t4_addrA = 0;
  t4_bwA = 0;
  t4_dinA = 0;
  t4_readB = 0;
  t4_addrB = 0;
  for (t4p_int=0; t4p_int<NUMDBNK; t4p_int=t4p_int+1) begin
    t4_doutB_a3[t4p_int] = 0;
    t4_fwrdB_a3[t4p_int] = 0;
    t4_serrB_a3[t4p_int] = 0;
    t4_derrB_a3[t4p_int] = 0;
    t4_padrB_a3[t4p_int] = 0;
    for (t4c_int=0; t4c_int<NUMCBNK; t4c_int=t4c_int+1) begin
      t4_writeA   = t4_writeA   | (t4_writeA_wire[t4p_int][t4c_int]   << ((t4p_int*NUMCBNK+t4c_int)*1));
      t4_addrA    = t4_addrA    | ( t4_addrA_wire[t4p_int][t4c_int]   << ((t4p_int*NUMCBNK+t4c_int)*BITCSRW));
      t4_bwA      = t4_bwA      | (   t4_bwA_wire[t4p_int][t4c_int]   << ((t4p_int*NUMCBNK+t4c_int)*PHCWDTH));
      t4_dinA     = t4_dinA     | (  t4_dinA_wire[t4p_int][t4c_int]   << ((t4p_int*NUMCBNK+t4c_int)*PHCWDTH));
      t4_readB    = t4_readB    | ( t4_readB_wire[t4p_int][t4c_int]   << ((t4p_int*NUMCBNK+t4c_int)*1));
      t4_addrB    = t4_addrB    | ( t4_addrB_wire[t4p_int][t4c_int]   << ((t4p_int*NUMCBNK+t4c_int)*BITCSRW));
      t4_doutB_a3[t4p_int] = t4_doutB_a3[t4p_int] | (t4_doutB_a3_wire[t4p_int][t4c_int] << ((t4c_int)*2));
      t4_fwrdB_a3[t4p_int] = t4_fwrdB_a3[t4p_int] | (t4_fwrdB_a3_wire[t4p_int][t4c_int] << ((t4c_int)*1));
      t4_serrB_a3[t4p_int] = t4_serrB_a3[t4p_int] | (t4_serrB_a3_wire[t4p_int][t4c_int] << ((t4c_int)*1));
      t4_derrB_a3[t4p_int] = t4_derrB_a3[t4p_int] | (t4_derrB_a3_wire[t4p_int][t4c_int] << ((t4c_int)*1));
      t4_padrB_a3[t4p_int] = t4_padrB_a3[t4p_int] | (t4_padrB_a3_wire[t4p_int][t4c_int] << ((t4c_int)*(BITCSRW)));
    end
  end
end

endmodule // algo_mrcnw_1r2w_rl_top


