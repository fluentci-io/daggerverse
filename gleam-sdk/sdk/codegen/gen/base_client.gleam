import gen/containerid.{type ContainerID}
import gen/directoryid.{type DirectoryID}
import gen/file_id.{type FileID}
import gen/type_def_id.{type TypeDefID}
import gen/socketid.{type SocketID}
import gen/serviceid.{type ServiceID}
import gen/cache_volume_id.{type CacheVolumeID}
import gen/function_arg_id.{type FunctionArgID}
import gen/function_id.{type FunctionID}
import gen/generated_code_id.{type GeneratedCodeID}
import gen/git_ref_id.{type GitRefID}
import gen/git_repository_id.{type GitRepositoryID}
import gen/module_id.{type ModuleID}
import gen/secret_id.{type SecretID}
import gen/query_tree.{type QueryTree}
import gleam/dynamic
import gleam/dict
import gleam/list

pub type BaseClient {
  BaseClient(query_tree: List(QueryTree))
}

pub fn new(query_tree: List(QueryTree)) -> BaseClient {
  BaseClient(query_tree)
}

pub fn connect(query_tree: List(QueryTree)) -> BaseClient {
  BaseClient(query_tree)
}

/// Constructs a cache volume for a given cache key.
///
pub fn cache_volume(base_client: BaseClient, key: String) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "cacheVolume",
          dict.new()
          |> dict.insert("key", dynamic.from(key)),
        ),
      ],
    ]),
  )
}

/// Checks if the current Dagger Engine is compatible with an SDK&#x27;s required version.
///
pub fn check_version_compatibility(
  base_client: BaseClient,
  version: String,
) -> Bool {
  let assert Ok(response) =
    compute_query(
      list.concat([
        base_client.query_tree,
        [
          query_tree.new(
            "checkVersionCompatibility",
            dict.new()
            |> dict.insert("version", dynamic.from(version)),
          ),
        ],
      ]),
    )
  response
}

/// Creates a scratch container or loads one by ID.
/// 
/// Optional platform argument initializes new containers to execute and publish
/// as that platform. Platform defaults to that of the builder&#x27;s host.
///
pub fn container(
  base_client: BaseClient,
  id: ContainerID,
  platform: Platform,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "container",
          dict.new()
          |> dict.insert("id", dynamic.from(id))
          |> dict.insert("platform", dynamic.from(platform)),
        ),
      ],
    ]),
  )
}

/// The FunctionCall context that the SDK caller is currently executing in.
/// If the caller is not currently executing in a function, this will return
/// an error.
///
pub fn current_function_call(base_client: BaseClient) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [query_tree.new("currentFunctionCall", dict.new())],
    ]),
  )
}

/// The module currently being served in the session, if any.
///
pub fn current_module(base_client: BaseClient) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [query_tree.new("currentModule", dict.new())],
    ]),
  )
}

/// The TypeDef representations of the objects currently being served in the session.
///
pub fn current_type_defs(base_client: BaseClient) -> List(BaseClient) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        base_client.query_tree,
        [query_tree.new("currentTypeDefs", dict.new())],
      ]),
    )
  response
}

/// The default platform of the builder.
///
pub fn default_platform(base_client: BaseClient) -> Platform {
  let assert Ok(response) =
    compute_query(
      list.concat([
        base_client.query_tree,
        [query_tree.new("defaultPlatform", dict.new())],
      ]),
    )
  response
}

/// Creates an empty directory or loads one by ID.
///
pub fn directory(base_client: BaseClient, id: DirectoryID) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "directory",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Loads a file by ID.
///
pub fn file(base_client: BaseClient, id: FileID) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "file",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Create a function.
///
pub fn function(
  base_client: BaseClient,
  name: String,
  return_type: TypeDefID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "function",
          dict.new()
          |> dict.insert("name", dynamic.from(name))
          |> dict.insert("returnType", dynamic.from(return_type)),
        ),
      ],
    ]),
  )
}

/// Create a code generation result, given a directory containing the generated
/// code.
///
pub fn generated_code(
  base_client: BaseClient,
  code: DirectoryID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "generatedCode",
          dict.new()
          |> dict.insert("code", dynamic.from(code)),
        ),
      ],
    ]),
  )
}

/// Queries a git repository.
///
pub fn git(
  base_client: BaseClient,
  url: String,
  keep_git_dir: Bool,
  ssh_known_hosts: String,
  ssh_auth_socket: SocketID,
  experimental_service_host: ServiceID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "git",
          dict.new()
          |> dict.insert("url", dynamic.from(url))
          |> dict.insert("keepGitDir", dynamic.from(keep_git_dir))
          |> dict.insert("sshKnownHosts", dynamic.from(ssh_known_hosts))
          |> dict.insert("sshAuthSocket", dynamic.from(ssh_auth_socket))
          |> dict.insert(
            "experimentalServiceHost",
            dynamic.from(experimental_service_host),
          ),
        ),
      ],
    ]),
  )
}

/// Queries the host environment.
///
pub fn host(base_client: BaseClient) -> BaseClient {
  base_client.new(
    list.concat([base_client.query_tree, [query_tree.new("host", dict.new())]]),
  )
}

/// Returns a file containing an http remote url content.
///
pub fn http(
  base_client: BaseClient,
  url: String,
  experimental_service_host: ServiceID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "http",
          dict.new()
          |> dict.insert("url", dynamic.from(url))
          |> dict.insert(
            "experimentalServiceHost",
            dynamic.from(experimental_service_host),
          ),
        ),
      ],
    ]),
  )
}

/// Load a CacheVolume from its ID.
///
pub fn load_cache_volume_from_id(
  base_client: BaseClient,
  id: CacheVolumeID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "loadCacheVolumeFromID",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Loads a container from an ID.
///
pub fn load_container_from_id(
  base_client: BaseClient,
  id: ContainerID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "loadContainerFromID",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Load a Directory from its ID.
///
pub fn load_directory_from_id(
  base_client: BaseClient,
  id: DirectoryID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "loadDirectoryFromID",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Load a File from its ID.
///
pub fn load_file_from_id(base_client: BaseClient, id: FileID) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "loadFileFromID",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Load a function argument by ID.
///
pub fn load_function_arg_from_id(
  base_client: BaseClient,
  id: FunctionArgID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "loadFunctionArgFromID",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Load a function by ID.
///
pub fn load_function_from_id(
  base_client: BaseClient,
  id: FunctionID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "loadFunctionFromID",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Load a GeneratedCode by ID.
///
pub fn load_generated_code_from_id(
  base_client: BaseClient,
  id: GeneratedCodeID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "loadGeneratedCodeFromID",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Load a git ref from its ID.
///
pub fn load_git_ref_from_id(
  base_client: BaseClient,
  id: GitRefID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "loadGitRefFromID",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Load a git repository from its ID.
///
pub fn load_git_repository_from_id(
  base_client: BaseClient,
  id: GitRepositoryID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "loadGitRepositoryFromID",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Load a module by ID.
///
pub fn load_module_from_id(
  base_client: BaseClient,
  id: ModuleID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "loadModuleFromID",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Load a Secret from its ID.
///
pub fn load_secret_from_id(
  base_client: BaseClient,
  id: SecretID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "loadSecretFromID",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Loads a service from ID.
///
pub fn load_service_from_id(
  base_client: BaseClient,
  id: ServiceID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "loadServiceFromID",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Load a Socket from its ID.
///
pub fn load_socket_from_id(
  base_client: BaseClient,
  id: SocketID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "loadSocketFromID",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Load a TypeDef by ID.
///
pub fn load_type_def_from_id(
  base_client: BaseClient,
  id: TypeDefID,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "loadTypeDefFromID",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Create a new module.
///
pub fn module(base_client: BaseClient) -> BaseClient {
  base_client.new(
    list.concat([base_client.query_tree, [query_tree.new("module", dict.new())]]),
  )
}

/// Load the static configuration for a module from the given source directory and optional subpath.
///
pub fn module_config(
  base_client: BaseClient,
  source_directory: DirectoryID,
  subpath: String,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "moduleConfig",
          dict.new()
          |> dict.insert("sourceDirectory", dynamic.from(source_directory))
          |> dict.insert("subpath", dynamic.from(subpath)),
        ),
      ],
    ]),
  )
}

/// Creates a named sub-pipeline.
///
pub fn pipeline(
  base_client: BaseClient,
  name: String,
  description: String,
  labels: List(PipelineLabel),
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "pipeline",
          dict.new()
          |> dict.insert("name", dynamic.from(name))
          |> dict.insert("description", dynamic.from(description))
          |> dict.insert("labels", dynamic.from(labels)),
        ),
      ],
    ]),
  )
}

/// Loads a secret from its ID.
///
pub fn secret(base_client: BaseClient, id: SecretID) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "secret",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Sets a secret given a user defined name to its plaintext and returns the secret.
/// The plaintext value is limited to a size of 128000 bytes.
///
pub fn set_secret(
  base_client: BaseClient,
  name: String,
  plaintext: String,
) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "setSecret",
          dict.new()
          |> dict.insert("name", dynamic.from(name))
          |> dict.insert("plaintext", dynamic.from(plaintext)),
        ),
      ],
    ]),
  )
}

/// Loads a socket by its ID.
///
pub fn socket(base_client: BaseClient, id: SocketID) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [
        query_tree.new(
          "socket",
          dict.new()
          |> dict.insert("id", dynamic.from(id)),
        ),
      ],
    ]),
  )
}

/// Create a new TypeDef.
///
pub fn type_def(base_client: BaseClient) -> BaseClient {
  base_client.new(
    list.concat([
      base_client.query_tree,
      [query_tree.new("typeDef", dict.new())],
    ]),
  )
}
