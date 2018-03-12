// $Id: log2.vh,v 2.3 2009/07/07 20:10:22 abbanerj Exp $
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
// File          : log2.vh
// Author        : Jane T. Lear (jalear@cisco.com)
// Description   : Function Macros
//
//////////////////////////////////////////////////////////////////////////////

`ifndef _LOG2_VH_
`define _LOG2_VH_
`define MACRO_log2 function integer log2; input [31:0] value; reg [32:0] v; begin v = value-1; for (log2=0; v>0; log2=log2+1) v = v>>1; end endfunction
`endif
