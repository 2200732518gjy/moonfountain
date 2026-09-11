///|
test "HTML preview escapes injection and hides private annotations" {
  let d = parse(
    "Title: <script>alert(1)</script>\n\n# Secret outline\n\n!<img src=x onerror=alert(1)>\n\n/* private */\n\nADA\n**Hello** & goodbye.",
  )
  let html = render_html(d)
  assert_false(html.contains("<script>"))
  assert_false(html.contains("<img"))
  assert_false(html.contains("private"))
  assert_false(html.contains("Secret outline"))
  assert_true(html.contains("<strong>Hello</strong> &amp; goodbye."))
  assert_true(render_html(d, outline=true).contains("Secret outline"))
}

///|
test "escaping is complete and markup nesting is balanced" {
  assert_eq(escape_html("<&>\"'"), "&lt;&amp;&gt;&quot;&#39;")
  assert_eq(inline_html("***🌙***"), "<strong><em>🌙</em></strong>")
  assert_true(render_html(parse("INT. ROOM #1#")).contains("data-line=\"1\""))
}
