///|
/// Semantic findings supplement (never replace) parser diagnostics.
/// Findings do not modify source or guess at a repair.
pub fn lint(doc : Document) -> Array[Diagnostic] {
  let out = doc.diagnostics.copy()
  let numbers : Map[String, Int] = Map([])
  let names : Map[String, String] = Map([])
  for e in doc.elements {
    if e.kind == SceneHeading {
      if e.detail != "" {
        match numbers.get(e.detail) {
          Some(line) =>
            out.push({
              code: "FNT101",
              line: e.line,
              message: "Duplicate scene number \{e.detail}; first seen at line \{line}",
            })
          None => numbers.set(e.detail, e.line)
        }
      } else if e.text.has_suffix("#") {
        out.push({
          code: "FNT102",
          line: e.line,
          message: "Malformed scene number retained in heading",
        })
      }
    }
    if e.kind == Character {
      let folded = e.text.to_upper()
      match names.get(folded) {
        Some(name) if name != e.text =>
          out.push({
            code: "FNT103",
            line: e.line,
            message: "Case-distinct role \{e.text} resembles \{name}; identities remain separate",
          })
        None => names.set(folded, e.text)
        _ => ()
      }
    }
    if e.kind == Dialogue && e.text.has_prefix("(") && !e.text.has_suffix(")") {
      out.push({
        code: "FNT104",
        line: e.line,
        message: "Unclosed parenthetical retained as dialogue",
      })
    }
    if e.kind == Action && stripped(e.text).has_prefix("@") {
      out.push({
        code: "FNT105",
        line: e.line,
        message: "Isolated or empty forced character cue retained as action",
      })
    }
  }
  for turn in turns(doc) {
    if turn.dialogue.length() == 0 {
      out.push({
        code: "FNT106",
        line: turn.line,
        message: "Character turn contains directions but no spoken dialogue",
      })
    }
  }
  out
}

///|
pub fn Diagnostic::format(self : Diagnostic) -> String {
  "line \{self.line}: \{self.code}: \{self.message}"
}
