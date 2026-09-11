///|
test "source lines preserve mixed endings and trailing line" {
  let s = "a\r\nb\rc\n"
  let lines = source_lines(s)
  assert_eq(lines.length(), 4)
  assert_eq(lines[0].next, 3)
  assert_eq(lines[1].start, 3)
  let mut rebuilt = ""
  for line in lines {
    rebuilt += s[line.start:line.next].to_owned()
  }
  assert_eq(rebuilt, s)
}

///|
test "BOM and non BMP offsets stay exact" {
  let s = "\u{FEFF}星🌙\nEnd"
  let lines = source_lines(s)
  assert_eq(lines[0].content(), "星🌙")
  assert_eq(lines[0].end, 4)
  assert_eq(lines[1].start, 5)
  assert_eq(stripped(" \t x "), "x")
}

///|
test "empty document retains addressable empty line" {
  assert_eq(source_lines("")[0].start, 0)
  assert_eq(source_lines("")[0].content(), "")
}
