//--------------------------------------------------------------------------
//  Cisco Systems Inc.                                                    
//                                                                        
//  Copyright (c) 2013 Cisco Systems                                      
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
//  File Name:          DGlobal.vh
//
//  Description:        This file contains macro definitions which are common
//                      top DopplerD, DopplerG and Cray
//
//--------------------------------------------------------------------------
//


`ifndef __DGLOBAL_VH__
`define __DGLOBAL_VH__
`include "TopDescCepDefines.vh"
// 64B Data Word  
`define TOP_64B_DATA_MSB                           63         
`define TOP_64B_DATA_LSB                           0          
`define TOP_64B_DATA_SIZE                          64         
`define TOP_64B_DATA_RANGE                         63 : 0

// Access Size CPU accesses 
`define TOP_CPU_ACCESS_MSB                         5          
`define TOP_CPU_ACCESS_LSB                         0          
`define TOP_CPU_ACCESS_SIZE                        6          
`define TOP_CPU_ACCESS_RANGE                       5 : 0

// Debug Data         
`define DGLOBAL_DEBUG_DATA_MSB                         291        
`define DGLOBAL_DEBUG_DATA_LSB                         0          
`define DGLOBAL_DEBUG_DATA_SIZE                        292        
`define DGLOBAL_DEBUG_DATA_RANGE                       291 : 0

`define DGLOBAL_SYSTEM_TIME_MSB                        63
`define DGLOBAL_SYSTEM_TIME_LSB                        0
`define DGLOBAL_SYSTEM_TIME_SIZE                       64
`define DGLOBAL_SYSTEM_TIME_RANGE                      63:0

`define DGLOBAL_INTERRUPT_MSB                        1
`define DGLOBAL_INTERRUPT_LSB                        0
`define DGLOBAL_INTERRUPT_SIZE                       2
`define DGLOBAL_INTERRUPT_RANGE                      1:0



`endif
