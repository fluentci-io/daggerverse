import gen/function_id.{type FunctionId}

pub type Function {
  Function(id: FunctionId)
}

pub fn new(id: FunctionId) -> Function {
  Function(id)
}
