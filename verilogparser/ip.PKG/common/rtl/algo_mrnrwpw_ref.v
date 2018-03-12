module algo_mrnrwpw_ref (refr,  
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
  parameter UPD_DELAY = 1;

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
  reg               write_wire [0:NUMWRPT-1];
  reg [BITADDR-1:0] wr_adr_wire [0:NUMWRPT-1];
  reg [BITVBNK1-1:0] wr_badr1_wire [0:NUMWRPT-1];
  reg [BITVBNK2-1:0] wr_badr2_wire [0:NUMWRPT-1];
  reg [BITVBNK3-1:0] wr_badr3_wire [0:NUMWRPT-1];
  reg [BITSROW-1:0] wr_radr_wire [0:NUMWRPT-1];
  reg [BITWRDS-1:0] wr_wadr_wire [0:NUMWRPT-1];
  reg [BITPADRX:0] wr_padr_wire [0:NUMWRPT-1];
  reg [WIDTH-1:0]   din_wire [0:NUMWRPT-1];
  reg               cnt_wire [0:NUMCTPT-1];
  reg [BITADDR-1:0] ct_adr_wire [0:NUMCTPT-1];
  reg [BITVBNK1-1:0] ct_badr1_wire [0:NUMCTPT-1];
  reg [BITVBNK2-1:0] ct_badr2_wire [0:NUMCTPT-1];
  reg [BITVBNK3-1:0] ct_badr3_wire [0:NUMCTPT-1];
  reg [BITSROW-1:0] ct_radr_wire [0:NUMCTPT-1];
  reg [BITWRDS-1:0] ct_wadr_wire [0:NUMCTPT-1];
  reg [WIDTH-1:0]   ct_imm_wire [0:NUMCTPT-1];
  reg               ac_read_wire [0:NUMACPT-1];
  reg               ac_write_wire [0:NUMACPT-1];
  reg [BITADDR-1:0] ac_addr_wire [0:NUMACPT-1];
  reg [BITVBNK1-1:0] ac_badr1_wire [0:NUMACPT-1];
  reg [BITVBNK2-1:0] ac_badr2_wire [0:NUMACPT-1];
  reg [BITVBNK3-1:0] ac_badr3_wire [0:NUMACPT-1];
  reg [BITSROW-1:0] ac_radr_wire [0:NUMACPT-1];
  reg [BITWRDS-1:0] ac_wadr_wire [0:NUMACPT-1];
  reg [BITPADRX:0] ac_padr_wire [0:NUMACPT-1];
  reg [WIDTH-1:0]   ac_din_wire [0:NUMACPT-1];
  reg               ru_read_wire [0:NUMRUPT-1];
  reg               ru_write_wire [0:NUMRUPT-1];
  reg [BITADDR-1:0] ru_addr_wire [0:NUMRUPT-1];
  reg [BITVBNK1-1:0] ru_badr1_wire [0:NUMRUPT-1];
  reg [BITVBNK2-1:0] ru_badr2_wire [0:NUMRUPT-1];
  reg [BITVBNK3-1:0] ru_badr3_wire [0:NUMRUPT-1];
  reg [BITSROW-1:0] ru_radr_wire [0:NUMRUPT-1];
  reg [BITWRDS-1:0] ru_wadr_wire [0:NUMRUPT-1];
  reg [BITPADRX:0] ru_padr_wire [0:NUMRUPT-1];
  reg [WIDTH-1:0]   ru_din_wire [0:NUMRUPT-1];

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
    for (prt_var=0; prt_var<NUMWRPT; prt_var=prt_var+1) begin: wr_loop
      assign write_wire[prt_var] = write >> prt_var;
      assign wr_adr_wire[prt_var] = wr_adr >> (prt_var*BITADDR);
      assign din_wire[prt_var] = din >> (prt_var*WIDTH);

      wire [BITVROW1-1:0] radr1_wire;
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1),
                 .NUMVROW (NUMVROW1), .BITVROW (BITVROW1))
        bnk1_inst (.vbadr(wr_badr1_wire[prt_var]), .vradr(radr1_wire), .vaddr(wr_adr_wire[prt_var]));

      wire [BITVROW2-1:0] radr2_wire;
      if (NUMVBNK2>1) begin: bnk2_loop
        np2_addr #(.NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                   .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2),
                   .NUMVROW (NUMVROW2), .BITVROW (BITVROW2))
          bnk2_inst (.vbadr(wr_badr2_wire[prt_var]), .vradr(radr2_wire), .vaddr(radr1_wire));
      end else begin: nbnk2_loop
        assign wr_badr2_wire[prt_var] = 0;
        assign radr2_wire = radr1_wire;
      end

      wire [BITVROW3-1:0] radr3_wire;
      if (NUMVBNK3>1) begin: bnk3_loop
        np2_addr #(.NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                   .NUMVBNK (NUMVBNK3), .BITVBNK (BITVBNK3),
                   .NUMVROW (NUMVROW3), .BITVROW (BITVROW3))
          bnk2_inst (.vbadr(wr_badr3_wire[prt_var]), .vradr(radr3_wire), .vaddr(radr2_wire));
      end else begin: nbnk3_loop
        assign wr_badr3_wire[prt_var] = 0;
        assign radr3_wire = radr2_wire;
      end

      if (NUMWRDS>1) begin: wrd_loop
        np2_addr #(.NUMADDR (NUMVROW3), .BITADDR (BITVROW3),
                   .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                   .NUMVROW (NUMSROW), .BITVROW (BITSROW))
          wadr_inst (.vbadr(wr_wadr_wire[prt_var]), .vradr(wr_radr_wire[prt_var]), .vaddr(radr3_wire));
      end else begin: nwrd_loop
        assign wr_wadr_wire[prt_var] = 0;
        assign wr_radr_wire[prt_var] = radr3_wire;
      end
   
      assign wr_padr_wire[prt_var] = wr_radr_wire[prt_var] |
                                     (wr_wadr_wire[prt_var] << (BITSROW)) |
                                     (wr_badr3_wire[prt_var] << (BITSROW+BITWRDS)) |
                                     (wr_badr2_wire[prt_var] << (BITSROW+BITWRDS+BITPBNK3)) |
                                     (wr_badr1_wire[prt_var] << (BITSROW+BITWRDS+BITPBNK3+BITPBNK2));
    end
    for (prt_var=0; prt_var<NUMCTPT; prt_var=prt_var+1) begin: ct_loop
      assign cnt_wire[prt_var] = cnt >> prt_var;
      assign ct_adr_wire[prt_var] = ct_adr >> (prt_var*BITADDR);
      assign ct_imm_wire[prt_var] = ct_imm >> (prt_var*WIDTH);

      wire [BITVROW1-1:0] radr1_wire;
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1),
                 .NUMVROW (NUMVROW1), .BITVROW (BITVROW1))
        bnk1_inst (.vbadr(ct_badr1_wire[prt_var]), .vradr(radr1_wire), .vaddr(ct_adr_wire[prt_var]));

      wire [BITVROW2-1:0] radr2_wire;
      if (NUMVBNK2>1) begin: bnk2_loop
        np2_addr #(.NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                   .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2),
                   .NUMVROW (NUMVROW2), .BITVROW (BITVROW2))
          bnk2_inst (.vbadr(ct_badr2_wire[prt_var]), .vradr(radr2_wire), .vaddr(radr1_wire));
      end else begin: nbnk2_loop
        assign ct_badr2_wire[prt_var] = 0;
        assign radr2_wire = radr1_wire;
      end

      wire [BITVROW3-1:0] radr3_wire;
      if (NUMVBNK3>1) begin: bnk3_loop
        np2_addr #(.NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                   .NUMVBNK (NUMVBNK3), .BITVBNK (BITVBNK3),
                   .NUMVROW (NUMVROW3), .BITVROW (BITVROW3))
          bnk3_inst (.vbadr(ct_badr3_wire[prt_var]), .vradr(radr3_wire), .vaddr(radr2_wire));
      end else begin: nbnk3_loop
        assign ct_badr3_wire[prt_var] = 0;
        assign radr3_wire = radr2_wire;
      end

      if (NUMWRDS>1) begin: wrd_loop
        np2_addr #(.NUMADDR (NUMVROW3), .BITADDR (BITVROW3),
                   .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                   .NUMVROW (NUMSROW), .BITVROW (BITSROW))
          wadr_inst (.vbadr(ct_wadr_wire[prt_var]), .vradr(ct_radr_wire[prt_var]), .vaddr(radr3_wire));
      end else begin: nwrd_loop
        assign ct_wadr_wire[prt_var] = 0;
        assign ct_radr_wire[prt_var] = radr3_wire;
      end
    end
    for (prt_var=0; prt_var<NUMACPT; prt_var=prt_var+1) begin: ac_loop
      assign ac_read_wire[prt_var] = ac_read >> prt_var;
      assign ac_write_wire[prt_var] = ac_write >> prt_var;
      assign ac_addr_wire[prt_var] = ac_addr >> (prt_var*BITADDR);
      assign ac_din_wire[prt_var] = ac_din >> (prt_var*WIDTH);

      wire [BITVROW1-1:0] radr1_wire;
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1),
                 .NUMVROW (NUMVROW1), .BITVROW (BITVROW1))
        bnk1_inst (.vbadr(ac_badr1_wire[prt_var]), .vradr(radr1_wire), .vaddr(ac_addr_wire[prt_var]));

      wire [BITVROW2-1:0] radr2_wire;
      if (NUMVBNK2>1) begin: bnk2_loop
        np2_addr #(.NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                   .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2),
                   .NUMVROW (NUMVROW2), .BITVROW (BITVROW2))
          bnk2_inst (.vbadr(ac_badr2_wire[prt_var]), .vradr(radr2_wire), .vaddr(radr1_wire));
      end else begin: nbnk2_loop
        assign ac_badr2_wire[prt_var] = 0;
        assign radr2_wire = radr1_wire;
      end

      wire [BITVROW3-1:0] radr3_wire;
      if (NUMVBNK3>1) begin: bnk3_loop
        np2_addr #(.NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                   .NUMVBNK (NUMVBNK3), .BITVBNK (BITVBNK3),
                   .NUMVROW (NUMVROW3), .BITVROW (BITVROW3))
          bnk2_inst (.vbadr(rd_badr3_wire[prt_var]), .vradr(radr3_wire), .vaddr(radr2_wire));
      end else begin: nbnk3_loop
        assign ac_badr3_wire[prt_var] = 0;
        assign radr3_wire = radr2_wire;
      end

      if (NUMWRDS>1) begin: wrd_loop
        np2_addr #(.NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                   .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                   .NUMVROW (NUMSROW), .BITVROW (BITSROW))
          wadr_inst (.vbadr(ac_wadr_wire[prt_var]), .vradr(ac_radr_wire[prt_var]), .vaddr(radr3_wire));
      end else begin: nwrd_loop
        assign ac_wadr_wire[prt_var] = 0;
        assign ac_radr_wire[prt_var] = radr3_wire;
      end

      assign ac_padr_wire[prt_var] = ac_radr_wire[prt_var] |
                                     (ac_wadr_wire[prt_var] << (BITSROW)) |
                                     (ac_badr3_wire[prt_var] << (BITSROW+BITWRDS)) |
                                     (ac_badr2_wire[prt_var] << (BITSROW+BITWRDS+BITPBNK3)) |
                                     (ac_badr1_wire[prt_var] << (BITSROW+BITWRDS+BITPBNK3+BITPBNK2));
    end
    for (prt_var=0; prt_var<NUMRUPT; prt_var=prt_var+1) begin: ru_loop
      assign ru_read_wire[prt_var] = ru_read >> prt_var;
      assign ru_write_wire[prt_var] = ru_write >> prt_var;
      assign ru_addr_wire[prt_var] = ru_addr >> (prt_var*BITADDR);
      assign ru_din_wire[prt_var] = ru_din >> (prt_var*WIDTH);

      wire [BITVROW1-1:0] radr1_wire;
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK1), .BITVBNK (BITVBNK1),
                 .NUMVROW (NUMVROW1), .BITVROW (BITVROW1))
        bnk1_inst (.vbadr(ru_badr1_wire[prt_var]), .vradr(radr1_wire), .vaddr(ru_addr_wire[prt_var]));

      wire [BITVROW2-1:0] radr2_wire;
      if (NUMVBNK2>1) begin: bnk2_loop
        np2_addr #(.NUMADDR (NUMVROW1), .BITADDR (BITVROW1),
                   .NUMVBNK (NUMVBNK2), .BITVBNK (BITVBNK2),
                   .NUMVROW (NUMVROW2), .BITVROW (BITVROW2))
          bnk2_inst (.vbadr(ru_badr2_wire[prt_var]), .vradr(radr2_wire), .vaddr(radr1_wire));
      end else begin: nbnk2_loop
        assign ru_badr2_wire[prt_var] = 0;
        assign radr2_wire = radr1_wire;
      end

      wire [BITVROW3-1:0] radr3_wire;
      if (NUMVBNK3>1) begin: bnk3_loop
        np2_addr #(.NUMADDR (NUMVROW2), .BITADDR (BITVROW2),
                   .NUMVBNK (NUMVBNK3), .BITVBNK (BITVBNK3),
                   .NUMVROW (NUMVROW3), .BITVROW (BITVROW3))
          bnk3_inst (.vbadr(ru_badr3_wire[prt_var]), .vradr(radr3_wire), .vaddr(radr2_wire));
      end else begin: nbnk3_loop
        assign ru_badr3_wire[prt_var] = 0;
        assign radr3_wire = radr2_wire;
      end

      if (NUMWRDS>1) begin: wrd_loop
        np2_addr #(.NUMADDR (NUMVROW3), .BITADDR (BITVROW3),
                   .NUMVBNK (NUMWRDS), .BITVBNK (BITWRDS),
                   .NUMVROW (NUMSROW), .BITVROW (BITSROW))
          wadr_inst (.vbadr(ru_wadr_wire[prt_var]), .vradr(ru_radr_wire[prt_var]), .vaddr(radr3_wire));
      end else begin: nwrd_loop
        assign ru_wadr_wire[prt_var] = 0;
        assign ru_radr_wire[prt_var] = radr3_wire;
      end

      assign ru_padr_wire[prt_var] = ru_radr_wire[prt_var] |
                                     (ru_wadr_wire[prt_var] << (BITSROW)) |
                                     (ru_badr3_wire[prt_var] << (BITSROW+BITWRDS)) |
                                     (ru_badr2_wire[prt_var] << (BITSROW+BITWRDS+BITPBNK3)) |
                                     (ru_badr1_wire[prt_var] << (BITSROW+BITWRDS+BITPBNK3+BITPBNK2));
    end
  end
  endgenerate

  // The following is for error injection support
`ifdef SUPPORTED
  // systemVerilog sparse memory -- location only allocated when indexed
  bit [WIDTH-1 :0] mem[*];
  bit [WIDTH-1 :0] mem_del[*];
  // This is for backdoor access support
  bit bdw_flag[*]; // backdoor written flag
  bit fwd_flag[*]; // backdoor forward flag
  // systemVerilog sparse memory -- location only allocated when indexed
  bit serr[NUMEROR][*];
  bit derr[NUMEROR][*];
`else
  reg [WIDTH-1 :0] mem[NUMADDR-1:0];
  reg [WIDTH-1 :0] mem_del[NUMADDR-1:0];
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

  integer mdel_int; 
  always @(posedge clk)
    for (mdel_int=0; mdel_int<NUMADDR; mdel_int=mdel_int+1)
      mem_del[mdel_int] <= mem[mdel_int];

//  wire [WIDTH-1:0] mem_help = mem['h57A4];

  reg [WIDTH:0] cnt_temp [0:NUMCTPT-1];
  integer ct_int, ctp_int;
  always_comb
    for (ct_int=0; ct_int<NUMCTPT; ct_int=ct_int+1) begin
      cnt_temp[ct_int] = mem[ct_adr_wire[ct_int]] + ct_imm_wire[ct_int];
      cnt_temp[ct_int] = {|cnt_temp[ct_int][WIDTH:WIDTH-1],cnt_temp[ct_int][WIDTH-2:0]};
      for (ctp_int=0; ctp_int<NUMCTPT; ctp_int=ctp_int+1)
        if ((ct_int != ctp_int) && (cnt_wire[ctp_int] && (ct_adr_wire[ctp_int] == ct_adr_wire[ct_int]))) begin
          cnt_temp[ct_int] = cnt_temp[ct_int] + ct_imm_wire[ctp_int];
          cnt_temp[ct_int] = {|cnt_temp[ct_int][WIDTH:WIDTH-1],cnt_temp[ct_int][WIDTH-2:0]};
        end
    end

  reg [BITADDR-1:0] ru_addr_reg [0:NUMRUPT-1][0:MEM_DELAY+UPD_DELAY-1];
  reg [BITVBNK1-1:0] ru_badr_reg [0:NUMRUPT-1][0:MEM_DELAY+UPD_DELAY-1];
  reg [BITSROW-1:0] ru_radr_reg [0:NUMRUPT-1][0:MEM_DELAY+UPD_DELAY-1];
  reg [BITWRDS-1:0] ru_wadr_reg [0:NUMRUPT-1][0:MEM_DELAY+UPD_DELAY-1];
  reg [BITPADRX:0] ru_padr_reg [0:NUMRUPT-1][0:MEM_DELAY+UPD_DELAY-1];

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
    for (wr_int=0; wr_int<NUMWRPT; wr_int=wr_int+1)
      if (write_wire[wr_int]) begin
`ifdef SUPPORTED
        mem[wr_adr_wire[wr_int]] = din_wire[wr_int];
        if (mem.exists(wr_adr_wire[wr_int])) bdw_flag.delete(wr_adr_wire[wr_int]);
        if (serr[wr_padr_wire[wr_int][BITPADRX:BITSROW]].exists(wr_radr_wire[wr_int]))
            serr[wr_padr_wire[wr_int][BITPADRX:BITSROW]].delete(wr_radr_wire[wr_int]);
        if (derr[wr_padr_wire[wr_int][BITPADRX:BITSROW]].exists(wr_radr_wire[wr_int]))
            derr[wr_padr_wire[wr_int][BITPADRX:BITSROW]].delete(wr_radr_wire[wr_int]);
`else
        mem[wr_adr_wire[wr_int]] <= din_wire[wr_int];
        bdw_flag[wr_adr_wire[wr_int]] <= 1'b0;
        serr[wr_padr_wire[wr_int][BITPADRX:BITSROW]][wr_radr_wire[wr_int]] <= 1'b0;
        derr[wr_padr_wire[wr_int][BITPADRX:BITSROW]][wr_radr_wire[wr_int]] <= 1'b0;
`endif
      end
    for (wr_int=0; wr_int<NUMCTPT; wr_int=wr_int+1)
      if (cnt_wire[wr_int]) begin
`ifdef SUPPORTED
        mem[ct_adr_wire[wr_int]] = cnt_temp[wr_int];
        if (mem.exists(ct_adr_wire[wr_int])) bdw_flag.delete(ct_adr_wire[wr_int]);
`else
        mem[ct_adr_wire[wr_int]] <= cnt_temp[wr_int];
        bdw_flag[ct_adr_wire[wr_int]] <= 1'b0;
`endif
      end
    for (wr_int=0; wr_int<NUMACPT; wr_int=wr_int+1)
      if (ac_write_wire[wr_int]) begin
`ifdef SUPPORTED
        mem[ac_addr_wire[wr_int]] = ac_din_wire[wr_int];
        if (mem.exists(ac_addr_wire[wr_int])) bdw_flag.delete(ac_addr_wire[wr_int]);
        if (serr[ac_padr_wire[wr_int][BITPADRX:BITSROW]].exists(ac_radr_wire[wr_int]))
            serr[ac_padr_wire[wr_int][BITPADRX:BITSROW]].delete(ac_radr_wire[wr_int]);
        if (derr[ac_padr_wire[wr_int][BITPADRX:BITSROW]].exists(ac_radr_wire[wr_int]))
            derr[ac_padr_wire[wr_int][BITPADRX:BITSROW]].delete(ac_radr_wire[wr_int]);
`else
        mem[ac_addr_wire[wr_int]] <= ac_din_wire[wr_int];
        bdw_flag[ac_addr_wire[wr_int]] <= 1'b0;
        serr[ac_padr_wire[wr_int][BITPADRX:BITSROW]][ac_radr_wire[wr_int]] <= 1'b0;
        derr[ac_padr_wire[wr_int][BITPADRX:BITSROW]][ac_radr_wire[wr_int]] <= 1'b0;
`endif
      end
    if (NUMRUPT && rst)
      for (int a=0; a<NUMADDR; a=a+1)
`ifdef SUPPORTED
        mem[a] = 0;
`else
        mem[a] <= 0;
`endif
    for (wr_int=0; wr_int<NUMRUPT; wr_int=wr_int+1)
      if (ru_write_wire[wr_int]) begin
`ifdef SUPPORTED
        mem[ru_addr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]] = ru_din_wire[wr_int];
        if (mem.exists(ru_addr_reg[wr_int][MEM_DELAY+UPD_DELAY-1])) bdw_flag.delete(ru_addr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]);
        if (serr[ru_padr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]].exists(ru_radr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]))
            serr[ru_padr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]].delete(ru_radr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]);
        if (derr[ru_padr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]].exists(ru_radr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]))
            derr[ru_padr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]].delete(ru_radr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]);
`else
        mem[ru_addr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]] <= ru_din_wire[wr_int];
        bdw_flag[ru_addr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]] <= 1'b0;
        serr[ru_padr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]][ru_radr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]] <= 1'b0;
        derr[ru_padr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]][ru_radr_reg[wr_int][MEM_DELAY+UPD_DELAY-1]] <= 1'b0;
`endif
      end
  end

  reg [NUMEROR:0] rd_c0 [0:NUMRDPT-1];
  reg [NUMEROR:0] rw_c0 [0:NUMRWPT-1];
  reg [NUMEROR:0] ct_c0 [0:NUMCTPT-1];
  reg [NUMEROR:0] ac_c0 [0:NUMACPT-1];
  reg [NUMEROR:0] ru_c0 [0:NUMRUPT-1];
  reg rd_c1 [0:NUMRDPT-1];
  reg rw_c1 [0:NUMRWPT-1];
  reg ct_c1 [0:NUMCTPT-1];
  reg ac_c1 [0:NUMACPT-1];
  reg ru_c1 [0:NUMRUPT-1];
  reg [BITPADR-1:0] rd_tmp0 [0:NUMRDPT-1];
  reg [BITPADR-1:0] rw_tmp0 [0:NUMRWPT-1];
  reg [BITPADR-1:0] ct_tmp0 [0:NUMCTPT-1];
  reg [BITPADR-1:0] ac_tmp0 [0:NUMACPT-1];
  reg [BITPADR-1:0] ru_tmp0 [0:NUMRUPT-1];
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
    for (rde_int=0; rde_int<NUMCTPT; rde_int=rde_int+1)
      if (cnt_wire[rde_int]) begin
        ct_c0[rde_int] = 0;
        ct_c1[rde_int] = 0;
        ct_tmp0[rde_int] = ct_radr_wire[rde_int] |
                           (ct_wadr_wire[rde_int] << BITSROW) |
                           (ct_badr3_wire[rde_int] << BITSROW+BITWRDS) |
                           (ct_badr2_wire[rde_int] << BITSROW+BITWRDS+BITPBNK3) |
                           (ct_badr1_wire[rde_int] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2) |
                           (fwd_flag[ct_adr_wire[rde_int]] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2+BITPBNK1);
        for (b0 = NUMEROR; b0 >= 0; b0 = b0 - 1) begin
`ifdef SUPPORTED
          if (serr[b0].exists(ct_radr_wire[rde_int]))
`else
          if (serr[b0][ct_radr_wire[rde_int]])
`endif
            ct_c0[rde_int] = ct_c0[rde_int]+1;
`ifdef SUPPORTED
          if (derr[b0].exists(ct_radr_wire[rde_int]))
`else
          if (derr[b0][ct_radr_wire[rde_int]])
`endif
            ct_c1[rde_int] = 1;
          if ((ct_c0[rde_int] > 0) || ct_c1[rde_int])
            ct_tmp0[rde_int] = ct_radr_wire[rde_int] | (b0 << BITSROW) | (fwd_flag[ct_adr_wire[rde_int]] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2+BITPBNK1);
        end
      end
    for (rde_int=0; rde_int<NUMACPT; rde_int=rde_int+1)
      if (ac_read_wire[rde_int]) begin
        ac_c0[rde_int] = 0;
        ac_c1[rde_int] = 0;
        ac_tmp0[rde_int] = ac_radr_wire[rde_int] |
                           (ac_wadr_wire[rde_int] << BITSROW) |
                           (ac_badr3_wire[rde_int] << BITSROW+BITWRDS) |
                           (ac_badr2_wire[rde_int] << BITSROW+BITWRDS+BITPBNK3) |
                           (ac_badr1_wire[rde_int] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2) |
                           (fwd_flag[ac_addr_wire[rde_int]] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2+BITPBNK1);
        for (b0 = NUMEROR; b0 >= 0; b0 = b0 - 1) begin
`ifdef SUPPORTED
          if (serr[b0].exists(ac_radr_wire[rde_int]))
`else
          if (serr[b0][ac_radr_wire[rde_int]])
`endif
            ac_c0[rde_int] = ac_c0[rde_int]+1;
`ifdef SUPPORTED
          if (derr[b0].exists(ac_radr_wire[rde_int]))
`else
          if (derr[b0][ac_radr_wire[rde_int]])
`endif
            ac_c1[rde_int] = 1;
          if ((ac_c0[rde_int] > 0) || ac_c1[rde_int])
            ac_tmp0[rde_int] = ac_radr_wire[rde_int] | (b0 << BITSROW) | (fwd_flag[ac_addr_wire[rde_int]] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2+BITPBNK1);
        end
      end
    for (rde_int=0; rde_int<NUMRUPT; rde_int=rde_int+1)
      if (ru_read_wire[rde_int]) begin
        ru_c0[rde_int] = 0;
        ru_c1[rde_int] = 0;
        ru_tmp0[rde_int] = ru_radr_wire[rde_int] |
                           (ru_wadr_wire[rde_int] << BITSROW) |
                           (ru_badr3_wire[rde_int] << BITSROW+BITWRDS) |
                           (ru_badr2_wire[rde_int] << BITSROW+BITWRDS+BITPBNK3) |
                           (ru_badr1_wire[rde_int] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2) |
                           (fwd_flag[ru_addr_wire[rde_int]] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2+BITPBNK1);
        for (b0 = NUMEROR; b0 >= 0; b0 = b0 - 1) begin
`ifdef SUPPORTED
          if (serr[b0].exists(ru_radr_wire[rde_int]))
`else
          if (serr[b0][ru_radr_wire[rde_int]])
`endif
            ru_c0[rde_int] = ru_c0[rde_int]+1;
`ifdef SUPPORTED
          if (derr[b0].exists(ru_radr_wire[rde_int]))
`else
          if (derr[b0][ru_radr_wire[rde_int]])
`endif
            ru_c1[rde_int] = 1;
          if ((ru_c0[rde_int] > 0) || ru_c1[rde_int])
            ru_tmp0[rde_int] = ru_radr_wire[rde_int] | (b0 << BITSROW) | (fwd_flag[ru_addr_wire[rde_int]] << BITSROW+BITWRDS+BITPBNK3+BITPBNK2+BITPBNK1);
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

  reg               ct_vld_reg [0:NUMCTPT-1][0:MEM_DELAY-1];
  reg               ct_serr_reg [0:NUMCTPT-1][0:MEM_DELAY-1];
  reg               ct_derr_reg [0:NUMCTPT-1][0:MEM_DELAY-1];

  reg               ac_vld_reg [0:NUMACPT-1][0:MEM_DELAY-1];
  reg [WIDTH-1:0]   ac_dout_reg [0:NUMACPT-1][0:MEM_DELAY-1];
  reg               ac_serr_reg [0:NUMACPT-1][0:MEM_DELAY-1];
  reg               ac_derr_reg [0:NUMACPT-1][0:MEM_DELAY-1];
  reg [BITPADR-1:0] ac_padr_reg [0:NUMACPT-1][0:MEM_DELAY-1];

  reg               ru_vld_reg [0:NUMRUPT-1][0:MEM_DELAY+UPD_DELAY-1];
  reg [WIDTH-1:0]   ru_dout_reg [0:NUMRUPT-1][0:MEM_DELAY+UPD_DELAY-1];
  reg               ru_serr_reg [0:NUMRUPT-1][0:MEM_DELAY+UPD_DELAY-1];
  reg               ru_derr_reg [0:NUMRUPT-1][0:MEM_DELAY+UPD_DELAY-1];

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
      for (rd_int=0; rd_int<NUMCTPT; rd_int=rd_int+1)
        if (del_int>0) begin
          ct_vld_reg[rd_int][del_int] <= ct_vld_reg[rd_int][del_int-1];
          ct_serr_reg[rd_int][del_int] <= ct_serr_reg[rd_int][del_int-1];
          ct_derr_reg[rd_int][del_int] <= ct_derr_reg[rd_int][del_int-1];
        end else begin
          ct_vld_reg[rd_int][del_int] <= cnt_wire[rd_int];
          ct_serr_reg[rd_int][del_int] <= (MODEROR == 0) ? 0 : (cnt_wire[rd_int] &&
                                         ((MODEROR == 1) ? (ct_c0[rd_int]==1) : (ct_c0[rd_int]>0)));
          ct_derr_reg[rd_int][del_int] <= (MODEROR == 0) ? 0 : (cnt_wire[rd_int] &&
                                         ((MODEROR == 1) ? (ct_c0[rd_int]>1) : ct_c1[rd_int]));
        end
      for (rd_int=0; rd_int<NUMACPT; rd_int=rd_int+1)
        if (del_int>0) begin
          ac_vld_reg[rd_int][del_int] <= ac_vld_reg[rd_int][del_int-1];
          ac_dout_reg[rd_int][del_int] <= ac_dout_reg[rd_int][del_int-1];
          ac_serr_reg[rd_int][del_int] <= ac_serr_reg[rd_int][del_int-1];
          ac_derr_reg[rd_int][del_int] <= ac_derr_reg[rd_int][del_int-1];
          ac_padr_reg[rd_int][del_int] <= ac_padr_reg[rd_int][del_int-1];
        end else begin
          ac_vld_reg[rd_int][del_int] <= ac_read_wire[rd_int];
          ac_dout_reg[rd_int][del_int] <= mem[ac_addr_wire[rd_int]];
          ac_serr_reg[rd_int][del_int] <= (MODEROR == 0) ? 0 : (ac_read_wire[rd_int] &&
                                         ((MODEROR == 1) ? (ac_c0[rd_int]==1) : (ac_c0[rd_int]>0)));
          ac_derr_reg[rd_int][del_int] <= (MODEROR == 0) ? 0 : (ac_read_wire[rd_int] &&
                                         ((MODEROR == 1) ? (ac_c0[rd_int]>1) : ac_c1[rd_int]));
          ac_padr_reg[rd_int][del_int] <= ac_read_wire[rd_int] ? ac_tmp0[rd_int] : 0;
        end
    end
    for (del_int=0; del_int<MEM_DELAY+UPD_DELAY; del_int=del_int+1) begin
      for (rd_int=0; rd_int<NUMRUPT; rd_int=rd_int+1)
        if (del_int>0) begin
          ru_vld_reg[rd_int][del_int] <= ru_vld_reg[rd_int][del_int-1];
          ru_addr_reg[rd_int][del_int] <= ru_addr_reg[rd_int][del_int-1];
          ru_badr_reg[rd_int][del_int] <= ru_badr_reg[rd_int][del_int-1];
          ru_radr_reg[rd_int][del_int] <= ru_radr_reg[rd_int][del_int-1];
          ru_wadr_reg[rd_int][del_int] <= ru_wadr_reg[rd_int][del_int-1];
          ru_dout_reg[rd_int][del_int] <= ru_dout_reg[rd_int][del_int-1];
          ru_serr_reg[rd_int][del_int] <= ru_serr_reg[rd_int][del_int-1];
          ru_derr_reg[rd_int][del_int] <= ru_derr_reg[rd_int][del_int-1];
          ru_padr_reg[rd_int][del_int] <= ru_padr_reg[rd_int][del_int-1];
        end else begin
          ru_vld_reg[rd_int][del_int] <= ru_read_wire[rd_int];
          ru_addr_reg[rd_int][del_int] <= ru_addr_wire[rd_int];
          ru_badr_reg[rd_int][del_int] <= ru_badr1_wire[rd_int];
          ru_radr_reg[rd_int][del_int] <= ru_radr_wire[rd_int];
          ru_wadr_reg[rd_int][del_int] <= ru_wadr_wire[rd_int];
          ru_dout_reg[rd_int][del_int] <= mem[ru_addr_wire[rd_int]];
          ru_serr_reg[rd_int][del_int] <= (MODEROR == 0) ? 0 : (ru_read_wire[rd_int] &&
                                         ((MODEROR == 1) ? (ru_c0[rd_int]==1) : (ru_c0[rd_int]>0)));
          ru_derr_reg[rd_int][del_int] <= (MODEROR == 0) ? 0 : (ru_read_wire[rd_int] &&
                                         ((MODEROR == 1) ? (ru_c0[rd_int]>1) : ru_c1[rd_int]));
          ru_padr_reg[rd_int][del_int] <= ru_read_wire[rd_int] ? ru_tmp0[rd_int] : 0;
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

  reg [NUMCTPT-1:0]         ct_vld;
  reg [NUMCTPT-1:0]         ct_serr;
  reg [NUMCTPT-1:0]         ct_derr;

  reg [NUMACPT-1:0]         ac_vld;
  reg [NUMACPT*WIDTH-1:0]   ac_dout;
  reg [NUMACPT-1:0]         ac_serr;
  reg [NUMACPT-1:0]         ac_derr;
  reg [NUMACPT*BITPADR-1:0] ac_padr;

  reg [NUMRUPT-1:0]         ru_vld;
  reg [NUMRUPT*WIDTH-1:0]   ru_dout;
  reg [NUMRUPT-1:0]         ru_serr;
  reg [NUMRUPT-1:0]         ru_derr;
  reg [NUMRUPT*BITPADR-1:0] ru_padr;

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
    ct_vld = 0;
    ct_serr = 0;
    ct_derr = 0;
    ac_vld = 0;
    ac_dout = 0;
    ac_serr = 0;
    ac_derr = 0;
    ac_padr = 0;
    ru_vld = 0;
    ru_dout = 0;
    ru_serr = 0;
    ru_derr = 0;
    ru_padr = 0;
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
    for (out_int=0; out_int<NUMCTPT; out_int=out_int+1) begin
      ct_vld = ct_vld | (ct_vld_reg[out_int][MEM_DELAY-1] << out_int);
      ct_serr = ct_serr | (ct_serr_reg[out_int][MEM_DELAY-1] << out_int);
      ct_derr = ct_derr | (ct_derr_reg[out_int][MEM_DELAY-1] << out_int);
    end
    for (out_int=0; out_int<NUMACPT; out_int=out_int+1) begin
      ac_vld = ac_vld | (ac_vld_reg[out_int][MEM_DELAY-1] << out_int);
      ac_dout = ac_dout | (ac_dout_reg[out_int][MEM_DELAY-1] << (out_int*WIDTH));
      ac_serr = ac_serr | (ac_serr_reg[out_int][MEM_DELAY-1] << out_int);
      ac_derr = ac_derr | (ac_derr_reg[out_int][MEM_DELAY-1] << out_int);
      ac_padr = ac_padr | (ac_padr_reg[out_int][MEM_DELAY-1] << (out_int*BITPADR));
    end
    for (out_int=0; out_int<NUMRUPT; out_int=out_int+1) begin
      ru_vld = ru_vld | (ru_vld_reg[out_int][MEM_DELAY-1] << out_int);
      ru_dout = ru_dout | (mem_del[ru_addr_reg[out_int][MEM_DELAY-1]] << (out_int*WIDTH));
      ru_serr = ru_serr | (ru_serr_reg[out_int][MEM_DELAY-1] << out_int);
      ru_derr = ru_derr | (ru_derr_reg[out_int][MEM_DELAY-1] << out_int);
      ru_padr = ru_padr | (ru_padr_reg[out_int][MEM_DELAY-1] << (out_int*BITPADR));
    end
  end

  reg ready;
  always @(posedge clk)
    ready <= !rst;
// synopsys translate_on
// translate_on
endmodule
