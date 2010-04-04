#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 04/03/2010 09:34:03
#

use strict;
use warnings;

use Test::More tests => 4;

use NFS::Watchdog::Utils;

my $mock = 't/mock/mounts';

new_ok( 'NFS::Watchdog::Utils', [ { mounts => $mock } ] );

my $utils = new NFS::Watchdog::Utils( { mounts => $mock } );

ok( $utils->mounts eq $mock,
    "Should Fail, mounts path must remain the same." );

ok( $utils->parse_nfs_from_mounts(),
    "Should Pass, this method should return true." );

ok( eq_array(
        [   {   origin      => 'bsd:/home/nfs',
                destination => '/mnt/bsd',
                type        => 'rw',
                server      => '172.16.34.128',
                options =>
                    'rw,relatime,vers=3,rsize=32768,wsize=32768,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=172.16.34.128,mountvers=3,mountproto=tcp,addr=172.16.34.128',
            }
        ],
        ( $utils->parse_nfs_from_mounts() )[0]
    ),
    "Should Pass, method should return an hash like this."
);

__END__
