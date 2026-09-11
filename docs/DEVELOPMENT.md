# Development and acceptance plan

Read duplication evidence before changing the project's central scope.
This project begins with a clean independent repository, never inherited history.

Independently reviewable milestones (each implementation slice includes tests):
1. Module, license, scope and acceptance scaffold.
2. Lossless UTF-16 source-line indexing across LF/CRLF/CR and BOM.
3. Scene/action parsing with forced syntax and scene numbers.
4. Title-page key/value continuation parsing.
5. Character cues, dialogue and parenthetical state.
6. Outline sections, synopses, lyrics, transitions and centered text.
7. Boneyard and note filtering with bounded malformed recovery.
8. Dual-dialogue adjacency and group semantics.
9. Escaped inline emphasis tokens and literal fallback.
10. Scene assembly and stable cast membership.
11. Per-character dialogue accounting.
12. Rehearsal cue sheets with preceding speaker context.
13. Semantic diagnostics for duplicate numbers and malformed cues.
14. Safe HTML preview with semantic markup.
15. Structured JSON export and schema contract.
16. Executable stdin/file CLI with explicit failures.
17. Exact source extraction and scene selection.
18. Resource budgets and adversarial/property regression suite.
19. Runnable original acceptance fixtures and cross-target automation.
20. API/tutorial/support/security/release documentation and audited handoff.

MoonBit is the implementation language. JS, Python and shell are allowed only
for host I/O, build/test automation and evidence, not screenplay semantics.
Source offsets are UTF-16 code units, half-open. Line numbers are one-based.
The parser preserves original input and never silently drops malformed text.
All examples are synthetic original scripts. Public API names can evolve until
0.1.0; support gaps must be documented rather than advertised as compliance.
