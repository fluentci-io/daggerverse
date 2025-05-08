import { _ } from "./deps.ts";

export const baseClient = (item: { name: string }) => `\
{{#each item.returnAndArgTypes}}
import gen/{{this._name}}.\\{type {{this.name}}\\}
{{/each}}
import gen/query_tree.{type QueryTree}
import gleam/dynamic
import gleam/dict
import gleam/list

pub type BaseClient {
  BaseClient(query_tree: List(QueryTree))
}

pub fn new(query_tree: List(QueryTree)) -> BaseClient {
  BaseClient(query_tree)
}

pub fn connect(query_tree: List(QueryTree)) -> BaseClient {
  BaseClient(query_tree)
}

{{#each item.fields}}

{{#if this.description}}
/// {{this.description}}
///
{{/if}}
pub fn {{this._name}}(${_.snakeCase(item.name)}: ${
  item.name
}{{#each this.args}}, {{this._name}}: {{this.type.name}}{{/each}}) -> {{this.type.name}} {
  {{#if this.type.isObject}}
  base_client.new(
    list.concat([
      ${_.snakeCase(item.name)}.query_tree,
      [
        query_tree.new("{{this.name}}", 
        dict.new() {{#each this.args}} |> dict.insert("{{this.name}}", dynamic.from({{this._name}})){{/each}})],
    ]),
  )
  {{/if}}
  {{#unless this.type.isObject}}
let assert Ok(response) =
  compute_query(
    list.concat([${_.snakeCase(item.name)}.query_tree, [
      query_tree.new("{{this.name}}", 
      dict.new(){{#each this.args}} |> dict.insert("{{this.name}}", dynamic.from({{this._name}})){{/each}})]])
  )
  response
  {{/unless}}
}
{{/each}}

`;

export const hbs = (item: { name: string; kind: string }) => {
  if (item.kind === "INPUT_OBJECT") {
    return `\
{{#if item.description}}
/// {{item.description}}
///
{{/if}}
    pub type {{item.name}} {
      {{item.name}}({{#each item.inputFields}}{{this._name}}: {{this.type.name}},{{/each}})
    }

    pub fn new({{#each item.inputFields}}{{this._name}}: {{this.type.name}},{{/each}}) -> {{item.name}} {
      {{item.name}}({{#each item.inputFields}}{{this._name}},{{/each}})
    }
`;
  }

  return `\
import gen/types.\\{
{{#each item.objectReturnTypes}}
  type {{this}},
{{/each}}
\\}
{{#each item.returnAndArgTypes}}
import gen/{{this._name}}.\\{type {{this.name}}\\}
{{/each}}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

{{#each item.fields}}

{{#if this.description}}
/// {{this.description}}
///
{{/if}}
pub fn {{this._name}}(${_.snakeCase(item.name)}: ${
    item.name
  }{{#each this.args}}, {{this._name}}: {{this.type.name}}{{/each}}) -> {{this.type.name}} {
  {{#if this.type.isObject}}
  base_client.new(
    list.concat([
      ${_.snakeCase(item.name)}.query_tree,
      [
        query_tree.new("{{this.name}}", 
        dict.new() {{#each this.args}} |> dict.insert("{{this.name}}", dynamic.from({{this._name}})){{/each}})],
    ]),
  )
  {{/if}}
  {{#unless this.type.isObject}}
let assert Ok(response) =
  compute_query(
    list.concat([${_.snakeCase(item.name)}.query_tree, [
      query_tree.new("{{this.name}}", 
      dict.new(){{#each this.args}} |> dict.insert("{{this.name}}", dynamic.from({{this._name}})){{/each}})]])
  )
  response
  {{/unless}}
}
{{/each}}
`;
};

export const typesTemplate = `\
import gen/base_client.{type BaseClient}

{{#each objects}}
pub type {{this}} =
  BaseClient
{{/each}}
`;

export const queryTree = `\
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
`;
