module core_nr1w_dup (vwrite, vwraddr, vdin,
                      vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                      pwrite, pwrradr, pdin, pread, prdradr, pdout, pdout_fwrd, pdout_serr, pdout_derr, pdout_padr,
	              ready, clk, rst,
		      select_addr, select_bit);
 
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 2;
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
  parameter FLOPIN = 1;
  parameter FLOPOUT = 0;

  localparam LBITVBK = BITVBNK>0 ? BITVBNK : 1;

  input                                vwrite;
  input [BITADDR-1:0]                  vwraddr;
  input [WIDTH-1:0]                    vdin;
  
  input [NUMRDPT-1:0]                  vread;
  input [NUMRDPT*BITADDR-1:0]          vrdaddr;
  output [NUMRDPT-1:0]                 vread_vld;
  output [NUMRDPT*WIDTH-1:0]           vdout;
  output [NUMRDPT-1:0]                 vread_fwrd;
  output [NUMRDPT-1:0]                 vread_serr;
  output [NUMRDPT-1:0]                 vread_derr;
  output [NUMRDPT*BITPADR-1:0]         vread_padr;

  output [NUMRDPT*NUMVBNK-1:0]         pwrite;
  output [NUMRDPT*NUMVBNK*(BITVROW+BITCOLS)-1:0] pwrradr;
  output [NUMRDPT*NUMVBNK*WIDTH-1:0]   pdin;

  output [NUMRDPT*NUMVBNK-1:0]         pread;
  output [NUMRDPT*NUMVBNK*(BITVROW+BITCOLS)-1:0] prdradr;
  input [NUMRDPT*NUMVBNK*WIDTH-1:0]    pdout;
  input [NUMRDPT*NUMVBNK-1:0]          pdout_fwrd;
  input [NUMRDPT*NUMVBNK-1:0]          pdout_serr;
  input [NUMRDPT*NUMVBNK-1:0]          pdout_derr;
  input [NUMRDPT*NUMVBNK*(BITPADR-BITVBNK)-1:0] pdout_padr;

  output                               ready;
  input                                clk;
  input                                rst;

  input [BITADDR-1:0]                  select_addr;
  input [BITWDTH-1:0]                  select_bit;
  
  reg ready;
  always @(posedge clk)
    ready <= !rst;

  wire vread_wire [0:NUMRDPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMRDPT-1];
  wire [LBITVBK-1:0] vrdbadr_wire [0:NUMRDPT-1];
  wire [BITCOLS-1:0] vrdcadr_wire [0:NUMRDPT-1];
  wire [BITVROW-1:0] vrdradr_wire [0:NUMRDPT-1];
  wire vwrite_wire;
  wire [BITADDR-1:0] vwraddr_wire;
  wire [WIDTH-1:0] vdin_wire;
  wire [LBITVBK-1:0] vwrbadr_wire;
  wire [BITCOLS-1:0] vwrcadr_wire;
  wire [BITVROW-1:0] vwrradr_wire;
  wire [LBITVBK-1:0] select_bank;
  wire [BITVROW-1:0] select_row;
  wire [BITCOLS-1:0] select_col;

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    wire ready_flpi_wire;
    reg ready_reg;
    reg [NUMRDPT-1:0] vread_reg;
    reg [NUMRDPT*BITADDR-1:0] vrdaddr_reg;
    reg vwrite_reg;
    reg [BITADDR-1:0] vwraddr_reg;
    reg [WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread & {NUMRDPT{ready}};
      vrdaddr_reg <= vrdaddr;
      vwrite_reg <= vwrite & ready;
      vwraddr_reg <= vwraddr;
      vdin_reg <= vdin;
    end

    assign ready_flpi_wire = ready_reg;
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
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
    wire ready_noflpi_wire;
    assign ready_noflpi_wire = ready;
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);
      wire [BITVROW+BITCOLS-1:0] vrdrow_noflpi_temp;

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW*NUMCOLS), .BITVROW (BITVROW+BITCOLS))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdrow_noflpi_temp), .vaddr(vrdaddr_wire[np2_var]));

      assign vrdcadr_wire[np2_var] = (NUMCOLS>1) ? vrdrow_noflpi_temp : 0;
      assign vrdradr_wire[np2_var] = vrdrow_noflpi_temp >> BITCOLS;
    end

    assign vwrite_wire = vwrite && (vwraddr_wire < NUMADDR);
    assign vwraddr_wire = vwraddr;
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

/*
  genvar np2_int;
  generate if (1) begin: np2_loop
    for (np2_int=0; np2_int<NUMRDPT; np2_int=np2_int+1) begin: rd_loop
      assign vread_wire[np2_int] = vread >> np2_int;
      assign vrdaddr_wire[np2_int] = vrdaddr >> (np2_int*BITADDR);
      wire [BITVROW+BITCOLS-1:0] vrdrow_temp;

      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW*NUMCOLS), .BITVROW (BITVROW+BITCOLS))
        rd_adr_inst (.vbadr(vrdbadr_wire[np2_int]), .vradr(vrdrow_temp), .vaddr(vrdaddr_wire[np2_int]));

      assign vrdcadr_wire[np2_int] = (NUMCOLS>1) ? vrdrow_temp : 0;
      assign vrdradr_wire[np2_int] = vrdrow_temp >> BITCOLS;
    end

    assign vwrite_wire = vwrite && (vwraddr < NUMADDR);
    assign vwraddr_wire = vwraddr;
    assign vdin_wire = vdin;
    wire [BITVROW+BITCOLS-1:0] vwrrow_temp;

    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW*NUMCOLS), .BITVROW (BITVROW+BITCOLS))
      wr_adr_inst (.vbadr(vwrbadr_wire), .vradr(vwrrow_temp), .vaddr(vwraddr_wire));

    assign vwrcadr_wire = (NUMCOLS>1) ? vwrrow_temp : 0;
    assign vwrradr_wire = vwrrow_temp >> BITCOLS;

    wire [BITVROW+BITCOLS-1:0] selrow_temp;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW*NUMCOLS), .BITVROW (BITVROW+BITCOLS))
      sl_adr (.vbadr(select_bank), .vradr(selrow_temp), .vaddr(select_addr));

    assign select_col = (NUMCOLS>1) ? selrow_temp : 0;
    assign select_row = selrow_temp >> BITCOLS;
  end
  endgenerate
*/
  reg               vwrite_del [0:NUMRDPT-1][0:NUMCOLS-1];
  reg [BITVBNK-1:0] vwrbadr_del [0:NUMRDPT-1][0:NUMCOLS-1];
  reg [BITVROW-1:0] vwrradr_del [0:NUMRDPT-1][0:NUMCOLS-1];
  reg [WIDTH-1:0]   vdin_del [0:NUMRDPT-1][0:NUMCOLS-1];

  reg select_vld [0:NUMRDPT-1];
  reg select_dat [0:NUMRDPT-1];
  integer sel_int;
  always_comb
    for (sel_int=0; sel_int<NUMRDPT; sel_int=sel_int+1) begin
      select_vld[sel_int] = vwrite_del[sel_int][select_col] &&
			    (vwrbadr_del[sel_int][select_col] == select_bank) &&
			    (vwrradr_del[sel_int][select_col] == select_row);
      select_dat[sel_int] = vdin_del[sel_int][select_col][select_bit];
    end 

  wire select_vld_0 = select_vld[0];
  wire select_dat_0 = select_dat[0];

  reg move [0:NUMRDPT-1];
  reg flush [0:NUMRDPT-1];
  reg clear [0:NUMRDPT-1];
  integer cflt_int;
  always_comb
    for (cflt_int=0; cflt_int<NUMRDPT; cflt_int=cflt_int+1) begin
      move[cflt_int] = vread_wire[cflt_int] && vwrite_wire && (vrdbadr_wire[cflt_int] == vwrbadr_wire) && (vrdradr_wire[cflt_int] == vwrradr_wire);
      flush[cflt_int] = move[cflt_int] && vwrite_del[cflt_int][vwrcadr_wire] && !((vwrbadr_del[cflt_int][vwrcadr_wire] == vrdbadr_wire[cflt_int]) &&
								                  (vwrradr_del[cflt_int][vwrcadr_wire] == vrdradr_wire[cflt_int]));
      clear[cflt_int] = !move[cflt_int] && vwrite_del[cflt_int][vwrcadr_wire] &&
			 vwrite_wire && (vwrbadr_del[cflt_int][vwrcadr_wire] == vwrbadr_wire) && (vwrradr_del[cflt_int][vwrcadr_wire] == vwrradr_wire);
    end

  integer vwpt_int, vwcl_int;
  always @(posedge clk)
    for (vwpt_int=0; vwpt_int<NUMRDPT; vwpt_int=vwpt_int+1) 
      if (rst)
        for (vwcl_int=0; vwcl_int<NUMCOLS; vwcl_int=vwcl_int+1) 
          vwrite_del[vwpt_int][vwcl_int] <= 1'b0;
      else if (move[vwpt_int]) begin
        vwrite_del[vwpt_int][vwrcadr_wire] <= 1'b1;
        vwrbadr_del[vwpt_int][vwrcadr_wire] <= vwrbadr_wire;
        vwrradr_del[vwpt_int][vwrcadr_wire] <= vwrradr_wire;
        vdin_del[vwpt_int][vwrcadr_wire] <= vdin_wire;
      end else if (clear[vwpt_int])
        vwrite_del[vwpt_int][vwrcadr_wire] <= 1'b0; 

  reg vwrite_int [0:NUMRDPT-1];
  reg [BITVBNK-1:0] vwrbadr_int [0:NUMRDPT-1];
  reg [BITVROW-1:0] vwrradr_int [0:NUMRDPT-1];
  reg [BITCOLS-1:0] vwrcadr_int [0:NUMRDPT-1];
  reg [WIDTH-1:0] vdin_int [0:NUMRDPT-1];
  reg vread_int [0:NUMRDPT-1];
  reg [BITVBNK-1:0] vrdbadr_int [0:NUMRDPT-1];
  reg [BITVROW-1:0] vrdradr_int [0:NUMRDPT-1];
  reg [BITCOLS-1:0] vrdcadr_int [0:NUMRDPT-1];
  integer vcft_int;
  always_comb
    for (vcft_int=0; vcft_int<NUMRDPT; vcft_int=vcft_int+1) begin
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
/*
      if (flush[vcft_int]) begin
        vwrite_int[vcft_int] = 1'b1;
        vwrbadr_int[vcft_int] = vwrbadr_del[vcft_int][vwrcadr_wire];
        vwrradr_int[vcft_int] = vwrradr_del[vcft_int][vwrcadr_wire];
        vwrcadr_int[vcft_int] = vwrcadr_wire;
        vdin_int[vcft_int] = vdin_del[vcft_int][vwrcadr_wire];
      end else if (!move[vcft_int] && vwrite_wire) begin
*/
      if (vwrite_wire) begin
        vwrite_int[vcft_int] = 1'b1;
        vwrbadr_int[vcft_int] = vwrbadr_wire;
        vwrradr_int[vcft_int] = vwrradr_wire;
        vwrcadr_int[vcft_int] = vwrcadr_wire;
        vdin_int[vcft_int] = vdin_wire;
      end
    end

  reg                vread_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg [LBITVBK-1:0]  vrdbadr_reg [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg                vread_fwd [0:NUMRDPT-1][0:SRAM_DELAY-1];
  reg [WIDTH-1:0]    vread_dat [0:NUMRDPT-1][0:SRAM_DELAY-1];
  integer vreg_int, vrpt_int;
  always @(posedge clk)
    for (vreg_int=0; vreg_int<SRAM_DELAY; vreg_int=vreg_int+1) 
      if (vreg_int>0) begin
        for (vrpt_int=0; vrpt_int<NUMRDPT; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_reg[vrpt_int][vreg_int-1];
          vrdbadr_reg[vrpt_int][vreg_int] <= vrdbadr_reg[vrpt_int][vreg_int-1];
          vread_fwd[vrpt_int][vreg_int] <= vread_fwd[vrpt_int][vreg_int-1];
          vread_dat[vrpt_int][vreg_int] <= vread_dat[vrpt_int][vreg_int-1];
        end
      end else begin
        for (vrpt_int=0; vrpt_int<NUMRDPT; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_wire[vrpt_int];
          vrdbadr_reg[vrpt_int][vreg_int] <= vrdbadr_wire[vrpt_int];
          vread_fwd[vrpt_int][vreg_int] <= vwrite_del[vrpt_int][vrdcadr_wire[vrpt_int]] &&
					   (vwrbadr_del[vrpt_int][vrdcadr_wire[vrpt_int]] == vrdbadr_wire[vrpt_int]) &&
					   (vwrradr_del[vrpt_int][vrdcadr_wire[vrpt_int]] == vrdradr_wire[vrpt_int]);
          vread_dat[vrpt_int][vreg_int] <= vdin_del[vrpt_int][vrdcadr_wire[vrpt_int]];
        end
      end

  reg               vread_out [0:NUMRDPT-1];
  reg [LBITVBK-1:0] vrdbadr_out [0:NUMRDPT-1];
  reg               vread_fwd_out [0:NUMRDPT-1];
  reg [WIDTH-1:0]   vread_dat_out [0:NUMRDPT-1]; 
  integer vdel_int;
  always_comb begin
    for (vdel_int=0; vdel_int<NUMRDPT; vdel_int=vdel_int+1) begin
      vread_out[vdel_int] = vread_reg[vdel_int][SRAM_DELAY-1];
      vrdbadr_out[vdel_int] = vrdbadr_reg[vdel_int][SRAM_DELAY-1];
      vread_fwd_out[vdel_int] = vread_fwd[vdel_int][SRAM_DELAY-1];
      vread_dat_out[vdel_int] = vread_dat[vdel_int][SRAM_DELAY-1];
    end
  end

/*
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
  wire flush_0 = flush[0];
  wire clear_0 = clear[0];
*/

  reg [NUMRDPT*NUMVBNK-1:0] pwrite;
  reg [NUMRDPT*NUMVBNK*(BITVROW+BITCOLS)-1:0] pwrradr;
  reg [NUMRDPT*NUMVBNK*WIDTH-1:0] pdin;
  reg [NUMRDPT*NUMVBNK-1:0] pread;
  reg [NUMRDPT*NUMVBNK*(BITVROW+BITCOLS)-1:0] prdradr;
  reg [BITVROW+BITCOLS-1:0] radr_temp;
  integer prd_int;
  always_comb begin
    radr_temp = 0;
    pwrite = 0;
    pwrradr = 0;
    pdin = 0;
    pread = 0;
    prdradr = 0;
    for (prd_int=0; prd_int<NUMRDPT; prd_int=prd_int+1) begin
      if (vwrite_int[prd_int]) begin  
        radr_temp = (NUMCOLS>1) ? {vwrradr_int[prd_int],vwrcadr_int[prd_int]} : vwrradr_int[prd_int];
        pwrite = pwrite | (1'b1 << (vwrbadr_int[prd_int]*NUMRDPT+prd_int));
        pwrradr = pwrradr | (radr_temp << ((vwrbadr_int[prd_int]*NUMRDPT+prd_int)*(BITVROW+BITCOLS)));
        pdin = pdin | (vdin_int[prd_int] << ((vwrbadr_int[prd_int]*NUMRDPT+prd_int)*WIDTH));
      end
      if (vread_int[prd_int]) begin
        radr_temp = (NUMCOLS>1) ? {vrdradr_int[prd_int],vrdcadr_int[prd_int]} : vrdradr_int[prd_int];
        pread = pread | (1'b1 << (vrdbadr_wire[prd_int]*NUMRDPT+prd_int));
        prdradr = prdradr | (radr_temp << ((vrdbadr_int[prd_int]*NUMRDPT+prd_int)*(BITVROW+BITCOLS)));
      end
    end
  end   

  reg               vread_vld_wire [0:NUMRDPT-1];
  reg [WIDTH-1:0]   vdout_wire [0:NUMRDPT-1];
  reg               vread_fwrd_wire [0:NUMRDPT-1];
  reg               vread_fwrd_help [0:NUMRDPT-1];
  reg               vread_serr_wire [0:NUMRDPT-1];
  reg               vread_derr_wire [0:NUMRDPT-1];
  reg [BITPADR-BITVBNK-1:0] vread_padr_help [0:NUMRDPT-1];
  reg [BITPADR-1:0] vread_padr_wire [0:NUMRDPT-1];
  integer vrd_int;
  always_comb 
    for (vrd_int=0; vrd_int<NUMRDPT; vrd_int=vrd_int+1) begin
      vread_vld_wire[vrd_int] = vread_out[vrd_int];
      vdout_wire[vrd_int] = vread_fwd_out[vrd_int] ? vread_dat_out[vrd_int] : pdout >> ((NUMRDPT*vrdbadr_out[vrd_int]+vrd_int)*WIDTH);
      vread_fwrd_help[vrd_int] = pdout_fwrd >> (NUMRDPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_fwrd_wire[vrd_int] = vread_fwd_out[vrd_int] || vread_fwrd_help[vrd_int];
      vread_serr_wire[vrd_int] = pdout_serr >> (NUMRDPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_derr_wire[vrd_int] = pdout_derr >> (NUMRDPT*vrdbadr_out[vrd_int]+vrd_int);
      vread_padr_help[vrd_int] = pdout_padr >> ((NUMRDPT*vrdbadr_out[vrd_int]+vrd_int)*(BITPADR-BITVBNK));
      vread_padr_wire[vrd_int] = {vrdbadr_out[vrd_int],vread_padr_help[vrd_int]};
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
      vread_vld_tmp = vread_vld_tmp | (vread_out[vwire_int] << vwire_int);
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



