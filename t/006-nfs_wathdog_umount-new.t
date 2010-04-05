#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 04/05/2010 12:55:23
#

use strict;
use warnings;

use Test::More tests => 6;

BEGIN {
    use_ok('NFS::Watchdog::Umount');
    use NFS::Watchdog::Umount;
}

my $umount;

$umount = new_ok( 'NFS::Watchdog::Umount', [] );

ok( $umount->mtab eq '/etc/mtab',
    "Should Pass, without parameters we must use default mtab location (/étc)."
);

undef $umount;

eval {
    $umount
        = new NFS::Watchdog::Umount(
        { mtab => '/tmp/' . int( rand( 10**10 ) ) } );
};

ok( !$umount, "Should Fail, with an wrong mtab path." );

undef $umount;

$umount = new_ok( 'NFS::Watchdog::Umount', [ { mtab => 't/mock/mtab' } ] );

ok( $umount->mtab eq 't/mock/mtab',
    "Shuold Pass, with an mock mtab location." );

__END__
