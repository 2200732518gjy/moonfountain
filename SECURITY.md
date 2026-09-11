# Security and privacy

This is an offline parser library and local CLI, not a secure document sandbox.
It evaluates no screenplay code, fetches no URLs, installs no plugins and writes
only stdout/stderr. Static HTML escapes all user text and uses no remote assets.

- Closed annotations are hidden by default, **not encrypted or destroyed**.
- Raw extractors and json-source expose original notes, cut scenes and contacts.
- Unclosed or budget-exhausted annotations stay visible. Always lint and manually
  review material before publishing; lint success is not a privacy certification.
- Title contact fields and other visible PII are not scrubbed. Do not submit real
  client scripts as bug reports. Reduce to a synthetic minimal case.
- Parser limits cap units/lines; CLI additionally rejects over-4-MiB and invalid
  UTF-8 input. These are not a universal memory/time bound for every public helper.
- Embedders must validate parser-produced documents, restrict input/path access,
  set process timeouts/output limits and avoid unbounded concurrent requests.
  Local CLI reads paths supplied by its user; it is not a server upload API.
- Dependencies are MoonBit core and Node's built-ins. Keep toolchains maintained;
  see THIRD_PARTY.md and CI.md for the installer trust boundary.

No private vulnerability reporting channel is established in this unpublished
local candidate. Do not put secrets into a future public issue. Contact the
maintainer through an already agreed private channel before sharing exploit data;
after publication, enable GitHub private vulnerability reporting before advertising it.
