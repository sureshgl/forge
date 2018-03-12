module core_1ru_nr1w_b2 (vwrite, vaddr, vdin,
                      vread, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                      pwrite, pwrradr, pdin, pread, prdradr, pdout, pdout_fwrd, pdout_serr, pdout_derr, pdout_padr,
	              ready, clk, rst,
		      select_addr, select_bit);
 
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRUPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 256;
  parameter BITVROW = 8;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPADR = 14;
  parameter NUMCOLS = 4; // Power of 2
  parameter BITCOLS = 2;

  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  input                                vwrite;
  input [BITADDR-1:0]                  vaddr;
  input [WIDTH-1:0]                    vdin;
  
  input [NUMRUPT-1:0]                  vread;
  output [NUMRUPT-1:0]                 vread_vld;
  output [NUMRUPT*WIDTH-1:0]           vdout;
  output [NUMRUPT-1:0]                 vread_fwrd;
  output [NUMRUPT-1:0]                 vread_serr;
  output [NUMRUPT-1:0]                 vread_derr;
  output [NUMRUPT*BITPADR-1:0]         vread_padr;

  output [NUMRUPT*NUMVBNK-1:0]         pwrite;
  output [NUMRUPT*NUMVBNK*(BITVROW+BITCOLS)-1:0] pwrradr;
  output [NUMRUPT*NUMVBNK*WIDTH-1:0]   pdin;

  output [NUMRUPT*NUMVBNK-1:0]         pread;
  output [NUMRUPT*NUMVBNK*(BITVROW+BITCOLS)-1:0] prdradr;
  input [NUMRUPT*NUMVBNK*WIDTH-1:0]    pdout;
  input [NUMRUPT*NUMVBNK-1:0]          pdout_fwrd;
  input [NUMRUPT*NUMVBNK-1:0]          pdout_serr;
  input [NUMRUPT*NUMVBNK-1:0]          pdout_derr;
  input [NUMRUPT*NUMVBNK*(BITPADR-BITVBNK)-1:0] pdout_padr;

  output                               ready;
  input                                clk;
  input                                rst;

  input [BITADDR-1:0]                  select_addr;
  input [BITWDTH-1:0]                  select_bit;
  
  reg [BITVROW+BITCOLS:0] rstaddr;
  wire rstvld = rstaddr < NUMVROW;
  always @(posedge clk)
    if (rst)
      rstaddr <= 0;
    else if (rstvld)
      rstaddr <= rstaddr + 1;

  reg ready;
  always @(posedge clk)
    ready <= !rstvld;

  wire vread_wire [0:NUMRUPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMRUPT-1];
  wire [BITVBNK-1:0] vrdbadr_wire [0:NUMRUPT-1];
  wire [BITCOLS-1:0] vrdcadr_wire [0:NUMRUPT-1];
  wire [BITVROW-1:0] vrdradr_wire [0:NUMRUPT-1];
  wire vwrite_wire;
  wire [BITADDR-1:0] vwraddr_wire;
  wire [WIDTH-1:0] vdin_wire;
  wire [BITVBNK-1:0] vwrbadr_wire;
  wire [BITCOLS-1:0] vwrcadr_wire;
  wire [BITVROW-1:0] vwrradr_wire;
  wire [BITVBNK-1:0] select_bank;
  wire [BITVROW-1:0] select_row;
  wire [BITCOLS-1:0] select_col;

// Delay write interface signals
  reg [(((SRAM_DELAY+FLOPIN+FLOPOUT)*BITADDR)-1):0] vaddr_del;
  always @(posedge clk)
    vaddr_del <= {vaddr_del, vaddr};

  wire [BITADDR-1:0] vaddr_del_max = vaddr_del >> ((SRAM_DELAY+FLOPIN+FLOPOUT-1)*BITADDR);
    
  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg [NUMRUPT-1:0] vread_reg;
    reg [NUMRUPT*BITADDR-1:0] vrdaddr_reg;
    reg vwrite_reg;
    reg [BITADDR-1:0] vwraddr_reg;
    reg [WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread & {NUMRUPT{ready}};
      vrdaddr_reg <= vaddr;
      vwrite_reg <= vwrite & ready;
      vwraddr_reg <= vaddr_del_max;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    for (np2_var=0; np2_var<NUMRUPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr_reg >> (np2_var*BITADDR);
      wire [BITVROW+BITCOLS-1:0] vrdrow_flpi_temp;

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW*NUMCOLS), .BITVROW (BITVROW+BITCOLS))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdrow_flpi_temp), .vaddr(vrdaddr_wire[np2_var]));

      assign vrdcadr_wire[np2_var] = (NUMCOLS>1) ? vrdrow_flpi_temp : 0;
      assign vrdradr_wire[np2_var] = vrdrow_flpi_temp >> BITCOLS;
    end

    assign vwrite_wire = vwrite_reg && (vwraddr_wire < NUMADDR);
    assign vwraddr_wire = vwraddr_reg;
    assign vdin_wire = vdin_reg;
    wire [BITVROW+BITCOLS-1:0] vwrrow_flpi_temp;

    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW*NUMCOLS), .BITVROW (BITVROW+BITCOLS))
      wr_adr_inst (.vbadr(vwrbadr_wire), .vradr(vwrrow_flpi_temp), .vaddr(vwraddr_wire));

    assign vwrcadr_wire = (NUMCOLS>1) ? vwrrow_flpi_temp : 0;
    assign vwrradr_wire = vwrrow_flpi_temp >> BITCOLS;

    wire [BITVROW+BITCOLS-1:0] selrow_flpi_temp;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW*NUMCOLS), .BITVROW (BITVROW+BITCOLS))
      sl_adr (.vbadr(select_bank), .vradr(selrow_flpi_temp), .vaddr(select_addr));

    assign select_col = (NUMCOLS>1) ? selrow_flpi_temp : 0;
    assign select_row = selrow_flpi_temp >> BITCOLS;
  end else begin: noflpi_loop
    assign ready_wire = ready;
    for (np2_var=0; np2_var<NUMRUPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread >> np2_var;
      assign vrdaddr_wire[np2_var] = vaddr >> (np2_var*BITADDR);
      wire [BITVROW+BITCOLS-1:0] vrdrow_noflpi_temp;

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW*NUMCOLS), .BITVROW (BITVROW+BITCOLS))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdrow_noflpi_temp), .vaddr(vrdaddr_wire[np2_var]));

      assign vrdcadr_wire[np2_var] = (NUMCOLS>1) ? vrdrow_noflpi_temp : 0;
      assign vrdradr_wire[np2_var] = vrdrow_noflpi_temp >> BITCOLS;
    end

    assign vwrite_wire = vwrite && (vwraddr_wire < NUMADDR);
    assign vwraddr_wire = vaddr_del_max;
    assign vdin_wire = vdin;
    wire [BITVROW+BITCOLS-1:0] vwrrow_noflpi_temp;

    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW*NUMCOLS), .BITVROW (BITVROW+BITCOLS))
      wr_adr_inst (.vbadr(vwrbadr_wire), .vradr(vwrrow_noflpi_temp), .vaddr(vwraddr_wire));

    assign vwrcadr_wire = (NUMCOLS>1) ? vwrrow_noflpi_temp : 0;
    assign vwrradr_wire = vwrrow_noflpi_temp >> BITCOLS;

    wire [BITVROW+BITCOLS-1:0] selrow_noflpi_temp;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW*NUMCOLS), .BITVROW (BITVROW+BITCOLS))
      sl_adr (.vbadr(select_bank), .vradr(selrow_noflpi_temp), .vaddr(select_addr));

    assign select_col = (NUMCOLS>1) ? selrow_noflpi_temp : 0;
    assign select_row = selrow_noflpi_temp >> BITCOLS;
  end
  endgenerate

  reg               vwrite_del [0:NUMRUPT-1][0:NUMCOLS-1];
  reg [BITVBNK-1:0] vwrbadr_del [0:NUMRUPT-1][0:NUMCOLS-1];
  reg [BITVROW-1:0] vwrradr_del [0:NUMRUPT-1][0:NUMCOLS-1];
  reg [WIDTH-1:0]   vdin_del [0:NUMRUPT-1][0:NUMCOLS-1];

  reg select_vld [0:NUMRUPT-1];
  reg select_dat [0:NUMRUPT-1];
  integer sel_int;
  always_comb
    for (sel_int=0; sel_int<NUMRUPT; sel_int=sel_int+1) begin
      select_vld[sel_int] = vwrite_del[sel_int][select_col] &&
			    (vwrbadr_del[sel_int][select_col] == select_bank) &&
			    (vwrradr_del[sel_int][select_col] == select_row);
      select_dat[sel_int] = vdin_del[sel_int][select_col][select_bit];
    end 

  wire select_vld_0 = select_vld[0];
  wire select_dat_0 = select_dat[0];

  reg move [0:NUMRUPT-1];
  reg clear [0:NUMRUPT-1];


  integer cflt_int;
  always_comb
    for (cflt_int=0; cflt_int<NUMRUPT; cflt_int=cflt_int+1) begin
      move[cflt_int] = vread_wire[cflt_int] && vwrite_wire && (vrdbadr_wire[cflt_int] == vwrbadr_wire) && (vrdradr_wire[cflt_int] == vwrradr_wire);
      clear[cflt_int] = !move[cflt_int] && vwrite_del[cflt_int][vwrcadr_wire] &&
			 vwrite_wire && (vwrbadr_del[cflt_int][vwrcadr_wire] == vwrbadr_wire) && (vwrradr_del[cflt_int][vwrcadr_wire] == vwrradr_wire);
    end

  integer vwpt_int, vwcl_int;
  always @(posedge clk)
    for (vwpt_int=0; vwpt_int<NUMRUPT; vwpt_int=vwpt_int+1) 
      if (rst)
        for (vwcl_int=0; vwcl_int<NUMCOLS; vwcl_int=vwcl_int+1)  begin
          vwrite_del[vwpt_int][vwcl_int] <= 1'b0;
          vwrbadr_del[vwpt_int][vwcl_int] <= 0;
          vwrradr_del[vwpt_int][vwcl_int] <= 0;
          vdin_del[vwpt_int][vwcl_int] <= 0;
        end
      else if (move[vwpt_int]) begin
        vwrite_del[vwpt_int][vwrcadr_wire] <= 1'b1;
        vwrbadr_del[vwpt_int][vwrcadr_wire] <= vwrbadr_wire;
        vwrradr_del[vwpt_int][vwrcadr_wire] <= vwrradr_wire;
        vdin_del[vwpt_int][vwrcadr_wire] <= vdin_wire;
      end else if (clear[vwpt_int])
        vwrite_del[vwpt_int][vwrcadr_wire] <= 1'b0; 

  reg vwrite_int [0:NUMRUPT-1];
  reg [BITVBNK-1:0] vwrbadr_int [0:NUMRUPT-1];
  reg [BITVROW-1:0] vwrradr_int [0:NUMRUPT-1];
  reg [BITCOLS-1:0] vwrcadr_int [0:NUMRUPT-1];
  reg [WIDTH-1:0] vdin_int [0:NUMRUPT-1];
  reg vread_int [0:NUMRUPT-1];
  reg [BITVBNK-1:0] vrdbadr_int [0:NUMRUPT-1];
  reg [BITVROW-1:0] vrdradr_int [0:NUMRUPT-1];
  reg [BITCOLS-1:0] vrdcadr_int [0:NUMRUPT-1];
  integer vcft_int;
  always_comb
    for (vcft_int=0; vcft_int<NUMRUPT; vcft_int=vcft_int+1) begin
      vwrite_int[vcft_int] = 0;
      vwrbadr_int[vcft_int] = 0;
      vwrradr_int[vcft_int] = 0;
      vwrcadr_int[vcft_int] = 0;
      vdin_int[vcft_int] = 0;
      vread_int[vcft_int] = 0;
      vrdbadr_int[vcft_int] = 0;
      vrdradr_int[vcft_int] = 0;
      vrdcadr_int[vcft_int] = 0;
      if (vread_wire[vcft_int]) begin
        vread_int[vcft_int] = 1'b1;
        vrdbadr_int[vcft_int] = vrdbadr_wire[vcft_int];
        vrdradr_int[vcft_int] = vrdradr_wire[vcft_int];
        vrdcadr_int[vcft_int] = vrdcadr_wire[vcft_int];
      end
      if (vwrite_wire) begin
        vwrite_int[vcft_int] = 1'b1;
        vwrbadr_int[vcft_int] = vwrbadr_wire;
        vwrradr_int[vcft_int] = vwrradr_wire;
        vwrcadr_int[vcft_int] = vwrcadr_wire;
        vdin_int[vcft_int] = vdin_wire;
      end
    end

  reg                vread_reg [0:NUMRUPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:NUMRUPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg [BITVROW-1:0]  vrdradr_reg [0:NUMRUPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg                vread_fwd [0:NUMRUPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg [WIDTH-1:0]    vread_dat [0:NUMRUPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg                vread_reg_comb [0:NUMRUPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg [BITVBNK-1:0]  vrdbadr_reg_comb [0:NUMRUPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg [BITVROW-1:0]  vrdradr_reg_comb [0:NUMRUPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg                vread_fwd_comb [0:NUMRUPT-1][0:SRAM_DELAY+FLOPOUT-1];
  reg [WIDTH-1:0]    vread_dat_comb [0:NUMRUPT-1][0:SRAM_DELAY+FLOPOUT-1];
  integer vreg_c_int, vrpt_c_int;
  integer vreg_int, vrpt_int;

  always_comb
    for (vreg_c_int=0; vreg_c_int<SRAM_DELAY+FLOPOUT; vreg_c_int=vreg_c_int+1) begin
      if (vreg_c_int>0) begin
        for (vrpt_c_int=0; vrpt_c_int<NUMRUPT; vrpt_c_int=vrpt_c_int+1) begin 
          vread_reg_comb[vrpt_c_int][vreg_c_int] = vread_reg[vrpt_c_int][vreg_c_int-1];
          vrdbadr_reg_comb[vrpt_c_int][vreg_c_int] = vrdbadr_reg[vrpt_c_int][vreg_c_int-1];
          vrdradr_reg_comb[vrpt_c_int][vreg_c_int] = vrdradr_reg[vrpt_c_int][vreg_c_int-1];
          if (vwrite_wire && (vwrbadr_wire == vrdbadr_reg[vrpt_c_int][vreg_c_int-1]) && (vwrradr_wire == vrdradr_reg[vrpt_c_int][vreg_c_int-1])) begin
            vread_fwd_comb[vrpt_c_int][vreg_c_int] = 1;
            vread_dat_comb[vrpt_c_int][vreg_c_int] = vdin_wire;
          end else begin
            vread_fwd_comb[vrpt_c_int][vreg_c_int] = vread_fwd[vrpt_c_int][vreg_c_int-1];
            vread_dat_comb[vrpt_c_int][vreg_c_int] = vread_dat[vrpt_c_int][vreg_c_int-1];
          end
        end
      end else begin
        for (vrpt_c_int=0; vrpt_c_int<NUMRUPT; vrpt_c_int=vrpt_c_int+1) begin 
          vread_reg_comb[vrpt_c_int][vreg_c_int]   = vread_wire[vrpt_c_int];
          vrdbadr_reg_comb[vrpt_c_int][vreg_c_int] = vrdbadr_wire[vrpt_c_int];
          vrdradr_reg_comb[vrpt_c_int][vreg_c_int] = vrdradr_wire[vrpt_c_int];
          if (vwrite_wire && (vwrbadr_wire == vrdbadr_wire[vrpt_c_int]) && (vwrradr_wire == vrdradr_wire[vrpt_c_int])) begin
            vread_fwd_comb[vrpt_c_int][vreg_c_int] = 1;
            vread_dat_comb[vrpt_c_int][vreg_c_int] = vdin_wire;
          end else begin
            vread_fwd_comb[vrpt_c_int][vreg_c_int] = 0;
            vread_dat_comb[vrpt_c_int][vreg_c_int] = 0;
          end
        end
      end
    end

  always @(posedge clk) begin
    for (vreg_int=0; vreg_int<SRAM_DELAY+FLOPOUT; vreg_int=vreg_int+1) begin
      if (rst) begin
        for (vrpt_int=0; vrpt_int<NUMRUPT; vrpt_int=vrpt_int+1)  begin
          vread_reg[vrpt_int][vreg_int]   <= 0;
          vrdbadr_reg[vrpt_int][vreg_int] <= 0;
          vrdradr_reg[vrpt_int][vreg_int] <= 0;
          vread_fwd[vrpt_int][vreg_int]   <= 0;
          vread_dat[vrpt_int][vreg_int]   <= 0;
        end
      end else begin
        for (vrpt_int=0; vrpt_int<NUMRUPT; vrpt_int=vrpt_int+1)  begin
          vread_reg[vrpt_int][vreg_int]   <= vread_reg_comb[vrpt_int][vreg_int];
          vrdbadr_reg[vrpt_int][vreg_int] <= vrdbadr_reg_comb[vrpt_int][vreg_int];
          vrdradr_reg[vrpt_int][vreg_int] <= vrdradr_reg_comb[vrpt_int][vreg_int];
          vread_fwd[vrpt_int][vreg_int]   <= vread_fwd_comb[vrpt_int][vreg_int];
          vread_dat[vrpt_int][vreg_int]   <= vread_dat_comb[vrpt_int][vreg_int];
        end
      end
    end
  end

  reg               vread_out [0:NUMRUPT-1];
  reg [BITVBNK-1:0] vrdbadr_out [0:NUMRUPT-1];
  reg               vread_fwd_out [0:NUMRUPT-1];
  reg [WIDTH-1:0]   vread_dat_out [0:NUMRUPT-1]; 
  integer vdel_int;
  always_comb begin
    for (vdel_int=0; vdel_int<NUMRUPT; vdel_int=vdel_int+1) begin
      if (FLOPOUT) begin
        vrdbadr_out[vdel_int] = vrdbadr_reg_comb[vdel_int][SRAM_DELAY+FLOPOUT-1];
        vread_fwd_out[vdel_int] = vread_fwd_comb[vdel_int][SRAM_DELAY+FLOPOUT-1];
        vread_out[vdel_int] = vread_reg_comb[vdel_int][SRAM_DELAY+FLOPOUT-1];
        vread_dat_out[vdel_int] = vread_dat_comb[vdel_int][SRAM_DELAY+FLOPOUT-1];
      end else begin
        vrdbadr_out[vdel_int] = vrdbadr_reg[vdel_int][SRAM_DELAY+FLOPOUT-1];
        vread_fwd_out[vdel_int] = vread_fwd[vdel_int][SRAM_DELAY+FLOPOUT-1];
        vread_out[vdel_int] = vread_reg[vdel_int][SRAM_DELAY+FLOPOUT-1];
        vread_dat_out[vdel_int] = vread_dat[vdel_int][SRAM_DELAY+FLOPOUT-1];
      end
    end
  end

  reg [NUMRUPT*NUMVBNK-1:0] pwrite;
  reg [NUMRUPT*NUMVBNK*(BITVROW+BITCOLS)-1:0] pwrradr;
  reg [NUMRUPT*NUMVBNK*WIDTH-1:0] pdin;
  reg [NUMRUPT*NUMVBNK-1:0] pread;
  reg [NUMRUPT*NUMVBNK*(BITVROW+BITCOLS)-1:0] prdradr;
  reg [BITVROW+BITCOLS-1:0] radr_temp;
  integer prd_int;
  always_comb begin
    radr_temp = 0;
    pwrite = 0;
    pwrradr = 0;
    pdin = 0;
    pread = 0;
    prdradr = 0;
    if (rstvld && !rst) begin
      pwrite = ~0;
      pwrradr = {(NUMRUPT*NUMVBNK){rstaddr[BITVROW+BITCOLS-1:0]}};
      pdin = 0;
    end else 
    for (prd_int=0; prd_int<NUMRUPT; prd_int=prd_int+1) begin
      if (vwrite_int[prd_int]) begin  
        radr_temp = (NUMCOLS>1) ? {vwrradr_int[prd_int],vwrcadr_int[prd_int]} : vwrradr_int[prd_int];
        pwrite = pwrite | (1'b1 << (vwrbadr_int[prd_int]*NUMRUPT+prd_int));
        pwrradr = pwrradr | (radr_temp << ((vwrbadr_int[prd_int]*NUMRUPT+prd_int)*(BITVROW+BITCOLS)));
        pdin = pdin | (vdin_int[prd_int] << ((vwrbadr_int[prd_int]*NUMRUPT+prd_int)*WIDTH));
      end
      if (vread_int[prd_int]) begin
        radr_temp = (NUMCOLS>1) ? {vrdradr_int[prd_int],vrdcadr_int[prd_int]} : vrdradr_int[prd_int];
        pread = pread | (1'b1 << (vrdbadr_wire[prd_int]*NUMRUPT+prd_int));
        prdradr = prdradr | (radr_temp << ((vrdbadr_int[prd_int]*NUMRUPT+prd_int)*(BITVROW+BITCOLS)));
      end
    end
  end   

  reg               vread_vld_wire [0:NUMRUPT-1];
  reg [WIDTH-1:0]   vdout_wire [0:NUMRUPT-1];
  reg               vread_fwrd_wire [0:NUMRUPT-1];
  reg               vread_fwrd_help [0:NUMRUPT-1];
  reg               vread_serr_wire [0:NUMRUPT-1];
  reg               vread_derr_wire [0:NUMRUPT-1];
  reg [BITPADR-BITVBNK-1:0] vread_padr_help [0:NUMRUPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:NUMRUPT-1];
  integer vrd_int;
  always_comb 
    for (vrd_int=0; vrd_int<NUMRUPT; vrd_int=vrd_int+1) begin
      vread_vld_wire[vrd_int] = vread_out[vrd_int];
      vdout_wire[vrd_int] = vread_fwd_out[vrd_int] ? vread_dat_out[vrd_int] : pdout >> ((NUMRUPT*vrdbadr_out[vrd_int]+vrd_int)*WIDTH);
      vread_fwrd_help[vrd_int] = pdout_fwrd >> (NUMRUPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_fwrd_wire[vrd_int] = vread_fwd_out[vrd_int] || vread_fwrd_help[vrd_int];
      vread_serr_wire[vrd_int] = pdout_serr >> (NUMRUPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_derr_wire[vrd_int] = pdout_derr >> (NUMRUPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_padr_help[vrd_int] = pdout_padr >> ((NUMRUPT*vrdbadr_out[vrd_int]+vrd_int)*(BITPADR-BITVBNK));
      vread_padr_wire[vrd_int] = {vrdbadr_out[vrd_int],vread_padr_help[vrd_int]};
    end

  reg [NUMRUPT-1:0]         vread_vld_tmp;
  reg [NUMRUPT*WIDTH-1:0]   vdout_tmp;
  reg [NUMRUPT-1:0]         vread_fwrd_tmp;
  reg [NUMRUPT-1:0]         vread_serr_tmp;
  reg [NUMRUPT-1:0]         vread_derr_tmp;
  reg [NUMRUPT*BITPADR-1:0] vread_padr_tmp;
  integer vwire_int;
  always_comb begin
    vread_vld_tmp = 0;
    vdout_tmp = 0;
    vread_fwrd_tmp = 0;
    vread_serr_tmp = 0;
    vread_derr_tmp = 0;
    vread_padr_tmp = 0;
    for (vwire_int=0; vwire_int<NUMRUPT; vwire_int=vwire_int+1) begin
      vread_vld_tmp = vread_vld_tmp | (vread_out[vwire_int] << vwire_int);
      vdout_tmp = vdout_tmp | (vdout_wire[vwire_int] << (vwire_int*WIDTH));
      vread_fwrd_tmp = vread_fwrd_tmp | (vread_fwrd_wire[vwire_int] << vwire_int);
      vread_serr_tmp = vread_serr_tmp | (vread_serr_wire[vwire_int] << vwire_int);
      vread_derr_tmp = vread_derr_tmp | (vread_derr_wire[vwire_int] << vwire_int);
      vread_padr_tmp = vread_padr_tmp | (vread_padr_wire[vwire_int] << (vwire_int*BITPADR));
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

/*
// Debug
  wire vwrite_int_0 = vwrite_int[0];
  wire [BITVBNK-1:0] vwrbadr_int_0 = vwrbadr_int[0];
  wire [BITVROW-1:0] vwrradr_int_0 = vwrradr_int[0];
  wire [BITCOLS-1:0] vwrcadr_int_0 = vwrcadr_int[0];
  wire [WIDTH-1:0] vdin_int_0 = vdin_int[0];
  wire vread_int_0 = vread_int[0];
  wire [BITVBNK-1:0] vrdbadr_int_0 = vrdbadr_int[0];
  wire [BITVROW-1:0] vrdradr_int_0 = vrdradr_int[0];
  wire [BITCOLS-1:0] vrdcadr_int_0 = vrdcadr_int[0];
  wire vread_wire_0 = vread_wire[0];
  wire [BITVBNK-1:0] vrdbadr_wire_0 = vrdbadr_wire[0];
  wire [BITVROW-1:0] vrdradr_wire_0 = vrdradr_wire[0];
  wire [BITVROW-1:0] vrdcadr_wire_0 = vrdcadr_wire[0];
  wire vwrite_del_0_0 = vwrite_del[0][0];
  wire [BITVBNK-1:0] vwrbadr_del_0_0 = vwrbadr_del[0][0];
  wire [BITVROW-1:0] vwrradr_del_0_0 = vwrradr_del[0][0];
  wire [WIDTH-1:0] vdin_del_0_0 = vdin_del[0][0];
  wire move_0 = move[0];
  wire clear_0 = clear[0];
  wire               vread_reg_int_0   = vread_reg[0][0];
  wire [BITVBNK-1:0] vrdbadr_reg_int_0 = vrdbadr_reg[0][0];
  wire [BITVROW-1:0] vrdradr_reg_int_0 = vrdradr_reg[0][0];
  wire               vread_fwd_int_0   = vread_fwd[0][0];
  wire               vread_fwd_int_1   = vread_fwd[0][1];
  wire [WIDTH-1:0]   vread_dat_int_0   = vread_dat[0][0];
  wire [WIDTH-1:0]   vread_dat_int_1   = vread_dat[0][1];
  wire [WIDTH-1:0]   vdout_wire_int_0   = vdout_wire [0];
  wire vread_fwd_out_int_0 = vread_fwd_out[0];
  //wire [BITVBNK-1:0] vrdbadr_wire_1 = vrdbadr_wire[1];
  //wire [BITVROW-1:0] vrdradr_wire_1 = vrdradr_wire[1];
  //wire [BITVROW-1:0] vrdcadr_wire_1 = vrdcadr_wire[1];
  //wire [BITVBNK-1:0] vrdbadr_reg_int_1 = vrdbadr_reg[0][1];
  //wire [BITVROW-1:0] vrdradr_reg_int_1 = vrdradr_reg[0][1];
//Debug
*/

endmodule



