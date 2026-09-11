///|
test "cast totals conserve all turns and spoken lines" {
  let d = parse(
    "ADA (V.O.)\nOne **two**.\n\nINT. TRAIN\n\nADA\n(whispers)\nThree four.\n\nBEN\nFive.",
  )
  let cs = cast(d)
  assert_eq(cs.length(), 2)
  assert_eq(cs[0].scenes, [0, 1])
  assert_eq(cs[0].turns, 2)
  assert_eq(cs[0].spoken_lines, 2)
  assert_eq(cs[0].words, 4)
  assert_eq(cs[1].words, 1)
  assert_eq(cs.fold(init=0, fn(n, c) { n + c.turns }), turns(d).length())
}

///|
test "word metric is explicit and identities stay case-sensitive" {
  assert_eq(word_count("你好世界"), 1)
  assert_eq(word_count("a　b\tc"), 3)
  assert_eq(word_count("  "), 0)
  let d = parse("@Ada\nHi.\n\nADA\nHey.")
  assert_eq(cast(d).length(), 2)
}
