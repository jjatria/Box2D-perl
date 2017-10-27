use strict;
use warnings;
use Box2D;
use Test::More;

use lib 't/lib';
use MyTest::Helper qw( b2vec2_cmp );

my $edge = Box2D::b2EdgeShape->new;
ok $edge, 'new';
isa_ok $edge, 'Box2D::b2EdgeShape';

my $v0 = Box2D::b2Vec2->new( 0.0, 0.0 );
my $v1 = Box2D::b2Vec2->new( 1.0, 0.0 );
my $v2 = Box2D::b2Vec2->new( 1.0, 1.0 );
my $v3 = Box2D::b2Vec2->new( 1.0, 2.0 );

$edge->Set( $v1, $v2 );
pass('Set');

is  $edge->GetChildCount, 1, 'GetChildCount';

ok b2vec2_cmp( $edge->m_vertex1, $v1), 'm_vertex1';
ok b2vec2_cmp( $edge->m_vertex2, $v2), 'm_vertex2';

ok !$edge->m_hasVertex0,         'm_hasVertex0';
ok !$edge->m_hasVertex3,         'm_hasVertex3';

ok !$edge->TestPoint( Box2D::b2Transform->new, $v1 ), 'TestPoint always returns false';
ok !$edge->TestPoint( Box2D::b2Transform->new, $v3 ), 'TestPoint always returns false';

my $mass = Box2D::b2MassData->new;
$edge->ComputeMass( $mass, 0 ); # Density is ignored

my $center = ($v1 + $v2) * 0.5;
ok b2vec2_cmp( $mass->center, $center), 'mass->center';
is $mass->mass, 0,                      'mass->mass';
is $mass->I,    0,                      'mass->I';

$edge->m_vertex0( $v0 );
$edge->m_hasVertex0(1);

$edge->m_vertex3( $v3 );
$edge->m_hasVertex3(1);

ok $edge->m_hasVertex0,                'm_hasVertex0';
ok b2vec2_cmp( $edge->m_vertex0, $v0), 'm_vertex0';

ok $edge->m_hasVertex3,                'm_hasVertex3';
ok b2vec2_cmp( $edge->m_vertex3, $v3), 'm_vertex3';

$edge->m_hasVertex0(0);
$edge->m_hasVertex3(0);

ok !$edge->m_hasVertex0, 'm_hasVertex0 false';
ok !$edge->m_hasVertex3, 'm_hasVertex3 false';

done_testing;
