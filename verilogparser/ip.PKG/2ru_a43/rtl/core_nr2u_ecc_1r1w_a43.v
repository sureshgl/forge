module core_nr2u_ecc_1r1w_a43 (vwrite, vdin,
                       vread, vaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                       t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                       t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB,
                       t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB, t3_fwrdB, t3_serrB, t3_derrB, t3_padrB,
                       ready, clk, rst);

  parameter BITWDTH = 5;
  parameter ENAPSDO = 0;
  parameter WIDTH = 32;
  parameter ECCWDTH = 7;
  parameter NUMRUPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 14;
  parameter SRAM_DELAY = 2;
  parameter UPD_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ENADEC = 0;
  parameter ENAHEC = 0;
  parameter ENAQEC = 0;
  parameter FLOPECC1 = 0;
  parameter FLOPECC2 = 0;

  localparam COREECC = ENAPAR + ENAECC + ENADEC + ENAHEC + ENAQEC;
  localparam PHYWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENADEC ? 2*WIDTH+ECCWDTH : ENAHEC ? WIDTH+2*ECCWDTH : ENAQEC ? WIDTH+4*ECCWDTH : WIDTH;

  input [2-1:0]                      vwrite;
  input [2*WIDTH-1:0]                vdin;

  input [NUMRUPT-1:0]                vread;
  input [NUMRUPT*BITADDR-1:0]        vaddr;
  output [NUMRUPT-1:0]               vread_vld;
  output [NUMRUPT*WIDTH-1:0]         vdout;
  output [NUMRUPT-1:0]               vread_fwrd;
  output [NUMRUPT-1:0]               vread_serr;
  output [NUMRUPT-1:0]               vread_derr;
  output [NUMRUPT*BITPADR-1:0]       vread_padr;

  output [NUMRUPT*NUMVBNK-1:0] t1_writeA;
  output [NUMRUPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMRUPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
  
  output [NUMRUPT*NUMVBNK-1:0] t1_readB;
  output [NUMRUPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMRUPT*NUMVBNK*PHYWDTH-1:0] t1_doutB;
  input [NUMRUPT*NUMVBNK-1:0] t1_fwrdB;
  input [NUMRUPT*NUMVBNK-1:0] t1_serrB;
  input [NUMRUPT*NUMVBNK-1:0] t1_derrB;
  input [NUMRUPT*NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB;
  
  output [(NUMRUPT)-1:0] t2_writeA;
  output [(NUMRUPT)*BITVROW-1:0] t2_addrA;
  output [(NUMRUPT)*PHYWDTH-1:0] t2_dinA;
  
  output [(NUMRUPT)-1:0] t2_readB;
  output [(NUMRUPT)*BITVROW-1:0] t2_addrB;
  input [(NUMRUPT)*PHYWDTH-1:0] t2_doutB;
  input [(NUMRUPT)-1:0] t2_fwrdB;
  input [(NUMRUPT)-1:0] t2_serrB;
  input [(NUMRUPT)-1:0] t2_derrB;
  input [(NUMRUPT)*(BITPADR-BITPBNK)-1:0] t2_padrB;
  
  output [(NUMRUPT)-1:0] t3_writeA;
  output [(NUMRUPT)*BITVROW-1:0] t3_addrA;
  output [(NUMRUPT)*(BITVBNK+1)-1:0] t3_dinA;
  
  output [(NUMRUPT)-1:0] t3_readB;
  output [(NUMRUPT)*BITVROW-1:0] t3_addrB;
  input [(NUMRUPT)*(BITVBNK+1)-1:0] t3_doutB;
  input [(NUMRUPT)-1:0] t3_fwrdB;
  input [(NUMRUPT)-1:0] t3_serrB;
  input [(NUMRUPT)-1:0] t3_derrB;
  input [(NUMRUPT)*(BITPADR-BITPBNK)-1:0] t3_padrB;

  output                             ready;
  input                              clk;
  input                              rst;

  reg [2:0] rst_reg;
  always @(posedge clk)
    rst_reg <= {rst_reg[1:0],rst};

  wire rst_sync = rst_reg[2];

  reg [BITVROW:0] rstaddr;
  wire rstvld = (rstaddr < NUMVROW);
  always @(posedge clk)
    if (rst_sync)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg ready;
  always @(posedge clk)
    ready <= !rst_sync && !rstvld;

  wire ready_wire;

  wire vread_wire [0:NUMRUPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMRUPT-1];
  wire [BITVBNK-1:0] vrdbadr_wire [0:NUMRUPT-1];
  wire [BITVROW-1:0] vrdradr_wire [0:NUMRUPT-1];

  wire vwrite_wire [0:2-1];
  wire [WIDTH-1:0] vdin_wire [0:2-1];
  wire [PHYWDTH-1:0] vdin_ecc_wire [0:2-1];

  reg                vread_reg [0:NUMRUPT-1][0:SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT+SRAM_DELAY+1+FLOPECC1+FLOPECC2];
  reg [BITADDR-1:0]  vrdadr_reg [0:NUMRUPT-1][0:SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT+SRAM_DELAY+1+FLOPECC1+FLOPECC2];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:NUMRUPT-1][0:SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT+SRAM_DELAY+1+FLOPECC1+FLOPECC2];
  reg [BITVROW-1:0]  vrdradr_reg [0:NUMRUPT-1][0:SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT+SRAM_DELAY+1+FLOPECC1+FLOPECC2];
  reg                vwrite_reg [0:1][0:SRAM_DELAY];
  reg [PHYWDTH-1:0]    vdin_reg [0:1][0:SRAM_DELAY];
  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMRUPT-1:0] vread_reg;
    reg [NUMRUPT*BITADDR-1:0] vaddr_reg;
    reg [2-1:0] vwrite_reg;
    reg [2*WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread & {2{ready}};
      vaddr_reg <= vaddr;
      vwrite_reg <= vwrite & {2{ready}};
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    for (np2_var=0; np2_var<NUMRUPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
      assign vrdaddr_wire[np2_var] = vaddr_reg >> (np2_var*BITADDR);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end
    for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = (vwrite_reg >> np2_var);
      assign vdin_wire[np2_var] = vdin_reg >> (np2_var*WIDTH);
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (np2_var=0; np2_var<NUMRUPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = (vread & {NUMRUPT{ready}}) >> np2_var;
      assign vrdaddr_wire[np2_var] = vaddr >> (np2_var*BITADDR);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end
    for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = ((vwrite & {2{ready}}) >> np2_var);
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);
    end
  end
  endgenerate

  wire [WIDTH-1:0] vdout_wire [0:NUMRUPT-1];
  wire rd_serr_wire [0:NUMRUPT-1];
  wire rd_derr_wire [0:NUMRUPT-1];
  wire vread_serr_wire [0:NUMRUPT-1];
  wire vread_derr_wire [0:NUMRUPT-1];
  wire vread_vld_wire [0:NUMRUPT-1];
  wire vread_fwrd_wire [0:NUMRUPT-1];
  wire [BITPADR-1:0] vread_padr_wire [0:NUMRUPT-1];

  wire [PHYWDTH-1:0] vdout_ecc_wire [0:NUMRUPT-1];
  wire vread_vld_ecc_wire [0:NUMRUPT-1];
  wire vread_fwrd_ecc_wire [0:NUMRUPT-1];
  wire [BITPADR-1:0] vread_padr_ecc_wire [0:NUMRUPT-1];

  genvar din_var, dout_var;
  generate begin: ecc_loop
    for(din_var=0; din_var<2; din_var=din_var+1) begin: din_loop
      core_ecc_calc #(.WIDTH(WIDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ENADEC(ENADEC), .ENAHEC(ENAHEC), .ENAQEC(ENAQEC), .ECCWDTH(ECCWDTH)) 
        din_ecc_inst (.din(vdin_wire[din_var]), .mem_din(vdin_ecc_wire[din_var]), .clk(clk), .rst(rst));
    end
    for(dout_var=0; dout_var<NUMRUPT; dout_var=dout_var+1) begin: dout_loop
      core_ecc_check #(.WIDTH(WIDTH), .ENAPAR(ENAPAR), .ENAECC(ENAECC), .ENADEC(ENADEC), .ENAHEC(ENAHEC),
                       .ENAQEC(ENAQEC), .ECCWDTH(ECCWDTH), .FLOPECC1(FLOPECC1), .FLOPECC2(FLOPECC2), .BITPADR(BITPADR)) 
        dout_ecc_inst (.rd_dout(vdout_wire[dout_var]),
                       .rd_vld(vread_vld_wire[dout_var]),
                       .rd_serr(rd_serr_wire[dout_var]),
                       .rd_derr(rd_derr_wire[dout_var]),
                       .rd_fwrd(vread_fwrd_wire[dout_var]),
                       .rd_padr(vread_padr_wire[dout_var]),
                       .mem_rd_dout(vdout_ecc_wire[dout_var]),
                       .mem_rd_vld(vread_vld_ecc_wire[dout_var]),
                       .mem_rd_fwrd(vread_fwrd_ecc_wire[dout_var]),
                       .mem_rd_padr(vread_padr_ecc_wire[dout_var]),
                       .clk(clk),
                       .rst(rst));
    end
  end
  endgenerate


  reg               vread_out[0:NUMRUPT-1];
  reg [BITADDR-1:0] vrdaddr_out[0:NUMRUPT-1];
  reg [BITVBNK-1:0] vrdbadr_out[0:NUMRUPT-1];
  reg [BITVROW-1:0] vrdradr_out[0:NUMRUPT-1];


  integer vdel_int, vprt_int;
  always @(posedge clk)  begin
    for (vdel_int=SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT+SRAM_DELAY+1+FLOPECC1+FLOPECC2; vdel_int>=0; vdel_int=vdel_int-1)
      if (vdel_int>0) begin
        for (vprt_int=0; vprt_int<NUMRUPT; vprt_int=vprt_int+1) begin
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
          vrdadr_reg[vprt_int][vdel_int] <= (vread_reg[vprt_int][vdel_int-1]) ? vrdadr_reg[vprt_int][vdel_int-1] : vrdadr_reg[vprt_int][vdel_int];
          vrdbadr_reg[vprt_int][vdel_int] <= (vread_reg[vprt_int][vdel_int-1]) ? vrdbadr_reg[vprt_int][vdel_int-1] : vrdbadr_reg[vprt_int][vdel_int];
          vrdradr_reg[vprt_int][vdel_int] <= (vread_reg[vprt_int][vdel_int-1]) ? vrdradr_reg[vprt_int][vdel_int-1] : vrdradr_reg[vprt_int][vdel_int];
        end
      end else begin
        for (vprt_int=0; vprt_int<NUMRUPT; vprt_int=vprt_int+1) begin
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
          vrdadr_reg[vprt_int][vdel_int] <= (vread_wire[vprt_int]) ? vrdaddr_wire[vprt_int] : vrdadr_reg[vprt_int][vdel_int];
          vrdbadr_reg[vprt_int][vdel_int] <= (vread_wire[vprt_int]) ? vrdbadr_wire[vprt_int] : vrdbadr_reg[vprt_int][vdel_int];
          vrdradr_reg[vprt_int][vdel_int] <= (vread_wire[vprt_int]) ? vrdradr_wire[vprt_int] : vrdradr_reg[vprt_int][vdel_int];
        end
      end
    for (vdel_int=SRAM_DELAY; vdel_int>=0; vdel_int=vdel_int-1)
      if (vdel_int>0) begin
        for (vprt_int=0; vprt_int<2; vprt_int=vprt_int+1) begin
          vwrite_reg[vprt_int][vdel_int] <= vwrite_reg[vprt_int][vdel_int-1];
          vdin_reg[vprt_int][vdel_int] <= (vwrite_reg[vprt_int][vdel_int-1]) ? vdin_reg[vprt_int][vdel_int-1] : vdin_reg[vprt_int][vdel_int];
        end
      end else begin
        for (vprt_int=0; vprt_int<2; vprt_int=vprt_int+1) begin
          if (vprt_int>0)
            vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int] && vread_reg[vprt_int][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+FLOPECC1+FLOPECC2-1] && ready;
          else
            vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int] && vread_reg[vprt_int][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+FLOPECC1+FLOPECC2-1] && ready &&
                                              !(vwrite_wire[1] && vread_reg[1][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+FLOPECC1+FLOPECC2-1] && (vrdbadr_reg[1][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+FLOPECC1+FLOPECC2-1] == vrdbadr_reg[vprt_int][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+FLOPECC1+FLOPECC2-1]) && (vrdradr_reg[1][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+FLOPECC1+FLOPECC2-1] == vrdradr_reg[vprt_int][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+FLOPECC1+FLOPECC2-1]));
          vdin_reg[vprt_int][vdel_int] <= (vwrite_wire[vprt_int] && ready) ? vdin_ecc_wire[vprt_int] : vdin_reg[vprt_int][vdel_int];
        end
      end
  end

  integer vout_int;
  always_comb
    for (vout_int=0; vout_int<NUMRUPT; vout_int=vout_int+1) begin
      vread_out[vout_int] = vread_reg[vout_int][SRAM_DELAY-1];
      vrdbadr_out[vout_int] = vrdbadr_reg[vout_int][SRAM_DELAY-1];
      vrdradr_out[vout_int] = vrdradr_reg[vout_int][SRAM_DELAY-1];
    end

  wire               vwritea_out = vwrite_reg[0][SRAM_DELAY];
  wire [BITVBNK-1:0] vwrbadra_out = vrdbadr_reg[0][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2];
  wire [BITVROW-1:0] vwrradra_out = vrdradr_reg[0][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2];
  wire [PHYWDTH-1:0]   vdina_out = vdin_reg[0][SRAM_DELAY];       

  wire               vwriteb_out = vwrite_reg[1][SRAM_DELAY];
  wire [BITVBNK-1:0] vwrbadrb_out = vrdbadr_reg[1][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2];
  wire [BITVROW-1:0] vwrradrb_out = vrdradr_reg[1][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2];
  wire [PHYWDTH-1:0]   vdinb_out = vdin_reg[1][SRAM_DELAY];       

  // Read request of pivoted data on DRAM memory
  reg               pwritea;
  reg [BITVBNK-1:0] pwrbadra;
  reg [BITVROW-1:0] pwrradra;
  reg [PHYWDTH-1:0]   pdina;
  reg               pwriteb;
  reg [BITVBNK-1:0] pwrbadrb;
  reg [BITVROW-1:0] pwrradrb;
  reg [PHYWDTH-1:0]   pdinb;

  reg               cwrite;
  reg [BITVROW-1:0] cwrradr;
  reg [PHYWDTH-1:0]   cdin;

  reg                   swrite;
  reg [BITVROW-1:0]     swrradr;
  reg [(BITVBNK+1)-1:0] sdin;

  reg [NUMRUPT*NUMVBNK-1:0] t1_readB;
  reg [NUMRUPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  reg [NUMRUPT*NUMVBNK-1:0] t1_read_tmp;
  integer t1rp_int, t1rb_int, t1rd_int;
  always_comb begin
    t1_readB = 0;
    t1_addrB = 0;
    for (t1rp_int=0; t1rp_int<NUMRUPT; t1rp_int=t1rp_int+1) begin
      t1_read_tmp[t1rp_int] = vread_wire[t1rp_int] && (vrdbadr_wire[t1rp_int] < NUMVBNK);
      if (ENAPSDO)
        t1_read_tmp[t1rp_int] = t1_read_tmp[t1rp_int] &&
                                !(pwritea && (pwrbadra == vrdbadr_wire[t1rp_int]) && (pwrradra == vrdradr_wire[t1rp_int])) &&
                                !(pwriteb && (pwrbadrb == vrdbadr_wire[t1rp_int]) && (pwrradrb == vrdradr_wire[t1rp_int]));
      if (t1_read_tmp[t1rp_int])
        t1_readB = t1_readB | (1'b1 << (t1rp_int*NUMVBNK+vrdbadr_wire[t1rp_int]));
      for (t1rb_int=0; t1rb_int<NUMVBNK; t1rb_int=t1rb_int+1)
        t1_addrB = t1_addrB | (vrdradr_wire[t1rp_int] << ((t1rp_int*NUMVBNK+t1rb_int)*BITVROW));
    end
  end

  reg [BITVBNK-1:0] prdbadr_reg [0:NUMRUPT-1][0:SRAM_DELAY-1];
  integer prdd_int, prdp_int;
  always @(posedge clk)
    for (prdd_int=0; prdd_int<SRAM_DELAY; prdd_int=prdd_int+1)
      for (prdp_int=0; prdp_int<NUMRUPT; prdp_int=prdp_int+1)
        if (prdd_int>0)
          prdbadr_reg[prdp_int][prdd_int] <= prdbadr_reg[prdp_int][prdd_int-1];
        else
          prdbadr_reg[prdp_int][prdd_int] <= vrdbadr_wire[prdp_int];

  reg [PHYWDTH-1:0] pdout_wire [0:NUMRUPT-1];
  reg pfwrd_wire [0:NUMRUPT-1];
  reg pserr_wire [0:NUMRUPT-1];
  reg pderr_wire [0:NUMRUPT-1];
  reg [BITPADR-BITPBNK-1:0] ppadr_wire [0:NUMRUPT-1];
  integer pdo_int, pdob_int, pdod_int;
  always_comb
    for (pdo_int=0; pdo_int<NUMRUPT; pdo_int=pdo_int+1) begin
      pdout_wire[pdo_int] = 0;
      pfwrd_wire[pdo_int] = 0;
      pserr_wire[pdo_int] = 0;
      pderr_wire[pdo_int] = 0;
      ppadr_wire[pdo_int] = 0;
      for (pdob_int=0; pdob_int<NUMVBNK; pdob_int=pdob_int+1)
        if (pdob_int == vrdbadr_out[pdo_int]) begin
          pdout_wire[pdo_int] = t1_doutB >> ((NUMVBNK*pdo_int+pdob_int)*PHYWDTH);
          pfwrd_wire[pdo_int] = t1_fwrdB[NUMVBNK*pdo_int+pdob_int];
          pserr_wire[pdo_int] = t1_serrB[NUMVBNK*pdo_int+pdob_int];
          pderr_wire[pdo_int] = t1_derrB[NUMVBNK*pdo_int+pdob_int];
          ppadr_wire[pdo_int] = t1_padrB >> ((NUMVBNK*pdo_int+pdob_int)*(BITPADR-BITPBNK));
        end
    end

  // Read request of mapping information on SRAM memory
  reg [(NUMRUPT)-1:0] t2_readB;
  reg [(NUMRUPT)*BITVROW-1:0] t2_addrB;
  integer t2rp_int, t2rd_int;
  always_comb begin
    t2_readB = 0;
    t2_addrB = 0;
    for (t2rp_int=0; t2rp_int<NUMRUPT; t2rp_int=t2rp_int+1) begin
      t2_readB[t2rp_int] = vread_wire[t2rp_int];
      if (ENAPSDO)
        t2_readB[t2rp_int] = t2_readB[t2rp_int] && !(cwrite && (vrdradr_wire[t2rp_int] == cwrradr));
      t2_addrB = t2_addrB | (vrdradr_wire[t2rp_int] << (t2rp_int*BITVROW));
    end
  end

  reg [PHYWDTH-1:0] cdout_wire [0:(NUMRUPT)-1];
  reg cfwrd_wire [0:(NUMRUPT)-1];
  reg cserr_wire [0:(NUMRUPT)-1];
  reg cderr_wire [0:(NUMRUPT)-1];
  reg [BITPADR-BITPBNK-1:0] cpadr_wire [0:(NUMRUPT)-1];
  integer cdo_int, cdod_int;
  always_comb
    for (cdo_int=0; cdo_int<NUMRUPT; cdo_int=cdo_int+1) begin
      cdout_wire[cdo_int] = t2_doutB >> (cdo_int*PHYWDTH);
      cfwrd_wire[cdo_int] = t2_fwrdB[cdo_int];
      cserr_wire[cdo_int] = t2_serrB[cdo_int];
      cderr_wire[cdo_int] = t2_derrB[cdo_int];
      cpadr_wire[cdo_int] = t2_padrB >> (cdo_int*(BITPADR-BITPBNK));
    end

  reg [(NUMRUPT)-1:0] t3_readB;
  reg [(NUMRUPT)*BITVROW-1:0] t3_addrB;
  integer t3rp_int, t3rd_int;
  always_comb begin
    t3_readB = 0;
    t3_addrB = 0;
    for (t3rp_int=0; t3rp_int<NUMRUPT; t3rp_int=t3rp_int+1) begin
      t3_readB[t3rp_int] = vread_wire[t3rp_int];
      if (ENAPSDO)
        t3_readB[t3rp_int] = t3_readB[t3rp_int] && !(swrite && (vrdradr_wire[t3rp_int] == swrradr));
      t3_addrB = t3_addrB | (vrdradr_wire[t3rp_int] << (t3rp_int*BITVROW));
    end
  end

  reg [(BITVBNK+1)-1:0] sdout_wire [0:NUMRUPT-1];
  reg sfwrd_wire [0:(NUMRUPT)-1];
  reg sserr_wire [0:(NUMRUPT)-1];
  reg sderr_wire [0:(NUMRUPT)-1];
  reg [BITPADR-BITPBNK-1:0] spadr_wire [0:(NUMRUPT)-1];
  integer sdo_int, sdod_int;
  always_comb
    for (sdo_int=0; sdo_int<NUMRUPT; sdo_int=sdo_int+1) begin
      sdout_wire[sdo_int] = t3_doutB >> (sdo_int*(BITVBNK+1));
      sfwrd_wire[sdo_int] = t3_fwrdB[sdo_int];
      sserr_wire[sdo_int] = t3_serrB[sdo_int];
      sderr_wire[sdo_int] = t3_derrB[sdo_int];
      spadr_wire[sdo_int] = t3_padrB >> (sdo_int*(BITPADR-BITPBNK));
    end

  reg             rdmap_vld [0:NUMRUPT-1][0:SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT+SRAM_DELAY+FLOPECC1+FLOPECC2];
  reg [BITVBNK:0] rdmap_reg [0:NUMRUPT-1][0:SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT+SRAM_DELAY+FLOPECC1+FLOPECC2];
  reg             rcdat_vld [0:NUMRUPT-1][0:SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT+SRAM_DELAY+FLOPECC1+FLOPECC2];
  reg [PHYWDTH-1:0] rcdat_reg [0:NUMRUPT-1][0:SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT+SRAM_DELAY+FLOPECC1+FLOPECC2];
  integer sdfp_int, sdfd_int;
  always @(posedge clk) 
    for (sdfp_int=0; sdfp_int<NUMRUPT; sdfp_int=sdfp_int+1)
      for (sdfd_int=0; sdfd_int<SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT+SRAM_DELAY+1+FLOPECC1+FLOPECC2; sdfd_int=sdfd_int+1)
        if (sdfd_int==SRAM_DELAY) begin
          if (swrite && (swrradr == vrdradr_reg[sdfp_int][sdfd_int-1])) begin
            rdmap_vld[sdfp_int][sdfd_int] <= 1'b1;
            rdmap_reg[sdfp_int][sdfd_int] <= sdin;
          end else if (rdmap_vld[sdfp_int][sdfd_int-1]) begin
            rdmap_vld[sdfp_int][sdfd_int] <= rdmap_vld[sdfp_int][sdfd_int-1];
            rdmap_reg[sdfp_int][sdfd_int] <= rdmap_reg[sdfp_int][sdfd_int-1];
          end else begin
            rdmap_vld[sdfp_int][sdfd_int] <= 1'b1;
            rdmap_reg[sdfp_int][sdfd_int] <= sdout_wire[sdfp_int];
          end
          if (cwrite && (cwrradr == vrdradr_reg[sdfp_int][sdfd_int-1])) begin
            rcdat_vld[sdfp_int][sdfd_int] <= 1'b1;
            rcdat_reg[sdfp_int][sdfd_int] <= cdin;
          end else if (rcdat_vld[sdfp_int][sdfd_int-1]) begin
            rcdat_vld[sdfp_int][sdfd_int] <= rcdat_vld[sdfp_int][sdfd_int-1];
            rcdat_reg[sdfp_int][sdfd_int] <= rcdat_reg[sdfp_int][sdfd_int-1];
          end else begin
            rcdat_vld[sdfp_int][sdfd_int] <= 1'b1;
            rcdat_reg[sdfp_int][sdfd_int] <= cdout_wire[sdfp_int];
          end
        end else if (sdfd_int>0) begin
          if (swrite && (swrradr == vrdradr_reg[sdfp_int][sdfd_int-1])) begin
            rdmap_vld[sdfp_int][sdfd_int] <= 1'b1;
            rdmap_reg[sdfp_int][sdfd_int] <= sdin;
          end else begin
            rdmap_vld[sdfp_int][sdfd_int] <= rdmap_vld[sdfp_int][sdfd_int-1];
            rdmap_reg[sdfp_int][sdfd_int] <= rdmap_reg[sdfp_int][sdfd_int-1];
          end
          if (cwrite && (cwrradr == vrdradr_reg[sdfp_int][sdfd_int-1])) begin
            rcdat_vld[sdfp_int][sdfd_int] <= 1'b1;
            rcdat_reg[sdfp_int][sdfd_int] <= cdin;
          end else begin
            rcdat_vld[sdfp_int][sdfd_int] <= rcdat_vld[sdfp_int][sdfd_int-1];
            rcdat_reg[sdfp_int][sdfd_int] <= rcdat_reg[sdfp_int][sdfd_int-1];
          end
        end else begin
          if (swrite && (swrradr == vrdradr_wire[sdfp_int])) begin
            rdmap_vld[sdfp_int][sdfd_int] <= 1'b1;
            rdmap_reg[sdfp_int][sdfd_int] <= sdin;
          end else begin
            rdmap_vld[sdfp_int][sdfd_int] <= 1'b0;
            rdmap_reg[sdfp_int][sdfd_int] <= 0;
          end
          if (cwrite && (cwrradr == vrdradr_wire[sdfp_int])) begin
            rcdat_vld[sdfp_int][sdfd_int] <= 1'b1;
            rcdat_reg[sdfp_int][sdfd_int] <= cdin;
          end else begin
            rcdat_vld[sdfp_int][sdfd_int] <= 1'b0;
            rcdat_reg[sdfp_int][sdfd_int] <= 0;
          end
        end

  reg             rddat_vld [0:NUMRUPT-1][0:SRAM_DELAY-1];
  reg [PHYWDTH-1:0] rddat_reg [0:NUMRUPT-1][0:SRAM_DELAY-1];
  integer rdfd_int, rdfp_int;
  always @(posedge clk) 
    for (rdfd_int=SRAM_DELAY-1; rdfd_int>=0; rdfd_int=rdfd_int-1)
      for (rdfp_int=0; rdfp_int<NUMRUPT; rdfp_int=rdfp_int+1)
        if (rdfd_int>0) begin
          if (vwrite_reg[1][SRAM_DELAY-1] && vread_reg[rdfp_int][rdfd_int-1] &&
              (vrdbadr_reg[1][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2-1] == vrdbadr_reg[rdfp_int][rdfd_int-1]) &&
              (vrdradr_reg[1][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2-1] == vrdradr_reg[rdfp_int][rdfd_int-1])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[1][SRAM_DELAY-1];
          end else if (vwrite_reg[0][SRAM_DELAY-1] && vread_reg[rdfp_int][rdfd_int-1] &&
	               (vrdbadr_reg[0][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2-1] == vrdbadr_reg[rdfp_int][rdfd_int-1]) &&
                       (vrdradr_reg[0][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2-1] == vrdradr_reg[rdfp_int][rdfd_int-1])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[0][SRAM_DELAY-1];
          end else if (vwrite_reg[1][SRAM_DELAY] && vread_reg[rdfp_int][rdfd_int-1] &&
	               (vrdbadr_reg[1][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2] == vrdbadr_reg[rdfp_int][rdfd_int-1]) &&
                       (vrdradr_reg[1][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2] == vrdradr_reg[rdfp_int][rdfd_int-1])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[1][SRAM_DELAY];
          end else if (vwrite_reg[0][SRAM_DELAY] && vread_reg[rdfp_int][rdfd_int-1] &&
                       (vrdbadr_reg[0][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2] == vrdbadr_reg[rdfp_int][rdfd_int-1]) &&
                       (vrdradr_reg[0][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2] == vrdradr_reg[rdfp_int][rdfd_int-1])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[0][SRAM_DELAY];
          end else begin
            rddat_vld[rdfp_int][rdfd_int] <= rddat_vld[rdfp_int][rdfd_int-1];
            rddat_reg[rdfp_int][rdfd_int] <= (rddat_vld[rdfp_int][rdfd_int-1]) ? rddat_reg[rdfp_int][rdfd_int-1] : rddat_reg[rdfp_int][rdfd_int];
          end
        end else begin
          if (vwrite_reg[1][SRAM_DELAY-1] && vread_wire[rdfp_int] &&
              (vrdbadr_reg[1][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2-1] == vrdbadr_wire[rdfp_int]) &&
              (vrdradr_reg[1][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2-1] == vrdradr_wire[rdfp_int])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[1][SRAM_DELAY-1];
          end else if (vwrite_reg[0][SRAM_DELAY-1] && vread_wire[rdfp_int] &&
                       (vrdbadr_reg[0][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2-1] == vrdbadr_wire[rdfp_int]) &&
                       (vrdradr_reg[0][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2-1] == vrdradr_wire[rdfp_int])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[0][SRAM_DELAY-1];
          end else if (vwrite_reg[1][SRAM_DELAY] && vread_wire[rdfp_int] &&
                       (vrdbadr_reg[1][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2] == vrdbadr_wire[rdfp_int]) &&
                       (vrdradr_reg[1][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2] == vrdradr_wire[rdfp_int])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[1][SRAM_DELAY];
          end else if (vwrite_reg[0][SRAM_DELAY] && vread_wire[rdfp_int] &&
                       (vrdbadr_reg[0][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2] == vrdbadr_wire[rdfp_int]) &&
                       (vrdradr_reg[0][SRAM_DELAY+FLOPOUT+UPD_DELAY+FLOPIN+SRAM_DELAY+FLOPECC1+FLOPECC2] == vrdradr_wire[rdfp_int])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[0][SRAM_DELAY];
          end else begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b0;
            rddat_reg[rdfp_int][rdfd_int] <= rddat_reg[rdfp_int][rdfd_int];
          end
        end

  reg             rpdat_vld [0:NUMRUPT-1][0:SRAM_DELAY-1];
  reg [PHYWDTH-1:0] rpdat_reg [0:NUMRUPT-1][0:SRAM_DELAY-1];
  integer rpfp_int, rpfd_int;
  always @(posedge clk) 
    for (rpfp_int=0; rpfp_int<NUMRUPT; rpfp_int=rpfp_int+1)
      for (rpfd_int=0; rpfd_int<SRAM_DELAY; rpfd_int=rpfd_int+1)
        if (rpfd_int > 0) 
          if (pwriteb && (pwrbadrb == vrdbadr_reg[rpfp_int][rpfd_int-1]) && (pwrradrb == vrdradr_reg[rpfp_int][rpfd_int-1])) begin
            rpdat_vld[rpfp_int][rpfd_int] <= 1'b1;
            rpdat_reg[rpfp_int][rpfd_int] <= pdinb;
          end else if (pwritea && (pwrbadra == vrdbadr_reg[rpfp_int][rpfd_int-1]) && (pwrradra == vrdradr_reg[rpfp_int][rpfd_int-1])) begin
            rpdat_vld[rpfp_int][rpfd_int] <= 1'b1;
            rpdat_reg[rpfp_int][rpfd_int] <= pdina;
          end else begin
            rpdat_vld[rpfp_int][rpfd_int] <= rpdat_vld[rpfp_int][rpfd_int-1];
            rpdat_reg[rpfp_int][rpfd_int] <= (rpdat_vld[rpfp_int][rpfd_int-1]) ? rpdat_reg[rpfp_int][rpfd_int-1] : rpdat_reg[rpfp_int][rpfd_int];
          end
        else
          if (pwriteb && (pwrbadrb == vrdbadr_wire[rpfp_int]) && (pwrradrb == vrdradr_wire[rpfp_int])) begin
            rpdat_vld[rpfp_int][rpfd_int] <= 1'b1;
            rpdat_reg[rpfp_int][rpfd_int] <= pdinb;
          end else if (pwritea && (pwrbadra == vrdbadr_wire[rpfp_int]) && (pwrradra == vrdradr_wire[rpfp_int])) begin
            rpdat_vld[rpfp_int][rpfd_int] <= 1'b1;
            rpdat_reg[rpfp_int][rpfd_int] <= pdina;
          end else begin
            rpdat_vld[rpfp_int][rpfd_int] <= 1'b0;
            rpdat_reg[rpfp_int][rpfd_int] <= rpdat_reg[rpfp_int][rpfd_int];
          end

  wire [PHYWDTH-1:0] vdout_int [0:NUMRUPT-1];
  wire vread_fwrd_int [0:NUMRUPT-1];
  genvar vmap_int;
  generate for (vmap_int=0; vmap_int<NUMRUPT; vmap_int=vmap_int+1) begin: vdo_loop
    wire [BITVBNK:0] rdmap_out = rdmap_vld[vmap_int][SRAM_DELAY-1] ? rdmap_reg[vmap_int][SRAM_DELAY-1] : sdout_wire[vmap_int];
    wire rdmap_vld_p = rdmap_out >> BITVBNK;
    wire [BITVBNK-1:0] rdmap_map = rdmap_out;
    wire [PHYWDTH-1:0] rcdat_out = rcdat_vld[vmap_int][SRAM_DELAY-1] ? rcdat_reg[vmap_int][SRAM_DELAY-1] : cdout_wire[vmap_int];
    wire [PHYWDTH-1:0] rpdat_out = rpdat_vld[vmap_int][SRAM_DELAY-1] ? rpdat_reg[vmap_int][SRAM_DELAY-1] : pdout_wire[vmap_int];

    assign vdout_int[vmap_int] = (rdmap_vld_p && (rdmap_map == vrdbadr_out[vmap_int])) ? rcdat_out : rpdat_out;
    assign vread_fwrd_int[vmap_int] = (rdmap_vld_p && (rdmap_map == vrdbadr_out[vmap_int])) ? rcdat_vld[vmap_int][SRAM_DELAY-1] || cfwrd_wire[vmap_int] :
                                                                                            rpdat_vld[vmap_int][SRAM_DELAY-1] || pfwrd_wire[vmap_int];
    assign vdout_ecc_wire[vmap_int] = rddat_vld[vmap_int][SRAM_DELAY-1] ? rddat_reg[vmap_int][SRAM_DELAY-1] : vdout_int[vmap_int];
    assign vread_fwrd_ecc_wire[vmap_int] = rddat_vld[vmap_int][SRAM_DELAY-1] || vread_fwrd_int[vmap_int];
    assign vread_padr_ecc_wire[vmap_int] = (rdmap_vld_p && (rdmap_map == vrdbadr_out[vmap_int])) ? ((NUMVBNK << (BITPADR-BITPBNK)) | cpadr_wire[vmap_int]) :
                                                                                             {vrdbadr_out[vmap_int],ppadr_wire[vmap_int]};
    assign vread_vld_ecc_wire[vmap_int] = vread_out[vmap_int];

    assign vread_serr_wire[vmap_int] = (COREECC > 0) ? rd_serr_wire[vmap_int] : ((rdmap_vld_p && (rdmap_map == vrdbadr_out[vmap_int])) ? cserr_wire[vmap_int] : pserr_wire[vmap_int]);
    assign vread_derr_wire[vmap_int] = (COREECC > 0) ? rd_derr_wire[vmap_int] : ((rdmap_vld_p && (rdmap_map == vrdbadr_out[vmap_int])) ? cderr_wire[vmap_int] : pderr_wire[vmap_int]);
  end
  endgenerate

  reg [NUMRUPT-1:0] vread_vld_tmp;
  reg [NUMRUPT*WIDTH-1:0] vdout_tmp;
  reg [NUMRUPT-1:0] vread_fwrd_tmp;
  reg [NUMRUPT-1:0] vread_serr_tmp;
  reg [NUMRUPT-1:0] vread_derr_tmp;
  reg [NUMRUPT*BITPADR-1:0] vread_padr_tmp;
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

  reg [NUMRUPT-1:0]         vread_vld;
  reg [NUMRUPT*WIDTH-1:0]   vdout;
  reg [NUMRUPT-1:0]         vread_fwrd;
  reg [NUMRUPT-1:0]         vread_serr;
  reg [NUMRUPT-1:0]         vread_derr;
  reg [NUMRUPT*BITPADR-1:0] vread_padr;

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

  reg cserrwb_reg;
  reg cderrwb_reg;
  always @(posedge clk)
    begin
      cserrwb_reg <= 0;
      cderrwb_reg <= 0;
    end

  wire [(BITVBNK+1)-1:0] wrmapa_out = rdmap_reg[0][SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT+SRAM_DELAY+FLOPECC1+FLOPECC2];
  wire [(BITVBNK+1)-1:0] wrmapb_out = rdmap_reg[1][SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT+SRAM_DELAY+FLOPECC1+FLOPECC2];
  wire [PHYWDTH-1:0]     wrdatb_out = rcdat_reg[1][SRAM_DELAY+UPD_DELAY+FLOPIN+FLOPOUT+SRAM_DELAY+FLOPECC1+FLOPECC2];

  wire               swrolda_vld = vwritea_out && wrmapa_out[BITVBNK];
  wire [BITVBNK-1:0] swrolda_map = wrmapa_out[BITVBNK-1:0];
  wire               swrnewa_vld = vwritea_out;
  wire [BITVBNK-1:0] swrnewa_map = vwrbadra_out;

  wire               swroldb_vld = vwriteb_out && wrmapb_out[BITVBNK];
  wire [BITVBNK-1:0] swroldb_map = wrmapb_out[BITVBNK-1:0];
  wire               swrnewb_vld = vwriteb_out;
  wire [BITVBNK-1:0] swrnewb_map = vwrbadrb_out;

  // Write request to pivoted banks
  wire write_new_a_to_cache = swrolda_vld && swrnewa_vld && (swrolda_map == swrnewa_map);
  wire write_new_a_to_pivot = swrnewa_vld && !write_new_a_to_cache;

  reg  write_old_b_to_pivot;
  reg  write_new_b_to_pivot;
  reg  write_new_b_to_cache;
  reg  update_b_to_invalid;
  reg  update_b_to_new;

  always_comb
    if (write_new_a_to_cache) begin
      write_new_b_to_cache = 1'b0;
      write_new_b_to_pivot = swrnewb_vld;
      update_b_to_new = 1'b0;
      update_b_to_invalid = swrnewb_vld && swroldb_vld && (swroldb_map == swrnewb_map);
      write_old_b_to_pivot = 1'b0;
    end else if (swrnewa_vld && swrnewb_vld && (swrnewa_map == swrnewb_map)) begin
      write_new_b_to_cache = 1'b1;
      write_new_b_to_pivot = 1'b0;
      update_b_to_new = 1'b1;
      update_b_to_invalid = 1'b0;
      write_old_b_to_pivot = swroldb_vld && (swroldb_map != swrnewb_map);
    end else begin
      write_new_b_to_cache = 1'b0;
      write_new_b_to_pivot = swrnewb_vld;
      update_b_to_new = 1'b0;
      update_b_to_invalid = swrnewb_vld && swroldb_vld && (swroldb_map == swrnewb_map);
      write_old_b_to_pivot = 1'b0;
    end

  always_comb
    if (rstvld) begin
      cwrite = !rst_sync;
      cwrradr = rstaddr;
      cdin = 0;
    end else if (write_new_a_to_cache) begin
      cwrite = 1'b1;
      cwrradr = vwrradra_out;
      cdin = vdina_out;
    end else begin
      cwrite = write_new_b_to_cache;
      cwrradr = vwrradrb_out;
      cdin = vdinb_out;
    end

  always_comb
    if (rstvld) begin
      swrite = !rst_sync;
      swrradr = rstaddr;
      sdin = 0;
    end else if (update_b_to_invalid) begin
      swrite = 1'b1;
      swrradr = vwrradrb_out;
      sdin = 0;
    end else if (update_b_to_new) begin
      swrite = 1'b1;
      swrradr = vwrradrb_out;
      sdin = {swrnewb_vld,swrnewb_map};
    end else begin
      swrite = 1'b0;
      swrradr = vwrradrb_out;
      sdin = 0;
    end

  always_comb
    if (write_new_a_to_pivot) begin
      pwritea = 1'b1;
      pwrbadra = vwrbadra_out;
      pwrradra = vwrradra_out;
      pdina = vdina_out;
      pwriteb = write_new_b_to_pivot || write_old_b_to_pivot;
      pwrbadrb = write_new_b_to_pivot ? vwrbadrb_out : swroldb_map;
      pwrradrb = vwrradrb_out;
      pdinb = write_new_b_to_pivot ? vdinb_out : wrdatb_out;
    end else begin
      pwritea = write_new_b_to_pivot;
      pwrbadra = vwrbadrb_out;
      pwrradra = vwrradrb_out;
      pdina = vdinb_out;
      pwriteb = write_old_b_to_pivot;
      pwrbadrb = swroldb_map;
      pwrradrb = vwrradrb_out;
      pdinb = wrdatb_out;
    end

  reg [NUMRUPT*NUMVBNK-1:0] t1_writeA;
  reg [NUMRUPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  reg [NUMRUPT*NUMVBNK*PHYWDTH-1:0] t1_dinA;
  integer t1wp_int;
  always_comb begin
    if (rstvld) begin
      t1_writeA = {NUMRUPT*NUMVBNK{!rst_sync}};
      t1_addrA = {NUMRUPT*NUMVBNK{rstaddr[BITVROW-1:0]}};
      t1_dinA = 0;
    end else begin
      t1_writeA = 0;
      t1_addrA = 0;
      t1_dinA = 0;
      for (t1wp_int=0; t1wp_int<NUMRUPT; t1wp_int=t1wp_int+1) begin
        if (pwritea && (pwrbadra<NUMVBNK)) begin
          t1_writeA = t1_writeA | (1'b1 << (pwrbadra+(t1wp_int*NUMVBNK)));
          t1_addrA = t1_addrA | (pwrradra << ((pwrbadra+(t1wp_int*NUMVBNK))*BITVROW));
          t1_dinA = t1_dinA | (pdina << ((pwrbadra+(t1wp_int*NUMVBNK))*PHYWDTH));
        end
        if (pwriteb && (pwrbadrb<NUMVBNK)) begin
          t1_writeA = t1_writeA | (1'b1 << (pwrbadrb+(t1wp_int*NUMVBNK)));
          t1_addrA = t1_addrA | (pwrradrb << ((pwrbadrb+(t1wp_int*NUMVBNK))*BITVROW));
          t1_dinA = t1_dinA | (pdinb << ((pwrbadrb+(t1wp_int*NUMVBNK))*PHYWDTH));
        end
      end
    end
  end

  assign t2_writeA = {(NUMRUPT){cwrite}};
  assign t2_addrA = {(NUMRUPT){cwrradr}};
  assign t2_dinA = {(NUMRUPT){cdin}};

  assign t3_writeA = {(NUMRUPT){swrite}};
  assign t3_addrA = {(NUMRUPT){swrradr}};
  assign t3_dinA = {(NUMRUPT){sdin}};

endmodule


