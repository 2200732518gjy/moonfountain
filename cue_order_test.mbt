///|
test "rehearsal keeps mid-speech directions in their original position" {
  let d = parse("ADA\nFirst.\n(pause)\nSecond.\n(turns)\nThird.")
  let t = turns(d)[0]
  assert_eq(t.parts.map(fn(p) { p.direction }), [
    false, true, false, true, false,
  ])
  assert_eq(t.parts.map(fn(p) { p.line }), [2, 3, 4, 5, 6])
  assert_true(
    cue_text(d, "ADA").contains("First.\n(pause)\nSecond.\n(turns)\nThird."),
  )
  assert_eq(t.dialogue, ["First.", "Second.", "Third."])
}

///|
test "cue data can be mutated without altering parsed elements" {
  let d = parse("ADA\nHello.")
  let cues = cue_sheet(d, "ADA")
  cues[0].parts.clear()
  assert_eq(turns(d)[0].parts.length(), 1)
}
