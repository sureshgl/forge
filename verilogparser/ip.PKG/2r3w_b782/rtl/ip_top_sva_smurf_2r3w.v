module ip_top_sva_2_smurf_2r3w
  #(
parameter     NUMADDR = 1024,
parameter     BITADDR = 10,
parameter     NUMWRPRT = 1,
parameter     NUMRDPRT = 1)
(
  input clk,
  input rst,
  input [NUMRDPRT-1:0]             read,
  input [NUMRDPRT*BITADDR-1:0]     rd_adr,
  input [NUMWRPRT-1:0]             write,
  input [NUMWRPRT*BITADDR-1:0]     wr_adr,
  input                            t1_readD,
  input [BITADDR-1:0]              t1_addrD,
  input                            t1_readE,
  input [BITADDR-1:0]              t1_addrE,
  input                            t1_writeA, 
  input [BITADDR-1:0]              t1_addrA,
  input                            t1_writeB, 
  input [BITADDR-1:0]              t1_addrB,
  input                            t1_writeC, 
  input [BITADDR-1:0]              t1_addrC
);

`ifdef FORMAL
//synopsys translate_off
genvar wr_int;
generate for (wr_int=0; wr_int<NUMWRPRT; wr_int=wr_int+1) begin: wr_loop
  wire write_wire = write >> wr_int;
  wire [BITADDR-1:0] wr_adr_wire = wr_adr >> (wr_int*BITADDR);

  assert_wr_range_check: assume property (@(posedge clk) disable iff (rst) write_wire |-> (wr_adr_wire < NUMADDR));
end
endgenerate

genvar t1_vbnk_int, t1_prpt_int;

genvar rd_int;
generate for (rd_int=0; rd_int<NUMRDPRT; rd_int=rd_int+1) begin: rd_loop
  wire read_wire = read >> rd_int;
  wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (rd_int*BITADDR);

  assert_rd_range_check: assume property (@(posedge clk) disable iff (rst) read_wire |-> (rd_adr_wire < NUMADDR));
end
endgenerate


//synopsys translate_on
`endif
endmodule

module ip_top_sva_smurf_2r3w
#(
  parameter WIDTH = 16,
  parameter BITWDTH = 4,
  parameter NUMRDPRT = 1,
  parameter NUMWRPRT = 1,
  parameter NUMADDR  = 1024,
  parameter BITADDR  = 10,
  parameter SRAM_DELAY = 1,
  parameter FLOPIN    = 0,
  parameter FLOPOUT   = 0
)
(
  input clk,
  input rst,
  input [NUMRDPRT-1:0] read,
  input [NUMRDPRT*BITADDR-1:0] rd_adr,
  input [NUMRDPRT*WIDTH-1:0] rd_dout,
  input [NUMRDPRT-1:0] rd_vld,
  input [NUMWRPRT-1:0] write,
  input [NUMWRPRT*BITADDR-1:0] wr_adr,
  input [NUMWRPRT*WIDTH-1:0] din,
  input [NUMWRPRT*WIDTH-1:0] bw,
  input t1_writeA,
  input [WIDTH-1:0] t1_dinA,
  input [WIDTH-1:0] t1_bwA,
  input [BITADDR-1:0] t1_addrA,
  input t1_writeB,
  input [WIDTH-1:0] t1_dinB,
  input [WIDTH-1:0] t1_bwB,
  input [BITADDR-1:0] t1_addrB,
  input t1_writeC,
  input [WIDTH-1:0] t1_dinC,
  input [WIDTH-1:0] t1_bwC,
  input [BITADDR-1:0] t1_addrC,
  input t1_readD,
  input [WIDTH-1:0] t1_doutD,
  input [BITADDR-1:0] t1_addrD,
  input t1_readE,
  input [WIDTH-1:0] t1_doutE,
  input [BITADDR-1:0] t1_addrE,
  input [BITADDR-1:0] select_addr,
  input [BITWDTH-1:0] select_bit
);
`ifdef FORMAL
//synopsys translate_off

wire [BITADDR-1:0] wr_adr_wire [0:NUMWRPRT-1];
wire [WIDTH-1:0]   wr_din_wire [0:NUMWRPRT-1];
wire [WIDTH-1:0]   bw_wire [0:NUMWRPRT-1];
genvar wr_var;
generate for (wr_var=0; wr_var<NUMWRPRT; wr_var=wr_var+1) begin : w_loop
  assign bw_wire[wr_var]     = bw[WIDTH*(wr_var+1)-1:WIDTH*wr_var]; 
  assign wr_adr_wire[wr_var] = wr_adr[BITADDR*(wr_var+1)-1: BITADDR*wr_var];
  assign wr_din_wire[wr_var] = din[WIDTH*(wr_var+1)-1:WIDTH*wr_var];
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
    if(t1_writeC && t1_bwC[select_bit] && (t1_addrC == select_addr)) begin
      meminv <= 1'b0;
      mem <= t1_dinC[select_bit];
    end
  end

generate if (SRAM_DELAY>0) begin : pd_loop
assert_pdoutD_check: assert property (@(posedge clk) disable iff (rst)
				       (t1_readD && (t1_addrD == select_addr)) |-> ##SRAM_DELAY
                                       ($past(meminv,SRAM_DELAY) || (t1_doutD[select_bit] == $past(mem,SRAM_DELAY))));
assert_pdoutE_check: assert property (@(posedge clk) disable iff (rst)
				       (t1_readE && (t1_addrE == select_addr)) |-> ##SRAM_DELAY
                                       ($past(meminv,SRAM_DELAY) || (t1_doutE[select_bit] == $past(mem,SRAM_DELAY))));
end else begin : npd_loop
assert_pdoutD_check: assert property (@(posedge clk) disable iff (rst)
				       (t1_readD && (t1_addrD == select_addr)) |-> ##SRAM_DELAY
                                       (meminv || (t1_doutD[select_bit] == mem)));
assert_pdoutE_check: assert property (@(posedge clk) disable iff (rst)
				       (t1_readE && (t1_addrE == select_addr)) |-> ##SRAM_DELAY
                                       (meminv || (t1_doutE[select_bit] == mem)));
end
endgenerate

reg fakememinv;
reg fakemem;
always @(posedge clk)
  if (rst) 
    fakememinv <= 1'b1;
  else  begin
    for (integer w_int =0 ;w_int <NUMWRPRT; w_int=w_int+1) 
      if (write[w_int] && bw_wire[w_int][select_bit] && (wr_adr_wire[w_int] == select_addr)) begin
        fakememinv <= 1'b0;
        fakemem <= wr_din_wire[w_int][select_bit];
      end
  end

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##1
					   (fakememinv || fakemem == mem));

genvar doutr_int;
generate for (doutr_int=0; doutr_int<NUMRDPRT; doutr_int=doutr_int+1) begin: doutr_loop
  wire read_wire = read >> doutr_int;
  wire [BITADDR-1:0] rd_adr_wire = rd_adr >> (doutr_int*BITADDR);
  wire rd_vld_wire = rd_vld >> doutr_int;
  wire [WIDTH-1:0] rd_dout_wire = rd_dout >> (doutr_int*WIDTH);

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
