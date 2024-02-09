import gen/types.{type Label}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// The label name.
///
pub fn name(label: Label) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([label.query_tree, [query_tree.new("name", dict.new())]]),
    )
  response
}

/// The label value.
///
pub fn value(label: Label) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([label.query_tree, [query_tree.new("value", dict.new())]]),
    )
  response
}
