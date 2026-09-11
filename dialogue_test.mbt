///|
test "dialogue state parentheticals extension and uppercase continuation" {
  let d = parse(
    "ADA (softly)\n(waiting)\nHello.\nLOUD WORDS\n\n!LOUD ACTION\nmore action",
  )
  let ts = turns(d)
  assert_eq(ts.length(), 1)
  assert_eq(ts[0].character, "ADA")
  assert_eq(ts[0].extension, "(softly)")
  assert_eq(ts[0].directions, ["(waiting)"])
  assert_eq(ts[0].dialogue, ["Hello.", "LOUD WORDS"])
  assert_eq(d.elements[4].kind, Action)
}

///|
test "forced international names and empty or isolated cues" {
  let d = parse("@小林\n你好。\n\n@McKay\nYes.\n\nLONELY\n\n@\nnot a cue")
  assert_eq(turns(d).map(fn(t) { t.character }), ["小林", "McKay"])
  assert_eq(d.elements[4].kind, Action)
  assert_eq(d.elements[5].kind, Action)
}
