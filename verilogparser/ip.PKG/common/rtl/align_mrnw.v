module align_mrnw (write, wr_adr, din, read, rd_adr, rd_dout, rd_serr, rd_padr,
	           mem_write, mem_wr_adr, mem_bw, mem_din, mem_read, mem_rd_adr, mem_rd_dout,
                   clk, rst);

  parameter WIDTH = 32;
  parameter PARITY = 1;
  parameter NUMRDPT = 2;
  parameter NUMWRPT = 2;
  parameter NUMADDR = 1024;
  parameter BITADDR = 10;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter BITPADR = 10;
  parameter SRAM_DELAY = 2;
  parameter FLOPMEM = 0;

  parameter MEMWDTH = WIDTH+PARITY;

  input [NUMWRPT-1:0] write;
  input [NUMWRPT*BITADDR-1:0] wr_adr;
  input [NUMWRPT*WIDTH-1:0] din;

  input [NUMRDPT-1:0] read;
  input [NUMRDPT*BITADDR-1:0] rd_adr;
  output [NUMRDPT*WIDTH-1:0] rd_dout;
  output [NUMRDPT-1:0] rd_serr;
  output [NUMRDPT*BITPADR-1:0] rd_padr;

  output [NUMWRPT-1:0] mem_write;
  output [NUMWRPT*BITSROW-1:0] mem_wr_adr;
  output [NUMWRPT*NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [NUMWRPT*NUMWRDS*MEMWDTH-1:0] mem_din;
  output [NUMRDPT-1:0] mem_read;
  output [NUMRDPT*BITSROW-1:0] mem_rd_adr;
  input [NUMRDPT*NUMWRDS*MEMWDTH-1:0] mem_rd_dout;

  input clk;
  input rst;

  wire [BITWRDS-1:0] wr_wadr [0:NUMWRPT-1];
  wire [BITSROW-1:0] wr_radr [0:NUMWRPT-1];
  wire [MEMWDTH-1:0] din_tmp [0:NUMWRPT-1];
  wire [BITWRDS-1:0] rd_wadr [0:NUMRDPT-1];
  wire [BITSROW-1:0] rd_radr [0:NUMRDPT-1];
  genvar np2_var;
  generate if (BITWRDS>0) begin: np2_loop
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      wire [BITADDR-1:0] wr_adr_wire = wr_adr >> (np2_var*BITADDR);
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                 .NUMVROW (NUMSROW), .BITVROW (BITSROW))
        wr_adr_inst (.vbadr(wr_wadr[np2_var]), .vradr(wr_radr[np2_var]), .vaddr(wr_adr_wire));

      wire [WIDTH-1:0] din_wire_np2 = din >> (np2_var*WIDTH);
      assign din_tmp[np2_var] = {(PARITY && ^din_wire_np2),din_wire_np2};
    end
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (np2_var*BITADDR);
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                 .NUMVROW (NUMSROW), .BITVROW (BITSROW))
        rd_adr_inst (.vbadr(rd_wadr[np2_var]), .vradr(rd_radr[np2_var]), .vaddr(rd_adr_wire));
    end
  end else begin: no_np2_loop
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign wr_wadr[np2_var] = 0;
      assign wr_radr[np2_var] = wr_adr >> (np2_var*BITADDR);

      wire [WIDTH-1:0] din_wire_no_np2 = din >> (np2_var*WIDTH);
      assign din_tmp[np2_var] = {(PARITY && ^din_wire_no_np2),din_wire_no_np2};
    end
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: rd_loop
      assign rd_wadr[np2_var] = 0;
      assign rd_radr[np2_var] = rd_adr >> (np2_var*BITADDR);
    end
  end
  endgenerate

  wire [BITWRDS-1:0] wr_wadr_0 = wr_wadr[0];
  wire [BITWRDS-1:0] wr_wadr_1 = wr_wadr[1];
  wire [BITSROW-1:0] wr_radr_0 = wr_radr[0];
  wire [BITSROW-1:0] wr_radr_1 = wr_radr[1];

  reg mem_write_wire [0:NUMWRPT-1];
  reg [BITSROW-1:0] mem_wr_adr_wire [0:NUMWRPT-1];
  reg [NUMWRDS*WIDTH-1:0] mem_bw_wire [0:NUMWRPT-1];
  reg [NUMWRDS*WIDTH-1:0] mem_din_wire [0:NUMWRPT-1];
  integer mwr_int, xwr_int;
  always_comb
    for (mwr_int=0; mwr_int<NUMWRPT; mwr_int=mwr_int+1) begin
      mem_write_wire[mwr_int] = 1'b0;
      mem_wr_adr_wire[mwr_int] = 0;
      mem_bw_wire[mwr_int] = 0;
      mem_din_wire[mwr_int] = 0;
      if (write[mwr_int]) begin
        mem_write_wire[mwr_int] = 1'b1;
        mem_wr_adr_wire[mwr_int] = wr_radr[mwr_int];
        mem_bw_wire[mwr_int] = {MEMWDTH{1'b1}} << (wr_wadr[mwr_int]*MEMWDTH);
        mem_din_wire[mwr_int] = din_tmp[mwr_int] << (wr_wadr[mwr_int]*MEMWDTH);
        for (xwr_int=0; xwr_int<mwr_int; xwr_int=xwr_int+1)
          if (mem_write_wire[xwr_int] && mem_write_wire[mwr_int] && (mem_wr_adr_wire[xwr_int] == mem_wr_adr_wire[mwr_int])) begin
            mem_write_wire[xwr_int] = 1'b0;
            mem_din_wire[mwr_int] = (mem_din_wire[xwr_int] & ~mem_bw_wire[mwr_int]) | mem_din_wire[mwr_int];
            mem_bw_wire[mwr_int] = mem_bw_wire[xwr_int] | mem_bw_wire[mwr_int];
          end 
      end
    end

  reg [NUMWRPT-1:0] mem_write;
  reg [NUMWRPT*BITSROW-1:0] mem_wr_adr;
  reg [NUMWRPT*NUMWRDS*WIDTH-1:0] mem_bw;
  reg [NUMWRPT*NUMWRDS*WIDTH-1:0] mem_din;
  integer mem_int;
  always_comb begin
    mem_write = 0;
    mem_wr_adr = 0;
    mem_bw = 0;
    mem_din = 0;
    for (mem_int=0; mem_int<NUMWRPT; mem_int=mem_int+1) begin
      mem_write = mem_write | (mem_write_wire[mem_int] << mem_int);
      mem_wr_adr = mem_wr_adr | (mem_wr_adr_wire[mem_int] << (mem_int*BITSROW));
      mem_bw = mem_bw | (mem_bw_wire[mem_int] << (mem_int*NUMWRDS*WIDTH));
      mem_din = mem_din | (mem_din_wire[mem_int] << (mem_int*NUMWRDS*WIDTH));
    end
  end

  wire [NUMRDPT*NUMWRDS*MEMWDTH-1:0] mem_rd_dout_tmp;
  generate if (FLOPMEM) begin: flpm_loop
    reg [NUMRDPT*NUMWRDS*MEMWDTH-1:0] mem_rd_dout_reg;
    always @(posedge clk)
      mem_rd_dout_reg <= mem_rd_dout;
    assign mem_rd_dout_tmp = mem_rd_dout_reg;
  end else begin: noflpm_loop
    assign mem_rd_dout_tmp = mem_rd_dout;
  end
  endgenerate

  reg [NUMRDPT-1:0] mem_read;
  reg [NUMRDPT*BITSROW-1:0] mem_rd_adr;
  reg [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_wire [0:NUMRDPT-1];
  integer mrd_int;
  always_comb begin
    mem_read = 0;
    mem_rd_adr = 0;
    for (mrd_int=0; mrd_int<NUMRDPT; mrd_int=mrd_int+1) begin
      mem_read = mem_read | (read[mrd_int] << mrd_int);
      mem_rd_adr = mem_rd_adr | (rd_radr[mrd_int] << (mrd_int*BITSROW));
      mem_rd_dout_wire[mrd_int] = mem_rd_dout_tmp >> (mrd_int*NUMWRDS*MEMWDTH);
    end
  end

  reg [BITWRDS-1:0] rd_wadr_reg [0:NUMRDPT-1][0:SRAM_DELAY+FLOPMEM-1];
  reg [BITSROW-1:0] rd_radr_reg [0:NUMRDPT-1][0:SRAM_DELAY+FLOPMEM-1];
  integer rd_int, rpt_int;
  always @(posedge clk)
    for (rpt_int=0; rpt_int<NUMRDPT; rpt_int=rpt_int+1)
      for (rd_int=SRAM_DELAY+FLOPMEM-1; rd_int>=0; rd_int=rd_int-1)
        if (rd_int>0) begin
          rd_wadr_reg[rpt_int][rd_int] <= rd_wadr_reg[rpt_int][rd_int-1];
          rd_radr_reg[rpt_int][rd_int] <= rd_radr_reg[rpt_int][rd_int-1];
        end else begin
          rd_wadr_reg[rpt_int][rd_int] <= rd_wadr[rpt_int];
	  rd_radr_reg[rpt_int][rd_int] <= rd_radr[rpt_int];
        end

  reg               dout_bit_err [0:NUMRDPT-1];
  reg [15:0]        dout_bit_pos [0:NUMRDPT-1];
  reg [MEMWDTH-1:0] dout_bit_mask [0:NUMRDPT-1];
  reg               dout_serr_mask [0:NUMRDPT-1];
  integer err_int;
  always_comb
    for (err_int=0; err_int<NUMRDPT; err_int=err_int+1) begin
      dout_bit_err[err_int] = 0;
      dout_bit_pos[err_int] = 0;
      dout_bit_mask[err_int] = dout_bit_err[err_int] << dout_bit_pos[err_int];
      dout_serr_mask[err_int] = |dout_bit_mask[err_int];
    end

  reg [MEMWDTH-1:0] rd_dout_tmp [0:NUMRDPT-1];
  reg [WIDTH-1:0] rd_dout_wire [0:NUMRDPT-1];
  reg rd_serr_wire [0:NUMRDPT-1];
  reg [BITPADR-1:0] rd_padr_wire [0:NUMRDPT-1];
  integer rtmp_int;
  always_comb
    for (rtmp_int=0; rtmp_int<NUMRDPT; rtmp_int=rtmp_int+1) begin
      rd_dout_tmp[rtmp_int] = mem_rd_dout_wire[rtmp_int] >> (rd_wadr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1]*MEMWDTH);
      rd_dout_wire[rtmp_int] = rd_dout_tmp[rtmp_int] ^ dout_bit_mask[rtmp_int];
      rd_serr_wire[rtmp_int] = PARITY ? ^(rd_dout_wire[rtmp_int] ^ dout_bit_mask[rtmp_int]) : 1'b0;
      rd_padr_wire[rtmp_int] = (NUMWRDS>1) ? {rd_wadr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1],rd_radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1]} :
                                             {rd_radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1]};
    end

  reg [NUMRDPT*WIDTH-1:0] rd_dout;
  reg [NUMRDPT-1:0] rd_serr;
  reg [NUMRDPT*BITPADR-1:0] rd_padr;
  integer rdo_int;
  always_comb begin
    rd_dout = 0;
    rd_serr = 0;
    rd_padr = 0;
    for (rdo_int=0; rdo_int<NUMRDPT; rdo_int=rdo_int+1) begin
      rd_dout = rd_dout | (rd_dout_wire[rdo_int] << (rdo_int*WIDTH));
      rd_serr = rd_serr | (rd_serr_wire[rdo_int] << rdo_int);
      rd_padr = rd_padr | (rd_padr_wire[rdo_int] << (rdo_int*BITPADR));
    end
  end

endmodule
