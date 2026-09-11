///|
test "outline lyrics centering and transitions" {
  let d = parse(
    "# Act One\n## Arrival\n= A visitor comes\n\n~Sing to the rain\n\n> THE END <\n\n> FADE OUT.\n\nCUT TO:\n\n===",
  )
  assert_eq(d.elements.map(fn(e) { e.kind }), [
    Section,
    Section,
    Synopsis,
    Lyric,
    Centered,
    Transition,
    Transition,
    PageBreak,
  ])
  assert_eq(d.elements[1].level, 2)
  assert_eq(d.elements[4].text, "THE END")
}

///|
test "syntax inside dialogue stays dialogue; action forces literal markers" {
  let d = parse(
    "ADA\n# spoken hashtag\n> spoken angle\n\n!# not a section\n\n==",
  )
  assert_eq(d.elements[1].kind, Dialogue)
  assert_eq(d.elements[2].kind, Dialogue)
  assert_eq(d.elements[3].kind, Action)
  assert_eq(d.elements[4].kind, Synopsis)
}
