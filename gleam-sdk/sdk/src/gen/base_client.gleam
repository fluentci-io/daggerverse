import gen/query_tree.{type QueryTree}
import gen/client_git_opts.{type ClientGitOpts}
import gen/cache_volume_id.{type CacheVolumeID}
import gen/container_id.{type ContainerID}
import gen/directory_id.{type DirectoryID}
import gen/file_id.{type FileID}
import gen/function_arg_id.{type FunctionArgID}
import gen/function_id.{type FunctionID}
import gen/generated_code_id.{type GeneratedCodeID}
import gen/git_ref_id.{type GitRefID}
import gen/git_repository_id.{type GitRepositoryID}
import gen/module_id.{type ModuleID}
import gen/secret_id.{type SecretID}
import gen/service_id.{type ServiceID}
import gen/socket_id.{type SocketID}
import gen/type_def_id.{type TypeDefID}
import gen/client_directory_opts.{type ClientDirectoryOpts}
import gen/client_container_opts.{type ClientContainerOpts}
import graphql.{type Request}
import gleam/dynamic
import gleam/dict
import gleam/list
import utils.{compute_query}

pub type BaseClient(t) {
  BaseClient(request: Request(t), query_tree: List(QueryTree))
}

pub fn connect(query_tree: List(QueryTree)) -> BaseClient(t) {
  BaseClient(graphql.new(), query_tree)
}

pub fn query(client: BaseClient(t)) -> BaseClient(t) {
  client.request
  |> compute_query(client.query_tree)
  todo
}

/// Constructs a cache volume for a given key.
/// 
pub fn cache_volume(client: BaseClient(t), key: String) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("key", dynamic.from(key))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("cacheVolume", args)],
    ]),
  )
  |> query
}

/// Checks if the current Dagger Engine is compatible with an SDK's requied version. 
/// 
pub fn check_version_compatibility(
  client: BaseClient(t),
  version: String,
) -> Bool {
  let args =
    dict.new()
    |> dict.insert("version", dynamic.from(version))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("checkVersionCompatibility", args)],
    ]),
  )
  |> query

  todo
}

/// Creates a scratch container or loads one by ID.
/// 
pub fn container(client: BaseClient(t)) -> BaseClient(t) {
  let args = dict.new()
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("container", args)],
    ]),
  )
  |> query
}

/// Creates a scratch container or loads one by ID.
/// 
pub fn container_opts(
  client: BaseClient(t),
  opts: ClientContainerOpts,
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(opts.id))
    |> dict.insert("platform", dynamic.from(opts.platform))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("container", args)],
    ]),
  )
  |> query
}

/// The FunctionCall context that the SDK caller is currently executing in.
/// If the caller is not currently in a function, this will return an error.
/// 
pub fn current_function_call(client: BaseClient(t)) -> BaseClient(t) {
  let args = dict.new()
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("currentFunctionCall", args)],
    ]),
  )
  |> query
}

/// The module currently being saved in the session, if any.
/// 
pub fn current_module(client: BaseClient(t)) -> BaseClient(t) {
  let args = dict.new()
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("currentModule", args)],
    ]),
  )
  |> query
}

/// The TypeDef representations of the objects currently being served in the session.
/// 
pub fn current_type_defs(client: BaseClient(t)) -> List(BaseClient(t)) {
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [
        query_tree.new("currentTypeDefs", dict.new()),
        query_tree.new("id", dict.new()),
      ],
    ]),
  )
  |> query

  [client]
}

/// The default platform of the builder. 
/// 
pub fn default_platform(client: BaseClient(t)) -> BaseClient(t) {
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("defaultPlatform", dict.new())],
    ]),
  )
  |> query
}

/// Creates an empty directory or loads one by ID.
/// 
pub fn directory(client: BaseClient(t)) -> BaseClient(t) {
  let args = dict.new()
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("directory", args)],
    ]),
  )
  |> query
}

/// Creates an empty directory or loads one by ID.
/// 
pub fn directory_opts(
  client: BaseClient(t),
  opts: ClientDirectoryOpts,
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(opts.id))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("directory", args)],
    ]),
  )
  |> query
}

/// Loads a file by ID.
/// 
@deprecated("Use `load_file_from_id` instead")
pub fn file(client: BaseClient(t), id: FileID) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([client.query_tree, [query_tree.new("file", args)]]),
  )
}

/// Create a function
/// 
pub fn function(
  client: BaseClient(t),
  name: String,
  return_type: BaseClient(t),
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("name", dynamic.from(name))
    |> dict.insert("returnType", dynamic.from(return_type))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("function", args)],
    ]),
  )
  |> query
}

/// Create a code generation result, given  a directory containing the generated code.
/// 
pub fn generated_code(
  client: BaseClient(t),
  directory: BaseClient(t),
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("code", dynamic.from(directory))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("generatedCode", args)],
    ]),
  )
  |> query
}

/// Queries a git repository.
/// 
pub fn git(
  client: BaseClient(t),
  url: String,
  opts: ClientGitOpts,
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("url", dynamic.from(url))
  BaseClient(
    ..client,
    query_tree: list.concat([client.query_tree, [query_tree.new("git", args)]]),
  )
  |> query
}

/// Queries the host environment.
/// 
pub fn host(client: BaseClient(t)) -> BaseClient(t) {
  let args = dict.new()
  BaseClient(
    ..client,
    query_tree: list.concat([client.query_tree, [query_tree.new("host", args)]]),
  )
  |> query
}

/// Returns a file containing an http url content.
/// 
pub fn http(client: BaseClient(t), url: String) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("url", dynamic.from(url))
  BaseClient(
    ..client,
    query_tree: list.concat([client.query_tree, [query_tree.new("http", args)]]),
  )
  |> query
}

/// Load a CacheVolume from its ID.
/// 
pub fn load_cache_volume_from_id(
  client: BaseClient(t),
  id: CacheVolumeID,
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadCacheVolumeFromID", args)],
    ]),
  )
  |> query
}

/// Load a Container from its ID
/// 
pub fn load_container_from_id(
  client: BaseClient(t),
  id: ContainerID,
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadContainerFromID", args)],
    ]),
  )
  |> query
}

/// Load a Directory from its ID.
/// 
pub fn load_directory_from_id(
  client: BaseClient(t),
  id: DirectoryID,
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadDirectoryFromID", args)],
    ]),
  )
  |> query
}

/// Load a File from its ID.
/// 
pub fn load_file_from_id(client: BaseClient(t), id: FileID) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadFileFromID", args)],
    ]),
  )
  |> query
}

/// Load a function argument by ID.
/// 
pub fn load_function_argument_from_id(
  client: BaseClient(t),
  id: FunctionArgID,
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadFunctionArgumentFromID", args)],
    ]),
  )
  |> query
}

/// Load a function by ID.
/// 
pub fn load_function_from_id(
  client: BaseClient(t),
  id: FunctionID,
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadFunctionFromID", args)],
    ]),
  )
  |> query
}

/// Load a GeneratedCode by ID.
/// 
pub fn load_generated_code_from_id(
  client: BaseClient(t),
  id: GeneratedCodeID,
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadGeneratedCodeFromID", args)],
    ]),
  )
  |> query
}

/// Load a git ref from its ID.
/// 
pub fn load_git_ref_from_id(
  client: BaseClient(t),
  id: GitRefID,
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadGitRefFromID", args)],
    ]),
  )
  |> query
}

/// Load a git repository from its ID.
/// 
pub fn load_git_repository_from_id(
  client: BaseClient(t),
  id: GitRepositoryID,
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadGitRepositoryFromID", args)],
    ]),
  )
  |> query
}

/// Load a module by ID.
/// 
pub fn load_module_from_id(client: BaseClient(t), id: ModuleID) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadModuleFromID", args)],
    ]),
  )
  |> query
}

/// Load a Secret from its ID.
/// 
pub fn load_secret_from_id(client: BaseClient(t), id: SecretID) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadSecretFromID", args)],
    ]),
  )
  |> query
}

/// Loads a service from ID.
/// 
pub fn load_service_from_id(
  client: BaseClient(t),
  id: ServiceID,
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadServiceFromID", args)],
    ]),
  )
  |> query
}

/// Load a Socket from its ID.
/// 
pub fn load_socket_from_id(client: BaseClient(t), id: SocketID) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadSocketFromID", args)],
    ]),
  )
  |> query
}

/// Load TypeDef by ID.
/// 
pub fn load_type_def_from_id(
  client: BaseClient(t),
  id: TypeDefID,
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([client.query_tree, [query_tree.new("id", args)]]),
  )
  |> query
}

/// Create a new module.
/// 
pub fn module(client: BaseClient(t)) -> BaseClient(t) {
  let args = dict.new()
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("module", args)],
    ]),
  )
  |> query
}

/// Load the static configuration for a module from the given source directory and optional subpath.
/// 
pub fn module_config(client: BaseClient(t)) -> BaseClient(t) {
  let args = dict.new()
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("moduleConfig", args)],
    ]),
  )
  |> query
}

/// Creates a named sub-pipeline.
/// 
pub fn pipeline(client: BaseClient(t), name: String) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("name", dynamic.from(name))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("pipeline", args)],
    ]),
  )
  |> query
}

/// Loads a secret from its ID.
/// 
pub fn secret(client: BaseClient(t), id: SecretID) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    ..client,
    query_tree: list.concat([client.query_tree, [query_tree.new("id", args)]]),
  )
  |> query
}

/// Sets a secret given a user defined name to its plaintext value and returns the secret.
/// The plaintext value is limited to a size of 128000 bytes.
/// 
pub fn set_secret(
  client: BaseClient(t),
  name: String,
  value: String,
) -> BaseClient(t) {
  let args =
    dict.new()
    |> dict.insert("name", dynamic.from(name))
    |> dict.insert("value", dynamic.from(value))
  BaseClient(
    ..client,
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("setSecret", args)],
    ]),
  )
  |> query
}

/// Loads a socket by its ID.
///
@deprecated("Use `load_socket_from_id` instead")
pub fn socket(client: BaseClient(t)) -> BaseClient(t) {
  let args = dict.new()
  BaseClient(
    ..client,
    query_tree: list.concat([client.query_tree, [query_tree.new("id", args)]]),
  )
  |> query
}

/// Create a new TypeDef.
/// 
pub fn type_def(client: BaseClient(t)) -> BaseClient(t) {
  let args = dict.new()
  BaseClient(
    ..client,
    query_tree: list.concat([client.query_tree, [query_tree.new("id", args)]]),
  )
  |> query
}
