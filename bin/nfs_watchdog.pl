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
use Sys::Syslog;

# die "In this version, just is supported Linux. Sorry."
#     if ( $OSNAME !~ /linux/i );

# ---------------------------------------------------------------------------
#
# -- TODO --
#
# * we must be shure that just only one process is running!
# * remember Try::Tiny!;
# * --help option;
# * logging actions and NFS feedbacks on syslog (if user inform this option
#   in command line);
# * option for execute umount;
# * option for execute umount in a very forced way;
# * perldoc!;
#
# Give an user option, just to return an error code, instead runing some
# fucking executable.
#
# ---------------------------------------------------------------------------

my ( $execute, $force, $ping, $syslog, $umount, $verbose, );

GetOptions(
    "execute=s" => \$execute,
    "force"     => \$force,
    "ping"      => \$ping,
    "syslog"    => \$syslog,
    "umount"    => \$umount,
    "verbose"   => \$verbose,
) or die "Cannot parse command line arguments with Getopt::Long";

die "Your informed exec script does not exists or isnt executable."
    if ( $execute and !-x $execute );

# ---------------------------------------------------------------------------
#
# Software Loop:
#
#   Test ping
#   Test Write
#   Test Read
#
#       If any of this tests fail, should umount volume (using an assync
#       method) and execute script
#
# ---------------------------------------------------------------------------

my $utils = new NFS::Watchdog::Utils()
    or die "I can't get NFS mount points.";

my $nfs_mounts = $utils->parse_nfs_from_mounts()
    or die "Cannot parse NFS mount points.";

openlog( __FILE__, 'nowait,pid', LOG_USER )
    if ($syslog);

foreach my $mount ( @{$nfs_mounts} ) {

    if ( $mount->{type} ne 'rw' ) {

    }
    syslog( 'info', "NFS mount point (%s) is just for reading.",
        $mount->{origin} );

    #
    # if nfs mount point is just for read, we must test only ping
    #

    use Data::Dumper;    # Debug
    print "Debug -> mount #", ( Dumper $mount ), "#\n";

    #
    # Umount must turn into a Module ( with Tests ofcourse )
    #

}

closelog() if ($syslog);

__END__
