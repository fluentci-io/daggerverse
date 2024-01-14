import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}

pub type QueryTree {
  QueryTree(
    operation: String,
    args: Dict(String, Dynamic),
    query: String,
    i: Int,
  )
}

pub fn new(operation: String, args: Dict(String, Dynamic)) -> QueryTree {
  QueryTree(operation, args, "", 0)
}

pub fn with_query(query_tree: QueryTree, query: String) -> QueryTree {
  QueryTree(..query_tree, query: query_tree.query <> query, i: query_tree.i + 1)
}
