# Why a small domain parser

A CommonMark tree cannot establish screenplay-specific cue/dialogue context.
A regex-only pass also loses whether a line follows a cue or begins a new block.
We chose a bounded line-state parser with a separate annotation masking pass,
then explicit derived records. The implementation is original MoonBit; no foreign
screenplay engine is hidden behind FFI.

1. Resource validation rejects oversized input before parsing. Raw source is kept.
2. Annotation masking preserves every UTF-16 position and newline. Successful
   notes move to a separate source-mapped collection; failed openers stay visible.
3. Title detection runs once. Body precedence is dialogue continuation, forced
   action, scene heading, special block, character cue, then action fallback.
4. Turn assembly retains ordered speech/directions; adjacency checks constrain dual
   pairs. Scene ranges derive from heading boundaries, never guessed time/location.
5. Scene/cast/cue/extraction are separate transformations, not mutable parser state.
6. Export escapes text and defaults to omitting raw source/annotation bodies.
   CLI command dispatch is MoonBit; JavaScript only reads bytes and writes results.

Invariants: ranges address the original text; visible element order is monotonic;
malformed text is not silently erased; scene boundaries reset rehearsal context;
role identity is exact; derived outputs do not mutate their input. Refusal is
explicit, not a successful empty report.

Costs: source indexing and body traversal are linear. Annotation delimiter search
has an explicit total scan budget. Inline parsing has a small length/depth cap.
Scene membership deduplication and repeated derived reports can be superlinear
for pathological many-role scripts; we **do not claim globally linear complexity**
or hard wall-clock guarantees. Whole input and output strings are materialized.
Hosts accepting untrusted traffic must impose additional request, concurrency,
wall-time and output limits. No network/server layer is included.

Tests combine focused positive/negative grammar cases, Unicode/line-ending/range
invariants, malformed/oversized adversarial inputs, regression cases for direction
order and deliberate whitespace, plus independent JSON parsing and actual CLI
subprocesses. No external corpus or snapshot updater can silently bless output.
