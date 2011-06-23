#!/usr/bin/perl -w

use strict;
#use Test::More tests => 1;
use Test::More 'no_plan';

BEGIN { use_ok 'Query::Punq' or die }

ok defined &where, 'where() should be imported';
