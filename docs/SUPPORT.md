# Supported grammar and deliberate limits

This is a tested Fountain-inspired 1.1 subset, **not a complete conformance claim**.

| Area | Implemented | Boundary / fallback |
|---|---|---|
| Source | UTF-16 ranges, BOM, LF/CRLF/CR, non-BMP text | Not byte offsets, visual columns or editable CST |
| Titles | Recognized first key, lower-case keys, repeated/custom later keys, 3-space/tab continuations | First blank ends title; custom first key is ordinary action; keys ASCII letters/spaces/hyphens |
| Scenes | Blank-delimited INT/EXT/EST/INT./EXT/INT/EXT/I/E prefixes; single-dot forcing; alnum/dot/hyphen numbers | Single-dot accepts any following non-dot/non-space/tab character (broader than specification); no location/time normalization |
| Action | Default unclassified line, `!` forced action | One element per line, not paragraph merging |
| Characters | Blank-before cue, nonblank next line; uppercase ASCII automatic names; `@` forcing; extensions | Non-Latin/lowercase names use `@`; exact-case identity; no aliases or empty forced cues |
| Dialogue | Continues to blank line; `(whole-line direction)`; exactly two ASCII spaces preserve an empty spoken line | Other blank indentation ends turn; marker-looking lines within a turn remain dialogue, including lyrics |
| Dual | Trailing `^` on adjacent second spoken turn, extensions supported | No chaining, crossing action, columns or pagination; orphan cue diagnosed and remains ordinary |
| Blocks | `#` levels, `=` synopsis, 3+ `=` pagebreak, `~` lyrics, `>center<`, `>` transition | Automatic uppercase TO: needs blank boundaries and no trailing space; no rich outline tree |
| Notes | `[[...]]` until blank line; boneyards `/*...*/` across lines; non-nested | First closer wins; immediately preceding backslash escapes opener, no slash-parity grammar |
| Emphasis | 1/2/3-star emphasis, underscore, bounded nesting, backslash escapes | Not CommonMark; whitespace-edge/4-star/unmatched delimiters literal; max depth 16, input 8192 units |
| Output | JSON v1, safe static HTML, cast/scenes, role cues and exact extracts | No exact screenplay pagination, FDX/PDF, SRT/VTT, editor or writing generation |

Title fields, visible text and diagnostics may reveal information even in default
exports. Malformed notes remain **visible**, deliberately preventing silent data
loss; this parser must not be used as a secrecy filter. Annotation searches have
an operation budget (4 × source units + 16); after exhaustion remaining annotation
text remains visible. Default parse ceilings: 262144 UTF-16 units, 20000 source
lines (including trailing empty line), 8192 units per line.

Token totals count ASCII space/tab/newline/CR and U+3000-separated runs after
recognized emphasis removal. They are not linguistic word counts: unspaced Chinese
may be one token; NBSP is not a separator. Empty intentional dialogue lines count
as spoken lines but contribute zero tokens. No duration inference is provided.

## Diagnostics

Codes are stable; explanatory message text is not a machine contract.

| Code | Meaning | Recovery |
|---|---|---|
| FNT001 | Unclosed note | Retain visible text |
| FNT002 | Unclosed boneyard | Retain visible text |
| FNT003 | Invalid dual adjacency | Ordinary turn |
| FNT004 | Annotation search budget exhausted | Remaining text visible |
| FNT101 | Duplicate scene number | Preserve both; do not renumber |
| FNT102 | Malformed trailing scene number | Preserve heading |
| FNT103 | Case-distinct role resembles another | Preserve distinct identities |
| FNT104 | Unclosed parenthetical | Keep dialogue |
| FNT105 | Isolated/empty forced character cue | Keep action |
| FNT106 | Turn has directions but no dialogue | Keep turn |
| FNT900 | Invalid limits or input over budget | No partial parse; original source retained |

CLI lint returns 1 for findings (except FNT900 refusal returns 2); other output
modes require separate lint gating. `parse` reports syntactic findings only;
`lint` appends semantic findings. Unknown role in CLI cues returns 2; library
cue_sheet returns an empty array. No severity ranking is invented.
