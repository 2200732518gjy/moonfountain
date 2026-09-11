# Contributing

Keep the center of this project Fountain structure and rehearsal breakdowns.
Read docs/SUPPORT.md before expanding grammar; do not turn it into CommonMark,
subtitle QC, writing generation or a production-management platform.

1. Make a dedicated clone/branch. Do not share one working repository among
   concurrent account windows. Configure identity **repo-locally** if necessary;
   never change global Git name/email or switch other windows' authentication.
2. Add a focused regression test before changing a grammar invariant. Test both
   recognition and literal/error fallback; use original synthetic scripts only.
3. Run `moon fmt`, `moon info`, then `python scripts/verify.py`. Native execution
   requires a C compiler. An explicit --native-check-only run leaves CI work pending.
4. Public API changes need generated interface and JSON/support docs updates.
   Never edit generated .mbti by hand or add unrelated dependencies silently.
5. Submit a meaningful commit with purpose and actual verification evidence.
   Do not use empty, mechanical or rewritten commits to inflate history.

Before any push verify the remote, active authenticated GitHub user and permission;
Git author text alone does not prove account attribution. Keep applications,
contact details, raw user screenplays and authentication files out of this repo.

See SECURITY.md for sensitive reports. Package publication is a separate
maintainer decision; local tests do not authorize publishing to MoonCakes.
