import gen/types.{type FunctionCallArgValue}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// The name of the argument.
///
pub fn name(function_call_arg_value: FunctionCallArgValue) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        function_call_arg_value.query_tree,
        [query_tree.new("name", dict.new())],
      ]),
    )
  response
}

/// The value of the argument represented as a string of the JSON serialization.
///
pub fn value(function_call_arg_value: FunctionCallArgValue) -> JSON {
  let assert Ok(response) =
    compute_query(
      list.concat([
        function_call_arg_value.query_tree,
        [query_tree.new("value", dict.new())],
      ]),
    )
  response
}
