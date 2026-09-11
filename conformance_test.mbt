///|
test "intentional two-space dialogue line is retained" {
  let d = parse("ADA\nFirst.\n  \nSecond.\n\n!Action.")
  assert_eq(turns(d)[0].dialogue, ["First.", "", "Second."])
  assert_true(cue_text(d, "ADA").contains("First.\n\nSecond."))
  assert_eq(d.elements[4].kind, Action)
}

///|
test "trailing space suppresses an automatic transition" {
  let d = parse("CUT TO: \n\nCUT TO:\n\n> CUT TO: ")
  assert_eq(d.elements.map(fn(e) { e.kind }), [Action, Transition, Transition])
  assert_eq(d.elements[0].text, "CUT TO: ")
}

///|
test "forced cue without a name cannot create an empty role" {
  assert_eq(turns(parse("@^\nWords.")).length(), 0)
  assert_eq(turns(parse("@(V.O.)\nWords.")).length(), 0)
}

///|
test "masked note is not mistaken for intentional two-space speech" {
  let d = parse("ADA\nHello.\n[[note]]\nAn action.")
  assert_eq(turns(d)[0].dialogue, ["Hello."])
}
