// deno-lint-ignore-file no-explicit-any
import { GraphQLNonNull, GraphQLScalarType } from "../../deps.ts";

export function getReturnType(schema: any, queryName: string) {
  const queryType = schema.getQueryType();
  const queryField = queryType?.getFields()[queryName];
  const queryFieldType =
    (queryField?.type as GraphQLScalarType).name ||
    (queryField?.type as GraphQLNonNull<GraphQLScalarType>).ofType?.name;
  return queryFieldType;
}

export function getArgsType(
  schema: any,
  queryName: string
): { name: string; type: string; optional: boolean }[] {
  const queryType = schema.getQueryType();
  const queryField = queryType?.getFields()[queryName];
  return queryField?.args.map((arg: any) => {
    const argType =
      (arg.type as GraphQLScalarType).name ||
      (arg.type as GraphQLNonNull<GraphQLScalarType>).ofType?.name;
    return {
      name: arg.name,
      type: argType,
      optional: !(arg.type instanceof GraphQLNonNull),
    };
  });
}

export function parseSchemaDescription(schema: { description?: string }) {
  if (schema.description) {
    try {
      return JSON.parse(schema.description);
    } catch (_e) {
      return {};
    }
  }
  return {};
}
