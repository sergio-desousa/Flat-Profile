# NAME

Flat::Profile - Streaming-first profiling for CSV/TSV flat files

# SYNOPSIS

    use Flat::Profile;

    my $profiler = Flat::Profile->new();

    my $report = $profiler->profile_file(
        path        => "data.csv",
        has_header  => 1,
        null_empty  => 1,   # default
        example_cap => 10,
    );

    my $it = $profiler->iter_rows(
        path       => "data.csv",
        has_header => 1,
        delimiter  => ",",
    );

    while (my $row = $it->next_row) {
        # $row is an arrayref: [$v0, $v1, ...]
    }

# DESCRIPTION

Flat::Profile is part of the Flat::\* series and provides streaming-first profiling
for CSV/TSV inputs.

This is early-stage code intended to support practical ETL workflows, with a focus
on predictable behavior for large files.

# METHODS

## new

Constructor.

## iter\_rows

Returns an iterator yielding row arrayrefs via `next_row()`.

Arguments:

- path (required)
- delimiter (optional): `,` or `\\t` (default `,`)
- has\_header (optional): boolean (default false)
- encoding (optional): Perl layer encoding name (default `UTF-8`)

## profile\_file

Profiles an input file in a single streaming pass and returns a hashref report
with per-column counts, lengths, and sample values.

Arguments (in addition to `iter_rows` arguments):

- example\_cap (optional): max unique sample values per column (default 10)
- null\_empty (optional): if true (default), empty string counts as null

# AUTHOR

Sergio de Sousa

# LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
