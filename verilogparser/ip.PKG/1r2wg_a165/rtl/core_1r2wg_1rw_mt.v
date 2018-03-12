
module core_1r2wg_1rw_mt (vwrite0, vwraddr0, vdin0,
                          vwrite1, vwraddr1, vdin1,
                          vread, vrdaddr, vdout,
                          pwrite0, pwraddr0, pdin0,
                          pwrite1, pwraddr1, pdin1,
                          pread, prdaddr, pdout,
   	                  swrite0, swrradr0, sdin0,
   	                  swrite1, swrradr1, sdin1,
                          sread0, srdradr0, sdout0, sserr0, sderr0,
                          sread1, srdradr1, sdout1, sserr1, sderr1,
                          sread2, srdradr2, sdout2, sserr2, sderr2,
                          sread3, srdradr3, sdout3, sserr3, sderr3,
                          sread4, srdradr4, sdout4, sserr4, sderr4,
                          sread5, srdradr5, sdout5, sserr5, sderr5,
                          sread6, srdradr6, sdout6, sserr6, sderr6,
                          sread7, srdradr7, sdout7, sserr7, sderr7,
                          ready, clk, rst);

  parameter WIDTH = 1794;
  parameter NUMWRPT = 2;
  parameter NUMADDR = 147456;
  parameter BITADDR = 18;
  parameter NUMVROW = 4096;
  parameter BITVROW = 12;
  parameter NUMVBNK = 36;
  parameter BITVBNK = 6;
  parameter NUMPBNK = 38;
  parameter BITPBNK = 6;
  
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter BITMAPT = BITPBNK*(NUMPBNK-1);

  input                               vread;
  input [BITADDR-1:0]                 vrdaddr;
  output [WIDTH-1:0]                  vdout;

  input                               vwrite0;
  input [BITADDR-1:0]                 vwraddr0;
  input [WIDTH-1:0]                   vdin0;

  input                               vwrite1;
  input [BITADDR-1:0]                 vwraddr1;
  input [WIDTH-1:0]                   vdin1;

  output                              pwrite0;
  output [(BITPBNK+BITVROW)-1:0]      pwraddr0;
  output [WIDTH-1:0]                  pdin0;

  output                              pwrite1;
  output [(BITPBNK+BITVROW)-1:0]      pwraddr1;
  output [WIDTH-1:0]                  pdin1;

  output                              pread;
  output [(BITPBNK+BITVROW)-1:0]      prdaddr;
  input [WIDTH-1:0]                   pdout;

  output                              swrite0;
  output [BITVROW-1:0]                swrradr0;
  output [BITMAPT-1:0]                sdin0;

  output                              swrite1;
  output [BITVROW-1:0]                swrradr1;
  output [BITMAPT-1:0]                sdin1;

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
  
  output                              sread4;
  output [BITVROW-1:0]                srdradr4;
  input                               sserr4;
  input                               sderr4;
  input [BITMAPT-1:0]                 sdout4;
  
  output                              sread5;
  output [BITVROW-1:0]                srdradr5;
  input                               sserr5;
  input                               sderr5;
  input [BITMAPT-1:0]                 sdout5;
  
  output                              sread6;
  output [BITVROW-1:0]                srdradr6;
  input                               sserr6;
  input                               sderr6;
  input [BITMAPT-1:0]                 sdout6;
  
  output                              sread7;
  output [BITVROW-1:0]                srdradr7;
  input                               sserr7;
  input                               sderr7;
  input [BITMAPT-1:0]                 sdout7;
  
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
      vwrite_reg <= {vwrite1,vwrite0} & {NUMWRPT{ready}};
      vwraddr_reg <= {vwraddr1,vwraddr0};
      vdin_reg <= {vdin1,vdin0};
    end

    assign vread_wire = vread_reg;
    assign vrdaddr_wire = vrdaddr_reg;
    assign vrdbadr_wire = vrdaddr_reg[BITADDR-1:BITVROW];
    assign vrdradr_wire = vrdaddr_reg[BITVROW-1:0];
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite_reg >> np2_var;
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
      assign vwrite_wire[np2_var] = ({vwrite1,vwrite0} & {NUMWRPT{ready}}) >> np2_var;
      assign vwraddr_wire[np2_var] = {vwraddr1,vwraddr0} >> (np2_var*BITADDR);
      assign vwrbadr_wire[np2_var] = vwraddr_wire[np2_var][BITADDR-1:BITVROW];
      assign vwrradr_wire[np2_var] = vwraddr_wire[np2_var][BITVROW-1:0];
      assign vdin_wire[np2_var] = {vdin1,vdin0} >> (np2_var*WIDTH);
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
  assign sread0 = vwrite_wire[0] && !(swrite0 && (swrradr0 == vwrradr_wire[0]));
  assign srdradr0 = vwrradr_wire[0];
  assign sread1 = vwrite_wire[0] && !(swrite0 && (swrradr0 == vwrradr_wire[0]));
  assign srdradr1 = vwrradr_wire[0];
  assign sread2 = vread_wire && !(swrite0 && (swrradr0 == vrdradr_wire));
  assign srdradr2 = vrdradr_wire;
  assign sread3 = vread_wire && !(swrite0 && (swrradr0 == vrdradr_wire));
  assign srdradr3 = vrdradr_wire;
  assign sread4 = vwrite_wire[1] && !(swrite1 && (swrradr1 == vwrradr_wire[1]));
  assign srdradr4 = vwrradr_wire[1];
  assign sread5 = vwrite_wire[1] && !(swrite1 && (swrradr1 == vwrradr_wire[1]));
  assign srdradr5 = vwrradr_wire[1];
  assign sread6 = vread_wire && !(swrite1 && (swrradr1 == vrdradr_wire));
  assign srdradr6 = vrdradr_wire;
  assign sread7 = vread_wire && !(swrite1 && (swrradr1 == vrdradr_wire));
  assign srdradr7 = vrdradr_wire;

  reg               wrmap0_vld [0:SRAM_DELAY-1];
  reg [BITMAPT-1:0] wrmap0_reg [0:SRAM_DELAY-1];
  reg               rdmap0_vld [0:SRAM_DELAY-1];
  reg [BITMAPT-1:0] rdmap0_reg [0:SRAM_DELAY-1];
  reg               wrmap1_vld [0:SRAM_DELAY-1];
  reg [BITMAPT-1:0] wrmap1_reg [0:SRAM_DELAY-1];
  reg               rdmap1_vld [0:SRAM_DELAY-1];
  reg [BITMAPT-1:0] rdmap1_reg [0:SRAM_DELAY-1];
  integer sfwd_int;
  always @(posedge clk)
    for (sfwd_int=0; sfwd_int<SRAM_DELAY; sfwd_int=sfwd_int+1) begin
      if (sfwd_int>0) begin
        if (swrite0 && (swrradr0 == vwrradr_reg[0][sfwd_int-1])) begin
          wrmap0_vld[sfwd_int] <= 1'b1;
          wrmap0_reg[sfwd_int] <= sdin0;
        end else begin
          wrmap0_vld[sfwd_int] <= wrmap0_vld[sfwd_int-1];
          wrmap0_reg[sfwd_int] <= wrmap0_reg[sfwd_int-1];
        end
        if (swrite0 && (swrradr0 == vrdradr_reg[sfwd_int-1])) begin
          rdmap0_vld[sfwd_int] <= 1'b1;
          rdmap0_reg[sfwd_int] <= sdin0;
        end else begin
          rdmap0_vld[sfwd_int] <= rdmap0_vld[sfwd_int-1];
          rdmap0_reg[sfwd_int] <= rdmap0_reg[sfwd_int-1];
        end
        if (swrite1 && (swrradr1 == vwrradr_reg[1][sfwd_int-1])) begin
          wrmap1_vld[sfwd_int] <= 1'b1;
          wrmap1_reg[sfwd_int] <= sdin1;
        end else begin
          wrmap1_vld[sfwd_int] <= wrmap1_vld[sfwd_int-1];
          wrmap1_reg[sfwd_int] <= wrmap1_reg[sfwd_int-1];
        end
        if (swrite1 && (swrradr1 == vrdradr_reg[sfwd_int-1])) begin
          rdmap1_vld[sfwd_int] <= 1'b1;
          rdmap1_reg[sfwd_int] <= sdin1;
        end else begin
          rdmap1_vld[sfwd_int] <= rdmap1_vld[sfwd_int-1];
          rdmap1_reg[sfwd_int] <= rdmap1_reg[sfwd_int-1];
        end
      end else begin
        if (swrite0 && (swrradr0 == vwrradr_wire[0])) begin
          wrmap0_vld[sfwd_int] <= 1'b1;
          wrmap0_reg[sfwd_int] <= sdin0;
        end else begin
          wrmap0_vld[sfwd_int] <= 1'b0;
          wrmap0_reg[sfwd_int] <= 0;
        end
        if (swrite0 && (swrradr0 == vrdradr_wire)) begin
          rdmap0_vld[sfwd_int] <= 1'b1;
          rdmap0_reg[sfwd_int] <= sdin0;
        end else begin
          rdmap0_vld[sfwd_int] <= 1'b0;
          rdmap0_reg[sfwd_int] <= 0;
        end
        if (swrite1 && (swrradr1 == vwrradr_wire[1])) begin
          wrmap1_vld[sfwd_int] <= 1'b1;
          wrmap1_reg[sfwd_int] <= sdin1;
        end else begin
          wrmap1_vld[sfwd_int] <= 1'b0;
          wrmap1_reg[sfwd_int] <= 0;
        end
        if (swrite1 && (swrradr1 == vrdradr_wire)) begin
          rdmap1_vld[sfwd_int] <= 1'b1;
          rdmap1_reg[sfwd_int] <= sdin1;
        end else begin
          rdmap1_vld[sfwd_int] <= 1'b0;
          rdmap1_reg[sfwd_int] <= 0;
        end
      end
    end

// ECC Checking Module for SRAM
  wire [BITMAPT-1:0] sdout0_out = sderr0 ? sdout1 : sdout0;
  wire [BITMAPT-1:0] sdout1_out = sderr2 ? sdout3 : sdout2;
  wire [BITMAPT-1:0] sdout2_out = sderr4 ? sdout5 : sdout4;
  wire [BITMAPT-1:0] sdout3_out = sderr6 ? sdout7 : sdout6;

  wire [BITMAPT-1:0] wrmap_out [0:NUMWRPT-1];
  wire [BITMAPT-1:0] rdmap_out [0:NUMWRPT-1];

  assign wrmap_out[0] = wrmap0_vld[SRAM_DELAY-1] ? wrmap0_reg[SRAM_DELAY-1] : sdout0_out;
  assign rdmap_out[0] = rdmap0_vld[SRAM_DELAY-1] ? rdmap0_reg[SRAM_DELAY-1] : sdout1_out;
  assign wrmap_out[1] = wrmap1_vld[SRAM_DELAY-1] ? wrmap1_reg[SRAM_DELAY-1] : sdout2_out;
  assign rdmap_out[1] = rdmap1_vld[SRAM_DELAY-1] ? rdmap1_reg[SRAM_DELAY-1] : sdout3_out;

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

  wire [BITPBNK-1:0] pwrbadr0_tmp = cflt[0] ? wrfre_out[0] : wrbnk_out[0];
  wire [BITVROW-1:0] pwrradr0_tmp = vwrradr_out[0];
  wire [WIDTH-1:0] pdin0_tmp = vdin_out[0];
  wire pwrite0_tmp = vwrite_out[0] && !(pread_tmp && (prdbadr_tmp==pwrbadr0_tmp));

  wire [BITPBNK-1:0] pwrbadr1_tmp = cflt[1] ? wrfre_out[1] : wrbnk_out[1];
  wire [BITVROW-1:0] pwrradr1_tmp = vwrradr_out[1];
  wire [WIDTH-1:0] pdin1_tmp = vdin_out[1];
  wire pwrite1_tmp = vwrite_out[1] && !(pread_tmp && (prdbadr_tmp==pwrbadr1_tmp));

  reg pwrite0;
  reg [(BITPBNK+BITVROW)-1:0] pwraddr0;
  reg [WIDTH-1:0] pdin0;
  reg pwrite1;
  reg [(BITPBNK+BITVROW)-1:0] pwraddr1;
  reg [WIDTH-1:0] pdin1;
  reg pread;
  reg [(BITPBNK+BITVROW)-1:0] prdaddr;
  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      pwrite0 <= pwrite0_tmp;
      pwraddr0 <= {pwrbadr0_tmp,pwrradr0_tmp};
      pdin0 <= pdin0_tmp;
      pwrite1 <= pwrite1_tmp;
      pwraddr1 <= {pwrbadr1_tmp,pwrradr1_tmp};
      pdin1 <= pdin1_tmp;
      pread <= pread_tmp;
      prdaddr <= {prdbadr_tmp,prdradr_tmp};
    end
  end else begin: nflp_loop
    always_comb begin
      pwrite0 = pwrite0_tmp;
      pwraddr0 = {pwrbadr0_tmp,pwrradr0_tmp};
      pdin0 = pdin0_tmp;
      pwrite1 = pwrite1_tmp;
      pwraddr1 = {pwrbadr1_tmp,pwrradr1_tmp};
      pdin1 = pdin1_tmp;
      pread = pread_tmp;
      prdaddr = {prdbadr_tmp,prdradr_tmp};
    end
  end
  endgenerate

  assign swrite0 = (rstvld && !rst) || vwrite_out[0];
  assign swrradr0 = rstvld ? rstaddr : vwrradr_out[0];
  assign sdin0 = rstvld ? ~0 :
                 cflt[0] ? ((wrmap_out[0] & ~({BITPBNK{1'b1}} << (vwrbadr_out[0]*BITPBNK)) & ~({BITPBNK{1'b1}} << (NUMVBNK*BITPBNK))) |
                            (wrfre_out[0] << (vwrbadr_out[0]*BITPBNK)) | (wrbnk_out[0] << (NUMVBNK*BITPBNK))) :
                           ((wrmap_out[0] & ~({BITPBNK{1'b1}} << (vwrbadr_out[0]*BITPBNK)) & ~({BITPBNK{1'b1}} << (NUMVBNK*BITPBNK))) |
                            (wrbnk_out[0] << (vwrbadr_out[0]*BITPBNK)) | (wrfre_out[0] << (NUMVBNK*BITPBNK)));

  assign swrite1 = (rstvld && !rst) || vwrite_out[1];
  assign swrradr1 = rstvld ? rstaddr : vwrradr_out[1];
  assign sdin1 = rstvld ? ~0 :
                 cflt[1] ? ((wrmap_out[1] & ~({BITPBNK{1'b1}} << (vwrbadr_out[1]*BITPBNK)) & ~({BITPBNK{1'b1}} << (NUMVBNK*BITPBNK))) |
                            (wrfre_out[1] << (vwrbadr_out[1]*BITPBNK)) | (wrbnk_out[1] << (NUMVBNK*BITPBNK))) :
                           ((wrmap_out[1] & ~({BITPBNK{1'b1}} << (vwrbadr_out[1]*BITPBNK)) & ~({BITPBNK{1'b1}} << (NUMVBNK*BITPBNK))) |
                            (wrbnk_out[1] << (vwrbadr_out[1]*BITPBNK)) | (wrfre_out[1] << (NUMVBNK*BITPBNK)));

  assign vdout = pdout;

endmodule
