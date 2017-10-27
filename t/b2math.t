use strict;
use warnings;
use Box2D;
use Test::More;

use lib 't/lib';
use MyTest::Helper qw(
  is_nearly b2vec2_cmp b2mat22_cmp b2vec3_cmp
  b2transform_cmp b2rot_cmp
);

ok  Box2D::b2IsValid( 0),               'b2IsValid';
ok  Box2D::b2IsValid( 1),               'b2IsValid';
ok  Box2D::b2IsValid(-1),               'b2IsValid';
ok !Box2D::b2IsValid( 1e1000**1e1000), '!b2IsValid';
ok !Box2D::b2IsValid(-1e1000**1e1000), '!b2IsValid';

my $nan = "NaN";

SKIP: {
    skip "No NaN support", 1 unless $nan != $nan;
    ok !Box2D::b2IsValid($nan), '!b2IsValid';
}

is_nearly Box2D::b2InvSqrt(4.0),   0.5,            'b2InvSqrt', 1e-3;
is_nearly Box2D::b2Sqrt(94),       sqrt(94),       'b2Sqrt(int)';
is_nearly Box2D::b2Sqrt(7.3),      sqrt(7.3),      'b2Sqrt(float)';
is_nearly Box2D::b2Atan2(35, 5.4), atan2(35, 5.4), 'b2Atan2';

{
    my $zero = Box2D::b2Vec2_zero;

    is $zero->x, 0, 'b2Vec2_zero';
    is $zero->y, 0, 'b2Vec2_zero';

    $zero->x(1);
    $zero->y(2);

    my $zero2 = Box2D::b2Vec2_zero;
    is $zero2->x, 0, 'b2Vec2_zero returns a different object';
    is $zero2->y, 0, 'b2Vec2_zero returns a different object';
}

note 'Operator tests';
{
    note 'b2Vec2';
    {
        my $a = Box2D::b2Vec2->new( 1, 2 );
        my $b = Box2D::b2Vec2->new( 3, 4 );

        cmp_ok $a, '!=', $b, 'b != b';
        cmp_ok $b, '!=', $a, 'b != a';
        cmp_ok $a, '==', $a, 'b == a';
        cmp_ok $b, '==', $b, 'b == a';

        ok !($a == $b), '!(a == b)';
        ok !($b == $a), '!(b == a)';
        ok !($a != $a), '!(a != a)';
        ok !($b != $b), '!(a != a)';

        ok(   Box2D::b2Vec2->new(33, 5.7) == Box2D::b2Vec2->new(33, 5.7),  'a == a' );
        ok( !(Box2D::b2Vec2->new(9.9, 95) != Box2D::b2Vec2->new(9.9, 95)), '!(a != a)' );

        my $c = Box2D::b2Vec2->new( $a->x, $a->y );
        ok $a == $c, "a == b";

        my $test;
        my $check = Box2D::b2Vec2->new;

        $test = $a + $b;
        $check->Set(
            $a->x + $b->x,
            $a->y + $b->y,
        );
        ok b2vec2_cmp( $test, $check ), 'a + b';

        $test = $a - $b;
        $check->Set(
            $a->x - $b->x,
            $a->y - $b->y,
        );
        ok b2vec2_cmp( $test, $check ), 'a - b';

        $test = $a . $b;
        is $test, $a->x * $b->x + $a->y * $b->y, 'a . b';

        $test = $a x $b;
        is $test, $a->x * $b->y - $a->y * $b->x, 'a x b';

        my $n = 4;
        $test = $n * $a;
        $check->Set(  $n * $a->x,  $n * $a->y );
        ok b2vec2_cmp( $test, $check ), 'scalar * vector';

        $test = $n x $a;
        $check->Set( -$n * $a->y,  $n * $a->x );
        ok b2vec2_cmp( $test, $check ), 'scalar x vector';

        $test = $a x $n;
        $check->Set(  $n * $a->y, -$n * $a->x );
        ok b2vec2_cmp( $test, $check ), 'vector x scalar';
    }

    note 'b2Mat22';
    {
        my $m = Box2D::b2Mat22->new;
        my $n = Box2D::b2Mat22->new;

        $m->SetIdentity;
        $n->SetZero;

        my $test = $m + $n;
        my $check = Box2D::b2Mat22->new(
          $m->ex->x + $n->ex->x,
          $m->ey->x + $n->ey->x,
          $m->ex->y + $n->ex->y,
          $m->ey->y + $n->ey->y,
        );
        ok b2mat22_cmp( $test, $check ), 'a + b';
    }

    note 'b2Vec33';
    {
        my $a = Box2D::b2Vec3->new( 11, 12, 13 );
        my $b = Box2D::b2Vec3->new( 14, 15, 16 );
        my $c = Box2D::b2Vec3->new( 21, 22, 23 );
        my $x = 9;

        my ($test, $check);

        $test = $x * $a;
        $check = Box2D::b2Vec3->new(
            $x * $a->x,
            $x * $a->y,
            $x * $a->z,
        );
        ok b2vec3_cmp( $test, $check ), 'scalar * vector';

        $test = $a + $b;
        $check = Box2D::b2Vec3->new(
            $a->x + $b->x,
            $a->y + $b->y,
            $a->z + $b->z,
        );
        ok b2vec3_cmp( $test, $check ), 'a + b';

        $test = $a - $b;
        $check = Box2D::b2Vec3->new(
            $a->x - $b->x,
            $a->y - $b->y,
            $a->z - $b->z,
        );
        ok b2vec3_cmp( $test, $check ), 'a - b';

        $test = $a . $b;
        is $test, $a->x * $b->x + $a->y * $b->y + $a->z * $b->z, 'a . b';

        $test = $a x $b;
        $check = Box2D::b2Vec3->new(
            $a->y * $b->z - $a->z * $b->y,
            $a->z * $b->x - $a->x * $b->z,
            $a->x * $b->y - $a->y * $b->x,
        );
        ok b2vec3_cmp( $test, $check ), 'a x b';

    }
}

note 'b2Dot';
{
    {
        my $a = Box2D::b2Vec2->new( 1, 2 );
        my $b = Box2D::b2Vec2->new( 3, 4 );

        is Box2D::b2Dot( $a, $b ), $a->x * $b->x + $a->y * $b->y, 'b2Vec2';
    }

    {
        my $a = Box2D::b2Vec3->new( 1, 2, 3 );
        my $b = Box2D::b2Vec3->new( 4, 5, 6 );

        my $test = Box2D::b2Dot( $a, $b );
        is $test, $a->x * $b->x + $a->y * $b->y + $a->z * $b->z, 'b2Vec3';
    }
}

note 'b2Cross';
{
    note 'b2Vec2';
    {
        my $a = Box2D::b2Vec2->new( 1, 2 );
        my $b = Box2D::b2Vec2->new( 3, 4 );
        my $n = 4;

        my $check = Box2D::b2Vec2->new;

        my $test = Box2D::b2Cross( $a,  $b );
        is $test, $a->x * $b->y - $a->y * $b->x, '(a, b)';

        $test = Box2D::b2Cross( $a,  $n );
        $check->Set(  $n * $a->y, -$n * $a->x );
        ok b2vec2_cmp( $test, $check ), '(vector, scalar)';

        $test = Box2D::b2Cross( $n, $a );
        $check->Set( -$n * $a->y,  $n * $a->x );
        ok b2vec2_cmp( $test, $check ), '(scalar, vector)';
    }

    note 'b2Vec3';
    {
        my $a = Box2D::b2Vec3->new( 1, 2, 3 );
        my $b = Box2D::b2Vec3->new( 4, 5, 6 );

        my $test = Box2D::b2Cross( $a, $b );
        my $check = Box2D::b2Vec3->new(
            $a->y * $b->z - $a->z * $b->y,
            $a->z * $b->x - $a->x * $b->z,
            $a->x * $b->y - $a->y * $b->x,
        );
        ok b2vec3_cmp( $test, $check ), '(a, b)';
    }
}

note 'b2Mul / b2Mul22 / b2MulT';
{
    my $v2 = Box2D::b2Vec2->new( 1, 2 );
    my $m2 = Box2D::b2Mat22->new( $v2, $v2 );

    {
        my $test = Box2D::b2Mul( $m2, $v2 );
        my $check = Box2D::b2Vec2->new(
          $m2->ex->x * $v2->x + $m2->ey->x * $v2->y,
          $m2->ex->y * $v2->x + $m2->ey->y * $v2->y
        );
        ok b2vec2_cmp( $test, $check ), 'b2Mul(b2Mat22, b2Vec2)';
    }

    {
        my $test = Box2D::b2MulT( $m2, $v2 );
        my $check = Box2D::b2Vec2->new(
            Box2D::b2Dot( $v2, $m2->ex ),
            Box2D::b2Dot( $v2, $m2->ey ),
        );
        ok b2vec2_cmp( $test, $check ), 'b2MulT(b2Mat22, b2Vec2)';
    }

    {
        my $test = Box2D::b2Mul( $m2, $m2 );
        my $check = Box2D::b2Mat22->new(
          Box2D::b2Mul( $m2, $m2->ex ),
          Box2D::b2Mul( $m2, $m2->ey ),
        );
        ok b2mat22_cmp( $test, $check ), 'b2Mul(b2Mat22, b2Mat22)';
    }

    {
        my $test = Box2D::b2MulT( $m2, $m2 );
        my $check = Box2D::b2Mat22->new(
            Box2D::b2Dot( $m2->ex, $m2->ex ),
            Box2D::b2Dot( $m2->ex, $m2->ey ),
            Box2D::b2Dot( $m2->ey, $m2->ex ),
            Box2D::b2Dot( $m2->ey, $m2->ey ),
        );
        ok b2mat22_cmp( $test, $check ), 'b2MulT(b2Mat22, b2Mat22)';
    }

    my $v3 = Box2D::b2Vec3->new( 4, 2, 3 );
    my $m3 = Box2D::b2Mat33->new( $v3, $v3, $v3 );
    {
        my $test = Box2D::b2Mul( $m3, $v3 );
        my $check = $v3->x * $m3->ex + $v3->y * $m3->ey + $v3->z * $m3->ez;
        ok b2vec3_cmp( $test, $check ), 'b2Mul(b2Mat33, b2Vec3)';
    }

    {
        my $test = Box2D::b2Mul22( $m3, $v2 );
        my $check = Box2D::b2Vec2->new(
            $m3->ex->x * $v2->x + $m3->ey->x * $v2->y,
            $m3->ex->y * $v2->x + $m3->ey->y * $v2->y,
        );
        ok b2vec2_cmp( $test, $check ), 'b2Mul22(b2Mat33, b2Vec2)';
    }

    my $r  = Box2D::b2Rot->new( 2 );
    {
        my $test = Box2D::b2Mul( $r, $r );
        my $check = Box2D::b2Rot->new(
            atan2(
                ($r->s * $r->c + $r->c * $r->s),
                ($r->c * $r->c - $r->s * $r->s),
            )
        );
        ok b2rot_cmp( $test, $check ), 'b2Mul(b2Rot, b2Rot)';
    }

    {
        my $test = Box2D::b2MulT( $r, $r );
        my $check = Box2D::b2Rot->new(
            atan2(
                ($r->c * $r->s - $r->s * $r->c),
                ($r->c * $r->c + $r->s * $r->s),
            )
        );
        ok b2rot_cmp( $test, $check ), 'b2MulT(b2Rot, b2Rot)';
    }

    {
        my $test = Box2D::b2Mul( $r, $v2 );
        my $check = Box2D::b2Vec2->new(
            ($r->c * $v2->x - $r->s * $v2->y),
            ($r->s * $v2->x + $r->c * $v2->y),
        );
        ok b2vec2_cmp( $test, $check ), 'b2Mul(b2Rot, b2Vec2)';
    }

    {
        my $test = Box2D::b2MulT( $r, $v2 );
        my $check = Box2D::b2Vec2->new(
            ( $r->c * $v2->x + $r->s * $v2->y),
            (-$r->s * $v2->x + $r->c * $v2->y),
        );
        ok b2vec2_cmp( $test, $check ), 'b2MulT(b2Rot, b2Vec2)';
    }

    my $t  = Box2D::b2Transform->new( $v2, $r );
    {
        my ($a, $b) = ($t, $t);
        my $test = Box2D::b2Mul( $a, $b );
        my $check = Box2D::b2Transform->new(
            Box2D::b2Mul( $a->q, $b->p) + $a->p, # b2Vec2
            Box2D::b2Mul( $a->q, $b->q ),        # b2Rot
        );
        ok b2transform_cmp( $test, $check ), 'b2Mul(b2Transform, b2Transform)';
    }

    {
        my ($a, $b) = ($t, $t);
        my $test = Box2D::b2MulT( $a, $b );
        my $check = Box2D::b2Transform->new(
            Box2D::b2MulT( $a->q, $b->p - $a->p ), # b2Vec2
            Box2D::b2MulT( $a->q, $b->q ),         # b2Rot
        );
        ok b2transform_cmp( $test, $check ), 'b2MulT(b2Transform, b2Transform)';
    }

    {
        my $test = Box2D::b2Mul( $t, $v2 );
        my $check = Box2D::b2Vec2->new(
            ($t->q->c * $v2->x - $t->q->s * $v2->y + $t->p->x),
            ($t->q->s * $v2->x + $t->q->c * $v2->y + $t->p->y),
        );
        ok b2vec2_cmp( $test, $check ), 'b2Mul(b2Transform, b2Vec2)';
    }

    {
        my $test = Box2D::b2MulT( $t, $v2 );
        my $px = $v2->x - $t->p->x;
        my $py = $v2->y - $t->p->y;
        my $check = Box2D::b2Vec2->new(
            ( $t->q->c * $px + $t->q->s * $py),
            (-$t->q->s * $px + $t->q->c * $py),
        );
        ok b2vec2_cmp( $test, $check ), 'b2MulT(b2Transform, b2Vec2)';
    }
}

note 'abs / b2Abs';
{
    is Box2D::b2Abs( 1), 1, 'b2Abs(1)';
    is Box2D::b2Abs(-1), 1, 'b2Abs(-1)';

    my $v2 = Box2D::b2Vec2->new( 1, 2 );
    my $m2 = Box2D::b2Mat22->new( $v2, -$v2 );
    {
        my $test = Box2D::b2Abs( $m2 );

        my $check = Box2D::b2Mat22->new( $v2, $v2 );
        ok b2mat22_cmp( $test, $check), 'b2Abs(b2Mat22)';

        $test = abs( $m2 );
        ok b2mat22_cmp( $test, $check), 'abs(b2Mat22)';
    }

    ok b2vec2_cmp( Box2D::b2Abs( -$v2 ), $v2), 'b2Abs(b2Vec2)';
    ok b2vec2_cmp(          abs( -$v2 ), $v2), 'abs(b2Vec2)';
}

note 'b2Min / b2Max';
{
    my ($a, $b) = (0, 1);
    is Box2D::b2Min( $a, $b ), $a, 'b2Min(scalar < scalar)';
    is Box2D::b2Min( $b, $a ), $a, 'b2Min(scalar > scalar)';
    is Box2D::b2Max( $a, $b ), $b, 'b2Max(scalar < scalar)';
    is Box2D::b2Max( $b, $a ), $b, 'b2Max(scalar > scalar)';

    my $va = Box2D::b2Vec2->new( 0, 1 );
    my $vb = Box2D::b2Vec2->new( 0, 2 );

    ok b2vec2_cmp( Box2D::b2Min( $va, $vb ), $va ), 'b2Min(b2Vec2 < b2Vec2)';
    ok b2vec2_cmp( Box2D::b2Min( $vb, $va ), $va ), 'b2Min(b2Vec2 > b2Vec2)';
    ok b2vec2_cmp( Box2D::b2Max( $va, $vb ), $vb ), 'b2Max(b2Vec2 < b2Vec2)';
    ok b2vec2_cmp( Box2D::b2Max( $vb, $va ), $vb ), 'b2Max(b2Vec2 > b2Vec2)';
}

{
    my $va = Box2D::b2Vec2->new( 3, 6);
    my $vb = Box2D::b2Vec2->new( 6, 6);
    is Box2D::b2Distance( $va, $vb ), ( $va - $vb )->Length, 'b2Distance';

    my $test = Box2D::b2DistanceSquared( $va, $vb );
    my $check = $va - $vb;
    is $test, $check . $check, 'b2DistanceSquared';
}

{
    my $x  = 1;
    my $lo = 3;
    my $hi = 4;
    my $test = Box2D::b2Clamp( $x, $lo, $hi );
    is $test, $lo, 'b2Clamp(scalar)';
}

{
    my $v2 = Box2D::b2Vec2->new( 3, 6);
    my $lo = Box2D::b2Vec2->new(-2, 4);
    my $hi = Box2D::b2Vec2->new( 8, 5);

    my $test = Box2D::b2Clamp( $v2, $lo, $hi );
    my $check = Box2D::b2Vec2->new( $v2->x, $hi->y );

    ok b2vec2_cmp( $test, $check ), 'b2Clamp(b2Vec2)';
}

todo 'Dunno how to get the xsp to work' => sub {
    my $a = 123;
    my $b = \456;
    Box2D::b2Swap( $a, $b );

    is ${$a}, 456, 'b2Swap';
    is   $b,  123, 'b2Swap';
};

is  Box2D::b2NextPowerOfTwo(2), 2 ** 2, 'b2NextPowerOfTwo';

ok  Box2D::b2IsPowerOfTwo(  2 ** 2 ),      'b2IsPowerOfTwo true';
ok !Box2D::b2IsPowerOfTwo( (2 ** 4) - 1 ), 'b2IsPowerOfTwo false';

done_testing;
