#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use Cwd 'realpath';
use File::Basename;


my $tot = realpath(dirname(__FILE__));
chdir($tot);
my $cmd = "git log --pretty=format:'%h' -n1";
my $ver = `$cmd`;
if($?){
  $ver = "UNKNOWNA";
}
my $isPerforce = "git describe --exact-match ".$ver ." 2> /dev/null";
my $verTmp = `$isPerforce`;
my $commitAhead = "";
chomp($verTmp);
if($verTmp =~/\s*(\d+)$/){
  $ver = $verTmp;
}else{
  my @lines = `git status`;
  if($?){
    $ver = "UNKNOWNC";
  }
  chomp($lines[1]);
  if($lines[1] =~  /^\s*Your\s*branch\s*is\s*ahead\s*of\s*\'\s*origin\s*\/\s*master\s*\'\s*by\s*(\d+)\s*commits\s*\.(.*)$/){
    $cmd = "git log --pretty=format:'%h_%at' -n1 --skip=".$1;
    $commitAhead = $1;
    $ver = `$cmd`;
    $ver = timeConverter($ver);
  }else{
    $cmd = "git log --pretty=format:'%h_%at' -n1";
    $ver = `$cmd`;
    $ver = timeConverter($ver);
  }
}
my @status = `git status -s`;
if($?){
  $ver = "UNKNOWND";
}else{
  foreach my $line (@status){
    if(($line =~ /^\s*M(.*)/) || ($line =~ /^\s*A(.*)/) || ($line =~ /^\s*D(.*)/) || ($commitAhead ne "")){
      chomp($ver);
      $ver = $ver."M";
      last;
    }
  }
}
print "$ver\n";

sub timeConverter {
  my $ver = shift;
  if($ver =~ /^(.*)_(.*)\s*/){
    my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($2);
    my $time =  sprintf("%02d%02d%02d%02d%02d%02d", ($year+1900), $mon+1,$mday, $hour, $min, $sec);
    $ver = $1."_".$time;
  }
  return $ver;
}
