module ip_top_sva_2_align_ecc_1r1w_a621
  #(
parameter     ENAPSDO = 0,
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMSROW = 256,
parameter     BITSROW = 8)
(
  input clk,
  input rst,
  input write,
  input [BITADDR-1:0] wr_adr,
  input read,
  input [BITADDR-1:0] rd_adr,
  input mem_write,
  input [BITSROW-1:0] mem_wr_adr,
  input mem_read,
  input [BITSROW-1:0] mem_rd_adr
);

//assert_rd_range_check: assume property (@(posedge clk) disable iff (rst) read |-> (rd_adr < NUMADDR));
assert_wr_range_check: assume property (@(posedge clk) disable iff (rst) write |-> (wr_adr < NUMADDR));

//assert_mem_rd_range_check: assert property (@(posedge clk) disable iff (rst) mem_read |-> (mem_rd_adr < NUMSROW));
assert_mem_wr_range_check: assert property (@(posedge clk) disable iff (rst) mem_write |-> (mem_wr_adr < NUMSROW));
assert_mem_rd_wr_pseudo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && mem_write && mem_read) |-> (mem_wr_adr != mem_rd_adr));

endmodule


module ip_top_sva_align_ecc_1r1w_a621
  #(
parameter     WIDTH   = 32,
parameter     ENAPSDO = 0,
parameter     ENAPAR  = 0,
parameter     ENAECC  = 0,
parameter     ENADEC  = 0,
parameter     ENAHEC  = 0,
parameter     ENAQEC  = 0,
parameter     ECCWDTH = 7,
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMWRDS = 4,
parameter     BITWRDS = 2,
parameter     NUMSROW = 256,
parameter     BITSROW = 8,
parameter     BITPADR = 10,
parameter     SRAM_DELAY = 2,
parameter     FLOPGEN = 0,
parameter     FLOPCMD = 0,
parameter     FLOPMEM = 0,
parameter     FLOPOUT = 0,
parameter     ENAPADR = 0,
parameter     RSTZERO = 0,
parameter     RSTONES = 0,
parameter     MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENADEC ? 2*WIDTH+ECCWDTH : ENAHEC ? WIDTH+2*ECCWDTH : ENAQEC ? WIDTH+4*ECCWDTH : WIDTH
   )
(
  input clk,
  input rst,
  input write,
  input [BITADDR-1:0] wr_adr,
  input [WIDTH-1:0] din,
  input read,
  input [BITADDR-1:0] rd_adr,
  input [WIDTH-1:0] rd_dout,
  input rd_fwrd,
  input rd_serr,
  input rd_derr,
  input [BITPADR-1:0] rd_padr,
  input mem_write,
  input [BITSROW-1:0] mem_wr_adr,
  input [NUMWRDS*MEMWDTH-1:0] mem_bw,
  input [NUMWRDS*MEMWDTH-1:0] mem_din,
  input mem_read,
  input [BITSROW-1:0] mem_rd_adr,
  input [NUMWRDS*MEMWDTH-1:0] mem_rd_dout,
  input mem_rd_fwrd,
  input [BITPADR-BITWRDS-1:0] mem_rd_padr,
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

wire [MEMWDTH-1:0] mem_bw_wire = mem_bw >> select_word*MEMWDTH;
wire [MEMWDTH-1:0] mem_din_wire = mem_din >> select_word*MEMWDTH;

wire [MEMWDTH-1:0] rstdin;
generate
  if (ENAPAR) begin: rpar_loop
    wire [WIDTH-1:0] rstval = RSTZERO ? 0 : RSTONES ? ~0 : {WIDTH{1'bx}};
    assign rstdin = {^rstval,rstval};
  end else if (ENAECC) begin: recc_loop
    wire [WIDTH-1:0] rstval = RSTZERO ? 0 : RSTONES ? ~0 : {WIDTH{1'bx}};
    wire [ECCWDTH-1:0] rstecc;
    ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
      ecc_calc_inst (.din(rstval), .eccout(rstecc));
    assign rstdin = {rstecc,rstval};
  end else if (ENADEC) begin: rdec_loop
    wire [WIDTH-1:0] rstval = RSTZERO ? 0 : RSTONES ? ~0 : {WIDTH{1'bx}};
    wire [ECCWDTH-1:0] rstecc;
    ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
      ecc_calc_inst (.din(rstval), .eccout(rstecc));
    assign rstdin = {rstval,rstecc,rstval};
  end else if (ENAHEC) begin: rhec_loop
    wire [(WIDTH>>1)-1:0] rstval = RSTZERO ? 0 : RSTONES ? ~0 : {(WIDTH>>1){1'bx}};
    wire [ECCWDTH-1:0] rstecc;
    ecc_calc #(.ECCDWIDTH(WIDTH>>1), .ECCWIDTH(ECCWDTH))
      ecc_calc_inst (.din(rstval), .eccout(rstecc));
    assign rstdin = {2{rstecc,rstval}};
  end else if (ENAQEC) begin: rqec_loop
    wire [(WIDTH>>2)-1:0] rstval = RSTZERO ? 0 : RSTONES ? ~0 : {(WIDTH>>2){1'bx}};
    wire [ECCWDTH-1:0] rstecc;
    ecc_calc #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
      ecc_calc_inst (.din(rstval), .eccout(rstecc));
    assign rstdin = {4{rstecc,rstval}};
  end else begin: rnop_loop
    wire [WIDTH-1:0] rstval = RSTZERO ? 0 : RSTONES ? ~0 : {WIDTH{1'bx}};
    assign rstdin = rstval;
  end
endgenerate

reg meminv;
reg [MEMWDTH-1:0] mem;
always @(posedge clk)
  if (rst) begin
    meminv <= 1'b1;
    mem <= rstdin;
  end else if (mem_write && (mem_wr_adr == select_srow)) begin
    meminv <= meminv && !(|mem_bw_wire);
    mem <= (mem_bw_wire & mem_din_wire) | (~mem_bw_wire & mem);
  end

wire mem_serr;
wire mem_derr;
wire mem_nerr;
wire [MEMWDTH-1:0] dout_mask;

assign mem_serr = 0;
assign mem_derr = 0;
assign mem_nerr = !mem_serr && !mem_derr;

wire dout_bit1_err = 0;
wire dout_bit2_err = 0;
wire [15:0] dout_bit1_pos = 0;
wire [15:0] dout_bit2_pos = 0;
wire [MEMWDTH-1:0] dout_bit1_mask = (ENAPAR || ENAECC || ENADEC || ENAHEC || ENAQEC) ? dout_bit1_err << dout_bit1_pos : 0;
wire [MEMWDTH-1:0] dout_bit2_mask = (ENAECC || ENADEC || ENAHEC || ENAQEC) ? dout_bit2_err << dout_bit2_pos : 0;
assign dout_mask = dout_bit1_mask ^ dout_bit2_mask;
wire dout_serr = ENAHEC ? |dout_mask && (|dout_bit1_mask ^ |dout_bit2_mask) ||
                          (|dout_mask[(MEMWDTH>>1)-1:0] && (|dout_bit1_mask[(MEMWDTH>>1)-1:0] ^ |dout_bit2_mask[(MEMWDTH>>1)-1:0])) ||
                          (|dout_mask[MEMWDTH-1:(MEMWDTH>>1)] && (|dout_bit1_mask[MEMWDTH-1:(MEMWDTH>>1)] ^ |dout_bit2_mask[MEMWDTH-1:(MEMWDTH>>1)])) :
                 ENAQEC ? |dout_mask && (|dout_bit1_mask ^ |dout_bit2_mask) ||
                          (|dout_mask[(MEMWDTH>>2)-1:0] && (|dout_bit1_mask[(MEMWDTH>>2)-1:0] ^ |dout_bit2_mask[(MEMWDTH>>2)-1:0])) ||
                          (|dout_mask[2*(MEMWDTH>>2)-1:(MEMWDTH>>2)] && (|dout_bit1_mask[2*(MEMWDTH>>2)-1:(MEMWDTH>>2)] ^ |dout_bit2_mask[2*(MEMWDTH>>2)-1:(MEMWDTH>>2)])) ||
                          (|dout_mask[3*(MEMWDTH>>2)-1:2*(MEMWDTH>>2)] && (|dout_bit1_mask[3*(MEMWDTH>>2)-1:2*(MEMWDTH>>2)] ^ |dout_bit2_mask[3*(MEMWDTH>>2)-1:2*(MEMWDTH>>2)])) ||
                          (|dout_mask[4*(MEMWDTH>>2)-1:3*(MEMWDTH>>2)] && (|dout_bit1_mask[4*(MEMWDTH>>2)-1:3*(MEMWDTH>>2)] ^ |dout_bit2_mask[4*(MEMWDTH>>2)-1:3*(MEMWDTH>>2)])) :
                          |dout_mask && (|dout_bit1_mask ^ |dout_bit2_mask);
wire dout_derr = ENAHEC ? (|dout_mask[(MEMWDTH>>1)-1:0] && |dout_bit1_mask[(MEMWDTH>>1)-1:0] && |dout_bit2_mask[(MEMWDTH>>1)-1:0]) ||
                          (|dout_mask[MEMWDTH-1:(MEMWDTH>>1)] && |dout_bit1_mask[MEMWDTH-1:(MEMWDTH>>1)] && |dout_bit2_mask[MEMWDTH-1:(MEMWDTH>>1)]) :
                 ENAQEC ? (|dout_mask[(MEMWDTH>>2)-1:0] && |dout_bit1_mask[(MEMWDTH>>2)-1:0] && |dout_bit2_mask[(MEMWDTH>>2)-1:0]) ||
                          (|dout_mask[2*(MEMWDTH>>2)-1:(MEMWDTH>>2)] && |dout_bit1_mask[2*(MEMWDTH>>2)-1:(MEMWDTH>>2)] && |dout_bit2_mask[2*(MEMWDTH>>2)-1:(MEMWDTH>>2)]) || 
                          (|dout_mask[3*(MEMWDTH>>2)-1:2*(MEMWDTH>>2)] && |dout_bit1_mask[3*(MEMWDTH>>2)-1:2*(MEMWDTH>>2)] && |dout_bit2_mask[3*(MEMWDTH>>2)-1:2*(MEMWDTH>>2)]) || 
                          (|dout_mask[4*(MEMWDTH>>2)-1:3*(MEMWDTH>>2)] && |dout_bit1_mask[4*(MEMWDTH>>2)-1:3*(MEMWDTH>>2)] && |dout_bit2_mask[4*(MEMWDTH>>2)-1:3*(MEMWDTH>>2)]) :
                          |dout_mask && |dout_bit1_mask && |dout_bit2_mask;

assume_mem_nerr_check: assert property (@(posedge clk) disable iff (rst) mem_nerr |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM) !dout_serr && !dout_derr);
assume_mem_serr_check: assert property (@(posedge clk) disable iff (rst) mem_serr |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM) dout_serr);
assume_mem_derr_check: assert property (@(posedge clk) disable iff (rst) mem_derr |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM) dout_derr);

wire [MEMWDTH-1:0] mem_dout_wire = mem_rd_dout >> select_word*MEMWDTH;

assert_mem_check: assert property (@(posedge clk) disable iff (rst) (mem_read && (mem_rd_adr == select_srow)) |-> ##SRAM_DELAY
                                   ($past(!RSTZERO && !RSTONES && meminv,SRAM_DELAY) || (mem_dout_wire == ($past(mem,SRAM_DELAY) ^ dout_mask))));

wire [ECCWDTH-1:0] din_ecc;
wire [ECCWDTH-1:0] din_ecc2;
wire [ECCWDTH-1:0] din_ecc3;
wire [ECCWDTH-1:0] din_ecc4;
generate if (ENAECC || ENADEC) begin: decc_loop
  ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
    ecc_calc_inst (.din(mem[WIDTH-1:0]), .eccout(din_ecc));
end else if (ENAHEC) begin: hecc_loop
  ecc_calc #(.ECCDWIDTH(WIDTH>>1), .ECCWIDTH(ECCWDTH))
    ecc_calc_1_inst (.din(mem[(WIDTH>>1)-1:0]), .eccout(din_ecc));
  ecc_calc #(.ECCDWIDTH(WIDTH>>1), .ECCWIDTH(ECCWDTH))
    ecc_calc_2_inst (.din(mem[WIDTH+ECCWDTH-1:(WIDTH>>1)+ECCWDTH]), .eccout(din_ecc2));
end else if (ENAQEC) begin: qecc_loop
  ecc_calc #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
    ecc_calc_1_inst (.din(mem[(WIDTH>>2)-1:0]), .eccout(din_ecc));
  ecc_calc #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
    ecc_calc_2_inst (.din(mem[(MEMWDTH>>2)+(WIDTH>>2)-1:(MEMWDTH>>2)]), .eccout(din_ecc2));
  ecc_calc #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
    ecc_calc_3_inst (.din(mem[2*(MEMWDTH>>2)+(WIDTH>>2)-1:2*(MEMWDTH>>2)]), .eccout(din_ecc3));
  ecc_calc #(.ECCDWIDTH(WIDTH>>2), .ECCWIDTH(ECCWDTH))
    ecc_calc_4_inst (.din(mem[3*(MEMWDTH>>2)+(WIDTH>>2)-1:3*(MEMWDTH>>2)]), .eccout(din_ecc4));
end
endgenerate

assert_mem_chk_check: assert property (@(posedge clk) disable iff (rst) ((!RSTZERO && !RSTONES && meminv) ||
                                                                         (ENAPAR ? !(^mem) :
                                                                          ENAECC ? ({din_ecc,mem[WIDTH-1:0]}==mem) :
                                                                          ENADEC ? ({mem[WIDTH-1:0],din_ecc,mem[WIDTH-1:0]}==mem) :
                                                                          ENAHEC ? ({din_ecc2,mem[(MEMWDTH>>1)+(WIDTH>>1)-1:(MEMWDTH>>1)],
                                                                                     din_ecc,mem[(WIDTH>>1)-1:0]}==mem) :
                                                                          ENAQEC ? ({din_ecc4,mem[3*(MEMWDTH>>2)+(WIDTH>>2)-1:3*(MEMWDTH>>2)],
                                                                                     din_ecc3,mem[2*(MEMWDTH>>2)+(WIDTH>>2)-1:2*(MEMWDTH>>2)],
                                                                                     din_ecc2,mem[(MEMWDTH>>2)+(WIDTH>>2)-1:(MEMWDTH>>2)],
                                                                                     din_ecc,mem[(WIDTH>>2)-1:0]}==mem) : 1'b1)));

reg fakememinv;
reg [WIDTH-1:0] fakemem;
always @(posedge clk)
  if (rst) begin
    fakememinv <= 1'b1;
    fakemem <= RSTZERO ? 0 : RSTONES ? ~0 : 'hx;
  end else if (write && (wr_adr == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= din;
  end
/*
wire mem_serr = 0;
wire mem_derr = 0;
wire mem_nerr = !mem_serr && !mem_derr;
assume_mem_err_check: assert property (@(posedge clk) disable iff (rst) !(mem_serr && mem_derr));
assume_mem_nerr_check: assert property (@(posedge clk) disable iff (rst) mem_nerr |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM) !core.dout_serr && !core.dout_derr);
assume_mem_serr_check: assert property (@(posedge clk) disable iff (rst) mem_serr |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM) core.dout_serr);
assume_mem_derr_check: assert property (@(posedge clk) disable iff (rst) mem_derr |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM) core.dout_derr);
*/
assert_dout_nerr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr) && mem_nerr) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
				         ($past(!RSTZERO && !RSTONES && fakememinv,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT) ||
                                          (($past(!RSTZERO && !RSTONES && meminv,SRAM_DELAY+FLOPMEM+FLOPOUT) || (!rd_serr && !rd_derr) ||
                                           (ENAPSDO && rd_fwrd && !(FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd))) &&
                                           (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)))));
assert_dout_serr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr) && mem_serr) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
					 ($past(!RSTZERO && !RSTONES && fakememinv,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT) ||
                                          ($past(!RSTZERO && !RSTONES && meminv,SRAM_DELAY+FLOPMEM+FLOPOUT) ?
                                           (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) :
                                           (ENAPAR ? ((rd_serr && !rd_derr) || (FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd) ||
                                                      (ENAPSDO && rd_fwrd && !(FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd))) &&
                                                     (!rd_fwrd || (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT))) :
                                            ENAECC ? ((rd_serr && !rd_derr) || (FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd) ||
                                                      (ENAPSDO && rd_fwrd && !(FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd))) &&
                                                     (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) :
                                            ENADEC ? ((rd_serr && !rd_derr) || (FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd) ||
                                                      (ENAPSDO && rd_fwrd && !(FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd))) &&
                                                     (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) :
                                            ENAHEC ? ((rd_serr && !rd_derr) || (FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd) ||
                                                      (ENAPSDO && rd_fwrd && !(FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd))) &&
                                                     (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) :
                                            ENAQEC ? ((rd_serr && !rd_derr) || (FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd) ||
                                                      (ENAPSDO && rd_fwrd && !(FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd))) &&
                                                     (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) :
                                                     !rd_serr && !rd_derr && (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT))))));
assert_dout_derr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr == select_addr) && mem_derr) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
					 ($past(!RSTZERO && !RSTONES && fakememinv,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT) ||
                                          ($past(!RSTZERO && !RSTONES && meminv,SRAM_DELAY+FLOPMEM+FLOPOUT) ?
                                           (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) :
                                           (ENAPAR ? !rd_serr && !rd_derr && (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) :
                                            ENAECC ? ((!rd_serr && rd_derr) || (FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd) ||
                                                      (ENAPSDO && rd_fwrd && !(FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd))) &&
                                                     (!rd_fwrd || (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT))) :
                                            ENADEC ? ((!rd_serr && rd_derr) || (FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd) ||
                                                      (ENAPSDO && rd_fwrd && !(FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd))) &&
                                                     (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)) :
                                            ENAHEC ? ((!rd_serr && rd_derr) || (FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd) ||
                                                      (ENAPSDO && rd_fwrd && !(FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd))) &&
                                                     (!rd_fwrd || (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT))) :
                                            ENAQEC ? ((!rd_serr && rd_derr) || (FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd) ||
                                                      (ENAPSDO && rd_fwrd && !(FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd))) &&
                                                     (!rd_fwrd || (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT))) :
                                                     !rd_serr && !rd_derr && (rd_dout == $past(fakemem,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT))))));
assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr==select_addr)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                    (rd_fwrd == ($past(core.forward_read,SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT) ||
                                                 (FLOPOUT ? $past(mem_rd_fwrd) : mem_rd_fwrd))));
assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read && (rd_adr==select_addr)) |-> ##(SRAM_DELAY+FLOPCMD+FLOPMEM+FLOPOUT)
                                      ((NUMWRDS==1) ? (rd_padr == (ENAPADR ? (FLOPOUT ? $past(mem_rd_padr) : mem_rd_padr) : select_srow)) :
                                                      (rd_padr == (ENAPADR ? {select_word,(FLOPOUT ? $past(mem_rd_padr) : mem_rd_padr)} :
                                                                             {select_word,select_srow}))));

endmodule

