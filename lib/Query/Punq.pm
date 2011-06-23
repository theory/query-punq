package Query::Punq;

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

David E. Wheeler <david@justatheory.com>

=head1 Copyright and License

Copyright (c) 2006-2011 David E. Wheeler. Some Rights Reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
