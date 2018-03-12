module core_mrpnwp_1r1w_base (vwrite, vwraddr, vdin,
                              vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
          		      pwrite, pwrbadr, pwrradr, pdin,
			      pread, prdbadr, prdradr,                              
                              t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, // t1_padrB,
			      vread_vld_bus, vread_padr_bus,
	                      ready, clk, rst);
 
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 2;
  parameter NUMWRPT = 3;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPADR = 13;
  parameter WRBUSRED = 1;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter BITDMUX = 0;

  input [NUMWRPT-1:0]                   vwrite;
  input [NUMWRPT*BITADDR-1:0]           vwraddr;
  input [(NUMWRPT/WRBUSRED)*WIDTH-1:0]  vdin;
  
  input [NUMRDPT-1:0]                   vread;
  input [NUMRDPT*BITADDR-1:0]           vrdaddr;
  output [NUMRDPT-1:0]                  vread_vld;
  output [NUMRDPT*WIDTH-1:0]            vdout;
  output [NUMRDPT-1:0]                  vread_fwrd;
  output [NUMRDPT-1:0]                  vread_serr;
  output [NUMRDPT-1:0]                  vread_derr;
  output [NUMRDPT*BITPADR-1:0]          vread_padr;

  input [NUMRDPT*WIDTH-1:0]             t1_doutB;
  input [NUMRDPT-1:0] 			vread_vld_bus;
  input [(BITPADR*NUMRDPT)-1:0] 	vread_padr_bus;

  input [NUMVBNK-1:0]                   t1_fwrdB;
  input [NUMVBNK-1:0]                   t1_serrB;
  input [NUMVBNK-1:0]                   t1_derrB;
//  input [NUMVBNK*(BITPADR-BITVBNK)-1:0] t1_padrB;

  output [NUMWRPT-1:0] pwrite;
  output [(BITVBNK*NUMWRPT)-1:0] pwrbadr;
  output [(BITVROW*NUMWRPT)-1:0] pwrradr;
  output [(WIDTH*(NUMWRPT/WRBUSRED))-1:0]   pdin;
  output [NUMRDPT-1:0] pread;
  output [(BITVBNK*NUMRDPT)-1:0] prdbadr;
  output [(BITVROW*NUMRDPT)-1:0] prdradr;

  output                                ready;
  input                                 clk;
  input                                 rst;

  reg [2:0] rst_reg;
  always @(posedge clk)
    rst_reg <= {rst_reg[1:0],rst};

  wire rst_sync = rst_reg[2];

  reg ready;
  always @(posedge clk)
    ready <= !rst_sync;

  wire vread_wire [0:NUMRDPT-1];
//  wire [BITADDR-1:0] vrdaddr_wire [0:NUMRDPT-1];
//  wire [BITVBNK-1:0] vrdbadr_wire [0:NUMRDPT-1];
//  wire [BITVROW-1:0] vrdradr_wire [0:NUMRDPT-1];
  wire vwrite_wire [0:NUMWRPT-1];
//  wire [BITADDR-1:0] vwraddr_wire [0:NUMWRPT-1];
//  wire [BITVBNK-1:0] vwrbadr_wire [0:NUMWRPT-1];
//  wire [BITVROW-1:0] vwrradr_wire [0:NUMWRPT-1];
  wire [WIDTH-1:0] vdin_wire [0:(NUMWRPT/WRBUSRED)-1];

  reg [NUMWRPT-1:0] pwrite;
//  reg [(BITVBNK*NUMWRPT)-1:0] pwrbadr;
//  reg [(BITVROW*NUMWRPT)-1:0] pwrradr;
  reg [(WIDTH*(NUMWRPT/WRBUSRED))-1:0]   pdin;
  integer pwrpo_int, pwba_int, pwra_int,pwd_int;
  always_comb begin
    for (pwrpo_int=0; pwrpo_int<NUMWRPT; pwrpo_int=pwrpo_int+1) begin
      pwrite[pwrpo_int] = vwrite_wire[pwrpo_int];
      for (pwd_int=0; pwd_int<WIDTH; pwd_int=pwd_int+1)
        pdin[(pwrpo_int/WRBUSRED)*WIDTH+pwd_int] = vdin_wire[pwrpo_int/WRBUSRED][pwd_int];
//      for (pwba_int=0; pwba_int<BITVBNK; pwba_int=pwba_int+1)
//        pwrbadr[pwrpo_int*BITVBNK+pwba_int] = vwrbadr_wire[pwrpo_int][pwba_int];
//      for (pwra_int=0; pwra_int<BITVROW; pwra_int=pwra_int+1)
//        pwrradr[pwrpo_int*BITVROW+pwra_int] = vwrradr_wire[pwrpo_int][pwra_int];
    end
  end
  reg [NUMRDPT-1:0] pread;
//  reg [(BITVBNK*NUMRDPT)-1:0] prdbadr;
//  reg [(BITVROW*NUMRDPT)-1:0] prdradr;
  integer prdpo_int, prba_int, prra_int;
  always_comb begin
    for (prdpo_int=0; prdpo_int<NUMRDPT; prdpo_int=prdpo_int+1) begin
      pread[prdpo_int] = vread_wire[prdpo_int];
//      for (prba_int=0; prba_int<BITVBNK; prba_int=prba_int+1)
//        prdbadr[prdpo_int*BITVBNK+prba_int] = vrdbadr_wire[prdpo_int][prba_int];
//      for (prra_int=0; prra_int<BITVROW; prra_int=prra_int+1)
//        prdradr[prdpo_int*BITVROW+prra_int] = vrdradr_wire[prdpo_int][prra_int];
    end
  end

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg [NUMRDPT-1:0] vread_reg;
//    reg [NUMRDPT*BITADDR-1:0] vrdaddr_reg;
    reg [NUMWRPT-1:0] vwrite_reg;
//    reg [NUMWRPT*BITADDR-1:0] vwraddr_reg;
    reg [(NUMWRPT/WRBUSRED)*WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      vread_reg <= vread & {NUMRDPT{ready}};
//      vrdaddr_reg <= vrdaddr;
      vwrite_reg <= vwrite & {NUMWRPT{ready}};
//      vwraddr_reg <= vwraddr;
      vdin_reg <= vdin;
    end

    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
/*      assign vrdaddr_wire[np2_var] = vrdaddr_reg >> (np2_var*BITADDR);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
*/
    end

    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite_reg >> np2_var;
      assign vdin_wire[np2_var/WRBUSRED] = vdin_reg >> ((np2_var/WRBUSRED)*WIDTH);
/*      assign vwraddr_wire[np2_var] = vwraddr_reg >> (np2_var*BITADDR);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire[np2_var]), .vradr(vwrradr_wire[np2_var]), .vaddr(vwraddr_wire[np2_var]));
*/
    end

  end else begin: noflpi_loop
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread >> np2_var;
/*      assign vrdaddr_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
*/
    end 

    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign vwrite_wire[np2_var] = vwrite >> np2_var;
      assign vdin_wire[np2_var/WRBUSRED] = vdin >> ((np2_var/WRBUSRED)*WIDTH);
/*      assign vwraddr_wire[np2_var] = vwraddr >> (np2_var*BITADDR);
  
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire[np2_var]), .vradr(vwrradr_wire[np2_var]), .vaddr(vwraddr_wire[np2_var]));
*/
    end 

  end
  endgenerate

  wire vread_wire_0 = vread_wire[0];
//  wire [BITADDR-1:0] vrdaddr_wire_0 = vrdaddr_wire[0];
//  wire [BITVBNK-1:0] vrdbadr_wire_0 = vrdbadr_wire[0];
//  wire [BITVROW-1:0] vrdradr_wire_0 = vrdradr_wire[0];

  reg                vread_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
//  reg [BITVBNK-1:0]  vrdbadr_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  integer vreg_int, vrpt_int;
  always @(posedge clk)
    for (vreg_int=0; vreg_int<SRAM_DELAY; vreg_int=vreg_int+1) 
      if (vreg_int>0) begin
        for (vrpt_int=0; vrpt_int<NUMRDPT; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_reg[vrpt_int][vreg_int-1];
//          vrdbadr_reg[vrpt_int][vreg_int] <= vrdbadr_reg[vrpt_int][vreg_int-1];
        end
      end else begin
        for (vrpt_int=0; vrpt_int<NUMRDPT; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_wire[vrpt_int];
//          vrdbadr_reg[vrpt_int][vreg_int] <= vrdbadr_wire[vrpt_int];
        end
      end

  reg                vread_out [0:NUMRDPT-1];
//  reg [BITVBNK-1:0]  vrdbadr_out [0:NUMRDPT-1];
  integer vdel_int;
  always_comb begin
    for (vdel_int=0; vdel_int<NUMRDPT; vdel_int=vdel_int+1) begin
      vread_out[vdel_int] = vread_reg[vdel_int][SRAM_DELAY-1];
//      vrdbadr_out[vdel_int] = vrdbadr_reg[vdel_int][SRAM_DELAY-1];
    end
  end
/*
  reg                       t1_vldB_mux [0:NUMRDPT-1];
//  reg [BITVBNK-1:0]         t1_badrB_mux [0:NUMRDPT-1];
  reg [WIDTH-1:0]           t1_doutB_mux [0:(NUMVBNK>>BITDMUX)-1][0:NUMRDPT-1];
  reg                       t1_fwrdB_mux [0:(NUMVBNK>>BITDMUX)-1][0:NUMRDPT-1];
  reg                       t1_serrB_mux [0:(NUMVBNK>>BITDMUX)-1][0:NUMRDPT-1];
  reg                       t1_derrB_mux [0:(NUMVBNK>>BITDMUX)-1][0:NUMRDPT-1];
  reg [BITPADR-BITVBNK-1:0] t1_padrB_mux [0:(NUMVBNK>>BITDMUX)-1][0:NUMRDPT-1];
  generate if (BITDMUX) begin: mflp_loop
    integer t1m_int, t1r_int;
    always @(posedge clk)
      for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
        t1_vldB_mux[t1r_int] <= vread_out[t1r_int];
        t1_badrB_mux[t1r_int] <= vrdbadr_out[t1r_int];
        for (t1m_int=0; t1m_int<(NUMVBNK>>BITDMUX); t1m_int=t1m_int+1) begin
          t1_doutB_mux[t1m_int][t1r_int] <= t1_doutB >> (((t1m_int<<BITDMUX) | vrdbadr_out[t1r_int][BITDMUX-1:0])*WIDTH);
          t1_fwrdB_mux[t1m_int][t1r_int] <= t1_fwrdB >> ((t1m_int<<BITDMUX) | vrdbadr_out[t1r_int][BITDMUX-1:0]);
          t1_serrB_mux[t1m_int][t1r_int] <= t1_serrB >> ((t1m_int<<BITDMUX) | vrdbadr_out[t1r_int][BITDMUX-1:0]);
          t1_derrB_mux[t1m_int][t1r_int] <= t1_derrB >> ((t1m_int<<BITDMUX) | vrdbadr_out[t1r_int][BITDMUX-1:0]);
//Arsen          t1_padrB_mux[t1m_int][t1r_int] <= t1_padrB >> (((t1m_int<<BITDMUX) | vrdbadr_out[t1r_int][BITDMUX-1:0])*(BITPADR-BITVBNK));
        end
      end
  end else begin: nomx_loop
    integer t1m_int, t1r_int;
    always_comb
      for (t1r_int=0; t1r_int<NUMRDPT; t1r_int=t1r_int+1) begin
        t1_vldB_mux[t1r_int] = vread_out[t1r_int];
        t1_badrB_mux[t1r_int] = vrdbadr_out[t1r_int];
        for (t1m_int=0; t1m_int<NUMVBNK; t1m_int=t1m_int+1) begin
          t1_doutB_mux[t1m_int][t1r_int] = t1_doutB >> (t1m_int*WIDTH);
          t1_fwrdB_mux[t1m_int][t1r_int] = t1_fwrdB >> t1m_int;
          t1_serrB_mux[t1m_int][t1r_int] = t1_serrB >> t1m_int;
          t1_derrB_mux[t1m_int][t1r_int] = t1_derrB >> t1m_int;
//Arsen          t1_padrB_mux[t1m_int][t1r_int] = t1_padrB >> (t1m_int*(BITPADR-BITVBNK));
        end
      end
  end
  endgenerate
*/
  reg               vread_vld_wire [0:NUMRDPT-1];
  reg [WIDTH-1:0]   vdout_wire [0:NUMRDPT-1];
  reg               vread_fwrd_wire [0:NUMRDPT-1];
  reg               vread_serr_wire [0:NUMRDPT-1];
  reg               vread_derr_wire [0:NUMRDPT-1];
  reg [BITPADR-BITVBNK-1:0] vread_padr_temp [0:NUMRDPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:NUMRDPT-1];
  integer vrd_int;
  always_comb 
    for (vrd_int=0; vrd_int<NUMRDPT; vrd_int=vrd_int+1) begin
//Arsen      vread_vld_wire[vrd_int] = t1_vldB_mux[vrd_int];
      vread_vld_wire[vrd_int] = vread_vld_bus[vrd_int];
//Arsen
//      vdout_wire[vrd_int] = t1_doutB_mux[t1_badrB_mux[vrd_int] >> BITDMUX][vrd_int];
      vdout_wire[vrd_int] = t1_doutB >> (vrd_int*WIDTH);
      vread_fwrd_wire[vrd_int] = 1'b0;
      vread_serr_wire[vrd_int] = 1'b0;
      vread_derr_wire[vrd_int] = 1'b0;
//Arsen      vread_padr_temp[vrd_int] = t1_padrB_mux[t1_badrB_mux[vrd_int] >> BITDMUX][vrd_int];
//Arsen      vread_padr_wire[vrd_int] = {t1_badrB_mux[vrd_int],vread_padr_temp[vrd_int]};
      vread_padr_wire[vrd_int] = vread_padr_bus >> (vrd_int*BITPADR);
    end

  reg [NUMRDPT-1:0]         vread_vld_tmp;
  reg [NUMRDPT*WIDTH-1:0]   vdout_tmp;
  reg [NUMRDPT-1:0]         vread_fwrd_tmp;
  reg [NUMRDPT-1:0]         vread_serr_tmp;
  reg [NUMRDPT-1:0]         vread_derr_tmp;
  reg [NUMRDPT*BITPADR-1:0] vread_padr_tmp;
  integer vwire_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_fwrd_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    for (vwire_int=0; vwire_int<NUMRDPT; vwire_int=vwire_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_vld_wire[vwire_int] << vwire_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vwire_int] << (vwire_int*WIDTH));
      vread_fwrd_tmp = vread_fwrd_tmp | (vread_fwrd_wire[vwire_int] << vwire_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vwire_int] << vwire_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vwire_int] << vwire_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vwire_int] << (vwire_int*BITPADR));
    end
  end

  reg [NUMRDPT-1:0]         vread_vld;
  reg [NUMRDPT*WIDTH-1:0]   vdout;
  reg [NUMRDPT-1:0]         vread_fwrd;
  reg [NUMRDPT-1:0]         vread_serr;
  reg [NUMRDPT-1:0]         vread_derr;
  reg [NUMRDPT*BITPADR-1:0] vread_padr;

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

endmodule



