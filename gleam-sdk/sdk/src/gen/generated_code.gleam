import gen/generated_code_id.{type GeneratedCodeId}

pub type GeneratedCode {
  GeneratedCode(id: GeneratedCodeId)
}

pub fn new(id: GeneratedCodeId) -> GeneratedCode {
  GeneratedCode(id)
}
