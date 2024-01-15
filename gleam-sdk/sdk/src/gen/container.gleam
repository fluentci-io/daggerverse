import gen/container_id.{type ContainerID}
import gen/types.{type Container, type Directory, type File, type Service}
import utils.{compute_query}
import gleam/dict
import gleam/list
import gen/query_tree
import gen/base_client
import gleam/dynamic
import gleam/io

/// A unique identifier for this container .
///  
pub fn id(container: Container) -> ContainerID {
  ""
}

/// Turn the container into a Service.
///
/// Be sure to set any exposed ports before this conversion.
/// 
pub fn as_service(container: Container) -> Service {
  container
}

/// Returns a File representing the container serialized to a tarball.
/// 
pub fn as_tarball(container: Container) -> File {
  container
}

/// Initializes this container from a Dockerfile build.
/// 
pub fn build(container: Container) -> Container {
  container
}

/// Retrieves default arguments for future commands.
/// 
pub fn default_args(container: Container) -> List(String) {
  []
}

/// Retrieves a directory at the given path.
/// 
pub fn directory(container: Container, path: String) -> Directory {
  todo
}

/// 
/// 
pub fn from(container: Container, address: String) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "from",
          dict.new()
          |> dict.insert("address", dynamic.from(address)),
        ),
      ],
    ]),
  )
}

pub fn with_exec(container: Container, exec: List(String)) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withExec",
          dict.new()
          |> dict.insert("args", dynamic.from(exec)),
        ),
      ],
    ]),
  )
}

pub fn stdout(container: Container) -> String {
  compute_query(
    list.concat([container.query_tree, [query_tree.new("stdout", dict.new())]]),
  )
  "stdout"
}
