//--------------------------------------------------------------------------
//  Cisco Systems Inc.                                                    
//                                                                        
//  Copyright (c) 2007 Cisco Systems                                      
//  All rights reserved                                                   
//                                                                        
// This is UNPUBLISHED PROPRIETARY SOURCE CODE of Cisco Systems, Inc;
// the contents of this file may not be disclosed to third parties, copied or
// duplicated in any form, in whole or in part, without the prior written
// permission of Cisco Systems, Inc.
//
// RESTRICTED RIGHTS LEGEND:
// Use, duplication or disclosure by the Government is subject to restrictions
// as set forth in subdivision (c)(1)(ii) of the Rights in Technical Data
// and Computer Software clause at DFARS 252.227-7013, and/or in similar or
// successor clauses in the FAR, DOD or NASA FAR Supplement. Unpublished -
// rights reserved under the Copyright Laws of the United States.
//
//--------------------------------------------------------------------------
//
//  File Name    :          CapWrap.vh
//  Author       :          sanam
//  Description  :          functions and Macros for CAP Wrappper Specific need
//  $Header: /auto/dsbu-asic-core/dglobal/MASTER/common/rtl/CapWrap.vh,v 1.2 2013/06/06 00:46:24 bli4 Exp $
//
//--------------------------------------------------------------------------
//

`ifndef _CAP_WRAP_VH_

 `define _CAP_WRAP_VH_

 `include "RAMWRAP.vh"

// global define to enable/disable ELAM interfaces across entire chip.
//    USAGES: 
//       CAP_ELAM_GLOBAL_ENABLE is defined and set to 0 in dopplerd_cosim_sim.mk for faster simulation targets
//       ELAM_GLOBAL_DISABLE is defined in dopplerd_emul_synth.mk to disable ELAM in some FPGAs synthesis targets where it does not fit
// 
`ifndef CAP_ELAM_GLOBAL_ENABLE
   `ifdef ELAM_GLOBAL_DISABLE
      `define CAP_ELAM_GLOBAL_ENABLE 1'b0
   `else
      `define CAP_ELAM_GLOBAL_ENABLE 1'b1
   `endif
`endif

// global define to enable/disable CPU or ELAM interfaces across entire chip.
  `define CAP_CPU_GLOBAL_ENABLE  1'b1

// global define to enable/disable EMUL parameter (for routing CAP wrap memories externally)
 `ifdef EMULATION
   `ifdef USE_GENERIC_WRAPPER     // temp fix for running backdoor on RTEA tests
     `define CAP_EMUL_GLOBAL_ENABLE 1'b0
   `else                          // temp fix for running backdoor on RTEA tests
     `define CAP_EMUL_GLOBAL_ENABLE 1'b1
   `endif
 `else
   `define CAP_EMUL_GLOBAL_ENABLE 1'b0
 `endif

 `define MACRO_getCodeWidth \
    function integer codeWidth; \
      input [31:0]  WIDTH; \
      input         PARITY; \
      input         ECC; \
      begin \
         if (PARITY) \
            codeWidth = 1; \
         else if (ECC) \
            codeWidth = (((log2(WIDTH)+WIDTH) < (1'b1 << (log2(WIDTH)))) ? log2(WIDTH)+1 : log2(WIDTH)+2); \
         else \
            codeWidth = 0; \
      end \
    endfunction  // codeWidth

`define MACRO_CAP_NUMWORDENABLES localparam CAP_NUMWORDENABLES =((NUMWORDENABLES==0)?1:NUMWORDENABLES);
`define CAP_CODE_WIDTH codeWidth(WIDTH, PARITY, ECC)
`define CAP_1P_CODE_WIDTH codeWidth((WIDTH/CAP_NUMWORDENABLES), PARITY, ECC)

//Gets Protection Width
 `define MACRO_getProtWidth \
function integer protWidth; \
      input [31:0]  width; \
      begin \
         protWidth =width+`CAP_CODE_WIDTH; \
      end \
    endfunction  // protWidth

                                    //                              
`define CAP_PROT_WIDTH protWidth(WIDTH)
`define CAP_SUB_PROT_WIDTH protWidth(WIDTH/CAP_NUMWORDENABLES)

                                    
 `define MACRO_RAM_cpuAddrWidth \
   function integer cpuAddrWidth; \
      input [31:0]  DEPTH; \
      begin \
         cpuAddrWidth = log2(DEPTH)+log2( (LOGICALWIDTH>32)?LOGICALWIDTH:(LOGICALWIDTH==0)?((WIDTH>32)?WIDTH:32):32)-5; \
      end \
   endfunction // cpuAddrOffsetWidth

 `define MACRO_TCAM_cpuAddrWidth \
    function integer cpuAddrWidth; \
      input [31:0]  DEPTH; \
      begin \
         cpuAddrWidth = log2(DEPTH)+log2( (LOGICALWIDTH>32)?LOGICALWIDTH:(LOGICALWIDTH==0)?((WIDTH>32)?WIDTH:32):32)-4; \
      end \
   endfunction // cpuAddrOffsetWidth

 `define MACRO_TCAM_getProtWidth \
     function integer protWidth; \
      input [31:0] WIDTH; \
      input        PARITY; \
      begin \
         if (PARITY) \
            protWidth = WIDTH+1; \
         else \
            protWidth = WIDTH; \
      end \
   endfunction // protWidth

  `define CAP_TCAM_PROT_WIDTH protWidth(WIDTH, PARITY)

  `define MACRO_CAPWRAP_COMMON_LPARAMS \
     localparam PROT         = ECC | PARITY; \
     `MACRO_CAP_NUMWORDENABLES \
     localparam CAPWORD32S = ((WIDTH%32) != 0) ? (WIDTH/32)+1 : WIDTH/32; \
     localparam SUB_WIDTH    = (WIDTH/CAP_NUMWORDENABLES); \
     localparam SUB_CODE_WIDTH    = codeWidth(SUB_WIDTH, PARITY, ECC); \
     localparam SUB_PROT_WIDTH    = SUB_WIDTH+SUB_CODE_WIDTH; \
     localparam ECC_WIDTH    = codeWidth(WIDTH, 0, 1); \
     localparam SUP_AWIDTH   = cpuAddrWidth(DEPTH); \
     localparam AWIDTH = log2(DEPTH);


  `define MACRO_CAPTCAM_COMMON_LPARAMS \
     localparam PROT         = BIP | PARITY; \
     localparam CAPWORD32S = ((WIDTH%32) != 0) ? (WIDTH/32)+1 : WIDTH/32; \
     localparam BIP_WIDTH    = 8; \
     localparam SUP_AWIDTH   = cpuAddrWidth(DEPTH); \
     localparam RD_LATENCY   = (PARITYPIPELINE) ? PIPELINE+2 : PIPELINE+1; \
     localparam AWIDTH = log2(DEPTH);

  `define MACRO_CAP1P_COMMON_LPARAMS \
     localparam PROT         = ECC | PARITY; \
     localparam CAPWORD32S = ((WIDTH%32) != 0) ? (WIDTH/32)+1 : WIDTH/32; \
     localparam SUB_WIDTH    = (WIDTH/CAP_NUMWORDENABLES); \
     localparam SUB_CODE_WIDTH    = codeWidth(SUB_WIDTH, PARITY, ECC); \
     localparam SUB_PROT_WIDTH    = SUB_WIDTH+SUB_CODE_WIDTH; \
     localparam ECC_WIDTH    = codeWidth(SUB_WIDTH, 0, 1); \
     localparam SUP_AWIDTH   = cpuAddrWidth(DEPTH); \
     localparam NUMWORDENABLEBITS = CAP_NUMWORDENABLES; \
     localparam AWIDTH = log2(DEPTH);

   `define CAP_1P_PROT_WIDTH (SUB_PROT_WIDTH * CAP_NUMWORDENABLES)
   `define CAP_1RW_PROT_WIDTH (SUB_PROT_WIDTH * CAP_NUMWORDENABLES)
     
  `define MACRO_ELAM1P_COMMON_LPARAMS \
     localparam ELAM_DWIDTH  = (2*`CAP_1RW_PROT_WIDTH); \
     localparam ELAM_CWIDTH0 = log2(DEPTH)+1; \
     localparam ELAM_CWIDTH1 = (ECC)? ECC_WIDTH +4 : ((PARITY) ? 3 : 2); \
     localparam ELAM_CWIDTH2 = 0; \
     localparam ELAM_CWIDTH3 = 0; \
     localparam ELAM_CWIDTH4 = (2 * log2(DEPTH)); \
     localparam ELAM_CWIDTH  = ELAM_CWIDTH0 + ELAM_CWIDTH1 + ELAM_CWIDTH2 + ELAM_CWIDTH3 + ELAM_CWIDTH4; \
     localparam ELAM_GEN_EN  = (ELAM_LOCAL == 1) && (`CAP_1RW_PROT_WIDTH <= 2048); \
     localparam USE2ELAMLANES= (`CAP_1RW_PROT_WIDTH > 1024);

  `define MACRO_ELAM2P_COMMON_LPARAMS \
     localparam ELAM_DWIDTH  = (2*`CAP_PROT_WIDTH); \
     localparam ELAM_CWIDTH0 = log2(DEPTH)+1; \
     localparam ELAM_CWIDTH1 = (ECC)? ECC_WIDTH +5 : ((PARITY) ? 4 : 3); \
     localparam ELAM_CWIDTH2 = 0; \
     localparam ELAM_CWIDTH3 = 0; \
     localparam ELAM_CWIDTH4 = (2 * log2(DEPTH)); \
     localparam ELAM_CWIDTH  = ELAM_CWIDTH0 + ELAM_CWIDTH1 + ELAM_CWIDTH2 + ELAM_CWIDTH3 + ELAM_CWIDTH4; \
     localparam ELAM_GEN_EN  = (ELAM_LOCAL == 1) && (`CAP_PROT_WIDTH <= 2048); \
     localparam USE2ELAMLANES= (`CAP_PROT_WIDTH > 1024);

  `define MACRO_ELAMDP_COMMON_LPARAMS \
     localparam ELAM_DWIDTH  = (4*`CAP_PROT_WIDTH); \
     localparam ELAM_CWIDTH0 = log2(DEPTH)+1; \
     localparam ELAM_CWIDTH1 = (ECC)? `CAP_PROT_WIDTH - WIDTH +5 : ((PARITY) ? 3 : 2); \
     localparam ELAM_CWIDTH2 = log2(DEPTH)+1; \
     localparam ELAM_CWIDTH3 = (ECC)? `CAP_PROT_WIDTH - WIDTH +5 : ((PARITY) ? 3 : 2); \
     localparam ELAM_CWIDTH4 = (4 * log2(DEPTH)); \
     localparam ELAM_CWIDTH  = ELAM_CWIDTH0 + ELAM_CWIDTH1 + ELAM_CWIDTH2 + ELAM_CWIDTH3 + ELAM_CWIDTH4; \
     localparam USE2ELAMLANES= (`CAP_PROT_WIDTH > 512); \
     localparam ELAM_GEN_EN  = (ELAM_LOCAL == 1) && (`CAP_PROT_WIDTH <= 1024);

  `define MACRO_ELAMTCAM_COMMON_LPARAMS \
     localparam ELAM_DWIDTH  = (2*`CAP_TCAM_PROT_WIDTH) + DEPTH + WIDTH; \
     localparam ELAM_CWIDTH0 = log2(DEPTH)+1; \
     localparam ELAM_CWIDTH1 = 4 + ((BIP) ? BIP_WIDTH : 1); \
     localparam ELAM_CWIDTH2 = 0; \
     localparam ELAM_CWIDTH3 = 0; \
     localparam ELAM_CWIDTH4 = (2 * log2(DEPTH)) + 2; \
     localparam ELAM_CWIDTH  = ELAM_CWIDTH0 + ELAM_CWIDTH1 + ELAM_CWIDTH2 + ELAM_CWIDTH3 + ELAM_CWIDTH4; \
     localparam ELAM_GEN_EN  = (ELAM_LOCAL == 1) && (ELAM_DWIDTH <= 4096); \
     localparam USE2ELAMLANES= (`CAP_TCAM_PROT_WIDTH > 1024);

  `define MACRO_PIPELINED_PARITY \
     localparam PIPELINED_PARITY = 0;

  `define MACRO_RAM_RD_LATENCY \
     localparam RD_LATENCY   = (PARITY && PARITYPIPELINE) ? PIPELINE+2    : PIPELINE+1;

  `define MACRO_ARRAM_RD_LATENCY \
     localparam RD_LATENCY   = (PARITY && PARITYPIPELINE) ? PIPELINE+1    : PIPELINE;

  `define MACRO_DPRAM_RD_LATENCY \
     localparam RD_LATENCY   = (PARITY && PARITYPIPELINE) ? PIPELINE_P0+2 : PIPELINE_P0+1;

  `define MACRO_EDRAM2P_RD_LATENCY \
     localparam RD_LATENCY   = (PARITY && PARITYPIPELINE) ? PIPELINE+2 : PIPELINE+1;

  `define MACRO_EDRAM1P_RD_LATENCY \
     localparam RD_LATENCY   = (PARITY && PARITYPIPELINE) ? PIPELINE+2 :  PIPELINE+1;

  `define MACRO_EDRAM_COMMON_LPARAMS \
     localparam BANKSZBITS     = log2(`EDRAMWRAP_BANKSIZE); \
     localparam PROTECTEDWIDTH = `CAP_PROT_WIDTH; \
     localparam BYTEENWIDTH    = (`CAP_PROT_WIDTH + 7)/8;

  `define MACRO_EDRAM_COMMON_WIRES \
     wire [`CAP_BUSIN_REFRESHPERIOD_WIDTH-1:0] REFPERINT   = capBusIn[`CAP_BUSIN_REFRESHPERIOD_RANGE]; \
     wire [`CAP_BUSIN_REFRESHBURST_WIDTH-1:0]  REFBURST    = `CAP_BUSIN_REFRESHBURST_WIDTH'hf; \
     wire [`EDRAMWRAP_REFPER_WIDTH-1:0]        REFPER      = `EDRAMWRAP_REFPER_WIDTH'd1024;

//     wire [`CAP_BUSIN_REFRESHPERIOD_WIDTH-1:0] REFPERINT   = capBusIn[`CAP_BUSIN_REFRESHPERIOD_RANGE]; \
//     wire [`CAP_BUSIN_REFRESHBURST_WIDTH-1:0]  REFBURST    = capBusIn[`CAP_BUSIN_REFRESHBURST_RANGE]; \
//     wire [`EDRAMWRAP_REFPER_WIDTH-1:0]        REFPER      = REFPERINT[`EDRAMWRAP_REFPER_WIDTH-1:0]; 


`endif
