import gen/types.{type Secret}
import gen/secret_id.{type SecretID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// The identifier for this secret.
///
pub fn id(secret: Secret) -> SecretID {
  let assert Ok(response) =
    compute_query(
      list.concat([secret.query_tree, [query_tree.new("id", dict.new())]]),
    )
  response
}

/// The value of this secret.
///
pub fn plaintext(secret: Secret) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([secret.query_tree, [query_tree.new("plaintext", dict.new())]]),
    )
  response
}
