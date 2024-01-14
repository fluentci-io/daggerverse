import gleeunit
import gleeunit/should
import utils.{build_query}
import gen/query_tree
import gleam/dict
import gleam/dynamic

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
