/// Key value object that represents a Pipeline label.
///
pub type PipelineLabel {
  PipelineLabel(name: String, value: String)
}

pub fn new(name: String, value: String) -> PipelineLabel {
  PipelineLabel(name, value)
}
