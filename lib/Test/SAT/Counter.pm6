unit module Test::SAT::Counter;

use Test;
use Compress::Zlib;

#| Verify that the SAT::Counter in $*SAT-COUNTER produces accurate counts.
sub count-ok ($p (:key($file), :value($answer))) is export {
    my $cnf = $file.ends-with(".gz") ??
        gzslurp($file) !! $file.IO;
    my $models = await $*SAT-COUNTER.new.count: $cnf;
    is $models, $answer, "correct count for $file";
}
