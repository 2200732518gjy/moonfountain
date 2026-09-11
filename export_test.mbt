///|
test "JSON report has stable versioned shape and privacy default" {
  let d = parse(
    "/* passwordless private note */\n\nINT. ROOM\n\nADA\n\"Hello\" 🌙",
  )
  let result = report_json(d)
  assert_true(result.stringify().contains("schema_version"))
  assert_false(result.stringify().contains("passwordless private note"))
  assert_true(
    report_json(d, include_source=true)
    .stringify()
    .contains("passwordless private note"),
  )
  assert_true(scene_text(d).contains("cast: ADA"))
  assert_eq(Kind::SceneHeading.label(), "scene")
}

///|
test "report determinism includes empty document" {
  let d = parse("")
  assert_eq(report_json(d), report_json(d))
  assert_eq(scene_text(d), "")
}
