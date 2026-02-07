# NAME

Flat::Profile - Streaming-first profiling for CSV/TSV flat files

# DESCRIPTION

Flat::Profile is part of the Flat::\* series and provides streaming-first profiling
for CSV/TSV inputs.

# METHODS

## profile\_file

Supports configurable null policies:

- null\_empty (default true): treat empty string as null
- null\_tokens (default empty): treat exact-matching tokens as null
