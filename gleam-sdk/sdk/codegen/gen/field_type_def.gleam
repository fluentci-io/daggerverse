import gen/types.{type FieldTypeDef, type TypeDef}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// A doc string for the field, if any
///
pub fn description(field_type_def: FieldTypeDef) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        field_type_def.query_tree,
        [query_tree.new("description", dict.new())],
      ]),
    )
  response
}

/// The name of the field in the object
///
pub fn name(field_type_def: FieldTypeDef) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        field_type_def.query_tree,
        [query_tree.new("name", dict.new())],
      ]),
    )
  response
}

/// The type of the field
///
pub fn type_def(field_type_def: FieldTypeDef) -> TypeDef {
  base_client.new(
    list.concat([
      field_type_def.query_tree,
      [query_tree.new("typeDef", dict.new())],
    ]),
  )
}
