pub type CurrentTypeDefsResponse {
  CurrentTypeDefsResponse
}

pub type TypeDef {
  TypeDef(id: String)
}

pub fn new(id: String) -> TypeDef {
  TypeDef(id)
}
