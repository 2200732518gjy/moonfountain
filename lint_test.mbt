///|
test "semantic diagnostics are stable and source-preserving" {
  let s = "INT. A #1#\n\n@Ada\nHi.\n\nADA\n(unclosed\n\nEXT. B #1#\n\n@LONE"
  let d = parse(s)
  assert_eq(lint(d).map(fn(x) { x.code }), [
    "FNT103", "FNT104", "FNT101", "FNT105",
  ])
  assert_eq(d.source, s)
  assert_true(lint(d)[2].format().contains("first seen at line 1"))
}

///|
test "malformed scene labels and direction-only turns are visible" {
  let d = parse("INT. A #bad number#\n\nADA\n(waiting)")
  assert_eq(lint(d).map(fn(x) { x.code }), ["FNT102", "FNT106"])
  assert_eq(lint(parse("INT. ROOM\n\nADA\nHello.")).length(), 0)
}
