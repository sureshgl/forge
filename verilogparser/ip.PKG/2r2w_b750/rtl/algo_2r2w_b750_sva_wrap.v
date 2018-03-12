module algo_2r2w_b750_sva_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter IP_REFRESH = 1, parameter IP_REFFREQ = 6,  parameter IP_REFFRHF = 0,

parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 2,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128,
parameter T1_NUMVROW = 256, parameter T1_BITVROW = 8
)
(clk, rst, write, wr_adr, din, bw, read, rd_adr, rd_dout, rd_vld, flopout_en,
 t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_writeB, t1_addrB, t1_dinB, t1_bwB,
 t1_readC, t1_addrC, t1_doutC, t1_readD, t1_addrD, t1_doutD);

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMRDPT = 1;
  parameter NUMADDR = IP_NUMADDR;
  parameter BITADDR = IP_BITADDR;
  parameter NUMVROW = T1_NUMVROW;
  parameter BITVROW = T1_BITVROW;
  parameter NUMVBNK = IP_NUMVBNK;
  parameter BITVBNK = IP_BITVBNK;
  parameter SRAM_DELAY = T1_DELAY;
  parameter NUMWRDS = T1_NUMWRDS;      // ALIGN Parameters
  parameter BITWRDS = T1_BITWRDS;
  parameter NUMSROW = T1_NUMSROW;
  parameter BITSROW = T1_BITSROW;      
  parameter PHYWDTH = T1_PHYWDTH;
  parameter BITPADR = BITVBNK+BITSROW+BITWRDS+1;

  input [2-1:0]                                 write;
  input [2*BITADDR-1:0]                         wr_adr;
  input [2*WIDTH-1:0]                           din;
  input [2*WIDTH-1:0]                           bw;

  input [2*NUMRDPT-1:0]                         read;
  input [2*NUMRDPT*BITADDR-1:0]                 rd_adr;
  input [2*NUMRDPT-1:0]                        rd_vld;
  input [2*NUMRDPT*WIDTH-1:0]                  rd_dout;

  input                                         clk, rst;
  input                                         flopout_en;

  input [NUMRDPT*NUMVBNK-1:0]                t1_writeA;
  input [NUMRDPT*NUMVBNK*BITSROW-1:0]        t1_addrA;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0]          t1_dinA;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0]          t1_bwA;

  input [NUMRDPT*NUMVBNK-1:0]                t1_writeB;
  input [NUMRDPT*NUMVBNK*BITSROW-1:0]        t1_addrB;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0]          t1_dinB;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0]          t1_bwB;

  input [NUMRDPT*NUMVBNK-1:0]                t1_readC;
  input [NUMRDPT*NUMVBNK*BITSROW-1:0]        t1_addrC;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0]           t1_doutC;

  input [NUMRDPT*NUMVBNK-1:0]                t1_readD;
  input [NUMRDPT*NUMVBNK*BITSROW-1:0]        t1_addrD;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0]           t1_doutD;

  assert_write_conflict: assert property (@(posedge clk) disable iff (rst) (!(write[0] && write[1] && (wr_adr[2*BITADDR-1:BITADDR] == wr_adr[BITADDR-1:0]))))
    else $display("[ERROR:memoir:%m:%0t] write conflict on write_addr=0x%0x", $time, wr_adr[BITADDR-1:0]);

endmodule
