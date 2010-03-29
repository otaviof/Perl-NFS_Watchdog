#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'NFS::Watchdog' );
}

diag( "Testing NFS::Watchdog $NFS::Watchdog::VERSION, Perl $], $^X" );
