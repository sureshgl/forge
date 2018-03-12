
module mth_bmmd_state_core (vwrite, vwraddr, vdin,
                            vread, vrdaddr, vdout,
                            pwrite, pwraddr, pdin,
                            pread, prdaddr, pdout,
   	                    swrite, swrradr, sdin,
                            sread0, srdradr0, sdout0, sserr0, sderr0,
                            sread1, srdradr1, sdout1, sserr1, sderr1,
                            sread2, srdradr2, sdout2, sserr2, sderr2,
                            sread3, srdradr3, sdout3, sserr3, sderr3,
                            ready, clk, rst);

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input                               vread;
  input [17-1:0]                 vrdaddr;
  output [1677-1:0]                  vdout;

  input                               vwrite;
  input [17-1:0]                 vwraddr;
  input [1677-1:0]                   vdin;

  output                              pwrite;
  output [(4+13)-1:0]      pwraddr;
  output [1677-1:0]                  pdin;

  output                              pread;
  output [(4+13)-1:0]      prdaddr;
  input [1677-1:0]                   pdout;

  output                              swrite;
  output [13-1:0]                swrradr;
  output [64-1:0]                sdin;

  output                              sread0;
  output [13-1:0]                srdradr0;
  input                               sserr0;
  input                               sderr0;
  input [64-1:0]                 sdout0;
  
  output                              sread1;
  output [13-1:0]                srdradr1;
  input                               sserr1;
  input                               sderr1;
  input [64-1:0]                 sdout1;
  
  output                              sread2;
  output [13-1:0]                srdradr2;
  input                               sserr2;
  input                               sderr2;
  input [64-1:0]                 sdout2;
  
  output                              sread3;
  output [13-1:0]                srdradr3;
  input                               sserr3;
  input                               sderr3;
  input [64-1:0]                 sdout3;
  
  output                             ready;
  input                              clk;
  input                              rst;

  reg [13:0] rstaddr;
  wire rstvld = rstaddr < 8192;
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg [64-1:0] rstdin;
  integer rst_int;
  always_comb begin
    rstdin = 0;
    for (rst_int=0; rst_int<16; rst_int=rst_int+1)
      rstdin = rstdin | (rst_int << (rst_int*4));
  end

  reg ready;
  always @(posedge clk)
    ready <= !rstvld;

  wire               ready_wire;
  wire               vread_wire;
  wire [17-1:0] vrdaddr_wire;
  wire [4-1:0] vrdbadr_wire;
  wire [13-1:0] vrdradr_wire;
  wire               vwrite_wire;
  wire [17-1:0] vwraddr_wire;
  wire [4-1:0] vwrbadr_wire;
  wire [13-1:0] vwrradr_wire;
  wire [1677-1:0]   vdin_wire;

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg vread_reg;
    reg [17-1:0] vrdaddr_reg;
    reg vwrite_reg;
    reg [17-1:0] vwraddr_reg;
    reg [1677-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread && ready;
      vrdaddr_reg <= vrdaddr;
      vwrite_reg <= vwrite && ready;
      vwraddr_reg <= vwraddr;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    assign vread_wire = vread_reg;
    assign vrdaddr_wire = vrdaddr_reg;
    assign vrdbadr_wire = vrdaddr_reg[17-1:13];
    assign vrdradr_wire = vrdaddr_reg[13-1:0];

    assign vwrite_wire = vwrite_reg;
    assign vwraddr_wire = vwraddr_reg;
    assign vwrbadr_wire = vwraddr_reg[17-1:13];
    assign vwrradr_wire = vwraddr_reg[13-1:0];
    assign vdin_wire = vdin_reg;

  end else begin: noflpi_loop
    assign ready_wire = ready; 
    assign vread_wire = vread;
    assign vrdaddr_wire = vrdaddr;
    assign vrdbadr_wire = vrdaddr[17-1:13];
    assign vrdradr_wire = vrdaddr[13-1:0];

    assign vwrite_wire = vwrite;
    assign vwraddr_wire = vwraddr;
    assign vwrbadr_wire = vwraddr[17-1:13];
    assign vwrradr_wire = vwraddr[13-1:0];
    assign vdin_wire = vdin;
  end
  endgenerate

  reg                vread_reg [0:SRAM_DELAY-1];
  reg [4-1:0]  vrdbadr_reg [0:SRAM_DELAY-1];
  reg [13-1:0]  vrdradr_reg [0:SRAM_DELAY-1];
  reg                vwrite_reg [0:SRAM_DELAY-1];
  reg [4-1:0]  vwrbadr_reg [0:SRAM_DELAY-1];
  reg [13-1:0]  vwrradr_reg [0:SRAM_DELAY-1];
  reg [1677-1:0]    vdin_reg [0:SRAM_DELAY-1];
 
  integer vprt_int, vdel_int; 
  always @(posedge clk) 
    for (vdel_int=0; vdel_int<SRAM_DELAY; vdel_int=vdel_int+1)
      if (vdel_int > 0) begin
        vread_reg[vdel_int] <= vread_reg[vdel_int-1];
        vrdbadr_reg[vdel_int] <= vrdbadr_reg[vdel_int-1];
        vrdradr_reg[vdel_int] <= vrdradr_reg[vdel_int-1];
        vwrite_reg[vdel_int] <= vwrite_reg[vdel_int-1];
        vwrbadr_reg[vdel_int] <= vwrbadr_reg[vdel_int-1];
        vwrradr_reg[vdel_int] <= vwrradr_reg[vdel_int-1];
        vdin_reg[vdel_int] <= vdin_reg[vdel_int-1];
      end else begin
        vread_reg[vdel_int] <= vread_wire;
        vrdbadr_reg[vdel_int] <= vrdbadr_wire;
        vrdradr_reg[vdel_int] <= vrdradr_wire;
        vwrite_reg[vdel_int] <= vwrite_wire && (vwraddr_wire < 122880) && ready_wire;
        vwrbadr_reg[vdel_int] <= vwrbadr_wire;
        vwrradr_reg[vdel_int] <= vwrradr_wire;
        vdin_reg[vdel_int] <= vdin_wire;
      end

  reg vread_out;
  reg [4-1:0] vrdbadr_out;
  reg [13-1:0] vrdradr_out;
  reg vwrite_out;
  reg [4-1:0] vwrbadr_out;
  reg [13-1:0] vwrradr_out;
  reg [1677-1:0] vdin_out;
  integer vout_int, vwpt_int;
  always_comb begin
    vread_out = vread_reg[SRAM_DELAY-1];
    vrdbadr_out = vrdbadr_reg[SRAM_DELAY-1];
    vrdradr_out = vrdradr_reg[SRAM_DELAY-1];
    vwrite_out = vwrite_reg[SRAM_DELAY-1];
    vwrbadr_out = vwrbadr_reg[SRAM_DELAY-1];
    vwrradr_out = vwrradr_reg[SRAM_DELAY-1];
    vdin_out = vdin_reg[SRAM_DELAY-1];
  end

  // Read request of mapping information on SRAM memory
  reg sread0, sread1, sread2, sread3;
  reg [13-1:0] srdradr0, srdradr1, srdradr2, srdradr3;
  assign sread0 = vwrite_wire && !(swrite && (swrradr == vwrradr_wire));
  assign srdradr0 = vwrradr_wire;
  assign sread1 = vwrite_wire && !(swrite && (swrradr == vwrradr_wire));
  assign srdradr1 = vwrradr_wire;
  assign sread2 = vread_wire && !(swrite && (swrradr == vrdradr_wire));
  assign srdradr2 = vrdradr_wire;
  assign sread3 = vread_wire && !(swrite && (swrradr == vrdradr_wire));
  assign srdradr3 = vrdradr_wire;

  reg               map0_vld [0:SRAM_DELAY-1];
  reg [64-1:0] map0_reg [0:SRAM_DELAY-1];
  reg               map1_vld [0:SRAM_DELAY-1];
  reg [64-1:0] map1_reg [0:SRAM_DELAY-1];
  integer sfwd_int;
  always @(posedge clk)
    for (sfwd_int=0; sfwd_int<SRAM_DELAY; sfwd_int=sfwd_int+1) begin
      if (sfwd_int>0) begin
        if (swrite && (swrradr == vwrradr_reg[sfwd_int-1])) begin
          map0_vld[sfwd_int] <= 1'b1;
          map0_reg[sfwd_int] <= sdin;
        end else begin
          map0_vld[sfwd_int] <= map0_vld[sfwd_int-1];
          map0_reg[sfwd_int] <= map0_reg[sfwd_int-1];
        end
        if (swrite && (swrradr == vrdradr_reg[sfwd_int-1])) begin
          map1_vld[sfwd_int] <= 1'b1;
          map1_reg[sfwd_int] <= sdin;
        end else begin
          map1_vld[sfwd_int] <= map1_vld[sfwd_int-1];
          map1_reg[sfwd_int] <= map1_reg[sfwd_int-1];
        end
      end else begin
        if (swrite && (swrradr == vwrradr_wire)) begin
          map0_vld[sfwd_int] <= 1'b1;
          map0_reg[sfwd_int] <= sdin;
        end else begin
          map0_vld[sfwd_int] <= 1'b0;
          map0_reg[sfwd_int] <= 0;
        end
        if (swrite && (swrradr == vrdradr_wire)) begin
          map1_vld[sfwd_int] <= 1'b1;
          map1_reg[sfwd_int] <= sdin;
        end else begin
          map1_vld[sfwd_int] <= 1'b0;
          map1_reg[sfwd_int] <= 0;
        end
      end
    end

// ECC Checking Module for SRAM
  wire [64-1:0] sdout0_out = sderr0 ? sdout1 : sdout0;
  wire [64-1:0] sdout1_out = sderr2 ? sdout3 : sdout2;

  wire [64-1:0] map0_out = map0_vld[SRAM_DELAY-1] ? map0_reg[SRAM_DELAY-1] : sdout0_out;
  wire [64-1:0] map1_out = map1_vld[SRAM_DELAY-1] ? map1_reg[SRAM_DELAY-1] : sdout1_out;

  wire [4-1:0] rdmap_out = map1_out >> (vrdbadr_out*4);
  wire [4-1:0] wrmap_out = map0_out >> (vwrbadr_out*4);
  wire [4-1:0] wrfre_out = map0_out >> (15*4);
  wire cflt = vread_out && vwrite_out && (rdmap_out==wrmap_out);

  wire pread_tmp = vread_out;
  wire [(4+13)-1:0] prdaddr_tmp = {rdmap_out,vrdradr_out};

  wire pwrite_tmp = vwrite_out;
  wire [(4+13)-1:0] pwraddr_tmp = cflt ? {wrfre_out,vwrradr_out} : {wrmap_out,vwrradr_out};
  wire [1677-1:0] pdin_tmp = vdin_out;

  reg pwrite;
  reg [(4+13)-1:0] pwraddr;
  reg [1677-1:0] pdin;
  reg pread;
  reg [(4+13)-1:0] prdaddr;
  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      pwrite <= pwrite_tmp;
      pwraddr <= pwraddr_tmp;
      pdin <= pdin_tmp;
      pread <= pread_tmp;
      prdaddr <= prdaddr_tmp;
    end
  end else begin: nflp_loop
    always_comb begin
      pwrite = pwrite_tmp;
      pwraddr = pwraddr_tmp;
      pdin = pdin_tmp;
      pread = pread_tmp;
      prdaddr = prdaddr_tmp;
    end
  end
  endgenerate

  assign swrite = (rstvld && !rst) || cflt;
  assign swrradr = rstvld ? rstaddr : vwrradr_out;
  assign sdin = rstvld ? rstdin : ((map0_out & ~({4{1'b1}} << (vwrbadr_out*4)) & ~({4{1'b1}} << (15*4))) |
                                   (wrfre_out << (vwrbadr_out*4)) | (wrmap_out << (15*4)));

  assign vdout = pdout;

endmodule
