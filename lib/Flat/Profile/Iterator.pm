package Flat::Profile::Iterator;

use strict;
use warnings;

sub new {
    my ($class, %opts) = @_;

    my $self = bless {
        _opts => { %opts },
    }, $class;

    return $self;
}

sub next_row {
    my ($self) = @_;

    # Iterator skeleton: real parsing/streaming will be added later.
    return undef;
}

1;
