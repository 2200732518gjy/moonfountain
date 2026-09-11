///|
pub(all) struct Inline {
  text : String
  bold : Bool
  italic : Bool
  underline : Bool
} derive(Eq, Debug, ToJson)

///|
/// Fountain inline emphasis. At depth 16 further markup stays literal.
pub fn inline_text(text : String) -> Array[Inline] {
  inline_scan(text, false, false, false, 0)
}

///|
fn unit_width(text : String, i : Int) -> Int {
  if text[i].to_int() >= 0xD800 &&
    text[i].to_int() <= 0xDBFF &&
    i + 1 < text.length() {
    2
  } else {
    1
  }
}

///|
fn inline_scan(
  text : String,
  bold : Bool,
  italic : Bool,
  underline : Bool,
  depth : Int,
) -> Array[Inline] {
  let out : Array[Inline] = []
  if depth >= 16 {
    return [{ text, bold, italic, underline }]
  }
  let mut i = 0
  let mut start = 0
  while i < text.length() {
    if text[i] == '\\' &&
      i + 1 < text.length() &&
      (text[i + 1] == '*' || text[i + 1] == '_' || text[i + 1] == '\\') {
      if start < i {
        out.push({ text: text[start:i].to_owned(), bold, italic, underline })
      }
      out.push({ text: text[i + 1:i + 2].to_owned(), bold, italic, underline })
      i += 2
      start = i
      continue
    }
    if text[i] == '*' || text[i] == '_' {
      let mark = text[i]
      let mut width = 1
      while i + width < text.length() && text[i + width] == mark {
        width += 1
      }
      let mut close = -1
      if (mark == '_' && width == 1) || (mark == '*' && width <= 3) {
        let mut j = i + width
        if j < text.length() && text[j] != ' ' && text[j] != '\t' {
          while j < text.length() {
            if text[j] == '\\' && j + 1 < text.length() {
              j += 2
              continue
            }
            if text[j] == mark {
              let mut run = 1
              while j + run < text.length() && text[j + run] == mark {
                run += 1
              }
              if run == width &&
                j > i + width &&
                text[j - 1] != ' ' &&
                text[j - 1] != '\t' {
                close = j
                break
              }
              j += run
            } else {
              j += 1
            }
          }
        }
      }
      if close >= 0 {
        if start < i {
          out.push({ text: text[start:i].to_owned(), bold, italic, underline })
        }
        let nested = inline_scan(
          text[i + width:close].to_owned(),
          bold || (mark == '*' && width >= 2),
          italic || (mark == '*' && width != 2),
          underline || mark == '_',
          depth + 1,
        )
        for part in nested {
          out.push(part)
        }
        i = close + width
        start = i
      } else {
        i += width
      }
    } else {
      i += unit_width(text, i)
    }
  }
  if start < text.length() {
    out.push({ text: text[start:].to_owned(), bold, italic, underline })
  }
  out
}

///|
pub fn plain_text(text : String) -> String {
  let out = StringBuilder()
  for part in inline_text(text) {
    out.write_stringview(part.text[:])
  }
  out.to_string()
}
