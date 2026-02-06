# NAME

Flat::Profile - Streaming-first profiling for CSV/TSV flat files

# SYNOPSIS

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

# DESCRIPTION

Flat::Profile is part of the Flat::\* series. It will provide streaming-first
profiling for CSV/TSV inputs and produce a structured report suitable for
schema inference and validation workflows.

This distribution is under active development.

# METHODS

## iter\_rows

Named arguments:

- path (required)
- delimiter (optional): `,` or `\\t` (default `,`)
- has\_header (optional): boolean (default false)
- encoding (optional): Perl layer encoding name (default `UTF-8`)
