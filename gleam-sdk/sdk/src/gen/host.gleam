import gen/types.{
  type Directory, type File, type Host, type Secret, type Service, type Socket,
}
import gen/base_client.{type BaseClient}
import gen/response.{type Response}

/// Accesses a directory on the host.
/// 
pub fn directory(host: Host, path: String) -> Directory {
  todo
}

/// Accesses a file on the host.
/// 
pub fn file(host: Host, path: String) -> File {
  todo
}

/// Creates a service that forwards traffic to a specified address via the host.
/// 
pub fn service(host: Host) -> Service {
  host
}

/// Sets a secret given a user-defined name and the file path on the host, and returns the secret.
/// 
pub fn set_secret_file(host: Host, path: String) -> Secret {
  todo
}

/// Creates a tunnel that forwards traffic from the host to a service.
/// 
pub fn tunnel(host: Host, service: Service) -> Service {
  todo
}

/// Accesses a Unix socket on the host.
/// 
pub fn unix_socket(host: Host, path: String) -> Socket {
  todo
}
