package CutPkgrInsieme;
use strict;
use warnings;
use DateTime;
use Carp;
use Cwd;
use Cwd 'realpath';
use Mail::Send;
use File::Find::Rule;
use File::Basename;
use Test::Deep qw(deep_diag);
use Test::Builder;
use FileHandle;
use JSON;
use Sys::Hostname;
use InfraUtils;
use Getopt::Long;
use Pod::Usage;
use Log::Log4perl qw(:easy);
use MemogenUtils;
use Data::Dumper;
use List::Compare;
use List::MoreUtils qw(uniq);
use Text::CSV_XS;


# ----------------------------------------------------------------------
# static global
# ----------------------------------------------------------------------
our $TEST;
our $ecnt;
our $err_log;
our $wcnt;
our $wrn_log;

my @sims       = qw (real_mem func_mem);
my @sims_short = qw (real_mem);
my @encTools   = qw (ncv vcs vsim velo);
my @tools      = qw (ncv vcs vsim);
my $simLogFile = "sim.log";
my $simPassString = '\[testbench\] Simulation PASSED';

my $rcSynLogFile = "rc.log";
my $rcSynCmdFile = "rc.cmd";
my $rcSynPassString = "No unresolved references in design";

my $dcSynLogFile = "dc.log";
my $dcSynPassString = "^Linking succeeded";

####################### DC Warning waivers ########################
# TIM-134 : High fanout net
# TIM-164 : trip points for the library named <lib1> differ from
#           those in the library named <lib2>
# SEL-003 : Nothing implicitly matched 'clk'
# VER-318 : Signed to unsigned conversion
# VER-329 : Parameter keyword used in local parameter declaration
# VO-4    : Verilog 'assign' or 'tran' statements are written out
# VO-11   : Verilog writer has added <\d+> nets
###################################################################
my @dcWaiverList = ("TIM-134", "TIM-164", "SEL-003", "VER-318", "VER-329", "VO-4", "VO-11", ": Operating condition", "Filename too long");

my $lecLogFile = "lec.log";
my $lecDCLogFile = "lec_dc.log";
my $lecPassString = "No of diff points\\s+= 0";

my $formalityLogFile = "fm.log";
my $formalityPassString = "Verification SUCCEEDED";

####################### LINT Warning waivers ########################
# Lint-[VCDE]   : Compiler directive encountered
# Lint-[UI]     : Unused input
# Lint-[CAWM-L] : Width mismatch
# Lint-[VNGS]   : Variable never gets set
# Lint-[ZERO]   : Zero delay in the design
#####################################################################
my @vcsLintWaiverList = ("Lint-[VCDE]", "Lint-[UI]", "Lint-[CAWM-L]", "Lint-[VNGS]");
my @dcLintWaiverList = ("(LINT-1)","(LINT-2)", "(LINT-28)", "(LINT-29)", "(LINT-31)", "(LINT-32)", "(LINT-33)","(LINT-52)");

# ----------------------------------------------------------------------
# static local
# ----------------------------------------------------------------------
# None

# ----------------------------------------------------------------------
# program constructor
# ----------------------------------------------------------------------
BEGIN {
  Log::Log4perl->easy_init({ level   => $INFO,
                             file    => "STDOUT",
                             layout   => '%d:[%.1p]: %m%n'});
  $TEST = Test::Builder->new();        # construct test harness
}

# ----------------------------------------------------------------------
# public methods
# ----------------------------------------------------------------------

sub new {
  my ( $class ) = @_;

  my $self = bless( {}, $class );

  $ecnt = 0;

  my $cfg  = {};
  my $opt  = {};

  $self->{'opt'}    = $opt;
  $self->{'cfg'}    = $cfg;

  $opt->{'f'}          =  "";
  $opt->{'pkgdir'}     =  "";
  $opt->{'pkgname'}    =  "";
  $opt->{'skip'}       =  "";
  $opt->{'only'}       =  "";
  $opt->{'real'}       =  "";
  $opt->{'func'}       =  "";
  $opt->{'beh'}        =  "";
  $opt->{'ncv'}        =  "";
  $opt->{'vcs'}        =  "";
  $opt->{'vsim'}       =  "";
  $opt->{'rc'}         =  "";
  $opt->{'dc'}         =  "";
  $opt->{'binpath'}    =  "";
  $opt->{'ajp'}        =  "";
  $opt->{'just-print'} =  0;
  $opt->{'h'}          =  0;
  $opt->{'np'}         =  0;    # no prompt


  $self->getOptions();
  $self->validateOptions();
  $self->init();

  return $self;
}

sub getOptions {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;


  my @args = @ARGV;

  ALWAYS "cmdline: $0 @args";

  my $opt = $self->{'opt'};

  my $rv = GetOptions ($opt,
                       'f=s',
                       'pkgdir=s',
                       'pkgname=s',
                       'skip=s',
                       'only=s',
                       'binpath=s',
                       'ajp=s',
                       'func!',
                       'beh!',
                       'real!',
                       'ncv!',
                       'vcs!',
                       'vsim!',
                       'rc!',
                       'dc!',
                       'np!',
                       'h!',
                       'just-print!'
                      );

  if (!$rv) {
    pod2usage ({-verbose => 2, -exit_status => 1});
  }
}

sub validateOptions {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;


  my $opt = $self->{'opt'};
  my $cfg = $self->{'cfg'};

  $cfg->{'steps'}->{'CutGen'}      = 1;
  $cfg->{'steps'}->{'Sims'}        = 1;
  $cfg->{'steps'}->{'ErrInj'}      = 1;
  $cfg->{'steps'}->{'Synth'}       = 1;
  $cfg->{'steps'}->{'dcSynth'}     = 1;
  $cfg->{'steps'}->{'GSims'}       = 1;
  $cfg->{'steps'}->{'DCGSims'}     = 1;
  $cfg->{'steps'}->{'RCLec'}       = 1;
  $cfg->{'steps'}->{'DCLec'}       = 1;
  $cfg->{'steps'}->{'Formality'}   = 1;
  $cfg->{'steps'}->{'Lint'}        = 1;
  $cfg->{'steps'}->{'Unroll'}      = 1;
  $cfg->{'steps'}->{'CutFormal'}   = 0;
  $cfg->{'steps'}->{'FCheck'}      = 0;
  $cfg->{'steps'}->{'Pkg'}         = 1;
  $cfg->{'steps'}->{'PostVCSLint'} = 1;
  $cfg->{'steps'}->{'PostDCLint'}  = 1;
  $cfg->{'steps'}->{'PostSimChks'} = 1;
  $cfg->{'steps'}->{'PostSynChks'} = 0;

  if (($opt->{'f'} eq '') ||
      ($opt->{'h'})
     ) {
    pod2usage ({-verbose => 2, -exit_status => 1});
  }

  {
    $opt->{'f'} = realpath($opt->{'f'});
    if (!-e $opt->{'f'}) {
      LOGDIE ("ValidateOptions: Cut JSON file doesn't exist");
    }
  }

  if ($opt->{'real'}) {
    @sims = qw(real_mem func_mem);
    @sims_short = qw(real_mem);
  }

  if ($opt->{'beh'}) {
    push (@sims, 'beh_mem');
    push (@sims_short, 'beh_mem');
  }

  if ($opt->{'ncv'}) {
    @tools = qw(ncv);
  }

  if ($opt->{'vcs'}) {
    @tools = qw(vcs);
  }

  if ($opt->{'vsim'}) {
    @tools = qw(vsim);
  }

  my @skip;
  my @only;

  if ($opt->{'skip'} ne "") {
    if ($opt->{'only'} ne "") {
      LOGDIE ("Only one of -skip and -only are allowed, not both. Use 'cutpkgr.pl -h' for help.");
    } else {
      @skip = split(',', $opt->{'skip'});
    }
  } else {
    if ($opt->{'only'} ne "") {
      @only = split(',', $opt->{'only'});
      $cfg->{'steps'}->{'CutGen'}      = 0;
      $cfg->{'steps'}->{'Sims'}        = 0;
      $cfg->{'steps'}->{'ErrInj'}      = 0;
      $cfg->{'steps'}->{'Synth'}       = 0;
      $cfg->{'steps'}->{'dcSynth'}     = 0;
      $cfg->{'steps'}->{'GSims'}       = 0;
      $cfg->{'steps'}->{'DCGSims'}     = 0;
      $cfg->{'steps'}->{'RCLec'}       = 0;
      $cfg->{'steps'}->{'DCLec'}       = 0;
      $cfg->{'steps'}->{'Formality'}   = 0;
      $cfg->{'steps'}->{'Lint'}        = 0;
      $cfg->{'steps'}->{'Unroll'}      = 0;
      $cfg->{'steps'}->{'CutFormal'}   = 0;
      $cfg->{'steps'}->{'FCheck'}      = 0;
      $cfg->{'steps'}->{'Pkg'}         = 0;
      $cfg->{'steps'}->{'PostVCSLint'} = 0;
      $cfg->{'steps'}->{'PostDCLint'}  = 0;
      $cfg->{'steps'}->{'PostSimChks'} = 0;
      $cfg->{'steps'}->{'PostSynChks'} = 0;

    }
  }
  foreach my $skipArg (@skip) {
    if ($skipArg =~ /cut/) {
     $cfg->{'steps'}->{'CutGen'}      = 0;
    } elsif ($skipArg =~ /^sim/) {
     $cfg->{'steps'}->{'Sims'}        = 0;
    } elsif ($skipArg =~ /^err/) {
     $cfg->{'steps'}->{'ErrInj'}      = 0;
    } elsif ($skipArg =~ /^rcsyn/) {
     $cfg->{'steps'}->{'Synth'}       = 0;
    } elsif ($skipArg =~ /^dcsyn/) {
     $cfg->{'steps'}->{'dcSynth'}     = 0;
    } elsif ($skipArg =~ /rcgate/) {
     $cfg->{'steps'}->{'GSims'}       = 0;
    } elsif ($skipArg =~ /dcgate/) {
     $cfg->{'steps'}->{'DCGSims'}     = 0;
    } elsif ($skipArg =~ /^rclec/) {
     $cfg->{'steps'}->{'RCLec'}       = 0;
    } elsif ($skipArg =~ /^dclec/) {
     $cfg->{'steps'}->{'DCLec'}       = 0;
    } elsif ($skipArg =~ /^for/) {
     $cfg->{'steps'}->{'Formality'}   = 0;
    } elsif ($skipArg =~ /^lint/) {
     $cfg->{'steps'}->{'Lint'}        = 0;
    } elsif ($skipArg =~ /^unr/) {
     $cfg->{'steps'}->{'Unroll'}      = 0;
    } elsif ($skipArg =~ /^frun/) {
     $cfg->{'steps'}->{'CutFormal'}   = 0;
    } elsif ($skipArg =~ /fch/) {
     $cfg->{'steps'}->{'FCheck'}      = 0;
    } elsif ($skipArg =~ /^pkg/) {
     $cfg->{'steps'}->{'Pkg'}         = 0;
    } elsif ($skipArg =~ /^postvcs/) {
     $cfg->{'steps'}->{'PostVCSLint'} = 0;
    } elsif ($skipArg =~ /^postdc/) {
     $cfg->{'steps'}->{'PostDCLint'}  = 0;
    } elsif ($skipArg =~ /^postsim/) {
     $cfg->{'steps'}->{'PostSimChks'} = 0;
    } elsif ($skipArg =~ /^postsyn/) {
     $cfg->{'steps'}->{'PostSynChks'} = 0;
    } else {
      LOGDIE("ValidateOptions: Skip option \"$skipArg\" not understood. Terminating...");
    }
  }
  foreach my $onlyArg (@only) {
    if ($onlyArg =~ /cut/) {
     $cfg->{'steps'}->{'CutGen'}      = 1;
    } elsif ($onlyArg =~ /^sim/) {
     $cfg->{'steps'}->{'Sims'}        = 1;
    } elsif ($onlyArg =~ /^err/) {
     $cfg->{'steps'}->{'ErrInj'}      = 1;
    } elsif ($onlyArg =~ /^rcsyn/) {
     $cfg->{'steps'}->{'Synth'}       = 1;
    } elsif ($onlyArg =~ /^dcsyn/) {
     $cfg->{'steps'}->{'dcSynth'}     = 1;
    } elsif ($onlyArg =~ /^rcgate/) {
     $cfg->{'steps'}->{'GSims'}       = 1;
    } elsif ($onlyArg =~ /^dcgate/) {
     $cfg->{'steps'}->{'DCGSims'}     = 1;
    } elsif ($onlyArg =~ /^rclec/) {
     $cfg->{'steps'}->{'RCLec'}       = 1;
    } elsif ($onlyArg =~ /^dclec/) {
     $cfg->{'steps'}->{'DCLec'}       = 1;
    } elsif ($onlyArg =~ /^for/) {
     $cfg->{'steps'}->{'Formality'}   = 1;
    } elsif ($onlyArg =~ /^lint/) {
     $cfg->{'steps'}->{'Lint'}        = 1;
    } elsif ($onlyArg =~ /^unr/) {
     $cfg->{'steps'}->{'Unroll'}      = 1;
    } elsif ($onlyArg =~ /^frun/) {
     $cfg->{'steps'}->{'CutFormal'}   = 1;
    } elsif ($onlyArg =~ /^fch/) {
     $cfg->{'steps'}->{'FCheck'}      = 1;
    } elsif ($onlyArg =~ /^pkg/) {
     $cfg->{'steps'}->{'Pkg'}         = 1;
    } elsif ($onlyArg =~ /^postvcs/) {
     $cfg->{'steps'}->{'PostVCSLint'} = 1;
    } elsif ($onlyArg =~ /^postdc/) {
     $cfg->{'steps'}->{'PostDCLint'}  = 1;
    } elsif ($onlyArg =~ /^postsim/) {
     $cfg->{'steps'}->{'PostSimChks'} = 1;
    } elsif ($onlyArg =~ /^postsyn/) {
     $cfg->{'steps'}->{'PostSynChks'} = 1;
    } else {
      LOGDIE("ValidateOptions: 'only' option \"$onlyArg\" not understood. Terminating...");
    }
  }
}

sub init {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  $self->getCfg();
}

sub run {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;


  my $opt  = $self->{'opt'};
  my $cfg  = $self->{'cfg'};

  $self->genCuts();
  $self->runSims();
  $self->runErrInj();
  $self->runSynth();
  $self->runDCSynth();
  $self->runGSims();
  $self->runDCGSims();
  $self->runRCLec();
  $self->runDCLec();
  $self->runFormality();
  $self->runVCSLint();
  $self->runDCLint();
  $self->cutFormal();
  $self->fChecker();
  $self->unrollCuts();
  $self->cutPackager();
  $self->postPkgSim();
  $self->postDCLint();
  $self->postVCSLint();
  $self->postPkgSyn();
  $self->updateBug();
  $self->dumpFailedCmds();
  $self->finish("Finished");
}

sub getAbsoluteBinPath {
  my $self = shift;
  my $path = shift;
  confess "Not enough arguments" if !defined $path;
  confess "Too many arguments" if defined shift;

  $path =~ s/\/$//;

  if ($path =~ /^\./) {
    my $cwd = realpath( getcwd() );
    $path = $cwd."/".$path;
  }

  LOGDIE ("Forge binary path $path is not accessible") if (!-e "$path/memogen/bin/memogen");

  return $path
}

sub getAbsoluteAsterPath {
  my $self = shift;
  my $path = shift;
  confess "Not enough arguments" if !defined $path;
  confess "Too many arguments" if defined shift;

  $path =~ s/\/$//;

  if ($path =~ /^\./) {
    my $cwd = realpath( getcwd() );
    $path = $cwd."/".$path;
  }

  LOGDIE ("Aster jar path $path is not accessible") if (!-e $path);

  return $path
}

sub parseFile {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  $cfg->{'json'} = readJson($opt->{'f'});
  
  if (exists $cfg->{'json'}->{'cmdLine'}) {
    $self->parseWebJSON();
  } elsif (exists $cfg->{'json'}->{'args'}) {
    $self->parseMemogenJSON();
  } else {
    $self->parseCmdFile();
  }
}

sub parseWebJSON {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  $cfg->{'json'} = readJson($opt->{'f'});

  if (!exists $cfg->{'json'}->{'vendor'} || !exists $cfg->{'json'}->{'tech'} ||
      !exists $cfg->{'json'}->{'groupName'} || !exists $cfg->{'json'}->{'packageName'} ||
      !exists $cfg->{'json'}->{'version'} || !exists $cfg->{'json'}->{'orders'} ||
      !exists $cfg->{'json'}->{'cmdLine'}) {
    LOGDIE "Malformed JSON. Can't find VT/groupName/packageName/version/orders/cmdLine information";
  }

  my $forgePath;
  if ($opt->{'binpath'} ne "") {
    $forgePath = $opt->{'binpath'};
  } else {
    $forgePath = $cfg->{'json'}->{'binaryPath'};
  }
  $cfg->{'binaryPath'} = $self->getAbsoluteBinPath($forgePath);

  if ($opt->{'pkgdir'} ne "") {
    $cfg->{'packageDir'} = $opt->{'pkgdir'};
  } else {
    LOGDIE "Package directory is not specified. Please specify package name with -pkgdir switch";
  }

  if ($opt->{'pkgname'} ne "") {
    $cfg->{'packageName'} = $opt->{'pkgname'};
  } elsif (exists $cfg->{'json'}->{'packageName'}) {
    $cfg->{'packageName'} = $cfg->{'json'}->{'packageName'};
  } else {
    LOGDIE "Package name is not specified. Please specify package name with -pkgname switch";
  }

  if ($opt->{'binpath'} ne "") {
    $cfg->{'binaryPath'} =~ /\/(\d+)\.(\d+)\.(\S+)/;
    $cfg->{'version'} = "$1.$2.$3";
  } else {
    $cfg->{'version'} = $cfg->{'json'}->{'version'};
  }
  $cfg->{'version'} =~ s/\./_/g;

  $cfg->{'orders'} = [];
  foreach my $cut (0..scalar (@{$cfg->{'json'}->{'orders'}}-1)) {
    $cfg->{'orders'}->[$cut]->{'cutName'} = $cfg->{'json'}->{'orders'}->[$cut]->{'cutName'};
    $cfg->{'orders'}->[$cut]->{'cutDir'}  = "";
  }

  if ($cfg->{'json'}->{'vendor'} eq "ibm") {
    if ($opt->{'ajp'} eq "") {
      LOGDIE ("For IBM, you need to specify aster jar path using -ajp switch. Please rerun with -ajp <path>.");
    } else {
      $cfg->{'ajp'} = $self->getAbsoluteAsterPath($opt->{'ajp'});
    }
  }

  $cfg->{'cmdLines'} = [];
  my $fullCmdLine = $cfg->{'binaryPath'}."/memogen/bin/memogen ";
  if ($cfg->{'json'}->{'vendor'} eq "ibm") {
    $fullCmdLine .= "-ajp $cfg->{'ajp'} ";
  }
  $fullCmdLine .= $cfg->{'json'}->{'cmdLine'}." -fdmem -fdout -bda -noob -rgr -fr";
  $fullCmdLine =~ s/ -nortl//;
  $fullCmdLine =~ s/ -nofile//;
  push @{$cfg->{'cmdLines'}}, $fullCmdLine;

  $cfg->{'vendor'}    = $cfg->{'json'}->{'vendor'};
  $cfg->{'tech'}      = $cfg->{'json'}->{'tech'};
  $cfg->{'groupName'} = $cfg->{'json'}->{'groupName'};

  $self->{'cfg'} = $cfg;
}

sub parseMemogenJSON {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  $cfg->{'json'} = readJson($opt->{'f'});

  if ($opt->{'binpath'} ne "") {
    $cfg->{'binaryPath'} = $opt->{'binpath'};
    $cfg->{'binaryPath'} = $self->getAbsoluteBinPath($opt->{'binpath'});
  } else {
    ERROR "*********************************************************************************************";
    ERROR "**JSON doesn't contain forge binary path. Specify it over commandline with -binpath option***";
    ERROR "*********************************************************************************************";
    LOGDIE"";
  }

  $cfg->{'vendor'}    = $self->getVendor($cfg->{'json'}->{'args'});
  $cfg->{'tech'}      = $self->getTech($cfg->{'json'}->{'args'});
  $cfg->{'groupName'} = $cfg->{'vendor'}."_".$cfg->{'tech'};

  if ($opt->{'pkgdir'} ne "") {
    $cfg->{'packageDir'} = $opt->{'pkgdir'};
  } else {
    LOGDIE "Package directory is not specified. Please specify package name with -pkgdir switch";
  }

  if ($opt->{'pkgname'} ne "") {
    $cfg->{'packageName'} = $opt->{'pkgname'};
  } else {
    LOGDIE "Package name is not specified. Please specify package name with -pkgname switch";
  }

  $cfg->{'binaryPath'} =~ /\/(\d+)\.(\d+)\.(\S+)/;
  $cfg->{'version'} = "$1.$2.$3";
  $cfg->{'version'} =~ s/\./_/g;

  my $cutName;
  my $csvFile;
  my $cutNames;

  my $cmdLineArgs = $cfg->{'json'}->{'args'};
  if ($cmdLineArgs =~ /\s+-cf\s+(.*?)-/) {
    $cmdLineArgs =~ s/\s+-cf\s+(.*?)-/ -cf "$1" -/;
  } elsif ( $cmdLineArgs =~ /\s+-cf\s+(.*?)$/) {
    $cmdLineArgs =~ s/\s+-cf\s+(.*?)$/ -cf "$1"/;
  }
  $cmdLineArgs =~ /\s+-name\s+(\S+)/;
  $cutName = $1;
  if ($cmdLineArgs =~ m/\s+-in\s+/) {
    $cmdLineArgs =~ /\s+-in\s+(\S+)/;
    $csvFile = $1;
    my $cwd = realpath( getcwd() );
    if ($csvFile !~ /^\//) {
      $csvFile = $cwd."/".$csvFile;
      $cmdLineArgs =~ s/\s+-in\s+(\S+)/ -in $csvFile/;
    }
    $cutNames = $self->getCSVCutNames($csvFile, $cutName);
  } else {
    $cutNames = $self->getCutNames($cutName, $cmdLineArgs);
  }

  if ($cfg->{'vendor'} eq "ibm") {
    if ($opt->{'ajp'} eq "") {
      LOGDIE ("For IBM, you need to specify aster jar path using -ajp switch. Please rerun with -ajp <path>.");
    } else {
      $cfg->{'ajp'} = $self->getAbsoluteAsterPath($opt->{'ajp'});
    }
  }

  $cfg->{'cmdLines'} = [];
  my $fullCmdLine = $cfg->{'binaryPath'}."/memogen/bin/memogen ";
  if ($cfg->{'vendor'} eq "ibm") {
    $fullCmdLine .= "-ajp $cfg->{'ajp'} ";
  }
  $fullCmdLine .= $cmdLineArgs;
  if ($fullCmdLine !~ /\s+-fdmem/) {
    $fullCmdLine .= " -fdmem ";
  }
  if ($fullCmdLine !~ /\s+-fdout/) {
    $fullCmdLine .= " -fdout ";
  }
  $fullCmdLine .= " -bda -noob -rgr -fr";
  $fullCmdLine =~ s/ -nortl//;
  $fullCmdLine =~ s/ -nofile//;
  push @{$cfg->{'cmdLines'}}, $fullCmdLine;

  $cfg->{'orders'} = [];
  my $words;
  my $bits;
  foreach my $cut (0..scalar(@$cutNames)-1) {
    $cfg->{'orders'}->[$cut]->{'cutName'} = $$cutNames[$cut];
    $cfg->{'orders'}->[$cut]->{'cutDir'} = "";
    if ($cmdLineArgs =~ m/\s+-dir\s+(\S+)/) {
      $cfg->{'orders'}->[$cut]->{'cutDir'} = $1;
    }
    if ($cmdLineArgs =~ m/\s+-w\s+(\w+)/) {
      $words = $1;
      if ($words =~ /\d+K/) {
        $words =~ s/(\d+)K/$1/;
        $words *= 1024;
      }elsif ($words =~ /(\d+)k/) {
        $words =~ s/(\d+)k/$1/;
        $words *= 1000;
      }
      $cfg->{'orders'}->[$cut]->{'words'} = $words;
    }
    if ($cmdLineArgs =~ m/\s+-b\s+(\w+)/) {
      $bits = $1;
      if ($bits =~ /\d+K/) {
        $bits =~ s/(\d+)K/$1/;
        $bits *= 1024;
      }elsif ($bits =~ /(\d+)k/) {
        $bits =~ s/(\d+)k/$1/;
        $bits *= 1000;
      }
      $cfg->{'orders'}->[$cut]->{'bits'} = $bits;
    }
  }
  $self->{'cfg'} = $cfg;
}

sub parseCmdFile {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  my $binPath;
  open my $in,  '<',  $opt->{'f'} or die "Can't read command file: $!";
  while(my $row = <$in> ) {
    next if ($row !~ /\w+/ || $row =~ /^\s*#/);
    $cfg->{'vendor'} = $self->getVendor($row);
    $cfg->{'tech'}   = $self->getTech($row);
    $row =~ /^\s*(\S+)\/memogen\/bin/;
    $binPath = $1;
    last;
  }
  close $in;
  if ($opt->{'binpath'} ne "") {
      $binPath = $opt->{'binpath'};
  }

  $cfg->{'groupName'} = $cfg->{'vendor'}."_".$cfg->{'tech'};
  $cfg->{'binaryPath'} = $self->getAbsoluteBinPath($binPath);
  $cfg->{'binaryPath'} =~ /\/(\d+)\.(\d+)\.(\S+)/;
  $cfg->{'version'} = "$1.$2.$3";
  $cfg->{'version'} =~ s/\./_/g;

  if ($opt->{'pkgdir'} ne "") {
    $cfg->{'packageDir'} = $opt->{'pkgdir'};
  } else {
    LOGDIE "Package directory is not specified. Please specify package name with -pkgdir switch";
  }

  if ($opt->{'pkgname'} ne "") {
    $cfg->{'packageName'} = $opt->{'pkgname'};
  } else {
    LOGDIE "Package name is not specified. Please specify package name with -pkgname switch";
  }

  my $cutName;
  my $csvFile;
  my $cutNames;
  $cfg->{'cmdLines'} = [];
  $cfg->{'orders'} = [];
  my $cutNum = 0;

  open $in,  '<',  $opt->{'f'} or die "Can't read command file: $!";
  while (my $cmdLineArgs = <$in>) {
    next if ($cmdLineArgs !~ /\w+/ || $cmdLineArgs =~ /^\s*#/);
    my $forgePath = $cfg->{'binaryPath'};
    my $memogenPath = $forgePath."/memogen/bin";
    $cmdLineArgs =~ s/^\s*(\S+)\/memogen\/bin/$memogenPath/;
    $cmdLineArgs =~ /\s+-name\s+(\S+)/;
    $cutName = $1;
    if ($cmdLineArgs =~ m/\s+-in\s+/) {
      $cmdLineArgs =~ /\s+-in\s+(\S+)/;
      $csvFile = $1;
      my $cwd = realpath( getcwd() );
      if ($csvFile !~ /^\//) {
        $csvFile = $cwd."/".$csvFile;
        $cmdLineArgs =~ s/\s+-in\s+(\S+)/ -in $csvFile/;
      }
      $cutNames = $self->getCSVCutNames($csvFile, $cutName);
    } else {
      $cutNames = $self->getCutNames($cutName, $cmdLineArgs);
    }

    chomp ($cmdLineArgs);
    if ($cmdLineArgs !~ /\s+-bda/) {
      $cmdLineArgs .= " -bda";
    }
    if ($cmdLineArgs !~ /\s+-noob/) {
      $cmdLineArgs .= " -noob";
    }
    if ($cmdLineArgs !~ /\s+-rgr/) {
      $cmdLineArgs .= " -rgr";
    }
    if ($cmdLineArgs !~ /\s+-fr/) {
      $cmdLineArgs .= " -fr";
    }
    if ($cmdLineArgs !~ /\s+-fdmem/) {
      $cmdLineArgs .= " -fdmem";
    }
    if ($cmdLineArgs !~ /\s+-fdout/) {
      $cmdLineArgs .= " -fdout";
    }
    $cmdLineArgs =~ s/ -nortl//;
    $cmdLineArgs =~ s/ -nofile//;
    $cmdLineArgs =~ s/ -nofile//;
    push @{$cfg->{'cmdLines'}}, $cmdLineArgs;
   
    my $words;
    my $bits;
    foreach my $cut (0..scalar(@$cutNames)-1) {
      $cfg->{'orders'}->[$cutNum]->{'cutName'} = $$cutNames[$cut];
      $cfg->{'orders'}->[$cutNum]->{'cutDir'} = "";
      if ($cmdLineArgs =~ m/\s+-dir\s+(\S+)/) {
        $cfg->{'orders'}->[$cutNum]->{'cutDir'} = $1;
      }
      if ($cmdLineArgs =~ m/\s+-w\s+(\w+)/) {
        $words = $1;
        if ($words =~ /\d+K/) {
          $words =~ s/(\d+)K/$1/;
          $words *= 1024;
        }elsif ($words =~ /(\d+)k/) {
          $words =~ s/(\d+)k/$1/;
          $words *= 1000;
        }
        $cfg->{'orders'}->[$cutNum]->{'words'} = $words;
      }
      if ($cmdLineArgs =~ m/\s+-b\s+(\w+)/) {
        $bits = $1;
        if ($bits =~ /\d+K/) {
          $bits =~ s/(\d+)K/$1/;
          $bits *= 1024;
        }elsif ($bits =~ /(\d+)k/) {
          $bits =~ s/(\d+)k/$1/;
          $bits *= 1000;
        }
        $cfg->{'orders'}->[$cutNum]->{'bits'} = $bits;
      }
    }
    $cutNum++;
  }
  $self->{'cfg'} = $cfg;
}

sub getCfg {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  $self->parseFile();
  
  my $uid    = $ENV{'USER'};

  $cfg->{'mail'} = $uid;
  $cfg->{'user'} = $uid;
  $cfg->{'sim_opt'} = ['ncv', 'vcs', 'vsim'];

  my $forgePath = $cfg->{'binaryPath'};
  my $memogenPath = $forgePath."/memogen";
  my $buildVersion = $cfg->{'version'};

  my $memogenRTLPath = $memogenPath."/src/rtl/common/rtl";
  my $encVerFile    = "$memogenRTLPath/memoir_design_library_${buildVersion}_ncv.v";
  if (-e $encVerFile) {
    INFO ("Unencrypted IP is not found at $memogenPath/src/rtl directory.");
    INFO ("Please do the following:");
    INFO ("    1. cd $memogenPath/src");
    INFO ("    2. mv rtl rtl_enc");
    INFO ("    3. ln -s ../../verilogparser/ip rtl");
    LOGDIE ("Rerun cut package script.");
  }
  
  my $parserPath = $forgePath."/verilogparser";
  my $designLibrary = $parserPath."/ip_obfuscated/memoir_design_library_${buildVersion}.v";

  my $parserBinPath = $parserPath."/bin";

  $cfg->{'designLibrary'} = $designLibrary;
  $cfg->{'parserBinPath'} = $parserBinPath;
  $cfg->{'ipDir'} = "$cfg->{'binaryPath'}/memogen/src/rtl";
  $self->getSpecialTestDrivers();

  {                             # fix up mail ids
    my $mstr = "";
    my @mids = split(/[,|;]/, $cfg->{'mail'});
    for (my $i = 0; $i <= $#mids; $i++) {
      $mids[$i] =~ s/\@.*//;
      $mstr .= "," . $mids[$i] . "\@cisco.com";
    }
    $mstr =~ s/^,//;
    $cfg->{'mail'} = $mstr;
  }

  $self->{'cfg'} = $cfg;
}

sub getCSVCutNames {
  my $self    = shift;
  my $csvFile = shift;
  my $cutName = shift;

  confess "Not enough arguments" if !defined $cutName;
  confess "Too many arguments" if defined shift;

  my $opt  = $self->{'opt'};
  my $cfg  = $self->{'cfg'};

  INFO "Input JSON reads $csvFile file as input";
  my $csv = Text::CSV_XS->new ();
  open my $FILE, "<", $csvFile or die "$csvFile: $!";
  my @fields;
  my $index = 0;
  my $nrPos = -1;
  my $cidPos = -1;
  my $cutNameArray = [];
  my $cutCnt = 0;
  while (my $row = $csv->getline ($FILE)) {
    $fields[$index] = $row;
    if ($index == 0) {
      my @header = @$row;
      foreach my $nr (0..scalar(@header)-1) {
        if ($header[$nr] eq "nr") {
          $nrPos = $nr;
        }
      }
      foreach my $cid (0..scalar(@header)-1) {
        if ($header[$cid] eq "cid") {
          $cidPos = $cid;
        }
      }
    } else {
      foreach my $field (@$row) {
        if ($field eq "") {
          LOGDIE "Incorrect CSV format. Empty fields detected in csv file.";
        }
      }

      my $cutIndex;
      if ($cidPos > -1) {
        $cutIndex = $$row[$cidPos];
      } else {
        $cutIndex = "C$index";
      }

      if ($nrPos > -1) {
        foreach my $cut (0..$$row[$nrPos]-1) {
          if ($$row[$nrPos] == 1) {
            push (@$cutNameArray, "${cutName}_${cutIndex}");
          } else {
            push (@$cutNameArray, "${cutName}_${cutIndex}_${cut}");
          }
          $cutCnt++;
        }
      } else {
        push (@$cutNameArray, "${cutName}_${cutIndex}");
        $cutCnt++;
      }
    }
    $index++;
  }

  return $cutNameArray;
}

sub getCutNames {
  my $self    = shift;
  my $cutName = shift;
  my $cmdLineArgs = shift;

  confess "Not enough arguments" if !defined $cutName;
  confess "Too many arguments" if defined shift;

  my $opt  = $self->{'opt'};
  my $cfg  = $self->{'cfg'};

  my $nr = 1;
  if ( $cmdLineArgs =~ /-nr\s+(\d+)\s+/) {
    $nr = $1;
  }
  my $cutNameArray = [];
  foreach my $index (0..$nr-1) {
    if ($nr == 1) {
      push (@$cutNameArray, "${cutName}");
    } else {
      push (@$cutNameArray, "${cutName}_${index}");
    }
  }
  return $cutNameArray;
}

sub getVendor {
  my $self = shift;
  my $cmdLineArgs = shift;

  confess "Not enough arguments" if !defined $cmdLineArgs;
  confess "Too many arguments" if defined shift;

  my $vendor = "";
  if ( $cmdLineArgs =~ /-v\s+(\w+)\s+/) {
    $vendor = $1;
  } else {
    LOGDIE ("getVendor: Couldn't get -v information.");
  }

  return $vendor;
}

sub getTech {
  my $self = shift;
  my $cmdLineArgs = shift;

  confess "Not enough arguments" if !defined $cmdLineArgs;
  confess "Too many arguments" if defined shift;

  my $tech = "";
  if ( $cmdLineArgs =~ /-t\s+(\w+)\s+/) {
    $tech = $1;
  } else {
    LOGDIE ("getTech: Couldn't get -t information.");
  }

  return $tech;
}

sub sendmail {
  my $self = shift;
  my $dpl = shift;

  confess "Not enough arguments" if !defined $dpl;
  confess "Too many arguments" if defined shift;

  my $opt  = $self->{'opt'};
  my $cfg  = $self->{'cfg'};

  if ( $cfg->{'mail'} !~ /^\s*$/ ) {
    ALWAYS "mailing results";

    my $msg = Mail::Send->new();
    $msg->to( $cfg->{'mail'} );

    my $ver = $cfg->{'version'};
    my $str = sprintf("[forge] new toolset available - $ver");

    $msg->subject($str);

    my $fh = $msg->open('sendmail');

    $str = "forged :\n" . join( "\n", @{$dpl} );
    print $fh "$str\n";

    $fh->close() or LOGDIE "SendMail: couldn't send email: $!\n";
  }
}


sub print {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  print $self->to_string(), "\n";
}

sub getCutInfo {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  return $self->{'cfg'}->{'orders'};
}

sub getOrderPath {
  my $self = shift;
  my $order = shift;
  confess "Not enough arguments" if !defined $order;
  confess "Too many arguments" if defined shift;

  my $cfg = $self->{'cfg'};

  my $packageDir = $cfg->{'packageDir'};
  my $projDir = $cfg->{'groupName'};
  my $packageName  = $cfg->{'packageName'};
  my $cutDir  = $cfg->{'orders'}->[$order]->{'cutDir'};

  if ($cutDir ne "") {
    return "${packageDir}/${projDir}/${packageName}/cuts/$cutDir";
  } else {
    return "${packageDir}/${projDir}/${packageName}/cuts";
  }
}

sub getCutName {
  my $self  = shift;
  my $cuts  = shift;
  my $order = shift;
  confess "Not enough arguments" if !defined $order;
  confess "Too many arguments" if defined shift;

  return $$cuts[$order]->{'cutName'};
}

sub getCutWords {
  my $self  = shift;
  my $cuts  = shift;
  my $order = shift;
  confess "Not enough arguments" if !defined $order;
  confess "Too many arguments" if defined shift;

  my $cfg = $self->{'cfg'};

  return $cfg->{'orders'}->[$order]->{'words'};
}

sub getCutBits {
  my $self  = shift;
  my $cuts  = shift;
  my $order = shift;
  confess "Not enough arguments" if !defined $order;
  confess "Too many arguments" if defined shift;

  my $cfg = $self->{'cfg'};

  return $cfg->{'orders'}->[$order]->{'bits'};
}

sub checkLogFile {
  my $self    = shift;
  my $logFile = shift;
  my $string  = shift;
  confess "Not enough arguments" if !defined $string;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  my $pass;

  open(FILE,$logFile) or die "Couldn't open $logFile";
  if (grep{/$string/} <FILE>){
    $pass = TRUE;
  }else{
    $pass = FALSE;
  }
  close FILE;
  return $pass;
}

sub genCuts {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  my $packageDir = $cfg->{'packageDir'};
  my $projDir = $cfg->{'groupName'};
  my $packageName  = $cfg->{'packageName'};

  if ($cfg->{'steps'}->{'CutGen'} == 0) {
    INFO (">>Skipping cut generation since -skip/-only option was specified<<");
    return 0;
  } else {
    INFO ("Generating cuts...:");
  }

  my $fullCutDir  = "$packageDir/$projDir/$packageName/cuts";
  my $dirFound = 0;
  foreach my $cut (0..scalar @{$cfg->{'orders'}}-1) {
    my $cutDir = $fullCutDir;
    if (${$cfg->{'orders'}}[$cut]->{'cutDir'} ne "") {
      $cutDir .= "/${$cfg->{'orders'}}[$cut]->{'cutDir'}";
    }
    if (-d $cutDir) {
      $dirFound = 1;
      ERROR ("genCuts: Cut directory $cutDir exists. Please remove/rename and rerun cutpkg.");
    }
  }

  LOGDIE "" if $dirFound == 1;
  
  if ( !-d $packageDir) {
    vmkpath( $packageDir, $opt->{'just-print'} );
  }

  vchdir($packageDir, $opt->{'just-print'});
  
  if ( !-d $projDir) {
    vmkpath( $projDir, $opt->{'just-print'} );
  }
  vchdir($projDir, $opt->{'just-print'});

  if ( !-d $packageName) {
    vmkpath( $packageName, $opt->{'just-print'} );
  }
  vchdir($packageName, $opt->{'just-print'});

  if ( !-d "cuts") {
    vmkpath( "cuts", $opt->{'just-print'} );
  }
  vchdir("cuts", $opt->{'just-print'});

  $ENV{MEMOGEN_UNENCRYPTED_MODE} = 1;

  foreach my $index (0..scalar @{$cfg->{'cmdLines'}}-1) {
    my $orderPath = $self->getOrderPath($index);
    my $cmd = ${$cfg->{'cmdLines'}}[$index]." \| tee cut${index}.log";
    my $rs = vsystem($cmd, $self->{'opt'}->{'just-print'});
    if ($rs != TRUE) {
      $TEST->ok(0, "Cut generation failed");
      LOGDIE("GenCuts: command \"$cmd\" failed");
    }
  }
}

sub runCmd {
  my $self = shift;
  my $cmd = shift;
  my $logFile = shift;
  my $passString = shift;
  my $runDir = shift;
  my $message = shift;

  confess "Not enough arguments" if !defined $message;
  confess "Too many arguments" if defined shift;

  my $opt = $self->{'opt'};
  my $cfg = $self->{'cfg'};

  vrm($logFile,$opt->{'just-print'});

  INFO ("* $cmd");
  system($cmd);

  my $pass = $self->checkLogFile($logFile, $passString);
  if ($pass eq FALSE) {
    $ecnt++;
    push (@$err_log, "$message: In $runDir, $cmd run failed. Please rerun manually to find out the nature of the failure.");
    return 1;
  }
  return 0;
}

sub runSims {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;


  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  if ($cfg->{'steps'}->{'Sims'} == 0) {
    INFO (">>Skipping dynamic simulations since -skip/-only option was specified>>");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("********************Running simulations********************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();

  my $cmd;
  my $pass;
  my $script;
  my $simECnt = 0;

  my $numOrders = scalar @$cuts - 1;
  foreach my $order (0..$numOrders) {
    foreach my $sim (@sims) {
      my $orderPath = $self->getOrderPath($order);
      my $cutName = $self->getCutName($cuts,$order);
      my $cutDir = $orderPath."/run_sample/testbench/".$cutName;
      if (!-d $cutDir) {
        ERROR ("        Directory $cutDir is not found.");
        ERROR ("        This may be due to cut name generated");
        ERROR ("        by memogen not matching the cut name");
        ERROR ("        supplied by <cut>.json");
        LOGDIE ("        Please fix the problem and rerun.");
      }
      my $runDir = $orderPath."/run_sample/testbench/".$cutName."/$sim";
      vchdir($runDir, $opt->{'just-print'});

      my $result_logs = "result_logs";
      if (!-d $result_logs) {
        vmkpath($result_logs, $opt->{'just-print'});
      }

      foreach my $tool (@tools) {
        if ($sim ne "real_mem") {
          $script = "./sim.$tool.sh 2>&1 > /dev/null";
        } else {
          $script = "./sim.$tool.sh +define+MEMOIR_DBG_TEST 2>&1 > /dev/null";
        }
        $simECnt += $self->runCmd($script,$simLogFile,$simPassString, $runDir, "runSims");
        $cmd = "\\cp $simLogFile $result_logs/${tool}_$simLogFile";
        vsystem($cmd, $opt->{'just-print'});
      }
    }
  }
  ERROR "Some simulation runs failed ($simECnt)" if ($simECnt > 0);
}

sub runSynth {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  my $pass;
  my $rcSynECnt = 0;

  if ($cfg->{'steps'}->{'Synth'} == 0) {
    INFO (">>Skipping synthesis since -skip/-only option was specified<<");
    return 0;
  } elsif ($opt->{'dc'}) {
    INFO (">>Skipping rc synthesis since -dc was specified.");
    return 0;
  } elsif ($opt->{'func'} || $opt->{'beh'}) {
    INFO (">>Skipping synthesis since -func/beh option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("*********************Running synthesis*********************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();

  my $cmd;
  my $numOrders = scalar @$cuts - 1;
  foreach my $order (0..$numOrders) {
    my $orderPath = $self->getOrderPath($order);
    my $cutName = $self->getCutName($cuts,$order);
    my $runDir = $orderPath."/run_sample/testbench/".$cutName."/real_mem";
    vchdir($runDir, $opt->{'just-print'});

    my $result_logs = "result_logs";
    if (!-d $result_logs) {
      vmkpath($result_logs, $opt->{'just-print'});
    }

    my $script = "./syn.sh";
    vsystem("\\rm -rf $rcSynLogFile*",$opt->{'just-print'});
    vsystem("\\rm -rf $rcSynCmdFile*",$opt->{'just-print'});
    vsystem("\\rm -rf logs/rc.log*",$opt->{'just-print'});
    $cmd = "$script 2>&1 > /dev/null";
    $rcSynECnt += $self->runCmd($cmd, $rcSynLogFile, $rcSynPassString, $runDir, "Synthesis" );
    $cmd = "\\cp $rcSynLogFile $result_logs/$rcSynLogFile";
    vsystem($cmd, $opt->{'just-print'});
  }
  ERROR "Some RC gate simulation runs failed ($rcSynECnt)" if ($rcSynECnt > 0);
}

sub runDCSynth {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  my $pass;
  my $dcSynECnt = 0;

  if ($cfg->{'steps'}->{'dcSynth'} == 0) {
    INFO (">>Skipping synthesis since -skip/-only option was specified<<");
    return 0;
  } elsif ($opt->{'rc'}) {
    INFO (">>Skipping dc synthesis since -dc was specified.");
    return 0;
  } elsif ($opt->{'func'} || $opt->{'beh'}) {
    INFO (">>Skipping synthesis since -func/beh option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("*******************Running DC synthesis********************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();

  my $cmd;
  my $numOrders = scalar @$cuts - 1;
  foreach my $order (0..$numOrders) {
    my $orderPath = $self->getOrderPath($order);
    my $cutName = $self->getCutName($cuts,$order);
    my $runDir = $orderPath."/run_sample/testbench/".$cutName."/real_mem";
    vchdir($runDir, $opt->{'just-print'});

    my $result_logs = "result_logs";
    if (!-d $result_logs) {
      vmkpath($result_logs, $opt->{'just-print'});
    }

    my $script = "./syn_dc.sh";
    vsystem("\\rm -rf $dcSynLogFile*",$opt->{'just-print'});
    vsystem("\\rm -rf $result_logs/$dcSynLogFile*",$opt->{'just-print'});
    vsystem("\\rm -rf logs/dc.log*",$opt->{'just-print'});
    $cmd = "$script 2>&1 > /dev/null";
    $dcSynECnt += $self->runCmd($cmd, $dcSynLogFile, $dcSynPassString, $runDir, "Synthesis" );
    $cmd = "\\cp $dcSynLogFile $result_logs/$dcSynLogFile";
    vsystem($cmd, $opt->{'just-print'});

    my $str = "^Warning:";
    my $dcWarnF = "result_logs/dc.wrn";
    $pass = $self->parseLogs($str,$dcSynLogFile, $dcWarnF, \@dcWaiverList);
    if (!$pass) {
      $ecnt++;
      push (@$err_log, "Error: In $runDir, DC synthesis checks failed. Please Review $runDir/$dcWarnF") if $pass == 0;
    }
  }
  ERROR "Some DC gate simulation runs failed ($dcSynECnt)" if ($dcSynECnt > 0);
}

sub runGSims {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  if ($cfg->{'steps'}->{'GSims'} == 0) {
    INFO (">>Skipping RC gate simulations since -skip/-only option was specified<<");
    return 0;
  } elsif ($opt->{'dc'}) {
    INFO (">>Skipping RC synthesis since -dc was specified.");
    return 0;
  } elsif ($opt->{'func'}) {
    INFO (">>Skipping gate simulations since -func option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("*****************Running gate simulations******************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();

  my $cmd;
  my $pass;
  my $gsimECnt = 0;
  my $numOrders  = scalar @$cuts - 1;
  my $script     = "./gsim.sh";

  foreach my $order (0..$numOrders) {
    my $orderPath = $self->getOrderPath($order);
    my $sim = "real_mem";
    my $cutName = $self->getCutName($cuts,$order);
    my $runDir = $orderPath."/run_sample/testbench/".$cutName."/$sim";
    vchdir($runDir, $opt->{'just-print'});

    my $RCSynGates = "outputs/${cutName}.v";

    if (!-e $RCSynGates) {
      ERROR ("RC Gatesims: $RCSynGates doesn't exist. You need to run RC synthesis first.");
    } else {
      my $result_logs = "result_logs";
      if (!-d $result_logs) {
        vmkpath($result_logs, $opt->{'just-print'});
      }

      my $cmd = "$script 2>&1 > /dev/null";
      $gsimECnt += $self->runCmd($cmd,$simLogFile,$simPassString,$runDir, "RCGateSims");
      $cmd = "\\cp $simLogFile $result_logs/gatesim_ncv_$simLogFile";
      vsystem($cmd, $opt->{'just-print'});
    }
  }
  ERROR "Some RC gate simulation runs failed ($gsimECnt)" if ($gsimECnt > 0);
}

sub runDCGSims {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  if ($cfg->{'steps'}->{'DCGSims'} == 0) {
    INFO (">>Skipping DC gate simulations since -skip/-only option was specified<<");
    return 0;
  } elsif ($opt->{'rc'}) {
    INFO (">>Skipping DC synthesis since -dc was specified.");
    return 0;
  } elsif ($opt->{'func'}) {
    INFO (">>Skipping gate simulations since -func option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("*****************Running gate simulations******************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();

  my $cmd;
  my $pass;
  my $DCGsimECnt = 0;
  my $numOrders  = scalar @$cuts - 1;
  my $script     = "./gsim_dc.sh";

  foreach my $order (0..$numOrders) {
    my $orderPath = $self->getOrderPath($order);
    my $sim = "real_mem";
    my $cutName = $self->getCutName($cuts,$order);
    my $runDir = $orderPath."/run_sample/testbench/".$cutName."/$sim";
    vchdir($runDir, $opt->{'just-print'});

    my $DCSynGates = "outputs/${cutName}.flat.vg";

    if (!-e $DCSynGates) {
      ERROR ("RC Gatesims: $DCSynGates doesn't exist. You need to run RC synthesis first.");
    } else {
      my $result_logs = "result_logs";
      if (!-d $result_logs) {
        vmkpath($result_logs, $opt->{'just-print'});
      }

      my $cmd = "$script 2>&1 > /dev/null";
      $DCGsimECnt += $self->runCmd($cmd,$simLogFile,$simPassString,$runDir, "DCGateSims");
      $cmd = "\\cp $simLogFile $result_logs/gatesim_ncv_$simLogFile";
      vsystem($cmd, $opt->{'just-print'});
    }
  }
  ERROR "Some DC gate simulation runs failed ($DCGsimECnt)" if ($DCGsimECnt > 0);
}

sub runRCLec {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  my $pass;

  if ($cfg->{'steps'}->{'RCLec'} == 0) {
    INFO (">>Skipping RC LEC since -skip/-only option was specified<<");
    return 0;
  } elsif ($opt->{'dc'}) {
    INFO (">>Skipping rc LEC since -dc was specified.");
    return 0;
  } elsif ($opt->{'func'} || $opt->{'beh'}) {
    INFO (">>Skipping RC LEC since -func/beh option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("***********************Running RC LEC**********************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();

  my $cmd;
  my $rcLecECnt = 0;
  my $numOrders = scalar @$cuts - 1;
  foreach my $order (0..$numOrders) {
    my $orderPath = $self->getOrderPath($order);
    my $cutName = $self->getCutName($cuts,$order);
    my $runDir = $orderPath."/run_sample/testbench/".$cutName."/real_mem";
    vchdir($runDir, $opt->{'just-print'});

    my $RCSynGates = "outputs/${cutName}.v";

    if (!-e $RCSynGates) {
      ERROR ("RC LEC: $RCSynGates doesn't exist. You need to run RC synthesis first.");
    } else {
      my $result_logs = "result_logs";
      if (!-d $result_logs) {
        vmkpath($result_logs, $opt->{'just-print'});
      }

      my $script = "./lec.sh";
      $cmd = "$script 2>&1 > /dev/null";
      $rcLecECnt += $self->runCmd($cmd, $lecLogFile, $lecPassString, $runDir, "LEC" );
      $cmd = "\\cp $lecLogFile $result_logs/$lecLogFile";
      vsystem($cmd, $opt->{'just-print'});
    }
  }
  ERROR "Some RC LEC runs failed ($rcLecECnt)" if ($rcLecECnt > 0);
}

sub runDCLec {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  my $pass;
  my $dcLecECnt = 0;

  if ($cfg->{'steps'}->{'DCLec'} == 0) {
    INFO (">>Skipping DC LEC since -skip/-only option was specified<<");
    return 0;
  } elsif ($opt->{'rc'}) {
    INFO (">>Skipping dc LEC since -dc was specified.");
    return 0;
  } elsif ($opt->{'func'} || $opt->{'beh'}) {
    INFO (">>Skipping LEC since -func/beh option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("***********************Running DC LEC**********************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();

  my $cmd;
  my $numOrders = scalar @$cuts - 1;
  foreach my $order (0..$numOrders) {
    my $orderPath = $self->getOrderPath($order);
    my $cutName = $self->getCutName($cuts,$order);
    my $runDir = $orderPath."/run_sample/testbench/".$cutName."/real_mem";
    vchdir($runDir, $opt->{'just-print'});

    my $DCSynGates = "outputs/${cutName}.flat.vg";

    if (!-e $DCSynGates) {
      ERROR ("DC LEC: $DCSynGates doesn't exist. You need to run DC synthesis first.");
    } else {
      my $result_logs = "result_logs";
      if (!-d $result_logs) {
        vmkpath($result_logs, $opt->{'just-print'});
      }

      my $script = "./lec_dc.sh";
      $cmd = "$script 2>&1 > /dev/null";
      $dcLecECnt += $self->runCmd($cmd, $lecDCLogFile, $lecPassString, $runDir, "LEC" );
      $cmd = "\\cp $lecDCLogFile $result_logs/$lecDCLogFile";
      vsystem($cmd, $opt->{'just-print'});
    }
  }
  ERROR "Some RC LEC runs failed ($dcLecECnt)" if ($dcLecECnt > 0);
}

sub runFormality {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  my $pass;

  if ($cfg->{'steps'}->{'Formality'} == 0) {
    INFO (">>Skipping Formality since -skip/-only option was specified<<");
    return 0;
  } elsif ($opt->{'rc'}) {
    INFO (">>Skipping Formality since -rc was specified.");
    return 0;
  } elsif ($opt->{'func'} || $opt->{'beh'}) {
    INFO (">>Skipping Formality since -func/beh option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("*********************Running Formality ********************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();

  my $cmd;
  my $formalityECnt = 0;
  my $numOrders = scalar @$cuts - 1;
  foreach my $order (0..$numOrders) {
    my $orderPath = $self->getOrderPath($order);
    my $cutName = $self->getCutName($cuts,$order);
    my $runDir = $orderPath."/run_sample/testbench/".$cutName."/real_mem";
    my $DCSynGates = "outputs/${cutName}.flat.vg";
    vchdir($runDir,$opt->{'just-print'});
    if (!-e $DCSynGates) {
      ERROR ("runFormality: $DCSynGates doesn't exist. You need to run DC synthesis first.");
    } else {

      my $result_logs = "result_logs";
      if (!-d $result_logs) {
        vmkpath($result_logs, $opt->{'just-print'});
      }

      my $script = "./formality.sh";
      $cmd = "$script 2>&1 > /dev/null";
      $formalityECnt += $self->runCmd($cmd, $formalityLogFile, $formalityPassString, $runDir, "Formality" );
      $cmd = "\\cp $formalityLogFile $result_logs/$formalityLogFile";
      vsystem($cmd, $opt->{'just-print'});
    }
  }
  ERROR "Some Formality runs failed ($formalityECnt)" if ($formalityECnt > 0);
}

sub runVCSLint {
  my $self  = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};
  
  if ($cfg->{'steps'}->{'Lint'} == 0) {
    INFO (">>Skipping Lint since -skip/-only option was specified<<");
    return 0;
  } elsif ($opt->{'func'} || $opt->{'beh'}) {
    INFO (">>Skipping Lint since -func/beh option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("********************Running Lint checks********************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();

  my $numOrders = scalar @$cuts - 1;
  my ($sim, $script, $cutName, $runDir, $cutDir, $pass);

  my $line;
  my $sim_f = "vcs_lint.f";
  foreach my $order (0..$numOrders) {
    my $cutName = $self->getCutName($cuts,$order);
    my $lintLogF = "result_logs/lint.log";
    my $lintCmd = "vcs -sverilog -F $sim_f +lint=all > result_logs/lint.log";

    my $orderPath = $self->getOrderPath($order);
    my $cutDir = $orderPath."/run_sample/testbench/".$cutName;
    my $runDir = "$cutDir/real_mem";

    vchdir($runDir, $opt->{'just-print'});

    my $vcsExe = "simv";
    if (-e $vcsExe) {
      vrm($vcsExe, $opt->{'just-print'});
    }

    my $vcsDir1 = "simv.daidir";
    if (-d $vcsDir1) {
      vrm($vcsDir1, $opt->{'just-print'});
    }

    my $vcsDir2 = "csrc";
    if (-d $vcsDir2) {
      vrm($vcsDir2, $opt->{'just-print'});
    }

    my $old_sim_f = "sim.vcs.f";
    open my $old , '<', $old_sim_f or die "Can't read file: $!";

    my $rtl_f;

    while( <$old> ) {
      if ($_ =~ /rtl\.f/) {
        $rtl_f = $_;
      }
    }

    open my $new, '>', $sim_f or die "Can't write new file: $!";
    $line = "../../../../rtl/${cutName}.v\n";
    print $new $line;
    $line = "-v ../../../../rtl/${cutName}_core_$cfg->{'version'}.v\n";
    print $new $line;
    $line = "-v ../../../../rtl/${cutName}_core_donut_$cfg->{'version'}.v\n";
    print $new $line;
    print $new $rtl_f;
    $line = "+define+SIM_TOP=$cutName\n";
    print $new $line;
    $line = "-F ../../../common.vcs.f\n";
    print $new $line;
    my $tech_f = uc($cfg->{'tech'})."_LIBS.f";
    $line = "-f $tech_f\n";
    $line = "-y ../../../simlibs\n";
    print $new $line;
    close $new;
    vchmod (0755, $sim_f, $opt->{'just-print'});


    my $result_logs = "result_logs";
    if (!-d $result_logs) {
      vmkpath($result_logs, $opt->{'just-print'});
    }

    my $passString = "^\\.\\./simv up to date";
    $self->runCmd($lintCmd, $lintLogF, $passString, $runDir, "Post package lint: ");
    my $str = "Lint";
    my $lintWarnF = "result_logs/lint.wrn";
    $pass = $self->parseLogs($str,$lintLogF, $lintWarnF, \@vcsLintWaiverList);
    push (@$err_log, "Error: In $runDir, VCS lint checks failed. Please Review $runDir/result_logs/$lintWarnF") if $pass == 0;
  }
}

sub runDCLint {
  my $self  = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};
  
  if ($cfg->{'steps'}->{'Lint'} == 0) {
    INFO (">>Skipping Lint since -skip/-only option was specified<<");
    return 0;
  } elsif ($opt->{'func'} || $opt->{'beh'}) {
    INFO (">>Skipping Lint since -func/beh option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("********************Running Lint checks********************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();
  my $pass;

  my $numOrders = scalar @$cuts - 1;
  foreach my $order (0..$numOrders) {
    my $cutName = $self->getCutName($cuts,$order);
    my $dcLogF = "dc.log";
    my $lintLogF = "reports/${cutName}\.check_design\.rpt";
    my $lintCmd = "./syn_dc_lint.sh 2>&1 > /dev/null";

    my $orderPath = $self->getOrderPath($order);
    my $cutDir = $orderPath."/run_sample/testbench/".$cutName;
    if (!-d $cutDir) {
      ERROR ("        Directory $cutDir is not found.");
      ERROR ("        This may be due to cut name generated");
      ERROR ("        by memogen not matching the cut name");
      ERROR ("        supplied by <cut>.json");
      LOGDIE ("        Please fix the problem and rerun.");
    }
    my $runDir = $cutDir."/real_mem";
    vchdir($runDir, $opt->{'just-print'});

    my $old = "syn_dc.sh";
    my $new = "syn_dc_lint.sh";
    open my $in,  '<',  $old or die "Can't read old file: $!";
    open my $out, '>', $new or die "Can't write new file: $!";
    while( <$in> ) {
      $_ =~ s/rgr_dc_syn_script/rgr_dc_lint_script/;
      print $out $_;
    }
    close $out;
    vchmod (0755, $new, $opt->{'just-print'});

    $old = "../../../rgr_dc_syn_script.tcl";
    $new = "../../../rgr_dc_lint_script.tcl";

    open $in,  '<',  $old or die "Can't read old file: $!";
    open $out, '>', $new or die "Can't write new file: $!";
    while( <$in> ) {
      if ($_ =~ /End of check_design/) {
        print $out $_;
        print $out "quit";
        last;
      }
      print $out $_;
    }
    close $out;

    my $result_logs = "result_logs";
    if (!-d $result_logs) {
      vmkpath($result_logs, $opt->{'just-print'});
    }
    
    my $passString = "End of check_design";
    $self->runCmd($lintCmd, $lintLogF, $passString, $runDir, "Post package lint: ");
    my $str = "LINT";
    my $lintWarnF = "result_logs/checkdesign.log";
    $pass = $self->parseLogs($str,$lintLogF, $lintWarnF, \@dcLintWaiverList);
    if (!$pass) {
      $ecnt++;
      push (@$err_log, "Error: In $runDir, DC lint checks failed. Please Review $runDir/$lintWarnF") if $pass == 0;
    }
  }
}

sub unrollCuts {
  my $self  = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  if ($cfg->{'steps'}->{'Unroll'} == 0) {
    INFO (">>Skipping cutFormal run since -skip/-only option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("**********************Unrolling Cuts***********************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();

  my $verilogparser = "$cfg->{'parserBinPath'}/verilogparser";

  if (!-e $verilogparser) {
    LOGDIE "unrollCuts: $verilogparser not accessible";
  }

  my $designLibrary = $cfg->{'designLibrary'};
  if (!-e $designLibrary) {
    LOGDIE "unrollCuts: $designLibrary not accessible";
  }

  my $numOrders = scalar @$cuts - 1;
  foreach my $order (0..$numOrders) {
    my $orderPath = $self->getOrderPath($order);
    my $runDir = $orderPath."/run_sample";

    vchdir($runDir,$opt->{'just-print'});

    my $unrollScript = "unroll.sh";
    my $concatScript = "vcat.pl";
    my $cmd = "\\cp $cfg->{'binaryPath'}/verilogparser/bin/vcat.pl $runDir";
    vsystem($cmd,$opt->{'just-print'});
    if (!-e $concatScript) {
      LOGDIE "vcat.pl is not present in $runDir directory. Terminating.";
    }
    if (!-e $unrollScript) {
      LOGDIE "unroll.sh is not present in $runDir directory. Terminating.";
    }

    my $type;
    my $cutName = $self->getCutName($cuts,$order);
    my $cutWords = $self->getCutWords($cuts,$order);
    my $cutBits = $self->getCutBits($cuts,$order);
    foreach my $sim (@sims) {
      if ($sim eq "func_mem") {
        $type = "func";
      } elsif ($sim eq "beh_mem") {
        $type = "beh";
      } else {
        $type = "real";
      }

      if ($type eq "real") {
        $cmd = "./$unrollScript -name $cutName 2>&1 > /dev/null";
      } else {
        $cmd = "./$unrollScript -name $cutName -type $type -nolec 2>&1 > /dev/null";
      }

      vsystem($cmd, $opt->{'just-print'});
    }
    if (!-e $concatScript) {
      LOGDIE "vcat.pl is not present in $runDir directory. Terminating.";
    }

    $cmd = "./$concatScript -name $cutName -w $cutWords -b $cutBits 2>&1 > /dev/null";
    vsystem($cmd, $opt->{'just-print'});
  }
}

sub cutFormal {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  if ($cfg->{'steps'}->{'CutFormal'} == 0) {
    INFO (">>Skipping cutFormal run since -skip/-only option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("*********************Running CutFormal*********************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();

  my $numOrders = scalar @$cuts - 1;
  foreach my $order (0..$numOrders) {
    my $orderPath = $self->getOrderPath($order);
    my $cutName = $self->getCutName($cuts,$order);
    my $runDir = $orderPath."/run_sample/fv/".$cutName;

    vchdir($runDir, $opt->{'just-print'});

    my $fvRunFile = "frun.sh";

    if (!-e $fvRunFile) {
      ERROR "cutFormal: $fvRunFile not accessible";
      $ecnt++;
      return 1;
    }

    vsystem("\\rm -rf *.log");
    my $cmd = "./$fvRunFile > frun.log";
    vsystem($cmd, $opt->{'just-print'});

    my $ifvErrCnt = 0;
    my @logFiles = findFileWithExtension($runDir, "log");
    foreach my $logFile (@logFiles) {
      $ifvErrCnt += $self->checkIFVLog($logFile);
    }
    if ($ifvErrCnt != 0) {
      ERROR "frun failed. Review IFV logs in the directory $runDir";
      $ecnt++;
      push (@$err_log, "frun failed in directory $runDir. Please rerun manually to find out the nature of the failure.");
    }
  }
}

sub getSpecialTestDrivers {
  my $self = shift;
  my $opt = $self->{'opt'};
  my $cfg = $self->{'cfg'};

  my $ipDir = $cfg->{'ipDir'};
  my $verifDir = "$ipDir/infra/verif";

  opendir(my $dh, $verifDir) || die "can't opendir $verifDir: $!";
  my $specialTestDriverAlgoList;
  @$specialTestDriverAlgoList = grep {-d "$verifDir/$_" && ! /^\.{1,2}$/} readdir($dh);
  closedir $dh;

  $cfg->{'specialTestDriverAlgoList'} = $specialTestDriverAlgoList;
  $self->{'cfg'} = $cfg;
  #print "$verifDir, $ipDir\n";
  #print split(', ', @{$self->{'cfg'}->{'specialTestDriverAlgoList'}});
  #print @{$self->{'cfg'}->{'specialTestDriverAlgoList'}};
  #LOGDIE "";
}

sub fChecker {
  my $self = shift;
  my $opt = $self->{'opt'};
  my $cfg = $self->{'cfg'};

  if ($cfg->{'steps'}->{'FCheck'} == 0) {
    INFO (">>Skipping fCheck run since -skip/-only option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("*********************Running fChecker**********************");
    INFO ("***********************************************************");
  }

  my $parserBinPath = $cfg->{'parserBinPath'};

  my $cuts = $self->getCutInfo();

  my $numOrders = scalar @$cuts - 1;
  foreach my $order (0..$numOrders) {
    my $orderPath = $self->getOrderPath($order);
    my $cutName = $self->getCutName($cuts,$order);
    my $runDir = $orderPath."/run_sample/fv/".$cutName;
    
    vchdir($runDir, $self->{'opt'}->{'just-print'});
    my $cmd = "$parserBinPath/fchkr.pl > fchkr.log";
    my $rc = vsystem($cmd, $self->{'opt'}->{'just-print'});
    if ($rc != TRUE) {
      ERROR "fChkr run failed.";
      $ecnt++;
      push (@$err_log, "fchkr run failed in directory $runDir. Please rerun manually to find out the nature of the failure.");
    }
  }
}

sub cutPackager {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  if ($cfg->{'steps'}->{'Pkg'} == 0) {
    INFO (">>Skipping packaging since -skip/-only option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("**********************Packaging Cuts***********************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();

  my $cmd;
  my $pkg = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/pkg";
  if ( -d $pkg) {
    INFO "Package directory exists. Copying it over.";
    my $pkgSuffix = getDateTime();
    my $oldPkgDir = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/pkg_$pkgSuffix";
    if (-d $oldPkgDir) {
      LOGDIE ("Old package directory $oldPkgDir exists. Exiting...");
    }  else {
      vsystem("mv $pkg $oldPkgDir", $opt->{'just-print'});
    }
  }
  vmkpath($pkg, $opt->{'just-print'});

  my $numOrders = scalar @$cuts - 1;
  foreach my $order (0..$numOrders) {
    vchdir($pkg, $opt->{'just-print'});
    my $orderPath = $self->getOrderPath($order);
    my $cutDir  = $cfg->{'orders'}->[$order]->{'cutDir'};
    my $cutName = $self->getCutName($cuts,$order);

    if ($cutDir ne "") {
      vmkpath($cutDir, $opt->{'just-print'});
      if ( !-d $cutDir) {
        LOGDIE "cutPackager: Couldn't create dirctory $cutName";
      }
      vchdir("$pkg/$cutDir", $opt->{'just-print'});
    }

    my $docDir = "doc";
    if ( !-d $docDir) {
      vmkpath($docDir, $opt->{'just-print'});
    }

    my $rtlDir = "rtl";
    if ( !-d $rtlDir) {
      vmkpath($rtlDir, $opt->{'just-print'});
    }

    my $verifSrcDir = "src/verif";
    if ( !-d $verifSrcDir) {
      vmkpath($verifSrcDir, $opt->{'just-print'});
    }

    my @verifArray = qw (verif.f testbench_init.v Common.sv testbench_clk.v testbench_refr.v testbench_dbg.v testbench_rand_init.v mem_beh_1r1w.sv mem_beh_1r1w1p.sv mem_beh_1rw.sv mem_beh_1rw2p.sv mem_beh_2r2w.sv mem_beh_2rw.sv test_driver.v);

    foreach my $file (@verifArray) {
      if ( !-e "$verifSrcDir/$file") {
        $cmd = "\\cp $cfg->{'binaryPath'}/memogen/src/rtl/infra/verif/$file $verifSrcDir/.";
        vsystem($cmd, $opt->{'just-print'});
      }
      if ( !-e "$verifSrcDir/$file") {
        LOGDIE "cutPackager: Testbench file $file couldn't be copied to delivery directory";
      }
    }

    my $inFile  = "$cfg->{'binaryPath'}/memogen/src/rtl/infra/verif/test_driver.v";
    my $outFile = "$verifSrcDir/test_driver.v";
    $self->removeErrInjCode($inFile, $outFile);
    foreach my $td (@{$cfg->{'specialTestDriverAlgoList'}}) {
      $inFile  = "$cfg->{'binaryPath'}/memogen/src/rtl/infra/verif/$td/test_driver_${td}.v";
      $outFile = "$verifSrcDir/test_driver_${td}.v";
      $self->removeErrInjCode($inFile, $outFile);
    }

    my $runDir = "run_sample";
    vmkpath($runDir, $opt->{'just-print'});
    if ( !-d $runDir) {
      LOGDIE "cutPackager: Couldn't create run_sample dirctory $runDir";
    }

    my $tbDir = "$runDir/testbench";
    vmkpath($tbDir, $opt->{'just-print'});
    if ( !-d $tbDir) {
      LOGDIE "cutPackager: Couldn't create run_sample dirctory $tbDir";
    }

    my $simlibDir = "$runDir/simlibs";
    vmkpath($simlibDir, $opt->{'just-print'});
    if ( !-d $simlibDir) {
      LOGDIE "cutPackager: Couldn't create simlibs dirctory $simlibDir";
    }

    my $numOrders = scalar @$cuts - 1;

    my $pkgCutPath;
    if ($cutDir ne "") {
      $pkgCutPath = "$pkg/$cutDir";
    } else {
      $pkgCutPath = $pkg;
    }
    vchdir("$pkgCutPath", $opt->{'just-print'});

    my $ext;
    foreach my $sim (@sims) {
      my $cutTopName = $cutName;
      if ($sim eq "func_mem") {
        $cutTopName = $cutName."_func";
      } elsif ($sim eq "beh_mem") {
        $cutTopName = $cutName."_beh";
      }
      my $srcCutV;
      if ($sim eq "real_mem") {
        $srcCutV = "$orderPath/rtl_encrypted/${cutTopName}.v";
      } else {
        $srcCutV = "$orderPath/rtl_unrolled/${cutTopName}.v";
      }
      my $dstCutV = "$rtlDir/${cutTopName}.v";
      if ($sim ne "func_mem") {
        $self->removeCmdLine($srcCutV, $dstCutV);
      }
      
      $ext = "core_".$cfg->{'version'};
      if ($sim eq "func_mem") {
        $ext .= "_func";
      } elsif ($sim eq "beh_mem") {
        $ext .= "_beh";
      }
      my $cutCoreName     = "${cutName}_${ext}";
      my $cutCoreV = "$rtlDir/${cutCoreName}.v";
      $self->encryptVerilog ($order,$ext);
      foreach my $tool (@encTools) {
        $cmd = "\\cp $orderPath/rtl_enc/${cutCoreName}_${tool}.v $rtlDir";
        vsystem($cmd, $opt->{'just-print'});
        my $cutCoreEncV = "$rtlDir/${cutCoreName}_${tool}.v";
        if ( !-e $cutCoreEncV) {
          LOGDIE "cutPackager: Encrypted ${cutCoreName}_<ncv,vcs,vsim,velo>.v files couldn't be copied to delivery directory";
        }
      }

      my $ext_donut = "core_donut_".$cfg->{'version'};
      my $cutCoreDonutName = "${cutName}_${ext_donut}";
      my $cutCoreDonutV    = "$rtlDir/${cutCoreDonutName}.v";
      $cmd = "\\cp $orderPath/rtl/${cutCoreDonutName}.v $cutCoreDonutV";
      vsystem($cmd, $opt->{'just-print'});
      if ( !-e $cutCoreDonutV) {
        LOGDIE "cutPackager: ${cutCoreDonutV} couldn't be copied to delivery directory";
      }

      my $ext_sva = "core_sva_".$cfg->{'version'};
      my $cutCoreSvaName = "${cutName}_${ext_sva}";
      my $srcSvaFile = "$orderPath/rtl_unrolled/${cutCoreSvaName}.v";
      my $dstSvaFile = "$rtlDir/${cutCoreSvaName}.v";
      open my $old , '<', $srcSvaFile or die "Can't read file: $srcSvaFile";
      open my $new , '>', $dstSvaFile or die "Can't read file: $dstSvaFile";
      while( <$old> ) {
        $_ =~ s/\[\s+\*(\d+)\s+\]/\[\*$1\]/;
        print $new $_;
      }
      close $old;
      close $new;

      $ext_sva = "core_sva_".$cfg->{'version'};
      $cutCoreSvaName = "${cutName}_${ext_sva}_func";
      $srcSvaFile = "$orderPath/rtl_unrolled/${cutCoreSvaName}.v";
      $dstSvaFile = "$rtlDir/${cutCoreSvaName}.v";
      open $old , '<', $srcSvaFile or die "Can't read file: $srcSvaFile";
      open $new , '>', $dstSvaFile or die "Can't read file: $dstSvaFile";
      while( <$old> ) {
        $_ =~ s/\[\s+\*(\d+)\s+\]/\[\*$1\]/;
        print $new $_;
      }
      close $old;
      close $new;
    }

    my $cutDatasheet = "$docDir/${cutName}_datasheet.txt";
    my $cutInst = "$docDir/${cutName}.inst";
    $self->removeCmdLine("$orderPath/doc/${cutName}_datasheet.txt", $cutDatasheet);

    $cmd = "\\cp $orderPath/doc/${cutName}.inst $cutInst";
    vsystem($cmd, $opt->{'just-print'});
    if ( !-e $cutInst) {
      LOGDIE "cutPackager: Cut datasheet file $cutDatasheet couldn't be copied to delivery directory";
    }

    $cmd = "\\cp $orderPath/run_sample/*.f $runDir";
    my $r1 = vsystem($cmd, $opt->{'just-print'});
    if ($r1 != TRUE) {
      LOGDIE ("cutPackager: Command \"$cmd\" failed.");
    }

    foreach my $sim (@sims_short) {
      my $ext = "";
      if ($sim eq "func_mem") {
        $ext = "_func";
      } elsif ($sim eq "beh_mem") {
        $ext = "_beh";
      }

      $cmd = "\\cp $orderPath/run_sample/run$ext $runDir";
      my $r2 = vsystem($cmd, $opt->{'just-print'});
      if ($r2 != TRUE) {
        LOGDIE ("cutPackager: Command \"$cmd\" failed.");
      }

      if ($sim eq "real_mem") {
        $cmd = "\\cp $orderPath/run_sample/simlibs/* $simlibDir";
        my $r4 = vsystem($cmd, $opt->{'just-print'});
        if ($r4 != TRUE) {
          LOGDIE ("cutPackager: Command \"$cmd\" failed.");
        }
      }
    }

    
    my $tbCutDir = "$tbDir/$cutName";
    vmkpath($tbCutDir, $opt->{'just-print'});
    if ( !-d $tbCutDir) {
      LOGDIE "Couldn't create dirctory $tbCutDir";
    }

    my $verifF = "-F ../../../../src/verif/verif.f";

    my $postfix;
    foreach my $sim (@sims_short) {
      my $memDir = "$tbCutDir/$sim";
      vmkpath($memDir, $opt->{'just-print'});
      if ( !-d $memDir) {
        LOGDIE "Couldn't create dirctory $memDir";
      }
      $cmd = "\\cp $orderPath/run_sample/testbench/$cutName/$sim/testbench\*.v $memDir";
      my $r5 = vsystem($cmd, $opt->{'just-print'});
      if ($r5 != TRUE) {
        LOGDIE ("cutPackager: Command \"$cmd\" failed.");
      }
      foreach my $tool (@tools) {
        $ext = "core_".$cfg->{'version'};
        $postfix = "";
        if ($sim eq "func_mem") {
          $postfix = "_func";
          $ext  .= "_func";
        } elsif ($sim eq "beh_mem") {
          $postfix = "_beh";
          $ext  .= "_beh";
        }
        my $old = "$orderPath/run_sample/testbench/$cutName/$sim/sim${postfix}.${tool}.f";
        my $new = "$memDir/sim${postfix}.${tool}.f";
        INFO ($old);
        INFO ($new);
        open my $in,  '<',  "$orderPath/run_sample/testbench/$cutName/$sim/sim${postfix}.${tool}.f" or die "Can't read old file: $!";
        open my $out, '>', "$memDir/sim${postfix}.${tool}.f" or die "Can't write new file: $!";
        print $out "-v ../../../../rtl/${cutName}_${ext}_${tool}.v \n";

        open $in,  '<',  "$orderPath/run_sample/testbench/$cutName/$sim/sim${postfix}.${tool}.f" or die "Can't read old file: $!";
        my $funcCore = "-v ../../../../rtl/${cutName}_core_$cfg->{'version'}_func_${tool}.v\n";
        print $out $funcCore;
        while( <$in> ) {
          if ($_ !~ /rtl\.f/) {
            if ($_ =~ /test_driver(\S+)/) {
              $_ = "../../../../src/verif/test_driver$1\n";
            }
            $_ =~ s/^.*verif\.f.*$/$verifF/;
            print $out $_;
          }
        }
        close $out;
      }
    }
  }

  my $projDir = $cfg->{'groupName'};
  my $packageDir = $cfg->{'packageDir'};

  vchdir($pkg, $opt->{'just-print'});
  $cmd = "tar cvfz $cfg->{'packageName'}.tar.gz * 2>&1 >> /dev/null";
  my $r9 = vsystem($cmd, $opt->{'just-print'});
  if ($r9 != TRUE) {
    LOGDIE ("cutPackager: Command \"$cmd\" failed.");
  }

  $self->pkgDonutCompileCheck();

}

sub pkgDonutCompileCheck {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};
  
  my $ext;
  my $donutV;

  my $cuts = $self->getCutInfo();
  my $numOrders = scalar @$cuts - 1;
  my $pkgDir = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/pkg";

  foreach my $order (0..$numOrders) {
    my $cutName = $self->getCutName($cuts,$order);
    my $cutDir  = $cfg->{'orders'}->[$order]->{'cutDir'};
    my $runDir = "$pkgDir/rtl";
    if ($cutDir ne "") {
      $runDir = "$pkgDir/$cutDir/rtl";
    }
    vchdir($runDir, $opt->{'just-print'});
    $ext = "_core_donut_".$cfg->{'version'};
    $donutV = $cutName.$ext.".v";
    foreach my $tool (@tools) {

      if ($tool eq "ncv") {
        vrm("INCA_libs", $opt->{'just-print'});
        if (-e $simLogFile) {
          vsystem("\\rm sim.log", $opt->{'just-print'});
        }
        my $cmd = "ncverilog -l sim.log +sv -compile $donutV 2>&1 > /dev/null";
        my $passString = "^\\s+errors: 0, warnings: 0";
        $self->runCmd($cmd, $simLogFile, $passString, $runDir, "cutPackager: Donut compile checks: ");
        vrm("INCA_libs", $opt->{'just-print'});
      }

      if ($tool eq "vcs") {
        if (-e $simLogFile) {
          vsystem("\\rm sim.log", $opt->{'just-print'});
        }
        my $passString = "^\\.\\./simv up to date";
        my $cmd = "vcs $donutV -l sim.log 2>&1 > /dev/null";
        $self->runCmd($cmd, $simLogFile, $passString, $runDir, "cutPackager: Donut compile checks: ");
        vrm("simv.daidir", $opt->{'just-print'});
        vrm("simv", $opt->{'just-print'});
        vrm("csrc", $opt->{'just-print'});
      }

      if ($tool eq "vsim") {
        my $passString = "^Top level modules:";
        if (-e $simLogFile) {
          vsystem("\\rm sim.log", $opt->{'just-print'});
        }
        my $cmd = "vlib work && vlog $donutV -l sim.log 2>&1 > /dev/null";
        $self->runCmd($cmd, $simLogFile, $passString, $runDir, "cutPackager: Donut compile checks: ");
        vrm("work", $opt->{'just-print'});
      }
      if (-e $simLogFile) {
        vrm("sim.log", $opt->{'just-print'});
      }
    }
  }
}

sub postPkgSim {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  if ($cfg->{'steps'}->{'PostSimChks'} == 0) {
    INFO (">>Skipping post packaging checks since -skip/-only option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("***************Running Post Packaging Sims*****************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();
  my $packageName = $cfg->{'packageName'};

  my $ppc = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/ppc";
  if ( -d $ppc) {
    INFO "PPC directory exists. Moving it.";
    my $ppcSuffix = getDateTime();
    my $oldPpcDir = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/ppc_$ppcSuffix";
    if (-d $oldPpcDir) {
      LOGDIE ("Old package directory $oldPpcDir exists. Exiting...");
    }  else {
      vsystem("mv $ppc $oldPpcDir", $opt->{'just-print'});
    }
  }
  vmkpath($ppc, $opt->{'just-print'});
  vchdir($ppc, $opt->{'just-print'});


  my $pkgDir = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/pkg";

  my $pkgFile = $packageName.".tar.gz";
  my $cmd = "\\cp -f $pkgDir/$pkgFile .";
  my $r1 = vsystem($cmd, $opt->{'just-print'});
  if ($r1 != TRUE) {
    LOGDIE ("postPkgSimsChecker: Command \"$cmd\" failed.");
  }
  $cmd = "tar xvfz $pkgFile 1>&2 > /dev/null";
  my $r2 = vsystem($cmd, $opt->{'just-print'});
  if ($r2 != TRUE) {
    LOGDIE ("postPkgSimsChecker: Command \"$cmd\" failed.");
  }

  my $numOrders = scalar @$cuts - 1;
  my ($sim, $script, $cutName, $runDir, $cutDir, $pass);
  my $orderPath;

  foreach my $order (0..$numOrders) {
    $cutName = $self->getCutName($cuts,$order);
    $orderPath = $self->getOrderPath($order);
    $cutDir  = $cfg->{'orders'}->[$order]->{'cutDir'};
    foreach $sim (@sims_short) {

       my $runDir = "$ppc/run_sample/testbench/$cutName/$sim";
       if ($cutDir ne "") {
        $runDir = "$ppc/$cutDir/run_sample/testbench/$cutName/$sim";
       }

      vchdir($runDir, $opt->{'just-print'});
      $cmd = "\\cp $orderPath/run_sample/testbench/$cutName/$sim/*.sh .";
      vsystem($cmd, $self->{'opt'}->{'just-print'});

      my $result_logs = "result_logs";
      if (!-d $result_logs) {
        vmkpath($result_logs, $opt->{'just-print'});
      }

      foreach my $tool (@tools) {
        if ($sim eq "beh_mem") {
          $script = "./sim.$tool.sh";
        } elsif($sim eq "real_mem") {
          $script = "./sim.$tool.sh +define+MEMOIR_DBG_TEST";
        }
        $cmd = "$script 2>&1 > /dev/null";
        $self->runCmd($cmd, $simLogFile, $simPassString, $runDir, "Post package checks");
        $cmd = "\\cp $simLogFile $result_logs/${tool}_$simLogFile";
        vsystem($cmd, $opt->{'just-print'});
        if($sim eq "real_mem") {
          $cmd = "$script +define+MEMOIR_FUNC_MODEL 2>&1 > /dev/null";
          $self->runCmd($cmd, $simLogFile, $simPassString, $runDir, "Post package checks");
          $cmd = "\\cp $simLogFile $result_logs/${tool}_func_$simLogFile";
          vsystem($cmd, $opt->{'just-print'});
        }
      }
    }
  }
}

sub postPkgSyn {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  if ($cfg->{'steps'}->{'PostSynChks'} == 0) {
    INFO (">>Skipping post packaging checks since -skip/-only option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("*********Running Post Packaging Synthesis Checks***********");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();
  my $packageName = $cfg->{'packageName'};

  my $ppc = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/ppc";
  vchdir($ppc, $opt->{'just-print'});

  my $numOrders = scalar @$cuts - 1;
  my ($sim, $script, $cutName, $runDir, $cutDir, $pass);
  my $orderPath;

  foreach my $order (0..$numOrders) {
    if ($opt->{'dc'}) {
      INFO (">>Skipping post package RC/LEC/RC_gatesim steps since -dc was specified");
    } else {
      $self->postSyn($order);
      $self->postLec($order);
      $self->postGates($order);
    }
    if ($opt->{'rc'}) {
      INFO (">>Skipping post package DC/DC->LEC/DC_gatesim steps since -rc was specified");
    } else {
      $self->postDCSyn($order);
      $self->postDCLec($order);
      $self->postDCGates($order);
      $self->postDCFormality($order);
    }
  }
}

sub postVCSLint {
  my $self  = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};
  
  if ($cfg->{'steps'}->{'PostVCSLint'} == 0) {
    INFO (">>Skipping post packaging VCS Lint checks since -skip/-only option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("**************Running Post Packaging VCS LINT***************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();
  my $packageName = $cfg->{'packageName'};

  my $ppc = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/ppc";
  vchdir($ppc, $opt->{'just-print'});

  my $numOrders = scalar @$cuts - 1;
  my ($sim, $script, $cutName, $runDir, $cutDir, $pass);

  my $line;
  my $sim_f = "vcs_lint.f";
  foreach my $order (0..$numOrders) {
    my $cutName = $self->getCutName($cuts,$order);
    my $lintLogF = "result_logs/lint.log";
    my $donutLintLogF = "result_logs/donut_lint.log";
    my $lintCmd = "vcs -sverilog -F $sim_f +lint=all > result_logs/lint.log";
    my $donutLintCmd = "vcs -sverilog -F $sim_f +define+MEMOIR_DONUT +lint=all > $donutLintLogF";

    my $orderPath = $self->getOrderPath($order);
    my $cutDir  = $cfg->{'orders'}->[$order]->{'cutDir'};
    my $runDir;
    if ($cutDir ne "") {
      $runDir = "$ppc/$cutDir/run_sample/testbench/$cutName/real_mem";
    } else {
      $runDir = "$ppc/run_sample/testbench/$cutName/real_mem";
    }

    vchdir($runDir, $opt->{'just-print'});

    my $vcsExe = "simv";
    if (-e $vcsExe) {
      vrm($vcsExe, $opt->{'just-print'});
    }

    my $vcsDir1 = "simv.daidir";
    if (-d $vcsDir1) {
      vrm($vcsDir1, $opt->{'just-print'});
    }

    my $vcsDir2 = "csrc";
    if (-d $vcsDir2) {
      vrm($vcsDir2, $opt->{'just-print'});
    }

    open my $new, '>', $sim_f or die "Can't write new file: $!";
    $line = "../../../../rtl/${cutName}.v\n";
    print $new $line;
    $line = "-v ../../../../rtl/${cutName}_core_$cfg->{'version'}_vcs.v\n";
    print $new $line;
    $line = "-v ../../../../rtl/${cutName}_core_donut_$cfg->{'version'}.v\n";
    print $new $line;
    $line = "-v ../../../../rtl/${cutName}_core_$cfg->{'version'}_func_vcs.v\n";
    print $new $line;
    my $sva = "../../../../rtl/${cutName}_core_sva_$cfg->{'version'}.v";
    if (-e $sva) {
      $line = "-v $sva\n";
      print $new $line;
    }
    $line = "+define+SIM_TOP=$cutName\n";
    print $new $line;
    $line = "-F ../../../common.vcs.f\n";
    print $new $line;
    my $tech_f = uc($cfg->{'tech'})."_LIBS.f";
    $line = "-f ../../../$tech_f\n";
    print $new $line;
    $line = "-y ../../../simlibs\n";
    print $new $line;
    close $new;
    vchmod (0755, $sim_f, $opt->{'just-print'});


    my $result_logs = "result_logs";
    if (!-d $result_logs) {
      vmkpath($result_logs, $opt->{'just-print'});
    }
    
    my $passString = "^\\.\\./simv up to date";
    $self->runCmd($lintCmd, $lintLogF, $passString, $runDir, "Post package lint: ");
    my $str = "Lint";
    my $lintWarnF = "result_logs/lint.wrn";
    $pass = $self->parseLogs($str,$lintLogF, $lintWarnF, \@vcsLintWaiverList);
    push (@$err_log, "Error: In $runDir, VCS lint checks failed. Please Review $runDir/result_logs/$lintWarnF") if $pass == 0;

    $self->runCmd($donutLintCmd, $donutLintLogF, $passString, $runDir, "Post package lint with donut model: ");
    my $donutLintWarnF = "result_logs/donut_lint.wrn";
    $pass = $self->parseLogs($str,$donutLintLogF, $donutLintWarnF, \@vcsLintWaiverList);
    push (@$err_log, "Error: In $runDir, VCS lint checks failed. Please Review $runDir/result_logs/$donutLintWarnF") if $pass == 0;
  }
}

sub postDCLint {
  my $self  = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};
  
  if ($cfg->{'steps'}->{'PostDCLint'} == 0) {
    INFO (">>Skipping post packaging DC Lint checks since -skip/-only option was specified<<");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("**************Running Post Packaging DC LINT***************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();
  my $packageName = $cfg->{'packageName'};

  my $ppc = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/ppc";
  vchdir($ppc, $opt->{'just-print'});

  my $numOrders = scalar @$cuts - 1;
  my ($sim, $script, $cutName, $runDir, $cutDir, $pass);
  my $orderPath;

  foreach my $order (0..$numOrders) {
    my $cutName = $self->getCutName($cuts,$order);
    my $dcLogF = "dc.log";
    my $lintLogF = "reports/${cutName}\.check_design\.rpt";
    my $lintCmd = "./syn_dc_lint.sh 2>&1 > /dev/null";

    my $orderPath = $self->getOrderPath($order);
    my $cutDir  = $cfg->{'orders'}->[$order]->{'cutDir'};
    my $runDir;
    if ($cutDir ne "") {
      $runDir = "$ppc/$cutDir/run_sample/testbench/$cutName/real_mem";
    } else {
      $runDir = "$ppc/run_sample/testbench/$cutName/real_mem";
    }

    vchdir($runDir, $opt->{'just-print'});

    my $old = "$orderPath/run_sample/testbench/$cutName/real_mem/syn_dc.sh";
    my $new = "syn_dc_lint.sh";
    open my $in,  '<',  $old or die "Can't read old file: $!";
    open my $out, '>', $new or die "Can't write new file: $!";
    while( <$in> ) {
      $_ =~ s/rgr_dc_syn_script/rgr_dc_lint_script/;
      $_ =~ s/core_$cfg->{'version'}\.v.*$/core_$cfg->{'version'}_vcs\.v"/;
      print $out $_;
    }
    close $out;
    vchmod (0755, $new, $opt->{'just-print'});

    $old = "$orderPath/run_sample/rgr_dc_syn_script.tcl";
    $new = "../../../rgr_dc_lint_script.tcl";
    open $in,  '<',  $old or die "Can't read old file: $!";
    open $out, '>', $new or die "Can't write new file: $!";
    while( <$in> ) {
      if ($_ =~ /End of check_design/) {
        print $out $_;
        print $out "quit";
        last;
      }
      print $out $_;
    }
    close $out;

    my $result_logs = "result_logs";
    if (!-d $result_logs) {
      vmkpath($result_logs, $opt->{'just-print'});
    }

    my $passString = "End of check_design";
    $self->runCmd($lintCmd, $dcLogF, $passString, $runDir, "Post package lint: ");
    my $str = "LINT";
    my $lintWarnF = "result_logs/check_design.log";
    $pass = $self->parseLogs($str,$lintLogF, $lintWarnF, \@dcLintWaiverList);
    if (!$pass) {
      $ecnt++;
      push (@$err_log, "Error: In $runDir, lint checks failed. Please Review $runDir/$lintWarnF") if $pass == 0;
    }
  }
}

sub parseLogs{
  my $self  = shift;
  my $matchString = shift;
  my $logFile = shift;
  my $outFile = shift;
  my $waiverList = shift;
  confess "Not enough arguments" if !defined $waiverList;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};
  
  my $pass;
  
  my @warnArray;
  my $lineCnt = 0;
  open my $in,  '<', $logFile or die "Can't read log file: $!";
  while( <$in> ) {
    chomp;
    if ($_ =~ /\Q$matchString/) {
      my $fail = 1;
      foreach my $warn (@$waiverList) {
        if ($_ =~ /\Q$warn/) {
          $fail = 0;
          last;
        }
      }
      if ($fail) {
        push (@warnArray, $_." @ $logFile line number $lineCnt\n");
      }
    }
      $lineCnt++;
  }

  if (-e $outFile) {
    vrm($outFile, $opt->{'just-print'});
  }

  if (scalar(@warnArray) > 0) {
    open my $out, '>', $outFile or die "Can't open log file $outFile";
    foreach my $warn (@warnArray) {
      print $out $warn;
    }
    close $out;
    vchmod (0755, $outFile, $opt->{'just-print'});
    return 0;
  } else {
    return 1;
  }
}

sub postSyn {
  my $self  = shift;
  my $order = shift;
  confess "Not enough arguments" if !defined $order;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};
  
  my $pass;

  my $cuts = $self->getCutInfo();
  my $cutName = $self->getCutName($cuts,$order);
  my $ppcDir = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/ppc";

  my $cutDir  = $cfg->{'orders'}->[$order]->{'cutDir'};
  my $runDir;
  if ($cutDir ne "") {
    $runDir = "$ppcDir/$cutDir/run_sample/testbench/$cutName/real_mem";
  } else {
    $runDir = "$ppcDir/run_sample/testbench/$cutName/real_mem";
  }

  vchdir($runDir, $opt->{'just-print'});

  my $result_logs = "result_logs";
  if (!-d $result_logs) {
    vmkpath($result_logs, $opt->{'just-print'});
  }

  my $orderPath = $self->getOrderPath($order);
  my $srcSynF = "$orderPath/run_sample/testbench/$cutName/real_mem/syn.sh";
  my $dstSynF = "$runDir/syn.sh";
  $self->copyFromCut2Ppc($order,$srcSynF,$dstSynF,"ncv");

  my $cmd = "\\cp $orderPath/run_sample/*.tcl $ppcDir/run_sample";
  if ($cutDir ne "") {
    $cmd = "\\cp $orderPath/run_sample/*.tcl $ppcDir/$cutDir/run_sample";
  }
  vsystem($cmd, $self->{'opt'}->{'just-print'});

  $cmd = "./syn.sh 2>&1 > /dev/null";
  $self->runCmd($cmd, $rcSynLogFile, $rcSynPassString, $runDir, "Post package RC synthesis:");
  $cmd = "\\cp $rcSynLogFile $result_logs/$rcSynLogFile";
  vsystem($cmd, $opt->{'just-print'});
}
sub postDCSyn {
  my $self  = shift;
  my $order = shift;
  confess "Not enough arguments" if !defined $order;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};
  
  my $pass;

  my $cuts = $self->getCutInfo();
  my $cutName = $self->getCutName($cuts,$order);
  my $ppcDir = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/ppc";

  my $cutDir  = $cfg->{'orders'}->[$order]->{'cutDir'};
  my $runDir;
  if ($cutDir ne "") {
    $runDir = "$ppcDir/$cutDir/run_sample/testbench/$cutName/real_mem";
  } else {
    $runDir = "$ppcDir/run_sample/testbench/$cutName/real_mem";
  }

  vchdir($runDir, $opt->{'just-print'});

  my $result_logs = "result_logs";
  if (!-d $result_logs) {
    vmkpath($result_logs, $opt->{'just-print'});
  }

  my $orderPath = $self->getOrderPath($order);
  my $srcSynF = "$orderPath/run_sample/testbench/$cutName/real_mem/syn_dc.sh";
  my $dstSynF = "$runDir/syn_dc.sh";
  $self->copyFromCut2Ppc($order,$srcSynF,$dstSynF,"vcs");

  my $cmd = "\\cp $orderPath/run_sample/*.tcl $ppcDir/run_sample";
  if ($cutDir ne "") {
    $cmd = "\\cp $orderPath/run_sample/*.tcl $ppcDir/$cutDir/run_sample";
  }
  vsystem($cmd, $self->{'opt'}->{'just-print'});

  $cmd = "./syn_dc.sh 2>&1 > /dev/null";
  $self->runCmd($cmd, $dcSynLogFile, $dcSynPassString, $runDir, "Post package checks");
  $cmd = "\\cp $dcSynLogFile $result_logs/$dcSynLogFile";
  vsystem($cmd, $opt->{'just-print'});

  my $str = "^Warning:";
  my $dcWarnF = "result_logs/dc.wrn";
  $pass = $self->parseLogs($str,$dcSynLogFile, $dcWarnF, \@dcWaiverList);
  push (@$err_log, "Error: In $runDir, dc checks failed. Please Review $runDir/$dcWarnF") if $pass == 0;
}

sub postGates {
  my $self  = shift;
  my $order = shift;
  confess "Not enough arguments" if !defined $order;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  my $pass;

  my $cuts = $self->getCutInfo();
  my $cutName = $self->getCutName($cuts,$order);
  my $ppcDir = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/ppc";

  my $cutDir  = $cfg->{'orders'}->[$order]->{'cutDir'};
  my $runDir;
  if ($cutDir ne "") {
    $runDir = "$ppcDir/$cutDir/run_sample/testbench/$cutName/real_mem";
  } else {
    $runDir = "$ppcDir/run_sample/testbench/$cutName/real_mem";
  }
  vchdir($runDir, $opt->{'just-print'});

  my $orderPath = $self->getOrderPath($order);

  my $verifF = "-F ../../../../src/verif/verif.f";
  open my $in,  '<',  "$orderPath/run_sample/testbench/$cutName/real_mem/gsim.f" or die "Can't read old file: $!";
  my $outFile = "$runDir/gsim.f";
  open my $out, '>', $outFile or die "Can't write new file: $outFile";
  while( <$in> ) {
    if ($_ !~ /rtl/) {
      if ($_ =~ /test_driver(\S+)/) {
        $_ = "-v ../../../../src/verif/test_driver$1\n";
        print $out $_;
      } elsif ($_ =~ /outputs/) {
        print $out " -v $runDir/outputs/${cutName}.v\n";
      }
      if ($_ =~ /outputs/) {
        print $out " -v $runDir/outputs/${cutName}.v\n";
      } elsif ($_ !~ /verif/) {
        print $out $_;
      }
    }
  }
  print $out $verifF;
  my $cmd = "\\cp $orderPath/run_sample/testbench/$cutName/real_mem/gsim.sh .";
  vsystem($cmd, $self->{'opt'}->{'just-print'});

  my $result_logs = "result_logs";
  if (!-d $result_logs) {
    vmkpath($result_logs, $opt->{'just-print'});
  }

  $cmd = "./gsim.sh 2>&1 > /dev/null";
  $self->runCmd($cmd, $simLogFile, $simPassString, $runDir, "Post package checks");
  $cmd = "\\cp $simLogFile $result_logs/gatesim_ncv_$simLogFile";
  vsystem($cmd, $opt->{'just-print'});
}

sub postDCGates {
  my $self  = shift;
  my $order = shift;
  confess "Not enough arguments" if !defined $order;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  my $pass;

  my $cuts = $self->getCutInfo();
  my $cutName = $self->getCutName($cuts,$order);
  my $ppcDir = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/ppc";

  my $cutDir  = $cfg->{'orders'}->[$order]->{'cutDir'};
  my $runDir;
  if ($cutDir ne "") {
    $runDir = "$ppcDir/$cutDir/run_sample/testbench/$cutName/real_mem";
  } else {
    $runDir = "$ppcDir/run_sample/testbench/$cutName/real_mem";
  }
  vchdir($runDir, $opt->{'just-print'});

  my $orderPath = $self->getOrderPath($order);

  my $verifF = "-F ../../../../src/verif/verif.f";
  open my $in,  '<',  "$orderPath/run_sample/testbench/$cutName/real_mem/gsim_dc.f" or die "Can't read old file: $!";
  my $outFile = "$runDir/gsim_dc.f";
  open my $out, '>', $outFile or die "Can't write new file: $outFile";
  while( <$in> ) {
    if ($_ !~ /rtl/) {
      if ($_ =~ /test_driver(\S+)/) {
        $_ = "-v ../../../../src/verif/test_driver$1\n";
        print $out $_;
      } elsif ($_ =~ /outputs/) {
        print $out " -v $runDir/outputs/${cutName}.flat.vg\n";
      } elsif ($_ !~ /verif/) {
        print $out $_;
      }
    }
  }
  print $out $verifF;
  my $cmd = "\\cp $orderPath/run_sample/testbench/$cutName/real_mem/gsim_dc.sh .";
  vsystem($cmd, $self->{'opt'}->{'just-print'});

  my $result_logs = "result_logs";
  if (!-d $result_logs) {
    vmkpath($result_logs, $opt->{'just-print'});
  }

  $cmd = "./gsim_dc.sh 2>&1 > /dev/null";
  $self->runCmd($cmd, $simLogFile, $simPassString, $runDir, "Post package checks");
  $cmd = "\\cp $simLogFile $result_logs/gatesim_ncv_$simLogFile";
  vsystem($cmd, $opt->{'just-print'});
}

sub postLec {
  my $self  = shift;
  my $order = shift;
  confess "Not enough arguments" if !defined $order;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  my $pass;

  my $cuts = $self->getCutInfo();
  my $cutName = $self->getCutName($cuts,$order);
  my $ppcDir = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/ppc";

  my $cutDir  = $cfg->{'orders'}->[$order]->{'cutDir'};
  my $runDir;
  if ($cutDir ne "") {
    $runDir = "$ppcDir/$cutDir/run_sample/testbench/$cutName/real_mem";
  } else {
    $runDir = "$ppcDir/run_sample/testbench/$cutName/real_mem";
  }

  vchdir($runDir, $opt->{'just-print'});
  my $result_logs = "result_logs";
  if (!-d $result_logs) {
    vmkpath($result_logs, $opt->{'just-print'});
  }


  my $orderPath = $self->getOrderPath($order);
  my $cmd = "\\cp $orderPath/run_sample/testbench/$cutName/real_mem/lec.sh .";
  vsystem($cmd, $self->{'opt'}->{'just-print'});

  $cmd = "./lec.sh 2>&1 > /dev/null";
  $self->runCmd($cmd, $lecLogFile, $lecPassString, $runDir, "Post package checks");
  $cmd = "\\cp $lecLogFile $result_logs/$lecLogFile";
  vsystem($cmd, $opt->{'just-print'});
}

sub postDCFormality {
  my $self = shift;
  my $order = shift;
  confess "Not enough arguments" if !defined $order;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  my $pass;

  my $cuts = $self->getCutInfo();
  my $cutName = $self->getCutName($cuts,$order);
  my $ppcDir = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/ppc";

  my $cutDir  = $cfg->{'orders'}->[$order]->{'cutDir'};
  my $runDir;
  if ($cutDir ne "") {
    $runDir = "$ppcDir/$cutDir/run_sample/testbench/$cutName/real_mem";
  } else {
    $runDir = "$ppcDir/run_sample/testbench/$cutName/real_mem";
  }

  my $runSampleDir;
  if ($cutDir ne "") {
    $runSampleDir = "$ppcDir/$cutDir/run_sample";
  } else {
    $runSampleDir = "$ppcDir/run_sample";
  }

  vchdir($runDir, $opt->{'just-print'});
  my $result_logs = "result_logs";
  if (!-d $result_logs) {
    vmkpath($result_logs, $opt->{'just-print'});
  }

  my $orderPath = $self->getOrderPath($order);
  my $srcFormF = "$orderPath/run_sample/testbench/$cutName/real_mem/formality.sh";
  my $dstFormF = "$runDir/formality.sh";
  $self->copyFromCut2Ppc($order,$srcFormF,$dstFormF,"vcs");

  my $cmd = "\\cp $orderPath/run_sample/rgr_formality_script.tcl $runSampleDir/rgr_formality_script.tcl";
  vsystem($cmd, $opt->{'just-print'});

  $cmd = "./formality.sh 2>&1 > /dev/null";
  $self->runCmd($cmd, $formalityLogFile, $formalityPassString, $runDir, "Post package formality:");
  $cmd = "\\cp $formalityLogFile $result_logs/$formalityLogFile";
  vsystem($cmd, $opt->{'just-print'});
}

sub postDCLec {
  my $self  = shift;
  my $order = shift;
  confess "Not enough arguments" if !defined $order;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  my $pass;

  my $cuts = $self->getCutInfo();
  my $cutName = $self->getCutName($cuts,$order);
  my $ppcDir = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/ppc";

  my $cutDir  = $cfg->{'orders'}->[$order]->{'cutDir'};
  my $runDir;
  if ($cutDir ne "") {
    $runDir = "$ppcDir/$cutDir/run_sample/testbench/$cutName/real_mem";
  } else {
    $runDir = "$ppcDir/run_sample/testbench/$cutName/real_mem";
  }

  my $runSampleDir;
  if ($cutDir ne "") {
    $runSampleDir = "$ppcDir/$cutDir/run_sample";
  } else {
    $runSampleDir = "$ppcDir/run_sample";
  }

  vchdir($runDir, $opt->{'just-print'});
  my $result_logs = "result_logs";
  if (!-d $result_logs) {
    vmkpath($result_logs, $opt->{'just-print'});
  }

  my $orderPath = $self->getOrderPath($order);
  my $srcLecF = "$orderPath/run_sample/testbench/$cutName/real_mem/lec_dc.sh";
  my $dstLecF = "$runDir/lec_dc.sh";
  $self->copyFromCut2Ppc($order,$srcLecF,$dstLecF,"ncv");

  my $cmd = "./formality.sh 2>&1 > /dev/null";

  $cmd = "\\cp $orderPath/run_sample/rtl2final_dc.lec.do  $runSampleDir/rtl2final_dc.lec.do";
  vsystem($cmd, $self->{'opt'}->{'just-print'});

  $cmd = "./lec_dc.sh 2>&1 > /dev/null";
  $self->runCmd($cmd, $lecDCLogFile, $lecPassString, $runDir, "Post package checks");
  $cmd = "\\cp $lecDCLogFile $result_logs/$lecDCLogFile";
  vsystem($cmd, $opt->{'just-print'});
}

sub updateBug {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  WARN ("updateBug method is not implemented yet.");
  $wcnt++;
  push (@$wrn_log, "updateBug");
}

sub runErrInj {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;


  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  if ($cfg->{'steps'}->{'ErrInj'} == 0) {
    INFO (">>Skipping Error Injection simulations since -skip/-only option was specified>>");
    return 0;
  } else {
    INFO ("***********************************************************");
    INFO ("************Running Error Injection simulations************");
    INFO ("***********************************************************");
  }

  my $cuts = $self->getCutInfo();

  my $cmd;
  my $pass;
  my $script;
  my $simECnt = 0;

  my $numOrders = scalar @$cuts - 1;
  foreach my $order (0..$numOrders) {
    my $orderPath = $self->getOrderPath($order);
    my $cutName = $self->getCutName($cuts,$order);
    my $cutDir = $orderPath."/run_sample/testbench/".$cutName;
    if (!-d $cutDir) {
      ERROR ("        Directory $cutDir is not found.");
      ERROR ("        This may be due to cut name generated");
      ERROR ("        by memogen not matching the cut name");
      ERROR ("        supplied by <cut>.json");
      LOGDIE ("        Please fix the problem and rerun.");
    }
    my $runDir = $orderPath."/run_sample/testbench/".$cutName."/beh_mem";
    vchdir($runDir, $opt->{'just-print'});

    my $result_logs = "result_logs";
    if (!-d $result_logs) {
      vmkpath($result_logs, $opt->{'just-print'});
    }

    foreach my $tool (@tools) {
      $script = "./sim.$tool.sh +define+BEH_ERR_TEST 2>&1 > /dev/null";
      $simECnt += $self->runCmd($script,$simLogFile,$simPassString, $runDir, "runSims");
      $cmd = "\\cp $simLogFile $result_logs/${tool}_errinj_$simLogFile";
      vsystem($cmd, $opt->{'just-print'});
    }
  }
  ERROR "Some Error Injection Simulation runs failed ($simECnt)" if ($simECnt > 0);
}

sub dumpFailedCmds {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  WARN ("dumpFailedCmds  method is not implemented yet.");
  $wcnt++;
  push (@$wrn_log, "dumpFailedCmds ");
}

sub dumpCfgJson {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  WARN ("dumpCfgJson  method is not implemented yet.");
  $wcnt++;
  push (@$wrn_log, "dumpCfgJson ");
}

sub checkLock {
  my $self = shift;
  confess "Not enough arguments" if !defined $self;
  confess "Too many arguments" if defined shift;

  my $opt    = $self->{'opt'};
  my $cfg    = $self->{'cfg'};

  WARN ("checkLock  method is not implemented yet.");
  $wcnt++;
  push (@$wrn_log, "dumpCfgJson ");
}

sub encryptVerilog {
  my $self = shift;
  my $order = shift;
  my $ext   = shift;
  confess "Not enough arguments" if !defined $ext;
  confess "Too many arguments" if defined shift;

  my $opt = $self->{'opt'};
  my $cfg = $self->{'cfg'};

  my $ord_d   = $self->getOrderPath($order);
  my $rtl_d   = "$ord_d/rtl_unrolled";
  my $cuts    = $self->getCutInfo();
  my $cutName = $self->getCutName($cuts,$order);
  my $rtl_f   = "$rtl_d/${cutName}_${ext}.v";

  my $enc_d   = "$ord_d/rtl_enc";

  if (-d $enc_d) {
    vrm ($enc_d, $opt->{'just-print'});
  }
  vmkpath ($enc_d, $opt->{'just-print'});

  my $cmd;
  foreach my $tool (@encTools) {
    my $enc_f = "${cutName}_${ext}_${tool}.v";
    $cmd = "cp $rtl_f $enc_d/${cutName}_${ext}_${tool}.v";
    my $rv = vsystem($cmd, $opt->{'just-print'});
    if ($rv != TRUE) {
      ERROR "$cmd <<- FAILED";
      $ecnt++;
    }
  }
}

sub finish {
  my $self = shift;
  my $gmsg = shift;

  my $opt  = $self->{'opt'};
  my $cfg  = $self->{'cfg'};

  my $cutPkgLog = "cutpkg.log";

  my $projDir = "$cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}";
  vchdir($projDir, $opt->{'just-print'});

  ALWAYS "$gmsg";

  my $fh = FileHandle->new($cutPkgLog, "w");

  if ($wcnt) {
    WARN "The following methods haven't been implemented \($wcnt\):";
    print $fh "The following methods haven't been implemented \($wcnt\):\n";
    foreach my $wrn (@$wrn_log) {
      WARN "    $wrn";
      print $fh "    $wrn\n";
    }
  }
  if ($ecnt) {
    print $fh "The following runs failed:\n";

    foreach my $err_msg (@$err_log) {
      print $fh "$err_msg\n";
    }
    print $fh "Please rerun these commands for further debug.";
    ERROR "Some cut validation steps failed ($ecnt) -- Review the logs at $cfg->{'packageDir'}/$cfg->{'groupName'}/$cfg->{'packageName'}/cutpkg.log";
  } elsif ($opt->{'skip'} ne "" || $opt->{'only'} ne "") {
    ERROR "*************************DO NOT SHIP THIS CUT*************************";
    ERROR "**Some cut validation steps were skipped. Please rerun all the steps**";
    ERROR "*************************DO NOT SHIP THIS CUT*************************";
  } else {
    print $fh "all good\n";
  }
  $fh->close();

  exit ($ecnt);
}

sub removeErrInjCode {
  my $self = shift;
  my $inFile = shift;
  my $outFile = shift;
  confess "Not enough arguments" if !defined $outFile;
  confess "Too many arguments" if defined shift;

  my $opt = $self->{'opt'};
  my $cfg = $self->{'cfg'};

  vrm ($outFile, $opt->{'just-print'});

  open my $in,  '<', $inFile or die "Can't read input file: $!";
  open my $out, '>', $outFile or die "Can't write new file: $!";

  my $offCnt  = 0;
  my $onCnt   = 0;
  my $offFlag = 0;
  while( <$in> ) {
    if ($_ =~ /MEMOIR_SHIP_OFF/) {
      if ($offFlag == 1) {
        close $out;
        LOGDIE ("Encounted back to back MEMOIR_SHIP_OFF pragmas in $inFile.");
      }
      $offCnt++;
      $offFlag = 1;
    } elsif ($_ =~ /MEMOIR_SHIP_ON/) {
      if ($offFlag == 0) {
        close $out;
        LOGDIE ("Encounted back to back MEMOIR_SHIP_ON pragmas in $inFile.");
      }
      $onCnt++;
      $offFlag = 0;
    } else {
      if ($offFlag == 0) {
        print $out $_;
      }
    }
  }
  close $out;

  LOGDIE ("Number of MEMOIR_SHIP_OFF's don't match MEMOIR_SHIP_ON's.") if ($offCnt != $onCnt);
}

sub removeCmdLine {
  my $self = shift;
  my $inFile = shift;
  my $outFile = shift;
  confess "Not enough arguments" if !defined $outFile;
  confess "Too many arguments" if defined shift;

  my $opt = $self->{'opt'};
  my $cfg = $self->{'cfg'};

  if ( -e $outFile) {
    vrm ($outFile, $opt->{'just-print'});
  }

  open my $in,  '<', $inFile or die "Can't read input file: $inFile";
  open my $out, '>', $outFile or die "Can't write new file: $outFile";

  while( <$in> ) {
    if ($_ !~ /Command Line/ && $_ !~ / -name /) {
      print $out $_;
    }
  }
  close $out;
}

sub checkIFVLog{
  my $self    = shift;
  my $logFile = shift;
  confess "Not enough arguments" if !defined $logFile;
  confess "Too many arguments" if defined shift;

  my $opt   = $self->{'opt'};
  my $cfg   = $self->{'cfg'};

  my $flag  = 0;
  my $total = 0;
  my $pass  = 0;

  open my $in,  '<', $logFile or die "Can't read IFV log file: $!";

  while( <$in> ) {
    if ($_ =~ /^Assertion Summary:/) {
      $flag = 1;
    }
    if ($flag == 1) {
      if ($_ =~ /^\s*Total\s*:\s*(\d+)/) {
        $total = $1;
      } elsif ($_ =~ /^\s*Pass\s*:\s*(\d+)/) {
        $pass = $1;
      }
    }
  }

  if ($pass != $total) {
    return 1;
  } else {
    return 0;
  }
}

sub copyFromCut2Ppc{
  my $self  = shift;
  my $order = shift;
  my $srcF  = shift;
  my $dstF  = shift;
  my $ext   = shift;
  confess "Not enough arguments" if !defined $ext;
  confess "Too many arguments" if defined shift;

  my $opt   = $self->{'opt'};
  my $cfg   = $self->{'cfg'};

  my $orderPath = $self->getOrderPath($order);
  if (-e $dstF) {
    vrm($dstF, $opt->{'just-print'});
  }
  open my $in,  '<', $srcF or die "Can't read old file: $!";
  open my $out, '+>', $dstF or die "Can't write new file: $!";
  while( <$in> ) {
    $_ =~ s/core_$cfg->{'version'}\.v.*$/core_$cfg->{'version'}_$ext\.v"/;
    print $out $_;
  }
  close $out;
  vchmod (0755, $dstF, $opt->{'just-print'});
}

1
