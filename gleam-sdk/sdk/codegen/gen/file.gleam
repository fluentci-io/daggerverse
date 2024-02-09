import gen/types.{type File}
import gen/file_id.{type FileID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// Retrieves the contents of the file.
///
pub fn contents(file: File) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([file.query_tree, [query_tree.new("contents", dict.new())]]),
    )
  response
}

/// Writes the file to a file path on the host.
///
pub fn export(file: File, path: String, allow_parent_dir_path: Bool) -> Bool {
  let assert Ok(response) =
    compute_query(
      list.concat([
        file.query_tree,
        [
          query_tree.new(
            "export",
            dict.new()
            |> dict.insert("path", dynamic.from(path))
            |> dict.insert(
              "allowParentDirPath",
              dynamic.from(allow_parent_dir_path),
            ),
          ),
        ],
      ]),
    )
  response
}

/// Retrieves the content-addressed identifier of the file.
///
pub fn id(file: File) -> FileID {
  let assert Ok(response) =
    compute_query(
      list.concat([file.query_tree, [query_tree.new("id", dict.new())]]),
    )
  response
}

/// Gets the size of the file, in bytes.
///
pub fn size(file: File) -> Int {
  let assert Ok(response) =
    compute_query(
      list.concat([file.query_tree, [query_tree.new("size", dict.new())]]),
    )
  response
}

/// Force evaluation in the engine.
///
pub fn sync(file: File) -> FileID {
  let assert Ok(response) =
    compute_query(
      list.concat([file.query_tree, [query_tree.new("sync", dict.new())]]),
    )
  response
}

/// Retrieves this file with its created/modified timestamps set to the given time.
///
pub fn with_timestamps(file: File, timestamp: Int) -> File {
  base_client.new(
    list.concat([
      file.query_tree,
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
