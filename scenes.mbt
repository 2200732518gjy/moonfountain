///|
pub(all) struct Scene {
  ordinal : Int
  number : String
  heading : String
  line : Int
  end_line : Int
  start : Int
  end : Int
  characters : Array[String]
  dialogue_lines : Int
} derive(Eq, Debug, ToJson)

///|
/// Scene ranges include following blank lines, stopping before the next heading.
/// Preamble is intentionally not fabricated as a numbered scene.
pub fn scenes(doc : Document) -> Array[Scene] {
  let headings : Array[Int] = []
  for i = 0; i < doc.elements.length(); i = i + 1 {
    if doc.elements[i].kind == SceneHeading {
      headings.push(i)
    }
  }
  let out : Array[Scene] = []
  let final_line = source_lines(doc.source).length()
  for n = 0; n < headings.length(); n = n + 1 {
    let e = doc.elements[headings[n]]
    let stop = if n + 1 < headings.length() {
      headings[n + 1]
    } else {
      doc.elements.length()
    }
    let characters : Array[String] = []
    let mut dialogue_lines = 0
    for i = headings[n] + 1; i < stop; i = i + 1 {
      let item = doc.elements[i]
      if item.kind == Character && !characters.contains(item.text) {
        characters.push(item.text)
      }
      if item.kind == Dialogue {
        dialogue_lines += 1
      }
    }
    out.push({
      ordinal: n + 1,
      number: e.detail,
      heading: e.text,
      line: e.line,
      end_line: if stop < doc.elements.length() {
        doc.elements[stop].line - 1
      } else {
        final_line
      },
      start: e.start,
      end: if stop < doc.elements.length() {
        doc.elements[stop].start
      } else {
        doc.source.length()
      },
      characters,
      dialogue_lines,
    })
  }
  out
}

///|
/// 0 denotes preamble or a document without scene headings.
pub fn scene_at_line(items : Array[Scene], line : Int) -> Int {
  let mut low = 0
  let mut high = items.length()
  while low < high {
    let mid = low + (high - low) / 2
    if items[mid].line <= line {
      low = mid + 1
    } else {
      high = mid
    }
  }
  if low == 0 {
    0
  } else if line <= items[low - 1].end_line {
    items[low - 1].ordinal
  } else {
    0
  }
}
