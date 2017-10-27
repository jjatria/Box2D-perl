use strict;
use warnings;
use Box2D;
use Test::More;

use lib 't/lib';
use MyTest::Helper qw( is_nearly );

my $vec = Box2D::b2Vec2->new( 10, 11 );

isa_ok $vec, 'Box2D::b2Vec2';

is $vec->x, 10, 'Get x';
is $vec->y, 11, 'Get y';

$vec->x(3);
$vec->y(4);

is $vec->x, 3, 'Set x';
is $vec->y, 4, 'Set y';

$vec = Box2D::b2Vec2->new;

isa_ok $vec, 'Box2D::b2Vec2';

$vec->Set( 5, 6 );

is $vec->x, 5, 'Set';
is $vec->y, 6, 'Set';

$vec->y(5);

is_nearly $vec->Length,    sqrt(50),         'Length';
is $vec->LengthSquared,    50,               'LengthSquared';
is_nearly $vec->Normalize, 7.07106781005859, 'Normalize';
is $vec->Length,           1,                'Unit vector';

ok $vec->IsValid, 'IsValid';

$vec->Set( 1e1000 ** 1e1000, 2 );
ok !$vec->IsValid, 'IsValid';

$vec->Set( 4, -1e1000 ** 1e1000 );
ok !$vec->IsValid, 'IsValid';

$vec->SetZero;

is $vec->x, 0, 'SetZero x';
is $vec->y, 0, 'SetZero y';

$vec += Box2D::b2Vec2->new(2, -4);
is $vec->x,  2, 'b2Vec2 += b2Vec2 x';
is $vec->y, -4, 'b2Vec2 += b2Vec2 y';

$vec *= 2.5;
is $vec->x,   5, 'b2Vec2 *= scalar x';
is $vec->y, -10, 'b2Vec2 *= scalar y';

$vec -= Box2D::b2Vec2->new(3, -9);
is $vec->x,  2, 'b2Vec2 -= b2Vec2 x';
is $vec->y, -1, 'b2Vec2 -= b2Vec2 y';

{
    my $c = -$vec;
    is $c->x, -2, '-b2Vec2 x';
    is $c->y,  1, '-b2Vec2 y';
}

{
    # Get the skew vector such that dot(skew_vec, other) == cross(vec, other)
    my $skew = $vec->Skew;
    my $other = Box2D::b2Vec2->new(3, -7);
    is_nearly $skew . $other, $vec x $other, 'Skew';
}

done_testing;
