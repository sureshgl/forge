module core_mrnw_1rw_mt (vwrite, vwraddr, vdin,
                         vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                         t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA,
                         t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB,
                         ready, clk, rst);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ECCWDTH = 7;
  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : WIDTH;
  parameter NUMRDPT = 2;
  parameter NUMWRPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter NUMPBNK = 11;
  parameter BITPBNK = 4;
  parameter BITPADR = 15;
  
  parameter SRAM_DELAY = 2;
  parameter DRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPWRM = 0;
  parameter FLOPPWR = 0;
  parameter FLOPOUT = 0;

  parameter BITMAPT = BITPBNK*NUMVBNK;

  input [NUMWRPT-1:0]           vwrite;
  input [NUMWRPT*BITADDR-1:0]   vwraddr;
  input [NUMWRPT*WIDTH-1:0]     vdin;

  input [NUMRDPT-1:0]           vread;
  input [NUMRDPT*BITADDR-1:0]   vrdaddr;
  output [NUMRDPT-1:0]          vread_vld;
  output [NUMRDPT*WIDTH-1:0]    vdout;
  output [NUMRDPT-1:0]          vread_fwrd;
  output [NUMRDPT-1:0]          vread_serr;
  output [NUMRDPT-1:0]          vread_derr;
  output [NUMRDPT*BITPADR-1:0]  vread_padr;

  output [NUMRDPT*NUMPBNK-1:0]         t1_readA;
  output [NUMRDPT*NUMPBNK-1:0]         t1_writeA;
  output [NUMRDPT*NUMPBNK*BITVROW-1:0] t1_addrA;
  output [NUMRDPT*NUMPBNK*MEMWDTH-1:0] t1_dinA;
  input [NUMRDPT*NUMPBNK*MEMWDTH-1:0]  t1_doutA;
  input [NUMRDPT*NUMPBNK-1:0]          t1_fwrdA;
  input [NUMRDPT*NUMPBNK-1:0]          t1_serrA;
  input [NUMRDPT*NUMPBNK-1:0]          t1_derrA;
  input [NUMRDPT*NUMPBNK*(BITPADR-BITPBNK)-1:0] t1_padrA;

  output [NUMWRPT-1:0]                   t2_writeA;
  output [NUMWRPT*BITVROW-1:0]           t2_addrA;
  output [NUMWRPT*BITMAPT-1:0]           t2_dinA;

  output [(NUMRDPT+NUMWRPT)-1:0]         t2_readB;
  output [(NUMRDPT+NUMWRPT)*BITVROW-1:0] t2_addrB;
  input [(NUMRDPT+NUMWRPT)*BITMAPT-1:0]  t2_doutB;
  
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
  wire               vwrite_wire [0:NUMWRPT-1];
  wire [BITADDR-1:0] vwraddr_wire [0:NUMWRPT-1];
  wire [BITVBNK-1:0] vwrbadr_wire [0:NUMWRPT-1];
  wire [BITVROW-1:0] vwrradr_wire [0:NUMWRPT-1];
  wire [WIDTH-1:0]   vdin_wire [0:NUMWRPT-1];
  wire               vread_wire [0:NUMRDPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMRDPT-1];
  wire [BITVBNK-1:0] vrdbadr_wire [0:NUMRDPT-1];
  wire [BITVROW-1:0] vrdradr_wire [0:NUMRDPT-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMWRPT-1:0] vwrite_reg;
    reg [NUMWRPT*BITADDR-1:0] vwraddr_reg;
    reg [NUMWRPT*WIDTH-1:0] vdin_reg;
    reg [NUMRDPT-1:0] vread_reg;
    reg [NUMRDPT*BITADDR-1:0] vrdaddr_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vwrite_reg <= vwrite & {NUMWRPT{ready}};
      vwraddr_reg <= vwraddr;
      vdin_reg <= vdin;
      vread_reg <= vread & {NUMRDPT{ready}};
      vrdaddr_reg <= vrdaddr;
    end

    assign ready_wire = ready_reg;
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite_reg >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr_reg >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        adr_inst (.vbadr(vwrbadr_wire[np2_var]), .vradr(vwrradr_wire[np2_var]), .vaddr(vwraddr_wire[np2_var]));
    end
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr_reg >> (np2_var*BITADDR);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = (vwrite & {NUMWRPT{ready}}) >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        adr_inst (.vbadr(vwrbadr_wire[np2_var]), .vradr(vwrradr_wire[np2_var]), .vaddr(vwraddr_wire[np2_var]));
    end
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = (vread & {NUMRDPT{ready}}) >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end
  end
  endgenerate

  reg                vwrite_reg [0:NUMWRPT-1][0:SRAM_DELAY+1];
  reg [BITVBNK-1:0]  vwrbadr_reg [0:NUMWRPT-1][0:SRAM_DELAY+1];
  reg [BITVROW-1:0]  vwrradr_reg [0:NUMWRPT-1][0:SRAM_DELAY+1];
  reg [WIDTH-1:0]    vdin_reg [0:NUMWRPT-1][0:SRAM_DELAY+1];

  reg                vread_reg [0:NUMRDPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:NUMRDPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
  reg [BITVROW-1:0]  vrdradr_reg [0:NUMRDPT-1][0:SRAM_DELAY+DRAM_DELAY-1];
 
  integer vprt_int, vdel_int; 
  always @(posedge clk) begin
    for (vprt_int=0; vprt_int<NUMWRPT; vprt_int=vprt_int+1)
      for (vdel_int=0; vdel_int<SRAM_DELAY+2; vdel_int=vdel_int+1)
        if (vdel_int > 0) begin
          vwrite_reg[vprt_int][vdel_int] <= vwrite_reg[vprt_int][vdel_int-1];
          vwrbadr_reg[vprt_int][vdel_int] <= vwrbadr_reg[vprt_int][vdel_int-1];
          vwrradr_reg[vprt_int][vdel_int] <= vwrradr_reg[vprt_int][vdel_int-1];
          vdin_reg[vprt_int][vdel_int] <= vdin_reg[vprt_int][vdel_int-1];
        end else begin
          vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int] && (vwraddr_wire[vprt_int] < NUMADDR);
          vwrbadr_reg[vprt_int][vdel_int] <= vwrbadr_wire[vprt_int];
          vwrradr_reg[vprt_int][vdel_int] <= vwrradr_wire[vprt_int];
          vdin_reg[vprt_int][vdel_int] <= vdin_wire[vprt_int];
        end
    for (vprt_int=0; vprt_int<NUMRDPT; vprt_int=vprt_int+1)
      for (vdel_int=0; vdel_int<SRAM_DELAY+DRAM_DELAY; vdel_int=vdel_int+1)
        if (vdel_int > 0) begin
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
          vrdbadr_reg[vprt_int][vdel_int] <= vrdbadr_reg[vprt_int][vdel_int-1];
          vrdradr_reg[vprt_int][vdel_int] <= vrdradr_reg[vprt_int][vdel_int-1];
        end else begin
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
          vrdbadr_reg[vprt_int][vdel_int] <= vrdbadr_wire[vprt_int];
          vrdradr_reg[vprt_int][vdel_int] <= vrdradr_wire[vprt_int];
        end
  end 

  reg vwrite_nxt [0:NUMWRPT-1];
  reg vwrite_out [0:NUMWRPT-1];
  reg [BITVBNK-1:0] vwrbadr_out [0:NUMWRPT-1];
  reg [BITVROW-1:0] vwrradr_out [0:NUMWRPT-1];
  reg [WIDTH-1:0] vdin_out [0:NUMWRPT-1];
  reg vread_out [0:NUMRDPT-1];
  reg [BITVBNK-1:0] vrdbadr_out [0:NUMRDPT-1];
  reg [BITVROW-1:0] vrdradr_out [0:NUMRDPT-1];
  integer vout_int, vwpt_int;
  always_comb begin
    for (vout_int=0; vout_int<NUMWRPT; vout_int=vout_int+1) begin
/*
      vwrite_nxt[vout_int] = vwrite_reg[vout_int][SRAM_DELAY-1];
      for (vwpt_int=vout_int+1; vwpt_int<NUMWRPT; vwpt_int=vwpt_int+1)
        vwrite_nxt[vout_int] = vwrite_nxt[vout_int] && !(vwrite_reg[vwpt_int][SRAM_DELAY-1] &&
                                                         (vwrbadr_reg[vwpt_int][SRAM_DELAY-1] == vwrbadr_reg[vout_int][SRAM_DELAY-1]) &&
                                                         (vwrradr_reg[vwpt_int][SRAM_DELAY-1] == vwrradr_reg[vout_int][SRAM_DELAY-1]));
*/
      if (FLOPWRM) begin
        vwrite_out[vout_int] = vwrite_reg[vout_int][SRAM_DELAY];
        for (vwpt_int=vout_int+1; vwpt_int<NUMWRPT; vwpt_int=vwpt_int+1)
          vwrite_out[vout_int] = vwrite_out[vout_int] && !(vwrite_reg[vwpt_int][SRAM_DELAY] &&
                                                           (vwrbadr_reg[vwpt_int][SRAM_DELAY] == vwrbadr_reg[vout_int][SRAM_DELAY]) &&
                                                           (vwrradr_reg[vwpt_int][SRAM_DELAY] == vwrradr_reg[vout_int][SRAM_DELAY]));
        vwrbadr_out[vout_int] = vwrbadr_reg[vout_int][SRAM_DELAY];
        vwrradr_out[vout_int] = vwrradr_reg[vout_int][SRAM_DELAY];
        vdin_out[vout_int] = vdin_reg[vout_int][SRAM_DELAY];
      end else if (SRAM_DELAY) begin
        vwrite_out[vout_int] = vwrite_reg[vout_int][SRAM_DELAY-1];
        for (vwpt_int=vout_int+1; vwpt_int<NUMWRPT; vwpt_int=vwpt_int+1)
          vwrite_out[vout_int] = vwrite_out[vout_int] && !(vwrite_reg[vwpt_int][SRAM_DELAY-1] &&
                                                           (vwrbadr_reg[vwpt_int][SRAM_DELAY-1] == vwrbadr_reg[vout_int][SRAM_DELAY-1]) &&
                                                           (vwrradr_reg[vwpt_int][SRAM_DELAY-1] == vwrradr_reg[vout_int][SRAM_DELAY-1]));
        vwrbadr_out[vout_int] = vwrbadr_reg[vout_int][SRAM_DELAY-1];
        vwrradr_out[vout_int] = vwrradr_reg[vout_int][SRAM_DELAY-1];
        vdin_out[vout_int] = vdin_reg[vout_int][SRAM_DELAY-1];
      end else begin
        vwrite_out[vout_int] = vwrite_wire[vout_int] && (vwraddr_wire[vout_int] < NUMADDR);
        for (vwpt_int=vout_int+1; vwpt_int<NUMWRPT; vwpt_int=vwpt_int+1)
          vwrite_out[vout_int] = vwrite_out[vout_int] && !(vwrite_wire[vwpt_int] &&
                                                           (vwrbadr_wire[vwpt_int] == vwrbadr_wire[vout_int]) &&
                                                           (vwrradr_wire[vwpt_int] == vwrradr_wire[vout_int]));
        vwrbadr_out[vout_int] = vwrbadr_wire[vout_int];
        vwrradr_out[vout_int] = vwrradr_wire[vout_int];
        vdin_out[vout_int] = vdin_wire[vout_int];
      end
    end
    for (vout_int=0; vout_int<NUMRDPT; vout_int=vout_int+1) begin
      if (SRAM_DELAY) begin
        vread_out[vout_int] = vread_reg[vout_int][SRAM_DELAY-1];
        vrdbadr_out[vout_int] = vrdbadr_reg[vout_int][SRAM_DELAY-1];
        vrdradr_out[vout_int] = vrdradr_reg[vout_int][SRAM_DELAY-1];
      end else begin
        vread_out[vout_int] = vread_wire[vout_int];
        vrdbadr_out[vout_int] = vrdbadr_wire[vout_int];
        vrdradr_out[vout_int] = vrdradr_wire[vout_int];
      end
    end
  end
/*
  integer vwrt_int; 
  always @(posedge clk)
    for (vwrt_int=0; vwrt_int<NUMWRPT; vwrt_int=vwrt_int+1)
      vwrite_out[vwrt_int] <= vwrite_nxt[vwrt_int];
*/

  wire vwrite_out_0 = vwrite_out[0];
  wire [BITVBNK-1:0] vwrbadr_out_0 = vwrbadr_out[0];
  wire [BITVROW-1:0] vwrradr_out_0 = vwrradr_out[0];
  wire [WIDTH-1:0] vdin_out_0 = vdin_out[0];

  wire vwrite_wire_0 = vwrite_wire[0];
  wire [BITVBNK-1:0] vwrbadr_wire_0 = vwrbadr_wire[0];
  wire [BITVROW-1:0] vwrradr_wire_0 = vwrradr_wire[0];
  wire [WIDTH-1:0] vdin_wire_0 = vdin_wire[0];
/*
  wire vread_out_0 = vread_out[0];
  wire [BITVBNK-1:0] vrdbadr_out_0 = vrdbadr_out[0];
  wire [BITVROW-1:0] vrdradr_out_0 = vrdradr_out[0];
*/
  reg pwrite_wire [0:NUMWRPT-1];
  reg [BITPBNK-1:0] pwrbadr_wire [0:NUMWRPT-1];
  reg [BITVROW-1:0] pwrradr_wire [0:NUMWRPT-1];
  reg [MEMWDTH-1:0] pdin_wire [0:NUMWRPT-1];

  wire pwrite_wire_0 = pwrite_wire[0];
  wire [BITPBNK-1:0] pwrbadr_wire_0 = pwrbadr_wire[0];
  wire [BITVROW-1:0] pwrradr_wire_0 = pwrradr_wire[0];
  wire [WIDTH-1:0] pdin_wire_0 = pdin_wire[0];
/*
  wire pwrite_wire_1 = pwrite_wire[1];
  wire [BITPBNK-1:0] pwrbadr_wire_1 = pwrbadr_wire[1];
  wire [BITVROW-1:0] pwrradr_wire_1 = pwrradr_wire[1];
  wire [WIDTH-1:0] pdin_wire_1 = pdin_wire[1];

  wire pwrite_wire_2 = pwrite_wire[2];
  wire [BITPBNK-1:0] pwrbadr_wire_2 = pwrbadr_wire[2];
  wire [BITVROW-1:0] pwrradr_wire_2 = pwrradr_wire[2];
  wire [WIDTH-1:0] pdin_wire_2 = pdin_wire[2];
*/
  // Read request of mapping information on SRAM memory
  reg swrite_wire [0:NUMWRPT-1];
  reg [BITVROW-1:0] swrradr_wire [0:NUMWRPT-1];
  reg [BITMAPT-1:0] sdin_wire [0:NUMWRPT-1];

  wire swrite_wire_0 = swrite_wire[0];
  wire [BITVROW-1:0] swrradr_wire_0 = swrradr_wire[0];
  wire [BITMAPT-1:0] sdin_wire_0 = sdin_wire[0];
/*
  wire swrite_wire_1 = swrite_wire[1];
  wire [BITVROW-1:0] swrradr_wire_1 = swrradr_wire[1];
  wire [BITMAPT-1:0] sdin_wire_1 = sdin_wire[1];
  wire swrite_wire_2 = swrite_wire[2];
  wire [BITVROW-1:0] swrradr_wire_2 = swrradr_wire[2];
  wire [BITMAPT-1:0] sdin_wire_2 = sdin_wire[2];
*/
  reg sread_wire [0:NUMRDPT+NUMWRPT-1];
  reg [BITVROW-1:0] srdradr_wire [0:NUMRDPT+NUMWRPT-1];
  integer srdp_int, srdc_int, srdw_int;
  always_comb begin
    for (srdp_int=0; srdp_int<NUMWRPT; srdp_int=srdp_int+1) begin
      sread_wire[srdp_int] = vwrite_wire[srdp_int];
//      for (srdw_int=0; srdw_int<NUMWRPT-1; srdw_int=srdw_int+1) begin
//        sread_wire[srdp_int] = sread_wire[srdp_int] && !(swrite_wire[srdw_int] && (swrradr_wire[srdw_int] == vwrradr_wire[srdp_int]));
//      end
      srdradr_wire[srdp_int] = vwrradr_wire[srdp_int];
    end
    for (srdp_int=NUMWRPT; srdp_int<NUMRDPT+NUMWRPT; srdp_int=srdp_int+1) begin
      sread_wire[srdp_int] = vread_wire[srdp_int-NUMWRPT];
//      for (srdw_int=0; srdw_int<NUMWRPT-1; srdw_int=srdw_int+1) begin
//        sread_wire[srdp_int] = sread_wire[srdp_int] && !(swrite_wire[srdw_int] && (swrradr_wire[srdw_int] == vrdradr_wire[srdp_int-NUMWRPT]));
//      end
      srdradr_wire[srdp_int] = vrdradr_wire[srdp_int-NUMWRPT];
    end
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
  reg               map_vld [0:NUMRDPT+NUMWRPT-1][0:SRAM_DELAY+FLOPWRM-1];
  reg [BITMAPT-1:0] map_reg [0:NUMRDPT+NUMWRPT-1][0:SRAM_DELAY+FLOPWRM-1];
  genvar sprt_int, sfwd_int;
  generate
    for (sfwd_int=0; sfwd_int<SRAM_DELAY+FLOPWRM; sfwd_int=sfwd_int+1) begin: map_loop
      for (sprt_int=0; sprt_int<NUMRDPT+NUMWRPT; sprt_int=sprt_int+1) begin: prt_loop
        reg [BITVROW-1:0] vradr_temp;
        reg map_vld_next;
        reg [BITMAPT-1:0] map_reg_next;
        integer swpt_int;
        always_comb begin
          if (sfwd_int>0) begin
            if (sprt_int<NUMWRPT)
	      vradr_temp = vwrradr_reg[sprt_int][sfwd_int-1];
            else
	      vradr_temp = vrdradr_reg[sprt_int-NUMWRPT][sfwd_int-1];
            map_vld_next = map_vld[sprt_int][sfwd_int-1];
            map_reg_next = map_reg[sprt_int][sfwd_int-1];
          end else begin
            if (sprt_int<NUMWRPT)
              vradr_temp = vwrradr_wire[sprt_int];
            else
              vradr_temp = vrdradr_wire[sprt_int-NUMWRPT];
	    map_vld_next = 1'b0;
	    map_reg_next = 0;
          end
          for (swpt_int=0; swpt_int<NUMWRPT; swpt_int=swpt_int+1)
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

// ECC Checking Module for SRAM
  reg [BITMAPT-1:0] sdout_wire [0:NUMRDPT+NUMWRPT-1];
  integer sdo_int;
  always_comb
    for (sdo_int=0; sdo_int<NUMRDPT+NUMWRPT; sdo_int=sdo_int+1)
      sdout_wire[sdo_int] = t2_doutB >> (sdo_int*BITMAPT);

  reg [BITMAPT-1:0] sdout_tmp [0:NUMWRPT-1];
  generate if (FLOPWRM) begin: wmflp_loop
    integer sdd_int;
    always @(posedge clk)
      for (sdd_int=0; sdd_int<NUMWRPT; sdd_int=sdd_int+1)
        sdout_tmp[sdd_int] <= sdout_wire[sdd_int];
  end else begin: nwmflp_floop
    integer sdd_int;
    always_comb
      for (sdd_int=0; sdd_int<NUMWRPT; sdd_int=sdd_int+1)
        sdout_tmp[sdd_int] = sdout_wire[sdd_int];
  end
  endgenerate
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
  reg [BITMAPT-1:0] map_out [0:NUMRDPT+NUMWRPT-1];
  integer fprt_int;
  always_comb begin
    for (fprt_int=0; fprt_int<NUMWRPT; fprt_int=fprt_int+1) 
      if (SRAM_DELAY+FLOPWRM)
        map_out[fprt_int] = map_vld[fprt_int][SRAM_DELAY+FLOPWRM-1] ? map_reg[fprt_int][SRAM_DELAY+FLOPWRM-1] : sdout_tmp[fprt_int];
      else
        map_out[fprt_int] = sdout_tmp[fprt_int];
    for (fprt_int=NUMWRPT; fprt_int<NUMRDPT+NUMWRPT; fprt_int=fprt_int+1)
      if (SRAM_DELAY)
        map_out[fprt_int] = map_vld[fprt_int][SRAM_DELAY-1] ? map_reg[fprt_int][SRAM_DELAY-1] : sdout_wire[fprt_int];
      else
        map_out[fprt_int] = sdout_wire[fprt_int];
  end

  wire [BITMAPT-1:0] map_out_0 = map_out[0];
  wire [BITMAPT-1:0] map_out_1 = map_out[1];
/*
  wire [BITMAPT-1:0] map_out_2 = map_out[2];
*/

  reg [BITPBNK-1:0] map_wire [0:NUMVBNK-1][0:NUMRDPT+NUMWRPT-1];
  integer mprt_int, mloc_int;
  always_comb
    for (mprt_int=0; mprt_int<NUMRDPT+NUMWRPT; mprt_int=mprt_int+1)
      for (mloc_int=0; mloc_int<NUMVBNK; mloc_int=mloc_int+1)
        map_wire[mloc_int][mprt_int] = map_out[mprt_int] >> (mloc_int*BITPBNK);

  reg [BITPBNK-1:0] prdbadr_reg [0:NUMRDPT-1][0:DRAM_DELAY-1];
  reg prdfwrd_reg [0:NUMRDPT-1][0:DRAM_DELAY-1];
  reg prdvldm_reg [0:NUMRDPT-1][0:DRAM_DELAY-1];
  reg [WIDTH-1:0] prddata_reg [0:NUMRDPT-1][0:DRAM_DELAY-1];

  wire vread_fwrd_help [0:NUMRDPT-1];
  wire vread_serr_help [0:NUMRDPT-1];
  wire vread_derr_help [0:NUMRDPT-1];
  wire [BITPADR-BITPBNK-1:0] vread_padr_help [0:NUMRDPT-1];

  wire vread_vld_wire [0:NUMRDPT-1];
  wire vread_fwrd_wire [0:NUMRDPT-1];
  wire vread_serr_wire [0:NUMRDPT-1];
  wire vread_derr_wire [0:NUMRDPT-1];
  wire [BITPADR-1:0] vread_padr_wire [0:NUMRDPT-1];
  wire [MEMWDTH-1:0] vdout_help [0:NUMRDPT-1];
  wire [WIDTH-1:0] vdout_wire [0:NUMRDPT-1];
  genvar vrd_var;
  generate for (vrd_var=0; vrd_var<NUMRDPT; vrd_var=vrd_var+1) begin: vrd_loop
    if (ENAPAR) begin: pc_loop
      assign vread_vld_wire[vrd_var] = vread_reg[vrd_var][SRAM_DELAY+DRAM_DELAY-1];
      assign vdout_help[vrd_var] = t1_doutA >> ((vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1])*MEMWDTH);
      assign vread_fwrd_help[vrd_var] = t1_fwrdA >> (vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1]);
      assign vread_padr_help[vrd_var] = t1_padrA >> ((vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1])*(BITPADR-BITPBNK));
      assign vread_fwrd_wire[vrd_var] = vread_fwrd_help[vrd_var] || prdfwrd_reg[vrd_var][DRAM_DELAY-1];
      assign vread_serr_wire[vrd_var] = ^vdout_help[vrd_var] && prdvldm_reg[vrd_var][DRAM_DELAY-1];
      assign vread_derr_wire[vrd_var] = 1'b0;
      assign vread_padr_wire[vrd_var] = {prdbadr_reg[vrd_var][DRAM_DELAY-1],vread_padr_help[vrd_var]};
      assign vdout_wire[vrd_var] = prdfwrd_reg[vrd_var][DRAM_DELAY-1] ? prddata_reg[vrd_var][DRAM_DELAY-1] : vdout_help[vrd_var];
    end else if (ENAECC) begin: ec_loop
      assign vread_vld_wire[vrd_var] = vread_reg[vrd_var][SRAM_DELAY+DRAM_DELAY-1];
      assign vdout_help[vrd_var] = t1_doutA >> ((vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1])*MEMWDTH);

      wire [WIDTH-1:0] rd_data_wire = vdout_help[vrd_var];
      wire [ECCWDTH-1:0] rd_ecc_wire = vdout_help[vrd_var] >> WIDTH;
      wire [WIDTH-1:0] rd_corr_data_wire;
      wire rd_sec_err_wire;
      wire rd_ded_err_wire;
    
      ecc_check   #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
          ecc_check_inst (.din(rd_data_wire), .eccin(rd_ecc_wire),
                          .dout(rd_corr_data_wire), .sec_err(rd_sec_err_wire), .ded_err(rd_ded_err_wire),
                          .clk(clk), .rst(rst));

      assign vread_fwrd_help[vrd_var] = t1_fwrdA >> (vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1]);
      assign vread_padr_help[vrd_var] = t1_padrA >> ((vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1])*(BITPADR-BITPBNK));
      assign vread_fwrd_wire[vrd_var] = vread_fwrd_help[vrd_var] || prdfwrd_reg[vrd_var][DRAM_DELAY-1];
      assign vread_serr_wire[vrd_var] = rd_sec_err_wire && prdvldm_reg[vrd_var][DRAM_DELAY-1];
      assign vread_derr_wire[vrd_var] = rd_ded_err_wire && prdvldm_reg[vrd_var][DRAM_DELAY-1];
      assign vread_padr_wire[vrd_var] = {prdbadr_reg[vrd_var][DRAM_DELAY-1],vread_padr_help[vrd_var]};
      assign vdout_wire[vrd_var] = prdfwrd_reg[vrd_var][DRAM_DELAY-1] ? prddata_reg[vrd_var][DRAM_DELAY-1] : rd_corr_data_wire;
    end else begin: nc_loop
      assign vread_vld_wire[vrd_var] = vread_reg[vrd_var][SRAM_DELAY+DRAM_DELAY-1];
      assign vdout_help[vrd_var] = t1_doutA >> ((vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1])*MEMWDTH);
      assign vread_fwrd_help[vrd_var] = t1_fwrdA >> (vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1]);
      assign vread_serr_help[vrd_var] = t1_serrA >> (vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1]);
      assign vread_derr_help[vrd_var] = t1_derrA >> (vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1]);
      assign vread_padr_help[vrd_var] = t1_padrA >> ((vrd_var*NUMPBNK+prdbadr_reg[vrd_var][DRAM_DELAY-1])*(BITPADR-BITPBNK));
      assign vread_fwrd_wire[vrd_var] = vread_fwrd_help[vrd_var] || prdfwrd_reg[vrd_var][DRAM_DELAY-1];
      assign vread_serr_wire[vrd_var] = vread_serr_help[vrd_var] && prdvldm_reg[vrd_var][DRAM_DELAY-1];
      assign vread_derr_wire[vrd_var] = vread_derr_help[vrd_var] && prdvldm_reg[vrd_var][DRAM_DELAY-1];
      assign vread_padr_wire[vrd_var] = {prdbadr_reg[vrd_var][DRAM_DELAY-1],vread_padr_help[vrd_var]};
      assign vdout_wire[vrd_var] = prdfwrd_reg[vrd_var][DRAM_DELAY-1] ? prddata_reg[vrd_var][DRAM_DELAY-1] : vdout_help[vrd_var];
    end
  end
  endgenerate
/*
  reg vread_vld_wire [0:NUMRDPT-1];
  reg vread_fwrd_wire [0:NUMRDPT-1];
  reg vread_fwrd_help [0:NUMRDPT-1];
  reg vread_serr_wire [0:NUMRDPT-1];
  reg vread_derr_wire [0:NUMRDPT-1];
  reg [BITPBNK-1:0] vread_badr_wire [0:NUMRDPT-1];
  reg [BITPADR-BITPBNK-1:0] vread_padr_wire [0:NUMRDPT-1];
  reg [WIDTH-1:0] vdout_wire [0:NUMRDPT-1];
  integer vdop_int;
  always_comb
    for (vdop_int=0; vdop_int<NUMRDPT; vdop_int=vdop_int+1) begin
      vread_vld_wire[vdop_int] = vread_reg[vdop_int][SRAM_DELAY+DRAM_DELAY-1];
      vread_fwrd_help[vdop_int] = t1_fwrdB >> (vdop_int*NUMPBNK+prdbadr_reg[vdop_int][DRAM_DELAY-1]);
      vread_fwrd_wire[vdop_int] = vread_fwrd_help[vdop_int] || prdfwrd_reg[vdop_int][DRAM_DELAY-1];
      vread_serr_wire[vdop_int] = t1_serrB >> (vdop_int*NUMPBNK+prdbadr_reg[vdop_int][DRAM_DELAY-1]);
      vread_derr_wire[vdop_int] = t1_derrB >> (vdop_int*NUMPBNK+prdbadr_reg[vdop_int][DRAM_DELAY-1]);
      vread_badr_wire[vdop_int] = prdbadr_reg[vdop_int][DRAM_DELAY-1];
      vread_padr_wire[vdop_int] = t1_padrB >> ((vdop_int*NUMPBNK+prdbadr_reg[vdop_int][DRAM_DELAY-1])*(BITPADR-BITPBNK));
      vdout_wire[vdop_int] = prdfwrd_reg[vdop_int][DRAM_DELAY-1] ? prddata_reg[vdop_int][DRAM_DELAY-1] :
                                                                   t1_doutB >> ((vdop_int*NUMPBNK+prdbadr_reg[vdop_int][DRAM_DELAY-1])*WIDTH);
    end
*/
  reg [NUMRDPT-1:0] vread_vld_tmp;
  reg [NUMRDPT-1:0] vread_fwrd_tmp;
  reg [NUMRDPT-1:0] vread_serr_tmp;
  reg [NUMRDPT-1:0] vread_derr_tmp;
  reg [NUMRDPT*BITPADR-1:0] vread_padr_tmp;
  reg [NUMRDPT*WIDTH-1:0] vdout_tmp;
  integer vdo_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_fwrd_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    for (vdo_int=0; vdo_int<NUMRDPT; vdo_int=vdo_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_vld_wire[vdo_int] << vdo_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vdo_int] << (vdo_int*WIDTH));
      vread_fwrd_tmp = vread_fwrd_tmp | (vread_fwrd_wire[vdo_int] << vdo_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vdo_int] << vdo_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vdo_int] << vdo_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vdo_int] << (vdo_int*BITPADR));
    end
  end

  reg [NUMRDPT-1:0] vread_vld;
  reg [NUMRDPT-1:0] vread_fwrd;
  reg [NUMRDPT-1:0] vread_serr;
  reg [NUMRDPT-1:0] vread_derr;
  reg [NUMRDPT*BITPADR-1:0] vread_padr;
  reg [NUMRDPT*WIDTH-1:0] vdout;
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

  wire map_vld_0 = map_vld[0][SRAM_DELAY-1];
/*
  wire map_vld_1 = map_vld[1][SRAM_DELAY-1];
  wire map_vld_2 = map_vld[2][SRAM_DELAY-1];
  wire map_vld_3 = map_vld[3][SRAM_DELAY-1];
*/
  wire [BITMAPT-1:0] map_reg_0 = map_reg[0][SRAM_DELAY-1];
/*
  wire [BITMAPT-1:0] map_reg_1 = map_reg[1][SRAM_DELAY-1];
  wire [BITMAPT-1:0] map_reg_2 = map_reg[2][SRAM_DELAY-1];
  wire [BITMAPT-1:0] map_reg_3 = map_reg[3][SRAM_DELAY-1];
  wire [BITMAPT-1:0] map_out_0 = map_out[0];
  wire [BITMAPT-1:0] map_out_1 = map_out[1];
  wire [BITMAPT-1:0] map_out_2 = map_out[2];
  wire [BITMAPT-1:0] map_out_3 = map_out[3];
*/
  reg [NUMPBNK-1:0] used_pivot_blk [0:NUMWRPT-1];
  integer blkp_int, blkx_int;
  always_comb
    for (blkp_int=0; blkp_int<NUMWRPT; blkp_int=blkp_int+1) begin
      used_pivot_blk[blkp_int] = 0;
      for (blkx_int=0; blkx_int<NUMVBNK; blkx_int=blkx_int+1)
        if (blkx_int != vwrbadr_out[blkp_int])
          used_pivot_blk[blkp_int] = used_pivot_blk[blkp_int] | (1'b1 << map_wire[blkx_int][blkp_int]);
    end

  reg [NUMPBNK-1:0] used_pivot_temp [0:NUMWRPT-1];
  reg [NUMPBNK-1:0] used_pivot [0:NUMWRPT-1];
  reg               new_vld [0:NUMWRPT-1];
  reg [BITPBNK-1:0] new_pos [0:NUMWRPT-1];
  integer newp_int, newx_int;
  always_comb
    for (newp_int=0; newp_int<NUMWRPT; newp_int=newp_int+1) begin
      new_vld[newp_int] = 1'b0;
      new_pos[newp_int] = 0;
      if (vwrite_out[newp_int])
        for (newx_int=NUMPBNK-1; newx_int>=0; newx_int=newx_int-1)
          if (!used_pivot_blk[newp_int][newx_int] && !used_pivot_temp[newp_int][newx_int]) begin
            new_vld[newp_int] = 1'b1;
            new_pos[newp_int] = newx_int;
          end
    end

  integer usei_int;
  reg [NUMPBNK-1:0] used_pivot_init;
  always_comb begin
    used_pivot_init = 0;
    for (usei_int=0; usei_int<NUMRDPT; usei_int=usei_int+1)
      if (vread_out[usei_int])
        used_pivot_init = used_pivot_init | (1'b1 << map_wire[vrdbadr_out[usei_int]][usei_int+NUMWRPT]);
  end

  integer usep_int;
  always_comb
    for (usep_int=0; usep_int<NUMWRPT; usep_int=usep_int+1) begin
      if (usep_int>0)
        used_pivot_temp[usep_int] = used_pivot[usep_int-1];
      else
        used_pivot_temp[usep_int] = used_pivot_init;
      used_pivot[usep_int] = used_pivot_temp[usep_int];
      if (new_vld[usep_int])
        used_pivot[usep_int] = used_pivot[usep_int] | (1'b1 << new_pos[usep_int]);
    end

  wire [NUMPBNK-1:0] used_pivot_blk_0 = used_pivot_blk[0];
  wire [NUMPBNK-1:0] used_pivot_temp_0 = used_pivot_temp[0];
  wire [NUMPBNK-1:0] used_pivot_0 = used_pivot[0];
/*
  wire [NUMPBNK-1:0] used_pivot_blk_1 = used_pivot_blk[1];
  wire [NUMPBNK-1:0] used_pivot_temp_1 = used_pivot_temp[1];
  wire [NUMPBNK-1:0] used_pivot_1 = used_pivot[1];
*/
  reg forward_read [0:NUMRDPT-1];
  reg [WIDTH-1:0] forward_data [0:NUMRDPT-1];
  integer fwdp_int, fwdw_int;
  always_comb
    for (fwdp_int=0; fwdp_int<NUMRDPT; fwdp_int=fwdp_int+1) begin
      forward_read[fwdp_int] = 0;
      forward_data[fwdp_int] = 0;
      for (fwdw_int=0; fwdw_int<NUMWRPT; fwdw_int=fwdw_int+1)
        if (FLOPPWR && FLOPWRM &&
            vwrite_reg[fwdw_int][SRAM_DELAY+1] && (vwrbadr_reg[fwdw_int][SRAM_DELAY+1] == vrdbadr_out[fwdp_int]) &&
                                                             (vwrradr_reg[fwdw_int][SRAM_DELAY+1] == vrdradr_out[fwdp_int])) begin
          forward_read[fwdp_int] = 1'b1;
          forward_data[fwdp_int] = vdin_reg[fwdw_int][SRAM_DELAY+1];
        end
      for (fwdw_int=0; fwdw_int<NUMWRPT; fwdw_int=fwdw_int+1)
        if ((FLOPPWR || FLOPWRM) &&
            vwrite_reg[fwdw_int][SRAM_DELAY] && (vwrbadr_reg[fwdw_int][SRAM_DELAY] == vrdbadr_out[fwdp_int]) &&
                                                (vwrradr_reg[fwdw_int][SRAM_DELAY] == vrdradr_out[fwdp_int])) begin
          forward_read[fwdp_int] = 1'b1;
          forward_data[fwdp_int] = vdin_reg[fwdw_int][SRAM_DELAY];
        end
    end

  wire forward_read_0 = forward_read[0];

  reg pread_wire [0:NUMRDPT-1]; 
  reg [BITPBNK-1:0] prdbadr_wire [0:NUMRDPT-1];
  reg [BITVROW-1:0] prdradr_wire [0:NUMRDPT-1];
  integer prdw_int;
  always_comb
    for (prdw_int=0; prdw_int<NUMRDPT; prdw_int=prdw_int+1) begin
      pread_wire[prdw_int] = vread_out[prdw_int] && !forward_read[prdw_int];
      prdbadr_wire[prdw_int] = map_wire[vrdbadr_out[prdw_int]][prdw_int+NUMWRPT];
      prdradr_wire[prdw_int] = vrdradr_out[prdw_int];
    end
      
  integer prdp_int, prdd_int, prdf_int;
  always @(posedge clk)
    for (prdp_int=0; prdp_int<NUMRDPT; prdp_int=prdp_int+1)
      for (prdd_int=0; prdd_int<DRAM_DELAY; prdd_int=prdd_int+1)
        if (prdd_int>0) begin
          prdbadr_reg[prdp_int][prdd_int] <= prdbadr_reg[prdp_int][prdd_int-1];
          prdfwrd_reg[prdp_int][prdd_int] <= prdfwrd_reg[prdp_int][prdd_int-1];
          prddata_reg[prdp_int][prdd_int] <= prddata_reg[prdp_int][prdd_int-1];
          prdvldm_reg[prdp_int][prdd_int] <= prdvldm_reg[prdp_int][prdd_int-1];
        end else begin
          prdbadr_reg[prdp_int][prdd_int] <= prdbadr_wire[prdp_int];
          prdfwrd_reg[prdp_int][prdd_int] <= forward_read[prdp_int];
          prddata_reg[prdp_int][prdd_int] <= forward_data[prdp_int];
          prdvldm_reg[prdp_int][prdd_int] <= vread_out[prdp_int] && !forward_read[prdp_int];
/*
          prdfwrd_reg[prdp_int][prdd_int] <= 1'b0;
          prddata_reg[prdp_int][prdd_int] <= 0;
          for (prdf_int=0; prdf_int<NUMWRPT; prdf_int=prdf_int+1)
            if (vwrite_reg[prdf_int][SRAM_DELAY+1] &&
                (vwrbadr_reg[prdf_int][SRAM_DELAY+1] == vrdbadr_reg[prdp_int][SRAM_DELAY-1]) &&
                (vwrradr_reg[prdf_int][SRAM_DELAY+1] == vrdradr_reg[prdp_int][SRAM_DELAY-1])) begin
              prdfwrd_reg[prdp_int][prdd_int] <= 1'b1;
              prddata_reg[prdp_int][prdd_int] <= vdin_reg[prdf_int][SRAM_DELAY+1];
            end   
          for (prdf_int=0; prdf_int<NUMWRPT; prdf_int=prdf_int+1)
            if (vwrite_reg[prdf_int][SRAM_DELAY] &&
                (vwrbadr_reg[prdf_int][SRAM_DELAY] == vrdbadr_reg[prdp_int][SRAM_DELAY-1]) &&
                (vwrradr_reg[prdf_int][SRAM_DELAY] == vrdradr_reg[prdp_int][SRAM_DELAY-1])) begin
              prdfwrd_reg[prdp_int][prdd_int] <= 1'b1;
              prddata_reg[prdp_int][prdd_int] <= vdin_reg[prdf_int][SRAM_DELAY];
            end   
*/
        end

  wire pread_wire_0 = pread_wire[0];
  wire [BITVBNK-1:0] prdbadr_wire_0 = prdbadr_wire[0];
  wire [BITVROW-1:0] prdradr_wire_0 = prdradr_wire[0];
/*
  wire pread_wire_1 = pread_wire[1];
  wire [BITVBNK-1:0] prdbadr_wire_1 = prdbadr_wire[1];
  wire [BITVROW-1:0] prdradr_wire_1 = prdradr_wire[1];
*/
  wire new_vld_0 = new_vld[0];
  wire [BITPBNK-1:0] new_pos_0 = new_pos[0];
/*
  wire [BITPBNK-1:0] map_wire_0_0 = map_wire[0][0];
  wire [BITPBNK-1:0] map_wire_1_0 = map_wire[1][0];
  wire [BITPBNK-1:0] map_wire_2_0 = map_wire[2][0];
  wire [BITPBNK-1:0] map_wire_3_0 = map_wire[3][0];
  wire new_vld_1 = new_vld[1];
  wire [BITPBNK-1:0] new_pos_1 = new_pos[1];
  wire [BITPBNK-1:0] map_wire_0_1 = map_wire[0][1];
  wire [BITPBNK-1:0] map_wire_1_1 = map_wire[1][1];
  wire [BITPBNK-1:0] map_wire_2_1 = map_wire[2][1];
  wire [BITPBNK-1:0] map_wire_3_1 = map_wire[3][1];
*/
  wire [MEMWDTH-1:0] din_tmp [0:NUMWRPT-1];
  genvar din_var;
  generate for (din_var=0; din_var<NUMWRPT; din_var=din_var+1) begin: var_loop
    if (ENAPAR) begin: pg_loop
      assign din_tmp[din_var] = {^vdin_out[din_var],vdin_out[din_var]};
    end else if (ENAECC) begin: eg_loop
      wire [ECCWDTH-1:0] din_ecc;
      ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
        ecc_calc_inst (.din(vdin_out[din_var]), .eccout(din_ecc));
      assign din_tmp[din_var] = {din_ecc,vdin_out[din_var]};
    end else begin: ng_loop
      assign din_tmp[din_var] = vdin_out[din_var];
    end
  end
  endgenerate

  integer pwrp_int;
  always_comb
    for (pwrp_int=0; pwrp_int<NUMWRPT; pwrp_int=pwrp_int+1) begin
      pwrite_wire[pwrp_int] = vwrite_out[pwrp_int];
      pwrbadr_wire[pwrp_int] = new_pos[pwrp_int];
      pwrradr_wire[pwrp_int] = vwrradr_out[pwrp_int];
      pdin_wire[pwrp_int] = din_tmp[pwrp_int];
    end

  reg pwrite_tmp [0:NUMWRPT-1];
  reg [BITPBNK-1:0] pwrbadr_tmp [0:NUMWRPT-1];
  reg [BITVROW-1:0] pwrradr_tmp [0:NUMWRPT-1];
  reg [MEMWDTH-1:0] pdin_tmp [0:NUMWRPT-1];
  generate if (FLOPPWR) begin: pwflp_loop
    integer pwrd_int; 
    always @(posedge clk)
      for (pwrd_int=0; pwrd_int<NUMWRPT; pwrd_int=pwrd_int+1) begin
        pwrite_tmp[pwrd_int] <= pwrite_wire[pwrd_int];
        pwrbadr_tmp[pwrd_int] <= pwrbadr_wire[pwrd_int];
        pwrradr_tmp[pwrd_int] <= pwrradr_wire[pwrd_int];
        pdin_tmp[pwrd_int] <= pdin_wire[pwrd_int];
      end
  end else begin: npwflp_loop
    integer pwrd_int; 
    always_comb
      for (pwrd_int=0; pwrd_int<NUMWRPT; pwrd_int=pwrd_int+1) begin
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
  reg [NUMRDPT*NUMPBNK-1:0] t1_readA;
  reg [NUMRDPT*NUMPBNK-1:0] t1_writeA;
  reg [NUMRDPT*NUMPBNK*BITVROW-1:0] t1_addrA;
  reg [NUMRDPT*NUMPBNK*MEMWDTH-1:0] t1_dinA;
  integer t1w_int, t1wa_int, t1wb_int, t1r_int, t1ra_int, t1rb_int;
  always_comb begin
    t1_readA = 0;
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (t1w_int=0; t1w_int<NUMWRPT; t1w_int=t1w_int+1)
      for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
        if (pwrite_tmp[t1w_int] && (pwrbadr_tmp[t1w_int]<NUMPBNK))
          t1_writeA = t1_writeA | (1'b1 << (t1r_int*NUMPBNK+pwrbadr_tmp[t1w_int]));
        for (t1wb_int=0; t1wb_int<NUMPBNK; t1wb_int=t1wb_int+1)
          if (pwrite_tmp[t1w_int] && (pwrbadr_tmp[t1w_int]==t1wb_int)) begin
            for (t1wa_int=0; t1wa_int<BITVROW; t1wa_int=t1wa_int+1)
              t1_addrA[(t1r_int*NUMPBNK+t1wb_int)*BITVROW+t1wa_int] = pwrradr_tmp[t1w_int][t1wa_int];
            for (t1wa_int=0; t1wa_int<MEMWDTH; t1wa_int=t1wa_int+1)
              t1_dinA[(t1r_int*NUMPBNK+t1wb_int)*MEMWDTH+t1wa_int] = pdin_tmp[t1w_int][t1wa_int];
          end
      end
    for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
      if (pread_wire[t1r_int])
        t1_readA = t1_readA | (1'b1 << (t1r_int*NUMPBNK+prdbadr_wire[t1r_int]));
      for (t1rb_int=0; t1rb_int<NUMPBNK; t1rb_int=t1rb_int+1)
        if (pread_wire[t1r_int] && (prdbadr_wire[t1r_int]==t1rb_int))
          for (t1ra_int=0; t1ra_int<BITVROW; t1ra_int=t1ra_int+1)
            t1_addrA[(t1r_int*NUMPBNK+t1rb_int)*BITVROW+t1ra_int] = prdradr_wire[t1r_int][t1ra_int];
    end
  end

  integer swrp_int, swrx_int;
  always_comb
    for (swrp_int=0; swrp_int<NUMWRPT; swrp_int=swrp_int+1) 
      if (rstvld && (swrp_int==0)) begin
        swrite_wire[swrp_int] = 1'b1;
        swrradr_wire[swrp_int] = rstaddr;
        sdin_wire[swrp_int] = rstdin;
      end else if (new_vld[swrp_int]) begin
        swrite_wire[swrp_int] = 1'b1;
        swrradr_wire[swrp_int] = vwrradr_out[swrp_int];
        sdin_wire[swrp_int] = map_out[swrp_int];
        for (swrx_int=0; swrx_int<swrp_int; swrx_int=swrx_int+1)
          if (swrite_wire[swrx_int] && swrite_wire[swrp_int] && (swrradr_wire[swrx_int] == swrradr_wire[swrp_int])) begin
            swrite_wire[swrx_int] = 1'b0;
            sdin_wire[swrp_int] = sdin_wire[swrx_int];
          end
        sdin_wire[swrp_int] = (sdin_wire[swrp_int] & ~({BITPBNK{1'b1}} << (vwrbadr_out[swrp_int]*BITPBNK))) |
                              (new_pos[swrp_int] << (vwrbadr_out[swrp_int]*BITPBNK));
      end else begin
        swrite_wire[swrp_int] = 1'b0;
        swrradr_wire[swrp_int] = 0;
        sdin_wire[swrp_int] = 0;
      end

  reg [NUMWRPT-1:0] t2_writeA;
  reg [NUMWRPT*BITVROW-1:0] t2_addrA;
  reg [NUMWRPT*BITMAPT-1:0] t2_dinA;
  reg [(NUMRDPT+NUMWRPT)-1:0] t2_readB;
  reg [(NUMRDPT+NUMWRPT)*BITVROW-1:0] t2_addrB;
  integer smcp_int;
  always_comb begin
    t2_writeA = 0;
    t2_addrA = 0;
    t2_dinA = 0;
    t2_readB = 0;
    t2_addrB = 0;
    for (smcp_int=0; smcp_int<NUMRDPT+NUMWRPT; smcp_int=smcp_int+1) begin
      t2_readB = t2_readB | (sread_wire[smcp_int] << smcp_int);
      t2_addrB = t2_addrB | (srdradr_wire[smcp_int] << (smcp_int*BITVROW));
    end
    for (smcp_int=0; smcp_int<NUMWRPT; smcp_int=smcp_int+1) begin
      t2_writeA = t2_writeA | (swrite_wire[smcp_int] << smcp_int);
      t2_addrA = t2_addrA | (swrradr_wire[smcp_int] << (smcp_int*BITVROW));
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
