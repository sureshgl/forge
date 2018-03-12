
module core_1rfw_1rw_rl2 (vwrite, vwraddr, vdin,
                          vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                          t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA,
                          t2_readA, t2_writeA, t2_addrA, t2_dinA, t2_doutA, t2_fwrdA, t2_serrA, t2_derrA, t2_padrA,
                          t3_readA, t3_writeA, t3_addrA, t3_dinA, t3_doutA, t3_fwrdA, t3_serrA, t3_derrA, t3_padrA,
                          ready, clk, rst,
                          select_addr, select_bit);

  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 14;
  parameter NUMCBNK = 2;
  parameter BITCBNK = 1;
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  
  parameter FIFOCNT = 1;

  input                              vwrite;
  input [BITADDR-1:0]                vwraddr;
  input [WIDTH-1:0]                  vdin;
  
  input                              vread;
  input [BITADDR-1:0]                vrdaddr;
  output                             vread_vld;
  output [WIDTH-1:0]                 vdout;
  output                             vread_fwrd;
  output                             vread_serr;
  output                             vread_derr;
  output [BITPADR-1:0]               vread_padr;

  output [NUMVBNK-1:0] t1_readA;
  output [NUMVBNK-1:0] t1_writeA;
  output [NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMVBNK*WIDTH-1:0] t1_dinA;
  input [NUMVBNK*WIDTH-1:0] t1_doutA;
  input [NUMVBNK-1:0] t1_fwrdA;
  input [NUMVBNK-1:0] t1_serrA;
  input [NUMVBNK-1:0] t1_derrA;
  input [NUMVBNK*(BITPADR-BITPBNK)-1:0] t1_padrA;

  output [NUMCBNK-1:0] t2_readA;
  output [NUMCBNK-1:0] t2_writeA;
  output [NUMCBNK*BITVROW-1:0] t2_addrA;
  output [NUMCBNK*WIDTH-1:0] t2_dinA;
  output [NUMCBNK*WIDTH-1:0] t2_doutA;
  output [NUMCBNK-1:0] t2_fwrdA;
  output [NUMCBNK-1:0] t2_serrA;
  output [NUMCBNK-1:0] t2_derrA;
  output [NUMCBNK*(BITPADR-BITPBNK)-1:0] t2_padrA;

  output [NUMCBNK-1:0] t3_readA;
  output [NUMCBNK-1:0] t3_writeA;
  output [NUMCBNK*BITVROW-1:0] t3_addrA;
  output [NUMCBNK*(BITVBNK+1)-1:0] t3_dinA;
  output [NUMCBNK*(BITVBNK+1)-1:0] t3_doutA;
  output [NUMCBNK-1:0] t3_fwrdA;
  output [NUMCBNK-1:0] t3_serrA;
  output [NUMCBNK-1:0] t3_derrA;
  output [NUMCBNK*(BITPADR-BITPBNK)-1:0] t3_padrA;

  output                             ready;
  input                              clk;
  input                              rst;

  input [BITADDR-1:0]                select_addr;
  input [BITWDTH-1:0]                select_bit;

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

  wire [BITVBNK-1:0] select_bank;
  wire [BITVROW-1:0] select_row;
  np2_addr #(
    .NUMADDR (NUMADDR), .BITADDR (BITADDR),
    .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
    .NUMVROW (NUMVROW), .BITVROW (BITVROW))
    sl_adr (.vbadr(select_bank), .vradr(select_row), .vaddr(select_addr));

  wire ready_wire;
  wire vread_wire;
  wire [BITADDR-1:0] vrdaddr_wire;
  wire [BITVBNK-1:0] vrdbadr_wire;
  wire [BITVROW-1:0] vrdradr_wire;
  wire vwrite_wire;
  wire [BITADDR-1:0] vwraddr_wire;
  wire [BITVBNK-1:0] vwrbadr_wire;
  wire [BITVROW-1:0] vwrradr_wire;
  wire [WIDTH-1:0] vdin_wire;

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg vread_reg;
    reg [BITADDR-1:0] vrdaddr_reg;
    reg vwrite_reg;
    reg [BITADDR-1:0] vwraddr_reg;
    reg [WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread & ready;
      vrdaddr_reg <= vrdaddr;
      vwrite_reg <= vwrite & ready;
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

    assign vwrite_wire = vwrite_reg && (vwraddr_wire < NUMADDR) && ready_reg;
    assign vwraddr_wire = vwraddr_reg;
    assign vdin_wire = vdin_reg;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire), .vradr(vwrradr_wire), .vaddr(vwraddr_wire));
  end else begin: noflpi_loop
    assign ready_wire = ready;
    assign vread_wire = vread;
    assign vrdaddr_wire = vrdaddr;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire), .vradr(vrdradr_wire), .vaddr(vrdaddr_wire));

    assign vwrite_wire = vwrite && (vwraddr_wire < NUMADDR) && ready;
    assign vwraddr_wire = vwraddr;
    assign vdin_wire = vdin;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire), .vradr(vwrradr_wire), .vaddr(vwraddr_wire));
  end
  endgenerate

  reg                vread_reg [0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:SRAM_DELAY-1];
  reg [BITVROW-1:0]  vrdradr_reg [0:SRAM_DELAY-1];
  reg                vwrite_reg [0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  vwrbadr_reg [0:SRAM_DELAY-1];
  reg [BITVROW-1:0]  vwrradr_reg [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]    vdin_reg [0:SRAM_DELAY-1];
 
  integer vdel_int; 
  always @(posedge clk) begin
    for (vdel_int=0; vdel_int<SRAM_DELAY; vdel_int=vdel_int+1)
      if (vdel_int > 0) begin
        vread_reg[vdel_int] <= vread_reg[vdel_int-1];
        vrdbadr_reg[vdel_int] <= vrdbadr_reg[vdel_int-1];
        vrdradr_reg[vdel_int] <= vrdradr_reg[vdel_int-1];
        if (vdel_int<SRAM_DELAY) begin
          vwrite_reg[vdel_int] <= vwrite_reg[vdel_int-1];
          vwrbadr_reg[vdel_int] <= vwrbadr_reg[vdel_int-1];
          vwrradr_reg[vdel_int] <= vwrradr_reg[vdel_int-1];          
          vdin_reg[vdel_int] <= vdin_reg[vdel_int-1];
        end
      end else begin
        vread_reg[vdel_int] <= vread_wire;
        vrdbadr_reg[vdel_int] <= vrdbadr_wire;
        vrdradr_reg[vdel_int] <= vrdradr_wire;
        vwrite_reg[vdel_int] <= vwrite_wire;
        vwrbadr_reg[vdel_int] <= vwrbadr_wire;
        vwrradr_reg[vdel_int] <= vwrradr_wire;
        vdin_reg[vdel_int] <= vdin_wire;          
      end
  end

  wire               vread_out = vread_reg[SRAM_DELAY-1];
  wire [BITVBNK-1:0] vrdbadr_out = vrdbadr_reg[SRAM_DELAY-1];
  wire [BITVROW-1:0] vrdradr_out = vrdradr_reg[SRAM_DELAY-1];

  wire               vwrite_out = vwrite_reg[SRAM_DELAY-1];
  wire [BITVBNK-1:0] vwrbadr_out = vwrbadr_reg[SRAM_DELAY-1];
  wire [BITVROW-1:0] vwrradr_out = vwrradr_reg[SRAM_DELAY-1];
  wire [WIDTH-1:0]   vdin_out = vdin_reg[SRAM_DELAY-1];       

  reg [BITCBNK-1:0] toggle_ptr;
  always @(posedge clk)
    if (!ready_wire)
      toggle_ptr <= 0;
    else
      toggle_ptr <= (toggle_ptr + vread_wire + vwrite_wire)%NUMCBNK;

  // Read request of pivoted data on DRAM memory
  wire pread = vread_wire;
  wire [BITVBNK-1:0] prdbadr = vrdbadr_wire;
  wire [BITVROW-1:0] prdradr = vrdradr_wire;

  reg               pwrite;
  reg [BITVBNK-1:0] pwrbadr;
  reg [BITVROW-1:0] pwrradr;
  reg [WIDTH-1:0]   pdin;

  // Read request of mapping information on SRAM memory
  wire [BITCBNK-1:0] vread_ptr = toggle_ptr;
  wire [BITCBNK-1:0] vwrite_ptr = vread_wire ? (toggle_ptr+1)%NUMCBNK : toggle_ptr;

  reg sread_wire [0:NUMCBNK-1]; 
  reg [BITVROW-1:0] srdradr_wire [0:NUMCBNK-1]; 
  integer srd_int;
  always_comb begin
    for (srd_int=0; srd_int<NUMCBNK; srd_int=srd_int+1) begin
      sread_wire[srd_int] = 1'b0;
      srdradr_wire[srd_int] = 0;
    end
    if (vread_wire) begin
      sread_wire[vread_ptr] = 1'b1;
      srdradr_wire[vread_ptr] = vrdradr_wire;
    end
    if (vwrite_wire) begin
      sread_wire[vwrite_ptr] = 1'b1;
      srdradr_wire[vwrite_ptr] = vwrradr_wire;
    end
  end
    
  reg               swrite;
  reg [BITVROW-1:0] swrradr;
  reg [BITVBNK:0]   sdin;
  reg [WIDTH-1:0]   ddin;

  reg               swrite_req [0:NUMCBNK-1];
  reg [BITVROW-1:0] swrradr_req [0:NUMCBNK-1];
  reg [BITVBNK:0]   sdin_req [0:NUMCBNK-1];
  reg [WIDTH-1:0]   ddin_req [0:NUMCBNK-1];

  reg               wrmap_vld [0:SRAM_DELAY-1];
  reg [BITVBNK:0]   wrmap_reg [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]   wrmap_dat [0:SRAM_DELAY-1];
  reg [BITCBNK-1:0] wrmap_ptr [0:SRAM_DELAY-1];
  integer wfwd_int;
  always @(posedge clk) begin
    for (wfwd_int=0; wfwd_int<SRAM_DELAY; wfwd_int=wfwd_int+1)
      if (wfwd_int > 0) begin
        if (swrite && (swrradr == vwrradr_reg[wfwd_int-1])) begin
          wrmap_vld[wfwd_int] <= 1'b1;
          wrmap_reg[wfwd_int] <= sdin[BITVBNK:0];
          wrmap_dat[wfwd_int] <= ddin;
          wrmap_ptr[wfwd_int] <= wrmap_ptr[wfwd_int-1];
        end else begin
          wrmap_vld[wfwd_int] <= wrmap_vld[wfwd_int-1];
          wrmap_reg[wfwd_int] <= wrmap_reg[wfwd_int-1];            
          wrmap_dat[wfwd_int] <= wrmap_dat[wfwd_int-1];
          wrmap_ptr[wfwd_int] <= wrmap_ptr[wfwd_int-1];
        end
      end else begin
        if (swrite && (swrradr == vwrradr_wire)) begin
          wrmap_vld[wfwd_int] <= 1'b1;
          wrmap_reg[wfwd_int] <= sdin[BITVBNK:0];
          wrmap_dat[wfwd_int] <= ddin;
          wrmap_ptr[wfwd_int] <= vwrite_ptr;
        end else if (swrite_req[vwrite_ptr] && (swrradr_req[vwrite_ptr] == vwrradr_wire)) begin
          wrmap_vld[wfwd_int] <= 1'b1;
          wrmap_reg[wfwd_int] <= sdin_req[vwrite_ptr][BITVBNK:0];
          wrmap_dat[wfwd_int] <= ddin_req[vwrite_ptr];
          wrmap_ptr[wfwd_int] <= vwrite_ptr;
        end else begin
          wrmap_vld[wfwd_int] <= 1'b0;
          wrmap_reg[wfwd_int] <= 0;
          wrmap_dat[wfwd_int] <= 0;
          wrmap_ptr[wfwd_int] <= vwrite_ptr;
        end
      end
    end

  reg               rdmap_vld [0:SRAM_DELAY-1];
  reg [BITVBNK:0]   rdmap_reg [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]   rdmap_dat [0:SRAM_DELAY-1];
  reg [BITCBNK-1:0] rdmap_ptr [0:SRAM_DELAY-1];
  integer rfwd_int;    
  always @(posedge clk) begin
    for (rfwd_int=0; rfwd_int<SRAM_DELAY; rfwd_int=rfwd_int+1)
      if (rfwd_int > 0) begin
        if (swrite && (swrradr == vrdradr_reg[rfwd_int-1])) begin
          rdmap_vld[rfwd_int] <= 1'b1;
          rdmap_reg[rfwd_int] <= sdin[BITVBNK:0];
          rdmap_dat[rfwd_int] <= ddin;
          rdmap_ptr[rfwd_int] <= rdmap_ptr[rfwd_int-1];
        end else begin
          rdmap_vld[rfwd_int] <= rdmap_vld[rfwd_int-1];
          rdmap_reg[rfwd_int] <= rdmap_reg[rfwd_int-1];            
          rdmap_dat[rfwd_int] <= rdmap_dat[rfwd_int-1];            
          rdmap_ptr[rfwd_int] <= rdmap_ptr[rfwd_int-1];
        end
      end else begin
        if (swrite && (swrradr == vrdradr_wire)) begin
          rdmap_vld[rfwd_int] <= 1'b1;
          rdmap_reg[rfwd_int] <= sdin[BITVBNK:0];
          rdmap_dat[rfwd_int] <= ddin;
          rdmap_ptr[rfwd_int] <= vread_ptr;
        end else if (swrite_req[vread_ptr] && (swrradr_req[vread_ptr] == vrdradr_wire)) begin
          rdmap_vld[rfwd_int] <= 1'b1;
          rdmap_reg[rfwd_int] <= sdin_req[vread_ptr][BITVBNK:0];
          rdmap_dat[rfwd_int] <= ddin_req[vread_ptr];
          rdmap_ptr[rfwd_int] <= vread_ptr;
        end else begin
          rdmap_vld[rfwd_int] <= 1'b0;
          rdmap_reg[rfwd_int] <= 0;
          rdmap_dat[rfwd_int] <= 0;
          rdmap_ptr[rfwd_int] <= vread_ptr;
        end
      end
    end

  reg wr_srch_flag;
  parameter SRCWDTH = 1 << BITWDTH;
  reg [SRCWDTH-1:0] wr_srch_data;
  reg wr_srch_flags;
  reg [SRCWDTH-1:0] wr_srch_datas;

  reg             rddat_vld [0:SRAM_DELAY-1];
  reg [WIDTH-1:0] rddat_reg [0:SRAM_DELAY-1];
  integer dfwd_int;
  always @(posedge clk) begin
    for (dfwd_int=0; dfwd_int<SRAM_DELAY; dfwd_int=dfwd_int+1)
      if (dfwd_int > 0) begin
        if (vwrite_out && vread_reg[dfwd_int-1] && (vwrbadr_out == vrdbadr_reg[dfwd_int-1]) && (vwrradr_out == vrdradr_reg[dfwd_int-1])) begin
          rddat_vld[dfwd_int] <= 1'b1;
          rddat_reg[dfwd_int] <= vdin_out;
        end else begin
          rddat_vld[dfwd_int] <= rddat_vld[dfwd_int-1];
          rddat_reg[dfwd_int] <= rddat_reg[dfwd_int-1];
        end
      end else begin
        if (vwrite_out && vread_wire && (vwrbadr_out == vrdbadr_wire) && (vwrradr_out == vrdradr_wire)) begin
          rddat_vld[dfwd_int] <= 1'b1;
          rddat_reg[dfwd_int] <= vdin_out;
        end else begin
          rddat_vld[dfwd_int] <= 1'b0;
          rddat_reg[dfwd_int] <= 0;
        end
      end
  end

  reg              pdat_vld [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]  pdat_reg [0:SRAM_DELAY-1];
  integer pfwd_int;
  always @(posedge clk) 
    for (pfwd_int=0; pfwd_int<SRAM_DELAY; pfwd_int=pfwd_int+1)
      if (pfwd_int > 0) begin
        if (pwrite && (pwrbadr == vrdbadr_reg[pfwd_int-1]) && (pwrradr == vrdradr_reg[pfwd_int-1])) begin
          pdat_vld[pfwd_int] <= 1'b1;
          pdat_reg[pfwd_int] <= pdin;
        end else begin
          pdat_vld[pfwd_int] <= pdat_vld[pfwd_int-1];
          pdat_reg[pfwd_int] <= pdat_reg[pfwd_int-1];
        end
      end else begin
        if (pwrite && (pwrbadr == vrdbadr_wire) && (pwrradr == vrdradr_wire)) begin
          pdat_vld[pfwd_int] <= 1'b1;
          pdat_reg[pfwd_int] <= pdin;
        end else begin
          pdat_vld[pfwd_int] <= 1'b0;
          pdat_reg[pfwd_int] <= 0;
        end
      end

  reg [WIDTH-1:0] ddout [0:NUMCBNK-1];
  reg ddout_fwrd [0:NUMCBNK-1];
  reg ddout_serr [0:NUMCBNK-1];
  reg ddout_derr [0:NUMCBNK-1];
  reg [BITPADR-BITPBNK-1:0] ddout_padr [0:NUMCBNK-1];
  integer ddo_int;
  always_comb
    for (ddo_int=0; ddo_int<NUMCBNK; ddo_int=ddo_int+1) begin
      ddout[ddo_int] = t2_doutA >> (ddo_int*WIDTH);
      ddout_fwrd[ddo_int] = t2_fwrdA >> ddo_int;
      ddout_serr[ddo_int] = t2_serrA >> ddo_int;
      ddout_derr[ddo_int] = t2_derrA >> ddo_int;
      ddout_padr[ddo_int] = t2_padrA >> (ddo_int*(BITPADR-BITPBNK));
    end

  reg [BITVBNK:0] sdout [0:NUMCBNK-1];
  reg sdout_fwrd [0:NUMCBNK-1];
  reg sdout_serr [0:NUMCBNK-1];
  reg sdout_derr [0:NUMCBNK-1];
  reg [BITPADR-BITPBNK-1:0] sdout_padr [0:NUMCBNK-1];
  integer sdo_int;
  always_comb
    for (sdo_int=0; sdo_int<NUMCBNK; sdo_int=sdo_int+1) begin
      sdout[sdo_int] = t3_doutA >> (sdo_int*(BITVBNK+1));
      sdout_fwrd[sdo_int] = t3_fwrdA >> sdo_int;
      sdout_serr[sdo_int] = t3_serrA >> sdo_int;
      sdout_derr[sdo_int] = t3_derrA >> sdo_int;
      sdout_padr[sdo_int] = t3_padrA >> (sdo_int*(BITPADR-BITPBNK));
    end

  integer prd_int;
  reg [BITVBNK-1:0] prdbadr_reg [0:SRAM_DELAY-1];
  always @(posedge clk)
    for (prd_int=0; prd_int<SRAM_DELAY; prd_int=prd_int+1)
      if (prd_int>0)
        prdbadr_reg[prd_int] <= prdbadr_reg[prd_int-1];
      else
        prdbadr_reg[prd_int] <= prdbadr;

  wire [WIDTH-1:0] pdout = t1_doutA >> (prdbadr_reg[SRAM_DELAY-1]*WIDTH);
  wire pdout_fwrd = t1_fwrdA >> prdbadr_reg[SRAM_DELAY-1];
  wire pdout_serr = t1_serrA >> prdbadr_reg[SRAM_DELAY-1];
  wire pdout_derr = t1_derrA >> prdbadr_reg[SRAM_DELAY-1];
  wire [BITPADR-BITPBNK-1:0] pdout_padr = t1_padrA >> (prdbadr_reg[SRAM_DELAY-1]*(BITPADR-BITPBNK));

  wire [BITVBNK:0] rdmap_out = rdmap_vld[SRAM_DELAY-1] ? rdmap_reg[SRAM_DELAY-1] : sdout[rdmap_ptr[SRAM_DELAY-1]];
  wire [WIDTH-1:0] rddat_out = rdmap_vld[SRAM_DELAY-1] ? rdmap_dat[SRAM_DELAY-1] : ddout[rdmap_ptr[SRAM_DELAY-1]];
  wire [WIDTH-1:0] pdat_out = pdat_vld[SRAM_DELAY-1] ? pdat_reg[SRAM_DELAY-1] : pdout;

  wire               vread_vld_tmp = vread_out;
  wire               vread_serr_tmp = (rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ? ddout_serr[rdmap_ptr[SRAM_DELAY-1]] : pdout_serr;
  wire               vread_derr_tmp = (rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ? ddout_derr[rdmap_ptr[SRAM_DELAY-1]] : pdout_derr;
  wire [WIDTH-1:0]   vdout_int = (rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ? rddat_out : pdat_out;
  wire [WIDTH-1:0]   vdout_tmp = rddat_vld[SRAM_DELAY-1] ? rddat_reg[SRAM_DELAY-1] : wr_srch_flag ? wr_srch_data : vdout_int;
  wire               vread_fwrd_tmp = (wr_srch_flag || rddat_vld[SRAM_DELAY-1] ||
                                       ((rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ?
                                        rdmap_vld[SRAM_DELAY-1] || ddout_fwrd[rdmap_ptr[SRAM_DELAY-1]] : pdat_vld[SRAM_DELAY-1] || pdout_fwrd));
  wire [BITPADR-1:0] vread_padr_tmp = (rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ?
                                       {NUMVBNK,ddout_padr[rdmap_ptr[SRAM_DELAY-1]]} : {vrdbadr_out,pdout_padr};

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

  wire [BITVBNK:0]   wrmap_out = wrmap_vld[SRAM_DELAY-1] ? wrmap_reg[SRAM_DELAY-1] : sdout[wrmap_ptr[SRAM_DELAY-1]];
  wire [WIDTH-1:0]   wrdat_out = wrmap_vld[SRAM_DELAY-1] ? wrmap_dat[SRAM_DELAY-1] : ddout[wrmap_ptr[SRAM_DELAY-1]];

  reg [3:0]          wrfifo_cnt; 
  reg                wrfifo_old_vld [0:FIFOCNT-1];
  reg [BITVBNK-1:0]  wrfifo_old_map [0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_old_dat [0:FIFOCNT-1];
  reg                wrfifo_new_vld [0:FIFOCNT-1];
  reg [BITVBNK-1:0]  wrfifo_new_map [0:FIFOCNT-1];
  reg [BITVROW-1:0]  wrfifo_new_row [0:FIFOCNT-1];
  reg [WIDTH-1:0]    wrfifo_new_dat [0:FIFOCNT-1];
  
  wire wrfifo_deq1 = |wrfifo_cnt;
  always @(posedge clk)
    if (rst)
      wrfifo_cnt <= 0;
    else
      wrfifo_cnt <= wrfifo_cnt + vwrite_out - wrfifo_deq1;
  
  integer wfifo_int;
  always @(posedge clk)
    for (wfifo_int=FIFOCNT-1; wfifo_int>=0; wfifo_int=wfifo_int-1)
      if (vwrite_out && (wrfifo_cnt == (wrfifo_deq1+wfifo_int))) begin
        if (swrite && (swrradr == vwrradr_out)) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin[BITVBNK-1:0];
          wrfifo_old_dat[wfifo_int] <= ddin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= wrmap_out[BITVBNK];
          wrfifo_old_map[wfifo_int] <= wrmap_out;
          wrfifo_old_dat[wfifo_int] <= wrdat_out;
        end
        wrfifo_new_vld[wfifo_int] <= 1'b1;
        wrfifo_new_map[wfifo_int] <= vwrbadr_out;
        wrfifo_new_row[wfifo_int] <= vwrradr_out;
        wrfifo_new_dat[wfifo_int] <= vdin_out;
      end else if (wrfifo_deq1 && (wfifo_int<FIFOCNT-1)) begin
        if (swrite && (swrradr == wrfifo_new_row[wfifo_int+1])) begin
          wrfifo_old_vld[wfifo_int] <= sdin[BITVBNK];
          wrfifo_old_map[wfifo_int] <= sdin[BITVBNK-1:0];
          wrfifo_old_dat[wfifo_int] <= ddin;
        end else begin
          wrfifo_old_vld[wfifo_int] <= wrfifo_old_vld[wfifo_int+1];
          wrfifo_old_map[wfifo_int] <= wrfifo_old_map[wfifo_int+1];
          wrfifo_old_dat[wfifo_int] <= wrfifo_old_dat[wfifo_int+1];
        end
        wrfifo_new_vld[wfifo_int] <= wrfifo_new_vld[wfifo_int+1];
        wrfifo_new_map[wfifo_int] <= wrfifo_new_map[wfifo_int+1];
        wrfifo_new_row[wfifo_int] <= wrfifo_new_row[wfifo_int+1];
        wrfifo_new_dat[wfifo_int] <= wrfifo_new_dat[wfifo_int+1];
      end

  integer wsrc_int;
  always_comb begin
    wr_srch_flag = 1'b0;
    wr_srch_data = 0;
    for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] &&
	  (wrfifo_new_map[wsrc_int] == vrdbadr_reg[SRAM_DELAY-1]) &&
	  (wrfifo_new_row[wsrc_int] == vrdradr_reg[SRAM_DELAY-1])) begin
        wr_srch_flag = 1'b1;
        wr_srch_data = wrfifo_new_dat[wsrc_int];
      end
//    wr_srch_dbit = wr_srch_data[select_bit];
    wr_srch_flags = 1'b0;
    wr_srch_datas = 0;
    for (wsrc_int=0; wsrc_int<FIFOCNT; wsrc_int=wsrc_int+1)
      if ((wrfifo_cnt > wsrc_int) && wrfifo_new_vld[wsrc_int] && (wrfifo_new_map[wsrc_int] == select_bank) && (wrfifo_new_row[wsrc_int] == select_row)) begin
        wr_srch_flags = 1'b1;
        wr_srch_datas = wrfifo_new_dat[wsrc_int];
      end
//    wr_srch_dbits = wr_srch_datas[select_bit];
  end

  wire               sold_vld = wrfifo_deq1 && wrfifo_old_vld[0];
  wire [BITVBNK-1:0] sold_map = wrfifo_old_map[0];
  wire [BITVROW-1:0] sold_row = wrfifo_new_row[0];
  wire [WIDTH-1:0]   sold_dat = wrfifo_old_dat[0];
  wire               snew_vld = wrfifo_deq1 && wrfifo_new_vld[0];
  wire [BITVBNK-1:0] snew_map = wrfifo_new_map[0];
  wire [BITVROW-1:0] snew_row = wrfifo_new_row[0];
  wire [WIDTH-1:0]   snew_dat = wrfifo_new_dat[0];

  wire new_to_cache = snew_vld && (vread_wire && (vrdbadr_wire == snew_map));
  wire new_to_pivot = snew_vld && !new_to_cache;

  wire old_to_pivot = sold_vld && new_to_cache && (sold_map != snew_map);
  wire old_to_clear = sold_vld && new_to_pivot && (sold_map == snew_map);

  always_comb
    if (new_to_pivot) begin
      pwrite = 1'b1;
      pwrbadr = snew_map;
      pwrradr = snew_row;
      pdin = snew_dat;
    end else if (old_to_pivot) begin
      pwrite = 1'b1;
      pwrbadr = sold_map;
      pwrradr = sold_row;
      pdin = sold_dat;
    end else begin
      pwrite = 1'b0;
      pwrbadr = 0;
      pwrradr = 0;
      pdin = 0;
    end

  assign t1_readA = pread ? (pread << prdbadr) : 0;
  assign t1_writeA = pwrite ? (pwrite << pwrbadr) : 0;

  integer t1_addr_int;
  reg [NUMVBNK*BITVROW-1:0] t1_addrA;
  always_comb begin
    t1_addrA = 0;
    for (t1_addr_int=0; t1_addr_int<NUMVBNK; t1_addr_int=t1_addr_int+1)
      if (pwrite && (pwrbadr == t1_addr_int))
        t1_addrA =  t1_addrA | (pwrradr << (BITVROW*t1_addr_int));
      else
        t1_addrA =  t1_addrA | (prdradr << (BITVROW*t1_addr_int));
  end

  assign t1_dinA = {NUMVBNK{pdin}};

  always_comb
    if (rstvld) begin
      swrite = !rst;
      swrradr = rstaddr;
      sdin = 0;
      ddin = 0;
    end else if (new_to_cache) begin
      swrite = 1'b1;
      swrradr = snew_row;
      sdin = {1'b1,snew_map};
      ddin = snew_dat;
    end else if (old_to_clear) begin
      swrite = 1'b1;
      swrradr = sold_row;
      sdin = 0;
      ddin = 0;
    end else begin
      swrite = 1'b0;
      swrradr = 0; 
      sdin = 0;
      ddin = 0;
    end

  reg swrite_wire [0:NUMCBNK-1];
  reg [BITVROW-1:0] swrradr_wire [0:NUMCBNK-1];
  reg [BITVBNK:0] sdin_wire [0:NUMCBNK-1];
  reg [WIDTH-1:0] ddin_wire [0:NUMCBNK-1];
  integer swr_int;
  always_comb
    for (swr_int=0; swr_int<NUMCBNK; swr_int=swr_int+1) begin
      swrite_wire[swr_int] = 1'b0;
      swrradr_wire[swr_int] = 0;
      sdin_wire[swr_int] = 0;
      ddin_wire[swr_int] = 0;
      if (!sread_wire[swr_int] && swrite_req[swr_int]) begin
        swrite_wire[swr_int] = 1'b1;
        swrradr_wire[swr_int] = swrradr_req[swr_int];
        sdin_wire[swr_int] = sdin_req[swr_int];
        ddin_wire[swr_int] = ddin_req[swr_int];
      end else if (!sread_wire[swr_int] && swrite) begin
        swrite_wire[swr_int] = 1'b1;
        swrradr_wire[swr_int] = swrradr;
        sdin_wire[swr_int] = sdin;
        ddin_wire[swr_int] = ddin;
      end
    end

  integer swrr_int;
  always @(posedge clk)
    for (swrr_int=0; swrr_int<NUMCBNK; swrr_int=swrr_int+1)
      if (rst)
        swrite_req[swrr_int] <= 1'b0;
      else if (swrite && (!swrite_wire[swrr_int] || swrite_req[swrr_int])) begin
        swrite_req[swrr_int] <= 1'b1;
        swrradr_req[swrr_int] <= swrradr;
        sdin_req[swrr_int] <= sdin;
        ddin_req[swrr_int] <= ddin;
      end else if (swrite_wire[swrr_int])
        swrite_req[swrr_int] <= 1'b0;

  wire swrite_req_0 = swrite_req[0];
  wire [BITVROW-1:0] swrradr_req_0 = swrradr_req[0];
  wire [BITVBNK:0] sdin_req_0 = sdin_req[0];
  wire [WIDTH-1:0] ddin_req_0 = ddin_req[0];
  wire swrite_req_1 = swrite_req[1];
  wire [BITVROW-1:0] swrradr_req_1 = swrradr_req[1];
  wire [BITVBNK:0] sdin_req_1 = sdin_req[1];
  wire [WIDTH-1:0] ddin_req_1 = ddin_req[1];

  reg [NUMCBNK-1:0] t2_readA;
  reg [NUMCBNK-1:0] t2_writeA;
  reg [NUMCBNK*BITVROW-1:0] t2_addrA;
  reg [NUMCBNK*WIDTH-1:0] t2_dinA;
  reg [NUMCBNK*(BITVBNK+1)-1:0] t3_dinA;
  integer t2_int;
  always_comb begin
    t2_readA = 0;
    t2_writeA = 0;
    t2_addrA = 0;
    t2_dinA = 0;
    t3_dinA = 0;
    for (t2_int=0; t2_int<NUMCBNK; t2_int=t2_int+1) begin
      if (sread_wire[t2_int]) begin
        t2_readA = t2_readA | (1'b1 << t2_int);
        t2_addrA = t2_addrA | (srdradr_wire[t2_int] << (t2_int*BITVROW));
      end
      if (swrite_wire[t2_int]) begin
        t2_writeA = t2_writeA | (1'b1 << t2_int);
        t2_addrA = t2_addrA | (swrradr_wire[t2_int] << (t2_int*BITVROW));
        t2_dinA = t2_dinA | (ddin_wire[t2_int] << (t2_int*WIDTH));
        t3_dinA = t3_dinA | (sdin_wire[t2_int] << (t2_int*(BITVBNK+1)));
      end
    end
  end
      
  assign t3_readA = t2_readA;
  assign t3_writeA = t2_writeA;
  assign t3_addrA = t2_addrA;

  wire sread_wire_0 = sread_wire[0];
  wire [BITVROW-1:0] srdradr_wire_0 = srdradr_wire[0];
  wire swrite_wire_0 = swrite_wire[0];
  wire [BITVROW-1:0] swrradr_wire_0 = swrradr_wire[0];
  wire [BITVBNK:0] sdin_wire_0 = sdin_wire[0];
  wire [WIDTH-1:0] ddin_wire_0 = ddin_wire[0];
  wire sread_wire_1 = sread_wire[1];
  wire [BITVROW-1:0] srdradr_wire_1 = srdradr_wire[1];
  wire swrite_wire_1 = swrite_wire[1];
  wire [BITVROW-1:0] swrradr_wire_1 = swrradr_wire[1];
  wire [BITVBNK:0] sdin_wire_1 = sdin_wire[1];
  wire [WIDTH-1:0] ddin_wire_1 = ddin_wire[1];

endmodule
