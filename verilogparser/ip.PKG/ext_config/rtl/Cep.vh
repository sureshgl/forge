////////////////////////////////////////////////////////////////////////////// 
// Copyright 2008, Cisco Systems, Inc. 
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
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Preamble: Originally developed for DopplerD by Steve Kolecki
// Description: define functions to be used to connect to the CapBus.
//
//                              .------.     
//  .-----.          .-----.    |      |    .------.
//  |     |          |     |    | Elam |    |      |
//  | TLA |          | TLA |    | View |    | CAP  |
//  | MEM |          | REG |    | Mux  |    | WRAP |
//  |     |          |     |    |      |    |      |
//  '-----'          '-----'    '------'    '------'
//    | ^              | ^           ^        |  ^
//    | | CapBusOut    | |           |        |  |
//    | '--------------(-+-----------+--------'  |
//    |   CapBusIn     |                         |
//    '----------------+-------------------------'
//
//////////////////////////////////////////////////////////////////////////////

`ifdef __CEPDEFINES_VH__
`else
 `define __CEPDEFINES_VH__ 1

 `include "DGlobal.vh"
 `include "Dcm.vh"

`ifdef EMULATION
   `define FASTCLK_PORT       , input sysClk100
   `define FASTCLK_PORT_INST  , .sysClk100(sysClk100)
   `define CEP_FASTCLK(sigIn) assign sigIn.common.FASTCLK = sysClk100;

   `define CAP_BUS_EFF_IN  `CAP_BUSIN_TOPBITFASTCLK_LSB
   `define CAP_BUS_EFF_OUT `CAP_BUSOUT_TOPBIT_LSB
   `define CAP_BUS_EXT_EFF_IN  `CAP_BUSIN_TOPBITEMUL_LSB
   `define CAP_BUS_EXT_EFF_OUT `CAP_BUSOUT_TOPBITEMUL_LSB
   `define CAP_EMUL_ECAP(sigIn,sigOut,eIn,eOut) \
      wire [`CAP_BUSIN_EMULEXTRAM_MSB-`CAP_BUSIN_EMULEXTRAM_LSB:0] eIn = sigIn[`CAP_BUSIN_EMULEXTRAM_MSB:`CAP_BUSIN_EMULEXTRAM_LSB]; \
      wire [`CAP_BUSOUT_EMULEXTRAM_MSB-`CAP_BUSOUT_EMULEXTRAM_LSB:0] eOut; \
      assign sigOut[`CAP_BUSOUT_EMULEXTRAM_MSB:`CAP_BUSOUT_EMULEXTRAM_LSB] = eOut
`else
   `define FASTCLK_PORT
   `define FASTCLK_PORT_INST
   `define CEP_FASTCLK(sigIn)
   `define CAP_BUS_EFF_IN  `CAP_BUSIN_TOPBIT_LSB
   `define CAP_BUS_EFF_OUT `CAP_BUSOUT_TOPBIT_LSB
   `define CAP_BUS_EXT_EFF_IN  `CAP_BUSIN_TOPBIT_LSB
   `define CAP_BUS_EXT_EFF_OUT `CAP_BUSOUT_TOPBIT_LSB
   `define CAP_EMUL_ECAP(sigIn,sigOut,eIn,eOut) \
      wire [`CAP_BUSIN_EMULEXTRAM_MSB-`CAP_BUSIN_EMULEXTRAM_LSB:0] eIn; \
      wire [`CAP_BUSOUT_EMULEXTRAM_MSB-`CAP_BUSOUT_EMULEXTRAM_LSB:0] eOut
`endif

`define CAP_ACTION_LSB             0
`define CAP_ACTION_SIZE            2
`define CAP_ACTION_MSB             (`CAP_ACTION_LSB + `CAP_ACTION_SIZE - 1)
`define CAP_ACTION_RANGE           `CAP_ACTION_MSB:`CAP_ACTION_LSB
`define CAP_ACTION_READ            2'd0
`define CAP_ACTION_READCLEAR       2'd1
`define CAP_ACTION_FULLWRITE       2'd2
`define CAP_ACTION_MERGEWRITE      2'd3
`define CAP_ACTION_WRITE_BIT       1

// special value for *_access_size to indicate write to last word of memory
`define CAP_END_OF_MEMORY_1WORD  6'd63
`define CAP_END_OF_MEMORY_2WORDS 6'd62

// help the 32bit externals by letting the keep using the generic EOM
`define CAP_END_OF_MEMORY        `CAP_END_OF_MEMORY_1WORD

`define CAP_ALWAYS_PRESENT_LSB     0
`define CAP_ALWAYS_PRESENT_SIZE    3
`define CAP_ALWAYS_PRESENT_MSB     (`CAP_ALWAYS_PRESENT_LSB + `CAP_ALWAYS_PRESENT_SIZE - 1)
`define CAP_ALWAYS_PRESENT_RANGE   `CAP_ALWAYS_PRESENT_MSB:`CAP_ALWAYS_PRESENT_LSB

`define CAP_CTL_REMAIN_LSB         0
`define CAP_CTL_REMAIN_SIZE        (`CAP_BUSOUT_ELAMCTL0_WIDTH - `CAP_ALWAYS_PRESENT_SIZE)
`define CAP_CTL_REMAIN_MSB         (`CAP_CTL_REMAIN_LSB + `CAP_CTL_REMAIN_SIZE - 1)
`define CAP_CTL_REMAIN_RANGE       `CAP_CTL_REMAIN_MSB:`CAP_CTL_REMAIN_LSB

`endif

