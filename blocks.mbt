///|
fn special_block(
  line : SourceLine,
  text : String,
  before : Bool,
  after : Bool,
) -> Element? {
  if text.has_prefix("#") {
    let mut n = 0
    while n < text.length() && text[n] == '#' {
      n += 1
    }
    return Some(element(line, Section, stripped(text[n:].to_owned()), level=n))
  }
  if text.length() >= 3 && text.to_array().all(fn(c) { c == '=' }) {
    return Some(element(line, PageBreak, ""))
  }
  if text.has_prefix("=") {
    return Some(element(line, Synopsis, stripped(text[1:].to_owned())))
  }
  if text.has_prefix("~") {
    return Some(element(line, Lyric, text[1:].to_owned()))
  }
  if text.has_prefix(">") && text.has_suffix("<") && text.length() >= 2 {
    return Some(
      element(line, Centered, stripped(text[1:text.length() - 1].to_owned())),
    )
  }
  if text.has_prefix(">") {
    return Some(element(line, Transition, stripped(text[1:].to_owned())))
  }
  if before &&
    after &&
    text.has_suffix("TO:") &&
    line.content().has_suffix("TO:") &&
    text == text.to_upper() {
    return Some(element(line, Transition, text))
  }
  None
}
