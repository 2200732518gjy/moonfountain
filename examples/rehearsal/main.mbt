///|
fn main {
  let source = "INT. BOOTH - NIGHT #1#\n\nADA\nReady?\n\n@林\nYes.\n(listens)\nNow.\n"
  let doc = @fountain.parse(source)
  try! assert_eq(@fountain.scenes(doc).length(), 1)
  try! assert_eq(@fountain.cast(doc).length(), 2)
  try! assert_eq(@fountain.lint(doc).length(), 0)
  let cues = @fountain.cue_sheet(doc, "林")
  try! assert_eq(cues.length(), 1)
  try! assert_eq(cues[0].preceding_text, "Ready?")
  try! assert_eq(cues[0].parts[1].direction, true)
  println(@fountain.scene_text(doc))
  println(@fountain.cue_text(doc, "林"))
}
