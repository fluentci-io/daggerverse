/// Key value object that represents a build argument.
///
pub type BuildArg {
  BuildArg(name: String, value: String)
}

pub fn new(name: String, value: String) -> BuildArg {
  BuildArg(name, value)
}
