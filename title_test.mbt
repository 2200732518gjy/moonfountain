///|
test "title fields continuations duplicates and extension keys" {
  let d = parse(
    "Title: Night Train\nAuthor: A\nAuthor: B\nContact:\n    studio\n    desk\nCustom: kept\n\nINT. TRAIN - NIGHT",
  )
  assert_eq(title_values(d, "TITLE"), ["Night Train"])
  assert_eq(title_values(d, "author"), ["A", "B"])
  assert_eq(title_values(d, "contact"), ["", "studio", "desk"])
  assert_eq(d.elements[7].kind, SceneHeading)
}

///|
test "ordinary colon action is not a title page" {
  assert_eq(parse("CUT TO:").elements[0].kind, Action)
  assert_eq(parse("Remember: bring keys").elements[0].kind, Action)
}
