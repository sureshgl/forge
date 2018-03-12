module core_nru_1r1w_mt (vread, vwrite, vaddr, vdin, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                         t1_writeA, t1_addrA, t1_dinA,
                         t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                         t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                         ready, clk, rst);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter NUMRUPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMPBNK = 11;
  parameter BITPBNK = 4;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter BITPADR = 14;
  parameter MEMWDTH = ENAPAR ? NUMWRDS*WIDTH+1 : ENAECC ? NUMWRDS*WIDTH+ECCWDTH : NUMWRDS*WIDTH;
  
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPPWR = 0;
  parameter FLOPOUT = 0;

  parameter BITMAPT = BITPBNK*NUMVBNK;

  input [NUMRUPT-1:0]           vread;
  input [NUMRUPT-1:0]           vwrite;
  input [NUMRUPT*BITADDR-1:0]   vaddr;
  input [NUMRUPT*WIDTH-1:0]     vdin;
  output [NUMRUPT-1:0]          vread_vld;
  output [NUMRUPT*WIDTH-1:0]    vdout;
  output [NUMRUPT-1:0]          vread_fwrd;
  output [NUMRUPT-1:0]          vread_serr;
  output [NUMRUPT-1:0]          vread_derr;
  output [NUMRUPT*BITPADR-1:0]  vread_padr;

  output [NUMRUPT*NUMPBNK-1:0]         t1_writeA;
  output [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrA;
  output [NUMRUPT*NUMPBNK*MEMWDTH-1:0]  t1_dinA;
  output [NUMRUPT*NUMPBNK-1:0]         t1_readB;
  output [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrB;
  input [NUMRUPT*NUMPBNK*MEMWDTH-1:0]   t1_doutB;
  input [NUMRUPT*NUMPBNK-1:0]          t1_fwrdB;
  input [NUMRUPT*NUMPBNK-1:0]          t1_serrB;
  input [NUMRUPT*NUMPBNK-1:0]          t1_derrB;
  input [NUMRUPT*NUMPBNK*(BITPADR-BITPBNK-BITWRDS)-1:0] t1_padrB;

  output [(NUMRUPT-1)-1:0]          t2_writeA;
  output [(NUMRUPT-1)*BITSROW-1:0]  t2_addrA;
  output [(NUMRUPT-1)*BITMAPT-1:0]  t2_dinA;

  output [NUMRUPT-1:0]              t2_readB;
  output [NUMRUPT*BITSROW-1:0]      t2_addrB;
  input [NUMRUPT*BITMAPT-1:0]       t2_doutB;
  
  output                             ready;
  input                              clk;
  input                              rst;

  reg [BITSROW:0] rstaddr;
  wire rstvld = rstaddr < NUMSROW;
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg [BITMAPT-1:0] rstdin;
  integer rst_int;
  always_comb begin
    rstdin = 0;
    for (rst_int=0; rst_int<NUMVBNK; rst_int=rst_int+1)
      rstdin = rstdin | (rst_int << (rst_int*BITPBNK));
  end

  reg ready;
  always @(posedge clk)
    ready <= !rstvld;

  wire               ready_wire;
  wire               vread_wire [0:NUMRUPT-1];
  wire               vwrite_wire [0:NUMRUPT-1];
  wire [BITADDR-1:0] vaddr_wire [0:NUMRUPT-1];
  wire [BITVBNK-1:0] vbadr_wire [0:NUMRUPT-1];
  wire [BITVROW-1:0] vradr_temp [0:NUMRUPT-1];
  wire [BITWRDS-1:0] vwadr_wire [0:NUMRUPT-1];
  wire [BITSROW-1:0] vradr_wire [0:NUMRUPT-1];
  wire [WIDTH-1:0]   vdin_wire [0:NUMRUPT-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMRUPT-1:0] vread_reg;
    reg [NUMRUPT-1:0] vwrite_reg;
    reg [NUMRUPT*BITADDR-1:0] vaddr_reg;
    reg [NUMRUPT*WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread & {NUMRUPT{ready}};
      vwrite_reg <= vwrite & {NUMRUPT{ready}};
      vaddr_reg <= vaddr;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    for (np2_var=0; np2_var<NUMRUPT; np2_var=np2_var+1) begin: ru_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
      assign vwrite_wire[np2_var] = vwrite_reg >> np2_var;
      assign vaddr_wire[np2_var] = vaddr_reg >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        badr_inst (.vbadr(vbadr_wire[np2_var]), .vradr(vradr_temp[np2_var]), .vaddr(vaddr_wire[np2_var]));

      if (NUMWRDS>1) begin: wd_loop
        np2_addr #(.NUMADDR (NUMVROW), .BITADDR (BITVROW),
                   .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                   .NUMVROW (NUMSROW), .BITVROW (BITSROW))
          wadr_inst (.vbadr(vwadr_wire[np2_var]), .vradr(vradr_wire[np2_var]), .vaddr(vradr_temp[np2_var]));
      end else begin: nwd_loop
        assign vwadr_wire[np2_var] = 0;
        assign vradr_wire[np2_var] = vradr_temp[np2_var];
      end
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (np2_var=0; np2_var<NUMRUPT; np2_var=np2_var+1) begin: ru_loop
      assign vread_wire[np2_var] = (vread & {NUMRUPT{ready}}) >> np2_var;
      assign vwrite_wire[np2_var] = (vwrite & {NUMRUPT{ready}}) >> np2_var;
      assign vaddr_wire[np2_var] = vaddr >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        badr_inst (.vbadr(vbadr_wire[np2_var]), .vradr(vradr_temp[np2_var]), .vaddr(vaddr_wire[np2_var]));

      if (NUMWRDS>1) begin: wd_loop
        np2_addr #(.NUMADDR (NUMVROW), .BITADDR (BITVROW),
                   .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                   .NUMVROW (NUMSROW), .BITVROW (BITSROW))
          wadr_inst (.vbadr(vwadr_wire[np2_var]), .vradr(vradr_wire[np2_var]), .vaddr(vradr_temp[np2_var]));
      end else begin: nwd_loop
        assign vwadr_wire[np2_var] = 0;
        assign vradr_wire[np2_var] = vradr_temp[np2_var];
      end
    end
  end
  endgenerate

  reg                vread_reg [0:NUMRUPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
  reg [BITVBNK-1:0]  vbadr_reg [0:NUMRUPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
  reg [BITWRDS-1:0]  vwadr_reg [0:NUMRUPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
  reg [BITSROW-1:0]  vradr_reg [0:NUMRUPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
  integer vprt_int, vdel_int; 
  always @(posedge clk) begin
    for (vprt_int=0; vprt_int<NUMRUPT; vprt_int=vprt_int+1)
      for (vdel_int=0; vdel_int<SRAM_DELAY+DRAM_DELAY; vdel_int=vdel_int+1)
        if (vdel_int > 0) begin
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
          vbadr_reg[vprt_int][vdel_int] <= vbadr_reg[vprt_int][vdel_int-1];
          vwadr_reg[vprt_int][vdel_int] <= vwadr_reg[vprt_int][vdel_int-1];
          vradr_reg[vprt_int][vdel_int] <= vradr_reg[vprt_int][vdel_int-1];
        end else begin
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
          vbadr_reg[vprt_int][vdel_int] <= vbadr_wire[vprt_int];
          vwadr_reg[vprt_int][vdel_int] <= vwadr_wire[vprt_int];
          vradr_reg[vprt_int][vdel_int] <= vradr_wire[vprt_int];
        end
  end 

  reg vread_out [0:NUMRUPT-1];
  reg [BITVBNK-1:0] vrdbadr_out [0:NUMRUPT-1];
  reg [BITWRDS-1:0] vrdwadr_out [0:NUMRUPT-1];
  reg [BITSROW-1:0] vrdradr_out [0:NUMRUPT-1];
  reg vwrite_out [0:NUMRUPT-1];
  reg [BITVBNK-1:0] vwrbadr_out [0:NUMRUPT-1];
  reg [BITWRDS-1:0] vwrwadr_out [0:NUMRUPT-1];
  reg [BITSROW-1:0] vwrradr_out [0:NUMRUPT-1];
  reg [WIDTH-1:0] vdin_out [0:NUMRUPT-1];
  integer vout_int;
  always_comb begin
    for (vout_int=0; vout_int<NUMRUPT; vout_int=vout_int+1) begin
      vread_out[vout_int] = vread_reg[vout_int][SRAM_DELAY-1];
      vrdbadr_out[vout_int] = vbadr_reg[vout_int][SRAM_DELAY-1];
      vrdwadr_out[vout_int] = vwadr_reg[vout_int][SRAM_DELAY-1];
      vrdradr_out[vout_int] = vradr_reg[vout_int][SRAM_DELAY-1];
      vwrite_out[vout_int] = vread_reg[vout_int][SRAM_DELAY+DRAM_DELAY-1] && vwrite_wire[vout_int];
      vwrbadr_out[vout_int] = vbadr_reg[vout_int][SRAM_DELAY+DRAM_DELAY-1];
      vwrwadr_out[vout_int] = vwadr_reg[vout_int][SRAM_DELAY+DRAM_DELAY-1];
      vwrradr_out[vout_int] = vradr_reg[vout_int][SRAM_DELAY+DRAM_DELAY-1];
      vdin_out[vout_int] = vdin_wire[vout_int];
    end
  end
/*
  wire vwrite_out_0 = vwrite_out[0];
  wire [BITVBNK-1:0] vwrbadr_out_0 = vwrbadr_out[0];
  wire [BITWRDS-1:0] vwrwadr_out_0 = vwrwadr_out[0];
  wire [BITSROW-1:0] vwrradr_out_0 = vwrradr_out[0];
  wire [WIDTH-1:0] vdin_out_0 = vdin_out[0];

  wire vread_out_0 = vread_out[0];
  wire [BITVBNK-1:0] vrdbadr_out_0 = vrdbadr_out[0];
  wire [BITWRDS-1:0] vrdwadr_out_0 = vrdwadr_out[0];
  wire [BITSROW-1:0] vrdradr_out_0 = vrdradr_out[0];

  wire vread_out_1 = vread_out[1];
  wire [BITVBNK-1:0] vrdbadr_out_1 = vrdbadr_out[1];
  wire [BITSROW-1:0] vrdradr_out_1 = vrdradr_out[1];
*/
  reg pwrite_wire [0:NUMRUPT-1];
  reg [BITPBNK-1:0] pwrbadr_wire [0:NUMRUPT-1];
  reg [BITSROW-1:0] pwrradr_wire [0:NUMRUPT-1];
  reg [MEMWDTH-1:0] pdin_wire [0:NUMRUPT-1];
/*
  wire pwrite_wire_0 = pwrite_wire[0];
  wire [BITPBNK-1:0] pwrbadr_wire_0 = pwrbadr_wire[0];
  wire [BITSROW-1:0] pwrradr_wire_0 = pwrradr_wire[0];
  wire [MEMWDTH-1:0] pdin_wire_0 = pdin_wire[0];

  wire pwrite_wire_1 = pwrite_wire[1];
  wire [BITPBNK-1:0] pwrbadr_wire_1 = pwrbadr_wire[1];
  wire [BITSROW-1:0] pwrradr_wire_1 = pwrradr_wire[1];
  wire [MEMWDTH-1:0] pdin_wire_1 = pdin_wire[1];

  wire pwrite_wire_2 = pwrite_wire[2];
  wire [BITPBNK-1:0] pwrbadr_wire_2 = pwrbadr_wire[2];
  wire [BITSROW-1:0] pwrradr_wire_2 = pwrradr_wire[2];
  wire [MEMWDTH-1:0] pdin_wire_2 = pdin_wire[2];
*/
  // Read request of mapping information on SRAM memory
  reg swrite_wire [0:(NUMRUPT-1)-1];
  reg [BITSROW-1:0] swrradr_wire [0:(NUMRUPT-1)-1];
  reg [BITMAPT-1:0] sdin_wire [0:(NUMRUPT-1)-1];
/*
  wire swrite_wire_0 = swrite_wire[0];
  wire [BITVROW-1:0] swrradr_wire_0 = swrradr_wire[0];
  wire [BITMAPT-1:0] sdin_wire_0 = sdin_wire[0];
  wire swrite_wire_1 = swrite_wire[1];
  wire [BITVROW-1:0] swrradr_wire_1 = swrradr_wire[1];
  wire [BITMAPT-1:0] sdin_wire_1 = sdin_wire[1];
  wire swrite_wire_2 = swrite_wire[2];
  wire [BITVROW-1:0] swrradr_wire_2 = swrradr_wire[2];
  wire [BITMAPT-1:0] sdin_wire_2 = sdin_wire[2];
*/
  reg sread_wire [0:NUMRUPT-1];
  reg [BITSROW-1:0] srdradr_wire [0:NUMRUPT-1];
  integer srdp_int, srdc_int, srdw_int;
  always_comb
    for (srdp_int=0; srdp_int<NUMRUPT; srdp_int=srdp_int+1) begin
      sread_wire[srdp_int] = vread_wire[srdp_int];
//      for (srdw_int=0; srdw_int<NUMRUPT-1; srdw_int=srdw_int+1) begin
//        sread_wire[srdp_int] = sread_wire[srdp_int] && !(swrite_wire[srdw_int] && (swrradr_wire[srdw_int] == vrdradr_wire[srdp_int-NUMRUPT]));
//      end
      srdradr_wire[srdp_int] = vradr_wire[srdp_int];
    end
/*
  wire sread_wire_0 = sread_wire[0];
  wire [BITVROW-1:0] srdradr_wire_0 = srdradr_wire[0];
  wire sread_wire_1 = sread_wire[1];
  wire [BITVROW-1:0] srdradr_wire_1 = srdradr_wire[1];
  wire sread_wire_2 = sread_wire[2];
  wire [BITVROW-1:0] srdradr_wire_2 = srdradr_wire[2];
  wire sread_wire_3 = sread_wire[3];
  wire [BITVROW-1:0] srdradr_wire_3 = srdradr_wire[3];
*/
  reg [BITMAPT-1:0] sdout_wire [0:NUMRUPT-1];
  reg               map_vld [0:NUMRUPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
  reg [BITMAPT-1:0] map_reg [0:NUMRUPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
  genvar sprt_int, sfwd_int;
  generate
    for (sfwd_int=0; sfwd_int<SRAM_DELAY+DRAM_DELAY; sfwd_int=sfwd_int+1) begin: map_loop
      for (sprt_int=0; sprt_int<NUMRUPT; sprt_int=sprt_int+1) begin: prt_loop
        reg [BITSROW-1:0] vradr_temp;
        reg map_vld_next;
        reg [BITMAPT-1:0] map_reg_next;
        integer swpt_int;
        always_comb begin
          if (sfwd_int==SRAM_DELAY) begin
            if (map_vld[sprt_int][sfwd_int-1]) begin 
	      vradr_temp = vradr_reg[sprt_int][sfwd_int-1];
              map_vld_next = map_vld[sprt_int][sfwd_int-1];
              map_reg_next = map_reg[sprt_int][sfwd_int-1];
            end else begin
	      vradr_temp = vradr_reg[sprt_int][sfwd_int-1];
              map_vld_next = 1'b1;
              map_reg_next = sdout_wire[sprt_int];
            end
          end else if (sfwd_int>0) begin
	    vradr_temp = vradr_reg[sprt_int][sfwd_int-1];
            map_vld_next = map_vld[sprt_int][sfwd_int-1];
            map_reg_next = map_reg[sprt_int][sfwd_int-1];
          end else begin
            vradr_temp = vradr_wire[sprt_int];
	    map_vld_next = 1'b0;
	    map_reg_next = 0;
          end
          for (swpt_int=0; swpt_int<NUMRUPT-1; swpt_int=swpt_int+1)
            if (swrite_wire[swpt_int] && (swrradr_wire[swpt_int] == vradr_temp)) begin
              map_vld_next = 1'b1;
              map_reg_next = sdin_wire[swpt_int];
            end
        end

        always @(posedge clk) begin
          map_vld[sprt_int][sfwd_int] <= map_vld_next;
          map_reg[sprt_int][sfwd_int] <= map_reg_next;
        end
      end
    end
  endgenerate

  integer sdo_int;
  always_comb
    for (sdo_int=0; sdo_int<NUMRUPT; sdo_int=sdo_int+1)
      sdout_wire[sdo_int] = t2_doutB >> (sdo_int*BITMAPT);

/*
  wire [BITMAPT-1:0] sdout_wire_0 = sdout_wire[0];
  wire [BITMAPT-1:0] sdout_wire_1 = sdout_wire[1];
  wire [BITMAPT-1:0] sdout_wire_2 = sdout_wire[2];
  wire [BITMAPT-1:0] sdout_wire_3 = sdout_wire[3];

  wire [BITMAPT-1:0] sdout_tmp_0 = sdout_tmp[0];
  wire [BITMAPT-1:0] sdout_tmp_1 = sdout_tmp[1];
  wire [BITMAPT-1:0] sdout_tmp_2 = sdout_tmp[2];
  wire [BITMAPT-1:0] sdout_tmp_3 = sdout_tmp[3];
*/
  reg [BITMAPT-1:0] rmap_out [0:NUMRUPT-1];
  reg [BITMAPT-1:0] wmap_out [0:NUMRUPT-1];
  integer fprt_int;
  always_comb
    for (fprt_int=0; fprt_int<NUMRUPT; fprt_int=fprt_int+1) begin
      rmap_out[fprt_int] = map_vld[fprt_int][SRAM_DELAY-1] ? map_reg[fprt_int][SRAM_DELAY-1] : sdout_wire[fprt_int];
      wmap_out[fprt_int] = map_reg[fprt_int][SRAM_DELAY+DRAM_DELAY-1];
    end
/*
  wire [BITMAPT-1:0] rmap_out_0 = rmap_out[0];
  wire [BITMAPT-1:0] rmap_out_1 = rmap_out[1];
  wire [BITMAPT-1:0] rmap_out_2 = rmap_out[2];

  wire [BITMAPT-1:0] wmap_out_0 = wmap_out[0];
  wire [BITMAPT-1:0] wmap_out_1 = wmap_out[1];
  wire [BITMAPT-1:0] wmap_out_2 = wmap_out[2];
*/
  reg [BITPBNK-1:0] rmap_wire [0:NUMVBNK-1][0:NUMRUPT-1];
  reg [BITPBNK-1:0] wmap_wire [0:NUMVBNK-1][0:NUMRUPT-1];
  integer mprt_int, mloc_int;
  always_comb
    for (mprt_int=0; mprt_int<NUMRUPT; mprt_int=mprt_int+1)
      for (mloc_int=0; mloc_int<NUMVBNK; mloc_int=mloc_int+1) begin
        rmap_wire[mloc_int][mprt_int] = rmap_out[mprt_int] >> (mloc_int*BITPBNK);
        wmap_wire[mloc_int][mprt_int] = wmap_out[mprt_int] >> (mloc_int*BITPBNK);
      end

  reg [BITPBNK-1:0] prdbadr_reg [0:NUMRUPT-1][0:DRAM_DELAY-1];
  reg [BITWRDS-1:0] prdwadr_reg [0:NUMRUPT-1][0:DRAM_DELAY-1];
  reg [BITSROW-1:0] prdradr_reg [0:NUMRUPT-1][0:DRAM_DELAY-1];
  reg [NUMWRDS*WIDTH-1:0] prdfwrd_reg [0:NUMRUPT-1][0:DRAM_DELAY-1];
  reg prdvldm_reg [0:NUMRUPT-1][0:DRAM_DELAY-1];
  reg [NUMWRDS*WIDTH-1:0] prddata_reg [0:NUMRUPT-1][0:DRAM_DELAY-1];

  wire vread_fwrd_help [0:NUMRUPT-1];
  wire vread_serr_help [0:NUMRUPT-1];
  wire vread_derr_help [0:NUMRUPT-1];
  wire [BITPADR-BITPBNK-BITWRDS-1:0] vread_padr_help [0:NUMRUPT-1];

  wire vread_vld_wire [0:NUMRUPT-1];
  wire vread_fwrd_wire [0:NUMRUPT-1];
  wire vread_serr_wire [0:NUMRUPT-1];
  wire vread_derr_wire [0:NUMRUPT-1];
  wire [BITPADR-1:0] vread_padr_wire [0:NUMRUPT-1];
  wire [MEMWDTH-1:0] vdout_help [0:NUMRUPT-1];
  wire [NUMWRDS*WIDTH-1:0] vdout_fwrd [0:NUMRUPT-1];
  wire [WIDTH-1:0] vdout_wire [0:NUMRUPT-1];
  genvar vrd_var;
  generate for (vrd_var=0; vrd_var<NUMRUPT; vrd_var=vrd_var+1) begin: vrd_loop
    if (ENAPAR) begin: pc_loop
      assign vread_vld_wire[vrd_var] = vread_reg[vrd_var][SRAM_DELAY+DRAM_DELAY-1];
      assign vdout_help[vrd_var] = t1_doutB >> ((vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1])*MEMWDTH);
      assign vread_fwrd_help[vrd_var] = t1_fwrdB >> (vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1]);
      assign vread_padr_help[vrd_var] = t1_padrB >> ((vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1])*(BITPADR-BITPBNK-BITWRDS));
      assign vread_fwrd_wire[vrd_var] = vread_fwrd_help[vrd_var] || |prdfwrd_reg[vrd_var][DRAM_DELAY-1];
      assign vread_serr_wire[vrd_var] = ^vdout_help[vrd_var] && prdvldm_reg[vrd_var][DRAM_DELAY-1];
      assign vread_derr_wire[vrd_var] = 1'b0;
      assign vread_padr_wire[vrd_var] = (NUMWRDS>1) ? {prdbadr_reg[vrd_var][DRAM_DELAY-1],prdwadr_reg[vrd_var][DRAM_DELAY-1],vread_padr_help[vrd_var]} :
                                                      {prdbadr_reg[vrd_var][DRAM_DELAY-1],vread_padr_help[vrd_var]};
      assign vdout_fwrd[vrd_var] = (prdfwrd_reg[vrd_var][DRAM_DELAY-1] & prddata_reg[vrd_var][DRAM_DELAY-1]) |
                                   (~prdfwrd_reg[vrd_var][DRAM_DELAY-1] & vdout_help[vrd_var]);
      assign vdout_wire[vrd_var] = vdout_fwrd[vrd_var] >> (prdwadr_reg[vrd_var][DRAM_DELAY-1]*WIDTH);
    end else if (ENAECC) begin: ec_loop
      assign vread_vld_wire[vrd_var] = vread_reg[vrd_var][SRAM_DELAY+DRAM_DELAY-1];
      assign vdout_help[vrd_var] = t1_doutB >> ((vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1])*MEMWDTH);

      wire [NUMWRDS*WIDTH-1:0] rd_data_wire = vdout_help[vrd_var];
      wire [ECCWDTH-1:0] rd_ecc_wire = vdout_help[vrd_var] >> NUMWRDS*WIDTH;
      wire [NUMWRDS*WIDTH-1:0] rd_corr_data_wire;
      wire rd_sec_err_wire;
      wire rd_ded_err_wire;
    
      ecc_check   #(.ECCDWIDTH(NUMWRDS*WIDTH), .ECCWIDTH(ECCWDTH))
          ecc_check_inst (.din(rd_data_wire), .eccin(rd_ecc_wire),
                          .dout(rd_corr_data_wire), .sec_err(rd_sec_err_wire), .ded_err(rd_ded_err_wire),
                          .clk(clk), .rst(rst));

      assign vread_fwrd_help[vrd_var] = t1_fwrdB >> (vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1]);
      assign vread_padr_help[vrd_var] = t1_padrB >> ((vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1])*(BITPADR-BITPBNK-BITWRDS));
      assign vread_fwrd_wire[vrd_var] = vread_fwrd_help[vrd_var] || |prdfwrd_reg[vrd_var][DRAM_DELAY-1];
      assign vread_serr_wire[vrd_var] = rd_sec_err_wire && prdvldm_reg[vrd_var][DRAM_DELAY-1];
      assign vread_derr_wire[vrd_var] = rd_ded_err_wire && prdvldm_reg[vrd_var][DRAM_DELAY-1];
      assign vread_padr_wire[vrd_var] = (NUMWRDS>1) ? {prdbadr_reg[vrd_var][DRAM_DELAY-1],prdwadr_reg[vrd_var][DRAM_DELAY-1],vread_padr_help[vrd_var]} :
                                                      {prdbadr_reg[vrd_var][DRAM_DELAY-1],vread_padr_help[vrd_var]};
      assign vdout_fwrd[vrd_var] = (prdfwrd_reg[vrd_var][DRAM_DELAY-1] & prddata_reg[vrd_var][DRAM_DELAY-1]) |
                                   (~prdfwrd_reg[vrd_var][DRAM_DELAY-1] & rd_corr_data_wire[vrd_var]);
      assign vdout_wire[vrd_var] = vdout_fwrd[vrd_var] >> (prdwadr_reg[vrd_var][DRAM_DELAY-1]*WIDTH);
    end else begin: nc_loop
      assign vread_vld_wire[vrd_var] = vread_reg[vrd_var][SRAM_DELAY+DRAM_DELAY-1];
      assign vdout_help[vrd_var] = t1_doutB >> ((vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1])*MEMWDTH);
      assign vread_fwrd_help[vrd_var] = t1_fwrdB >> (vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1]);
      assign vread_serr_help[vrd_var] = t1_serrB >> (vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1]);
      assign vread_derr_help[vrd_var] = t1_derrB >> (vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1]);
      assign vread_padr_help[vrd_var] = t1_padrB >> ((vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1])*(BITPADR-BITPBNK-BITWRDS));
      assign vread_fwrd_wire[vrd_var] = vread_fwrd_help[vrd_var] || |prdfwrd_reg[vrd_var][DRAM_DELAY-1];
      assign vread_serr_wire[vrd_var] = vread_serr_help[vrd_var] && prdvldm_reg[vrd_var][DRAM_DELAY-1];
      assign vread_derr_wire[vrd_var] = vread_derr_help[vrd_var] && prdvldm_reg[vrd_var][DRAM_DELAY-1];
      assign vread_padr_wire[vrd_var] = (NUMWRDS>1) ? {prdbadr_reg[vrd_var][DRAM_DELAY-1],prdwadr_reg[vrd_var][DRAM_DELAY-1],vread_padr_help[vrd_var]} :
                                                      {prdbadr_reg[vrd_var][DRAM_DELAY-1],vread_padr_help[vrd_var]};
      assign vdout_fwrd[vrd_var] = (prdfwrd_reg[vrd_var][DRAM_DELAY-1] & prddata_reg[vrd_var][DRAM_DELAY-1]) |
                                   (~prdfwrd_reg[vrd_var][DRAM_DELAY-1] & vdout_help[vrd_var]);
      assign vdout_wire[vrd_var] = vdout_fwrd[vrd_var] >> (prdwadr_reg[vrd_var][DRAM_DELAY-1]*WIDTH);
    end
  end
  endgenerate

  reg [NUMRUPT-1:0] vread_vld_tmp;
  reg [NUMRUPT-1:0] vread_fwrd_tmp;
  reg [NUMRUPT-1:0] vread_serr_tmp;
  reg [NUMRUPT-1:0] vread_derr_tmp;
  reg [NUMRUPT*BITPADR-1:0] vread_padr_tmp;
  reg [NUMRUPT*WIDTH-1:0] vdout_tmp;
  integer vdo_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_fwrd_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    for (vdo_int=0; vdo_int<NUMRUPT; vdo_int=vdo_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_vld_wire[vdo_int] << vdo_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vdo_int] << (vdo_int*WIDTH));
      vread_fwrd_tmp = vread_fwrd_tmp | (vread_fwrd_wire[vdo_int] << vdo_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vdo_int] << vdo_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vdo_int] << vdo_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vdo_int] << (vdo_int*BITPADR));
    end
  end

  reg [NUMRUPT-1:0] vread_vld;
  reg [NUMRUPT-1:0] vread_fwrd;
  reg [NUMRUPT-1:0] vread_serr;
  reg [NUMRUPT-1:0] vread_derr;
  reg [NUMRUPT*BITPADR-1:0] vread_padr;
  reg [NUMRUPT*WIDTH-1:0] vdout;
  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      vread_vld <= vread_vld_tmp;
      vdout <= vdout_tmp;
      vread_fwrd <= vread_fwrd_tmp;
      vread_serr <= vread_serr_tmp;
      vread_derr <= vread_derr_tmp;
      vread_padr <= vread_padr_tmp;
    end
  end else begin: nflp_loop
    always_comb begin
      vread_vld = vread_vld_tmp;
      vdout = vdout_tmp;
      vread_fwrd = vread_fwrd_tmp;
      vread_serr = vread_serr_tmp;
      vread_derr = vread_derr_tmp;
      vread_padr = vread_padr_tmp;
    end
  end
  endgenerate
/*
  wire map_vld_0 = map_vld[0][SRAM_DELAY-1];
  wire map_vld_1 = map_vld[1][SRAM_DELAY-1];
  wire map_vld_2 = map_vld[2][SRAM_DELAY-1];
  wire map_vld_3 = map_vld[3][SRAM_DELAY-1];
  wire [BITMAPT-1:0] map_reg_0 = map_reg[0][SRAM_DELAY-1];
  wire [BITMAPT-1:0] map_reg_1 = map_reg[1][SRAM_DELAY-1];
  wire [BITMAPT-1:0] map_reg_2 = map_reg[2][SRAM_DELAY-1];
  wire [BITMAPT-1:0] map_reg_3 = map_reg[3][SRAM_DELAY-1];
  wire [BITMAPT-1:0] map_out_0 = map_out[0];
  wire [BITMAPT-1:0] map_out_1 = map_out[1];
  wire [BITMAPT-1:0] map_out_2 = map_out[2];
  wire [BITMAPT-1:0] map_out_3 = map_out[3];
*/
  reg [NUMPBNK-1:0] used_pivot_blk [0:NUMRUPT-1];
  integer blkp_int, blkx_int;
  always_comb
    for (blkp_int=0; blkp_int<NUMRUPT; blkp_int=blkp_int+1) begin
      used_pivot_blk[blkp_int] = 0;
      for (blkx_int=0; blkx_int<NUMVBNK; blkx_int=blkx_int+1)
        used_pivot_blk[blkp_int] = used_pivot_blk[blkp_int] | (1'b1 << wmap_wire[blkx_int][blkp_int]);
    end

  reg [NUMPBNK-1:0] used_pivot_temp [0:NUMRUPT-1];
  reg [NUMPBNK-1:0] used_pivot [0:NUMRUPT-1];
  integer usep_int, usex_int;
  always_comb 
    for (usep_int=0; usep_int<NUMRUPT; usep_int=usep_int+1)
      if (usep_int>0)
        used_pivot_temp[usep_int] = used_pivot[usep_int-1];
      else
        used_pivot_temp[usep_int] = 0;
  
  reg               new_vld [0:NUMRUPT-1];
  reg [BITPBNK-1:0] new_pos [0:NUMRUPT-1];
  integer newp_int, newx_int;
  always_comb
    for (newp_int=0; newp_int<NUMRUPT; newp_int=newp_int+1) begin
      new_vld[newp_int] = 1'b0;
      new_pos[newp_int] = 0;
      if (vwrite_out[newp_int] && used_pivot_temp[newp_int][wmap_wire[vwrbadr_out[newp_int]][newp_int]]) begin
        for (newx_int=0; newx_int<NUMPBNK; newx_int=newx_int+1)
          if (!used_pivot_blk[newp_int][newx_int] && !used_pivot_temp[newp_int][newx_int]) begin
            new_vld[newp_int] = 1'b1;
            new_pos[newp_int] = newx_int;
          end
      end
    end

  integer used_int;
  always_comb
    for (used_int=0; used_int<NUMRUPT; used_int=used_int+1)
      if (vwrite_out[used_int]) begin
        if (new_vld[used_int])
          used_pivot[used_int] = used_pivot_temp[used_int] | (1'b1 << new_pos[used_int]);
        else
          used_pivot[used_int] = used_pivot_temp[used_int] | (1'b1 << wmap_wire[vwrbadr_out[used_int]][used_int]);
      end else
        used_pivot[used_int] = used_pivot_temp[used_int];
     
/* 
  wire [NUMPBNK-1:0] used_pivot_blk_0 = used_pivot_blk[0];
  wire [NUMPBNK-1:0] used_pivot_temp_0 = used_pivot_temp[0];
  wire [NUMPBNK-1:0] used_pivot_0 = used_pivot[0];
  wire [NUMPBNK-1:0] used_pivot_blk_1 = used_pivot_blk[1];
  wire [NUMPBNK-1:0] used_pivot_temp_1 = used_pivot_temp[1];
  wire [NUMPBNK-1:0] used_pivot_1 = used_pivot[1];

  reg forward_read [0:NUMRUPT-1];
  reg [WIDTH-1:0] forward_data [0:NUMRUPT-1];
  integer fwdp_int, fwdw_int;
  always_comb
    for (fwdp_int=0; fwdp_int<NUMRUPT; fwdp_int=fwdp_int+1) begin
      forward_read[fwdp_int] = 0;
      forward_data[fwdp_int] = 0;
      for (fwdw_int=0; fwdw_int<NUMRUPT; fwdw_int=fwdw_int+1)
        if (vwrite_out[fwdw_int] && (vwrbadr_out[fwdw_int] == vbadr_wire[fwdp_int]) &&
                                    (vwrradr_out[fwdw_int] == vradr_wire[fwdp_int])) begin
          forward_read[fwdp_int] = vread_wire[fwdp_int];
          forward_data[fwdp_int] = vdin_del[fwdw_int];
        end
    end

  wire forward_read_0 = forward_read[0];
  wire [WIDTH-1:0] forward_data_0 = forward_data[0];
  wire forward_read_1 = forward_read[1];
  wire [WIDTH-1:0] forward_data_1 = forward_data[1];
*/
  reg pread_wire [0:NUMRUPT-1]; 
  reg [BITPBNK-1:0] prdbadr_wire [0:NUMRUPT-1];
  reg [BITWRDS-1:0] prdwadr_wire [0:NUMRUPT-1];
  reg [BITSROW-1:0] prdradr_wire [0:NUMRUPT-1];
  integer prdw_int;
  always_comb
    for (prdw_int=0; prdw_int<NUMRUPT; prdw_int=prdw_int+1) begin
      pread_wire[prdw_int] = vread_out[prdw_int]/* && !forward_read[prdw_int]*/;
      prdbadr_wire[prdw_int] = rmap_wire[vrdbadr_out[prdw_int]][prdw_int];
      prdwadr_wire[prdw_int] = vrdwadr_out[prdw_int];
      prdradr_wire[prdw_int] = vrdradr_out[prdw_int];
    end

  reg [NUMWRDS*WIDTH-1:0] prdfwrd_nxt [0:NUMRUPT-1][0:DRAM_DELAY-1];
  reg [NUMWRDS*WIDTH-1:0] prddata_nxt [0:NUMRUPT-1][0:DRAM_DELAY-1];
  integer prnp_int, prnd_int, prnf_int;
  always_comb
    for (prnp_int=0; prnp_int<NUMRUPT; prnp_int=prnp_int+1)
      for (prnd_int=0; prnd_int<DRAM_DELAY; prnd_int=prnd_int+1)
        if (prnd_int>0) begin
          prdfwrd_nxt[prnp_int][prnd_int] = prdfwrd_reg[prnp_int][prnd_int-1];
          prddata_nxt[prnp_int][prnd_int] = prddata_reg[prnp_int][prnd_int-1];
          for (prnf_int=0; prnf_int<NUMRUPT; prnf_int=prnf_int+1)
//            if (pwrite_wire[prnf_int] && (pwrbadr_wire[prnf_int] == prdbadr_reg[prnp_int][prnd_int-1]) &&
//                                         (pwrradr_wire[prnf_int] == prdradr_reg[prnp_int][prnd_int-1])) begin
//              prdfwrd_nxt[prnp_int][prnd_int] = ~0;
//              prddata_nxt[prnp_int][prnd_int] = pdin_wire[prnf_int];
//            end
            if (vwrite_out[prnf_int] && (vwrbadr_out[prnf_int] == vbadr_reg[prnp_int][SRAM_DELAY+prnd_int-1]) &&
                                        (vwrradr_out[prnf_int] == vradr_reg[prnp_int][SRAM_DELAY+prnd_int-1])) begin
              prdfwrd_nxt[prnp_int][prnd_int] = ~0;
              prddata_nxt[prnp_int][prnd_int] = pdin_wire[prnf_int];
//              prdfwrd_nxt[prnp_int][prnd_int] = prdfwrd_nxt[prnp_int][prnd_int] | ({WIDTH{1'b1}} << (vwrwadr_out[prnf_int]*WIDTH));
//              prddata_nxt[prnp_int][prnd_int] = (prddata_nxt[prnp_int][prnd_int] & ~({WIDTH{1'b1}} << (vwrwadr_out[prnf_int]*WIDTH))) |
//                                                 (vdin_out[prnf_int] << (vwrwadr_out[prnf_int]*WIDTH));
            end
        end else begin
          prdfwrd_nxt[prnp_int][prnd_int] = 0;
          prddata_nxt[prnp_int][prnd_int] = 0;
          for (prnf_int=0; prnf_int<NUMRUPT; prnf_int=prnf_int+1)
//            if (pwrite_wire[prnf_int] && (pwrbadr_wire[prnf_int] == prdbadr_wire[prnp_int]) &&
//                                         (pwrradr_wire[prnf_int] == prdradr_wire[prnp_int])) begin
//              prdfwrd_nxt[prnp_int][prnd_int] = ~0;
//              prddata_nxt[prnp_int][prnd_int] = pdin_wire[prnf_int];
//            end
            if (vwrite_out[prnf_int] && (vwrbadr_out[prnf_int] == vbadr_reg[prnp_int][SRAM_DELAY-1]) &&
                                        (vwrradr_out[prnf_int] == vradr_reg[prnp_int][SRAM_DELAY-1])) begin
              prdfwrd_nxt[prnp_int][prnd_int] = ~0;
              prddata_nxt[prnp_int][prnd_int] = pdin_wire[prnf_int];
//              prdfwrd_nxt[prnp_int][prnd_int] = prdfwrd_nxt[prnp_int][prnd_int] | ({WIDTH{1'b1}} << (vwrwadr_out[prnf_int]*WIDTH));
//              prddata_nxt[prnp_int][prnd_int] = (prddata_nxt[prnp_int][prnd_int] & ~({WIDTH{1'b1}} << (vwrwadr_out[prnf_int]*WIDTH))) |
//                                                 (vdin_out[prnf_int] << (vwrwadr_out[prnf_int]*WIDTH));
            end
        end

  integer prdp_int, prdd_int;
  always @(posedge clk)
    for (prdp_int=0; prdp_int<NUMRUPT; prdp_int=prdp_int+1)
      for (prdd_int=0; prdd_int<DRAM_DELAY; prdd_int=prdd_int+1)
        if (prdd_int>0) begin
          prdbadr_reg[prdp_int][prdd_int] <= prdbadr_reg[prdp_int][prdd_int-1];
          prdwadr_reg[prdp_int][prdd_int] <= prdwadr_reg[prdp_int][prdd_int-1];
          prdradr_reg[prdp_int][prdd_int] <= prdradr_reg[prdp_int][prdd_int-1];
          prdvldm_reg[prdp_int][prdd_int] <= prdvldm_reg[prdp_int][prdd_int-1];
          prdfwrd_reg[prdp_int][prdd_int] <= prdfwrd_nxt[prdp_int][prdd_int];
          prddata_reg[prdp_int][prdd_int] <= prddata_nxt[prdp_int][prdd_int];
        end else begin
          prdbadr_reg[prdp_int][prdd_int] <= prdbadr_wire[prdp_int];
          prdwadr_reg[prdp_int][prdd_int] <= prdwadr_wire[prdp_int];
          prdradr_reg[prdp_int][prdd_int] <= prdradr_wire[prdp_int];
          prdvldm_reg[prdp_int][prdd_int] <= vread_out[prdp_int];
          prdfwrd_reg[prdp_int][prdd_int] <= prdfwrd_nxt[prdp_int][prdd_int];
          prddata_reg[prdp_int][prdd_int] <= prddata_nxt[prdp_int][prdd_int];
        end
/*
  wire [BITVBNK-1:0] vbadr_reg_0_0 = vbadr_reg[0][SRAM_DELAY-1];
  wire [BITWRDS-1:0] vwadr_reg_0_0 = vwadr_reg[0][SRAM_DELAY-1];
  wire [BITSROW-1:0] vradr_reg_0_0 = vradr_reg[0][SRAM_DELAY-1];

  wire pread_wire_0 = pread_wire[0];
  wire [BITPBNK-1:0] prdbadr_wire_0 = prdbadr_wire[0];
  wire [BITVROW-1:0] prdradr_wire_0 = prdradr_wire[0];

  wire pread_wire_1 = pread_wire[1];
  wire [BITPBNK-1:0] prdbadr_wire_1 = prdbadr_wire[1];
  wire [BITVROW-1:0] prdradr_wire_1 = prdradr_wire[1];

  wire new_vld_0 = new_vld[0];
  wire [BITPBNK-1:0] new_pos_0 = new_pos[0];
  wire [BITPBNK-1:0] wmap_wire_0_0 = wmap_wire[0][0];
  wire [BITPBNK-1:0] wmap_wire_1_0 = wmap_wire[1][0];
  wire [BITPBNK-1:0] wmap_wire_2_0 = wmap_wire[2][0];
  wire [BITPBNK-1:0] wmap_wire_3_0 = wmap_wire[3][0];
  wire new_vld_1 = new_vld[1];
  wire [BITPBNK-1:0] new_pos_1 = new_pos[1];
  wire [BITPBNK-1:0] wmap_wire_0_1 = wmap_wire[0][1];
  wire [BITPBNK-1:0] wmap_wire_1_1 = wmap_wire[1][1];
  wire [BITPBNK-1:0] wmap_wire_2_1 = wmap_wire[2][1];
  wire [BITPBNK-1:0] wmap_wire_3_1 = wmap_wire[3][1];

  wire [BITPBNK-1:0] rmap_wire_0_1 = rmap_wire[0][1];
  wire [BITPBNK-1:0] rmap_wire_1_1 = rmap_wire[1][1];
  wire [BITPBNK-1:0] rmap_wire_2_1 = rmap_wire[2][1];
  wire [BITPBNK-1:0] rmap_wire_3_1 = rmap_wire[3][1];
*/
  reg [NUMWRDS*WIDTH-1:0] din_fwd [0:NUMRUPT-1];
  integer fwdp_int, fwdw_int;
  always_comb
    for (fwdp_int=0; fwdp_int<NUMRUPT; fwdp_int=fwdp_int+1) begin
      din_fwd[fwdp_int] = vdout_fwrd[fwdp_int];
      for (fwdw_int=0; fwdw_int<NUMRUPT; fwdw_int=fwdw_int+1)
        if (vwrite_out[fwdp_int] && vwrite_out[fwdw_int] && (vwrbadr_out[fwdp_int] == vwrbadr_out[fwdw_int]) &&
                                                            (vwrradr_out[fwdp_int] == vwrradr_out[fwdw_int]))
          din_fwd[fwdp_int] = (din_fwd[fwdp_int] & ~({WIDTH{1'b1}} << (vwrwadr_out[fwdw_int]*WIDTH))) |
                              (vdin_out[fwdw_int] << (vwrwadr_out[fwdw_int]*WIDTH));
    end

  wire [MEMWDTH-1:0] din_tmp [0:NUMRUPT-1];
  genvar din_var;
  generate for (din_var=0; din_var<NUMRUPT; din_var=din_var+1) begin: var_loop
    if (ENAPAR) begin: pg_loop
      assign din_tmp[din_var] = {^din_fwd[din_var],din_fwd[din_var]};
    end else if (ENAECC) begin: eg_loop
      wire [ECCWDTH-1:0] din_ecc;
      ecc_calc #(.ECCDWIDTH(NUMWRDS*WIDTH), .ECCWIDTH(ECCWDTH))
        ecc_calc_inst (.din(din_fwd[din_var]), .eccout(din_ecc));
      assign din_tmp[din_var] = {din_ecc,din_fwd[din_var]};
    end else begin: ng_loop
      assign din_tmp[din_var] = din_fwd[din_var];
    end
  end
  endgenerate
/*
  wire [BITPBNK-1:0] prdbadr_reg_0 = prdbadr_reg[0][DRAM_DELAY-1];
  wire [BITPADR-1:0] vread_padr_wire_0 = vread_padr_wire[0];
  wire [NUMWRDS*WIDTH-1:0] vdout_help_0 = vdout_help[0];
  wire [NUMWRDS*WIDTH-1:0] vdout_fwrd_0 = vdout_fwrd[0];
  wire [MEMWDTH-1:0] din_tmp_0 = din_tmp[0];
  wire [NUMWRDS*MEMWDTH-1:0] din_fwd_0 = din_fwd[0];
  wire [NUMWRDS*WIDTH-1:0] prdfwrd_reg_0 = prdfwrd_reg[0][DRAM_DELAY-1];
  wire [NUMWRDS*WIDTH-1:0] prddata_reg_0 = prddata_reg[0][DRAM_DELAY-1];

  wire [NUMWRDS*WIDTH-1:0] vdout_help_1 = vdout_help[1];
  wire [NUMWRDS*WIDTH-1:0] vdout_fwrd_1 = vdout_fwrd[1];
  wire [MEMWDTH-1:0] din_tmp_1 = din_tmp[1];
  wire [NUMWRDS*MEMWDTH-1:0] din_fwd_1 = din_fwd[1];
  wire [NUMWRDS*WIDTH-1:0] prdfwrd_reg_1 = prdfwrd_reg[1][DRAM_DELAY-1];
  wire [NUMWRDS*WIDTH-1:0] prddata_reg_1 = prddata_reg[1][DRAM_DELAY-1];
*/
  integer pwrp_int, pwrw_int;
  always_comb
    for (pwrp_int=0; pwrp_int<NUMRUPT; pwrp_int=pwrp_int+1) begin
      pwrite_wire[pwrp_int] = vwrite_out[pwrp_int];
      pwrbadr_wire[pwrp_int] = new_vld[pwrp_int] ? new_pos[pwrp_int] : wmap_wire[vwrbadr_out[pwrp_int]][pwrp_int];
      pwrradr_wire[pwrp_int] = vwrradr_out[pwrp_int];
      pdin_wire[pwrp_int] = din_tmp[pwrp_int];
    end

  reg pwrite_tmp [0:NUMRUPT-1];
  reg [BITPBNK-1:0] pwrbadr_tmp [0:NUMRUPT-1];
  reg [BITVROW-1:0] pwrradr_tmp [0:NUMRUPT-1];
  reg [MEMWDTH-1:0] pdin_tmp [0:NUMRUPT-1];
  generate if (FLOPPWR) begin: swflp_loop
    integer pwrd_int; 
    always @(posedge clk)
      for (pwrd_int=0; pwrd_int<NUMRUPT; pwrd_int=pwrd_int+1) begin
        pwrite_tmp[pwrd_int] <= pwrite_wire[pwrd_int];
        pwrbadr_tmp[pwrd_int] <= pwrbadr_wire[pwrd_int];
        pwrradr_tmp[pwrd_int] <= pwrradr_wire[pwrd_int];
        pdin_tmp[pwrd_int] <= pdin_wire[pwrd_int];
      end
  end else begin: nswflp_loop
    integer pwrd_int; 
    always_comb
      for (pwrd_int=0; pwrd_int<NUMRUPT; pwrd_int=pwrd_int+1) begin
        pwrite_tmp[pwrd_int] = pwrite_wire[pwrd_int];
        pwrbadr_tmp[pwrd_int] = pwrbadr_wire[pwrd_int];
        pwrradr_tmp[pwrd_int] = pwrradr_wire[pwrd_int];
        pdin_tmp[pwrd_int] = pdin_wire[pwrd_int];
      end
  end
  endgenerate
/*
  wire pwrite_reg_0 = pwrite_reg[0];
  wire [BITPBNK-1:0] pwrbadr_reg_0 = pwrbadr_reg[0];
  wire [BITVROW-1:0] pwrradr_reg_0 = pwrradr_reg[0];
  wire [WIDTH-1:0] pdin_reg_0 = pdin_reg[0];
*/
  reg [NUMRUPT*NUMPBNK-1:0] t1_writeA;
  reg [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrA;
  reg [NUMRUPT*NUMPBNK*MEMWDTH-1:0] t1_dinA;
  reg [NUMRUPT*NUMPBNK-1:0] t1_readB;
  reg [NUMRUPT*NUMPBNK*BITSROW-1:0] t1_addrB;
  integer t1w_int, t1wa_int, t1wb_int, t1r_int, t1ra_int, t1rb_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    if (rstvld && !rst) begin
      t1_writeA = ~0;
      t1_addrA = {(NUMRUPT*NUMPBNK){rstaddr[BITSROW-1:0]}};
      t1_dinA = 0;
    end else 
      for (t1w_int=0; t1w_int<NUMRUPT; t1w_int=t1w_int+1)
        for (t1r_int=0; t1r_int<NUMRUPT; t1r_int=t1r_int+1) begin
          if (pwrite_tmp[t1w_int])
            t1_writeA = t1_writeA | (1'b1 << (t1r_int*NUMPBNK+pwrbadr_tmp[t1w_int]));
          for (t1wb_int=0; t1wb_int<NUMPBNK; t1wb_int=t1wb_int+1)
            if (pwrite_tmp[t1w_int] && (pwrbadr_tmp[t1w_int]==t1wb_int)) begin
              for (t1wa_int=0; t1wa_int<BITSROW; t1wa_int=t1wa_int+1)
                t1_addrA[(t1r_int*NUMPBNK+t1wb_int)*BITSROW+t1wa_int] = pwrradr_tmp[t1w_int][t1wa_int];
              for (t1wa_int=0; t1wa_int<MEMWDTH; t1wa_int=t1wa_int+1)
                t1_dinA[(t1r_int*NUMPBNK+t1wb_int)*MEMWDTH+t1wa_int] = pdin_tmp[t1w_int][t1wa_int];
            end
        end
    t1_readB = 0;
    t1_addrB = 0;
    for (t1r_int=0; t1r_int<NUMRUPT; t1r_int=t1r_int+1) begin
      if (pread_wire[t1r_int])
        t1_readB = t1_readB | (1'b1 << (t1r_int*NUMPBNK+prdbadr_wire[t1r_int]));
      for (t1ra_int=0; t1ra_int<BITSROW; t1ra_int=t1ra_int+1)
        for (t1rb_int=0; t1rb_int<NUMPBNK; t1rb_int=t1rb_int+1)
          t1_addrB[(t1r_int*NUMPBNK+t1rb_int)*BITSROW+t1ra_int] = prdradr_wire[t1r_int][t1ra_int];
    end
  end

  integer swrp_int, swrx_int;
  always_comb
    for (swrp_int=0; swrp_int<NUMRUPT-1; swrp_int=swrp_int+1) 
      if (rstvld && (swrp_int==0)) begin
        swrite_wire[swrp_int] = 1'b1;
        swrradr_wire[swrp_int] = rstaddr;
        sdin_wire[swrp_int] = rstdin;
      end else if (vwrite_out[swrp_int+1] && new_vld[swrp_int+1]) begin
        swrite_wire[swrp_int] = 1'b1;
        swrradr_wire[swrp_int] = vwrradr_out[swrp_int+1];
        sdin_wire[swrp_int] = wmap_out[swrp_int+1];
        for (swrx_int=0; swrx_int<swrp_int; swrx_int=swrx_int+1)
          if (swrite_wire[swrx_int] && swrite_wire[swrp_int] && (swrradr_wire[swrx_int] == swrradr_wire[swrp_int])) begin
            swrite_wire[swrx_int] = 1'b0;
            sdin_wire[swrp_int] = sdin_wire[swrx_int];
          end
        sdin_wire[swrp_int] = (sdin_wire[swrp_int] & ~({BITPBNK{1'b1}} << (vwrbadr_out[swrp_int+1]*BITPBNK))) |
                              (new_pos[swrp_int+1] << (vwrbadr_out[swrp_int+1]*BITPBNK));
      end else begin
        swrite_wire[swrp_int] = 1'b0;
        swrradr_wire[swrp_int] = 0;
        sdin_wire[swrp_int] = 0;
      end

  reg [(NUMRUPT-1)-1:0] t2_writeA;
  reg [(NUMRUPT-1)*BITSROW-1:0] t2_addrA;
  reg [(NUMRUPT-1)*BITMAPT-1:0] t2_dinA;
  reg [NUMRUPT-1:0] t2_readB;
  reg [NUMRUPT*BITSROW-1:0] t2_addrB;
  integer smcp_int;
  always_comb begin
    t2_writeA = 0;
    t2_addrA = 0;
    t2_dinA = 0;
    t2_readB = 0;
    t2_addrB = 0;
    for (smcp_int=0; smcp_int<NUMRUPT; smcp_int=smcp_int+1) begin
      t2_readB = t2_readB | (sread_wire[smcp_int] << smcp_int);
      t2_addrB = t2_addrB | (srdradr_wire[smcp_int] << (smcp_int*BITSROW));
    end
    for (smcp_int=0; smcp_int<NUMRUPT-1; smcp_int=smcp_int+1) begin
      t2_writeA = t2_writeA | (swrite_wire[smcp_int] << smcp_int);
      t2_addrA = t2_addrA | (swrradr_wire[smcp_int] << (smcp_int*BITSROW));
      t2_dinA = t2_dinA | (sdin_wire[smcp_int] << (smcp_int*BITMAPT));
    end
  end

/*
  wire [NUMPBNK-1:0] used_pivot_temp_0 = used_pivot_temp[0];
  wire [NUMPBNK-1:0] used_pivot_temp_1 = used_pivot_temp[1];
  wire [NUMPBNK-1:0] used_pivot_0 = used_pivot[0];
  wire [NUMPBNK-1:0] used_pivot_1 = used_pivot[1];
  wire [BITPBNK-1:0] new_pos_0 = new_pos[0];
  wire [BITPBNK-1:0] new_pos_1 = new_pos[1];
  wire [BITPBNK-1:0] map_wire_0_2 = map_wire[0][2];
  wire [BITPBNK-1:0] map_wire_1_2 = map_wire[1][2];
  wire [BITPBNK-1:0] map_wire_2_2 = map_wire[2][2];
  wire [BITPBNK-1:0] map_wire_3_2 = map_wire[3][2];
  wire [BITPBNK-1:0] map_temp_0 = map_temp[0];
  wire [BITPBNK-1:0] map_temp_1 = map_temp[1];
  wire used_0 = used[0];
  wire used_1 = used[1];
  wire [BITPBNK-1:0] map_wire_0_0 = map_wire[0][0];
  wire [BITPBNK-1:0] map_wire_1_0 = map_wire[1][0];
  wire [BITPBNK-1:0] map_wire_2_0 = map_wire[2][0];
  wire [BITPBNK-1:0] map_wire_3_0 = map_wire[3][0];
  wire [BITPBNK-1:0] map_prt0 = map_wire[vbadr_out[0]][0];
  wire [BITPBNK-1:0] map_prt1 = map_wire[vbadr_out[1]][1];
  wire [BITPBNK-1:0] map_prt2 = map_wire[vbadr_out[2]][2];
  wire [BITPBNK-1:0] map_prt3 = map_wire[vbadr_out[3]][3];
*/

endmodule
