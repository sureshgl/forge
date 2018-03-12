//////////////////////////////////////////////////////////////////////////////
// Copyright 2012, Cisco Systems, Inc.
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
// file:  MemRdlCommStructs.vh
//
// description:  The NFL block maintains the Netflow Flow Table and
// performs searches on it.  This file defines macros that are used inside
// of the NFL block.
//
// $Id: MemRdlCommStructs.vh,v 1.3 2014/05/27 23:43:15 bli4 Exp $
//
//////////////////////////////////////////////////////////////////////////////

`ifndef __MEMRDLCOMMSTRUCTS_VH__
`define __MEMRDLCOMMSTRUCTS_VH__

`include "Dcm.vh"
`include "PowerCtl.vh"

`define CEP_REFPER_LSB     0
`define CEP_REFPER_SIZE    16
`define CEP_REFPER_MSB     (`CEP_REFPER_LSB + `CEP_REFPER_SIZE - 1)
`define CEP_REFPER_RANGE   `CEP_REFPER_MSB : `CEP_REFPER_LSB

`define CEP_REFBURST_LSB   0
`define CEP_REFBURST_SIZE  4
`define CEP_REFBURST_MSB   (`CEP_REFBURST_LSB + `CEP_REFBURST_SIZE - 1)
`define CEP_REFBURST_RANGE `CEP_REFBURST_MSB : `CEP_REFBURST_LSB

`define CEP_TRANS_SIZE_LSB   0
`define CEP_TRANS_SIZE_SIZE  6
`define CEP_TRANS_SIZE_MSB   (`CEP_TRANS_SIZE_LSB + `CEP_TRANS_SIZE_SIZE - 1)
`define CEP_TRANS_SIZE_RANGE `CEP_TRANS_SIZE_MSB : `CEP_TRANS_SIZE_LSB

typedef struct packed
{
   logic                         read;
   logic                         write;
   logic [19:0]                  address;
   logic [`CEP_TRANS_SIZE_RANGE] totalSize;
   logic [63:0]                  writeData;
   logic                         timeout;
} RdlToMemCpu_t;

typedef struct packed
{
   logic                         accessComplete;
   logic [`CEP_TRANS_SIZE_RANGE] accessSize;
   logic                         readDataValid;
   logic [63:0]                  readData;
} MemToRdlCpu_t;

typedef struct packed
{
   logic protChkDisable;
   logic protOverride;
   logic parIn;
} RdlToMemPar_t;

typedef struct packed
{
   logic        parErr;
   logic        captureEn;
   logic        parOut;
   logic [19:0] protErrAddress;
} MemToRdlPar_t;

typedef struct packed
{
   logic        protChkDisable;
   logic        protOverride;
   logic [12:0] eccIn;
} RdlToMemEcc_t;

typedef struct packed
{
   logic        corErr;
   logic        uncErr;
   logic        captureEn;
   logic [12:0] syndrome;
   logic [19:0] protErrAddress;
} MemToRdlEcc_t;

typedef struct packed
{
   logic       protOverride;
   logic       startBipChk;
   logic [7:0] bipIn;
} RdlToMemBip_t;

typedef struct packed
{
   logic captureEn;
   logic bipErr;
   logic [7:0] syndrome;
} MemToRdlBip_t;

typedef struct packed
{
   logic            read;
   logic            dataViewEn;
   logic [3:0]      dataViewSel;
   logic [1:0]      ctlViewEn;
   logic [1:0][2:0] ctlViewSel;
} RdlToMemFulle_t;

typedef struct packed
{
   logic [`DCM_ELAM_DATA_SLICE_WIDTH-1:0]       dataView;
   logic [1:0][`DCM_ELAM_CNTRL_SLICE_WIDTH-1:0] ctlView;
} MemToRdlFulle_t;

typedef struct packed
{
   logic [1:0]      ctlViewEn;
   logic [1:0][2:0] ctlViewSel;
} RdlToMemCtle_t;

typedef struct packed
{
   logic [1:0][`DCM_ELAM_CNTRL_SLICE_WIDTH-1:0] ctlView;
} MemToRdlCtle_t;

typedef struct packed
{
   logic                        halt;
   logic [`POWER_CTL_BUS_RANGE] powerCtl;

`ifdef EMULATION 
   logic FASTCLK ;
`endif
} RdlToMemCommon_t;

//
// Composed Busses -- including those with only one feature to keep
// hierarchy the same
//

// one feature only

typedef struct packed
{
   RdlToMemCpu_t    cpu;
   RdlToMemCommon_t common;
} RdlToMemCpuBus_t;

typedef struct packed
{
   MemToRdlCpu_t   cpu;
} MemToRdlCpuBus_t;

typedef struct packed
{
   RdlToMemPar_t    prot;
   RdlToMemCommon_t common;
} RdlToMemParBus_t;

typedef struct packed
{
   MemToRdlPar_t   prot;
} MemToRdlParBus_t;

typedef struct packed
{
   RdlToMemEcc_t    prot;
   RdlToMemCommon_t common;
} RdlToMemEccBus_t;

typedef struct packed
{
   MemToRdlEcc_t   prot;
} MemToRdlEccBus_t;

typedef struct packed
{
   RdlToMemBip_t    prot;
   RdlToMemCommon_t common;
} RdlToMemBipBus_t;

typedef struct packed
{
   MemToRdlBip_t   prot;
} MemToRdlBipBus_t;

typedef struct packed
{
   RdlToMemFulle_t  elam;
   RdlToMemCommon_t common;
} RdlToMemFulleBus_t;

typedef struct packed
{
   MemToRdlFulle_t elam;
} MemToRdlFulleBus_t;

typedef struct packed
{
   RdlToMemCtle_t  elam;
   RdlToMemCommon_t common;
} RdlToMemCtleBus_t;

typedef struct packed
{
   MemToRdlCtle_t elam;
} MemToRdlCtleBus_t;

// variations on two features

typedef struct packed
{
   RdlToMemCpu_t    cpu;
   RdlToMemPar_t    prot;
   RdlToMemCommon_t common;
} RdlToMemCpuParBus_t;

typedef struct packed
{
   MemToRdlCpu_t   cpu;
   MemToRdlPar_t   prot;
} MemToRdlCpuParBus_t;

typedef struct packed
{
   RdlToMemCpu_t    cpu;
   RdlToMemEcc_t    prot;
   RdlToMemCommon_t common;
} RdlToMemCpuEccBus_t;

typedef struct packed
{
   MemToRdlCpu_t   cpu;
   MemToRdlEcc_t   prot;
} MemToRdlCpuEccBus_t;

typedef struct packed
{
   RdlToMemCpu_t    cpu;
   RdlToMemBip_t    prot;
   RdlToMemCommon_t common;
} RdlToMemCpuBipBus_t;

typedef struct packed
{
   MemToRdlCpu_t   cpu;
   MemToRdlBip_t   prot;
} MemToRdlCpuBipBus_t;

typedef struct packed
{
   RdlToMemCpu_t    cpu;
   RdlToMemFulle_t  elam;
   RdlToMemCommon_t common;
} RdlToMemCpuFulleBus_t;

typedef struct packed
{
   MemToRdlCpu_t   cpu;
   MemToRdlFulle_t elam;
} MemToRdlCpuFulleBus_t;

typedef struct packed
{
   RdlToMemCpu_t    cpu;
   RdlToMemCtle_t   elam;
   RdlToMemCommon_t common;
} RdlToMemCpuCtleBus_t;

typedef struct packed
{
   MemToRdlCpu_t  cpu;
   MemToRdlCtle_t elam;
} MemToRdlCpuCtleBus_t;

typedef struct packed
{
   RdlToMemPar_t    prot;
   RdlToMemFulle_t  elam;
   RdlToMemCommon_t common;
} RdlToMemParFulleBus_t;

typedef struct packed
{
   MemToRdlPar_t   prot;
   MemToRdlFulle_t elam;
} MemToRdlParFulleBus_t;

typedef struct packed
{
   RdlToMemPar_t    prot;
   RdlToMemCtle_t   elam;
   RdlToMemCommon_t common;
} RdlToMemParCtleBus_t;

typedef struct packed
{
   MemToRdlPar_t   prot;
   MemToRdlCtle_t  elam;
} MemToRdlParCtleBus_t;

typedef struct packed
{
   RdlToMemEcc_t    prot;
   RdlToMemFulle_t  elam;
   RdlToMemCommon_t common;
} RdlToMemEccFulleBus_t;

typedef struct packed
{
   MemToRdlEcc_t   prot;
   MemToRdlFulle_t elam;
} MemToRdlEccFulleBus_t;

typedef struct packed
{
   RdlToMemEcc_t    prot;
   RdlToMemCtle_t   elam;
   RdlToMemCommon_t common;
} RdlToMemEccCtleBus_t;

typedef struct packed
{
   MemToRdlEcc_t  prot;
   MemToRdlCtle_t elam;
} MemToRdlEccCtleBus_t;

typedef struct packed
{
   RdlToMemBip_t    prot;
   RdlToMemFulle_t  elam;
   RdlToMemCommon_t common;
} RdlToMemBipFulleBus_t;

typedef struct packed
{
   MemToRdlBip_t   prot;
   MemToRdlFulle_t elam;
} MemToRdlBipFulleBus_t;

typedef struct packed
{
   RdlToMemBip_t    prot;
   RdlToMemCtle_t   elam;
   RdlToMemCommon_t common;
} RdlToMemBipCtleBus_t;

typedef struct packed
{
   MemToRdlBip_t  prot;
   MemToRdlCtle_t elam;
} MemToRdlBipCtleBus_t;

// variations of all three features

typedef struct packed
{
   RdlToMemCpu_t    cpu;
   RdlToMemPar_t    prot;
   RdlToMemFulle_t  elam;
   RdlToMemCommon_t common;
} RdlToMemCpuParFulleBus_t;

typedef struct packed
{
   MemToRdlCpu_t   cpu;
   MemToRdlPar_t   prot;
   MemToRdlFulle_t elam;
} MemToRdlCpuParFulleBus_t;

typedef struct packed
{
   RdlToMemCpu_t    cpu;
   RdlToMemBip_t    prot;
   RdlToMemFulle_t  elam;
   RdlToMemCommon_t common;
} RdlToMemCpuBipFulleBus_t;

typedef struct packed
{
   MemToRdlCpu_t   cpu;
   MemToRdlBip_t   prot;
   MemToRdlFulle_t elam;
} MemToRdlCpuBipFulleBus_t;

typedef struct packed
{
   RdlToMemCpu_t    cpu;
   RdlToMemEcc_t    prot;
   RdlToMemFulle_t  elam;
   RdlToMemCommon_t common;
} RdlToMemCpuEccFulleBus_t;

typedef struct packed
{
   MemToRdlCpu_t   cpu;
   MemToRdlEcc_t   prot;
   MemToRdlFulle_t elam;
} MemToRdlCpuEccFulleBus_t;

typedef struct packed
{
   RdlToMemCpu_t    cpu;
   RdlToMemPar_t    prot;
   RdlToMemCtle_t  elam;
   RdlToMemCommon_t common;
} RdlToMemCpuParCtleBus_t;

typedef struct packed
{
   MemToRdlCpu_t   cpu;
   MemToRdlPar_t   prot;
   MemToRdlCtle_t  elam;
} MemToRdlCpuParCtleBus_t;

typedef struct packed
{
   RdlToMemCpu_t    cpu;
   RdlToMemBip_t    prot;
   RdlToMemCtle_t   elam;
   RdlToMemCommon_t common;
} RdlToMemCpuBipCtleBus_t;

typedef struct packed
{
   MemToRdlCpu_t   cpu;
   MemToRdlBip_t   prot;
   MemToRdlCtle_t  elam;
} MemToRdlCpuBipCtleBus_t;

typedef struct packed
{
   RdlToMemCpu_t    cpu;
   RdlToMemEcc_t    prot;
   RdlToMemCtle_t   elam;
   RdlToMemCommon_t common;
} RdlToMemCpuEccCtleBus_t;

typedef struct packed
{
   MemToRdlCpu_t   cpu;
   MemToRdlEcc_t   prot;
   MemToRdlCtle_t  elam;
} MemToRdlCpuEccCtleBus_t;

`endif // __MEMRDLCOMMSTRUCTS_VH__
