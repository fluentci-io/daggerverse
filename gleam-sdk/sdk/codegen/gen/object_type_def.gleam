import gen/types.{type Function, type ObjectTypeDef}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// The function used to construct new instances of this object, if any
///
pub fn constructor(object_type_def: ObjectTypeDef) -> Function {
  base_client.new(
    list.concat([
      object_type_def.query_tree,
      [query_tree.new("constructor", dict.new())],
    ]),
  )
}

/// The doc string for the object, if any
///
pub fn description(object_type_def: ObjectTypeDef) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        object_type_def.query_tree,
        [query_tree.new("description", dict.new())],
      ]),
    )
  response
}

/// Static fields defined on this object, if any
///
pub fn fields(object_type_def: ObjectTypeDef) -> List(FieldTypeDef) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        object_type_def.query_tree,
        [query_tree.new("fields", dict.new())],
      ]),
    )
  response
}

/// Functions defined on this object, if any
///
pub fn functions(object_type_def: ObjectTypeDef) -> List(Function) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        object_type_def.query_tree,
        [query_tree.new("functions", dict.new())],
      ]),
    )
  response
}

/// The name of the object
///
pub fn name(object_type_def: ObjectTypeDef) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        object_type_def.query_tree,
        [query_tree.new("name", dict.new())],
      ]),
    )
  response
}

/// If this ObjectTypeDef is associated with a Module, the name of the module. Unset otherwise.
///
pub fn source_module_name(object_type_def: ObjectTypeDef) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        object_type_def.query_tree,
        [query_tree.new("sourceModuleName", dict.new())],
      ]),
    )
  response
}
