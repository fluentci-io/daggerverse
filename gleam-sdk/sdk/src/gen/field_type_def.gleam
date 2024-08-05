import gen/types.{type FieldTypeDef}
import gen/field_type_def_id.{type FieldTypeDefID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict

/// A unique identifier for this EnvVariable.
/// 
pub fn id(field_type_def: FieldTypeDef) -> FieldTypeDefID {
  let assert Ok(response) =
    compute_query(
      list.concat([
        field_type_def.query_tree,
        [query_tree.new("id", dict.new())],
      ]),
    )
  response
}

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

pub fn type_def(field_type_def: FieldTypeDef) -> FieldTypeDef {
  base_client.new(
    list.concat([
      field_type_def.query_tree,
      [query_tree.new("typeDef", dict.new())],
    ]),
  )
}
