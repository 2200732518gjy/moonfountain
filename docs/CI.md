# Verification contract

`python scripts/verify.py` checks formatting, then strict checking, release building,
tests and the self-checking example on wasm-gc, wasm, js and native. The JS leg
also launches 25 real CLI subprocess cases. It regenerates public interfaces and
rejects tracked interface drift. Python >=3.8 and Node >=22 are tooling only.

Windows without a C compiler may explicitly use
`python scripts/verify.py --native-check-only`; this is a partial pass, never a
native execution claim. `--target js` runs a single target; no implicit native skip.
MoonBit's Node filesystem CLI supports JS only; the library and embedded example
are the four-target deliverables. No browser/file permissions are assumed by core.

GitHub Actions uses independent Ubuntu 24.04 jobs with a C compiler for native,
read-only token permissions, no persisted checkout credential, and no cache that
could hide a missing dependency. Jobs cover push, pull request and manual runs.
Checkout v4 and setup-node v4 commit references were resolved through GitHub's
public API on 2026-09-11. The installer is downloaded from the official MoonBit
host and verified against a reviewed SHA-256; its body is not vendored here.
This verifies the installer only, not cryptographic provenance of compiler archives.
The installer selects the moving official latest toolchain and CI prints all
versions. Update the installer checksum only after reviewing upstream changes.
A future formatter change can require a reviewed formatting refresh.

Local September verification uses an account-isolated toolchain: moon
0.1.20260904, moonc v0.10.12+1634b282e (2026-09-07). The implementation was also
tested during development with moonc 0.10.4 (2026-07-15); old formatter output
differs, so use the September formatter for the final style gate. Hosted execution was verified on 2026-09-11: [run 34613640264](https://github.com/2200732518gjy/moonfountain/actions/runs/34613640264)
on commit `5ef0b00895816c2baab92533eefcb06c2ccde736` passed all four jobs.
Every target passed 46 tests and its executable example; native was genuinely
compiled and executed on Ubuntu, not skipped. JS also passed 25 CLI subprocesses.
CI used moonc v0.10.12+1634b282e (2026-09-07). Later commits must independently
pass their own run before tagging; a historical green run is not proof of new code.
