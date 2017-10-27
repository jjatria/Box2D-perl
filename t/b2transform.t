use strict;
use warnings;
use Box2D;
use Test::More;

use lib 't/lib';
use MyTest::Helper qw( is_nearly b2vec2_cmp );

my ( $x,  $y,  $angle )  = (  7.0,  9.0, 1.0 );
my ( $x2, $y2, $angle2 ) = ( 11.0, 13.0, 2.0 );

my $position  = Box2D::b2Vec2->new( $x,  $y );
my $position2 = Box2D::b2Vec2->new( $x2, $y2 );

my $rotation  = Box2D::b2Rot->new( $angle );
my $rotation2 = Box2D::b2Rot->new( $angle2 );

my $transform = Box2D::b2Transform->new( $position, $rotation );

isa_ok $transform, 'Box2D::b2Transform';

ok b2vec2_cmp( $transform->p, $position ), 'Get p';
is_nearly $transform->q->GetAngle, $angle, 'Get q->GetAngle';

# Empty constructor does nothing
$transform = Box2D::b2Transform->new;

isa_ok $transform, 'Box2D::b2Transform';

$transform->Set( $position2, $angle2 );

ok b2vec2_cmp( $transform->p, $position2 ), 'Set p';
is_nearly $transform->q->GetAngle, $angle2, 'Set angle';

$transform->SetIdentity;

is $transform->p->x, 0, 'SetIdentity p->x';
is $transform->p->y, 0, 'SetIdentity p->y';
is $transform->q->s, 0, 'SetIdentity q->s';
is $transform->q->c, 1, 'SetIdentity q->c';

$transform->p($position2);
$transform->q($rotation2);

ok b2vec2_cmp( $transform->p, $position2 ), 'p as mutator';
is_nearly $transform->q->GetAngle, $angle2, 'q as mutator';

done_testing;
