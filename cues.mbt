///|
pub(all) struct Cue {
  scene : Int
  line : Int
  character : String
  preceding_character : String
  preceding_text : String
  simultaneous : Bool
  dialogue : Array[String]
  directions : Array[String]
  parts : Array[SpeechPart]
} derive(Eq, Debug, ToJson)

///|
/// Cue context never crosses scene boundaries. Simultaneous speech is flagged,
/// not falsely presented as a sequential spoken trigger.
pub fn cue_sheet(doc : Document, character : String) -> Array[Cue] {
  let ts = turns(doc)
  let ss = scenes(doc)
  let out : Array[Cue] = []
  for i = 0; i < ts.length(); i = i + 1 {
    let turn = ts[i]
    if turn.character != character {
      continue
    }
    let scene = scene_at_line(ss, turn.line)
    let mut preceding_character = ""
    let mut preceding_text = ""
    if i > 0 && scene_at_line(ss, ts[i - 1].line) == scene {
      let previous = ts[i - 1]
      preceding_character = previous.character
      if previous.dialogue.length() > 0 {
        preceding_text = plain_text(
          previous.dialogue[previous.dialogue.length() - 1],
        )
      }
    }
    out.push({
      scene,
      line: turn.line,
      character,
      preceding_character,
      preceding_text,
      simultaneous: turn.dual || (i + 1 < ts.length() && ts[i + 1].dual),
      dialogue: turn.dialogue.copy(),
      directions: turn.directions.copy(),
      parts: turn.parts.copy(),
    })
  }
  out
}

///|
pub fn cue_text(doc : Document, character : String) -> String {
  let out = StringBuilder()
  out.write_stringview(("CUE SHEET: " + character + "\n")[:])
  for cue in cue_sheet(doc, character) {
    out.write_stringview(
      ("\nScene \{cue.scene}, line \{cue.line}" +
      (if cue.simultaneous { " [SIMULTANEOUS]\n" } else { "\n" }))[:],
    )
    if cue.preceding_character != "" {
      out.write_stringview(
        ("Context — " +
        cue.preceding_character +
        ": " +
        cue.preceding_text +
        "\n")[:],
      )
    }
    for part in cue.parts {
      out.write_stringview((plain_text(part.text) + "\n")[:])
    }
  }
  out.to_string()
}
