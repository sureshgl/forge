module align_bw_dwsn (read, write, addr, bw, din, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	              mem_read, mem_write, mem_addr, mem_bw, mem_dwsn, mem_din, mem_dout, mem_serr, clk, rst);

  parameter WIDTH = 32;
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
  parameter FLOPGEN = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  input read;
  input write;
  input [BITADDR-1:0] addr;
  input [WIDTH-1:0] bw;
  input [WIDTH-1:0] din;
  output [WIDTH-1:0] rd_dout;
  output             rd_fwrd;
  output             rd_serr;
  output             rd_derr;
  output [BITPADR-1:0] rd_padr;

  output mem_read;
  output mem_write;
  output [BITSROW-1:0] mem_addr;
  output [NUMWRDS*WIDTH-1:0] mem_bw;
  output [BITDWSN-1:0] mem_dwsn;
  output [NUMWRDS*WIDTH-1:0] mem_din;
  input [NUMWRDS*WIDTH-1:0] mem_dout;
  input [NUMWRDS-1:0] mem_serr;

  input clk;
  input rst;

  wire write_wire;
  wire [BITADDR-1:0] wr_adr_wire;
  wire [WIDTH-1:0] bw_wire;
  wire [WIDTH-1:0] din_wire;
  wire read_wire;
  wire [BITADDR-1:0] rd_adr_wire;
  generate if (FLOPGEN) begin: flpg_loop
    reg write_reg;
    reg [BITADDR-1:0] addr_reg;
    reg [WIDTH-1:0] bw_reg;
    reg [WIDTH-1:0] din_reg;
    always @(posedge clk)
      if (rst)
        write_reg <= 1'b0;
      else if (write) begin
        write_reg <= 1'b1;
        addr_reg <= addr;
        bw_reg <= bw;
        din_reg <= din;
      end else if (write_reg && !read)
        write_reg <= 1'b0;

    assign write_wire = write_reg;
    assign wr_adr_wire = addr_reg;
    assign bw_wire = bw_reg;
    assign din_wire = din_reg;
    assign read_wire = read;
    assign rd_adr_wire = addr;
  end else begin: noflpi_loop
    assign write_wire = write;
    assign wr_adr_wire = addr;
    assign bw_wire = bw;
    assign din_wire = din;
    assign read_wire = read;
    assign rd_adr_wire = addr;
  end
  endgenerate

  wire [BITWRDS-1:0] wr_wadr;
  wire [BITSROW-1:0] wr_radr;
  wire [BITWRDS-1:0] rd_wadr;
  wire [BITSROW-1:0] rd_radr;
  generate if (BITWRDS>0) begin: np2_loop
    np2_addr #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
      .NUMVROW (NUMSROW), .BITVROW (BITSROW))
      wr_adr_inst (.vbadr(wr_wadr), .vradr(wr_radr), .vaddr(wr_adr_wire));
    np2_addr #(
      .NUMADDR (NUMADDR), .BITADDR (BITADDR),
      .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
      .NUMVROW (NUMSROW), .BITVROW (BITSROW))
      rd_adr_inst (.vbadr(rd_wadr), .vradr(rd_radr), .vaddr(rd_adr_wire));
  end else begin: no_np2_loop
    assign wr_wadr = 0;
    assign wr_radr = wr_adr_wire;
    assign rd_wadr = 0;
    assign rd_radr = rd_adr_wire;
  end
  endgenerate

  wire mem_read_tmp = read_wire;
  wire mem_write_tmp = write_wire && !read_wire;
  wire [BITSROW-1:0] mem_addr_tmp = read_wire ? rd_radr : wr_radr;
  wire [NUMWRDS*WIDTH-1:0] mem_bw_tmp = bw_wire << (wr_wadr*WIDTH);
  wire [NUMWRDS*WIDTH-1:0] mem_din_tmp = din_wire << (wr_wadr*WIDTH);

  reg [BITDWSN-1:0] mem_dwsn_tmp;
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
    mem_dwsn_tmp = ~0;
    for (dwsn_int=0; dwsn_int<BITDWSN; dwsn_int=dwsn_int+1) 
      if (dwsn_int<16) begin
             if ((dwsn_int==0)  && NUMDWS0)   mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS0)  & (mem_bw_tmp >> 0)));
        else if ((dwsn_int==1)  && NUMDWS1)   mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS1)  & (mem_bw_tmp >> SDWS0)));
        else if ((dwsn_int==2)  && NUMDWS2)   mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS2)  & (mem_bw_tmp >> SDWS1)));
        else if ((dwsn_int==3)  && NUMDWS3)   mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS3)  & (mem_bw_tmp >> SDWS2)));
        else if ((dwsn_int==4)  && NUMDWS4)   mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS4)  & (mem_bw_tmp >> SDWS3)));
        else if ((dwsn_int==5)  && NUMDWS5)   mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS5)  & (mem_bw_tmp >> SDWS4)));
        else if ((dwsn_int==6)  && NUMDWS6)   mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS6)  & (mem_bw_tmp >> SDWS5)));
        else if ((dwsn_int==7)  && NUMDWS7)   mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS7)  & (mem_bw_tmp >> SDWS6)));
        else if ((dwsn_int==8)  && NUMDWS8)   mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS8)  & (mem_bw_tmp >> SDWS7)));
        else if ((dwsn_int==9)  && NUMDWS9)   mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS9)  & (mem_bw_tmp >> SDWS8)));
        else if ((dwsn_int==10) && NUMDWS10)  mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS10) & (mem_bw_tmp >> SDWS9)));
        else if ((dwsn_int==11) && NUMDWS11)  mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS11) & (mem_bw_tmp >> SDWS10)));
        else if ((dwsn_int==12) && NUMDWS12)  mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS12) & (mem_bw_tmp >> SDWS11)));
        else if ((dwsn_int==13) && NUMDWS13)  mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS13) & (mem_bw_tmp >> SDWS12)));
        else if ((dwsn_int==14) && NUMDWS14)  mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS14) & (mem_bw_tmp >> SDWS13)));
        else if ((dwsn_int==15) && NUMDWS15)  mem_dwsn_tmp[dwsn_int]  = !(|(~(~0 << NUMDWS15) & (mem_bw_tmp >> SDWS14)));
      end else
        mem_dwsn_tmp[dwsn_int] = 0;
  end

  generate if (FLOPCMD) begin: flpc_loop
    reg mem_read_reg;
    reg mem_write_reg;
    reg [BITSROW-1:0] mem_addr_reg;
    reg [NUMWRDS*WIDTH-1:0] mem_bw_reg;
    reg [NUMWRDS*WIDTH-1:0] mem_din_reg;
    reg [BITDWSN-1:0] mem_dwsn_reg;
    always @(posedge clk) begin
      mem_read_reg <= mem_read_tmp;
      mem_write_reg <= mem_write_tmp;
      mem_addr_reg <= mem_addr_tmp;
      mem_bw_reg <= mem_bw_tmp;
      mem_din_reg <= mem_din_tmp;
      mem_dwsn_reg <= mem_dwsn_tmp;
    end

    assign mem_read = mem_read_reg;
    assign mem_write = mem_write_reg;
    assign mem_addr = mem_addr_reg;
    assign mem_bw = mem_bw_reg;
    assign mem_din = mem_din_reg;
    assign mem_dwsn = mem_dwsn_reg;
  end else begin: nflpc_loop
    assign mem_read = mem_read_tmp;
    assign mem_write = mem_write_tmp;
    assign mem_addr = mem_addr_tmp;
    assign mem_bw = mem_bw_tmp;
    assign mem_din = mem_din_tmp;
    assign mem_dwsn = mem_dwsn_tmp;
  end
  endgenerate

  wire forward_read = FLOPGEN && read_wire && write_wire && (rd_adr_wire == wr_adr_wire);

  reg [BITWRDS-1:0] rd_wadr_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg [BITSROW-1:0] rd_radr_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg [WIDTH-1:0]   rd_fwd_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg [WIDTH-1:0]   rd_dat_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg               rd_vld_reg [0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  integer rd_int;
  always @(posedge clk)
    for (rd_int=0; rd_int<SRAM_DELAY+FLOPCMD+FLOPMEM; rd_int=rd_int+1)
      if (rd_int>0) begin
	rd_wadr_reg[rd_int] <= rd_wadr_reg[rd_int-1];
        rd_radr_reg[rd_int] <= rd_radr_reg[rd_int-1];
        rd_fwd_reg[rd_int] <= rd_fwd_reg[rd_int-1];
        rd_dat_reg[rd_int] <= rd_dat_reg[rd_int-1];
        rd_vld_reg[rd_int] <= rd_vld_reg[rd_int-1];
      end else begin
	rd_wadr_reg[rd_int] <= rd_wadr;
	rd_radr_reg[rd_int] <= rd_radr;
        rd_fwd_reg[rd_int] <= forward_read ? bw_wire : 0;
        rd_dat_reg[rd_int] <= din_wire;
        rd_vld_reg[rd_int] <= read_wire;
      end

  wire [NUMWRDS*WIDTH-1:0] mem_dout_tmp;
  wire [NUMWRDS-1:0] mem_serr_tmp;
  generate if (FLOPMEM) begin: flpm_loop
    reg [NUMWRDS*WIDTH-1:0] mem_dout_reg;
    reg [NUMWRDS-1:0] mem_serr_reg;
    always @(posedge clk) begin
      mem_dout_reg <= mem_dout;
      mem_serr_reg <= mem_serr;
    end
    assign mem_dout_tmp = mem_dout_reg; 
    assign mem_serr_tmp = mem_serr_reg; 
  end else begin: noflpm_loop
    assign mem_dout_tmp = mem_dout;
    assign mem_serr_tmp = mem_serr;
  end
  endgenerate

  wire [WIDTH-1:0] rd_dout_wire = mem_dout_tmp >> (rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]*WIDTH);
  wire rd_serr_wire = mem_serr_tmp >> rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  wire [WIDTH-1:0] rd_dout_tmp;
  wire rd_fwrd_tmp;
  wire rd_serr_tmp;
  wire rd_derr_tmp;
  wire [BITPADR-1:0] rd_padr_tmp;
  assign rd_dout_tmp = (rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] & rd_dat_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]) |
                       (~rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1] & rd_dout_wire);
  assign rd_fwrd_tmp = &rd_fwd_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  assign rd_serr_tmp = 1'b0;
  assign rd_derr_tmp = 1'b0;
  assign rd_padr_tmp = (NUMWRDS>1) ? {rd_wadr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1]} :
                                     rd_radr_reg[SRAM_DELAY+FLOPCMD+FLOPMEM-1];

  generate if (FLOPOUT) begin: flpo_loop
    reg [WIDTH-1:0] rd_dout_reg;
    reg rd_fwrd_reg;
    reg rd_serr_reg;
    reg rd_derr_reg;
    reg [BITPADR-1:0] rd_padr_reg;
    always @(posedge clk) begin
      rd_dout_reg <= rd_dout_tmp;
      rd_fwrd_reg <= rd_fwrd_tmp;
      rd_serr_reg <= rd_serr_tmp;
      rd_derr_reg <= rd_derr_tmp;
      rd_padr_reg <= rd_padr_tmp;
    end
    assign rd_dout = rd_dout_reg;
    assign rd_fwrd = rd_fwrd_reg;
    assign rd_serr = rd_serr_reg;
    assign rd_derr = rd_derr_reg;
    assign rd_padr = rd_padr_reg;
  end else begin: noflpo_loop
    assign rd_dout = rd_dout_tmp;
    assign rd_fwrd = rd_fwrd_tmp;
    assign rd_serr = rd_serr_tmp;
    assign rd_derr = rd_derr_tmp;
    assign rd_padr = rd_padr_tmp;
  end
  endgenerate

endmodule
