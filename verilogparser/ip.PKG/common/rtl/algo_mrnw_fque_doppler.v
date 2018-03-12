
module algo_mrnw_fque_doppler (push, pu_ptr,
                       pop, po_pvld, po_ptr,
                       cp_read, cp_write, cp_adr, cp_din, cp_vld, cp_dout,
                       t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
                       freecnt,
		               clk, rst, ready);

  parameter NUMPORT = 8;
  parameter NUMADDR = 64;
  parameter BITADDR = 8;
  parameter BITQPTR = 8;
  parameter BITQCNT = BITADDR+1;

  parameter BITPORT = 3;
  parameter NUMVROW = 8;
  parameter BITVROW = 3;
  
  parameter QPTR_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter RSTQPTR = 0;
  parameter BITCPAD = BITADDR;
  parameter CPUWDTH = BITADDR+BITQCNT;


  input  [NUMPORT-1:0]         push;
  input  [NUMPORT*BITQPTR-1:0] pu_ptr;

  input  [NUMPORT-1:0]         pop;
  output [NUMPORT-1:0]         po_pvld;
  output [NUMPORT*BITQPTR-1:0] po_ptr;

  input                        cp_read;
  input                        cp_write;
  input  [BITCPAD-1:0]         cp_adr;
  input  [CPUWDTH-1:0]         cp_din;
  output                       cp_vld;
  output [CPUWDTH-1:0]         cp_dout;

  output [BITQCNT -1:0]        freecnt;
  output                       ready;
  input                        clk;
  input                        rst;

  output [NUMPORT-1:0]         t1_writeA;
  output [NUMPORT*BITVROW-1:0] t1_addrA;
  output [NUMPORT*BITQPTR-1:0] t1_dinA;
  output [NUMPORT-1:0]         t1_readB;
  output [NUMPORT*BITVROW-1:0] t1_addrB;
  input  [NUMPORT*BITQPTR-1:0] t1_doutB;

  core_mrnw_fque_doppler #(.NUMPORT (NUMPORT), .NUMADDR (NUMADDR), .BITADDR (BITADDR), .BITQPTR (BITQPTR),
                   .BITPORT (BITPORT), .NUMVROW (NUMVROW), .BITVROW(BITVROW),
                   .QPTR_DELAY (QPTR_DELAY), .FLOPIN (FLOPIN), .FLOPOUT (FLOPOUT),
                   .BITCPAD(BITCPAD), .CPUWDTH(CPUWDTH))
    core (.vpush(push), .vpu_ptr(pu_ptr),
          .vpop(pop), .vpo_pvld(po_pvld), .vpo_ptr(po_ptr),
          .vcpread (cp_read), .vcpwrite (cp_write), .vcpaddr (cp_adr), .vcpdin (cp_din), .vcpread_vld (cp_vld), .vcpread_dout (cp_dout),
          .t1_writeA(t1_writeA), .t1_addrA(t1_addrA), .t1_dinA(t1_dinA), .t1_readB(t1_readB), .t1_addrB(t1_addrB), .t1_doutB(t1_doutB),
          .freecnt(freecnt),
          .ready (ready), .clk (clk), .rst (rst));

`ifdef FORMAL

ip_top_sva_mrnw_fque_doppler #(
     .NUMPORT     (NUMPORT),
     .BITPORT     (BITPORT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .BITQPTR     (BITQPTR),
     .QPTR_DELAY  (QPTR_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);


ip_top_sva_2_mrnw_fque_doppler #(
     .NUMPORT     (NUMPORT),
     .BITPORT     (BITPORT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .NUMVROW     (NUMVROW),
     .BITVROW     (BITVROW),
     .BITQPTR     (BITQPTR))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin
  wire [BITQPRT-1:0] help_qprt = sva_int;
  wire [BITADDR-1:0] help_addr = sva_int;
ip_top_sva_mrnw_fque_doppler #(
     .NUMPORT     (NUMPORT),
     .BITPORT     (BITPORT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .BITQPTR     (BITQPTR),
     .QPTR_DELAY  (QPTR_DELAY),
     .FLOPIN      (FLOPIN),
     .FLOPOUT     (FLOPOUT))
ip_top_sva (.*);
end
endgenerate

ip_top_sva_2_mrnw_fque_doppler #(
     .NUMPORT     (NUMPORT),
     .NUMADDR     (NUMADDR),
     .BITADDR     (BITADDR),
     .BITQPTR     (BITQPTR))
ip_top_sva_2 (.*);

`endif

endmodule
