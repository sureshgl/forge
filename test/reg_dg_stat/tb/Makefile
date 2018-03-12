BSUB_CMD = bsub -I -P misc.p -q interactive 
VCS_BSUB = $(BSUB_CMD) -R "rusage[vcs=1:duration=6]"
VCS_CMD  = $(VCS_BSUB) vcs -sverilog -debug_pp -full64 -F filelist +lint=TFIPC-L -l vcs.log +vcs+lic+wait -timescale=1ns/10ps
FILELIST = filelist

.PHONY: clean vcs run dve 

clean:
	\rm -fr vcs.log sim.log simv.daidir csrc simv DVEfiles ucli.key *.vpd

vcs: 
	$(VCS_CMD)

run:
	$(VCS_BSUB) ./simv -l sim.log +vcs+lic+wait +waves $(RUNTIME_ARGS) +testName=$(TESTNAME)

dve:
	$(BSUB_CMD) dve -full64 & 

