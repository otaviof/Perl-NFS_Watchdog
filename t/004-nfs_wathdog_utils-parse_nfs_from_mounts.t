#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 04/03/2010 09:34:03
#

use strict;
use warnings;

use Test::More tests => 2;

BEGIN {
    use_ok('NFS::Watchdog::Utils');
    use NFS::Watchdog::Utils;
}

new_ok( 'NFS::Watchdog::Utils', [] );

__END__
