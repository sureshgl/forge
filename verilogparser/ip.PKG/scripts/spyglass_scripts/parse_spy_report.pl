#! /usr/bin/perl
#! /usr/bin/csh

###################################################################################
#	Author:S_Venkataraman 		vensrini@cisco.com  
# version 1.0 Script to parse all the spyglass reports
###################################################################################
#
################################### Main Routine ##################################

my ($rpt_file) = "" ;

my @MESSAGE = (
            "Usage : $0 < report_directory>  \n",
            ) ;
if($ARGV[0])
{
while(@ARGV){
  $_ = shift;
  if($_ =~ /^-h/){
    die "@MESSAGE";
  } else {
	$sourceDir=$_;
  };
};
}
else
	{
	die "@MESSAGE";
	}

%hash=();
%flag=();
#my @allsubchips = < $sourceDir/* > ;
#foreach (@allsubchips) {
#        print "$_ found \n";
#}
open(OUT,">ts_sg_summ.csv");
@allsubchips=();

# RULE LIST FOR ALL SPYGLASS CHECKS
@cdc_struct_rules = ("Ac_unsync01", "Ac_unsync02", "Ac_glitch02", "Clock_sync05", "Clock_sync06", "Clock_sync09", "Reset_sync01", "Reset_sync02", "Reset_sync03");
@cdc_func_rules = ("Ac_cdc01a", "Ac_cdc04a", "Ac_cdc08", "Ac_conv01", "Ac_conv02", "Ac_fifo01", "Ac_handshake01", "Ac_handshake02");
@lint_syn_rules = ("BlockHeader", "InferLatch", "NoAssignX-ML", "STARC02-2.5.1.7", "STARC02-2.5.1.9", "STARC05-2.3.1.6", "W116", "W215", "W216", "W218", "W293", "W362", "W422", "W450L", "W467", "W480", "W481a", "W481b", "W496a", "W496b", "W66", "W69", "W71", "W505", "ResetSynthCheck", "bothedges");
@lint_structure_rules = ("Info_Case_Analysis", "BufClock", "CombLoop", "DuplicateCaseLabel-ML", "FlopClockConstant", "FlopEConst", "FlopSRConst", "LatchFeedback", "STARC02-2.4.1.5");
@lint_connectivity_rules = ("Info_Case_Analysis", "STARC05-2.1.3.1", "UndrivenInTerm-ML", "W110", "checkPinConnectedToSupply", "W123");
@adv_lint_rules = ("Av_fsm01", "Av_fsm02", "Av_fsminf01", "Av_fsminf02", "Av_case01", "Av_case02", "Av_deadcode01", "Av_staticnet01", "Av_bus01", "Av_bus02", "Av_dontcare01", "Av_range01");
@lintall_rules=("Info_Case_Analysis","BufClock","CombLoop","FlopClockConstant","FlopEConst","FlopSRConst","LatchFeedback","InferLatch","NoAssignX-ML","ResetSynthCheck","Info_Case_Analysis","UndrivenInTerm-ML","UndrivenNUnloaded-ML","UnloadedInPort-ML","W164a","W164b","W210","W263","W287b","W287c");
opendir SUBCHIPDIR, $sourceDir;
#Step to get all subchip names assuming directory name is subchip based and skipping dot files
while(defined($subchip=readdir(SUBCHIPDIR))) {
next if $subchip =~ /^\.\.?$/;
next if $subchip =~ /HTML/;
next if $subchip =~ /Run/;
next if $subchip =~ /Final/;
next if $subchip =~ /^console/;
next if $subchip =~ /^\./;
push( @allsubchips,"$subchip");
$rpt_file="$sourceDir\/$subchip/$subchip/lint/lintall/spyglass_reports/moresimple.rpt";
if (-e $rpt_file) {
$rpt_file =~ s/(.*\.gz)\s*$/gzip -dc < $1|/;
#warn ( "# INFO: Parsing $rule in report file: $rpt_file...\n" ) ;
foreach $rule (@lintall_rules)
	{
open(rpt, "$rpt_file") || die "OPEN file : $rpt_file FAILED \n ";
$matches=0;
$errors=0;
$warnings=0;
while(<rpt>)
	{
		if (/$rule/ && /Error/) {
		$matches++;
		$errors++;
		}
		if (/$rule/ && /Warning/) {
		$matches++;
		$warnings++;
		}
	}
		#print "Rule $rule Total: $matches Errors: $errors Warnings: $warnings in $rpt_file\n";
		$hash{$subchip}{$rule}{total}=$matches;
		$hash{$subchip}{$rule}{errors}=$errors;
		$hash{$subchip}{$rule}{warning}=$warnings;
close ( rpt ) ;
	}
	}# file exists condition
else {
	foreach $rule (@cdc_func_rules)
	{
		$hash{$subchip}{$rule}{total}=Err;
		$hash{$subchip}{$rule}{errors}=Err;
		$hash{$subchip}{$rule}{warning}=Err;
	}
	}#else ends creating errro message for file not found
$rpt_file="$sourceDir\/$subchip/$subchip/cdc_block/cdc_struct/spyglass_reports/moresimple.rpt";
if (-e $rpt_file) {
$rpt_file =~ s/(.*\.gz)\s*$/gzip -dc < $1|/;
#warn ( "# INFO: Parsing $rule in report file: $rpt_file...\n" ) ;
foreach $rule (@cdc_struct_rules)
	{
open(rpt, "$rpt_file") || die "OPEN file : $rpt_file FAILED \n ";
$matches=0;
$errors=0;
$warnings=0;
while(<rpt>)
	{
		if (/$rule/ && /Error/) {
		$matches++;
		$errors++;
		}
		if (/$rule/ && /Warning/) {
		$matches++;
		$warnings++;
		}
	}
		#print "Rule $rule Total: $matches Errors: $errors Warnings: $warnings in $rpt_file\n";
		$hash{$subchip}{$rule}{total}=$matches;
		$hash{$subchip}{$rule}{errors}=$errors;
		$hash{$subchip}{$rule}{warning}=$warnings;
close ( rpt ) ;
	}
	}# file exists condition
else {
	foreach $rule (@cdc_func_rules)
	{
		$hash{$subchip}{$rule}{total}=Err;
		$hash{$subchip}{$rule}{errors}=Err;
		$hash{$subchip}{$rule}{warning}=Err;
	}
	}#else ends creating errro message for file not found
#Looping cdc functional low effort for all subchips
$rpt_file="$sourceDir\/$subchip/$subchip/cdc_block/cdc_formal/spyglass_reports/moresimple.rpt";
if (-e $rpt_file) {
$rpt_file =~ s/(.*\.gz)\s*$/gzip -dc < $1|/;
#warn ( "# INFO: Parsing $rule in report file: $rpt_file...\n" ) ;
foreach $rule (@cdc_func_rules)
	{
open(rpt, "$rpt_file") || die "OPEN file : $rpt_file FAILED \n ";
$matches=0;
$errors=0;
$warnings=0;
while(<rpt>)
	{
		if (/$rule/ && /Error/) {
		$matches++;
		$errors++;
		}
		if (/$rule/ && /Warning/) {
		$matches++;
		$warnings++;
		}
	}
		#print "Rule $rule Total: $matches Errors: $errors Warnings: $warnings in $rpt_file\n";
		$hash{$subchip}{$rule}{total}=$matches;
		$hash{$subchip}{$rule}{errors}=$errors;
		$hash{$subchip}{$rule}{warning}=$warnings;
		if( $hash{$subchip}{$rule}{errors}) {
		$flag{$subchip}=1;
		}
close ( rpt ) ;
	}
	}# file exists condition
else {
	foreach $rule (@cdc_func_rules)
	{
		$hash{$subchip}{$rule}{total}=Err;
		$hash{$subchip}{$rule}{errors}=Err;
		$hash{$subchip}{$rule}{warning}=Err;
	}
	}#else ends creating errro message for file not found
}
close (SUBCHIPDIR);
#system(clear);
	printf "%15s",Subchips=>;
	printf OUT  "Subchips,";
foreach $sc ( @allsubchips ) {
	printf "%15s",$sc;
	printf OUT "$sc,";
}
printf OUT "\n";
printf OUT ",";
foreach $sc ( @allsubchips ) {
	printf OUT "Total/Error/Warning/Waiver,";
}
printf "\n";
printf OUT "\n";
	printf "%15s",LINT_SYN;
	printf OUT  "LINT_SYN,";
printf "\n";
printf OUT "\n";
foreach $rule ( @lintall_rules ) {
	printf "%15s",$rule;
	printf OUT "$rule,";
foreach $sc ( @allsubchips ) {
	printf "%15s","$hash{$sc}{$rule}{total}\/$hash{$sc}{$rule}{errors}\/$hash{$sc}{$rule}{warning}\/0";
	printf OUT "$hash{$sc}{$rule}{total}\/$hash{$sc}{$rule}{errors}\/$hash{$sc}{$rule}{warning}\/0,";
}
printf "\n";
printf OUT "\n";
}
printf "\n";
printf OUT "\n";
	printf "%15s",CDC_STRUCTURAL;
	printf OUT  "%15s",CDC_STRUCTURAL;
printf "\n";
printf OUT "\n";
foreach $rule ( @cdc_struct_rules ) {
	printf "%15s",$rule;
	printf OUT "$rule,";
foreach $sc ( @allsubchips ) {
	printf "%15s","$hash{$sc}{$rule}{total}\/$hash{$sc}{$rule}{errors}\/$hash{$sc}{$rule}{warning}\/0";
	printf OUT "$hash{$sc}{$rule}{total}\/$hash{$sc}{$rule}{errors}\/$hash{$sc}{$rule}{warning}\/0,";
}
printf "\n";
printf OUT "\n";
}
printf "\n";
printf OUT "\n";
	printf "%15s",CDC_FUNCTIONAL;
	printf OUT "CDC_FUNCTIONAL,";
printf "\n";
printf OUT "\n";
	printf "%15s",LOW_EFORT;
	printf OUT "LOW_EFORT,";
printf "\n";
printf OUT "\n";
foreach $rule ( @cdc_func_rules ) {
	printf "%15s",$rule;
	printf OUT "$rule,";
foreach $sc ( @allsubchips ) {
	printf "%15s","$hash{$sc}{$rule}{total}\/$hash{$sc}{$rule}{errors}\/$hash{$sc}{$rule}{warning}\/0";
	printf OUT "$hash{$sc}{$rule}{total}\/$hash{$sc}{$rule}{errors}\/$hash{$sc}{$rule}{warning}\/0,";
}
printf "\n";
printf OUT "\n";
}

foreach $subchip (@allsubchips) {
#Looping cdc functional high effort for all subchips
$rpt_file="$sourceDir\/$subchip\/$subchip"."_cdc_functional_highEffort.rpt";
if (-e $rpt_file) {
$rpt_file =~ s/(.*\.gz)\s*$/gzip -dc < $1|/;
#warn ( "# INFO: Parsing $rule in report file: $rpt_file...\n" ) ;
foreach $rule (@cdc_func_rules)
	{
open(rpt, "$rpt_file") || die "OPEN file : $rpt_file FAILED \n ";
$matches=0;
$errors=0;
$warnings=0;
while(<rpt>)
	{
		if (/$rule/ && /Error/) {
		$matches++;
		$errors++;
		}
		if (/$rule/ && /Warning/) {
		$matches++;
		$warnings++;
		}
	}
		#print "Rule $rule Total: $matches Errors: $errors Warnings: $warnings in $rpt_file\n";
		$hash{$subchip}{$rule}{total}=$matches;
		$hash{$subchip}{$rule}{errors}=$errors;
		$hash{$subchip}{$rule}{warning}=$warnings;
close ( rpt ) ;
	}
	}# file exists condition
else {
	foreach $rule (@cdc_func_rules)
	{
		$hash{$subchip}{$rule}{total}="NR";
		$hash{$subchip}{$rule}{errors}="NR";
		$hash{$subchip}{$rule}{warning}="NR";
	}
	}#else ends creating errro message for file not found
}

printf "\n";
printf OUT "\n";
	printf "%15s",HIGH_EFFORT;
	printf OUT "HIGH_EFFORT,";
printf "\n";
printf OUT "\n";
foreach $rule ( @cdc_func_rules ) {
	printf "%15s",$rule;
	printf OUT "$rule,";
foreach $sc ( @allsubchips ) {
	printf "%15s","$hash{$sc}{$rule}{total}\/$hash{$sc}{$rule}{errors}\/$hash{$sc}{$rule}{warning}\/0";
	printf OUT "$hash{$sc}{$rule}{total}\/$hash{$sc}{$rule}{errors}\/$hash{$sc}{$rule}{warning}\/0,";
}
printf "\n";
printf OUT "\n";
}
close(OUT);
$user_id = $ENV{user};
if (-e "mailme") { unlink "mailme"; }
system ("uuencode ts_sg_summ.csv ts_sg_summ.csv > mailme");
system ("mail -s 'TS Spyglass Summary' jaga < mailme");
if (-e "mailme") { unlink "mailme"; }
exit(0);
