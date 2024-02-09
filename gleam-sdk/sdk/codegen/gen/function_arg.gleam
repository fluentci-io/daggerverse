import gen/types.{type FunctionArg, type TypeDef}
import gen/json.{type JSON}
import gen/function_arg_id.{type FunctionArgID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// A default value to use for this argument when not explicitly set by the caller, if any
///
pub fn default_value(function_arg: FunctionArg) -> JSON {
  let assert Ok(response) =
    compute_query(
      list.concat([
        function_arg.query_tree,
        [query_tree.new("defaultValue", dict.new())],
      ]),
    )
  response
}

/// A doc string for the argument, if any
///
pub fn description(function_arg: FunctionArg) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        function_arg.query_tree,
        [query_tree.new("description", dict.new())],
      ]),
    )
  response
}

/// The ID of the argument
///
pub fn id(function_arg: FunctionArg) -> FunctionArgID {
  let assert Ok(response) =
    compute_query(
      list.concat([function_arg.query_tree, [query_tree.new("id", dict.new())]]),
    )
  response
}

/// The name of the argument
///
pub fn name(function_arg: FunctionArg) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        function_arg.query_tree,
        [query_tree.new("name", dict.new())],
      ]),
    )
  response
}

/// The type of the argument
///
pub fn type_def(function_arg: FunctionArg) -> TypeDef {
  base_client.new(
    list.concat([
      function_arg.query_tree,
      [query_tree.new("typeDef", dict.new())],
    ]),
  )
}
