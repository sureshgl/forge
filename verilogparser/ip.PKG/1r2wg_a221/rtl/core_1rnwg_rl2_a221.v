
module core_1rnwg_rl2_a221 (vwrite, vwraddr, vdin,
                            vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                            t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_padrB,
                            t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_padrB,
                            ready, clk, rst);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter ENAPSDO = 0;
  parameter NUMWRPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 14;
  parameter REFRESH = 0;
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter ECCBITS = 4;
  
  parameter SDOUT_WIDTH = 2*(BITVBNK+1)+ECCBITS;

  input [NUMWRPT-1:0]                vwrite;
  input [NUMWRPT*BITADDR-1:0]        vwraddr;
  input [NUMWRPT*WIDTH-1:0]          vdin;
  
  input                              vread;
  input [BITADDR-1:0]                vrdaddr;
  output                             vread_vld;
  output [WIDTH-1:0]                 vdout;
  output                             vread_fwrd;
  output                             vread_serr;
  output                             vread_derr;
  output [BITPADR-1:0]               vread_padr;

  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*WIDTH-1:0] t1_dinA;

  output [NUMVBNK-1:0] t1_readB;
  output [NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMVBNK*WIDTH-1:0] t1_doutB;
  input [NUMVBNK-1:0] t1_fwrdB;
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB;

  output [2*NUMWRPT-1:0] t2_writeA;
  output [2*NUMWRPT*BITVROW-1:0] t2_addrA;
  output [2*NUMWRPT*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;

  output [2*NUMWRPT-1:0] t2_readB;
  output [2*NUMWRPT*BITVROW-1:0] t2_addrB;
  input [2*NUMWRPT*(SDOUT_WIDTH+WIDTH)-1:0] t2_doutB;
  input [2*NUMWRPT-1:0] t2_fwrdB;
  input [2*NUMWRPT*(BITPADR-BITPBNK)-1:0] t2_padrB;

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

  reg ready;
  always @(posedge clk)
    ready <= !rstvld;

  wire ready_wire;
  wire vread_wire;
  wire [BITADDR-1:0] vrdaddr_wire;
  wire [BITVBNK-1:0] vrdbadr_wire;
  wire [BITVROW-1:0] vrdradr_wire;
  wire vwrite_wire [0:NUMWRPT-1];
  wire [BITADDR-1:0] vwraddr_wire [0:NUMWRPT-1];
  wire [BITVBNK-1:0] vwrbadr_wire [0:NUMWRPT-1];
  wire [BITVROW-1:0] vwrradr_wire [0:NUMWRPT-1];
  wire [WIDTH-1:0] vdin_wire [0:NUMWRPT-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg vread_reg;
    reg [BITADDR-1:0] vrdaddr_reg;
    reg [NUMWRPT-1:0] vwrite_reg;
    reg [NUMWRPT*BITADDR-1:0] vwraddr_reg;
    reg [NUMWRPT*WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread & ready;
      vrdaddr_reg <= vrdaddr;
      vwrite_reg <= vwrite & {2{ready}};
      vwraddr_reg <= vwraddr;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    assign vread_wire = vread_reg;
    assign vrdaddr_wire = vrdaddr_reg;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire), .vradr(vrdradr_wire), .vaddr(vrdaddr_wire));

    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite_reg >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr_reg >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*WIDTH);
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
          wr_adr_inst (.vbadr(vwrbadr_wire[np2_var]), .vradr(vwrradr_wire[np2_var]), .vaddr(vwraddr_wire[np2_var]));
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    assign vread_wire = vread;
    assign vrdaddr_wire = vrdaddr;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire), .vradr(vrdradr_wire), .vaddr(vrdaddr_wire));

    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite >> np2_var;
      assign vwraddr_wire[np2_var] = vwraddr >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
          wr_adr_inst (.vbadr(vwrbadr_wire[np2_var]), .vradr(vwrradr_wire[np2_var]), .vaddr(vwraddr_wire[np2_var]));
    end
  end
  endgenerate

  reg                vread_reg [0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:SRAM_DELAY-1];
  reg [BITVROW-1:0]  vrdradr_reg [0:SRAM_DELAY-1];
  integer vrd_int; 
  always @(posedge clk)
    for (vrd_int=0; vrd_int<SRAM_DELAY; vrd_int=vrd_int+1)
      if (vrd_int > 0) begin
        vread_reg[vrd_int] <= vread_reg[vrd_int-1];
        vrdbadr_reg[vrd_int] <= vrdbadr_reg[vrd_int-1];
        vrdradr_reg[vrd_int] <= vrdradr_reg[vrd_int-1];
      end else begin
        vread_reg[vrd_int] <= vread_wire;
        vrdbadr_reg[vrd_int] <= vrdbadr_wire;
        vrdradr_reg[vrd_int] <= vrdradr_wire;
      end

  reg                vwrite_reg [0:NUMWRPT-1][0:SRAM_DELAY];
  reg [BITVBNK-1:0]  vwrbadr_reg [0:NUMWRPT-1][0:SRAM_DELAY];
  reg [BITVROW-1:0]  vwrradr_reg [0:NUMWRPT-1][0:SRAM_DELAY];
  reg [WIDTH-1:0]    vdin_reg [0:NUMWRPT-1][0:SRAM_DELAY];
  integer vwrp_int, vwrd_int; 
  always @(posedge clk)
    for (vwrp_int=0; vwrp_int<NUMWRPT; vwrp_int=vwrp_int+1)
      for (vwrd_int=0; vwrd_int<SRAM_DELAY+1; vwrd_int=vwrd_int+1)
        if (vwrd_int > 0) begin
          vwrite_reg[vwrp_int][vwrd_int] <= vwrite_reg[vwrp_int][vwrd_int-1];
          vwrbadr_reg[vwrp_int][vwrd_int] <= vwrbadr_reg[vwrp_int][vwrd_int-1];
          vwrradr_reg[vwrp_int][vwrd_int] <= vwrradr_reg[vwrp_int][vwrd_int-1];          
          vdin_reg[vwrp_int][vwrd_int] <= vdin_reg[vwrp_int][vwrd_int-1];
        end else begin
          vwrite_reg[vwrp_int][vwrd_int] <= vwrite_wire[vwrp_int] && (vwraddr_wire[vwrp_int] < NUMADDR) && ready_wire;
          vwrbadr_reg[vwrp_int][vwrd_int] <= vwrbadr_wire[vwrp_int];
          vwrradr_reg[vwrp_int][vwrd_int] <= vwrradr_wire[vwrp_int];
          vdin_reg[vwrp_int][vwrd_int] <= vdin_wire[vwrp_int];          
        end

  wire               vread_out = vread_reg[SRAM_DELAY-1];
  wire [BITVBNK-1:0] vrdbadr_out = vrdbadr_reg[SRAM_DELAY-1];
  wire [BITVROW-1:0] vrdradr_out = vrdradr_reg[SRAM_DELAY-1];

  reg                vwrite_out [0:NUMWRPT-1];
  reg [BITVBNK-1:0]  vwrbadr_out [0:NUMWRPT-1];
  reg [BITVROW-1:0]  vwrradr_out [0:NUMWRPT-1];
  reg [WIDTH-1:0]    vdin_out [0:NUMWRPT-1];
  integer vout_int;
  always_comb
    for (vout_int=0; vout_int<NUMWRPT; vout_int=vout_int+1) begin
      vwrite_out[vout_int] = vwrite_reg[vout_int][SRAM_DELAY];
      vwrbadr_out[vout_int] = vwrbadr_reg[vout_int][SRAM_DELAY];
      vwrradr_out[vout_int] = vwrradr_reg[vout_int][SRAM_DELAY];
      vdin_out[vout_int] = vdin_reg[vout_int][SRAM_DELAY];
    end

  reg                    pwrite_wire [0:NUMWRPT-1];
  reg [BITVBNK-1:0]      pwrbadr_wire [0:NUMWRPT-1];
  reg [BITVROW-1:0]      pwrradr_wire [0:NUMWRPT-1];
  reg [WIDTH-1:0]        pdin_wire [0:NUMWRPT-1];

  wire pwrite_wire_0 = pwrite_wire[0];
  wire [BITVBNK-1:0] pwrbadr_wire_0 = pwrbadr_wire[0];
  wire [BITVROW-1:0] pwrradr_wire_0 = pwrradr_wire[0];
  wire [SDOUT_WIDTH-1:0] pdin_wire_0 = pdin_wire[0];
  
  wire pwrite_wire_1 = pwrite_wire[1];
  wire [BITVBNK-1:0] pwrbadr_wire_1 = pwrbadr_wire[1];
  wire [BITVROW-1:0] pwrradr_wire_1 = pwrradr_wire[1];
  wire [SDOUT_WIDTH-1:0] pdin_wire_1 = pdin_wire[1];

  reg [NUMVBNK-1:0] t1_readB;
  reg [NUMVBNK*BITVROW-1:0] t1_addrB;
  reg t1_read_tmp;
  integer t1rw_int, t1rb_int, t1rd_int;
  always_comb begin
    t1_readB = 0;
    t1_addrB = 0;
    t1_read_tmp = vread_wire;
    if (ENAPSDO)
      for (t1rw_int=0; t1rw_int<NUMWRPT; t1rw_int=t1rw_int+1)
        t1_read_tmp = t1_read_tmp && !(pwrite_wire[t1rw_int] && (pwrbadr_wire[t1rw_int] == vrdbadr_wire) && (pwrradr_wire[t1rw_int] == vrdradr_wire));
    if (t1_read_tmp)
      t1_readB = t1_readB | (1'b1 << vrdbadr_wire);
    for (t1rb_int=0; t1rb_int<NUMVBNK; t1rb_int=t1rb_int+1)
      for (t1rd_int=0; t1rd_int<BITVROW; t1rd_int=t1rd_int+1)
        t1_addrB[t1rb_int*BITVROW+t1rd_int] = vrdradr_wire[t1rd_int];
  end

  reg [WIDTH-1:0] pdout_wire;
  reg pfwrd_wire;
  reg pserr_wire;
  reg pderr_wire;
  reg [BITPADR-BITPBNK-1:0] ppadr_wire;
  integer pdob_int, pdod_int;
  always_comb begin
    pdout_wire = 0;
    pfwrd_wire = 0;
//    pserr_wire = 0;
//    pderr_wire = 0;
    ppadr_wire = 0;
    for (pdob_int=0; pdob_int<NUMVBNK; pdob_int=pdob_int+1)
      if (pdob_int == vrdbadr_out) begin
        for (pdod_int=0; pdod_int<WIDTH; pdod_int=pdod_int+1)
          pdout_wire[pdod_int] = t1_doutB[pdob_int*WIDTH+pdod_int];
        pfwrd_wire = t1_fwrdB[pdob_int];
//        pserr_wire = t1_serrB[pdob_int];
//        pderr_wire = t1_derrB[pdob_int];
        for (pdod_int=0; pdod_int<BITPADR-BITPBNK; pdod_int=pdod_int+1)
          ppadr_wire[pdod_int] = t1_padrB[pdob_int*(BITPADR-BITPBNK)+pdod_int];
      end
  end

  reg                    swrite_wire [0:NUMWRPT-1];
  reg [BITVROW-1:0]      swrradr_wire [0:NUMWRPT-1];
  reg [SDOUT_WIDTH-1:0]  sdin_wire [0:NUMWRPT-1];
  reg [WIDTH-1:0]        cdin_wire [0:NUMWRPT-1];

  wire swrite_wire_0 = swrite_wire[0];
  wire [BITVROW-1:0] swrradr_wire_0 = swrradr_wire[0];
  wire [SDOUT_WIDTH-1:0] sdin_wire_0 = sdin_wire[0];
  wire [WIDTH-1:0] cdin_wire_0 = cdin_wire[0];
  
  wire swrite_wire_1 = swrite_wire[1];
  wire [BITVROW-1:0] swrradr_wire_1 = swrradr_wire[1];
  wire [SDOUT_WIDTH-1:0] sdin_wire_1 = sdin_wire[1];
  wire [WIDTH-1:0] cdin_wire_1 = cdin_wire[1];

  // Read request of mapping information on SRAM memory
  reg [2*NUMWRPT-1:0] t2_readB;
  reg [2*NUMWRPT*BITVROW-1:0] t2_addrB;
  integer t2rp_int, t2rd_int;
  always_comb
    for (t2rp_int=0; t2rp_int<NUMWRPT; t2rp_int=t2rp_int+1) begin
      t2_readB[2*t2rp_int] = vread_wire;
      if (ENAPSDO)
        t2_readB[2*t2rp_int] = t2_readB[2*t2rp_int] && !(swrite_wire[t2rp_int] && (vrdradr_wire == swrradr_wire[t2rp_int]));
      for (t2rd_int=0; t2rd_int<BITVROW; t2rd_int=t2rd_int+1)
        t2_addrB[2*t2rp_int*BITVROW+t2rd_int] = vrdradr_wire[t2rd_int];
      t2_readB[2*t2rp_int+1] = vwrite_wire[t2rp_int];
      if (ENAPSDO)
        t2_readB[2*t2rp_int+1] = t2_readB[2*t2rp_int+1] && !(swrite_wire[t2rp_int] && (vwrradr_wire[t2rp_int] == swrradr_wire[t2rp_int]));
      for (t2rd_int=0; t2rd_int<BITVROW; t2rd_int=t2rd_int+1)
        t2_addrB[(2*t2rp_int+1)*BITVROW+t2rd_int] = vwrradr_wire[t2rp_int][t2rd_int];
    end

  wire [BITVBNK:0]           sdout_out [0:2*NUMWRPT-1];
  wire                       sfwrd_out [0:2*NUMWRPT-1];
  wire [BITPADR-BITPBNK-1:0] spadr_out [0:2*NUMWRPT-1];
  wire [WIDTH-1:0]           cdout_out [0:2*NUMWRPT-1];
  genvar sdo_int;
  generate
    for (sdo_int=0; sdo_int<2*NUMWRPT; sdo_int=sdo_int+1) begin: sdo_loop
      wire [SDOUT_WIDTH-1:0] sdout_wire = t2_doutB >> (sdo_int*(SDOUT_WIDTH+WIDTH)+WIDTH);
      assign cdout_out[sdo_int] = t2_doutB >> (sdo_int*(SDOUT_WIDTH+WIDTH));
      assign sfwrd_out[sdo_int] = t2_fwrdB >> sdo_int;
      assign spadr_out[sdo_int] = t2_padrB >> (sdo_int*(BITPADR-BITPBNK));

      wire sdout_bit1_err = 0;
      wire sdout_bit2_err = 0;
      wire [7:0] sdout_bit1_pos = 0;
      wire [7:0] sdout_bit2_pos = 0;
      wire [SDOUT_WIDTH-1:0] sdout_bit1_mask = sdout_bit1_err << sdout_bit1_pos;
      wire [SDOUT_WIDTH-1:0] sdout_bit2_mask = sdout_bit2_err << sdout_bit2_pos;
      wire [SDOUT_WIDTH-1:0] sdout_mask = sdout_bit1_mask ^ sdout_bit2_mask;
      wire sdout_serr = |sdout_mask && (|sdout_bit1_mask ^ |sdout_bit2_mask);
      wire sdout_derr = |sdout_mask && |sdout_bit1_mask && |sdout_bit2_mask;
      wire [SDOUT_WIDTH-1:0] sdout_int = sdout_wire ^ sdout_mask;

      wire [BITVBNK:0]   sdout_data = sdout_int;
      wire [ECCBITS-1:0] sdout_ecc = sdout_int >> BITVBNK+1;
      wire [BITVBNK:0]   sdout_dup_data = sdout_int >> BITVBNK+1+ECCBITS;
      wire [BITVBNK:0]   sdout_post_ecc;
      wire               sdout_sec_err;
      wire               sdout_ded_err;

      ecc_check   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
          ecc_check_inst (.din(sdout_data), .eccin(sdout_ecc),
                          .dout(sdout_post_ecc), .sec_err(sdout_sec_err), .ded_err(sdout_ded_err),
                          .clk(clk), .rst(rst));

      assign sdout_out[sdo_int] = sdout_ded_err ? sdout_dup_data : sdout_post_ecc;
    end
  endgenerate

  reg                    wrmap_vld [0:NUMWRPT-1][0:SRAM_DELAY];
  reg [BITVBNK:0]        wrmap_reg [0:NUMWRPT-1][0:SRAM_DELAY];
  reg [WIDTH-1:0]        wrdat_reg [0:NUMWRPT-1][0:SRAM_DELAY];
  integer wfmp_int, wfmd_int;
  always @(posedge clk)
    for (wfmp_int=0; wfmp_int<NUMWRPT; wfmp_int=wfmp_int+1)
      for (wfmd_int=0; wfmd_int<SRAM_DELAY+1; wfmd_int=wfmd_int+1)
        if (wfmd_int > 0) begin
          if (swrite_wire[wfmp_int] && (swrradr_wire[wfmp_int] == vwrradr_reg[wfmp_int][wfmd_int-1])) begin
            wrmap_vld[wfmp_int][wfmd_int] <= 1'b1;
            wrmap_reg[wfmp_int][wfmd_int] <= sdin_wire[wfmp_int][BITVBNK:0];
            wrdat_reg[wfmp_int][wfmd_int] <= cdin_wire[wfmp_int];
          end else if (wrmap_vld[wfmp_int][wfmd_int-1]) begin
            wrmap_vld[wfmp_int][wfmd_int] <= wrmap_vld[wfmp_int][wfmd_int-1];
            wrmap_reg[wfmp_int][wfmd_int] <= wrmap_reg[wfmp_int][wfmd_int-1];            
            wrdat_reg[wfmp_int][wfmd_int] <= wrdat_reg[wfmp_int][wfmd_int-1];            
          end else if (wfmd_int==SRAM_DELAY) begin
            wrmap_vld[wfmp_int][wfmd_int] <= 1'b1;
            wrmap_reg[wfmp_int][wfmd_int] <= sdout_out[2*wfmp_int+1];
            wrdat_reg[wfmp_int][wfmd_int] <= cdout_out[2*wfmp_int+1];
          end else begin
            wrmap_vld[wfmp_int][wfmd_int] <= 1'b0;
            wrmap_reg[wfmp_int][wfmd_int] <= 0;
            wrdat_reg[wfmp_int][wfmd_int] <= 0;
          end
        end else begin
          if (swrite_wire[wfmp_int] && (swrradr_wire[wfmp_int] == vwrradr_wire[wfmp_int])) begin
            wrmap_vld[wfmp_int][wfmd_int] <= 1'b1;
            wrmap_reg[wfmp_int][wfmd_int] <= sdin_wire[wfmp_int][BITVBNK:0];
            wrdat_reg[wfmp_int][wfmd_int] <= cdin_wire[wfmp_int];
          end else begin
            wrmap_vld[wfmp_int][wfmd_int] <= 1'b0;
            wrmap_reg[wfmp_int][wfmd_int] <= 0;
            wrdat_reg[wfmp_int][wfmd_int] <= 0;
          end
        end

  reg               rdmap_vld [0:NUMWRPT-1][0:SRAM_DELAY-1];
  reg [BITVBNK:0]   rdmap_reg [0:NUMWRPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]   rdmap_dat [0:NUMWRPT-1][0:SRAM_DELAY-1];
  integer rfmp_int, rfmd_int;
  always @(posedge clk) begin
    for (rfmp_int=0; rfmp_int<NUMWRPT; rfmp_int=rfmp_int+1)
      for (rfmd_int=0; rfmd_int<SRAM_DELAY; rfmd_int=rfmd_int+1)
        if (rfmd_int > 0) begin
          if (swrite_wire[rfmp_int] && (swrradr_wire[rfmp_int] == vrdradr_reg[rfmd_int-1])) begin
            rdmap_vld[rfmp_int][rfmd_int] <= 1'b1;
            rdmap_reg[rfmp_int][rfmd_int] <= sdin_wire[rfmp_int][BITVBNK:0];
            rdmap_dat[rfmp_int][rfmd_int] <= cdin_wire[rfmp_int];
          end else begin
            rdmap_vld[rfmp_int][rfmd_int] <= rdmap_vld[rfmp_int][rfmd_int-1];
            rdmap_reg[rfmp_int][rfmd_int] <= rdmap_reg[rfmp_int][rfmd_int-1];            
            rdmap_dat[rfmp_int][rfmd_int] <= rdmap_dat[rfmp_int][rfmd_int-1];            
          end
        end else begin
          rdmap_vld[rfmp_int][rfmd_int] <= swrite_wire[rfmp_int] && (swrradr_wire[rfmp_int] == vrdradr_wire);
          rdmap_reg[rfmp_int][rfmd_int] <= sdin_wire[rfmp_int][BITVBNK:0];
          rdmap_dat[rfmp_int][rfmd_int] <= cdin_wire[rfmp_int];
        end
  end

  reg              pdat_vld [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]  pdat_reg [0:SRAM_DELAY-1];
  integer pfwp_int, pfwd_int;
  always @(posedge clk) 
    for (pfwd_int=0; pfwd_int<SRAM_DELAY; pfwd_int=pfwd_int+1)
      if (pfwd_int > 0) begin
        pdat_vld[pfwd_int] <= pdat_vld[pfwd_int-1];
        pdat_reg[pfwd_int] <= pdat_reg[pfwd_int-1];
        for (pfwp_int=0; pfwp_int<NUMWRPT; pfwp_int=pfwp_int+1)
          if (pwrite_wire[pfwp_int] && (pwrbadr_wire[pfwp_int] == vrdbadr_reg[pfwd_int-1]) && (pwrradr_wire[pfwp_int] == vrdradr_reg[pfwd_int-1])) begin
            pdat_vld[pfwd_int] <= 1'b1;
            pdat_reg[pfwd_int] <= pdin_wire[pfwp_int];
          end
      end else begin
        pdat_vld[pfwd_int] <= 1'b0;
        pdat_reg[pfwd_int] <= 0;
        for (pfwp_int=0; pfwp_int<NUMWRPT; pfwp_int=pfwp_int+1)
          if (pwrite_wire[pfwp_int] && (pwrbadr_wire[pfwp_int] == vrdbadr_wire) && (pwrradr_wire[pfwp_int] == vrdradr_wire)) begin
            pdat_vld[pfwd_int] <= 1'b1;
            pdat_reg[pfwd_int] <= pdin_wire[pfwp_int];
          end
      end

  reg             rddat_vld [0:SRAM_DELAY-1];
  reg [WIDTH-1:0] rddat_reg [0:SRAM_DELAY-1];
  integer rfwp_int, rfwd_int;
  always @(posedge clk)
    for (rfwd_int=0; rfwd_int<SRAM_DELAY; rfwd_int=rfwd_int+1)
      if (rfwd_int > 0) begin
        rddat_vld[rfwd_int] <= rddat_vld[rfwd_int-1];
        rddat_reg[rfwd_int] <= rddat_reg[rfwd_int-1];
        for (rfwp_int=0; rfwp_int<NUMWRPT; rfwp_int=rfwp_int+1)
          if (vwrite_reg[rfwp_int][SRAM_DELAY-1] && vread_reg[rfwd_int-1] &&
              (vwrbadr_reg[rfwp_int][SRAM_DELAY-1] == vrdbadr_reg[rfwd_int-1]) && (vwrradr_reg[rfwp_int][SRAM_DELAY-1] == vrdradr_reg[rfwd_int-1])) begin
            rddat_vld[rfwd_int] <= 1'b1;
            rddat_reg[rfwd_int] <= vdin_reg[rfwp_int][SRAM_DELAY-1];
          end
      end else begin
        rddat_vld[rfwd_int] <= 1'b0;
        rddat_reg[rfwd_int] <= 0;
        for (rfwp_int=0; rfwp_int<NUMWRPT; rfwp_int=rfwp_int+1)
          if (vwrite_reg[rfwp_int][SRAM_DELAY-1] && vread_wire &&
              (vwrbadr_reg[rfwp_int][SRAM_DELAY-1] == vrdbadr_wire) && (vwrradr_reg[rfwp_int][SRAM_DELAY-1] == vrdradr_wire)) begin
            rddat_vld[rfwd_int] <= 1'b1;
            rddat_reg[rfwd_int] <= vdin_reg[rfwp_int][SRAM_DELAY-1];
          end
      end

  reg [BITVBNK:0] rdmap_out [0:NUMWRPT-1];
  reg [WIDTH-1:0] rddat_out [0:NUMWRPT-1];
  integer rmap_int;
  always_comb
    for (rmap_int=0; rmap_int<NUMWRPT; rmap_int=rmap_int+1) begin
      rdmap_out[rmap_int] = rdmap_vld[rmap_int][SRAM_DELAY-1] ? rdmap_reg[rmap_int][SRAM_DELAY-1] : sdout_out[2*rmap_int];
      rddat_out[rmap_int] = rdmap_vld[rmap_int][SRAM_DELAY-1] ? rdmap_dat[rmap_int][SRAM_DELAY-1] : cdout_out[2*rmap_int];
    end

  wire [WIDTH-1:0] pdat_out = pdat_vld[SRAM_DELAY-1] ? pdat_reg[SRAM_DELAY-1] : pdout_wire;

  reg               vread_vld_tmp;
  reg               vread_serr_tmp;
  reg               vread_derr_tmp;
  reg [WIDTH-1:0]   vdout_int;
  reg [WIDTH-1:0]   vdout_tmp;
  reg               vread_fwrd_tmp;
  reg [BITPADR-1:0] vread_padr_tmp;
  integer vdo_int;
  always_comb begin
    vread_vld_tmp = vread_out;
    vread_serr_tmp = 1'b0;
    vread_derr_tmp = 1'b0;
    vread_fwrd_tmp = pdat_vld[SRAM_DELAY-1] || pfwrd_wire;
    vread_padr_tmp = {vrdbadr_out,ppadr_wire};
    vdout_int = pdat_out; 
    for (vdo_int=0; vdo_int<NUMWRPT; vdo_int=vdo_int+1)
      if (rdmap_out[vdo_int][BITVBNK] && (rdmap_out[vdo_int][BITVBNK-1:0] == vrdbadr_out)) begin
        vdout_int = rddat_out[vdo_int];
        vread_fwrd_tmp = rdmap_vld[vdo_int][SRAM_DELAY-1] || sfwrd_out[2*vdo_int];
        vread_padr_tmp = ((NUMVBNK+vdo_int) << (BITPADR-BITPBNK)) | spadr_out[2*vdo_int];
      end
    vdout_tmp = rddat_vld[SRAM_DELAY-1] ? rddat_reg[SRAM_DELAY-1] : vdout_int;
    vread_fwrd_tmp = vread_fwrd_tmp || rddat_vld[SRAM_DELAY-1];
  end 

  reg               vread_vld;
  reg [WIDTH-1:0]   vdout;
  reg               vread_fwrd;
  reg               vread_serr;
  reg               vread_derr;
  reg [BITPADR-1:0] vread_padr;

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

  wire [BITVBNK:0] wrmap_out [0:NUMWRPT-1];
  wire [WIDTH-1:0] wrdat_out [0:NUMWRPT-1];
  wire             new_to_pivot [0:NUMWRPT-1];
  genvar wr_var;
  generate for (wr_var=0; wr_var<NUMWRPT; wr_var=wr_var+1) begin: snew_loop
    assign wrmap_out[wr_var] = wrmap_reg[wr_var][SRAM_DELAY];
    assign wrdat_out[wr_var] = wrdat_reg[wr_var][SRAM_DELAY];

    wire               sold_vld = vwrite_out[wr_var] && wrmap_out[wr_var][BITVBNK];
    wire [BITVBNK-1:0] sold_map = wrmap_out[wr_var][BITVBNK-1:0];
    wire [BITVROW-1:0] sold_row = vwrradr_out[wr_var];
    wire [WIDTH-1:0]   sold_dat = wrdat_out[wr_var];
    wire               snew_vld = vwrite_out[wr_var];
    wire [BITVBNK-1:0] snew_map = vwrbadr_out[wr_var];
    wire [BITVROW-1:0] snew_row = vwrradr_out[wr_var];
    wire [WIDTH-1:0]   snew_dat = vdin_out[wr_var];

    wire new_to_cache = snew_vld && (vread_wire && (vrdbadr_wire == snew_map));
    assign new_to_pivot[wr_var] = snew_vld && !new_to_cache;

    wire old_to_pivot = sold_vld && new_to_cache && (sold_map != snew_map);
    wire old_to_clear = sold_vld && new_to_pivot[wr_var] && (sold_map == snew_map);

    reg kill_old_to_pivot;
    integer kill_int;
    always_comb begin
      kill_old_to_pivot = 0;
      for (kill_int=0; kill_int<NUMWRPT; kill_int=kill_int+1)
        kill_old_to_pivot = kill_old_to_pivot || (new_to_pivot[kill_int] && (vwrbadr_out[kill_int] == sold_map));
    end

    always_comb
      if (new_to_pivot[wr_var]) begin
        pwrite_wire[wr_var] = 1'b1;
        pwrbadr_wire[wr_var] = snew_map;
        pwrradr_wire[wr_var] = snew_row;
        pdin_wire[wr_var] = snew_dat;
      end else if (old_to_pivot && !kill_old_to_pivot) begin
        pwrite_wire[wr_var] = 1'b1;
        pwrbadr_wire[wr_var] = sold_map;
        pwrradr_wire[wr_var] = sold_row;
        pdin_wire[wr_var] = sold_dat;
      end else begin
        pwrite_wire[wr_var] = 1'b0;
        pwrbadr_wire[wr_var] = 0;
        pwrradr_wire[wr_var] = 0;
        pdin_wire[wr_var] = 0;
      end

    reg [BITVBNK:0] sdin_pre_ecc;
    always_comb
      if (rstvld) begin
        swrite_wire[wr_var] = !rst;
        swrradr_wire[wr_var] = rstaddr;
        sdin_pre_ecc = 0;
        cdin_wire[wr_var] = 0;
      end else if (new_to_cache) begin
        swrite_wire[wr_var] = 1'b1;
        swrradr_wire[wr_var] = snew_row;
        sdin_pre_ecc = {1'b1,snew_map};
        cdin_wire[wr_var] = snew_dat;
      end else if (old_to_clear) begin
        swrite_wire[wr_var] = 1'b1;
        swrradr_wire[wr_var] = sold_row;
        sdin_pre_ecc = 0;
        cdin_wire[wr_var] = 0;
      end else begin
        swrite_wire[wr_var] = 1'b0;
        swrradr_wire[wr_var] = 0; 
        sdin_pre_ecc = 0;
        cdin_wire[wr_var] = 0;
      end

    wire [ECCBITS-1:0] sdin_ecc;
    ecc_calc   #(.ECCDWIDTH(BITVBNK+1), .ECCWIDTH(ECCBITS))
        ecc_calc_inst (.din(sdin_pre_ecc), .eccout(sdin_ecc));

    assign sdin_wire[wr_var] = {sdin_pre_ecc, sdin_ecc, sdin_pre_ecc};
  end
endgenerate

  reg [NUMVBNK-1:0] t1_writeA;
  reg [NUMVBNK*BITVROW-1:0] t1_addrA;
  reg [NUMVBNK*WIDTH-1:0] t1_dinA;
  integer t1w_int, t1b_int, t1d_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (t1w_int=0; t1w_int<NUMWRPT; t1w_int=t1w_int+1)
      for (t1b_int=0; t1b_int<NUMVBNK; t1b_int=t1b_int+1)
        if (pwrite_wire[t1w_int] && (t1b_int == pwrbadr_wire[t1w_int])) begin
          t1_writeA[t1b_int] = 1'b1;
          for (t1d_int=0; t1d_int<BITVROW; t1d_int=t1d_int+1)
            t1_addrA[t1b_int*BITVROW+t1d_int] = pwrradr_wire[t1w_int][t1d_int];
          for (t1d_int=0; t1d_int<WIDTH; t1d_int=t1d_int+1)
            t1_dinA[t1b_int*WIDTH+t1d_int] = pdin_wire[t1w_int][t1d_int];
        end
  end

  reg [2*NUMWRPT-1:0] t2_writeA;
  reg [2*NUMWRPT*BITVROW-1:0] t2_addrA;
  reg [2*NUMWRPT*(SDOUT_WIDTH+WIDTH)-1:0] t2_dinA;
  integer t2w_int, t2d_int;
  always_comb
    for (t2w_int=0; t2w_int<NUMWRPT; t2w_int=t2w_int+1) begin
      t2_writeA[2*t2w_int] = swrite_wire[t2w_int];
      t2_writeA[2*t2w_int+1] = swrite_wire[t2w_int];
      for (t2d_int=0; t2d_int<BITVROW; t2d_int=t2d_int+1) begin
        t2_addrA[2*t2w_int*BITVROW+t2d_int] = swrradr_wire[t2w_int][t2d_int];
        t2_addrA[(2*t2w_int+1)*BITVROW+t2d_int] = swrradr_wire[t2w_int][t2d_int];
      end
      for (t2d_int=0; t2d_int<SDOUT_WIDTH; t2d_int=t2d_int+1) begin
        t2_dinA[2*t2w_int*(SDOUT_WIDTH+WIDTH)+WIDTH+t2d_int] = sdin_wire[t2w_int][t2d_int];
        t2_dinA[(2*t2w_int+1)*(SDOUT_WIDTH+WIDTH)+WIDTH+t2d_int] = sdin_wire[t2w_int][t2d_int];
      end
      for (t2d_int=0; t2d_int<WIDTH; t2d_int=t2d_int+1) begin
        t2_dinA[2*t2w_int*(SDOUT_WIDTH+WIDTH)+t2d_int] = cdin_wire[t2w_int][t2d_int];
        t2_dinA[(2*t2w_int+1)*(SDOUT_WIDTH+WIDTH)+t2d_int] = cdin_wire[t2w_int][t2d_int];
      end
   end
   
endmodule


