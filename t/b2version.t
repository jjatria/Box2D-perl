use strict;
use warnings;
use Box2D;
use Test::More;

my $version = Box2D::b2Version->new();

isa_ok( $version, "Box2D::b2Version", "Box2D::b2Version->new()" );

$version->major(9);      pass("version->major set to 9");
$version->minor(88);     pass("version->minor set to 88");
$version->revision(777); pass("version->revision set to 777");

is( $version->major,      9, "version->major is 9");
is( $version->minor,     88, "version->major is 88");
is( $version->revision, 777, "version->major is 777");

# testing of b2_version will be moved to t/b2Settings.t

pass("cleanup");

done_testing;