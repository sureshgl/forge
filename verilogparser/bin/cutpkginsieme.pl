#!/bin/env perl

# WORK IN PROGRESS. Lot of checks need to be added. Need to organize code into methods.

use strict;
use warnings;
use Carp;
use JSON;
use Getopt::Long;
use File::Path qw(remove_tree);
use FindBin qw($Bin);
use lib "$Bin/../framework";
use InfraUtils;
use Log::Log4perl qw(:easy);

use CutPkgrInsieme;

my $cutpkgr = CutPkgrInsieme->new ();
$cutpkgr->run();

__END__

=pod

=head1 NAME

  cutpkg.pl generates cuts ordered by customer and packages them after running all the required checks.

=head1 AUTHOR

  (c) Memoir Systems Inc. All rights reserved.

=head1 USAGE

  cutpkg.pl -f <cut-json-file> -binpath <binary path> -pkgname <package name> -skip <step1,step2,...> -only <step1,step2,...> -just-print -h

=head1 DESCRIPTION

  This script does the following:
      Generates the specified cuts, validates them (by running simulations, synthesis, cut formal, LEC, lint etc).
      Once validated, it packages the relevant files into a tar ball.
      Untars the package to a new location, validates the contents to ensure that package is as expected.
 
  IMPORTANT:
      cutpkg.pl generates cuts in -noob mode. Hence it assumes that <forge path>/memogen/src/rtl points to
      unencrypted IP. Therefore, if you forge a binary, you will have to mv rtl to some other name (rtl_enc for
      encrypted RTL), and the link verilogparser/ip to rtl ('ln -s ../../verilogparser/ip rtl).

      Also, the build spec used in forge_spec_<name>.json must contain verilog parser. A forge without verilog
      parser included can't be used by cutpkgr.pl.
     


=head1 OPTIONS

=over

=item -f

  Three kinds of files can be supplied as command inputs to cut packager.
  1. Json file containing the cut information from memogen web server.
  2. memogen output json <cut>.jsn (auto-generated during memogen run).
  3. A file containing Memogen commandlines


=item -binpath

  Forge binary path. Example: /auto/proj/users/raju/t1/forge/MTKTSMC28HPM/3.3.6868
  This will override the path specified in json/memogen cmd file.


=item -pkgdir

  The directory in where the cut packaging is done is specified using -pkgdir.

=item -pkgname

  A unique pacakge name can be specified over commandline that will override the package
  name specified in the json file. If -pkgname is not specified over command line nor in
  json file, a default package name is constructed in <vendor>_<tech>_<cut name> format.


=item -skip <step1,step2,...>

  If specified, the steps mentioned (in comma seperated format) will be excluded from running. All other steps will be run.


=item -only <step1,step2,...>

  If specified, only steps mentioned (in comma seperated format) will be run. All other steps will be skipped.

=item -real

  If specified, real (RTL) packager steps are run. Func/Behave models are excluded from packaging and checks.

=item -<sim tool name>

  This option enables us to narrow down the encryption/simulation tools to be used to save time.  Options available here are -ncv, -vcs, and -vsim.

  Example: Specifying '-ncv -vcs' will result in running ncv+vcs encryption and simulations. Mentor vsim is excluded.

=item -h

  Will display cutgen.pl usage help.


=item -just-print

  Will print all the commads that are executed within the script (without actually executing them).


=back  

=head1 EXAMPLES

=head2 Example 1: -skip

     Cut generation, funcitonal simulations, and lint can be excluded from running using the following commandline:

         cutpkg.pl -f mediatek_order1234.jsn -pkgname mtk_20140101 -skip cutgen,sims,lint

=head2 Example 2: -skip

     Only formal and fchecker steps can be run as follows:

         cutpkg.pl -f mediatek_order1234.jsn -pkgname mtk_20140102 -only frun,fcheck

=head2 Example 3: -binpath

     Only formal and fchecker steps can be run as follows:

         cutpkg.pl -f mediatek_order1234.jsn -binpath /auto/proj/users/raju/forge/MEMOGEN_INTERNAL/3.3.1234 -pkgname mtk_20140102 -only frun,fcheck

=head1 Addiitonal Information
----------------------


=head2 Encoding of steps to be used with -skip and -only options:

     The encoding used for specifying the steps to be excluded (using -skip) or included (using -only) are as follows:

     Step No. Name                       Step
     -------  ----                       ----
     1.       Cut Generation             cutgen
     2.       Functional(dynamic) sims   sims
     3.       Error injection            err
     4.       RC Synthesis               rcsyn
     5.       DC Synthesis               dcsyn
     6.       Synthesis                  syn
     7.       RC Gate sims               rcgate
     8.       DC Gate sims               dcgate
     9.       RC LEC                     rclec
     10.      DC LEC                     dclec
     11.      DC Formality               form
     12.      Lint                       lint
     13.      Cut Formal                 frun
     14.      fCheck                     fcheck
     15.      Unroll cuts                unroll
     16.      Package cuts               pkg
     17.      Post package checks        post
     18.      Post package synthesis     postsyn

     NOTE: For cut delivery, steps #1, 14,15,16, and 17 are enough. These are enabled by default, and rest are disabled by default. Therefore, for default pkg runs, -only/skip is not required.

=head2 Sample cut json file:  

     {
       "cmdLine":"-v mtk -t tsmc28hpm -a 1R1W_B10 -b 32 -f 1 -w 1024 -tl 2 -nr 5 -nofile -name mem_1R1W_1024x32x500",
       "version":"3.3.6778M",
       "binaryPath":"/auto/proj/users/raju/perforce/t3/forge/MTKTSMC28HPM/3.3.6778M",
       "vendor":"mtk",
       "tech":"tsmc28hpm",
       "jobId":100,
       "groupName":"MediaTek",
       "packagePath":"/auto/proj/users/web/workdir/cuts/MTK_Grp",
       "packageName":"MediaTek1234",
       "orders":[{"cid":"C1","rid":2,"cutId":46,"macroId":60,"orderId":25,"cutName":"mem_1R1W_1024x32x500_1"},{"cid":"C1","rid":5,"cutId":46,"macroId":64,"orderId":26,"cutName":"mem_1R1W_1024x32x500_4"}]
     }
=cut
