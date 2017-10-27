use strict;
use warnings;
use Box2D;
use Test::More;
use Class::Load qw( try_load_class );

use lib 't/lib';
use MyTest::Helper qw(
  b2mat22_cmp b2mat33_cmp b2vec2_cmp b2vec3_cmp
);

my $zero = Box2D::b2Vec2_zero;

my %singular = (
  ex => Box2D::b2Vec3->new(  0,  0,  0 ),
  ey => Box2D::b2Vec3->new(  1,  1,  1 ),
  ez => Box2D::b2Vec3->new(  0,  0,  0 ),
);

my %invertible = (
  ex => Box2D::b2Vec3->new(  1,  7,  3 ),
  ey => Box2D::b2Vec3->new(  7,  4, -5 ),
  ez => Box2D::b2Vec3->new(  3, -5,  6 ),
);

my @cols = qw( ex ey ez );

my $matrix = Box2D::b2Mat33->new( @invertible{@cols} );
isa_ok( $matrix, "Box2D::b2Mat33" );
ok check( $matrix, @invertible{@cols} ), 'Arguments to constructor';

$matrix->SetZero;
ok check( $matrix, $zero, $zero, $zero), 'SetZero';

$matrix = Box2D::b2Mat33->new;
isa_ok $matrix, 'Box2D::b2Mat33';

$matrix->$_( $invertible{$_} ) foreach @cols;

ok check( $matrix, @invertible{@cols} ), 'ex, ey, and ez as mutators';

{
    # Solve for x: A * x = b, where b is a column vector arg

    my $A = Box2D::b2Mat33->new( @invertible{@cols} );
    my $ex = $singular{ex};

    my $x = $A->Solve33( $ex );
    my $b = Box2D::b2Mul( $A, $x );

    ok b2vec3_cmp( $b, $ex ), 'Solve33';
}

{
    # Solve for x: A * x = b, where b is a column vector arg
    # Solve only the upper 2-by-2 matrix equation

    my $A = Box2D::b2Mat33->new( @invertible{@cols} );
    my $ex = Box2D::b2Vec2->new(3, -5);

    my $x = $A->Solve22( $ex );
    my $b = Box2D::b2Mul22( $A, $x );

    ok b2vec2_cmp( $b, $ex ), 'Solve22';
}

foreach (
        [ singular   => \%singular   ],
        [ invertible => \%invertible ],
    ) {

    my ($name, $values) = @{$_};
    my $matrix = Box2D::b2Mat33->new( @{$values}{@cols} );

    my $test = Box2D::b2Mat33->new;
    $matrix->GetInverse22( $test );

    my $check = Box2D::b2Mat22->new(
      $matrix->ex->x, $matrix->ey->x,
      $matrix->ex->y, $matrix->ey->y,
    )->GetInverse;

    ok b2mat22_cmp( $test, $check), "GetInverse22 when $name";
}

{
    # This is a singular matrix
    my $matrix = Box2D::b2Mat33->new( @singular{@cols} );

    my $test = Box2D::b2Mat33->new;
    $matrix->GetSymInverse33( $test );

    my $check = Box2D::b2Mat33->new;
    $check->SetZero;

    ok b2mat33_cmp( $test, $check), 'GetSymInverse33 when singular';
}

SKIP: {
    skip 'Matrix inversion test requires Math::Matrix', 9
      unless try_load_class 'Math::Matrix';

    # This is not a singular matrix
    my $matrix = Box2D::b2Mat33->new( @invertible{@cols} );

    my $test = Box2D::b2Mat33->new;
    $matrix->GetSymInverse33( $test );

    my $check = to_box2d (
        Math::Matrix->new(
            [ map { $matrix->ex->$_ } qw( x y z ) ],
            [ map { $matrix->ey->$_ } qw( x y z ) ],
            [ map { $matrix->ez->$_ } qw( x y z ) ],
        )->invert
    );

    ok b2mat33_cmp( $test, $check), 'GetSymInverse33 when invertible';
}

sub check {
    my ($m, $a, $b, $c) = @_;

    if (ref $m eq 'Box2D::b2Mat22') {
        foreach (
                [ $m->ex, $a ],
                [ $m->ey, $b ],
            ) {
            return 0 unless b2vec2_cmp( @{$_} );
        }
    }
    else {
        foreach (
                [ $m->ex, $a ],
                [ $m->ey, $b ],
                [ $m->ez, $c ],
            ) {

            return 0 unless b2vec2_cmp( @{$_} );
        }
    }

    return 1;
}

sub to_box2d {
  return Box2D::b2Mat33->new(
    map {
      Box2D::b2Vec3->new( @{ $_[0]->slice($_)->transpose->[0] } )
    } (0 .. 2)
  );
}

done_testing;
