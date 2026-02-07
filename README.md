# NAME

Flat::Profile - Streaming-first profiling for CSV/TSV flat files

# SYNOPSIS

    use Flat::Profile;

    my $profiler = Flat::Profile->new();

    my $report = $profiler->profile_file(
        path        => "data.csv",
        has_header  => 1,
        null_empty  => 1,
        example_cap => 10,
    );

# DESCRIPTION

Flat::Profile is part of the Flat::\* series and provides streaming-first profiling
for CSV/TSV inputs.

# METHODS

## profile\_file

Profiles an input file in a single streaming pass and returns a hashref report.

Adds `ragged` diagnostics for short/long rows compared to the expected width.

## iter\_rows

Returns an iterator yielding row arrayrefs via `next_row()`.

# AUTHOR

Sergio de Sousa

# LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
