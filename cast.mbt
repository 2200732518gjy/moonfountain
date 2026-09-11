///|
pub(all) struct CastMember {
  name : String
  first_line : Int
  scenes : Array[Int]
  turns : Int
  spoken_lines : Int
  words : Int
} derive(Eq, Debug, ToJson)

///|
/// Whitespace-delimited tokens, NOT linguistic word segmentation or duration.
pub fn word_count(text : String) -> Int {
  let mut n = 0
  let mut inside = false
  for c in plain_text(text).to_array() {
    if c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\u{3000}' {
      inside = false
    } else if !inside {
      n += 1
      inside = true
    }
  }
  n
}

///|
/// Exact character identity; extensions do not split a role. Case is not folded.
pub fn cast(doc : Document) -> Array[CastMember] {
  let out : Array[CastMember] = []
  let indices : Map[String, Int] = Map([])
  let ss = scenes(doc)
  for turn in turns(doc) {
    let scene = scene_at_line(ss, turn.line)
    let mut words = 0
    for text in turn.dialogue {
      words += word_count(text)
    }
    match indices.get(turn.character) {
      Some(i) => {
        let prev = out[i]
        let scene_ids = prev.scenes.copy()
        if !scene_ids.contains(scene) {
          scene_ids.push(scene)
        }
        out[i] = {
          ..prev,
          scenes: scene_ids,
          turns: prev.turns + 1,
          spoken_lines: prev.spoken_lines + turn.dialogue.length(),
          words: prev.words + words,
        }
      }
      None => {
        indices.set(turn.character, out.length())
        out.push({
          name: turn.character,
          first_line: turn.line,
          scenes: [scene],
          turns: 1,
          spoken_lines: turn.dialogue.length(),
          words,
        })
      }
    }
  }
  out
}
