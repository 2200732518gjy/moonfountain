///|
/// Title pages end at the first blank line. Unknown keys are preserved.
fn title_pair(text : String) -> (String, String)? {
  match text.find(":") {
    Some(i) => {
      let key = stripped(text[:i].to_owned())
      if key == "" ||
        !key
        .to_array()
        .all(fn(c) {
          (c >= 'A' && c <= 'Z') ||
          (c >= 'a' && c <= 'z') ||
          c == ' ' ||
          c == '-'
        }) {
        return None
      }
      Some((key.to_lower(), stripped(text[i + 1:].to_owned())))
    }
    None => None
  }
}

///|
fn parse_title(lines : Array[SourceLine], elements : Array[Element]) -> Int {
  let first = title_pair(lines[0].content())
  let recognized = match first {
    Some((key, _)) =>
      [
        "title", "credit", "author", "authors", "source", "draft date", "date", "contact",
        "copyright", "notes",
      ].contains(key)
    None => false
  }
  if !recognized {
    return 0
  }
  let mut i = 0
  let mut key = ""
  while i < lines.length() {
    let line = lines[i]
    let raw = line.content()
    if stripped(raw) == "" {
      break
    }
    if raw.has_prefix("   ") || raw.has_prefix("\t") {
      elements.push(element(line, TitleField, stripped(raw), detail=key))
    } else {
      match title_pair(raw) {
        Some((k, value)) => {
          key = k
          elements.push(element(line, TitleField, value, detail=key))
        }
        None => break
      }
    }
    i += 1
  }
  i
}

///|
/// Ordered values retain repeated keys and continuation lines.
pub fn title_values(doc : Document, key : String) -> Array[String] {
  doc.elements
  .filter(fn(e) { e.kind == TitleField && e.detail == key.to_lower() })
  .map(fn(e) { e.text })
}
