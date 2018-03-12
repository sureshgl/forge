module ip_top_sva_2_2rw_rl_edram_del
  #(
parameter WIDTH   = 32,
parameter BITWDTH = 5,
parameter NUMADDR = 8192,
parameter BITADDR = 13,
parameter NUMVBNK = 8,
parameter BITVBNK = 3,
parameter NUMVROW = 1024,
parameter BITVROW = 10,
parameter NUMMBNK = 8,
parameter BITMBNK = 3,
parameter NUMMROW = 256,
parameter BITMROW = 8, 
parameter ECCBITS = 4,
parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS
   )
(
  input clk,
  input rst,
  input ready,
  input vrefr,
  input vread,
  input vwrite,
  input [BITADDR-1:0] vaddr,
  input [WIDTH-1:0] vdin,
  input pwrite,
  input [BITVBNK-1:0] pwrbadr,
  input [BITVROW-1:0] pwrradr,
  input pread1,
  input [BITVBNK-1:0] prdbadr1,
  input [BITVROW-1:0] prdradr1,
  input pread2,
  input [BITVBNK-1:0] prdbadr2,
  input [BITVROW-1:0] prdradr2,
  input prefr,
  input [BITVBNK-1:0] prfbadr,
  input swrite,
  input [BITVROW-1:0] swrradr,
  input sread,
  input [BITVROW-1:0] srdradr,
  input cwrite,
  input [BITVROW-1:0] cwrradr,
  input cread,
  input [BITVROW-1:0] crdradr
);

//  assert_refr2_check: assert property (@(posedge clk) disable iff (!ready) !vrefr ##1 vrefr |-> ##1 vrefr);
  assert_rw_1p_check: assert property (@(posedge clk) disable iff (rst) !(vread && vwrite) && !(vrefr && vread) && !(vrefr && vwrite)); 
  assert_rw_range_check: assert property (@(posedge clk) disable iff (rst) (vread || vwrite) |-> (vaddr < NUMADDR));
/*
  assert_phi_no_check: assert property (@(posedge clk) disable iff (rst) ((core.vrefr1 || core.vrefr2) && !core.wrfifo_deq1 && !core.vread1 && !core.vread2) |-> ##1
					((prefr && (!core.phigh || (prfbadr == core.phibadr))) ||
					 $past(prefr && (!core.phigh || (prfbadr == core.phibadr)))));
  assert_phi_rf_check: assert property (@(posedge clk) disable iff (rst) (core.vrefr1 && core.vrefr2) |-> ##1
					((prefr && (!core.phigh || (prfbadr == core.phibadr))) ||
					 $past(prefr && (!core.phigh || (prfbadr == core.phibadr)))));
  assert_phi_wr1_check: assert property (@(posedge clk) disable iff (rst) (core.vrefr2 && core.wrfifo_deq1) |-> ##1
				         ((prefr && (!core.phigh || (prfbadr == core.phibadr))) ||
				          $past(prefr && (!core.phigh || (prfbadr == core.phibadr)))));
  assert_phi_wr2_check: assert property (@(posedge clk) disable iff (rst) (core.vrefr1 && core.wrfifo_deq1) |-> ##1
				         ((prefr && (!core.phigh || (prfbadr == core.phibadr))) ||
				          $past(prefr && (!core.phigh || (prfbadr == core.phibadr)))));
  assert_phi_rd_check: assert property (@(posedge clk) disable iff (rst) ((core.vrefr1 || core.vrefr2) && (core.vread1 || core.vread2)) |-> ##1
				        ((prefr && (!core.phigh || (prfbadr == core.phibadr))) ||
			         $past(prefr && (!core.phigh || (prfbadr == core.phibadr)))));
  assert_phi_req_check: assert property (@(posedge clk) disable iff (rst) core.request |-> ##1
					 ((!core.refresh_module.norefr || core.prefr) ||
					  $past(!core.refresh_module.norefr || core.prefr)));
*/
  assert_prw_check: assert property (@(posedge clk) disable iff (rst) !((pread1 || pread2) && pwrite));
  assert_prf_range_check: assert property (@(posedge clk) disable iff (rst) prefr |-> (prfbadr < NUMVBNK));
  assert_prf_bank_check: assert property (@(posedge clk) disable iff (rst) prefr |-> ##1
					   !(prefr && (prfbadr == $past(prfbadr))) &&
					   !(pread1 && (prdbadr1 == $past(prfbadr))) && 
					   !(pread2 && (prdbadr2 == $past(prfbadr))) && 
					   !(pwrite && (pwrbadr == $past(prfbadr))));  
  assert_prd1_range_check: assert property (@(posedge clk) disable iff (rst) pread1 |-> (prdbadr1 < NUMVBNK) && (prdradr1 < NUMVROW));
  assert_prd1_bank_check: assert property (@(posedge clk) disable iff (rst) pread1 |-> ##1
					   !(prefr && (prfbadr == $past(prdbadr1))) &&
					   !(pread1 && (prdbadr1 == $past(prdbadr1))) && 
					   !(pread2 && (prdbadr2 == $past(prdbadr1))) && 
					   !(pwrite && (pwrbadr == $past(prdbadr1))));  
  assert_prd2_range_check: assert property (@(posedge clk) disable iff (rst) pread2 |-> (prdbadr2 < NUMVBNK) && (prdradr2 < NUMVROW));
  assert_prd2_bank_check: assert property (@(posedge clk) disable iff (rst) pread2 |-> ##1
					   !(prefr && (prfbadr == $past(prdbadr2))) &&
					   !(pread1 && (prdbadr1 == $past(prdbadr2))) && 
					   !(pread2 && (prdbadr2 == $past(prdbadr2))) && 
					   !(pwrite && (pwrbadr == $past(prdbadr2))));  
  assert_pwr_range_check: assert property (@(posedge clk) disable iff (rst) pwrite |-> (pwrbadr < NUMVBNK) && (pwrradr < NUMVROW));
  assert_pwr_curr_check: assert property (@(posedge clk) disable iff (rst) pwrite |->
					   !(prefr && (prfbadr == pwrbadr)) &&
					   !(pread1 && (prdbadr1 == pwrbadr)) && 
					   !(pread2 && (prdbadr2 == pwrbadr)));
  assert_pwr_bank_check: assert property (@(posedge clk) disable iff (rst) pwrite |-> ##1
					   !(prefr && (prfbadr == $past(pwrbadr))) &&
					   !(pread1 && (prdbadr1 == $past(pwrbadr))) && 
					   !(pread2 && (prdbadr2 == $past(pwrbadr))) && 
					   !(pwrite && (pwrbadr == $past(pwrbadr))));  
  assert_prd12_check: assert property (@(posedge clk) disable iff (rst) (pread1 && pread2) |-> (prdbadr1 == prdbadr2) && (!prefr || (prfbadr != prdbadr1)));
  assert_prf1_check: assert property (@(posedge clk) disable iff (rst) (prefr && pread1) |-> (prfbadr != prdbadr1));
  assert_prf2_check: assert property (@(posedge clk) disable iff (rst) (prefr && pread2) |-> (prfbadr != prdbadr2));

/*
genvar t1_int;
generate for (t1_int=0; t1_int<1; t1_int=t1_int+1) begin: t1_loop
  wire t1_readA_wire = t1_readA >> t1_int;
  wire t1_writeA_wire = t1_writeA >> t1_int;
  wire [BITVBNK+BITMROW-1:0] t1_addrA_wire = t1_addrA >> (t1_int*(BITVBNK+BITMROW));
  wire [BITVBNK-1:0] t1_vbnkA_wire = t1_addrA_wire >> BITMROW;
  wire [BITMROW-1:0] t1_mrowA_wire = t1_addrA_wire; 
  wire t1_refrB_wire = t1_refrB >> t1_int;
  wire [BITVBNK-1:0] t1_vbnkB_wire = t1_bankB >> (t1_int*BITVBNK);

  assert_t1_rw_1p_check: assert property (@(posedge clk) disable iff (rst) !(t1_readA_wire && t1_writeA_wire));
  assert_t1_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire || t1_writeA_wire) |->
					     (t1_vbnkA_wire < NUMVBNK) && (t1_mrowA_wire < NUMMROW));
  assert_t1_rf_range_check: assert property (@(posedge clk) disable iff (rst) t1_refrB_wire |-> (t1_vbnkB_wire < NUMVBNK));
  assert_t1_rw_bank_check: assert property (@(posedge clk) disable iff (rst) (t1_readA_wire || t1_writeA_wire) |-> ##1
					    !(t1_refrB_wire && (t1_vbnkB_wire == $past(t1_vbnkA_wire))) &&
					    !((t1_readA_wire || t1_writeA_wire) && (t1_vbnkA_wire == $past(t1_vbnkA_wire))));
  assert_t1_rf_bank_check: assert property (@(posedge clk) disable iff (rst) t1_refrB_wire |-> ##1
					    !(t1_refrB_wire && (t1_vbnkB_wire == $past(t1_vbnkB_wire))) &&
					    !((t1_readA_wire || t1_writeA_wire) && (t1_vbnkA_wire == $past(t1_vbnkB_wire))));
  assert_t1_rfrw_check: assert property (@(posedge clk) disable iff (rst) (t1_refrB_wire && (t1_readA_wire || t1_writeA_wire)) |->
					 (t1_vbnkB_wire != t1_vbnkA_wire));
end
endgenerate

genvar t2_int;
generate for (t2_int=0; t2_int<1; t2_int=t2_int+1) begin: t2_loop
  wire t2_readA_wire = t2_readA >> t2_int;
  wire t2_writeA_wire = t2_writeA >> t2_int;
  wire [BITVBNK+BITMROW-1:0] t2_addrA_wire = t2_addrA >> (t2_int*(BITVBNK+BITMROW));
  wire [BITVBNK-1:0] t2_vbnkA_wire = t2_addrA_wire >> BITMROW;
  wire [BITMROW-1:0] t2_mrowA_wire = t2_addrA_wire; 

  assert_t2_rw_1p_check: assert property (@(posedge clk) disable iff (rst) !(t2_readA_wire && t2_writeA_wire));
  assert_t2_rw_range_check: assert property (@(posedge clk) disable iff (rst) (t2_readA_wire || t2_writeA_wire) |->
					     (t2_vbnkA_wire < NUMVBNK) && (t2_mrowA_wire < NUMMROW));
end
endgenerate
*/

  assert_swr_range_check: assert property (@(posedge clk) disable iff (rst) swrite |-> (swrradr < NUMVROW));
  assert_srd_range_check: assert property (@(posedge clk) disable iff (rst) sread |-> (srdradr < NUMVROW));
  assert_srw_psuedo_check: assert property (@(posedge clk) disable iff (rst) (swrite && sread) |-> (swrradr != srdradr));

  assert_cwr_range_check: assert property (@(posedge clk) disable iff (rst) cwrite |-> (cwrradr < NUMVROW));
  assert_crd_range_check: assert property (@(posedge clk) disable iff (rst) cread |-> (crdradr < NUMVROW));
  assert_crw_psuedo_check: assert property (@(posedge clk) disable iff (rst) (cwrite && cread) |-> (cwrradr != crdradr));

endmodule

module ip_top_sva_2rw_rl_edram_del
  #(
parameter WIDTH   = 32,
parameter BITWDTH = 5,
parameter NUMADDR = 8192,
parameter BITADDR = 13,
parameter NUMVROW = 1024,
parameter BITVROW = 10,
parameter NUMVBNK = 8,
parameter BITVBNK = 3,
parameter BITPADR = 14,
parameter ECCBITS = 4,
parameter SRAM_DELAY = 2,
parameter DRAM_DELAY = 2,
parameter FLOPIN = 0,
parameter FLOPOUT = 0,
parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS,
parameter FIFOCNT = 2*SRAM_DELAY+2
   )
(
  input clk,
  input rst,
  input vread,
  input vwrite,
  input [BITADDR-1:0] vaddr,
  input [WIDTH-1:0] vdin,
  input vread_vld,
  input [WIDTH-1:0] vdout,
  input vread_serr,
  input vread_derr,
  input [BITPADR-1:0] vread_padr,
  input pwrite,
  input [BITVBNK-1:0] pwrbadr,
  input [BITVROW-1:0] pwrradr,
  input [WIDTH-1:0] pdin,
  input pread1,
  input [BITVBNK-1:0] prdbadr1,
  input [BITVROW-1:0] prdradr1,
  input [WIDTH-1:0] pdout1,
  input pdout1_serr,
  input pread2,
  input [BITVBNK-1:0] prdbadr2,
  input [BITVROW-1:0] prdradr2,
  input [WIDTH-1:0] pdout2,
  input pdout2_serr,
  input swrite,
  input [BITVROW-1:0] swrradr,
  input [SDOUT_WIDTH-1:0] sdin,
  input sread,
  input [BITVROW-1:0] srdradr,
  input [SDOUT_WIDTH-1:0] sdout,
  input cwrite,
  input [BITVROW-1:0] cwrradr,
  input [WIDTH-1:0] cdin,
  input cread,
  input [BITVROW-1:0] crdradr,
  input [WIDTH-1:0] cdout,
  input [BITADDR-1:0] select_addr,
  input [BITWDTH-1:0] select_bit
);

wire [BITVBNK-1:0] select_bank;
wire [BITVROW-1:0] select_row;
np2_addr #(
  .NUMADDR (NUMADDR), .BITADDR (BITADDR),
  .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
  .NUMVROW (NUMVROW), .BITVROW (BITVROW))
  sel_adr (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));

assert_rw_sl_np2_check: assert property (@(posedge clk) disable iff (rst) (vread || vwrite) |-> ##FLOPIN
				         ((core.vaddr_wire == select_addr) == ((core.vbadr_wire == select_bank) && (core.vradr_wire == select_row))));
assert_rw_np2_range_check: assert property (@(posedge clk) disable iff (rst) (vread || vwrite) |-> ##FLOPIN
					    ((core.vbadr_wire < NUMVBNK) && (core.vradr_wire < NUMVROW)));
assert_sl_np2_range_check: assert property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR) |->
					    ((select_bank < NUMVBNK) && (select_row < NUMVROW))); 

reg pmem;
always @(posedge clk)
  if (rst)
    pmem <= 1'b0;
  else if (pwrite && (pwrbadr == select_bank) && (pwrradr == select_row))
    pmem <= pdin[select_bit];

reg [SDOUT_WIDTH-1:0] smem;
always @(posedge clk)
  if (rst)
    smem <= 0;
  else if (swrite && (swrradr == select_row))
    smem <= sdin;

wire [ECCBITS-1:0] smem_ecc;
ecc_calc #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
    ecc_calc_inst (.din(smem[BITVBNK:0]), .eccout(smem_ecc));

reg cmem;
always @(posedge clk)
  if (rst)
    cmem <= 0;
  else if (cwrite && (cwrradr == select_row))
    cmem <= cdin[select_bit];

wire mem_wire = (smem[BITVBNK] && (smem[BITVBNK-1:0] == select_bank)) ? cmem : pmem;

assert_smem_ecc_check: assert property (@(posedge clk) disable iff (rst) (smem == {smem[BITVBNK:0],smem_ecc,smem[BITVBNK:0]}));

assert_pdout1_check: assert property (@(posedge clk) disable iff (rst) (pread1 && (prdbadr1 == select_bank) && (prdradr1 == select_row)) |-> ##DRAM_DELAY
				      (pdout1_serr || (pdout1[select_bit] == $past(pmem,DRAM_DELAY))));
assert_pdout2_check: assert property (@(posedge clk) disable iff (rst) (pread2 && (prdbadr2 == select_bank) && (prdradr2 == select_row)) |-> ##DRAM_DELAY
				      (pdout2_serr || (pdout2[select_bit] == $past(pmem,DRAM_DELAY))));

assert_sdout_check: assert property (@(posedge clk) disable iff (rst) (sread && (srdradr == select_row)) |-> ##SRAM_DELAY
				     (sdout == $past(smem,SRAM_DELAY)));

assert_cdout_check: assert property (@(posedge clk) disable iff (rst) (cread && (crdradr == select_row)) |-> ##SRAM_DELAY
				     (cdout[select_bit] == $past(cmem,SRAM_DELAY)));

assert_sdout_ecc_check: assert property (@(posedge clk) disable iff (rst) (sread && (srdradr == select_row)) |-> ##SRAM_DELAY
				         (core.sdout_out == $past(smem[BITVBNK:0],SRAM_DELAY)));

wire state_serr = 0;
wire state_derr = 0;
wire state_nerr = !state_serr && !state_derr;
assume_state_err_check: assert property (@(posedge clk) disable iff (rst) !(state_serr && state_derr));
assume_state_serr_check: assert property (@(posedge clk) disable iff (rst) state_serr |-> ##SRAM_DELAY core.sdout_serr && !core.sdout_derr);
assume_state_derr_check: assert property (@(posedge clk) disable iff (rst) state_derr |-> ##SRAM_DELAY !core.sdout_serr && core.sdout_derr);
assume_state_nerr_check: assert property (@(posedge clk) disable iff (rst) state_nerr |-> ##SRAM_DELAY !core.sdout_serr && !core.sdout_derr);

assert_sdout_nerr_check: assert property (@(posedge clk) disable iff (rst) (sread && (srdradr == select_row) && state_nerr) |-> ##SRAM_DELAY
					  !core.sdout_ded_err && !core.sdout_sec_err && (core.sdout_dup_data == core.sdout_post_ecc));
assert_sdout_serr_check: assert property (@(posedge clk) disable iff (rst) (sread && (srdradr == select_row) && state_serr) |-> ##SRAM_DELAY
					  !core.sdout_ded_err && (core.sdout_sec_err ? (core.sdout_dup_data == core.sdout_post_ecc) :
										       (core.sdout_dup_data != core.sdout_post_ecc)));
assert_sdout_derr_check: assert property (@(posedge clk) disable iff (rst) (sread && (srdradr == select_row) && state_derr) |-> ##SRAM_DELAY
					  core.sdout_ded_err ? !core.sdout_sec_err :
					  core.sdout_sec_err ? !core.sdout_ded_err && (core.sdout_dup_data != core.sdout_post_ecc) :
							       (core.sdout_dup_data != core.sdout_post_ecc));

assert_mapw_fwd_check: assert property (@(posedge clk) disable iff (rst) ((core.vread_wire || core.vwrite_wire) && (core.vradr_wire == select_row)) |-> ##SRAM_DELAY
                                        (core.mapw_out == smem[BITVBNK:0]));
assert_cdatw_fwd_check: assert property (@(posedge clk) disable iff (rst) ((core.vread_wire || core.vwrite_wire) && (core.vradr_wire == select_row)) |-> ##SRAM_DELAY
                                         (core.cdatw_out[select_bit] == cmem));

assert_mapr_fwd_check: assert property (@(posedge clk) disable iff (rst) ((core.vread_wire || core.vwrite_wire) && (core.vradr_wire == select_row)) |-> ##(DRAM_DELAY+4)
                                        (core.mapr_out == $past(smem[BITVBNK:0],DRAM_DELAY-SRAM_DELAY+4)));
assert_cdatr_fwd_check: assert property (@(posedge clk) disable iff (rst) ((core.vread_wire || core.vwrite_wire) && (core.vradr_wire == select_row)) |-> ##(DRAM_DELAY+4)
                                         (core.cdatr_out[select_bit] == $past(cmem,DRAM_DELAY-SRAM_DELAY+4)));

//DADA Add pdatr_fwd check

assert_sold1_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.snew_vld1 && (core.snew_row1 == select_row)) |->
					 (({core.sold_vld1,core.sold_map1} == smem[BITVBNK:0]) && (core.sold_dat1[select_bit] == cmem)));
assert_sold2_fwd_check: assert property (@(posedge clk) disable iff (rst) (core.snew_vld2 && (core.snew_row2 == select_row)) |->
					 (({core.sold_vld2,core.sold_map2} == smem[BITVBNK:0]) && (core.sold_dat2[select_bit] == cmem)));
assert_wrfifo_check: assert property (@(posedge clk) disable iff (rst) (core.wrfifo_cnt <= FIFOCNT));

reg pmem_int;
always @(posedge clk)
  if (rst)
    pmem_int <= 1'b0;
  else if (core.pwrite2_int && (core.pwrbadr2_int == select_bank) && (core.pwrradr2_int == select_row))
    pmem_int <= core.pdin2_int[select_bit];
  else if (core.pwrite1_int && (core.pwrbadr1_int == select_bank) && (core.pwrradr1_int == select_row))
    pmem_int <= core.pdin1_int[select_bit];

wire mem_wire_int = (smem[BITVBNK] && (smem[BITVBNK-1:0] == select_bank)) ? cmem : pmem_int;

reg rmem;
always @(posedge clk)
  if (rst)
    rmem <= 0;
  else if (core.snew_vld2 && (core.snew_map2 == select_bank) && (core.snew_row2 == select_row))
    rmem <= core.snew_dat2[select_bit];
  else if (core.snew_vld1 && (core.snew_map1 == select_bank) && (core.snew_row1 == select_row))
    rmem <= core.snew_dat1[select_bit];

assert_rmem_check: assert property (@(posedge clk) disable iff (rst) (mem_wire_int == rmem));

reg vmem;
always @(posedge clk)
  if (rst)
    vmem <= 0;
  else if (core.vwrite_out && (core.vwrbadr_out == select_bank) && (core.vwrradr_out == select_row))
    vmem <= core.vdin_out[select_bit];

assert_vmem_check: assert property (@(posedge clk) disable iff (rst) ((core.wr_srch_flags ? core.wr_srch_datas[select_bit] : rmem) == vmem));

assert_pmem_check: assert property (@(posedge clk) disable iff (rst) (($past(pmem_int) == pmem) || (pmem_int == pmem)));

reg fakemem;
reg fakememinv;
always @(posedge clk)
  if (rst)
    fakememinv <= 1'b1;
  else if (vwrite && (vaddr == select_addr)) begin
    fakememinv <= 1'b0;
    fakemem <= vdin[select_bit];
  end

assert_fakemem_check: assert property (@(posedge clk) disable iff (rst) 1'b1 |-> ##(FLOPIN+SRAM_DELAY+1)
				       ($past(fakememinv,FLOPIN+SRAM_DELAY+1) || ($past(fakemem,FLOPIN+SRAM_DELAY+1) == vmem) || ($past(fakemem,FLOPIN+SRAM_DELAY) == vmem)));

assert_vld_check: assert property (@(posedge clk) disable iff (rst) (vread && (vaddr == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+4+FLOPOUT) vread_vld);
assert_derr_check: assert property (@(posedge clk) disable iff (rst) (vread && (vaddr == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+4+FLOPOUT) !(vread_derr && !vread_serr));
assert_dout_check: assert property (@(posedge clk) disable iff (rst) (vread && (vaddr == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+4+FLOPOUT)
                                    ($past(fakememinv,FLOPIN+DRAM_DELAY+4+FLOPOUT) || vread_serr || (vdout[select_bit] == $past(fakemem,FLOPIN+DRAM_DELAY+4+FLOPOUT))));
assert_padr_check: assert property (@(posedge clk) disable iff (rst) (vread && (vaddr == select_addr)) |-> ##(FLOPIN+DRAM_DELAY+4+FLOPOUT)
                                    (&vread_padr || (vread_padr == ((1 << (BITPADR-1)) | select_row)) ||
                                    (vread_padr == {1'b0,(FLOPOUT ? $past(core.pdatr_padr_out) : core.pdatr_padr_out)})));


endmodule


