module core_nr2w_1r1w_a653 (vwrite, vwraddr, vdin,
                            vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                            t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                            t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB,
                            t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB, t3_fwrdB, t3_serrB, t3_derrB, t3_padrB,
                            ready, clk, rst);

  parameter BITWDTH = 5;
  parameter ENAPSDO = 0;
  parameter WIDTH = 32;
  parameter NUMRDPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 14;
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;


  parameter CGFLOPI = 1;
  parameter CGFLOPO = 1;

  input [2-1:0]                      vwrite;
  input [2*BITADDR-1:0]              vwraddr;
  input [2*WIDTH-1:0]                vdin;

  input [NUMRDPT-1:0]                vread;
  input [NUMRDPT*BITADDR-1:0]        vrdaddr;
  output [NUMRDPT-1:0]               vread_vld;
  output [NUMRDPT*WIDTH-1:0]         vdout;
  output [NUMRDPT-1:0]               vread_fwrd;
  output [NUMRDPT-1:0]               vread_serr;
  output [NUMRDPT-1:0]               vread_derr;
  output [NUMRDPT*BITPADR-1:0]       vread_padr;

  output [NUMRDPT*NUMVBNK-1:0] t1_writeA;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA;
  
  output [NUMRDPT*NUMVBNK-1:0] t1_readB;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_doutB;
  input [NUMRDPT*NUMVBNK-1:0] t1_fwrdB;
  input [NUMRDPT*NUMVBNK-1:0] t1_serrB;
  input [NUMRDPT*NUMVBNK-1:0] t1_derrB;
  input [NUMRDPT*NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrB;
  
  output [(NUMRDPT+1)-1:0] t2_writeA;
  output [(NUMRDPT+1)*BITVROW-1:0] t2_addrA;
  output [(NUMRDPT+1)*WIDTH-1:0] t2_dinA;
  
  output [(NUMRDPT+1)-1:0] t2_readB;
  output [(NUMRDPT+1)*BITVROW-1:0] t2_addrB;
  input [(NUMRDPT+1)*WIDTH-1:0] t2_doutB;
  input [(NUMRDPT+1)-1:0] t2_fwrdB;
  input [(NUMRDPT+1)-1:0] t2_serrB;
  input [(NUMRDPT+1)-1:0] t2_derrB;
  input [(NUMRDPT+1)*(BITPADR-BITPBNK)-1:0] t2_padrB;
  
  output [(NUMRDPT+2)-1:0] t3_writeA;
  output [(NUMRDPT+2)*BITVROW-1:0] t3_addrA;
  output [(NUMRDPT+2)*(BITVBNK+1)-1:0] t3_dinA;
  
  output [(NUMRDPT+2)-1:0] t3_readB;
  output [(NUMRDPT+2)*BITVROW-1:0] t3_addrB;
  input [(NUMRDPT+2)*(BITVBNK+1)-1:0] t3_doutB;
  input [(NUMRDPT+2)-1:0] t3_fwrdB;
  input [(NUMRDPT+2)-1:0] t3_serrB;
  input [(NUMRDPT+2)-1:0] t3_derrB;
  input [(NUMRDPT+2)*(BITPADR-BITPBNK)-1:0] t3_padrB;

  output                             ready;
  input                              clk;
  input                              rst;

  reg [BITVROW:0] rstaddr;
  wire rstvld = (rstaddr < NUMVROW);
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg ready;
  always @(posedge clk)
    ready <= !rstvld;

  wire ready_wire;

  wire vread_wire [0:NUMRDPT-1];
  wire vread_cg_wire [0:NUMRDPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMRDPT-1];
  wire [BITADDR-1:0] vrdaddr_cg_wire [0:NUMRDPT-1];
  wire [BITVBNK-1:0] vrdbadr_wire [0:NUMRDPT-1];
  wire [BITVROW-1:0] vrdradr_wire [0:NUMRDPT-1];

  wire vwrite_wire [0:2-1];
  wire vwrite_cg_wire [0:2-1];
  wire [BITADDR-1:0] vwraddr_wire [0:2-1];
  wire [BITADDR-1:0] vwraddr_cg_wire [0:2-1];
  wire [BITVBNK-1:0] vwrbadr_wire [0:2-1];
  wire [BITVROW-1:0] vwrradr_wire [0:2-1];
  wire [WIDTH-1:0] vdin_wire [0:2-1];
  wire [WIDTH-1:0] vdin_cg_wire [0:2-1];

  genvar np2_var;
  integer rdpt_int,wrpt_int;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMRDPT-1:0] vread_np2_reg;
    reg [BITADDR-1:0] vrdaddr_np2_reg [0:NUMRDPT-1];
    reg [2-1:0] vwrite_np2_reg;
    reg [BITADDR-1:0] vwraddr_np2_reg [0:2-1];
    reg [WIDTH-1:0] vdin_np2_reg [0:2-1];
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_cg_loop
      assign vread_cg_wire[np2_var] = vread >> np2_var;
      assign vrdaddr_cg_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);
    end
    for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: wr_cg_loop
      assign vwrite_cg_wire[np2_var] = (vwrite >> np2_var) & (vwraddr_cg_wire[np2_var] < NUMADDR);
      assign vwraddr_cg_wire[np2_var] = vwraddr >> (np2_var*BITADDR);
      assign vdin_cg_wire[np2_var] = vdin >> (np2_var*WIDTH);
    end
  
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_np2_reg <= vread & {NUMRDPT{ready}};
      for (rdpt_int=0; rdpt_int<NUMRDPT; rdpt_int=rdpt_int+1) begin: vrd_loop
        vrdaddr_np2_reg[rdpt_int] <= (ready && (!CGFLOPI | vread_cg_wire[rdpt_int])) ? vrdaddr_cg_wire[rdpt_int] : vrdaddr_np2_reg[rdpt_int];
      end
      vwrite_np2_reg <= vwrite & {2{ready}};
      for (wrpt_int=0; wrpt_int<2; wrpt_int=wrpt_int+1) begin: vwr_loop
        vwraddr_np2_reg[wrpt_int] <= (ready && (!CGFLOPI | vwrite_cg_wire[wrpt_int])) ? vwraddr_cg_wire[wrpt_int] : vwraddr_np2_reg[wrpt_int];
        vdin_np2_reg[wrpt_int] <= (ready && (!CGFLOPI | vwrite_cg_wire[wrpt_int])) ? vdin_cg_wire[wrpt_int] : vdin_np2_reg[wrpt_int];
      end
    end

    assign ready_wire = ready_reg;
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_np2_reg >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr_np2_reg[np2_var];
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end
    for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = (vwrite_np2_reg >> np2_var) & {2{(vwraddr_wire[np2_var] < NUMADDR)}};
      assign vwraddr_wire[np2_var] = vwraddr_np2_reg[np2_var];
      assign vdin_wire[np2_var] = vdin_np2_reg[np2_var];
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire[np2_var]), .vradr(vwrradr_wire[np2_var]), .vaddr(vwraddr_wire[np2_var]));
    end
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = (vread & {NUMRDPT{ready}}) >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
    end
    for (np2_var=0; np2_var<2; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = ((vwrite & {2{ready}}) >> np2_var) & (vwraddr_wire[np2_var] < NUMADDR);
      assign vwraddr_wire[np2_var] = vwraddr >> (np2_var*BITADDR);
      assign vdin_wire[np2_var] = vdin >> (np2_var*WIDTH);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire[np2_var]), .vradr(vwrradr_wire[np2_var]), .vaddr(vwraddr_wire[np2_var]));
    end
  end
  endgenerate

  reg                vread_reg [0:NUMRDPT-1][0:SRAM_DELAY];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:NUMRDPT-1][0:SRAM_DELAY];
  reg [BITVROW-1:0]  vrdradr_reg [0:NUMRDPT-1][0:SRAM_DELAY];
  reg                vwrite_reg [0:1][0:SRAM_DELAY];
  reg [BITVBNK-1:0]  vwrbadr_reg [0:1][0:SRAM_DELAY];
  reg [BITVROW-1:0]  vwrradr_reg [0:1][0:SRAM_DELAY];
  reg [WIDTH-1:0]    vdin_reg [0:1][0:SRAM_DELAY];

  integer vdel_int, vprt_int;
  always @(posedge clk) 
    for (vdel_int=SRAM_DELAY; vdel_int>=0; vdel_int=vdel_int-1)
      if (vdel_int>0) begin
        for (vprt_int=0; vprt_int<NUMRDPT; vprt_int=vprt_int+1) begin
          vread_reg[vprt_int][vdel_int] <= vread_reg[vprt_int][vdel_int-1];
          vrdbadr_reg[vprt_int][vdel_int] <= (vread_reg[vprt_int][vdel_int-1]) ? vrdbadr_reg[vprt_int][vdel_int-1] : vrdbadr_reg[vprt_int][vdel_int];
          vrdradr_reg[vprt_int][vdel_int] <= (vread_reg[vprt_int][vdel_int-1]) ? vrdradr_reg[vprt_int][vdel_int-1] : vrdradr_reg[vprt_int][vdel_int];
        end
        for (vprt_int=0; vprt_int<2; vprt_int=vprt_int+1) begin
          vwrite_reg[vprt_int][vdel_int] <= vwrite_reg[vprt_int][vdel_int-1];
          vwrbadr_reg[vprt_int][vdel_int] <= (vwrite_reg[vprt_int][vdel_int-1]) ? vwrbadr_reg[vprt_int][vdel_int-1] : vwrbadr_reg[vprt_int][vdel_int];
          //vwrradr_reg[vprt_int][vdel_int] <= (vwrite_reg[vprt_int][vdel_int-1]) ? vwrradr_reg[vprt_int][vdel_int-1] : vwrradr_reg[vprt_int][vdel_int];
          vwrradr_reg[vprt_int][vdel_int] <= vwrradr_reg[vprt_int][vdel_int-1];
          vdin_reg[vprt_int][vdel_int] <= (vwrite_reg[vprt_int][vdel_int-1]) ? vdin_reg[vprt_int][vdel_int-1] : vdin_reg[vprt_int][vdel_int];
        end
      end else begin
        for (vprt_int=0; vprt_int<NUMRDPT; vprt_int=vprt_int+1) begin
          vread_reg[vprt_int][vdel_int] <= vread_wire[vprt_int];
          vrdbadr_reg[vprt_int][vdel_int] <= (vread_wire[vprt_int]) ? vrdbadr_wire[vprt_int] : vrdbadr_reg[vprt_int][vdel_int];
          vrdradr_reg[vprt_int][vdel_int] <= (vread_wire[vprt_int]) ? vrdradr_wire[vprt_int] : vrdradr_reg[vprt_int][vdel_int];
        end
        for (vprt_int=0; vprt_int<2; vprt_int=vprt_int+1) begin
          if (vprt_int>0)
            vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int] && (vwraddr_wire[vprt_int] < NUMADDR) && ready;
          else
            vwrite_reg[vprt_int][vdel_int] <= vwrite_wire[vprt_int] && (vwraddr_wire[vprt_int] < NUMADDR) && ready &&
                                              !(vwrite_wire[1] && (vwrbadr_wire[1] == vwrbadr_wire[vprt_int]) && (vwrradr_wire[1] == vwrradr_wire[vprt_int]));
          vwrbadr_reg[vprt_int][vdel_int] <= (vwrite_wire[vprt_int] && (vwraddr_wire[vprt_int] < NUMADDR) && ready) ? vwrbadr_wire[vprt_int] : vwrbadr_reg[vprt_int][vdel_int];
          vwrradr_reg[vprt_int][vdel_int] <= (vwrite_wire[vprt_int] && (vwraddr_wire[vprt_int] < NUMADDR) && ready) ? vwrradr_wire[vprt_int] : vwrradr_reg[vprt_int][vdel_int];
          vdin_reg[vprt_int][vdel_int] <= (vwrite_wire[vprt_int] && (vwraddr_wire[vprt_int] < NUMADDR) && ready) ? vdin_wire[vprt_int] : vdin_reg[vprt_int][vdel_int];
        end
      end

  reg               vread_out[0:NUMRDPT-1];
  reg [BITVBNK-1:0] vrdbadr_out[0:NUMRDPT-1];
  reg [BITVROW-1:0] vrdradr_out[0:NUMRDPT-1];
  integer vout_int;
  always_comb
    for (vout_int=0; vout_int<NUMRDPT; vout_int=vout_int+1) begin
      vread_out[vout_int] = vread_reg[vout_int][SRAM_DELAY-1];
      vrdbadr_out[vout_int] = vrdbadr_reg[vout_int][SRAM_DELAY-1];
      vrdradr_out[vout_int] = vrdradr_reg[vout_int][SRAM_DELAY-1];
    end

  wire               vwritea_out = vwrite_reg[0][SRAM_DELAY];
  wire [BITVBNK-1:0] vwrbadra_out = vwrbadr_reg[0][SRAM_DELAY];
  wire [BITVROW-1:0] vwrradra_out = vwrradr_reg[0][SRAM_DELAY];
  wire [WIDTH-1:0]   vdina_out = vdin_reg[0][SRAM_DELAY];       

  wire               vwriteb_out = vwrite_reg[1][SRAM_DELAY];
  wire [BITVBNK-1:0] vwrbadrb_out = vwrbadr_reg[1][SRAM_DELAY];
  wire [BITVROW-1:0] vwrradrb_out = vwrradr_reg[1][SRAM_DELAY];
  wire [WIDTH-1:0]   vdinb_out = vdin_reg[1][SRAM_DELAY];       

  // Read request of pivoted data on DRAM memory
  reg               pwritea;
  reg [BITVBNK-1:0] pwrbadra;
  reg [BITVROW-1:0] pwrradra;
  reg [WIDTH-1:0]   pdina;
  reg               pwriteb;
  reg [BITVBNK-1:0] pwrbadrb;
  reg [BITVROW-1:0] pwrradrb;
  reg [WIDTH-1:0]   pdinb;

  reg               cwrite;
  reg [BITVROW-1:0] cwrradr;
  reg [WIDTH-1:0]   cdin;

  reg                   swrite;
  reg [BITVROW-1:0]     swrradr;
  reg [(BITVBNK+1)-1:0] sdin;

  reg [NUMRDPT*NUMVBNK-1:0] t1_readB;
  reg [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  reg [NUMRDPT*NUMVBNK-1:0] t1_read_tmp;
  integer t1rp_int, t1rb_int, t1rd_int;
  always_comb begin
    t1_readB = 0;
    t1_addrB = 0;
    for (t1rp_int=0; t1rp_int<NUMRDPT; t1rp_int=t1rp_int+1) begin
      t1_read_tmp[t1rp_int] = vread_wire[t1rp_int] && (vrdbadr_wire[t1rp_int] < NUMVBNK);
      if (ENAPSDO)
        t1_read_tmp[t1rp_int] = t1_read_tmp[t1rp_int] &&
                                !(pwritea && (pwrbadra == vrdbadr_wire[t1rp_int]) && (pwrradra == vrdradr_wire[t1rp_int])) &&
                                !(pwriteb && (pwrbadrb == vrdbadr_wire[t1rp_int]) && (pwrradrb == vrdradr_wire[t1rp_int]));
      if (t1_read_tmp[t1rp_int])
        t1_readB = t1_readB | (1'b1 << (t1rp_int*NUMVBNK+vrdbadr_wire[t1rp_int]));
      for (t1rb_int=0; t1rb_int<NUMVBNK; t1rb_int=t1rb_int+1)
//        for (t1rd_int=0; t1rd_int<BITVROW; t1rd_int=t1rd_int+1)
//          t1_addrB[(t1rp_int*NUMVBNK+t1rb_int)*BITVROW+t1rd_int] = vrdradr_wire[t1rp_int][t1rd_int];
        t1_addrB = t1_addrB | (vrdradr_wire[t1rp_int] << ((t1rp_int*NUMVBNK+t1rb_int)*BITVROW));
    end
  end

  reg [BITVBNK-1:0] prdbadr_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  integer prdd_int, prdp_int;
  always @(posedge clk)
    for (prdd_int=0; prdd_int<SRAM_DELAY; prdd_int=prdd_int+1)
      for (prdp_int=0; prdp_int<NUMRDPT; prdp_int=prdp_int+1)
        if (prdd_int>0)
          prdbadr_reg[prdp_int][prdd_int] <= prdbadr_reg[prdp_int][prdd_int-1];
        else
          prdbadr_reg[prdp_int][prdd_int] <= vrdbadr_wire[prdp_int];

  reg [WIDTH-1:0] pdout_wire [0:NUMRDPT-1];
  reg pfwrd_wire [0:NUMRDPT-1];
  reg pserr_wire [0:NUMRDPT-1];
  reg pderr_wire [0:NUMRDPT-1];
  reg [BITPADR-BITPBNK-1:0] ppadr_wire [0:NUMRDPT-1];
  integer pdo_int, pdob_int, pdod_int;
  always_comb
    for (pdo_int=0; pdo_int<NUMRDPT; pdo_int=pdo_int+1) begin
      pdout_wire[pdo_int] = 0;
      pfwrd_wire[pdo_int] = 0;
      pserr_wire[pdo_int] = 0;
      pderr_wire[pdo_int] = 0;
      ppadr_wire[pdo_int] = 0;
      for (pdob_int=0; pdob_int<NUMVBNK; pdob_int=pdob_int+1)
        if (pdob_int == vrdbadr_out[pdo_int]) begin
//          for (pdod_int=0; pdod_int<WIDTH; pdod_int=pdod_int+1) 
//            pdout_wire[pdo_int][pdod_int] = t1_doutB[(NUMVBNK*pdo_int+pdob_int)*WIDTH+pdod_int];
          pdout_wire[pdo_int] = t1_doutB >> ((NUMVBNK*pdo_int+pdob_int)*WIDTH);
          pfwrd_wire[pdo_int] = t1_fwrdB[NUMVBNK*pdo_int+pdob_int];
          pserr_wire[pdo_int] = t1_serrB[NUMVBNK*pdo_int+pdob_int];
          pderr_wire[pdo_int] = t1_derrB[NUMVBNK*pdo_int+pdob_int];
//          for (pdod_int=0; pdod_int<BITPADR-BITPBNK; pdod_int=pdod_int+1) 
//            ppadr_wire[pdo_int][pdod_int] = t1_padrB[(NUMVBNK*pdo_int+pdob_int)*(BITPADR-BITPBNK)+pdod_int];
          ppadr_wire[pdo_int] = t1_padrB >> ((NUMVBNK*pdo_int+pdob_int)*(BITPADR-BITPBNK));
        end
    end

  // Read request of mapping information on SRAM memory
  reg [(NUMRDPT+1)-1:0] t2_readB;
  reg [(NUMRDPT+1)*BITVROW-1:0] t2_addrB;
  integer t2rp_int, t2rd_int;
  always_comb begin
    t2_readB = 0;
    t2_addrB = 0;
    for (t2rp_int=0; t2rp_int<NUMRDPT; t2rp_int=t2rp_int+1) begin
      t2_readB[t2rp_int] = vread_wire[t2rp_int];
      if (ENAPSDO)
        t2_readB[t2rp_int] = t2_readB[t2rp_int] && !(cwrite && (vrdradr_wire[t2rp_int] == cwrradr));
//      for (t2rd_int=0; t2rd_int<BITVROW; t2rd_int=t2rd_int+1)
//        t2_addrB[t2rp_int*BITVROW+t2rd_int] = vrdradr_wire[t2rp_int][t2rd_int];
      t2_addrB = t2_addrB | (vrdradr_wire[t2rp_int] << (t2rp_int*BITVROW));
    end
    t2_readB[NUMRDPT] = vwrite_wire[1];
    if (ENAPSDO)
      t2_readB[NUMRDPT] = t2_readB[NUMRDPT] && !(cwrite && (vwrradr_wire[1] == cwrradr));
//    for (t2rd_int=0; t2rd_int<BITVROW; t2rd_int=t2rd_int+1)
//      t2_addrB[NUMRDPT*BITVROW+t2rd_int] = vwrradr_wire[1][t2rd_int];
      t2_addrB = t2_addrB | (vwrradr_wire[1] << (NUMRDPT*BITVROW));
  end

  reg [WIDTH-1:0] cdout_wire [0:(NUMRDPT+1)-1];
  reg cfwrd_wire [0:(NUMRDPT+1)-1];
  reg cserr_wire [0:(NUMRDPT+1)-1];
  reg cderr_wire [0:(NUMRDPT+1)-1];
  reg [BITPADR-BITPBNK-1:0] cpadr_wire [0:(NUMRDPT+1)-1];
  integer cdo_int, cdod_int;
  always_comb
    for (cdo_int=0; cdo_int<NUMRDPT+1; cdo_int=cdo_int+1) begin
//      for (cdod_int=0; cdod_int<WIDTH; cdod_int=cdod_int+1)
//        cdout_wire[cdo_int][cdod_int] = t2_doutB[cdo_int*WIDTH+cdod_int];
      cdout_wire[cdo_int] = t2_doutB >> (cdo_int*WIDTH);
      cfwrd_wire[cdo_int] = t2_fwrdB[cdo_int];
      cserr_wire[cdo_int] = t2_serrB[cdo_int];
      cderr_wire[cdo_int] = t2_derrB[cdo_int];
//      for (cdod_int=0; cdod_int<BITPADR-BITPBNK; cdod_int=cdod_int+1)
//        cpadr_wire[cdo_int][cdod_int] = t2_padrB[cdo_int*(BITPADR-BITPBNK)+cdod_int];
      cpadr_wire[cdo_int] = t2_padrB >> (cdo_int*(BITPADR-BITPBNK));
    end

  reg [(NUMRDPT+2)-1:0] t3_readB;
  reg [(NUMRDPT+2)*BITVROW-1:0] t3_addrB;
  integer t3rp_int, t3rd_int;
  always_comb begin
    t3_readB = 0;
    t3_addrB = 0;
    for (t3rp_int=0; t3rp_int<NUMRDPT; t3rp_int=t3rp_int+1) begin
      t3_readB[t3rp_int] = vread_wire[t3rp_int];
      if (ENAPSDO)
        t3_readB[t3rp_int] = t3_readB[t3rp_int] && !(swrite && (vrdradr_wire[t3rp_int] == swrradr));
//      for (t3rd_int=0; t3rd_int<BITVROW; t3rd_int=t3rd_int+1)
//        t3_addrB[t3rp_int*BITVROW+t3rd_int] = vrdradr_wire[t3rp_int][t3rd_int];
      t3_addrB = t3_addrB | (vrdradr_wire[t3rp_int] << (t3rp_int*BITVROW));
    end
    for (t3rp_int=0; t3rp_int<2; t3rp_int=t3rp_int+1) begin
      t3_readB[NUMRDPT+t3rp_int] = vwrite_wire[t3rp_int];
      if (ENAPSDO)
        t3_readB[NUMRDPT+t3rp_int] = t3_readB[NUMRDPT+t3rp_int] && !(swrite && (vwrradr_wire[t3rp_int] == swrradr));
//      for (t3rd_int=0; t3rd_int<BITVROW; t3rd_int=t3rd_int+1)
//        t3_addrB[(NUMRDPT+t3rp_int)*BITVROW+t3rd_int] = vwrradr_wire[t3rp_int][t3rd_int];
      t3_addrB = t3_addrB | (vwrradr_wire[t3rp_int] << ((NUMRDPT+t3rp_int)*BITVROW));
    end
  end

  reg [(BITVBNK+1)-1:0] sdout_wire [0:NUMRDPT+2-1];
  reg sfwrd_wire [0:(NUMRDPT+2)-1];
  reg sserr_wire [0:(NUMRDPT+2)-1];
  reg sderr_wire [0:(NUMRDPT+2)-1];
  reg [BITPADR-BITPBNK-1:0] spadr_wire [0:(NUMRDPT+2)-1];
  integer sdo_int, sdod_int;
  always_comb
    for (sdo_int=0; sdo_int<NUMRDPT+2; sdo_int=sdo_int+1) begin
//      for (sdod_int=0; sdod_int<BITVBNK+1; sdod_int=sdod_int+1)
//        sdout_wire[sdo_int][sdod_int] = t3_doutB[sdo_int*(BITVBNK+1)+sdod_int];
      sdout_wire[sdo_int] = t3_doutB >> (sdo_int*(BITVBNK+1));
      sfwrd_wire[sdo_int] = t3_fwrdB[sdo_int];
      sserr_wire[sdo_int] = t3_serrB[sdo_int];
      sderr_wire[sdo_int] = t3_derrB[sdo_int];
//      for (sdod_int=0; sdod_int<BITPADR-BITPBNK; sdod_int=sdod_int+1)
//        spadr_wire[sdo_int][sdod_int] = t3_padrB[sdo_int*(BITPADR-BITPBNK)+sdod_int];
      spadr_wire[sdo_int] = t3_padrB >> (sdo_int*(BITPADR-BITPBNK));
    end

  reg              wrmapa_vld [0:SRAM_DELAY];
  reg [BITVBNK:0]  wrmapa_reg [0:SRAM_DELAY];

  reg              wrmapb_vld [0:SRAM_DELAY];
  reg [BITVBNK:0]  wrmapb_reg [0:SRAM_DELAY];

  reg              wrdatb_vld [0:SRAM_DELAY];
  reg [WIDTH-1:0]  wrdatb_reg [0:SRAM_DELAY];

  integer wrf_int;
  always @(posedge clk) 
    for (wrf_int=SRAM_DELAY; wrf_int>=0; wrf_int=wrf_int-1)
      if (wrf_int>0) begin
        if (swrite && (swrradr == vwrradr_reg[0][wrf_int-1])) begin
          wrmapa_vld[wrf_int] <= 1'b1;
          wrmapa_reg[wrf_int] <= sdin;
        end else begin
          wrmapa_vld[wrf_int] <= wrmapa_vld[wrf_int-1];
          wrmapa_reg[wrf_int] <= (wrmapa_vld[wrf_int-1]) ? wrmapa_reg[wrf_int-1] : wrmapa_reg[wrf_int];
        end
        if (swrite && (swrradr == vwrradr_reg[1][wrf_int-1])) begin
          wrmapb_vld[wrf_int] <= 1'b1;
          wrmapb_reg[wrf_int] <= sdin;
        end else begin
          wrmapb_vld[wrf_int] <= wrmapb_vld[wrf_int-1];
          wrmapb_reg[wrf_int] <= (wrmapb_vld[wrf_int-1]) ? wrmapb_reg[wrf_int-1] : wrmapb_reg[wrf_int];
        end
        if (cwrite && (cwrradr == vwrradr_reg[1][wrf_int-1])) begin
          wrdatb_vld[wrf_int] <= 1'b1;
          wrdatb_reg[wrf_int] <= cdin;
        end else begin
          wrdatb_vld[wrf_int] <= wrdatb_vld[wrf_int-1];
          wrdatb_reg[wrf_int] <= (wrdatb_vld[wrf_int-1]) ? wrdatb_reg[wrf_int-1] : wrdatb_reg[wrf_int];
        end
      end else begin
        if (swrite && (swrradr == vwrradr_wire[0])) begin
          wrmapa_vld[wrf_int] <= 1'b1;
          wrmapa_reg[wrf_int] <= sdin;
        end else begin
          wrmapa_vld[wrf_int] <= 1'b0;
          wrmapa_reg[wrf_int] <= 0;
        end
        if (swrite && (swrradr == vwrradr_wire[1])) begin
          wrmapb_vld[wrf_int] <= 1'b1;
          wrmapb_reg[wrf_int] <= sdin;
        end else begin
          wrmapb_vld[wrf_int] <= 1'b0;
          wrmapb_reg[wrf_int] <= 0;
        end
        if (cwrite && (cwrradr == vwrradr_wire[1])) begin
          wrdatb_vld[wrf_int] <= 1'b1;
          wrdatb_reg[wrf_int] <= cdin;
        end else begin
          wrdatb_vld[wrf_int] <= 1'b0;
          wrdatb_reg[wrf_int] <= 0;
        end
      end

  reg             rdmap_vld [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg [BITVBNK:0] rdmap_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg             rcdat_vld [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0] rcdat_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  integer sdfp_int, sdfd_int;
  always @(posedge clk) 
    for (sdfp_int=0; sdfp_int<NUMRDPT; sdfp_int=sdfp_int+1)
      for (sdfd_int=0; sdfd_int<SRAM_DELAY; sdfd_int=sdfd_int+1)
        if (sdfd_int>0) begin
          if (swrite && (swrradr == vrdradr_reg[sdfp_int][sdfd_int-1])) begin
            rdmap_vld[sdfp_int][sdfd_int] <= 1'b1;
            rdmap_reg[sdfp_int][sdfd_int] <= sdin;
          end else begin
            rdmap_vld[sdfp_int][sdfd_int] <= rdmap_vld[sdfp_int][sdfd_int-1];
            rdmap_reg[sdfp_int][sdfd_int] <= (rdmap_vld[sdfp_int][sdfd_int-1]) ? rdmap_reg[sdfp_int][sdfd_int-1] : rdmap_reg[sdfp_int][sdfd_int];
          end
          if (cwrite && (cwrradr == vrdradr_reg[sdfp_int][sdfd_int-1])) begin
            rcdat_vld[sdfp_int][sdfd_int] <= 1'b1;
            rcdat_reg[sdfp_int][sdfd_int] <= cdin;
          end else begin
            rcdat_vld[sdfp_int][sdfd_int] <= rcdat_vld[sdfp_int][sdfd_int-1];
            rcdat_reg[sdfp_int][sdfd_int] <= (rcdat_vld[sdfp_int][sdfd_int-1]) ? rcdat_reg[sdfp_int][sdfd_int-1] : rcdat_reg[sdfp_int][sdfd_int];
          end
        end else begin
          if (swrite && (swrradr == vrdradr_wire[sdfp_int])) begin
            rdmap_vld[sdfp_int][sdfd_int] <= 1'b1;
            rdmap_reg[sdfp_int][sdfd_int] <= sdin;
          end else begin
            rdmap_vld[sdfp_int][sdfd_int] <= 1'b0;
            rdmap_reg[sdfp_int][sdfd_int] <= rdmap_reg[sdfp_int][sdfd_int];
          end
          if (cwrite && (cwrradr == vrdradr_wire[sdfp_int])) begin
            rcdat_vld[sdfp_int][sdfd_int] <= 1'b1;
            rcdat_reg[sdfp_int][sdfd_int] <= cdin;
          end else begin
            rcdat_vld[sdfp_int][sdfd_int] <= 1'b0;
            rcdat_reg[sdfp_int][sdfd_int] <= rcdat_reg[sdfp_int][sdfd_int];
          end
        end

  reg             rddat_vld [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0] rddat_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  integer rdfd_int, rdfp_int;
  always @(posedge clk) 
    for (rdfd_int=SRAM_DELAY-1; rdfd_int>=0; rdfd_int=rdfd_int-1)
      for (rdfp_int=0; rdfp_int<NUMRDPT; rdfp_int=rdfp_int+1)
        if (rdfd_int>0) begin
          if (vwrite_reg[1][SRAM_DELAY-1] && vread_reg[rdfp_int][rdfd_int-1] &&
              (vwrbadr_reg[1][SRAM_DELAY-1] == vrdbadr_reg[rdfp_int][rdfd_int-1]) &&
              (vwrradr_reg[1][SRAM_DELAY-1] == vrdradr_reg[rdfp_int][rdfd_int-1])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[1][SRAM_DELAY-1];
          end else if (vwrite_reg[0][SRAM_DELAY-1] && vread_reg[rdfp_int][rdfd_int-1] &&
	               (vwrbadr_reg[0][SRAM_DELAY-1] == vrdbadr_reg[rdfp_int][rdfd_int-1]) &&
                       (vwrradr_reg[0][SRAM_DELAY-1] == vrdradr_reg[rdfp_int][rdfd_int-1])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[0][SRAM_DELAY-1];
          end else if (vwrite_reg[1][SRAM_DELAY] && vread_reg[rdfp_int][rdfd_int-1] &&
	               (vwrbadr_reg[1][SRAM_DELAY] == vrdbadr_reg[rdfp_int][rdfd_int-1]) &&
                       (vwrradr_reg[1][SRAM_DELAY] == vrdradr_reg[rdfp_int][rdfd_int-1])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[1][SRAM_DELAY];
          end else if (vwrite_reg[0][SRAM_DELAY] && vread_reg[rdfp_int][rdfd_int-1] &&
                       (vwrbadr_reg[0][SRAM_DELAY] == vrdbadr_reg[rdfp_int][rdfd_int-1]) &&
                       (vwrradr_reg[0][SRAM_DELAY] == vrdradr_reg[rdfp_int][rdfd_int-1])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[0][SRAM_DELAY];
          end else begin
            rddat_vld[rdfp_int][rdfd_int] <= rddat_vld[rdfp_int][rdfd_int-1];
            rddat_reg[rdfp_int][rdfd_int] <= (rddat_vld[rdfp_int][rdfd_int-1]) ? rddat_reg[rdfp_int][rdfd_int-1] : rddat_reg[rdfp_int][rdfd_int];
          end
        end else begin
          if (vwrite_reg[1][SRAM_DELAY-1] && vread_wire[rdfp_int] &&
              (vwrbadr_reg[1][SRAM_DELAY-1] == vrdbadr_wire[rdfp_int]) &&
              (vwrradr_reg[1][SRAM_DELAY-1] == vrdradr_wire[rdfp_int])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[1][SRAM_DELAY-1];
          end else if (vwrite_reg[0][SRAM_DELAY-1] && vread_wire[rdfp_int] &&
                       (vwrbadr_reg[0][SRAM_DELAY-1] == vrdbadr_wire[rdfp_int]) &&
                       (vwrradr_reg[0][SRAM_DELAY-1] == vrdradr_wire[rdfp_int])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[0][SRAM_DELAY-1];
          end else if (vwrite_reg[1][SRAM_DELAY] && vread_wire[rdfp_int] &&
                       (vwrbadr_reg[1][SRAM_DELAY] == vrdbadr_wire[rdfp_int]) &&
                       (vwrradr_reg[1][SRAM_DELAY] == vrdradr_wire[rdfp_int])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[1][SRAM_DELAY];
          end else if (vwrite_reg[0][SRAM_DELAY] && vread_wire[rdfp_int] &&
                       (vwrbadr_reg[0][SRAM_DELAY] == vrdbadr_wire[rdfp_int]) &&
                       (vwrradr_reg[0][SRAM_DELAY] == vrdradr_wire[rdfp_int])) begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b1;
            rddat_reg[rdfp_int][rdfd_int] <= vdin_reg[0][SRAM_DELAY];
          end else begin
            rddat_vld[rdfp_int][rdfd_int] <= 1'b0;
            rddat_reg[rdfp_int][rdfd_int] <= rddat_reg[rdfp_int][rdfd_int];
          end
        end

  reg             rpdat_vld [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0] rpdat_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  integer rpfp_int, rpfd_int;
  always @(posedge clk) 
    for (rpfp_int=0; rpfp_int<NUMRDPT; rpfp_int=rpfp_int+1)
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

  wire vread_vld_wire [0:NUMRDPT-1];
  wire [WIDTH-1:0] vdout_int [0:NUMRDPT-1];
  wire [WIDTH-1:0] vdout_wire [0:NUMRDPT-1];
  wire vread_fwrd_int [0:NUMRDPT-1];
  wire vread_fwrd_wire [0:NUMRDPT-1];
  wire vread_serr_wire [0:NUMRDPT-1];
  wire vread_derr_wire [0:NUMRDPT-1];
  wire [BITPADR-1:0] vread_padr_wire [0:NUMRDPT-1];
  genvar vmap_int;
  generate for (vmap_int=0; vmap_int<NUMRDPT; vmap_int=vmap_int+1) begin: vdo_loop
    wire [BITVBNK:0] rdmap_out = rdmap_vld[vmap_int][SRAM_DELAY-1] ? rdmap_reg[vmap_int][SRAM_DELAY-1] : sdout_wire[vmap_int];
    wire rdmap_vld_p = rdmap_out >> BITVBNK;
    wire [BITVBNK-1:0] rdmap_map = rdmap_out;
    wire [WIDTH-1:0] rcdat_out = rcdat_vld[vmap_int][SRAM_DELAY-1] ? rcdat_reg[vmap_int][SRAM_DELAY-1] : cdout_wire[vmap_int];
    wire [WIDTH-1:0] rpdat_out = rpdat_vld[vmap_int][SRAM_DELAY-1] ? rpdat_reg[vmap_int][SRAM_DELAY-1] : pdout_wire[vmap_int];

    assign vread_vld_wire[vmap_int] = vread_out[vmap_int];
    assign vdout_int[vmap_int] = (rdmap_vld_p && (rdmap_map == vrdbadr_out[vmap_int])) ? rcdat_out : rpdat_out;
    assign vdout_wire[vmap_int] = rddat_vld[vmap_int][SRAM_DELAY-1] ? rddat_reg[vmap_int][SRAM_DELAY-1] : vdout_int[vmap_int];
    assign vread_fwrd_int[vmap_int] = (rdmap_vld_p && (rdmap_map == vrdbadr_out[vmap_int])) ? rcdat_vld[vmap_int][SRAM_DELAY-1] || cfwrd_wire[vmap_int] :
                                                                                            rpdat_vld[vmap_int][SRAM_DELAY-1] || pfwrd_wire[vmap_int];
    assign vread_fwrd_wire[vmap_int] = rddat_vld[vmap_int][SRAM_DELAY-1] || vread_fwrd_int[vmap_int];
    assign vread_serr_wire[vmap_int] = (rdmap_vld_p && (rdmap_map == vrdbadr_out[vmap_int])) ? cserr_wire[vmap_int] : pserr_wire[vmap_int];
    assign vread_derr_wire[vmap_int] = (rdmap_vld_p && (rdmap_map == vrdbadr_out[vmap_int])) ? cderr_wire[vmap_int] : pderr_wire[vmap_int];
    assign vread_padr_wire[vmap_int] = (rdmap_vld_p && (rdmap_map == vrdbadr_out[vmap_int])) ? ((NUMVBNK << (BITPADR-BITPBNK)) | cpadr_wire[vmap_int]) :
                                                                                             {vrdbadr_out[vmap_int],ppadr_wire[vmap_int]};
  end
  endgenerate

  reg [NUMRDPT-1:0] vread_vld_tmp;
  reg [NUMRDPT*WIDTH-1:0] vdout_tmp;
  reg [NUMRDPT-1:0] vread_fwrd_tmp;
  reg [NUMRDPT-1:0] vread_serr_tmp;
  reg [NUMRDPT-1:0] vread_derr_tmp;
  reg [NUMRDPT*BITPADR-1:0] vread_padr_tmp;
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

  reg [WIDTH-1:0]           vdout_reg [0:NUMRDPT-1];
  reg [NUMRDPT-1:0]         vread_vld;
  reg [NUMRDPT*WIDTH-1:0]   vdout;
  reg [NUMRDPT-1:0]         vread_fwrd;
  reg [NUMRDPT-1:0]         vread_serr;
  reg [NUMRDPT-1:0]         vread_derr;
  reg [NUMRDPT*BITPADR-1:0] vread_padr;
  integer fvdo_int,fvdr_int;

  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      for (fvdr_int=0; fvdr_int<NUMRDPT; fvdr_int=fvdr_int+1)
        vdout_reg[fvdr_int] <= (!CGFLOPO | vread_vld_tmp[fvdr_int]) ? vdout_wire[fvdr_int] : vdout_reg[fvdr_int];

      vread_vld <= vread_vld_tmp;
      vread_fwrd <= vread_fwrd_tmp;
      vread_serr <= vread_serr_tmp;
      vread_derr <= vread_derr_tmp;
      vread_padr <= vread_padr_tmp;
    end
    always_comb begin
      vdout = 0;
      for (fvdo_int=0; fvdo_int<NUMRDPT; fvdo_int=fvdo_int+1) begin: vdout_loop
        vdout = vdout | vdout_reg[fvdo_int] << (fvdo_int*WIDTH);
      end
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


  reg [BITVBNK:0] sdoutwa_reg;
  reg [BITVBNK:0] sdoutwb_reg;
  reg [WIDTH-1:0] cdoutwb_reg;
  reg cfwrdwb_reg;
  reg cserrwb_reg;
  reg cderrwb_reg;
  always @(posedge clk)
    begin
      sdoutwa_reg <= sdout_wire[NUMRDPT];
      sdoutwb_reg <= sdout_wire[NUMRDPT+1];
      cdoutwb_reg <= cdout_wire[NUMRDPT];
      cfwrdwb_reg <= cfwrd_wire[NUMRDPT];
      cserrwb_reg <= cserr_wire[NUMRDPT];
      cderrwb_reg <= cderr_wire[NUMRDPT];
    end

  wire [(BITVBNK+1)-1:0] wrmapa_out = wrmapa_vld[SRAM_DELAY] ? wrmapa_reg[SRAM_DELAY] : sdoutwa_reg;

  wire [(BITVBNK+1)-1:0] wrmapb_out = wrmapb_vld[SRAM_DELAY] ? wrmapb_reg[SRAM_DELAY] : sdoutwb_reg;
  wire [WIDTH-1:0]       wrdatb_out = wrdatb_vld[SRAM_DELAY] ? wrdatb_reg[SRAM_DELAY] : cdoutwb_reg;

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
      cwrite = !rst;
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
      swrite = !rst;
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

  reg [NUMRDPT*NUMVBNK-1:0] t1_writeA;
  reg [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  reg [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA;
  integer t1wp_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (t1wp_int=0; t1wp_int<NUMRDPT; t1wp_int=t1wp_int+1) begin
      if (pwritea && (pwrbadra<NUMVBNK)) begin
        t1_writeA = t1_writeA | (1'b1 << (pwrbadra+(t1wp_int*NUMVBNK)));
        t1_addrA = t1_addrA | (pwrradra << ((pwrbadra+(t1wp_int*NUMVBNK))*BITVROW));
        t1_dinA = t1_dinA | (pdina << ((pwrbadra+(t1wp_int*NUMVBNK))*WIDTH));
      end
      if (pwriteb && (pwrbadrb<NUMVBNK)) begin
        t1_writeA = t1_writeA | (1'b1 << (pwrbadrb+(t1wp_int*NUMVBNK)));
        t1_addrA = t1_addrA | (pwrradrb << ((pwrbadrb+(t1wp_int*NUMVBNK))*BITVROW));
        t1_dinA = t1_dinA | (pdinb << ((pwrbadrb+(t1wp_int*NUMVBNK))*WIDTH));
      end
    end
  end

  assign t2_writeA = {(NUMRDPT+1){cwrite}};
  assign t2_addrA = {(NUMRDPT+1){cwrradr}};
  assign t2_dinA = {(NUMRDPT+1){cdin}};

  assign t3_writeA = {(NUMRDPT+2){swrite}};
  assign t3_addrA = {(NUMRDPT+2){swrradr}};
  assign t3_dinA = {(NUMRDPT+2){sdin}};

endmodule


