import gen/types.{type Directory, type GeneratedCode}
import gen/generated_code_id.{type GeneratedCodeID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// The directory containing the generated code
///
pub fn code(generated_code: GeneratedCode) -> Directory {
  base_client.new(
    list.concat([
      generated_code.query_tree,
      [query_tree.new("code", dict.new())],
    ]),
  )
}

pub fn id(generated_code: GeneratedCode) -> GeneratedCodeID {
  let assert Ok(response) =
    compute_query(
      list.concat([
        generated_code.query_tree,
        [query_tree.new("id", dict.new())],
      ]),
    )
  response
}

/// List of paths to mark generated in version control (i.e. .gitattributes)
///
pub fn vcs_generated_paths(generated_code: GeneratedCode) -> List(String) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        generated_code.query_tree,
        [query_tree.new("vcsGeneratedPaths", dict.new())],
      ]),
    )
  response
}

/// List of paths to ignore in version control (i.e. .gitignore)
///
pub fn vcs_ignored_paths(generated_code: GeneratedCode) -> List(String) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        generated_code.query_tree,
        [query_tree.new("vcsIgnoredPaths", dict.new())],
      ]),
    )
  response
}

/// Set the list of paths to mark generated in version control
///
pub fn with_vcs_generated_paths(
  generated_code: GeneratedCode,
  paths: List(String),
) -> GeneratedCode {
  base_client.new(
    list.concat([
      generated_code.query_tree,
      [
        query_tree.new(
          "withVCSGeneratedPaths",
          dict.new()
          |> dict.insert("paths", dynamic.from(paths)),
        ),
      ],
    ]),
  )
}

/// Set the list of paths to ignore in version control
///
pub fn with_vcs_ignored_paths(
  generated_code: GeneratedCode,
  paths: List(String),
) -> GeneratedCode {
  base_client.new(
    list.concat([
      generated_code.query_tree,
      [
        query_tree.new(
          "withVCSIgnoredPaths",
          dict.new()
          |> dict.insert("paths", dynamic.from(paths)),
        ),
      ],
    ]),
  )
}
