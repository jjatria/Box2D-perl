use strict;
use warnings;
use Box2D;
use Test::More;

use lib 't/lib';
use MyTest::Helper qw( is_nearly b2vec2_cmp );

my $sweep = Box2D::b2Sweep->new;

isa_ok $sweep, 'Box2D::b2Sweep';

my $a = Box2D::b2Vec2->new( 1, 2 );
my $b = Box2D::b2Vec2->new( 3, 4 );
my $c = Box2D::b2Vec2->new( 5, 6 );

my ($d, $e, $f) = ( 7, 8, 0.9 );

$sweep->localCenter( $a );
$sweep->c0( $b );
$sweep->c( $c );
$sweep->a0( $d );
$sweep->a( $e );
$sweep->alpha0( $f );

is $sweep->localCenter->x, $a->x, 'Set and Get localCenter';
is $sweep->localCenter->y, $a->y, 'Set and Get localCenter';
is $sweep->c0->x,          $b->x, 'Set and Get c0';
is $sweep->c0->y,          $b->y, 'Set and Get c0';
is $sweep->c->x,           $c->x, 'Set and Get c';
is $sweep->c->y,           $c->y, 'Set and Get c';
is $sweep->a0,             $d,    'Set and Get a0';
is $sweep->a,              $e,    'Set and Get a';

is_nearly $sweep->alpha0, $f, 'Set and Get alpha0'; #yep, we lose precision here

{
    my $xf = Box2D::b2Transform->new;
    my $beta = 12;
    $sweep->GetTransform( $xf, $beta );

    my $q = Box2D::b2Rot->new(
      (1 - $beta) * $sweep->a0 + $beta * $sweep->a
    );

    my $p = (1 - $beta) * $sweep->c0 + $beta * $sweep->c;
    $p -= Box2D::b2Mul( $q, $sweep->localCenter );

    ok b2vec2_cmp( $xf->p, $p),               'GetTransform';
    is_nearly $xf->q->GetAngle, $q->GetAngle, 'GetTransform';
}

{
    my $alpha = 0.5;

    my $beta = ($alpha - $sweep->alpha0) / (1 - $sweep->alpha0);
    my $c0   = (1 - $beta) * $sweep->c0 + $beta * $sweep->c;
    my $a0   = (1 - $beta) * $sweep->a0 + $beta * $sweep->a;

    $sweep->Advance( $alpha );

    ok b2vec2_cmp( $sweep->c0, $c0), 'Advance';
    is_nearly      $sweep->a0, $a0,  'Advance';
}

{
    my $twoPi = 2 * Box2D::b2_pi;
    my $d     = $twoPi * int($sweep->a0 / $twoPi);
    my $a0    = $sweep->a0 - $d;
    my $a     = $sweep->a - $d;

    $sweep->Normalize;

    is_nearly $sweep->a0, $a0, 'Normalize';
    is_nearly $sweep->a,  $a,  'Normalize';
}

done_testing;
