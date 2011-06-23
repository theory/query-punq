Query/Punq version 0.01
=======================

This module contains some experiments I was performing to try to come up with
a natural way to write queries in Perl that would translate to SQL. I now
consider this a bad idea, because, well, there's nothing wrong with SQL. But
it was kind of fun to mess around with, and one might find some decent ideas
in it. More likely, though, you should just look at
[Devel::Declare](http://search.cpan.org/perldoc?Devel::Declare), which came
out of Matt Trout wanting to achieve the same kind of thing.

Installation
------------

To install this module, type the following:

    perl Build.PL
    ./Build
    ./Build test
    ./Build install

Dependencies
------------

This module requires no modules or libraries not already included with Perl.

Copyright and License
---------------------

Copyright (c) 2006-2011, David E. Wheeler. Some Rights Reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
