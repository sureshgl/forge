#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use FindBin qw($RealBin);
use File::Basename;
use FileHandle;
use Cwd;
use Cwd 'realpath';
use IPC::Run3;
use List::Compare;
use Clone qw(clone);
use Data::Dumper;
use Log::Log4perl qw(:easy);
use Log::Log4perl::Level;
use JSON;

# TBD report unused .tcl files

my $ecnt = 0;
my $opt = {};
my $cfg = {};

getOptions($opt, $cfg);
getCfg($opt, $cfg);
my $iev = "$cfg->{'bin'} +64bit -F filelist +define+FORMAL +licq +ncverilogargs+nc64bit +ncverilogargs+native";
emitRtlFileList($opt, $cfg);
readRunIfv($opt, $cfg);
runFormal($opt, $cfg);
emitFrunCfg($opt, $cfg);

if ($ecnt) {
  ERROR "exiting with errors ($ecnt) -- DO NOT RELEASE";
} else {
  ALWAYS "run fchkr for analysis";
  ALWAYS "all good";
}
exit($ecnt);

sub emitFrunCfg {
  my $opt = shift;
  my $cfg = shift;

  my $fo = "frun_cfg.json";
  my $fh = FileHandle->new( $fo, "w" );
  if ( !defined $fh ) {
    LOGDIE "failed to open $fo for write - run frun.pl";
  }
  my $json = new JSON;
  my $jstr = $json->pretty->encode($cfg) . "\n";
  print $fh $jstr;
  $fh->close();
}

sub runFormal {
  my $opt = shift;
  my $cfg = shift;
  my $cmd;

  if ($opt->{'r'} eq '') {
    $cmd = '\rm -fr INCA_libs';
    print "     $cmd\n";
    system($cmd);
  }
  my $runs = $cfg->{'runs'};
  my $en_runs = $cfg->{'enabled_runs'};
  foreach my $run (@{$runs}) {
    if (!exists $en_runs->{$run->{'name'}}) {
      next;
    }
    ALWAYS "running $run->{'tcl'} as $run->{'name'}";
    clearEnvVars($opt, $cfg);
    foreach my $env (@{$run->{'env'}}) {
      my $ek = (keys %{$env})[0];
      my $ev = (values %{$env})[0];
      print "     setenv $ek $ev\n";
      $ENV{$ek} = $ev;
    }
    my $topv = $cfg->{'frun'}->{'cutCoreName'};
    my $tcl = $cfg->{'frun'}->{'algo_ifv_dir'} . "/" . $run->{'tcl'} . ".tcl";
    if (!-e $tcl) {
      ERROR "tcl $run->{'tcl'} ($tcl) for run $run->{'name'} not found";
    }
    $tcl = realpath($tcl);
    $tcl = "+tcl+${tcl}";
    my $log = "-l " . $run->{'name'} . ".log";
    my $cmd = $iev . " +top+${topv}";
    $cmd .= " $tcl $log";
    $cmd .= $opt->{'q'} ? " -q +nostdout" : "";
    $cmd .= $opt->{'cov'} ? " +replay +coverage+A +covworkdir+".$run->{'name'}."_work" : "";
    $cmd .= $opt->{'gui'} ? " +gui" : " +exit";
    print "     $cmd\n";
    if ($opt->{'n'}) {
      # skip
    } else {
      system($cmd);
    }
  }
}

sub clearEnvVars {
  my $opt = shift;
  my $cfg = shift;

  my $allenv = $cfg->{'allenv'};
  foreach my $env (keys %{$allenv}) {
    print "     unsetenv $env\n";
    delete $ENV{$env};
  }
}

sub readRunIfv {
  my $opt = shift;
  my $cfg = shift;

  $cfg->{'runs'} = [];
  $cfg->{'allenv'} = {};
  $cfg->{'enabled_runs'} = {};

  my $fi = $cfg->{'frun'}->{'binaryPath'} . "/../verilogparser/ip/" . $cfg->{'frun'}->{'algo'} . "/ifv/run_ifv";
  ALWAYS "reading $fi";
  my $fh = FileHandle->new( $fi, "r" );
  if ( !defined $fh ) {
    LOGDIE "failed to open $fi for read\n";
    $ecnt++;
  }
  my $ln = 0;
  my $st = 0;
  my $group = 0;
  my $envvars = [];
  my $runs = $cfg->{'runs'};
  my $allenv = $cfg->{'allenv'};
  my $last_was_run = 1;
  while (<$fh>) {
    $ln++;
    chomp;
    s/^\s*$//;
    next if (/^$/);
    if (/^\s*run\s+(\S+)\s+(\S+)\s*$/) {
      $last_was_run = 1;
      DEBUG "found run $1 $2\n";
      my $run = {};
      $run->{'tcl'} = $1;
      $run->{'name'} = $2;
      $run->{'env'} = $envvars;
      push @{$runs}, $run;
    } elsif (/^\s*setenv\s+(\S+)\s+(\S+)\s*$/) {
      if ($last_was_run) {
        DEBUG "reinit envvars";
        $envvars = [];
      }
      my $e = $1;
      my $ev = $2;
      $ev =~ s/\\//g; # remove shell escape char \
      my $envvar = {};
      $envvar->{$e} = $ev;
      push @{$envvars}, $envvar;
      $allenv->{$e} = $ev;
      DEBUG "found setenv $e $ev\n";
      $last_was_run = 0;
    } else {
      DEBUG "NOT processing line $ln : $_\n";
    }
  }
  $fh->close();

  my @av_run_names;
  foreach my $ar (@{$runs}) {
    push @av_run_names, $ar->{'name'};
  }

  my @en_run_names;
  if ($opt->{'r'} ne '') {
    my @era = split(',', $opt->{'r'});
    foreach my $er (@era) {
      foreach my $ar (@{$runs}) {
        if ($ar->{'name'} eq $er) {
          $cfg->{'enabled_runs'}->{$er} = 1;
          push @en_run_names, $er;
        }
      }
      if (!exists $cfg->{'enabled_runs'}->{$er}) {
        ERROR "enabled run $er - NOT found";
        $ecnt++;
      }
    }
  } else {
    foreach my $ar (@{$cfg->{'runs'}}) {
      $cfg->{'enabled_runs'}->{$ar->{'name'}} = 1;
      push @en_run_names, $ar->{'name'};
    }
  }

  { # duplicate run name check - needed for fchkr.pl to read all output log files
    my $lf = {};
    $cfg->{'logfiles'} = []; 
    foreach my $r (@{$cfg->{'runs'}}) {
      my $rname = $r->{'name'};
      if ($rname eq '') {
        ERROR " run name not specified $r->{'tcl'}";
        $ecnt++;
      }
      my $cname = "run $r->{'tcl'} $rname";
      if (defined $lf->{$rname}) {
        ERROR " duplicate use of run name $rname - now \"$cname\" last \"$lf->{$rname}\"";
        $ecnt++;
      }
      $lf->{$rname} = $cname;
      push @{$cfg->{'logfiles'}}, $rname . ".log";
    }
  }

  ALWAYS "available runs (". scalar (@av_run_names) . "): @av_run_names";
  ALWAYS "enabled runs   (". scalar (@en_run_names) . "): @en_run_names";

  DEBUG Dumper($cfg->{'runs'});

}

sub getCfg {
  my $opt = shift;
  my $cfg = shift;

  $cfg->{'bin'} = $opt->{'ifv'} ? "ifv" : "iev";

  $cfg->{'fv_run_dir'} = realpath(getcwd);
  ALWAYS "fv run dir $cfg->{'fv_run_dir'}";
  {
    my $fi = "../../cutinfo/$opt->{'name'}.json";
    ALWAYS "reading $fi";
    my $fh = FileHandle->new( $fi, "r" );
    if ( !defined $fh ) {
      LOGDIE "failed to open $fi for read - regenerate cut if needed\n";
    }
    my @js = <$fh>;
    my $s = join( "\n", @js );
    $fh->close();
    my $jh = decode_json($s);
    $cfg->{'frun'} = $jh;
    TRACE Dumper ($cfg->{'frun'});
  }
}

sub emitRtlFileList {
  my $opt = shift;
  my $cfg = shift;

  my $frun = $cfg->{'frun'};
  $frun->{'filelist'} = [];
  my $filelist = $frun->{'filelist'};
  my $binPath = $frun->{'binaryPath'};
  my $algo = $frun->{'algo'};
  my $cutName = $frun->{'cutName'};
  my $cutCoreName = $frun->{'cutCoreName'};
  my $pversion = $frun->{'plainVersion'};
  my $noobstr = $frun->{'noob'} ? "true" : "false";
  my $version  = $frun->{'version'};
  my $fvrdir   = $cfg->{'fv_run_dir'};
  my $cut_core_v = $opt->{'fvcore'} ? $fvrdir . "/../../../rtl/${cutCoreName}_fv.v" : $fvrdir . "/../../../rtl/${cutCoreName}.v";
  ALWAYS "cut=$cutName cutCore=$cutCoreName algo=$algo noob=$noobstr version=$version";
  if (!-e $cut_core_v) {
    ERROR "$cut_core_v NOT accessible";
    $ecnt++;
  }
  $cut_core_v = realpath($cut_core_v);
  ALWAYS "cut core file: $cut_core_v";
  my $ip_non_obf_v = "$binPath/../verilogparser/ip_obfuscated/memoir_design_library_${pversion}.v";
  if (!-e $ip_non_obf_v) {
    ERROR "$ip_non_obf_v NOT accessible";
    $ecnt++;
  }
  $ip_non_obf_v= realpath($ip_non_obf_v);
  my $ip_obf_v = "$binPath/../verilogparser/ip_obfuscated/common/rtl/memoir_design_library_${pversion}.v";
  if (!-e $ip_obf_v) {
    ERROR "$ip_obf_v NOT accessible";
    $ecnt++;
  }
  $ip_obf_v = realpath($ip_obf_v);
  my $algo_rtl_dir = "$binPath/../verilogparser/ip/$algo/rtl";
  if (!-e $algo_rtl_dir) {
    ERROR "$algo_rtl_dir NOT accessible";
    $ecnt++;
  }
  my $algo_ifv_dir = "$binPath/../verilogparser/ip/$algo/ifv";
  if (!-e $algo_ifv_dir) {
    ERROR "$algo_ifv_dir NOT accessible";
    $ecnt++;
  }
  $frun->{'algo_ifv_dir'} = $algo_ifv_dir;
  if ($cfg->{'frun'}->{'noob'}) {
    foreach my $dotf ("rtl.f", "formal.f", "external.f") {
      my $fn = "$algo_rtl_dir/$dotf";
      if (!-e $fn) {
        WARN "$fn NOT accessible";
        next;
      }
      DEBUG "reading $fn";
      my $dir = dirname($fn);
      my $fh = FileHandle->new($fn, "r");
      LOGCONFESS "failed to open $fn for read \n" if (!defined $fh);
      while (<$fh>) {
        chomp;
        s/\/\/.*//;
        next if (/^\s*$/);
        my $rf = "$dir/$_";
        if (-e $rf) {
          $rf = realpath($rf);
          push @{$filelist}, $rf;
        } else {
          ERROR "$rf - not found";
          $ecnt++;
        }
      }
      $fh->close();
    }

    ALWAYS "pointing to RTL from IP dir " . realpath ($algo_rtl_dir);
  } else {
    push @{$filelist}, $ip_obf_v;
    ALWAYS "pointing to RTL from obf design library: $ip_obf_v";
  }
  push @{$filelist}, $cut_core_v;
  TRACE Dumper ($filelist);

  {
    my $fn = "filelist";
    my $fh = FileHandle->new($fn, "w");
    LOGCONFESS "failed to open $fn for writing \n" if (!defined $fh);
    foreach my $f (@{$filelist}) {
      print $fh "$f\n";
    }
    $fh->close();
  }
}

sub getOptions {
  my $opt = shift;
  my $cfg = shift;

  Log::Log4perl->easy_init( { level   => $WARN,
      file    => "STDOUT",
      layout   => '[%.1p]: %m%n'} );
  ALWAYS "cmdline: $0 @ARGV\n";

  $opt->{'name'} = "";
  $opt->{'fvcore'} = 0;
  $opt->{'r'}    = "";
  $opt->{'n'}    = 0;
  $opt->{'q'}    = 1;
  $opt->{'ifv'}  = 0;
  $opt->{'gui'}  = 0; # launch formal GUI
  $opt->{'ll'}   = "warn";
  $opt->{'help'} = 0;
  $opt->{'cov'} = 0;
  $opt->{'h'} = 0;

  my $rv = GetOptions ($opt,
    'name=s',
    'fvcore!',
    'r=s',
    'n!',
    'q!',
    'ifv!',
    'gui!',
    'll=s',
    'help!',
    'cov!',
    'h!'
  );

  if ( !$rv ||
    $opt->{'h'} ||
    $opt->{'help'}
  ) {
    print "Usage: $0 -name <cut-name> -fvcore [-r run-name[,run-name,...]] [-ifv] [-gui] [-n] [-q|-noq] [-ll] [-cov] [-h|-help]\n";
    print "   This script runs formal\n";
    print "   -name  : cut name\n";
    print "   -fvcore: use cut_core_fv.v instead of cut_core.v\n";
    print "   -r     : list of comma separated run names to be run\n";
    print "            run name is the second operand in runs in run_ifv \n";
    print "   -n     : report commands only - dont run them\n";
    print "   -q     : default - run formal in quiet mode - supplies -q +nostdout\n";
    print "   -noq   : run formal in verbose mode\n";
    print "   -ifv   : use ifv instead of iev tool\n";
    print "   -cov   : to generate coverage database\n";
    print "   -gui   : if specified supplies +gui to each iev run\n";
    print "            if not specified supplies +exit to each iev run\n";
    print "   -ll    : log level\n";
    print "   -h     : to print this message\n";
    print "   run_ifv format:\n";
    print "     run show_all show_all\n";
    print "     setenv IFV_HIER blah\n";
    print "     run <tcl-name> <run-name>\n";
    print "     ...\n";
    print "     same tcl can be used in multiple runs as long as run names are unique\n";
    exit(1);
  }

  $opt->{'ll'} = uc($opt->{'ll'});
  Log::Log4perl->easy_init( { level   => Log::Log4perl::Level::to_priority($opt->{'ll'}),
      file    => "STDOUT",
      layout  => '[%.1p]: %m%n'} );

  if ($opt->{'q'}) {
    ALWAYS "quiet mode set: running formal in quiet mode";
  }
  if ($opt->{'n'}) {
    ALWAYS "norun set: reporting commands only";
  }
  if ($opt->{'gui'}) {
    ALWAYS "gui set: will launch gui";
  }
}
