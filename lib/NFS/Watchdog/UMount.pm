package NFS::Watchdog::Umount;

#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 04/05/2010 12:54:32
#

use strict;
use warnings;

use AnyEvent::Util;
use File::Copy;
use Moose;

has 'mtab' => (
    is      => 'rw',
    isa     => 'Str',
    default => '/etc/mtab',
    trigger => sub {
        my ( $self, $path ) = @_;
        die "File does not exists: $path"
            if ( $path and !-f $path );
    },
);

sub exec_umount {
    my ( $self, $point ) = @_;
    return if ( !$point );
    my $r;
    fork_call {
        system( 'umount -l -f ' . $point . ' > /dev/null 2>&1' );
    }
    sub { $r = @_; };
    return ( $r == 0 ) ? 1 : 0;
}

sub remove_from_mtab {
    my ( $self, $remove ) = @_;
    return if ( !$remove );
    my $mtab_new = $self->mtab . "." . int( rand( 10**10 ) ) . '.tmp';
    open( my $fh1, '<', $self->mtab ) or return;
    open( my $fh2, '>', $mtab_new )   or return;
    while (<$fh1>) { print $fh2 $_ if ( !/$remove\s+nfs/ ); }
    close($fh1);
    close($fh2);
    return move( $mtab_new, $self->mtab );
}

1;

__END__
