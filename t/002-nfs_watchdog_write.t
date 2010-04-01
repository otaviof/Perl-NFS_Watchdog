#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 03/30/2010 18:48:27
#

use strict;
use warnings;

use Test::More tests => 2;

use NFS::Watchdog;

my $watchdog = new NFS::Watchdog( { nfs_dir => '/tmp' } )
    or die $!;

ok( $watchdog->write(), "Should Pass, write method exists" );

my $file = $watchdog->write();

print "Debug -> path #", $file, "#\n";
print "Debug -> file #", $file, "#\n" if ( -f $file );

ok( ( -f $file ) ? 1 : 0, "Should Pass, writed file must exist" );

# unlink($file);

__END__
