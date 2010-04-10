#!/usr/bin/env perl

#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 03/29/2010 15:25:49
#

use strict;
use warnings;

use English;

use Getopt::Long;
use NFS::Watchdog::Utils;
use NFS::Watchdog;
use Net::Ping::External qw(ping);
use Sys::Syslog;
use Try::Tiny;

use Data::Dumper;    # Debug

die "In this version, just is supported Linux. Sorry."
    if ( $OSNAME !~ /linux/i );

my ( $execute, $force, $ping, $syslog, $umount );

GetOptions(
    "execute=s" => \$execute,
    "force"     => \$force,
    "ping"      => \$ping,
    "syslog"    => \$syslog,
    "umount"    => \$umount,
) or die "Cannot parse command line arguments with Getopt::Long";

die "Your informed exec script does not exists or isnt executable."
    if ( $execute and !-x $execute );

$SIG{ALRM} = sub { print Dumper @_; };

# ---------------------------------------------------------------------------
#                              -- Subroutines --
# ---------------------------------------------------------------------------

sub final_action {
    my ($point) = @_;
    print "Debug ->>>> ping #", $ping,    "#\n";
    print "Debug ->>> force #", $force,   "#\n";
    print "Debug ->>> point #", $point,   "#\n";
    print "Debug ->> syslog #", $syslog,  "#\n";
    print "Debug ->> umount #", $umount,  "#\n";
    print "Debug -> execute #", $execute, "#\n";
}

# ---------------------------------------------------------------------------
#                                  -- Main --
# ---------------------------------------------------------------------------

my $utils = new NFS::Watchdog::Utils()
    or die "I can't get NFS mount points.";

my $nfs_mounts = $utils->parse_nfs_from_mounts()
    or die "Cannot parse NFS mount points.";

openlog( __FILE__, 'nowait,pid', 'LOG_USER' )
    if ($syslog);

foreach my $mount ( @{$nfs_mounts} ) {

    syslog( 'info', "NFS mount point '%s' to '%s' type: '%s'.",
        $mount->{origin}, $mount->{destination}, $mount->{type} )
        if ($syslog);

    #
    # Ping Test
    #

    if ($ping
        and !ping(
            hostname => $mount->{server},
            count    => 5,
            size     => 1024,
            timeout  => 3
        )
        )
    {
        syslog( 'info', "Ping error for server '%s'.", $mount->{server} )
            if ($syslog);
        final_action( $mount->{server} );
        next;
    }

    next if ( $mount->{type} ne 'rw' );

    #
    # Read/Write Tests
    #

    my $watchdog = try {
        new NFS::Watchdog( { nfs_dir => $mount->{destination} } );
    }
    catch {
        syslog( 'info', "new NFS::Watchdog: '%s'.", $_ )
            if ($syslog);
        use Data::Dumper;    # Debug
        print "Debug -> \$_ #", ( Dumper $_ ), "#\n";
        next;
    };

    my $file = $watchdog->write();

    syslog( 'info', "Test file path: '%s'.", $file )
        if ($syslog);

    next if ( $file
        and $watchdog->read($file)
        and $watchdog->unlink($file) );

    syslog( 'info', "Read/Write error for '%s'.", $mount->{destination} )
        if ($syslog);

    final_action( $mount->{server} );

}

closelog() if ($syslog);

__END__
