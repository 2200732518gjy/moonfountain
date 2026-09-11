# JSON report schema v1

`report_json(document, include_source=false)` emits one object:
- `schema_version`: integer 1; `offset_unit`: `utf16`.
- `elements`: source-order records with `kind`, `text`, one-based `line`,
  half-open `start`/`end`, `detail`, `level`, `dual`. Kind labels are lower-case
  strings, not compiler-specific enum serializations.
- `scenes`, `cast`, `turns`: the public record arrays documented in the generated
  interface. Scene 0 in cast/cues means preamble, not an inferred location.
- `diagnostics`: stable code, line, human-readable message; order is parser
  findings, then source-order semantic findings, then turn-level findings.
- `annotation_count`: count of hidden notes/boneyards.
- `source` and `annotations`: null by default. Explicit `include_source=true`
  includes original text and annotations; never use it for a public redacted view.

Parsed visible content and title contact fields are still present by default.
This privacy default is not a general PII scrubber. Arrays preserve source or
first-appearance order; clients must ignore unknown future object fields.
Offsets address the original string, including BOM and original line endings;
they are not UTF-8 byte offsets or display columns.
