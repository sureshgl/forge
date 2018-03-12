module stack_mrnw (write, wr_adr, bw, din, read, rd_adr, rd_dout, rd_fwrd, rd_serr, rd_derr, rd_padr,
	           mem_write, mem_wr_adr, mem_bw, mem_din, mem_read, mem_rd_adr, mem_rd_dout,
                   clk, rst);

  parameter WIDTH = 32;
  parameter ENAPSDO = 1;
  parameter NUMRDPT = 2;
  parameter NUMWRPT = 2;
  parameter NUMADDR = 1024;
  parameter BITADDR = 10;
  parameter NUMWBNK = 4;
  parameter BITWBNK = 2;
  parameter NUMWROW = 256;
  parameter BITWROW = 8;
  parameter BITPADR = 10;
  parameter SRAM_DELAY = 2;
  parameter FLOPCMD = 0;
  parameter FLOPMEM = 0;
  parameter FLOPOUT = 0;

  input [NUMWRPT-1:0] write;
  input [NUMWRPT*BITADDR-1:0] wr_adr;
  input [NUMWRPT*WIDTH-1:0] bw;
  input [NUMWRPT*WIDTH-1:0] din;

  input [NUMRDPT-1:0] read;
  input [NUMRDPT*BITADDR-1:0] rd_adr;
  output [NUMRDPT*WIDTH-1:0] rd_dout;
  output [NUMRDPT-1:0] rd_fwrd;
  output [NUMRDPT-1:0] rd_serr;
  output [NUMRDPT-1:0] rd_derr;
  output [NUMRDPT*BITPADR-1:0] rd_padr;

  output [NUMWRPT*NUMWBNK-1:0] mem_write;
  output [NUMWRPT*NUMWBNK*BITWROW-1:0] mem_wr_adr;
  output [NUMWRPT*NUMWBNK*WIDTH-1:0] mem_bw;
  output [NUMWRPT*NUMWBNK*WIDTH-1:0] mem_din;
  output [NUMRDPT*NUMWBNK-1:0] mem_read;
  output [NUMRDPT*NUMWBNK*BITWROW-1:0] mem_rd_adr;
  input [NUMRDPT*NUMWBNK*WIDTH-1:0] mem_rd_dout;

  input clk;
  input rst;

  wire [NUMWRPT-1:0] write_wire = write;
  wire [NUMWRPT*BITADDR-1:0] wr_adr_wire = wr_adr;
  wire [NUMWRPT*WIDTH-1:0] bw_wire = bw;
  wire [NUMWRPT*WIDTH-1:0] din_wire = din;
  wire [NUMRDPT-1:0] read_wire = read;
  wire [NUMRDPT*BITADDR-1:0] rd_adr_wire = rd_adr;

  wire [BITADDR-1:0] wr_addr [0:NUMWRPT-1];
  wire [BITWBNK-1:0] wr_wadr [0:NUMWRPT-1];
  wire [BITWROW-1:0] wr_radr [0:NUMWRPT-1];
  wire [WIDTH-1:0]   wr_mask [0:NUMWRPT-1];
  wire [WIDTH-1:0]   wr_data [0:NUMWRPT-1];
  wire [BITADDR-1:0] rd_addr [0:NUMRDPT-1];
  wire [BITWBNK-1:0] rd_wadr [0:NUMRDPT-1];
  wire [BITWROW-1:0] rd_radr [0:NUMRDPT-1];
  genvar np2_var;
  generate if (1) begin: np2_loop
    for (np2_var=0; np2_var<NUMWRPT; np2_var=np2_var+1) begin: wr_loop
      assign wr_addr[np2_var] = wr_adr_wire >> (np2_var*BITADDR);
      if (BITWBNK>0) begin: bnk_loop
        np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                   .NUMVBNK (NUMWBNK), .BITVBNK (BITWBNK),
                   .NUMVROW (NUMWROW), .BITVROW (BITWROW))
          wr_adr_inst (.vbadr(wr_wadr[np2_var]), .vradr(wr_radr[np2_var]), .vaddr(wr_addr[np2_var]));
      end else begin: nbnk_loop
        assign wr_wadr[np2_var] = 0;
        assign wr_radr[np2_var] = wr_addr[np2_var];
      end

      assign wr_mask[np2_var] = bw_wire >> (np2_var*WIDTH);
      assign wr_data[np2_var] = din_wire >> (np2_var*WIDTH);
    end
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign rd_addr[np2_var] = rd_adr_wire >> (np2_var*BITADDR);
      if (BITWBNK>0) begin: bnk_loop
      np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMWBNK), .BITVBNK (BITWBNK),
                 .NUMVROW (NUMWROW), .BITVROW (BITWROW))
        rd_adr_inst (.vbadr(rd_wadr[np2_var]), .vradr(rd_radr[np2_var]), .vaddr(rd_addr[np2_var]));
      end else begin: nbnk_loop
        assign rd_wadr[np2_var] = 0;
        assign rd_radr[np2_var] = rd_addr[np2_var];
      end
    end
  end
  endgenerate

  reg write_vld_reg [0:NUMRDPT+NUMWRPT-2];
  reg [BITWBNK-1:0] write_wadr_reg [0:NUMRDPT+NUMWRPT-2];
  reg [BITWROW-1:0] write_radr_reg [0:NUMRDPT+NUMWRPT-2];
  reg [WIDTH-1:0] write_bw_reg [0:NUMRDPT+NUMWRPT-2];
  reg [WIDTH-1:0] write_din_reg [0:NUMRDPT+NUMWRPT-2];
/*
  wire write_vld_reg_0 = write_vld_reg[0];
  wire [BITWBNK-1:0] write_wadr_reg_0 = write_wadr_reg[0];
  wire [BITWROW-1:0] write_radr_reg_0 = write_radr_reg[0];
  wire [WIDTH-1:0] write_bw_reg_0 = write_bw_reg[0];
  wire [WIDTH-1:0] write_din_reg_0 = write_din_reg[0];

  wire write_vld_reg_1 = write_vld_reg[1];
  wire [BITWBNK-1:0] write_wadr_reg_1 = write_wadr_reg[1];
  wire [BITWROW-1:0] write_radr_reg_1 = write_radr_reg[1];
  wire [WIDTH-1:0] write_bw_reg_1 = write_bw_reg[1];
  wire [WIDTH-1:0] write_din_reg_1 = write_din_reg[1];

  wire write_vld_reg_2 = write_vld_reg[2];
  wire [BITWBNK-1:0] write_wadr_reg_2 = write_wadr_reg[2];
  wire [BITWROW-1:0] write_radr_reg_2 = write_radr_reg[2];
  wire [WIDTH-1:0] write_bw_reg_2 = write_bw_reg[2];
  wire [WIDTH-1:0] write_din_reg_2 = write_din_reg[2];
*/
  reg wr_match [0:NUMWRPT-1];
  reg rd_match [0:NUMWRPT-1];
  reg wr_eject [0:NUMWRPT-1];
  reg [3:0] wr_ejprt [0:NUMWRPT-1];
  reg wr_used [0:NUMRDPT+NUMWRPT-2];
  reg wr_used_tmp [0:NUMRDPT+NUMWRPT-2];

  reg mem_write_wire [0:NUMWRPT-1];
  reg [BITWBNK-1:0] mem_wr_wadr_wire [0:NUMWRPT-1];
  reg [BITWROW-1:0] mem_wr_radr_wire [0:NUMWRPT-1];
  reg [WIDTH-1:0] mem_bw_wire [0:NUMWRPT-1];
  reg [WIDTH-1:0] mem_din_wire [0:NUMWRPT-1];
  reg mem_read_wire [0:NUMRDPT-1];
  reg [BITWBNK-1:0] mem_rd_wadr_wire [0:NUMRDPT-1];
  reg [BITWROW-1:0] mem_rd_radr_wire [0:NUMRDPT-1];

  reg forward_read [0:NUMRDPT-1];
  reg [WIDTH-1:0] forward_mask [0:NUMRDPT-1];
  reg [WIDTH-1:0] forward_data [0:NUMRDPT-1];
/*
  wire forward_read_0 = forward_read[0];
  wire wr_match_0 = wr_match[0];
  wire rd_match_0 = rd_match[0];
  wire wr_eject_0 = wr_eject[0];
  wire forward_read_1 = forward_read[1];
  wire wr_match_1 = wr_match[1];
  wire rd_match_1 = rd_match[1];
  wire wr_eject_1 = wr_eject[1];
  wire [3:0] wr_ejprt_0 = wr_ejprt[0];
  wire [3:0] wr_ejprt_1 = wr_ejprt[1];

  wire wr_used_0 = wr_used[0];
  wire wr_used_tmp_0 = wr_used_tmp[0];
  wire wr_used_1 = wr_used[1];
  wire wr_used_tmp_1 = wr_used_tmp[1];
  wire wr_used_2 = wr_used[2];
  wire wr_used_tmp_2 = wr_used_tmp[2];

  wire mem_write_wire_0 = mem_write_wire[0];
  wire mem_write_wire_1 = mem_write_wire[1];
*/
  generate if (ENAPSDO) begin: psdo_loop
    reg write_vld_nxt [0:NUMRDPT+NUMWRPT-2];
    reg [BITWBNK-1:0] write_wadr_nxt [0:NUMRDPT+NUMWRPT-2];
    reg [BITWROW-1:0] write_radr_nxt [0:NUMRDPT+NUMWRPT-2];
    reg [WIDTH-1:0] write_bw_nxt [0:NUMRDPT+NUMWRPT-2];
    reg [WIDTH-1:0] write_din_nxt [0:NUMRDPT+NUMWRPT-2];

    integer wrn_int, rdr_int;
    always_comb begin
      for (wrn_int=0; wrn_int<NUMRDPT+NUMWRPT-1; wrn_int=wrn_int+1) begin
        write_vld_nxt[wrn_int] = write_vld_reg[wrn_int];
        write_wadr_nxt[wrn_int] = write_wadr_reg[wrn_int];
        write_radr_nxt[wrn_int] = write_radr_reg[wrn_int];
        write_bw_nxt[wrn_int] = write_bw_reg[wrn_int];
        write_din_nxt[wrn_int] = write_din_reg[wrn_int];
        wr_used[wrn_int] = 1'b0;
        wr_used_tmp[wrn_int] = 1'b0;
        if (wrn_int<NUMWRPT) begin
          wr_match[wrn_int] = 1'b0;
          wr_eject[wrn_int] = 1'b0;
          wr_ejprt[wrn_int] = 0;
        end
      end
      for (wrn_int=0; wrn_int<NUMWRPT; wrn_int=wrn_int+1) begin
        for (rdr_int=0; rdr_int<NUMRDPT+NUMWRPT-1; rdr_int=rdr_int+1)
          if (write_wire[wrn_int] && write_vld_reg[rdr_int] && (wr_radr[wrn_int] == write_radr_reg[rdr_int]) && (wr_wadr[wrn_int] == write_wadr_reg[rdr_int])) begin
            write_vld_nxt[rdr_int] = 1'b1;
            write_wadr_nxt[rdr_int] = wr_wadr[wrn_int];
            write_radr_nxt[rdr_int] = wr_radr[wrn_int];
            write_bw_nxt[rdr_int] = write_bw_nxt[rdr_int] | wr_mask[wrn_int];
            write_din_nxt[rdr_int] = (write_din_nxt[rdr_int] & write_bw_nxt[rdr_int] & ~wr_mask[wrn_int]) | (wr_data[wrn_int] & wr_mask[wrn_int]);
            wr_used[rdr_int] = 1'b1;
            wr_used_tmp[rdr_int] = 1'b1;
            wr_match[wrn_int] = 1'b1;
          end
      end
      for (wrn_int=0; wrn_int<NUMWRPT; wrn_int=wrn_int+1) begin
        rd_match[wrn_int] = 1'b0;
        for (rdr_int=0; rdr_int<NUMRDPT; rdr_int=rdr_int+1) begin
          if (write_wire[wrn_int] && read_wire[rdr_int] && (wr_radr[wrn_int] == rd_radr[rdr_int]) && (wr_wadr[wrn_int] == rd_wadr[rdr_int]))
            rd_match[wrn_int] = 1'b1;
        end
      end
      for (rdr_int=0; rdr_int<NUMRDPT; rdr_int=rdr_int+1) begin
        for (wrn_int=0; wrn_int<NUMRDPT+NUMWRPT-1; wrn_int=wrn_int+1) begin
          if (read_wire[rdr_int] && write_vld_reg[wrn_int] && (rd_radr[rdr_int] == write_radr_reg[wrn_int]) && (rd_wadr[rdr_int] == write_wadr_reg[wrn_int])) begin
            wr_used[wrn_int] = 1'b1;
            wr_used_tmp[wrn_int] = 1'b1;
          end
        end
      end
      for (wrn_int=0; wrn_int<NUMWRPT; wrn_int=wrn_int+1)
        for (rdr_int=0; rdr_int<NUMRDPT+NUMWRPT-1; rdr_int=rdr_int+1)
          if (rd_match[wrn_int] && !wr_match[wrn_int] && !wr_used[rdr_int] && !wr_eject[wrn_int]) begin
            write_vld_nxt[rdr_int] = 1'b1;
            write_wadr_nxt[rdr_int] = wr_wadr[wrn_int];
            write_radr_nxt[rdr_int] = wr_radr[wrn_int];
            write_bw_nxt[rdr_int] = wr_mask[wrn_int];
            write_din_nxt[rdr_int] = wr_data[wrn_int];
            wr_eject[wrn_int] = 1'b1;
            wr_ejprt[wrn_int] = rdr_int;
            wr_used[rdr_int] = 1'b1;
          end
      for (wrn_int=0; wrn_int<NUMRDPT+NUMWRPT-1; wrn_int=wrn_int+1)
        if (rst)
          write_vld_nxt[wrn_int] = 1'b0;
    end

    integer wrr_int;
    always @(posedge clk)
      for (wrr_int=0; wrr_int<NUMRDPT+NUMWRPT-1; wrr_int=wrr_int+1) begin
        write_vld_reg[wrr_int] <= write_vld_nxt[wrr_int];
        write_wadr_reg[wrr_int] <= write_wadr_nxt[wrr_int];
        write_radr_reg[wrr_int] <= write_radr_nxt[wrr_int];
        write_bw_reg[wrr_int] <= write_bw_nxt[wrr_int];
        write_din_reg[wrr_int] <= write_din_nxt[wrr_int];
      end
      
    integer mem_int, fwd_int;
    always_comb begin
      for (mem_int=0; mem_int<NUMWRPT; mem_int=mem_int+1) begin
        mem_write_wire[mem_int] = write_wire[mem_int] && !(rd_match[mem_int] && !(wr_eject[mem_int] && write_vld_reg[wr_ejprt[mem_int]]));
        mem_wr_wadr_wire[mem_int] = rd_match[mem_int] ? write_wadr_reg[wr_ejprt[mem_int]] : wr_wadr[mem_int];
        mem_wr_radr_wire[mem_int] = rd_match[mem_int] ? write_radr_reg[wr_ejprt[mem_int]] : wr_radr[mem_int];
        mem_bw_wire[mem_int] = rd_match[mem_int] ? write_bw_reg[wr_ejprt[mem_int]] : wr_mask[mem_int];
        mem_din_wire[mem_int] = rd_match[mem_int] ? write_din_reg[wr_ejprt[mem_int]] : wr_data[mem_int];
      end
      for (mem_int=0; mem_int<NUMRDPT; mem_int=mem_int+1) begin
        mem_read_wire[mem_int] = read_wire[mem_int];
        mem_rd_wadr_wire[mem_int] = rd_wadr[mem_int];
        mem_rd_radr_wire[mem_int] = rd_radr[mem_int];
        forward_read[mem_int] = 1'b0;
        forward_mask[mem_int] = 0;
        forward_data[mem_int] = 0;
        for (fwd_int=0; fwd_int<NUMRDPT+NUMWRPT-1; fwd_int=fwd_int+1)
          if (read_wire[mem_int] && write_vld_reg[fwd_int] && (rd_radr[mem_int] == write_radr_reg[fwd_int]) && (rd_wadr[mem_int] == write_wadr_reg[fwd_int])) begin
            forward_read[mem_int] = 1'b1;
            forward_mask[mem_int] = write_bw_reg[fwd_int];
            forward_data[mem_int] = write_din_reg[fwd_int];
          end
      end
    end
  end else begin: npsdo_loop
    integer mem_int;
    always_comb begin
      for (mem_int=0; mem_int<NUMWRPT; mem_int=mem_int+1) begin
        mem_write_wire[mem_int] = write_wire[mem_int];
        mem_wr_wadr_wire[mem_int] = wr_wadr[mem_int];
        mem_wr_radr_wire[mem_int] = wr_radr[mem_int];
        mem_bw_wire[mem_int] = wr_mask[mem_int];
        mem_din_wire[mem_int] = wr_data[mem_int];
      end
      for (mem_int=0; mem_int<NUMRDPT; mem_int=mem_int+1) begin
        mem_read_wire[mem_int] = read_wire[mem_int];
        mem_rd_wadr_wire[mem_int] = rd_wadr[mem_int];
        mem_rd_radr_wire[mem_int] = rd_radr[mem_int];
        forward_read[mem_int] = 1'b0;
      end
    end
  end
  endgenerate

/*
  wire [BITWBNK-1:0] wr_wadr_0 = wr_wadr[0];
  wire [BITWBNK-1:0] wr_wadr_1 = wr_wadr[1];
  wire [BITWROW-1:0] wr_radr_0 = wr_radr[0];
  wire [BITWROW-1:0] wr_radr_1 = wr_radr[1];

  reg mem_write_wire [0:NUMWRPT-1];
  reg [BITWBNK-1:0] mem_wr_wadr_wire [0:NUMWRPT-1];
  reg [BITWROW-1:0] mem_wr_radr_wire [0:NUMWRPT-1];
  reg [WIDTH-1:0] mem_bw_wire [0:NUMWRPT-1];
  reg [WIDTH-1:0] mem_din_wire [0:NUMWRPT-1];
  integer mwr_int, xwr_int;
  always_comb
    for (mwr_int=0; mwr_int<NUMWRPT; mwr_int=mwr_int+1) begin
      mem_write_wire[mwr_int] = write_wire[mwr_int];
      mem_wr_wadr_wire[mwr_int] = wr_wadr[mwr_int];
      mem_wr_radr_wire[mwr_int] = wr_radr[mwr_int];
      mem_bw_wire[mwr_int] = {MEMWDTH{1'b1}} << (wr_wadr[mwr_int]*MEMWDTH);
      mem_din_wire[mwr_int] = din_tmp[mwr_int] << (wr_wadr[mwr_int]*MEMWDTH);
        for (xwr_int=0; xwr_int<mwr_int; xwr_int=xwr_int+1)
          if (NUMWBNK && mem_write_wire[xwr_int] && mem_write_wire[mwr_int] && (mem_wr_adr_wire[xwr_int] == mem_wr_adr_wire[mwr_int])) begin
            mem_write_wire[xwr_int] = 1'b0;
            mem_din_wire[mwr_int] = (mem_din_wire[xwr_int] & ~mem_bw_wire[mwr_int]) | mem_din_wire[mwr_int];
            mem_bw_wire[mwr_int] = mem_bw_wire[xwr_int] | mem_bw_wire[mwr_int];
          end 
    end
*/
  reg [NUMRDPT*NUMWBNK-1:0] mem_read_tmp;
  reg [NUMRDPT*NUMWBNK*BITWROW-1:0] mem_rd_adr_tmp;
  reg [NUMWRPT*NUMWBNK-1:0] mem_write_tmp;
  reg [NUMWRPT*NUMWBNK*BITWROW-1:0] mem_wr_adr_tmp;
  reg [NUMWRPT*NUMWBNK*WIDTH-1:0] mem_bw_tmp;
  reg [NUMWRPT*NUMWBNK*WIDTH-1:0] mem_din_tmp;
  integer mem_int, memb_int, memw_int;
  always_comb begin
    mem_read_tmp = 0;
    mem_rd_adr_tmp = 0;
    for (mem_int=0; mem_int<NUMRDPT; mem_int=mem_int+1)
      for (memb_int=0; memb_int<NUMWBNK; memb_int=memb_int+1) begin
        if (mem_read_wire[mem_int] && (mem_rd_wadr_wire[mem_int] == memb_int))
          mem_read_tmp[memb_int*NUMRDPT+mem_int] = 1'b1;
        for (memw_int=0; memw_int<BITWROW; memw_int=memw_int+1)
          mem_rd_adr_tmp[(memb_int*NUMRDPT+mem_int)*BITWROW+memw_int] = mem_rd_radr_wire[mem_int][memw_int];
      end
    mem_write_tmp = 0;
    mem_wr_adr_tmp = 0;
    mem_bw_tmp = 0;
    mem_din_tmp = 0;
    for (mem_int=0; mem_int<NUMWRPT; mem_int=mem_int+1)
      for (memb_int=0; memb_int<NUMWBNK; memb_int=memb_int+1) begin
        if (mem_write_wire[mem_int] && (mem_wr_wadr_wire[mem_int] == memb_int))
          mem_write_tmp[memb_int*NUMWRPT+mem_int] = 1'b1;
        for (memw_int=0; memw_int<BITWROW; memw_int=memw_int+1)
          mem_wr_adr_tmp[(memb_int*NUMWRPT+mem_int)*BITWROW+memw_int] = mem_wr_radr_wire[mem_int][memw_int];
        for (memw_int=0; memw_int<WIDTH; memw_int=memw_int+1)
          mem_bw_tmp[(memb_int*NUMWRPT+mem_int)*WIDTH+memw_int] = mem_bw_wire[mem_int][memw_int];
        for (memw_int=0; memw_int<WIDTH; memw_int=memw_int+1)
          mem_din_tmp[(memb_int*NUMWRPT+mem_int)*WIDTH+memw_int] = mem_din_wire[mem_int][memw_int];
      end
  end

  generate if (FLOPCMD) begin: flpc_loop
    reg [NUMWRPT*NUMWBNK-1:0] mem_write_reg;
    reg [NUMWRPT*NUMWBNK*BITWROW-1:0] mem_wr_adr_reg;
    reg [NUMWRPT*NUMWBNK*WIDTH-1:0] mem_bw_reg;
    reg [NUMWRPT*NUMWBNK*WIDTH-1:0] mem_din_reg;
    reg [NUMRDPT*NUMWBNK-1:0] mem_read_reg;
    reg [NUMRDPT*NUMWBNK*BITWROW-1:0] mem_rd_adr_reg;
    always @(posedge clk) begin
      mem_write_reg <= mem_write_tmp;
      mem_wr_adr_reg <= mem_wr_adr_tmp;
      mem_bw_reg <= mem_bw_tmp;
      mem_din_reg <= mem_din_tmp;
      mem_read_reg <= mem_read_tmp;
      mem_rd_adr_reg <= mem_rd_adr_tmp;
    end

    assign mem_write = mem_write_reg;
    assign mem_wr_adr = mem_wr_adr_reg;
    assign mem_bw = mem_bw_reg;
    assign mem_din = mem_din_reg;
    assign mem_read = mem_read_reg;
    assign mem_rd_adr = mem_rd_adr_reg;
  end else begin: nflpc_loop
    assign mem_write = mem_write_tmp;
    assign mem_wr_adr = mem_wr_adr_tmp;
    assign mem_bw = mem_bw_tmp;
    assign mem_din = mem_din_tmp;
    assign mem_read = mem_read_tmp;
    assign mem_rd_adr = mem_rd_adr_tmp;
  end
  endgenerate

/*
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
*/

  reg [BITWBNK-1:0] rd_wadr_reg [0:NUMRDPT-1][0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg [BITWROW-1:0] rd_radr_reg [0:NUMRDPT-1][0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg               rd_fwd_reg [0:NUMRDPT-1][0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg [WIDTH-1:0]   rd_msk_reg [0:NUMRDPT-1][0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  reg [WIDTH-1:0]   rd_dat_reg [0:NUMRDPT-1][0:SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  integer rd_int, rpt_int;
  always @(posedge clk)
    for (rpt_int=0; rpt_int<NUMRDPT; rpt_int=rpt_int+1)
      for (rd_int=0; rd_int<SRAM_DELAY+FLOPCMD+FLOPMEM; rd_int=rd_int+1)
        if (rd_int>0) begin
          rd_wadr_reg[rpt_int][rd_int] <= rd_wadr_reg[rpt_int][rd_int-1];
          rd_radr_reg[rpt_int][rd_int] <= rd_radr_reg[rpt_int][rd_int-1];
          rd_fwd_reg[rpt_int][rd_int] <= rd_fwd_reg[rpt_int][rd_int-1];
          rd_msk_reg[rpt_int][rd_int] <= rd_msk_reg[rpt_int][rd_int-1];
          rd_dat_reg[rpt_int][rd_int] <= rd_dat_reg[rpt_int][rd_int-1];
        end else begin
          rd_wadr_reg[rpt_int][rd_int] <= rd_wadr[rpt_int];
	  rd_radr_reg[rpt_int][rd_int] <= rd_radr[rpt_int];
          rd_fwd_reg[rpt_int][rd_int] <= forward_read[rpt_int];
          rd_msk_reg[rpt_int][rd_int] <= forward_mask[rpt_int];
          rd_dat_reg[rpt_int][rd_int] <= forward_data[rpt_int];
        end

  wire [NUMRDPT*NUMWBNK*WIDTH-1:0] mem_rd_dout_tmp;
  generate if (FLOPMEM) begin: flpm_loop
    reg [NUMRDPT*NUMWBNK*WIDTH-1:0] mem_rd_dout_reg;
    always @(posedge clk) 
      mem_rd_dout_reg <= mem_rd_dout;

    assign mem_rd_dout_tmp = mem_rd_dout_reg;
  end else begin: noflpm_loop
    assign mem_rd_dout_tmp = mem_rd_dout;
  end
  endgenerate

  reg [WIDTH-1:0] rd_dout_wire [0:NUMRDPT-1];
  integer dout_int;
  always_comb
    for (dout_int=0; dout_int<NUMRDPT; dout_int=dout_int+1) begin
      rd_dout_wire[dout_int] = mem_rd_dout_tmp >> ((rd_wadr_reg[dout_int][SRAM_DELAY+FLOPCMD*FLOPMEM-1]*NUMRDPT+dout_int)*WIDTH);
    end

  wire [WIDTH-1:0] rd_dout_tmp [0:NUMRDPT-1];
  wire rd_fwrd_tmp [0:NUMRDPT-1];
  wire rd_serr_tmp [0:NUMRDPT-1];
  wire rd_derr_tmp [0:NUMRDPT-1];
  wire [BITPADR-1:0] rd_padr_tmp [0:NUMRDPT-1];
  genvar rtmp_int;
  generate for (rtmp_int=0; rtmp_int<NUMRDPT; rtmp_int=rtmp_int+1) begin: rdc_loop
    assign rd_dout_tmp[rtmp_int] = (ENAPSDO && rd_fwd_reg[rtmp_int][SRAM_DELAY+FLOPCMD+FLOPMEM-1]) ?
                                   (rd_dat_reg[rtmp_int][SRAM_DELAY+FLOPCMD+FLOPMEM-1] & rd_msk_reg[rtmp_int][SRAM_DELAY+FLOPCMD+FLOPMEM-1]) |
                                   (rd_dout_wire[rtmp_int] & ~rd_msk_reg[rtmp_int][SRAM_DELAY+FLOPCMD+FLOPMEM-1]) : rd_dout_wire[rtmp_int];
    assign rd_fwrd_tmp[rtmp_int] = (ENAPSDO && rd_fwd_reg[rtmp_int][SRAM_DELAY+FLOPCMD+FLOPMEM-1]);
    assign rd_serr_tmp[rtmp_int] = 1'b0;
    assign rd_derr_tmp[rtmp_int] = 1'b0;
    assign rd_padr_tmp[rtmp_int] = (NUMWBNK>1) ? {rd_wadr_reg[rtmp_int][SRAM_DELAY+FLOPCMD+FLOPMEM-1],rd_radr_reg[rtmp_int][SRAM_DELAY+FLOPCMD+FLOPMEM-1]} :
                                                 rd_radr_reg[rtmp_int][SRAM_DELAY+FLOPCMD+FLOPMEM-1];
  end
  endgenerate

  reg [NUMRDPT*WIDTH-1:0] rd_dout_help;
  reg [NUMRDPT-1:0] rd_fwrd_help;
  reg [NUMRDPT-1:0] rd_serr_help;
  reg [NUMRDPT-1:0] rd_derr_help;
  reg [NUMRDPT*BITPADR-1:0] rd_padr_help;
  integer rdh_int;
  always_comb begin
    rd_dout_help = 0;
    rd_fwrd_help = 0;
    rd_serr_help = 0;
    rd_derr_help = 0;
    rd_padr_help = 0;
    for (rdh_int=0; rdh_int<NUMRDPT; rdh_int=rdh_int+1) begin
      rd_dout_help = rd_dout_help | (rd_dout_tmp[rdh_int] << (rdh_int*WIDTH));
      rd_fwrd_help = rd_fwrd_help | (rd_fwrd_tmp[rdh_int] << rdh_int);
      rd_serr_help = rd_serr_help | (rd_serr_tmp[rdh_int] << rdh_int);
      rd_derr_help = rd_derr_help | (rd_derr_tmp[rdh_int] << rdh_int);
      rd_padr_help = rd_padr_help | (rd_padr_tmp[rdh_int] << (rdh_int*BITPADR));
    end
  end

  generate if (FLOPOUT) begin: flpo_loop
    reg [NUMRDPT*WIDTH-1:0] rd_dout_reg;
    reg [NUMRDPT-1:0] rd_fwrd_reg;
    reg [NUMRDPT-1:0] rd_serr_reg;
    reg [NUMRDPT-1:0] rd_derr_reg;
    reg [NUMRDPT*BITPADR-1:0] rd_padr_reg;
    always @(posedge clk) begin
      rd_dout_reg <= rd_dout_help;
      rd_fwrd_reg <= rd_fwrd_help;
      rd_serr_reg <= rd_serr_help;
      rd_derr_reg <= rd_derr_help;
      rd_padr_reg <= rd_padr_help;
    end
    assign rd_dout = rd_dout_reg;
    assign rd_fwrd = rd_fwrd_reg;
    assign rd_serr = rd_serr_reg;
    assign rd_derr = rd_derr_reg;
    assign rd_padr = rd_padr_reg;
  end else begin: noflpo_loop
    assign rd_dout = rd_dout_help;
    assign rd_fwrd = rd_fwrd_help;
    assign rd_serr = rd_serr_help;
    assign rd_derr = rd_derr_help;
    assign rd_padr = rd_padr_help;
  end
  endgenerate

endmodule
