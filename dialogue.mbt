///|
fn character_parts(cue : String) -> (String, String) {
  match cue.find("(") {
    Some(i) if cue.has_suffix(")") =>
      (stripped(cue[:i].to_owned()), cue[i:].to_owned())
    _ => (stripped(cue), "")
  }
}

///|
fn is_character(text : String) -> Bool {
  if text.has_prefix("@") {
    return stripped(text[1:].to_owned()) != ""
  }
  if text.has_suffix("TO:") {
    return false
  }
  let (name, _) = character_parts(text)
  name != "" &&
  name == name.to_upper() &&
  name.to_array().any(fn(c) { c >= 'A' && c <= 'Z' })
}

///|
pub(all) struct Turn {
  character : String
  extension : String
  line : Int
  end_line : Int
  dialogue : Array[String]
  directions : Array[String]
  dual : Bool
} derive(Eq, Debug, ToJson)

///|
/// A turn is a cue followed by contiguous dialogue/parenthetical elements.
pub fn turns(doc : Document) -> Array[Turn] {
  let out : Array[Turn] = []
  let mut i = 0
  while i < doc.elements.length() {
    let e = doc.elements[i]
    if e.kind != Character {
      i += 1
      continue
    }
    let dialogue : Array[String] = []
    let directions : Array[String] = []
    let mut end_line = e.line
    let mut j = i + 1
    while j < doc.elements.length() {
      let next = doc.elements[j]
      if next.kind == Dialogue {
        dialogue.push(next.text)
      } else if next.kind == Parenthetical {
        directions.push(next.text)
      } else {
        break
      }
      end_line = next.line
      j += 1
    }
    out.push({
      character: e.text,
      extension: e.detail,
      line: e.line,
      end_line,
      dialogue,
      directions,
      dual: e.dual,
    })
    i = j
  }
  out
}
