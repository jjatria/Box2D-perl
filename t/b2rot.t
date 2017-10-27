use strict;
use warnings;
use Box2D;
use Test::More;

use lib 't/lib';
use MyTest::Helper qw( is_nearly );

my $angle = 2;
my $rot = Box2D::b2Rot->new( $angle );
isa_ok $rot, 'Box2D::b2Rot';

is_nearly $rot->s,        sin($angle), 'Get s';
is_nearly $rot->c,        cos($angle), 'Get c';
is        $rot->GetAngle,     $angle,  'GetAngle';

$rot->Set( Box2D::b2_pi / 2 );

is_nearly $rot->s, 1, 'Set s';
is_nearly $rot->c, 0, 'Set c';

$rot->SetIdentity;

is $rot->s, 0, 'Get s';
is $rot->c, 1, 'Get c';

$rot = Box2D::b2Rot->new;

isa_ok $rot, 'Box2D::b2Rot';

$rot->s(1);
$rot->c(0);

is $rot->s, 1, 'Set s';
is $rot->c, 0, 'Set c';
is_nearly $rot->GetAngle, Box2D::b2_pi / 2, 'GetAngle';

$angle = 1.5;
$rot->Set( $angle );

is_nearly $rot->s, sin $angle, 'Set';
is_nearly $rot->c, cos $angle, 'Set';

{
    my $x = $rot->GetXAxis;
    is $x->x, $rot->c, 'GetXAxis';
    is $x->y, $rot->s, 'GetXAxis';
}

{
    my $y = $rot->GetYAxis;
    is $y->x, -$rot->s, 'GetYAxis';
    is $y->y,  $rot->c, 'GetYAxis';
}

done_testing;
