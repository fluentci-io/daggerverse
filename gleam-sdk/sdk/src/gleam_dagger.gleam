import gleam/io
import gleam/result.{try}
import gleam/dynamic.{field, string}
import gleam/hackney
import gleam/http/request
import gleam/json
import gleam/option.{Some}
import graphql
import envoy
import gen/client.{container}
import gen/container.{from, stdout, with_exec}

pub type Data {
  Data(country: Country)
}

pub type Country {
  Country(name: String)
}

const country_query = "query CountryQuery($code: ID!) {
  country(code: $code) {
    name
  }
}"

pub fn main() {
  client.connect()
  |> container()
  |> from("golang:1.19")
  |> with_exec(["go", "version"])
  |> stdout()

  let assert Ok(request) = request.to("https://api.github.com/users/tsirysndr")

  use response <- try(
    request
    |> hackney.send,
  )

  io.debug(envoy.get("DAGGER_SESSION_TOKEN"))
  io.debug(envoy.get("DAGGER_SESSION_PORT"))

  let assert Ok(Some(data)) =
    graphql.new()
    |> graphql.set_query(country_query)
    |> graphql.set_variable("code", json.string("GB"))
    |> graphql.set_host("countries.trevorblades.com")
    |> graphql.set_path("/graphql")
    |> graphql.set_header("Content-Type", "application/json")
    |> graphql.set_decoder(dynamic.decode1(
      Data,
      field("country", of: dynamic.decode1(Country, field("name", of: string))),
    ))
    |> graphql.send(hackney.send)

  io.debug(data)
  io.println("Hello from dagger!")

  Ok(response)
}
