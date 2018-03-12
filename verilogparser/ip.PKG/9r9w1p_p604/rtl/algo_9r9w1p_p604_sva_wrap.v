module algo_9r9w1p_p604_sva_wrap
#(parameter IP_WIDTH = 64, parameter IP_BITWIDTH = 6, parameter IP_NUMADDR = 8192, parameter IP_DECCBITS = 0,
parameter IP_BITADDR = 13, parameter IP_NUMVBNK = 1, parameter IP_BITVBNK = 1, parameter IP_BITPBNK = 1,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter T1_WIDTH = 64,
parameter NUMGRPW = 13, parameter GRPWDTH = 138, parameter NUMGRPF = 5, parameter NUMCMDL = 4, parameter BITCMDL = 2,
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 1,
parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128,
parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13, parameter T1_BITWSPF = 0
)

(clk, rst, ready, write, wr_adr, din, read, rd_adr, rd_dout, rd_vld, rd_serr, rd_derr, rd_padr,
 t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_readB, t1_addrB, t1_doutB);
// MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMRDPT = 9;
  parameter NUMWRPT = 9;
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

  input [NUMWRPT-1:0]                              write;
  input [NUMWRPT*BITADDR-1:0]                      wr_adr;
  input [NUMWRPT*WIDTH-1:0]                        din;

  input [NUMRDPT-1:0]                              read;
  input [NUMRDPT*BITADDR-1:0]                      rd_adr;
  input [NUMRDPT-1:0]                             rd_vld;
  input [NUMRDPT*WIDTH-1:0]                       rd_dout;
  input [NUMRDPT-1:0]                             rd_serr;
  input [NUMRDPT-1:0]                             rd_derr;
  input [NUMRDPT*BITPADR-1:0]                     rd_padr;

  input                                           ready;
  input                                            clk, rst;

  input [NUMGRPW*NUMVBNK-1:0] t1_writeA;
  input [NUMGRPW*NUMVBNK*BITSROW-1:0] t1_addrA;
  input [NUMVBNK*PHYWDTH-1:0] t1_bwA;
  input [NUMVBNK*PHYWDTH-1:0] t1_dinA;
  input [NUMGRPW*NUMVBNK-1:0] t1_readB;
  input [NUMGRPW*NUMVBNK*BITSROW-1:0] t1_addrB;
  input [NUMVBNK*PHYWDTH-1:0] t1_doutB;

  reg [BITADDR - 1 - BITVROW : 0] wbank [0:NUMWRPT-1];

  genvar             i;
  generate
    for (i = 0; i < NUMWRPT; i++) begin : wbank_val
       always_comb begin
         wbank[i] =  wr_adr>> (i*BITADDR + BITVROW);
       end
     end
  endgenerate

  genvar           j;
  genvar           k;
  generate
    for (j = 0; j < NUMWRPT; j++) begin
      for (k = 0; k < j; k++) begin
        assert_w_bank_conflict: assert property (@(posedge clk) disable iff (!ready) 1 |-> !(write[j] & write[k] & (wbank[j] == wbank[k])))
          else $display("[ERROR:memoir:%m:%0t] write bank conflict w%0d w%0d bank%0d=0x%0x bank%0d=0x%0x", $time, j+1, k+1, j+1, wbank[j], k+1, wbank[k]);
      end
    end
  endgenerate

endmodule    //algo_9r9w1p_p604_sva_wrap
