import gen/types.{type InterfaceTypeDef}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// The doc string for the interface, if any
///
pub fn description(interface_type_def: InterfaceTypeDef) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        interface_type_def.query_tree,
        [query_tree.new("description", dict.new())],
      ]),
    )
  response
}

/// Functions defined on this interface, if any
///
pub fn functions(interface_type_def: InterfaceTypeDef) -> List(Function) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        interface_type_def.query_tree,
        [query_tree.new("functions", dict.new())],
      ]),
    )
  response
}

/// The name of the interface
///
pub fn name(interface_type_def: InterfaceTypeDef) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        interface_type_def.query_tree,
        [query_tree.new("name", dict.new())],
      ]),
    )
  response
}

/// If this InterfaceTypeDef is associated with a Module, the name of the module. Unset otherwise.
///
pub fn source_module_name(interface_type_def: InterfaceTypeDef) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        interface_type_def.query_tree,
        [query_tree.new("sourceModuleName", dict.new())],
      ]),
    )
  response
}
