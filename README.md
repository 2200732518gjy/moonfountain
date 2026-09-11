# MoonFountain

An original pure MoonBit library for turning plain-text Fountain screenplays
into source-mapped scene and dialogue structures and useful rehearsal material.

Local development in progress; not yet published to GitHub or MoonCakes.
No runtime dependencies beyond MoonBit core. MIT licensed.

## Intended boundaries
Fountain 1.1 block syntax, visible fallback for ambiguous text, scene/cast/cue
analysis, safe HTML and structured JSON. Not a CommonMark parser, subtitle
converter, AI writer, production scheduler, PDF paginator or FDX importer.

## Local verification
`moon fmt --check`, `moon check --deny-warn`, `moon test`.
