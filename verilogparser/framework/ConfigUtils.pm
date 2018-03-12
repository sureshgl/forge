package ConfigUtils;
use Exporter;
@ISA = qw (Exporter);
@EXPORT = qw (
               getAlgoConfigFile isUnencryptedMode
	       getVendor getTech  getMode
             );
use strict;
use warnings "all";
use Carp;
use Test::Deep qw(deep_diag);
use Test::Builder;
 
use PathUtils; 
  
my $modemap = 
{
      "ARM40"     =>  {"vendor" => "arm",       "tech" => "tsmc40g"},            
      "IBM32OLD"  =>  {"vendor" => "ibm",       "tech" => "cu-32hp"},                        
      "IBM32"     =>  {"vendor" => "ibm",       "tech" => "cu32hp"},                         
      "IBM32AS22" =>  {"vendor" => "ibm",       "tech" => "cu-32hp_as22"},
      "AVAGO28"   =>  {"vendor" => "avago",     "tech" => "28nm"}
};

sub getAlgoConfigFile{
  my $vendor = shift;
  my $tech = shift;
  return getAlgoConfigDir().$vendor."_".$tech.".jsn";
}

sub getVendor {
  my $mode = shift;
  confess "Mode not found  -- $mode " if !defined $modemap->{$mode};
  return  $modemap->{$mode}->{"vendor"};
}
  
sub getTech {
  my $mode = shift;
  confess "Mode not found  -- $mode " if !defined $modemap->{$mode};
  return  $modemap->{$mode}->{"tech"};
}   

sub getMode {
  my $vendor = shift;
  my $tech   = shift;
  my $mode = $modemap;

  foreach my $key (keys %$mode) {
    if (($mode->{$key}->{'vendor'} eq $vendor)  && $mode->{$key}->{'tech'} eq $tech) {
      return $key;
      last;
    }
  }
  return 0;
}
 
sub isUnencryptedMode{
  return defined $ENV{'MEMOGEN_UNENCRYPTED_MODE'};
}

1;
