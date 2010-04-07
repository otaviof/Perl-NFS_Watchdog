#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 04/07/2010 17:37:41
#

use strict;
use warnings;

use Test::More tests => 3;

use NFS::Watchdog;

my $watchdog = new NFS::Watchdog( { nfs_dir => '/tmp' } )
    or die $!;

my $file = $watchdog->write();

ok( -f $file, "Should Pass, before write file must exists." );

ok( $watchdog->unlink($file),
    "Should Pass, unlink method must return true." );

ok( !-f $file, "Should Fail, file must not exists anymore." );

__END__
