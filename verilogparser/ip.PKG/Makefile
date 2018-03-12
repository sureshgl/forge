default: all_all

everything: clean all_all all_no_enc ibm_cu-32hp arm_tsmc40g scaled_40nm scaled_28nm

tb:
	  $(MAKE) -C infra/verif || exit 1;

all_all:
	../memoverse/infra/bin/obfuscate_params.pl -v all -t all     -a all -p all -f syn-enc -fvc

all_no_enc:
	../memoverse/infra/bin/obfuscate_params.pl -v all -t all     -a all -p all -f syn -fvc

ibm_cu-32hp: tb
	../memoverse/infra/bin/obfuscate_params.pl -v ibm -t cu-32hp -a all -p all

marvell_tsmc28hpm: tb
	../memoverse/infra/bin/obfuscate_params.pl -v marvell -t tsmc28hpm -a all -p all

ibm_cu32hp: tb
	../memoverse/infra/bin/obfuscate_params.pl -v ibm -t cu32hp -a all -p all

arm_tsmc40g: tb
	../memoverse/infra/bin/obfuscate_params.pl -v arm -t tsmc40g -a all -p all

scaled_40nm: tb
	../memoverse/infra/bin/obfuscate_params.pl -v scaled -t 40nm -a all -p all

clean:
	\rm -fr ../ip_obfuscated ../ip_encrypted infra/verif/INCA_libs
