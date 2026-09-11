///|
test "scenes have contiguous source ranges and stable first appearance cast" {
  let d = parse(
    "A preamble.\n\nINT. TRAIN - NIGHT #1#\n\nADA\nHello.\n\nBEN\nHi.\n\nADA\nAgain.\n\nEXT. PLATFORM - DAWN\n\n@小林\n早。",
  )
  let ss = scenes(d)
  assert_eq(ss.length(), 2)
  assert_eq(ss[0].characters, ["ADA", "BEN"])
  assert_eq(ss[0].dialogue_lines, 3)
  assert_eq(ss[0].end, ss[1].start)
  assert_eq(ss[1].end, d.source.length())
  assert_eq(scene_at_line(ss, 1), 0)
  assert_eq(scene_at_line(ss, 14), 2)
  assert_eq(scene_at_line(ss, 999), 0)
}

///|
test "unnumbered and empty scenes remain distinct" {
  let ss = scenes(parse("INT. A\n\nINT. B"))
  assert_eq(ss.length(), 2)
  assert_eq(ss[0].number, "")
  assert_eq(ss[0].dialogue_lines, 0)
  assert_eq(scenes(parse("only action")).length(), 0)
}
