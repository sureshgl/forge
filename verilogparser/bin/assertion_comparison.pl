#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;
use HTML::TreeBuilder;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Data::Dumper;

my $opt = {
           'left'         => "", 
           'right'        => ""
          };
my $rv = GetOptions ($opt,
                     'left=s',
                     'right=s'
                    );
if ( !$rv ||
     $opt->{'left'} eq "" ||
     $opt->{'right'} eq "" ) {
  print "Usage: $0 -left <left-file> -right <right-file>\n";
  exit(1);
}

my $left =1;
my $Right =2;
my %totalsummaryhash1 = getTotalSummaryHash($opt->{'left'},$left);
my %totalsummaryhash2 = getTotalSummaryHash($opt->{'right'},$Right);
my $totalSummaryErr = 0;

my @tableNames1;
my @tableNames2;
my $globalErr = 0;

print "Top Level Assertion comparison in both DataBase"."\n";
foreach my $l1 (keys %totalsummaryhash1) {
  print "----------------------------------------------------"."\n";
  print "Table Name  \"". $l1. "\"  Check "."\n";
  foreach my $l2 (keys $totalsummaryhash1{$l1}) {
    if (defined($totalsummaryhash2{$l1}{$l2})) {
      foreach my $l3 (keys $totalsummaryhash1{$l1}{$l2}) {
        if ($totalsummaryhash1{$l1}{$l2}{$l3} != $totalsummaryhash2{$l1}{$l2}{$l3}) {
          print "\n";
          print $l2. " Row  ". "\t". $l3. " column ". "\t"."Left DataBase :=". $totalsummaryhash1{$l1}{$l2}{$l3}."\t"."Right DataBase :=".$totalsummaryhash2{$l1}{$l2}{$l3}."\n";
          print "\n";
          $totalSummaryErr++;
          $globalErr++;
        }
      }
    }
  }
  print "----------------------------------------------------"."\n";
}

if (!$totalSummaryErr) {
  print "----------------------------------------------------"."\n";
  print " TOP LEVEL ASSERTION COMPARISON CHECK PASSED"."\n";
  print "----------------------------------------------------"."\n";
} else {
  print "----------------------------------------------------"."\n";
  print " TOP LEVEL ASSERTION COMPARISON CHECK FAILED"."\n";
  print "----------------------------------------------------"."\n";
}
my %pagehash1 = getHash($opt->{'left'},\@tableNames1);
my %pagehash2 = getHash($opt->{'right'},\@tableNames2);



assertTableComp(\%pagehash1,\%pagehash2);


if ( $globalErr) {
  print "----------------------------------------------------"."\n"; 
  print "ASSERTIONS RESULTS ARE NOT MATCHING IN BOTH DATABASES. PLEASE FIX AND RERUN AGAIN.  RESULT \"FAILED \""."\n";
  print "----------------------------------------------------"."\n";
} else {
  print "----------------------------------------------------"."\n";
  print "ASSERTIONS RESULTS MATCH IN BOTH DATABASES. RESULT \"PASSED \""."\n";
  print "----------------------------------------------------"."\n";
}

if ($globalErr != 0) {
  print "Error: NOT good\n";
  exit(1);
}

#print Dumper (\%pagehash1)."\n\n";

sub assertTableComp {

  my %table1 = %{$_[0]};
  my %table2 = %{$_[1]};
  my $tableCheck = 0;
  my $assertCheck = 0;

  print "Check to make sure if both databases have same tables".  "\n";
  foreach my $l1 (keys %table1) {
    if (defined($table2{$l1})) {
      #print "Assert Table Name := ". "\t". $l1. " \"Found\" in Both Data Bases ".  "\n";
    } else {
      print "Assert Table Name := ". "\t".  $l1 .  "Found in  Left  Data Base.But  \"Not Found \" in Right  Data Bases ".  "\n";
      $tableCheck++;
      $globalErr++;
    }
  }

  foreach my $l1 (keys %table2) {
    if (defined($table1{$l1})) {
      #print "Assert Table Name := ". "\t". $l1. " \"Found\" in Both Data Bases ".  "\n";
    } else {
      print "Assert Table Name := ". "\t".  $l1 .  "Found in Right  Data Base.But  \"Not Found \" in Left Data Bases ".  "\n";
      $tableCheck++;
      $globalErr++;
    }
  }

  if (!$tableCheck) {

    print "----------------------------------------------------"."\n";
    print "BOTH DB'S HAVE SAME TABLES. NOW WE START CHECK FOR ASSERTIONS IN EACH TABLES.".  "\n";
    print "----------------------------------------------------"."\n";
    foreach my $l1 (keys %table1) {
      foreach my $l2 (keys $table1{$l1}) {
        if (defined($table2{$l1}{$l2})) {
          foreach my $l3 (keys $table1{$l1}{$l2}) {
            if ($table1{$l1}{$l2}{$l3} != $table2{$l1}{$l2}{$l3}) {
              print "----------------------------------------------------"."\n";
              print "Mismatch in \"". $l1. "\" Table "."\n";
              print $l2. " in ". "\t". $l3. " column ". "\t".$table1{$l1}{$l2}{$l3}."\t".$table2{$l1}{$l2}{$l3}."\n";
              print "----------------------------------------------------"."\n";
              $assertCheck++;
              $globalErr++;
              #print $l2.":\n".$l3."\t".$table1{$l1}{$l2}{$l3}."\t".$table2{$l1}{$l2}{$l3}."\n";
            }
          }
        }
      }
    }
  } else {

    print "BOTH DB's HAVE NOT SAME TABLES.".  "\n";

  }
  if ( $assertCheck) {
    print "----------------------------------------------------"."\n"; 
    print "INDIVIDUAL ASSERTIONS ARE NOT MATCHING IN BOTH DATABASES. PLEASE FIX AND RERUN AGAIN.  RESULT \"FAILED \""."\n";
    print "----------------------------------------------------"."\n";
  } else {
    print "----------------------------------------------------"."\n";
    print "INDIVIDUAL ASSERTIONS MATCH IN BOTH DATABASES. RESULT \"PASSED \""."\n";
    print "----------------------------------------------------"."\n";
	
  }
}
sub getTotalSummaryHash {

  my $page = $_[0];
  my $idx = $_[1];
  my $html = HTML::TreeBuilder->new;
  my $root = $html->parse_file($page);
  my %myfullhash = ();

  my @tables = $root->look_down(_tag => q{table});
  my $tabIdx = 0;

  for my $table (@tables) {
    if ($tabIdx < 3) {
      my @rows = $table->look_down(_tag => q{tr});
      my $rowIdx = 0;
      my %myhash = ();
      for my $row (@rows) {
        if ($rowIdx == 0) {
          $rowIdx++;
          next;
        }
        my %rowhash = ();
        my @cols = $row->look_down(_tag => q{td});
        if (@cols == 4) {
          $rowhash{'ASSERT'} = $cols[1]->as_text;
          $rowhash{'PROPERTIES'} = $cols[2]->as_text;
          $rowhash{'SEQUENCES'} = $cols[3]->as_text;
          $myhash{$cols[0]->as_text} = \%rowhash;
        } elsif (@cols == 3) {
          $rowhash{'NUMBER'} = $cols[1]->as_text;
          $rowhash{'PERCENT'} = $cols[2]->as_text;
          $myhash{$cols[0]->as_text} = \%rowhash;
        }  

      }
      if ($tabIdx == 0) {
        $myfullhash{'Assertions by Category'} = \%myhash;
      } elsif ($tabIdx == 1) {
        $myfullhash{'Assertions by Severity'} = \%myhash;
      } elsif ($tabIdx == 2) {
        $myfullhash{'Summary for Assertions'} = \%myhash;
      }
      $tabIdx++;
    }
  }

  my $arrCnt =0;
  foreach my $l2 (keys $myfullhash{'Summary for Assertions'}) {
    if ($myfullhash{'Summary for Assertions'}{$l2}{'NUMBER'} != 0 &&  $l2 ne "Total Number") {
      if ($idx == 1) {
        $tableNames1[$arrCnt++] =  $l2;
      } elsif ($idx == 2) {
        $tableNames2[$arrCnt++] =  $l2;
      }
    }
  }



  return %myfullhash;
}

sub getHash {

  my $page = $_[0];
  my @tableName = @{$_[1]};
  print "table elements count : ".@tableName."\n";
  print "Individual Assertion Tables"."\n";
  for my $tn (@tableName) {
    print "table Name : $tn\n";
  }
  my $html = HTML::TreeBuilder->new;
  my $root = $html->parse_file($page);

  my %myfullhash = ();
  #my %myhash1 = ();
  #my %myhash2 = ();

  my @tables = $root->look_down(_tag => q{table});
  my $tabIdx = 0;
  my $tabloop = 0;

  for my $table (@tables) {
    if (($tabIdx > 2 ) && ( $tabIdx < (@tables-1))) {
      my $tableStr = "";
      my @rows = $table->look_down(_tag => q{tr});
      my $rowIdx = 0;
      my %myhash = ();
      for my $row (@rows) {
        if ($rowIdx == 0) {
          $rowIdx++;
          next;
        }
        my %rowhash = ();
        my @cols = $row->look_down(_tag => q{td});
        if (@cols == 7) {
          $rowhash{'category'} = $cols[1]->as_text;
          $tableStr .= $cols[1]->as_text;
          $rowhash{'severity'} = $cols[2]->as_text;
          $tableStr .= $cols[2]->as_text;
          $rowhash{'attempts'} = $cols[3]->as_text;
          $tableStr .= $cols[3]->as_text;
          $rowhash{'realsuccess'} = $cols[4]->as_text;
          $tableStr .= $cols[4]->as_text;
          $rowhash{'failures'} = $cols[5]->as_text;
          $tableStr .= $cols[5]->as_text;
          $rowhash{'incomplete'} = $cols[6]->as_text;
          $tableStr .= $cols[6]->as_text;
          $myhash{$cols[0]->as_text} = \%rowhash;
          $tableStr .= $cols[0]->as_text;

        } else {
          last;
        }
        $rowIdx++;
      }
      #my $digest = md5_hex($tableStr);
      #$myhash{'checksum'} = md5_hex($tableStr);
      #$myfullhash{"table".$tabIdx} = \%myhash
      $myfullhash{$tableName[$tabloop++]} = \%myhash
    }
    $tabIdx++;
  }

  #$myfullhash{'table1'} = \%myhash1;
  #$myfullhash{'table2'} = \%myhash2;
  return %myfullhash;
}

