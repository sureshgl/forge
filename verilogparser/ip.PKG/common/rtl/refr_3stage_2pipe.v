
module refr_3stage_2pipe (clk, rst, pacc1, pacc2, pacc3, pa1badr, pa2badr, pa3badr, norefr, prefr, prfbadr, phigh, phibadr) ;

  parameter NUMRBNK = 4;
  parameter BITRBNK = 2;
  parameter MAXREFR = 1; //16; // MICA is 128, OPAL is 256
  parameter BITMXRF = 1;

  input clk, rst, pacc1, pacc2, pacc3;
  input [BITRBNK-1:0]             pa1badr, pa2badr, pa3badr;
  input				  norefr;
  output                          prefr;
  output [BITRBNK-1:0]            prfbadr;
  output                          phigh;
  output [BITRBNK-1:0]            phibadr;

  reg               prefr_svld;
  reg               prefr_cvld;
  reg               prefr_pvld;
  reg [BITRBNK-1:0] prefr_addr;

  reg [BITRBNK-1:0] prefr_sptr [0:2];
  reg [BITMXRF-1:0] prefr_scnt [0:2];

  reg [BITRBNK-1:0] prefr_ptr;
  reg [BITRBNK-1:0] prefr_ptr_plus_1;
  reg [BITRBNK-1:0] prefr_ptr_plus_2;
  reg [BITRBNK-1:0] prefr_ptr_plus_3;
  always @(posedge clk)
    if (rst)
      prefr_ptr <= 0;
    else if (prefr_pvld)
      if (prefr_cvld)
        prefr_ptr <= (prefr_addr == NUMRBNK-1) ? 0 : prefr_addr + 1;
      else if (prefr_addr == prefr_ptr)
        prefr_ptr <= prefr_ptr;
      else 
        prefr_ptr <= prefr_sptr[0];
 
  always_comb begin
    prefr_ptr_plus_1 = (prefr_ptr == NUMRBNK-1) ? 0 : prefr_ptr + 1;
    prefr_ptr_plus_2 = (prefr_ptr == NUMRBNK-2) ? 0 :
                       (prefr_ptr == NUMRBNK-1) ? 1 : prefr_ptr + 2;
    prefr_ptr_plus_3 = (prefr_ptr == NUMRBNK-3) ? 0 :
    		       (prefr_ptr == NUMRBNK-2) ? 1 :
                       (prefr_ptr == NUMRBNK-1) ? 2 : prefr_ptr + 3;
  end

// Comments for Sanjeev's pleasure
// If not pseudo dual port prefr_scnt[x][1] will always be zero
// 0 holds the largest count stuck pointer
// 1 holds the second largest count stuck pointer
// requires swapping if 1 becomes greater than 0 in terms of count

  always @(posedge clk)
    if (rst) begin
      prefr_sptr[0] <= 0;
      prefr_scnt[0] <= 0;
      prefr_sptr[1] <= 0;
      prefr_scnt[1] <= 0;
      prefr_sptr[2] <= 0;
      prefr_scnt[2] <= 0;
    end else if (prefr_svld && (prefr_sptr[0] == prefr_addr)) begin
      prefr_sptr[0] <= prefr_sptr[1];
      prefr_scnt[0] <= prefr_scnt[1];
      prefr_sptr[1] <= prefr_sptr[2];
      prefr_scnt[1] <= prefr_scnt[2];
      prefr_sptr[2] <= 0;
      prefr_scnt[2] <= 0;
    end else if (prefr_svld && (prefr_sptr[1] == prefr_addr)) begin
      prefr_sptr[1] <= prefr_sptr[2];
      prefr_scnt[1] <= prefr_scnt[2];
      prefr_sptr[2] <= 0;
      prefr_scnt[2] <= 0;
    end else if (prefr_svld && (prefr_sptr[2] == prefr_addr)) begin
      prefr_sptr[2] <= 0;
      prefr_scnt[2] <= 0;
    end else if (prefr_pvld && (prefr_ptr_plus_1 == prefr_addr) && (NUMRBNK > 1)) begin
      if (|prefr_scnt[0] && |prefr_scnt[1]) begin
        prefr_sptr[2] <= prefr_ptr;
        prefr_scnt[2] <= 1;
      end else if (|prefr_scnt[0]) begin
        prefr_sptr[1] <= prefr_ptr;
        prefr_scnt[1] <= 1;
      end else begin
        prefr_sptr[0] <= prefr_ptr;
        prefr_scnt[0] <= 1;
      end
    end else if (prefr_pvld && (prefr_ptr_plus_2 == prefr_addr) && (NUMRBNK > 2)) begin
      if (|prefr_scnt[0]) begin
        prefr_sptr[1] <= prefr_ptr;
        prefr_scnt[1] <= 1;
        prefr_sptr[2] <= prefr_ptr_plus_1;
        prefr_scnt[2] <= 1;
      end else begin
        prefr_sptr[0] <= prefr_ptr;
        prefr_scnt[0] <= 1;
        prefr_sptr[1] <= prefr_ptr_plus_1;
        prefr_scnt[1] <= 1;
      end
    end else if (prefr_pvld && (prefr_ptr_plus_3 == prefr_addr) && (NUMRBNK > 3)) begin
      prefr_sptr[0] <= prefr_ptr;
      prefr_scnt[0] <= 1;
      prefr_sptr[1] <= prefr_ptr_plus_1;
      prefr_scnt[1] <= 1;
      prefr_sptr[2] <= prefr_ptr_plus_2;
      prefr_scnt[2] <= 1;
    end else if (!prefr_cvld && !(|prefr_scnt[0]) && prefr_pvld && (prefr_ptr == prefr_addr)) begin
      if (NUMRBNK > 2) begin
        prefr_sptr[2] <= prefr_ptr_plus_2;
        prefr_scnt[2] <= 1;
      end
      if (NUMRBNK > 1) begin
        prefr_sptr[1] <= prefr_ptr_plus_1;
        prefr_scnt[1] <= 1;
      end
      if (NUMRBNK > 0) begin
        prefr_sptr[0] <= prefr_ptr;
        prefr_scnt[0] <= 1;
      end
    end

  wire [BITRBNK-1:0] prefr_sptr_0 = prefr_sptr[0];
  wire [BITMXRF:0]   prefr_scnt_0 = prefr_scnt[0];
  wire [BITRBNK-1:0] prefr_sptr_1 = prefr_sptr[1];
  wire [BITMXRF:0]   prefr_scnt_1 = prefr_scnt[1];
  wire [BITRBNK-1:0] prefr_sptr_2 = prefr_sptr[2];
  wire [BITMXRF:0]   prefr_scnt_2 = prefr_scnt[2];

  always_comb
    if (norefr) begin
      prefr_svld = 1'b0;
      prefr_cvld = 1'b0;
      prefr_pvld = 1'b0;
      prefr_addr = 0;
    end else if (|prefr_scnt[0] && !(pacc1 && (pa1badr == prefr_sptr[0])) &&
                                   !(pacc2 && (pa2badr == prefr_sptr[0])) &&
                                   !(pacc3 && (pa3badr == prefr_sptr[0]))) begin
      prefr_svld = 1'b1;
      prefr_cvld = 1'b0;
      prefr_pvld = 1'b0;
      prefr_addr = prefr_sptr[0];
    end else if (|prefr_scnt[1] && !(pacc1 && (pa1badr == prefr_sptr[1])) &&
                          	   !(pacc2 && (pa2badr == prefr_sptr[1])) &&
                          	   !(pacc3 && (pa3badr == prefr_sptr[1]))) begin
      prefr_svld = 1'b1;
      prefr_cvld = 1'b0;
      prefr_pvld = 1'b0;
      prefr_addr = prefr_sptr[1];
    end else if (|prefr_scnt[2] && !(pacc1 && (pa1badr == prefr_sptr[2])) &&
                          	   !(pacc2 && (pa2badr == prefr_sptr[2])) &&
                          	   !(pacc3 && (pa3badr == prefr_sptr[2]))) begin
      prefr_svld = 1'b1;
      prefr_cvld = 1'b0;
      prefr_pvld = 1'b0;
      prefr_addr = prefr_sptr[2];
    end else if (!(pacc1 && (pa1badr == prefr_ptr)) &&
                 !(pacc2 && (pa2badr == prefr_ptr)) &&
                 !(pacc3 && (pa3badr == prefr_ptr))) begin
      prefr_svld = 1'b0;
      prefr_cvld = 1'b1;
      prefr_pvld = 1'b1;
      prefr_addr = prefr_ptr;
    end else if (!(pacc1 && (pa1badr == prefr_ptr_plus_1)) &&
                 !(pacc2 && (pa2badr == prefr_ptr_plus_1)) &&
                 !(pacc3 && (pa3badr == prefr_ptr_plus_1)) && (NUMRBNK > 1)) begin
      prefr_svld = 1'b0;
      prefr_cvld = !(|prefr_scnt[0] && (prefr_sptr[0] == prefr_ptr));
      prefr_pvld = !(|prefr_scnt[0] && (prefr_sptr[0] == prefr_ptr));
      prefr_addr = prefr_ptr_plus_1;
    end else if (!(pacc1 && (pa1badr == prefr_ptr_plus_2)) &&
                 !(pacc2 && (pa2badr == prefr_ptr_plus_2)) &&
                 !(pacc3 && (pa3badr == prefr_ptr_plus_2)) && (NUMRBNK > 2)) begin
      prefr_svld = 1'b0;
      prefr_cvld = !((|prefr_scnt[0] && (prefr_sptr[0] == prefr_ptr)) ||
      		     (|prefr_scnt[0] && (prefr_sptr[0] == prefr_ptr_plus_1)));
      prefr_pvld = !(|prefr_scnt[0] && (prefr_sptr[0] == prefr_ptr));
      prefr_addr = prefr_cvld ? prefr_ptr_plus_2 : prefr_sptr[0];
    end else if (!(pacc1 && (pa1badr == prefr_ptr_plus_3)) &&
                 !(pacc2 && (pa2badr == prefr_ptr_plus_3)) &&
                 !(pacc3 && (pa3badr == prefr_ptr_plus_3)) && (NUMRBNK > 3)) begin
      prefr_svld = 1'b0;
      prefr_cvld = !((|prefr_scnt[0] && (prefr_sptr[0] == prefr_ptr)) ||
                     (|prefr_scnt[0] && (prefr_sptr[0] == prefr_ptr_plus_1)) ||
                     (|prefr_scnt[0] && (prefr_sptr[0] == prefr_ptr_plus_2)));
      prefr_pvld = !(|prefr_scnt[0] && (prefr_sptr[0] == prefr_ptr));
      prefr_addr = prefr_cvld ? prefr_ptr_plus_3 : prefr_sptr[0];
    end else begin
      prefr_svld = 1'b0;
      prefr_cvld = 1'b0;
      prefr_pvld = !(|prefr_scnt[0]);
      prefr_addr = prefr_ptr;
    end

  assign prefr = prefr_cvld || prefr_svld;
  assign prfbadr = prefr_addr;

  assign phigh = |prefr_scnt[0];
  assign phibadr = prefr_sptr[0]; 

endmodule


