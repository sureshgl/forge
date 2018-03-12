////////////////////////////////////////////////////////////////////////////// 
// Copyright 2010, Cisco Systems, Inc. 
// All Rights Reserved. 
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
// Description: Macros for DCM logic in TLAs and DCM
// 
///////////////////////////////////////////////////////////////////////////////////

`ifdef __DCM_VH__
`else
 `define __DCM_VH__ 1
  `include "DcmDesc.vh"

//Adding a pktId define, might move this later to some other top level file
    `define DCM_PKTID_DEBUG_BIT_POSN           8
    
//Dcm defines begin here    
    `define DCM_ELAM_BUS_WIDTH                 292
    `define DCM_ELAM_NUM_OF_SLICES             2
    `define DCM_ELAM_NUM_OF_SLICES_BUS         `DCM_ELAM_NUM_OF_SLICES-1:0
    `define DCM_ELAM_LOG_NUM_OF_SLICES         1
    `define DCM_ELAM_SLICE_WIDTH               (`DCM_ELAM_BUS_WIDTH/`DCM_ELAM_NUM_OF_SLICES)
    `define DCM_VIEW_MERGE_NUM_OF_INPUT_SLICES 256 
    `define DCM_VIEW_MUX_SEL_WIDTH             8
    `define DCM_LOCAL_MUX_SEL_WIDTH            4
    `define DCM_TRACE_ID_WIDTH                 7 
    `define DCM_FLUSH_WIDTH                    1 
    `define DCM_COMPOSITE_TRACE_ID_WIDTH       (`DCM_TRACE_ID_WIDTH + `DCM_FLUSH_WIDTH)
    `define DCM_MODE_SEL_WIDTH                 3
    
///////////////////////////////////////////////////////////////////////////////////
//  Defines for New Elam organization of two 18 bit control and one 128 bit data
///////////////////////////////////////////////////////////////////////////////////
   `define DCM_NUM_CNTRL_VIEWS                  256
   `define DCM_NUM_CNTRL_VIEWS_BUS              `DCM_NUM_CNTRL_VIEWS-1:0
   `define DCM_NUM_DECODE_VIEWS_BUS             `DCM_NUM_CNTRL_VIEWS-1:0

   `define DCM_NUM_CNTRL_SLICES                 2
   `define DCM_NUM_CNTRL_SLICES_BUS             `DCM_NUM_CNTRL_SLICES-1:0

   `define DCM_ELAM_CNTRL_SLICE_WIDTH            18
   `define DCM_ELAM_CNTRL_SLICE_BUS             `DCM_ELAM_CNTRL_SLICE_WIDTH-1:0

   `define DCM_NUM_DATA_VIEWS                  256
   `define DCM_NUM_DATA_VIEWS_BUS              `DCM_NUM_DATA_VIEWS-1:0

   `define DCM_ELAM_DATA_SLICE_WIDTH            128
   `define DCM_ELAM_DATA_SLICE_BUS             `DCM_ELAM_DATA_SLICE_WIDTH-1:0

    `define DCM_ELAM_NUM_OF_DECODE_SLICES       3
    `define DCM_ELAM_NUM_OF_DECODE_SLICES_BUS   `DCM_ELAM_NUM_OF_DECODE_SLICES-1:0
///////////////////////////////////////////////////////////////////////////////////
//  Defines for Pass Thru Mux
///////////////////////////////////////////////////////////////////////////////////

    `define DCM_TRACE_PASSTHRUMUX_CNTRL_BUS    4
    `define DCM_PASSTHRUMUX_SEL_WIDTH         `DCM_ELAM_LOG_NUM_OF_SLICES
    `define DCM_NUM_OF_TRACE_PARTITIONS        2 
    `define DCM_NON_ID_SLICE_WIDTH            ((`DCM_ELAM_SLICE_WIDTH) - (`DCM_COMPOSITE_TRACE_ID_WIDTH))     //138
    `define DCM_CNTRL_NONCOMPOSITETRACE_WIDTH  (`DCM_ELAM_CNTRL_SLICE_WIDTH - `DCM_COMPOSITE_TRACE_ID_WIDTH)  //10
    `define DCM_TLA_TRACECONTROL_TRACENOW_UPPER 3
    `define DCM_TLA_TRACECONTROL_TRACENOW_LOWER 2
    `define DCM_TLA_TRACECONTROL_SETFLUSH_UPPER 1
    `define DCM_TLA_TRACECONTROL_SETFLUSH_LOWER 0
     
///////////////////////////////////////////////////////////////////////////////////
// Configurations for various modes
///////////////////////////////////////////////////////////////////////////////////

    `define DCM_SIPHON_MODE                   0 
    `define DCM_TRACE_CEDE_MODE               1 
    `define DCM_SEIZE_WITH_FLUSH_MODE         2
    `define DCM_SEIZE_WO_FLUSH_MODE           3
    `define DCM_ERROR_MODE                     4 
    `define DCM_TLA_POWER_SAVE_MODE            7 
    `define DCM_PASSTHRUMODE_CNTRL0            0 
    `define DCM_PASSTHRUMODE_CNTRL1            1 
    `define DCM_PASSTHRUMODE_DATA              0 
 
    `define DCM_CNTRL_PASSTHRU_MODESEL_BUS     1:0

///////////////////////////////////////////////////////////////////////////////////
// Postions of various bits on the Trace Slice
// Flush bit: 145
// Trace Id : 145 : 138
// Non Id   : 137 : 0
///////////////////////////////////////////////////////////////////////////////////

    `define DCM_FLUSH_POSITION_IN_SLICE                 (`DCM_ELAM_SLICE_WIDTH - 1)  //145
    `define DCM_TRACEID_MSB_IN_SLICE                    (`DCM_FLUSH_POSITION_IN_SLICE-1)   //144
    `define DCM_COMPOSITE_TRACEID_MSB_IN_SLICE          (`DCM_FLUSH_POSITION_IN_SLICE)     //145
    `define DCM_COMPOSITE_TRACEID_LSB_IN_SLICE          ((`DCM_COMPOSITE_TRACEID_MSB_IN_SLICE + 1) - (`DCM_COMPOSITE_TRACE_ID_WIDTH) ) //138
    `define DCM_NONID_MSB_IN_SLICE                      (`DCM_COMPOSITE_TRACEID_LSB_IN_SLICE - 1)           //137
    `define DCM_NONID_LSB_IN_SLICE                      ((`DCM_NONID_MSB_IN_SLICE +1 )- (`DCM_NON_ID_SLICE_WIDTH))   //0

    `define DCM_FLUSH_POSITION_IN_COMPOSITE_ID          (`DCM_COMPOSITE_TRACE_ID_WIDTH -1)        //7
    `define DCM_TRACEID_MSB_IN_COMPOSITE_ID             (`DCM_FLUSH_POSITION_IN_COMPOSITE_ID - 1)  //6
    `define DCM_TRACEID_LSB_IN_COMPOSITE_ID             (`DCM_TRACEID_MSB_IN_COMPOSITE_ID+1) - (`DCM_TRACE_ID_WIDTH)  //0
    `define DCM_CNTRLPORTION_MSB_IN_SLICE                (`DCM_ELAM_SLICE_WIDTH-1)     //145
    `define DCM_CNTRLPORTION_LSB_IN_SLICE                (`DCM_ELAM_DATA_SLICE_WIDTH)  //128
    `define DCM_DATAPORTION_MSB_IN_SLICE                (`DCM_ELAM_SLICE_WIDTH-1)     //127
    `define DCM_DATAPORTION_LSB_IN_SLICE                 0


///////////////////////////////////////////////////////////////////////////////////
// Postions of various bits on the Cntrl Slice
// Flush bit: 17
// Trace Id : 16 : 10
// Non Id   : 9:0
///////////////////////////////////////////////////////////////////////////////////
    `define DCM_COMPOSITE_TRACEID_MSB_IN_CNTRL_SLICE   (`DCM_ELAM_CNTRL_SLICE_WIDTH-1)   //17
    `define DCM_COMPOSITE_TRACEID_LSB_IN_CNTRL_SLICE   ((`DCM_COMPOSITE_TRACEID_MSB_IN_CNTRL_SLICE + 1) - (`DCM_COMPOSITE_TRACE_ID_WIDTH) )  //10
///////////////////////////////////////////////////////////////////////////////////
//  Defines for Trace Cntrl Block
///////////////////////////////////////////////////////////////////////////////////
    `define DCM_TLA_MATCH_MASK_WIDTH                    18
    `define DCM_TLA_MATCH_MASK_SEL_WIDTH                `DCM_ELAM_LOG_NUM_OF_SLICES
    `define DCM_TLA_MATCH_MASK_MSB_IN_SLICE            (`DCM_ELAM_SLICE_WIDTH - 1)
    `define DCM_TLA_MATCH_MASK_LSB_IN_SLICE           ((`DCM_TLA_MATCH_MASK_MSB_IN_SLICE + 1) - `DCM_TLA_MATCH_MASK_WIDTH)
    `define DCM_TRACECNTRL_MISC_BUS_WIDTH               1

///////////////////////////////////////////////////////////////////////////////////
//  Defines for control sections in a flattened 292bit bus
///////////////////////////////////////////////////////////////////////////////////

    `define DCM_TOTAL_CNTRL_BIT_COUNT                    (`DCM_TLA_MATCH_MASK_WIDTH*`DCM_ELAM_NUM_OF_SLICES)
    `define DCM_TOTAL_DATA_BIT_COUNT                     (`DCM_ELAM_BUS_WIDTH - `DCM_TOTAL_CNTRL_BIT_COUNT)
    `define DCM_LOWER_CNTRL_BUS                          `DCM_TLA_MATCH_MASK_MSB_IN_SLICE:`DCM_TLA_MATCH_MASK_LSB_IN_SLICE
    `define DCM_UPPER_CNTRL_BUS                          `DCM_TLA_MATCH_MASK_MSB_IN_SLICE+`DCM_ELAM_SLICE_WIDTH:`DCM_TLA_MATCH_MASK_LSB_IN_SLICE+`DCM_ELAM_SLICE_WIDTH
 
 //--------------------------------------------------------------------------- 
 //These are trace id defines for various TLAs. 
 //To add a new tla, add the corresponding entry in DcmDesc.rdl
 //DcmTlaIdTableDesc (pick the next number to use as the id) 
 //gsrc/DcmDesc.vh will then generate a corresponding RESET_VALUE define
 //that should be assigned to the TRACE_ID
 //--------------------------------------------------------------------------- 

`define DCM_AQM_TRACE_ID      `DCM_TLAIDTABLEDESC_AQMDCMID_RESET_VALUE                       
`define DCM_ASE_TRACE_ID      `DCM_TLAIDTABLEDESC_ASE0DCMID_RESET_VALUE
`define DCM_CMM_TRACE_ID      `DCM_TLAIDTABLEDESC_CMMDCMID_RESET_VALUE
`define DCM_EGR_TRACE_ID      `DCM_TLAIDTABLEDESC_EGRDCMID_RESET_VALUE
`define DCM_ELE_TRACE_ID      `DCM_TLAIDTABLEDESC_ELEDCMID_RESET_VALUE
`define DCM_EPF_TRACE_ID      `DCM_TLAIDTABLEDESC_EPFDCMID_RESET_VALUE
`define DCM_EPP_TRACE_ID      `DCM_TLAIDTABLEDESC_EPPDCMID_RESET_VALUE
`define DCM_EQC_TRACE_ID      `DCM_TLAIDTABLEDESC_EQCDCMID_RESET_VALUE
`define DCM_ESM_TRACE_ID      `DCM_TLAIDTABLEDESC_ESMDCMID_RESET_VALUE
`define DCM_FPE_TRACE_ID      `DCM_TLAIDTABLEDESC_FPEINGRESSDCMID_RESET_VALUE
`define DCM_FPEINGRESS_TRACE_ID `DCM_TLAIDTABLEDESC_FPEINGRESSDCMID_RESET_VALUE
`define DCM_FPEEGRESS_TRACE_ID `DCM_TLAIDTABLEDESC_FPEEGRESSDCMID_RESET_VALUE
`define DCM_FPS_TRACE_ID      `DCM_TLAIDTABLEDESC_FPS0DCMID_RESET_VALUE
`define DCM_FRW_TRACE_ID      `DCM_TLAIDTABLEDESC_FRWDCMID_RESET_VALUE
`define DCM_FSE_TRACE_ID      `DCM_TLAIDTABLEDESC_FSE0DCMID_RESET_VALUE
`define DCM_HSH_TRACE_ID      `DCM_TLAIDTABLEDESC_HSH0DCMID_RESET_VALUE
`define DCM_IGR_TRACE_ID      `DCM_TLAIDTABLEDESC_IGRDCMID_RESET_VALUE
`define DCM_ILE_TRACE_ID      `DCM_TLAIDTABLEDESC_ILEDCMID_RESET_VALUE
`define DCM_IPF_TRACE_ID      `DCM_TLAIDTABLEDESC_IPFDCMID_RESET_VALUE
`define DCM_IPP_TRACE_ID      `DCM_TLAIDTABLEDESC_IPPDCMID_RESET_VALUE
`define DCM_IQS_TRACE_ID      `DCM_TLAIDTABLEDESC_IQSDCMID_RESET_VALUE
`define DCM_IQM_TRACE_ID      `DCM_TLAIDTABLEDESC_IQMDCMID_RESET_VALUE
`define DCM_ISM_TRACE_ID      `DCM_TLAIDTABLEDESC_ISMDCMID_RESET_VALUE
`define DCM_MSC_TRACE_ID      `DCM_TLAIDTABLEDESC_MSCINGRESSDCMID_RESET_VALUE
`define DCM_MSCINGRESS_TRACE_ID `DCM_TLAIDTABLEDESC_MSCINGRESSDCMID_RESET_VALUE
`define DCM_MSCEGRESS_TRACE_ID  `DCM_TLAIDTABLEDESC_MSCEGRESSDCMID_RESET_VALUE
`define DCM_NFL_TRACE_ID      `DCM_TLAIDTABLEDESC_NFLDCMID_RESET_VALUE
`define DCM_NIF_TRACE_ID      `DCM_TLAIDTABLEDESC_NIFDCMID_RESET_VALUE
`define DCM_NRU_TRACE_ID      `DCM_TLAIDTABLEDESC_NRUDCMID_RESET_VALUE
`define DCM_OFT_TRACE_ID      `DCM_TLAIDTABLEDESC_OFT0DCMID_RESET_VALUE
`define DCM_PBC_TRACE_ID      `DCM_TLAIDTABLEDESC_PBCDCMID_RESET_VALUE
`define DCM_PIM_TRACE_ID      `DCM_TLAIDTABLEDESC_PIMDCMID_RESET_VALUE
`define DCM_PLC_TRACE_ID      `DCM_TLAIDTABLEDESC_PLCDCMID_RESET_VALUE
`define DCM_RMU_TRACE_ID      `DCM_TLAIDTABLEDESC_RMUDCMID_RESET_VALUE
`define DCM_RRE_TRACE_ID      `DCM_TLAIDTABLEDESC_RREDCMID_RESET_VALUE
`define DCM_RWE_TRACE_ID      `DCM_TLAIDTABLEDESC_RWEDCMID_RESET_VALUE
`define DCM_SEC_TRACE_ID      `DCM_TLAIDTABLEDESC_SECDCMID_RESET_VALUE
`define DCM_SIF_TRACE_ID      `DCM_TLAIDTABLEDESC_SIFDCMID_RESET_VALUE
`define DCM_SLI_TRACE_ID      `DCM_TLAIDTABLEDESC_SLIDCMID_RESET_VALUE
`define DCM_SQS_TRACE_ID      `DCM_TLAIDTABLEDESC_SQSDCMID_RESET_VALUE
`define DCM_SUP_TRACE_ID      `DCM_TLAIDTABLEDESC_SUPDCMID_RESET_VALUE
`define DCM_TSQ_TRACE_ID      `DCM_TLAIDTABLEDESC_TSQ0DCMID_RESET_VALUE
`define DCM_TAQ_TRACE_ID      `DCM_TLAIDTABLEDESC_TAQ0DCMID_RESET_VALUE
`define DCM_TFQ_TRACE_ID      `DCM_TLAIDTABLEDESC_TFQ0DCMID_RESET_VALUE
`define DCM_TLQ_TRACE_ID      `DCM_TLAIDTABLEDESC_TLQ0DCMID_RESET_VALUE
`define DCM_DMC_TRACE_ID      `DCM_TLAIDTABLEDESC_DMCDCMID_RESET_VALUE
`define DCM_NCA_TRACE_ID      `DCM_TLAIDTABLEDESC_NCADCMID_RESET_VALUE
`define DCM_BSP_TRACE_ID      `DCM_TLAIDTABLEDESC_BSPDCMID_RESET_VALUE
`define DCM_NSP_TRACE_ID      `DCM_TLAIDTABLEDESC_NSPDCMID_RESET_VALUE
`define DCM_NCD_TRACE_ID      `DCM_TLAIDTABLEDESC_NCDDCMID_RESET_VALUE
`define DCM_ETH_TRACE_ID      `DCM_TLAIDTABLEDESC_ETHDCMID_RESET_VALUE
`define DCM_UHD_TRACE_ID      `DCM_TLAIDTABLEDESC_UHDDCMID_RESET_VALUE
`define DCM_PXC_TRACE_ID      `DCM_TLAIDTABLEDESC_PXCDCMID_RESET_VALUE
`define DCM_NMP_TRACE_ID      `DCM_TLAIDTABLEDESC_NMPDCMID_RESET_VALUE
`define DCM_SPQ_TRACE_ID      `DCM_TLAIDTABLEDESC_SPQDCMID_RESET_VALUE
`define DCM_NCC_TRACE_ID      `DCM_TLAIDTABLEDESC_NCCDCMID_RESET_VALUE
`define DCM_CDE_TRACE_ID      `DCM_TLAIDTABLEDESC_CDEDCMID_RESET_VALUE
`define DCM_LKE_TRACE_ID      `DCM_TLAIDTABLEDESC_LKEDCMID_RESET_VALUE
`define DCM_MCE_TRACE_ID      `DCM_TLAIDTABLEDESC_MCEDCMID_RESET_VALUE
`define DCM_DPE_TRACE_ID      `DCM_TLAIDTABLEDESC_DPEDCMID_RESET_VALUE
`define DCM_NCB_TRACE_ID      `DCM_TLAIDTABLEDESC_NCBDCMID_RESET_VALUE
`define DCM_TRE_TRACE_ID      `DCM_TLAIDTABLEDESC_TREDCMID_RESET_VALUE
`define DCM_NAP_TRACE_ID      `DCM_TLAIDTABLEDESC_NAPDCMID_RESET_VALUE
`define DCM_IDT_TRACE_ID      `DCM_TLAIDTABLEDESC_IDTDCMID_RESET_VALUE
`define DCM_CCI_TRACE_ID      `DCM_TLAIDTABLEDESC_CCIDCMID_RESET_VALUE
`define DCM_SVN_TRACE_ID      `DCM_TLAIDTABLEDESC_SVNDCMID_RESET_VALUE
`define DCM_FTN_TRACE_ID      `DCM_TLAIDTABLEDESC_FTNDCMID_RESET_VALUE
`define DCM_XBF_TRACE_ID      `DCM_TLAIDTABLEDESC_XBFDCMID_RESET_VALUE
`define DCM_XBA_TRACE_ID      `DCM_TLAIDTABLEDESC_XBADCMID_RESET_VALUE
`define DCM_NSI_TRACE_ID      `DCM_TLAIDTABLEDESC_NSIDCMID_RESET_VALUE

`endif
