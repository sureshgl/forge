// $Id: RAMWRAP.vh,v 2.10 2014/05/27 23:55:16 bli4 Exp $
//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2006, Cisco Systems, Inc.
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
//
// File          : RAMWRAP.vh
// Author        : Jane T. Lear (jalear\@cisco.com
// Description   : Standard macros for RAMWRAP, TCAMWRAP and EDRAMWRAP
//                 varieties.
//
//////////////////////////////////////////////////////////////////////////////

// BEWARE that this file might be inlined by vpp for .lib generation
// and therefore can only use `ifdef, `else, `endif, and `define .
// DO NOT use `ifndef or `elsif

`ifdef _RAMWRAP_VH_
`else
 `define _RAMWRAP_VH_

`ifdef EMULATION     

 `define TCAMWRAP_PL_CLK_PORTS input FASTCLK, input FASTCLK2X ,
 `define TCAMWRAP_PL_CLK_PORTS_INST .FASTCLK (FASTCLK), .FASTCLK2X (FASTCLK2X) ,
 `define TCAMWRAP_1RWS_CLK_PORTS input FASTCLK, input FASTCLK2X ,
 `define TCAMWRAP_1RWS_CLK_PORTS_INST .FASTCLK (FASTCLK), .FASTCLK2X (FASTCLK2X) ,

`else

 `define TCAMWRAP_PL_CLK_PORTS 
 `define TCAMWRAP_PL_CLK_PORTS_INST
 `define TCAMWRAP_1RWS_CLK_PORTS 
 `define TCAMWRAP_1RWS_CLK_PORTS_INST

`endif

// Eventually this might be tech-specific
// but you must use full `ifdef nesting to itemize
// all the cases.  otherwise vpp will not handle it.
`define EDRAMWRAP_REFPER_WIDTH 16

`ifdef avago_av28m
 `define EDRAMWRAP_BANKSIZE 8192
`else
 `define EDRAMWRAP_BANKSIZE 2048
`endif

`include "PowerCtl.vh"

`endif //  `ifdef _RAMWRAP_VH_
      
