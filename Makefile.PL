use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(

    # ABSTRACT_FROM => 'lib/NFS/Watchdog.pm',

    NAME         => 'NFS::Watchdog',
    AUTHOR       => 'Otavio Fernandes <otaviof@gmail.com>',
    VERSION_FROM => 'lib/NFS/Watchdog.pm',
    EXE_FILES    => [ 'bin/nfs_watchdog.pl', ],
    PREREQ_PM    => {
        'AnyEvent'      => 5.251,
        'AnyEvent::AIO' => 1.1,
        'EV'            => 3.9,
        'Git::Wrapper'  => 0.006,
        'Moose'         => 1.01,
        'Test::More'    => 0,
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

use Git::Wrapper;

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
