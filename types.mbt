///|
pub(all) enum Kind {
  Action
  SceneHeading
  Character
  Dialogue
  Parenthetical
  Transition
  Centered
  Lyric
  Section
  Synopsis
  PageBreak
  Note
  Boneyard
  TitleField
} derive(Eq, Debug, ToJson)

///|
pub(all) struct Element {
  kind : Kind
  text : String
  line : Int
  start : Int
  end : Int
  detail : String
  level : Int
  dual : Bool
} derive(Eq, Debug, ToJson)

///|
pub(all) struct Diagnostic {
  code : String
  line : Int
  message : String
} derive(Eq, Debug, ToJson)

///|
pub(all) struct Document {
  source : String
  elements : Array[Element]
  diagnostics : Array[Diagnostic]
  annotations : Array[Element]
} derive(Eq, Debug, ToJson)

///|
fn element(
  line : SourceLine,
  kind : Kind,
  text : String,
  detail? : String = "",
  level? : Int = 0,
  dual? : Bool = false,
) -> Element {
  {
    kind,
    text,
    line: line.number,
    start: line.start,
    end: line.end,
    detail,
    level,
    dual,
  }
}
