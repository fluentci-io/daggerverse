import gen/container_id.{type ContainerId}
import gen/file.{type File}
import gen/service.{type Service}
import gen/directory.{type Directory}

pub type Container {
  Container(id: ContainerId)
}

/// A unique identifier for this container .
///  
pub fn id(container: Container) -> ContainerId {
  container.id
}

/// Turn the container into a Service.
///
/// Be sure to set any exposed ports before this conversion.
/// 
pub fn as_service(container: Container) -> Service {
  service.new("")
}

/// Returns a File representing the container serialized to a tarball.
/// 
pub fn as_tarball(container: Container) -> File {
  file.new("")
}

/// Initializes this container from a Dockerfile build.
/// 
pub fn build(container: Container) -> Container {
  container
}

/// Retrieves default arguments for future commands.
/// 
pub fn default_args(container: Container) -> List(String) {
  []
}

/// Retrieves a directory at the given path.
/// 
pub fn directory(container: Container, path: String) -> Directory {
  directory.new("")
}

/// 
/// 
pub fn from(container: Container, name: String) -> Container {
  container
}

pub fn with_exec(container: Container, exec: List(String)) -> Container {
  container
}

pub fn stdout(container: Container) -> String {
  "stdout"
}
