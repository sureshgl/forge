module ip_top_sva_2_smurf_2rw
  #(
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     WIDTH = 16,
parameter     NUMRWPT = 2)
(
  input clk,
  input rst,
  input [NUMRWPT-1:0]              rw_read,
  input [NUMRWPT*BITADDR-1:0]      rw_addr,
  input [NUMRWPT-1:0]              rw_write,
  input                            t1_readA,
  input                            t1_writeA, 
  input [WIDTH-1:0]                t1_dinA,
  input [BITADDR-1:0]              t1_addrA,
  input                            t1_readB,
  input                            t1_writeB, 
  input [WIDTH-1:0]                t1_dinB,
  input [BITADDR-1:0]              t1_addrB
);

`ifdef FORMAL
//synopsys translate_off

genvar wr_int;
generate for (wr_int=0; wr_int<NUMRWPT; wr_int=wr_int+1) begin: wr_loop
  wire write_wire = rw_write >> wr_int;
  wire [BITADDR-1:0] wr_adr_wire = rw_addr >> (wr_int*BITADDR);

  assert_wr_range_check: assume property (@(posedge clk) disable iff (rst) write_wire |-> (wr_adr_wire < NUMADDR));
  assert_rd_wr_check: assume property (@(posedge clk) disable iff (rst) !(rw_write[wr_int] && rw_read[wr_int]));
end
endgenerate

genvar t1_vbnk_int, t1_prpt_int;

genvar rd_int;
generate for (rd_int=0; rd_int<NUMRWPT; rd_int=rd_int+1) begin: rd_loop
  wire read_wire = rw_read >> rd_int;
  wire [BITADDR-1:0] rd_adr_wire = rw_addr >> (rd_int*BITADDR);

  assert_rd_range_check: assume property (@(posedge clk) disable iff (rst) read_wire |-> (rd_adr_wire < NUMADDR));
end
endgenerate


//    assert_t1_1portA_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA && t1_writeA));
//    assert_t1_1portB_check: assert property (@(posedge clk) disable iff (rst) !(t1_readB && t1_writeB));

//synopsys translate_on
`endif
endmodule

module ip_top_sva_smurf_2rw
#(
  parameter WIDTH = 16,
  parameter NUMRWPT = 2,
  parameter NUMADDR  = 1024,
  parameter BITADDR  = 10,
  parameter BITWDTH  = 10,
  parameter SRAM_DELAY = 1,
  parameter FLOPIN    = 0,
  parameter FLOPOUT   = 0
)
(
  input clk,
  input rst,
  input [NUMRWPT-1:0] rw_read,
  input [NUMRWPT-1:0] rw_write,
  input [NUMRWPT*BITADDR-1:0] rw_addr,
  input [NUMRWPT*WIDTH-1:0] rw_dout,
  input [NUMRWPT-1:0] rw_vld,
  input [NUMRWPT*WIDTH-1:0] rw_din,
  input [NUMRWPT*WIDTH-1:0] rw_bw,
  input t1_readA,
  input t1_writeA,
  input [BITADDR-1:0] t1_addrA,
  input [WIDTH-1:0]  t1_dinA,
  input [WIDTH-1:0]  t1_bwA,
  input [WIDTH-1:0] t1_doutA,

  input t1_readB,
  input t1_writeB,
  input [BITADDR-1:0] t1_addrB,
  input [WIDTH-1:0]   t1_dinB,
  input [WIDTH-1:0]   t1_bwB,
  input [WIDTH-1:0]    t1_doutB,
  input [BITADDR-1:0] select_addr,
  input [BITWDTH-1:0] select_bit
);
`ifdef FORMAL
//synopsys translate_off

wire [BITADDR-1:0] wr_adr_wire [0:NUMRWPT-1];
wire [WIDTH-1:0]   wr_din_wire [0:NUMRWPT-1];
wire [WIDTH-1:0]   bw_wire [0:NUMRWPT-1];
genvar wr_var;
generate for (wr_var=0; wr_var<NUMRWPT; wr_var=wr_var+1) begin : w_loop
  assign bw_wire[wr_var]     = rw_bw[WIDTH*(wr_var+1)-1:WIDTH*wr_var]; 
  assign wr_adr_wire[wr_var] = rw_addr[BITADDR*(wr_var+1)-1: BITADDR*wr_var];
  assign wr_din_wire[wr_var] = rw_din[WIDTH*(wr_var+1)-1:WIDTH*wr_var];
end
endgenerate

reg meminv;
reg mem;
always @(posedge clk) 
  if(rst)
    meminv <= 1'b1;
  else begin 
    if(t1_writeA && t1_bwA[select_bit] && (t1_addrA == select_addr)) begin
      meminv <= 1'b0;
      mem <= t1_dinA[select_bit];
    end
    if(t1_writeB && t1_bwB[select_bit] && (t1_addrB == select_addr)) begin
      meminv <= 1'b0;
      mem <= t1_dinB[select_bit];
    end
  end

generate if (SRAM_DELAY >0) begin :dp_loop
assert_pdoutA_check: assert property (@(posedge clk) disable iff (rst)
				       (t1_readA && (t1_addrA == select_addr)) |-> ##SRAM_DELAY
                                       ($past(meminv,SRAM_DELAY) || (t1_doutA[select_bit] == $past(mem,SRAM_DELAY))));
assert_pdoutB_check: assert property (@(posedge clk) disable iff (rst)
				       (t1_readB && (t1_addrB == select_addr)) |-> ##SRAM_DELAY
                                       ($past(meminv,SRAM_DELAY) || (t1_doutB[select_bit] == $past(mem,SRAM_DELAY))));
end else begin : ndp_loop
assert_pdoutA_check: assert property (@(posedge clk) disable iff (rst)
				       (t1_readA && (t1_addrA == select_addr)) |-> ##SRAM_DELAY
                                       (meminv || (t1_doutA[select_bit] == mem)));
assert_pdoutB_check: assert property (@(posedge clk) disable iff (rst)
				       (t1_readB && (t1_addrB == select_addr)) |-> ##SRAM_DELAY
                                       (meminv || (t1_doutB[select_bit] == mem)));
end 
endgenerate

reg fakememinv;
reg fakemem;
always @(posedge clk)
  if (rst) 
    fakememinv <= 1'b1;
  else  begin
    for (integer w_int =0 ;w_int <NUMRWPT; w_int=w_int+1) 
      if (rw_write[w_int] && bw_wire[w_int][select_bit] && (wr_adr_wire[w_int] == select_addr)) begin
        fakememinv <= 1'b0;
        fakemem <= wr_din_wire[w_int][select_bit];
      end
  end

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##1
					   (fakememinv || fakemem == mem));

genvar doutr_int;
generate for (doutr_int=0; doutr_int<NUMRWPT; doutr_int=doutr_int+1) begin: doutr_loop
  wire read_wire = rw_read >> doutr_int;
  wire [BITADDR-1:0] rd_adr_wire = rw_addr >> (doutr_int*BITADDR);
  wire rd_vld_wire = rw_vld >> doutr_int;
  wire [WIDTH-1:0] rd_dout_wire = rw_dout >> (doutr_int*WIDTH);

  if(FLOPIN+SRAM_DELAY+FLOPOUT>0) begin : dly_loop
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire && (rd_adr_wire == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                                       ((rd_vld_wire == 1'b1) && (rd_dout_wire[select_bit] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)))));
  end else begin : ndly_loop
  assert_dout_check: assert property (@(posedge clk) disable iff (rst) (read_wire && (rd_adr_wire == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (fakememinv || ((rd_vld_wire==1'b1) && (rd_dout_wire[select_bit] == fakemem))));
  end
end
endgenerate
//synopsys translate_on
`endif

endmodule
