package Flat::Profile;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(croak);

sub new {
    my ($class, %opts) = @_;

    my $self = bless {
        _opts => { %opts },
    }, $class;

    return $self;
}

sub profile_file {
    my ($self, %args) = @_;

    # v1 implementation will be streaming-first and return a structured report.
    # For now, this is an API stub.
    croak "profile_file() is not implemented yet";
}

sub iter_rows {
    my ($self, %args) = @_;

    # v1 implementation will return an iterator object with next_row().
    # For now, this is an API stub.
    croak "iter_rows() is not implemented yet";
}

1;

__END__

=pod

=head1 NAME

Flat::Profile - Streaming-first profiling for CSV/TSV flat files

=head1 SYNOPSIS

  use Flat::Profile;

  my $profiler = Flat::Profile->new();

  # Planned API (not implemented yet):
  # my $report   = $profiler->profile_file(path => "data.csv", has_header => 1);
  # my $iterator = $profiler->iter_rows(path => "data.csv", has_header => 1);

=head1 DESCRIPTION

Flat::Profile is part of the Flat::* series. It will provide streaming-first
profiling for CSV/TSV inputs and produce a structured report suitable for
schema inference and validation workflows.

This distribution is under active development.

=head1 METHODS

=head2 new

  my $profiler = Flat::Profile->new(%opts);

Constructor. Options are reserved for future use.

=head2 profile_file

Planned: profile an input file/stream and return a structured report.

=head2 iter_rows

Planned: return an iterator object that yields parsed row arrayrefs via
C<next_row()>.

=head1 AUTHOR

Sergio de Sousa

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
