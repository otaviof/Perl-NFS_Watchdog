#
#  Author: Otavio Fernandes <otavio.fernandes@locaweb.com.br>
# Created: 03/29/2010 15:45:08
#

use strict;
use warnings;

use Test::More tests => 1;

BEGIN {
    use_ok('NFS::Watchdog');
    use NFS::Watchdog;
}

my $watchdog = new_ok('NFS::Watchdog');

__END__
