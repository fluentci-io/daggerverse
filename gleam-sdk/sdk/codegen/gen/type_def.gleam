import gen/types.{
  type InterfaceTypeDef, type ListTypeDef, type ObjectTypeDef, type TypeDef,
}
import gen/type_def_id.{type TypeDefID}
import gen/function_id.{type FunctionID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// If kind is INTERFACE, the interface-specific type definition.
/// If kind is not INTERFACE, this will be null.
///
pub fn as_interface(type_def: TypeDef) -> InterfaceTypeDef {
  base_client.new(
    list.concat([
      type_def.query_tree,
      [query_tree.new("asInterface", dict.new())],
    ]),
  )
}

/// If kind is LIST, the list-specific type definition.
/// If kind is not LIST, this will be null.
///
pub fn as_list(type_def: TypeDef) -> ListTypeDef {
  base_client.new(
    list.concat([type_def.query_tree, [query_tree.new("asList", dict.new())]]),
  )
}

/// If kind is OBJECT, the object-specific type definition.
/// If kind is not OBJECT, this will be null.
///
pub fn as_object(type_def: TypeDef) -> ObjectTypeDef {
  base_client.new(
    list.concat([type_def.query_tree, [query_tree.new("asObject", dict.new())]]),
  )
}

pub fn id(type_def: TypeDef) -> TypeDefID {
  let assert Ok(response) =
    compute_query(
      list.concat([type_def.query_tree, [query_tree.new("id", dict.new())]]),
    )
  response
}

/// The kind of type this is (e.g. primitive, list, object)
///
pub fn kind(type_def: TypeDef) -> TypeDefKind {
  let assert Ok(response) =
    compute_query(
      list.concat([type_def.query_tree, [query_tree.new("kind", dict.new())]]),
    )
  response
}

/// Whether this type can be set to null. Defaults to false.
///
pub fn optional(type_def: TypeDef) -> Bool {
  let assert Ok(response) =
    compute_query(
      list.concat([
        type_def.query_tree,
        [query_tree.new("optional", dict.new())],
      ]),
    )
  response
}

/// Adds a function for constructing a new instance of an Object TypeDef, failing if the type is not an object.
///
pub fn with_constructor(type_def: TypeDef, function: FunctionID) -> TypeDef {
  base_client.new(
    list.concat([
      type_def.query_tree,
      [
        query_tree.new(
          "withConstructor",
          dict.new()
          |> dict.insert("function", dynamic.from(function)),
        ),
      ],
    ]),
  )
}

/// Adds a static field for an Object TypeDef, failing if the type is not an object.
///
pub fn with_field(
  type_def: TypeDef,
  name: String,
  type_def: TypeDefID,
  description: String,
) -> TypeDef {
  base_client.new(
    list.concat([
      type_def.query_tree,
      [
        query_tree.new(
          "withField",
          dict.new()
          |> dict.insert("name", dynamic.from(name))
          |> dict.insert("typeDef", dynamic.from(type_def))
          |> dict.insert("description", dynamic.from(description)),
        ),
      ],
    ]),
  )
}

/// Adds a function for an Object or Interface TypeDef, failing if the type is not one of those kinds.
///
pub fn with_function(type_def: TypeDef, function: FunctionID) -> TypeDef {
  base_client.new(
    list.concat([
      type_def.query_tree,
      [
        query_tree.new(
          "withFunction",
          dict.new()
          |> dict.insert("function", dynamic.from(function)),
        ),
      ],
    ]),
  )
}

/// Returns a TypeDef of kind Interface with the provided name.
///
pub fn with_interface(
  type_def: TypeDef,
  name: String,
  description: String,
) -> TypeDef {
  base_client.new(
    list.concat([
      type_def.query_tree,
      [
        query_tree.new(
          "withInterface",
          dict.new()
          |> dict.insert("name", dynamic.from(name))
          |> dict.insert("description", dynamic.from(description)),
        ),
      ],
    ]),
  )
}

/// Sets the kind of the type.
///
pub fn with_kind(type_def: TypeDef, kind: TypeDefKind) -> TypeDef {
  base_client.new(
    list.concat([
      type_def.query_tree,
      [
        query_tree.new(
          "withKind",
          dict.new()
          |> dict.insert("kind", dynamic.from(kind)),
        ),
      ],
    ]),
  )
}

/// Returns a TypeDef of kind List with the provided type for its elements.
///
pub fn with_list_of(type_def: TypeDef, element_type: TypeDefID) -> TypeDef {
  base_client.new(
    list.concat([
      type_def.query_tree,
      [
        query_tree.new(
          "withListOf",
          dict.new()
          |> dict.insert("elementType", dynamic.from(element_type)),
        ),
      ],
    ]),
  )
}

/// Returns a TypeDef of kind Object with the provided name.
/// 
/// Note that an object&#x27;s fields and functions may be omitted if the intent is
/// only to refer to an object. This is how functions are able to return their
/// own object, or any other circular reference.
///
pub fn with_object(
  type_def: TypeDef,
  name: String,
  description: String,
) -> TypeDef {
  base_client.new(
    list.concat([
      type_def.query_tree,
      [
        query_tree.new(
          "withObject",
          dict.new()
          |> dict.insert("name", dynamic.from(name))
          |> dict.insert("description", dynamic.from(description)),
        ),
      ],
    ]),
  )
}

/// Sets whether this type can be set to null.
///
pub fn with_optional(type_def: TypeDef, optional: Bool) -> TypeDef {
  base_client.new(
    list.concat([
      type_def.query_tree,
      [
        query_tree.new(
          "withOptional",
          dict.new()
          |> dict.insert("optional", dynamic.from(optional)),
        ),
      ],
    ]),
  )
}
