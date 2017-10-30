package MyTest::Helper;

use warnings;
use strict;
use Test::More;

our @ISA = qw(Exporter);

our $VERSION = '0.06';

our @EXPORT_OK = qw(
  is_nearly
  b2vec2_cmp
  b2vec3_cmp
  b2mat22_cmp
  b2mat33_cmp
  b2transform_cmp
  b2rot_cmp
);

sub is_nearly {
  my ($a, $b, $name, $threshold) = @_;

  $name      //= '$x';
  $threshold //= 1e-5;

  my $result = _is_nearly( $a, $b, $threshold );

  ok $result, "$name is nearly $b (~$threshold)";
  note "    got $a" unless $result;
}

sub _is_nearly {
  my ($a, $b, $threshold) = @_;

  $threshold //= 1e-5;
  return abs($a - $b) <= $threshold;
}

sub b2vec2_cmp { _method_cmp( shift, shift, qw( x y ) ) };
sub b2vec3_cmp { _method_cmp( shift, shift, qw( x y z ) ) };

sub b2mat22_cmp {
  my ($a, $b) = @_;
  for (qw( ey ex )) {
    return 0 unless b2vec2_cmp( $a->$_, $b->$_ );
  }
  return 1;
}

sub b2mat33_cmp {
  my ($a, $b) = @_;
  for (qw( ey ex ez )) {
    return 0 unless b2vec3_cmp( $a->$_, $b->$_ );
  }
  return 1;
}

sub b2transform_cmp {
  my ($a, $b) = @_;
  return 0 unless b2vec2_cmp( $a->p, $b->p );
  return 0 unless b2rot_cmp( $a->q, $b->q );
  return 1;
}

sub b2rot_cmp {
  my ($a, $b) = @_;
  return 0 unless _is_nearly( $a->GetAngle, $b->GetAngle );
  return 1;
}

sub _method_cmp {
  my ($a, $b, @methods) = @_;
  for (@methods) {
    return 0 unless _is_nearly($a->$_, $b->$_);
  }
  return 1
}

1;
