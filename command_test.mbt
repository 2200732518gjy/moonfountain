///|
test "command modes report content and explicit usage errors" {
  let source = "INT. ROOM\n\nADA\nHello."
  assert_eq(command("json", source).status, 0)
  assert_true(command("scenes", source).stdout.contains("ROOM"))
  assert_true(command("cues", source, argument="ADA").stdout.contains("Hello."))
  assert_eq(command("cues", source, argument="BEN").status, 2)
  assert_eq(command("html", source, argument="extra").status, 2)
  assert_eq(command("unknown", source).status, 2)
  assert_eq(command("help", "").status, 0)
}

///|
test "lint status is nonzero only for actual findings" {
  assert_eq(command("lint", "ordinary action").status, 0)
  assert_eq(command("lint", "[[unclosed").status, 1)
}
