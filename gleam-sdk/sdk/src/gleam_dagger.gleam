import gen/base_client.{type BaseClient, container, pipeline}
import gen/container.{from, stdout, with_exec}

pub fn connect() -> BaseClient {
  base_client.connect([])
}

pub fn main() {
  let client = connect()

  client
  |> pipeline("demo")
  |> container()
  |> from("alpine")
  |> with_exec(["echo", "Hello from Dagger Gleam SDK!"])
  |> stdout()
}
