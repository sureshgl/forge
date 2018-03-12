module algo_4k1l_a441_top (push, pu_ptr,
                           pop, po_pvld, po_ptr,
                           t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
                           clk, rst, ready);


  parameter NUMPUPT = 1;
  parameter NUMPOPT = 4;
  parameter BITPOPT = 2;
  parameter NUMADDR = 64;
  parameter BITADDR = 6;
  parameter BITQPTR = BITADDR;
  parameter BITQCNT = BITADDR+1;
  parameter QPTR_WIDTH = 11;
  parameter NUMVBNK = 4;
  parameter BITVBNK = 2;

  parameter QPTR_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPECC = 1;

  parameter NUMWRDS = 1;
  parameter BITWRDS = 0;

  parameter BITCPAD = BITADDR;
  parameter CPUWDTH = BITADDR+BITQCNT;

  input [NUMPUPT-1:0]              push;
  input [NUMPUPT*BITQPTR-1:0]      pu_ptr;

  input [NUMPOPT-1:0]              pop;
  output [NUMPOPT-1:0]             po_pvld;
  output [NUMPOPT*BITQPTR-1:0]     po_ptr;


  output                           ready;
  input                            clk, rst;

  output [NUMVBNK-1:0]             t1_writeA;
  output [NUMVBNK*BITADDR-1:0]     t1_addrA;
  output [NUMVBNK*QPTR_WIDTH-1:0]  t1_dinA;
  output [NUMVBNK-1:0]             t1_readB;
  output [NUMVBNK*BITADDR-1:0]     t1_addrB;
  input [NUMVBNK*QPTR_WIDTH-1:0]   t1_doutB;
`ifdef FORMAL 

wire [BITADDR-1:0] select_addr;
assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
/*
wire [BITVROW-1:0] select_vrow;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  adr_a2 (.vbadr(), .vradr(select_vrow), .vaddr(select_addr));
  
wire [BITSROW-1:0] select_srow;
np2_addr #(
  .NUMADDR (NUMVROW), .BITADDR (BITVROW),
  .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
  .NUMVROW (NUMSROW), .BITVROW (BITSROW))
  vrow_inst (.vbadr(), .vradr(select_srow), .vaddr(select_vrow));
*/
`else
wire [BITADDR-1:0] select_addr = 0;
/*
wire [BITVROW-1:0] select_vrow = 0;
wire [BITSROW-1:0] select_srow = 0;
wire [BITDROW-1:0] select_drow = 0;
*/
`endif

wire                           t1_writeA_a1[0:NUMVBNK-1];
wire [BITADDR-1:0]             t1_addrA_a1[0:NUMVBNK-1];
wire [BITQPTR-1:0]             t1_dinA_a1[0:NUMVBNK-1];
wire                           t1_readB_a1[0:NUMVBNK-1];
wire [BITADDR-1:0]             t1_addrB_a1[0:NUMVBNK-1];
reg  [BITQPTR-1:0]             t1_doutB_a1[0:NUMVBNK-1];
reg                            t1_fwrdB_a1[0:NUMVBNK-1];
reg                            t1_serrB_a1[0:NUMVBNK-1];
reg                            t1_derrB_a1[0:NUMVBNK-1];
reg  [BITADDR-1:0]             t1_padrB_a1[0:NUMVBNK-1];
wire [BITADDR :0]              freecnt [0:NUMVBNK-1];

wire                           po_pvld_wire[0:NUMVBNK-1];
wire [BITQPTR-1:0]             po_ptr_wire[0:NUMVBNK-1];
wire                           ready_wire[0:NUMVBNK-1];

reg [NUMPOPT-1:0]              po_pvld;
reg [NUMPOPT*BITQPTR-1:0]      po_ptr;

wire                           t1_writeA_wire [0:NUMVBNK-1];
wire [BITADDR-1:0]             t1_addrA_wire [0:NUMVBNK-1];
wire [QPTR_WIDTH-1:0]          t1_bwA_wire [0:NUMVBNK-1];
wire [QPTR_WIDTH-1:0]          t1_dinA_wire [0:NUMVBNK-1];
wire                           t1_readB_wire [0:NUMVBNK-1];
wire [BITADDR-1:0]             t1_addrB_wire [0:NUMVBNK-1];

reg [BITVBNK-1:0] min_bnk;
always_comb begin 
  min_bnk = NUMVBNK-1;
  for(integer i=0;i<NUMVBNK;i=i+1) 
    min_bnk = (freecnt[i] < freecnt[min_bnk]) ? i : min_bnk;
end

reg               push_wire[NUMVBNK-1:0];
reg [BITQPTR-1:0] pu_ptr_wire[NUMVBNK-1:0];

always_comb begin
  for (integer i=0; i<NUMVBNK; i++) 
      push_wire[i]   = 1'b0;  
  for (integer i=0; i<NUMVBNK; i++) begin
    if (i==min_bnk) begin
      push_wire[i]   = push;  
      pu_ptr_wire[i] = pu_ptr;
    end
  end
end

reg [BITVBNK-1:0] pop_rrptr;
reg [BITVBNK-1:0] pop_rrptr_nxt;
reg [NUMPOPT-1:0] b2p_map [NUMVBNK-1:0];
reg [0:NUMVBNK-1] pop_bnk ;
integer pbnk;
always_comb begin
  for (integer i =0; i<NUMPOPT; i++)
    pop_bnk[i] = 1'b0;
  pbnk = pop_rrptr;
  pop_rrptr_nxt = pop_rrptr;
  for (integer i=0; i<NUMPOPT; i++) begin
    if (pop[i]) begin
      pop_bnk[pbnk] = 1'b1;
      b2p_map[pbnk] = i;
      pbnk = (pbnk + 1'b1)%NUMVBNK;
    end
  end
  pop_rrptr_nxt = pbnk;
end

always @(posedge clk)
  pop_rrptr <= rst ? {BITVBNK{1'b0}} : pop_rrptr_nxt;

reg [BITQPTR-1:0] po_ptr_out [0:NUMPOPT-1];
reg               po_pvld_out [0:NUMPOPT-1];
always_comb begin
  for (integer i=0; i<NUMVBNK; i=i+1) 
    if (pop_bnk[i]) begin
      po_ptr_out[b2p_map[i]] = po_ptr_wire[i];
      po_pvld_out[b2p_map[i]] = po_pvld_wire[i];;
  end
end

always_comb begin
  po_ptr = 0;
  po_pvld = 0;
  for (integer pop_int=0; pop_int<NUMPOPT; pop_int++) begin
    po_ptr  = po_ptr | (po_ptr_out[pop_int]<< (BITQPTR*pop_int)); 
    po_pvld = po_pvld | (po_pvld_out[pop_int] << pop_int);
  end
end
reg ready;

int ready_var;
always_comb begin
  ready = 1;
  for (ready_var=0; ready_var<NUMVBNK; ready_var=ready_var+1)
    ready = ready && ready_wire[ready_var];
end

genvar circ_var;
generate
  for (circ_var=0; circ_var<NUMVBNK; circ_var=circ_var+1) begin: a1_loop
    wire [8-1:0] rst_ofst = circ_var;
    algo_mrnw_fque #(.NUMPUPT(1), .NUMPOPT(1), .NUMADDR(NUMADDR), .BITADDR(BITADDR), .BITQPTR(BITQPTR), .QPTR_DELAY(QPTR_DELAY+FLOPECC), 
                     .BITCPAD(BITCPAD), .CPUWDTH(CPUWDTH))
    circ_inst (.push(push_wire[circ_var]), .pu_ptr(pu_ptr_wire[circ_var]), .pop(pop_bnk[circ_var]), .po_ptr(po_ptr_wire[circ_var]), .po_pvld(po_pvld_wire[circ_var]),
               .cp_read(1'b0), .cp_write(1'b0), .cp_adr({BITCPAD{1'b0}}), .cp_din({CPUWDTH{1'b0}}), .cp_vld(), .cp_dout(),
               .t1_writeA(t1_writeA_a1[circ_var]), .t1_addrA(t1_addrA_a1[circ_var]), .t1_dinA(t1_dinA_a1[circ_var]),
               .t1_readB(t1_readB_a1[circ_var]), .t1_addrB(t1_addrB_a1[circ_var]), .t1_doutB(t1_doutB_a1[circ_var]),
               .rst_ofst(rst_ofst), .freecnt(freecnt[circ_var]),
               .clk(clk), .rst(rst), .ready(ready_wire[circ_var]),
               .select_addr({BITADDR{1'b0}}));
  end
endgenerate

wire [BITQPTR-1:0] t1_doutB_a1_wire [0:NUMVBNK-1];
wire t1_fwrdB_a1_wire [0:NUMVBNK-1];
wire t1_serrB_a1_wire [0:NUMVBNK-1];
wire t1_derrB_a1_wire [0:NUMVBNK-1];
wire [BITADDR-1:0] t1_padrB_a1_wire [0:NUMVBNK-1];

genvar t1r;
generate
  for (t1r=0; t1r<NUMVBNK; t1r=t1r+1) begin: t1r_loop

    wire [QPTR_WIDTH-1:0] t1_doutB_wire = t1_doutB >> (t1r*QPTR_WIDTH);

    wire t1_mem_write_wire;
    wire [BITADDR-1:0] t1_mem_wr_adr_wire;
    wire [QPTR_WIDTH-1:0] t1_mem_bw_wire;
    wire [QPTR_WIDTH-1:0] t1_mem_din_wire;
    wire t1_mem_read_wire;
    wire [BITADDR-1:0] t1_mem_rd_adr_wire;
    wire [QPTR_WIDTH-1:0] t1_mem_rd_dout_wire;
    wire t1_mem_rd_fwrd_wire;
    wire t1_mem_rd_serr_wire;
    wire t1_mem_rd_derr_wire;
    wire [BITADDR-1:0] t1_mem_rd_padr_wire;
    if (1) begin: align_loop
      infra_align_ecc_1r1w #(.WIDTH (BITQPTR), .ENAPSDO (NUMWRDS==1), .ENAECC (1), .ECCWDTH (QPTR_WIDTH-BITQPTR), .ENAPADR (0),
                             .NUMADDR (NUMADDR/NUMVBNK), .BITADDR ((BITADDR)),
                             .NUMSROW (NUMADDR/NUMVBNK), .BITSROW (BITADDR), .NUMWRDS (NUMWRDS), .BITWRDS (BITWRDS), .BITPADR (BITADDR),
                             .SRAM_DELAY (QPTR_DELAY), .FLOPGEN (1), .FLOPMEM (0), .FLOPOUT (FLOPECC))
        infra (.write(t1_writeA_a1[t1r]), .wr_adr(t1_addrA_a1[t1r]), .din(t1_dinA_a1[t1r]),
               .read(t1_readB_a1[t1r]), .rd_adr(t1_addrB_a1[t1r]),
               .rd_dout(t1_doutB_a1[t1r]), .rd_fwrd(t1_fwrdB_a1[t1r]), .rd_serr(), .rd_derr(), .rd_padr(), 
               .mem_write (t1_mem_write_wire), .mem_wr_adr(t1_mem_wr_adr_wire), .mem_din (t1_mem_din_wire), .mem_bw(t1_mem_bw_wire),
               .mem_read (t1_mem_read_wire), .mem_rd_adr(t1_mem_rd_adr_wire), .mem_rd_dout (t1_mem_rd_dout_wire),
               .mem_rd_fwrd(t1_mem_rd_fwrd_wire), .mem_rd_padr(t1_mem_rd_padr_wire),
               .clk (clk), .rst (rst),
               .select_addr ({BITADDR{1'b0}}));
    end

    if (1) begin: stack_loop
      infra_stack_1r1w #(.WIDTH (QPTR_WIDTH), .ENAPSDO (NUMWRDS>1), .NUMADDR (NUMADDR/NUMVBNK), .BITADDR (BITADDR),
                         .NUMWROW (NUMADDR/NUMVBNK), .BITWROW (BITADDR), .NUMWBNK (1), .BITWBNK (0),
                         .SRAM_DELAY (QPTR_DELAY), .FLOPCMD (FLOPCMD), .FLOPMEM (FLOPMEM))
        infra (.write (t1_mem_write_wire), .wr_adr (t1_mem_wr_adr_wire), .bw (t1_mem_bw_wire), .din (t1_mem_din_wire),
               .read (t1_mem_read_wire), .rd_adr (t1_mem_rd_adr_wire), .rd_dout (t1_mem_rd_dout_wire),
               .rd_fwrd (t1_mem_rd_fwrd_wire), .rd_serr (t1_mem_rd_serr_wire), .rd_derr (t1_mem_rd_derr_wire), .rd_padr(t1_mem_rd_padr_wire),
               .mem_write (t1_writeA_wire[t1r]), .mem_wr_adr(t1_addrA_wire[t1r]),
               .mem_bw (t1_bwA_wire[t1r]), .mem_din (t1_dinA_wire[t1r]),
               .mem_read (t1_readB_wire[t1r]), .mem_rd_adr(t1_addrB_wire[t1r]), .mem_rd_dout (t1_doutB_wire),
               .clk (clk), .rst(rst),
               .select_addr ({BITADDR{1'd0}}));
    end
  end
endgenerate

reg [NUMVBNK-1:0] t1_writeA;
reg [NUMVBNK*BITADDR-1:0] t1_addrA;
reg [NUMVBNK*QPTR_WIDTH-1:0] t1_bwA;
reg [NUMVBNK*QPTR_WIDTH-1:0] t1_dinA;
reg [NUMVBNK-1:0] t1_readB;
reg [NUMVBNK*BITADDR-1:0] t1_addrB;
integer t1r_int;
always_comb begin
  t1_writeA = 0;
  t1_addrA = 0;
  t1_bwA = 0;
  t1_dinA = 0;
  t1_readB = 0;
  t1_addrB = 0;
  for (t1r_int=0; t1r_int<NUMVBNK; t1r_int=t1r_int+1) begin
    t1_writeA = t1_writeA | (t1_writeA_wire[t1r_int] << (t1r_int));
    t1_addrA = t1_addrA | (t1_addrA_wire[t1r_int] << (t1r_int*BITADDR));
    t1_bwA = t1_bwA | (t1_bwA_wire[t1r_int] << (t1r_int*QPTR_WIDTH));
    t1_dinA = t1_dinA | (t1_dinA_wire[t1r_int] << (t1r_int*QPTR_WIDTH));
    t1_readB = t1_readB | (t1_readB_wire[t1r_int] << (t1r_int));
    t1_addrB = t1_addrB | (t1_addrB_wire[t1r_int] << (t1r_int*BITADDR));
  end
end



endmodule
