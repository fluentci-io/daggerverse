import gen/file.{type File}
import gen/directory.{type Directory}
import gen/service.{type Service}
import gen/secret.{type Secret}
import gen/socket.{type Socket}

pub type Host {
  Host
}

pub fn new() -> Host {
  Host
}

/// Accesses a directory on the host.
/// 
pub fn directory(host: Host, path: String) -> Directory {
  directory.new("")
}

/// Accesses a file on the host.
/// 
pub fn file(host: Host, path: String) -> File {
  file.new("")
}

/// Creates a service that forwards traffic to a specified address via the host.
/// 
pub fn service(host: Host) -> Service {
  service.new("")
}

/// Sets a secret given a user-defined name and the file path on the host, and returns the secret.
/// 
pub fn set_secret_file(host: Host, path: String) -> Secret {
  secret.new("")
}

/// Creates a tunnel that forwards traffic from the host to a service.
/// 
pub fn tunnel(host: Host, service: Service) -> Service {
  service.new("")
}

/// Accesses a Unix socket on the host.
/// 
pub fn unix_socket(host: Host, path: String) -> Socket {
  socket.new("")
}
