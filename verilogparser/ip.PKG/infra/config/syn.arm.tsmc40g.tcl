# ----------------------------------------------------------------------
eval [list lappend HDL_SEARCH_PATH] { \
                                          /auto/libraries/arm/tsmc_40nm/G/verilog/rf_2p_hse  \
                                          /auto/libraries/arm/tsmc_40nm/G/verilog/rf_sp_hde  \
                                          /auto/libraries/arm/tsmc_40nm/G/verilog/rf_sp_hsd  \
                                          /auto/libraries/arm/tsmc_40nm/G/verilog/sram_dp_hde \
                                          /auto/libraries/arm/tsmc_40nm/G/verilog/sram_sp_hde \
                                          /auto/libraries/arm/tsmc_40nm/G/verilog/sram_sp_hsc \
                                      }

eval [list lappend LIB_SEARCH_PATH] { \
                                          /auto/libraries/arm/tsmc_40nm/std_cells/arm/tsmc/cln40g/sc9_base_hvt/r1p1-00eac0/lib \
                                          /auto/proj/users/sree/arm_tsmc_lib_data/40g/lib/rf_2p_hse  \
                                          /auto/proj/users/sree/arm_tsmc_lib_data/40g/lib/rf_sp_hde  \
                                          /auto/proj/users/sree/arm_tsmc_lib_data/40g/lib/rf_sp_hsd  \
                                          /auto/proj/users/sree/arm_tsmc_lib_data/40g/lib/sram_dp_hde \
                                          /auto/proj/users/sree/arm_tsmc_lib_data/40g/lib/sram_sp_hde \
                                          /auto/proj/users/sree/arm_tsmc_lib_data/40g/lib/sram_sp_hsc \
                                      }

eval [list lappend SYN_LIB_FILES ] { \
                                         sc9_cln40g_base_hvt_ss_typical_max_0p81v_m40c.lib \
                                     }

