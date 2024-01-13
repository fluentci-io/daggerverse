import graphql.{type Request}
import gen/query_tree.{type QueryTree}
import gen/cache_volume.{type CacheVolume}
import gen/container.{type Container}
import gen/function_call.{type FunctionCall}
import gen/module.{type Module}
import gen/type_def.{type TypeDef}
import gen/platform.{type Platform}
import gen/directory.{type Directory}
import gen/file.{type File}
import gen/function.{type Function}
import gen/generated_code.{type GeneratedCode}
import gen/git_repository.{type ClientGitOpts, type GitRepository}
import gen/host.{type Host}
import gen/http.{type Http}
import gen/cache_volume_id.{type CacheVolumeId}
import gen/container_id.{type ContainerId}
import gen/directory_id.{type DirectoryId}
import gen/file_id.{type FileId}
import gen/response

pub type Client(t) {
  Client(query_tree: List(QueryTree), request: Request(t))
}

pub fn connect() -> Client(t) {
  Client(query_tree: [], request: graphql.new())
}

/// Constructs a cache volume for a given key.
/// 
pub fn cache_volume(client: Client(response.CacheVolume)) -> CacheVolume {
  todo
}

/// Checks if the current Dagger Engine is compatible with an SDK's requied version. 
/// 
pub fn check_version_compatibility(
  client: Client(response.CheckVersionCompatibility),
) -> Bool {
  todo
}

/// Creates a scratch container or loads one by ID.
/// 
pub fn container(client: Client(response.Container)) -> Container {
  container.Container(id: "")
}

/// The FunctionCall context that the SDK caller is currently executing in.
/// If the caller is not currently in a function, this will return an error.
/// 
pub fn current_function_call(
  client: Client(response.CurrentFunctionCall),
) -> FunctionCall {
  todo
}

/// The module currently being saved in the session, if any.
/// 
pub fn current_module(client: Client(response.CurrentModule)) -> Module {
  todo
}

/// The TypeDef representations of the objects currently being served in the session.
/// 
pub fn current_type_defs(
  client: Client(response.CurrentTypeDefs),
) -> List(TypeDef) {
  todo
}

/// The default platform of the builder. 
/// 
pub fn default_platform(client: Client(response.DefaultPlatform)) -> Platform {
  todo
}

/// Creates an empty directory or loads one by ID.
/// 
pub fn directory(client: Client(response.Directory)) -> Directory {
  todo
}

/// Loads a file by ID.
/// 
pub fn file(client: Client(response.File)) -> File {
  todo
}

/// Create a function
/// 
pub fn function(
  client: Client(response.Function),
  name: String,
  return_type: TypeDef,
) -> Function {
  todo
}

/// Create a code generation result, given  a directory containing the generated code.
/// 
pub fn generated_code(
  client: Client(response.GeneratedCode),
  directory: Directory,
) -> GeneratedCode {
  todo
}

/// Queries a git repository.
/// 
pub fn git(
  client: Client(response.GitRepository),
  url: String,
  opts: ClientGitOpts,
) -> GitRepository {
  todo
}

/// Queries the host environment.
/// 
pub fn host(client: Client(response.Host)) -> Host {
  todo
}

/// Returns a file containing an http url content.
/// 
pub fn http(client: Client(response.Http)) -> Http {
  todo
}

/// Load a CacheVolume from its ID.
/// 
pub fn load_cache_volume_from_id(
  client: Client(response.LoadCacheVolumeFromID),
  id: CacheVolumeId,
) -> CacheVolume {
  todo
}

/// Load a Container from its ID
/// 
pub fn load_container_from_id(
  client: Client(response.LoadContainerFromID),
  id: ContainerId,
) -> Container {
  todo
}

/// Load a Directory from its ID.
/// 
pub fn load_directory_from_id(
  client: Client(response.LoadDirectoryFromID),
  id: DirectoryId,
) -> Directory {
  todo
}

/// Load a File from its ID.
/// 
pub fn load_file_from_id(
  client: Client(response.LoadFileFromID),
  id: FileId,
) -> File {
  todo
}
