#!/bin/csh -f
$PROJECT_ROOT/f32/bin/search.pl -a -f $PROJECT_ROOT/f32/${subchip}/rtl/${subchip}.vf -f $PROJECT_ROOT/f32/${subchip}/rtl/${subchip}_ip.vf -f $PROJECT_ROOT/f32/f32_top/rtl/f32_avago_lib.vf | sort -u | grep -v “\-f” | grep "\.vh" | tee ${subchip}/${subchip}_rtl.vf ;
$PROJECT_ROOT/f32/bin/search.pl -a -f $PROJECT_ROOT/f32/${subchip}/rtl/${subchip}_ip.vf -f $PROJECT_ROOT/f32/f32_top/rtl/f32_avago_lib.vf | sort -u | grep -v "\-f" | grep -v "\.vh" | tee --append ${subchip}/${subchip}_rtl.vf
$PROJECT_ROOT/f32/bin/search.pl -a -f $PROJECT_ROOT/f32/${subchip}/rtl/${subchip}.vf | sort -u | grep -v "\-f" | grep -v "\.vh" | tee --append ${subchip}/${subchip}_rtl.vf
