import gen/types.{type ListTypeDef, type TypeDef}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// The type of the elements in the list
///
pub fn element_type_def(list_type_def: ListTypeDef) -> TypeDef {
  base_client.new(
    list.concat([
      list_type_def.query_tree,
      [query_tree.new("elementTypeDef", dict.new())],
    ]),
  )
}
