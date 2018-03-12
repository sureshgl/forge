package MemogenUtils;
use Exporter;
@ISA = qw (Exporter);
@EXPORT = qw (
               getMemogenDir
               getMemogenCmdInTree
            );
use strict;
use warnings "all";
use IPC::Run3;
use Carp;
use Cwd;
use Cwd 'realpath';
use Math::Random;
use Data::Dumper;
use Getopt::Long qw(GetOptionsFromArray);
use Clone qw(clone);
use List::Util qw(max min shuffle);
use Log::Log4perl qw(:easy);
use File::Find;

use InfraUtils;
use ConfigUtils;

# ----------------------------------------------------------------------
# Static vars and methods
# ----------------------------------------------------------------------
my $cmdlineOptions;
my $memogenFeatures;

# called in program constructor BEGIN
sub getCmdlineOptions {
  if (!defined $cmdlineOptions) {
    $cmdlineOptions = {
                       'batch'       => 0,
                       'interactive' => 0,
                       'just-print'  => 0,
                       'skip'        => "",
                       'raw'         => "",
                       'sa'          => "",
                       'coverage'    => 0,
                       'help'        => 0,
                       'h'           => 0,
                      };

    my $rv = GetOptionsFromArray
                        (clone(\@ARGV),
                         $cmdlineOptions,
                         'batch!',
                         'interactive!',
                         'just-print!',
                         'coverage!',
                         'skip=s',
                         'raw=s',
                         'sa=s',
                         'help|h!',
                        );
    if (!$rv || $cmdlineOptions->{'h'} || $cmdlineOptions->{'help'}) {
      $cmdlineOptions->{'workDoneHandler'} = sub {
        print " Usage: $0 [--batch|--interactive|--just-print] [--skip <pre,cmd,post,plot,check,cmp>] [--raw <memogen args>] [--h|help]\n";
        print "        --skip        -- skip steps listed - any combination of: pre,cmd,post,plot,check,cmp\n";
        print "        --sa          -- additional args to be passed to memogen\n";
        print "        --raw         -- exec memogen directly with supplied args and skip all steps\n";
        print "        --coverage    -- run instrumented binary for coverage analysis\n";
        print "        --just-print  -- print system commands being executed but do nothing\n";
        print "        --batch       -- ignored for now\n";
        print "        --interactive -- ignored for now\n";
        print " Examples:\n";
        print " 1. $0 --skip \"check,cmp\"\n";
        print "        Above command runs memogen but skips checkers and golden comparison.\n";
        print "        Should only be used when experimenting new run args.\n";
        print " 2. $0 --raw \"-v ibm -t cu-32hp -a 1R1W_BASE -f 300 -w 128K -b 77\"\n";
        print "        Above command invokes memogen directly skipping all checks.\n";
        print "        Use this when trying out new memogen run args which will later be\n";
        print "        put in to run script\n";
        print " 3. $0 --raw \"-help\"\n";
        print "        Above command invokes memogen help and exits.\n";
        exit(1);
      };
      $cmdlineOptions->{'workDone'} = 1;
    }
  }
  return clone($cmdlineOptions);
}

# called in program constructor BEGIN
sub getMemogenFeatures {
  $memogenFeatures = {};
}

# ----------------------------------------------------------------------
# public methods
# ----------------------------------------------------------------------


###############################################
################# Environment #################
###############################################

sub getMemogenDir(){
    return getMemoverseDir()."/memogen";
}

sub getMemogenCmdInTree() {
  return getMemogenDir()."/memoir/bin/memogen";
}

1;
