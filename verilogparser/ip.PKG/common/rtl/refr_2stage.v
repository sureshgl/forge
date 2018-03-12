module refr_2stage (clk, rst, pref, pacc1, pacbadr1, pacc2, pacbadr2, prefr, prfbadr);

  parameter NUMRBNK = 16;
  parameter BITRBNK = 4;
  parameter REFLOPW = 0;
  parameter MAXREFR = 1; //16; // MICA is 128, OPAL is 256
  parameter BITMXRF = 2;

  input clk, rst;
  input                           pref;
  input                           pacc1;
  input [BITRBNK-1:0]             pacbadr1;
  input                           pacc2;
  input [BITRBNK-1:0]             pacbadr2;
  output                          prefr;
  output [BITRBNK-1:0]            prfbadr;

  reg               prefr_svld;
  reg               prefr_cvld;
  reg               prefr_pvld;
  reg [BITRBNK-1:0] prefr_addr;

  reg [BITRBNK-1:0] prefr_sptr_0;
  reg [BITMXRF:0]   prefr_scnt_0;
  reg [BITRBNK-1:0] prefr_sptr_1;
  reg [BITMXRF:0]   prefr_scnt_1;

  reg [BITRBNK-1:0] prefr_ptr;
  reg [BITRBNK-1:0] prefr_ptr_plus_1;
  reg [BITRBNK-1:0] prefr_ptr_plus_2;
  always @(posedge clk)
    if (rst)
      prefr_ptr <= 0;
    else if (prefr_pvld)
      if (prefr_cvld)
        prefr_ptr <= (prefr_addr == NUMRBNK-1) ? 0 : prefr_addr + 1;
      else
        prefr_ptr <= prefr_sptr_0;
 
  always_comb begin
    prefr_ptr_plus_1 = (prefr_ptr == NUMRBNK-1) ? 0 : prefr_ptr + 1;
    prefr_ptr_plus_2 = (prefr_ptr == NUMRBNK-2) ? 0 :
                       (prefr_ptr == NUMRBNK-1) ? 1 : prefr_ptr + 2;
  end

// Comments for Sanjeev's pleasure
// If not pseudo dual port prefr_scnt[x][1] will always be zero
// 0 holds the largest count stuck pointer
// 1 holds the second largest count stuck pointer
// requires swapping if 1 becomes greater than 0 in terms of count

  always @(posedge clk)
    if (rst) begin
      prefr_sptr_0 <= 0;
      prefr_scnt_0 <= 0;
      prefr_sptr_1 <= 0;
      prefr_scnt_1 <= 0;
    end else if (prefr_svld && (prefr_sptr_0 == prefr_addr)) begin
      prefr_sptr_0 <= prefr_sptr_1;
      prefr_scnt_0 <= prefr_scnt_1;
      prefr_sptr_1 <= 0;
      prefr_scnt_1 <= 0;
    end else if (prefr_svld && (prefr_sptr_1 == prefr_addr)) begin
      prefr_sptr_1 <= 0;
      prefr_scnt_1 <= 0;
    end else if (prefr_pvld && (prefr_ptr_plus_1 == prefr_addr) && (NUMRBNK > 1)) begin
      if (|prefr_scnt_0) begin
        prefr_sptr_1 <= prefr_ptr;
        prefr_scnt_1 <= 1;
      end else begin
        prefr_sptr_0 <= prefr_ptr;
        prefr_scnt_0 <= 1;
      end
    end else if (prefr_pvld && (prefr_ptr_plus_2 == prefr_addr) && (NUMRBNK > 2)) begin
      prefr_sptr_0 <= prefr_ptr;
      prefr_scnt_0 <= 1;
      prefr_sptr_1 <= prefr_ptr_plus_1;
      prefr_scnt_1 <= 1;
    end

  always_comb
    if (|prefr_scnt_0 && !(pacc1 && (pacbadr1 == prefr_sptr_0)) &&
                         !(pacc2 && (pacbadr2 == prefr_sptr_0))) begin
      prefr_svld = 1'b1;
      prefr_cvld = 1'b0;
      prefr_pvld = 1'b0;
      prefr_addr = prefr_sptr_0;
    end else if (|prefr_scnt_1 && !(pacc1 && (pacbadr1 == prefr_sptr_1)) &&
				  !(pacc2  && (pacbadr2 == prefr_sptr_1))) begin
      prefr_svld = 1'b1;
      prefr_cvld = 1'b0;
      prefr_pvld = 1'b0;
      prefr_addr = prefr_sptr_1;
    end else if (!(pacc1 && (pacbadr1 == prefr_ptr)) &&
                 !(pacc2 && (pacbadr2 == prefr_ptr))) begin
      prefr_svld = 1'b0;
      prefr_cvld = 1'b1;
      prefr_pvld = 1'b1;
      prefr_addr = prefr_ptr;
    end else if (!(pacc1 && (pacbadr1 == prefr_ptr_plus_1)) &&
                 !(pacc2 && (pacbadr2 == prefr_ptr_plus_1))) begin
      prefr_svld = 1'b0;
      prefr_cvld = !(|prefr_scnt_0 && (prefr_sptr_0 == prefr_ptr)) && (NUMRBNK > 1);
      prefr_pvld = !(|prefr_scnt_0 && (prefr_sptr_0 == prefr_ptr)) && (NUMRBNK > 1);
      prefr_addr = prefr_ptr_plus_1;
    end else begin
      prefr_svld = 1'b0;
      prefr_cvld = !(((prefr_scnt_0 == MAXREFR) && (prefr_sptr_0 == prefr_ptr)) ||
                     ((prefr_scnt_0 == MAXREFR) && (prefr_sptr_0 == prefr_ptr_plus_1))) && (NUMRBNK > 2);
      prefr_pvld = !((prefr_scnt_0 == MAXREFR) && (prefr_sptr_0 == prefr_ptr)) && (NUMRBNK > 2);
      prefr_addr = prefr_cvld ? prefr_ptr_plus_2 : prefr_sptr_0;
    end

  assign prefr = prefr_cvld || prefr_svld;
  assign prfbadr = prefr_addr;

endmodule


