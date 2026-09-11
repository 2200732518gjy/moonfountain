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

Until those checks run, CHANGELOG remains unreleased and no green badge is added.
