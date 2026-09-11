# Release checklist (not an execution record)

- Run scripts/verify.py on a clean checkout; require native execution on CI.
- Audit meaningful commits and retained implementation, review dependency notices,
  diagnostic/API contracts and privacy-sensitive default outputs.
- Ask the participant for official browser authorization only after local readiness.
  Use account-isolated gh configuration. Verify gh auth status, gh api user,
  intended remote/owner, push permission and commit-to-account attribution.
- Only then create the public repo, set its real repository metadata, push and wait
  for green hosted CI; inspect unauthenticated repository visibility where possible.
- Create matching v0.1.0 tag and non-draft Release against the verified commit.
  Initially distribute source; don't attach runtime binaries without license review.
- Finalize the external one-page application using real participant/contact/repo,
  CI, release and contribution evidence; run the skill's strict validator.
- Append completed identity/fingerprint to the shared project registry.
- Remind the participant to publish the package to MoonCakes manually. The builder
  workflow does not execute that separate external publication.

The initial public four-target CI passed on 2026-09-11; see CI.md.
For each release, verify the exact final tag commit and its CI, not only a prior run.
Personal application data stays outside this repository. MoonCakes publication requires separate participant authorization (received for the record below).

## MoonCakes publication record — 2026-09-11

- Separately authorized by the participant; both GitHub and MoonCakes identity verified as `2200732518gjy`.
- Published `2200732518gjy/moonfountain@0.1.0` from release commit `cf06280141dc4c9ca1157849185a1b2e575f3864`.
- Official `moon publish` checked both source and extracted archive; server returned HTTP 200.
- Registry manifest reports version 0.1.0, not yanked, build_status success.
- Registry creation time: 2026-09-11T15:28:50.990110Z.
- Archive SHA-256: `b6410047cfa5d6ebcbd7991c81fa17934058fc3d535725d928bf2a7c57c1251b`.
- Shared MoonBit credentials remained byte-for-byte unchanged. No global Git identity or active GitHub account was switched.
- The v0.1.0 tag remains immutable; this publication record is a later documentation-only update.
