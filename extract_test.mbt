///|
test "exact scene extraction preserves CRLF comments and Unicode" {
  let source = "\u{FEFF}Title: Test\r\n\r\nINT. A #9#\r\n\r\nADA\r\n🌙 [[note]]\r\n\r\nEXT. B #9#"
  let d = parse(source)
  assert_eq(
    extract_scene(d, 1),
    Some("INT. A #9#\r\n\r\nADA\r\n🌙 [[note]]\r\n\r\n"),
  )
  assert_eq(extract_scene(d, 2), Some("EXT. B #9#"))
  assert_eq(turn_source(d, 0), Some("ADA\r\n🌙 [[note]]\r\n"))
  assert_eq(scenes_for_role(d, "ADA").length(), 1)
  assert_eq(extract_lines(d, 1, 1), Some("\u{FEFF}Title: Test\r\n"))
}

///|
test "invalid selections are never silently clamped" {
  let d = parse("x\n")
  assert_eq(extract_lines(d, 0, 1), None)
  assert_eq(extract_lines(d, 2, 1), None)
  assert_eq(extract_lines(d, 1, 3), None)
  assert_eq(extract_lines(d, 2, 2), Some(""))
  assert_eq(extract_scene(d, 1), None)
  assert_eq(turn_source(d, -1), None)
}
