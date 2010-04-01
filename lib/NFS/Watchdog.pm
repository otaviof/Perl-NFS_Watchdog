package NFS::Watchdog;

#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 03/30/2010 16:06:14
#

use warnings;
use strict;

our $VERSION = '0.01';

use Moose;
use AnyEvent;
use AnyEvent::AIO;
use IO::AIO;
use Fcntl;

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

$|++;

sub write {
    my ($self) = @_;
    my $path = $self->nfs_dir . '/' . rand(10) . '.tmp';

    my $req = aio_open $path, O_RDWR | O_CREAT, 0644, sub {
        my $fh = shift
            or die "Cannot open: $!";

        aio_write $fh, 0, 1, "1", 0, sub {
            die "Cannot write: $!"
                if ( !$_[0] );

            aio_close $fh, sub {
                die "Cannot close: $!"
                    if ( $_[0] );
            };
        };
    };

    sleep 2 and $req->cancel;
    return $path;
}

sub read {
    my ( $self, $path ) = @_;
    return if ( !$path );
    my $req = aio_open $path, O_RDONLY, 0, sub {
        my $fh = shift
            or die "Error while opening: $!";
        my $size = -s $fh;
        aio_read $fh, 0, $size, undef, 0, sub {
            $_[0] == $size
                or die "Short read: $!";
        };
        aio_close $fh, sub {
            die "Cannot close: $!"
                if ( $_[0] );
        };
    };
    sleep 2 and $req->cancel;
    return 1;
}

1;

__END__
