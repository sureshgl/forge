module algo_mrnrw_ref (refr,  
                         read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                         rw_read, rw_write, rw_addr, rw_din, rw_vld, rw_dout, rw_serr, rw_derr, rw_padr,
                         write, wr_adr, din, 
                         cnt, ct_adr, ct_imm, ct_vld, ct_serr, ct_derr,
                         ac_read, ac_write, ac_addr, ac_din, ac_vld, ac_dout, ac_serr, ac_derr, ac_padr,
                         ru_read, ru_write, ru_addr, ru_din, ru_vld, ru_dout, ru_serr, ru_derr, ru_padr,
                         ma_write, ma_adr, ma_bp, ma_din, dq_vld, dq_adr,
                         push, pu_adr, pu_din, pu_ptr, pu_vld, pu_cnt,
                         pop, po_adr, po_vld, po_dout, po_serr, po_derr, po_padr, po_ptr, po_nxt, po_cnt, po_snxt, po_sdout,
                         clk, ready, rst);

  parameter WIDTH = 4;
  parameter NUMADDR = 16;
  parameter BITADDR = 4;
  parameter NUMRDPT = 2;
  parameter NUMRWPT = 0;
  parameter NUMWRPT = 1;
  parameter NUMCTPT = 0;
  parameter NUMACPT = 0;
  parameter NUMRUPT = 0;
  parameter NUMMAPT = 0;
  parameter NUMDQPT = 0;
  parameter NUMPUPT = 0;
  parameter NUMPOPT = 0;
  parameter NUMXMPT = 0;
  parameter NUMXSPT = 0;
  parameter NUMSEPT = 0;
  parameter NUMHUPT = 0;
  parameter NUMVBNK1 = 4;
  parameter BITVBNK1 = 2;
  parameter BITPBNK1 = 3;
  parameter NUMVROW1 = 4;
  parameter BITVROW1 = 2;
  parameter NUMVBNK2 = 1;
  parameter BITVBNK2 = 0;
  parameter BITPBNK2 = 0;
  parameter NUMVROW2 = NUMVROW1;
  parameter BITVROW2 = BITVROW1;
  parameter NUMVBNK3 = 1;
  parameter BITVBNK3 = 0;
  parameter BITPBNK3 = 0;
  parameter NUMVROW3 = NUMVROW2;
  parameter BITVROW3 = BITVROW2;
  parameter NUMWRDS = 1;
  parameter BITWRDS = 0;
  parameter NUMSROW = NUMVROW3;
  parameter BITSROW = BITVROW3;
  parameter BITPADR = 5;
  parameter BITEROR = BITPADR-BITSROW-1;
  parameter NUMEROR = 1 << BITEROR;
  parameter MODEROR = 0; // 0 for no error protection; 1 for parity mode; 2 for ECC mode
  parameter BITPADRX = (NUMVBNK1 == 1) ? (BITPADR - 1) : (BITPADR - 2);

  parameter DEPTH = 32;
  parameter NUMCELL = 8;
  parameter BITCELL = 3;
  parameter NUMQUEU = DEPTH/80;
  parameter BITQUEU = BITADDR-BITCELL;
  parameter NUMSCNT = 2;
  parameter CNTWDTH = WIDTH/NUMSCNT;

  parameter MEM_DELAY = 1;
  parameter UPD_DELAY = 7;

  input                        refr;

  input [NUMRDPT-1:0]          read;
  input [NUMRDPT*BITADDR-1:0]  rd_adr;
  output [NUMRDPT-1:0]         rd_vld;
  output [NUMRDPT*WIDTH-1:0]   rd_dout;
  output [NUMRDPT-1:0]         rd_serr;
  output [NUMRDPT-1:0]         rd_derr;
  output [NUMRDPT*BITPADR-1:0] rd_padr;

  input [NUMRWPT-1:0]          rw_read;
  input [NUMRWPT-1:0]          rw_write;
  input [NUMRWPT*BITADDR-1:0]  rw_addr;
  input [NUMRWPT*WIDTH-1:0]    rw_din;
  output [NUMRWPT-1:0]         rw_vld;
  output [NUMRWPT*WIDTH-1:0]   rw_dout;
  output [NUMRWPT-1:0]         rw_serr;
  output [NUMRWPT-1:0]         rw_derr;
  output [NUMRWPT*BITPADR-1:0] rw_padr;

  input [NUMWRPT-1:0]          write;
  input [NUMWRPT*BITADDR-1:0]  wr_adr;
  input [NUMWRPT*WIDTH-1:0]    din;

  input [NUMCTPT-1:0]          cnt;
  input [NUMCTPT*BITADDR-1:0]  ct_adr;
  input [NUMCTPT*WIDTH-1:0]    ct_imm;
  output [NUMCTPT-1:0]         ct_vld;
  output [NUMCTPT-1:0]         ct_serr;
  output [NUMCTPT-1:0]         ct_derr;
 
  input [NUMACPT-1:0]          ac_read;
  input [NUMACPT-1:0]          ac_write;
  input [NUMACPT*BITADDR-1:0]  ac_addr;
  input [NUMACPT*WIDTH-1:0]    ac_din;
  output [NUMACPT-1:0]         ac_vld;
  output [NUMACPT*WIDTH-1:0]   ac_dout; 
  output [NUMACPT-1:0]         ac_serr;
  output [NUMACPT-1:0]         ac_derr;
  output [NUMACPT*BITPADR-1:0] ac_padr;

  input [NUMRUPT-1:0]          ru_read;
  input [NUMRUPT-1:0]          ru_write;
  input [NUMRUPT*BITADDR-1:0]  ru_addr;
  input [NUMRUPT*WIDTH-1:0]    ru_din;
  output [NUMRUPT-1:0]         ru_vld;
  output [NUMRUPT*WIDTH-1:0]   ru_dout; 
  output [NUMRUPT-1:0]         ru_serr;
  output [NUMRUPT-1:0]         ru_derr;
  output [NUMRUPT*BITPADR-1:0] ru_padr;

  input [NUMMAPT-1:0]          ma_write;
  output [NUMMAPT*BITADDR-1:0] ma_adr;
  output [NUMMAPT-1:0]         ma_bp;
  input [NUMMAPT*WIDTH-1:0]    ma_din;

  output [NUMDQPT-1:0]         dq_vld;
  output [NUMDQPT*BITADDR-1:0] dq_adr;

  output [NUMPUPT-1:0]         push;
  output [NUMPUPT*BITQUEU-1:0] pu_adr;
  output [NUMPUPT*BITADDR-1:0] pu_ptr; 
  output [NUMPUPT*WIDTH-1:0]   pu_din; 
  input [NUMPUPT-1:0]          pu_vld;
  input [NUMPUPT*(BITADDR+1)-1:0]    pu_cnt; 
  
  output [NUMPOPT-1:0]         pop;
  output [NUMPOPT*BITQUEU-1:0] po_adr;
  input [NUMPOPT-1:0]          po_vld;
  input [NUMPOPT*BITADDR-1:0]  po_ptr; 
  input [NUMPOPT*BITADDR-1:0]  po_nxt; 
  input [NUMPOPT*WIDTH-1:0]    po_dout; 
  input [NUMPOPT-1:0]          po_serr;
  input [NUMPOPT-1:0]          po_derr;
  input [NUMPOPT*BITPADR-1:0]  po_padr;
  input [NUMPOPT*(BITADDR+1)-1:0]    po_cnt; 
  input [NUMPOPT*BITADDR-1:0]  po_snxt; 
  input [NUMPOPT*WIDTH-1:0]    po_sdout; 

  input                        clk;
  input                        rst;
  output                       ready;

// synopsys translate_off
// translate_off
  reg               read_wire [0:NUMRDPT-1];
  reg [BITADDR-1:0] rd_adr_wire [0:NUMRDPT-1];
  reg [BITVBNK1-1:0] rd_badr1_wire [0:NUMRDPT-1];
  reg [BITVBNK2-1:0] rd_badr2_wire [0:NUMRDPT-1];
  reg [BITVBNK3-1:0] rd_badr3_wire [0:NUMRDPT-1];
  reg [BITSROW-1:0] rd_radr_wire [0:NUMRDPT-1];
  reg [BITWRDS-1:0] rd_wadr_wire [0:NUMRDPT-1];
  reg               rw_read_wire [0:NUMRWPT-1];
  reg               rw_write_wire [0:NUMRWPT-1];
  reg [BITADDR-1:0] rw_addr_wire [0:NUMRWPT-1];
  reg [BITVBNK1-1:0] rw_badr1_wire [0:NUMRWPT-1];
  reg [BITVBNK2-1:0] rw_badr2_wire [0:NUMRWPT-1];
  reg [BITVBNK3-1:0] rw_badr3_wire [0:NUMRWPT-1];
  reg [BITSROW-1:0] rw_radr_wire [0:NUMRWPT-1];
  reg [BITWRDS-1:0] rw_wadr_wire [0:NUMRWPT-1];
  reg [BITPADRX:0] rw_padr_wire [0:NUMRWPT-1];
  reg [WIDTH-1:0]   rw_din_wire [0:NUMRWPT-1];

  genvar prt_var;
  generate if (1) begin: prt_loop
    for (prt_var=0; prt_var<NUMRDPT; prt_var=prt_var+1) begin: rd_loop
      assign read_wire[prt_var] = read >> prt_var;
      assign rd_adr_wire[prt_var] = rd_adr >> (prt_var*BITADDR);

      wire [BITVROW1-1:0] radr1_wire;
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1),
                 .NUMVROW (NUMVROW1), .BITVROW (BITVROW1))
        bnk1_inst (.vbadr(rd_badr1_wire[prt_var]), .vradr(radr1_wire), .vaddr(rd_adr_wire[prt_var]));

      wire [BITVROW2-1:0] radr2_wire;
      if (NUMVBNK2>1) begin: bnk2_loop
        np2_addr #(.NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                   .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2),
                   .NUMVROW (NUMVROW2), .BITVROW (BITVROW2))
          bnk2_inst (.vbadr(rd_badr2_wire[prt_var]), .vradr(radr2_wire), .vaddr(radr1_wire));
      end else begin: nbnk2_loop
        assign rd_badr2_wire[prt_var] = 0;
        assign radr2_wire = radr1_wire;
      end

      wire [BITVROW3-1:0] radr3_wire;
      if (NUMVBNK3>1) begin: bnk3_loop
        np2_addr #(.NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                   .NUMVBNK (NUMVBNK3), .BITVBNK (BITVBNK3),
                   .NUMVROW (NUMVROW3), .BITVROW (BITVROW3))
          bnk3_inst (.vbadr(rd_badr3_wire[prt_var]), .vradr(radr3_wire), .vaddr(radr2_wire));
      end else begin: nbnk3_loop
        assign rd_badr3_wire[prt_var] = 0;
        assign radr3_wire = radr2_wire;
      end

      if (NUMWRDS>1) begin: wrd_loop
        np2_addr #(.NUMADDR (NUMVROW3), .BITADDR (BITVROW3),
                   .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                   .NUMVROW (NUMSROW), .BITVROW (BITSROW))
          wadr_inst (.vbadr(rd_wadr_wire[prt_var]), .vradr(rd_radr_wire[prt_var]), .vaddr(radr3_wire));
      end else begin: nwrd_loop
        assign rd_wadr_wire[prt_var] = 0;
        assign rd_radr_wire[prt_var] = radr3_wire;
      end
    end
    for (prt_var=0; prt_var<NUMRWPT; prt_var=prt_var+1) begin: rw_loop
      assign rw_read_wire[prt_var] = rw_read >> prt_var;
      assign rw_write_wire[prt_var] = rw_write >> prt_var;
      assign rw_addr_wire[prt_var] = rw_addr >> (prt_var*BITADDR);
      assign rw_din_wire[prt_var] = rw_din >> (prt_var*WIDTH);

      wire [BITVROW1-1:0] radr1_wire;
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1),
                 .NUMVROW (NUMVROW1), .BITVROW (BITVROW1))
        bnk1_inst (.vbadr(rw_badr1_wire[prt_var]), .vradr(radr1_wire), .vaddr(rw_addr_wire[prt_var]));

      wire [BITVROW2-1:0] radr2_wire;
      if (NUMVBNK2>1) begin: bnk2_loop
        np2_addr #(.NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                   .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2),
                   .NUMVROW (NUMVROW2), .BITVROW (BITVROW2))
          bnk2_inst (.vbadr(rw_badr2_wire[prt_var]), .vradr(radr2_wire), .vaddr(radr1_wire));
      end else begin: nbnk2_loop
        assign rw_badr2_wire[prt_var] = 0;
        assign radr2_wire = radr1_wire;
      end

      wire [BITVROW3-1:0] radr3_wire;
      if (NUMVBNK3>1) begin: bnk3_loop
        np2_addr #(.NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                   .NUMVBNK (NUMVBNK3), .BITVBNK (BITVBNK3),
                   .NUMVROW (NUMVROW3), .BITVROW (BITVROW3))
          bnk3_inst (.vbadr(rw_badr3_wire[prt_var]), .vradr(radr3_wire), .vaddr(radr2_wire));
      end else begin: nbnk3_loop
        assign rw_badr3_wire[prt_var] = 0;
        assign radr3_wire = radr2_wire;
      end

      if (NUMWRDS>1) begin: wrd_loop
        np2_addr #(.NUMADDR (NUMVROW3), .BITADDR (BITVROW3),
                   .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                   .NUMVROW (NUMSROW), .BITVROW (BITSROW))
          wadr_inst (.vbadr(rw_wadr_wire[prt_var]), .vradr(rw_radr_wire[prt_var]), .vaddr(radr3_wire));
      end else begin: nwrd_loop
        assign rw_wadr_wire[prt_var] = 0;
        assign rw_radr_wire[prt_var] = radr3_wire;
      end

      assign rw_padr_wire[prt_var] = rw_radr_wire[prt_var] |
                                     (rw_wadr_wire[prt_var] << (BITSROW)) |
                                     (rw_badr3_wire[prt_var] << (BITSROW+BITWRDS)) |
                                     (rw_badr2_wire[prt_var] << (BITSROW+BITWRDS+BITPBNK3)) |
                                     (rw_badr1_wire[prt_var] << (BITSROW+BITWRDS+BITPBNK3+BITPBNK2));
    end
  end
  endgenerate

  // The following is for error injection support
`ifdef SUPPORTED
  // systemVerilog sparse memory -- location only allocated when indexed
  bit [WIDTH-1 :0] mem[*];
  // This is for backdoor access support
  bit bdw_flag[*]; // backdoor written flag
  bit fwd_flag[*]; // backdoor forward flag
  // systemVerilog sparse memory -- location only allocated when indexed
  bit serr[NUMEROR][*];
  bit derr[NUMEROR][*];
`else
  reg [WIDTH-1 :0] mem[NUMADDR-1:0];
  // This is for backdoor access support
  reg bdw_flag[NUMADDR-1:0]; // backdoor written flag
  reg fwd_flag[NUMADDR-1:0]; // backdoor forward flag
  integer f_int;
  initial begin
    for (f_int=0; f_int<NUMADDR; f_int=f_int+1) begin
      bdw_flag[f_int] = 1'b0;
      fwd_flag[f_int] = 1'b0;
    end
  end

  bit serr[NUMEROR-1:0][NUMSROW-1:0];
  bit derr[NUMEROR-1:0][NUMSROW-1:0];
  integer b_int, s_int;
  initial begin
    for (b_int=0; b_int<NUMEROR; b_int=b_int+1)
      for (s_int=0; s_int<NUMSROW; s_int=s_int+1) begin
          serr[b_int][s_int] = 1'b0;
          derr[b_int][s_int] = 1'b0;
      end
  end
`endif

  // on write, clear error (if exists) on that bank and the extra bank
  integer wr_int;
  always @(posedge clk) begin
    for (wr_int=0; wr_int<NUMRWPT; wr_int=wr_int+1)
      if (rw_write_wire[wr_int]) begin
`ifdef SUPPORTED
        mem[rw_addr_wire[wr_int]] = rw_din_wire[wr_int];
        if (mem.exists(rw_addr_wire[wr_int])) bdw_flag.delete(rw_addr_wire[wr_int]);
        if (serr[rw_padr_wire[wr_int][BITPADRX:BITSROW]].exists(rw_radr_wire[wr_int]))
            serr[rw_padr_wire[wr_int][BITPADRX:BITSROW]].delete(rw_radr_wire[wr_int]);
        if (derr[rw_padr_wire[wr_int][BITPADRX:BITSROW]].exists(rw_radr_wire[wr_int]))
            derr[rw_padr_wire[wr_int][BITPADRX:BITSROW]].delete(rw_radr_wire[wr_int]);
`else
        mem[rw_addr_wire[wr_int]] <= rw_din_wire[wr_int];
        bdw_flag[rw_addr_wire[wr_int]] <= 1'b0;
        serr[rw_padr_wire[wr_int][BITPADRX:BITSROW]][rw_radr_wire[wr_int]] <= 1'b0;
        derr[rw_padr_wire[wr_int][BITPADRX:BITSROW]][rw_radr_wire[wr_int]] <= 1'b0;
`endif
      end
  end

  reg [NUMEROR:0] rd_c0 [0:NUMRDPT-1];
  reg [NUMEROR:0] rw_c0 [0:NUMRWPT-1];
  reg rd_c1 [0:NUMRDPT-1];
  reg rw_c1 [0:NUMRWPT-1];
  reg [BITPADR-1:0] rd_tmp0 [0:NUMRDPT-1];
  reg [BITPADR-1:0] rw_tmp0 [0:NUMRWPT-1];
  integer b0, rde_int;
  always_comb begin
    for (rde_int=0; rde_int<NUMRDPT; rde_int=rde_int+1)
      if (read_wire[rde_int]) begin
        rd_c0[rde_int] = 0;
        rd_c1[rde_int] = 0;
        rd_tmp0[rde_int] = rd_radr_wire[rde_int] |
                           (rd_wadr_wire[rde_int] << BITSROW) |
                           (rd_badr3_wire[rde_int] << BITSROW+BITWRDS) |
                           (rd_badr2_wire[rde_int] << BITSROW+BITWRDS+BITPBNK3) |
                           (rd_badr1_wire[rde_int] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2) |
                           (fwd_flag[rd_adr_wire[rde_int]] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2+BITPBNK1);
        for (b0 = NUMEROR; b0 >= 0; b0 = b0 - 1) begin
`ifdef SUPPORTED
          if (serr[b0].exists(rd_radr_wire[rde_int]))
`else
          if (serr[b0][rd_radr_wire[rde_int]])
`endif
            rd_c0[rde_int] = rd_c0[rde_int]+1;
`ifdef SUPPORTED
          if (derr[b0].exists(rd_radr_wire[rde_int]))
`else
          if (derr[b0][rd_radr_wire[rde_int]])
`endif
            rd_c1[rde_int] = 1;
          if ((rd_c0[rde_int] > 0) || rd_c1[rde_int])
            rd_tmp0[rde_int] = rd_radr_wire[rde_int] | (b0 << BITSROW) | (fwd_flag[rd_adr_wire[rde_int]] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2+BITPBNK1);
        end
      end
    for (rde_int=0; rde_int<NUMRWPT; rde_int=rde_int+1)
      if (rw_read_wire[rde_int]) begin
        rw_c0[rde_int] = 0;
        rw_c1[rde_int] = 0;
        rw_tmp0[rde_int] = rw_radr_wire[rde_int] |
                           (rw_wadr_wire[rde_int] << BITSROW) |
                           (rw_badr3_wire[rde_int] << BITSROW+BITWRDS) |
                           (rw_badr2_wire[rde_int] << BITSROW+BITWRDS+BITPBNK3) |
                           (rw_badr1_wire[rde_int] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2) |
                           (fwd_flag[rw_addr_wire[rde_int]] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2+BITPBNK1);
        for (b0 = NUMEROR; b0 >= 0; b0 = b0 - 1) begin
`ifdef SUPPORTED
          if (serr[b0].exists(rw_radr_wire[rde_int]))
`else
          if (serr[b0][rw_radr_wire[rde_int]])
`endif
            rw_c0[rde_int] = rw_c0[rde_int]+1;
`ifdef SUPPORTED
          if (derr[b0].exists(rw_radr_wire[rde_int]))
`else
          if (derr[b0][rw_radr_wire[rde_int]])
`endif
            rw_c1[rde_int] = 1;
          if ((rw_c0[rde_int] > 0) || rw_c1[rde_int])
            rw_tmp0[rde_int] = rw_radr_wire[rde_int] | (b0 << BITSROW) | (fwd_flag[rw_addr_wire[rde_int]] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2+BITPBNK1);
        end
      end
  end

  // output pipeline
  reg               rd_vld_reg [0:NUMRDPT-1][0:MEM_DELAY-1];
  reg [WIDTH-1:0]   rd_dout_reg [0:NUMRDPT-1][0:MEM_DELAY-1];
  reg               rd_serr_reg [0:NUMRDPT-1][0:MEM_DELAY-1];
  reg               rd_derr_reg [0:NUMRDPT-1][0:MEM_DELAY-1];
  reg [BITPADR-1:0] rd_padr_reg [0:NUMRDPT-1][0:MEM_DELAY-1];

  reg               rw_vld_reg [0:NUMRWPT-1][0:MEM_DELAY-1];
  reg [WIDTH-1:0]   rw_dout_reg [0:NUMRWPT-1][0:MEM_DELAY-1];
  reg               rw_serr_reg [0:NUMRWPT-1][0:MEM_DELAY-1];
  reg               rw_derr_reg [0:NUMRWPT-1][0:MEM_DELAY-1];
  reg [BITPADR-1:0] rw_padr_reg [0:NUMRWPT-1][0:MEM_DELAY-1];

  integer rd_int, del_int;
  always @(posedge clk) begin
    for (del_int=0; del_int<MEM_DELAY; del_int=del_int+1) begin
      for (rd_int=0; rd_int<NUMRDPT; rd_int=rd_int+1)
        if (del_int>0) begin
          rd_vld_reg[rd_int][del_int] <= rd_vld_reg[rd_int][del_int-1];
          rd_dout_reg[rd_int][del_int] <= rd_dout_reg[rd_int][del_int-1];
          rd_serr_reg[rd_int][del_int] <= rd_serr_reg[rd_int][del_int-1];
          rd_derr_reg[rd_int][del_int] <= rd_derr_reg[rd_int][del_int-1];
          rd_padr_reg[rd_int][del_int] <= rd_padr_reg[rd_int][del_int-1];
        end else begin
          rd_vld_reg[rd_int][del_int] <= read_wire[rd_int];
          rd_dout_reg[rd_int][del_int] <= mem[rd_adr_wire[rd_int]];
          rd_serr_reg[rd_int][del_int] <= (MODEROR == 0) ? 0 : (read_wire[rd_int] &&
                                         ((MODEROR == 1) ? (rd_c0[rd_int]==1) : (rd_c0[rd_int]>0)));
          rd_derr_reg[rd_int][del_int] <= (MODEROR == 0) ? 0 : (read_wire[rd_int] &&
                                         ((MODEROR == 1) ? (rd_c0[rd_int]>1) : rd_c1[rd_int]));
          rd_padr_reg[rd_int][del_int] <= read_wire[rd_int] ? rd_tmp0[rd_int] : 0;
        end
      for (rd_int=0; rd_int<NUMRWPT; rd_int=rd_int+1)
        if (del_int>0) begin
          rw_vld_reg[rd_int][del_int] <= rw_vld_reg[rd_int][del_int-1];
          rw_dout_reg[rd_int][del_int] <= rw_dout_reg[rd_int][del_int-1];
          rw_serr_reg[rd_int][del_int] <= rw_serr_reg[rd_int][del_int-1];
          rw_derr_reg[rd_int][del_int] <= rw_derr_reg[rd_int][del_int-1];
          rw_padr_reg[rd_int][del_int] <= rw_padr_reg[rd_int][del_int-1];
        end else begin
          rw_vld_reg[rd_int][del_int] <= rw_read_wire[rd_int];
          rw_dout_reg[rd_int][del_int] <= mem[rw_addr_wire[rd_int]];
          rw_serr_reg[rd_int][del_int] <= (MODEROR == 0) ? 0 : (rw_read_wire[rd_int] &&
                                         ((MODEROR == 1) ? (rw_c0[rd_int]==1) : (rw_c0[rd_int]>0)));
          rw_derr_reg[rd_int][del_int] <= (MODEROR == 0) ? 0 : (rw_read_wire[rd_int] &&
                                         ((MODEROR == 1) ? (rw_c0[rd_int]>1) : rw_c1[rd_int]));
          rw_padr_reg[rd_int][del_int] <= rw_read_wire[rd_int] ? rw_tmp0[rd_int] : 0;
        end
    end
end

  reg [NUMRDPT-1:0]         rd_vld;
  reg [NUMRDPT*WIDTH-1:0]   rd_dout;
  reg [NUMRDPT-1:0]         rd_serr;
  reg [NUMRDPT-1:0]         rd_derr;
  reg [NUMRDPT*BITPADR-1:0] rd_padr;

  reg [NUMRWPT-1:0]         rw_vld;
  reg [NUMRWPT*WIDTH-1:0]   rw_dout;
  reg [NUMRWPT-1:0]         rw_serr;
  reg [NUMRWPT-1:0]         rw_derr;
  reg [NUMRWPT*BITPADR-1:0] rw_padr;

  integer out_int;
  always_comb begin
    rd_vld = 0;
    rd_dout = 0;
    rd_serr = 0;
    rd_derr = 0;
    rd_padr = 0;
    rw_vld = 0;
    rw_dout = 0;
    rw_serr = 0;
    rw_derr = 0;
    rw_padr = 0;
    for (out_int=0; out_int<NUMRDPT; out_int=out_int+1) begin
      rd_vld = rd_vld | (rd_vld_reg[out_int][MEM_DELAY-1] << out_int);
      rd_dout = rd_dout | (rd_dout_reg[out_int][MEM_DELAY-1] << (out_int*WIDTH));
      rd_serr = rd_serr | (rd_serr_reg[out_int][MEM_DELAY-1] << out_int);
      rd_derr = rd_derr | (rd_derr_reg[out_int][MEM_DELAY-1] << out_int);
      rd_padr = rd_padr | (rd_padr_reg[out_int][MEM_DELAY-1] << (out_int*BITPADR));
    end
    for (out_int=0; out_int<NUMRWPT; out_int=out_int+1) begin
      rw_vld = rw_vld | (rw_vld_reg[out_int][MEM_DELAY-1] << out_int);
      rw_dout = rw_dout | (rw_dout_reg[out_int][MEM_DELAY-1] << (out_int*WIDTH));
      rw_serr = rw_serr | (rw_serr_reg[out_int][MEM_DELAY-1] << out_int);
      rw_derr = rw_derr | (rw_derr_reg[out_int][MEM_DELAY-1] << out_int);
      rw_padr = rw_padr | (rw_padr_reg[out_int][MEM_DELAY-1] << (out_int*BITPADR));
    end
  end

  reg ready;
  always @(posedge clk)
    ready <= !rst;
// synopsys translate_on
// translate_on

endmodule
