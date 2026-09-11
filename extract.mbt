///|
/// Exact original source for a one-based inclusive line range. Includes each
/// selected line terminator; invalid ranges return None rather than clamp.
pub fn extract_lines(doc : Document, first : Int, last : Int) -> String? {
  let lines = source_lines(doc.source)
  if first < 1 || last < first || last > lines.length() {
    return None
  }
  Some(doc.source[lines[first - 1].start:lines[last - 1].next].to_owned())
}

///|
/// Ordinals are one-based, not scene-number labels (which can be duplicated).
pub fn extract_scene(doc : Document, ordinal : Int) -> String? {
  let ss = scenes(doc)
  if ordinal < 1 || ordinal > ss.length() {
    return None
  }
  let scene = ss[ordinal - 1]
  Some(doc.source[scene.start:scene.end].to_owned())
}

///|
/// Select scenes containing this exact spoken role in original order.
pub fn scenes_for_role(doc : Document, character : String) -> Array[Scene] {
  scenes(doc).filter(fn(scene) { scene.characters.contains(character) })
}

///|
/// Raw extracts include comments/title metadata if present in the range.
pub fn turn_source(doc : Document, turn_index : Int) -> String? {
  let ts = turns(doc)
  if turn_index < 0 || turn_index >= ts.length() {
    return None
  }
  extract_lines(doc, ts[turn_index].line, ts[turn_index].end_line)
}
