# API and ownership

`parse(source)` returns `Document { source, elements, diagnostics, annotations }`.
It does not throw for grammar errors. `parse_with_limits` accepts positive limits
no larger than defaults. A refusal retains `source`, returns empty element and
annotation arrays and one FNT900. Check this before presenting analysis as valid.
`lint(doc)` copies parser findings and adds semantic findings without repairing input.

## Structures and indexing

- `source_lines`: exact `text` excluding terminator; `start`, `end`, `next` including
  boundary after terminator; one-based `number`. Empty source has one line;
  final newline creates a final empty line. `content()` strips an initial BOM only.
- `elements`: visible nonblank blocks in source order; line-level original ranges,
  no terminator in `end`. `text` is semantic/masked content, **not necessarily**
  `source[start:end]`. `detail` holds title key, scene number or cue extension.
- `annotations`: successful note/boneyard spans include delimiters in the original
  source; their `text` excludes delimiters. They are not visible body elements.
- `scenes`: one-based ordinal (different from optional string scene number), range
  through following blanks up to the next heading; includes hidden source content.
  Preamble is not a fabricated scene. `scene_at_line` returns 0 outside scenes.
- `turns`: cue, extension, dialogue, directions and ordered `parts`. Each part has
  `text`, `direction` and source `line`. Use parts to retain interleaved directions;
  concatenating the two convenience arrays would lose performance order.
- `dual_pairs`: only adjacent compatible turns. The right turn carries `dual=true`.
- `cast`: exact-name, first-appearance order, unique scene ordinals, turn count,
  spoken-line count, whitespace-token count. Preamble participation uses scene 0.
- `cue_sheet(doc, exact_name)`: target turns with preceding speech context inside
  the same scene. Both sides of a valid dual pair have `simultaneous=true`.
  Context can precede intervening action; it is not a stage-management trigger.

All offsets are original-string UTF-16 units, not bytes. All source line numbers
are one-based. Returned arrays are mutable MoonBit arrays; derived records are
computed snapshots, not automatically updated views. Treat parser documents as
read-only. Public record construction/mutation can violate invariants; analysis
functions expect a document created by this parser, not arbitrary adversarial records.
No internal shared/global document cache is used.

## Selecting and exporting

`extract_lines(doc, first, last)` uses inclusive one-based lines and includes
original terminators. `extract_scene(doc, ordinal)` uses one-based array order,
not `#number#`. `turn_source(doc, index)` uses a **zero-based** turn index.
Invalid ranges return None, not a silently clamped slice. `scenes_for_role`
selects parsed scenes for the exact role and does not synthesize preamble scenes.
These raw extractors are **not redacted**, even when a rendered view hides notes.

`inline_text` exposes bounded emphasis tokens; `plain_text` removes recognized
markup only. `inline_html` escapes all text. `render_html(doc, outline=false)`
omits Section/Synopsis by default; true includes them. JSON's privacy and stable
schema are documented in JSON.md. `command` implements host-independent dispatch;
its result has stdout, stderr and status, without doing I/O itself.
