#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use FindBin qw($Bin);
use FileHandle;
use File::Basename;
use Data::Dumper;
use JSON;
use Cwd;
use Cwd 'realpath';
use IPC::Run3;
use Log::Log4perl qw(:easy);

Log::Log4perl->easy_init( { level   => $INFO,
                            file    => "STDOUT",
                            layout   => '%d:[%.1p]: %m%n'} );

my $opt = {
    'name'         => "",  # cut name
    'w   '         => "",  # cut name
    'b   '         => "",  # cut name
    'help'         => 0,
    'h'            => 0
};

ALWAYS "cmdline: $0 @ARGV\n";
my $rv = GetOptions ($opt,
                     'name=s',
                     'w=s',
                     'b=s',
                     'help!',
                     'h!'
                    );

if ( !$rv ||
     !(defined $opt->{'name'})   || ($opt->{'name'} eq '') ||
     !(defined $opt->{'w'})  || ($opt->{'w'} eq '') ||
     !(defined $opt->{'b'})   || ($opt->{'b'} eq '') ||
     $opt->{'h'} ||
     $opt->{'help'}
   ) {
    print "Usage: $0 -name <cut-name> [-h|-help]\n";
    print " This script does something specific for insieme\n";
    print " The cut.v and cut_func.v module definitions are pulled in to *cut.v*\n";
    print " [yes the output file name is cut.v] surrounded by `ifdef MEMOIR_FUNC_MODEL\n";
    print "   -name : cut name\n";
    print "   -w    : words\n";
    print "   -b    : bits\n";
    print "   -h    : to print this message\n";
    exit(1);
}

my $cwd = realpath(getcwd);
my $cmd = "";

my $cut_v      = "../rtl_unrolled/" .  $opt->{'name'} . ".v";
my $cut_func_v = "../rtl_unrolled/" .  $opt->{'name'} . "_func.v";
my $cut_dest_v = "../rtl_encrypted/" . $opt->{'name'} . ".v";

if (!-e $cut_v) {
  LOGDIE "$cut_v - not found";
}

if (!-e $cut_func_v) {
  LOGDIE "$cut_func_v - not found";
}

$cmd = "\\mkdir -p ../rtl_encrypted";
vsystem($cmd);

{
  my $fhr = FileHandle->new( $cut_v, "r" );
  if ( !defined $fhr ) {
    LOGDIE "failed to open $cut_v for read\n";
  }
  my $fhf = FileHandle->new( $cut_func_v, "r" );
  if ( !defined $fhf ) {
    LOGDIE "failed to open $cut_func_v for read\n";
  }
  my $fho = FileHandle->new( $cut_dest_v, "w" );
  if ( !defined $fho ) {
    LOGDIE "failed to open $cut_dest_v for write\n";
  }

  print $fho "`ifndef MEMOIR_FUNC_MODEL\n";
  my $bist_sig_decl_a = [];
  my $bist_sig_decl_b = [];
  my $bist_sig_output = [];
  while (<$fhr>) {
    print $fho $_;
    if (/^input mem16_/) {
      push @{$bist_sig_decl_a}, $_;
    }
    if (/^input core_(mem|bist)_/) {
      push @{$bist_sig_decl_a}, $_;
    }
    if (/^output (t._bist_done_(pass|fail)_out)\,$/) {
      push @{$bist_sig_output}, $1;
      push @{$bist_sig_decl_b}, $_;
    }
    if (/^output \[.*\] (t._bist_done_(pass|fail)_out)\,$/) {
      push @{$bist_sig_output}, $1;
      push @{$bist_sig_decl_b}, $_;
    }
  }
  if ($#{$bist_sig_decl_a} < 0) {
    LOGDIE "no core bist sig declaration in real.v";
  }
  if ($#{$bist_sig_decl_b} < 0) {
    LOGDIE "no bist pass/fail sig declaration in real.v";
  }
  if ($#{$bist_sig_output} < 0) {
    LOGDIE "no bist pass/fail signal name identified in real.v";
  }

  print $fho "`else\n";
  my $f = 0;
  while (<$fhf>) {
    if (/^module (.*)_func$/) {
      print $fho "module $opt->{'name'}\n";
      $f = 1;
    } elsif ($_ =~ /^#\(\)/ && $opt->{'w'} ne "" && $opt->{'b'} ne "") {
      $_ =~ s/#\(\)/#\(parameter DEPTH = $opt->{'w'}, parameter WIDTH = $opt->{'b'}\)/;
      print $fho $_;
    } elsif (/^output ready\,$/) {
      print $fho $_;
      print $fho @{$bist_sig_decl_a};
    } elsif (/^input dbg_en\,$/) {
      print $fho @{$bist_sig_decl_b};
      print $fho $_;
    } elsif (/^\s*\`ifdef CUSTOMER_DPIS$/) {
      foreach my $bo (@{$bist_sig_output}) {
        print $fho "assign $bo = 'h0;\n";
      }
      print $fho $_;
    } else {
      print $fho $_;
    }
  }
  if (!$f) {
    LOGDIE "module name regexp failed\n";
  }

  print $fho "`endif\n";

  $fhr->close();
  $fhf->close();
  $fho->close();
}

sub vsystem {
    my $cmd = shift;

    INFO "* $cmd\n";

    my $rv = run3 ($cmd, undef, undef, undef, {'return_if_system_error' => 1});

    my $es   = $?;
    my $en   = $!;
    my $estr = $@;

    if ($rv != 1) {
        LOGDIE "$cmd failed\n";
    }
    if ($es) {
        LOGDIE "$cmd exited with non-zero status : $es : $en : $estr\n";
    }
}
