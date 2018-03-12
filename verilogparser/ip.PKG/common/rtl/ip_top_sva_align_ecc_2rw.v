module ip_top_sva_2_align_ecc_2rw
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
`ifdef FORMAL
//synopsys translate_off

genvar rw_var;
generate for (rw_var=0; rw_var<2; rw_var=rw_var+1) begin: rw_loop
  wire write_wire = write >> rw_var;
  wire read_wire = read >> rw_var;
  wire [BITADDR-1:0] addr_wire = addr >> (rw_var*BITADDR);

  assert_rw_check: assume property (@(posedge clk) disable iff (rst) !(write_wire && read_wire));
//  assert_rw_range_check: assume property (@(posedge clk) disable iff (rst) (write_wire || read_wire) |-> (addr_wire < NUMADDR));
end
endgenerate

genvar mem_var;
generate for (mem_var=0; mem_var<2; mem_var=mem_var+1) begin: mem_loop
  wire mem_write_wire = mem_write >> mem_var;
  wire mem_read_wire = mem_read >> mem_var;
  wire [BITSROW-1:0] mem_addr_wire = mem_addr >> (mem_var*BITSROW);

  assert_mem_rw_check: assume property (@(posedge clk) disable iff (rst) !(mem_write_wire && mem_read_wire));
//  assert_mem_rw_range_check: assume property (@(posedge clk) disable iff (rst) (mem_write_wire || mem_read_wire) |-> (mem_addr_wire < NUMSROW));
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
//synopsys translate_on
`endif
endmodule


module ip_top_sva_align_ecc_2rw
  #(
parameter     WIDTH   = 32,
parameter     ENAPAR  = 0,
parameter     ENAECC  = 0,
parameter     ECCWDTH = 7,
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMWRDS = 4,
parameter     BITWRDS = 2,
parameter     NUMSROW = 256,
parameter     BITSROW = 8,
parameter     SRAM_DELAY = 2,
parameter     FLOPGEN = 0,
parameter     FLOPMEM = 0,
parameter     FLOPOUT = 0,
parameter     RSTZERO = 0,
parameter     MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH
   )
(
  input clk,
  input rst,
  input [2-1:0] write,
  input [2-1:0] read,
  input [2*BITADDR-1:0] addr,
  input [2*WIDTH-1:0] din,
  input [2*WIDTH-1:0] rd_dout,
  input [2-1:0] rd_fwrd,
  input [2-1:0] rd_serr,
  input [2-1:0] rd_derr,
  input [2*(BITWRDS+BITSROW)-1:0] rd_padr,
  input [2-1:0] mem_write,
  input [2-1:0] mem_read,
  input [2*BITSROW-1:0] mem_addr,
  input [2*NUMWRDS*MEMWDTH-1:0] mem_bw,
  input [2*NUMWRDS*MEMWDTH-1:0] mem_din,
  input [2*NUMWRDS*MEMWDTH-1:0] mem_dout,
  input [BITADDR-1:0] select_addr
);
`ifdef FORMAL
//synopsys translate_off
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
reg [WIDTH-1:0] rd_dout_wire [0:2-1];
reg rd_fwrd_wire [0:2-1];
reg rd_serr_wire [0:2-1];
reg rd_derr_wire [0:2-1];
reg [BITWRDS+BITSROW-1:0] rd_padr_wire [0:2-1];
integer prt_int;
always_comb
  for (prt_int=0; prt_int<2; prt_int=prt_int+1) begin
    write_wire[prt_int] = write >> prt_int;
    read_wire[prt_int] = read >> prt_int;
    addr_wire[prt_int] = addr >> (prt_int*BITADDR);
    din_wire[prt_int] = din >> (prt_int*WIDTH);
    rd_dout_wire[prt_int] = rd_dout >> (prt_int*WIDTH);
    rd_fwrd_wire[prt_int] = rd_fwrd >> prt_int;
    rd_serr_wire[prt_int] = rd_serr >> prt_int;
    rd_derr_wire[prt_int] = rd_derr >> prt_int;
    rd_padr_wire[prt_int] = rd_padr >> (prt_int*(BITWRDS+BITSROW));
  end

reg mem_write_wire [0:2-1];
reg mem_read_wire [0:2-1];
reg [BITSROW-1:0] mem_addr_wire [0:2-1];
reg [MEMWDTH-1:0] mem_bw_wire [0:2-1];
reg [MEMWDTH-1:0] mem_din_wire [0:2-1];
reg [MEMWDTH-1:0] mem_dout_wire [0:2-1];
integer memw_int;
always_comb
  for (memw_int=0; memw_int<2; memw_int=memw_int+1) begin
    mem_write_wire[memw_int] = mem_write >> memw_int;
    mem_read_wire[memw_int] = mem_read >> memw_int;
    mem_addr_wire[memw_int] = mem_addr >> (memw_int*BITSROW);
    mem_bw_wire[memw_int] = mem_bw >> ((memw_int*NUMWRDS+select_word)*MEMWDTH);
    mem_din_wire[memw_int] = mem_din >> ((memw_int*NUMWRDS+select_word)*MEMWDTH);
    mem_dout_wire[memw_int] = mem_dout >> ((memw_int*NUMWRDS+select_word)*MEMWDTH);
  end
   
reg meminv;
reg [MEMWDTH-1:0] mem;
reg meminv_next;
reg [MEMWDTH-1:0] mem_next;
integer mem_int;
always_comb begin
  meminv_next = meminv;
  mem_next = mem;
  if (rst) begin
    meminv_next = 1'b1;
    mem_next = RSTZERO ? 0 : 'hx;
  end else for (mem_int=0; mem_int<2; mem_int=mem_int+1)
    if (mem_write_wire[mem_int] && (mem_addr_wire[mem_int] == select_srow)) begin
      meminv_next = meminv_next && !(|mem_bw_wire[mem_int]);
      mem_next = (mem_din_wire[mem_int] & mem_bw_wire[mem_int]) | (mem_next & ~mem_bw_wire[mem_int]);
    end
end

always @(posedge clk) begin
  meminv <= meminv_next;
  mem <= mem_next;
end
/*
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
*/
wire mem_serr [0:2-1];
wire mem_derr [0:2-1];
wire mem_nerr [0:2-1];
wire [MEMWDTH-1:0] dout_mask [0:2-1];
genvar err_var;
generate for (err_var=0; err_var<2; err_var=err_var+1) begin: err_loop
  assign mem_serr[err_var] = 0;
  assign mem_derr[err_var] = 0;
  assign mem_nerr[err_var] = !mem_serr[err_var] && !mem_derr[err_var];

  wire dout_bit1_err = 0;
  wire dout_bit2_err = 0;
  wire [15:0] dout_bit1_pos = 0;
  wire [15:0] dout_bit2_pos = 0;
  wire [MEMWDTH-1:0] dout_bit1_mask = (ENAPAR || ENAECC) ? dout_bit1_err << dout_bit1_pos : 0;
  wire [MEMWDTH-1:0] dout_bit2_mask = ENAECC ? dout_bit2_err << dout_bit2_pos : 0;
  assign dout_mask[err_var] = dout_bit1_mask ^ dout_bit2_mask;
  wire dout_serr = |dout_mask[err_var] && (|dout_bit1_mask ^ |dout_bit2_mask);
  wire dout_derr = |dout_mask[err_var] && |dout_bit1_mask && |dout_bit2_mask;

  assume_mem_nerr_check: assert property (@(posedge clk) disable iff (rst) mem_nerr[err_var] |-> ##(SRAM_DELAY+FLOPMEM) !dout_serr && !dout_derr);
  assume_mem_serr_check: assert property (@(posedge clk) disable iff (rst) mem_serr[err_var] |-> ##(SRAM_DELAY+FLOPMEM) dout_serr);
  assume_mem_derr_check: assert property (@(posedge clk) disable iff (rst) mem_derr[err_var] |-> ##(SRAM_DELAY+FLOPMEM) dout_derr);

end
endgenerate

genvar mem_chk;
generate for (mem_chk=0; mem_chk<2; mem_chk=mem_chk+1) begin: mem_chk_loop
  assert_mem_check: assert property (@(posedge clk) disable iff (rst) (mem_read_wire[mem_chk] && (mem_addr_wire[mem_chk] == select_srow)) |-> ##SRAM_DELAY
                                     ($past(!RSTZERO && meminv,SRAM_DELAY) ||
                                      (mem_dout_wire[mem_chk] == ($past(mem,SRAM_DELAY) ^ dout_mask[mem_chk]))));
end
endgenerate

wire [ECCWDTH-1:0] din_ecc;
generate if (ENAECC) begin: decc_loop
  ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
    ecc_calc_inst (.din(mem[WIDTH-1:0]), .eccout(din_ecc));
end
endgenerate

assert_mem_chk_check: assert property (@(posedge clk) disable iff (rst) (meminv || (ENAPAR ? !(^mem) :
                                                                                    ENAECC ? ({din_ecc,mem[WIDTH-1:0]}==mem) : 1'b1)));

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

genvar dout_var;
generate for (dout_var=0; dout_var<2; dout_var=dout_var+1) begin: dout_loop
  assert_dout_nerr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var] == select_addr) && mem_nerr[dout_var]) |-> ##(SRAM_DELAY+FLOPMEM+FLOPOUT)
                                           ($past(fakememinv,SRAM_DELAY+FLOPMEM+FLOPOUT) ||
                                            (($past(meminv,SRAM_DELAY+FLOPMEM+FLOPOUT) || (!rd_serr_wire[dout_var] && !rd_derr_wire[dout_var])) &&
                                             (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT)))));
  assert_dout_serr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var] == select_addr) && mem_serr[dout_var]) |-> ##(SRAM_DELAY+FLOPMEM+FLOPOUT)
                                           ($past(fakememinv,SRAM_DELAY+FLOPMEM+FLOPOUT) ||
                                            ($past(meminv,SRAM_DELAY+FLOPMEM+FLOPOUT) ?
                                             (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT)) :
                                             (ENAPAR ? rd_serr_wire[dout_var] && !rd_derr_wire[dout_var] && (!rd_fwrd_wire[dout_var] || (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT))) :
                                              ENAECC ? rd_serr_wire[dout_var] && !rd_derr_wire[dout_var] && (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT)) :
                                                       !rd_serr_wire[dout_var] && !rd_derr_wire[dout_var] && (!rd_fwrd_wire[dout_var] || (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT)))))));
  assert_dout_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var] == select_addr) && mem_derr[dout_var]) |-> ##(SRAM_DELAY+FLOPMEM+FLOPOUT)
                                           ($past(fakememinv,SRAM_DELAY+FLOPMEM+FLOPOUT) ||
                                            ($past(meminv,SRAM_DELAY+FLOPMEM+FLOPOUT) ?
                                             (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT)) :
                                              (ENAPAR ? !rd_serr_wire[dout_var] && rd_derr_wire[dout_var] && (!rd_fwrd_wire[dout_var] || (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT))) :
                                               ENAECC ? !rd_serr_wire[dout_var] && rd_derr_wire[dout_var] && (!rd_fwrd_wire[dout_var] || (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT))) :
                                                        !rd_serr_wire[dout_var] && !rd_derr_wire[dout_var] && (!rd_fwrd_wire[dout_var] || (rd_dout_wire[dout_var] == $past(fakemem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT)))))));
  assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var]==select_addr)) |-> ##(SRAM_DELAY+FLOPMEM+FLOPOUT)
                                      ($past(fakememinv,SRAM_DELAY+FLOPMEM+FLOPOUT) ||
                                       $past(fakemem==mem[WIDTH-1:0],SRAM_DELAY+FLOPMEM+FLOPOUT) || rd_fwrd_wire[dout_var]));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[dout_var] && (addr_wire[dout_var]==select_addr)) |-> ##(SRAM_DELAY+FLOPMEM+FLOPOUT)
				      (rd_padr_wire[dout_var] == {select_word,select_srow}));
end
endgenerate
//synopsys translate_on
`endif
endmodule
