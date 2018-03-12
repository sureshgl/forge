module pifo (
  clk, rst, ready,
  ar_push, ar_dat, ar_bp,
  p_vld, p_aid, p_prt, p_hndl, p_stg, p_bp,
  r_vld, r_aid, r_prt, r_hndl, r_shu, r_bp,
  x_vld, x_aid, x_hndl, x_stg, x_bp,
  eng_c_pkt_threshold
);

// Arch parameters
parameter  NUMWKQS = 2048; // number of work queues
localparam BITWKQS = (NUMWKQS>1) ? $clog2(NUMWKQS) : 1;
parameter  BITPLST = 40; // program and processor list
parameter  NUMPPCR = 8; // number of packet processing cores

parameter  BITPADR = 13;
parameter  BITEBCT = 9;
parameter  BITPPCL = 2; // bits for num cells per packet 

// arb meta data
parameter  OFSAWKQ = 0;
parameter  OFSAPLS = OFSAWKQ+BITWKQS;
parameter  OFSAPCL = OFSAPLS+BITPLST;
parameter  OFSAEBC = OFSAPCL+BITPPCL;
parameter  OFSAPAD = OFSAEBC+BITEBCT;
parameter  BITARDT = OFSAPAD+BITPADR;
// Program list breakdown = {END=0,END=0,prog-label-N,...prog-label-0,processor-id-N,...processor-id-0}
parameter  NUMPRGM = 4; // max number of prog tuples
parameter  BITPLBL = 4; // program label size
// TBD check NUMPRGM*(BITCONS*BITPLBL) <= BITPLST
parameter  NUMSTGS = 6; // total number of stages for a packet
parameter  BITSTGS = (NUMSTGS > 1) ? $clog2(NUMSTGS) : 1;

// AFIFO parameters
parameter  NUMFIFO = 512;  
parameter  NUMPORT = 4; // number of output ports
parameter  NUMCONS = NUMPPCR;  // top most consumer is dummy, used for end of processing
localparam BITFIFO = NUMFIFO>1 ? $clog2(NUMFIFO) : 1;
localparam BITPORT = NUMPORT>1 ? $clog2(NUMPORT) : 1;
localparam BITCONS = NUMCONS>1 ? $clog2(NUMCONS) : 1;
localparam ROB_DEPTH = NUMFIFO; //reorder buf depth = arb fifo depth
input                clk;
input                rst;
output               ready;

input                ar_push;
input  [BITARDT-1:0] ar_dat;
output               ar_bp;

output [NUMCONS-1:0] p_vld;
output [BITFIFO-1:0] p_aid  [0:NUMCONS-1];
output [BITPORT-1:0] p_prt  [0:NUMCONS-1];
output [BITARDT-1:0] p_hndl [0:NUMCONS-1];
output [BITSTGS-1:0] p_stg  [0:NUMCONS-1];
input  [NUMCONS-1:0] p_bp;

input  [NUMCONS-1:0] r_vld;
input  [BITFIFO-1:0] r_aid  [0:NUMCONS-1];
input  [BITPORT-1:0] r_prt  [0:NUMCONS-1];
input  [BITARDT-1:0] r_hndl [0:NUMCONS-1];
input  [NUMCONS-1:0] r_shu;
output [NUMCONS-1:0] r_bp;

output [NUMPORT-1:0] x_vld;
output [BITFIFO-1:0] x_aid  [0:NUMPORT-1];
output [BITARDT-1:0] x_hndl [0:NUMPORT-1];
output [BITSTGS-1:0] x_stg  [0:NUMPORT-1];
input  [NUMPORT-1:0] x_bp;

output [BITFIFO:0] eng_c_pkt_threshold [0:NUMCONS-1];

wire rq_ready, pq_ready, cm_ready, rob_ready, oq_ready;
assign ready = rq_ready && pq_ready && cm_ready && rob_ready && oq_ready;    

wire               push;
wire [BITARDT-1:0] udat;
wire [BITPORT-1:0] uprt;
wire [BITCONS-1:0] ucon;
wire [BITFIFO-1:0] uid;
wire               ubp;
// request packet for processing
arrque #(
  .BITARDT(BITARDT))
rq (
  .clk(clk), .rst(rst), .ready(rq_ready),
  .ar_push(ar_push), .ar_dat(ar_dat), .ar_bp(ar_bp),
  .push(push), .udat(udat), .ubp(ubp)
);

wire               arb;
wire [NUMCONS-1:0] amsk;
wire               avld;
wire [BITFIFO-1:0] aid;
wire [BITCONS-1:0] acon;
wire [BITPORT-1:0] aprt;
wire [BITARDT-1:0] ahndl;
wire [BITSTGS-1:0] astg;

wire               stage;
wire [BITPORT-1:0] sprt;
wire [BITCONS-1:0] scon;
wire [BITFIFO-1:0] sid;
wire [BITARDT-1:0] shndl;
wire               shu;

wire               pop;
wire [NUMPORT-1:0] omsk;
wire [BITPORT-1:0] oprt;
wire               ovld;
wire [BITFIFO-1:0] oid;
wire [BITARDT-1:0] ohndl;
wire [BITSTGS-1:0] ostg;

//reg wires
wire [15:0] arb_fifo_pkt_threshold_0_thresh;
wire [15:0] eng_c_pkt_threshold_0_thresh;
wire [15:0] eng_c_pkt_threshold_1_thresh;
wire [15:0] eng_c_pkt_threshold_2_thresh;

//reg connections
wire [BITFIFO-1:0] fifo_arb_thr = arb_fifo_pkt_threshold_0_thresh - 1;
//FIXME: use generate loop
assign eng_c_pkt_threshold[0] = eng_c_pkt_threshold_0_thresh;
assign eng_c_pkt_threshold[1] = eng_c_pkt_threshold_1_thresh;
assign eng_c_pkt_threshold[2] = eng_c_pkt_threshold_2_thresh;

// PIFO queue arbiter
fifo_arb #(
  .NUMFIFO(NUMFIFO), .NUMPORT(NUMPORT), .NUMCONS(NUMCONS))
pifo (
  .clk(clk), .rst(rst),
  .push(push), .uprt(uprt), .ucon(ucon), .uid(uid), 
  .bp(ubp), .bp_thr(fifo_arb_thr),
  .arb(arb), .amsk(amsk), .avld(avld), .acon(acon), .aid(aid), .aprt(aprt),
  .stage(stage), .sprt(sprt), .scon(scon), .sid (sid),
  .pop(pop),  .omsk(omsk), .oprt(oprt), .ovld(ovld), .oid(oid)
);

// packet processing queue
arpque #(
  .NUMCONS(NUMCONS), .BITFIFO(BITFIFO), .BITCONS(BITCONS), .BITARDT(BITARDT),
  .BITPORT(BITPORT), .BITSTGS(BITSTGS))
pq (
  .clk(clk), .rst(rst), .ready(pq_ready),
  .arb(arb), .amsk(amsk), .avld(avld), .aid(aid), .acon(acon), .aprt(aprt), 
  .ahndl(ahndl), .astg(astg), 
  .p_vld(p_vld), .p_aid(p_aid), .p_prt(p_prt), .p_hndl(p_hndl), 
  .p_stg(p_stg), .p_bp (p_bp)
);

// packet processing context mem
arcm #(
  .BITWKQS(BITWKQS), .BITPADR(BITPADR), .BITPLST(BITPLST), .BITEBCT(BITEBCT),
  .BITPPCL(BITPPCL), .BITPORT(BITPORT), .BITCONS(BITCONS), .OFSAWKQ(OFSAWKQ),
  .OFSAPLS(OFSAPLS), .OFSAPCL(OFSAPCL), .OFSAEBC(OFSAEBC), .OFSAPAD(OFSAPAD),
  .BITARDT(BITARDT), .NUMPRGM(NUMPRGM), .BITPLBL(BITPLBL), .NUMSTGS(NUMSTGS),
  .BITSTGS(BITSTGS), .NUMFIFO(NUMFIFO), .BITFIFO(BITFIFO), .NUMCONS(NUMCONS))
cm (
  .clk(clk), .rst(rst), .ready(cm_ready),
  .push(push), .udat(udat), .uprt(uprt), .ucon(ucon), .uid(uid), 
  .avld(avld), .aid(aid), .ahndl(ahndl), .astg(astg), 
  .stage(stage), .sid(sid), .scon(scon), .shndl(shndl), .shu(shu),
  .ovld(ovld), .oid(oid), .ohndl(ohndl), .ostg(ostg)
);

// stage reorder buffer
arreord_buf #(.NUMCONS(NUMCONS), .BITARDT(BITARDT), .BITPORT(BITPORT), .BITCONS(BITCONS), .BITFIFO(BITFIFO), .ROB_DEPTH(ROB_DEPTH))
rob (
  .clk(clk), .rst(rst), .ready(rob_ready),
  .avld(avld), .acon(acon), .aid(aid), .aprt(aprt),
  .r_vld(r_vld), .r_aid(r_aid), .r_prt(r_prt), .r_hndl(r_hndl), .r_shu(r_shu), .r_bp(r_bp),
  .stage(stage), .sprt(sprt), .sid(sid), .shndl(shndl), .shu(shu)
);

// schedule to port and packet commit
aroque #(
  .NUMPORT(NUMPORT), .NUMCONS(NUMCONS), .BITFIFO(BITFIFO), .BITCONS(BITCONS),
  .BITARDT(BITARDT), .BITPORT(BITPORT), .BITSTGS(BITSTGS))
oq (
  .clk(clk), .rst(rst), .ready(oq_ready),
  .pop(pop), .omsk(omsk), .ovld(ovld), .oid(oid), .oprt(oprt), .ohndl(ohndl), .ostg(ostg), 
  .x_vld(x_vld), .x_aid(x_aid), .x_hndl(x_hndl), .x_stg(x_stg), .x_bp (x_bp)
);

// synopsys  translate_off
// synthesis translate_off
initial begin
  if (BITPLST < ((BITCONS+BITPLBL)*NUMPRGM))
    $display("[E:%m:%0t] BITPLST size bad", $time);
end
// synthesis translate_on
// synopsys  translate_on

endmodule // arb_top
