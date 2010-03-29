use strict;
use warnings;

use ExtUtils::MakeMaker;
use Git::Wrapper;

WriteMakefile(
    NAME          => 'NFS::Watchdog',
    AUTHOR        => 'Otavio Fernandes <otaviof@gmail.com>',
    VERSION_FROM  => 'lib/NFS/Watchdog.pm',
    ABSTRACT_FROM => 'lib/NFS/Watchdog.pm',
    EXE_FILES     => [ 'bin/nfs_watchdog.pl', ],
    PREREQ_PM     => {
        'Test::More'   => 0,
        'Git::Wrapper' => 0.006,
    },

    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'NFS-Watchdog-*' },

    ( $ExtUtils::MakeMaker::VERSION >= 6.3002
        ? ( 'LICENSE' => 'perl' )
        : () ),
);

my $git = new Git::Wrapper( $ENV{PWD} );

open( my $CHG, '<', 'Changes' ) or die $!;
print $CHG for $git->log;
close($CHG);

__END__
