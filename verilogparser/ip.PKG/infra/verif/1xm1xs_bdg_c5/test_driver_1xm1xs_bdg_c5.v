module test_driver_1xm1xs_bdg_c5
(                   read, rd_adr, rd_vld, rd_dout, rd_serr, rd_derr, rd_padr,
                    rw_read, rw_write, rw_addr, rw_din, rw_vld, rw_dout, rw_serr, rw_derr, rw_padr,
                    write, wr_adr, din,
                    cnt, ct_adr, ct_imm, ct_vld, ct_serr, ct_derr,
                    ac_read, ac_write, ac_addr, ac_din, ac_vld, ac_dout, ac_serr, ac_derr, ac_padr,
                    ru_read, ru_write, ru_addr, ru_din, ru_vld, ru_dout, ru_serr, ru_derr, ru_padr,
                    ma_write, ma_adr, ma_din, ma_bp,
                    dq_vld, dq_adr, 
                    push, pu_adr, pu_din, pu_ptr, pu_vld, pu_cnt,
                    pop, po_adr, po_vld, po_dout, po_serr, po_derr, po_padr,
                    po_ptr, po_nxt, po_cnt, po_snxt, po_sdout,
                    dbg_en, dbg_read, dbg_write, dbg_bank, dbg_addr, dbg_din, dbg_vld, dbg_dout, dbg_refr, dbg_rbnk,
                    clk, lclk, ready, rst, refr,
                    m_creq_valid,m_creq_type,m_creq_attr,m_creq_size,m_creq_id,m_creq_addr,m_creq_rdstall,m_creq_wrstall,
                    m_dreq_valid,m_dreq_id,m_dreq_data,m_dreq_attr,m_dreq_stall,
                    m_rreq_valid,m_rreq_id,m_rreq_data,m_rreq_attr,m_rreq_stall,
                    s_creq_valid,s_creq_type,s_creq_attr,s_creq_size,s_creq_id,s_creq_addr,s_creq_rdstall,s_creq_wrstall,
                    s_dreq_valid,s_dreq_id,s_dreq_data,s_dreq_attr,s_dreq_stall,
                    s_rreq_valid,s_rreq_id,s_rreq_data,s_rreq_attr,s_rreq_stall
);
parameter DEPTH = 32;
parameter BITADDR = 5;
parameter WIDTH   = 8;
parameter BITPADR = 16;

parameter NUMCELL = 8;
parameter BITCELL = 3;
parameter NUMQUEU = DEPTH/80;
parameter BITQUEU = BITADDR-BITCELL;
parameter NUMSCNT = 2;
parameter CNTWDTH = WIDTH >=4 ? WIDTH/NUMSCNT : 4/NUMSCNT;

parameter ENARDSG = 0;
parameter ENAWRSG = 0;
parameter ENAPSDO = 0;
parameter ENARPSD = 0;
parameter ENARDSQ = 0;
parameter ENAWRSQ = 0;
parameter ENAWRST = 0;
parameter WRRDHAZ = 4;
parameter RDWRHAZ = 3;
parameter WIN_DELAY = 26;
parameter NUMVBNK = 4;
parameter BITVBNK = 2;
parameter NUMVROW = 8;
parameter BITVROW = 3;

parameter NUMRDPT = 0;
parameter NUMRWPT = 0;
parameter NUMWRPT = 0;
parameter NUMCTPT = 0;
parameter NUMACPT = 0;
parameter NUMRUPT = 0;
parameter NUMMAPT = 0;
parameter NUMDQPT = 0;
parameter NUMPUPT = 0;
parameter NUMPOPT = 0;

parameter NUMXMPT = 1;
parameter NUMXSPT = 1;

parameter MEM_DELAY = 1;
parameter UPD_DELAY = 1;

parameter TB_HALF_CLK_PER = 1000;
parameter TB_HALF_LCLK_PER = 1500;

parameter REFRESH_M_IN_N_N_HF = 0;
parameter REFRESH_M_IN_N_N = 15;
parameter REFRESH_M_IN_N_M = 1;

parameter TB_VPD_DUMP_FILE = "dump.vpd";

parameter REFRESH = (REFRESH_M_IN_N_N > 0) ? 1 : 0;

parameter NUMMASK = 0;
parameter PTMASK1 = 0;
parameter PTMASK2 = 0;
parameter PTMASK3 = 0;
parameter PTMASK4 = 0;
parameter PTMASK5 = 0;
parameter PTMASK6 = 0;
parameter PTMASK7 = 0;
parameter PTMASK8 = 0;

parameter NUMDBNK = 0;
parameter BITDBNK = 0;
parameter NUMDROW = 0;
parameter BITDROW = 0;
parameter DBGWDTH = 0;
parameter BITDRBNK = 0;

parameter MAX_MEM_DELAY = 10;

parameter C1_BANK = 0;	parameter C1_ROWS = 0;	parameter C1_WDTH = 0;  parameter C1_DELY = 1;  parameter C1_RBNK = 0;  parameter C1_RROW = 0;
parameter C2_BANK = 0;	parameter C2_ROWS = 0;	parameter C2_WDTH = 0;  parameter C2_DELY = 1;  parameter C2_RBNK = 0;  parameter C2_RROW = 0;
parameter C3_BANK = 0;	parameter C3_ROWS = 0;	parameter C3_WDTH = 0;  parameter C3_DELY = 1;  parameter C3_RBNK = 0;  parameter C3_RROW = 0;
parameter C4_BANK = 0;	parameter C4_ROWS = 0;	parameter C4_WDTH = 0;  parameter C4_DELY = 1;  parameter C4_RBNK = 0;  parameter C4_RROW = 0;
parameter C5_BANK = 0;	parameter C5_ROWS = 0;	parameter C5_WDTH = 0;  parameter C5_DELY = 1;  parameter C5_RBNK = 0;  parameter C5_RROW = 0;
parameter C6_BANK = 0;	parameter C6_ROWS = 0;	parameter C6_WDTH = 0;  parameter C6_DELY = 1;  parameter C6_RBNK = 0;  parameter C6_RROW = 0;
parameter C7_BANK = 0;	parameter C7_ROWS = 0;	parameter C7_WDTH = 0;  parameter C7_DELY = 1;  parameter C7_RBNK = 0;  parameter C7_RROW = 0;
parameter C8_BANK = 0;	parameter C8_ROWS = 0;	parameter C8_WDTH = 0;  parameter C8_DELY = 1;  parameter C8_RBNK = 0;  parameter C8_RROW = 0;

parameter NXADDRWIDTH = 31;
parameter NXDATAWIDTH = 256;
parameter NXIDWIDTH = 4;
parameter NXTYPEWIDTH = 3;
parameter NXSIZEWIDTH = 8;
parameter NXATTRWIDTH = 3;
parameter NUMWAYS = 4;
parameter NUMROWS = 128;

output [NUMRDPT-1:0]         read;
output [NUMRDPT*BITADDR-1:0] rd_adr;
input [NUMRDPT-1:0]          rd_vld;
input [NUMRDPT*WIDTH-1:0]    rd_dout; 
input [NUMRDPT-1:0]          rd_serr;
input [NUMRDPT-1:0]          rd_derr;
input [NUMRDPT*BITPADR-1:0]  rd_padr;

output [NUMRWPT-1:0]         rw_read;
output [NUMRWPT-1:0]         rw_write;
output [NUMRWPT*BITADDR-1:0] rw_addr;
output [NUMRWPT*WIDTH-1:0]   rw_din; 
input [NUMRWPT-1:0]          rw_vld;
input [NUMRWPT*WIDTH-1:0]    rw_dout; 
input [NUMRWPT-1:0]          rw_serr;
input [NUMRWPT-1:0]          rw_derr;
input [NUMRWPT*BITPADR-1:0]  rw_padr;

output [NUMWRPT-1:0]         write;
output [NUMWRPT*BITADDR-1:0] wr_adr;
output [NUMWRPT*WIDTH-1:0]   din; 

output [NUMCTPT-1:0]         cnt;
output [NUMCTPT*BITADDR-1:0] ct_adr;
output [NUMCTPT*WIDTH-1:0]   ct_imm; 
input [NUMCTPT-1:0]          ct_vld;
input [NUMCTPT-1:0]          ct_serr;
input [NUMCTPT-1:0]          ct_derr;

output [NUMACPT-1:0]         ac_read;
output [NUMACPT-1:0]         ac_write;
output [NUMACPT*BITADDR-1:0] ac_addr;
output [NUMACPT*WIDTH-1:0]   ac_din; 
input [NUMACPT-1:0]          ac_vld;
input [NUMACPT*WIDTH-1:0]    ac_dout; 
input [NUMACPT-1:0]          ac_serr;
input [NUMACPT-1:0]          ac_derr;
input [NUMACPT*BITPADR-1:0]  ac_padr;

output [NUMRUPT-1:0]         ru_read;
output [NUMRUPT-1:0]         ru_write;
output [NUMRUPT*BITADDR-1:0] ru_addr;
output [NUMRUPT*WIDTH-1:0]   ru_din; 
input [NUMRUPT-1:0]          ru_vld;
input [NUMRUPT*WIDTH-1:0]    ru_dout; 
input [NUMRUPT-1:0]          ru_serr;
input [NUMRUPT-1:0]          ru_derr;
input [NUMRUPT*BITPADR-1:0]  ru_padr;

output [NUMMAPT-1:0]         ma_write;
input [NUMMAPT*BITADDR-1:0]  ma_adr;
output [NUMMAPT*WIDTH-1:0]   ma_din; 
input [NUMMAPT-1:0]          ma_bp;

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


output                       dbg_en;
output                       dbg_read;
output                       dbg_write;
output [BITDBNK-1:0]         dbg_bank;
output [BITDROW-1:0]         dbg_addr;
output [DBGWDTH-1:0]         dbg_din; 
input                        dbg_vld;
input [DBGWDTH-1:0]          dbg_dout; 
output                       dbg_refr;
output [BITDRBNK-1:0]        dbg_rbnk;

output                       clk;
output                       lclk;
output                       rst;
input                        ready;
output                       refr;


//L2 IFC
input m_creq_valid;
input [NXTYPEWIDTH-1 : 0]m_creq_type;
input [NXATTRWIDTH-1 : 0]m_creq_attr;
input [NXSIZEWIDTH-1 : 0]m_creq_size;
input [NXIDWIDTH-1 : 0]m_creq_id;
input [NXADDRWIDTH-1 : 0]m_creq_addr;
output m_creq_rdstall;
output m_creq_wrstall;


input m_dreq_valid;
input [NXIDWIDTH-1 : 0]m_dreq_id;
input [NXDATAWIDTH-1 : 0]m_dreq_data;
input [NXATTRWIDTH-1 : 0]m_dreq_attr;
output m_dreq_stall;

output m_rreq_valid;
output [NXIDWIDTH-1 : 0]m_rreq_id;
output [NXDATAWIDTH-1 : 0]m_rreq_data;
output [NXATTRWIDTH-1 : 0]m_rreq_attr;
input m_rreq_stall;

//CPU IFC
output s_creq_valid;
output [NXTYPEWIDTH-1 : 0]s_creq_type;
output [NXATTRWIDTH-1 : 0]s_creq_attr;
output [NXSIZEWIDTH-1 : 0]s_creq_size;
output [NXIDWIDTH-1 : 0]s_creq_id;
output [NXADDRWIDTH-1 : 0]s_creq_addr;
input s_creq_rdstall;
input s_creq_wrstall;


output s_dreq_valid;
output [NXIDWIDTH-1 : 0]s_dreq_id;
output [NXDATAWIDTH-1 : 0]s_dreq_data;
output [NXATTRWIDTH-1 : 0]s_dreq_attr;
input s_dreq_stall;

input s_rreq_valid;
input [NXIDWIDTH-1 : 0]s_rreq_id;
input [NXDATAWIDTH-1 : 0]s_rreq_data;
input [NXATTRWIDTH-1 : 0]s_rreq_attr;
output s_rreq_stall;


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

             Dbg_Ifc#(BITDROW,BITDBNK,DBGWDTH) dbgIfc(clk);

             assign dbg_en    = dbgIfc.dbg_en    ; 
             assign dbg_read  = dbgIfc.dbg_read  ; 
             assign dbg_write = dbgIfc.dbg_write ; 
             assign dbg_addr  = dbgIfc.dbg_addr  ; 
             assign dbg_din  = dbgIfc.dbg_din ; 
             assign dbg_bank  = dbgIfc.dbg_bank  ; 
             assign dbgIfc.dbg_vld = dbg_vld;
             assign dbgIfc.dbg_dout = dbg_dout;
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



     MeCacheProgram
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
		.NUMROWS(NUMROWS),
                .DBGADDRWIDTH(BITDROW),
		.DBGBADDRWIDTH(BITDBNK),
		.DBGDATAWIDTH(DBGWDTH),
		.NUMDBNK(NUMDBNK),
		.NUMDROW(NUMDROW)
         ) 
     i_MeCacheProgram (miscIfc,mAxiIfc,sAxiIfc,dbgIfc);
     //i_MeCacheProgram (miscIfc,mAxiIfc[NOMSTP],sAxiIfc[NOMSTP]);
endmodule 
