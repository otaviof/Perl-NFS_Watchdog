#
#  Author: Otavio Fernandes <otaviof@gmail.com>
# Created: 04/05/2010 13:20:05
#

use strict;
use warnings;

use Test::More tests => 2;

use File::Copy;
use File::Slurp;
use NFS::Watchdog::Umount;

my $path_mock = 't/mock/mtab';
my $path_new  = 't/mock/mtab.' . int( rand( 10**10 ) );

copy( $path_mock, $path_new )
    or die "Cannot copy mtab mock file.";

my $umount = new NFS::Watchdog::Umount( { mtab => $path_new } );

my $remove = '/mnt/bsd';

ok( $umount->remove_from_mtab($remove),
    "Should Pass, method must return true on a normal environment." );

my @mock_lines = read_file($path_new);

ok( !grep( /$remove/, @mock_lines ),
    "Should Pass, removed line must be away from this file." );

unlink($path_new);

__END__
