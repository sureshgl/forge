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
//  File Name:          TopDescCepDefines.vh
//
//  Description:        This file contains macro definitions which are
//  required in Cep related files
//  
//--------------------------------------------------------------------------
//

`ifdef CRAY_FOR_DOPPLERE
`else

// macros for field cap_BusIn.elamViewEnable0
`define CAP_BUSIN_ELAMVIEWENABLE0_RANGE                             113:113
`define CAP_BUSIN_ELAMVIEWENABLE0_MSB                                   113
`define CAP_BUSIN_ELAMVIEWENABLE0_LSB                                   113
`define CAP_BUSIN_ELAMVIEWENABLE0_WIDTH                                   1
`define CAP_BUSIN_ELAMVIEWENABLE0_REL_RANGE                         113:113
`define CAP_BUSIN_ELAMVIEWENABLE0_REL_MSB                               113
`define CAP_BUSIN_ELAMVIEWENABLE0_REL_LSB                               113
`define CAP_BUSIN_ELAMVIEWENABLE0_RESET_VALUE                          1'h0

// macros with short names for field cap_BusIn.elamViewEnable0
`define CAP_BSIN_ELMVWENBL0_RANGE                                   113:113
`define CAP_BSIN_ELMVWENBL0_MSB                                         113
`define CAP_BSIN_ELMVWENBL0_LSB                                         113
`define CAP_BSIN_ELMVWENBL0_WIDTH                                         1
`define CAP_BSIN_ELMVWENBL0_RESET_VALUE                                1'h0

//FieldType - ControlField 
// software : 	 read = true	 write = true	
// hardware : 	 read = true	 write = false	
// macros for field cap_BusIn.elamSelect0
`define CAP_BUSIN_ELAMSELECT0_RANGE                                 117:114
`define CAP_BUSIN_ELAMSELECT0_MSB                                       117
`define CAP_BUSIN_ELAMSELECT0_LSB                                       114
`define CAP_BUSIN_ELAMSELECT0_WIDTH                                       4
`define CAP_BUSIN_ELAMSELECT0_REL_RANGE                             117:114
`define CAP_BUSIN_ELAMSELECT0_REL_MSB                                   117
`define CAP_BUSIN_ELAMSELECT0_REL_LSB                                   114
`define CAP_BUSIN_ELAMSELECT0_RESET_VALUE                              4'h0

// macros with short names for field cap_BusIn.elamSelect0
`define CAP_BSIN_ELMSLCT0_RANGE                                     117:114
`define CAP_BSIN_ELMSLCT0_MSB                                           117
`define CAP_BSIN_ELMSLCT0_LSB                                           114
`define CAP_BSIN_ELMSLCT0_WIDTH                                           4
`define CAP_BSIN_ELMSLCT0_RESET_VALUE                                  4'h0

//FieldType - ControlField 
// software : 	 read = true	 write = true	
// hardware : 	 read = true	 write = false	
// macros for field cap_BusIn.elamCtlViewEnable0
`define CAP_BUSIN_ELAMCTLVIEWENABLE0_RANGE                          118:118
`define CAP_BUSIN_ELAMCTLVIEWENABLE0_MSB                                118
`define CAP_BUSIN_ELAMCTLVIEWENABLE0_LSB                                118
`define CAP_BUSIN_ELAMCTLVIEWENABLE0_WIDTH                                1
`define CAP_BUSIN_ELAMCTLVIEWENABLE0_REL_RANGE                      118:118
`define CAP_BUSIN_ELAMCTLVIEWENABLE0_REL_MSB                            118
`define CAP_BUSIN_ELAMCTLVIEWENABLE0_REL_LSB                            118
`define CAP_BUSIN_ELAMCTLVIEWENABLE0_RESET_VALUE                       1'h0

// macros with short names for field cap_BusIn.elamCtlViewEnable0
`define CAP_BSIN_ELMCTLVWENBL0_RANGE                                118:118
`define CAP_BSIN_ELMCTLVWENBL0_MSB                                      118
`define CAP_BSIN_ELMCTLVWENBL0_LSB                                      118
`define CAP_BSIN_ELMCTLVWENBL0_WIDTH                                      1
`define CAP_BSIN_ELMCTLVWENBL0_RESET_VALUE                             1'h0

//FieldType - ControlField 
// software : 	 read = true	 write = true	
// hardware : 	 read = true	 write = false	
// macros for field cap_BusIn.elamCtlSelect0
`define CAP_BUSIN_ELAMCTLSELECT0_RANGE                              121:119
`define CAP_BUSIN_ELAMCTLSELECT0_MSB                                    121
`define CAP_BUSIN_ELAMCTLSELECT0_LSB                                    119
`define CAP_BUSIN_ELAMCTLSELECT0_WIDTH                                    3
`define CAP_BUSIN_ELAMCTLSELECT0_REL_RANGE                          121:119
`define CAP_BUSIN_ELAMCTLSELECT0_REL_MSB                                121
`define CAP_BUSIN_ELAMCTLSELECT0_REL_LSB                                119
`define CAP_BUSIN_ELAMCTLSELECT0_RESET_VALUE                           3'h0

// macros with short names for field cap_BusIn.elamCtlSelect0
`define CAP_BSIN_ELMCTLSLCT0_RANGE                                  121:119
`define CAP_BSIN_ELMCTLSLCT0_MSB                                        121
`define CAP_BSIN_ELMCTLSLCT0_LSB                                        119
`define CAP_BSIN_ELMCTLSLCT0_WIDTH                                        3
`define CAP_BSIN_ELMCTLSLCT0_RESET_VALUE                               3'h0

//FieldType - ControlField 
// software : 	 read = true	 write = true	
// hardware : 	 read = true	 write = false	
// macros for field cap_BusIn.elamCtlViewEnable1
`define CAP_BUSIN_ELAMCTLVIEWENABLE1_RANGE                          122:122
`define CAP_BUSIN_ELAMCTLVIEWENABLE1_MSB                                122
`define CAP_BUSIN_ELAMCTLVIEWENABLE1_LSB                                122
`define CAP_BUSIN_ELAMCTLVIEWENABLE1_WIDTH                                1
`define CAP_BUSIN_ELAMCTLVIEWENABLE1_REL_RANGE                      122:122
`define CAP_BUSIN_ELAMCTLVIEWENABLE1_REL_MSB                            122
`define CAP_BUSIN_ELAMCTLVIEWENABLE1_REL_LSB                            122
`define CAP_BUSIN_ELAMCTLVIEWENABLE1_RESET_VALUE                       1'h0

// macros with short names for field cap_BusIn.elamCtlViewEnable1
`define CAP_BSIN_ELMCTLVWENBL1_RANGE                                122:122
`define CAP_BSIN_ELMCTLVWENBL1_MSB                                      122
`define CAP_BSIN_ELMCTLVWENBL1_LSB                                      122
`define CAP_BSIN_ELMCTLVWENBL1_WIDTH                                      1
`define CAP_BSIN_ELMCTLVWENBL1_RESET_VALUE                             1'h0

//FieldType - ControlField 
// software : 	 read = true	 write = true	
// hardware : 	 read = true	 write = false	
// macros for field cap_BusIn.elamCtlSelect1
`define CAP_BUSIN_ELAMCTLSELECT1_RANGE                              125:123
`define CAP_BUSIN_ELAMCTLSELECT1_MSB                                    125
`define CAP_BUSIN_ELAMCTLSELECT1_LSB                                    123
`define CAP_BUSIN_ELAMCTLSELECT1_WIDTH                                    3
`define CAP_BUSIN_ELAMCTLSELECT1_REL_RANGE                          125:123
`define CAP_BUSIN_ELAMCTLSELECT1_REL_MSB                                125
`define CAP_BUSIN_ELAMCTLSELECT1_REL_LSB                                123
`define CAP_BUSIN_ELAMCTLSELECT1_RESET_VALUE                           3'h0

// macros with short names for field cap_BusIn.elamCtlSelect1
`define CAP_BSIN_ELMCTLSLCT1_RANGE                                  125:123
`define CAP_BSIN_ELMCTLSLCT1_MSB                                        125
`define CAP_BSIN_ELMCTLSLCT1_LSB                                        123
`define CAP_BSIN_ELMCTLSLCT1_WIDTH                                        3
`define CAP_BSIN_ELMCTLSLCT1_RESET_VALUE                               3'h0

// macros for field cap_BusOut.elamData0
`define CAP_BUSOUT_ELAMDATA0_RANGE                                  258:131
`define CAP_BUSOUT_ELAMDATA0_MSB                                        258
`define CAP_BUSOUT_ELAMDATA0_LSB                                        131
`define CAP_BUSOUT_ELAMDATA0_WIDTH                                      128
`define CAP_BUSOUT_ELAMDATA0_REL_RANGE                              258:131
`define CAP_BUSOUT_ELAMDATA0_REL_MSB                                    258
`define CAP_BUSOUT_ELAMDATA0_REL_LSB                                    131
`define CAP_BUSOUT_ELAMDATA0_RESET_VALUE                             128'h0

// macros with short names for field cap_BusOut.elamData0
`define CAP_BSOT_ELMDT0_RANGE                                       258:131
`define CAP_BSOT_ELMDT0_MSB                                             258
`define CAP_BSOT_ELMDT0_LSB                                             131
`define CAP_BSOT_ELMDT0_WIDTH                                           128
`define CAP_BSOT_ELMDT0_RESET_VALUE                                  128'h0

//FieldType - ControlField 
// software : 	 read = true	 write = true	
// hardware : 	 read = true	 write = false	
// macros for field cap_BusOut.elamCtl0
`define CAP_BUSOUT_ELAMCTL0_RANGE                                   276:259
`define CAP_BUSOUT_ELAMCTL0_MSB                                         276
`define CAP_BUSOUT_ELAMCTL0_LSB                                         259
`define CAP_BUSOUT_ELAMCTL0_WIDTH                                        18
`define CAP_BUSOUT_ELAMCTL0_REL_RANGE                               276:259
`define CAP_BUSOUT_ELAMCTL0_REL_MSB                                     276
`define CAP_BUSOUT_ELAMCTL0_REL_LSB                                     259
`define CAP_BUSOUT_ELAMCTL0_RESET_VALUE                               18'h0

// macros with short names for field cap_BusOut.elamCtl0
`define CAP_BSOT_ELMCTL0_RANGE                                      276:259
`define CAP_BSOT_ELMCTL0_MSB                                            276
`define CAP_BSOT_ELMCTL0_LSB                                            259
`define CAP_BSOT_ELMCTL0_WIDTH                                           18
`define CAP_BSOT_ELMCTL0_RESET_VALUE                                  18'h0

//FieldType - ControlField 
// software : 	 read = true	 write = true	
// hardware : 	 read = true	 write = false	
// macros for field cap_BusOut.elamCtl1
`define CAP_BUSOUT_ELAMCTL1_RANGE                                   294:277
`define CAP_BUSOUT_ELAMCTL1_MSB                                         294
`define CAP_BUSOUT_ELAMCTL1_LSB                                         277
`define CAP_BUSOUT_ELAMCTL1_WIDTH                                        18
`define CAP_BUSOUT_ELAMCTL1_REL_RANGE                               294:277
`define CAP_BUSOUT_ELAMCTL1_REL_MSB                                     294
`define CAP_BUSOUT_ELAMCTL1_REL_LSB                                     277
`define CAP_BUSOUT_ELAMCTL1_RESET_VALUE                               18'h0

// macros with short names for field cap_BusOut.elamCtl1
`define CAP_BSOT_ELMCTL1_RANGE                                      294:277
`define CAP_BSOT_ELMCTL1_MSB                                            294
`define CAP_BSOT_ELMCTL1_LSB                                            277
`define CAP_BSOT_ELMCTL1_WIDTH                                           18
`define CAP_BSOT_ELMCTL1_RESET_VALUE                                  18'h0

// macros for field cap_BusIn.wordEnN
`define CAP_BUSIN_WORDENN_RANGE                                     135:128
`define CAP_BUSIN_WORDENN_MSB                                           135
`define CAP_BUSIN_WORDENN_LSB                                           128
`define CAP_BUSIN_WORDENN_WIDTH                                           8
`define CAP_BUSIN_WORDENN_REL_RANGE                                 135:128
`define CAP_BUSIN_WORDENN_REL_MSB                                       135
`define CAP_BUSIN_WORDENN_REL_LSB                                       128
`define CAP_BUSIN_WORDENN_RESET_VALUE                                  8'h0

// macros for field cap_BusIn.topBit
`define CAP_BUSIN_TOPBIT_RANGE                                      164:164
`define CAP_BUSIN_TOPBIT_MSB                                            164
`define CAP_BUSIN_TOPBIT_LSB                                            164
`define CAP_BUSIN_TOPBIT_WIDTH                                            1
`define CAP_BUSIN_TOPBIT_REL_RANGE                                  164:164
`define CAP_BUSIN_TOPBIT_REL_MSB                                        164
`define CAP_BUSIN_TOPBIT_REL_LSB                                        164
`define CAP_BUSIN_TOPBIT_RESET_VALUE                                   1'h0

// macros for field cap_BusOut.topBit
`define CAP_BUSOUT_TOPBIT_RANGE                                     295:295
`define CAP_BUSOUT_TOPBIT_MSB                                           295
`define CAP_BUSOUT_TOPBIT_LSB                                           295
`define CAP_BUSOUT_TOPBIT_WIDTH                                           1
`define CAP_BUSOUT_TOPBIT_REL_RANGE                                 295:295
`define CAP_BUSOUT_TOPBIT_REL_MSB                                       295
`define CAP_BUSOUT_TOPBIT_REL_LSB                                       295
`define CAP_BUSOUT_TOPBIT_RESET_VALUE                                  1'h0


///////////////////////
// Macro's for external ram (emulation)
// macros for register cap_BusIn
//FieldType - ControlField 
// software : 	 read = true	 write = true	
// hardware : 	 read = true	 write = false	
// macros for field cap_BusIn.emulExtRam
`define CAP_BUSIN_EMULEXTRAM_RANGE                                   2484:0
`define CAP_BUSIN_EMULEXTRAM_MSB                                       2484
`define CAP_BUSIN_EMULEXTRAM_LSB                                          0
`define CAP_BUSIN_EMULEXTRAM_WIDTH                                     2485
`define CAP_BUSIN_EMULEXTRAM_REL_RANGE                               2484:0
`define CAP_BUSIN_EMULEXTRAM_REL_MSB                                   2484
`define CAP_BUSIN_EMULEXTRAM_REL_LSB                                      0
`define CAP_BUSIN_EMULEXTRAM_RESET_VALUE                            2485'h0

// macros with short names for field cap_BusIn.emulExtRam
`define CAP_BSIN_EMLEXTRM_RANGE                                      2484:0
`define CAP_BSIN_EMLEXTRM_MSB                                          2484
`define CAP_BSIN_EMLEXTRM_LSB                                             0
`define CAP_BSIN_EMLEXTRM_WIDTH                                        2485
`define CAP_BSIN_EMLEXTRM_RESET_VALUE                               2485'h0

//FieldType - ControlField 
// software : 	 read = true	 write = true	
// hardware : 	 read = true	 write = false	
// macros for field cap_BusIn.topBitEmul
`define CAP_BUSIN_TOPBITEMUL_RANGE                                2485:2485
`define CAP_BUSIN_TOPBITEMUL_MSB                                       2485
`define CAP_BUSIN_TOPBITEMUL_LSB                                       2485
`define CAP_BUSIN_TOPBITEMUL_WIDTH                                        1
`define CAP_BUSIN_TOPBITEMUL_REL_RANGE                            2485:2485
`define CAP_BUSIN_TOPBITEMUL_REL_MSB                                   2485
`define CAP_BUSIN_TOPBITEMUL_REL_LSB                                   2485
`define CAP_BUSIN_TOPBITEMUL_RESET_VALUE                               1'h0

// macros with short names for field cap_BusIn.topBitEmul
`define CAP_BSIN_TPBTEML_RANGE                                    2485:2485
`define CAP_BSIN_TPBTEML_MSB                                           2485
`define CAP_BSIN_TPBTEML_LSB                                           2485
`define CAP_BSIN_TPBTEML_WIDTH                                            1
`define CAP_BSIN_TPBTEML_RESET_VALUE                                   1'h0

// macros for register cap_BusOut
//FieldType - ControlField 
// software : 	 read = true	 write = true	
// hardware : 	 read = true	 write = false	
// macros for field cap_BusOut.emulExtRam
`define CAP_BUSOUT_EMULEXTRAM_RANGE                                  3519:0
`define CAP_BUSOUT_EMULEXTRAM_MSB                                      3519
`define CAP_BUSOUT_EMULEXTRAM_LSB                                         0
`define CAP_BUSOUT_EMULEXTRAM_WIDTH                                    3520
`define CAP_BUSOUT_EMULEXTRAM_REL_RANGE                              3519:0
`define CAP_BUSOUT_EMULEXTRAM_REL_MSB                                  3519
`define CAP_BUSOUT_EMULEXTRAM_REL_LSB                                     0
`define CAP_BUSOUT_EMULEXTRAM_RESET_VALUE                           3520'h0

// macros with short names for field cap_BusOut.emulExtRam
`define CAP_BSOT_EMLEXTRM_RANGE                                      3519:0
`define CAP_BSOT_EMLEXTRM_MSB                                          3519
`define CAP_BSOT_EMLEXTRM_LSB                                             0
`define CAP_BSOT_EMLEXTRM_WIDTH                                        3520
`define CAP_BSOT_EMLEXTRM_RESET_VALUE                               3520'h0

//FieldType - ControlField 
// software : 	 read = true	 write = true	
// hardware : 	 read = true	 write = false	
// macros for field cap_BusOut.topBitEmul
`define CAP_BUSOUT_TOPBITEMUL_RANGE                               3520:3520
`define CAP_BUSOUT_TOPBITEMUL_MSB                                      3520
`define CAP_BUSOUT_TOPBITEMUL_LSB                                      3520
`define CAP_BUSOUT_TOPBITEMUL_WIDTH                                       1
`define CAP_BUSOUT_TOPBITEMUL_REL_RANGE                           3520:3520
`define CAP_BUSOUT_TOPBITEMUL_REL_MSB                                  3520
`define CAP_BUSOUT_TOPBITEMUL_REL_LSB                                  3520
`define CAP_BUSOUT_TOPBITEMUL_RESET_VALUE                              1'h0

// macros with short names for field cap_BusOut.topBitEmul
`define CAP_BSOT_TPBTEML_RANGE                                    3520:3520
`define CAP_BSOT_TPBTEML_MSB                                           3520
`define CAP_BSOT_TPBTEML_LSB                                           3520
`define CAP_BSOT_TPBTEML_WIDTH                                            1
`define CAP_BSOT_TPBTEML_RESET_VALUE                                   1'h0

`endif

