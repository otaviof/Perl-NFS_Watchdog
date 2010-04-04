package NFS::Watchdog::Utils;

#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 04/03/2010 09:29:18
#

use strict;
use warnings;

use Moose;

has 'mounts' => (
    is      => 'rw',
    isa     => 'Str',
    default => '/proc/mounts',
    trigger => sub {
        my ( $self, $path ) = @_;
        die "File does not exists: $path"
            if ( $path and !-f $path );
    },
);

sub parse_nfs_from_mounts {
    my ($self) = @_;
    my $rtrn;
    open my $fh, '<', $self->mounts
        or return;
    while (<$fh>) {
        chomp;
        next
            if (
            !/^ (\S+:\S+)\s+
                (\/\S+)\s+nfs\s+
                ((rw|ro),.*?,addr=(\S+))\s+\d\s+\d$
                /xs
            );
        push @{$rtrn},
            {
            origin      => $1,
            destination => $2,
            type        => $4,
            server      => $5,
            options     => $3
            };
    }
    close($fh);
    return $rtrn;
}

1;

__END__
