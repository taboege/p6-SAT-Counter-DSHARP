NAME
====

SAT::Counter::DSHARP - #SAT solver DSHARP

SYNOPSIS
========

``` perl6
use SAT::Counter::DSHARP;

say dsharp 't/gaussoids-4.cnf', :now;
#= 679
say dsharp 't/bmc-ibm-2.cnf', :now;
#= 13330654897016668160
```

DESCRIPTION
===========

SAT::Counter::DSHARP wraps the `dsharp` executable (bundled with the module) used to count the satisfying assignments of a Boolean formula in the `DIMACS cnf` format, i.e. the `#SAT` problem associated to the formula.

Given a DIMACS cnf problem, it starts `dsharp`, feeds it the problem and returns a Promise which is kept with the `#SAT` solution found or broken on error.

AUTHOR
======

Tobias Boege <tboege ☂ ovgu ☇ de>

COPYRIGHT AND LICENSE
=====================

Copyright 2018 Tobias Boege

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

