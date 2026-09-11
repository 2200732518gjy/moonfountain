///|
test "resource refusal is explicit and never partial" {
  let limits = Limits::{ max_units: 20, max_lines: 3, max_line_units: 8 }
  let d = parse_with_limits("123456789", limits)
  assert_eq(d.elements.length(), 0)
  assert_eq(d.source, "123456789")
  assert_eq(d.diagnostics[0].code, "FNT900")
  assert_eq(
    parse_with_limits("a\nb\nc\nd", limits).diagnostics[0].code,
    "FNT900",
  )
  assert_eq(
    parse_with_limits("x", { ..limits, max_units: 0 }).diagnostics[0].code,
    "FNT900",
  )
}

///|
test "many unmatched boneyards have bounded recovery" {
  let s = Array::make(500, "/* ").join("")
  let d = parse(s)
  assert_true(d.diagnostics.any(fn(d) { d.code == "FNT004" }))
  assert_eq(d.source, s)
  assert_true(d.diagnostics.length() < 20)
}

///|
test "deterministic generated scripts preserve source and semantic totals" {
  let atoms = [
    "INT. A", "", "ADA", "Hello 🌙", "(quiet)", "[[note]]", "/*bad", "!ACTION",
    "@小林", "Yes.", "# Outline", "BEN ^", "***text***", "\\*literal",
  ]
  for seed = 0; seed < 80; seed = seed + 1 {
    let lines : Array[String] = []
    for i = 0; i < 20; i = i + 1 {
      lines.push(atoms[(seed * 17 + i * 7) % atoms.length()])
    }
    let source = lines.join(if seed % 2 == 0 { "\r\n" } else { "\n" })
    let d = parse(source)
    assert_eq(d, parse(source))
    for e in d.elements {
      assert_true(e.start >= 0 && e.end <= source.length() && e.start <= e.end)
    }
    assert_eq(cast(d).fold(init=0, fn(n, c) { n + c.turns }), turns(d).length())
    assert_false(render_html(d).contains("<script>"))
    assert_eq(extract_lines(d, 1, source_lines(source).length()), Some(source))
  }
}

///|
test "all delimiter and Unicode mutations are non-crashing" {
  for token in ["🌙", "[[", "]]", "/*", "*/", "*", "_", "\\", "\r", "\n"] {
    for suffix in ["", "🌙", "**x**", "\n\n.INTRO", "[[ok]]"] {
      let d = parse(token + suffix)
      ignore(report_json(d).stringify())
      ignore(render_html(d))
      ignore(plain_text(token + suffix))
    }
  }
}
