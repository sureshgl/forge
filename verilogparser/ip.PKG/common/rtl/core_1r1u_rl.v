
module core_1r1u_rl (vwrite, vdin,
                     vread, vrdaddr, vread_vld, vdout, vread_fwrd, vread_serr, vread_derr, vread_padr,
                     t1_readA, t1_writeA, t1_addrA, t1_dinA, t1_doutA, t1_fwrdA, t1_serrA, t1_derrA, t1_padrA,
                     t2_writeA, t2_addrA, t2_dinA, t2_readB, t2_addrB, t2_doutB, t2_fwrdB, t2_serrB, t2_derrB, t2_padrB,
                     t3_writeA, t3_addrA, t3_dinA, t3_readB, t3_addrB, t3_doutB, t3_fwrdB, t3_serrB, t3_derrB, t3_padrB,
                     ready, clk, rst);

  parameter WIDTH = 32;
  parameter NUMADDR = 8192;
  parameter BITADDR = 13;
  parameter NUMVROW = 1024;
  parameter BITVROW = 10;
  parameter NUMVBNK = 8;
  parameter BITVBNK = 3;
  parameter BITPBNK = 4;
  parameter BITPADR = 14;
  parameter SRAM_DELAY = 2;
  parameter FLOPIN = 0;
  parameter FLOPOUT = 0;

  parameter SDOUT_WIDTH = BITVBNK+1;
  
  input                              vwrite;
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

  output t2_writeA;
  output [BITVROW-1:0] t2_addrA;
  output [WIDTH-1:0] t2_dinA;

  output t2_readB;
  output [BITVROW-1:0] t2_addrB;
  input [WIDTH-1:0] t2_doutB;
  input t2_fwrdB;
  input t2_serrB;
  input t2_derrB;
  input [BITVROW-1:0] t2_padrB;

  output t3_writeA;
  output [BITVROW-1:0] t3_addrA;
  output [SDOUT_WIDTH-1:0] t3_dinA;

  output t3_readB;
  output [BITVROW-1:0] t3_addrB;
  input [SDOUT_WIDTH-1:0] t3_doutB;
  input t3_fwrdB;
  input t3_serrB;
  input t3_derrB;
  input [BITVROW-1:0] t3_padrB;

  output                             ready;
  input                              clk;
  input                              rst;

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

  wire ready_wire;
  wire vread_wire;
  wire [BITADDR-1:0] vrdaddr_wire;
  wire [BITVBNK-1:0] vrdbadr_wire;
  wire [BITVROW-1:0] vrdradr_wire;
  wire vwrite_wire;
  wire [WIDTH-1:0] vdin_wire;

  genvar np2_var;
  generate if (FLOPIN) begin: flpi_loop
    reg ready_reg;
    reg vread_reg;
    reg [BITADDR-1:0] vrdaddr_reg;
    reg vwrite_reg;
    reg [WIDTH-1:0] vdin_reg;
    always @(posedge clk) begin
      ready_reg <= ready;
      vread_reg <= vread && ready;
      vrdaddr_reg <= vrdaddr;
      vwrite_reg <= vwrite && ready;
      vdin_reg <= vdin;
    end

    assign ready_wire = ready_reg;
    assign vread_wire = vread_reg;
    assign vrdaddr_wire = vrdaddr_reg;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire), .vradr(vrdradr_wire), .vaddr(vrdaddr_wire));

    assign vwrite_wire = vwrite_reg;
    assign vdin_wire = vdin_reg;
  end else begin: noflpi_loop
    assign ready_wire = ready;
    assign vread_wire = vread && ready;
    assign vrdaddr_wire = vrdaddr;
    np2_addr #(.NUMADDR (NUMADDR), .BITADDR (BITADDR),
               .NUMVBNK (NUMVBNK), .BITVBNK (BITVBNK),
               .NUMVROW (NUMVROW), .BITVROW (BITVROW))
        rd_adr_inst (.vbadr(vrdbadr_wire), .vradr(vrdradr_wire), .vaddr(vrdaddr_wire));

    assign vwrite_wire = vwrite && ready;
    assign vdin_wire = vdin;
  end
  endgenerate

  reg                vread_reg [0:SRAM_DELAY-1];
  reg [BITADDR-1:0]  vrdaddr_reg [0:SRAM_DELAY-1];
  reg [BITVBNK-1:0]  vrdbadr_reg [0:SRAM_DELAY-1];
  reg [BITVROW-1:0]  vrdradr_reg [0:SRAM_DELAY-1];
 
  integer vdel_int; 
  always @(posedge clk) begin
    for (vdel_int=0; vdel_int<SRAM_DELAY; vdel_int=vdel_int+1)
      if (vdel_int > 0) begin
        vread_reg[vdel_int] <= vread_reg[vdel_int-1];
        vrdaddr_reg[vdel_int] <= vrdaddr_reg[vdel_int-1];
        vrdbadr_reg[vdel_int] <= vrdbadr_reg[vdel_int-1];
        vrdradr_reg[vdel_int] <= vrdradr_reg[vdel_int-1];
      end else begin
        vread_reg[vdel_int] <= vread_wire;
        vrdaddr_reg[vdel_int] <= vrdaddr_wire;
        vrdbadr_reg[vdel_int] <= vrdbadr_wire;
        vrdradr_reg[vdel_int] <= vrdradr_wire;
      end
  end

  wire               vread_out = vread_reg[SRAM_DELAY-1];
  wire [BITVBNK-1:0] vrdbadr_out = vrdbadr_reg[SRAM_DELAY-1];
  wire [BITVROW-1:0] vrdradr_out = vrdradr_reg[SRAM_DELAY-1];

  wire               vwrite_out = vwrite_wire && (vrdaddr_reg[SRAM_DELAY-1] < NUMADDR);
  wire [WIDTH-1:0]   vdin_out = vdin_wire;       

  reg                pwrite;
  reg [BITVBNK-1:0]  pwrbadr;
  reg [BITVROW-1:0]  pwrradr;
  reg [WIDTH-1:0]    pdin;
  wire               pread;
  wire [BITVBNK-1:0] prdbadr;
  wire [BITVROW-1:0] prdradr;

  reg                swrite;
  reg [BITVROW-1:0]  swrradr;
  reg [BITVBNK:0]    sdin;
  wire               sread;
  wire [BITVROW-1:0] srdradr;

  reg                cwrite;
  reg [BITVROW-1:0]  cwrradr;
  reg [WIDTH-1:0]    cdin;
  wire               cread;
  wire [BITVROW-1:0] crdradr;

  assign pread = vread_wire;
  assign prdbadr = vrdbadr_wire;
  assign prdradr = vrdradr_wire;

  assign sread = vread_wire/* && (!swrite || (swrradr != srdradr))*/;
  assign srdradr = vrdradr_wire;

  assign cread = vread_wire/* && (!cwrite || (cwrradr != crdradr))*/;
  assign crdradr = vrdradr_wire;

  reg               rdmap_vld [0:SRAM_DELAY-1];
  reg [BITVBNK:0]   rdmap_reg [0:SRAM_DELAY-1];
  integer rmap_int;    
  always @(posedge clk) begin
    for (rmap_int=0; rmap_int<SRAM_DELAY; rmap_int=rmap_int+1)
      if (rmap_int > 0) begin
        if (swrite && (swrradr == vrdradr_reg[rmap_int-1])) begin
          rdmap_vld[rmap_int] <= 1'b1;
          rdmap_reg[rmap_int] <= sdin[BITVBNK:0];
        end else begin
          rdmap_vld[rmap_int] <= rdmap_vld[rmap_int-1];
          rdmap_reg[rmap_int] <= rdmap_reg[rmap_int-1];            
        end
      end else begin
        rdmap_vld[rmap_int] <= swrite && (swrradr == vrdradr_wire);
        rdmap_reg[rmap_int] <= sdin[BITVBNK:0];
      end
  end

  reg               rcdat_vld [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]   rcdat_reg [0:SRAM_DELAY-1];
  integer rdat_int;    
  always @(posedge clk) begin
    for (rdat_int=0; rdat_int<SRAM_DELAY; rdat_int=rdat_int+1)
      if (rdat_int > 0) begin
        if (cwrite && (cwrradr == vrdradr_reg[rdat_int-1])) begin
          rcdat_vld[rdat_int] <= 1'b1;
          rcdat_reg[rdat_int] <= cdin;
        end else begin
          rcdat_vld[rdat_int] <= rcdat_vld[rdat_int-1];
          rcdat_reg[rdat_int] <= rcdat_reg[rdat_int-1];            
        end
      end else begin
        rcdat_vld[rdat_int] <= cwrite && (cwrradr == vrdradr_wire);
        rcdat_reg[rdat_int] <= cdin;
      end
  end

  reg             rddat_vld [0:SRAM_DELAY-1];
  reg [WIDTH-1:0] rddat_reg [0:SRAM_DELAY-1];
  integer rfwd_int;
  always @(posedge clk) begin
    for (rfwd_int=0; rfwd_int<SRAM_DELAY; rfwd_int=rfwd_int+1)
      if (rfwd_int > 0) begin
        if (vwrite_out && vread_reg[rfwd_int-1] && (vrdbadr_out == vrdbadr_reg[rfwd_int-1]) && (vrdradr_out == vrdradr_reg[rfwd_int-1])) begin
          rddat_vld[rfwd_int] <= 1'b1;
          rddat_reg[rfwd_int] <= vdin_out;
        end else begin
          rddat_vld[rfwd_int] <= rddat_vld[rfwd_int-1];
          rddat_reg[rfwd_int] <= rddat_reg[rfwd_int-1];
        end
      end else begin
        if (vwrite_out && vread_wire && (vrdbadr_out == vrdbadr_wire) && (vrdradr_out == vrdradr_wire)) begin
          rddat_vld[rfwd_int] <= 1'b1;
          rddat_reg[rfwd_int] <= vdin_out;
        end else begin
          rddat_vld[rfwd_int] <= 1'b0;
          rddat_reg[rfwd_int] <= 0;
        end
      end
  end

  reg              rpdat_vld [0:SRAM_DELAY-1];
  reg [WIDTH-1:0]  rpdat_reg [0:SRAM_DELAY-1];
  integer pfwd_int;
  always @(posedge clk) 
    for (pfwd_int=0; pfwd_int<SRAM_DELAY; pfwd_int=pfwd_int+1)
      if (pfwd_int > 0) begin
        if (pwrite && (pwrbadr == vrdbadr_reg[pfwd_int-1]) && (pwrradr == vrdradr_reg[pfwd_int-1])) begin
          rpdat_vld[pfwd_int] <= 1'b1;
          rpdat_reg[pfwd_int] <= pdin;
        end else begin
          rpdat_vld[pfwd_int] <= rpdat_vld[pfwd_int-1];
          rpdat_reg[pfwd_int] <= rpdat_reg[pfwd_int-1];
        end
      end else begin
        if (pwrite && (pwrbadr == vrdbadr_wire) && (pwrradr == vrdradr_wire)) begin
          rpdat_vld[pfwd_int] <= 1'b1;
          rpdat_reg[pfwd_int] <= pdin;
        end else begin
          rpdat_vld[pfwd_int] <= 1'b0;
          rpdat_reg[pfwd_int] <= 0;
        end
      end

  wire [WIDTH-1:0]           pdout = t1_doutA >> (vrdbadr_out*WIDTH);
  wire                       pdout_fwrd = t1_fwrdA >> vrdbadr_out;
  wire                       pdout_serr = t1_serrA >> vrdbadr_out;
  wire                       pdout_derr = t1_derrA >> vrdbadr_out;
  wire [BITPADR-BITPBNK-1:0] pdout_padr = t1_padrA >> (vrdbadr_out*(BITPADR-BITPBNK));

  wire [WIDTH-1:0]           cdout = t2_doutB;
  wire                       cdout_fwrd = t2_fwrdB;
  wire                       cdout_serr = t2_serrB;
  wire                       cdout_derr = t2_derrB;
  wire [BITVROW-1:0]         cdout_padr = t2_padrB;

  wire [WIDTH-1:0]           sdout = t3_doutB;
  wire                       sdout_fwrd = t3_fwrdB;
  wire                       sdout_serr = t3_serrB;
  wire                       sdout_derr = t3_derrB;
  wire [BITVROW-1:0]         sdout_padr = t3_padrB;

  wire [BITVBNK:0]   rdmap_out = sdout;
  wire [WIDTH-1:0]   rcdat_out = cdout;
  wire [WIDTH-1:0]   rpdat_out = pdout;

  wire               vread_vld_tmp = vread_out;
  wire [WIDTH-1:0]   vdout_tmp = (rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ? rcdat_out : rpdat_out;
  wire               vread_fwrd_tmp = (rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ? cdout_fwrd : pdout_fwrd;
  wire               vread_serr_tmp = (rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ? cdout_serr : pdout_serr;
  wire               vread_derr_tmp = (rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ? cdout_derr : pdout_derr;
  wire [BITPADR-1:0] vread_padr_tmp = (rdmap_out[BITVBNK] && (rdmap_out[BITVBNK-1:0] == vrdbadr_out)) ? {NUMVBNK,cdout_padr} : {vrdbadr_out,pdout_padr};

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

  wire [BITVBNK:0]   wrmap_out = rdmap_vld[SRAM_DELAY-1] ? rdmap_reg[SRAM_DELAY-1] : sdout;
  wire [WIDTH-1:0]   wcdat_out = rcdat_vld[SRAM_DELAY-1] ? rcdat_reg[SRAM_DELAY-1] : cdout;

  wire               sold_vld = wrmap_out[BITVBNK];
  wire [BITVBNK-1:0] sold_map = wrmap_out[BITVBNK-1:0];
  wire [BITVROW-1:0] sold_row = vrdradr_out;
  wire [WIDTH-1:0]   sold_dat = wcdat_out;
  wire               snew_vld = vwrite_out;
  wire [BITVBNK-1:0] snew_map = vrdbadr_out;
  wire [BITVROW-1:0] snew_row = vrdradr_out;
  wire [WIDTH-1:0]   snew_dat = vdin_out;

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

  always_comb
    if (rstvld) begin
      swrite = !rst;
      swrradr = rstaddr;
      sdin = 0;
    end else if (new_to_cache) begin
      swrite = 1'b1;
      swrradr = snew_row;
      sdin = {1'b1,snew_map};
    end else if (old_to_clear) begin
      swrite = 1'b1;
      swrradr = sold_row;
      sdin = 0;
    end else begin
      swrite = 1'b0;
      swrradr = 0; 
      sdin = 0;
    end

  always_comb
    if (rstvld) begin
      cwrite = !rst;
      cwrradr = rstaddr;
      cdin = 0;
    end else if (new_to_cache) begin
      cwrite = 1'b1;
      cwrradr = snew_row;
      cdin = snew_dat;
    end else begin
      cwrite = 1'b0;
      cwrradr = 0; 
      cdin = 0;
    end

  reg [NUMVBNK-1:0] t1_readA;
  reg [NUMVBNK-1:0] t1_writeA;
  reg [NUMVBNK*BITVROW-1:0] t1_addrA;
  reg [NUMVBNK*WIDTH-1:0] t1_dinA;
  always_comb begin
    t1_readA = 0;
    t1_writeA = 0;
    t1_addrA = 0;
    t1_dinA = 0;
    if (pwrite) begin
      t1_writeA = t1_writeA | (1'b1 << pwrbadr);
      t1_addrA = t1_addrA | (pwrradr << (pwrbadr*BITVROW));
      t1_dinA = t1_dinA | (pdin << (pwrbadr*WIDTH));
    end
    if (pread) begin
      t1_readA = t1_readA | (1'b1 << prdbadr);
      t1_addrA = t1_addrA | (prdradr << (prdbadr*BITVROW));
    end
  end

  assign t2_writeA = cwrite;
  assign t2_addrA = cwrradr;
  assign t2_dinA = cdin;
  assign t2_readB = cread; 
  assign t2_addrB = crdradr; 

  assign t3_writeA = swrite;
  assign t3_addrA = swrradr;
  assign t3_dinA = sdin;
  assign t3_readB = sread; 
  assign t3_addrB = srdradr; 

endmodule


