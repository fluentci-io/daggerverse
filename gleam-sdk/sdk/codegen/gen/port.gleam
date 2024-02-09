import gen/types.{type Port}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// The port description.
///
pub fn description(port: Port) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([port.query_tree, [query_tree.new("description", dict.new())]]),
    )
  response
}

/// The port number.
///
pub fn port(port: Port) -> Int {
  let assert Ok(response) =
    compute_query(
      list.concat([port.query_tree, [query_tree.new("port", dict.new())]]),
    )
  response
}

/// The transport layer network protocol.
///
pub fn protocol(port: Port) -> NetworkProtocol {
  let assert Ok(response) =
    compute_query(
      list.concat([port.query_tree, [query_tree.new("protocol", dict.new())]]),
    )
  response
}
