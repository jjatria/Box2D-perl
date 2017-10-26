use strict;
use warnings;
use Box2D;
use Test::More;

my $circle = Box2D::b2CircleShape->new();
ok( $circle, 'new' );
isa_ok( $circle, 'Box2D::b2CircleShape' );


my $v0 = Box2D::b2Vec2->new( 0.0, 1.0 );

$circle->m_p( $v0 );

is( $circle->m_p->x, $v0->x, 'm_p x' );
is( $circle->m_p->y, $v0->y, 'm_p y' );

my $proxy = Box2D::b2DistanceProxy->new;
$proxy->Set( $circle, 0 );

{
	my $s = $proxy->GetSupport( Box2D::b2Vec2->new );
	is( $s, 0, "GetSupport" );
}

{
	my $v = $proxy->GetSupportVertex( Box2D::b2Vec2->new );
	is( $v->x, $circle->m_p->x, 'GetSupportVertex' );
	is( $v->y, $circle->m_p->y, 'GetSupportVertex' );
}

{
	my $s = $proxy->GetVertexCount();
	is( $s, 1, "GetVertexCount" );
}

{
	my $v = $proxy->GetVertex( 0 );
	is( $v->x, $circle->m_p->x, 'GetSupportVertex' );
	is( $v->y, $circle->m_p->y, 'GetSupportVertex' );
}

done_testing;
