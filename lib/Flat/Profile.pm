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

    if (!exists $args{path}) {
        croak "profile_file() requires named argument: path";
    }

    my $path = $args{path};

    my $delimiter = exists $args{delimiter} ? $args{delimiter} : ",";
    if ($delimiter ne "," && $delimiter ne "\t") {
        croak "profile_file() delimiter must be ',' or \"\\t\"";
    }

    my $has_header = $args{has_header} ? 1 : 0;

    my $encoding = exists $args{encoding} ? $args{encoding} : "UTF-8";

    my $example_cap = exists $args{example_cap} ? $args{example_cap} : 10;
    if ($example_cap !~ /^\d+$/ || $example_cap < 0) {
        croak "profile_file() example_cap must be an integer >= 0";
    }

    my $null_empty = exists $args{null_empty} ? ($args{null_empty} ? 1 : 0) : 1;

    my $null_tokens = exists $args{null_tokens} ? $args{null_tokens} : [];
    if (ref($null_tokens) ne 'ARRAY') {
        croak "profile_file() null_tokens must be an arrayref";
    }

    my %null_token_map;
    for my $tok (@{$null_tokens}) {
        if (!defined $tok) {
            croak "profile_file() null_tokens must not contain undef";
        }
        $null_token_map{$tok} = 1;
    }

    open my $fh, "<:encoding($encoding)", $path
        or croak "Failed to open '$path' for reading: $!";

    my $it = Flat::Profile::Iterator->new(
        fh         => $fh,
        delimiter  => $delimiter,
        has_header => $has_header,
    );

    my $generated_at = _format_utc_timestamp();

    my %report = (
        report_version => 1,

        generated_at   => $generated_at,
        perl_version   => $],
        module_version => $VERSION,

        path        => $path,
        delimiter   => $delimiter,
        encoding    => $encoding,
        has_header  => $has_header ? 1 : 0,
        null_empty  => $null_empty ? 1 : 0,
        null_tokens => [ @{$null_tokens} ],
        header      => undef,

        rows        => 0,
        columns     => [],

        expected_width     => undef,
        max_observed_width => 0,
        ragged => {
            short_rows => 0,
            long_rows  => 0,
            short_examples => [],
            long_examples  => [],
            example_cap    => 10,
        },
    );

    my $ragged_example_cap = 10;
    my $header_captured = 0;

    while (my $row = $it->next_row) {
        $report{rows}++;

        if ($has_header && !$header_captured) {
            $report{header} = $it->get_Header;
            $header_captured = 1;

            if (defined $report{header}) {
                $report{expected_width} = scalar @{$report{header}};
            }
        }

        my $width = scalar @{$row};
        if ($width > $report{max_observed_width}) {
            $report{max_observed_width} = $width;
        }

        if (!defined $report{expected_width}) {
            $report{expected_width} = $width;
        }

        if (defined $report{expected_width}) {
            if ($width < $report{expected_width}) {
                $report{ragged}{short_rows}++;

                if (@{$report{ragged}{short_examples}} < $ragged_example_cap) {
                    push @{$report{ragged}{short_examples}}, {
                        row_number => $report{rows},
                        width      => $width,
                    };
                }
            }
            elsif ($width > $report{expected_width}) {
                $report{ragged}{long_rows}++;

                if (@{$report{ragged}{long_examples}} < $ragged_example_cap) {
                    push @{$report{ragged}{long_examples}}, {
                        row_number => $report{rows},
                        width      => $width,
                    };
                }
            }
        }

        my $num_cols = $width;

        for (my $i = 0; $i < $num_cols; $i++) {
            my $value = $row->[$i];

            my $col = $report{columns}->[$i];
            if (!defined $col) {
                $col = {
                    index         => $i,
                    count_values  => 0,
                    count_null    => 0,
                    count_nonnull => 0,
                    min_length    => undef,
                    max_length    => undef,
                    sample_values => [],
                    _sample_seen  => {},
                };
                $report{columns}->[$i] = $col;
            }

            $col->{count_values}++;

            my $is_null =
                !defined $value
                || ($null_empty && defined $value && $value eq '')
                || (defined $value && $null_token_map{$value});

            if ($is_null) {
                $col->{count_null}++;
                next;
            }

            $col->{count_nonnull}++;

            my $len = length($value);

            if (!defined $col->{min_length} || $len < $col->{min_length}) {
                $col->{min_length} = $len;
            }
            if (!defined $col->{max_length} || $len > $col->{max_length}) {
                $col->{max_length} = $len;
            }

            if ($example_cap > 0) {
                if (@{$col->{sample_values}} < $example_cap) {
                    if (!$col->{_sample_seen}{$value}) {
                        push @{$col->{sample_values}}, $value;
                        $col->{_sample_seen}{$value} = 1;
                    }
                }
            }
        }
    }

    for my $col (@{$report{columns}}) {
        next if !defined $col;
        delete $col->{_sample_seen};
    }

    $report{ragged}{example_cap} = $ragged_example_cap;

    return \%report;
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

sub _format_utc_timestamp {
    my @t = gmtime(time());
    my $year = $t[5] + 1900;
    my $mon  = $t[4] + 1;
    my $day  = $t[3];
    my $hour = $t[2];
    my $min  = $t[1];
    my $sec  = $t[0];

    return sprintf("%04d-%02d-%02dT%02d:%02d:%02dZ", $year, $mon, $day, $hour, $min, $sec);
}

1;

__END__

=pod

=head1 NAME

Flat::Profile - Streaming-first profiling for CSV/TSV flat files

=head1 DESCRIPTION

Flat::Profile is part of the Flat::* series and provides streaming-first profiling
for CSV/TSV inputs.

=head1 REPORT FORMAT

The return value of C<profile_file()> is a hashref with stable top-level metadata:

=over 4

=item * report_version (integer)

=item * generated_at (UTC timestamp string)

=item * perl_version (numeric C<$]>)

=item * module_version (string C<$VERSION>)

=back

=head1 METHODS

=head2 profile_file

Supports configurable null policies:

=over 4

=item * null_empty (default true): treat empty string as null

=item * null_tokens (default empty): treat exact-matching tokens as null

=back

=cut
