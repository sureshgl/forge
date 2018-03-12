module core_nw1ru_1r1w (vset, vstaddr, vstin,
                        vread, vwrite, vaddr, vdin, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                        t1_writeA, t1_addrA, t1_dinA, t1_readB, t1_addrB, t1_doutB, t1_fwrdB, t1_serrB, t1_derrB, t1_padrB,
                        ready, clk, rst);

  parameter BITWDTH = 5;
  parameter WIDTH = 32;
  parameter NUMSTPT = 2;
  parameter NUMPBNK = 3;
  parameter BITPBNK = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter BITPADR = BITPBNK+BITADDR;
  parameter SRAM_DELAY = 2;
  parameter UPDT_DELAY = 1;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input [NUMSTPT-1:0]                vset;
  input [NUMSTPT*BITADDR-1:0]        vstaddr;
  input [NUMSTPT*WIDTH-1:0]          vstin;

  input                              vread;
  input                              vwrite;
  input [BITADDR-1:0]                vaddr;
  input [WIDTH-1:0]                  vdin;
  output                             vread_vld;
  output [WIDTH-1:0]                 vdout;
  output                             vread_fwrd;
  output                             vread_serr;
  output                             vread_derr;
  output [BITPADR-1:0]               vread_padr;

  output [NUMPBNK-1:0] t1_writeA;
  output [NUMPBNK*BITADDR-1:0] t1_addrA;
  output [NUMPBNK*WIDTH-1:0] t1_dinA;
  
  output [NUMPBNK-1:0] t1_readB;
  output [NUMPBNK*BITADDR-1:0] t1_addrB;
  input [NUMPBNK*WIDTH-1:0] t1_doutB;
  input [NUMPBNK-1:0] t1_fwrdB;
  input [NUMPBNK-1:0] t1_serrB;
  input [NUMPBNK-1:0] t1_derrB;
  input [NUMPBNK*(BITPADR-BITPBNK)-1:0] t1_padrB;
  
  output                             ready;
  input                              clk;
  input                              rst;

  reg [2:0] rst_reg;
  always @(posedge clk)
    rst_reg <= {rst_reg[1:0],rst};

  wire rst_sync = rst_reg[2];

  reg [BITADDR:0] rstaddr;
  wire rstvld = !rst_sync && (rstaddr < NUMADDR);
  always @(posedge clk)
    if (rst_sync)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg ready;
  always @(posedge clk)
    ready <= !rst_sync && !rstvld;

  wire ready_wire;

  wire vset_wire [0:NUMSTPT-1];
  wire [BITADDR-1:0] vstaddr_wire [0:NUMSTPT-1];
  wire [WIDTH-1:0] vstin_wire [0:NUMSTPT-1];

  wire vread_wire;
  wire vwrite_wire;
  wire [BITADDR-1:0] vaddr_wire;
  wire [WIDTH-1:0] vdin_wire;

  genvar flp_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMSTPT-1:0] vset_reg;
    reg [NUMSTPT*BITADDR-1:0] vstaddr_reg;
    reg [NUMSTPT*WIDTH-1:0] vstin_reg;
    reg vread_reg;
    reg vwrite_reg;
    reg [BITADDR-1:0] vaddr_reg;
    reg [WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vset_reg <= vset & {NUMSTPT{ready}};
      vstaddr_reg <= vstaddr;
      vstin_reg <= vstin;
      vread_reg <= vread && ready;
      vwrite_reg <= vwrite && ready;
      vaddr_reg <= vaddr;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    integer same_int;
    for (flp_var=0; flp_var<NUMSTPT; flp_var=flp_var+1) begin: st_loop
      assign vset_wire[flp_var] = vset_reg[flp_var] && (vstaddr_wire[flp_var]<NUMADDR);
      assign vstaddr_wire[flp_var] = vstaddr_reg >> (flp_var*BITADDR);
      assign vstin_wire[flp_var] = vstin_reg >> (flp_var*WIDTH);
    end

    assign vread_wire = vread_reg && (vaddr_reg<NUMADDR);
    assign vwrite_wire = vwrite_reg;
    assign vaddr_wire = vaddr_reg;
    assign vdin_wire = vdin_reg;
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (flp_var=0; flp_var<NUMSTPT; flp_var=flp_var+1) begin: st_loop
      assign vset_wire[flp_var] = vset[flp_var] && (vstaddr_wire[flp_var]<NUMADDR) && ready;
      assign vstaddr_wire[flp_var] = vstaddr >> (flp_var*BITADDR);
      assign vstin_wire[flp_var] = vstin >> (flp_var*WIDTH);
    end

    assign vread_wire = vread && (vaddr<NUMADDR) && ready;
    assign vwrite_wire = vwrite && ready;
    assign vaddr_wire = vaddr;
    assign vdin_wire = vdin;
  end
  endgenerate

  reg                vread_reg [0:SRAM_DELAY+FLOPOUT+UPDT_DELAY+FLOPIN-1];
  reg [BITADDR-1:0]  vaddr_reg [0:SRAM_DELAY+FLOPOUT+UPDT_DELAY+FLOPIN-1];
  integer vdel_int, vprt_int;
  always @(posedge clk) 
    for (vdel_int=0; vdel_int<SRAM_DELAY+FLOPOUT+UPDT_DELAY+FLOPIN; vdel_int=vdel_int+1)
      if (vdel_int>0) begin
        vread_reg[vdel_int] <= vread_reg[vdel_int-1];
        vaddr_reg[vdel_int] <= vaddr_reg[vdel_int-1];
      end else begin
        vread_reg[vdel_int] <= vread_wire;
        vaddr_reg[vdel_int] <= vaddr_wire;
      end

  wire               vread_out = vread_reg[SRAM_DELAY-1];
  wire               vwrite_out = vread_reg[SRAM_DELAY+FLOPOUT+UPDT_DELAY+FLOPIN-1];
  wire [BITADDR-1:0] vaddr_out = vaddr_reg[SRAM_DELAY+FLOPOUT+UPDT_DELAY+FLOPIN-1];

  // Read request of pivoted data on DRAM memory
  reg               pwrite [0:NUMPBNK-1];
  reg [BITADDR-1:0] pwraddr [0:NUMPBNK-1];
  reg [WIDTH-1:0]   pdin [0:NUMPBNK-1];

  reg [NUMPBNK-1:0] t1_readB;
  reg [NUMPBNK*BITADDR-1:0] t1_addrB;
  integer t1rd_int;
  always_comb begin
    t1_readB = 0;
    t1_addrB = 0;
    if (vread_wire)
      for (t1rd_int=0; t1rd_int<NUMPBNK; t1rd_int=t1rd_int+1) begin
        t1_readB = t1_readB | (1'b1 << t1rd_int);
        t1_addrB = t1_addrB | (vaddr_wire << (t1rd_int*BITADDR));
      end
  end

  reg [WIDTH-1:0]           pdout_wire [0:NUMPBNK-1];
  reg                       pfwrd_wire [0:NUMPBNK-1];
  reg                       pserr_wire [0:NUMPBNK-1];
  reg                       pderr_wire [0:NUMPBNK-1];
  reg [BITPADR-BITPBNK-1:0] padr_wire [0:NUMPBNK-1];
  integer pdo_int;
  always_comb
    for (pdo_int=0; pdo_int<NUMPBNK; pdo_int=pdo_int+1) begin
      pdout_wire[pdo_int] = t1_doutB >> (pdo_int*WIDTH);
      pfwrd_wire[pdo_int] = t1_fwrdB >> pdo_int;
      pserr_wire[pdo_int] = t1_serrB >> pdo_int;
      pderr_wire[pdo_int] = t1_derrB >> pdo_int;
      padr_wire[pdo_int] = t1_padrB >> (pdo_int*(BITPADR-BITPBNK));
    end

  reg              rdcnt_vld [0:NUMPBNK-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]  rdcnt_reg [0:NUMPBNK-1][0:SRAM_DELAY-1];
  integer rprt_int, rdel_int;
  always @(posedge clk) 
    for (rprt_int=0; rprt_int<NUMPBNK; rprt_int=rprt_int+1)
      for (rdel_int=0; rdel_int<SRAM_DELAY; rdel_int=rdel_int+1)
        if (rdel_int>0) begin
          if (pwrite[rprt_int] && vread_reg[rdel_int-1] && (pwraddr[rprt_int] == vaddr_reg[rdel_int-1])) begin
            rdcnt_vld[rprt_int][rdel_int] <= 1'b1;
            rdcnt_reg[rprt_int][rdel_int] <= pdin[rprt_int];
          end else begin
            rdcnt_vld[rprt_int][rdel_int] <= rdcnt_vld[rprt_int][rdel_int-1];
            rdcnt_reg[rprt_int][rdel_int] <= rdcnt_reg[rprt_int][rdel_int-1];            
          end
        end else begin
          if (pwrite[rprt_int] && vread_wire && (pwraddr[rprt_int] == vaddr_wire)) begin
            rdcnt_vld[rprt_int][rdel_int] <= 1'b1;
            rdcnt_reg[rprt_int][rdel_int] <= pdin[rprt_int];
          end else begin
            rdcnt_vld[rprt_int][rdel_int] <= 1'b0;
            rdcnt_reg[rprt_int][rdel_int] <= 0;
          end
        end

  reg [WIDTH-1:0] rdcnt_out [0:NUMPBNK-1];
  integer rdct_int;
  always_comb
    for (rdct_int=0; rdct_int<NUMPBNK; rdct_int=rdct_int+1)
      rdcnt_out[rdct_int] = rdcnt_vld[rdct_int][SRAM_DELAY-1] ? rdcnt_reg[rdct_int][SRAM_DELAY-1] : pdout_wire[rdct_int];

  wire vread_vld_temp = vread_out;
  reg [WIDTH-1:0] vdout_temp;
  reg vread_fwrd_temp;
  reg vread_ferr_temp;
  reg vread_serr_temp;
  reg vread_derr_temp;
  reg [BITPADR-1:0] vread_padr_temp;
  reg [BITPBNK-1:0] vread_badr_temp;
  integer vdo_int;
  always_comb begin
    vread_fwrd_temp = 0;
    vdout_temp = 0;
    vread_badr_temp = 0;
    for (vdo_int=0; vdo_int<NUMPBNK; vdo_int=vdo_int+1) begin
      vread_fwrd_temp = vread_fwrd_temp || (vread_out && (rdcnt_vld[vdo_int][SRAM_DELAY-1] || pfwrd_wire[vdo_int]));
      if (|rdcnt_out[vdo_int]) begin
        vdout_temp = rdcnt_out[vdo_int];
        vread_badr_temp = vdo_int;
      end
    end
    vread_padr_temp = padr_wire[0];
    vread_ferr_temp = 0;
    vread_serr_temp = 0;
    vread_derr_temp = 0; 
    for (vdo_int=NUMPBNK-1; vdo_int>=0; vdo_int=vdo_int-1)
      if (pserr_wire[vdo_int]) begin
        vread_ferr_temp = vread_ferr_temp || (vread_out && !(rdcnt_vld[vdo_int][SRAM_DELAY-1] || pfwrd_wire[vdo_int])); 
        vread_serr_temp = 1'b1;
        vread_padr_temp = {vdo_int,padr_wire[vdo_int]};
      end
    for (vdo_int=NUMPBNK-1; vdo_int>=0; vdo_int=vdo_int-1)
      if (pderr_wire[vdo_int]) begin
        vread_ferr_temp = vread_ferr_temp || (vread_out && !(rdcnt_vld[vdo_int][SRAM_DELAY-1] || pfwrd_wire[vdo_int])); 
        vread_derr_temp = 1'b1;
        vread_padr_temp = {vdo_int,padr_wire[vdo_int]};
      end
    vread_fwrd_temp = vread_fwrd_temp && !vread_ferr_temp;
  end

  reg               vread_vld;
  reg [WIDTH-1:0]   vdout;
  reg               vread_fwrd;
  reg               vread_serr;
  reg               vread_derr;
  reg [BITPADR-1:0] vread_padr;
  reg [BITPBNK-1:0] vread_badr;
  generate if (FLOPOUT) begin: flpo_loop
    always @(posedge clk) begin
      vread_vld <= vread_vld_temp;
      vdout <= vdout_temp; 
      vread_fwrd <= vread_fwrd_temp;
      vread_serr <= vread_serr_temp;
      vread_derr <= vread_derr_temp;
      vread_padr <= vread_padr_temp;
      vread_badr <= vread_badr_temp;
    end
  end else begin: nflpo_loop
    always_comb begin
      vread_vld = vread_vld_temp;
      vdout = vdout_temp;
      vread_fwrd = vread_fwrd_temp;
      vread_serr = vread_serr_temp;
      vread_derr = vread_derr_temp;
      vread_padr = vread_padr_temp;
      vread_badr = vread_badr_temp;
    end
  end
  endgenerate

  reg [BITPBNK-1:0] vread_badr_reg [0:UPDT_DELAY+FLOPIN-1];
  reg [BITPBNK-1:0] vread_badr_out;
  generate if (UPDT_DELAY+FLOPIN>0) begin : updnz
    integer vbnk_int;
    always @(posedge clk)
      for (vbnk_int=0; vbnk_int<UPDT_DELAY+FLOPIN; vbnk_int=vbnk_int+1)
        if (vbnk_int>0)
          vread_badr_reg[vbnk_int] <= vread_badr_reg[vbnk_int-1];
        else
          vread_badr_reg[vbnk_int] <= vread_badr;
    always_comb
      vread_badr_out = vread_badr_reg[UPDT_DELAY+FLOPIN-1];
  end else begin: updz
      always_comb
        vread_badr_out = vread_badr;
  end
  endgenerate

  reg vset_temp [0:NUMSTPT-1];
  integer vstp_int, vstc_int;
  always_comb
    for (vstp_int=0; vstp_int<NUMSTPT; vstp_int=vstp_int+1) begin
      vset_temp[vstp_int] = vset_wire[vstp_int];
      for (vstc_int=0; vstc_int<vstp_int; vstc_int=vstc_int+1)
        if (vset_wire[vstp_int] && vset_wire[vstc_int] && (vstaddr_wire[vstp_int]==vstaddr_wire[vstc_int]))
          vset_temp[vstc_int] = 1'b0;
    end

  integer pwr_int, pst_int;
  always_comb begin
    pst_int = 0;
    for (pwr_int=0; pwr_int<NUMPBNK; pwr_int=pwr_int+1) begin
      pwrite[pwr_int] = 1'b0;
      pwraddr[pwr_int] = 0;
      pdin[pwr_int] = 0;
    end
    if (vwrite_out && vwrite_wire) begin
      pwrite[vread_badr_out] = 1'b1;
      pwraddr[vread_badr_out] = vaddr_out;
      pdin[vread_badr_out] = vdin_wire;
    end
    for (pwr_int=0; pwr_int<NUMSTPT; pwr_int=pwr_int+1) begin
      if (vwrite_out && vwrite_wire && (pst_int==vread_badr_out))
        pst_int = pst_int+1;
      if (vset_temp[pwr_int]) begin
        pwrite[pst_int] = 1'b1;
        pwraddr[pst_int] = vstaddr_wire[pwr_int];
        pdin[pst_int] = vstin_wire[pwr_int];
        pst_int = pst_int+1;
      end
    end
    if (rstvld)
      for (pwr_int=0; pwr_int<NUMPBNK; pwr_int=pwr_int+1) begin
        pwrite[pwr_int] = 1'b1;
        pwraddr[pwr_int] = rstaddr;
        pdin[pwr_int] = 0;
      end
  end
    
/*
  wire vcnt_out_0 = vcnt_out[0];
  wire vcnt_out_1 = vcnt_out[1];
  wire vcnt_out_2 = vcnt_out[2];
  wire vcnt_out_3 = vcnt_out[3];
  wire pwrite_0 = pwrite[0];
  wire pwrite_1 = pwrite[1];
  wire pwrite_2 = pwrite[2];
  wire pwrite_3 = pwrite[3];
*/
  reg [NUMPBNK-1:0] t1_writeA;
  reg [NUMPBNK*BITADDR-1:0] t1_addrA;
  reg [NUMPBNK*WIDTH-1:0] t1_dinA;
  integer t1wp_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    for (t1wp_int=0; t1wp_int<NUMPBNK; t1wp_int=t1wp_int+1)
      if (pwrite[t1wp_int]) begin
        t1_writeA = t1_writeA | (1'b1 << t1wp_int);
        t1_addrA = t1_addrA | (pwraddr[t1wp_int] << (t1wp_int*BITADDR));
        t1_dinA = t1_dinA | (pdin[t1wp_int] << (t1wp_int*WIDTH));
      end
  end

endmodule



