import gen/query_tree.{type QueryTree, with_query}
import gen/response.{type Response}
import graphql.{type Request}
import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic, classify}
import gleam/list.{fold, map}
import gleam/string.{lowercase, repeat, replace}
import gleam/io
import gleam/result.{unwrap}
import gleam/int
import gleam/float
import gleam/bool

/// Format argument into GraphQL query format.
/// 
pub fn build_args(args: Dict(String, Dynamic)) -> String {
  case dict.size(args) == 0 {
    True -> ""
    False ->
      "("
      <> format_args(args)
      |> fold("", fn(acc, x) {
        case acc == "" {
          True -> x
          False -> acc <> "," <> x
        }
      })
      <> ")"
  }
}

pub fn format_args(args: Dict(String, Dynamic)) -> List(String) {
  dict.keys(args)
  |> map(fn(x) {
    let assert Ok(value) = dict.get(args, x)
    case classify(value) {
      "String" ->
        x
        <> ":\""
        <> dynamic.string(value)
        |> unwrap("")
        <> "\""
      "Int" ->
        x
        <> ":"
        <> dynamic.int(value)
        |> unwrap(0)
        |> int.to_string
        |> replace(each: "\"", with: "\"")
      "Float" ->
        x
        <> ":"
        <> dynamic.float(value)
        |> unwrap(0.0)
        |> float.to_string
        |> replace(each: "\"", with: "\"")
      "Atom" ->
        x
        <> ":"
        <> dynamic.bool(value)
        |> unwrap(False)
        |> bool.to_string
        |> lowercase
        |> replace(each: "\"", with: "\"")
      _ -> x <> ":" <> ""
    }
  })
}

/// Remove unwanted quotes
/// 
pub fn format_value(key: String, value: String) -> String {
  todo
}

pub fn compute_query_tree() {
  todo
}

/// Find QueryTree, convert them into GraphQl query
/// then compute and return the result to the appropriate field
/// 
pub fn compute_nested_query(request: Request(t), q: List(QueryTree)) {
  todo
}

/// Convert query tree into a GraphQL query then compute it.
/// 
pub fn compute_query(request: Request(t), q: List(QueryTree)) {
  build_query(q)
}

/// Convert the query tree into a GraphQL query.
/// 
pub fn build_query(q: List(QueryTree)) -> String {
  io.debug(q)
  let assert Ok(initial) =
    q
    |> list.at(0)

  let qt =
    q
    |> fold(initial, fn(acc, x) {
      let q_len =
        q
        |> list.length

      case q_len - 1 != acc.i {
        True ->
          acc
          |> with_query(x.operation <> build_args(x.args) <> "{")
        False ->
          acc
          |> with_query(
            x.operation
            <> build_args(x.args)
            <> "}"
            |> repeat(times: q_len - 1),
          )
      }
    })

  io.debug(qt)
  "query{" <> qt.query <> "}"
}

/// Return a GraphQL query result flattened.
/// 
pub fn query_flatten(response: Response) {
  todo
}
