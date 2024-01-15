import gen/query_tree.{type QueryTree, with_query}
import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic, classify}
import gleam/list.{fold, map}
import gleam/string.{lowercase, repeat, replace, starts_with}
import gleam/io
import gleam/result.{unwrap}
import gleam/int.{base_parse}
import gleam/float
import gleam/bool
import gleam/httpc
import gleam/http.{Http, Post}
import gleam/http/request
import gleam/http/response
import gleam/bit_array
import gleam/json
import envoy

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
      "String" -> format_string_value(x, value)
      "Int" -> format_int_value(x, value)
      "Float" -> format_float_value(x, value)
      "Atom" -> format_atom_value(x, value)
      "List" -> format_list_value(x, value)
      _ -> ""
    }
  })
}

pub fn format_list_value(key: String, value: Dynamic) -> String {
  let assert Ok(v) = dynamic.list(of: dynamic.dynamic)(value)
  let assert Ok(v) =
    v
    |> list.at(0)
  key
  <> ":["
  <> case classify(v) {
    "String" -> {
      let assert Ok(v) = dynamic.list(of: dynamic.string)(value)
      v
      |> map(fn(x) { "\"" <> x <> "\"" })
      |> fold("", fn(acc, x) {
        case acc == "" {
          True -> x
          False -> acc <> "," <> x
        }
      })
    }
    "Int" -> {
      let assert Ok(v) = dynamic.list(of: dynamic.int)(value)
      v
      |> map(fn(x) { int.to_string(x) })
      |> fold("", fn(acc, x) {
        case acc == "" {
          True -> x
          False -> acc <> "," <> x
        }
      })
    }
    "Float" -> {
      let assert Ok(v) = dynamic.list(of: dynamic.float)(value)
      v
      |> map(fn(x) { float.to_string(x) })
      |> fold("", fn(acc, x) {
        case acc == "" {
          True -> x
          False -> acc <> "," <> x
        }
      })
    }
    "Atom" -> {
      dynamic.bool(value)
      |> unwrap(False)
      |> bool.to_string
      |> lowercase
      |> replace(each: "\"", with: "\"")

      ""
    }
    _ -> ""
  }
  <> "]"
}

/// Remove unwanted quotes
/// 
pub fn format_string_value(key: String, value: Dynamic) -> String {
  key
  <> ":\""
  <> dynamic.string(value)
  |> unwrap("")
  <> "\""
}

pub fn format_int_value(key: String, value: Dynamic) -> String {
  key
  <> ":"
  <> dynamic.int(value)
  |> unwrap(0)
  |> int.to_string
  |> replace(each: "\"", with: "\"")
}

pub fn format_float_value(key: String, value: Dynamic) -> String {
  key
  <> ":"
  <> dynamic.float(value)
  |> unwrap(0.0)
  |> float.to_string
  |> replace(each: "\"", with: "\"")
}

pub fn format_atom_value(key: String, value: Dynamic) -> String {
  key
  <> ":"
  <> dynamic.bool(value)
  |> unwrap(False)
  |> bool.to_string
  |> lowercase
  |> replace(each: "\"", with: "\"")
}

pub fn compute_query_tree(value: Dynamic) -> String {
  io.debug("compute_query_tree")
  io.debug(value)

  let assert Ok(q) =
    value
    |> dynamic.tuple3(dynamic.dynamic, dynamic.dynamic, dynamic.dynamic)
  let assert Ok(query_tree_list) = dynamic.list(of: dynamic.dynamic)(q.2)

  let subquery =
    query_tree_list
    |> map(fn(x) {
      let assert Ok(tu) =
        x
        |> dynamic.tuple5(
          dynamic.dynamic,
          dynamic.dynamic,
          dynamic.dynamic,
          dynamic.dynamic,
          dynamic.dynamic,
        )
      io.debug(tu.1)
      compute_nested_query([
        query_tree.new(
          dynamic.string(tu.1)
          |> unwrap(""),
          dict.new(),
        ),
      ])
      query_tree.new(
        dynamic.string(tu.1)
        |> unwrap(""),
        dict.new(),
      )
    })
  // call build_query operation: "id"
  // for each query tree
  build_query(list.concat([subquery, [query_tree.new("id", dict.new())]]))
}

/// Find QueryTree, convert them into GraphQl query
/// then compute and return the result to the appropriate field
/// 
pub fn compute_nested_query(q: List(QueryTree)) {
  q
  |> map(fn(x) {
    let args =
      dict.map_values(x.args, fn(key, value) {
        let subquery = case is_query_tree(value) {
          True -> compute_query_tree(value)
          False -> ""
        }
        io.debug("1. ao")
        io.debug(subquery)
        // call compute query
        // set x.args[key] = compute query result
        let args = case subquery {
          "" -> value
          _ -> dynamic.from("123")
        }

        case is_array_query_tree(value) {
          True -> {
            let subquery =
              value
              |> dynamic.list(of: dynamic.dynamic)
              |> unwrap([])
              |> map(fn(x) { compute_query_tree(x) })
            io.debug("2. ao")
            io.debug(subquery)
            dynamic.from(
              subquery
              |> map(fn(x) {
                // call compute query
                "123"
              }),
            )
            // set x.args[key] = compute query result
          }
          False -> args
        }
      })

    case dict.size(x.args) > 0 {
      True -> query_tree.new(x.operation, args)
      False -> x
    }
  })
}

/// Convert query tree into a GraphQL query then compute it.
/// 
pub fn compute_query(q: List(QueryTree)) {
  let response =
    compute_nested_query(q)
    |> build_query
    |> compute
  io.debug(response)
}

/// Convert the query tree into a GraphQL query.
/// 
pub fn build_query(q: List(QueryTree)) -> String {
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

  io.debug(">>>>>")
  io.debug(qt)
  io.debug("<<<<")
  "query{" <> qt.query <> "}"
}

/// Return a GraphQL query result flattened.
/// 
pub fn query_flatten() {
  todo
}

pub fn is_query_tree(x: Dynamic) -> Bool {
  classify(x)
  |> starts_with("Tuple of ")
}

pub fn is_array_query_tree(x: Dynamic) -> Bool {
  case
    classify(x)
    |> starts_with("List")
  {
    True -> {
      x
      |> dynamic.list(of: dynamic.dynamic)
      |> unwrap([])
      |> map(fn(x) { is_query_tree(x) })
      |> fold(True, fn(acc, x) {
        case acc == True {
          True -> x
          False -> False
        }
      })
    }
    False -> False
  }
}

pub fn dagger_env_is_set() -> Bool {
  case envoy.get("DAGGER_SESSION_TOKEN") {
    Ok(_) ->
      case envoy.get("DAGGER_SESSION_PORT") {
        Ok(_) -> True
        _ -> False
      }
    _ -> False
  }
}

pub fn compute(query: String) {
  case dagger_env_is_set() {
    True -> {
      let assert Ok(session_token) = envoy.get("DAGGER_SESSION_TOKEN")
      let assert Ok(session_port) = envoy.get("DAGGER_SESSION_PORT")
      io.debug(">> query")
      io.debug(query)
      let result =
        request.new()
        |> request.set_method(Post)
        |> request.set_scheme(Http)
        |> request.set_host("127.0.0.1")
        |> request.set_port(
          session_port
          |> base_parse(10)
          |> unwrap(0),
        )
        |> request.set_path("/query")
        |> request.prepend_header(
          "Authorization",
          "Basic "
          <> base64_encode(session_token),
        )
        |> request.prepend_header("Content-Type", "application/json")
        |> request.set_body(
          json.object([#("query", json.string(query))])
          |> json.to_string,
        )
        |> httpc.send

      case result {
        Ok(resp) -> {
          io.debug(resp.status)
          io.debug(
            resp
            |> response.get_header("content-type"),
          )
          io.debug(resp.body)
          Ok("success")
        }
        Error(e) -> {
          io.debug(e)
          Error("error")
        }
      }
    }
    False -> Error("Dagger environment variables are not set")
  }
}

pub fn base64_encode(x: String) -> String {
  bit_array.from_string(x <> ":")
  |> bit_array.base64_encode(True)
}
