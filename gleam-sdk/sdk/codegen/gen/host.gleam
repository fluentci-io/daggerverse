import gen/types.{
  type Directory, type File, type Host, type Secret, type Service, type Socket,
}
import gen/service_id.{type ServiceID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// Accesses a directory on the host.
///
pub fn directory(
  host: Host,
  path: String,
  exclude: List(String),
  include: List(String),
) -> Directory {
  base_client.new(
    list.concat([
      host.query_tree,
      [
        query_tree.new(
          "directory",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("exclude", dynamic.from(exclude))
          |> dict.insert("include", dynamic.from(include)),
        ),
      ],
    ]),
  )
}

/// Accesses a file on the host.
///
pub fn file(host: Host, path: String) -> File {
  base_client.new(
    list.concat([
      host.query_tree,
      [
        query_tree.new(
          "file",
          dict.new()
          |> dict.insert("path", dynamic.from(path)),
        ),
      ],
    ]),
  )
}

/// Creates a service that forwards traffic to a specified address via the host.
///
pub fn service(host: Host, ports: List(PortForward), host: String) -> Service {
  base_client.new(
    list.concat([
      host.query_tree,
      [
        query_tree.new(
          "service",
          dict.new()
          |> dict.insert("ports", dynamic.from(ports))
          |> dict.insert("host", dynamic.from(host)),
        ),
      ],
    ]),
  )
}

/// Sets a secret given a user-defined name and the file path on the host, and returns the secret.
/// The file is limited to a size of 512000 bytes.
///
pub fn set_secret_file(host: Host, name: String, path: String) -> Secret {
  base_client.new(
    list.concat([
      host.query_tree,
      [
        query_tree.new(
          "setSecretFile",
          dict.new()
          |> dict.insert("name", dynamic.from(name))
          |> dict.insert("path", dynamic.from(path)),
        ),
      ],
    ]),
  )
}

/// Creates a tunnel that forwards traffic from the host to a service.
///
pub fn tunnel(
  host: Host,
  service: ServiceID,
  native: Bool,
  ports: List(PortForward),
) -> Service {
  base_client.new(
    list.concat([
      host.query_tree,
      [
        query_tree.new(
          "tunnel",
          dict.new()
          |> dict.insert("service", dynamic.from(service))
          |> dict.insert("native", dynamic.from(native))
          |> dict.insert("ports", dynamic.from(ports)),
        ),
      ],
    ]),
  )
}

/// Accesses a Unix socket on the host.
///
pub fn unix_socket(host: Host, path: String) -> Socket {
  base_client.new(
    list.concat([
      host.query_tree,
      [
        query_tree.new(
          "unixSocket",
          dict.new()
          |> dict.insert("path", dynamic.from(path)),
        ),
      ],
    ]),
  )
}
