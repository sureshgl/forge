
module refr_1stage (clk, rst, pref, pacc, pacbadr, prefr, prfbadr) ;

  parameter NUMRBNK = 7;
  parameter BITRBNK = 3;
  parameter REFLOPW = 0;
  parameter MAXREFR = 2; //16; // MICA is 128, OPAL is 256
  parameter BITMXRF = 1;

  input clk, rst, pacc, pref ;
  input [BITRBNK-1:0]             pacbadr;
  output                          prefr;
  output [BITRBNK-1:0]            prfbadr;

  reg               prefr_svld;
  reg               prefr_cvld;
  reg               prefr_pvld;
  reg [BITRBNK-1:0] prefr_addr;

  wire [BITRBNK:0] prefr_wcnt;
  generate if (REFLOPW) begin: lp
    reg [BITRBNK:0] prefr_wcnt_reg;
    always @(posedge clk)
      if (rst)
        prefr_wcnt_reg <= 0;
      else if (pref)
        prefr_wcnt_reg <= NUMRBNK - 1;
      else if (prefr)
        prefr_wcnt_reg <= prefr_wcnt_reg - 1;
    assign prefr_wcnt = prefr_wcnt_reg;
  end else begin: hb
    assign prefr_wcnt = 1;
  end
  endgenerate

  reg [BITRBNK-1:0] prefr_ptr;
  reg [BITRBNK-1:0] prefr_ptr_plus_1;
  always @(posedge clk)
    if (rst)
      prefr_ptr <= 0;
    else if (prefr_cvld || prefr_pvld)
      prefr_ptr <= (prefr_addr == NUMRBNK-1) ? 0 : prefr_addr + 1;
 
  always_comb begin
    prefr_ptr_plus_1 = (prefr_ptr == NUMRBNK-1) ? 0 : prefr_ptr + 1;
  end

// Comments for Sanjeev's pleasure
// If not pseudo dual port prefr_scnt[x][1] will always be zero
// 0 holds the largest count stuck pointer
// 1 holds the second largest count stuck pointer
// requires swapping if 1 becomes greater than 0 in terms of count

  reg [BITRBNK-1:0] prefr_sptr_0;
  reg [BITMXRF:0]   prefr_scnt_0;
  always @(posedge clk)
    if (rst) begin
      prefr_sptr_0 <= 0;
      prefr_scnt_0 <= 0;
    end else if (prefr_svld && (prefr_sptr_0 == prefr_addr)) begin
      prefr_sptr_0 <= prefr_sptr_0;
      prefr_scnt_0 <= prefr_scnt_0 - 1;
    end else if (prefr_pvld) begin
      prefr_sptr_0 <= prefr_ptr;
      prefr_scnt_0 <= (prefr_scnt_0 == MAXREFR) ? prefr_scnt_0 : prefr_scnt_0 + 1;
    end

  always_comb
    if (|prefr_scnt_0 && !(pacc && (pacbadr == prefr_sptr_0))) begin
      prefr_svld = |prefr_wcnt || pref;
      prefr_cvld = 1'b0;
      prefr_pvld = 1'b0;
      prefr_addr = prefr_sptr_0;
    end else if (!(pacc && (pacbadr == prefr_ptr))) begin
      prefr_svld = 1'b0;
      prefr_cvld = |prefr_wcnt || pref;
      prefr_pvld = 1'b0;
      prefr_addr = prefr_ptr;
    end else begin
      prefr_svld = 1'b0;
      prefr_cvld = 1'b0;
      prefr_pvld = /*!((prefr_scnt_0 == MAXREFR) && (prefr_ptr == prefr_sptr_0)) &&*/ (|prefr_wcnt || pref);
      prefr_addr = prefr_ptr_plus_1;
    end

  assign prefr = (NUMRBNK==1) ? !pacc : (prefr_cvld || prefr_svld || prefr_pvld);
  assign prfbadr = prefr_addr;

endmodule


