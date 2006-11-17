package Query::Punq;

# $Id: Punq.pm 1932 2005-08-08 17:17:03Z theory $

use strict;
use vars qw($VERSION);

$VERSION = '0.01';

sub import {
    my $caller = caller;
    no strict 'refs';
    return if defined &{"$caller\::where"};
    *{"$caller\::where"} = \&where;
}

my $q = Query::Punq::Overload->new;

sub where (&) {
    no strict 'refs';
    local *{caller() . '::AUTOLOAD'} = \&Query::Punq::Overload::AUTOLOAD;
    local $_ = $q;
    shift->();
    return $q->clear;
}

package Query::Punq::Overload;
use strict;

use overload
    # Numeric comparison
    '<'    => \&_nlt,
    '<='   => \&_nle,
    '>'    => \&_ngt,
    '>='   => \&_nge,
    '=='   => \&_neq,
    '!='   => \&_nne,

    # String comparison
    'lt'   => \&_lt,
    'le'   => \&_le,
    'gt'   => \&_gt,
    'ge'   => \&_ge,
    'eq'   => \&_eq,
    'ne'   => \&_ne,

    # Conjunction and Disjunction.
    '&'    => \&_and,
    '|'    => \&_or,
;

sub new { bless {} }

sub AUTOLOAD {
    our $AUTOLOAD;
    ($_->{attr} = $AUTOLOAD) =~ s/.+:://;
    return $_;
}

sub is { shift }

sub clear {
    my $self = shift;
    delete @{$self}{qw(op attr)};
    return unless exists $self->{expr};
    return @{ delete $self->{expr} };
}

# Set up comparison operators.
for (
    # Numeric comparison
    [ nlt => '<'  ],
    [ nle => '<=' ],
    [ ngt => '>'  ],
    [ nge => '>=' ],
    [ neq => '==' ],
    [ nne => '!=' ],

    # String comparison
    [ lt =>  'lt' ],
    [ le =>  'le' ],
    [ gt =>  'gt' ],
    [ ge =>  'ge' ],
    [ eq =>  'eq' ],
    [ ne =>  'ne' ],
) {
    my ($meth, $op, $revop) = @{ $_ };
    no strict 'refs';
    *{"_$meth"} = sub {
        my ($self, $val, $rev) = @_;
        push @{ $self->{expr} } => [
            delete $self->{op},
            $rev ? ( $val, $op, delete $self->{attr})
                : ( delete $self->{attr}, $op, $val )
            ];
        return $self;
    };
}

sub _or {
    my ($self, $val) = @_;
    push @{ $self->{expr}[-1] }, 'OR';
    return $self;
}

sub _and {
    my ($self, $val, $reversed) = @_;
    push @{ $self->{expr}[-1] }, 'AND';
    return $self;
}

for my $meth (qw(length hex lc uc)) {
    no strict 'refs';
    *{$meth} = sub {
        my $self = shift;
        $self->{op} = $meth;
        return $self;
    };
}


1;
__END__

##############################################################################

=begin comment

Fake-out Module::Build. Delete if it ever changes to support =head1 headers
other than all uppercase.

=head1 NAME

Query::Punq - Perl's Unique Query language

=end comment

=head1 Name

Query::Punq - Perl's Unique Query language

=head1 Synopsis

    use Query::Punq;



=head1 Description



=back

=head1 See Also

=over

=item L<SQL::Abstract|SQL::Abstract>



=back

=head1 Bugs

Please send bug reports to <bug-query-punq@rt.cpan.org>.

=head1 Author

=begin comment

Fake-out Module::Build. Delete if it ever changes to support =head1 headers
other than all uppercase.

=head1 AUTHOR

=end comment

David Wheeler <david@kineticode.com>

=head1 Copyright and License

Copyright (c) 2006 Kineticode, Inc. All Rights Reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut