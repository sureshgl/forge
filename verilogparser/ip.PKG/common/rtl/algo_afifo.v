module algo_afifo (
                   rst, 
                   push_clk, push, push_data, push_err,
                   pop_clk, pop, pop_data, pop_vld, pop_err,
                   empty, full
);

  parameter WIDTH   = 32;
  parameter NUMWRDS = 16;
  parameter BITAPTR =  4;

  input rst;

  input push_clk;
  input push;
  input [WIDTH-1:0] push_data;
  output push_err;

  input pop_clk;
  input pop;
  output [WIDTH-1:0] pop_data;
  output pop_vld;
  output pop_err;

  output full;
  output empty;


  core_afifo #(
               .WIDTH (WIDTH),
               .NUMWRDS (NUMWRDS),
               .BITAPTR(BITAPTR)
               )
  core (
        /*AUTOINST*/
        // Outputs
        .push_err                       (push_err),
        .pop_data                       (pop_data),
        .pop_vld                        (pop_vld),
        .pop_err                        (pop_err),
        .full                           (full),
        .empty                          (empty),
        // Inputs
        .rst                            (rst),
        .push_clk                       (push_clk),
        .push                           (push),
        .push_data                      (push_data[WIDTH-1:0]),
        .pop_clk                        (pop_clk),
        .pop                            (pop));
  

`ifdef FORMAL

  ip_top_sva_afifo #(
                     .WIDTH (WIDTH),
                     .NUMWRDS (NUMWRDS),
                     .BITAPTR(BITAPTR)
                     )
  ip_top_sva (.*);

  ip_top_sva_2_afifo #(
                       .WIDTH (WIDTH),
                       .NUMWRDS (NUMWRDS),
                       .BITAPTR(BITAPTR)
                       )
  ip_top_sva_2 (.*);

`elsif SIM_SVA
  // TBD tie off select_addr here?
  ip_top_sva_afifo #(
                     .WIDTH (WIDTH),
                     .NUMWRDS (NUMWRDS),
                     .BITAPTR(BITAPTR)
                     )
  ip_top_sva (.*);

  ip_top_sva_2_afifo #(
                       .WIDTH (WIDTH),
                       .NUMWRDS (NUMWRDS),
                       .BITAPTR(BITAPTR)
                      )
  ip_top_sva_2 (.*);
`endif

endmodule // algo_afifo

