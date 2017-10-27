use strict;
use warnings;
use Box2D;
use Test::More;

sub is_nearly {
  my ($a, $b, $name, $threshold) = @_;
  cmp_ok abs($a - $b), q{<=}, $threshold // 1e-5, "Box2d::b2_$name is nearly $b";
}

cmp_ok Box2D::b2_maxFloat, q{>},  1e+37, q{Box2D::b2_maxFloat > 1e+37};
cmp_ok Box2D::b2_epsilon,  q{<=}, 1e-5,  q{Box2D::b2_maxFloat <= 1e-5};

my $pi = Box2D::b2_pi;
my $lS = Box2D::b2_linearSlop;
my $mT = Box2D::b2_maxTranslation;
my $mR = Box2D::b2_maxRotation;
my $v  = Box2D::b2_version;

is_nearly $pi,                             3.14159265359, 'pi';
is_nearly $lS,                             0.005,         'linearSlop';
is_nearly $mT,                             2,             'maxTranslation';
is_nearly $mR,                             0.5 * $pi,     'maxRotation';

is_nearly Box2D::b2_maxManifoldPoints,     2,             'maxManifoldPoints';
is_nearly Box2D::b2_maxPolygonVertices,    8,             'maxPolygonVertices';
is_nearly Box2D::b2_aabbExtension,         0.1,           'aabbExtension';
is_nearly Box2D::b2_aabbMultiplier,        2,             'aabbMultiplier';
is_nearly Box2D::b2_angularSlop,           2 / 180 * $pi, 'angularSlop';
is_nearly Box2D::b2_polygonRadius,         2 * $lS,       'polygonRadius';
is_nearly Box2D::b2_maxSubSteps,           8,             'maxSubSteps';
is_nearly Box2D::b2_maxTOIContacts,        32,            'maxTOIContacts';
is_nearly Box2D::b2_velocityThreshold,     1,             'velocityThreshold';
is_nearly Box2D::b2_maxLinearCorrection,   0.2,           'maxLinearCorrection';
is_nearly Box2D::b2_maxAngularCorrection,  8 / 180 * $pi, 'maxAngularCorrection';
is_nearly Box2D::b2_maxTranslationSquared, $mT * $mT,     'maxTranslationSquared';
is_nearly Box2D::b2_maxRotationSquared,    $mR * $mR,     'maxRotationSquared';
is_nearly Box2D::b2_baumgarte,             0.2,           'baumgarte';
is_nearly Box2D::b2_toiBaugarte,           0.75,          'toiBaugarte';
is_nearly Box2D::b2_timeToSleep,           0.5,           'timeToSleep';
is_nearly Box2D::b2_linearSleepTolerance,  0.01,          'linearSleepTolerance';
is_nearly Box2D::b2_angularSleepTolerance, 2 / 180 * $pi, 'angularSleepTolerance';

# TODO: Memory Allocation
# void* b2Alloc(int32 size);
# void b2Free(void* mem);
# void b2Log(const char* string, ...);

isa_ok $v, 'Box2D::b2Version', 'Box2D::b2_version';

like $v->major,    qr/^\d+$/,         'version->major is a number';
like $v->minor,    qr/^\d+$/,         'version->minor is a number';
like $v->revision, qr/^\d+$/,         'version->revision is a number';
isnt $v,           Box2D::b2_version, 'b2_version returns different objects';

note sprintf('Version: %s.%s.%s', $v->major, $v->minor, $v->revision);

done_testing;
