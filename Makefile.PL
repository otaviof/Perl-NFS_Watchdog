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

# --
# Writing 'Changes' file from Git
# --

my $git = new Git::Wrapper( $ENV{PWD} );

unlink 'Changes' if ( -f 'Changes' );

open( my $CHG, '>', 'Changes' ) or die $!;
foreach my $log ( $git->log ) {
    print $CHG "commit: ", $log->id, "\n";
    print $CHG "Author: ", $log->attr->{date},   "\n";
    print $CHG "  Date: ", $log->attr->{author}, "\n\n";
    print $CHG "\t", $log->message, "\n\n";

}
close($CHG);

__END__
