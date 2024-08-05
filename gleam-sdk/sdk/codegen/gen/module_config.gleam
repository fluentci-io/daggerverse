import gen/types.{type ModuleConfig}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// Modules that this module depends on.
///
pub fn dependencies(module_config: ModuleConfig) -> List(String) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        module_config.query_tree,
        [query_tree.new("dependencies", dict.new())],
      ]),
    )
  response
}

/// Exclude these file globs when loading the module root.
///
pub fn exclude(module_config: ModuleConfig) -> List(String) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        module_config.query_tree,
        [query_tree.new("exclude", dict.new())],
      ]),
    )
  response
}

/// Include only these file globs when loading the module root.
///
pub fn include(module_config: ModuleConfig) -> List(String) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        module_config.query_tree,
        [query_tree.new("include", dict.new())],
      ]),
    )
  response
}

/// The name of the module.
///
pub fn name(module_config: ModuleConfig) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        module_config.query_tree,
        [query_tree.new("name", dict.new())],
      ]),
    )
  response
}

/// The root directory of the module&#x27;s project, which may be above the module source code.
///
pub fn root(module_config: ModuleConfig) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        module_config.query_tree,
        [query_tree.new("root", dict.new())],
      ]),
    )
  response
}

/// Either the name of a built-in SDK (&#x27;go&#x27;, &#x27;python&#x27;, etc.) OR a module reference pointing to the SDK&#x27;s module implementation.
///
pub fn sdk(module_config: ModuleConfig) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        module_config.query_tree,
        [query_tree.new("sdk", dict.new())],
      ]),
    )
  response
}
