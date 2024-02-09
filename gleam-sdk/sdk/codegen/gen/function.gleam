import gen/types.{type Function, type TypeDef}
import gen/function_id.{type FunctionID}
import gen/type_def_id.{type TypeDefID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// Arguments accepted by this function, if any
///
pub fn args(function: Function) -> List(FunctionArg) {
  let assert Ok(response) =
    compute_query(
      list.concat([function.query_tree, [query_tree.new("args", dict.new())]]),
    )
  response
}

/// A doc string for the function, if any
///
pub fn description(function: Function) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        function.query_tree,
        [query_tree.new("description", dict.new())],
      ]),
    )
  response
}

/// The ID of the function
///
pub fn id(function: Function) -> FunctionID {
  let assert Ok(response) =
    compute_query(
      list.concat([function.query_tree, [query_tree.new("id", dict.new())]]),
    )
  response
}

/// The name of the function
///
pub fn name(function: Function) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([function.query_tree, [query_tree.new("name", dict.new())]]),
    )
  response
}

/// The type returned by this function
///
pub fn return_type(function: Function) -> TypeDef {
  base_client.new(
    list.concat([
      function.query_tree,
      [query_tree.new("returnType", dict.new())],
    ]),
  )
}

/// Returns the function with the provided argument
///
pub fn with_arg(
  function: Function,
  name: String,
  type_def: TypeDefID,
  description: String,
  default_value: JSON,
) -> Function {
  base_client.new(
    list.concat([
      function.query_tree,
      [
        query_tree.new(
          "withArg",
          dict.new()
          |> dict.insert("name", dynamic.from(name))
          |> dict.insert("typeDef", dynamic.from(type_def))
          |> dict.insert("description", dynamic.from(description))
          |> dict.insert("defaultValue", dynamic.from(default_value)),
        ),
      ],
    ]),
  )
}

/// Returns the function with the doc string
///
pub fn with_description(function: Function, description: String) -> Function {
  base_client.new(
    list.concat([
      function.query_tree,
      [
        query_tree.new(
          "withDescription",
          dict.new()
          |> dict.insert("description", dynamic.from(description)),
        ),
      ],
    ]),
  )
}
