# NAME

Flat::Profile - Streaming-first profiling for CSV/TSV flat files

# SYNOPSIS

    use Flat::Profile;

    my $profiler = Flat::Profile->new();

    my $report = $profiler->profile_file(
        path       => "data.csv",
        has_header => 1,
    );

    my $it = $profiler->iter_rows(
        path       => "data.csv",
        has_header => 1,
    );

# DESCRIPTION

Flat::Profile is part of the Flat::\* series.

# METHODS

## profile\_file

Profiles an input file in a single streaming pass and returns a hashref report.

Named arguments:

- path (required)
- delimiter (optional): `,` or `\\t` (default `,`)
- has\_header (optional): boolean (default false)
- encoding (optional): Perl layer encoding name (default `UTF-8`)
- example\_cap (optional): max unique sample values per column (default 10)

## iter\_rows

Returns an iterator object that yields parsed row arrayrefs via `next_row()`.
