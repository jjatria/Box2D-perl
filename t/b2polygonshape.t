use strict;
use warnings;
use Box2D;
use Test::More;

my @v = (
    Box2D::b2Vec2->new( 0.0, 0.0 ),
    Box2D::b2Vec2->new( 1.0, 0.0 ),
    Box2D::b2Vec2->new( 0.0, 1.0 ),
);

my $poly = Box2D::b2PolygonShape->new();
my $proxy = Box2D::b2DistanceProxy->new;
$proxy->Set($poly, 0);

is( $proxy->GetVertexCount, 0, "GetVertexCount" );
is( $poly->m_count, 0, "m_count" );
{
    my $cen = $poly->m_centroid;
    is( $cen->x, 0, "m_centroid" );
    is( $cen->y, 0, "m_centroid" );
}

$poly->Set( @v );
$proxy->Set($poly, 0);
pass("Set");

is( $proxy->GetVertexCount, 3, "GetVertexCount" );
is( $poly->m_count, 3, "m_count" );

$poly->m_count( 4 );
$proxy->Set($poly, 0);

# Get vertices in the order they are in the polygon,
# since they may be re-ordered by ->Set
@v = map { $poly->m_vertices($_) } 0 .. $#v;

is( $proxy->GetVertexCount, 4, "GetVertexCount" );
is( $poly->m_count, 4, "m_count" );
{
    my $cen = $poly->m_centroid;
    cmp_ok( abs($cen->x - 1/3), "<=", 1e-5, "m_centroid" );
    cmp_ok( abs($cen->y - 1/3), "<=", 1e-5, "m_centroid" );
    $poly->m_centroid( $v[2] );
    $cen = $poly->m_centroid;
    is( $cen->x, $v[2]->x, "m_centroid" );
    is( $cen->y, $v[2]->y, "m_centroid" );
}

foreach my $index (0 .. $#v) {
    my $vertex = $proxy->GetVertex( $index );
    is( $vertex->x, $v[$index]->x, "GetVertex $index" );
    is( $vertex->y, $v[$index]->y, "GetVertex $index" );

    $vertex = $poly->m_vertices( $index );
    is( $vertex->x, $v[$index]->x, "m_vertices $index" );
    is( $vertex->y, $v[$index]->y, "m_vertices $index" );

    my $normal = $poly->m_normals( $index );

    my $a = $v[($#v - $index + 1 ) % scalar @v];
    my $b = $v[($#v - $index + 2 ) % scalar @v];
    my $check = Box2D::b2Vec2->new( -($b->x - $a->x), $b->y - $a->y );
    $check->Normalize;

    is( $normal->x, $check->x, "m_normals $index" );
    is( $normal->y, $check->y, "m_normals $index" );
}

{
    $poly->m_vertices( 0, $v[2] );
    my $vertex = $proxy->GetVertex( 0 );
    is( $vertex->x, $v[2]->x, "m_vertices set" );
    is( $vertex->y, $v[2]->y, "m_vertices set" );
    $vertex = $poly->m_vertices( 0 );
    is( $vertex->x, $v[2]->x, "m_vertices set" );
    is( $vertex->y, $v[2]->y, "m_vertices set" );
}

{
    $poly->m_normals( 1, $v[0] );
    my $vertex = $poly->m_normals( 1 );
    is( $vertex->x, $v[0]->x, "m_normals set" );
    is( $vertex->y, $v[0]->y, "m_normals set" );
}

my ( $w, $h ) = ( 10.0, 12.0 );
my $rect = Box2D::b2PolygonShape->new();
$rect->SetAsBox( $w / 2.0, $h / 2.0 );
$proxy->Set($rect, 0);

is( $proxy->GetVertexCount, 4, "GetVertexCount" );

foreach ( 0 .. 3 ) {
    my $vertex = $proxy->GetVertex($_);
    is( abs( $vertex->x ), $w / 2, "SetAsBox(2) GetVertex $_" );
    is( abs( $vertex->y ), $h / 2, "SetAsBox(2) GetVertex $_" );
}

my ( $x, $y, $angle ) = ( 14.0, 16.0, 0.0 );
my $rect2 = Box2D::b2PolygonShape->new();
$rect2->SetAsBox( $w, $h, Box2D::b2Vec2->new( $x, $y), $angle );
$proxy->Set($rect2, 0);

is( $proxy->GetVertexCount, 4, "SetAsBox(4) GetVertexCount" );
is( $rect2->m_centroid->x, $x, "SetAsBox(4) m_centroid" );
is( $rect2->m_centroid->y, $y, "SetAsBox(4) m_centroid" );

foreach ( 0 .. 3 ) {
    my $vertex = $proxy->GetVertex($_);
    is( abs( $vertex->x - $x ), $w, "SetAsBox(4) GetVertex $_" );
    is( abs( $vertex->y - $y ), $h, "SetAsBox(4) GetVertex $_" );
}

done_testing;
