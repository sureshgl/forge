module core_nr1w_2rw (vwrite1, vread1, vaddr1, vdin1, vdout1, vread1_serr, vread1_derr, vread1_padr,
                      vread2, vaddr2, vread2_vld, vdout2, vread2_serr, vread2_derr, vread2_padr,
                      pwrite1, pread1, pradr1, pdin1, pdout1, pdout1_serr, pdout1_derr, pdout1_padr,
                      pwrite2, pread2, pradr2, pdin2, pdout2, pdout2_serr, pdout2_derr, pdout2_padr,
                      xwrite1, xread1, xradr1, xdin1, xdout1, xdout1_serr, xdout1_derr, xdout1_padr,
                      xwrite2, xread2, xradr2, xdin2, xdout2, xdout2_serr, xdout2_derr, xdout2_padr,
	              ready, clk, rst,
	              select_addr, select_bit);
 
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

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input                                vwrite1;
  input                                vread1;
  input [BITADDR-1:0]                  vaddr1;
  input [WIDTH-1:0]                    vdin1;
  output [WIDTH-1:0]                   vdout1;
  output                               vread1_serr;
  output                               vread1_derr;
  output [BITPADR-1:0]                 vread1_padr;
  
  input [NUMVRPT-1:0]                  vread2;
  input [NUMVRPT*BITADDR-1:0]          vaddr2;
  output [NUMVRPT-1:0]                 vread2_vld;
  output [NUMVRPT*WIDTH-1:0]           vdout2;
  output [NUMVRPT-1:0]                 vread2_serr;
  output [NUMVRPT-1:0]                 vread2_derr;
  output [NUMVRPT*BITPADR-1:0]         vread2_padr;

  output [NUMPRPT*NUMVBNK-1:0]         pwrite1;
  output [NUMPRPT*NUMVBNK-1:0]         pread1;
  output [NUMPRPT*NUMVBNK*BITVROW-1:0] pradr1;
  output [NUMPRPT*NUMVBNK*WIDTH-1:0]   pdin1;
  input [NUMPRPT*NUMVBNK*WIDTH-1:0]    pdout1;
  input [NUMPRPT*NUMVBNK-1:0]          pdout1_serr;
  input [NUMPRPT*NUMVBNK-1:0]          pdout1_derr;
  input [NUMPRPT*NUMVBNK*(BITPADR-BITPBNK-1)-1:0] pdout1_padr;
  
  output [NUMPRPT*NUMVBNK-1:0]         pwrite2;
  output [NUMPRPT*NUMVBNK-1:0]         pread2;
  output [NUMPRPT*NUMVBNK*BITVROW-1:0] pradr2;
  output [NUMPRPT*NUMVBNK*WIDTH-1:0]   pdin2;
  input [NUMPRPT*NUMVBNK*WIDTH-1:0]    pdout2;
  input [NUMPRPT*NUMVBNK-1:0]          pdout2_serr;
  input [NUMPRPT*NUMVBNK-1:0]          pdout2_derr;
  input [NUMPRPT*NUMVBNK*(BITPADR-BITPBNK-1)-1:0] pdout2_padr;

  output [NUMPRPT-1:0]                 xwrite1;
  output [NUMPRPT-1:0]                 xread1;
  output [NUMPRPT*BITVROW-1:0]         xradr1;
  output [NUMPRPT*WIDTH-1:0]           xdin1;
  input [NUMPRPT*WIDTH-1:0]            xdout1;
  input [NUMPRPT-1:0]                  xdout1_serr;
  input [NUMPRPT-1:0]                  xdout1_derr;
  input [NUMPRPT*(BITPADR-BITPBNK-1)-1:0] xdout1_padr;

  output [NUMPRPT-1:0]                 xwrite2;
  output [NUMPRPT-1:0]                 xread2;
  output [NUMPRPT*BITVROW-1:0]         xradr2;
  output [NUMPRPT*WIDTH-1:0]           xdin2;
  input [NUMPRPT*WIDTH-1:0]            xdout2;
  input [NUMPRPT-1:0]                  xdout2_serr;
  input [NUMPRPT-1:0]                  xdout2_derr;
  input [NUMPRPT*(BITPADR-BITPBNK-1)-1:0] xdout2_padr;

  output                               ready;
  input                                clk;
  input                                rst;

  input [BITADDR-1:0]                  select_addr;
  input [BITWDTH-1:0]                  select_bit;

  reg [BITVROW:0] rstaddr;
  wire rstdone = (rstaddr == NUMVROW);
  wire rstvld = !rstdone;
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;
      
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

  wire [BITVBNK-1:0] select_bank;
  wire [BITVROW-1:0] select_row;
  np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
             .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
             .NUMVROW (NUMVROW), .BITVROW (BITVROW))
    sel_adr (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));

  wire ready_wire;

  wire vwrite1_wire;
  wire vread1_wire;
  wire [BITADDR-1:0] vaddr1_wire;
  wire [WIDTH-1:0] vdin1_wire;
  wire [BITPBNK-1:0] vbadr1_wire;
  wire [BITVROW-1:0] vradr1_wire;

  wire vread2_wire [0:NUMVRPT-1];
  wire [BITADDR-1:0] vaddr2_wire [0:NUMVRPT-1];
  wire [BITVBNK-1:0] vbadr2_wire [0:NUMVRPT-1];
  wire [BITVROW-1:0] vradr2_wire [0:NUMVRPT-1];

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg vread1_reg;
    reg vwrite1_reg;
    reg [BITADDR-1:0] vaddr1_reg;
    reg [WIDTH-1:0] vdin1_reg;
    reg [NUMVRPT-1:0] vread2_reg;
    reg [NUMVRPT*BITADDR-1:0] vaddr2_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread1_reg <= vread1 && ready;
      vwrite1_reg <= vwrite1 && ready;
      vaddr1_reg <= vaddr1;
      vdin1_reg <= vdin1;
      vread2_reg <= vread2 & {NUMVRPT{ready}};
      vaddr2_reg <= vaddr2;
    end

    assign ready_wire = ready_reg;
    for (np2_var=0; np2_var<NUMVRPT; np2_var=np2_var+1) begin: rd_loop
      assign vread2_wire[np2_var] = vread2_reg >> np2_var;
      assign vaddr2_wire[np2_var] = vaddr2_reg >> (np2_var*BITADDR);
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vbadr2_wire[np2_var]), .vradr(vradr2_wire[np2_var]), .vaddr(vaddr2_wire[np2_var]));
    end

    assign vwrite1_wire = vwrite1_reg && ready_reg;
    assign vread1_wire = vread1_reg;
    assign vaddr1_wire = vaddr1_reg;
    assign vdin1_wire = vdin1_reg;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
      rw_adr_inst (.vbadr(vbadr1_wire), .vradr(vradr1_wire), .vaddr(vaddr1_wire));
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (np2_var=0; np2_var<NUMVRPT; np2_var=np2_var+1) begin: rd_loop
      assign vread2_wire[np2_var] = vread2 >> np2_var;
      assign vaddr2_wire[np2_var] = vaddr2 >> (np2_var*BITADDR);
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vbadr2_wire[np2_var]), .vradr(vradr2_wire[np2_var]), .vaddr(vaddr2_wire[np2_var]));
    end

    assign vwrite1_wire = vwrite1 && ready;
    assign vread1_wire = vread1;
    assign vaddr1_wire = vaddr1;
    assign vdin1_wire = vdin1;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK), .BITPBNK (BITPBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
      rw_adr_inst (.vbadr(vbadr1_wire), .vradr(vradr1_wire), .vaddr(vaddr1_wire));
  end
  endgenerate

  reg                vread2_reg [0:NUMVRPT-1][0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  vbadr2_reg [0:NUMVRPT-1][0:SRAM_DELAY-1];
  reg [BITVROW-1:0]  vradr2_reg [0:NUMVRPT-1][0:SRAM_DELAY-1];
  reg                vwrite1_reg [0:SRAM_DELAY-1];
  reg                vread1_reg [0:SRAM_DELAY-1];
  reg [BITPBNK-1:0]  vbadr1_reg [0:SRAM_DELAY-1];
  reg [BITVROW-1:0]  vradr1_reg [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]    vdin1_reg [0:SRAM_DELAY-1];
  
  integer vreg_int, vrpt_int;
  always @(posedge clk)
    for (vreg_int=0; vreg_int<SRAM_DELAY; vreg_int=vreg_int+1) 
      if (vreg_int>0) begin
        for (vrpt_int=0; vrpt_int<NUMVRPT; vrpt_int=vrpt_int+1) begin 
          vread2_reg[vrpt_int][vreg_int] <= vread2_reg[vrpt_int][vreg_int-1];
          vbadr2_reg[vrpt_int][vreg_int] <= vbadr2_reg[vrpt_int][vreg_int-1];
          vradr2_reg[vrpt_int][vreg_int] <= vradr2_reg[vrpt_int][vreg_int-1];
        end
        vwrite1_reg[vreg_int] <= vwrite1_reg[vreg_int-1];
        vread1_reg[vreg_int] <= vread1_reg[vreg_int-1];
        vbadr1_reg[vreg_int] <= vbadr1_reg[vreg_int-1];
        vradr1_reg[vreg_int] <= vradr1_reg[vreg_int-1];          
        vdin1_reg[vreg_int] <= vdin1_reg[vreg_int-1];
      end else begin
        for (vrpt_int=0; vrpt_int<NUMVRPT; vrpt_int=vrpt_int+1) begin 
          vread2_reg[vrpt_int][vreg_int] <= vread2_wire[vrpt_int] && ready_wire;
          vbadr2_reg[vrpt_int][vreg_int] <= vbadr2_wire[vrpt_int];
          vradr2_reg[vrpt_int][vreg_int] <= vradr2_wire[vrpt_int];
        end
        vwrite1_reg[vreg_int] <= vwrite1_wire && ready_wire;
        vread1_reg[vreg_int] <= vread1_wire && ready_wire;
        vbadr1_reg[vreg_int] <= vbadr1_wire;
        vradr1_reg[vreg_int] <= vradr1_wire;
        vdin1_reg[vreg_int] <= vdin1_wire;          
      end

  reg                vread2_out [0:NUMVRPT-1];
  reg [BITVBNK-1:0]  vbadr2_out [0:NUMVRPT-1];
  reg [BITVROW-1:0]  vradr2_out [0:NUMVRPT-1];
  reg                vwrite1_out;
  reg                vread1_out;
  reg [BITPBNK-1:0]  vbadr1_out;
  reg [BITVROW-1:0]  vradr1_out;
  reg [WIDTH-1:0]    vdin1_out;
  integer vdel_int;
  always_comb begin
    for (vdel_int=0; vdel_int<NUMVRPT; vdel_int=vdel_int+1) begin
      vread2_out[vdel_int] = vread2_reg[vdel_int][SRAM_DELAY-1];
      vbadr2_out[vdel_int] = vbadr2_reg[vdel_int][SRAM_DELAY-1];
      vradr2_out[vdel_int] = vradr2_reg[vdel_int][SRAM_DELAY-1];
    end
    vwrite1_out = vwrite1_reg[SRAM_DELAY-1];
    vread1_out = vread1_reg[SRAM_DELAY-1];
    vbadr1_out = vbadr1_reg[SRAM_DELAY-1];
    vradr1_out = vradr1_reg[SRAM_DELAY-1];
    vdin1_out = vdin1_reg[SRAM_DELAY-1];
  end

  reg [NUMPRPT*NUMVBNK-1:0] pwrite1;
  reg [NUMPRPT*NUMVBNK-1:0] pread1;
  reg [NUMPRPT*NUMVBNK*BITVROW-1:0] pradr1;
  reg [NUMPRPT*NUMVBNK*WIDTH-1:0] pdin1;
  always_comb begin
    pwrite1 = 0;
    pread1 = 0;
    pradr1 = 0;
    pdin1 = 0;
    if (!rst) begin
      if (rstvld) begin
        pwrite1 = {NUMPRPT*NUMVBNK{1'b1}};
        pradr1 = {NUMPRPT*NUMVBNK{rstaddr[BITVROW-1:0]}}; 
      end else if (vwrite1_wire) begin
        pwrite1 = {NUMPRPT{1'b1}} << (vbadr1_wire*NUMPRPT);
        pread1 = {NUMPRPT*NUMVBNK{1'b1}} & ~({NUMPRPT{1'b1}} << (vbadr1_wire*NUMPRPT));
        pradr1 = {NUMPRPT*NUMVBNK{vradr1_wire}};
        pdin1 = {NUMPRPT*NUMVBNK{vdin1_wire}}; 
      end else if (vread1_wire) begin
        pread1 = {NUMPRPT{1'b1}} << (vbadr1_wire*NUMPRPT);
        pradr1 = {NUMPRPT*NUMVBNK{vradr1_wire}};
      end
    end
  end   

  reg [NUMPRPT*NUMVBNK-1:0] pwrite2;
  reg [NUMPRPT*NUMVBNK-1:0] pread2;
  reg [NUMPRPT*NUMVBNK*BITVROW-1:0] pradr2;
  reg [NUMPRPT-1:0] read_temp;
  reg [NUMPRPT*BITVROW-1:0] radr_temp;
  integer prd_int;
  always_comb begin
    read_temp = 0;
    radr_temp = 0;
    pwrite2 = 0;
    pread2 = 0;
    pradr2 = 0;
    for (prd_int=0; prd_int<NUMVRPT; prd_int=prd_int+1)
      if (prd_int[0]==0) begin
        if (vread2_wire[prd_int]) begin
          pread2 = pread2 | (vread2_wire[prd_int] << (vbadr2_wire[prd_int]*NUMPRPT+(prd_int>>1)));
          pradr2 = pradr2 | (vradr2_wire[prd_int] << ((vbadr2_wire[prd_int]*NUMPRPT+(prd_int>>1))*BITVROW));
        end
      end else if (vread2_wire[prd_int-1] && vread2_wire[prd_int] && (vbadr2_wire[prd_int-1] == vbadr2_wire[prd_int])) begin
        read_temp = 1'b1 << (prd_int>>1); 
        radr_temp = vradr2_wire[prd_int] << ((prd_int>>1)*BITVROW);
        pread2 = pread2 | ({NUMVBNK{read_temp}} & ~({NUMPRPT{1'b1}} << (vbadr2_wire[prd_int]*NUMPRPT)));
        pradr2 = pradr2 | ({NUMVBNK{radr_temp}} & ~({NUMPRPT*BITVROW{1'b1}} << (vbadr2_wire[prd_int]*NUMPRPT*BITVROW)));
      end else if (vread2_wire[prd_int]) begin
        pread2 = pread2 | (vread2_wire[prd_int] << (vbadr2_wire[prd_int]*NUMPRPT+(prd_int>>1)));
        pradr2 = pradr2 | (vradr2_wire[prd_int] << ((vbadr2_wire[prd_int]*NUMPRPT+(prd_int>>1))*BITVROW));
      end
  end   

  wire               xwrite_req;
  wire [BITVROW-1:0] xwrradr_req;
  reg [WIDTH-1:0]    xdin_req;
  reg                xserr_req;
  
  reg [NUMPRPT-1:0] xwrite1;
  reg [NUMPRPT-1:0] xread1;
  reg [NUMPRPT*BITVROW-1:0] xradr1;
  reg [NUMPRPT*WIDTH-1:0] xdin1;
  always_comb begin
    xwrite1 = {NUMPRPT{xwrite_req}};
    xread1 = 0;
    xradr1 = {NUMPRPT{xwrradr_req}};
    xdin1 = {NUMPRPT{xdin_req}};
  end   

  reg [NUMPRPT-1:0] xwrite2;
  reg [NUMPRPT-1:0] xread2;
  reg [NUMPRPT*BITVROW-1:0] xradr2;
  reg [NUMPRPT-1:0] xread_temp;
  reg [NUMPRPT*BITVROW-1:0] xradr_temp;
  integer xrd_int;
  always_comb begin
    xread_temp = 0;
    xradr_temp = 0;
    xwrite2 = 0;
    xread2 = 0;
    xradr2 = 0;
    for (xrd_int=1; xrd_int<NUMVRPT; xrd_int=xrd_int+2) begin
      if (vread2_wire[xrd_int-1] && vread2_wire[xrd_int] && (vbadr2_wire[xrd_int-1] == vbadr2_wire[xrd_int]) && ready_wire)
        xread_temp = 1'b1 << (xrd_int>>1); 
      else
        xread_temp = 0;
      xradr_temp = vradr2_wire[xrd_int] << ((xrd_int>>1)*BITVROW);
      xread2 = xread2 | xread_temp;
      xradr2 = xradr2 | xradr_temp;
    end
  end   

  reg [WIDTH-1:0] pdout1_wire [0:NUMPRPT-1][0:NUMVBNK-1];
  reg             pdout1_serr_wire [0:NUMPRPT-1][0:NUMVBNK-1];
  reg             pdout1_derr_wire [0:NUMPRPT-1][0:NUMVBNK-1];
  reg [BITPADR-BITPBNK-2:0] pdout1_padr_wire [0:NUMPRPT-1][0:NUMVBNK-1];
  reg [WIDTH-1:0] pdout2_wire [0:NUMPRPT-1][0:NUMVBNK-1];
  reg             pdout2_serr_wire [0:NUMPRPT-1][0:NUMVBNK-1];
  reg             pdout2_derr_wire [0:NUMPRPT-1][0:NUMVBNK-1];
  reg [BITPADR-BITPBNK-2:0] pdout2_padr_wire [0:NUMPRPT-1][0:NUMVBNK-1];
  reg [WIDTH-1:0] xdout2_wire [0:NUMPRPT-1];
  reg             xdout2_serr_wire [0:NUMPRPT-1];
  reg             xdout2_derr_wire [0:NUMPRPT-1];
  reg [BITPADR-BITPBNK-2:0] xdout2_padr_wire [0:NUMPRPT-1];
  integer rerr_int, berr_int;
  always_comb begin
    for (rerr_int=0; rerr_int<NUMPRPT; rerr_int=rerr_int+1) begin
      xdout2_wire[rerr_int] = xdout2 >> (rerr_int*WIDTH);
      xdout2_serr_wire[rerr_int] = xdout2_serr >> rerr_int;
      xdout2_derr_wire[rerr_int] = xdout2_derr >> rerr_int;
      xdout2_padr_wire[rerr_int] = xdout2_padr >> (rerr_int*(BITPADR-BITPBNK-1));
      for (berr_int=0; berr_int<NUMVBNK; berr_int=berr_int+1) begin
        pdout1_wire[rerr_int][berr_int] = pdout1 >> ((NUMPRPT*berr_int+rerr_int)*WIDTH);
        pdout1_serr_wire[rerr_int][berr_int] = pdout1_serr >> (NUMPRPT*berr_int+rerr_int);
        pdout1_derr_wire[rerr_int][berr_int] = pdout1_derr >> (NUMPRPT*berr_int+rerr_int);
        pdout1_padr_wire[rerr_int][berr_int] = pdout1_padr >> ((NUMPRPT*berr_int+rerr_int)*(BITPADR-BITPBNK-1));
        pdout2_wire[rerr_int][berr_int] = pdout2 >> ((NUMPRPT*berr_int+rerr_int)*WIDTH);
        pdout2_serr_wire[rerr_int][berr_int] = pdout2_serr >> (NUMPRPT*berr_int+rerr_int);
        pdout2_derr_wire[rerr_int][berr_int] = pdout2_derr >> (NUMPRPT*berr_int+rerr_int);
        pdout2_padr_wire[rerr_int][berr_int] = pdout2_padr >> ((NUMPRPT*berr_int+rerr_int)*(BITPADR-BITPBNK-1));
      end
    end
  end

  reg              xrd_fwd_vld [0:NUMPRPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]  xrd_fwd_reg [0:NUMPRPT-1][0:SRAM_DELAY-1];
  integer rrdf_int, xrdf_int;
  always @(posedge clk)
    for (rrdf_int=0; rrdf_int<NUMPRPT; rrdf_int=rrdf_int+1)
      for (xrdf_int=0; xrdf_int<SRAM_DELAY; xrdf_int=xrdf_int+1)
        if (xrdf_int>0)
          if (xwrite_req && (xwrradr_req == vradr2_reg[2*rrdf_int+1][xrdf_int-1])) begin
            xrd_fwd_vld[rrdf_int][xrdf_int] <= 1'b1;
            xrd_fwd_reg[rrdf_int][xrdf_int] <= xdin_req;
          end else begin
            xrd_fwd_vld[rrdf_int][xrdf_int] <= xrd_fwd_vld[rrdf_int][xrdf_int-1];
            xrd_fwd_reg[rrdf_int][xrdf_int] <= xrd_fwd_reg[rrdf_int][xrdf_int-1];
          end
        else
          if (xwrite_req && (xwrradr_req == vradr2_wire[2*rrdf_int+1])) begin
            xrd_fwd_vld[rrdf_int][xrdf_int] <= 1'b1;
            xrd_fwd_reg[rrdf_int][xrdf_int] <= xdin_req;
          end else begin
            xrd_fwd_vld[rrdf_int][xrdf_int] <= 1'b0;
            xrd_fwd_reg[rrdf_int][xrdf_int] <= 0;
          end

  reg [WIDTH-1:0] xor_data [0:NUMPRPT-1];
  reg xor_fwd_data [0:NUMPRPT-1];
  integer rxdt_int;
  always_comb
    for (rxdt_int=0; rxdt_int<NUMPRPT; rxdt_int=rxdt_int+1) begin
      xor_data[rxdt_int] = xrd_fwd_vld[rxdt_int][SRAM_DELAY-1] ? xrd_fwd_reg[rxdt_int][SRAM_DELAY-1] : xdout2_wire[rxdt_int];
      xor_fwd_data[rxdt_int] = xrd_fwd_vld[rxdt_int][SRAM_DELAY-1];
    end

  assign xwrite_req = (rstvld && !rst) || vwrite1_out;
  assign xwrradr_req = rstvld ? rstaddr : vradr1_out;
  integer xwr_int;
  always_comb begin
    xdin_req = 0;
    xserr_req = 0;
    if (!rstvld) begin 
      for (xwr_int=0; xwr_int<NUMVBNK; xwr_int=xwr_int+1)
        if (vbadr1_out != xwr_int) begin
          xdin_req = xdin_req ^ pdout1_wire[0][xwr_int];
          xserr_req = xserr_req || pdout1_serr_wire[0][xwr_int];
        end else begin
          xdin_req = xdin_req ^ vdin1_out;
          xserr_req = xserr_req;
        end
    end
  end

  wire [WIDTH-1:0]   vdout1_tmp = pdout1_wire[0][vbadr1_out];
  wire               vread1_serr_tmp = pdout1_serr_wire[0][vbadr1_out];
  wire               vread1_derr_tmp = pdout1_derr_wire[0][vbadr1_out];
  wire [BITPADR-1:0] vread1_padr_tmp = {vbadr1_out,pdout1_padr_wire[0][vbadr1_out]};

  reg                vread2_vld_wire [0:NUMVRPT-1];
  reg [WIDTH-1:0]    vdout2_wire [0:NUMVRPT-1];
  reg                vread2_serr_wire [0:NUMVRPT-1];
  reg                vread2_derr_wire [0:NUMVRPT-1];
  reg [BITPADR-1:0]  vread2_padr_wire [0:NUMVRPT-1];

  reg [WIDTH-1:0]           pdout_temp;
  reg                       pdout_serr_temp;
  reg                       pdout_derr_temp;
  reg [BITPADR-BITPBNK-2:0] pdout_padr_temp;
  integer vrd_int, vxor_int;
  always_comb begin
    for (vrd_int=0; vrd_int<NUMVRPT; vrd_int=vrd_int+1) begin
      vread2_vld_wire[vrd_int] = vread2_out[vrd_int];
      vdout2_wire[vrd_int] = 0;
      vread2_serr_wire[vrd_int] = 0;
      vread2_derr_wire[vrd_int] = 0;
      vread2_padr_wire[vrd_int] = 0;
    end
    for (vrd_int=0; vrd_int<NUMVRPT; vrd_int=vrd_int+1) 
      if (vrd_int[0]==0) begin
        pdout_temp = pdout2_wire[vrd_int>>1][vbadr2_out[vrd_int]];
        pdout_serr_temp = pdout2_serr_wire[vrd_int>>1][vbadr2_out[vrd_int]];
        pdout_derr_temp = pdout2_derr_wire[vrd_int>>1][vbadr2_out[vrd_int]];
        pdout_padr_temp = pdout2_padr_wire[vrd_int>>1][vbadr2_out[vrd_int]]; 
        vdout2_wire[vrd_int] = pdout_temp;
	vread2_derr_wire[vrd_int] = vread2_derr_wire[vrd_int] || (vread2_vld_wire[vrd_int] && (pdout_derr_temp || (vread2_serr_wire[vrd_int] && pdout_serr_temp)));
        vread2_serr_wire[vrd_int] = vread2_vld_wire[vrd_int] && pdout_serr_temp;
        vread2_padr_wire[vrd_int] = {vbadr2_out[vrd_int],pdout_padr_temp};
      end else if (vread2_out[vrd_int-1] && vread2_out[vrd_int] && (vbadr2_out[vrd_int-1] == vbadr2_out[vrd_int])) begin
        vread2_padr_wire[vrd_int] = xor_fwd_data[vrd_int>>1] ? ~0 : {NUMVBNK,xdout2_padr_wire[vrd_int>>1]};
        for (vxor_int=NUMVBNK; vxor_int>=0; vxor_int=vxor_int-1) begin
          if (vxor_int==NUMVBNK) begin
            pdout_temp = xor_data[vrd_int>>1];
            pdout_serr_temp = xdout2_serr_wire[vrd_int>>1];
            pdout_derr_temp = xdout2_derr_wire[vrd_int>>1];
            pdout_padr_temp = xdout2_padr_wire[vrd_int>>1]; 
          end else if (vbadr2_out[vrd_int] != vxor_int) begin
            pdout_temp = pdout2_wire[vrd_int>>1][vxor_int];
            pdout_serr_temp = pdout2_serr_wire[vrd_int>>1][vxor_int];
            pdout_derr_temp = pdout2_derr_wire[vrd_int>>1][vxor_int];
            pdout_padr_temp = pdout2_padr_wire[vrd_int>>1][vxor_int]; 
          end else begin
            pdout_temp = 0;
	    pdout_serr_temp = 0;
	    pdout_derr_temp = 0;
	    pdout_padr_temp = 0;
          end
          vdout2_wire[vrd_int] = vdout2_wire[vrd_int] ^ pdout_temp;
	  vread2_derr_wire[vrd_int] = vread2_derr_wire[vrd_int] || (vread2_vld_wire[vrd_int] && (pdout_derr_temp || (vread2_serr_wire[vrd_int] && pdout_serr_temp)));
          vread2_serr_wire[vrd_int] = vread2_serr_wire[vrd_int] || (vread2_vld_wire[vrd_int] && pdout_serr_temp);
          if (pdout_serr_temp)
            vread2_padr_wire[vrd_int] = {vxor_int,pdout_padr_temp};
        end
      end else begin
        pdout_temp = pdout2_wire[vrd_int>>1][vbadr2_out[vrd_int]];
        pdout_serr_temp = pdout2_serr_wire[vrd_int>>1][vbadr2_out[vrd_int]];
        pdout_derr_temp = pdout2_derr_wire[vrd_int>>1][vbadr2_out[vrd_int]];
        pdout_padr_temp = pdout2_padr_wire[vrd_int>>1][vbadr2_out[vrd_int]]; 
        vdout2_wire[vrd_int] = pdout_temp;
	vread2_derr_wire[vrd_int] = vread2_derr_wire[vrd_int] || (vread2_vld_wire[vrd_int] && (pdout_derr_temp || (vread2_serr_wire[vrd_int] && pdout_serr_temp)));
        vread2_serr_wire[vrd_int] = vread2_vld_wire[vrd_int] && pdout_serr_temp;
        vread2_padr_wire[vrd_int] = {vbadr2_out[vrd_int],pdout_padr_temp};
      end
  end

  reg [NUMVRPT-1:0]         vread2_vld_tmp;
  reg [NUMVRPT*WIDTH-1:0]   vdout2_tmp;
  reg [NUMVRPT-1:0]         vread2_serr_tmp;
  reg [NUMVRPT-1:0]         vread2_derr_tmp;
  reg [NUMVRPT*BITPADR-1:0] vread2_padr_tmp;
  integer vwire_int;
  always_comb begin
    vread2_vld_tmp = 0;
    vdout2_tmp = 0;
    vread2_serr_tmp = 0;
    vread2_derr_tmp = 0;
    vread2_padr_tmp = 0;
    for (vwire_int=0; vwire_int<NUMVRPT; vwire_int=vwire_int+1) begin
      vread2_vld_tmp = vread2_vld_tmp | (vread2_out[vwire_int] << vwire_int);
      vdout2_tmp = vdout2_tmp | (vdout2_wire[vwire_int] << (vwire_int*WIDTH));
      vread2_serr_tmp = vread2_serr_tmp | (vread2_serr_wire[vwire_int] << vwire_int);
      vread2_derr_tmp = vread2_derr_tmp | (vread2_derr_wire[vwire_int] << vwire_int);
      vread2_padr_tmp = vread2_padr_tmp | (vread2_padr_wire[vwire_int] << (vwire_int*BITPADR));
    end
  end

  reg [WIDTH-1:0]           vdout1;
  reg                       vread1_serr;
  reg                       vread1_derr;
  reg [BITPADR-1:0]         vread1_padr;
  reg [NUMVRPT-1:0]         vread2_vld;
  reg [NUMVRPT*WIDTH-1:0]   vdout2;
  reg [NUMVRPT-1:0]         vread2_serr;
  reg [NUMVRPT-1:0]         vread2_derr;
  reg [NUMVRPT*BITPADR-1:0] vread2_padr;

  generate if (FLOPOUT) begin: flp_loop
    always @(posedge clk) begin
      vdout1 <= vdout1_tmp;
      vread1_serr <= vread1_serr_tmp;
      vread1_derr <= vread1_derr_tmp;
      vread1_padr <= vread1_padr_tmp;
      vread2_vld <= vread2_vld_tmp;
      vdout2 <= vdout2_tmp;
      vread2_serr <= vread2_serr_tmp;
      vread2_derr <= vread2_derr_tmp;
      vread2_padr <= vread2_padr_tmp;
    end
  end else begin: nflp_loop
    always_comb begin
      vdout1 = vdout1_tmp;
      vread1_serr = vread1_serr_tmp;
      vread1_derr = vread1_derr_tmp;
      vread1_padr = vread1_padr_tmp;
      vread2_vld = vread2_vld_tmp;
      vdout2 = vdout2_tmp;
      vread2_serr = vread2_serr_tmp;
      vread2_derr = vread2_derr_tmp;
      vread2_padr = vread2_padr_tmp;
    end
  end
  endgenerate

endmodule



