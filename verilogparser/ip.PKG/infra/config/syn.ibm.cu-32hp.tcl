# ----------------------------------------------------------------------
eval [list lappend HDL_SEARCH_PATH] { \
/auto/libraries/ibm/ibm_cu32hp/1290215997/edramf_v001/verilog/wrappers \
/auto/libraries/ibm/ibm_cu32hp/1287611519/memory_support_9t_v002/verilog/rtl \
/auto/libraries/ibm/ibm_cu32hp/1287611519/sram1d_v001/verilog/wrappers \
/auto/libraries/ibm/ibm_cu32hp/mica_compiler_libs/edramf_v001/verilog/wrappers \
/auto/libraries/ibm/ibm_cu32hp/mica_compiler_libs/edramf_v001/verilog/beh \
/auto/libraries/ibm/ibm_cu32hp/mica_compiler_libs/memory_support_9t_v002_sram/verilog/rtl \
/auto/libraries/ibm/ibm_cu32hp/mica_compiler_libs/sram1d_v001/verilog/wrappers \
/auto/libraries/ibm/ibm_cu32hp/mica_compiler_libs/sram1d_v001/verilog/beh \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/technologyfiles_v001/verilog/beh \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/edramf_v001/verilog/beh \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/sc_9t_uvt_v002/verilog/beh \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/sc_9t_hvt_v002/verilog/beh \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/sc_9t_mvt_v002/verilog/beh \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/asic_support_9t_v002/verilog/beh \
/auto/libraries/ibm/ibm_cu32hp/sram2s/sram2s_v001/verilog/wrappers \
/auto/libraries/ibm/ibm_cu32hp/sram2s/sram2s_v001/verilog/beh \
/auto/libraries/ibm/ibm_cu32hp/sram2s/memory_support_9t_v002/verilog/rtl \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/memory_support_9t_v002/verilog/wrappers \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/memory_support_9t_v002/verilog/rtl \
                                      }

eval [list lappend LIB_SEARCH_PATH] { \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/technologyfiles_v001/lib/IBM_CU32HP_WLM.lib \
/auto/libraries/ibm/ibm_cu32hp/mica_compiler_libs/edramf_v001/lib/edramf_32soi_IBMMICAUVTLIB_tt_nominal_nom_0p800v-0p950v-VDD-VCS_50c_mxs.lib \
/auto/libraries/ibm/ibm_cu32hp/mica_compiler_libs/sram1d_v001/lib/sram1d_32soi_SRAM1D_tt_nominal_nom_0p800v-0p950v-VDD-VCS_50c_mxs.lib \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/asic_support_9t_v002/lib/asic_support_9t_32soi_STD_ss_nominal_max_0p800v_m40c_mxs.lib \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/sc_9t_mvt_v002/lib/sc9_32soi_base_mvt_ss_nominal_max_0p80v_m40c_mxs.lib \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/sc_9t_mvt_v002/lib/sc9_32soi_asic_mvt_ss_nominal_max_0p80v_m40c_mxs.lib \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/sc_9t_hvt_v002/lib/sc9_32soi_asic_hvt_ss_nominal_max_0p80v_m40c_mxs.lib \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/sc_9t_hvt_v002/lib/sc9_32soi_base_hvt_ss_nominal_max_0p80v_m40c_mxs.lib \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/sc_9t_hvt_v002/lib/sc9_32soi_STD_hvt_ss_nominal_max_0p80v_m40c_mxs.lib \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/memory_support_9t_v001/lib/memory_support_9t_32soi_STD_ss_nominal_max_0p850v_125c_mxs.lib \
/auto/libraries/ibm/ibm_cu32hp/sram2s/sram2s_v001/lib/sram2s_32soi_DACHUANG_tt_nominal_nom_0p800v-0p950v-VDD-VCS_50c_mxs.lib \
/auto/libraries/ibm/ibm_cu32hp/1288547002/sram1d_v001/lib/sram1d_32soi_DACHUANG_tt_nominal_nom_0p800v-0p950v-VDD-VCS_50c_mxs.lib \
/auto/libraries/ibm/ibm_cu32hp/1287611519/sram1d_v001/lib/sram1d_32soi_K15_tt_nominal_nom_0p800v-0p950v-VDD-VCS_50c_mxs.lib \
/auto/libraries/ibm/ibm_cu32hp/sram1d_tdm_wrapper/1302734194/sram1d_v001/lib/sram1d_32soi_DACHUANG_tt_nominal_nom_0p800v-0p950v-VDD-VCS_50c_mxs.lib
}

eval [list lappend SYN_LIB_FILES ] { \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/sc_9t_uvt_v002/lib/sc9_32soi_base_uvt_ss_nominal_max_0p80v_m40c_mxs.lib \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/sc_9t_uvt_v002/lib/sc9_32soi_asic_uvt_ss_nominal_max_0p80v_m40c_mxs.lib \
/auto/libraries/ibm/ibm_cu32hp/rel1.0/asic_support_9t_v002/lib/asic_support_9t_32soi_STD_ss_nominal_max_0p800v_m40c_mxs.lib \
                                     }
