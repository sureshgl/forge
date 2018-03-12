module algo_2r2w_b750_top_wrap
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

// MEMOIR_TRANSLATE_OFF

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
  output [2*NUMRDPT-1:0]                        rd_vld;
  output [2*NUMRDPT*WIDTH-1:0]                  rd_dout;

  input                                         clk, rst;
  input                                         flopout_en;

  output [NUMRDPT*NUMVBNK-1:0]                t1_writeA;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0]        t1_addrA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]          t1_dinA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]          t1_bwA;

  output [NUMRDPT*NUMVBNK-1:0]                t1_writeB;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0]        t1_addrB;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]          t1_dinB;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]          t1_bwB;

  output [NUMRDPT*NUMVBNK-1:0]                t1_readC;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0]        t1_addrC;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0]           t1_doutC;

  output [NUMRDPT*NUMVBNK-1:0]                t1_readD;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0]        t1_addrD;
  input [NUMRDPT*NUMVBNK*PHYWDTH-1:0]           t1_doutD;

  wire [2*NUMRDPT*NUMVBNK-1:0]                t1_writeA_wire;
  wire [2*NUMRDPT*NUMVBNK*BITSROW-1:0]        t1_addrA_wire;
  wire [2*NUMVBNK*PHYWDTH-1:0]                  t1_dinA_wire;  
  wire [2*NUMVBNK*PHYWDTH-1:0]                  t1_bwA_wire;

  wire [2*NUMRDPT*NUMVBNK-1:0]                t1_readB_wire;
  wire [2*NUMRDPT*NUMVBNK*BITSROW-1:0]        t1_addrB_wire;
  reg [2*NUMVBNK*PHYWDTH-1:0]                   t1_doutB_wire;


  algo_2nr2w_b750_dup_top  #(.WIDTH(WIDTH),
					   .BITWDTH(BITWDTH),
					   .NUMRDPT(NUMRDPT),
					   .NUMADDR(NUMADDR),
					   .BITADDR(BITADDR),
					   .NUMVROW(NUMVROW),
					   .BITVROW(BITVROW),
					   .NUMVBNK(NUMVBNK),
					   .BITVBNK(BITVBNK),
					   .NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW), .PHYWDTH(PHYWDTH), 
					   .SRAM_DELAY(SRAM_DELAY), .FLOPIN(FLOPIN),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT))
				algo_top
					(.clk(clk), .rst(rst), 
					 .write(write), .wr_adr(wr_adr), .din(din),
					 .read(read), .rd_adr(rd_adr),
                     .rd_vld(rd_vld), .rd_dout(rd_dout), 
					 .t1_writeA(t1_writeA_wire), .t1_addrA(t1_addrA_wire), .t1_dinA(t1_dinA_wire), .t1_bwA(t1_bwA_wire),
					 .t1_readB(t1_readB_wire), .t1_addrB(t1_addrB_wire), .t1_doutB(t1_doutB_wire));
  
  reg [NUMRDPT*NUMVBNK-1:0]                t1_writeA;
  reg [NUMRDPT*NUMVBNK*BITSROW-1:0]        t1_addrA;
  reg [NUMRDPT*NUMVBNK*PHYWDTH-1:0]          t1_dinA;  
  reg [NUMRDPT*NUMVBNK*PHYWDTH-1:0]          t1_bwA;
  reg                     t1_writeA_tmp [0:NUMRDPT-1][0:NUMVBNK-1];
  reg [BITSROW-1:0]       t1_addrA_tmp [0:NUMRDPT-1][0:NUMVBNK-1];
  reg [PHYWDTH-1:0]         t1_dinA_tmp [0:NUMRDPT-1][0:NUMVBNK-1];  
  reg [PHYWDTH-1:0]         t1_bwA_tmp [0:NUMRDPT-1][0:NUMVBNK-1];

  reg [NUMRDPT*NUMVBNK-1:0]                t1_writeB;
  reg [NUMRDPT*NUMVBNK*BITSROW-1:0]        t1_addrB;
  reg [NUMRDPT*NUMVBNK*PHYWDTH-1:0]          t1_dinB;  
  reg [NUMRDPT*NUMVBNK*PHYWDTH-1:0]          t1_bwB;
  reg                     t1_writeB_tmp [0:NUMRDPT-1][0:NUMVBNK-1];
  reg [BITSROW-1:0]       t1_addrB_tmp [0:NUMRDPT-1][0:NUMVBNK-1];
  reg [PHYWDTH-1:0]         t1_dinB_tmp [0:NUMRDPT-1][0:NUMVBNK-1];  
  reg [PHYWDTH-1:0]         t1_bwB_tmp [0:NUMRDPT-1][0:NUMVBNK-1];

  reg [NUMRDPT*NUMVBNK-1:0]                t1_readC;
  reg [NUMRDPT*NUMVBNK*BITSROW-1:0]        t1_addrC;
  reg                     t1_readC_tmp [0:NUMRDPT-1][0:NUMVBNK-1];
  reg [BITSROW-1:0]       t1_addrC_tmp [0:NUMRDPT-1][0:NUMVBNK-1];
  reg [PHYWDTH-1:0]         t1_doutC_tmp [0:NUMRDPT-1][0:NUMVBNK-1];

  reg [NUMRDPT*NUMVBNK-1:0]                t1_readD;
  reg [NUMRDPT*NUMVBNK*BITSROW-1:0]        t1_addrD;
  reg                     t1_readD_tmp [0:NUMRDPT-1][0:NUMVBNK-1];
  reg [BITSROW-1:0]       t1_addrD_tmp [0:NUMRDPT-1][0:NUMVBNK-1];
  reg [PHYWDTH-1:0]         t1_doutD_tmp [0:NUMRDPT-1][0:NUMVBNK-1];

  integer t1p_int, t1b_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;    
	t1_bwA = 0;
    t1_writeB = 0;
    t1_addrB = 0;
    t1_dinB = 0;    
	t1_bwB = 0;
    t1_readC = 0;
    t1_addrC = 0;
    t1_readD = 0;
    t1_addrD = 0;
    t1_doutB_wire = 0;
    for (t1p_int=0; t1p_int<NUMRDPT; t1p_int=t1p_int+1) begin
      for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1) begin
        t1_writeA_tmp[t1p_int][t1b_int] = t1_writeA_wire >> (2*(NUMRDPT*t1b_int+t1p_int)+0);
        t1_addrA_tmp[t1p_int][t1b_int] = t1_addrA_wire >> ((2*(NUMRDPT*t1b_int+t1p_int)+0)*BITSROW);
        t1_dinA_tmp[t1p_int][t1b_int] = t1_dinA_wire >> ((2*(NUMRDPT*t1b_int+t1p_int)+0)*PHYWDTH);        
		t1_bwA_tmp[t1p_int][t1b_int] = t1_bwA_wire >> ((2*(NUMRDPT*t1b_int+t1p_int)+0)*PHYWDTH);
        t1_writeB_tmp[t1p_int][t1b_int] = t1_writeA_wire >> (2*(NUMRDPT*t1b_int+t1p_int)+1);
        t1_addrB_tmp[t1p_int][t1b_int] = t1_addrA_wire >> ((2*(NUMRDPT*t1b_int+t1p_int)+1)*BITSROW);
        t1_dinB_tmp[t1p_int][t1b_int] = t1_dinA_wire >> ((2*(NUMRDPT*t1b_int+t1p_int)+1)*PHYWDTH);        
		t1_bwB_tmp[t1p_int][t1b_int] = t1_bwA_wire >> ((2*(NUMRDPT*t1b_int+t1p_int)+1)*PHYWDTH);
        t1_readC_tmp[t1p_int][t1b_int] = t1_readB_wire >> (2*(NUMRDPT*t1b_int+t1p_int)+0);
        t1_addrC_tmp[t1p_int][t1b_int] = t1_addrB_wire >> ((2*(NUMRDPT*t1b_int+t1p_int)+0)*BITSROW);
        t1_doutC_tmp[t1p_int][t1b_int] = t1_doutC >> ((NUMRDPT*t1b_int+t1p_int)*PHYWDTH);
        t1_readD_tmp[t1p_int][t1b_int] = t1_readB_wire >> (2*(NUMRDPT*t1b_int+t1p_int)+1);
        t1_addrD_tmp[t1p_int][t1b_int] = t1_addrB_wire >> ((2*(NUMRDPT*t1b_int+t1p_int)+1)*BITSROW);
        t1_doutD_tmp[t1p_int][t1b_int] = t1_doutD >> ((NUMRDPT*t1b_int+t1p_int)*PHYWDTH);
        t1_writeA = t1_writeA | (t1_writeA_tmp[t1p_int][t1b_int] << (NUMRDPT*t1b_int+t1p_int));
        t1_addrA = t1_addrA | (t1_addrA_tmp[t1p_int][t1b_int] << ((NUMRDPT*t1b_int+t1p_int)*BITSROW));
        t1_dinA = t1_dinA | (t1_dinA_tmp[t1p_int][t1b_int] << ((NUMRDPT*t1b_int+t1p_int)*PHYWDTH));        
		t1_bwA = t1_bwA | (t1_bwA_tmp[t1p_int][t1b_int] << ((NUMRDPT*t1b_int+t1p_int)*PHYWDTH));
        t1_writeB = t1_writeB | (t1_writeB_tmp[t1p_int][t1b_int] << (NUMRDPT*t1b_int+t1p_int));
        t1_addrB = t1_addrB | (t1_addrB_tmp[t1p_int][t1b_int] << ((NUMRDPT*t1b_int+t1p_int)*BITSROW));
        t1_dinB = t1_dinB | (t1_dinB_tmp[t1p_int][t1b_int] << ((NUMRDPT*t1b_int+t1p_int)*PHYWDTH));        
		t1_bwB = t1_bwB | (t1_bwB_tmp[t1p_int][t1b_int] << ((NUMRDPT*t1b_int+t1p_int)*PHYWDTH));
        t1_readC = t1_readC | (t1_readC_tmp[t1p_int][t1b_int] << (NUMRDPT*t1b_int+t1p_int));
        t1_addrC = t1_addrC | (t1_addrC_tmp[t1p_int][t1b_int] << ((NUMRDPT*t1b_int+t1p_int)*BITSROW));
        t1_readD = t1_readD | (t1_readD_tmp[t1p_int][t1b_int] << (NUMRDPT*t1b_int+t1p_int));
        t1_addrD = t1_addrD | (t1_addrD_tmp[t1p_int][t1b_int] << ((NUMRDPT*t1b_int+t1p_int)*BITSROW));
        t1_doutB_wire = t1_doutB_wire | ({t1_doutD_tmp[t1p_int][t1b_int],t1_doutC_tmp[t1p_int][t1b_int]} << (2*(NUMRDPT*t1b_int+t1p_int)*PHYWDTH));
      end
    end
  end

// MEMOIR_TRANSLATE_ON

endmodule    //algo_2r2w_b750_top_wrap

