.PHONY: run clean
run:  clean
	ncverilog -sv -f verif_super.f +define+SIM_TOP=testbench -nocopyright -sv +define+NCV_SIMULATOR -q -licqueue -svseed 754 +ntb_random_seed=754 -l sim.log testbench.sv +log_level=5 +waves +access+r
#	qrsh -cwd -V -b y -j y -q all.q ncverilog -sv -f verif.f +define+SIM_TOP=testbench -nocopyright -sv +define+NCV_SIMULATOR -q -licqueue -svseed 6989 +ntb_random_seed=6989 -l sim.log testbench.sv

# TBD: get below working...
tb2:
	ncverilog -sv -f verif.f +define+SIM_TOP=testbench -nocopyright -sv +define+NCV_SIMULATOR -q -licqueue -svseed 754 +ntb_random_seed=754 -l sim.log test_driver.v +log_level=2 +waves +access+r

clean:
	\rm -fr INCA_libs sim.log ncverilog.key 
