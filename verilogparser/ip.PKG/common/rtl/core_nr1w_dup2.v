module core_nr1w_dup2 (vwrite, vwraddr, vbw, vdin, vread, vrdaddr, vread_vld, vdout, flopout_en,
                       t1_writeA, t1_addrA, t1_bwA, t1_dinA, t1_readB, t1_addrB, t1_doutB,
	                   clk, rst);
 
  parameter WIDTH = 32;
  parameter BITWDTH = 5;
  parameter NUMRDPT = 2;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;

  parameter SRAM_DELAY  = 2;
  parameter LSRAM_DELAY = SRAM_DELAY>0 ? SRAM_DELAY : 1;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;
  parameter FLOPWTH = 1;
  input                                vwrite;
  input [BITADDR-1:0]                  vwraddr;
  input [WIDTH-1:0]                    vbw;
  input [WIDTH-1:0]                    vdin;
  
  input [NUMRDPT-1:0]                  vread;
  input [NUMRDPT*BITADDR-1:0]          vrdaddr;
  output [NUMRDPT-1:0]                 vread_vld;
  output [NUMRDPT*WIDTH-1:0]           vdout;

  input [FLOPWTH-1:0]                  flopout_en;

  output [NUMRDPT*NUMVBNK-1:0]         t1_writeA;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  output [NUMRDPT*NUMVBNK*WIDTH-1:0]   t1_bwA;
  output [NUMRDPT*NUMVBNK*WIDTH-1:0]   t1_dinA;
  output [NUMRDPT*NUMVBNK-1:0]         t1_readB;
  output [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  input [NUMRDPT*NUMVBNK*WIDTH-1:0]    t1_doutB;

  input                                clk;
  input                                rst;


  wire vread_wire [0:NUMRDPT-1];
  wire [BITADDR-1:0] vrdaddr_wire [0:NUMRDPT-1];
  wire [BITVBNK-1:0] vrdbadr_wire [0:NUMRDPT-1];
  wire [BITVROW-1:0] vrdradr_wire [0:NUMRDPT-1];
  wire vwrite_wire;
  wire [BITADDR-1:0] vwraddr_wire;
  wire [BITVBNK-1:0] vwrbadr_wire;
  wire [BITVROW-1:0] vwrradr_wire;
  wire [WIDTH-1:0] vbw_wire;
  wire [WIDTH-1:0] vdin_wire;

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg [NUMRDPT-1:0] vread_reg;
    reg [NUMRDPT*BITADDR-1:0] vrdaddr_reg;
    reg vwrite_reg;
    reg [BITADDR-1:0] vwraddr_reg;
    reg [WIDTH-1:0] vbw_reg;
    reg [WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      vread_reg <= vread;
      vrdaddr_reg <= vrdaddr;
      vwrite_reg <= vwrite;
      vwraddr_reg <= vwraddr;
      vbw_reg <= vbw;
      vdin_reg <= vdin;
    end

    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread_reg >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr_reg >> (np2_var*BITADDR);
      if(BITVBNK <= 0) begin : one_bnk
        //wire vbadr_wire_temp = 0;
        //always_comb begin
          assign vrdbadr_wire[np2_var] = 0;
          assign vrdradr_wire[np2_var] = vrdaddr_wire[np2_var];
        //end
      end else begin
        np2_addr_ramwrap #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                   .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                   .NUMVROW (NUMVROW), .BITVROW (BITVROW))
          rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
      end //one_bnk  To remove empty modules
    end

    assign vwraddr_wire = vwraddr_reg;
    assign vwrite_wire = vwrite_reg;
    assign vbw_wire = vbw_reg;
    assign vdin_wire = vdin_reg;
     if(BITVBNK <= 0) begin : one_bnk
       //wire vwrbadr_wire_temp = 0;
       //always_comb begin
         assign vwrbadr_wire = 0;
         assign vwrradr_wire = vwraddr_wire;
       //end
     end else begin
       np2_addr_ramwrap #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire), .vradr(vwrradr_wire), .vaddr(vwraddr_wire));
    end
  end else begin: noflpi_loop
    for (np2_var=0; np2_var<NUMRDPT; np2_var=np2_var+1) begin: rd_loop
      assign vread_wire[np2_var] = vread >> np2_var;
      assign vrdaddr_wire[np2_var] = vrdaddr >> (np2_var*BITADDR);
      if(BITVBNK <= 0) begin : one_bnk
        //wire vrdbadr_wire_temp = 0;
        //always_comb begin
          assign vrdbadr_wire[np2_var] = 0;
          assign vrdradr_wire[np2_var] = vrdaddr_wire[np2_var];
       //end
      end else begin
        np2_addr_ramwrap #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                   .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                   .NUMVROW (NUMVROW), .BITVROW (BITVROW))
          rd_adr_inst (.vbadr(vrdbadr_wire[np2_var]), .vradr(vrdradr_wire[np2_var]), .vaddr(vrdaddr_wire[np2_var]));
      end
    end 

    assign vwrite_wire = vwrite;
    assign vwraddr_wire = vwraddr;
    assign vbw_wire = vbw;
    assign vdin_wire = vdin;
    if(BITVBNK <= 0) begin : one_bnk
      //wire vwrbadr_wire_temp = 0;
      //always_comb begin
        assign vwrbadr_wire = 0;
        assign vwrradr_wire = vwraddr_wire;
      //end
    end else begin
      np2_addr_ramwrap #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
                 .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
                 .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        wr_adr_inst (.vbadr(vwrbadr_wire), .vradr(vwrradr_wire), .vaddr(vwraddr_wire));
    end
  end
  endgenerate

  reg                vread_reg [0:NUMRDPT-1][0:LSRAM_DELAY-1];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:NUMRDPT-1][0:LSRAM_DELAY-1];
  generate if (SRAM_DELAY>0) begin : sr_nz
    integer vreg_int, vrpt_int;
    always @(posedge clk)
    for (vreg_int=0; vreg_int<SRAM_DELAY; vreg_int=vreg_int+1) 
      if (vreg_int>0) begin
        for (vrpt_int=0; vrpt_int<NUMRDPT; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_reg[vrpt_int][vreg_int-1];
          vrdbadr_reg[vrpt_int][vreg_int] <= vrdbadr_reg[vrpt_int][vreg_int-1];
        end
      end else begin
        for (vrpt_int=0; vrpt_int<NUMRDPT; vrpt_int=vrpt_int+1) begin 
          vread_reg[vrpt_int][vreg_int] <= vread_wire[vrpt_int];
          vrdbadr_reg[vrpt_int][vreg_int] <= vrdbadr_wire[vrpt_int];
        end
      end
  end else begin
    integer vrpt_int;
    always_comb 
      for (vrpt_int=0; vrpt_int<NUMRDPT; vrpt_int=vrpt_int+1) begin 
        vread_reg[vrpt_int][0]  = vread_wire[vrpt_int];
        vrdbadr_reg[vrpt_int][0] = vrdbadr_wire[vrpt_int];
      end
  end
  endgenerate

  reg                vread_out [0:NUMRDPT-1];
  reg [BITVBNK-1:0]  vrdbadr_out [0:NUMRDPT-1];
  integer vdel_int;
  always_comb begin
    for (vdel_int=0; vdel_int<NUMRDPT; vdel_int=vdel_int+1) begin
      vread_out[vdel_int] = vread_reg[vdel_int][LSRAM_DELAY-1];
      vrdbadr_out[vdel_int] = vrdbadr_reg[vdel_int][LSRAM_DELAY-1];
    end
  end

  reg [NUMRDPT*NUMVBNK-1:0] t1_writeA;
  reg [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrA;
  reg [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_bwA;
  reg [NUMRDPT*NUMVBNK*WIDTH-1:0] t1_dinA;
  reg [NUMRDPT*NUMVBNK-1:0] t1_readB;
  reg [NUMRDPT*NUMVBNK*BITVROW-1:0] t1_addrB;
  integer prp_int, prb_int;
  always_comb begin
    t1_writeA = 0;
    t1_addrA = 0;
    t1_bwA = 0;
    t1_dinA = 0;
    for (prp_int=0; prp_int<NUMRDPT; prp_int=prp_int+1)
      for (prb_int=0; prb_int<NUMVBNK; prb_int=prb_int+1) begin
        if (vwrite_wire)
          t1_writeA = t1_writeA | (1'b1 << (prp_int*NUMVBNK+vwrbadr_wire)); 
        t1_addrA = t1_addrA | (vwrradr_wire << ((prp_int*NUMVBNK+prb_int)*BITVROW));
        t1_bwA = t1_bwA | (vbw_wire << ((prp_int*NUMVBNK+prb_int)*WIDTH));
        t1_dinA = t1_dinA | (vdin_wire << ((prp_int*NUMVBNK+prb_int)*WIDTH));
      end
    t1_readB = 0;
    t1_addrB = 0;
    for (prp_int=0; prp_int<NUMRDPT; prp_int=prp_int+1)
      for (prb_int=0; prb_int<NUMVBNK; prb_int=prb_int+1) begin
        if (vread_wire[prp_int])
          t1_readB = t1_readB | (1'b1 << (prp_int*NUMVBNK+prb_int)); 
        t1_addrB = t1_addrB | (vrdradr_wire[prp_int] << ((prp_int*NUMVBNK+prb_int)*BITVROW));
      end
  end

  reg               vread_vld_wire [0:NUMRDPT-1];
  reg [WIDTH-1:0]   vdout_wire [0:NUMRDPT-1];
  integer vrd_int;
  always_comb 
    for (vrd_int=0; vrd_int<NUMRDPT; vrd_int=vrd_int+1) begin
      vread_vld_wire[vrd_int] = vread_out[vrd_int];
      vdout_wire[vrd_int] = t1_doutB >> ((NUMVBNK*vrd_int+vrdbadr_out[vrd_int])*WIDTH);
    end

  reg [NUMRDPT-1:0]         vread_vld_tmp [0:FLOPOUT];
  reg [NUMRDPT*WIDTH-1:0]   vdout_tmp [0:FLOPOUT];

  genvar vrd_var;
  generate for (vrd_var=0; vrd_var<=FLOPOUT; vrd_var=vrd_var+1) begin: vrd_loop
    if (vrd_var>0) begin: flp_loop
      always @(posedge clk) begin
        vread_vld_tmp[vrd_var] <= vread_vld_tmp[vrd_var-1];
        vdout_tmp[vrd_var] <= vdout_tmp[vrd_var-1];
      end
    end else begin: nflp_loop
      integer vwire_int;
      always_comb begin
        vread_vld_tmp[vrd_var] = 0;
        vdout_tmp[vrd_var] = 0;
        for (vwire_int=0; vwire_int<NUMRDPT; vwire_int=vwire_int+1) begin
          vread_vld_tmp[vrd_var] = vread_vld_tmp[vrd_var] | (vread_vld_wire[vwire_int] << vwire_int);
          vdout_tmp[vrd_var] = vdout_tmp[vrd_var] | (vdout_wire[vwire_int] << (vwire_int*WIDTH));
        end
      end
    end
  end
  endgenerate

  assign vread_vld = (flopout_en[0]) ? vread_vld_tmp[0] : vread_vld_tmp[FLOPOUT];
  assign vdout = (flopout_en[0]) ? vdout_tmp[0] : vdout_tmp[FLOPOUT];

endmodule // core_nr1w_dup2



