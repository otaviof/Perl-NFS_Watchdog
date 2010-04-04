#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 04/03/2010 09:34:03
#

use strict;
use warnings;

use Test::More tests => 4;

BEGIN {
    use_ok('NFS::Watchdog::Utils');
    use NFS::Watchdog::Utils;
}

my $utils;
eval {
    $utils
        = new NFS::Watchdog::Utils(
        { mounts => '/tmp/' . int( rand( 10**10 ) ) } );
};

ok( !$utils, "Should Fail, if mounts file doesn't exists." );

undef $utils;

$utils = new_ok( 'NFS::Watchdog::Utils', [] );

ok( $utils->mounts eq "/proc/mounts",
    "Should Pass, no arguments to constructor means default location." );

__END__
