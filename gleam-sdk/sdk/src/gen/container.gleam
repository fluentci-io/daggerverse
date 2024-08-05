import gen/container_id.{type ContainerID}
import gen/types.{type Container, type Directory, type File, type Service}
import utils.{compute_query}
import gleam/dict
import gleam/list
import gen/query_tree
import gen/base_client
import gleam/dynamic

/// A unique identifier for this container .
///  
pub fn id(container: Container) -> ContainerID {
  let assert Ok(response) =
    compute_query(
      list.concat([container.query_tree, [query_tree.new("id", dict.new())]]),
    )
  response
}

/// Turn the container into a Service.
///
/// Be sure to set any exposed ports before this conversion.
/// 
pub fn as_service(container: Container) -> Service {
  base_client.new(
    list.concat([
      container.query_tree,
      [query_tree.new("asService", dict.new())],
    ]),
  )
}

/// Returns a File representing the container serialized to a tarball.
/// 
pub fn as_tarball(container: Container) -> File {
  container
}

/// Initializes this container from a Dockerfile build.
/// 
pub fn build(container: Container, context: Directory) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "build",
          dict.new()
          |> dict.insert("context", dynamic.from(context)),
        ),
      ],
    ]),
  )
}

/// Retrieves default arguments for future commands.
/// 
pub fn default_args(container: Container) -> List(String) {
  let assert Ok(_) =
    compute_query(
      list.concat([
        container.query_tree,
        [query_tree.new("defaultArgs", dict.new())],
      ]),
    )
  []
}

/// Retrieves a directory at the given path.
/// 
pub fn directory(container: Container, path: String) -> Directory {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "directory",
          dict.new()
          |> dict.insert("path", dynamic.from(path)),
        ),
      ],
    ]),
  )
}

/// Builds a new Docker container from this directory.
/// 
pub fn docker_build(container: Container) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [query_tree.new("dockerBuild", dict.new())],
    ]),
  )
}

/// Builds a new Docker container from this directory. 
/// 
pub fn docker_build_opts(container: Container) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [query_tree.new("dockerBuild", dict.new())],
    ]),
  )
}

/// Returns a list of files and directories at the given path.
/// 
pub fn entries(container: Container) -> Container {
  base_client.new(
    list.concat([container.query_tree, [query_tree.new("entries", dict.new())]]),
  )
}

/// Returns a list of files and directories at the given path.
/// 
pub fn entries_opts(container: Container) -> Container {
  base_client.new(
    list.concat([container.query_tree, [query_tree.new("entries", dict.new())]]),
  )
}

/// Writes the contents of the directory to a path on the host.
/// 
pub fn export(container: Container, path: String) -> Bool {
  let assert Ok(_) =
    compute_query(
      list.concat([
        container.query_tree,
        [
          query_tree.new(
            "export",
            dict.new()
            |> dict.insert("path", dynamic.from(path)),
          ),
        ],
      ]),
    )
  True
}

/// Retrieves a file at the given path.
/// 
pub fn file(container: Container, path: String) -> File {
  base_client.new(
    list.concat([
      container.query_tree,
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

/// Returns a list of files and directories that matche the given pattern.
/// 
pub fn glob(container: Container, pattern: String) -> List(String) {
  let assert Ok(_) =
    compute_query(
      list.concat([
        container.query_tree,
        [
          query_tree.new(
            "glob",
            dict.new()
            |> dict.insert("pattern", dynamic.from(pattern)),
          ),
        ],
      ]),
    )
  []
}

/// Creates a named sub-pipeline.
/// 
pub fn pipeline(container: Container, name: String) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "pipeline",
          dict.new()
          |> dict.insert("name", dynamic.from(name)),
        ),
      ],
    ]),
  )
}

/// Creates a named sub-pipeline.
/// 
pub fn pipeline_opts(container: Container, name: String) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "pipeline",
          dict.new()
          |> dict.insert("name", dynamic.from(name)),
        ),
      ],
    ]),
  )
}

/// Force evaluation in the engine.
///
pub fn sync(container: Container) -> Directory {
  let assert Ok(_) =
    compute_query(
      list.concat([container.query_tree, [query_tree.new("sync", dict.new())]]),
    )
  container
}

/// Retrieves this directory plus a directory written at the given path.
/// 
pub fn with_directory(
  container: Container,
  path: String,
  directory: Directory,
) -> Directory {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withDirectory",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("directory", dynamic.from(directory)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory plus a directory written at the given path.
/// 
pub fn with_directory_opts(
  container: Container,
  path: String,
  directory: Directory,
) -> Directory {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withDirectory",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("directory", dynamic.from(directory)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory plus the contents of the given file copied to the given path.
/// 
pub fn with_file(container: Container, path: String, source: File) -> Directory {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withFile",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("file", dynamic.from(source)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory plus the contents of the given file copied to the given path.
/// 
pub fn with_file_opts(
  container: Container,
  path: String,
  source: File,
) -> Directory {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withFile",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("file", dynamic.from(source)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory plus a new directory created at the given path.
/// 
pub fn with_new_directory(container: Container, path: String) -> Directory {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withNewDirectory",
          dict.new()
          |> dict.insert("path", dynamic.from(path)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory plus a new directory created at the given path.
/// 
pub fn with_new_directory_opts(container: Container, path: String) -> Directory {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withNewDirectory",
          dict.new()
          |> dict.insert("path", dynamic.from(path)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory plus a new file written at the given path.
/// 
pub fn with_new_file(
  container: Container,
  path: String,
  contents: String,
) -> Directory {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withNewFile",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("contents", dynamic.from(contents)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory plus a new file written at the given path.
/// 
pub fn with_new_file_opts(
  container: Container,
  path: String,
  contents: String,
) -> Directory {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withNewFile",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("contents", dynamic.from(contents)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory with all file/dir timestamps set to the given time.
/// 
pub fn with_timestamps(container: Container, timestamp: Int) -> Directory {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withTimestamps",
          dict.new()
          |> dict.insert("timestamp", dynamic.from(timestamp)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory with the directory at the given path removed.
/// 
pub fn without_directory(container: Container, path: String) -> Directory {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withoutDirectory",
          dict.new()
          |> dict.insert("path", dynamic.from(path)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory with the file at the given path removed.
/// 
pub fn without_file(container: Container, path: String) -> Directory {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withoutFile",
          dict.new()
          |> dict.insert("path", dynamic.from(path)),
        ),
      ],
    ]),
  )
}

/// Initializes this container from a pulled base image.
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

/// Retrieves this container after executing the specified command inside it.
///
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

/// The output stream of the last executed command.
/// 
pub fn stdout(container: Container) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([container.query_tree, [query_tree.new("stdout", dict.new())]]),
    )
  response
}
