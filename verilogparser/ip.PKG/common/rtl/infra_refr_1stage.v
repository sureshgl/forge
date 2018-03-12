module infra_refr_1stage (clk, rst, 
			  pref, pacc, pacbadr, prefr, prfbadr,
			  select_rbnk, select_rrow);

  parameter NUMRBNK = 8;
  parameter BITRBNK = 3;
  parameter REFLOPW = 0;
  parameter NUMRROW = 16;
  parameter BITRROW = 4;
  parameter REFFREQ = 10;
  parameter REFFRHF = 0;

  input                           pref;
  input                           pacc ;
  input [BITRBNK-1:0]             pacbadr;
  output                          prefr;
  output [BITRBNK-1:0]            prfbadr;

  input clk;
  input rst;

  input [BITRBNK-1:0] select_rbnk;
  input [BITRROW-1:0] select_rrow;

  refr_1stage #(.NUMRBNK (NUMRBNK), .BITRBNK (BITRBNK), .REFLOPW (REFLOPW))
    refresh_module (.clk (clk),
                    .rst (rst),
                    .pref (pref),
                    .pacc (pacc),
                    .pacbadr (pacbadr),
                    .prefr (prefr),
                    .prfbadr (prfbadr));

`ifdef FORMAL
assume_select_rbnk_range: assume property (@(posedge clk) disable iff (rst) (select_rbnk < NUMRBNK));
assume_select_rbnk_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rbnk));
assume_select_rrow_range: assume property (@(posedge clk) disable iff (rst) (select_rrow < NUMRROW));
assume_select_rrow_stable: assume property (@(posedge clk) disable iff (rst) $stable(select_rrow));

ip_top_sva_refr_1stage 
    #(
     .NUMRBNK     (NUMRBNK),
     .BITRBNK     (BITRBNK),
     .REFLOPW     (REFLOPW),
     .NUMRROW     (NUMRROW),
     .BITRROW     (BITRROW),
     .REFFREQ     (REFFREQ),
     .REFFRHF     (REFFRHF))
ip_top_sva (.*);

ip_top_sva_2_refr_1stage 
    #(
     .NUMRBNK     (NUMRBNK),
     .BITRBNK     (BITRBNK),
     .REFFREQ     (REFFREQ),
     .REFFRHF     (REFFRHF))
ip_top_sva_2 (.*);

`elsif SIM_SVA

genvar sva_int;
// generate for (sva_int=0; sva_int<WIDTH; sva_int=sva_int+1) begin
generate for (sva_int=0; sva_int<1; sva_int=sva_int+1) begin: sva_loop
  wire [BITRBNK-1:0] help_rbnk = sva_int;
  wire [BITRROW-1:0] help_rrow = sva_int;
ip_top_sva_refr_1stage 
    #(
     .NUMRBNK     (NUMRBNK),
     .BITRBNK     (BITRBNK),
     .REFLOPW     (REFLOPW),
     .NUMRROW     (NUMRROW),
     .BITRROW     (BITRROW),
     .REFFREQ     (REFFREQ),
     .REFFRHF     (REFFRHF))
ip_top_sva (.select_rbnk(help_rbnk), .select_rrow(help_rrow), .*);
end
endgenerate

ip_top_sva_2_refr_1stage 
    #(
     .NUMRBNK     (NUMRBNK),
     .BITRBNK     (BITRBNK),
     .REFFREQ     (REFFREQ),
     .REFFRHF     (REFFRHF))
ip_top_sva_2 (.*);

`endif

endmodule
