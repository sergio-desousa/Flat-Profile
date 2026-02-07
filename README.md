# Flat::Profile

Streaming-first profiling for CSV/TSV flat files (part of the Flat::* series).

Flat::Profile is designed for practical ETL workflows and large legacy data files:
it profiles data in a single pass and produces a structured report that can feed
schema inference and validation steps (Flat::Schema / Flat::Validate).

## Status

Early-stage, but usable. API and report format are stabilizing.

## Requirements

- Perl 5.32+
- `Text::CSV`

## Install

From CPAN (once released):

```bash
cpanm Flat::Profile
````

From source:

```bash
cpanm --installdeps .
prove -l
```

## Quickstart

### Streaming rows

```perl
use Flat::Profile;

my $p = Flat::Profile->new();

my $it = $p->iter_rows(
    path       => "data.csv",
    has_header => 1,
    delimiter  => ",",     # or "\t" for TSV
    encoding   => "UTF-8", # default
);

while (my $row = $it->next_row) {
    # $row is an arrayref: [$v0, $v1, ...]
}

my $header = $it->get_Header;     # arrayref or undef
my $nrows  = $it->get_Row_Index;  # data rows returned (header excluded)
```

### Profile a file

```perl
use Flat::Profile;

my $p = Flat::Profile->new();

my $report = $p->profile_file(
    path        => "data.csv",
    has_header  => 1,
    delimiter   => ",",
    null_empty  => 1,            # default: '' counts as null
    null_tokens => ["NULL","NA"],# optional exact-match null tokens
    example_cap => 10,           # max unique sample values per column
);

# $report is a hashref; see "Report format" below.
```

## Null semantics

By default, Flat::Profile treats **empty string** as null:

* `null_empty => 1` (default): `''` counts as null
* `null_empty => 0`: `''` counts as a value

You can also treat specific exact string tokens as null:

* `null_tokens => ["NULL", "N/A"]`

Notes:

* Token matching is **exact** in v1 (no trimming, case-sensitive).
* `undef` is always treated as null.

## Ragged rows (width mismatches)

Flat::Profile tracks short/long rows compared to an **expected width**:

* If `has_header => 1`, expected width is the header width.
* Otherwise, expected width is the first data row width.

Ragged samples record `row_number` using **data-row numbering**
(header excluded): the first data row is `row_number => 1`.

## Report format (v1)

`profile_file()` returns a hashref with stable top-level metadata:

* `report_version` (integer, currently `1`)
* `generated_at` (UTC timestamp string, e.g. `2026-02-07T12:34:56Z`)
* `perl_version` (numeric `$]`)
* `module_version` (string `$VERSION`)
* `path`, `delimiter`, `encoding`, `has_header`
* `null_empty`, `null_tokens`
* `rows` (data rows; header excluded)
* `header` (arrayref or undef)
* `expected_width`, `max_observed_width`
* `ragged` (short/long counts + examples)
* `columns` (arrayref of per-column stats)

Per-column fields include:

* `index`
* `count_values`
* `count_null`
* `count_nonnull`
* `min_length`, `max_length`
* `sample_values` (unique, capped by `example_cap`)

Example (abridged):

```perl
{
  report_version => 1,
  rows => 3,
  has_header => 1,
  header => ["h1","h2"],
  ragged => {
    short_rows => 1,
    long_rows  => 0,
    short_examples => [{ row_number => 2, width => 1 }],
  },
  columns => [
    { index => 0, count_values => 3, count_null => 0, min_length => 1, max_length => 3, sample_values => ["a","ccc"] },
    { index => 1, count_values => 2, count_null => 1, min_length => 2, max_length => 2, sample_values => ["dd"] },
  ],
}
```

## Author

Sergio de Sousa

For support and bug reports, please use GitHub Issues:
https://github.com/sergio-desousa/Flat-Profile/issues


## License

Perl 5 (Artistic/GPL dual).
