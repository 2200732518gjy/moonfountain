///|
pub fn Kind::label(self : Kind) -> String {
  match self {
    Action => "action"
    SceneHeading => "scene"
    Character => "character"
    Dialogue => "dialogue"
    Parenthetical => "parenthetical"
    Transition => "transition"
    Centered => "centered"
    Lyric => "lyric"
    Section => "section"
    Synopsis => "synopsis"
    PageBreak => "page_break"
    Note => "note"
    Boneyard => "boneyard"
    TitleField => "title_field"
  }
}

///|
/// Stable schema v1. Raw source and hidden annotation contents are opt-in.
pub fn report_json(doc : Document, include_source? : Bool = false) -> Json {
  let elements = doc.elements.map(fn(e) {
    let value : Json = {
      "kind": e.kind.label(),
      "text": e.text,
      "line": e.line,
      "start": e.start,
      "end": e.end,
      "detail": e.detail,
      "level": e.level,
      "dual": e.dual,
    }
    value
  })
  let value : Json = {
    "schema_version": 1,
    "offset_unit": "utf16",
    "elements": elements.to_json(),
    "scenes": scenes(doc).to_json(),
    "cast": cast(doc).to_json(),
    "turns": turns(doc).to_json(),
    "diagnostics": lint(doc).to_json(),
    "annotation_count": doc.annotations.length(),
    "source": if include_source {
      doc.source.to_json()
    } else {
      Json::null()
    },
    "annotations": if include_source {
      doc.annotations.to_json()
    } else {
      Json::null()
    },
  }
  value
}

///|
pub fn scene_text(doc : Document) -> String {
  let out = StringBuilder()
  for scene in scenes(doc) {
    out.write_stringview(
      ("\{scene.ordinal}. " +
      scene.heading +
      " [line \{scene.line}; spoken lines \{scene.dialogue_lines}]\n")[:],
    )
    out.write_stringview(("   cast: " + scene.characters.join(", ") + "\n")[:])
  }
  out.to_string()
}
