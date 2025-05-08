import gen/types.{type EnvVariable}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// The environment variable name.
///
pub fn name(env_variable: EnvVariable) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        env_variable.query_tree,
        [query_tree.new("name", dict.new())],
      ]),
    )
  response
}

/// The environment variable value.
///
pub fn value(env_variable: EnvVariable) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        env_variable.query_tree,
        [query_tree.new("value", dict.new())],
      ]),
    )
  response
}
