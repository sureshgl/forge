module align_ecc_mrnw (write, wr_adr, din, read, rd_adr, rd_vld, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	               mem_write, mem_wr_adr, mem_bw, mem_din, mem_read, mem_rd_adr, mem_rd_fwrd, mem_rd_dout, mem_rd_padr,
                       clk, rst);

  parameter WIDTH = 32;
  parameter ENAPSDO = 0;
  parameter ENAPAR = 0;
  parameter ENAECC = 0;
  parameter ENADEC = 0;
  parameter ECCWDTH = 7;
  parameter NUMRDPT = 2;
  parameter NUMWRPT = 2;
  parameter NUMADDR = 1024;
  parameter BITADDR = 10;
  parameter NUMSROW = 256;
  parameter BITSROW = 8;
  parameter NUMWRDS = 4;
  parameter BITWRDS = 2;
  parameter BITPADR = 10;
  parameter SRAM_DELAY = 2;
  parameter FLOPGEN = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;
  parameter ENAPADR = 0;

  parameter MEMWDTH = ENAPAR ? WIDTH+1 : ENAECC ? WIDTH+ECCWDTH : ENADEC ? 2*WIDTH+ECCWDTH : WIDTH;

  input [NUMWRPT-1:0] write;
  input [NUMWRPT*BITADDR-1:0] wr_adr;
  input [NUMWRPT*WIDTH-1:0] din;

  input [NUMRDPT-1:0] read;
  input [NUMRDPT*BITADDR-1:0] rd_adr;
  output [NUMRDPT-1:0] rd_vld;
  output [NUMRDPT*WIDTH-1:0] rd_dout;
  output [NUMRDPT-1:0] rd_fwrd;
  output [NUMRDPT-1:0] rd_serr;
  output [NUMRDPT-1:0] rd_derr;
  output [NUMRDPT*BITPADR-1:0] rd_padr;

  output [NUMWRPT-1:0] mem_write;
  output [NUMWRPT*BITSROW-1:0] mem_wr_adr;
  output [NUMWRPT*NUMWRDS*MEMWDTH-1:0] mem_bw;
  output [NUMWRPT*NUMWRDS*MEMWDTH-1:0] mem_din;
  output [NUMRDPT-1:0] mem_read;
  output [NUMRDPT*BITSROW-1:0] mem_rd_adr;
  input [NUMRDPT-1:0] mem_rd_fwrd;
  input [NUMRDPT*NUMWRDS*MEMWDTH-1:0] mem_rd_dout;
  input [NUMRDPT*(BITPADR-BITWRDS)-1:0] mem_rd_padr;

  input clk;
  input rst;

  wire [NUMWRPT-1:0] write_wire;
  wire [NUMWRPT*BITADDR-1:0] wr_adr_wire;
  wire [NUMWRPT*WIDTH-1:0] din_wire;
  wire [NUMRDPT-1:0] read_wire;
  wire [NUMRDPT*BITADDR-1:0] rd_adr_wire;
  generate if (FLOPGEN) begin: flpg_loop
    reg [NUMWRPT-1:0] write_reg;
    reg [NUMWRPT*BITADDR-1:0] wr_adr_reg;
    reg [NUMWRPT*WIDTH-1:0] din_reg;
    always @(posedge clk) begin
      write_reg <= write;
      wr_adr_reg <= wr_adr;
      din_reg <= din;
    end
    assign write_wire = write_reg;
    assign wr_adr_wire = wr_adr_reg;
    assign din_wire = din_reg;
    assign read_wire = read;
    assign rd_adr_wire = rd_adr;
  end else begin: noflpi_loop
    assign write_wire = write;
    assign wr_adr_wire = wr_adr;
    assign din_wire = din;
    assign read_wire = read;
    assign rd_adr_wire = rd_adr;
  end
  endgenerate

  wire [WIDTH-1:0]   wr_data [0:NUMWRPT-1];
  wire [BITADDR-1:0] wr_addr [0:NUMWRPT-1];
  wire [BITWRDS-1:0] wr_wadr [0:NUMWRPT-1];
  wire [BITSROW-1:0] wr_radr [0:NUMWRPT-1];
  wire [MEMWDTH-1:0] din_tmp [0:NUMWRPT-1];
  wire [BITADDR-1:0] rd_addr [0:NUMRDPT-1];
  wire [BITWRDS-1:0] rd_wadr [0:NUMRDPT-1];
  wire [BITSROW-1:0] rd_radr [0:NUMRDPT-1];
  genvar np2_var;
  generate if (1) begin:np2_loop
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign wr_addr[np2_var] = wr_adr_wire >> (np2_var*BITADDR);
      if (BITWRDS>0) begin: wrd_loop
        np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                   .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                   .NUMVROW (NUMSROW), .BITVROW (BITSROW))
          wr_adr_inst (.vbadr(wr_wadr[np2_var]), .vradr(wr_radr[np2_var]), .vaddr(wr_addr[np2_var]));
      end else begin: no_wrd_loop
        assign wr_wadr[np2_var] = 0;
        assign wr_radr[np2_var] = wr_addr[np2_var];
      end

      assign wr_data[np2_var] = din_wire >> (np2_var*WIDTH);
      if (ENAPAR) begin: pg_loop
        assign din_tmp[np2_var] = {^wr_data[np2_var],wr_data[np2_var]};
      end else if (ENAECC) begin: eg_loop
        wire [ECCWDTH-1:0] din_ecc_eg;
        ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
          ecc_calc_inst (.din(wr_data[np2_var]), .eccout(din_ecc_eg));
        assign din_tmp[np2_var] = {din_ecc_eg,wr_data[np2_var]};
      end else if (ENADEC) begin: dg_loop
        wire [ECCWDTH-1:0] din_ecc_dg;
        ecc_calc #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
          ecc_calc_inst (.din(wr_data[np2_var]), .eccout(din_ecc_dg));
        assign din_tmp[np2_var] = {wr_data[np2_var],din_ecc_dg,wr_data[np2_var]};
      end else begin: ng_loop
        assign din_tmp[np2_var] = wr_data[np2_var];
      end
    end
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign rd_addr[np2_var] = rd_adr_wire >> (np2_var*BITADDR);
      if (BITWRDS>0) begin: wrd_loop
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                 .NUMVROW (NUMSROW), .BITVROW (BITSROW))
        rd_adr_inst (.vbadr(rd_wadr[np2_var]), .vradr(rd_radr[np2_var]), .vaddr(rd_addr[np2_var]));
      end else begin: no_wrd_loop
        assign rd_wadr[np2_var] = 0;
        assign rd_radr[np2_var] = rd_addr[np2_var];
      end
    end
  end
  endgenerate
/*
  wire [BITWRDS-1:0] wr_wadr_0 = wr_wadr[0];
  wire [BITWRDS-1:0] wr_wadr_1 = wr_wadr[1];
  wire [BITSROW-1:0] wr_radr_0 = wr_radr[0];
  wire [BITSROW-1:0] wr_radr_1 = wr_radr[1];
*/
  reg mem_write_wire [0:NUMWRPT-1];
  reg [BITSROW-1:0] mem_wr_adr_wire [0:NUMWRPT-1];
  reg [NUMWRDS*MEMWDTH-1:0] mem_bw_wire [0:NUMWRPT-1];
  reg [NUMWRDS*MEMWDTH-1:0] mem_din_wire [0:NUMWRPT-1];
  integer mwr_int, xwr_int;
  always_comb
    for (mwr_int=0; mwr_int<NUMWRPT; mwr_int=mwr_int+1) begin
      mem_write_wire[mwr_int] = 1'b0;
      mem_wr_adr_wire[mwr_int] = wr_radr[mwr_int];
      mem_bw_wire[mwr_int] = 0;
      mem_din_wire[mwr_int] = 0;
      if (write_wire[mwr_int]) begin
        mem_write_wire[mwr_int] = 1'b1;
        mem_bw_wire[mwr_int] = {MEMWDTH{1'b1}} << (wr_wadr[mwr_int]*MEMWDTH);
        mem_din_wire[mwr_int] = din_tmp[mwr_int] << (wr_wadr[mwr_int]*MEMWDTH);
        for (xwr_int=0; xwr_int<mwr_int; xwr_int=xwr_int+1)
          if (NUMWRDS && mem_write_wire[xwr_int] && mem_write_wire[mwr_int] && (mem_wr_adr_wire[xwr_int] == mem_wr_adr_wire[mwr_int])) begin
            mem_write_wire[xwr_int] = 1'b0;
            mem_din_wire[mwr_int] = (mem_din_wire[xwr_int] & ~mem_bw_wire[mwr_int]) | mem_din_wire[mwr_int];
            mem_bw_wire[mwr_int] = mem_bw_wire[xwr_int] | mem_bw_wire[mwr_int];
          end 
      end
    end

  reg forward_read [0:NUMRDPT-1];
  reg [WIDTH-1:0] forward_data [0:NUMRDPT-1];
  integer fwdr_int, fwdw_int;
  always_comb
    for (fwdr_int=0; fwdr_int<NUMRDPT; fwdr_int=fwdr_int+1) begin
      forward_read[fwdr_int] = 0;
      forward_data[fwdr_int] = 0;
      for (fwdw_int=0; fwdw_int<NUMWRPT; fwdw_int=fwdw_int+1)
        if (FLOPGEN && read_wire[fwdr_int] && write_wire[fwdw_int] && (rd_addr[fwdr_int] == wr_addr[fwdw_int])) begin
          forward_read[fwdr_int] = 1'b1;
          forward_data[fwdr_int] = wr_data[fwdw_int];
        end 
    end

  reg [NUMRDPT-1:0] mem_read;
  reg [NUMRDPT*BITSROW-1:0] mem_rd_adr;
  reg [NUMWRPT-1:0] mem_write;
  reg [NUMWRPT*BITSROW-1:0] mem_wr_adr;
  reg [NUMWRPT*NUMWRDS*MEMWDTH-1:0] mem_bw;
  reg [NUMWRPT*NUMWRDS*MEMWDTH-1:0] mem_din;
  integer mem_int, memb_int;
  always_comb begin
    for (mem_int=0; mem_int<NUMRDPT; mem_int=mem_int+1) begin
      mem_read[mem_int] = read_wire[mem_int] && !(ENAPSDO && forward_read[mem_int]);
      for (memb_int=0; memb_int<BITSROW; memb_int=memb_int+1)
        mem_rd_adr[mem_int*BITSROW+memb_int] = rd_radr[mem_int][memb_int];
    end
    for (mem_int=0; mem_int<NUMWRPT; mem_int=mem_int+1) begin
      mem_write[mem_int] = mem_write_wire[mem_int];
      for (memb_int=0; memb_int<BITSROW; memb_int=memb_int+1)
        mem_wr_adr[mem_int*BITSROW+memb_int] = mem_wr_adr_wire[mem_int][memb_int];
      for (memb_int=0; memb_int<NUMWRDS*MEMWDTH; memb_int=memb_int+1)
        mem_bw[mem_int*NUMWRDS*MEMWDTH+memb_int] = mem_bw_wire[mem_int][memb_int];
      for (memb_int=0; memb_int<NUMWRDS*MEMWDTH; memb_int=memb_int+1)
        mem_din[mem_int*NUMWRDS*MEMWDTH+memb_int] = mem_din_wire[mem_int][memb_int];
    end
  end

  wire [NUMRDPT-1:0] mem_rd_fwrd_tmp;
  wire [NUMRDPT*NUMWRDS*MEMWDTH-1:0] mem_rd_dout_tmp;
  wire [NUMRDPT*(BITPADR-BITWRDS)-1:0] mem_rd_padr_tmp;
  generate if (FLOPMEM) begin: flpm_loop
    reg [NUMRDPT-1:0] mem_rd_fwrd_reg;
    reg [NUMRDPT*NUMWRDS*MEMWDTH-1:0] mem_rd_dout_reg;
    reg [NUMRDPT*(BITPADR-BITWRDS)-1:0] mem_rd_padr_reg;
    always @(posedge clk) begin
      mem_rd_fwrd_reg <= mem_rd_fwrd;
      mem_rd_dout_reg <= mem_rd_dout;
      mem_rd_padr_reg <= mem_rd_padr;
    end
    assign mem_rd_fwrd_tmp = mem_rd_fwrd_reg;
    assign mem_rd_dout_tmp = mem_rd_dout_reg;
    assign mem_rd_padr_tmp = mem_rd_padr_reg;
  end else begin: noflpm_loop
    assign mem_rd_fwrd_tmp = mem_rd_fwrd;
    assign mem_rd_dout_tmp = mem_rd_dout;
    assign mem_rd_padr_tmp = mem_rd_padr;
  end
  endgenerate

  reg mem_rd_fwrd_wire [0:NUMRDPT-1];
  reg [NUMWRDS*MEMWDTH-1:0] mem_rd_dout_wire [0:NUMRDPT-1];
  reg [BITPADR-BITWRDS-1:0] mem_rd_padr_wire [0:NUMRDPT-1];
  integer mrd_int;
  always_comb
    for (mrd_int=0; mrd_int<NUMRDPT; mrd_int=mrd_int+1) begin
      mem_rd_fwrd_wire[mrd_int] = mem_rd_fwrd_tmp >> mrd_int;
      mem_rd_dout_wire[mrd_int] = mem_rd_dout_tmp >> (mrd_int*NUMWRDS*MEMWDTH);
      mem_rd_padr_wire[mrd_int] = mem_rd_padr_tmp >> (mrd_int*(BITPADR-BITWRDS));
    end

  reg [BITWRDS-1:0] rd_wadr_reg [0:NUMRDPT-1][0:SRAM_DELAY+FLOPMEM-1];
  reg [BITSROW-1:0] rd_radr_reg [0:NUMRDPT-1][0:SRAM_DELAY+FLOPMEM-1];
  reg               rd_fwd_reg [0:NUMRDPT-1][0:SRAM_DELAY+FLOPMEM-1];
  reg [WIDTH-1:0]   rd_dat_reg [0:NUMRDPT-1][0:SRAM_DELAY+FLOPMEM-1];
  reg               rd_vld_reg [0:NUMRDPT-1][0:SRAM_DELAY+FLOPMEM-1];
  reg               rd_mem_reg [0:NUMRDPT-1][0:SRAM_DELAY+FLOPMEM-1];
  integer rd_int, rpt_int;
  always @(posedge clk)
    for (rpt_int=0; rpt_int<NUMRDPT; rpt_int=rpt_int+1)
      for (rd_int=0; rd_int<SRAM_DELAY+FLOPMEM; rd_int=rd_int+1)
        if (rd_int>0) begin
          rd_wadr_reg[rpt_int][rd_int] <= rd_wadr_reg[rpt_int][rd_int-1];
          rd_radr_reg[rpt_int][rd_int] <= rd_radr_reg[rpt_int][rd_int-1];
          rd_fwd_reg[rpt_int][rd_int] <= rd_fwd_reg[rpt_int][rd_int-1];
          rd_dat_reg[rpt_int][rd_int] <= rd_dat_reg[rpt_int][rd_int-1];
          rd_vld_reg[rpt_int][rd_int] <= rd_vld_reg[rpt_int][rd_int-1];
          rd_mem_reg[rpt_int][rd_int] <= rd_mem_reg[rpt_int][rd_int-1];
        end else begin
          rd_wadr_reg[rpt_int][rd_int] <= rd_wadr[rpt_int];
	  rd_radr_reg[rpt_int][rd_int] <= rd_radr[rpt_int];
          rd_fwd_reg[rpt_int][rd_int] <= forward_read[rpt_int];
          rd_dat_reg[rpt_int][rd_int] <= forward_data[rpt_int];
          rd_vld_reg[rpt_int][rd_int] <= read_wire[rpt_int];
          rd_mem_reg[rpt_int][rd_int] <= mem_read[rpt_int];
        end

  wire               rd_fwrd_wire [0:NUMRDPT-1];
  wire [MEMWDTH-1:0] rd_dout_int [0:NUMRDPT-1];
  wire [BITPADR-BITWRDS-1:0] rd_padr_wire [0:NUMRDPT-1];
  genvar err_var;
  generate for (err_var=0; err_var<NUMRDPT; err_var=err_var+1) begin: err_loop
    wire [MEMWDTH-1:0] rd_dout_wire = mem_rd_dout_wire[err_var] >> (rd_wadr_reg[err_var][SRAM_DELAY+FLOPMEM-1]*MEMWDTH);

    assign rd_fwrd_wire[err_var] = mem_rd_fwrd_wire[err_var];
    assign rd_dout_int[err_var] = rd_dout_wire;
    assign rd_padr_wire[err_var] = mem_rd_padr_wire[err_var];
  end
  endgenerate

  wire rd_vld_tmp [0:NUMRDPT-1];
  wire [WIDTH-1:0] rd_dout_tmp [0:NUMRDPT-1];
  wire rd_fwrd_tmp [0:NUMRDPT-1];
  wire rd_serr_tmp [0:NUMRDPT-1];
  wire rd_derr_tmp [0:NUMRDPT-1];
  wire [BITPADR-1:0] rd_padr_tmp [0:NUMRDPT-1];
  genvar rtmp_int;
  generate for (rtmp_int=0; rtmp_int<NUMRDPT; rtmp_int=rtmp_int+1) begin: rdc_loop
    if (ENAPAR) begin: pc_loop
      assign rd_vld_tmp[rtmp_int] = rd_vld_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_dout_tmp[rtmp_int] = rd_fwd_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] ? rd_dat_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] : rd_dout_int[rtmp_int];
      assign rd_fwrd_tmp[rtmp_int] = rd_fwd_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] || rd_fwrd_wire[rtmp_int];
      assign rd_serr_tmp[rtmp_int] = ^rd_dout_int[rtmp_int] && rd_mem_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_derr_tmp[rtmp_int] = 1'b0;
      assign rd_padr_tmp[rtmp_int] = (NUMWRDS>1) ? {rd_wadr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1],
                                                    (ENAPADR ? rd_padr_wire[rtmp_int] : rd_radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1])} :
                                                   ENAPADR ? rd_padr_wire[rtmp_int] : rd_radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
    end else if (ENAECC) begin: ec_loop
      wire [WIDTH-1:0] rd_data_wire_e = rd_dout_int[rtmp_int];
      wire [ECCWDTH-1:0] rd_ecc_wire_e = rd_dout_int[rtmp_int] >> WIDTH;
      wire [WIDTH-1:0] rd_corr_data_wire_e;
      wire rd_sec_err_wire_e;
      wire rd_ded_err_wire_e;

      ecc_check   #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
          ecc_check_inst (.din(rd_data_wire_e), .eccin(rd_ecc_wire_e),
                          .dout(rd_corr_data_wire_e), .sec_err(rd_sec_err_wire_e), .ded_err(rd_ded_err_wire_e),
                          .clk(clk), .rst(rst));

      assign rd_vld_tmp[rtmp_int] = rd_vld_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_dout_tmp[rtmp_int] = rd_fwd_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] ? rd_dat_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] : rd_corr_data_wire_e;
      assign rd_fwrd_tmp[rtmp_int] = rd_fwd_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] || rd_fwrd_wire[rtmp_int];
      assign rd_serr_tmp[rtmp_int] = rd_sec_err_wire_e && rd_mem_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_derr_tmp[rtmp_int] = rd_ded_err_wire_e && rd_mem_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_padr_tmp[rtmp_int] = (NUMWRDS>1) ? {rd_wadr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1],
                                                    (ENAPADR ? rd_padr_wire[rtmp_int] : rd_radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1])} :
                                                   ENAPADR ? rd_padr_wire[rtmp_int] : rd_radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
    end else if (ENADEC) begin: dc_loop
      wire [WIDTH-1:0] rd_data_wire_d = rd_dout_int[rtmp_int];
      wire [ECCWDTH-1:0] rd_ecc_wire_d = rd_dout_int[rtmp_int] >> WIDTH;
      wire [WIDTH-1:0] rd_dup_data_wire_d = rd_dout_int[rtmp_int] >> (WIDTH+ECCWDTH);
      wire [WIDTH-1:0] rd_corr_data_wire_d;
      wire rd_sec_err_wire_d;
      wire rd_ded_err_wire_d;
      wire rd_dup_sec_err_wire_d;
      wire rd_dup_ded_err_wire_d;

      ecc_check #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
          ecc_check_inst (.din(rd_data_wire_d), .eccin(rd_ecc_wire_d),
                          .dout(rd_corr_data_wire_d), .sec_err(rd_sec_err_wire_d), .ded_err(rd_ded_err_wire_d),
                          .clk(clk), .rst(rst));

      ecc_check #(.ECCDWIDTH(WIDTH), .ECCWIDTH(ECCWDTH))
          ecc_dup_check_inst (.din(rd_dup_data_wire_d), .eccin(rd_ecc_wire_d),
                              .dout(), .sec_err(rd_dup_sec_err_wire_d), .ded_err(rd_dup_ded_err_wire_d),
                              .clk(clk), .rst(rst));

      assign rd_vld_tmp[rtmp_int] = rd_vld_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_dout_tmp[rtmp_int] = rd_fwd_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] ? rd_dat_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] :
                                                                    rd_ded_err_wire_d ? rd_dup_data_wire_d : rd_corr_data_wire_d;
      assign rd_fwrd_tmp[rtmp_int] = rd_fwd_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] || rd_fwrd_wire[rtmp_int];
      assign rd_serr_tmp[rtmp_int] = (((rd_data_wire_d == rd_corr_data_wire_d) && rd_sec_err_wire_d && rd_dup_sec_err_wire_d) ||
                                      ((rd_sec_err_wire_d ^ rd_dup_sec_err_wire_d) && !rd_ded_err_wire_d && !rd_dup_ded_err_wire_d)) && rd_mem_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_derr_tmp[rtmp_int] = (((rd_data_wire_d != rd_corr_data_wire_d) && rd_sec_err_wire_d && rd_dup_sec_err_wire_d) ||
                                      rd_ded_err_wire_d || rd_dup_ded_err_wire_d) && rd_mem_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_padr_tmp[rtmp_int] = (NUMWRDS>1) ? {rd_wadr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1],rd_radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1]} :
                                                   rd_radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
    end else begin: nc_loop
      assign rd_vld_tmp[rtmp_int] = rd_vld_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
      assign rd_dout_tmp[rtmp_int] = rd_fwd_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] ? rd_dat_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] : rd_dout_int[rtmp_int];
      assign rd_fwrd_tmp[rtmp_int] = rd_fwd_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1] || rd_fwrd_wire[rtmp_int];
      assign rd_serr_tmp[rtmp_int] = 1'b0;
      assign rd_derr_tmp[rtmp_int] = 1'b0;
      assign rd_padr_tmp[rtmp_int] = (NUMWRDS>1) ? {rd_wadr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1],
                                                    (ENAPADR ? rd_padr_wire[rtmp_int] : rd_radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1])} :
                                                   ENAPADR ? rd_padr_wire[rtmp_int] : rd_radr_reg[rtmp_int][SRAM_DELAY+FLOPMEM-1];
    end
  end
  endgenerate

  reg [NUMRDPT-1:0] rd_vld_help;
  reg [NUMRDPT*WIDTH-1:0] rd_dout_help;
  reg [NUMRDPT-1:0] rd_fwrd_help;
  reg [NUMRDPT-1:0] rd_serr_help;
  reg [NUMRDPT-1:0] rd_derr_help;
  reg [NUMRDPT*BITPADR-1:0] rd_padr_help;
  integer rdh_int;
  always_comb begin
    rd_vld_help = 0;
    rd_dout_help = 0;
    rd_fwrd_help = 0;
    rd_serr_help = 0;
    rd_derr_help = 0;
    rd_padr_help = 0;
    for (rdh_int=0; rdh_int<NUMRDPT; rdh_int=rdh_int+1) begin
      rd_vld_help = rd_vld_help | (rd_vld_tmp[rdh_int] << rdh_int);
      rd_dout_help = rd_dout_help | (rd_dout_tmp[rdh_int] << (rdh_int*WIDTH));
      rd_fwrd_help = rd_fwrd_help | (rd_fwrd_tmp[rdh_int] << rdh_int);
      rd_serr_help = rd_serr_help | (rd_serr_tmp[rdh_int] << rdh_int);
      rd_derr_help = rd_derr_help | (rd_derr_tmp[rdh_int] << rdh_int);
      rd_padr_help = rd_padr_help | (rd_padr_tmp[rdh_int] << (rdh_int*BITPADR));
    end
  end

  generate if (FLOPOUT) begin: flpo_loop
    reg [NUMRDPT-1:0] rd_vld_reg;
    reg [NUMRDPT*WIDTH-1:0] rd_dout_reg;
    reg [NUMRDPT-1:0] rd_fwrd_reg;
    reg [NUMRDPT-1:0] rd_serr_reg;
    reg [NUMRDPT-1:0] rd_derr_reg;
    reg [NUMRDPT*BITPADR-1:0] rd_padr_reg;
    always @(posedge clk) begin
      rd_vld_reg <= rd_vld_help;
      rd_dout_reg <= rd_dout_help;
      rd_fwrd_reg <= rd_fwrd_help;
      rd_serr_reg <= rd_serr_help;
      rd_derr_reg <= rd_derr_help;
      rd_padr_reg <= rd_padr_help;
    end
    assign rd_vld = rd_vld_reg;
    assign rd_dout = rd_dout_reg;
    assign rd_fwrd = rd_fwrd_reg;
    assign rd_serr = rd_serr_reg;
    assign rd_derr = rd_derr_reg;
    assign rd_padr = rd_padr_reg;
  end else begin: noflpo_loop
    assign rd_vld = rd_vld_help;
    assign rd_dout = rd_dout_help;
    assign rd_fwrd = rd_fwrd_help;
    assign rd_serr = rd_serr_help;
    assign rd_derr = rd_derr_help;
    assign rd_padr = rd_padr_help;
  end
  endgenerate

endmodule
