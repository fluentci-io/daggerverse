/// Distinguishes the different kinds of TypeDefs.
///
pub type TypeDefKind {
  BooleanKind
  IntegerKind
  InterfaceKind
  ListKind
  ObjectKind
  StringKind
  VoidKind
}

/// A boolean value
///
pub fn boolean_kind() -> TypeDefKind {
  BooleanKind
}

/// An integer value
///
pub fn integer_kind() -> TypeDefKind {
  IntegerKind
}

/// A named type of functions that can be matched+implemented by other objects+interfaces.
/// 
/// Always paired with an InterfaceTypeDef.
///
pub fn interface_kind() -> TypeDefKind {
  InterfaceKind
}

/// A list of values all having the same type.
/// 
/// Always paired with a ListTypeDef.
///
pub fn list_kind() -> TypeDefKind {
  ListKind
}

/// A named type defined in the GraphQL schema, with fields and functions.
/// 
/// Always paired with an ObjectTypeDef.
///
pub fn object_kind() -> TypeDefKind {
  ObjectKind
}

/// A string value
///
pub fn string_kind() -> TypeDefKind {
  StringKind
}

/// A special kind used to signify that no value is returned.
/// 
/// This is used for functions that have no return value. The outer TypeDef
/// specifying this Kind is always Optional, as the Void is never actually
/// represented.
///
pub fn void_kind() -> TypeDefKind {
  VoidKind
}
