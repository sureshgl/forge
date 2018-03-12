module algo_nmpd_1r1w_fl_shared (
                                     malloc, ma_vld, ma_adr, ma_fwrd, ma_serr, ma_derr, ma_padr, ma_bp, bp_thr, bp_hys,
                                     dq_vld, dq_adr,
                                     cp_read, cp_write, cp_adr, cp_din, cp_vld, cp_dout,
                                     t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB,
                                     grpmsk, grpbp, grpcnt, grpmt, ena_rand,
                                     clk, rst, ready,
                                     select_addr, 
                                     pwrite, pwrbadr, pwrradr );

  parameter ENAEXT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;

  parameter NUMMAPT = 1;
  parameter NUMDQPT = 1;
  parameter NUMEGPT = 1;
  parameter NUMARPT = 4;

  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;

  parameter NUMGRPW = 1;  // 13 SJ
  parameter NUMGRPF = 1; // 7 SJ

  parameter NUMCMDL = 1; // 2 SJ  4 org 
  parameter BITCMDL = 1; // 2 SJ
  parameter NUMGRPC = NUMVBNK/NUMCMDL;

  parameter SRAM_DELAY = 1;
  parameter DRAM_DELAY = 1;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter BITCPAD = 2+3+5;
  parameter CPUWDTH = 54;

  input [NUMMAPT-1:0]          malloc;
  output [NUMMAPT-1:0]         ma_vld;
  output [NUMMAPT*BITADDR-1:0] ma_adr;
  output [NUMMAPT-1:0]         ma_fwrd;
  output [NUMMAPT-1:0]         ma_serr;
  output [NUMMAPT-1:0]         ma_derr;
  output [NUMMAPT*(BITVROW+1)-1:0] ma_padr;
  output [NUMMAPT-1:0]         ma_bp;
  input [BITVROW:0]            bp_thr;
  input [BITVROW:0]            bp_hys;

  
  input [NUMDQPT-1:0]          dq_vld;
  input [NUMDQPT*BITADDR-1:0]  dq_adr;

  input [NUMMAPT*NUMVBNK-1:0]  grpmsk;
  input [NUMMAPT*NUMVBNK-1:0]  grpbp;
  input [NUMMAPT*(BITVBNK+1)-1:0] grpcnt;
  output [NUMVBNK-1:0]         grpmt;
  input                        ena_rand;

  input                        cp_read;
  input                        cp_write;
  input [BITCPAD-1:0]          cp_adr;
  input [CPUWDTH-1:0]          cp_din;
  output                       cp_vld;
  output [CPUWDTH-1:0]         cp_dout;

  output                       ready;
  input                        clk;
  input                        rst;

  input [BITADDR-1:0]          select_addr;

  output [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_writeA;
  output [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_addrA;
  output [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_dinA;
  output [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_readB;
  output [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_addrB;
  input [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_doutB;
  input [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_fwrdB;
  input [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_serrB;
  input [(NUMDQPT/NUMEGPT)*NUMVBNK-1:0] t2_derrB;
  input [(NUMDQPT/NUMEGPT)*NUMVBNK*BITVROW-1:0] t2_padrB;

  output [(NUMMAPT)-1:0] pwrite ;
  output [((NUMMAPT)*BITVBNK)-1:0] pwrbadr;
  output [((NUMMAPT)*BITVROW)-1:0] pwrradr;

  core_nmpd_1r1w_fl_shared #(
                                 .NUMMAPT (NUMMAPT), .NUMDQPT (NUMDQPT), .NUMEGPT (NUMEGPT), .NUMARPT (NUMARPT),
                                 .NUMADDR (NUMADDR), .BITADDR (BITADDR),
                                 .NUMVROW (NUMVROW), .BITVROW (BITVROW), .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), 
                                 .SRAM_DELAY (SRAM_DELAY), .DRAM_DELAY (DRAM_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT))

      core (.vmalloc(malloc), .vma_bp(ma_bp), .vma_vld(ma_vld), .vma_addr(ma_adr), 
            .vma_fwrd(ma_fwrd), .vma_serr(ma_serr), .vma_derr(ma_derr), .vma_padr(ma_padr),
            .vdeq(dq_vld), .vdqaddr(dq_adr),
            .vcpread(cp_read), .vcpwrite(cp_write), .vcpdin(cp_din), .vcpaddr(cp_adr), .vcpread_vld(cp_vld), .vcpread_dout(cp_dout),
            .pwrite(pwrite), .pwrbadr(pwrbadr), .pwrradr(pwrradr), 
            .t2_writeA(t2_writeA), .t2_addrA(t2_addrA), .t2_dinA(t2_dinA), 
            .t2_readB(t2_readB), .t2_addrB(t2_addrB), .t2_doutB(t2_doutB), 
            .t2_fwrdB(t2_fwrdB), .t2_serrB(t2_serrB), .t2_derrB(t2_derrB), .t2_padrB(t2_padrB),
            .bp_thr(bp_thr), .bp_hys(bp_hys),
            .grpmt(grpmt), .grpmsk(grpmsk), .grpcnt(grpcnt), .grpbp(grpbp), .ena_rand(ena_rand),
            .ready(ready), .clk(clk), .rst(rst));
  
  
  reg pwrite_wire [0:NUMMAPT-1];
  reg [BITVBNK-1:0] pwrbadr_wire [0:NUMMAPT-1];
  reg [BITVROW-1:0] pwrradr_wire [0:NUMMAPT-1];
  integer pwrp_int;
  always_comb begin
    for (pwrp_int=0; pwrp_int<NUMMAPT; pwrp_int=pwrp_int+1) begin
      pwrite_wire[pwrp_int] = pwrite >> pwrp_int;
      pwrbadr_wire[pwrp_int] = pwrbadr >> (pwrp_int*BITVBNK); 
      pwrradr_wire[pwrp_int] = pwrradr >> (pwrp_int*BITVROW); 
    end
  end

`ifdef FORMAL

assume_select_addr_range: assume property (@(posedge clk) disable iff (rst) (select_addr < NUMADDR));
assume_select_addr_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_addr));
//assume_select_bit_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_bit));

ip_top_sva_nmpd_1r1w_fl_shared #(
     .ENAEXT      (ENAEXT),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMMAPT     (NUMMAPT),
     .NUMDQPT     (NUMDQPT),
     .NUMEGPT     (NUMEGPT), 
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMGRPW     (NUMGRPW),
     .NUMGRPC     (NUMGRPC),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);


ip_top_sva_2_nmpd_1r1w_fl_shared #(
     .ENAEXT      (ENAEXT),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMMAPT     (NUMMAPT),
     .NUMDQPT     (NUMDQPT),
     .NUMEGPT     (NUMEGPT),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMGRPW     (NUMGRPW),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITADDR-1:0] help_addr = sva_int;
ip_top_sva_nmpd_1r1w_fl_shared #(
     .ENAEXT      (ENAEXT),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMMAPT     (NUMMAPT),
     .NUMDQPT     (NUMDQPT),
     .NUMEGPT     (NUMEGPT),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMGRPW     (NUMGRPW),
     .NUMGRPC     (NUMGRPC),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.select_addr(help_addr), .select_bit (help_bit), .*);
end
endgenerate

ip_top_sva_2_nmpd_1r1w_fl_shared #(
     .ENAEXT      (ENAEXT),
     .ENAPAR      (ENAPAR),
     .ENAECC      (ENAECC),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMMAPT     (NUMMAPT),
     .NUMDQPT     (NUMDQPT),
     .NUMEGPT     (NUMEGPT),
     .NUMVBNK     (NUMVBNK),
     .BITVBNK     (BITVBNK),
     .NUMVROW     (NUMVROW),
     .NUMGRPW     (NUMGRPW),
     .BITVROW     (BITVROW),
     .SRAM_DELAY  (SRAM_DELAY),
     .DRAM_DELAY  (DRAM_DELAY))
ip_top_sva_2 (.*);

`endif


endmodule
