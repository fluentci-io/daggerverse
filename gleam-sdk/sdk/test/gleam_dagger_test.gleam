import gleeunit
import gleeunit/should
import utils.{build_query, compute_query, is_array_query_tree, is_query_tree}
import gen/query_tree
import gleam/dict
import gleam/dynamic
import gen/base_client.{connect, directory_opts}
import gen/client_directory_opts
import gleam/io
import gleam/result
import gen/types.{type Directory}

pub fn main() {
  gleeunit.main()
}

pub fn build_query_with_arg_int_test() {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(1))
  let q = [query_tree.new("container", args), query_tree.new("id", dict.new())]
  build_query(q)
  |> should.equal("query{container(id:1){id}}")
}

pub fn build_query_with_arg_bool_test() {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from(False))
  let q = [query_tree.new("container", args), query_tree.new("id", dict.new())]
  build_query(q)
  |> should.equal("query{container(id:false){id}}")
}

pub fn build_query_with_arg_string_test() {
  let args =
    dict.new()
    |> dict.insert("id", dynamic.from("1"))
  let q = [query_tree.new("container", args), query_tree.new("id", dict.new())]
  build_query(q)
  |> should.equal("query{container(id:\"1\"){id}}")
}

pub fn build_query_test() {
  let ref =
    dict.new()
    |> dict.insert("ref", dynamic.from("alpine"))
  let file =
    dict.new()
    |> dict.insert("path", dynamic.from("/etc/alpine-release"))
  let q = [
    query_tree.new("core", dict.new()),
    query_tree.new("image", ref),
    query_tree.new("file", file),
  ]
  build_query(q)
  |> should.equal(
    "query{core{image(ref:\"alpine\"){file(path:\"/etc/alpine-release\")}}}",
  )
}

pub fn is_query_tree_test() {
  let q = query_tree.new("container", dict.new())
  is_query_tree(dynamic.from(q))
  |> should.equal(True)
}

pub fn is_query_tree_false_test() {
  is_query_tree(dynamic.from(1))
  |> should.equal(False)
}

pub fn is_array_query_tree_test() {
  let q = query_tree.new("container", dict.new())
  // let d =
  //  dynamic.from([q])
  //  |> dynamic.list(of: dynamic.dynamic)
  //  |> result.unwrap([])

  // io.debug(d)
  is_array_query_tree(dynamic.from([q]))
  |> should.equal(True)
}

pub fn compute_query_test() {
  let client = connect([])

  let dir: Directory =
    client
    |> directory_opts(client_directory_opts.new(""))

  let args =
    dict.new()
    |> dict.insert("dir", dynamic.from(dir))
  let q = [query_tree.new("container", args), query_tree.new("id", dict.new())]

  compute_query(q)
}
