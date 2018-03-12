//////////////////////////////////////////////////////////////////////////////
// Copyright 2014, Cisco Systems, Inc.
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
// file:  PowerCtl.vh
//
// description:  This header file describes the POWER_CTL bus that will go to
// every memory in order to turn on different features or modes, such as
// enabling the light sleep feature or putting the memory into shutdown mode.
//
// $Id: PowerCtl.vh,v 2.2 2014/06/04 01:47:48 gwolski Exp $
//
//////////////////////////////////////////////////////////////////////////////

`ifndef __POWERCTL_VH__
`define __POWERCTL_VH__

`define POWER_CTL_BUS_MSB      4
`define POWER_CTL_BUS_LSB      0
`define POWER_CTL_BUS_RANGE    4:0
`define POWER_CTL_BUS_SIZE     5

// light sleep
`define POWER_CTL_BUS_LS_RANGE 0

// deep sleep
`define POWER_CTL_BUS_DS_RANGE 1

// shutdown
`define POWER_CTL_BUS_SD_RANGE 2

// low voltage operation
`define POWER_CTL_BUS_LV_RANGE 3

`define POWER_CTL_BUS_TSBDISABLE_RANGE 4

`define POWER_CTL_DISABLE_FEATURES `POWER_CTL_BUS_SIZE'd0

`endif // __POWERCTL_VH__

