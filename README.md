[![Actions Status](https://github.com/sergio-desousa/Flat-Profile/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/sergio-desousa/Flat-Profile/actions?workflow=test)
# NAME

Flat::Profile - Streaming-first profiling for CSV/TSV flat files

# SYNOPSIS

    use Flat::Profile;

    my $profiler = Flat::Profile->new();

    # Planned API:
    # my $report   = $profiler->profile_file(path => "data.csv", has_header => 1);
    my $iterator = $profiler->iter_rows(path => "data.csv", has_header => 1);

    while (my $row = $iterator->next_row()) {
        # $row is an arrayref: [$v0, $v1, ...]
    }

# DESCRIPTION

Flat::Profile is part of the Flat::\* series. It will provide streaming-first
profiling for CSV/TSV inputs and produce a structured report suitable for
schema inference and validation workflows.

This distribution is under active development.

# METHODS

## new

    my $profiler = Flat::Profile->new(%opts);

Constructor. Options are reserved for future use.

## profile\_file

Planned: profile an input file/stream and return a structured report.

## iter\_rows

    my $iterator = $profiler->iter_rows(%args);

Returns an iterator object that yields parsed row arrayrefs via `next_row()`.

# AUTHOR

Sergio de Sousa

# LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
