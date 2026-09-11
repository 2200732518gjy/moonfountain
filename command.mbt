///|
pub(all) struct CommandResult {
  status : Int
  stdout : String
  stderr : String
} derive(Eq, Debug, ToJson)

///|
pub fn usage() -> String {
  "MoonFountain 0.1.0\nUsage: moonfountain <json|json-source|html|scenes|cast|lint|cues> FILE|- [CHARACTER]\nJSON hides raw source/annotations unless json-source is selected.\n"
}

///|
/// Host-independent dispatch; status 1 = findings, 2 = invalid invocation.
pub fn command(
  mode : String,
  source : String,
  argument? : String = "",
) -> CommandResult {
  if mode == "help" {
    return { status: 0, stdout: usage(), stderr: "", }
  }
  if !["json", "json-source", "html", "scenes", "cast", "lint", "cues"].contains(
      mode,
    ) ||
    (mode == "cues" && argument == "") ||
    (mode != "cues" && argument != "") {
    return { status: 2, stdout: "", stderr: usage(), }
  }
  let doc = parse(source)
  if doc.diagnostics.any(fn(d) { d.code == "FNT900" }) {
    return {
      status: 2,
      stdout: "",
      stderr: doc.diagnostics.map(fn(d) { d.format() }).join("\n") + "\n",
    }
  }
  let stdout = match mode {
    "json" => report_json(doc).stringify() + "\n"
    "json-source" => report_json(doc, include_source=true).stringify() + "\n"
    "html" => render_html(doc)
    "scenes" => scene_text(doc)
    "cast" => cast(doc).to_json().stringify() + "\n"
    "cues" => {
      if cue_sheet(doc, argument).is_empty() {
        return {
          status: 2,
          stdout: "",
          stderr: "Unknown role: " + argument + "\n",
        }
      }
      cue_text(doc, argument)
    }
    "lint" => lint(doc).map(fn(d) { d.format() }).join("\n") + "\n"
    _ => ""
  }
  {
    status: if mode == "lint" && !lint(doc).is_empty() {
      1
    } else {
      0
    },
    stdout,
    stderr: "",
  }
}
