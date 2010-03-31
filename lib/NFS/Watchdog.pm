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
    use Data::Dumper;    # Debug
    my $path = $self->nfs_dir . '/' . rand(10) . '.tmp';

    print "Debug -> path #", $path, "#\n";
    # my $w_ready = AnyEvent->condvar;

    open( my $fh, '>', $path ) or die $!;

    return;

    my $w;
    $w = AnyEvent->io(
        fh   => $fh,
        poll => "w",
        cb   => sub {
            print $w "test\n";
            #     $w_ready->send;
        },
    );

    # print "Debug -> w #",       Dumper $w,       "#\n";
    # print "Debug -> w_ready #", Dumper $w_ready, "#\n";

    # sleep 2 and undef $w_ready;
    # return if ( !$w );
    return $path;
}

1;

__END__
