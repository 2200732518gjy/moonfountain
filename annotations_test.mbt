///|
test "annotations are retained separately and never leak into dialogue" {
  let source = "/* old scene\n\nINT. HIDDEN\n*/\n\nADA\nHello [[quietly]] there."
  let d = parse(source)
  assert_eq(d.annotations.length(), 2)
  assert_eq(d.annotations[0].kind, Boneyard)
  assert_eq(d.annotations[1].line, 7)
  assert_eq(turns(d).length(), 1)
  assert_eq(turns(d)[0].line, 6)
  assert_eq(d.source, source)
  assert_eq(d.diagnostics.length(), 0)
}

///|
test "unclosed notes recover at blank lines and retain input" {
  let d = parse("[[unfinished\n\nINT. ROOM\n\n/*broken")
  assert_eq(d.annotations.length(), 0)
  assert_eq(d.diagnostics.map(fn(d) { d.code }), ["FNT001", "FNT002"])
  assert_eq(d.elements[1].kind, SceneHeading)
}

///|
test "CRLF annotations retain UTF16 positions" {
  let d = parse("[[🌙]]\r\n\r\n.INTRO")
  assert_eq(d.annotations[0].end, 6)
  assert_eq(d.elements[0].start, 10)
  assert_eq(d.elements[0].line, 3)
}
