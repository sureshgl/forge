module core_nror1w_edram (vrefr, vrfrbnk, vrfaddr,
	                  vwrite, vwrrbnk, vwraddr, vdin,
                          vread, vrdrbnk, vrdaddr, vread_vld, vdout, vread_serr, vread_derr, vread_padr,
                          prefr, prfrbnk, pwrite, pread, prbnk, pradr, pdin, pdout, pdout_serr, pdout_derr, pdout_padr,
	                  xrefr, xrfrbnk, xwrite, xread, xrbnk, xradr, xdin, xdout, xdout_serr, xdout_derr, xdout_padr,
	                  ready, clk, rst,
	                  select_bit);
 
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter BITADDR = 13;
  parameter NUMADDR = 8192;
  parameter NUMVRPT = 2;
  parameter NUMPRPT = 1;
  parameter BITVROW = 10;
  parameter NUMVROW = 1024;
  parameter BITVBNK = 3;
  parameter NUMVBNK = 8;
  parameter BITPBNK = 4;
  parameter BITPADR = 15;
  parameter NUMRBNK = 4;
  parameter BITRBNK = 2;
  parameter REFRESH = 0;

  parameter SRAM_DELAY = 2;
  parameter FLOPOUT = 0;

  input                                vrefr;
  input [BITRBNK-1:0]                  vrfrbnk;
  input [BITADDR-1:0]                  vrfaddr;
  
  input                                vwrite;
  input [BITRBNK-1:0]                  vwrrbnk;
  input [BITADDR-1:0]                  vwraddr;
  input [WIDTH-1:0]                    vdin;
  
  input [NUMVRPT-1:0]                  vread;
  input [NUMVRPT*BITRBNK-1:0]          vrdrbnk;
  input [NUMVRPT*BITADDR-1:0]          vrdaddr;
  output [NUMVRPT-1:0]                 vread_vld;
  output [NUMVRPT*WIDTH-1:0]           vdout;
  output [NUMVRPT-1:0]                 vread_serr;
  output [NUMVRPT-1:0]                 vread_derr;
  output [NUMVRPT*BITPADR-1:0]         vread_padr;

  output [NUMVBNK*NUMPRPT-1:0]         prefr;
  output [NUMVBNK*NUMPRPT*BITRBNK-1:0] prfrbnk;

  output [NUMVBNK*NUMPRPT-1:0]         pwrite;
  output [NUMVBNK*NUMPRPT-1:0]         pread;
  output [NUMVBNK*NUMPRPT*BITRBNK-1:0] prbnk;
  output [NUMVBNK*NUMPRPT*BITVROW-1:0] pradr;
  output [NUMVBNK*NUMPRPT*WIDTH-1:0]   pdin;
  input [NUMVBNK*NUMPRPT*WIDTH-1:0]    pdout;
  input [NUMVBNK*NUMPRPT-1:0]          pdout_serr;
  input [NUMVBNK*NUMPRPT-1:0]          pdout_derr;
  input [NUMVBNK*NUMPRPT*(BITPADR-BITPBNK-1)-1:0] pdout_padr;

  output [NUMPRPT-1:0]                 xrefr;
  output [NUMPRPT*BITRBNK-1:0]         xrfrbnk;

  output [NUMPRPT-1:0]                 xwrite;
  output [NUMPRPT-1:0]                 xread;
  output [NUMPRPT*BITRBNK-1:0]         xrbnk;
  output [NUMPRPT*BITVROW-1:0]         xradr;
  output [NUMPRPT*WIDTH-1:0]           xdin;
  input [NUMPRPT*WIDTH-1:0]            xdout;
  input [NUMPRPT-1:0]                  xdout_serr;
  input [NUMPRPT-1:0]                  xdout_derr;
  input [NUMPRPT*(BITPADR-BITPBNK-1)-1:0] xdout_padr;

  output                               ready;
  input                                clk;
  input                                rst;

  input [BITWDTH-1:0]                  select_bit;

  reg rate_limit;
  always @(posedge clk)
    if (rst)
      rate_limit <= 1'b0;
    else
      rate_limit <= !rate_limit;

  reg [BITVROW:0] rstaddr;
  reg [BITRBNK-1:0] rstrbnk;
  wire rstdone = (rstaddr == NUMVROW);
  wire rstvld = (!rate_limit || !REFRESH) && !rstdone;
  always @(posedge clk)
    if (rst) begin
      rstaddr <= 0;
      rstrbnk <= 0;
    end else if (rstvld) begin
      rstaddr <= (rstrbnk == NUMRBNK-1) ? rstaddr + 1 : rstaddr; 
      rstrbnk <= (rstrbnk == NUMRBNK-1) ? 0 : rstrbnk + 1;
    end
      
  reg rstdone_reg [0:SRAM_DELAY];
  integer rst_int;
  always @(posedge clk)
    for (rst_int=0; rst_int<SRAM_DELAY+1; rst_int=rst_int+1)
      if (rst_int>0)
        rstdone_reg[rst_int] <= rstdone_reg[rst_int-1];
      else
        rstdone_reg[rst_int] <= rstdone;

  reg ready;
  always @(posedge clk)
    ready <= rstdone && rstdone_reg[SRAM_DELAY];

  wire vrefr_wire;
  wire [BITRBNK-1:0] vrfrbnk_wire;
  wire [BITADDR-1:0] vrfaddr_wire;
  wire [BITVBNK-1:0] vrfbadr_wire;
  wire [BITVROW-1:0] vrfradr_wire;

  wire vread_wire [0:NUMVRPT-1];
  wire [BITRBNK-1:0] vrdrbnk_wire [0:NUMVRPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMVRPT-1];
  wire [BITVBNK-1:0] vrdbadr_wire [0:NUMVRPT-1];
  wire [BITVROW-1:0] vrdradr_wire [0:NUMVRPT-1];

  wire vwrite_wire;
  wire [BITRBNK-1:0] vwrrbnk_wire;
  wire [BITADDR-1:0] vwraddr_wire;
  wire [WIDTH-1:0] vdin_wire;
  wire [BITPBNK-1:0] vwrbadr_wire;
  wire [BITVROW-1:0] vwrradr_wire;

  genvar np2_int;
  generate begin: np2_loop
    assign vrefr_wire = vrefr;
    assign vrfrbnk_wire = vrfrbnk;
    assign vrfaddr_wire = vrfaddr;

    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
      rf_adr_inst (.vbadr(vrfbadr_wire), .vradr(vrfradr_wire), .vaddr(vrfaddr_wire));

    for (np2_int=0; np2_int<NUMVRPT; np2_int=np2_int+1) begin: rd_loop
      assign vread_wire[np2_int] = vread >> np2_int;
      assign vrdrbnk_wire[np2_int] = vrdrbnk >> (np2_int*BITRBNK);
      assign vrdaddr_wire[np2_int] = vrdaddr >> (np2_int*BITADDR);

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_int]), .vradr(vrdradr_wire[np2_int]), .vaddr(vrdaddr_wire[np2_int]));

    end

    assign vwrite_wire = vwrite;
    assign vwrrbnk_wire = vwrrbnk;
    assign vwraddr_wire = vwraddr;
    assign vdin_wire = vdin;

    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
      wr_adr_inst (.vbadr(vwrbadr_wire), .vradr(vwrradr_wire), .vaddr(vwraddr_wire));

  end
  endgenerate

  reg                vrefr_reg [0:SRAM_DELAY-1];
  reg [BITRBNK-1:0]  vrfrbnk_reg [0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  vrfbadr_reg [0:SRAM_DELAY-1];
  reg [BITVROW-1:0]  vrfradr_reg [0:SRAM_DELAY-1];
  reg                vread_reg [0:NUMVRPT-1][0:SRAM_DELAY-1];
  reg [BITRBNK-1:0]  vrdrbnk_reg [0:NUMVRPT-1][0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:NUMVRPT-1][0:SRAM_DELAY-1];
  reg [BITVROW-1:0]  vrdradr_reg [0:NUMVRPT-1][0:SRAM_DELAY-1];
  reg                vwrite_reg [0:SRAM_DELAY-1];
  reg [BITRBNK-1:0]  vwrrbnk_reg [0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  vwrbadr_reg [0:SRAM_DELAY-1];
  reg [BITVROW-1:0]  vwrradr_reg [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]    vdin_reg [0:SRAM_DELAY-1];
  
  integer vreg_int, vrpt_int;
  always @(posedge clk)
    for (vreg_int=0; vreg_int<SRAM_DELAY; vreg_int=vreg_int+1) 
      if (vreg_int>0) begin
        vrefr_reg[vreg_int] <= vrefr_reg[vreg_int-1];
        vrfrbnk_reg[vreg_int] <= vrfrbnk_reg[vreg_int-1];          
        vrfbadr_reg[vreg_int] <= vrfbadr_reg[vreg_int-1];
        vrfradr_reg[vreg_int] <= vrfradr_reg[vreg_int-1];          
        for (vrpt_int=0; vrpt_int<NUMVRPT; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_reg[vrpt_int][vreg_int-1];
          vrdrbnk_reg[vrpt_int][vreg_int] <= vrdrbnk_reg[vrpt_int][vreg_int-1];
          vrdbadr_reg[vrpt_int][vreg_int] <= vrdbadr_reg[vrpt_int][vreg_int-1];
          vrdradr_reg[vrpt_int][vreg_int] <= vrdradr_reg[vrpt_int][vreg_int-1];
        end
        vwrite_reg[vreg_int] <= vwrite_reg[vreg_int-1];
        vwrrbnk_reg[vreg_int] <= vwrrbnk_reg[vreg_int-1];          
        vwrbadr_reg[vreg_int] <= vwrbadr_reg[vreg_int-1];
        vwrradr_reg[vreg_int] <= vwrradr_reg[vreg_int-1];          
        vdin_reg[vreg_int] <= vdin_reg[vreg_int-1];
      end else begin
        vrefr_reg[vreg_int] <= vrefr_wire && ready;
        vrfrbnk_reg[vreg_int] <= vrfrbnk_wire;
        vrfbadr_reg[vreg_int] <= vrfbadr_wire;
        vrfradr_reg[vreg_int] <= vrfradr_wire;
        for (vrpt_int=0; vrpt_int<NUMVRPT; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_wire[vrpt_int] && ready;
          vrdrbnk_reg[vrpt_int][vreg_int] <= vrdrbnk_wire[vrpt_int];
          vrdbadr_reg[vrpt_int][vreg_int] <= vrdbadr_wire[vrpt_int];
          vrdradr_reg[vrpt_int][vreg_int] <= vrdradr_wire[vrpt_int];
        end
        vwrite_reg[vreg_int] <= vwrite_wire && ready;
        vwrrbnk_reg[vreg_int] <= vwrrbnk_wire;
        vwrbadr_reg[vreg_int] <= vwrbadr_wire;
        vwrradr_reg[vreg_int] <= vwrradr_wire;
        vdin_reg[vreg_int] <= vdin_wire;          
      end

  reg                vrefr_out;
  reg [BITRBNK-1:0]  vrfrbnk_out;
  reg [BITVBNK-1:0]  vrfbadr_out;
  reg [BITVROW-1:0]  vrfradr_out;
  reg                vread_out [0:NUMVRPT-1];
  reg [BITRBNK-1:0]  vrdrbnk_out [0:NUMVRPT-1];
  reg [BITVBNK-1:0]  vrdbadr_out [0:NUMVRPT-1];
  reg [BITVROW-1:0]  vrdradr_out [0:NUMVRPT-1];
  reg                vwrite_out;
  reg [BITRBNK-1:0]  vwrrbnk_out;
  reg [BITVBNK-1:0]  vwrbadr_out;
  reg [BITVROW-1:0]  vwrradr_out;
  reg [WIDTH-1:0]    vdin_out;
  integer vdel_int;
  always_comb begin
    vrefr_out = vrefr_reg[SRAM_DELAY-1];
    vrfrbnk_out = vrfrbnk_reg[SRAM_DELAY-1];
    vrfbadr_out = vrfbadr_reg[SRAM_DELAY-1];
    vrfradr_out = vrfradr_reg[SRAM_DELAY-1];
    for (vdel_int=0; vdel_int<NUMVRPT; vdel_int=vdel_int+1) begin
      vread_out[vdel_int] = vread_reg[vdel_int][SRAM_DELAY-1];
      vrdrbnk_out[vdel_int] = vrdrbnk_reg[vdel_int][SRAM_DELAY-1];
      vrdbadr_out[vdel_int] = vrdbadr_reg[vdel_int][SRAM_DELAY-1];
      vrdradr_out[vdel_int] = vrdradr_reg[vdel_int][SRAM_DELAY-1];
    end
    vwrite_out = vwrite_reg[SRAM_DELAY-1];
    vwrrbnk_out = vwrrbnk_reg[SRAM_DELAY-1];
    vwrbadr_out = vwrbadr_reg[SRAM_DELAY-1];
    vwrradr_out = vwrradr_reg[SRAM_DELAY-1];
    vdin_out = vdin_reg[SRAM_DELAY-1];
  end

  reg [3:0]          xorfifo_cnt;
  reg [BITRBNK-1:0]  xorfifo_rbnk [0:SRAM_DELAY];
  reg [BITVROW-1:0]  xorfifo_radr [0:SRAM_DELAY];
  reg [WIDTH-1:0]    xorfifo_data [0:SRAM_DELAY];

  reg [NUMVBNK-1:0] prefr;
  reg [NUMVBNK*BITRBNK-1:0] prfrbnk;
  always_comb begin
    prefr = 0;
    prfrbnk = 0;
    if (vrefr_wire && vread_wire[0] && (vrfbadr_wire == vrdbadr_wire[0]) && (vrfrbnk_wire == vrdrbnk_wire[0])) begin
      prefr = {NUMVBNK{1'b1}} & ~(1'b1 << vrfbadr_wire);
      prfrbnk = {NUMVBNK{vrfrbnk_wire}};
    end else if (vrefr_wire && vread_wire[1]) begin
      prefr = (1'b1 << vrfbadr_wire);
      prfrbnk = {NUMVBNK{vrfrbnk_wire}};
    end else if (vrefr_wire) begin
      prefr = {NUMVBNK{1'b1}};
      prfrbnk = {NUMVBNK{vrfrbnk_wire}};
    end
  end

  assign xrefr = vrefr;
  assign xrfbadr = 0;

  reg [NUMPRPT*NUMVBNK-1:0] pwrite;
  reg [NUMPRPT*NUMVBNK-1:0] pread;
  reg [NUMPRPT*NUMVBNK*BITRBNK-1:0] prbnk;
  reg [NUMPRPT*NUMVBNK*BITVROW-1:0] pradr;
  reg [NUMPRPT*NUMVBNK*WIDTH-1:0] pdin;
  reg [NUMPRPT-1:0] xwrite;
  reg [NUMPRPT-1:0] xread;
  reg [NUMPRPT*BITRBNK-1:0] xrbnk;
  reg [NUMPRPT*BITVROW-1:0] xradr;
  reg [NUMPRPT*WIDTH-1:0] xdin;
  reg [NUMPRPT-1:0] read_temp;
  reg [NUMPRPT*BITRBNK-1:0] rbnk_temp;
  reg [NUMPRPT*BITVROW-1:0] radr_temp;
  wire [WIDTH-1:0] pdin_temp = vdin;
  integer prd_int;
  always_comb begin
    read_temp = 0;
    rbnk_temp = 0;
    radr_temp = 0;
    pwrite = 0;
    pread = 0;
    prbnk = 0;
    pradr = 0;
    pdin = 0;
    xwrite = 0;
    xread = 0;
    xrbnk = 0;
    xradr = 0;
    xdin = 0;
    if (rstvld) begin
      pwrite = {NUMPRPT*NUMVBNK{1'b1}};
      prbnk = {NUMPRPT*NUMVBNK{rstrbnk}}; 
      pradr = {NUMPRPT*NUMVBNK{rstaddr[BITVROW-1:0]}}; 
      xwrite = {NUMPRPT{|xorfifo_cnt}};
      xrbnk = {NUMPRPT{xorfifo_rbnk[0]}};
      xradr = {NUMPRPT{xorfifo_radr[0]}};
      xdin = {NUMPRPT{xorfifo_data[0]}}; 
    end else if (vwrite) begin
      pwrite = {NUMPRPT{1'b1}} << (vwrbadr_wire*NUMPRPT);
      pread = {NUMPRPT*NUMVBNK{1'b1}} & ~({NUMPRPT{1'b1}} << (vwrbadr_wire*NUMPRPT));
      prbnk = {NUMPRPT*NUMVBNK{vwrrbnk_wire}};
      pradr = {NUMPRPT*NUMVBNK{vwrradr_wire}};
      pdin = {NUMPRPT*NUMVBNK{pdin_temp}}; 
      xwrite = {NUMPRPT{|xorfifo_cnt}};
      xrbnk = {NUMPRPT{xorfifo_rbnk[0]}};
      xradr = {NUMPRPT{xorfifo_radr[0]}};
      xdin = {NUMPRPT{xorfifo_data[0]}}; 
    end else begin
      for (prd_int=0; prd_int<NUMVRPT; prd_int=prd_int+1)
        if (prd_int[0]==0) begin
	  if (vread_wire[prd_int]) begin
          pread = pread | (vread_wire[prd_int] << (vrdbadr_wire[prd_int]*NUMPRPT+(prd_int>>1)));
          prbnk = prbnk | (vrdrbnk_wire[prd_int] << ((vrdbadr_wire[prd_int]*NUMPRPT+(prd_int>>1))*BITRBNK));
          pradr = pradr | (vrdradr_wire[prd_int] << ((vrdbadr_wire[prd_int]*NUMPRPT+(prd_int>>1))*BITVROW));
          end
        end else if ((vread_wire[prd_int-1] && vread_wire[prd_int] && (vrdbadr_wire[prd_int-1] == vrdbadr_wire[prd_int])) ||
                     (vrefr_wire && vread_wire[prd_int] && (vrfbadr_wire == vrdbadr_wire[prd_int]) && (vrfrbnk_wire == vrdrbnk_wire[prd_int]))) begin
          read_temp = 1'b1 << (prd_int>>1); 
          rbnk_temp = vrdrbnk_wire[prd_int] << ((prd_int>>1)*BITRBNK);
          radr_temp = vrdradr_wire[prd_int] << ((prd_int>>1)*BITVROW);
          pread = pread | ({NUMVBNK{read_temp}} & ~({NUMPRPT{1'b1}} << (vrdbadr_wire[prd_int]*NUMPRPT)));
          prbnk = prbnk | ({NUMVBNK{rbnk_temp}} & ~({NUMPRPT*BITRBNK{1'b1}} << (vrdbadr_wire[prd_int]*NUMPRPT*BITRBNK)));
          pradr = pradr | ({NUMVBNK{radr_temp}} & ~({NUMPRPT*BITVROW{1'b1}} << (vrdbadr_wire[prd_int]*NUMPRPT*BITVROW)));
	  xread = xread | read_temp;
	  xrbnk = xrbnk | rbnk_temp;
	  xradr = xradr | radr_temp;
        end else begin
	  if (vread_wire[prd_int]) begin
          pread = pread | (vread_wire[prd_int] << (vrdbadr_wire[prd_int]*NUMPRPT+(prd_int>>1)));
          prbnk = prbnk | (vrdrbnk_wire[prd_int] << ((vrdbadr_wire[prd_int]*NUMPRPT+(prd_int>>1))*BITRBNK));
          pradr = pradr | (vrdradr_wire[prd_int] << ((vrdbadr_wire[prd_int]*NUMPRPT+(prd_int>>1))*BITVROW));
          end
        end
      if (!(|xread || (REFRESH && vrefr))) begin
        xwrite = {NUMPRPT{|xorfifo_cnt}};
        xrbnk = {NUMPRPT{xorfifo_rbnk[0]}};
        xradr = {NUMPRPT{xorfifo_radr[0]}};
        xdin = {NUMPRPT{xorfifo_data[0]}}; 
      end
    end
  end   

  reg [WIDTH-1:0] xdout_wire [0:NUMPRPT-1];
  reg             xdout_serr_wire [0:NUMPRPT-1];
  reg             xdout_derr_wire [0:NUMPRPT-1];
  reg [BITPADR-BITPBNK-2:0] xdout_padr_wire [0:NUMPRPT-1];
  reg [WIDTH-1:0] pdout_wire [0:NUMPRPT-1][0:NUMVBNK-1];
  reg               pdout_serr_wire [0:NUMPRPT-1][0:NUMVBNK-1];
  reg               pdout_derr_wire [0:NUMPRPT-1][0:NUMVBNK-1];
  reg [BITPADR-BITPBNK-2:0] pdout_padr_wire [0:NUMPRPT-1][0:NUMVBNK-1];
  integer rerr_int, berr_int;
  always_comb
    for (rerr_int=0; rerr_int<NUMPRPT; rerr_int=rerr_int+1) begin
      xdout_wire[rerr_int] = xdout >> (rerr_int*WIDTH);
      xdout_serr_wire[rerr_int] = xdout_serr >> rerr_int;
      xdout_derr_wire[rerr_int] = xdout_derr >> rerr_int;
      xdout_padr_wire[rerr_int] = xdout_padr >> (rerr_int*(BITPADR-BITPBNK-1));
      for (berr_int=0; berr_int<NUMVBNK; berr_int=berr_int+1) begin
        pdout_wire[rerr_int][berr_int] = pdout >> ((NUMPRPT*berr_int+rerr_int)*WIDTH);
        pdout_serr_wire[rerr_int][berr_int] = pdout_serr >> (NUMPRPT*berr_int+rerr_int);
        pdout_derr_wire[rerr_int][berr_int] = pdout_derr >> (NUMPRPT*berr_int+rerr_int);
        pdout_padr_wire[rerr_int][berr_int] = pdout_padr >> ((NUMPRPT*berr_int+rerr_int)*(BITPADR-BITPBNK-1));
      end
    end

  wire               xwrite_req;
  wire [BITRBNK-1:0] xwrrbnk_req;
  wire [BITVROW-1:0] xwrradr_req;
  reg [WIDTH-1:0]    xdin_req;
  reg                xserr_req;
  
  reg             xrd_srch_flag [0:NUMPRPT-1];
  reg [WIDTH-1:0] xrd_srch_data [0:NUMPRPT-1];
  reg             xrd_srch_dbit [0:NUMPRPT-1];
  integer rsrc_int, xsrc_int;
  always_comb 
    for (rsrc_int=0; rsrc_int<NUMPRPT; rsrc_int=rsrc_int+1) begin
      xrd_srch_flag[rsrc_int] = 1'b0;
      xrd_srch_data[rsrc_int] = 0;
      for (xsrc_int=0; xsrc_int<SRAM_DELAY+1; xsrc_int=xsrc_int+1)
        if ((xorfifo_cnt > xsrc_int) && (xorfifo_rbnk[xsrc_int] == vrdrbnk_reg[2*rsrc_int+1][0]) && (xorfifo_radr[xsrc_int] == vrdradr_reg[2*rsrc_int+1][0])) begin
          xrd_srch_flag[rsrc_int] = 1'b1;
          xrd_srch_data[rsrc_int] = xorfifo_data[xsrc_int];
        end
      xrd_srch_dbit[rsrc_int] = xrd_srch_data[rsrc_int][select_bit];
    end

  reg              xrd_fwd_vld [0:NUMPRPT-1][1:SRAM_DELAY-1];
  reg [WIDTH-1:0]  xrd_fwd_reg [0:NUMPRPT-1][1:SRAM_DELAY-1];
  integer rrdf_int, xrdf_int;
  always @(posedge clk)
    for (rrdf_int=0; rrdf_int<NUMPRPT; rrdf_int=rrdf_int+1)
      for (xrdf_int=1; xrdf_int<SRAM_DELAY; xrdf_int=xrdf_int+1)
        if (xrdf_int>1)
          if (xwrite_req && (xwrrbnk_req == vrdrbnk_reg[2*rrdf_int+1][xrdf_int-1]) && (xwrradr_req == vrdradr_reg[2*rrdf_int+1][xrdf_int-1])) begin
            xrd_fwd_vld[rrdf_int][xrdf_int] <= 1'b1;
            xrd_fwd_reg[rrdf_int][xrdf_int] <= xdin_req;
          end else begin
            xrd_fwd_vld[rrdf_int][xrdf_int] <= xrd_fwd_vld[rrdf_int][xrdf_int-1];
            xrd_fwd_reg[rrdf_int][xrdf_int] <= xrd_fwd_reg[rrdf_int][xrdf_int-1];
          end
        else
          if (xwrite_req && (xwrrbnk_req == vrdrbnk_reg[2*rrdf_int+1][0]) &&  (xwrradr_req == vrdradr_reg[2*rrdf_int+1][0])) begin
            xrd_fwd_vld[rrdf_int][xrdf_int] <= 1'b1;
            xrd_fwd_reg[rrdf_int][xrdf_int] <= xdin_req;
          end else begin
            xrd_fwd_vld[rrdf_int][xrdf_int] <= xrd_srch_flag[rrdf_int];
            xrd_fwd_reg[rrdf_int][xrdf_int] <= xrd_srch_data[rrdf_int];
          end

  reg [WIDTH-1:0] xor_data [0:NUMPRPT-1];
  reg xor_fwd_data [0:NUMPRPT-1];
  integer rxdt_int;
  always_comb
    for (rxdt_int=0; rxdt_int<NUMPRPT; rxdt_int=rxdt_int+1)
      if (SRAM_DELAY>1) begin
        xor_data[rxdt_int] = xrd_fwd_vld[rxdt_int][SRAM_DELAY-1] ? xrd_fwd_reg[rxdt_int][SRAM_DELAY-1] : xdout_wire[rxdt_int];
        xor_fwd_data[rxdt_int] = xrd_fwd_vld[rxdt_int][SRAM_DELAY-1];
      end else begin
        xor_data[rxdt_int] = xrd_srch_flag[rxdt_int] ? xrd_srch_data[rxdt_int] : xdout_wire[rxdt_int];
        xor_fwd_data[rxdt_int] = xrd_srch_flag[rxdt_int];
      end

  assign xwrite_req = rstvld || vwrite_out;
  assign xwrrbnk_req = rstvld ? rstrbnk : vwrrbnk_out;
  assign xwrradr_req = rstvld ? rstaddr : vwrradr_out;
  integer xwr_int;
  always_comb begin
    xdin_req = 0;
    xserr_req = 0;
    if (!rstvld) begin
      for (xwr_int=0; xwr_int<NUMVBNK; xwr_int=xwr_int+1)
        if (vwrbadr_out != xwr_int) begin
          xdin_req = xdin_req ^ pdout_wire[0][xwr_int];
          xserr_req = xserr_req || pdout_serr_wire[0][xwr_int];
        end else begin
          xdin_req = xdin_req ^ vdin_out;
          xserr_req = xserr_req;
        end
    end
  end


  wire xorfifo_deq = (!xread && ((REFRESH==0) || !vrefr) && |xorfifo_cnt);
  always @(posedge clk) 
    if (rst)
      xorfifo_cnt <= 0;
    else
      xorfifo_cnt <= xorfifo_cnt + xwrite_req - xorfifo_deq;

  integer xfifo_int;
  always @(posedge clk)
    for (xfifo_int=0; xfifo_int<SRAM_DELAY+1; xfifo_int=xfifo_int+1)
      if (xwrite_req && (xorfifo_cnt == (xorfifo_deq+xfifo_int))) begin
        xorfifo_rbnk[xfifo_int] <= xwrrbnk_req;
        xorfifo_radr[xfifo_int] <= xwrradr_req;
        xorfifo_data[xfifo_int] <= xdin_req;
      end else if (xfifo_int<SRAM_DELAY) 
	if (xorfifo_deq) begin
          xorfifo_rbnk[xfifo_int] <= xorfifo_rbnk[xfifo_int+1];
          xorfifo_radr[xfifo_int] <= xorfifo_radr[xfifo_int+1];
          xorfifo_data[xfifo_int] <= xorfifo_data[xfifo_int+1];
	end

  reg               vread_vld_wire [0:NUMVRPT-1];
  reg [WIDTH-1:0]   vdout_wire [0:NUMVRPT-1];
  reg               vread_serr_wire [0:NUMVRPT-1];
  reg               vread_derr_wire [0:NUMVRPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:NUMVRPT-1];

  reg [WIDTH-1:0]           pdout_temp;
  reg                       pdout_serr_temp;
  reg                       pdout_derr_temp;
  reg [BITPADR-BITPBNK-2:0] pdout_padr_temp;
  integer vrd_int, vxor_int;
  always_comb begin
    for (vrd_int=0; vrd_int<NUMVRPT; vrd_int=vrd_int+1) begin
      vread_vld_wire[vrd_int] = vread_out[vrd_int];
      vdout_wire[vrd_int] = 0;
      vread_serr_wire[vrd_int] = 0;
      vread_derr_wire[vrd_int] = 0;
      vread_padr_wire[vrd_int] = 0;
    end
    for (vrd_int=0; vrd_int<NUMVRPT; vrd_int=vrd_int+1) 
      if (vrd_int[0]==0) begin
        pdout_temp = pdout_wire[vrd_int>>1][vrdbadr_out[vrd_int]];
        pdout_serr_temp = pdout_serr_wire[vrd_int>>1][vrdbadr_out[vrd_int]];
        pdout_derr_temp = pdout_derr_wire[vrd_int>>1][vrdbadr_out[vrd_int]];
        pdout_padr_temp = pdout_padr_wire[vrd_int>>1][vrdbadr_out[vrd_int]]; 
        vdout_wire[vrd_int] = pdout_temp;
	vread_derr_wire[vrd_int] = vread_derr_wire[vrd_int] || (vread_vld_wire[vrd_int] && (pdout_derr_temp || (vread_serr_wire[vrd_int] && pdout_serr_temp)));
        vread_serr_wire[vrd_int] = vread_vld_wire[vrd_int] && pdout_serr_temp;
        vread_padr_wire[vrd_int] = {vrdbadr_out[vrd_int],pdout_padr_temp};
      end else if (vread_out[vrd_int-1] && vread_out[vrd_int] && (vrdbadr_out[vrd_int-1] == vrdbadr_out[vrd_int]) ||
                   (vrefr_out && vread_out[vrd_int] && (vrfbadr_out == vrdbadr_out[vrd_int]) && (vrfrbnk_out == vrdrbnk_out[vrd_int]))) begin
        vread_padr_wire[vrd_int] = xor_fwd_data[vrd_int>>1] ? ~0 : {NUMVBNK,xdout_padr_wire[vrd_int>>1]};
        for (vxor_int=NUMVBNK; vxor_int>=0; vxor_int=vxor_int-1) begin
          if (vxor_int==NUMVBNK) begin
            pdout_temp = xor_data[vrd_int>>1];
            pdout_serr_temp = xdout_serr_wire[vrd_int>>1];
            pdout_derr_temp = xdout_derr_wire[vrd_int>>1];
            pdout_padr_temp = xdout_padr_wire[vrd_int>>1]; 
          end else if (vrdbadr_out[vrd_int] != vxor_int) begin
            pdout_temp = pdout_wire[vrd_int>>1][vxor_int];
            pdout_serr_temp = pdout_serr_wire[vrd_int>>1][vxor_int];
            pdout_derr_temp = pdout_derr_wire[vrd_int>>1][vxor_int];
            pdout_padr_temp = pdout_padr_wire[vrd_int>>1][vxor_int]; 
          end else begin
            pdout_temp = 0;
	    pdout_serr_temp = 0;
	    pdout_derr_temp = 0;
	    pdout_padr_temp = 0;
          end
          vdout_wire[vrd_int] = vdout_wire[vrd_int] ^ pdout_temp;
	  vread_derr_wire[vrd_int] = vread_derr_wire[vrd_int] || (vread_vld_wire[vrd_int] && (pdout_derr_temp || (vread_serr_wire[vrd_int] && pdout_serr_temp)));
          vread_serr_wire[vrd_int] = vread_serr_wire[vrd_int] || (vread_vld_wire[vrd_int] && pdout_serr_temp);
          if (pdout_serr_temp)
            vread_padr_wire[vrd_int] = {vxor_int,pdout_padr_temp};
        end
      end else begin
        pdout_temp = pdout_wire[vrd_int>>1][vrdbadr_out[vrd_int]];
        pdout_serr_temp = pdout_serr_wire[vrd_int>>1][vrdbadr_out[vrd_int]];
        pdout_derr_temp = pdout_derr_wire[vrd_int>>1][vrdbadr_out[vrd_int]];
        pdout_padr_temp = pdout_padr_wire[vrd_int>>1][vrdbadr_out[vrd_int]]; 
        vdout_wire[vrd_int] = pdout_temp;
	vread_derr_wire[vrd_int] = vread_derr_wire[vrd_int] || (vread_vld_wire[vrd_int] && (pdout_derr_temp || (vread_serr_wire[vrd_int] && pdout_serr_temp)));
        vread_serr_wire[vrd_int] = vread_vld_wire[vrd_int] && pdout_serr_temp;
        vread_padr_wire[vrd_int] = {vrdbadr_out[vrd_int],pdout_padr_temp};
      end
  end

  reg [NUMVRPT-1:0]         vread_vld_tmp;
  reg [NUMVRPT*WIDTH-1:0]   vdout_tmp;
  reg [NUMVRPT-1:0]         vread_serr_tmp;
  reg [NUMVRPT-1:0]         vread_derr_tmp;
  reg [NUMVRPT*BITPADR-1:0] vread_padr_tmp;
  integer vwire_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    for (vwire_int=0; vwire_int<NUMVRPT; vwire_int=vwire_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_out[vwire_int] << vwire_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vwire_int] << (vwire_int*WIDTH));
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vwire_int] << vwire_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vwire_int] << vwire_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vwire_int] << (vwire_int*BITPADR));
    end
  end

  reg [NUMVRPT-1:0]         vread_vld;
  reg [NUMVRPT*WIDTH-1:0]   vdout;
  reg [NUMVRPT-1:0]         vread_serr;
  reg [NUMVRPT-1:0]         vread_derr;
  reg [NUMVRPT*BITPADR-1:0] vread_padr;

  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      vread_vld <= vread_vld_tmp;
      vdout <= vdout_tmp;
      vread_serr <= vread_serr_tmp;
      vread_derr <= vread_derr_tmp;
      vread_padr <= vread_padr_tmp;
    end
  end else begin: nflp_loop
    always_comb begin
      vread_vld = vread_vld_tmp;
      vdout = vdout_tmp;
      vread_serr = vread_serr_tmp;
      vread_derr = vread_derr_tmp;
      vread_padr = vread_padr_tmp;
    end
  end
  endgenerate

endmodule
