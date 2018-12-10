use Test;
use SAT::Counter::dsharp;

plan 6;

is dsharp.new.count('t/gaussoids-4.cnf'.IO).&await,       679, "IO dispatch";
is dsharp.new.count(slurp 't/gaussoids-4.cnf').&await,    679, "Str dispatch";
is dsharp.new.count('t/gaussoids-4.cnf'.IO.lines).&await, 679, "Seq dispatch";

my $DIMACS = q:to/EOF/;
p cnf 9 1
1 2 3 4 5 6 7 8 9 0
EOF
my $actee := cache $DIMACS.lines.map({
    if m/^ [ $<var>=[\d+] \s+ ]+ 0 $/ {
        slip gather {
            take $_;
            for $<var> -> $negate {
                take $<var>».Str.map(-> $n {
                    $n == $negate ?? -$n !! $n
                }).join(' ') ~ " 0";
            }
        }
    }
    elsif m/^ 'p cnf' \s $<vars>=[\d+] \s $<clauses>=[\d+] / {
        "p cnf $<vars> { $<clauses> * (1 + $<vars>) }"
    }
});

is dsharp.new.count($DIMACS).&await,                        511, "Str dispatch";
is dsharp.new.count($actee).&await,                         502, "List dispatch";
is dsharp.new.count($actee.Supply.throttle(1, 0.3)).&await, 502, "Supply dispatch";
