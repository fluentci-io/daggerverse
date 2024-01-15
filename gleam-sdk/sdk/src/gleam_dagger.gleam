import gleam/io
import gen/base_client.{type BaseClient, container, pipeline}
import gen/container.{from, stdout, with_exec}
import envoy

pub fn connect() -> BaseClient {
  base_client.connect([])
}

pub fn main() {
  io.debug(envoy.get("DAGGER_SESSION_TOKEN"))
  io.debug(envoy.get("DAGGER_SESSION_PORT"))

  let client = connect()

  client
  |> pipeline("demo")
  |> container()
  |> from("alpine")
  |> with_exec(["echo", "Hello Dagger Gleam SDK!"])
  |> stdout()
}
