import graphql
import gen/cache_volume.{type CacheVolume}
import gen/container.{type Container}
import gen/function_call.{type FunctionCall}
import gen/module.{type Module}

pub type Client {
  Client
}

pub fn connect() -> Client {
  graphql.new()
  Client
}

pub fn cache_volume(client: Client) -> CacheVolume(t) {
  todo
}

pub fn check_version_compatibility(client: Client) -> Bool {
  todo
}

pub fn container(client: Client) -> Container {
  todo
}

pub fn current_function_call(client: Client) -> FunctionCall {
  todo
}

pub fn current_module(client: Client) -> Module {
  todo
}
