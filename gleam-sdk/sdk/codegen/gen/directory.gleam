import gen/types.{type Container, type Directory, type File, type Module}
import gen/directory_id.{type DirectoryID}
import gen/file_id.{type FileID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// Load the directory as a Dagger module
///
pub fn as_module(directory: Directory, source_subpath: String) -> Module {
  base_client.new(
    list.concat([
      directory.query_tree,
      [
        query_tree.new(
          "asModule",
          dict.new()
          |> dict.insert("sourceSubpath", dynamic.from(source_subpath)),
        ),
      ],
    ]),
  )
}

/// Gets the difference between this directory and an another directory.
///
pub fn diff(directory: Directory, other: DirectoryID) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
      [
        query_tree.new(
          "diff",
          dict.new()
          |> dict.insert("other", dynamic.from(other)),
        ),
      ],
    ]),
  )
}

/// Retrieves a directory at the given path.
///
pub fn directory(directory: Directory, path: String) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
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
pub fn docker_build(
  directory: Directory,
  dockerfile: String,
  platform: Platform,
  build_args: List(BuildArg),
  target: String,
  secrets: List(SecretID),
) -> Container {
  base_client.new(
    list.concat([
      directory.query_tree,
      [
        query_tree.new(
          "dockerBuild",
          dict.new()
          |> dict.insert("dockerfile", dynamic.from(dockerfile))
          |> dict.insert("platform", dynamic.from(platform))
          |> dict.insert("buildArgs", dynamic.from(build_args))
          |> dict.insert("target", dynamic.from(target))
          |> dict.insert("secrets", dynamic.from(secrets)),
        ),
      ],
    ]),
  )
}

/// Returns a list of files and directories at the given path.
///
pub fn entries(directory: Directory, path: String) -> List(String) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        directory.query_tree,
        [
          query_tree.new(
            "entries",
            dict.new()
            |> dict.insert("path", dynamic.from(path)),
          ),
        ],
      ]),
    )
  response
}

/// Writes the contents of the directory to a path on the host.
///
pub fn export(directory: Directory, path: String) -> Bool {
  let assert Ok(response) =
    compute_query(
      list.concat([
        directory.query_tree,
        [
          query_tree.new(
            "export",
            dict.new()
            |> dict.insert("path", dynamic.from(path)),
          ),
        ],
      ]),
    )
  response
}

/// Retrieves a file at the given path.
///
pub fn file(directory: Directory, path: String) -> File {
  base_client.new(
    list.concat([
      directory.query_tree,
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
pub fn glob(directory: Directory, pattern: String) -> List(String) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        directory.query_tree,
        [
          query_tree.new(
            "glob",
            dict.new()
            |> dict.insert("pattern", dynamic.from(pattern)),
          ),
        ],
      ]),
    )
  response
}

/// The content-addressed identifier of the directory.
///
pub fn id(directory: Directory) -> DirectoryID {
  let assert Ok(response) =
    compute_query(
      list.concat([directory.query_tree, [query_tree.new("id", dict.new())]]),
    )
  response
}

/// Creates a named sub-pipeline
///
pub fn pipeline(
  directory: Directory,
  name: String,
  description: String,
  labels: List(PipelineLabel),
) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
      [
        query_tree.new(
          "pipeline",
          dict.new()
          |> dict.insert("name", dynamic.from(name))
          |> dict.insert("description", dynamic.from(description))
          |> dict.insert("labels", dynamic.from(labels)),
        ),
      ],
    ]),
  )
}

/// Force evaluation in the engine.
///
pub fn sync(directory: Directory) -> DirectoryID {
  let assert Ok(response) =
    compute_query(
      list.concat([directory.query_tree, [query_tree.new("sync", dict.new())]]),
    )
  response
}

/// Retrieves this directory plus a directory written at the given path.
///
pub fn with_directory(
  directory: Directory,
  path: String,
  directory: DirectoryID,
  exclude: List(String),
  include: List(String),
) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
      [
        query_tree.new(
          "withDirectory",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("directory", dynamic.from(directory))
          |> dict.insert("exclude", dynamic.from(exclude))
          |> dict.insert("include", dynamic.from(include)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory plus the contents of the given file copied to the given path.
///
pub fn with_file(
  directory: Directory,
  path: String,
  source: FileID,
  permissions: Int,
) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
      [
        query_tree.new(
          "withFile",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("source", dynamic.from(source))
          |> dict.insert("permissions", dynamic.from(permissions)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory plus a new directory created at the given path.
///
pub fn with_new_directory(
  directory: Directory,
  path: String,
  permissions: Int,
) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
      [
        query_tree.new(
          "withNewDirectory",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("permissions", dynamic.from(permissions)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory plus a new file written at the given path.
///
pub fn with_new_file(
  directory: Directory,
  path: String,
  contents: String,
  permissions: Int,
) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
      [
        query_tree.new(
          "withNewFile",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("contents", dynamic.from(contents))
          |> dict.insert("permissions", dynamic.from(permissions)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory with all file/dir timestamps set to the given time.
///
pub fn with_timestamps(directory: Directory, timestamp: Int) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
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
pub fn without_directory(directory: Directory, path: String) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
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
pub fn without_file(directory: Directory, path: String) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
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
