module algo_1rw_b701_top_wrap
#(parameter IP_WIDTH = 4, parameter IP_BITWIDTH = 2, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 32, parameter IP_BITADDR = 5, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 4,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 4, parameter T1_NUMVBNK = 4, parameter T1_BITVBNK = 2, parameter T1_DELAY = 1,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 8, parameter T1_BITSROW = 3, parameter T1_PHYWDTH = 4,
parameter T1_NUMVROW = 8, parameter T1_BITVROW = 3
)

(clk, rst, rw_read, rw_write, rw_addr, rw_bw, rw_din, rw_dout, rw_vld, 
 t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_doutA, flopout_en);

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR = IP_ENAPAR;
  parameter ENAECC = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
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
  parameter FLOPWTH = FLOPOUT >0?FLOPOUT:1;

  input                                            rw_write;
  input                                            rw_read;
  input [BITADDR-1:0]                              rw_addr;
  input [WIDTH-1:0]                                rw_bw;
  input [WIDTH-1:0]                                rw_din;

  output                                           rw_vld;
  output [WIDTH-1:0]                               rw_dout;

  input                                            clk, rst;

  input [FLOPWTH-1:0]                              flopout_en;

  output [NUMRDPT*NUMVBNK-1:0]                     t1_writeA;
  output [NUMRDPT*NUMVBNK*BITSROW-1:0]   		   t1_addrA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]             t1_dinA;
  output [NUMRDPT*NUMVBNK*PHYWDTH-1:0]             t1_bwA;

  output [NUMRDPT*NUMVBNK-1:0]                     t1_readA;
  input  [NUMRDPT*NUMVBNK*PHYWDTH-1:0]             t1_doutA;

  algo_nror1w_b701_dup_top #(.WIDTH(WIDTH), .BITWDTH(BITWDTH), .NUMRDPT(NUMRDPT), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH),
					  .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
					  .NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW), .PHYWDTH(PHYWDTH), 
					  .SRAM_DELAY(SRAM_DELAY), .FLOPIN(FLOPIN),   .FLOPCMD(FLOPCMD),   .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT), .FLOPWTH(FLOPWTH))
				algo_top
					(.clk(clk), .rst(rst), 
					 .write(rw_write), .wr_adr(rw_addr), .bw(rw_bw), .din(rw_din),
                     .flopout_en(flopout_en),
					 .read(rw_read), .rd_adr(rw_addr), .rd_vld(rw_vld), .rd_dout(rw_dout), 
                   //.t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_bwA(t1_bwA), .t1_readB(t1_readA), .t1_addrB(t1_addrA), .t1_doutB(t1_doutA));
					 .t1_writeA(t1_writeA), .t1_addrA(),         .t1_dinA(t1_dinA), .t1_bwA(t1_bwA), .t1_readB(t1_readA), .t1_addrB(t1_addrA), .t1_doutB(t1_doutA));


`ifdef FORMAL2
//synopsys translate_off

wire [BITADDR-1:0] select_addr;
wire [BITWDTH-1:0] select_bit;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_bit_range: assume property (@(posedge clk) disable iff (rst) (select_bit < WIDTH));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));
assume_select_rw_one: assume property (@(posedge clk) disable iff (rst) !(rw_read && rw_write));

wire [BITVROW-1:0] select_vrow;
wire [BITVBNK-1:0] select_vbnk;
np2_addr_ramwrap #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  row_adr (.vbadr(select_vbnk), .vradr(select_vrow), .vaddr(select_addr));

wire [BITSROW-1:0] select_srow;
np2_addr_ramwrap #(
  .NUMADDR (NUMVROW), .BITADDR (BITVROW),
  .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
  .NUMVROW (NUMSROW), .BITVROW (BITSROW))
  vrow_inst (.vbadr(), .vradr(select_srow), .vaddr(select_vrow));

reg fakememinv;
reg fakemem;
always @(posedge clk)
  if (rst) 
    fakememinv <= 1'b1;
  else if (rw_write && (rw_addr == select_addr) && rw_bw[select_bit]) begin
    fakememinv <= 1'b0;
    fakemem <= rw_din[select_bit];
  end

  wire                t1_readA_w [0:NUMRDPT-1][0:NUMVBNK-1];
  wire                t1_writeA_w [0:NUMRDPT-1][0:NUMVBNK-1];
  wire [BITSROW-1:0]  t1_addrA_w  [0:NUMRDPT-1][0:NUMVBNK-1];
  wire [WIDTH-1:0]    t1_dinA_w [0:NUMRDPT-1][0:NUMVBNK-1];
  wire [WIDTH-1:0]    t1_bwA_w [0:NUMRDPT-1][0:NUMVBNK-1];
  wire [WIDTH-1:0]    t1_doutA_w [0:NUMRDPT-1][0:NUMVBNK-1];

  generate for (genvar p=0; p<NUMRDPT; p++) begin
    for (genvar b=0; b<NUMVBNK; b++) begin
      assign t1_readA_w[p][b]    = t1_readA[(p*NUMVBNK+b)];
      assign t1_writeA_w[p][b]   = t1_writeA[(p*NUMVBNK+b)];
      assign t1_dinA_w[p][b]  = t1_dinA[((p*NUMVBNK+b)*WIDTH)+:WIDTH];
      assign t1_bwA_w[p][b]   = t1_bwA[((p*NUMVBNK+b)*WIDTH)+:WIDTH];
      assign t1_doutA_w[p][b] = t1_doutA[((p*NUMVBNK+b)*WIDTH)+:WIDTH];
      assign t1_addrA_w[p][b] = t1_addrA[((p*NUMVBNK+b)*BITSROW)+:BITSROW];
    end
  end
  endgenerate


reg mem;
always @(posedge clk)
  if (t1_writeA_w[0][select_vbnk] && (t1_addrA_w[0][select_vbnk] == select_vrow) && t1_bwA_w[0][select_vbnk][select_bit]) begin
    mem <= t1_dinA_w[0][select_vbnk][select_bit];
  end

  assume_mem_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_w[0][select_vbnk] && (t1_addrA_w[0][select_vbnk] == select_vrow)) |-> ##1
                                                                      (t1_doutA_w[0][select_vbnk][select_bit] == $past(mem,1)));
 

  assert_dout_check_0: assert property (@(posedge clk) disable iff(rst) (rw_read && rw_addr == select_addr) |-> ##1 (fakememinv || ((rw_vld == 1'b1) && (rw_dout[select_bit] == fakemem))));
//synopsys translate_on
`endif

endmodule    //algo_1r1w_b10_top_wrap

