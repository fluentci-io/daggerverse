// deno-lint-ignore-file no-explicit-any
import fs from "node:fs";

import { Client, TypeDef, TypeDefKind } from "../client.ts";
import { connect } from "../connect.ts";
import { _, parseArgs } from "../../deps.ts";
import {
  getArgsType,
  getReturnType,
  getObjectReturnType,
  getObjectArgType,
  getDirectory,
} from "./lib.ts";
import invoke from "./invoke.ts";
import introspect from "./introspect.ts";

const flags = parseArgs(Deno.args, {
  string: ["mod-path"],
  default: { "mod-path": "/src" },
});

let moduleEntrypoint = `file://${flags["mod-path"]}/mod.ts`;

if (fs.existsSync(`${flags["mod-path"]}/.fluentci/mod.ts`)) {
  moduleEntrypoint = `file://${flags["mod-path"]}/.fluentci/mod.ts`;
}

const module = await import(moduleEntrypoint);
const metadata = introspect(moduleEntrypoint.replace("file://", ""));
const functions = metadata.map((m) => m.functionName);

if (!module) {
  throw new Error("Module not found");
}

if (!metadata.length) {
  throw new Error("No exported module function found");
}

const typeMap: Record<string, TypeDefKind> = {
  string: TypeDefKind.StringKind,
  number: TypeDefKind.IntegerKind,
  boolean: TypeDefKind.BooleanKind,
  void: TypeDefKind.VoidKind,
  "Promise<string>": TypeDefKind.StringKind,
  "Promise<number>": TypeDefKind.IntegerKind,
  "Promise<boolean>": TypeDefKind.BooleanKind,
  "Promise<void>": TypeDefKind.VoidKind,
};

const listTypeMap: Record<string, TypeDefKind> = {
  "string[]": TypeDefKind.StringKind,
  "number[]": TypeDefKind.IntegerKind,
  "boolean[]": TypeDefKind.BooleanKind,
};

const functionDescription = (key: string) =>
  metadata.find((m) => m.functionName === key)?.doc || "";

export function main() {
  connect(async (client: Client) => {
    const fnCall = client.currentFunctionCall();
    let mod = client.module_();

    const name = await fnCall.name();
    let returnValue;

    if (name === "") {
      const moduleName = await client.currentModule().name();
      let objDef = client.typeDef().withObject(moduleName);

      for (const key of functions) {
        objDef = await register(client, key, objDef, functionDescription(key));
      }

      mod = mod.withObject(objDef);

      const moduleDescription = metadata.find(
        (m) => m.moduleDescription
      )?.moduleDescription;

      if (moduleDescription) {
        mod = mod.withDescription(moduleDescription);
      }

      const id = await mod.id();
      returnValue = `"${id}"`;
    } else {
      const args = await fnCall.inputArgs();
      console.log("function call name => ", name);

      const argsType = getArgsType(metadata, name);
      const _variableValues: any[] = [];
      let variableValues: any[] = [];
      for (const arg of args) {
        const argName = await arg.name();
        const argValue = await arg.value();

        _variableValues.push({
          [argName]: parseArg(
            argValue,
            argsType.find((a) => a.name === argName)?.type || "string"
          ),
        });
      }

      variableValues = argsType.map((a) =>
        _.get(
          _variableValues.find((v) => v[a.name]),
          a.name,
          undefined
        )
      );

      const result = await invoke(module[name], ...variableValues);

      console.log("=> result", result);

      returnValue = JSON.stringify(result);
    }

    await fnCall.returnValue(returnValue as any);
  });
}

function parseArg(value: any, type: string) {
  switch (type) {
    case "string":
      return value.replace(/"/g, "");
    case "number":
      return parseInt(value);
    case "boolean":
      return /^\s*(true|1|on)\s*$/i.test(value);
    case "string[]":
      return JSON.parse(value);
    case "number[]":
      return JSON.parse(value);
    case "boolean[]":
      return JSON.parse(value);
    default:
      return value.replace(/"/g, "");
  }
}

async function register(
  client: Client,
  functionName: any,
  objDef: TypeDef,
  fnDesc: string
) {
  const returnType = getReturnType(metadata, functionName);
  const argsType = getArgsType(metadata, functionName);
  const objectReturnType = getObjectReturnType(metadata, functionName);

  let fn = client.function_(
    functionName,
    objectReturnType
      ? client.typeDef().withObject(objectReturnType)
      : client.typeDef().withKind(typeMap[returnType!])
  );

  for (const arg of argsType) {
    const objectType = getObjectArgType(metadata, functionName, arg.name);
    if (objectType) {
      fn = fn.withArg(
        arg.name,
        client.typeDef().withObject(objectType).withOptional(arg.optional),
        {
          description: arg.doc,
          defaultValue: (objectType === "Directory"
            ? await getDirectory(client, arg.defaultValue?.replaceAll('"', ""))
            : arg.defaultValue) as string & { __JSON: never },
        }
      );
      continue;
    }

    if (listTypeMap[arg.type]) {
      fn = fn.withArg(
        arg.name,
        client
          .typeDef()
          .withListOf(client.typeDef().withKind(listTypeMap[arg.type]))
          .withOptional(arg.optional),
        {
          description: arg.doc,
          defaultValue: arg.defaultValue as string & { __JSON: never },
        }
      );
      continue;
    }

    fn = fn.withArg(
      arg.name,
      client.typeDef().withKind(typeMap[arg.type]).withOptional(arg.optional),
      {
        description: arg.doc,
        defaultValue: arg.defaultValue as string & { __JSON: never },
      }
    );
  }

  fn = fn.withDescription(fnDesc);

  return objDef.withFunction(fn);
}

// Learn more at https://deno.land/manual/examples/module_metadata#concepts
if (import.meta.main) {
  main();
}
