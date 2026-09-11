///|
/// Escape all user-controlled HTML text. No script, URL or raw HTML passthrough.
pub fn escape_html(text : String) -> String {
  let out = StringBuilder()
  for c in text.to_array() {
    let replacement = match c {
      '&' => "&amp;"
      '<' => "&lt;"
      '>' => "&gt;"
      '"' => "&quot;"
      '\'' => "&#39;"
      _ => c.to_string()
    }
    out.write_stringview(replacement[:])
  }
  out.to_string()
}

///|
pub fn inline_html(text : String) -> String {
  let out = StringBuilder()
  for part in inline_text(text) {
    if part.bold {
      out.write_stringview("<strong>")
    }
    if part.italic {
      out.write_stringview("<em>")
    }
    if part.underline {
      out.write_stringview("<u>")
    }
    out.write_stringview(escape_html(part.text)[:])
    if part.underline {
      out.write_stringview("</u>")
    }
    if part.italic {
      out.write_stringview("</em>")
    }
    if part.bold {
      out.write_stringview("</strong>")
    }
  }
  out.to_string()
}

///|
/// Semantic reading preview, not industry pagination. Notes and boneyards are
/// excluded; outline is opt-in. Source-line anchors support editor navigation.
pub fn render_html(doc : Document, outline? : Bool = false) -> String {
  let out = StringBuilder()
  out.write_stringview(
    "<!doctype html><html lang=\"en\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><title>MoonFountain preview</title><style>body{max-width:52rem;margin:2rem auto;padding:0 1rem;font:16px/1.6 monospace}.character{margin-left:35%;margin-bottom:0}.dialogue,.parenthetical{margin-left:20%;margin-right:15%;white-space:pre-wrap}.action{white-space:pre-wrap}.transition{text-align:right}.centered{text-align:center}.lyric{font-style:italic}.dual{border-left:3px solid #777;padding-left:1rem}.title{text-align:center}.section,.synopsis{color:#555}h2{font-size:1.1em}hr{break-after:page}</style></head><body><main>\n",
  )
  for e in doc.elements {
    if e.kind == Note || e.kind == Boneyard {
      continue
    }
    if !outline && (e.kind == Section || e.kind == Synopsis) {
      continue
    }
    if e.kind == PageBreak {
      out.write_stringview("<hr>\n")
      continue
    }
    let (tag, class_name) = match e.kind {
      SceneHeading => ("h2", "scene")
      Character => ("p", if e.dual { "character dual" } else { "character" })
      Dialogue => ("p", "dialogue")
      Parenthetical => ("p", "parenthetical")
      Transition => ("p", "transition")
      Centered => ("p", "centered")
      Lyric => ("p", "lyric")
      Section => ("h3", "section")
      Synopsis => ("p", "synopsis")
      TitleField => ("p", "title")
      _ => ("p", "action")
    }
    out.write_stringview(
      ("<" +
      tag +
      " class=\"" +
      class_name +
      "\" id=\"line-\{e.line}\" data-line=\"\{e.line}\">")[:],
    )
    out.write_stringview(inline_html(e.text)[:])
    if e.kind == Character && e.detail != "" {
      out.write_stringview((" " + escape_html(e.detail))[:])
    }
    if e.kind == Character && e.dual {
      out.write_stringview(" <small>[simultaneous]</small>")
    }
    if e.kind == SceneHeading && e.detail != "" {
      out.write_stringview(
        (" <small>#" + escape_html(e.detail) + "#</small>")[:],
      )
    }
    out.write_stringview(("</" + tag + ">\n")[:])
  }
  out.write_stringview("</main></body></html>\n")
  out.to_string()
}
