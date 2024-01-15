import gen/types.{type FunctionCall}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// The argument values the function is being invoked with.
///
pub fn input_args(function_call: FunctionCall) -> List(FunctionCallArgValue) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        function_call.query_tree,
        [query_tree.new("inputArgs", dict.new())],
      ]),
    )
  response
}

/// The name of the function being called.
///
pub fn name(function_call: FunctionCall) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        function_call.query_tree,
        [query_tree.new("name", dict.new())],
      ]),
    )
  response
}

/// The value of the parent object of the function being called.
/// If the function is &quot;top-level&quot; to the module, this is always an empty object.
///
pub fn parent(function_call: FunctionCall) -> JSON {
  let assert Ok(response) =
    compute_query(
      list.concat([
        function_call.query_tree,
        [query_tree.new("parent", dict.new())],
      ]),
    )
  response
}

/// The name of the parent object of the function being called.
/// If the function is &quot;top-level&quot; to the module, this is the name of the module.
///
pub fn parent_name(function_call: FunctionCall) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        function_call.query_tree,
        [query_tree.new("parentName", dict.new())],
      ]),
    )
  response
}

/// Set the return value of the function call to the provided value.
/// The value should be a string of the JSON serialization of the return value.
///
pub fn return_value(function_call: FunctionCall, value: JSON) -> Void {
  let assert Ok(response) =
    compute_query(
      list.concat([
        function_call.query_tree,
        [
          query_tree.new(
            "returnValue",
            dict.new()
            |> dict.insert("value", dynamic.from(value)),
          ),
        ],
      ]),
    )
  response
}
