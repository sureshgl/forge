package InfraUtils;
use Exporter;
@ISA = qw (Exporter);
@EXPORT = qw (
               TRUE FALSE
               findFile findFileWithExtension findDir findDirWithFile findFileWithPattern
               getTot
               isPacificTime isIndiaTime getDateTime getLocalGridQueue
               vsystem vchdir vrm vcp vmkpath vchmod avsystem
               acquire_lock release_lock
               initializeRandGen
               walk flatten contains pr_key purge_keys stk_diff_nested_key
               stringify eq_float display_side_by_side
               random_boolean random_element random_permuted_sublist is_subset purge_comment_keys
               svn_purge
               lg is_pot is_npot
               initDoubleLoggerA initDoubleLoggerB
               getVersionStringA getVersionStringB
               getMajorVerion getMinorVersion getBuildVersion getVersionStringA getVersionStringB
               readJson writeJson decodeJson encodeJson
               excel_compare
               matchCountInFile
            );
use strict;
use warnings "all";
use Carp;
use File::Remove 'remove';
use File::Copy;
use File::Path qw(make_path);
use Fcntl qw(:DEFAULT :flock :seek :Fcompat);
use File::FcntlLock;
use Math::Random;
use IPC::Run3;
use Compress::Zlib;
use Cwd;
use Cwd 'realpath';
use Data::Dumper;
use FileHandle;
use File::Basename;
use File::Find;
use Digest::SHA1;
use Sys::Hostname;
use POSIX qw (ceil);
use JSON;
use Scalar::Util qw(looks_like_number);
use List::Util qw(max reduce);
use Log::Log4perl qw(:easy);
use DateTime;

use constant FALSE         =>  0;
use constant TRUE          =>  1;

my $tot = realpath(dirname(__FILE__) . "/../../../");
my $buildversion  = "";
my $date_zone = `date +%Z`;
chomp($date_zone);

# Return is 0 first value if pass !
# And Some diagnostics as second value
sub excel_compare{
    my ($file1, $file2, $ignore_spec) = @_;
    $ignore_spec = (defined $ignore_spec) ? $ignore_spec : "";
    my $output = qx(excel_cmp $file1 $file2 $ignore_spec 2>&1);
    my $fail = $? >> 8;
    return ($fail, $output);
}

sub is_subset($$){
    my ($big, $small) = @_;
    my %big = map {$_ => 1} @$big;
    for my $s (@$small){
        return 0 if (not $big{$s});
    }
    return 1;
}

# returns a random subset of an array
# second arg is optional
sub random_permuted_sublist($$){
    my ($a, $n) = @_;
    my @b = random_permutation(@$a);
    $n = random_uniform_integer(1,0,scalar @b)
        if (not defined $n);
    my @c = ($n == 0) ? () : @b[0 .. $n-1];
    return wantarray ? @c : \@c;
}

# returns a random element from the array
sub random_element($){
    my $a = shift;
    return $a->[random_uniform_integer(1,0,$#$a)];
}

sub random_boolean(){
    return random_uniform_integer(1,0,1);
}

sub stk_diff_nested_key($){
	my $stack = shift;
	$Test::Deep::Stack = $stack; # Super hack

	my $where = $stack->render('$data');

	my $last = $stack->getLast;
    my $exp  = $last->{'exp'};

    # diff is done as cmp_deeply($got,$exp)
    my ($whrac, $whrexp) = (undef, undef);

	if (ref $exp){
		my $diag = $last->{'diag'};
        if (defined $diag){
            my @diag = split("\n",$diag);
            if (scalar @diag <= 2){
                for my $d (@diag){
                    if ($d =~ /^Missing: (.+)$/){
                        my @missings = split("\\s*,\\s*",$1);
                        $whrexp = $where."{".$missings[0]."}";
                    } elsif ($d =~ /^Extra: (.+)$/){
                        my @extras = split("\\s*,\\s*",$1);
                        $whrac = $where."{".$extras[0]."}";
                    }
                    else {
                        confess "Could not understand diag line: $d";
                    }
                }
            } else {
                confess "More lines than expected for diag: $diag";
            }
        }
	}

    if ((not defined $whrac) && (not defined $whrexp)){
        ($whrac, $whrexp) = ($where, $where);
    }

	return ($whrac, $whrexp);
}

sub display_side_by_side($$){
    my ($s1, $s2) = @_;
    my @s1 = split(/\n/,$s1);
    my @s2 = split(/\n/,$s2);
    my $max1 = reduce {max($a,$b)} 0, map {length} @s1;
    my $s="";
    my $i=0;
    for ($i=0; $i<=max($#s1,$#s2); $i++){
        my ($s1, $s2) = ($s1[$i], $s2[$i]);
        $s1 = "" unless defined $s1;
        $s2 = "" unless defined $s2;
        my $sp = " " x ($max1 - length($s1));
        $s .= $s1.$sp." | ".$s2."\n";
    }
    return $s;
}

sub pr_key($$){
    my $data = shift;
    my $key = shift;
    my $ret = eval $key;
    local $Data::Dumper::Indent=1;
    local $Data::Dumper::Sortkeys=1;  
    return Dumper($ret);
}

sub purge_keys($$){
  my $data = shift;
  my $pk = shift;
  foreach my $key (@{$pk}) {
    if ($key =~ /^\w+$/){
     my $cls = ref $data;
     if (ref $data eq 'HASH'){
       $data = walk($data,sub($){my $k=shift; delete $k->{$key}});
     } else {
       bless($data,'HASH');
       my $data2 = walk($data,sub($){my $k=shift; delete $k->{$key}});
       bless $data, $cls;
       bless $data2, $cls;
       $data = $data2;
     }
    } else {
      my @k = split(" ",$key);
      if ($k[0] eq 'delete'){
        my $ret = eval $key."; \$data";
        if ($@){
            DEBUG $@;
        } else {
            $data = $ret;
        }
      }
    }
  }
  return $data;
}

# checks if second arg is 'contained' in first arg
# note: this uses 'eq' for comparison
# in scalar context returns true/false
# in array context: for arrays returns (idx,true) or (undef,false)
#                   for hash returns (val,true) or (undef,false)
sub contains($$){
    my ($d, $k) = @_;
    my ($ret, $contains) = (undef, FALSE);
    if (ref $d eq 'ARRAY'){
        for (my $i=0; $i<=$#$d; $i++){
            if ($d->[$i] eq $k){
                $ret = $i;
                $contains = TRUE;
                last;
            }
        }
    } elsif (ref $d eq 'HASH'){
        $contains = exists $d->{$k};
        if ($contains){
            $ret = $d->{$k};   
        }
    }
    return ($ret, $contains);
}

sub stringify($){
    my ($d) = @_;
    if (ref $d eq 'ARRAY'){
        return '['.join(",",map {stringify($_)} @$d).']';
    } elsif (ref $d eq 'HASH'){
        return '{'.join(", ",map {"$_=>".stringify($d->{$_})}
                             keys %$d).'}';
    } else{
        return defined $d ? looks_like_number($d) ? $d : "'$d'" : 'undef';
    }
}

sub walk($$){
    my ($d,$f) = @_;
    if (ref $d eq 'ARRAY'){
        my @cd = map {walk($_,$f)} @$d;
        return \@cd;
    } elsif (ref $d eq 'HASH'){
      &$f($d);
      my %cd = map {$_ => walk($d->{$_},$f)} keys %$d;
      return \%cd;
    } else{
        return $d;
    }
}

# $h is any data structure
# $f is a function which takes two args: key, val
# ex1: perl -I framework -we 'use InfraUtils; flatten({a=>1,b=>[10,20,30],c=>{d=>4,f=>{g=>6,h=>7}}})'
# ex2: perl -I framework -we 'use InfraUtils; my %a=(); my $f=sub{my ($k,$v)=@_; $a{$k}=$v}; flatten({a=>1,b=>[10,20,30],c=>{d=>4,f=>{g=>6,h=>7}}}, $f); for my $k(sort keys %a){ print "$k => $a{$k}\n" }'
sub flatten{
    my $h = shift;
    my $f = shift || sub {my ($k,$v)=@_; print "$k => $v\n"};
    _flatten($h, "", $f);
}

sub _flatten{
    my $h = shift;
    my $ctx = shift;
    my $f = shift;
    if (ref $h eq 'HASH'){
        foreach my $k (keys %$h){
            _flatten($h->{$k}, $ctx.".".$k, $f);
        }
    } elsif (ref $h eq 'ARRAY'){
        for (my $i=0; $i<scalar @$h; $i++){
            _flatten($h->[$i], $ctx.".".$i, $f);
        }
    } else {
        &$f($ctx, $h);
    }
}

# looks for an exact (^blah$) regexp match in file name
sub findFile {
  my $dir = shift;
  my $fname = shift;
  confess "Too many args" if defined shift;
  confess "Not enough args" if !defined $fname;

  my @fl;
  finddepth(
            sub  {
              if (($_ =~ /^$fname$/) && -f) {
                push @fl, $File::Find::name;
              }
            },
            $dir);

  return @fl;
}

# finds /\.$ext^ i.e., $ext should not contain '.'
sub findFileWithExtension {
  my $dir = shift;
  my $ext = shift;
  confess "Too many args" if defined shift;
  confess "Not enough args" if !defined $ext;

  my @fl;
  finddepth(
            sub  {
              if (($_ =~ /\.$ext$/) && -f) {
                push @fl, $File::Find::name;
              }
            },
            $dir);

  return @fl;
}

# finds file that matches the pattern /$pattern/
sub findFileWithPattern {
  my $dir = shift;
  my $pat = shift;
  confess "Too many args" if defined shift;
  confess "Not enough args" if !defined $pat;

  my @fl;
  finddepth(
            sub  {
              if (($_ =~ /$pat/) && -f) {
                push @fl, $File::Find::name;
              }
            },
            $dir);

  return @fl;
}

sub findDirWithFile {
  my $dir = shift;
  my $fname = shift;
  confess "Too many args" if defined shift;
  confess "Not enough args" if !defined $fname;

  my @fl;
  finddepth(
            sub  {
              if (($_ eq $fname) && -f) {
                push @fl, $File::Find::dir;
              }
            },
            $dir);

  return @fl;
}

sub findDir {
  my $dir = shift;
  my $dname = shift;
  confess "Too many args" if defined shift;
  confess "Not enough args" if !defined $dname;

  my @fl;
  finddepth(
            sub  {
              if (($_ eq $dname) && -d) {
                push @fl, $File::Find::name;
              }
            },
            $dir);

  return @fl;
}

sub getTot {
  confess "Too many args" if defined shift;

  return $tot;
}

sub vsystem {
  my $cmd = shift;
  my $justPrint = shift || 0;
  confess "Too many args" if defined shift;

  INFO "* $cmd";
  if ($justPrint) {
    return TRUE;
  }
  if (hostname eq "mach") {
    LOGCONFESS "*** DO NOT run on mach! *** \n";
  }

  my $rv = run3 ($cmd, undef, undef, undef, {'return_if_system_error' => 1});
  my $es = $?;
  my $en = $!;
  my $estr = $@;

  if ($rv != TRUE) {
    ERROR "$cmd failed\n";
    return FALSE;
  }
  if ($es) {
    ERROR "$cmd exited with non-zero status : $es : $en : $estr\n";
    return FALSE;
  }
  return TRUE;
}

sub vchdir {
    my $dir = shift;
    my $justPrint = shift || 0;
    confess "Too many args" if defined shift;

    INFO "* cd $dir";
    if ($justPrint) {
      return;
    }
    chdir ($dir) or LOGDIE "cd $dir failed\n";
}

sub vrm {
  my @fds = @_[0..$#_-1];
  my $justPrint = $_[-1];
  confess "Not enough args" if !defined $justPrint;

  INFO "* rm -fr @fds";
  if ($justPrint) {
    return;
  }
  remove (\1, @fds) or LOGDIE "ERROR: rm -fr @fds failed\n";
}

sub vchmod {
  my $mode = shift;
  my @fds = @_[0..$#_-1];
  my $justPrint = $_[-1];
  confess "Not enough args" if !defined $justPrint;

  DEBUG "* chmod $mode @fds\n";
  if ($justPrint) {
    return;
  }
  my $c = chmod($mode, @fds);
  LOGDIE "ERROR: chmod @fds failed\n" if ($c != scalar(@fds));
}


sub vcp {
  my $s = shift;
  my $d = shift;
  my $justPrint = shift || 0;
  confess "Too many args" if defined shift;

  INFO "* cp $s $d";
  if ($justPrint) {
    return;
  }
  copy($s, $d) or LOGDIE "ERROR: cp $s $d failed\n";
}

sub vmkpath {
  my $d = shift;
  my $justPrint = shift || 0;
  confess "Not enough args" if !defined $justPrint;

  INFO "* mkdir $d";
  if ($justPrint) {
    return;
  }
  my $e = [];
  make_path($d, {verbose => 0, error => \$e});
  if ($#{$e} > -1) {
    LOGDIE "make_path $d failed\n";
  }
}

# generates phrase or reads phrase from file for seeding Math::Random rand functions
# file in which phrase is saved/retrieved: random_phrase in the run directory
# this needs to be called in BEGIN block. see EstimatorRun.pm for an example.
sub initializeRandGen {

  my $rpf  = dirname($0) . '/random_phrase';
  my $rpf1 = dirname($0) . '/checked_in_random_phrase';
  my $phrase;
  my @seeds;
  if (-e $rpf && -f $rpf) {
    my $fh = FileHandle->new($rpf, "r");
    LOGDIE "failed to open $rpf for read\n" if (!defined $fh);
    $phrase = <$fh>;
    $fh->close();
  } elsif (-e $rpf1 && -f $rpf1) {
    my $fh = FileHandle->new($rpf1, "r");
    LOGDIE "failed to open $rpf1 for read\n" if (!defined $fh);
    $phrase = <$fh>;
    $fh->close();
  } else {
    $phrase =  time ^ ($$ + ($$ << 15));
    my $fh = FileHandle->new($rpf, "w");
    LOGDIE "failed to open $rpf for write\n" if (!defined $fh);
    print $fh $phrase;
    $fh->close();
  }
  random_set_seed_from_phrase($phrase);
  DEBUG "random_phrase=$phrase\n";
}

sub eq_float {
  my $a = shift;
  my $b = shift;
  my $p = shift;

  return (abs($a - $b) < $p);
}

sub purge_comment_keys {
  my $hash = shift;

  purge_keys($hash, ["__comment"]);
}

# ********** dangerous routine - removess all non-svn files **********
sub svn_purge {
  my $dir = shift;

  my $cmd = "svn status -v --xml --no-ignore $dir 2>&1";
  my $output = `$cmd`;
  if ($?) {
    LOGDIE "failed to get status - $cmd\n";
  }
  my $xml = new XML::Simple(ForceArray=> ['entry'], KeyAttr=>[]);
  my $cfg = $xml->XMLin($output);

  my $cnt = 0;
  foreach my $f (@{$cfg->{'target'}->{'entry'}}) {
    my $path = $f->{'path'};
    if (($f->{'wc-status'}->{'item'} =~ /^unversioned$/) ||
        ($f->{'wc-status'}->{'item'} =~ /^ignored$/)) {
      $cnt++;
      INFO "rm -fr $path\n";
      remove (\1, $path) or LOGDIE "rm -fr $path failed\n";
    }
  }

}

sub lg {
   my $num = shift;
   # log below is ln
   return ceil(log($num)/log(2));
}

sub is_pot { # is power-of-two
  my $num = shift;
  my $rv = ((1 << lg($num)) == $num) ? 1 : 0;
  return $rv;
}

sub is_npot { # is non-power-of-two
  my $num = shift;
  my $rv = ((1 << lg($num)) != $num) ? 1 : 0;
  return $rv;
}

sub initDoubleLoggerA {

  my $log = basename($0);
  if ($log =~ /\.pl$/) {
    $log =~ s/\.pl/\.log/;
  } else {
    $log .= ".log";
  }
  Log::Log4perl->easy_init( { level   => $DEBUG,
                              file    => ">$log",
                              layout   => '%d:%.1p:%F{1}-%L-%M: %m%n'},
                            { level   => $INFO,
                              file    => "STDOUT",
                              layout   => '%d:[%.1p]: %m%n'} );
}

sub initDoubleLoggerB {

  my $log = basename($0);
  if ($log =~ /\.pl$/) {
    $log =~ s/\.pl/\.log/;
  } else {
    $log .= ".log";
  }
  Log::Log4perl->easy_init( { level   => $INFO,
                              file    => ">$log",
                              layout   => '%d:%.1p:%F{1}-%L-%M: %m%n'},
                            { level   => $WARN,
                              file    => "STDOUT",
                              layout   => '%d:[%.1p]: %m%n'} );
}

sub getMajorVerion {

  my $fn = getTot() . "/memoverse/common/resources/version/majorversion";
  my $fh = FileHandle->new($fn, "r");
  LOGDIE "failed to open $fn for read\n" if (!defined $fh);
  my $v = <$fh>;
  chomp ($v);
  $fh->close();

  return $v;
}

sub getMinorVersion {

  my $fn = getTot() . "/memoverse/common/resources/version/minorversion";
  my $fh = FileHandle->new($fn, "r");
  LOGDIE "failed to open $fn for read\n" if (!defined $fh);
  my $v = <$fh>;
  chomp ($v);
  $fh->close();

  return $v;
}

sub getBuildVersion {
    if ($buildversion eq '') {
        my $bcmd = getTot() . "/memoverse/infra/bin/p4version.csh";
        $buildversion = `$bcmd`;
        if ($?) {
          LOGDIE "failed to get build version";
        }
        chomp($buildversion);
    }
    return $buildversion;
}

sub getVersionStringA {
  return getMajorVerion() . "." . getMinorVersion() . "." . getBuildVersion();
}

sub getVersionStringB {
  return getMajorVerion() . "_" . getMinorVersion() . "_" . getBuildVersion();
}

sub readJson {
   my $fi = shift;

   INFO "reading json $fi";
   my $jh = {};
   if ( $fi =~ /\.gz$/ ) {
     my $gz = gzopen( $fi, "rb" );
     if ( !defined $gz ) {
       LOGDIE "Cannot open $fi: $gzerrno\n";
     }
     my $s    = "";
     my $line = "";
     while ( $gz->gzreadline($line) > 0 ) {
       $s .= "$line\n";
     }
     $gz->gzclose();
     $jh = decodeJsonString($s);
   } else {
     my $fh = FileHandle->new( $fi, "r" );
     if ( !defined $fh ) {
       LOGDIE "failed to open $fi for read\n";
     }
     my @js = <$fh>;
     my $s = join( "\n", @js );
     $fh->close();
     $jh = decodeJsonString($s);
   }
   return $jh;
}

sub decodeJsonString {
   my $s = shift;

   my $jh = {};
   eval {
     $jh = decode_json($s);
   };
   if ($@){
     WARN "malformed json - returning empty hash";
     $jh = {};
   }
   return $jh;
}

sub decodeJson {
   my $fh = shift; ### file handle

   my $jh = {};
   my @js = <$fh>;
   my $s = join( "\n", @js );
   eval {
     $jh = decode_json($s);
   };
   if ($@){
     WARN "malformed json - returning empty hash";
     $jh = {};
   }
   return $jh;
}

sub writeJson {
   my $fo = shift;
   my $jh = shift;

   INFO "writing json $fo";
   if ( $fo =~ /\.gz$/ ) {
     my $gz = gzopen( $fo, "wb" );
     if ( !defined $gz ) {
       LOGDIE "Cannot open $fo: $gzerrno\n";
     }
     $gz->gzwrite(encodeJson($jh));
     $gz->gzclose();
   } else {
     my $fh = FileHandle->new( $fo, "w" );
     if ( !defined $fh ) {
       LOGDIE "failed to open $fo for write";
     }
     print $fh encodeJson($jh);
     $fh->close();
   }
}

sub encodeJson {
   my $jh = shift;
   my $json = new JSON;
   my $jstr = $json->pretty->encode($jh) . "\n";
   return $jstr;
}

# execute system commands under a mutex lock mechanism
sub avsystem {
  my $fn = shift;
  my $cmds = shift; # ref to array
  my $justPrint = shift || 0;
  confess "Too many args" if defined shift;
  confess "Not enough args" if !defined $justPrint;

  my $rv = TRUE;

  my ($lock_fh, $h) = acquire_lock($fn);

  if (defined $h->{'status'} && $h->{'status'}) {
    # already done
  } else {
    foreach my $cmd (@{$cmds}) {
      my $v = vsystem($cmd, $justPrint);
      $rv = ($rv == FALSE) ? FALSE : $v;
    }
  }

  release_lock($fn, $lock_fh, {'status' => 1});

  return $rv;
}

# acquire lock and return the file handle
# also read file and return the value in the file.
# handle to a hash is returned - contents of the hash is up to the cooperating processes
sub acquire_lock {
  my $fn = shift;
  confess "Too many args" if defined shift;
  confess "Not enough args" if !defined $fn;

  my $fh;
  sysopen($fh, $fn, O_RDWR | O_CREAT) or LOGDIE "failed to open: $fn: $!";
  $fh->autoflush(1);
  ALWAYS "acquiring lock: $fn";
  my $fs = new File::FcntlLock;
  $fs->l_type(F_WRLCK);
  $fs->l_whence(SEEK_SET);
  $fs->l_start(0);
  $fs->lock( $fh, F_SETLKW ) or LOGDIE  "failed to get write lock: $fn:" . $fs->error;
  my $lh = decodeJson($fh);
  return ($fh, $lh);
}

# write hash as determined by the cooperating processes
# and release the lock.
sub release_lock {
  my $fn = shift;
  my $fh = shift;
  my $lh = shift;
  confess "Too many args" if defined shift;
  confess "Not enough args" if !defined $lh;

  seek($fh, 0, SEEK_SET) or LOGDIE "seek failed: $fn: $!";
  print $fh encodeJson($lh) or LOGDIE "write failed: $fn: $!";
  truncate($fh, tell($fh)) or LOGDIE "truncate failed: $fn: $!";
  my $fs = new File::FcntlLock;
  $fs->l_type(F_UNLCK);
  ALWAYS "releasing lock: $fn";
  $fs->lock( $fh, F_SETLK ) or LOGDIE "unlock failed: $fn: " . $fs->error;
  close($fh) or LOGDIE "close failed: $fn: $!";
}

sub matchCountInFile {
  my $fn = shift;
  my $str = shift;

  open(F, $fn);
  my @lines = <F>;
  my @matches = grep /$str/, @lines;
  close F;
  return scalar @matches;
}


sub sha1_hash {
    ## Computes SHA1 hash of file or directory.
    my $fname= shift;
    my $extension = shift; $extension = '' unless defined $extension;

    my @file_list;

    find(sub { if(-f $_) { 
            my ($ext) = $File::Find::name =~ /(\.[^.]+)$/;
            if($extension eq "" || $ext eq $extension) {
            push @file_list, $File::Find::name; 
            };
            } }, $fname);

    my $sha1 = Digest::SHA1->new;
    foreach my $the_file (@file_list) {
        my $fh;
        open $fh, $the_file;
        $sha1->addfile($fh);
    };
    return $sha1->hexdigest;
};

sub isPacificTime {
  return ($date_zone eq "PST" || $date_zone eq "PDT");
}

sub isIndiaTime {
  return ($date_zone eq "IST");
}

sub getLocalGridQueue {
  return (isPacificTime() ? "rhel5.q" :
          (isIndiaTime() ? "india.q" :
           "garbage.q"));
}

sub getDateTime {
  confess "Too many arguments" if defined shift;
  my $dt = DateTime->now;
  my $ymd    = $dt->ymd('');
  my $hms    = $dt->hms('');
  return "${ymd}_${hms}";
}

1;
