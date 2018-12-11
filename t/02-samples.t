use Test;
use Test::SAT::Counter;
use SAT::Counter::dsharp;

# All numbers here confirmed[*] with dsharp, sharpSAT and cachet.
# (I modified cachet-wmc-1-21 for bignum support but the license does not
# permit me to share it. The version distributed officially is very close
# to supporting it though.)
#
# [*] There _are_ some disagreements between these solvers, as follows
# with an explanation for why the number here is correct:
#   + cachet/disjunction-100.cnf: report 2**100 instead of 2**100-1,
#     this must obviously be a bug in cachet.

plan 4;

my $*SAT-COUNTER = dsharp;

# Some gaussoids
subtest 'gaussoids' => {
    plan 4;
    count-ok 't/gaussoids-4.cnf'          => 679;
    count-ok 't/real-gaussoids-4.cnf'     => 629;
    count-ok 't/unorientable.cnf'         => 0;
    count-ok 't/uniform-gaussoids-4.cnf'  => 5376;
}

if %*ENV<DSHARP_INTENSE_TESTING> {
    subtest 'more intense tests' => {
        count-ok 't/oriented-gaussoids-4.cnf' => 34873;
        count-ok 't/positive-gaussoids-6.cnf' => 32768;
        count-ok 't/dense-gaussoids-8.cnf.gz' => 764;
    }
}
else {
    skip 'DSHARP_INTENSE_TESTING is not set';
}

# These come from the dsharp repository.
subtest 'dsharp upstream tests' => {
    plan 2;
    count-ok 't/bmc-ibm-2.cnf'            => 13330654897016668160;
    count-ok 't/logistics.a.cnf'          => 377969276544912;
}

# Testing big number support
subtest 'gmp test' => {
    plan 1;
    count-ok 't/disjunction-100.cnf'      => 2**100-1;
}
