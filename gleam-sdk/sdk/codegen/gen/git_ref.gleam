import gen/types.{type Directory, type GitRef}
import gen/git_ref_id.{type GitRefID}
import gen/socketid.{type SocketID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// The resolved commit id at this ref.
///
pub fn commit(git_ref: GitRef) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([git_ref.query_tree, [query_tree.new("commit", dict.new())]]),
    )
  response
}

/// Retrieves the content-addressed identifier of the git ref.
///
pub fn id(git_ref: GitRef) -> GitRefID {
  let assert Ok(response) =
    compute_query(
      list.concat([git_ref.query_tree, [query_tree.new("id", dict.new())]]),
    )
  response
}

/// The filesystem tree at this ref.
///
pub fn tree(
  git_ref: GitRef,
  ssh_known_hosts: String,
  ssh_auth_socket: SocketID,
) -> Directory {
  base_client.new(
    list.concat([
      git_ref.query_tree,
      [
        query_tree.new(
          "tree",
          dict.new()
          |> dict.insert("sshKnownHosts", dynamic.from(ssh_known_hosts))
          |> dict.insert("sshAuthSocket", dynamic.from(ssh_auth_socket)),
        ),
      ],
    ]),
  )
}
