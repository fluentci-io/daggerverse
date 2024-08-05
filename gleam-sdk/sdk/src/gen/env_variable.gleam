import gen/types.{type EnvVariable}
import gen/env_variable_id.{type EnvVariableID}
import gen/query_tree
import utils.{compute_query}
import gleam/list
import gleam/dict

/// A unique identifier for this EnvVariable.
/// 
pub fn id(env_variable: EnvVariable) -> EnvVariableID {
  let assert Ok(response) =
    compute_query(
      list.concat([env_variable.query_tree, [query_tree.new("id", dict.new())]]),
    )
  response
}

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
