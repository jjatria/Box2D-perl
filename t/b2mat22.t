use strict;
use warnings;
use Box2D;
use Test2::V0;

use lib 't/lib';
use MyTest::Helper qw( b2vec2_cmp );

my $exa = Box2D::b2Vec2->new( 1, 3 );
my $eya = Box2D::b2Vec2->new( 2, 4 );
my $exb = Box2D::b2Vec2->new( 5, 7 );
my $eyb = Box2D::b2Vec2->new( 6, 8 );

my $zero  = Box2D::b2Vec2->new( 0, 0 );

my $matrix = Box2D::b2Mat22->new( $exa->x, $eya->x, $exa->y, $eya->y );

isa_ok $matrix, 'Box2D::b2Mat22';
ok my_check( $matrix, $exa, $eya), 'Set';

$matrix->Set( $exb, $eyb );
ok my_check( $matrix, $exb, $eyb), 'Set';

$matrix->SetIdentity;

my $horiz = Box2D::b2Vec2->new( 1, 0 );
my $vert  = Box2D::b2Vec2->new( 0, 1 );
ok my_check( $matrix, $horiz, $vert), 'SetIdentity';

$matrix = Box2D::b2Mat22->new;
isa_ok $matrix, 'Box2D::b2Mat22';

$matrix->SetZero;
ok my_check( $matrix, $zero, $zero), 'SetZero';

$matrix->ex($exb);
$matrix->ey($eyb);

ok my_check( $matrix, $exb, $eyb), 'ey and ex as mutators';

$matrix = Box2D::b2Mat22->new( $eyb, $exa );
isa_ok( $matrix, 'Box2D::b2Mat22' );
ok my_check( $matrix, $eyb, $exa), 'Arguments to constructor';

ok my_check(
    Box2D::b2Mul($matrix, $matrix->GetInverse), $horiz, $vert
), 'GetInverse';

$matrix = Box2D::b2Mat22->new( $eyb, $exa );
{
    # Solve for x: A * x = b, where b is a column vector arg
    my $A = $matrix;
    my $x = $A->Solve( $exa );
    my $b = Box2D::b2Mul($A, $x );

    ok b2vec2_cmp( $b, $exa ), 'Solve';
}

sub my_check {
    my ($m, $a, $b, $msg) = @_;
    foreach ( [ $m->ex, $a ], [ $m->ey, $b ] ) {
      return 0 unless b2vec2_cmp( @{$_} );
    }
    return 1;
}

done_testing;
