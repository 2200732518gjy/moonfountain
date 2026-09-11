///|
test "nested Fountain emphasis and combined bold italic" {
  let s = inline_text("_an *italic* word_ and ***loud***")
  assert_eq(s[1].italic, true)
  assert_eq(s[1].underline, true)
  assert_eq(s[s.length() - 1].bold, true)
  assert_eq(s[s.length() - 1].italic, true)
  assert_eq(
    plain_text("_an *italic* word_ and ***loud***"),
    "an italic word and loud",
  )
}

///|
test "escaped unmatched and whitespace markers stay literal" {
  assert_eq(
    plain_text("\\*literal\\* and * broken* and **open"),
    "*literal* and * broken* and **open",
  )
  assert_eq(plain_text("****wide****"), "****wide****")
  assert_eq(plain_text("🌙 **星星**"), "🌙 星星")
  assert_eq(plain_text(""), "")
}
