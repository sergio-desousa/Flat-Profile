# NAME

Flat::Profile - Streaming-first profiling for CSV/TSV flat files

# DESCRIPTION

Flat::Profile is part of the Flat::\* series and provides streaming-first profiling
for CSV/TSV inputs.

# REPORT FORMAT

The return value of `profile_file()` is a hashref with stable top-level metadata:

- report\_version (integer)
- generated\_at (UTC timestamp string)
- perl\_version (numeric `$]`)
- module\_version (string `$VERSION`)

# METHODS

## profile\_file

Supports configurable null policies:

- null\_empty (default true): treat empty string as null
- null\_tokens (default empty): treat exact-matching tokens as null
