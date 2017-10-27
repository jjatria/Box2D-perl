use strict;
use warnings;
use Box2D;
use Test::More;

my $vec = Box2D::b2Vec3->new( 10, 11, 12 );

isa_ok $vec, 'Box2D::b2Vec3';

is $vec->x, 10, 'Get x';
is $vec->y, 11, 'Get y';
is $vec->z, 12, 'Get z';

$vec->x(3);
$vec->y(4);
$vec->z(5);

is $vec->x, 3, 'Set x';
is $vec->y, 4, 'Set y';
is $vec->z, 5, 'Set z';

$vec = Box2D::b2Vec3->new;

isa_ok $vec, 'Box2D::b2Vec3';

$vec->Set( 6, 7, 8 );

is $vec->x, 6, 'Set x';
is $vec->y, 7, 'Set y';
is $vec->z, 8, 'Set z';

$vec->SetZero;

is $vec->x, 0, 'SetZero x';
is $vec->y, 0, 'SetZero y';
is $vec->z, 0, 'SetZero z';

$vec += Box2D::b2Vec3->new(2, -4, 6);
is $vec->x,  2, 'b2Vec3 += b2Vec3 x';
is $vec->y, -4, 'b2Vec3 += b2Vec3 y';
is $vec->z,  6, 'b2Vec3 += b2Vec3 z';

$vec *= 2.5;
is $vec->x,   5, 'b2Vec3 *= scalar x';
is $vec->y, -10, 'b2Vec3 *= scalar y';
is $vec->z,  15, 'b2Vec3 *= scalar z';

$vec -= Box2D::b2Vec3->new(3, -9, 4);
is $vec->x,  2, 'b2Vec3 -= b2Vec3 x';
is $vec->y, -1, 'b2Vec3 -= b2Vec3 y';
is $vec->z, 11, 'b2Vec3 -= b2Vec3 z';

{
    my $c = -$vec;
    is $c->x,  -2, '-b2Vec3 x';
    is $c->y,   1, '-b2Vec3 y';
    is $c->z, -11, '-b2Vec3 z';
}

done_testing;
