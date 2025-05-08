import gen/types.{type Container, type Directory, type File, type Service}
import gen/container_id.{type ContainerID}
import gen/directory_id.{type DirectoryID}
import gen/file_id.{type FileID}
import gen/cache_volume_id.{type CacheVolumeID}
import gen/secret_id.{type SecretID}
import gen/service_id.{type ServiceID}
import gen/socket_id.{type SocketID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// Turn the container into a Service.
/// 
/// Be sure to set any exposed ports before this conversion.
///
pub fn as_service(container: Container) -> Service {
  base_client.new(
    list.concat([
      container.query_tree,
      [query_tree.new("asService", dict.new())],
    ]),
  )
}

/// Returns a File representing the container serialized to a tarball.
///
pub fn as_tarball(
  container: Container,
  platform_variants: List(ContainerID),
  forced_compression: ImageLayerCompression,
  media_types: ImageMediaTypes,
) -> File {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "asTarball",
          dict.new()
          |> dict.insert("platformVariants", dynamic.from(platform_variants))
          |> dict.insert("forcedCompression", dynamic.from(forced_compression))
          |> dict.insert("mediaTypes", dynamic.from(media_types)),
        ),
      ],
    ]),
  )
}

/// Initializes this container from a Dockerfile build.
///
pub fn build(
  container: Container,
  context: DirectoryID,
  dockerfile: String,
  build_args: List(BuildArg),
  target: String,
  secrets: List(SecretID),
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "build",
          dict.new()
          |> dict.insert("context", dynamic.from(context))
          |> dict.insert("dockerfile", dynamic.from(dockerfile))
          |> dict.insert("buildArgs", dynamic.from(build_args))
          |> dict.insert("target", dynamic.from(target))
          |> dict.insert("secrets", dynamic.from(secrets)),
        ),
      ],
    ]),
  )
}

/// Retrieves default arguments for future commands.
///
pub fn default_args(container: Container) -> List(String) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        container.query_tree,
        [query_tree.new("defaultArgs", dict.new())],
      ]),
    )
  response
}

/// Retrieves a directory at the given path.
/// 
/// Mounts are included.
///
pub fn directory(container: Container, path: String) -> Directory {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "directory",
          dict.new()
          |> dict.insert("path", dynamic.from(path)),
        ),
      ],
    ]),
  )
}

/// Retrieves entrypoint to be prepended to the arguments of all commands.
///
pub fn entrypoint(container: Container) -> List(String) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        container.query_tree,
        [query_tree.new("entrypoint", dict.new())],
      ]),
    )
  response
}

/// Retrieves the value of the specified environment variable.
///
pub fn env_variable(container: Container, name: String) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        container.query_tree,
        [
          query_tree.new(
            "envVariable",
            dict.new()
            |> dict.insert("name", dynamic.from(name)),
          ),
        ],
      ]),
    )
  response
}

/// Retrieves the list of environment variables passed to commands.
///
pub fn env_variables(container: Container) -> List(EnvVariable) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        container.query_tree,
        [query_tree.new("envVariables", dict.new())],
      ]),
    )
  response
}

/// EXPERIMENTAL API! Subject to change/removal at any time.
/// 
/// experimentalWithAllGPUs configures all available GPUs on the host to be accessible to this container.
/// This currently works for Nvidia devices only.
///
pub fn experimental_with_all_gp_us(container: Container) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [query_tree.new("experimentalWithAllGPUs", dict.new())],
    ]),
  )
}

/// EXPERIMENTAL API! Subject to change/removal at any time.
/// 
/// experimentalWithGPU configures the provided list of devices to be accesible to this container.
/// This currently works for Nvidia devices only.
///
pub fn experimental_with_gpu(
  container: Container,
  devices: List(String),
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "experimentalWithGPU",
          dict.new()
          |> dict.insert("devices", dynamic.from(devices)),
        ),
      ],
    ]),
  )
}

/// Writes the container as an OCI tarball to the destination file path on the host for the specified platform variants.
/// 
/// Return true on success.
/// It can also publishes platform variants.
///
pub fn export(
  container: Container,
  path: String,
  platform_variants: List(ContainerID),
  forced_compression: ImageLayerCompression,
  media_types: ImageMediaTypes,
) -> Bool {
  let assert Ok(response) =
    compute_query(
      list.concat([
        container.query_tree,
        [
          query_tree.new(
            "export",
            dict.new()
            |> dict.insert("path", dynamic.from(path))
            |> dict.insert("platformVariants", dynamic.from(platform_variants))
            |> dict.insert(
              "forcedCompression",
              dynamic.from(forced_compression),
            )
            |> dict.insert("mediaTypes", dynamic.from(media_types)),
          ),
        ],
      ]),
    )
  response
}

/// Retrieves the list of exposed ports.
/// 
/// This includes ports already exposed by the image, even if not
/// explicitly added with dagger.
///
pub fn exposed_ports(container: Container) -> List(Port) {
  let assert Ok(response) =
    compute_query(
      list.concat([
        container.query_tree,
        [query_tree.new("exposedPorts", dict.new())],
      ]),
    )
  response
}

/// Retrieves a file at the given path.
/// 
/// Mounts are included.
///
pub fn file(container: Container, path: String) -> File {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "file",
          dict.new()
          |> dict.insert("path", dynamic.from(path)),
        ),
      ],
    ]),
  )
}

/// Initializes this container from a pulled base image.
///
pub fn from(container: Container, address: String) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "from",
          dict.new()
          |> dict.insert("address", dynamic.from(address)),
        ),
      ],
    ]),
  )
}

/// A unique identifier for this container.
///
pub fn id(container: Container) -> ContainerID {
  let assert Ok(response) =
    compute_query(
      list.concat([container.query_tree, [query_tree.new("id", dict.new())]]),
    )
  response
}

/// The unique image reference which can only be retrieved immediately after the &#x27;Container.From&#x27; call.
///
pub fn image_ref(container: Container) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        container.query_tree,
        [query_tree.new("imageRef", dict.new())],
      ]),
    )
  response
}

/// Reads the container from an OCI tarball.
/// 
/// NOTE: this involves unpacking the tarball to an OCI store on the host at
/// $XDG_CACHE_DIR/dagger/oci. This directory can be removed whenever you like.
///
pub fn import_container(
  container: Container,
  source: FileID,
  tag: String,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "import",
          dict.new()
          |> dict.insert("source", dynamic.from(source))
          |> dict.insert("tag", dynamic.from(tag)),
        ),
      ],
    ]),
  )
}

/// Retrieves the value of the specified label.
///
pub fn label(container: Container, name: String) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        container.query_tree,
        [
          query_tree.new(
            "label",
            dict.new()
            |> dict.insert("name", dynamic.from(name)),
          ),
        ],
      ]),
    )
  response
}

/// Retrieves the list of labels passed to container.
///
pub fn labels(container: Container) -> List(Label) {
  let assert Ok(response) =
    compute_query(
      list.concat([container.query_tree, [query_tree.new("labels", dict.new())]]),
    )
  response
}

/// Retrieves the list of paths where a directory is mounted.
///
pub fn mounts(container: Container) -> List(String) {
  let assert Ok(response) =
    compute_query(
      list.concat([container.query_tree, [query_tree.new("mounts", dict.new())]]),
    )
  response
}

/// Creates a named sub-pipeline
///
pub fn pipeline(
  container: Container,
  name: String,
  description: String,
  labels: List(PipelineLabel),
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
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

/// The platform this container executes and publishes as.
///
pub fn platform(container: Container) -> Platform {
  let assert Ok(response) =
    compute_query(
      list.concat([
        container.query_tree,
        [query_tree.new("platform", dict.new())],
      ]),
    )
  response
}

/// Publishes this container as a new image to the specified address.
/// 
/// Publish returns a fully qualified ref.
/// It can also publish platform variants.
///
pub fn publish(
  container: Container,
  address: String,
  platform_variants: List(ContainerID),
  forced_compression: ImageLayerCompression,
  media_types: ImageMediaTypes,
) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        container.query_tree,
        [
          query_tree.new(
            "publish",
            dict.new()
            |> dict.insert("address", dynamic.from(address))
            |> dict.insert("platformVariants", dynamic.from(platform_variants))
            |> dict.insert(
              "forcedCompression",
              dynamic.from(forced_compression),
            )
            |> dict.insert("mediaTypes", dynamic.from(media_types)),
          ),
        ],
      ]),
    )
  response
}

/// Retrieves this container&#x27;s root filesystem. Mounts are not included.
///
pub fn rootfs(container: Container) -> Directory {
  base_client.new(
    list.concat([container.query_tree, [query_tree.new("rootfs", dict.new())]]),
  )
}

/// Return a websocket endpoint that, if connected to, will start the container with a TTY streamed
/// over the websocket.
/// 
/// Primarily intended for internal use with the dagger CLI.
///
pub fn shell_endpoint(container: Container) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        container.query_tree,
        [query_tree.new("shellEndpoint", dict.new())],
      ]),
    )
  response
}

/// The error stream of the last executed command.
/// 
/// Will execute default command if none is set, or error if there&#x27;s no default.
///
pub fn stderr(container: Container) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([container.query_tree, [query_tree.new("stderr", dict.new())]]),
    )
  response
}

/// The output stream of the last executed command.
/// 
/// Will execute default command if none is set, or error if there&#x27;s no default.
///
pub fn stdout(container: Container) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([container.query_tree, [query_tree.new("stdout", dict.new())]]),
    )
  response
}

/// Forces evaluation of the pipeline in the engine.
/// 
/// It doesn&#x27;t run the default command if no exec has been set.
///
pub fn sync(container: Container) -> ContainerID {
  let assert Ok(response) =
    compute_query(
      list.concat([container.query_tree, [query_tree.new("sync", dict.new())]]),
    )
  response
}

/// Retrieves the user to be set for all commands.
///
pub fn user(container: Container) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([container.query_tree, [query_tree.new("user", dict.new())]]),
    )
  response
}

/// Configures default arguments for future commands.
///
pub fn with_default_args(
  container: Container,
  args: List(String),
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withDefaultArgs",
          dict.new()
          |> dict.insert("args", dynamic.from(args)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container plus a directory written at the given path.
///
pub fn with_directory(
  container: Container,
  path: String,
  directory: DirectoryID,
  exclude: List(String),
  include: List(String),
  owner: String,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withDirectory",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("directory", dynamic.from(directory))
          |> dict.insert("exclude", dynamic.from(exclude))
          |> dict.insert("include", dynamic.from(include))
          |> dict.insert("owner", dynamic.from(owner)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container but with a different command entrypoint.
///
pub fn with_entrypoint(
  container: Container,
  args: List(String),
  keep_default_args: Bool,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withEntrypoint",
          dict.new()
          |> dict.insert("args", dynamic.from(args))
          |> dict.insert("keepDefaultArgs", dynamic.from(keep_default_args)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container plus the given environment variable.
///
pub fn with_env_variable(
  container: Container,
  name: String,
  value: String,
  expand: Bool,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withEnvVariable",
          dict.new()
          |> dict.insert("name", dynamic.from(name))
          |> dict.insert("value", dynamic.from(value))
          |> dict.insert("expand", dynamic.from(expand)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container after executing the specified command inside it.
///
pub fn with_exec(
  container: Container,
  args: List(String),
  skip_entrypoint: Bool,
  stdin: String,
  redirect_stdout: String,
  redirect_stderr: String,
  experimental_privileged_nesting: Bool,
  insecure_root_capabilities: Bool,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withExec",
          dict.new()
          |> dict.insert("args", dynamic.from(args))
          |> dict.insert("skipEntrypoint", dynamic.from(skip_entrypoint))
          |> dict.insert("stdin", dynamic.from(stdin))
          |> dict.insert("redirectStdout", dynamic.from(redirect_stdout))
          |> dict.insert("redirectStderr", dynamic.from(redirect_stderr))
          |> dict.insert(
            "experimentalPrivilegedNesting",
            dynamic.from(experimental_privileged_nesting),
          )
          |> dict.insert(
            "insecureRootCapabilities",
            dynamic.from(insecure_root_capabilities),
          ),
        ),
      ],
    ]),
  )
}

/// Expose a network port.
/// 
/// Exposed ports serve two purposes:
/// 
/// - For health checks and introspection, when running services
/// - For setting the EXPOSE OCI field when publishing the container
///
pub fn with_exposed_port(
  container: Container,
  port: Int,
  protocol: NetworkProtocol,
  description: String,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withExposedPort",
          dict.new()
          |> dict.insert("port", dynamic.from(port))
          |> dict.insert("protocol", dynamic.from(protocol))
          |> dict.insert("description", dynamic.from(description)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container plus the contents of the given file copied to the given path.
///
pub fn with_file(
  container: Container,
  path: String,
  source: FileID,
  permissions: Int,
  owner: String,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withFile",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("source", dynamic.from(source))
          |> dict.insert("permissions", dynamic.from(permissions))
          |> dict.insert("owner", dynamic.from(owner)),
        ),
      ],
    ]),
  )
}

/// Indicate that subsequent operations should be featured more prominently in
/// the UI.
///
pub fn with_focus(container: Container) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [query_tree.new("withFocus", dict.new())],
    ]),
  )
}

/// Retrieves this container plus the given label.
///
pub fn with_label(
  container: Container,
  name: String,
  value: String,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withLabel",
          dict.new()
          |> dict.insert("name", dynamic.from(name))
          |> dict.insert("value", dynamic.from(value)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container plus a cache volume mounted at the given path.
///
pub fn with_mounted_cache(
  container: Container,
  path: String,
  cache: CacheVolumeID,
  source: DirectoryID,
  sharing: CacheSharingMode,
  owner: String,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withMountedCache",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("cache", dynamic.from(cache))
          |> dict.insert("source", dynamic.from(source))
          |> dict.insert("sharing", dynamic.from(sharing))
          |> dict.insert("owner", dynamic.from(owner)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container plus a directory mounted at the given path.
///
pub fn with_mounted_directory(
  container: Container,
  path: String,
  source: DirectoryID,
  owner: String,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withMountedDirectory",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("source", dynamic.from(source))
          |> dict.insert("owner", dynamic.from(owner)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container plus a file mounted at the given path.
///
pub fn with_mounted_file(
  container: Container,
  path: String,
  source: FileID,
  owner: String,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withMountedFile",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("source", dynamic.from(source))
          |> dict.insert("owner", dynamic.from(owner)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container plus a secret mounted into a file at the given path.
///
pub fn with_mounted_secret(
  container: Container,
  path: String,
  source: SecretID,
  owner: String,
  mode: Int,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withMountedSecret",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("source", dynamic.from(source))
          |> dict.insert("owner", dynamic.from(owner))
          |> dict.insert("mode", dynamic.from(mode)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container plus a temporary directory mounted at the given path.
///
pub fn with_mounted_temp(container: Container, path: String) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withMountedTemp",
          dict.new()
          |> dict.insert("path", dynamic.from(path)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container plus a new file written at the given path.
///
pub fn with_new_file(
  container: Container,
  path: String,
  contents: String,
  permissions: Int,
  owner: String,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withNewFile",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("contents", dynamic.from(contents))
          |> dict.insert("permissions", dynamic.from(permissions))
          |> dict.insert("owner", dynamic.from(owner)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container with a registry authentication for a given address.
///
pub fn with_registry_auth(
  container: Container,
  address: String,
  username: String,
  secret: SecretID,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withRegistryAuth",
          dict.new()
          |> dict.insert("address", dynamic.from(address))
          |> dict.insert("username", dynamic.from(username))
          |> dict.insert("secret", dynamic.from(secret)),
        ),
      ],
    ]),
  )
}

/// Initializes this container from this DirectoryID.
///
pub fn with_rootfs(container: Container, directory: DirectoryID) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withRootfs",
          dict.new()
          |> dict.insert("directory", dynamic.from(directory)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container plus an env variable containing the given secret.
///
pub fn with_secret_variable(
  container: Container,
  name: String,
  secret: SecretID,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withSecretVariable",
          dict.new()
          |> dict.insert("name", dynamic.from(name))
          |> dict.insert("secret", dynamic.from(secret)),
        ),
      ],
    ]),
  )
}

/// Establish a runtime dependency on a service.
/// 
/// The service will be started automatically when needed and detached when it is
/// no longer needed, executing the default command if none is set.
/// 
/// The service will be reachable from the container via the provided hostname alias.
/// 
/// The service dependency will also convey to any files or directories produced by the container.
///
pub fn with_service_binding(
  container: Container,
  alias: String,
  service: ServiceID,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withServiceBinding",
          dict.new()
          |> dict.insert("alias", dynamic.from(alias))
          |> dict.insert("service", dynamic.from(service)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container plus a socket forwarded to the given Unix socket path.
///
pub fn with_unix_socket(
  container: Container,
  path: String,
  source: SocketID,
  owner: String,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withUnixSocket",
          dict.new()
          |> dict.insert("path", dynamic.from(path))
          |> dict.insert("source", dynamic.from(source))
          |> dict.insert("owner", dynamic.from(owner)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container with a different command user.
///
pub fn with_user(container: Container, name: String) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withUser",
          dict.new()
          |> dict.insert("name", dynamic.from(name)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container with a different working directory.
///
pub fn with_workdir(container: Container, path: String) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withWorkdir",
          dict.new()
          |> dict.insert("path", dynamic.from(path)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container with unset default arguments for future commands.
///
pub fn without_default_args(container: Container) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [query_tree.new("withoutDefaultArgs", dict.new())],
    ]),
  )
}

/// Retrieves this container with an unset command entrypoint.
///
pub fn without_entrypoint(
  container: Container,
  keep_default_args: Bool,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withoutEntrypoint",
          dict.new()
          |> dict.insert("keepDefaultArgs", dynamic.from(keep_default_args)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container minus the given environment variable.
///
pub fn without_env_variable(container: Container, name: String) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withoutEnvVariable",
          dict.new()
          |> dict.insert("name", dynamic.from(name)),
        ),
      ],
    ]),
  )
}

/// Unexpose a previously exposed port.
///
pub fn without_exposed_port(
  container: Container,
  port: Int,
  protocol: NetworkProtocol,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withoutExposedPort",
          dict.new()
          |> dict.insert("port", dynamic.from(port))
          |> dict.insert("protocol", dynamic.from(protocol)),
        ),
      ],
    ]),
  )
}

/// Indicate that subsequent operations should not be featured more prominently
/// in the UI.
/// 
/// This is the initial state of all containers.
///
pub fn without_focus(container: Container) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [query_tree.new("withoutFocus", dict.new())],
    ]),
  )
}

/// Retrieves this container minus the given environment label.
///
pub fn without_label(container: Container, name: String) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withoutLabel",
          dict.new()
          |> dict.insert("name", dynamic.from(name)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container after unmounting everything at the given path.
///
pub fn without_mount(container: Container, path: String) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withoutMount",
          dict.new()
          |> dict.insert("path", dynamic.from(path)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container without the registry authentication of a given address.
///
pub fn without_registry_auth(
  container: Container,
  address: String,
) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withoutRegistryAuth",
          dict.new()
          |> dict.insert("address", dynamic.from(address)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container with a previously added Unix socket removed.
///
pub fn without_unix_socket(container: Container, path: String) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [
        query_tree.new(
          "withoutUnixSocket",
          dict.new()
          |> dict.insert("path", dynamic.from(path)),
        ),
      ],
    ]),
  )
}

/// Retrieves this container with an unset command user.
/// 
/// Should default to root.
///
pub fn without_user(container: Container) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [query_tree.new("withoutUser", dict.new())],
    ]),
  )
}

/// Retrieves this container with an unset working directory.
/// 
/// Should default to &quot;/&quot;.
///
pub fn without_workdir(container: Container) -> Container {
  base_client.new(
    list.concat([
      container.query_tree,
      [query_tree.new("withoutWorkdir", dict.new())],
    ]),
  )
}

/// Retrieves the working directory for all commands.
///
pub fn workdir(container: Container) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        container.query_tree,
        [query_tree.new("workdir", dict.new())],
      ]),
    )
  response
}
