#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 04/01/2010 00:12:22
#

use strict;
use warnings;

use Test::More tests => 2;

use NFS::Watchdog;

my $watchdog
    = new NFS::Watchdog(
    { nfs_dir => ( ( $ENV{NFS_DIR} ) ? $ENV{NFS_DIR} : '/tmp' ) } )
    or die $!;

my $file = $watchdog->write();

ok( -f $file, "Should Pass, written file must exist." );

ok( $watchdog->read($file),
    "Should Pass, we must read an existent file from FS." );

unlink($file);

__END__
