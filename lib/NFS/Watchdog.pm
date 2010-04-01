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

sub write {
    my ( $self, $size ) = @_;
    my $path = $self->nfs_dir . '/' . rand(10) . '.tmp';
    aio_open $path, O_RDWR | O_CREAT | O_EXCL, 0644, sub {
        my $fh = shift
            or die "Cannot open: $!";
        aio_write $fh, 0, 1, "1", 0, sub {
            $_[0] > 0 or die "Write Error: $!";
            aio_close $fh, sub {
                print "Debug -> aio_close #", ( Dumper $_), "#\n" if ($_);
            };
        };
    };

=cut
    use Data::Dumper;

    for ( 1 .. 5 ) {
        my $stat = 0;
        aio_lstat $path, sub {
            print "Debug -> aio_stat #", ( Dumper $_), "#\n";
        };
        sleep 1;
    }
=cut

    return $path;
}

1;

__END__
