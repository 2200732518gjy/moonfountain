///|
/// Parse a bounded Fountain block grammar. Original input is always retained.
pub fn parse(source : String) -> Document {
  let lines = source_lines(source)
  let elements : Array[Element] = []
  let body_start = parse_title(lines, elements)
  let mut in_dialogue = false
  for i = body_start; i < lines.length(); i = i + 1 {
    let line = lines[i]
    let text = stripped(line.content())
    if text == "" {
      in_dialogue = false
      continue
    }
    let before = i == 0 || stripped(lines[i - 1].content()) == ""
    let after = i + 1 == lines.length() ||
      stripped(lines[i + 1].content()) == ""
    if in_dialogue {
      let kind = if text.has_prefix("(") && text.has_suffix(")") {
        Parenthetical
      } else {
        Dialogue
      }
      elements.push(element(line, kind, text))
    } else if text.has_prefix("!") {
      elements.push(element(line, Action, text[1:].to_owned()))
    } else if before && after && is_scene(text) {
      let heading = if text.has_prefix(".") {
        text[1:].to_owned()
      } else {
        text
      }
      let (body, number) = scene_number(heading)
      elements.push(element(line, SceneHeading, body, detail=number))
    } else if before && !after && is_character(text) {
      let cue = if text.has_prefix("@") {
        stripped(text[1:].to_owned())
      } else {
        text
      }
      let (name, extension) = character_parts(cue)
      elements.push(element(line, Character, name, detail=extension))
      in_dialogue = true
    } else {
      elements.push(element(line, Action, line.content()))
    }
  }
  { source, elements, diagnostics: [] }
}

///|
fn is_scene(text : String) -> Bool {
  if text.has_prefix(".") &&
    text.length() > 1 &&
    text[1] != '.' &&
    text[1] != ' ' &&
    text[1] != '\t' {
    return true
  }
  let upper = text.to_upper()
  for prefix in ["INT", "EXT", "EST", "INT./EXT", "INT/EXT", "I/E"] {
    if upper.has_prefix(prefix + ".") || upper.has_prefix(prefix + " ") {
      return true
    }
  }
  false
}

///|
fn scene_number(text : String) -> (String, String) {
  if !text.has_suffix("#") {
    return (text, "")
  }
  let mut i = text.length() - 2
  while i >= 0 {
    if text[i] == '#' {
      let n = text[i + 1:text.length() - 1].to_owned()
      if n != "" &&
        n
        .to_array()
        .all(fn(c) {
          (c >= 'A' && c <= 'Z') ||
          (c >= 'a' && c <= 'z') ||
          (c >= '0' && c <= '9') ||
          c == '-' ||
          c == '.'
        }) {
        return (stripped(text[:i].to_owned()), n)
      }
      break
    }
    i -= 1
  }
  (text, "")
}
