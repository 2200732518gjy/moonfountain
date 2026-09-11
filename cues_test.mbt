///|
test "cue sheets trace context without crossing scene boundaries" {
  let d = parse(
    "INT. A\n\nADA\nReady?\n\nBEN\n(quietly)\nYes.\n\nINT. B\n\nBEN\nNew scene.",
  )
  let cues = cue_sheet(d, "BEN")
  assert_eq(cues.length(), 2)
  assert_eq(cues[0].preceding_character, "ADA")
  assert_eq(cues[0].preceding_text, "Ready?")
  assert_eq(cues[1].preceding_character, "")
  assert_eq(cues[1].scene, 2)
  assert_eq(cue_sheet(d, "MISSING").length(), 0)
  assert_true(cue_text(d, "BEN").contains("(quietly)"))
}

///|
test "both sides of simultaneous dialogue are labelled" {
  let d = parse("ADA\nGo.\n\nBEN ^\nNow.")
  assert_true(cue_sheet(d, "ADA")[0].simultaneous)
  assert_true(cue_sheet(d, "BEN")[0].simultaneous)
  assert_true(cue_text(d, "BEN").contains("[SIMULTANEOUS]"))
}
