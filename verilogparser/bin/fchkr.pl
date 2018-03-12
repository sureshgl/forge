#!/usr/bin/env perl

# TBD process below lines as errors
#formalverifier: *E,IONOEN: file does not exist, /auto/proj/users/sree/t4/dev/ip/1r1w_a621/ifv/fwd_ecc_check.tcl.
#formalverifier: *E,WLDNFD: Object matching "des.algo_top.t2_loop[*].stack_loop.infra.ip_top_sva_2.assert_rd_range_check" not found in the design.

# report if no log file has been found

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

# TBD: pin constraints are not listed in constraint -show -all ... not good

my $ecnt = 0;
my $opt = {};
my $cfg = {};

getOptions($opt, $cfg);
readDesignProperties($opt, $cfg);
getLogFileList($opt, $cfg);
readShowAllLog($opt, $cfg);
readLogFiles($opt, $cfg);
populateGraph($opt, $cfg);
report($opt, $cfg);
validate($opt, $cfg);

### TBD: only one prove per file - check it
# TBD LOOK for
# formalverifier: *W,SSNOAS: Session does not have any assertion.
# in B10 mem_check.tcl this can be reproduced easily
# TBD
# in port_check.log for B10 there are no constraints for an assertion that is proven :(


if ($ecnt) {
  ERROR "exiting with errors ($ecnt) -- DO NOT RELEASE";
} else {
  ALWAYS "all good";
}
exit($ecnt);


sub getOptions {
  my $opt = shift;
  my $cfg = shift;

  Log::Log4perl->easy_init( { level   => $WARN,
                              file    => "STDOUT",
                              layout   => '[%.1p]: %m%n'} );
  ALWAYS "cmdline: $0 @ARGV\n";

  $opt->{'name'} = "";
  $opt->{'log'} = "";
  $opt->{'ll'} = "warn";
  $opt->{'help'} = 0;
  $opt->{'h'} = 0;

  my $rv = GetOptions ($opt,
                       'name=s',
                       'log=s',
                       'll=s',
                       'help!',
                       'h!'
                      );

  $opt->{'ll'} = uc($opt->{'ll'});

  Log::Log4perl->easy_init( { level   => Log::Log4perl::Level::to_priority($opt->{'ll'}),
                              file    => "STDOUT",
                              layout  => '[%.1p]: %m%n'} );

  if ( !$rv ||
       ($opt->{'name'} eq '') ||
       ($opt->{'h'} || $opt->{'help'})
     ) {
    print "Usage: $0 -name <cut-name> [-log] [-ll] [-h|-help]\n";
    print "   This script constructs graph of formal properties\n";
    print "   -name: cut name\n";
    print "   -log : list of comma separated iev log files if not specified it is *.log\n";
    print "   -ll  : log level\n";
    print "   -h   : to print this message\n";
    exit(1);
  }
}

sub readDesignProperties {
  my $opt = shift;
  my $cfg = shift;

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
    TRACE Dumper (clone($cfg->{'frun'}));
  }
  my @en_c_chk = split (',', $cfg->{'frun'}->{'enabledConditionalChecks'});
  $cfg->{'frun'}->{'enabledConditionalChecks'} = \@en_c_chk;
  my @su_c_chk = split (',', $cfg->{'frun'}->{'supportedConditionalChecks'});
  $cfg->{'frun'}->{'supportedConditionalChecks'} = \@su_c_chk;
  ALWAYS "enabled   conditional checks: @en_c_chk";
  ALWAYS "supported conditional checks: @su_c_chk";

  my $frun = $cfg->{'frun'};
  my $binPath = $frun->{'binaryPath'};
  my $algo = $frun->{'algo'};
  my $cutName = $frun->{'cutName'};
  my $noobstr = $frun->{'noob'} ? "true" : "false";
  my $version = $frun->{'version'};
  my $algo_ifv_dir = "$binPath/../verilogparser/ip/$algo/ifv";
  if (!-e $algo_ifv_dir) {
    ERROR "$algo_ifv_dir NOT accessible";
    $ecnt++;
  }
  $frun->{'algo_ifv_dir'} = $algo_ifv_dir;

  {
    my $fn = $algo_ifv_dir . "/properties.json";
    ALWAYS "reading $fn";
    my $s = "{\n\"primary_design_constraints\" : [\n ],\n \"conditional_properties\" : {\n }\n}\n";
    my $fh = FileHandle->new( $fn, "r" );
    if ( !defined $fh ) {
      ERROR "failed to open $fn for read\n";
      $ecnt++;
    } else {
      my @js = <$fh>;
      $s = join( "\n", @js );
      $fh->close();
    }
    my $jh = decode_json($s);
    $cfg->{'design'}->{'properties'} = $jh;
  }

  {                             # read frun_cfg.json to figure out paths
    my $fi = "frun_cfg.json";
    ALWAYS "reading $fi";
    my $fh = FileHandle->new( $fi, "r" );
    if ( !defined $fh ) {
      WARN "failed to open $fi for read\n";
      $cfg->{'frun_cfg'} = {};
    } else {
      my @js = <$fh>;
      my $s = join( "\n", @js );
      $fh->close();
      my $jh = decode_json($s);
      $cfg->{'frun_cfg'} = $jh;
    }
    TRACE Dumper (clone($cfg->{'frun_cfg'}));
  }
  ALWAYS "cut=$cutName algo=$algo noob=$noobstr version=$version";

  {
    my @pf_c_chk = keys %{$cfg->{'design'}->{'properties'}->{'conditional_properties'}};
    my $lc = List::Compare->new(\@su_c_chk, \@pf_c_chk);
    my @p_only = $lc->get_Ronly();
    if ($#p_only >= 0) {
      ERROR "conditional checks not supported: @p_only";
      $ecnt = $ecnt + $#p_only + 1;
    }
  }
  {
    my @pf_c_chk = keys %{$cfg->{'design'}->{'properties'}->{'conditional_properties'}};
    my $lc = List::Compare->new(\@en_c_chk, \@pf_c_chk);
    my @p_only = $lc->get_Ronly();
    if ($#p_only >= 0) {
      WARN "conditional checks present in properties.json but not enabled: @p_only";
    }
  }
}

sub getLogFileList {
  my $opt = shift;
  my $cfg = shift;

  if ($opt->{'log'} ne "") {
    $cfg->{'logfiles'} = {map {$_ , {}} split(',', $opt->{'log'})};
  } else {
    $cfg->{'logfiles'} = {map {$_, {}} @{$cfg->{'frun_cfg'}->{'logfiles'}}};
  }

}

sub readShowAllLog {
  my $opt = shift;
  my $cfg = shift;

  my $fn = "show_all.log";      # special file

  if (exists $cfg->{'logfiles'}->{$fn}) {
    delete $cfg->{'logfiles'}->{$fn};
  }

  $cfg->{'design'}->{'constraints'} = [];
  $cfg->{'design'}->{'assertions'} = [];
  $cfg->{'design'}->{'cutpoints'} = [];

  DEBUG "reading $fn";
  my $fh = FileHandle->new($fn, "r");
  LOGDIE "failed to open $fn for read" if (!defined $fh);
  my $ln = 0;
  my $st = 0;
  my $sta = 0;
  my $stc = 0;
  my $stp = 0;
  while (<$fh>) {
    $ln++;
    if (/^FormalVerifier> /) {
      $sta = 0;
      $stc = 0;
      $stp = 0;
    }
    if (/^FormalVerifier> assertion -show -all$/) {
      $sta = 1;
      $stc = 0;
      $stp = 0;
    } elsif ($sta == 1) {
      if (/^  (.*) \: Not_Run \- Trigger\: Not_Run$/) {
        push @{$cfg->{'design'}->{'assertions'}}, $1;
      } elsif (/^  (.*) : Not_Run$/) {
        push @{$cfg->{'design'}->{'assertions'}}, $1;
      } else {
        ERROR "assert: cannot process line $ln: $_";
        $ecnt++;
      }
      ## TBD: whats the difference between Trigger Not_Run and plain Not_Run??
    } elsif (/^FormalVerifier> constraint -show -all$/) {
      $stc  = 1;
      $sta = 0;
      $stp = 0;
    } elsif ($stc == 1) {
      if (/^Constraints:$/) {
        # skip
      } elsif (/^  (.*)\: Trivially True$/) {
        TRACE "$fn: found constraint: $1";
        push @{$cfg->{'design'}->{'assertions'}}, $1; # per Da, constraints are also assertions unless explicitly indicated
      } elsif (/^  (.*)$/) {
        TRACE "$fn: found constraint: $1";
        push @{$cfg->{'design'}->{'assertions'}}, $1; # per Da, constraints are also assertions unless explicitly indicated
      } elsif (/^formalverifier: \*W,SSNOCS: Session does not have any property constraint.$/) {
        WARN "$fn: no constraints found";
      } else {
        ERROR "constraint: cannot process line $ln: $_";
        $ecnt++;
      }
      ## TBD: process trivially true constraints
    } elsif (/^FormalVerifier> cutpoint -show -all$/) {
      $stc  = 0;
      $sta = 0;
      $stp = 1;
    } elsif ($stp == 1) {
      if (/^formalverifier: \*W,UDPINF: Cutpoint not found on any signal.$/) {
        # OK
      } else {
        ERROR "cutpoint: cannot process line $ln: $_";
        $ecnt++;
      }
    } else {
    }
  }

  $fh->close();

}

sub readLogFiles {              # read all the other log files
  my $opt = shift;
  my $cfg = shift;

  foreach my $fn (sort keys %{$cfg->{'logfiles'}}) {
    DEBUG "reading $fn";
    my $fh = FileHandle->new($fn, "r");
    LOGDIE "failed to open $fn for read" if (!defined $fh);
    my $ln = 0;
    my $st = 0;
    my $sta = 0;
    my $stc = 0;
    my $stp = 0;
    $cfg->{'logfiles'}->{$fn}->{'constraints'} = {};
    $cfg->{'logfiles'}->{$fn}->{'assertions'} = {};
    $cfg->{'logfiles'}->{$fn}->{'proven_assertions'} = {};
    my $cnst = $cfg->{'logfiles'}->{$fn}->{'constraints'};
    my $asrt = $cfg->{'logfiles'}->{$fn}->{'assertions'};
    my $prva = $cfg->{'logfiles'}->{$fn}->{'proven_assertions'};
    while (<$fh>) {
      $ln++;
      # first assertion -show -all -- this is only for confirming that all assertions identified found have been proven
      ###### TBD look for lines with tool errors *E, something ...
      if (($stp > 2) && ($st == 2)) {
        $st = 0;
      }
      if (/^FormalVerifier> /) {
        $sta = 0;
        $stc = 0;
        $stp = 0;
      }
      if (/^FormalVerifier> assertion -delete -all$/) {
        $st++;
        TRACE "assertion delete";
      } elsif (/^FormalVerifier> constraint -delete -all$/) {
        $st++;
        TRACE "constraint delete";
      } elsif (($st == 2) && ($_ =~ /^FormalVerifier> assertion -show -all$/)) {
        TRACE "assertion show";
        $sta = 1;
        $stc = 0;
      } elsif (($st == 2) && ($_ =~ /^FormalVerifier> constraint -show -all$/)) {
        TRACE "constraint show";
        $sta = 0;
        $stc = 1;
      } elsif ($sta == 1) {     # assertion
        if (/^  (.*) : Not_Run$/) {
          TRACE "$fn: found assert: $1";
          $asrt->{$1} = 1;
        } elsif (/^  (.*) \: Not_Run \- Trigger\: Not_Run$/) {
          TRACE "$fn: found assert: $1";
          $asrt->{$1} = 1;
        } else {
          ERROR "assert: $fn: cannot process line $ln: $_";
          $ecnt++;
        }
      } elsif ($stc == 1) {     # constraint
        if (/^Constraints:$/) {
          # skip
        } elsif (/^  (.*)\: Trivially True$/) {
          TRACE "$fn: found constraint: $1";
          $cnst->{$1} = 1;
        } elsif (/^  (.*)$/) {
          TRACE "$fn: found constraint: $1";
          $cnst->{$1} = 1;
        } elsif (/^formalverifier: \*W,SSNOCS: Session does not have any property constraint.$/) {
          WARN "$fn: no constraints found";
        } else {
          ERROR "constraint: $fn: cannot process line $ln: $_";
          $ecnt++;
        }
      } elsif (/^FormalVerifier> prove$/) {
        TRACE "assertion prove";
        $stp++;
      } elsif (($stp == 1) && (/^Verification mode:$/)) {
        $stp++;
      } elsif ($stp == 2) {
        if (/^  (.*) \: Pass \- Trigger\: Pass \((\d+)\)$/) {
          TRACE "$fn: found proven assert (ptp): $1 $2";
          $prva->{$1}->{'type'} = "Pass_Trigger_Pass";
        } elsif (/^  (.*) \: Pass$/) {
          TRACE "$fn: found proven assert (p): $1";
          $prva->{$1}->{'type'} = "Pass";
        } elsif (/^  (.*) \: Pass \- Trigger\: Fail$/) {
          TRACE "$fn: found proven assert (ptf): $1";
          $prva->{$1}->{'type'} = "Pass_Trigger_Fail";
        } elsif (/^  (.*) \: Explored \((\d+)\)$/) {
          TRACE "$fn: found proven assert (e): $1";
          $prva->{$1}->{'type'} = "Explored";
        } elsif (/^  (.*) \: Explored \((\d+)\) \- Trigger\: Pass \((\d+)\)$/) {
          TRACE "$fn: found proven assert (etp): $1";
          $prva->{$1}->{'type'} = "Explored";
        } elsif (/^  (.*) \: Explored \(\d+\) \- Trigger\: Explored \(\d+\)$/) {
          TRACE "$fn: found proven assert (ete): $1";
          $prva->{$1}->{'type'} = "Explored";
        } elsif (/^Assertion Summary:$/) {
          TRACE "$fn: skipping line $ln: $_";
        } elsif (/^Session Status: Finished$/) {
          TRACE "done picking up proven asserts";
          $stp++;
        } else {
          ERROR "prove: $fn: cannot process line $ln: $_";
          $ecnt++;
        }
      } else {

      }
    }
    $fh->close();
  }
}

sub populateGraph {
  my $opt = shift;
  my $cfg = shift;

  $cfg->{'adjacency_list'} = {};
  $cfg->{'leaf_nodes'}  = {};
  $cfg->{'root_nodes'}  = {};
  $cfg->{'left_nodes'}  = {};
  $cfg->{'right_nodes'} = {};
  foreach my $fn (sort keys %{$cfg->{'logfiles'}}) {
    my @ca = keys $cfg->{'logfiles'}->{$fn}->{'constraints'};
    my $cnst = \@ca;
    my @aa = keys $cfg->{'logfiles'}->{$fn}->{'assertions'};
    my $asrt = \@aa;
    my @pa = keys $cfg->{'logfiles'}->{$fn}->{'proven_assertions'};
    my $prva = \@pa;
    my $cc = $#{$cnst} + 1; my $ac = $#{$asrt} + 1; my $pc = $#{$prva} + 1;
    my $str = sprintf("processing %-24s c=%02d a=%02d p=%02d", $fn, $cc, $ac, $pc);
    my $ww = 0;
    my $ee = ($ac <= 0) ? 1 : 0;
    $ee += ($pc <= 0) ? 1 : 0;
    $ee += ($ac != $pc) ? 1 : 0;
    $ecnt += $ee;
    if ($ee) {
      ERROR "$str **";
    } elsif ($ww) {
      WARN "$str *";
    } else {
      INFO "$str";
    }
    my $lc = List::Compare->new($asrt, $prva);
    my @a_only = $lc->get_Lonly();
    my @p_only = $lc->get_Ronly();
    if ($#a_only >= 0) {
      ERROR "$fn: " . scalar(@a_only) . " assertions enabled but not proven";
      $ecnt = $ecnt + $#a_only + 1;
      foreach my $a (@a_only) {
        print "  $a\n";
      }
    }
    if ($#p_only >= 0) {
      ERROR "$fn: " . scalar(@p_only) . " assertions proven but not enabled";
      $ecnt = $ecnt + $#p_only + 1;
      foreach my $p (@p_only) {
        print "  $p\n";
      }
    }
    foreach my $a (@{$prva}) {
      foreach my $c (@{$cnst}) {
        TRACE "$fn: adding adjacency list $c $a";
        $cfg->{'adjacency_list'}->{$c}->{$a} = 1;
        $cfg->{'left_nodes'}->{$c} = 1;
        $cfg->{'right_nodes'}->{$a} = 1;
      }
    }
  }
  {
    my $lc = List::Compare->new($cfg->{'left_nodes'}, $cfg->{'right_nodes'});
    my @rootn= $lc->get_Lonly();
    my @leafn = $lc->get_Ronly();
    my @intn  = $lc->get_intersection();
    $cfg->{'root_nodes'} = {map {$_ => 1} @rootn};
    $cfg->{'leaf_nodes'} = {map {$_ => 1} @leafn};
    $cfg->{'intermediate_nodes'} = {map {$_ => 1} @intn};
  }
}

sub report {
  my $opt = shift;
  my $cfg = shift;
  my $depth = shift || 1;

  if (!(($opt->{'ll'} eq "DEBUG") || ($opt->{'ll'} eq "TRACE"))) {
    return;
  }
  report_rl($opt, $cfg);
  report_adjacency_lists($opt, $cfg);
}

sub report_rl {
  my $opt = shift;
  my $cfg = shift;

  my @rootn = keys %{$cfg->{'root_nodes'}};
  ALWAYS "root nodes " . ($#rootn + 1) . ":";
  foreach (@rootn) {
    print "  $_\n";
  }

  my @leafn = keys %{$cfg->{'leaf_nodes'}};
  ALWAYS "leaf nodes " . ($#leafn + 1) . ":";
  foreach (@leafn) {
    print "  $_\n";
  }
 
  my @intn = keys %{$cfg->{'intermediate_nodes'}};
  ALWAYS "intermediate nodes " . ($#intn + 1) . ":";
  foreach (@intn) {
    print "  $_\n";
  }
}

sub report_adjacency_lists {
  my $opt = shift;
  my $cfg = shift;

  if (!($opt->{'ll'} eq "TRACE")) {
    return;
  }
  ALWAYS "adjacency lists:";
  foreach my $av (keys %{$cfg->{'adjacency_list'}}) {
    my $an = $cfg->{'adjacency_list'}->{$av};
    print "  $av\n";
    foreach my $v (keys %{$an}) {
      print "    $v\n";
    }
  }
}

sub isPrimaryDesignConstraint {
  my $opt = shift;
  my $cfg = shift;
  my $des_prop = shift;

  my $rv = 0;
  my $pdc = $cfg->{'design'}->{'properties'}->{'primary_design_constraints'};
  foreach my $pdc (@{$pdc}) {
    if ($des_prop =~ /$pdc/) {
      $rv = 1;
    }
  }
  if ($rv) {
    TRACE "found primary design constraint $des_prop";
  }
  return $rv;
}

sub validate {
  my $opt = shift;
  my $cfg = shift;

  my $design_properties = $cfg->{'design'}->{'assertions'};
  my $design_constraints = [];
  my $design_assertions = [];
  foreach my $dp (@{$design_properties}) {
    if (isPrimaryDesignConstraint($opt, $cfg, $dp)) {
      push @{$design_constraints}, $dp;
    } else {
      push @{$design_assertions}, $dp;
    }
  }

  ALWAYS "found " . ($#{$design_constraints} + 1)  . " primary design constraints";
  if (($opt->{'ll'} eq "DEBUG") || ($opt->{'ll'} eq "TRACE")) {
    if ($#{$design_constraints} >= 0) {
      DEBUG "primary design constraints";
      foreach my $p (@{$design_constraints}) {
        print "  $p\n";
      }
    }
  }

  { 
    # TBD check that primary design constraints are not in the right node list
    my $i = 0; 
  }

  my $pah = {};
  foreach my $fn (sort keys %{$cfg->{'logfiles'}}) {
    foreach my $k (keys $cfg->{'logfiles'}->{$fn}->{'proven_assertions'}) {
      $pah->{$k} = 1; 
    }
  }

  # TBD also get proven assertions from the graph - anything to the right

  my $proven_assertions = [keys %{$pah}]; 

  if ($#{$design_assertions} != $#{$proven_assertions}) {
    my $da = $#{$design_assertions} + 1;
    my $pa = $#{$proven_assertions} + 1;
    ERROR "assertion count from show_all $da mismatches with proven assertion count $pa";
    $ecnt++;
  }

  my $lc = List::Compare->new($design_assertions, $proven_assertions);
  my @a_only = $lc->get_Lonly();
  my @p_only = $lc->get_Ronly();
  if ($#a_only >= 0) {
    ERROR scalar(@a_only) . " assertions in show_all but not proven";
    $ecnt = $ecnt + $#a_only + 1;
    foreach my $a (@a_only) {
      print "  $a\n";
    }
  }
  if ($#p_only >= 0) {
    ERROR scalar(@p_only) . " assertions proven but not in show_all";
    $ecnt = $ecnt + $#p_only + 1;
    foreach my $p (@p_only) {
      print "  $p\n";
    }
  }

  {                             # conditional property pass/fail check

    ALWAYS "conditional property checks\n";
    foreach my $fn (sort keys %{$cfg->{'logfiles'}}) {
      foreach my $pa (sort keys %{$cfg->{'logfiles'}->{$fn}->{'proven_assertions'}}) {
        isPass($pa, $cfg->{'logfiles'}->{$fn}->{'proven_assertions'}->{$pa}->{'type'}, $fn);
      }
    }
  }
  loop_detect($opt, $cfg);
}

sub loop_detect {
  my $opt = shift;
  my $cfg = shift;

  ALWAYS "loop detection";
  my $adj_list = $cfg->{'adjacency_list'};

  my $visited_nodes = {};
  foreach my $av (keys %{$adj_list}) {
    my $level = 0;
    my $node_stack = [];
    push @{$node_stack}, $av;
    $visited_nodes->{$av}->{$av} = 1;
    traverse($adj_list, $visited_nodes, $level, $av, $av, $node_stack);
  }

}

sub traverse {
  my $adjacency_list = shift;
  my $visited_nodes = shift;
  my $level  = shift;
  my $root_node  = shift;
  my $cur_node = shift;
  my $node_stack = shift;

  $level++;
  #print "-- $level $root_node $cur_node @{$node_stack}\n";
  if (exists $adjacency_list->{$cur_node}) { 
    foreach my $next_node (keys %{$adjacency_list->{$cur_node}}) {
      if (($root_node eq $next_node) || (grep (/\Q$next_node\E/, @{$node_stack}))) {
        ERROR "LOOP detected: @{$node_stack} $next_node";
        $ecnt++;
      } else { 
        if (!defined $visited_nodes->{$cur_node}->{$next_node}) {
          push @{$node_stack}, $next_node;
          $visited_nodes->{$cur_node}->{$next_node} = 0;
          traverse ($adjacency_list, $visited_nodes, $level, $root_node, $next_node, $node_stack);
        }
      }
    }
  }
  $level--;
  pop (@{$node_stack});
}

sub isPass {
  my $proven_assert = shift;
  my $pf_type = shift;
  my $file_name = shift;

  my $rv = 0;
  if ($pf_type eq 'Explored') {
    WARN "assert explored $proven_assert";
    $rv = 1;
  } elsif (($pf_type ne 'Pass_Trigger_Pass') &&
      ($pf_type ne 'Pass')) {
    foreach my $cchk (@{$cfg->{'frun'}->{'enabledConditionalChecks'}}) {
      if (defined $cfg->{'design'}->{'properties'}->{'conditional_properties'}->{$cchk}) {
        foreach my $cprop (@{$cfg->{'design'}->{'properties'}->{'conditional_properties'}->{$cchk}}) {
          my $regexp = $cprop->{'regexp'};
          my $etype = $cprop->{'expected'};
          foreach my $rxp (@{$regexp}) {
            if (($proven_assert =~ /$rxp/) && ($etype eq $pf_type)) {
              $rv = 1;
              DEBUG "proven assertion $proven_assert from $file_name matches $cchk conditional check regexp $rxp expected=$etype actual=$pf_type";
            }
          }
        }
      }
    }
  } else {
    TRACE "assert passed failed $proven_assert $pf_type";
    $rv = 1;
  }

  if (!$rv) {
    ERROR "assert failed $proven_assert $pf_type";
    $ecnt++;
  }
}
