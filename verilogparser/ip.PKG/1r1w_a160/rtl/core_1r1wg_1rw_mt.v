
module core_1r1wg_1rw_mt (vwrite, vwraddr, vdin,
                          vread, vrdaddr, vdout,
                          pwrite, pwraddr, pdin,
                          pread, prdaddr, pdout,
   	                  swrite, swrradr, sdin,
                          sread0, srdradr0, sdout0, sserr0, sderr0,
                          sread1, srdradr1, sdout1, sserr1, sderr1,
                          sread2, srdradr2, sdout2, sserr2, sderr2,
                          sread3, srdradr3, sdout3, sserr3, sderr3,
                          ready, clk, rst);

  parameter WIDTH = 1794;
  parameter NUMWRPT = 1;
  parameter NUMADDR = 49152;
  parameter BITADDR = 16;
  parameter NUMVROW = 4096;
  parameter BITVROW = 12;
  parameter NUMVBNK = 12;
  parameter BITVBNK = 4;
  parameter NUMPBNK = 13;
  parameter BITPBNK = 4;
  
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter BITMAPT = BITPBNK*NUMPBNK;

  input                               vread;
  input [BITADDR-1:0]                 vrdaddr;
  output [WIDTH-1:0]                  vdout;

  input                               vwrite;
  input [BITADDR-1:0]                 vwraddr;
  input [WIDTH-1:0]                   vdin;

  output                              pwrite;
  output [(BITPBNK+BITVROW)-1:0]      pwraddr;
  output [WIDTH-1:0]                  pdin;

  output                              pread;
  output [(BITPBNK+BITVROW)-1:0]      prdaddr;
  input [WIDTH-1:0]                   pdout;

  output                              swrite;
  output [BITVROW-1:0]                swrradr;
  output [BITMAPT-1:0]                sdin;

  output                              sread0;
  output [BITVROW-1:0]                srdradr0;
  input                               sserr0;
  input                               sderr0;
  input [BITMAPT-1:0]                 sdout0;
  
  output                              sread1;
  output [BITVROW-1:0]                srdradr1;
  input                               sserr1;
  input                               sderr1;
  input [BITMAPT-1:0]                 sdout1;
  
  output                              sread2;
  output [BITVROW-1:0]                srdradr2;
  input                               sserr2;
  input                               sderr2;
  input [BITMAPT-1:0]                 sdout2;
  
  output                              sread3;
  output [BITVROW-1:0]                srdradr3;
  input                               sserr3;
  input                               sderr3;
  input [BITMAPT-1:0]                 sdout3;
  
  output                             ready;
  input                              clk;
  input                              rst;

  reg [BITVROW:0] rstaddr;
  wire rstvld = rstaddr < NUMVROW;
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

//  reg [BITMAPT-1:0] rstdin;
//  integer rst_int;
//  always_comb begin
//    rstdin = 0;
//    for (rst_int=0; rst_int<NUMPBNK; rst_int=rst_int+1)
//      rstdin = rstdin | (rst_int << (rst_int*BITPBNK));
//  end

  reg ready;
  always @(posedge clk)
    ready <= !rstvld;

  wire               vread_wire;
  wire [BITADDR-1:0] vrdaddr_wire;
  wire [BITVBNK-1:0] vrdbadr_wire;
  wire [BITVROW-1:0] vrdradr_wire;
  wire               vwrite_wire [0:NUMWRPT-1];
  wire [BITADDR-1:0] vwraddr_wire [0:NUMWRPT-1];
  wire [BITVBNK-1:0] vwrbadr_wire [0:NUMWRPT-1];
  wire [BITVROW-1:0] vwrradr_wire [0:NUMWRPT-1];
  wire [WIDTH-1:0]   vdin_wire [0:NUMWRPT-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg vread_reg;
    reg [BITADDR-1:0] vrdaddr_reg;
    reg [NUMWRPT-1:0] vwrite_reg;
    reg [NUMWRPT*BITADDR-1:0] vwraddr_reg;
    reg [NUMWRPT*WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      vread_reg <= vread && ready;
      vrdaddr_reg <= vrdaddr;
      vwrite_reg <= vwrite & {NUMWRPT{ready}};
      vwraddr_reg <= vwraddr;
      vdin_reg <= vdin;
    end

    assign vread_wire = vread_reg;
    assign vrdaddr_wire = vrdaddr_reg;
    assign vrdbadr_wire = vrdaddr_reg[BITADDR-1:BITVROW];
    assign vrdradr_wire = vrdaddr_reg[BITVROW-1:0];
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = (vwrite_reg & {NUMWRPT{ready}}) >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr_reg >> (np2_var*BITADDR);
      assign vwrbadr_wire[np2_var] = vwraddr_wire[np2_var][BITADDR-1:BITVROW];
      assign vwrradr_wire[np2_var] = vwraddr_wire[np2_var][BITVROW-1:0];
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*WIDTH);
    end
  end else begin: noflpi_loop
    assign vread_wire = vread && ready;
    assign vrdaddr_wire = vrdaddr;
    assign vrdbadr_wire = vrdaddr[BITADDR-1:BITVROW];
    assign vrdradr_wire = vrdaddr[BITVROW-1:0];
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = (vwrite & {NUMWRPT{ready}}) >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr >> (np2_var*BITADDR);
      assign vwrbadr_wire[np2_var] = vwraddr_wire[np2_var][BITADDR-1:BITVROW];
      assign vwrradr_wire[np2_var] = vwraddr_wire[np2_var][BITVROW-1:0];
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);
    end
  end
  endgenerate

  reg                vread_reg [0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:SRAM_DELAY-1];
  reg [BITVROW-1:0]  vrdradr_reg [0:SRAM_DELAY-1];
  reg                vwrite_reg [0:NUMWRPT-1][0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  vwrbadr_reg [0:NUMWRPT-1][0:SRAM_DELAY-1];
  reg [BITVROW-1:0]  vwrradr_reg [0:NUMWRPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]    vdin_reg [0:NUMWRPT-1][0:SRAM_DELAY-1];
 
  integer vprt_int, vdel_int; 
  always @(posedge clk) 
    for (vdel_int=0; vdel_int<SRAM_DELAY; vdel_int=vdel_int+1)
      if (vdel_int > 0) begin
        vread_reg[vdel_int] <= vread_reg[vdel_int-1];
        vrdbadr_reg[vdel_int] <= vrdbadr_reg[vdel_int-1];
        vrdradr_reg[vdel_int] <= vrdradr_reg[vdel_int-1];
        for (vprt_int=0; vprt_int<NUMWRPT; vprt_int=vprt_int+1) begin
          vwrite_reg[vprt_int][vdel_int] <= vwrite_reg[vprt_int][vdel_int-1];
          vwrbadr_reg[vprt_int][vdel_int] <= vwrbadr_reg[vprt_int][vdel_int-1];
          vwrradr_reg[vprt_int][vdel_int] <= vwrradr_reg[vprt_int][vdel_int-1];
          vdin_reg[vprt_int][vdel_int] <= vdin_reg[vprt_int][vdel_int-1];
        end
      end else begin
        vread_reg[vdel_int] <= vread_wire;
        vrdbadr_reg[vdel_int] <= vrdbadr_wire;
        vrdradr_reg[vdel_int] <= vrdradr_wire;
        for (vprt_int=0; vprt_int<NUMWRPT; vprt_int=vprt_int+1) begin
          vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int] && (vwraddr_wire[vprt_int] < NUMADDR);
          vwrbadr_reg[vprt_int][vdel_int] <= vwrbadr_wire[vprt_int];
          vwrradr_reg[vprt_int][vdel_int] <= vwrradr_wire[vprt_int];
          vdin_reg[vprt_int][vdel_int] <= vdin_wire[vprt_int];
        end
      end

  reg vread_out;
  reg [BITVBNK-1:0] vrdbadr_out;
  reg [BITVROW-1:0] vrdradr_out;
  reg vwrite_out [0:NUMWRPT-1];
  reg [BITVBNK-1:0] vwrbadr_out [0:NUMWRPT-1];
  reg [BITVROW-1:0] vwrradr_out [0:NUMWRPT-1];
  reg [WIDTH-1:0] vdin_out [0:NUMWRPT-1];
  integer vout_int, vwpt_int;
  always_comb begin
    vread_out = vread_reg[SRAM_DELAY-1];
    vrdbadr_out = vrdbadr_reg[SRAM_DELAY-1];
    vrdradr_out = vrdradr_reg[SRAM_DELAY-1];
    for (vout_int=0; vout_int<NUMWRPT; vout_int=vout_int+1) begin
      vwrite_out[vout_int] = vwrite_reg[vout_int][SRAM_DELAY-1];
      vwrbadr_out[vout_int] = vwrbadr_reg[vout_int][SRAM_DELAY-1];
      vwrradr_out[vout_int] = vwrradr_reg[vout_int][SRAM_DELAY-1];
      vdin_out[vout_int] = vdin_reg[vout_int][SRAM_DELAY-1];
    end
  end

  // Read request of mapping information on SRAM memory
  assign sread0 = vwrite_wire[0] && !(swrite && (swrradr == vwrradr_wire[0]));
  assign srdradr0 = vwrradr_wire[0];
  assign sread1 = vwrite_wire[0] && !(swrite && (swrradr == vwrradr_wire[0]));
  assign srdradr1 = vwrradr_wire[0];
  assign sread2 = vread_wire && !(swrite && (swrradr == vrdradr_wire));
  assign srdradr2 = vrdradr_wire;
  assign sread3 = vread_wire && !(swrite && (swrradr == vrdradr_wire));
  assign srdradr3 = vrdradr_wire;

  reg               wrmap_vld [0:SRAM_DELAY-1];
  reg [BITMAPT-1:0] wrmap_reg [0:SRAM_DELAY-1];
  reg               rdmap_vld [0:SRAM_DELAY-1];
  reg [BITMAPT-1:0] rdmap_reg [0:SRAM_DELAY-1];
  integer sfwd_int;
  always @(posedge clk)
    for (sfwd_int=0; sfwd_int<SRAM_DELAY; sfwd_int=sfwd_int+1) begin
      if (sfwd_int>0) begin
        if (swrite && (swrradr == vwrradr_reg[0][sfwd_int-1])) begin
          wrmap_vld[sfwd_int] <= 1'b1;
          wrmap_reg[sfwd_int] <= sdin;
        end else begin
          wrmap_vld[sfwd_int] <= wrmap_vld[sfwd_int-1];
          wrmap_reg[sfwd_int] <= wrmap_reg[sfwd_int-1];
        end
        if (swrite && (swrradr == vrdradr_reg[sfwd_int-1])) begin
          rdmap_vld[sfwd_int] <= 1'b1;
          rdmap_reg[sfwd_int] <= sdin;
        end else begin
          rdmap_vld[sfwd_int] <= rdmap_vld[sfwd_int-1];
          rdmap_reg[sfwd_int] <= rdmap_reg[sfwd_int-1];
        end
      end else begin
        if (swrite && (swrradr == vwrradr_wire[0])) begin
          wrmap_vld[sfwd_int] <= 1'b1;
          wrmap_reg[sfwd_int] <= sdin;
        end else begin
          wrmap_vld[sfwd_int] <= 1'b0;
          wrmap_reg[sfwd_int] <= 0;
        end
        if (swrite && (swrradr == vrdradr_wire)) begin
          rdmap_vld[sfwd_int] <= 1'b1;
          rdmap_reg[sfwd_int] <= sdin;
        end else begin
          rdmap_vld[sfwd_int] <= 1'b0;
          rdmap_reg[sfwd_int] <= 0;
        end
      end
    end

// ECC Checking Module for SRAM
  wire [BITMAPT-1:0] sdout0_out = sderr0 ? sdout1 : sdout0;
  wire [BITMAPT-1:0] sdout1_out = sderr2 ? sdout3 : sdout2;

  wire [BITMAPT-1:0] wrmap_out [0:NUMWRPT-1];
  wire [BITMAPT-1:0] rdmap_out [0:NUMWRPT-1];

  assign wrmap_out[0] = wrmap_vld[SRAM_DELAY-1] ? wrmap_reg[SRAM_DELAY-1] : sdout0_out;
  assign rdmap_out[0] = rdmap_vld[SRAM_DELAY-1] ? rdmap_reg[SRAM_DELAY-1] : sdout1_out;

  reg [BITPBNK-1:0] rdbnk_tmp [0:NUMWRPT-1];
  reg [BITPBNK-1:0] rdbnk_out;
  integer rdb_int;
  always_comb begin
    rdbnk_out = vrdbadr_out;
    for (rdb_int=0; rdb_int<NUMWRPT; rdb_int=rdb_int+1) begin
      rdbnk_tmp[rdb_int] = rdmap_out[rdb_int] >> (vrdbadr_out*BITPBNK);
      if (!(&rdbnk_tmp[rdb_int]))
        rdbnk_out = rdbnk_tmp[rdb_int];
    end
  end

  reg [BITPBNK-1:0] wrbnk_tmp [0:NUMWRPT-1];
  reg [BITPBNK-1:0] wrfre_tmp [0:NUMWRPT-1];
  reg [BITPBNK-1:0] wrbnk_out [0:NUMWRPT-1];
  reg [BITPBNK-1:0] wrfre_out [0:NUMWRPT-1];
  reg cflt [0:NUMWRPT-1];
  integer cflt_int;
  always_comb
    for (cflt_int=0; cflt_int<NUMWRPT; cflt_int=cflt_int+1) begin
      wrbnk_tmp[cflt_int] = wrmap_out[cflt_int] >> (vwrbadr_out[cflt_int]*BITPBNK);
      wrfre_tmp[cflt_int] = wrmap_out[cflt_int] >> (NUMVBNK*BITPBNK);
      wrbnk_out[cflt_int] = (&wrbnk_tmp[cflt_int]) ? vwrbadr_out[cflt_int] : wrbnk_tmp[cflt_int];
      wrfre_out[cflt_int] = (&wrfre_tmp[cflt_int]) ? NUMVBNK+cflt_int : wrfre_tmp[cflt_int];
      cflt[cflt_int] = vread_out && vwrite_out[cflt_int] && (rdbnk_out == wrbnk_out[cflt_int]);
    end

  wire pread_tmp = vread_out;
  wire [BITPBNK-1:0] prdbadr_tmp = rdbnk_out;
  wire [BITVROW-1:0] prdradr_tmp = vrdradr_out;

  wire [BITPBNK-1:0] pwrbadr_tmp = cflt[0] ? wrfre_out[0] : wrbnk_out[0];
  wire [BITVROW-1:0] pwrradr_tmp = vwrradr_out[0];
  wire [WIDTH-1:0] pdin_tmp = vdin_out[0];
  wire pwrite_tmp = vwrite_out[0] && !(pread_tmp && (prdbadr_tmp==pwrbadr_tmp));

  reg pwrite;
  reg [(BITPBNK+BITVROW)-1:0] pwraddr;
  reg [WIDTH-1:0] pdin;
  reg pread;
  reg [(BITPBNK+BITVROW)-1:0] prdaddr;
  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      pwrite <= pwrite_tmp;
      pwraddr <= {pwrbadr_tmp,pwrradr_tmp};
      pdin <= pdin_tmp;
      pread <= pread_tmp;
      prdaddr <= {prdbadr_tmp,prdradr_tmp};
    end
  end else begin: nflp_loop
    always_comb begin
      pwrite = pwrite_tmp;
      pwraddr = {pwrbadr_tmp,pwrradr_tmp};
      pdin = pdin_tmp;
      pread = pread_tmp;
      prdaddr = {prdbadr_tmp,prdradr_tmp};
    end
  end
  endgenerate

  assign swrite = (rstvld && !rst) || vwrite_out[0];
  assign swrradr = rstvld ? rstaddr : vwrradr_out[0];
  assign sdin = rstvld ? ~0 :
                cflt[0] ? ((wrmap_out[0] & ~({BITPBNK{1'b1}} << (vwrbadr_out[0]*BITPBNK)) & ~({BITPBNK{1'b1}} << (NUMVBNK*BITPBNK))) |
                           (wrfre_out[0] << (vwrbadr_out[0]*BITPBNK)) | (wrbnk_out[0] << (NUMVBNK*BITPBNK))) :
                          ((wrmap_out[0] & ~({BITPBNK{1'b1}} << (vwrbadr_out[0]*BITPBNK)) & ~({BITPBNK{1'b1}} << (NUMVBNK*BITPBNK))) |
                           (wrbnk_out[0] << (vwrbadr_out[0]*BITPBNK)) | (wrfre_out[0] << (NUMVBNK*BITPBNK)));

  assign vdout = pdout;

endmodule
