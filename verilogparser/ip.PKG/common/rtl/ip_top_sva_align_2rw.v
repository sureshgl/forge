module ip_top_sva_2_align_2rw
  #(
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMSROW = 256,
parameter     BITSROW = 8)
(
  input clk,
  input rst,
  input [2-1:0] write,
  input [2-1:0] read,
  input [2*BITADDR-1:0] addr,
  input [2-1:0] mem_write,
  input [2-1:0] mem_read,
  input [2*BITSROW-1:0] mem_addr
);

genvar rw_var;
generate for (rw_var=0; rw_var<2; rw_var=rw_var+1) begin: rw_loop
  wire write_wire = write >> rw_var;
  wire read_wire = read >> rw_var;
  wire [BITADDR-1:0] addr_wire = addr >> (rw_var*BITADDR);

  assert_rw_check: assume property (@(posedge clk) disable iff (rst) !(write_wire && read_wire));
  assert_rw_range_check: assume property (@(posedge clk) disable iff (rst) (write_wire || read_wire) |-> (addr_wire < NUMADDR));
end
endgenerate

genvar mem_var;
generate for (mem_var=0; mem_var<2; mem_var=mem_var+1) begin: mem_loop
  wire mem_write_wire = mem_write >> mem_var;
  wire mem_read_wire = mem_read >> mem_var;
  wire [BITSROW-1:0] mem_addr_wire = mem_addr >> (mem_var*BITSROW);

  assert_mem_rw_check: assume property (@(posedge clk) disable iff (rst) !(mem_write_wire && mem_read_wire));
  assert_mem_rw_range_check: assume property (@(posedge clk) disable iff (rst) (mem_write_wire || mem_read_wire) |-> (mem_addr_wire < NUMSROW));
end
endgenerate

generate if (1) begin: psdo_loop
  wire mem_read_0_wire = mem_read >> 0;
  wire mem_write_0_wire = mem_write >> 0;
  wire [BITSROW-1:0] mem_addr_0_wire = mem_addr >> (0*BITSROW);

  wire mem_read_1_wire = mem_read >> 1;
  wire mem_write_1_wire = mem_write >> 1;
  wire [BITSROW-1:0] mem_addr_1_wire = mem_addr >> (1*BITSROW);

  assert_mem_rw0_pseudo_check: assert property (@(posedge clk) disable iff (rst) mem_write_0_wire |->
                                                !((mem_read_1_wire || mem_write_1_wire) && (mem_addr_0_wire == mem_addr_1_wire)));
  assert_mem_rw1_pseudo_check: assert property (@(posedge clk) disable iff (rst) mem_write_1_wire |->
                                                !((mem_read_0_wire || mem_write_0_wire) && (mem_addr_0_wire == mem_addr_1_wire)));
end
endgenerate

endmodule


module ip_top_sva_align_2rw
  #(
parameter     WIDTH   = 32,
parameter     PARITY  = 1,
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMWRDS = 4,
parameter     BITWRDS = 2,
parameter     NUMSROW = 256,
parameter     BITSROW = 8,
parameter     SRAM_DELAY = 2,
parameter     FLOPMEM = 0,
parameter     RSTZERO = 0,
parameter     MEMWDTH = WIDTH+PARITY
   )
(
  input clk,
  input rst,
  input [2-1:0] write,
  input [2-1:0] read,
  input [2*BITADDR-1:0] addr,
  input [2*WIDTH-1:0] din,
  input [2*WIDTH-1:0] dout,
  input [2-1:0] serr,
  input [2*(BITWRDS+BITSROW)-1:0] padr,
  input [2-1:0] mem_write,
  input [2-1:0] mem_read,
  input [2*BITSROW-1:0] mem_addr,
  input [2*NUMWRDS*MEMWDTH-1:0] mem_bw,
  input [2*NUMWRDS*MEMWDTH-1:0] mem_din,
  input [2*NUMWRDS*MEMWDTH-1:0] mem_dout,
  input [BITADDR-1:0] select_addr
);

wire [BITWRDS-1:0] select_word;
wire [BITSROW-1:0] select_srow;
generate if (BITWRDS>0) begin: np2_loop
  np2_addr #(
    .NUMADDR (NUMADDR), .BITADDR (BITADDR),
    .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
    .NUMVROW (NUMSROW), .BITVROW (BITSROW))
    sel_adr (.vbadr(select_word), .vradr(select_srow), .vaddr(select_addr));
  end else begin: no_np2_loop
    assign select_word = 0;
    assign select_srow = select_addr;
  end
endgenerate


reg write_wire [0:2-1];
reg read_wire [0:2-1];
reg [BITADDR-1:0] addr_wire [0:2-1];
reg [WIDTH-1:0] din_wire [0:2-1];
reg [WIDTH-1:0] dout_wire [0:2-1];
reg serr_wire [0:2-1];
reg [BITWRDS+BITSROW-1:0] padr_wire [0:2-1];
integer prt_int;
always_comb
  for (prt_int=0; prt_int<2; prt_int=prt_int+1) begin
    write_wire[prt_int] = write >> prt_int;
    read_wire[prt_int] = read >> prt_int;
    addr_wire[prt_int] = addr >> (prt_int*BITADDR);
    din_wire[prt_int] = din >> (prt_int*WIDTH);
    dout_wire[prt_int] = dout >> (prt_int*WIDTH);
    serr_wire[prt_int] = serr >> prt_int;
    padr_wire[prt_int] = padr >> (prt_int*(BITWRDS+BITSROW));
  end

reg mem_write_wire [0:2-1];
reg mem_read_wire [0:2-1];
reg [BITSROW-1:0] mem_addr_wire [0:2-1];
reg [MEMWDTH-1:0] mem_bw_wire [0:2-1];
reg [MEMWDTH-1:0] mem_din_wire [0:2-1];
reg [MEMWDTH-1:0] mem_dout_wire [0:2-1];
integer mem_int;
always_comb
  for (mem_int=0; mem_int<2; mem_int=mem_int+1) begin
    mem_write_wire[mem_int] = mem_write >> mem_int;
    mem_read_wire[mem_int] = mem_read >> mem_int;
    mem_addr_wire[mem_int] = mem_addr >> (mem_int*BITSROW);
    mem_bw_wire[mem_int] = mem_bw >> ((mem_int*NUMWRDS+select_word)*MEMWDTH);
    mem_din_wire[mem_int] = mem_din >> ((mem_int*NUMWRDS+select_word)*MEMWDTH);
    mem_dout_wire[mem_int] = mem_dout >> ((mem_int*NUMWRDS+select_word)*MEMWDTH);
  end
   
reg meminv;
reg [MEMWDTH-1:0] mem;
always @(posedge clk)
  if (rst) begin
    meminv <= 1'b1;
    mem <= RSTZERO ? 0 : 'hx;
  end else if (mem_write_wire[1] && (mem_addr_wire[1] == select_srow)) begin
    meminv <= 1'b0;
    mem <= (mem_bw_wire[1] & mem_din_wire[1]) | (~mem_bw_wire[1] & mem);
  end else if (mem_write_wire[0] && (mem_addr_wire[0] == select_srow)) begin
    meminv <= 1'b0;
    mem <= (mem_bw_wire[0] & mem_din_wire[0]) | (~mem_bw_wire[0] & mem);
  end

genvar mem_chk;
generate for (mem_chk=0; mem_chk<2; mem_chk=mem_chk+1) begin: mem_chk_loop
  assert_mem_check: assert property (@(posedge clk) disable iff (rst) (mem_read_wire[mem_chk] && (mem_addr_wire[mem_chk] == select_srow)) |-> ##SRAM_DELAY
                                     ($past(!RSTZERO && meminv,SRAM_DELAY) || (mem_dout_wire[mem_chk] == $past(mem,SRAM_DELAY))));
end
endgenerate

assert_mem_parity_check: assert property (@(posedge clk) disable iff (rst) ((PARITY == 0) || (RSTZERO && meminv) || !(^mem)));

reg fakememinv;
reg [WIDTH-1:0] fakemem;
always @(posedge clk)
  if (rst) begin 
    fakememinv <= 1'b1;
    fakemem <= RSTZERO ? 0 : 'hx;
  end else if (write_wire[1] && (addr_wire[1] == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din_wire[1];
  end else if (write_wire[0] && (addr_wire[0] == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din_wire[0];
  end

wire mem_serr [0:2-1];
wire mem_nerr [0:2-1];
genvar mem_err;
generate for (mem_err=0; mem_err<2; mem_err=mem_err+1) begin: err_loop
  assign mem_serr[mem_err] = 0;
  assign mem_nerr[mem_err] = !mem_serr[mem_err];

  assume_mem_nerr_check: assert property (@(posedge clk) disable iff (rst) mem_nerr[mem_err] |-> ##(SRAM_DELAY+FLOPMEM) !core.dout_serr_mask[mem_err]);
  assume_mem_serr_check: assert property (@(posedge clk) disable iff (rst) mem_serr[mem_err] |-> ##(SRAM_DELAY+FLOPMEM) core.dout_serr_mask[mem_err]);
end
endgenerate

genvar dout_var;
generate for (dout_var=0; dout_var<2; dout_var=dout_var+1) begin: dout_loop
  assert_dout_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var] == select_addr) && mem_nerr[dout_var]) |-> ##(SRAM_DELAY+FLOPMEM)
				           ($past(!RSTZERO && fakememinv,SRAM_DELAY+FLOPMEM) || (!serr_wire[dout_var] && (dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM)))));
  assert_dout_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var] == select_addr) && mem_serr[dout_var]) |-> ##(SRAM_DELAY+FLOPMEM)
					   (PARITY ? ($past(!RSTZERO && fakememinv,SRAM_DELAY+FLOPMEM) || serr_wire[dout_var]) : !serr_wire[dout_var]));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var]==select_addr)) |-> ##(SRAM_DELAY+FLOPMEM)
				      (padr_wire[dout_var] == {select_word,select_srow}));
end
endgenerate

endmodule
