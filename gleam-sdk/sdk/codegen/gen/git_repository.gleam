import gen/types.{type GitRef, type GitRepository}
import gen/git_repository_id.{type GitRepositoryID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// Returns details on one branch.
///
pub fn branch(git_repository: GitRepository, name: String) -> GitRef {
  base_client.new(
    list.concat([
      git_repository.query_tree,
      [
        query_tree.new(
          "branch",
          dict.new()
          |> dict.insert("name", dynamic.from(name)),
        ),
      ],
    ]),
  )
}

/// Returns details on one commit.
///
pub fn commit(git_repository: GitRepository, id: String) -> GitRef {
  base_client.new(
    list.concat([
      git_repository.query_tree,
      [
        query_tree.new(
          "commit",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Retrieves the content-addressed identifier of the git repository.
///
pub fn id(git_repository: GitRepository) -> GitRepositoryID {
  let assert Ok(response) =
    compute_query(
      list.concat([
        git_repository.query_tree,
        [query_tree.new("id", dict.new())],
      ]),
    )
  response
}

/// Returns details on one tag.
///
pub fn tag(git_repository: GitRepository, name: String) -> GitRef {
  base_client.new(
    list.concat([
      git_repository.query_tree,
      [
        query_tree.new(
          "tag",
          dict.new()
          |> dict.insert("name", dynamic.from(name)),
        ),
      ],
    ]),
  )
}
