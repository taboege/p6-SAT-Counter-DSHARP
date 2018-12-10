unit class SAT::Counter::dsharp is export;

multi method count (IO::Path $file --> Promise) {
    self.count: $file.lines
}

multi method count (Str $DIMACS --> Promise) {
    self.count: $DIMACS.lines
}

# Is there any way to shorten this? List, Seq and Supply are the
# same in that I just want to iterate over them.

multi method count (List $lines --> Promise) {
    self.count: $lines.Supply
}

multi method count (Seq $lines --> Promise) {
    self.count: $lines.Supply
}

multi method count (Supply $lines --> Promise) {
    my $out;
    with my $proc = Proc::Async.new: :w, %?RESOURCES<dsharp>, '-q' {
        $out = .stdout;
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

=begin pod

=head1 NAME

SAT::Counter::dsharp - #SAT solver dsharp

=head1 SYNOPSIS

    use SAT::Counter::dsharp;
    
    say await dsharp.new.count($my-cnf-file.IO)

=head1 DESCRIPTION

SAT::Counter::dsharp wraps the C<dsharp> executable (bundled with the module)
used to count the satisfying assignments of a Boolean formula in the
C<DIMACS cnf> format, i.e. the C<#SAT> problem associated to the formula.

Given a DIMACS cnf problem, it starts C<dsharp>, feeds it the problem and
returns a Promise which is kept with the C<#SAT> solution found or broken on
error.

=head1 AUTHOR

Tobias Boege <tboege@ovgu.de>

=head1 COPYRIGHT AND LICENSE

Copyright 2018 Tobias Boege

This library is free software; you can redistribute it and/or modify it
under the Artistic License 2.0.

=end pod
