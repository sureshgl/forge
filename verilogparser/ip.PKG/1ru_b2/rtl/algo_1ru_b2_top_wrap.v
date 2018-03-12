module algo_1ru_b2_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 1,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128,
parameter T1_NUMVROW = 8192, parameter T1_BITVROW = 13
)

(clk, rst, ready, ru_write, ru_addr, ru_din, ru_read, ru_dout, ru_vld, ru_serr, ru_derr, ru_padr,
 t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_readB, t1_addrB, t1_doutB, refr);
// MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter NUMRUPT = 1;
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

  input                                            ru_write;
  input [BITADDR-1:0]                              ru_addr;
  input [WIDTH-1:0]                                ru_din;

  input [NUMRUPT-1:0]                              ru_read;
  output [NUMRUPT-1:0]                             ru_vld;
  output [NUMRUPT*WIDTH-1:0]                       ru_dout;
  output [NUMRUPT-1:0]                             ru_serr;
  output [NUMRUPT-1:0]                             ru_derr;
  output [NUMRUPT*BITPADR-1:0]                     ru_padr;

  output                                           ready;
  input                                            clk, rst;

  output [NUMRUPT*NUMVBNK-1:0]                     t1_writeA;
  output [NUMRUPT*NUMVBNK*BITSROW-1:0]   		   t1_addrA;
  output [NUMRUPT*NUMVBNK*PHYWDTH-1:0]             t1_dinA;
  output [NUMRUPT*NUMVBNK*PHYWDTH-1:0]             t1_bwA;

  output [NUMRUPT*NUMVBNK-1:0]                     t1_readB;
  output [NUMRUPT*NUMVBNK*BITSROW-1:0]   		   t1_addrB;
  input  [NUMRUPT*NUMVBNK*PHYWDTH-1:0]             t1_doutB;

  input  refr;
/*
`ifdef AMP_REF
  wire                  rd_vld_rtl;
  wire [WIDTH-1:0]      rd_dout_rtl;
  wire                  rd_serr_rtl;
  wire                  rd_derr_rtl;
  wire [BITPADR-1:0]    rd_padr_rtl;
  
  task Write;
  input [BITADDR-1:0] addr;
  input [WIDTH-1:0] ru_din;
  begin 
    algo_ref.bdw_flag[addr] = 1'b1;
    algo_ref.mem[addr] = ru_din; 
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

  algo_mrnrwpw_ref #(
    .WIDTH(WIDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMRDPT(1), .NUMRWPT(0), .NUMWRPT(1),
    .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
    .NUMSROW(NUMSROW), .BITSROW(BITSROW), .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .BITPADR(BITPADR),
    .MEM_DELAY(T1_DELAY+FLOPIN+FLOPMEM+FLOPOUT)) algo_ref (
       .rd_read(ru_read), .rd_addr(ru_addr), .rd_vld(ru_vld), .rd_dout(ru_dout), .rd_serr(ru_serr), .rd_derr(ru_derr), .rd_padr(ru_padr),
       .rw_read(), .rw_write(), .rw_addr(), .rw_din(), .rw_vld(), .rw_dout(), .rw_serr(), .rw_derr(), .rw_padr(),
       .wr_write(ru_write), .wr_addr(wr_adr), .wr_din(ru_din),
       .clk(clk), .ready(), .rst(rst));
`endif
*/

reg H2O_AMC1R1WB10_001_00;
always @(posedge clk)
  H2O_AMC1R1WB10_001_00 <= rst;
wire rst_int = H2O_AMC1R1WB10_001_00 && rst;


  algo_1ru_nr1w_b2_top #(			  .WIDTH(WIDTH),
					  .BITWDTH(BITWDTH),
					  .NUMADDR(NUMADDR),
					  .BITADDR(BITADDR),
					  .NUMRUPT(NUMRUPT),
					  .NUMVROW(NUMVROW),
					  .BITVROW(BITVROW),
					  .NUMVBNK(NUMVBNK),
					  .BITVBNK(BITVBNK),
					  .NUMWRDS(NUMWRDS),
					  .BITWRDS(BITWRDS),
					  .NUMSROW(NUMSROW),
					  .BITSROW(BITSROW),
					  .PHYWDTH(PHYWDTH), 
					  .SRAM_DELAY(SRAM_DELAY),
					  .FLOPIN(FLOPIN),
					  .FLOPMEM(FLOPMEM),
					  .FLOPOUT(FLOPOUT))
				algo_top
					(.clk(clk),
					 .rst(rst_int),
					 .ready(ready),
					 .write(ru_write),
					 .addr(ru_addr),
					 .din(ru_din),
					 .read(ru_read),
`ifdef AMP_REF
                                         .rd_vld(ru_vld_rtl),
					 .rd_dout(ru_dout_rtl),
					 .rd_serr(ru_serr_rtl),
					 .rd_derr(ru_derr_rtl),
					 .rd_padr(ru_padr_rtl),
`else
                                         .rd_vld(ru_vld),
					 .rd_dout(ru_dout),
					 .rd_serr(ru_serr),
					 .rd_derr(ru_derr),
					 .rd_padr(ru_padr),
`endif

					 .t1_writeA(t1_writeA),
					 .t1_addrA(t1_addrA),
					 .t1_dinA(t1_dinA),
					 .t1_bwA(t1_bwA),
					 .t1_readB(t1_readB),
					 .t1_addrB(t1_addrB),
					 .t1_doutB(t1_doutB));
  
// MEMOIR_TRANSLATE_ON
endmodule    //algo_1ru_b2_top_wrap

