module align_2rw (write, read, addr, din, dout, serr, padr,
	          mem_write, mem_read, mem_addr, mem_bw, mem_din, mem_dout,
                  clk, rst);

  parameter WIDTH = 32;
  parameter PARITY = 1;
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

  input [2-1:0] write;
  input [2-1:0] read;
  input [2*BITADDR-1:0] addr;
  input [2*WIDTH-1:0] din;
  output [2*WIDTH-1:0] dout;
  output [2-1:0] serr;
  output [2*BITPADR-1:0] padr;

  output [2-1:0] mem_write;
  output [2-1:0] mem_read;
  output [2*BITSROW-1:0] mem_addr;
  output [2*NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [2*NUMWRDS*MEMWDTH-1:0] mem_din;
  input [2*NUMWRDS*MEMWDTH-1:0] mem_dout;

  input clk;
  input rst;

  wire [BITWRDS-1:0] wadr [0:2-1];
  wire [BITSROW-1:0] radr [0:2-1];
  wire [MEMWDTH-1:0] din_tmp [0:2-1];
  genvar np2_var;
  generate for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: adr_loop
    wire [BITADDR-1:0] addr_wire = addr >> (np2_var*BITADDR);
    wire [WIDTH-1:0] din_wire = din >> (np2_var*WIDTH);

    assign din_tmp[np2_var] = {(PARITY && ^din_wire),din_wire};

    if (BITWRDS>0) begin: np2_loop
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                 .NUMVROW (NUMSROW), .BITVROW (BITSROW))
        np2_inst (.vbadr(wadr[np2_var]), .vradr(radr[np2_var]), .vaddr(addr_wire));
    end else begin: no_np2_loop
      assign wadr[np2_var] = 0;
      assign radr[np2_var] = addr_wire;
    end
  end
  endgenerate

  reg write_vld_reg;
  reg [BITSROW-1:0] write_adr_reg;
  reg [NUMWRDS-1:0] write_msk_reg;
  reg [NUMWRDS*MEMWDTH-1:0] write_dat_reg;
  always @(posedge clk)
    if (rst)
      write_vld_reg <= 1'b0;
    else if (write[0] && read[1] && (radr[0] == radr[1])) begin
      write_vld_reg <= 1'b1;
      write_adr_reg <= radr[0]; 
      if (write_vld_reg && (radr[0] == write_adr_reg)) begin
        write_msk_reg <= write_msk_reg | (1 << wadr[0]);
        write_dat_reg <= (write_dat_reg & ~({MEMWDTH{1'b1}} << (wadr[0]*MEMWDTH))) | (din_tmp[0] << (wadr[0]*MEMWDTH));
      end else begin
        write_msk_reg <= 1 << wadr[0];
        write_dat_reg <= din_tmp[0] << (wadr[0]*MEMWDTH);
      end
    end else if (write[1] && read[0] && (radr[1] == radr[0])) begin
      write_vld_reg <= 1'b1; write_adr_reg <= radr[1]; 
      if (write_vld_reg && (radr[1] == write_adr_reg)) begin
        write_msk_reg <= write_msk_reg | (1 << wadr[1]);
        write_dat_reg <= (write_dat_reg & ~({MEMWDTH{1'b1}} << (wadr[1]*MEMWDTH))) | (din_tmp[1] << (wadr[1]*MEMWDTH));
      end else begin
        write_msk_reg <= 1 << wadr[1];
        write_dat_reg <= din_tmp[1] << (wadr[1]*MEMWDTH);
      end
    end else if (write_vld_reg && write[0] && (radr[0] == write_adr_reg) && write[1] && (radr[1] == write_adr_reg)) begin
      write_vld_reg <= 1'b1;
      write_adr_reg <= radr[0]; 
      write_msk_reg <= write_msk_reg | (1 << wadr[0]) | (1 << wadr[1]);
      write_dat_reg <= (write_dat_reg & ~({MEMWDTH{1'b1}} << (wadr[0]*MEMWDTH)) & ~({MEMWDTH{1'b1}} << (wadr[1]*MEMWDTH))) |
                       (din_tmp[0] << (wadr[0]*MEMWDTH)) | (din_tmp[1] << (wadr[1]*MEMWDTH));
    end else if (write[0] && write_vld_reg && (radr[0] == write_adr_reg)) begin
      write_vld_reg <= 1'b1;
      write_adr_reg <= radr[0]; 
      write_msk_reg <= write_msk_reg | (1 << wadr[0]);
      write_dat_reg <= (write_dat_reg & ~({MEMWDTH{1'b1}} << (wadr[0]*MEMWDTH))) | (din_tmp[0] << (wadr[0]*MEMWDTH));
    end else if (write[1] && write_vld_reg && (radr[1] == write_adr_reg)) begin
      write_vld_reg <= 1'b1;
      write_adr_reg <= radr[1]; 
      write_msk_reg <= write_msk_reg | (1 << wadr[1]);
      write_dat_reg <= (write_dat_reg & ~({MEMWDTH{1'b1}} << (wadr[1]*MEMWDTH))) | (din_tmp[1] << (wadr[1]*MEMWDTH));
    end

  reg [NUMWRDS*MEMWDTH-1:0] write_msk_tmp;
  integer msk_int;
  always_comb begin
    write_msk_tmp = 0;
    for (msk_int=0; msk_int<NUMWRDS; msk_int=msk_int+1)
      write_msk_tmp = write_msk_tmp | ({MEMWDTH{write_msk_reg[msk_int]}} << (msk_int*MEMWDTH)); 
  end

  wire mem_write_wire [0:2-1];
  wire mem_read_wire [0:2-1];
  wire [BITSROW-1:0] mem_addr_wire [0:2-1];
  wire [NUMWRDS*MEMWDTH-1:0] mem_bw_wire [0:2-1];
  wire [NUMWRDS*MEMWDTH-1:0] mem_din_wire [0:2-1];
/*
  assign mem_read_wire[0] = read[0];
  assign mem_write_wire[0] = write[0] && !(read[1] && (radr[0] == radr[1]) && (!write_vld_reg || (write_adr_reg == radr[0])));
  assign mem_addr_wire[0] = read[0] ? radr[0] : (write[0] && read[1] && (radr[0] == radr[1])) ? write_adr_reg : radr[0];
  assign mem_bw_wire[0] = (write[0] && read[1] && (radr[0] == radr[1])) ? write_msk_tmp : {MEMWDTH{1'b1}} << (wadr[0]*MEMWDTH);
  assign mem_din_wire[0] = (write[0] && read[1] && (radr[0] == radr[1])) ? write_dat_reg : din_tmp[0] << (wadr[0]*MEMWDTH);

  assign mem_read_wire[1] = read[1];
  assign mem_write_wire[1] = write[1] && !(read[0] && (radr[1] == radr[0]) && (!write_vld_reg || (write_adr_reg == radr[1])));
  assign mem_addr_wire[1] = read[1] ? radr[1] : (write[1] && read[0] && (radr[1] == radr[0])) ? write_adr_reg : radr[1];
  assign mem_bw_wire[1] = (write[1] && read[0] && (radr[1] == radr[0])) ? write_msk_tmp : {MEMWDTH{1'b1}} << (wadr[1]*MEMWDTH);
  assign mem_din_wire[1] = (write[1] && read[0] && (radr[1] == radr[0])) ? write_dat_reg : din_tmp[1] << (wadr[1]*MEMWDTH);

  assign mem_read_wire[0] = read[0];
  assign mem_write_wire[0] = write[0] && !(write[1] && (radr[0] == radr[1]));
  assign mem_addr_wire[0] = radr[0];
  assign mem_bw_wire[0] = {MEMWDTH{1'b1}} << (wadr[0]*MEMWDTH);
  assign mem_din_wire[0] = din_tmp[0] << (wadr[0]*MEMWDTH);

  assign mem_read_wire[1] = read[1];
  assign mem_write_wire[1] = write[1];
  assign mem_addr_wire[1] = radr[1];
  assign mem_bw_wire[1] = ((write[0] && write[1] && (radr[0] == radr[1])) ? mem_bw_wire[0] : 0) | ({MEMWDTH{1'b1}} << (wadr[1]*MEMWDTH));
  assign mem_din_wire[1] = ((write[0] && write[1] && (radr[0] == radr[1])) ? mem_din_wire[0] : 0) | (din_tmp[1] << (wadr[1]*MEMWDTH));
*/
  assign mem_read_wire[0] = read[0];
  assign mem_write_wire[0] = write[0] && !(write[1] && (radr[0] == radr[1])) && !(read[1] && (radr[0] == radr[1]) && (!write_vld_reg || (write_adr_reg == radr[0])));
  assign mem_addr_wire[0] = read[0] ? radr[0] : (write[0] && read[1] && (radr[0] == radr[1])) ? write_adr_reg : radr[0];
  assign mem_bw_wire[0] = (write[0] && read[1] && (radr[0] == radr[1])) ? write_msk_tmp : {MEMWDTH{1'b1}} << (wadr[0]*MEMWDTH);
  assign mem_din_wire[0] = (write[0] && read[1] && (radr[0] == radr[1])) ? write_dat_reg : din_tmp[0] << (wadr[0]*MEMWDTH);

  assign mem_read_wire[1] = read[1];
  assign mem_write_wire[1] = write[1] && !(read[0] && (radr[1] == radr[0]) && (!write_vld_reg || (write_adr_reg == radr[1])));
  assign mem_addr_wire[1] = read[1] ? radr[1] : (write[1] && read[0] && (radr[1] == radr[0])) ? write_adr_reg : radr[1];
  assign mem_bw_wire[1] = (write[1] && read[0] && (radr[1] == radr[0])) ? write_msk_tmp :
                          ((write[0] && write[1] && (radr[0] == radr[1])) ? mem_bw_wire[0] : 0) | ({MEMWDTH{1'b1}} << (wadr[1]*MEMWDTH));
  assign mem_din_wire[1] = (write[1] && read[0] && (radr[1] == radr[0])) ? write_dat_reg :
                           ((write[0] && write[1] && (radr[0] == radr[1])) ? mem_din_wire[0] : 0) | (din_tmp[1] << (wadr[1]*MEMWDTH));

  wire [BITSROW-1:0] mem_addr_wire_0 = mem_addr_wire[0];
  wire [BITSROW-1:0] mem_addr_wire_1 = mem_addr_wire[1];

  reg [2-1:0] mem_write;
  reg [2-1:0] mem_read;
  reg [2*BITSROW-1:0] mem_addr;
  reg [2*NUMWRDS*MEMWDTH-1:0] mem_bw;
  reg [2*NUMWRDS*MEMWDTH-1:0] mem_din;
  integer mem_int;
  always_comb begin
    mem_write = 0;
    mem_read = 0;
    mem_addr = 0;
    mem_bw = 0;
    mem_din = 0;
    for (mem_int=0; mem_int<2; mem_int=mem_int+1) begin
      mem_write = mem_write | (mem_write_wire[mem_int] << mem_int);
      mem_read = mem_read | (mem_read_wire[mem_int] << mem_int);
      mem_addr = mem_addr | (mem_addr_wire[mem_int] << (mem_int*BITSROW));
      mem_bw = mem_bw | (mem_bw_wire[mem_int] << (mem_int*NUMWRDS*MEMWDTH));
      mem_din = mem_din | (mem_din_wire[mem_int] << (mem_int*NUMWRDS*MEMWDTH));
    end
  end

  reg [BITWRDS-1:0] wadr_reg [0:2-1][0:SRAM_DELAY+FLOPMEM-1];
  reg [BITSROW-1:0] radr_reg [0:2-1][0:SRAM_DELAY+FLOPMEM-1];
  reg               fwd_reg [0:2-1][0:SRAM_DELAY+FLOPMEM-1];
  reg [MEMWDTH-1:0] dat_reg [0:2-1][0:SRAM_DELAY+FLOPMEM-1];
  integer rdp_int, rdb_int;
  always @(posedge clk)
    for (rdp_int=0; rdp_int<2; rdp_int=rdp_int+1)
      for (rdb_int=SRAM_DELAY+FLOPMEM-1; rdb_int>=0; rdb_int=rdb_int-1)
        if (rdb_int>0) begin
          wadr_reg[rdp_int][rdb_int] <= wadr_reg[rdp_int][rdb_int-1];
          radr_reg[rdp_int][rdb_int] <= radr_reg[rdp_int][rdb_int-1];
          fwd_reg[rdp_int][rdb_int] <= fwd_reg[rdp_int][rdb_int-1];
          dat_reg[rdp_int][rdb_int] <= dat_reg[rdp_int][rdb_int-1];
        end else begin
          wadr_reg[rdp_int][rdb_int] <= wadr[rdp_int];
          radr_reg[rdp_int][rdb_int] <= radr[rdp_int];
          fwd_reg[rdp_int][rdb_int] <= read[rdp_int] && write_vld_reg && (radr[rdp_int] == write_adr_reg) && write_msk_reg[wadr[rdp_int]];
          dat_reg[rdp_int][rdb_int] <= write_dat_reg >> (wadr[rdp_int]*MEMWDTH);
        end

  wire [2*NUMWRDS*MEMWDTH-1:0] mem_dout_tmp;
  generate if (FLOPMEM) begin: flpm_loop
    reg [2*NUMWRDS*MEMWDTH-1:0] mem_dout_reg;
    always @(posedge clk)
      mem_dout_reg <= mem_dout;
    assign mem_dout_tmp = mem_dout_reg;
  end else begin: noflpm_loop
    assign mem_dout_tmp = mem_dout;
  end
  endgenerate

  reg               dout_bit_err [0:2-1];
  reg [15:0]        dout_bit_pos [0:2-1];
  reg [MEMWDTH-1:0] dout_bit_mask [0:2-1];
  reg               dout_serr_mask [0:2-1];
  integer err_int;
  always_comb
    for (err_int=0; err_int<2; err_int=err_int+1) begin
      dout_bit_err[err_int] = 0;
      dout_bit_pos[err_int] = 0;
      dout_bit_mask[err_int] = dout_bit_err[err_int] << dout_bit_pos[err_int];
      dout_serr_mask[err_int] = |dout_bit_mask[err_int];
    end

  reg [MEMWDTH-1:0] dout_tmp [0:2-1];
  reg [WIDTH-1:0] dout_wire [0:2-1];
  reg serr_wire [0:2-1];
  reg [BITPADR-1:0] padr_wire [0:2-1];
  integer dout_int;
  always_comb
    for (dout_int=0; dout_int<2; dout_int=dout_int+1) begin
      dout_tmp[dout_int] = mem_dout_tmp >> ((dout_int*NUMWRDS+wadr_reg[dout_int][SRAM_DELAY+FLOPMEM-1])*MEMWDTH);
      dout_wire[dout_int] = fwd_reg[dout_int][SRAM_DELAY+FLOPMEM-1] ? dat_reg[dout_int][SRAM_DELAY+FLOPMEM-1] : dout_tmp[dout_int] ^ dout_bit_mask[dout_int];
      serr_wire[dout_int] = PARITY ? (!fwd_reg[dout_int][SRAM_DELAY+FLOPMEM-1] && ^(dout_tmp[dout_int] ^ dout_bit_mask[dout_int])) : 1'b0;
      padr_wire[dout_int] = (NUMWRDS>1) ? {wadr_reg[dout_int][SRAM_DELAY+FLOPMEM-1],radr_reg[dout_int][SRAM_DELAY+FLOPMEM-1]} : {radr_reg[dout_int][SRAM_DELAY+FLOPMEM-1]};
    end

  reg [2*WIDTH-1:0] dout;
  reg [2-1:0] serr;
  reg [2*BITPADR-1:0] padr;
  integer out_int;
  always_comb begin
    dout = 0;
    serr = 0;
    padr = 0;
    for (out_int=0; out_int<2; out_int=out_int+1) begin
      dout = dout | (dout_wire[out_int] << (out_int*WIDTH));
      serr = serr | (serr_wire[out_int] << out_int);
      padr = padr | (padr_wire[out_int] << (out_int*BITPADR));
    end
  end

endmodule
