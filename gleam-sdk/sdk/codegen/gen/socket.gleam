import gen/types.{type Socket}
import gen/socket_id.{type SocketID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// The content-addressed identifier of the socket.
///
pub fn id(socket: Socket) -> SocketID {
  let assert Ok(response) =
    compute_query(
      list.concat([socket.query_tree, [query_tree.new("id", dict.new())]]),
    )
  response
}
