module test_driver_l2_a2_cache;

parameter  NUMADDR = 294967296;
parameter  BITADDR = 32;
parameter  NUMBYLN = 32; // line size
parameter  BITBYLN = $clog2(NUMBYLN);
parameter  NUMWAYS = 8;
parameter  BITWAYS = $clog2(NUMWAYS);
parameter  NUMINDX = 128;
parameter  BITINDX = 7;
parameter  NUMSEQN = 16;
parameter  BITSEQN = 4; 
parameter  BITTAGS = BITADDR-BITINDX-BITBYLN;
parameter  MEMDELY = 2;
parameter  FIFOCNT = 8;
parameter  BITFIFO = 3;
parameter  NUMBTLN = 2; // num beats per line
parameter  XBITATR = 3;
parameter  BITDATA = 256;

localparam LBTWAYS = BITWAYS>0 ? BITWAYS : 1;
localparam LBTLRUU = BITWAYS>0 ? BITWAYS : 1;
localparam BITVALD = 1;
localparam BITDRTY = 1;

localparam BITTAGM = NUMWAYS*(BITTAGS+BITVALD+BITDRTY+LBTLRUU);
localparam BITDATM = NUMWAYS*BITDATA;



parameter TB_HALF_CLK_PER = 1000;
parameter TB_HALF_LCLK_PER = 1500;

parameter REFRESH_M_IN_N_N_HF = 0;
parameter REFRESH_M_IN_N_N = 15;
parameter REFRESH_M_IN_N_M = 1;

parameter TB_VPD_DUMP_FILE = "dump.vpd";

parameter REFRESH = (REFRESH_M_IN_N_N > 0) ? 1 : 0;

parameter NOMSTP = 1;
parameter NOSLVP = 1;


wire                       clk;
wire                       lclk;
wire                       rst;
wire                       ready;
wire                       refr;

wire                 ureq_rd;
wire                 ureq_wr;
wire                 ureq_inv;
wire [BITSEQN-1:0]   ureq_seq;
wire [BITADDR-1:0]   ureq_addr;
wire [BITDATA-1:0]   ureq_din;
wire [NUMBYLN-1:0]   ureq_be;
wire                 ureq_stall;

wire                 ursp_rd;
wire                 ursp_wr;
wire                 ursp_inv;
wire [BITSEQN-1:0]   ursp_seq;
wire [BITDATA-1:0]   ursp_dout;
wire [XBITATR-1:0]   ursp_attr;
wire                 ursp_stall;
  
wire                 ord_vld; 
wire [BITSEQN-1:0]   ord_seq;
wire [BITSEQN-1:0]   ord_osq;

wire                 dreq_rd;
wire                 dreq_wr;
wire [BITSEQN-1:0]   dreq_seq;
wire [BITADDR-1:0]   dreq_addr;
wire [BITDATA-1:0]   dreq_din;
wire                 dreq_stall;

wire                 drsp_vld;
wire [BITSEQN-1:0]   drsp_seq;
wire [BITDATA-1:0]   drsp_dout;
wire [XBITATR-1:0]   drsp_attr;
wire                 drsp_stall;

wire                 t1_we_w0;
wire [BITINDX-1:0]   t1_a_w0;
wire [BITTAGM-1:0]   t1_din_w0;
wire                 t1_re_r0;
wire [BITINDX-1:0]   t1_a_r0;
wire [BITTAGM-1:0]   t1_dout_r0;

wire                 t2_we_w0;
wire [BITINDX-1:0]   t2_a_w0;
wire [BITDATM-1:0]   t2_din_w0;
wire                 t2_re_r0;
wire [BITINDX-1:0]   t2_a_r0;
wire [BITDATM-1:0]   t2_dout_r0;

wire e_cch_whit;
wire e_cch_rhit;
wire e_cch_ihit;
wire e_pf_empty;
wire e_pf_full;
wire e_pf_oflw;
wire t1_uerr_r0;
wire t2_uerr_r0;

assign t1_uerr_r0 = 0;
assign t2_uerr_r0 = 0;

    L2_M_Ifc#(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) mL2Ifc[NOMSTP] (clk);


    assign ureq_rd            = mL2Ifc[0].reqRd;
    assign ureq_wr            = mL2Ifc[0].reqWr;
    assign ureq_inv           = mL2Ifc[0].reqInv;
    assign ureq_seq           = mL2Ifc[0].reqSeq;
    assign ureq_addr          = mL2Ifc[0].reqAddr;
    assign ureq_din           = mL2Ifc[0].reqDin;
    assign ureq_be            = mL2Ifc[0].reqByteEn;
    assign ursp_stall         = mL2Ifc[0].rspStall;

    always@(*) begin
          mL2Ifc[0].reqStall    = ureq_stall;
   	  mL2Ifc[0].rspRd       = ursp_rd;
   	  mL2Ifc[0].rspWr       = ursp_wr;
   	  mL2Ifc[0].rspInv      = ursp_inv;    
   	  mL2Ifc[0].rspSeq      = ursp_seq;       
   	  mL2Ifc[0].rspDout     = ursp_dout;     
   	  mL2Ifc[0].rspAttr     = ursp_attr;     
     end




    L2_S_Ifc#(BITADDR,BITDATA,BITSEQN,NUMBYLN,XBITATR) sL2Ifc[NOSLVP] (clk);



    assign drsp_vld           = sL2Ifc[0].rspVld;
    assign drsp_seq           = sL2Ifc[0].rspSeq;
    assign drsp_dout          = sL2Ifc[0].rspDout;
    assign drsp_attr          = sL2Ifc[0].rspAttr;    
    assign dreq_stall         = sL2Ifc[0].reqStall;     

    always@(*) begin
         sL2Ifc[0].reqRd       = dreq_rd;
         sL2Ifc[0].reqWr       = dreq_wr;
         sL2Ifc[0].reqSeq      = dreq_seq;
         sL2Ifc[0].reqAddr     = dreq_addr;
         sL2Ifc[0].reqDin      = dreq_din;
         sL2Ifc[0].rspStall    = drsp_stall;
     end


      wire refr_e;
    Misc_Ifc miscIfc (clk);

        assign rst = miscIfc.rst;
        assign miscIfc.ready = ready;
        assign miscIfc.refr = refr_e;


        wire NOCON_c_0;
        testbench_init     
            #(
            .TB_HALF_CLK_PER(TB_HALF_CLK_PER),
            .TB_VPD_DUMP_FILE(TB_VPD_DUMP_FILE),
            .REFRESH_M_IN_N_N(0),
            .REFRESH_M_IN_N_N_HF(0),
            .REFRESH_M_IN_N_M(1)
            )
            
         c     (.rst(rst),
            .clk(clk),
            .refr(refr),
            .refr_e(refr_e))
         ;

    
  mem_beh_1r1w #(.WORDS(NUMINDX), .AW(BITINDX), .DW(BITTAGM), .LATENCY(MEMDELY))
    tag_inst ( .clk(clk), .rst(rst), 
     .write_1(t1_we_w0), .addr_1(t1_a_w0), .din_1(t1_din_w0),.bw_1({BITTAGM{1'b1}}),
     .read_0(t1_re_r0), .addr_0(t1_a_r0), .dout_0(t1_dout_r0),.read_derr_0(),.read_serr_0());

  mem_beh_1r1w #(.WORDS(NUMINDX), .AW(BITINDX), .DW(BITDATM), .LATENCY(MEMDELY))
    dat_inst ( .clk(clk), .rst(rst),
     .write_1(t2_we_w0), .addr_1(t2_a_w0), .din_1(t2_din_w0),.bw_1({BITDATM{1'b1}}),
     .read_0(t2_re_r0), .addr_0(t2_a_r0), .dout_0(t2_dout_r0),.read_derr_0(),.read_serr_0());




     zt_des_cache_sb_1r1w #(.NUMADDR(NUMADDR),.BITADDR(BITADDR), .NUMBYLN(NUMBYLN), .NUMWAYS(NUMWAYS), .NUMINDX(NUMINDX), .BITINDX(BITINDX),.NUMSEQN(NUMSEQN),.BITSEQN(BITSEQN),.MEMDELY(MEMDELY),.BITDATA(BITDATA) ) dut (.*);


     CacheProgram
        #(
                .BITADDR(BITADDR), 
                .BITDATA(BITDATA),
		.BITSEQN(BITSEQN),
		.NUMBYLN(NUMBYLN),
		.XBITATR(XBITATR),
                .NOMSTP(NOMSTP),
                .NOSLVP(NOSLVP),
		.NUMWAYS(NUMWAYS), 
		.NUMINDX(NUMINDX) 
         ) 
     i_MeCacheProgram (miscIfc,mL2Ifc,sL2Ifc);
endmodule 
