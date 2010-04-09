package NFS::Watchdog;

#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 03/30/2010 16:06:14
#

use warnings;
use strict;

our $VERSION = '0.01';

use AnyEvent;
use Coro::AIO;
use Fcntl;
use Moose;

has 'nfs_dir' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
    trigger  => sub {
        my ( $self, $dir ) = @_;
        my $opendir_ready = AnyEvent->condvar;
        my $opendir       = AnyEvent->io(
            fh   => $dir,
            poll => "r",
            cb   => sub { $opendir_ready->send; }
        );
        sleep 2 and undef $opendir_ready;
        return if ( !$opendir );
        return 1;
    },
);

sub write {
    my ($self) = @_;
    my $path = $self->nfs_dir . '/' . rand(10) . '.tmp';

    eval {
        local $SIG{ALRM} = sub { die "Write Timeout\n" };
        alarm 3;

        aioreq_pri 4;

        my $fh = aio_open $path, O_RDWR | O_CREAT, 0644
            or die "Cannot open file ( $path ): $!";
        aio_write $fh, 0, length("1"), "1", 0
            or die "Cannot write file ( $path ): $!";
        aio_close $fh;

        alarm 0;
    };

    return if ($@);
    return $path;
}

sub read {
    my ( $self, $path ) = @_;
    return if ( !$path );

    eval {
        local $SIG{ALRM} = sub { die "Read Timeout\n" };
        alarm 3;

        aioreq_pri 4;

        my $fh = aio_open $path, O_RDONLY, 0
            or die "Cannot open file ( $path ): $!";
        aio_read $fh, 0, length("1"), 0, 0
            or die "Cannot read file ( $path ): $!";
        aio_close $fh;

        alarm 0;
    };

    return 0 if ($@);
    return 1;
}

sub unlink {
    my ( $self, $path ) = @_;
    return if ( !$path );
    return ( aio_unlink $path == 0 ) ? 1 : 0;
}

1;

__END__
