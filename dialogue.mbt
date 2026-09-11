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
    let forced = stripped(text[1:].to_owned())
    let cue = if forced.has_suffix("^") {
      stripped(forced[:forced.length() - 1].to_owned())
    } else {
      forced
    }
    let (name, _) = character_parts(cue)
    return name != ""
  }
  if text.has_suffix("TO:") {
    return false
  }
  let cue = if text.has_suffix("^") {
    stripped(text[:text.length() - 1].to_owned())
  } else {
    text
  }
  let (name, _) = character_parts(cue)
  name != "" &&
  name == name.to_upper() &&
  name.to_array().any(fn(c) { c >= 'A' && c <= 'Z' })
}

///|
pub(all) struct SpeechPart {
  text : String
  direction : Bool
  line : Int
} derive(Eq, Debug, ToJson)

///|
pub(all) struct Turn {
  character : String
  extension : String
  line : Int
  end_line : Int
  dialogue : Array[String]
  directions : Array[String]
  parts : Array[SpeechPart]
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
    let parts : Array[SpeechPart] = []
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
      parts.push({
        text: next.text,
        direction: next.kind == Parenthetical,
        line: next.line,
      })
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
      parts,
      dual: e.dual,
    })
    i = j
  }
  out
}

///|
/// Walk only the preceding turn; action/headings/outline break pairing.
fn can_pair_dual(elements : Array[Element]) -> Bool {
  let mut i = elements.length() - 1
  let mut spoken = false
  while i >= 0 {
    let e = elements[i]
    match e.kind {
      Dialogue => spoken = true
      Parenthetical => ()
      Character => return spoken && !e.dual
      _ => return false
    }
    i -= 1
  }
  false
}

///|
pub(all) struct DualPair {
  left : Turn
  right : Turn
} derive(Eq, Debug, ToJson)

///|
pub fn dual_pairs(doc : Document) -> Array[DualPair] {
  let ts = turns(doc)
  let out : Array[DualPair] = []
  for i = 1; i < ts.length(); i = i + 1 {
    if ts[i].dual {
      out.push({ left: ts[i - 1], right: ts[i] })
    }
  }
  out
}
