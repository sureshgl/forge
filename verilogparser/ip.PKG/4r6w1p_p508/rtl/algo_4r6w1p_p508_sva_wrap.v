module algo_4r6w1p_p508_sva_wrap
#(parameter IP_WIDTH = 64, parameter IP_BITWIDTH = 6, parameter IP_NUMADDR = 8192, parameter IP_DECCBITS = 0,
parameter IP_BITADDR = 13, parameter IP_NUMVBNK = 1, parameter IP_BITVBNK = 1, parameter IP_BITPBNK = 1,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter T1_WIDTH = 64,
parameter NUMGRPW = 4, parameter WRBUSRED = 1,
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,
parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 1,
parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128,
parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13, parameter T1_BITWSPF = 0
)

(clk, rst, ready, write, wr_badr, wr_radr, din, read, rd_badr, rd_radr, rd_dout, rd_vld, rd_serr, rd_derr, rd_padr);
// MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMRDPT = 4;
  parameter NUMWRPT = 6;
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
  input [NUMWRPT*BITVBNK-1:0]                      wr_badr;
  input [NUMWRPT*BITVROW-1:0]                      wr_radr;
  input [(2+4/WRBUSRED)*WIDTH-1:0]                        din;

  input [NUMRDPT-1:0]                              read;
  input [NUMRDPT*BITVBNK-1:0]                      rd_badr;
  input [NUMRDPT*BITVROW-1:0]                      rd_radr;
  input [NUMRDPT-1:0]                             rd_vld;
  input [NUMRDPT*WIDTH-1:0]                       rd_dout;
  input [NUMRDPT-1:0]                             rd_serr;
  input [NUMRDPT-1:0]                             rd_derr;
  input [NUMRDPT*BITPADR-1:0]                     rd_padr;

  input                                           ready;
  input                                            clk, rst;

  reg [BITADDR - 1 - BITVROW : 0] wbank [0:NUMWRPT-1];

  genvar             i;
  generate
    for (i = 0; i < NUMWRPT; i++) begin : wbank_val
       always_comb begin
         wbank[i] =  wr_badr>> (i*BITVBNK);
       end
     end
  endgenerate

  reg [BITADDR - 1 - BITVROW : 0] rbank [0:NUMRDPT-1];
  genvar             m;
  generate
    for (m = 0; m < NUMRDPT; m++) begin : rbank_val
       always_comb begin
         rbank[m] =  rd_badr>> (m*BITVBNK);
       end
     end
  endgenerate

  genvar           j;
  genvar           k;
  generate
    for (j = 0; j < NUMWRPT; j++) begin
      for (k = 0; k < j; k++) begin
        assert_w_bank_conflict: assert property (@(posedge clk) disable iff (!ready || ready === 1'bx) 1 |-> !(write[j] & write[k] & (wbank[j] == wbank[k])))
	  else $display("[ERROR:memoir:%m:%0t] write bank conflict w%0d w%0d bank%0d=0x%0x bank%0d=0x%0x, write_1 is 0x%0x, write_2 is 0x%0x, ready is 0x%0x", $time, j+1, k+1, j+1, wbank[j], k+1, wbank[k], write[j], write[k], ready);
      end
    end
  endgenerate

  genvar           p;
  genvar           q;
  generate
    for (p = 0; p < NUMRDPT; p++) begin
      for (q = 0; q < p; q++) begin
        assert_r_bank_conflict: assert property (@(posedge clk) disable iff (!ready || ready === 1'bx) 1 |-> !(read[p] & read[q] & (rbank[p] == rbank[q])))
          else $display("[ERROR:memoir:%m:%0t] read bank conflict w%0d w%0d bank%0d=0x%0x bank%0d=0x%0x", $time, p+1, q+1, p+1, rbank[p], q+1, rbank[q]);
      end
    end
  endgenerate

endmodule    //algo_8r20w1p_p507_sva_wrap
