module test_driver_l2_cache;

parameter NXADDRWIDTH = 34;
parameter NXDATAWIDTH = 256;
parameter NXIDWIDTH = 5;
parameter NXTYPEWIDTH = 3;
parameter NXSIZEWIDTH = 8;
parameter NXATTRWIDTH = 3;
parameter NUMXMPT = 1;
parameter NUMXSPT = 1;
parameter NUMWAYS = 8;
parameter NUMROWS = 2048;
parameter MEMDELY = 4;


// NAXI parameters
parameter  XBITDAT = NXDATAWIDTH;   // NAXI bus data size
parameter  XBITTYP = NXTYPEWIDTH;
parameter  XBITSIZ = NXSIZEWIDTH;
parameter  XBITATR = NXATTRWIDTH;
// upstream params
parameter  XNUMBET = 8; // data beat count
parameter  XNUMSEQ = 32;
parameter  XBITSEQ = XNUMSEQ>1 ? $clog2(XNUMSEQ) : 1;
// downstream params
parameter  YNUMBET = 2; // data beat count
parameter  YNUMSEQ = 16;
parameter  YBITSEQ = YNUMSEQ>1 ? $clog2(YNUMSEQ) : 1;

// Upstream downstream buffer params
parameter NUMUCFF = 8;                                  // upstream command FIFO size
parameter NUMUDFF = 8;                                  // upstream data FIFO size
parameter BITUDFF = (NUMUDFF>1) ? $clog2(NUMUDFF) : 1;
parameter BITUCFF = (NUMUCFF>1) ? $clog2(NUMUCFF) : 1;
parameter NUMRDFF = 64;                                 // upstream data FIFO size
parameter BITRDFF = (NUMRDFF>1) ? $clog2(NUMRDFF) : 1;
parameter URPDELY = 3;

// Cache core parameters 
parameter  BITADDR = NXADDRWIDTH;
parameter  NUMBYLN = 64;    // 32 bytes per line 
parameter  BITDATA = NUMBYLN*8;
parameter  NUMBTLN = NUMBYLN/(XBITDAT/8);   // number of beats to line MUST BE POT
parameter  NUMMXLN = XNUMBET/NUMBTLN; // max number of lines per naxi request
localparam BITMXLN = (NUMMXLN>1) ? $clog2(NUMMXLN) : 1; 
parameter  BITBYLN = $clog2(NUMBYLN);

parameter  NUMINDX = NUMROWS;
parameter  BITWAYS = $clog2(NUMWAYS);
parameter  BITINDX = $clog2(NUMROWS);
parameter  BITTAGS = BITADDR-BITINDX-BITBYLN;
localparam BITVALD = 1;
localparam BITDRTY = 1;

localparam LBTWAYS = BITWAYS>0 ? BITWAYS : 1;
localparam LBTLRUU = BITWAYS>0 ? BITWAYS : 1;

localparam BITTAGM = NUMWAYS*(BITTAGS+BITVALD+BITDRTY+LBTLRUU);
localparam BITDATM = NUMWAYS*BITDATA;




parameter TB_HALF_CLK_PER = 1000;
parameter TB_HALF_LCLK_PER = 1500;

parameter REFRESH_M_IN_N_N_HF = 0;
parameter REFRESH_M_IN_N_N = 15;
parameter REFRESH_M_IN_N_M = 1;

parameter TB_VPD_DUMP_FILE = "dump.vpd";

parameter REFRESH = (REFRESH_M_IN_N_N > 0) ? 1 : 0;




wire                       clk;
wire                       lclk;
wire                       rst;
wire                       ready;
wire                       refr;


//L2 IFC
wire m_creq_valid;
wire [NXTYPEWIDTH-1 : 0]m_creq_type;
wire [NXATTRWIDTH-1 : 0]m_creq_attr;
wire [NXSIZEWIDTH-1 : 0]m_creq_size;
wire [YBITSEQ-1 : 0]m_creq_id;
wire [NXADDRWIDTH-1 : 0]m_creq_addr;
wire m_creq_rdstall;
wire m_creq_wrstall;


wire m_dreq_valid;
wire [YBITSEQ-1 : 0]m_dreq_id;
wire [NXDATAWIDTH-1 : 0]m_dreq_data;
wire [NXATTRWIDTH-1 : 0]m_dreq_attr;
wire m_dreq_stall;

wire m_rreq_valid;
wire [YBITSEQ-1 : 0]m_rreq_id;
wire [NXDATAWIDTH-1 : 0]m_rreq_data;
wire [NXATTRWIDTH-1 : 0]m_rreq_attr;
wire m_rreq_stall;

//CPU IFC
wire s_creq_valid;
wire [NXTYPEWIDTH-1 : 0]s_creq_type;
wire [NXATTRWIDTH-1 : 0]s_creq_attr;
wire [NXSIZEWIDTH-1 : 0]s_creq_size;
wire [NXIDWIDTH-1 : 0]s_creq_id;
wire [NXADDRWIDTH-1 : 0]s_creq_addr;
wire s_creq_rdstall;
wire s_creq_wrstall;


wire s_dreq_valid;
wire [NXIDWIDTH-1 : 0]s_dreq_id;
wire [NXDATAWIDTH-1 : 0]s_dreq_data;
wire [NXATTRWIDTH-1 : 0]s_dreq_attr;
wire s_dreq_stall;

wire s_rreq_valid;
wire [NXIDWIDTH-1 : 0]s_rreq_id;
wire [NXDATAWIDTH-1 : 0]s_rreq_data;
wire [NXATTRWIDTH-1 : 0]s_rreq_attr;
wire s_rreq_stall;

wire                               t1_we_w0;
wire [BITINDX-1:0]                 t1_a_w0;
wire [BITTAGM-1:0]                 t1_din_w0;
wire                               t1_re_r0;
wire [BITINDX-1:0]                 t1_a_r0;
wire  [BITTAGM-1:0]                t1_dout_r0;
                                     
wire                               t2_we_w0;
wire [BITINDX-1:0]                 t2_a_w0;
wire [BITDATM-1:0]                 t2_din_w0;
wire                               t2_re_r0;
wire [BITINDX-1:0]                 t2_a_r0;
wire  [BITDATM-1:0]                t2_dout_r0;

wire                               t3_we_w0;
wire [BITRDFF-1:0]                 t3_a_w0;
wire [BITDATA-1:0]                 t3_din_w0;
wire                               t3_re_r0;
wire [BITRDFF-1:0]                 t3_a_r0;
wire [BITDATA-1:0]                 t3_dout_r0;

    Naxi_Ifc#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) mAxiIfc[NUMXMPT] (clk);

    assign s_creq_valid            = mAxiIfc[0].creqValid;
    assign s_creq_type             = mAxiIfc[0].creqType;
    assign s_creq_attr             = mAxiIfc[0].creqAttr;
    assign s_creq_size             = mAxiIfc[0].creqSize;
    assign s_creq_id               = mAxiIfc[0].creqId;
    assign s_creq_addr             = mAxiIfc[0].creqAddr;
    assign s_dreq_valid            = mAxiIfc[0].dreqValid;
    assign s_dreq_id               = mAxiIfc[0].dreqId;
    assign s_dreq_data             = mAxiIfc[0].dreqData;
    assign s_dreq_attr             = mAxiIfc[0].dreqAttr;
    assign s_rreq_stall            = mAxiIfc[0].rreqStall;

    always@(*) begin
          mAxiIfc[0].creqRdStall    = s_creq_rdstall;
   	  mAxiIfc[0].creqWrStall    = s_creq_wrstall;
   	  mAxiIfc[0].dreqStall      = s_dreq_stall;
   	  mAxiIfc[0].rreqValid      = s_rreq_valid;    
   	  mAxiIfc[0].rreqId         = s_rreq_id;       
   	  mAxiIfc[0].rreqData       = s_rreq_data;     
   	  mAxiIfc[0].rreqAttr       = s_rreq_attr;     
     end




    Naxi_Ifc#(NXADDRWIDTH,NXDATAWIDTH,NXIDWIDTH,NXTYPEWIDTH,NXSIZEWIDTH,NXATTRWIDTH) sAxiIfc[NUMXSPT] (clk);


    assign m_creq_rdstall           = sAxiIfc[0].creqRdStall;
    assign m_creq_wrstall           = sAxiIfc[0].creqWrStall;
    assign m_dreq_stall             = sAxiIfc[0].dreqStall;
    assign m_rreq_valid             = sAxiIfc[0].rreqValid;    
    assign m_rreq_id                = sAxiIfc[0].rreqId;       
    assign m_rreq_data              = sAxiIfc[0].rreqData;     
    assign m_rreq_attr              = sAxiIfc[0].rreqAttr;     

    always@(*) begin
         sAxiIfc[0].creqValid       = m_creq_valid;
         sAxiIfc[0].creqType        = m_creq_type;
         sAxiIfc[0].creqAttr        = m_creq_attr;
         sAxiIfc[0].creqSize        = m_creq_size;
         sAxiIfc[0].creqId          = m_creq_id;
         sAxiIfc[0].creqAddr        = m_creq_addr;
         sAxiIfc[0].dreqValid       = m_dreq_valid;
         sAxiIfc[0].dreqId          = m_dreq_id;
         sAxiIfc[0].dreqData        = m_dreq_data;
         sAxiIfc[0].dreqAttr        = m_dreq_attr;
         sAxiIfc[0].rreqStall       = m_rreq_stall;
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

  mem_beh_1r1w #(.WORDS(NUMRDFF), .AW(BITRDFF), .DW(BITDATA), .LATENCY(URPDELY))
    rfifo_inst ( .clk(clk), .rst(rst),
     .write_1(t3_we_w0), .addr_1(t3_a_w0), .din_1(t3_din_w0),.bw_1({BITDATA{1'b1}}),
     .read_0(t3_re_r0), .addr_0(t3_a_r0), .dout_0(t3_dout_r0),.read_derr_0(),.read_serr_0());



     zt_des_cache_top_1r1w #(.XBITDAT(XBITDAT),.XBITTYP(XBITTYP),.XBITSIZ(XBITSIZ),.XBITATR(XBITATR),.XNUMBET(XNUMBET),.XNUMSEQ(XNUMSEQ),.YNUMBET(YNUMBET),.YNUMSEQ(YNUMSEQ),.BITADDR(BITADDR),.BITDATA(BITDATA),.NUMBYLN(NUMBYLN),.NUMWAYS(NUMWAYS),.NUMINDX(NUMINDX),.BITWAYS(BITWAYS),.BITINDX(BITINDX),.MEMDELY(MEMDELY),.URPDELY(URPDELY) ) dut (.*);
     L2CacheProgram
        #(
                .NXADDRWIDTH(NXADDRWIDTH), 
		.NXDATAWIDTH(NXDATAWIDTH), 
		.NXIDWIDTH(NXIDWIDTH), 
		.NXTYPEWIDTH(NXTYPEWIDTH), 
		.NXSIZEWIDTH(NXSIZEWIDTH), 
		.NXATTRWIDTH(NXATTRWIDTH),
                .NOMSTP(NUMXMPT),
                .NOSLVP(NUMXSPT),
                .NUMWAYS(NUMWAYS), 
		.NUMROWS(NUMROWS)
         ) 
     i_MeCacheProgram (miscIfc,mAxiIfc,sAxiIfc);
endmodule 
