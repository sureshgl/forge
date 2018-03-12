/*
 ###############################################################################
 # Copyright (c) 2001 - by Andiamo Systems Inc.
 # Copyright (c) 2007 - by Cisco Systems Inc.
 # All rights reserved.
 #
 # Author     : Atlantis project
 # Owner      : Hsitung Huang (ctung@cisco.com)
 #
 # Description: This ip_async_fifo is copied from Atlantis project.
 #
 #              The sync1 flops of wp_g and rp_g are added with prefix "presync_dstclk_".
 #              The sync2 flops of wp_g and rp_g are added with prefix "sync_dstclk_".
 #              Therefore, the post-processing synthesis script can search and find
 #              the flops with the prefix strings and replace them with special sync flops.
 #
 # Important Note: The data_out is valid only when !af_empty.
 #           Note: User should qualify data_out with !af_empty before using data_out.
 #           Note: Please use ip_async_fifo2 (rather than ip_async_fifo)
 #                 because ip_async_fifo2 data_out has been qualified with !af_emtpy.
 #
 # Important Note: To make sure RTL is not synthesized to the logic gates with glitches
 #                 such that !af_empty qualification is compromised in gate level,
 #                 user should instantiate gates with dont_touch in ip_async_fifo2.
 #
 # Important Note: Don't put too much logic after data_out (user should flop in data_out path ASAP)
 #           Note: User can use ip_async_fifo_reg (rather than ip_async_fifo)
 #                 where data_out has been qualified with !af_empty and flop to rd clock (r_clk) domain.
 #
 ###############################################################################
 # $Id: ip_async_fifo.v,v 1.29 2014/04/07 22:43:05 sihsu Exp $
 # $Author: sihsu $
 # $Source: /nfs/nvbu/asic/repository/andiamo_vegas/vegas_ip/ip_async_fifo/rtl/ip_async_fifo.v,v $
 # $Revision: 1.29 $$
 # $Date: 2014/04/07 22:43:05 $
 #
 # $Log: ip_async_fifo.v,v $
 # Revision 1.29  2014/04/07 22:43:05  sihsu
 # Fix spyglass issue on wp_g and wp_b
 #
 # Revision 1.28  2014/04/01 03:05:58  kevyuan
 # removed underflow check for active pop fifos.
 #
 # Revision 1.27  2014/03/31 03:48:50  kevyuan
 # added assertions for overflow and underflow
 #
 # Revision 1.26  2012/12/22 04:08:37  diliao
 # add r_rst or w_rst then disable assertion
 #
 # Revision 1.25  2012/09/26 20:50:04  saikatb
 #
 # - Added output af_cnt.
 #
 # Revision 1.24  2012/04/13 07:13:25  mahampto
 # Changed inline ifdef to be multiple lines (some vcs versions don't like inline
 # ifdefs).
 #
 # Revision 1.23  2012/04/10 22:01:44  ctung
 # no logic change: remove "//syopsys translate" enclosure for "define TCQ"
 #
 # Revision 1.22  2012/02/11 00:18:00  ctung
 # Important Note: Please use ip_async_fifo2 or ip_async_fifo_reg
 #
 # Revision 1.20  2011/12/07 21:52:24  rhoffman
 # define to disable finish exits by fifos
 #
 # Revision 1.19  2011/05/20 20:41:19  ctung
 # Change #1 to TCQ
 #
 # Revision 1.18  2010/09/26 19:43:35  chuang
 # replace KATANA with USER_VENDOR__SYNC_FLOP; missed second part as found by ctung
 #
 # Revision 1.17  2010/05/26 07:55:38  chuang
 # remove KATANA and replaced with USE_VENDOR__SYNC_FLOP
 #
 # Revision 1.16  2010/01/18 09:52:42  sakjain
 # added F16_SYNCHRONIZER_ON
 #
 # Revision 1.15  2010/01/16 21:02:33  chuang
 # add katana and change to `elsif
 #
 # Revision 1.14  2009/08/11 18:06:46  ctung
 # Edit comments
 #
 # Revision 1.13  2009/08/04 17:53:17  ctung
 # Add Note: Don't put too much logic after data_out
 #
 # Revision 1.12  2008/07/02 13:58:49  ppathak
 #  added  ip_sync_ctlbus_dst for write/read ptr synchronization, with ifdef THB_SYNCHRONIZER_ON
 #
 # Revision 1.11  2008/05/09 17:58:05  ctung
 # Add comment for af_thrsh which is threshold from full.
 #
 # Revision 1.10  2008/03/05 06:02:12  lixin
 # added special handling for async flops
 #
 # Revision 1.9  2007/10/10 19:21:07  ctung
 # Review and waive spyglass warnings.
 # Add synopsys revision.
 #
 # Revision 1.8  2007/08/29 17:56:12  ctung
 # Add IP_ASYNC_FIFO_DEBUG
 #
 # Revision 1.7  2007/07/17 08:11:27  lixin
 # fixed register names to work with the async flop swap tcl script.
 #
 # Revision 1.6  2007/03/27 20:36:37  ctung
 # Make af_thrsh size the same as ADDR
 #
 # Revision 1.5  2007/03/24 01:54:10  ctung
 # Parameter size for af_thrsh
 #
 # Revision 1.3  2007/03/14 19:16:38  ctung
 # Derive FIFO_ADDR from FIFO_DEPTH
 #
 # Revision 1.2  2007/02/17 01:37:29  ctung
 # The sync1 flops of wp_g and rp_g are added with prefix "presync_dstclk_".
 # The sync2 flops of wp_g and rp_g are added with prefix "sync_dstclk_".
 #
 # $Endlog
 ###############################################################################
*/
`ifdef TCQ
`else
`define TCQ #1
`endif

module ip_async_fifo (
                   // Write Clock domain
                   w_rst,
                   w_clk,
                   wr_en,
                   data_in,
                   af_alm_full,
                   af_thrsh,
                   af_set_intr_p,
                   af_cnt,
                   
                   // Read Clock domain
                   r_rst,
                   r_clk,                      
                   rd_en,
                   data_out,
                   af_empty
                   );
// synopsys template 
   
   parameter    FIFO_DEPTH = 8;         // power-of-2 number
   parameter    FIFO_WIDTH = 256;       // Any integer larger than 0
// parameter    FIFO_ADDR  = 3          // log2(FIFO_DEPTH)
   parameter    FIFO_ADDR  =            // log2(FIFO_DEPTH)
                             (FIFO_DEPTH<=2)?1:
                             (FIFO_DEPTH<=4)?2:
                             (FIFO_DEPTH<=8)?3:
                             (FIFO_DEPTH<=16)?4:
                             (FIFO_DEPTH<=32)?5:
                             32;

   //-----------------------------------
   // Write clock interface
   //-----------------------------------
   
   input                w_rst;           // Write clock domain reset signal
   input                w_clk;           // Write clock domain clock signal  
   input                wr_en;           // Write clock domain write enable 

   input [FIFO_WIDTH-1:0] data_in;       // Write clock domain data-in bus 

   output                 af_alm_full;   // Async FIFO almost full status in write clock domain
   input [FIFO_ADDR-1:0]  af_thrsh;      // Almost full threshold, CPU register bits on write clock domain
                                         // Note: af_thrsh is the threshold (distance) from full.
                                         // If set af_thrsh to 0, af_alm_full equals to af_full.

   output                 af_set_intr_p; // Overflow interrupt
   
   output [FIFO_ADDR:0] af_cnt;
   
   //-----------------------------------
   // Read clock interface
   //-----------------------------------
   
   input                r_rst;           // Read clock domain reset signal
   input                r_clk;           // Read clock domain clock signal
   input                rd_en;           // Read clock domain read enable

   output [FIFO_WIDTH-1:0] data_out;     // Read clock domain read data-out which is not flopped out.
   // Important Note: The data_out is valid only when !af_empty.
   //           Note: User should qualify data_out with !af_empty before using data_out.
   //           Note: Please use ip_async_fifo2 (rather than ip_async_fifo)
   //                 because ip_async_fifo2 data_out has been qualified with !af_emtpy.

   output                  af_empty;     // Async FIFO empty status on read clock domain
   
   //===========================================================
   // Start of Logic
   //===========================================================

   // Async FIFO Parameter Declarations
   
   // Memory declaration
   reg [FIFO_WIDTH-1:0]                           async_mem [0:FIFO_DEPTH-1];

   // synopsys translate_off
   // for wave debug 
   wire [FIFO_WIDTH-1:0]                          async_mem0 = async_mem[0];
`ifdef IP_ASYNC_FIFO_DEBUG
   wire [FIFO_WIDTH-1:0]                          async_mem1 = async_mem[1];
   wire [FIFO_WIDTH-1:0]                          async_mem2 = async_mem[2];
   wire [FIFO_WIDTH-1:0]                          async_mem3 = async_mem[3];
`endif

`ifdef IP_ASYNC_FIFO_DEBUG
   wire [FIFO_WIDTH-1:0]                          async_memL3 = async_mem[FIFO_DEPTH-4];
   wire [FIFO_WIDTH-1:0]                          async_memL2 = async_mem[FIFO_DEPTH-3];
   wire [FIFO_WIDTH-1:0]                          async_memL1 = async_mem[FIFO_DEPTH-2];
`endif
   wire [FIFO_WIDTH-1:0]                          async_memL0 = async_mem[FIFO_DEPTH-1];
   // synopsys translate_on
   // 
   reg [FIFO_ADDR:0]              wp_g;
   reg [FIFO_ADDR:0]              wp_b;
   reg [FIFO_ADDR:0]              presync_dstclk_wp_g_r_clk_sync;
   reg [FIFO_ADDR:0]              rp_g;
   reg [FIFO_ADDR:0]              rp_b;
   reg [FIFO_ADDR:0]              presync_dstclk_rp_g_w_clk_sync;
   wire [FIFO_ADDR:0]             nxt_wp_b;
   wire [FIFO_ADDR:0]             nxt_rp_b;
   reg [FIFO_ADDR:0]              nxt_wp_g;
   reg [FIFO_ADDR:0]              nxt_rp_g;
   reg [FIFO_ADDR:0]              rp_b_w_clk;
   reg                            af_set_intr_p;
   
   
   wire [FIFO_WIDTH-1:0]          data_out;
   wire [FIFO_ADDR:0]             af_depth_thrsh;
   wire [FIFO_ADDR:0]             wp_b_cmp;   
   wire                           af_alm_full;
   wire                           af_full;
   wire                           af_empty;
   wire [FIFO_ADDR:0]             af_cnt;
   wire                           af_fb;
   wire                           fifo_we;
   integer i, j, k;
   
`ifdef FLNCR_FIFO_ASSERTION
   always @(posedge r_clk) begin
     if ((!(r_rst || w_rst)) && af_empty && rd_en) begin // for async fifo, don't qualify with ~wr_en
           $display($stime, " %m ERROR: Async fifo underflow, rp_b=%0d ... EXITING", rp_b);
           //#1000;
           //$finish;
     end
   end
`endif


   
   //***** Write (w_clk) clock domain   *******
   // write pointer
   
   assign                         nxt_wp_b = wp_b + 1'b1;
   
   always @(/*AS*/nxt_wp_b) begin
      nxt_wp_g[FIFO_ADDR] = nxt_wp_b[FIFO_ADDR];
      for (i = 1; i <= FIFO_ADDR; i = i + 1) begin
        nxt_wp_g[FIFO_ADDR-i] = nxt_wp_b[FIFO_ADDR-(i-1)] ^ nxt_wp_b[FIFO_ADDR-i];
      end
   end
   
   always @(posedge w_clk) begin
      if (w_rst) begin
         wp_g <= `TCQ {FIFO_ADDR+1{1'b0}};
         wp_b <= `TCQ {FIFO_ADDR+1{1'b0}};
      end else if (fifo_we) begin
         wp_g <= `TCQ nxt_wp_g;
         wp_b <= `TCQ nxt_wp_b;
      end
   end // always (posedge w_clk)
   
   // ***** Read  (r_clk) Clk Domain ******
   // read pointer
   
   assign nxt_rp_b = rp_b + 1'b1;
   always @(/*AS*/nxt_rp_b) begin
      nxt_rp_g[FIFO_ADDR] = nxt_rp_b[FIFO_ADDR];
      for (j = 1; j <= FIFO_ADDR; j = j + 1) begin
        nxt_rp_g[FIFO_ADDR-j] = nxt_rp_b[FIFO_ADDR-(j-1)] ^ nxt_rp_b[FIFO_ADDR-j];
      end
   end
   
   always @(posedge r_clk) begin
      if (r_rst) begin
         rp_g <= `TCQ {FIFO_ADDR{1'b0}};
         rp_b <= `TCQ {FIFO_ADDR{1'b0}};
      end else if (rd_en) begin
         rp_g <= `TCQ nxt_rp_g;
         rp_b <= `TCQ nxt_rp_b;
      end
   end // always @ (posedge r_clk)
   
   
   // Sync wp_g to read clock domain (r_clk)  to generate fifo empty

 `ifdef THB_SYNCHRONIZER_ON // ppathak begin
   wire [FIFO_ADDR:0]              sync_dstclk_wp_g_r_clk_sync;
   ip_sync_ctlbus_dst 
     #(FIFO_ADDR+1) 
       ip_sync_ctlbus_dst_wp (
                              .clk                      ( r_clk                       ), // dstclk
                              .srcclk_controlbus        ( wp_g                        ),
                              .sync_dstclk_controlbus   ( sync_dstclk_wp_g_r_clk_sync )
                              );
 `elsif F16_SYNCHRONIZER_ON // ppathak begin
   wire [FIFO_ADDR:0]              sync_dstclk_wp_g_r_clk_sync;
   ip_sync_ctlbus_dst 
     #(FIFO_ADDR+1) 
       ip_sync_ctlbus_dst_wp (
                              .clk                      ( r_clk                       ), // dstclk
                              .srcclk_controlbus        ( wp_g                        ),
                              .sync_dstclk_controlbus   ( sync_dstclk_wp_g_r_clk_sync )
                              );
 `elsif ELECTRA

   wire [FIFO_ADDR:0]              sync_dstclk_wp_g_r_clk_sync;

   ele_sync_flop #(FIFO_ADDR+1)
     ele_sync_flop_inst0
   (
     .data_out(sync_dstclk_wp_g_r_clk_sync),
     .dstclk(r_clk),
     .data_in(wp_g)
   );

`elsif USE_VENDOR__SYNC_FLOP
   wire [FIFO_ADDR:0]              sync_dstclk_wp_g_r_clk_sync;
   ip_sync_ctlbus_dst 
     #(FIFO_ADDR+1) 
       ip_sync_ctlbus_dst_wp (
                              .clk                      ( r_clk                       ), // dstclk
                              .srcclk_controlbus        ( wp_g                        ),
                              .sync_dstclk_controlbus   ( sync_dstclk_wp_g_r_clk_sync )
                              );

`else

   reg [FIFO_ADDR:0]              sync_dstclk_wp_g_r_clk_sync;

   always @(posedge r_clk) begin
      presync_dstclk_wp_g_r_clk_sync <= `TCQ wp_g;
      sync_dstclk_wp_g_r_clk_sync <= `TCQ presync_dstclk_wp_g_r_clk_sync;
   end

`endif


   assign af_empty = (r_rst || (sync_dstclk_wp_g_r_clk_sync == rp_g)) ? 1'b1: 1'b0;
   
   // Sync rp_g to write clock domain to generate fifo full

 `ifdef THB_SYNCHRONIZER_ON //ppathak begin
   wire [FIFO_ADDR:0] sync_dstclk_rp_g_w_clk_sync;
   ip_sync_ctlbus_dst  
     #(FIFO_ADDR+1) 
       ip_sync_ctlbus_dst_rp (
                              .clk                      ( w_clk                       ), // dstclk
                              .srcclk_controlbus        ( rp_g                        ),
                              .sync_dstclk_controlbus   ( sync_dstclk_rp_g_w_clk_sync )
                              );
 `elsif F16_SYNCHRONIZER_ON //ppathak begin
   wire [FIFO_ADDR:0] sync_dstclk_rp_g_w_clk_sync;
   ip_sync_ctlbus_dst  
     #(FIFO_ADDR+1) 
       ip_sync_ctlbus_dst_rp (
                              .clk                      ( w_clk                       ), // dstclk
                              .srcclk_controlbus        ( rp_g                        ),
                              .sync_dstclk_controlbus   ( sync_dstclk_rp_g_w_clk_sync )
                              );
`elsif ELECTRA
   
   wire [FIFO_ADDR:0]              sync_dstclk_rp_g_w_clk_sync;
   
   ele_sync_flop #(FIFO_ADDR+1)
     ele_sync_flop_inst1
       (
        .data_out(sync_dstclk_rp_g_w_clk_sync),
        .dstclk(w_clk),
        .data_in(rp_g)
        );
   
`elsif USE_VENDOR__SYNC_FLOP
   wire [FIFO_ADDR:0] sync_dstclk_rp_g_w_clk_sync;
   ip_sync_ctlbus_dst  
     #(FIFO_ADDR+1) 
       ip_sync_ctlbus_dst_rp (
                              .clk                      ( w_clk                       ), // dstclk
                              .srcclk_controlbus        ( rp_g                        ),
                              .sync_dstclk_controlbus   ( sync_dstclk_rp_g_w_clk_sync )
                              );

`else

   reg [FIFO_ADDR:0]              sync_dstclk_rp_g_w_clk_sync;

   always @(posedge w_clk) begin
      presync_dstclk_rp_g_w_clk_sync  <= `TCQ rp_g;
      sync_dstclk_rp_g_w_clk_sync  <= `TCQ presync_dstclk_rp_g_w_clk_sync;
   end

`endif
   
// Convert gray coded write pointer to the binary code

   always @(/*AS*/sync_dstclk_rp_g_w_clk_sync) begin
      rp_b_w_clk[FIFO_ADDR] = sync_dstclk_rp_g_w_clk_sync[FIFO_ADDR];
      for (k = 1; k <= FIFO_ADDR; k = k + 1) begin
        rp_b_w_clk[FIFO_ADDR-k] = rp_b_w_clk[FIFO_ADDR-(k-1)] ^ sync_dstclk_rp_g_w_clk_sync[FIFO_ADDR-k]; //spyglass disable W122
      end
   end
   
   // Now geneate the almost full 
   assign af_fb = wp_b[FIFO_ADDR] ^ rp_b_w_clk[FIFO_ADDR];
   assign wp_b_cmp = (af_fb) ? (wp_b[FIFO_ADDR-1:0] + FIFO_DEPTH):(wp_b[FIFO_ADDR-1:0]); //spyglass disable W116
   assign af_cnt = (wp_b_cmp - rp_b_w_clk[FIFO_ADDR-1:0]); //spyglass disable W484
   assign af_depth_thrsh = FIFO_DEPTH - af_thrsh;
   assign af_alm_full = (af_cnt >= af_depth_thrsh) ? 1'b1: 1'b0;
   assign af_full     = (af_cnt >= FIFO_DEPTH) ? 1'b1: 1'b0;

   assign fifo_we = wr_en & (~af_full);
   
   always @(posedge w_clk) begin
      if (fifo_we) begin
         async_mem[wp_b[FIFO_ADDR-1:0]] <= `TCQ data_in;
      end
   end
   
   //Read from FIFO

   assign data_out[FIFO_WIDTH-1:0] = async_mem[rp_b[FIFO_ADDR-1:0]];

//Set the interrupt bit incase of Async FIFO overflow
   always @(posedge w_clk)
     begin
        af_set_intr_p <= `TCQ af_full & wr_en;
     end
   
//******  Debug activity
// synopsys translate_off
   reg [(FIFO_ADDR+1):0]             max_af_cnt;
   reg debug_en;
   `ifdef VEGAS_IP_DISABLE_RTL_DEBUG_FINISH
   initial debug_en = 1'b0;
   `else
   initial debug_en = 1'b1;
   `endif


   always @(posedge w_clk) begin
      if (debug_en) begin 
        if ((!(r_rst || w_rst)) && af_full && wr_en) begin
           $display($stime, " %m ERROR: Async fifo overflow, wp_b=%0d, rp_b=%0d ... EXITING", wp_b, rp_b_w_clk);
           #1000;
           $finish;
        end
  
        max_af_cnt <= w_rst ? 0 : ((af_cnt > max_af_cnt) ? af_cnt : max_af_cnt);
      end
   end
   // synopsys translate_on
   
   
// synopsys dc_script_begin
// synopsys dc_script_end

endmodule

