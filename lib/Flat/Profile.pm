package Flat::Profile;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp qw(croak);

use Flat::Profile::Iterator;

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

    if (!exists $args{path}) {
        croak "iter_rows() requires named argument: path";
    }

    my $path = $args{path};

    my $delimiter = exists $args{delimiter} ? $args{delimiter} : ",";
    if ($delimiter ne "," && $delimiter ne "\t") {
        croak "iter_rows() delimiter must be ',' or \"\\t\"";
    }

    my $has_header = $args{has_header} ? 1 : 0;

    my $encoding = exists $args{encoding} ? $args{encoding} : "UTF-8";

    open my $fh, "<:encoding($encoding)", $path
        or croak "Failed to open '$path' for reading: $!";

    return Flat::Profile::Iterator->new(
        fh         => $fh,
        delimiter  => $delimiter,
        has_header => $has_header,
    );
}

1;

__END__

=pod

=head1 NAME

Flat::Profile - Streaming-first profiling for CSV/TSV flat files

=head1 SYNOPSIS

  use Flat::Profile;

  my $profiler = Flat::Profile->new();

  my $it = $profiler->iter_rows(
      path       => "data.csv",
      has_header => 1,
      delimiter  => ",",
      encoding   => "UTF-8",
  );

  while (my $row = $it->next_row) {
      # $row is an arrayref: [$v0, $v1, ...]
  }

=head1 DESCRIPTION

Flat::Profile is part of the Flat::* series. It will provide streaming-first
profiling for CSV/TSV inputs and produce a structured report suitable for
schema inference and validation workflows.

This distribution is under active development.

=head1 METHODS

=head2 iter_rows

Named arguments:

=over 4

=item * path (required)

=item * delimiter (optional): C<,> or C<\\t> (default C<,>)

=item * has_header (optional): boolean (default false)

=item * encoding (optional): Perl layer encoding name (default C<UTF-8>)

=back

=cut
