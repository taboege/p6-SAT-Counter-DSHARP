unit class Build;

method build (IO() $dist-path) {
    my $make = $*VM.config<make>;
    my $src = $dist-path.add("src");
    my $res = $dist-path.add("resources");
    $res.mkdir;

    my $dsharp = $src.add("dsharp");
    my $solver = 'dsharp';
    say "Building $solver with gmp support...";
    run $make, '-C', ~$dsharp, 'GMP=1', 'DEBUG=';
    say "Copying $solver to resources";
    copy $dsharp.add($solver), $res.add($solver);
    True
}

# vim: ft=perl6
