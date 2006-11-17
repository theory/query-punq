#!/usr/bin/perl -w

# $Id: base.t 1930 2005-08-08 15:58:16Z theory $

use strict;
#use Test::More tests => 1;
use Test::More 'no_plan';

BEGIN { use_ok 'Query::Punq' or die }

ok defined &where, 'where() should be imported';
