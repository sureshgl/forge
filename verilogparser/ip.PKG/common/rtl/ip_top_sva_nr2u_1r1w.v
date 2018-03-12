module ip_top_sva_2_nr2u_1r1w
  #(
parameter     WIDTH   = 32,
parameter     ENAPSDO = 0,
parameter     NUMRUPT = 2,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     FLOPIN  = 0,
parameter     FLOPOUT  = 0,
parameter     SRAM_DELAY = 2,
parameter     UPD_DELAY = 2
   )
(
  input clk,
  input rst,
  input [NUMRUPT-1:0] ru_read,
  input [NUMRUPT*BITADDR-1:0] ru_addr,
  input [2-1:0] ru_write,

  input [NUMRUPT*NUMVBNK-1:0] t1_writeA,
  input [NUMRUPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMRUPT*NUMVBNK-1:0] t1_readB,
  input [NUMRUPT*NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMRUPT-1:0] t2_writeA,
  input [(NUMRUPT)*BITVROW-1:0] t2_addrA,
  input [(NUMRUPT)*WIDTH-1:0] t2_dinA,
  input [NUMRUPT-1:0] t2_readB,
  input [(NUMRUPT)*BITVROW-1:0] t2_addrB,
  input [NUMRUPT-1:0] t3_writeA,
  input [(NUMRUPT)*BITVROW-1:0] t3_addrA,
  input [(NUMRUPT)*(BITVBNK+1)-1:0] t3_dinA,
  input [NUMRUPT-1:0] t3_readB,
  input [(NUMRUPT)*BITVROW-1:0] t3_addrB
);

genvar ru_int;
generate for (ru_int=0; ru_int<NUMRUPT; ru_int=ru_int+1) begin: ru_loop
  wire read_wire = ru_read >> ru_int;
  wire write_wire = ru_write >> ru_int;

  wire [BITADDR-1:0] ru_addr_wire = ru_addr >> (ru_int*BITADDR);

  assert_ru_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN) !($past(!read_wire,SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN) && write_wire));
  assert_ru_range_check: assert property (@(posedge clk) disable iff (rst) read_wire |-> (ru_addr_wire < NUMADDR));
end
endgenerate

genvar t1_int;
generate for (t1_int=0; t1_int<NUMRUPT*NUMVBNK; t1_int=t1_int+1) begin: t1_loop
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITVROW-1:0] t1_addrA_wire = t1_addrA >> (t1_int*BITVROW);

  assert_t1_wr_range_check: assert property (@(posedge clk) disable iff (rst) t1_writeA_wire |-> (t1_addrA_wire < NUMVROW));

  wire t1_readB_wire = t1_readB >> t1_int;
  wire [BITVROW-1:0] t1_addrB_wire = t1_addrB >> (t1_int*BITVROW);

  assert_t1_rd_range_check: assert property (@(posedge clk) disable iff (rst) t1_readB_wire |-> (t1_addrB_wire < NUMVROW));
  assert_t1_rw_psuedo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && t1_writeA_wire && t1_readB_wire) |-> (t1_addrA_wire != t1_addrB_wire));
end
endgenerate

genvar t2_int;
generate for (t2_int=0; t2_int<NUMRUPT; t2_int=t2_int+1) begin: t2_loop
  wire t2_writeA_wire = t2_writeA >> t2_int;
  wire [BITVROW-1:0] t2_addrA_wire = t2_addrA >> (t2_int*BITVROW);
  wire [WIDTH-1:0] t2_dinA_wire = t2_dinA >> (t2_int*WIDTH);

  wire t2_writeA_0_wire = t2_writeA;
  wire [BITVROW-1:0] t2_addrA_0_wire = t2_addrA;
  wire [WIDTH-1:0] t2_dinA_0_wire = t2_dinA;

  wire t2_readB_wire = t2_readB >> t2_int;
  wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2_int*BITVROW);

  assert_t2_wr_same_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_writeA_0_wire &&
                                                                                                 (t2_addrA_0_wire == t2_addrA_wire) &&
                                                                                                 (t2_dinA_0_wire == t2_dinA_wire)));
  assert_t2_wr_range_check: assert property (@(posedge clk) disable iff (rst) t2_writeA_wire |-> (t2_addrA_wire < NUMVROW));
  assert_t2_rd_range_check: assert property (@(posedge clk) disable iff (rst) t2_readB_wire |-> (t2_addrB_wire < NUMVROW));
  assert_t2_rw_psuedo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && t2_writeA_wire && t2_readB_wire) |-> (t2_addrA_wire != t2_addrB_wire));
end
endgenerate

genvar t3_int;
generate for (t3_int=0; t3_int<NUMRUPT; t3_int=t3_int+1) begin: t3_loop
  wire t3_writeA_wire = t3_writeA >> t3_int;
  wire [BITVROW-1:0] t3_addrA_wire = t3_addrA >> (t3_int*BITVROW);
  wire [(BITVBNK+1)-1:0] t3_dinA_wire = t3_dinA >> (t3_int*(BITVBNK+1));

  wire t3_writeA_0_wire = t3_writeA;
  wire [BITVROW-1:0] t3_addrA_0_wire = t3_addrA;
  wire [(BITVBNK+1)-1:0] t3_dinA_0_wire = t3_dinA;

  wire t3_readB_wire = t3_readB >> t3_int;
  wire [BITVROW-1:0] t3_addrB_wire = t3_addrB >> (t3_int*BITVROW);

  assert_t3_wr_same_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_writeA_0_wire &&
                                                                                                 (t3_addrA_0_wire == t3_addrA_wire) &&
                                                                                                 (t3_dinA_0_wire == t3_dinA_wire)));
  assert_t3_wr_range_check: assert property (@(posedge clk) disable iff (rst) t3_writeA_wire |-> (t3_addrA_wire < NUMVROW));
  assert_t3_rd_range_check: assert property (@(posedge clk) disable iff (rst) t3_readB_wire |-> (t3_addrB_wire < NUMVROW));
  assert_t3_rw_psuedo_check: assert property (@(posedge clk) disable iff (rst) (ENAPSDO && t3_writeA_wire && t3_readB_wire) |-> (t3_addrA_wire != t3_addrB_wire));
end
endgenerate

endmodule

module ip_top_sva_nr2u_1r1w
  #(
parameter     WIDTH   = 32,
parameter     BITWDTH = 5,
parameter     ENAPAR  = 0,
parameter     ENAECC  = 0,
parameter     NUMRUPT = 2,
parameter     NUMADDR = 8192,
parameter     BITADDR = 13,
parameter     NUMVROW = 1024,
parameter     BITVROW = 10,
parameter     NUMVBNK = 8,
parameter     BITVBNK = 3,
parameter     BITPBNK = 4,
parameter     BITPADR = 14,
parameter     SRAM_DELAY = 2,
parameter     UPD_DELAY = 2,
parameter     FLOPIN = 0,
parameter     FLOPOUT = 0
   )
(
  input clk,
  input rst,
  input ready,
  input [2-1:0] ru_write,

  input [2*WIDTH-1:0] ru_din,
  input [NUMRUPT-1:0] ru_read,
  input [NUMRUPT*BITADDR-1:0] ru_addr,
  input [NUMRUPT-1:0] ru_vld,
  input [NUMRUPT*WIDTH-1:0] ru_dout,
  input [NUMRUPT-1:0] ru_fwrd,
  input [NUMRUPT-1:0] ru_serr,
  input [NUMRUPT-1:0] ru_derr,
  input [NUMRUPT*BITPADR-1:0] ru_padr,
  input [NUMRUPT*NUMVBNK-1:0] t1_writeA,
  input [NUMRUPT*NUMVBNK*BITVROW-1:0] t1_addrA,
  input [NUMRUPT*NUMVBNK*WIDTH-1:0] t1_dinA,
  input [NUMRUPT*NUMVBNK-1:0] t1_readB,
  input [NUMRUPT*NUMVBNK*BITVROW-1:0] t1_addrB,
  input [NUMRUPT*NUMVBNK*WIDTH-1:0] t1_doutB,
  input [NUMRUPT*NUMVBNK-1:0] t1_fwrdB,
  input [NUMRUPT*NUMVBNK-1:0] t1_serrB,
  input [NUMRUPT*NUMVBNK-1:0] t1_derrB,
  input [NUMRUPT*NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB,
  input [(NUMRUPT)-1:0] t2_writeA,
  input [(NUMRUPT)*BITVROW-1:0] t2_addrA,
  input [(NUMRUPT)*WIDTH-1:0] t2_dinA,
  input [(NUMRUPT)-1:0] t2_readB,
  input [(NUMRUPT)*BITVROW-1:0] t2_addrB,
  input [(NUMRUPT)*WIDTH-1:0] t2_doutB,
  input [(NUMRUPT)-1:0] t2_fwrdB,
  input [(NUMRUPT)-1:0] t2_serrB,
  input [(NUMRUPT)-1:0] t2_derrB,
  input [(NUMRUPT)*(BITPADR-BITPBNK)-1:0] t2_padrB,
  input [(NUMRUPT)-1:0] t3_writeA,
  input [(NUMRUPT)*BITVROW-1:0] t3_addrA,
  input [(NUMRUPT)*(BITVBNK+1)-1:0] t3_dinA,
  input [(NUMRUPT)-1:0] t3_readB,
  input [(NUMRUPT)*BITVROW-1:0] t3_addrB,
  input [(NUMRUPT)*(BITVBNK+1)-1:0] t3_doutB,
  input [(NUMRUPT)-1:0] t3_fwrdB,
  input [(NUMRUPT)-1:0] t3_serrB,
  input [(NUMRUPT)-1:0] t3_derrB,
  input [(NUMRUPT)*(BITPADR-BITPBNK)-1:0] t3_padrB,
  input [BITADDR-1:0] select_addr
);

  reg ready_del [0:SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY-1];
  reg [BITADDR-1:0] addr_del [0:NUMRUPT-1][0:SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY-1];
  reg read_del [0:NUMRUPT-1][0:SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY-1];

  wire [BITVBNK-1:0] select_bank;
  wire [BITVROW-1:0] select_row;
  np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
             .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
             .NUMVROW (NUMVROW), .BITVROW (BITVROW))
             adr_inst (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));

  wire                                  read_wire [0:NUMRUPT-1];
  wire                                  write_wire [0:NUMRUPT-1];
  wire [BITADDR-1:0]                    ru_addr_wire [0:NUMRUPT-1];
  wire [WIDTH-1:0]                      din_wire [0:NUMRUPT-1];
  wire                                  ru_vld_wire [0:NUMRUPT-1];
  wire [WIDTH-1:0]                      ru_dout_wire [0:NUMRUPT-1];
  wire                                  ru_fwrd_wire [0:NUMRUPT-1];
  wire                                  ru_serr_wire [0:NUMRUPT-1];
  wire                                  ru_derr_wire [0:NUMRUPT-1];
  wire [BITPADR-1:0]                    ru_padr_wire [0:NUMRUPT-1];
  genvar                                ru_int;
  generate for (ru_int=0; ru_int<NUMRUPT; ru_int=ru_int+1) begin: ru_loop
    assign read_wire[ru_int] = (ru_read & {NUMRUPT{ready}}) >> ru_int;
    assign write_wire[ru_int] = (ru_write & {NUMRUPT{ready}}) >> ru_int;
    assign ru_addr_wire[ru_int] = ru_addr >> (ru_int*BITADDR);
    assign din_wire[ru_int] = ru_din >> (ru_int*WIDTH);
    assign ru_vld_wire[ru_int] = ru_vld >> ru_int;
    assign ru_dout_wire[ru_int] = ru_dout >> (ru_int*WIDTH);
    assign ru_fwrd_wire[ru_int] = ru_fwrd >> ru_int;
    assign ru_serr_wire[ru_int] = ru_serr >> ru_int;
    assign ru_derr_wire[ru_int] = ru_derr >> ru_int;
    assign ru_padr_wire[ru_int] = ru_padr >> (ru_int*BITPADR);
  end
  endgenerate

reg meminv;
reg [WIDTH-1:0] mem;
always @(posedge clk)
  if (rst)
    meminv <= 1'b1;
  else if (t1_writeA[select_bank] && (((t1_addrA >> (select_bank*BITVROW)) & {BITVROW{1'b1}}) == select_row)) begin
    meminv <= 1'b0;
    mem <= t1_dinA >> select_bank*WIDTH;
  end

reg [BITVBNK:0] mapmem;
always @(posedge clk)
  if (rst)
    mapmem <= 0;
  else if (t3_writeA[0] && ((t3_addrA & {BITVROW{1'b1}}) == select_row))
    mapmem <= t3_dinA;

reg [WIDTH-1:0] datmem;
always @(posedge clk)
  if (!ready)
    datmem <= 0;
  else if (t2_writeA[0] && ((t2_addrA & {BITVROW{1'b1}}) == select_row))
    datmem <= t2_dinA;

wire [WIDTH-1:0] mem_wire = (mapmem[BITVBNK] && (mapmem[BITVBNK-1:0] == select_bank)) ? datmem : mem;

genvar t1_dout_int;
generate for (t1_dout_int=0; t1_dout_int<NUMRUPT; t1_dout_int=t1_dout_int+1) begin: pdout_loop
  wire t1_readB_wire = t1_readB >> (select_bank+(t1_dout_int*NUMVBNK));
  wire [BITVROW-1:0] t1_addrB_wire = t1_addrB >> ((select_bank+(t1_dout_int*NUMVBNK))*BITVROW);
  wire [WIDTH-1:0] t1_doutB_wire = t1_doutB >> ((select_bank+(t1_dout_int*NUMVBNK))*WIDTH);
  wire t1_fwrdB_wire = t1_fwrdB >> (select_bank+(t1_dout_int*NUMVBNK));
  wire t1_serrB_wire = t1_serrB >> (select_bank+(t1_dout_int*NUMVBNK));
  wire t1_derrB_wire = t1_derrB >> (select_bank+(t1_dout_int*NUMVBNK));

  assert_pdout_check: assert property (@(posedge clk) disable iff (rst) (t1_readB_wire && (t1_addrB_wire == select_row)) |-> ##SRAM_DELAY
                                       ($past(meminv,SRAM_DELAY) ||
                                       (!t1_fwrdB_wire && (ENAPAR ? t1_serrB_wire : ENAECC ? t1_derrB_wire : 0)) ||
                                       (t1_doutB_wire == $past(mem,SRAM_DELAY))));
end
endgenerate

genvar t2_dout_int;
generate for (t2_dout_int=0; t2_dout_int<NUMRUPT; t2_dout_int=t2_dout_int+1) begin: cdout_loop
  wire t2_readB_wire = t2_readB >> t2_dout_int;
  wire [BITVROW-1:0] t2_addrB_wire = t2_addrB >> (t2_dout_int*BITVROW);
  wire [WIDTH-1:0] t2_doutB_wire = t2_doutB >> (t2_dout_int*WIDTH);
  wire t2_fwrdB_wire = t2_fwrdB >> t2_dout_int;
  wire t2_serrB_wire = t2_serrB >> t2_dout_int;
  wire t2_derrB_wire = t2_derrB >> t2_dout_int;

  assert_cdout_check: assert property (@(posedge clk) disable iff (rst) (t2_readB_wire && (t2_addrB_wire == select_row)) |-> ##SRAM_DELAY
                                       (!t2_fwrdB_wire && (ENAPAR ? t2_serrB_wire : ENAECC ? t2_derrB_wire : 0)) ||
                                       (t2_doutB_wire == $past(datmem,SRAM_DELAY)));
end
endgenerate

genvar t3_dout_int;
generate for (t3_dout_int=0; t3_dout_int<NUMRUPT; t3_dout_int=t3_dout_int+1) begin: sdout_loop
  wire t3_readB_wire = t3_readB >> t3_dout_int;
  wire [BITVROW-1:0] t3_addrB_wire = t3_addrB >> (t3_dout_int*BITVROW);
  wire [BITVBNK:0] t3_doutB_wire = t3_doutB >> (t3_dout_int*(BITVBNK+1));

  assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (t3_readB_wire && (t3_addrB_wire == select_row)) |-> ##SRAM_DELAY
                                       (t3_doutB_wire == $past(mapmem,SRAM_DELAY)));
end
endgenerate

assert_wrmapa_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[0] && core.vread_reg[0][SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT-1] && (core.vrdradr_reg[0][SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT-1] == select_row)) |-> ##(SRAM_DELAY+1)
                                          (core.wrmapa_out == mapmem[BITVBNK:0]));
assert_wrmapb_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[1] && core.vread_reg[1][SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT-1] && (core.vrdradr_reg[1][SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT-1] == select_row)) |-> ##(SRAM_DELAY+1)
                                          (core.wrmapb_out == mapmem[BITVBNK:0]));

assert_wrdatb_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vwrite_wire[1] && core.vread_reg[1][SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT-1] && (core.vrdradr_reg[1][SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT-1] == select_row)) |-> ##(SRAM_DELAY+1)
                                          (core.wrdatb_out == datmem));

genvar rdm_int;
generate for (rdm_int=0; rdm_int<NUMRUPT; rdm_int=rdm_int+1) begin: rdm_loop
  wire t1_fwrdB_wire = t1_fwrdB >> (select_bank+(rdm_int*NUMVBNK));
  wire t1_serrB_wire = t1_serrB >> (select_bank+(rdm_int*NUMVBNK));
  wire t1_derrB_wire = t1_derrB >> (select_bank+(rdm_int*NUMVBNK));

  wire t2_fwrdB_wire = t2_fwrdB >> rdm_int;
  wire t2_serrB_wire = t2_serrB >> rdm_int;
  wire t2_derrB_wire = t2_derrB >> rdm_int;

  assert_rdmap_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[rdm_int] && (core.vrdradr_wire[rdm_int] == select_row)) |-> ##SRAM_DELAY
                                           (core.vdo_loop[rdm_int].rdmap_out == mapmem[BITVBNK:0]));
  assert_rcdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[rdm_int] && (core.vrdradr_wire[rdm_int] == select_row)) |-> ##SRAM_DELAY
                                           (!t2_fwrdB_wire && !core.rcdat_vld[rdm_int][SRAM_DELAY-1] &&
                                            (ENAPAR ? t2_serrB_wire : ENAECC ? t2_derrB_wire : 1'b0)) ||
                                           (core.vdo_loop[rdm_int].rcdat_out == datmem));
  assert_rpdat_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.vread_wire[rdm_int] && (core.vrdbadr_wire[rdm_int] == select_bank) && (core.vrdradr_wire[rdm_int] == select_row)) |-> ##SRAM_DELAY
                                           (meminv || (!t1_fwrdB_wire && !core.rpdat_vld[rdm_int][SRAM_DELAY-1] &&
                                                       (ENAPAR ? t1_serrB_wire : ENAECC ? t1_derrB_wire : 1'b0)) ||
                                           (core.vdo_loop[rdm_int].rpdat_out == mem)));

end
endgenerate

reg rmeminv;
reg [WIDTH-1:0] rmem;
always @(posedge clk)
  if (rst)
    rmeminv <= 1'b1;
  else if (core.vwriteb_out && (core.vwrbadrb_out == select_bank) && (core.vwrradrb_out == select_row)) begin
    rmeminv <= 1'b0;
    rmem <= core.vdinb_out;
  end else if (core.vwritea_out && (core.vwrbadra_out == select_bank) && (core.vwrradra_out == select_row)) begin
    rmeminv <= 1'b0;
    rmem <= core.vdina_out;
  end else if (core.write_old_b_to_pivot && (core.swroldb_map == select_bank) && (core.vwrradrb_out == select_row) &&
               (ENAPAR ? core.cserrwb_reg : ENAECC ? core.cderrwb_reg : 1'b0))
    rmeminv <= 1'b1;

assert_rmem_check: assert property (@(posedge clk) disable iff (rst) (rmeminv || (mem_wire == rmem)));

  integer adrp_int, adrd_int;
  always @(posedge clk)
    for (adrp_int=0; adrp_int<NUMRUPT; adrp_int=adrp_int+1)
      for (adrd_int=0; adrd_int<SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY; adrd_int=adrd_int+1)
        if (rst) begin
          read_del[adrp_int][adrd_int] <= 0;
          addr_del[adrp_int][adrd_int] <= 0;
          ready_del[adrd_int] <= 0; 
        end else if (adrd_int>0) begin
          read_del[adrp_int][adrd_int] <= read_del[adrp_int][adrd_int-1];
          addr_del[adrp_int][adrd_int] <= addr_del[adrp_int][adrd_int-1];
          ready_del[adrd_int] <= ready_del[adrd_int-1];
        end else begin
          read_del[adrp_int][adrd_int] <= read_wire[adrp_int];
          addr_del[adrp_int][adrd_int] <= ru_addr_wire[adrp_int];
          ready_del[adrd_int] <= ready;
        end

  reg [WIDTH-1:0] fakemem;
  reg fakememinv;
  integer fake_int;
  always @(posedge clk)
    if (rst) begin
      fakememinv <= 1'b1;
      fakemem <= 0;
    end else for (fake_int=0; fake_int<NUMRUPT; fake_int=fake_int+1) begin
      if (write_wire[fake_int] && read_del[fake_int][FLOPIN+SRAM_DELAY+FLOPOUT+UPD_DELAY-1] && (addr_del[fake_int][FLOPIN+SRAM_DELAY+FLOPOUT+UPD_DELAY-1]==select_addr)) begin
        fakememinv <= 1'b0;
        fakemem <= din_wire[fake_int];
      end
    end

  assert_fakemem_check: assert property (@(posedge clk) disable iff (rst || !ready) 1'b1 |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+1)
                                             ($past(fakememinv,FLOPIN+SRAM_DELAY+1) || ($past(fakemem,FLOPIN+SRAM_DELAY+1) == mem_wire)));

  reg [WIDTH-1:0] t1_doutB_sel_wire [0:NUMRUPT-1];
  reg [WIDTH-1:0] t2_doutB_sel_wire [0:NUMRUPT-1];
  genvar ru_dout_int;
  generate for (ru_dout_int=0; ru_dout_int<NUMRUPT; ru_dout_int=ru_dout_int+1) begin: ru_dout_loop
  wire t1_fwrdB_sel_wire = t1_fwrdB >>  (NUMVBNK*ru_dout_int+select_bank);
  wire t1_serrB_sel_wire = t1_serrB >>  (NUMVBNK*ru_dout_int+select_bank);
  wire t1_derrB_sel_wire = t1_derrB >>  (NUMVBNK*ru_dout_int+select_bank);
  wire [BITPADR-BITPBNK-1:0] t1_padrB_sel_wire = t1_padrB >> ((NUMVBNK*ru_dout_int+select_bank)*(BITPADR-BITPBNK));

  wire t2_fwrdB_sel_wire = t2_fwrdB >> ru_dout_int;
  wire t2_serrB_sel_wire = t2_serrB >> ru_dout_int;
  wire t2_derrB_sel_wire = t2_derrB >> ru_dout_int;
  wire [BITPADR-BITPBNK-1:0] t2_padrB_sel_wire = t2_padrB >> (ru_dout_int*(BITPADR-BITPBNK));

  assert_vdout_int_check: assert property (@(posedge clk) disable iff (rst) (read_wire[ru_dout_int] && (ru_addr_wire[ru_dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY)
                                           (rmeminv || (!core.vread_fwrd_int[ru_dout_int] && (ENAPAR ? ru_serr_wire[ru_dout_int] : ENAECC ? ru_derr_wire[ru_dout_int] : 1'b0)) ||
                                           (core.vdout_int[ru_dout_int] == rmem)));
  assert_dout_check: assert property (@(posedge clk) disable iff (!ready) (read_wire[ru_dout_int] && (ru_addr_wire[ru_dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (ru_vld_wire[ru_dout_int] && ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                                       (!ru_fwrd_wire[ru_dout_int] && (ENAPAR ? ru_serr_wire[ru_dout_int] : ENAECC ? ru_derr_wire[ru_dout_int] : 1'b0)) ||
                                                       (ru_dout_wire[ru_dout_int] == $past(fakemem,FLOPIN+SRAM_DELAY+FLOPOUT)))));
  assert_fwrd_check: assert property (@(posedge clk) disable iff (rst) (read_wire[ru_dout_int] && (ru_addr_wire[ru_dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                       $past(fakemem==mem_wire,FLOPIN+SRAM_DELAY+FLOPOUT) || ru_fwrd_wire[ru_dout_int]) &&
                                      (ru_fwrd_wire[ru_dout_int] || !((ru_padr_wire[ru_dout_int][BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) ?
                                                         (FLOPOUT ? $past(t2_fwrdB_sel_wire) : t2_fwrdB_sel_wire) :
                                                         (FLOPOUT ? $past(t1_fwrdB_sel_wire) : t1_fwrdB_sel_wire))));
  assert_derr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[ru_dout_int] && (ru_addr_wire[ru_dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      ($past(fakememinv,FLOPIN+SRAM_DELAY+FLOPOUT) ||
                                      (((ru_padr_wire[ru_dout_int][BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) ?
                                        (ru_serr_wire[ru_dout_int] == (FLOPOUT ? $past(t2_serrB_sel_wire) : t2_serrB_sel_wire)) :
                                        (ru_serr_wire[ru_dout_int] == (FLOPOUT ? $past(t1_serrB_sel_wire) : t1_serrB_sel_wire))) &&
                                       ((ru_padr_wire[ru_dout_int][BITPADR-1:BITPADR-BITPBNK] == NUMVBNK) ?
                                        (ru_derr_wire[ru_dout_int] == (FLOPOUT ? $past(t2_derrB_sel_wire) : t2_derrB_sel_wire)) :
                                        (ru_derr_wire[ru_dout_int] == (FLOPOUT ? $past(t1_derrB_sel_wire) : t1_derrB_sel_wire))))));
  assert_padr_check: assert property (@(posedge clk) disable iff (rst) (read_wire[ru_dout_int] && (ru_addr_wire[ru_dout_int] == select_addr)) |-> ##(FLOPIN+SRAM_DELAY+FLOPOUT)
                                      (ru_padr_wire[ru_dout_int] == ((NUMVBNK << (BITPADR-BITPBNK)) | (FLOPOUT ? $past(t2_padrB_sel_wire) : t2_padrB_sel_wire))) ||
                                      (ru_padr_wire[ru_dout_int] == {select_bank,(FLOPOUT ? $past(t1_padrB_sel_wire) : t1_padrB_sel_wire)}));

end
endgenerate

endmodule


