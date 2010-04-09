#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 03/29/2010 15:45:08
#

use strict;
use warnings;

use Test::More tests => 4;

BEGIN {
    use_ok('NFS::Watchdog');
    use NFS::Watchdog;
}

my $w1;
eval { $w1 = new NFS::Watchdog(); };

ok( !$w1, "Should Fail, there isn't no directory to start." );

my $w2;
eval {
    $w2
        = new NFS::Watchdog(
        '/tmp/' . int( rand(100) ) . '/' . int( rand(100) ) );
};

ok( !$w2, "Should Fail, directory doesn't exists." );

new_ok( 'NFS::Watchdog',
    [ { nfs_dir => ( ( $ENV{NFS_DIR} ) ? $ENV{NFS_DIR} : '/tmp' ) } ] );

__END__
