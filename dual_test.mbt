///|
test "dual dialogue has two replayable separate turns" {
  let d = parse("ADA\nNow!\n\nBEN (shouts) ^\nGo!\n\n@小林 ^\nWait!")
  let pairs = dual_pairs(d)
  assert_eq(pairs.length(), 1)
  assert_eq(pairs[0].left.character, "ADA")
  assert_eq(pairs[0].right.character, "BEN")
  assert_eq(pairs[0].right.extension, "(shouts)")
  assert_eq(d.diagnostics[0].code, "FNT003")
}

///|
test "orphan and action-separated dual cues diagnose not pair" {
  let d = parse("ADA ^\nAlone.\n\n!A door shuts.\n\nBEN ^\nHello.")
  assert_eq(dual_pairs(d).length(), 0)
  assert_eq(d.diagnostics.length(), 2)
}
