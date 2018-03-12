module align_dwsn (read, write, addr, din, dout, serr, padr,
	           mem_read, mem_write, mem_addr, mem_bw, mem_dwsn, mem_din, mem_dout, clk);

  parameter WIDTH = 32;
  parameter PARITY = 1;
  parameter NUMADDR = 1024;
  parameter BITADDR = 10;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter BITPADR = 10;
  parameter NUMDWS0 = 72;
  parameter NUMDWS1 = 72;
  parameter NUMDWS2 = 72;
  parameter NUMDWS3 = 72;
  parameter NUMDWS4 = 72;
  parameter NUMDWS5 = 72;
  parameter NUMDWS6 = 72;
  parameter NUMDWS7 = 72;
  parameter NUMDWS8 = 72;
  parameter NUMDWS9 = 72;
  parameter NUMDWS10 = 72;
  parameter NUMDWS11 = 72;
  parameter NUMDWS12 = 72;
  parameter NUMDWS13 = 72;
  parameter NUMDWS14 = 72;
  parameter NUMDWS15 = 72;
  parameter BITDWSN = 4;
  parameter SRAM_DELAY = 2;
  parameter FLOPMEM = 0;

  parameter MEMWDTH = WIDTH+PARITY;

  input read;
  input write;
  input [BITADDR-1:0] addr;
  input [WIDTH-1:0] din;
  output [WIDTH-1:0] dout;
  output             serr;
  output [BITPADR-1:0] padr;

  output mem_read;
  output mem_write;
  output [BITSROW-1:0] mem_addr;
  output [NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [BITDWSN-1:0] mem_dwsn;
  output [NUMWRDS*MEMWDTH-1:0] mem_din;
  input [NUMWRDS*MEMWDTH-1:0] mem_dout;

  input clk;

  wire [BITWRDS-1:0] wadr;
  wire [BITSROW-1:0] radr;
  generate if (BITWRDS>0) begin: np2_loop
    np2_addr #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
      .NUMVROW (NUMSROW), .BITVROW (BITSROW))
      np2_addr_inst (.vbadr(wadr), .vradr(radr), .vaddr(addr));
  end else begin: no_np2_loop
    assign wadr = 0;
    assign radr = addr;
  end
  endgenerate

  assign mem_read = read;
  assign mem_write = write;
  assign mem_addr = radr;
  assign mem_bw = {MEMWDTH{1'b1}} << (wadr*MEMWDTH);
  assign mem_din = {(PARITY && ^din),din} << (wadr*MEMWDTH);

  reg [BITDWSN-1:0] mem_dwsn;
  parameter SDWS0  = 0      + NUMDWS0;
  parameter SDWS1  = SDWS0  + NUMDWS1;
  parameter SDWS2  = SDWS1  + NUMDWS2;
  parameter SDWS3  = SDWS2  + NUMDWS3;
  parameter SDWS4  = SDWS3  + NUMDWS4;
  parameter SDWS5  = SDWS4  + NUMDWS5;
  parameter SDWS6  = SDWS5  + NUMDWS6;
  parameter SDWS7  = SDWS6  + NUMDWS7;
  parameter SDWS8  = SDWS7  + NUMDWS8;
  parameter SDWS9  = SDWS8  + NUMDWS9;
  parameter SDWS10 = SDWS9  + NUMDWS10;
  parameter SDWS11 = SDWS10 + NUMDWS11;
  parameter SDWS12 = SDWS11 + NUMDWS12;
  parameter SDWS13 = SDWS12 + NUMDWS13;
  parameter SDWS14 = SDWS13 + NUMDWS14;
  integer dwsn_int;
  always_comb begin
    mem_dwsn = ~0;
    for (dwsn_int=0; dwsn_int<BITDWSN; dwsn_int=dwsn_int+1) 
      if (dwsn_int<16) begin
             if ((dwsn_int==0)  && NUMDWS0)   mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS0)  & (mem_bw >> 0)));
        else if ((dwsn_int==1)  && NUMDWS1)   mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS1)  & (mem_bw >> SDWS0)));
        else if ((dwsn_int==2)  && NUMDWS2)   mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS2)  & (mem_bw >> SDWS1)));
        else if ((dwsn_int==3)  && NUMDWS3)   mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS3)  & (mem_bw >> SDWS2)));
        else if ((dwsn_int==4)  && NUMDWS4)   mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS4)  & (mem_bw >> SDWS3)));
        else if ((dwsn_int==5)  && NUMDWS5)   mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS5)  & (mem_bw >> SDWS4)));
        else if ((dwsn_int==6)  && NUMDWS6)   mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS6)  & (mem_bw >> SDWS5)));
        else if ((dwsn_int==7)  && NUMDWS7)   mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS7)  & (mem_bw >> SDWS6)));
        else if ((dwsn_int==8)  && NUMDWS8)   mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS8)  & (mem_bw >> SDWS7)));
        else if ((dwsn_int==9)  && NUMDWS9)   mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS9)  & (mem_bw >> SDWS8)));
        else if ((dwsn_int==10) && NUMDWS10)  mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS10) & (mem_bw >> SDWS9)));
        else if ((dwsn_int==11) && NUMDWS11)  mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS11) & (mem_bw >> SDWS10)));
        else if ((dwsn_int==12) && NUMDWS12)  mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS12) & (mem_bw >> SDWS11)));
        else if ((dwsn_int==13) && NUMDWS13)  mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS13) & (mem_bw >> SDWS12)));
        else if ((dwsn_int==14) && NUMDWS14)  mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS14) & (mem_bw >> SDWS13)));
        else if ((dwsn_int==15) && NUMDWS15)  mem_dwsn[dwsn_int]  = !(|(~(~0 << NUMDWS15) & (mem_bw >> SDWS14)));
      end else
        mem_dwsn[dwsn_int] = 0;
  end

  reg [BITWRDS-1:0] wadr_reg [0:SRAM_DELAY+FLOPMEM-1];
  reg [BITSROW-1:0] radr_reg [0:SRAM_DELAY+FLOPMEM-1];
  integer rd_int;
  always @(posedge clk)
    for (rd_int=SRAM_DELAY+FLOPMEM-1; rd_int>=0; rd_int=rd_int-1)
      if (rd_int>0) begin
	wadr_reg[rd_int] <= wadr_reg[rd_int-1];
        radr_reg[rd_int] <= radr_reg[rd_int-1];
      end else begin
	wadr_reg[rd_int] <= wadr;
	radr_reg[rd_int] <= radr;
      end

  wire [NUMWRDS*MEMWDTH-1:0] mem_dout_tmp;
  generate if (FLOPMEM) begin: flpm_loop
    reg [NUMWRDS*MEMWDTH-1:0] mem_dout_reg;
    always @(posedge clk)
      mem_dout_reg <= mem_dout;
    assign mem_dout_tmp = mem_dout_reg;
  end else begin: noflpm_loop
    assign mem_dout_tmp = mem_dout;
  end
  endgenerate

  wire               dout_bit_err = 0;
  wire [15:0]        dout_bit_pos = 0;
  wire [MEMWDTH-1:0] dout_bit_mask = dout_bit_err << dout_bit_pos;
  wire               dout_serr_mask = |dout_bit_mask;

  wire [MEMWDTH-1:0] dout_wire = mem_dout_tmp >> (wadr_reg[SRAM_DELAY+FLOPMEM-1]*MEMWDTH);
  assign dout = dout_wire ^ dout_bit_mask;
  assign serr = PARITY ? ^(dout_wire ^ dout_bit_mask) : 1'b0;
  assign padr = (NUMWRDS>1) ? {wadr_reg[SRAM_DELAY+FLOPMEM-1],radr_reg[SRAM_DELAY+FLOPMEM-1]} :
                              {radr_reg[SRAM_DELAY+FLOPMEM-1]};

endmodule
