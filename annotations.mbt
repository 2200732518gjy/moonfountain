///|
/// Notes are bounded by a blank line; boneyards may span blank lines.
/// Malformed openers remain visible instead of swallowing the rest of a script.
fn mask_annotations(
  source : String,
) -> (String, Array[Element], Array[Diagnostic]) {
  let out = StringBuilder()
  let annotations : Array[Element] = []
  let diagnostics : Array[Diagnostic] = []
  let mut i = 0
  let mut line = 1
  while i < source.length() {
    let is_note = i + 1 < source.length() &&
      source[i] == '[' &&
      source[i + 1] == '['
    let is_boneyard = i + 1 < source.length() &&
      source[i] == '/' &&
      source[i + 1] == '*'
    // Backslash escapes the opener; backslash itself remains in source text.
    let escaped = i > 0 && source[i - 1] == '\\'
    if (is_note || is_boneyard) && !escaped {
      let close = if is_note { "]]" } else { "*/" }
      let mut j = i + 2
      let mut found = -1
      let mut saw_newline = false
      while j + 1 < source.length() {
        if source[j] == close[0] && source[j + 1] == close[1] {
          found = j + 2
          break
        }
        let c = source[j]
        if is_note {
          if c == '\n' || c == '\r' {
            if saw_newline {
              break
            }
            saw_newline = true
            if c == '\r' && j + 1 < source.length() && source[j + 1] == '\n' {
              j += 1
            }
          } else if c != ' ' && c != '\t' {
            saw_newline = false
          }
        }
        j += 1
      }
      if found >= 0 {
        annotations.push({
          kind: if is_note {
            Note
          } else {
            Boneyard
          },
          text: source[i + 2:found - 2].to_owned(),
          start: i,
          end: found,
          line,
          detail: "",
          level: 0,
          dual: false,
        })
        while i < found {
          if source[i] == '\n' || source[i] == '\r' {
            out.write_stringview(source[i:i + 1])
            if source[i] == '\n' ||
              i + 1 == source.length() ||
              source[i + 1] != '\n' {
              line += 1
            }
          } else {
            out.write_stringview(" ")
          }
          i += 1
        }
        continue
      }
      diagnostics.push({
        code: if is_note {
          "FNT001"
        } else {
          "FNT002"
        },
        line,
        message: "Unclosed annotation retained as visible text",
      })
    }
    if source[i].to_int() >= 0xD800 &&
      source[i].to_int() <= 0xDBFF &&
      i + 1 < source.length() {
      out.write_stringview(source[i:i + 2])
      i += 2
      continue
    }
    out.write_stringview(source[i:i + 1])
    if source[i] == '\n' ||
      (source[i] == '\r' && (i + 1 == source.length() || source[i + 1] != '\n')) {
      line += 1
    }
    i += 1
  }
  (out.to_string(), annotations, diagnostics)
}
