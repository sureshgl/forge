module algo_2rw_b40_top_wrap
#(parameter IP_WIDTH = 32, parameter IP_BITWIDTH = 5, parameter IP_DECCBITS = 7, parameter IP_NUMADDR = 8192, parameter IP_BITADDR = 13, 
parameter IP_NUMVBNK = 4,	parameter IP_BITVBNK = 2, parameter IP_BITPBNK = 3,
parameter IP_ENAECC = 0, parameter IP_ENAPAR = 0, parameter IP_SECCBITS = 4, parameter IP_SECCDWIDTH = 3, 
parameter FLOPECC = 0, parameter FLOPIN = 0, parameter FLOPOUT = 0, parameter FLOPCMD = 0, parameter FLOPMEM = 0,

parameter T1_WIDTH = 64, parameter T1_NUMVBNK = 1, parameter T1_BITVBNK = 1, parameter T1_DELAY = 2,
parameter T1_BITWSPF = 0, parameter T1_NUMWRDS = 1, parameter T1_BITWRDS = 1,  parameter T1_NUMSROW = 4096, parameter T1_BITSROW = 12, parameter T1_PHYWDTH = 128,
parameter T1_NUMVROW = 256, parameter T1_BITVROW = 8)
(clk, rst, ready, rw_read, rw_write, rw_addr, rw_din, rw_dout, rw_vld, rw_serr, rw_derr, rw_padr,
 t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_bwA, t1_doutA,
 t1_readB, t1_writeB, t1_addrB, t1_dinB, t1_bwB, t1_doutB);

// MEMOIR_TRANSLATE_OFF

  parameter WIDTH = IP_WIDTH;
  parameter BITWDTH = IP_BITWIDTH;
  parameter ENAPAR  = IP_ENAPAR;
  parameter ENAECC  = IP_ENAECC;
  parameter ECCWDTH = IP_DECCBITS;
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

  input [2-1:0]                        rw_read;
  input [2-1:0]                        rw_write;
  input [2*BITADDR-1:0]                rw_addr;
  input [2*WIDTH-1:0]                  rw_din;
  output [2-1:0]                       rw_vld;
  output [2*WIDTH-1:0]                 rw_dout;
  output [2-1:0]                       rw_serr;
  output [2-1:0]                       rw_derr;
  output [2*BITPADR-1:0]               rw_padr;

  output                               ready;
  input                                clk, rst;

  output [NUMVBNK-1:0]               t1_readA;
  output [NUMVBNK-1:0]               t1_writeA;
  output [NUMVBNK*BITSROW-1:0]       t1_addrA;
  output [NUMVBNK*PHYWDTH-1:0]         t1_dinA;
  output [NUMVBNK*PHYWDTH-1:0]         t1_bwA;
  input [NUMVBNK*PHYWDTH-1:0]          t1_doutA;

  output [NUMVBNK-1:0]               t1_readB;
  output [NUMVBNK-1:0]               t1_writeB;
  output [NUMVBNK*BITSROW-1:0]       t1_addrB;
  output [NUMVBNK*PHYWDTH-1:0]         t1_dinB;
  output [NUMVBNK*PHYWDTH-1:0]         t1_bwB;
  input [NUMVBNK*PHYWDTH-1:0]          t1_doutB;

  wire [2*NUMVBNK-1:0]               t1_readA_wire;
  wire [2*NUMVBNK-1:0]               t1_writeA_wire;
  wire [2*NUMVBNK*BITSROW-1:0]       t1_addrA_wire;
  wire [2*NUMVBNK*PHYWDTH-1:0]         t1_dinA_wire;  
  wire [2*NUMVBNK*PHYWDTH-1:0]         t1_bwA_wire;
  reg [2*NUMVBNK*PHYWDTH-1:0]          t1_doutA_wire;

/*
`ifdef AMP_REF
  wire [2-1:0]                         rw_vld_rtl;
  wire [2*WIDTH-1:0]                   rw_dout_rtl;
  wire [2-1:0]                         rw_serr_rtl;
  wire [2-1:0]                         rw_derr_rtl;
  wire [2*BITPADR-1:0]                 rw_padr_rtl;

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
  
  algo_mrnrwpw_ref #(
    .WIDTH(WIDTH), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .NUMRDPT(0), .NUMRWPT(2), .NUMWRPT(0),
    .NUMVROW(NUMVROW), .BITVROW(BITVROW), .NUMVBNK(NUMVBNK), .BITVBNK(BITVBNK),
    .NUMSROW(NUMSROW), .BITSROW(BITSROW), .NUMWRDS(NUMWRDS), .BITWRDS(BITWRDS), .BITPADR(BITPADR),
    .MEM_DELAY(T1_DELAY+FLOPIN+FLOPCMD+FLOPMEM+FLOPOUT)) algo_ref (
       .rd_read(), .rd_addr(), .rd_vld(), .rd_dout(), .rd_serr(), .rd_derr(), .rd_padr(),
       .rw_read(rw_read), .rw_write(rw_write), .rw_addr(rw_addr), .rw_din(rw_din), .rw_vld(rw_vld), .rw_dout(rw_dout), .rw_serr(rw_serr), .rw_derr(rw_derr), .rw_padr(rw_padr),
       .wr_write(), .wr_addr(), .wr_din(),
       .clk(clk), .ready(), .rst(rst));
`endif
*/

reg H2O_AMC2RWB40_001_00;
always @(posedge clk)
  H2O_AMC2RWB40_001_00 <= rst;
wire rst_int = H2O_AMC2RWB40_001_00 && rst;

  
  algo_2rw_base_top #(.WIDTH(WIDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ECCWDTH(ECCWDTH),
					  .BITWDTH(BITWDTH),
					  .NUMADDR(NUMADDR),
					  .BITADDR(BITADDR),
					  .NUMVROW(NUMVROW),
					  .BITVROW(BITVROW),
					  .NUMVBNK(NUMVBNK),
					  .BITVBNK(BITVBNK),
					  .NUMWRDS(NUMWRDS),   .BITWRDS(BITWRDS),   .NUMSROW(NUMSROW),   .BITSROW(BITSROW), .PHYWDTH(PHYWDTH), 
					  .SRAM_DELAY(SRAM_DELAY), .FLOPIN(FLOPIN),  .FLOPMEM(FLOPMEM),   .FLOPOUT(FLOPOUT))
				algo_top
					  (.clk(clk), .rst(rst_int), .ready(ready),
                       .read(rw_read), .write(rw_write), .addr(rw_addr), .din(rw_din),
/*
`ifdef AMP_REF
                       .rd_vld(rw_vld_rtl), .rd_dout(rw_dout_rtl), .rd_serr(rw_serr_rtl), .rd_derr(rw_serr_rtl), .rd_padr(rw_padr_rtl),
`else
*/
                       .rd_vld(rw_vld), .rd_dout(rw_dout), .rd_serr(rw_serr), .rd_derr(rw_derr), .rd_padr(rw_padr),
/*
`endif
*/
                           .t1_readA(t1_readA_wire), .t1_writeA(t1_writeA_wire), .t1_addrA(t1_addrA_wire),
                                           .t1_dinA(t1_dinA_wire), .t1_bwA(t1_bwA_wire), .t1_doutA(t1_doutA_wire));

  reg [NUMVBNK-1:0]               t1_readA;
  reg [NUMVBNK-1:0]               t1_writeA;
  reg [NUMVBNK*BITSROW-1:0]       t1_addrA;
  reg [NUMVBNK*PHYWDTH-1:0]         t1_dinA;  
  reg [NUMVBNK*PHYWDTH-1:0]         t1_bwA;
  reg [BITSROW-1:0]       t1_addrA_tmp [0:NUMVBNK-1];
  reg [PHYWDTH-1:0]         t1_dinA_tmp [0:NUMVBNK-1];  
  reg [PHYWDTH-1:0]         t1_bwA_tmp [0:NUMVBNK-1];
  reg [PHYWDTH-1:0]         t1_doutA_tmp [0:NUMVBNK-1];

  reg [NUMVBNK-1:0]               t1_readB;
  reg [NUMVBNK-1:0]               t1_writeB;
  reg [NUMVBNK*BITSROW-1:0]       t1_addrB;
  reg [NUMVBNK*PHYWDTH-1:0]         t1_dinB;  
  reg [NUMVBNK*PHYWDTH-1:0]         t1_bwB;
  reg [BITSROW-1:0]       t1_addrB_tmp [0:NUMVBNK-1];
  reg [PHYWDTH-1:0]         t1_dinB_tmp [0:NUMVBNK-1];  
  reg [PHYWDTH-1:0]         t1_bwB_tmp [0:NUMVBNK-1];
  reg [PHYWDTH-1:0]         t1_doutB_tmp [0:NUMVBNK-1];
  integer t1p_int, t1b_int;
  always_comb begin
    t1_addrA = 0;
    t1_dinA = 0;    
	t1_bwA = 0;
    t1_addrB = 0;
    t1_dinB = 0;    
	t1_bwB = 0;
    t1_doutA_wire = 0;
    for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1) begin
      t1_readA[t1b_int] = t1_readA_wire >> (2*t1b_int+0);
      t1_writeA[t1b_int] = t1_writeA_wire >> (2*t1b_int+0);
      t1_addrA_tmp[t1b_int] = t1_addrA_wire >> ((2*t1b_int+0)*BITSROW);
      t1_dinA_tmp[t1b_int] = t1_dinA_wire >> ((2*t1b_int+0)*PHYWDTH);      
	  t1_bwA_tmp[t1b_int] = t1_bwA_wire >> ((2*t1b_int+0)*PHYWDTH);
      t1_doutA_tmp[t1b_int] = t1_doutA >> (t1b_int*PHYWDTH);
      t1_readB[t1b_int] = t1_readA_wire >> (2*t1b_int+1);
      t1_writeB[t1b_int] = t1_writeA_wire >> (2*t1b_int+1);
      t1_addrB_tmp[t1b_int] = t1_addrA_wire >> ((2*t1b_int+1)*BITSROW);
      t1_dinB_tmp[t1b_int] = t1_dinA_wire >> ((2*t1b_int+1)*PHYWDTH);      
	  t1_bwB_tmp[t1b_int] = t1_bwA_wire >> ((2*t1b_int+1)*PHYWDTH);
      t1_doutB_tmp[t1b_int] = t1_doutB >> (t1b_int*PHYWDTH);
      t1_addrA = t1_addrA | (t1_addrA_tmp[t1b_int] << (t1b_int*BITSROW));
      t1_dinA = t1_dinA | (t1_dinA_tmp[t1b_int] << (t1b_int*PHYWDTH));      
	  t1_bwA = t1_bwA | (t1_bwA_tmp[t1b_int] << (t1b_int*PHYWDTH));
      t1_addrB = t1_addrB | (t1_addrB_tmp[t1b_int] << (t1b_int*BITSROW));
      t1_dinB = t1_dinB | (t1_dinB_tmp[t1b_int] << (t1b_int*PHYWDTH));      
	  t1_bwB = t1_bwB | (t1_bwB_tmp[t1b_int] << (t1b_int*PHYWDTH));
      t1_doutA_wire = t1_doutA_wire | ({t1_doutB_tmp[t1b_int],t1_doutA_tmp[t1b_int]} << (2*t1b_int*PHYWDTH));
    end
  end

// MEMOIR_TRANSLATE_ON

endmodule    //algo_2rw_b40_top_wrap
