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
import gleam/dynamic
import gleam/dict
import gleam/list
import utils.{compute_query}

pub type BaseClient {
  BaseClient(query_tree: List(QueryTree))
}

pub fn new(query_tree: List(QueryTree)) -> BaseClient {
  BaseClient(query_tree)
}

pub fn connect(query_tree: List(QueryTree)) -> BaseClient {
  BaseClient(query_tree)
}

/// Constructs a cache volume for a given key.
/// 
pub fn cache_volume(client: BaseClient, key: String) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("key", dynamic.from(key))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("cacheVolume", args)],
    ]),
  )
}

/// Checks if the current Dagger Engine is compatible with an SDK's requied version. 
/// 
pub fn check_version_compatibility(client: BaseClient, version: String) -> Bool {
  let args =
    dict.new()
    |> dict.insert("version", dynamic.from(version))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("checkVersionCompatibility", args)],
    ]),
  )

  todo
}

/// Creates a scratch container or loads one by ID.
/// 
pub fn container(client: BaseClient) -> BaseClient {
  let args = dict.new()
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("container", args)],
    ]),
  )
}

/// Creates a scratch container or loads one by ID.
/// 
pub fn container_opts(
  client: BaseClient,
  opts: ClientContainerOpts,
) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(opts.id))
    |> dict.insert("platform", dynamic.from(opts.platform))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("container", args)],
    ]),
  )
}

/// The FunctionCall context that the SDK caller is currently executing in.
/// If the caller is not currently in a function, this will return an error.
/// 
pub fn current_function_call(client: BaseClient) -> BaseClient {
  let args = dict.new()
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("currentFunctionCall", args)],
    ]),
  )
}

/// The module currently being saved in the session, if any.
/// 
pub fn current_module(client: BaseClient) -> BaseClient {
  let args = dict.new()
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("currentModule", args)],
    ]),
  )
}

/// The TypeDef representations of the objects currently being served in the session.
/// 
pub fn current_type_defs(client: BaseClient) -> List(BaseClient) {
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [
        query_tree.new("currentTypeDefs", dict.new()),
        query_tree.new("id", dict.new()),
      ],
    ]),
  )

  [client]
}

/// The default platform of the builder. 
/// 
pub fn default_platform(client: BaseClient) -> BaseClient {
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("defaultPlatform", dict.new())],
    ]),
  )
}

/// Creates an empty directory or loads one by ID.
/// 
pub fn directory(client: BaseClient) -> BaseClient {
  let args = dict.new()
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("directory", args)],
    ]),
  )
}

/// Creates an empty directory or loads one by ID.
/// 
pub fn directory_opts(
  client: BaseClient,
  opts: ClientDirectoryOpts,
) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(opts.id))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("directory", args)],
    ]),
  )
  // 
}

/// Loads a file by ID.
/// 
@deprecated("Use `load_file_from_id` instead")
pub fn file(client: BaseClient, id: FileID) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([client.query_tree, [query_tree.new("file", args)]]),
  )
}

/// Create a function
/// 
pub fn function(
  client: BaseClient,
  name: String,
  return_type: BaseClient,
) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("name", dynamic.from(name))
    |> dict.insert("returnType", dynamic.from(return_type))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("function", args)],
    ]),
  )
}

/// Create a code generation result, given  a directory containing the generated code.
/// 
pub fn generated_code(client: BaseClient, directory: BaseClient) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("code", dynamic.from(directory))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("generatedCode", args)],
    ]),
  )
}

/// Queries a git repository.
/// 
pub fn git(client: BaseClient, url: String, opts: ClientGitOpts) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("url", dynamic.from(url))
  BaseClient(
    query_tree: list.concat([client.query_tree, [query_tree.new("git", args)]]),
  )
}

/// Queries the host environment.
/// 
pub fn host(client: BaseClient) -> BaseClient {
  let args = dict.new()
  BaseClient(
    query_tree: list.concat([client.query_tree, [query_tree.new("host", args)]]),
  )
}

/// Returns a file containing an http url content.
/// 
pub fn http(client: BaseClient, url: String) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("url", dynamic.from(url))
  BaseClient(
    query_tree: list.concat([client.query_tree, [query_tree.new("http", args)]]),
  )
}

/// Load a CacheVolume from its ID.
/// 
pub fn load_cache_volume_from_id(
  client: BaseClient,
  id: CacheVolumeID,
) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadCacheVolumeFromID", args)],
    ]),
  )
}

/// Load a Container from its ID
/// 
pub fn load_container_from_id(client: BaseClient, id: ContainerID) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadContainerFromID", args)],
    ]),
  )
}

/// Load a Directory from its ID.
/// 
pub fn load_directory_from_id(client: BaseClient, id: DirectoryID) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadDirectoryFromID", args)],
    ]),
  )
}

/// Load a File from its ID.
/// 
pub fn load_file_from_id(client: BaseClient, id: FileID) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadFileFromID", args)],
    ]),
  )
}

/// Load a function argument by ID.
/// 
pub fn load_function_argument_from_id(
  client: BaseClient,
  id: FunctionArgID,
) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadFunctionArgumentFromID", args)],
    ]),
  )
}

/// Load a function by ID.
/// 
pub fn load_function_from_id(client: BaseClient, id: FunctionID) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadFunctionFromID", args)],
    ]),
  )
}

/// Load a GeneratedCode by ID.
/// 
pub fn load_generated_code_from_id(
  client: BaseClient,
  id: GeneratedCodeID,
) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadGeneratedCodeFromID", args)],
    ]),
  )
}

/// Load a git ref from its ID.
/// 
pub fn load_git_ref_from_id(client: BaseClient, id: GitRefID) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadGitRefFromID", args)],
    ]),
  )
}

/// Load a git repository from its ID.
/// 
pub fn load_git_repository_from_id(
  client: BaseClient,
  id: GitRepositoryID,
) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadGitRepositoryFromID", args)],
    ]),
  )
}

/// Load a module by ID.
/// 
pub fn load_module_from_id(client: BaseClient, id: ModuleID) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadModuleFromID", args)],
    ]),
  )
}

/// Load a Secret from its ID.
/// 
pub fn load_secret_from_id(client: BaseClient, id: SecretID) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadSecretFromID", args)],
    ]),
  )
}

/// Loads a service from ID.
/// 
pub fn load_service_from_id(client: BaseClient, id: ServiceID) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadServiceFromID", args)],
    ]),
  )
}

/// Load a Socket from its ID.
/// 
pub fn load_socket_from_id(client: BaseClient, id: SocketID) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("loadSocketFromID", args)],
    ]),
  )
}

/// Load TypeDef by ID.
/// 
pub fn load_type_def_from_id(client: BaseClient, id: TypeDefID) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([client.query_tree, [query_tree.new("id", args)]]),
  )
}

/// Create a new module.
/// 
pub fn module(client: BaseClient) -> BaseClient {
  let args = dict.new()
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("module", args)],
    ]),
  )
}

/// Load the static configuration for a module from the given source directory and optional subpath.
/// 
pub fn module_config(client: BaseClient) -> BaseClient {
  let args = dict.new()
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("moduleConfig", args)],
    ]),
  )
}

/// Creates a named sub-pipeline.
/// 
pub fn pipeline(client: BaseClient, name: String) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("name", dynamic.from(name))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("pipeline", args)],
    ]),
  )
}

/// Loads a secret from its ID.
/// 
pub fn secret(client: BaseClient, id: SecretID) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(id))
  BaseClient(
    query_tree: list.concat([client.query_tree, [query_tree.new("id", args)]]),
  )
}

/// Sets a secret given a user defined name to its plaintext value and returns the secret.
/// The plaintext value is limited to a size of 128000 bytes.
/// 
pub fn set_secret(client: BaseClient, name: String, value: String) -> BaseClient {
  let args =
    dict.new()
    |> dict.insert("name", dynamic.from(name))
    |> dict.insert("value", dynamic.from(value))
  BaseClient(
    query_tree: list.concat([
      client.query_tree,
      [query_tree.new("setSecret", args)],
    ]),
  )
}

/// Loads a socket by its ID.
///
@deprecated("Use `load_socket_from_id` instead")
pub fn socket(client: BaseClient) -> BaseClient {
  let args = dict.new()
  BaseClient(
    query_tree: list.concat([client.query_tree, [query_tree.new("id", args)]]),
  )
}

/// Create a new TypeDef.
/// 
pub fn type_def(client: BaseClient) -> BaseClient {
  let args = dict.new()
  BaseClient(
    query_tree: list.concat([client.query_tree, [query_tree.new("id", args)]]),
  )
}
