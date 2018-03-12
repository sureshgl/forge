###
#  DUMB UTILS to list all paths. 
###

package PathUtils;
use Exporter;
@ISA = qw (Exporter);
@EXPORT = qw (
		getTot
                  getMemoverseDir
                    getEstimatorDir
                        getAlgoConfigDir
                    getMemogenDir
                    getConfigsDir
                    getLibsDir
                    getAlgoDir
                  getIpDir
                  getIpObfDir
                  getIpEncDir
                  getMemochkDir
                  getCommonDir
                  
             );
use strict;
use warnings "all";
use Carp;
use Cwd;
use Cwd 'realpath';
use File::Basename;
use Test::Deep qw(deep_diag);
use Test::Builder;

my $cached = {};

sub getTot 		{return getCached("Tot", 		sub{return realpath(dirname(__FILE__) . "/../../../")."/";}); }
sub getCommonDir	{return getCached("CommonDir", 		sub{return getTot()."common/";}); }
sub getMemochkDir	{return getCached("MemochkDir", 	sub{return getTot()."memochk/";}); }
sub getIpDir		{return getCached("IpDir", 		sub{return getTot()."ip/";}); }
sub getIpObfDir		{return getCached("IpObfDir", 		sub{return getTot()."ip_obfuscated/";}); }
sub getIpEncDir		{return getCached("IpEncDir", 		sub{return getTot()."ip_encrypted/";}); }
sub getMemoverseDir	{return getCached("MemoverseDir", 	sub{return getTot()."memoverse/";}); }
sub getEstimatorDir	{return getCached("EstimatorDir", 	sub{return getMemoverseDir()."estimator/";}); }
sub getMemogenDir	{return getCached("MemogenDir", 	sub{return getMemoverseDir()."memogen/";}); }
sub getConfigsDir	{return getCached("ConfigsDir", 	sub{return getMemoverseDir()."configs/";}); }
sub getLibsDir		{return getCached("LibsDir", 		sub{return getMemoverseDir()."libs/";}); }
sub getAlgoDir		{return getCached("AlgoDir", 		sub{return getMemoverseDir()."algo/";}); }
sub getAlgoConfigDir	{return getCached("AlgoConfigDir",	sub{return getEstimatorDir()."cfg/algo_configs/";}); }

sub getCached{
  my $name = shift;
  my $fn = shift;
  $cached->{$name} = $fn->() if (not defined $cached->{$name});
  return $cached->{$name};
}

1;
