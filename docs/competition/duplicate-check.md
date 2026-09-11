# MoonFountain duplication review — 2026-09-11

## Scope and procedure
Original MoonBit Fountain 1.1 screenplay structure parser and rehearsal breakdown library: source lines -> screenplay elements -> scenes/dialogue turns -> cast and cue sheets. The participant explicitly authorized autonomous selection from zero. The installed `$osc2026-guide` Project Research Guide was read and applied; September rules come from the builder's fixed reference, not the August charter.

`moon search fountain --limit 10` fails on moon 0.1.20260713: no such subcommand. Direct live MoonCakes API requests replace it: `https://mooncakes.io/api/v0/search?kw=TERM&limit=100`. Queries: fountain, screenplay, scriptwriting, screenwriting, dialogue, subtitle, markdown, dbf, dbase, embroidery, dst. Raw responses are in evidence. GitHub repository searches `fountain language:MoonBit` and `screenplay moonbit` returned zero. The general web-search tool produced no usable result, NOT evidence of absence. API fuzzy matches and maximum-100 result caps limit completeness. This is a scoped check, not organizer acceptance or proof that no private/unindexed implementation exists.

## Candidate comparison and existing identity boundaries
| Candidate | Primary workflow and core data | Decision |
|---|---|---|
| MoonFountain | Screenplay cues, scene headings, dialogue/parenthetical groups -> rehearsal/cast outputs | Select: domain/workflow/data distinct from the complete registry snapshot read before selection |
| dBase/DBF toolkit | Fixed-width table records -> schema/value decoding | Not selected; initial names checked only, no completed independent duplication gate |
| Embroidery DST toolkit | Stitch deltas and machine commands -> stitch paths | Not selected; initial names checked only; adjacent to machine-path MoonGCode and fabric MoonWeave |

The complete permanent registry snapshot was read and compared by domain, workflow, core data, algorithms, outputs, users and boundaries. Shared parsing/testing/CLI techniques are not project identity. Do not build Markdown/CommonMark, SRT/VTT, text search, generic source-preserving configuration editing, media transport analysis or AI production orchestration as this project's center.

## Adjacent primary projects inspected
| Package/version | Repository / published page | Maintenance and inspected boundary |
|---|---|---|
| mizchi/markdown 0.8.3 | https://github.com/mizchi/markdown.mbt ; https://mooncakes.io/docs/mizchi/markdown | MIT; pushed 2026-08-30. README/source-facing API reviewed: CommonMark/GFM CST and incremental HTML; does not establish Fountain scene/character/dialogue grammar. Fountain is not a Markdown dialect that its CommonMark parser can simply enable. No general Markdown implementation will be copied. |
| MaoDingA/moonpost 0.2.1 | https://github.com/MaoDingA/moonbitpostqc ; https://mooncakes.io/docs/MaoDingA/moonpost | Public API/package summaries and complete source-tree paths inspected; pushed 2026-07-07. Subtitle/timecode/delivery QC, not screenplay cues. SRT/VTT excluded. |
| vectie/mooncast | https://github.com/vectie/mooncast ; https://mooncakes.io/docs/vectie/mooncast | Root generated API and complete non-truncated tree inspected; pushed 2026-09-04. Rights-aware AIGC/workspace graph, production gates, artifacts and dispatch; not a Fountain text parser. No orchestration, generation or rights system built here. |
| ZSeanYves/markitdown 0.5.3 | https://github.com/ZSeanYves/markitdown ; https://mooncakes.io/docs/ZSeanYves/markitdown | Metadata/README and published subtitle API summaries inspected; pushed 2026-08-08. Document-to-Markdown ingestion, including SRT/VTT; no direct Fountain overlap found in inspected scope. |

All unique fuzzy-search discoveries are catalogued in the permanent registry, explicitly at metadata-only depth unless upgraded above. Collaboration/extension was considered: MoonFountain can provide structured screenplay input to renderers/production tools, but Markdown grammar, subtitle timing and workspace state machines do not supply its central scene/dialogue classification. An independent small parsing core avoids introducing those unrelated runtime/dependency models.

## Decision and reserved boundary
PASS for local implementation within the bounded screenplay parsing and rehearsal-analysis scope; no directly overlapping mature MoonBit implementation found in the retained evidence. Review again before submission if scope changes. Recheck date: 2026-09-11. MoonCakes was searched, NOT published to.
