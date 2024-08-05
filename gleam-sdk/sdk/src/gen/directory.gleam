import gen/types.{type Directory, type File, type Module}
import gen/directory_id.{type DirectoryID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// A unique identifier for this Directory.
/// 
pub fn id(directory: Directory) -> DirectoryID {
  let assert Ok(response) =
    compute_query(
      list.concat([directory.query_tree, [query_tree.new("id", dict.new())]]),
    )
  response
}

/// Load the directory as a Dagger module
/// 
pub fn as_module(directory: Directory) -> Module {
  base_client.new(
    list.concat([
      directory.query_tree,
      [query_tree.new("as_module", dict.new())],
    ]),
  )
}

/// Load the directory as a Dagger module
/// 
pub fn as_module_opt(directory: Directory) -> Module {
  base_client.new(
    list.concat([
      directory.query_tree,
      [query_tree.new("as_module", dict.new())],
    ]),
  )
}

/// Gets the difference between this directory and an another directory.
/// 
pub fn diff(directory: Directory, other: Directory) -> Directory {
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

/// Builds a new Docker directory from this directory.
/// 
pub fn docker_build(directory: Directory) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        directory.query_tree,
        [query_tree.new("docker_build", dict.new())],
      ]),
    )
  response
}

/// Builds a new Docker directory from this directory.
/// 
pub fn docker_build_opt(directory: Directory) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        directory.query_tree,
        [query_tree.new("docker_build", dict.new())],
      ]),
    )
  response
}

/// Returns a list of files and directories at the given path.
/// 
pub fn entries(directory: Directory, path: String) -> List(String) {
  let assert Ok(_) =
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
  []
}

/// Returns a list of files and directories at the given path.
/// 
pub fn entries_opt(directory: Directory, path: String) -> List(String) {
  let assert Ok(_) =
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
  []
}

/// Writes the contents of the directory to a path on the host.
/// 
pub fn export(directory: Directory, path: String) -> Bool {
  let assert Ok(_) =
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
  True
}

///  Retrieves a file at the given path.
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
  let assert Ok(_) =
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
  []
}

/// Creates a named sub-pipeline.
/// 
pub fn pipeline(directory: Directory, name: String) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
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
pub fn pipeline_opts(directory: Directory, name: String) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
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
pub fn sync(directory: Directory) -> Directory {
  let assert Ok(_) =
    compute_query(
      list.concat([directory.query_tree, [query_tree.new("sync", dict.new())]]),
    )
  directory
}

/// Retrieves this directory plus a directory written at the given path.
/// 
pub fn with_directory(
  directory: Directory,
  path: String,
  dir: Directory,
) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
      [
        query_tree.new(
          "withDirectory",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("directory", dynamic.from(dir)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory plus a directory written at the given path.
/// 
pub fn with_directory_opts(
  directory: Directory,
  path: String,
  dir: Directory,
) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
      [
        query_tree.new(
          "withDirectory",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("directory", dynamic.from(dir)),
        ),
      ],
    ]),
  )
}

/// Retrieves this directory plus the contents of the given file copied to the given path.
/// 
pub fn with_file(directory: Directory, path: String, source: File) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
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
  directory: Directory,
  path: String,
  source: File,
) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
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
pub fn with_new_directory(directory: Directory, path: String) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
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
pub fn with_new_directory_opts(directory: Directory, path: String) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
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
  directory: Directory,
  path: String,
  contents: String,
) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
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
  directory: Directory,
  path: String,
  contents: String,
) -> Directory {
  base_client.new(
    list.concat([
      directory.query_tree,
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
