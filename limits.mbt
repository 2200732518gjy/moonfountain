///|
pub(all) struct Limits {
  max_units : Int
  max_lines : Int
  max_line_units : Int
} derive(Eq, Debug, ToJson)

///|
pub fn Limits::default() -> Limits {
  { max_units: 262144, max_lines: 20000, max_line_units: 8192, }
}

///|
pub fn parse(source : String) -> Document {
  parse_with_limits(source, Limits::default())
}

///|
/// Limits may be tightened, not raised beyond hard safety ceilings. Refusal
/// returns original source and FNT900, with no misleading partial parse.
pub fn parse_with_limits(source : String, limits : Limits) -> Document {
  let hard = Limits::default()
  let mut reason = ""
  let mut line = 1
  if limits.max_units < 1 ||
    limits.max_units > hard.max_units ||
    limits.max_lines < 1 ||
    limits.max_lines > hard.max_lines ||
    limits.max_line_units < 1 ||
    limits.max_line_units > hard.max_line_units {
    reason = "Invalid limits: values must be positive and no greater than default ceilings"
  } else if source.length() > limits.max_units {
    reason = "Input exceeds UTF-16 unit budget"
  } else {
    let lines = source_lines(source)
    if lines.length() > limits.max_lines {
      reason = "Input exceeds line budget"
    } else {
      for item in lines {
        if item.end - item.start > limits.max_line_units {
          reason = "Input exceeds per-line UTF-16 unit budget"
          line = item.number
          break
        }
      }
    }
  }
  if reason != "" {
    return {
      source,
      elements: [],
      annotations: [],
      diagnostics: [{ code: "FNT900", line, message: reason, }],
    }
  }
  parse_unchecked(source)
}
