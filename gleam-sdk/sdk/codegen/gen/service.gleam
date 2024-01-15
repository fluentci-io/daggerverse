import gen/types.{type Service}
import gen/service_id.{type ServiceID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

/// Retrieves an endpoint that clients can use to reach this container.
/// 
/// If no port is specified, the first exposed port is used. If none exist an error is returned.
/// 
/// If a scheme is specified, a URL is returned. Otherwise, a host:port pair is returned.
///
pub fn endpoint(service: Service, port: Int, scheme: String) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([
        service.query_tree,
        [
          query_tree.new(
            "endpoint",
            dict.new()
            |> dict.insert("port", dynamic.from(port))
            |> dict.insert("scheme", dynamic.from(scheme)),
          ),
        ],
      ]),
    )
  response
}

/// Retrieves a hostname which can be used by clients to reach this container.
///
pub fn hostname(service: Service) -> String {
  let assert Ok(response) =
    compute_query(
      list.concat([service.query_tree, [query_tree.new("hostname", dict.new())]]),
    )
  response
}

/// A unique identifier for this service.
///
pub fn id(service: Service) -> ServiceID {
  let assert Ok(response) =
    compute_query(
      list.concat([service.query_tree, [query_tree.new("id", dict.new())]]),
    )
  response
}

/// Retrieves the list of ports provided by the service.
///
pub fn ports(service: Service) -> List(Port) {
  let assert Ok(response) =
    compute_query(
      list.concat([service.query_tree, [query_tree.new("ports", dict.new())]]),
    )
  response
}

/// Start the service and wait for its health checks to succeed.
/// 
/// Services bound to a Container do not need to be manually started.
///
pub fn start(service: Service) -> ServiceID {
  let assert Ok(response) =
    compute_query(
      list.concat([service.query_tree, [query_tree.new("start", dict.new())]]),
    )
  response
}

/// Stop the service.
///
pub fn stop(service: Service) -> ServiceID {
  let assert Ok(response) =
    compute_query(
      list.concat([service.query_tree, [query_tree.new("stop", dict.new())]]),
    )
  response
}
