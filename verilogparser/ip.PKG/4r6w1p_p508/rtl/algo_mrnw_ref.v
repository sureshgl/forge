module algo_mrnw_ref (refr,  
                         read, rd_badr, rd_radr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                         rw_read, rw_write, rw_addr, rw_din, rw_vld, rw_dout, rw_serr, rw_derr, rw_padr,
                         write, wr_badr, wr_radr, din, 
                         cnt, ct_adr, ct_imm, ct_vld, ct_serr, ct_derr,
                         ac_read, ac_write, ac_addr, ac_din, ac_vld, ac_dout, ac_serr, ac_derr, ac_padr,
                         ru_read, ru_write, ru_addr, ru_din, ru_vld, ru_dout, ru_serr, ru_derr, ru_padr,
                         ma_write, ma_adr, ma_bp, ma_din, dq_vld, dq_adr,
                         push, pu_adr, pu_din, pu_ptr, pu_vld, pu_cnt,
                         pop, po_adr, po_vld, po_dout, po_serr, po_derr, po_padr, po_ptr, po_nxt, po_cnt, po_snxt, po_sdout,
                         clk, ready, rst);

  parameter WIDTH = 4;
  parameter WRBUSRED = 4;
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
  input [NUMRDPT*BITVBNK1-1:0]  rd_badr;
  input [NUMRDPT*BITVROW1-1:0]  rd_radr;
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
  input [NUMWRPT*BITVBNK1-1:0]  wr_badr;
  input [NUMWRPT*BITVROW1-1:0]  wr_radr;
  input [(4+16/WRBUSRED)*WIDTH-1:0]    din;

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
  reg [BITVBNK1-1:0] rd_badr_wire [0:NUMRDPT-1];
  reg [BITVROW1-1:0] rd_radr_wire [0:NUMRDPT-1];
  reg               write_wire [0:NUMWRPT-1];
  reg [BITVBNK1-1:0] wr_badr_wire [0:NUMWRPT-1];
  reg [BITVROW1-1:0] wr_radr_wire [0:NUMWRPT-1];
  reg [WIDTH-1:0]   din_wire [0:(4+16/WRBUSRED)-1];

  genvar prt_var;
  generate if (1) begin: prt_loop
    for (prt_var=0; prt_var<NUMRDPT; prt_var=prt_var+1) begin: rd_loop
      assign read_wire[prt_var] = read >> prt_var;
      assign rd_badr_wire[prt_var] = rd_badr >> (prt_var*BITVBNK1);
      assign rd_radr_wire[prt_var] = rd_radr >> (prt_var*BITVROW1);
    end
    for (prt_var=0; prt_var<NUMWRPT; prt_var=prt_var+1) begin: wr_loop
      assign write_wire[prt_var] = write >> prt_var;
      assign wr_badr_wire[prt_var] = wr_badr >> (prt_var*BITVBNK1);
      assign wr_radr_wire[prt_var] = wr_radr >> (prt_var*BITVROW1);
    end
  end
  endgenerate

  genvar pwrp_int;
  generate
    for (pwrp_int=0; pwrp_int<4+16/WRBUSRED; pwrp_int=pwrp_int+1) begin
      assign din_wire[pwrp_int] = din >> ((pwrp_int)*WIDTH);
    end
  endgenerate

  reg [WIDTH-1 :0] mem[NUMVBNK1-1:0][NUMVROW1-1:0];

  // on write, clear error (if exists) on that bank and the extra bank
  integer wr_int;
  always @(posedge clk) begin
    for (wr_int=0; wr_int<NUMWRPT; wr_int=wr_int+1)
      if (write_wire[wr_int]) begin
       if (wr_int < 4) begin
             mem[wr_badr_wire[wr_int]][wr_radr_wire[wr_int]] <= din_wire[wr_int];
          end else begin
             mem[wr_badr_wire[wr_int]][wr_radr_wire[wr_int]] <= din_wire[4 + (wr_int-4)/WRBUSRED];
          end
      end
  end

  // output pipeline
  reg               rd_vld_reg [0:NUMRDPT-1][0:MEM_DELAY-1];
  reg [WIDTH-1:0]   rd_dout_reg [0:NUMRDPT-1][0:MEM_DELAY-1];

  integer rd_int, del_int;
  always @(posedge clk) begin
    for (del_int=0; del_int<MEM_DELAY; del_int=del_int+1) begin
      for (rd_int=0; rd_int<NUMRDPT; rd_int=rd_int+1)
        if (del_int>0) begin
          rd_vld_reg[rd_int][del_int] <= rd_vld_reg[rd_int][del_int-1];
          rd_dout_reg[rd_int][del_int] <= rd_dout_reg[rd_int][del_int-1];
        end else begin
          rd_vld_reg[rd_int][del_int] <= read_wire[rd_int];
          rd_dout_reg[rd_int][del_int] <= mem[rd_badr_wire[rd_int]][rd_radr_wire[rd_int]];
        end
    end
end

  reg [NUMRDPT-1:0]         rd_vld;
  reg [NUMRDPT*WIDTH-1:0]   rd_dout;
  reg [NUMRDPT-1:0]         rd_serr;
  reg [NUMRDPT-1:0]         rd_derr;
  reg [NUMRDPT*BITPADR-1:0] rd_padr;

  integer out_int;
  always_comb begin
    rd_vld = 0;
    rd_dout = 0;
    rd_serr = 0;
    rd_derr = 0;
    rd_padr = 0;
    for (out_int=0; out_int<NUMRDPT; out_int=out_int+1) begin
      rd_vld = rd_vld | (rd_vld_reg[out_int][MEM_DELAY-1] << out_int);
      rd_dout = rd_dout | (rd_dout_reg[out_int][MEM_DELAY-1] << (out_int*WIDTH));
    end
  end

  reg ready;
  always @(posedge clk)
    ready <= !rst;
// synopsys translate_on
// translate_on

endmodule
