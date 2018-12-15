=begin pod

=head1 NAME

SAT::Counter::DSHARP - #SAT solver DSHARP

=head1 SYNOPSIS

=begin code
use SAT::Counter::DSHARP;

say dsharp 't/gaussoids-4.cnf', :now;
#= 679
say dsharp 't/bmc-ibm-2.cnf', :now;
#= 13330654897016668160
=end code

=head1 DESCRIPTION

SAT::Counter::DSHARP wraps the C<dsharp> executable (bundled with the module)
used to count the satisfying assignments of a Boolean formula in the
C<DIMACS cnf> format, i.e. the C<#SAT> problem associated to the formula.

Given a DIMACS cnf problem, it starts C<dsharp>, feeds it the problem and
returns a Promise which is kept with the C<#SAT> solution found or broken on
error.

=end pod

use SAT;

# XXX: Workaround for zef stripping execute bits on resource install.
BEGIN sink with %?RESOURCES<dsharp>.IO { .chmod: 0o100 +| .mode };

class SAT::Counter::DSHARP does SAT::Counter is export {
    multi method count (Supply $lines, *% () --> Promise) {
        my $out;
        with my $proc = Proc::Async.new: :w, %?RESOURCES<dsharp>, '-q' {
            $out = .stdout.lines;
            .start and await .ready;
            react whenever $lines -> $line {
                .put: $line;
                LAST .close-stdin;
            }
        }

        $out.map({
            m/^ '# of solutions:' \s* <( \d+ )> / ??
                $/.Int !! Empty
        }).Promise
    }
}

multi sub dsharp (|c) is export {
    SAT::Counter::DSHARP.new.count(|c)
}

=begin pod

=head1 AUTHOR

Tobias Boege <tboege@ovgu.de>

=head1 COPYRIGHT AND LICENSE

Copyright 2018 Tobias Boege

This library is free software; you can redistribute it and/or modify it
under the Artistic License 2.0.

=end pod
