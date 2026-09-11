# Provenance and dependencies

## Original material

MoonFountain parser, models, algorithms, output implementation, tests, synthetic
screenplays, CSS and documentation are original work for this repository, with AI
assistance disclosed in AI_USAGE.md. No screenplay source code or test corpus was
copied from another parser. No real film scripts or third-party images/fonts are
bundled. The repository's original code is licensed under MIT (LICENSE).

## References, not copied implementation

- Fountain syntax specification: https://fountain.io/syntax/ (consulted 2026-09-11).
  Used to understand screenplay notation, not copied as implementation or republished
  manual. Fountain is an open screenplay format; this is an independent partial
  implementation, with no endorsement or complete-conformance claim. We do not
  relicense the external website under this repository's MIT license.
- MoonBit official language/core/toolchain documentation: https://docs.moonbitlang.com/
  and https://github.com/moonbitlang/core . Used for language/API usage.
- Adjacent MoonBit packages were inspected for duplication, not imported/copied;
  names, versions, URLs, inspection depth and limitations are in the competition
  duplication report. Raw retained JSON metadata is factual research evidence,
  not a distribution of those projects' source code.

## Runtime and build tools

| Component | Use | License / handling |
|---|---|---|
| moonbitlang/core | Compiler-provided String/Array/Map/Json and env; sole library dependency | Apache-2.0; checked installed core/LICENSE and https://github.com/moonbitlang/core/blob/main/LICENSE; not vendored |
| Node.js | JS CLI runtime; node:fs, node:child_process etc in smoke harness | Node.js MIT plus bundled component notices: https://github.com/nodejs/node/blob/main/LICENSE; runtime not redistributed |
| Python | Verification script only; standard library | PSF license; interpreter not redistributed |
| actions/checkout, actions/setup-node | Hosted CI tooling | MIT, upstream action repositories; pinned commit refs in workflow, not vendored |
| MoonBit toolchain | Compile/test/format | Distributed separately by its publisher; toolchain terms are not replaced by project MIT |

Distributing compiled bundles may incorporate runtime code and require preserving
its notices; this release distributes source only. Review exact runtime
licenses/notices before attaching binaries to any Release. Package publication
and hosting are not implied by this dependency inventory.
