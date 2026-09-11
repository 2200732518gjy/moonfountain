///|
test "natural forced and escaped scenes" {
  let d = parse(
    "int. station - day #12A#\n\n.INTRO\n\n!INT. NOT A SCENE\n\n...ellipsis",
  )
  assert_eq(d.elements[0].kind, SceneHeading)
  assert_eq(d.elements[0].detail, "12A")
  assert_eq(d.elements[1].text, "INTRO")
  assert_eq(d.elements[2].kind, Action)
  assert_eq(d.elements[3].kind, Action)
}

///|
test "scene requires blank boundaries and delimited prefix" {
  let d = parse("INT. room\nnext\n\nINTERNAL ROOM\n\nEXT. field\n")
  assert_eq(d.elements[0].kind, Action)
  assert_eq(d.elements[2].kind, Action)
  assert_eq(d.elements[3].kind, SceneHeading)
}

///|
test "malformed scene numbers are not silently removed" {
  let d = parse("INT. ROOM #bad number#")
  assert_eq(d.elements[0].detail, "")
  assert_eq(d.elements[0].text, "INT. ROOM #bad number#")
}
