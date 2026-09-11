///|
/// UTF-16 offsets [start,end), excluding line terminator; next includes it.
pub(all) struct SourceLine {
  number : Int
  start : Int
  end : Int
  next : Int
  text : String
} derive(Eq, Debug, ToJson)

///|
/// Exact source index. A final newline produces a final empty line.
pub fn source_lines(source : String) -> Array[SourceLine] {
  let out : Array[SourceLine] = []
  let mut start = 0
  let mut i = 0
  while i < source.length() {
    if source[i] == '\n' || source[i] == '\r' {
      let end = i
      if source[i] == '\r' && i + 1 < source.length() && source[i + 1] == '\n' {
        i += 1
      }
      i += 1
      out.push({
        number: out.length() + 1,
        start,
        end,
        next: i,
        text: source[start:end].to_owned(),
      })
      start = i
    } else {
      i += 1
    }
  }
  out.push({
    number: out.length() + 1,
    start,
    end: i,
    next: i,
    text: source[start:i].to_owned(),
  })
  out
}

///|
fn stripped(s : String) -> String {
  s.trim(chars=" \t").to_owned()
}

///|
pub fn SourceLine::content(self : SourceLine) -> String {
  if self.number == 1 && self.text.has_prefix("\u{FEFF}") {
    self.text[1:].to_owned()
  } else {
    self.text
  }
}
