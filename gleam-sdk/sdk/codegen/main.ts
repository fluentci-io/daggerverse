import { handlebars,  parseArgs, _ } from "./deps.ts";
import { hbs, typesTemplate, baseClient, queryTree } from './templates.ts'; 
import * as schema from "./schema.json" with { type: "json"};

export async function main() {
  const args = parseArgs(Deno.args, {
    boolean: ["hbs"]
  });
  Deno.mkdirSync("./gen", { recursive: true });
  args.hbs && Deno.mkdirSync("./templates", { recursive: true });
  Deno.writeTextFileSync("./gen/query_tree.gleam", queryTree);
  
  const { types }  = schema.default.data.__schema;
  const templates: Record<string, string> = {};

  const enums = types.filter(x => x.kind === 'ENUM' && !x.name.startsWith('__'));
  console.log(enums);
  const scalars = types.filter(x => x.kind === 'SCALAR' && ![
    'Boolean', 
    'Float',
    'ID', 
    'Int', 
    'String', 
    'DateTime', 
    'Json', 
    'JsonScalar'
  ].includes(x.name) && !x.name.startsWith('__'));
  const inputObjects = types.filter(x => x.kind === 'INPUT_OBJECT' && !x.name.startsWith('__'));
  console.log(inputObjects);
  const query = types.find(x => x.kind === 'OBJECT' && x.name === 'Query');
  const objects = types.filter(x => x.kind === 'OBJECT' && !x.name.startsWith('__') && x.name !== 'Query' && x.name !== 'Mutation');

  args.hbs && Deno.writeTextFileSync("./templates/base_client.gleam.hbs", baseClient({ name: "BaseClient" }));

  Deno.writeTextFileSync(
    "./gen/base_client.gleam", 
    handlebars.compile(baseClient({ name: "BaseClient" }))
    ({ item:  base_client_params(query!, "BaseClient") })
    .replaceAll("\\{", "{")
    .replaceAll("\\}", "}")
    .replaceAll("Boolean", "Bool")
  );

  for (const item of scalars) {
    const content = `\
${item.description ? `/// ${item.description.replaceAll("\n", "\n/// ")}\n///` : ""}
pub type ${item.name} =
  String
  `;
    args.hbs && Deno.writeTextFileSync(`./templates/${_.snakeCase(item.name)}.gleam.hbs`, content);
    templates[item.name] = content;
  }

  for (const item of enums) {
    const content = `\
    ${item.description ? `/// ${item.description.replaceAll("\n", "\n/// ")}\n///` : ""}
    pub type ${item.name} {
      ${item.enumValues?.map(x => x.name).join("\n")}
    }
    
    ${item.enumValues?.map(x => `\
${x.description ? `/// ${x.description.replaceAll("\n", "\n/// ")}\n///` : ""}
    pub fn ${_.snakeCase(x.name)}() -> ${item.name} {
      ${x.name}
    }`).join("\n")}
    
    `;
    Deno.writeTextFileSync(`./gen/${_.snakeCase(item.name)}.gleam`, content);
  }

  for (const item of objects) {
    const content = hbs(item);
    args.hbs && Deno.writeTextFileSync(`./templates/${_.snakeCase(item.name)}.gleam.hbs`, content);
    templates[item.name] = content;
  }


  args.hbs && Deno.writeTextFileSync("./templates/types.gleam.hbs", typesTemplate);

  Deno.writeTextFileSync("./gen/types.gleam", handlebars.compile(typesTemplate)({ objects: objects.map(x => x.name), inputObjects }));

  for (const item of inputObjects) {
    args.hbs && Deno.writeTextFileSync(`./templates/${_.snakeCase(item.name)}.gleam.hbs`, hbs(item));
    Deno.writeTextFileSync(`./gen/${_.snakeCase(item.name)}.gleam`, handlebars.compile(hbs(item))({ item: inputObjectParams(item) }));
  }



  for (const key of Object.keys(templates)) {
    const item = objects.find(x => x.name === key);
    const content = handlebars.compile(templates[key])({ item: params(item!, key) })
    .replaceAll("\\{", "{")
    .replaceAll("\\}", "}")
    .replaceAll("Boolean", "Bool");
    Deno.writeTextFileSync(`./gen/${_.snakeCase(key)}.gleam`, content);
  }
  const format = new Deno.Command('gleam', {
    args: ['format', `./gen`],
    stdout: 'piped',
    stderr: 'piped',
  });
  const process = format.spawn();
  await process.status;
}

function inputObjectParams(item: typeof schema.default.data.__schema.types[0]) {
  return {
    ...item,
    inputFields: item?.inputFields?.map(x => ({ ...x,
      _name: _.snakeCase(x.name),
      type: {
      ...x.type,
      name: x.type.name || x.type.ofType?.name
    }})),
  }
}

function params(item: typeof schema.default.data.__schema.types[0], name: string) {
  return {
    ...item,
    objectReturnTypes: _.uniq([...item?.fields?.filter(x => x.type?.kind === "OBJECT" || x.type.ofType?.kind === "OBJECT").map(x => x.type?.name || x.type.ofType?.name) || [], name]),
    returnAndArgTypes: _.uniqBy([...item?.fields?.filter(x => (x.type?.ofType?.name && x.type?.ofType?.name.includes("ID")) || x.type?.name === "JSON").map(x => ({
      _name: x.type?.kind === 'SCALAR' ? x.type?.name?.toLowerCase() : _.snakeCase(x.type?.ofType?.name || x.type?.ofType?.ofType?.name),
      name: x.type?.kind === 'SCALAR' ? x.type?.name : x.type?.ofType?.name || x.type?.ofType?.ofType?.name,
    })) || [],
    ...item?.fields?.flatMap(x => x.args?.filter(x => (x.type.name || x.type.ofType?.name)?.includes("ID")).map(x => ({
      _name: x.type?.kind === 'SCALAR' ? x.type?.name?.toLowerCase() : _.snakeCase(x.type?.ofType?.name || x.type?.ofType?.ofType?.name),
      name: x.type?.kind === 'SCALAR' ? x.type?.name : x.type?.ofType?.name || x.type?.ofType?.ofType?.name,
    }))) || [],
  ], "name"),
    fields: item?.fields?.map(x => ({ ...x, 
      _name: _.snakeCase(x.name) === "import" ? "import_container" : _.snakeCase(x.name),
      description: x.description?.replaceAll("\n", "\n/// "),
      args: x.args?.map(x => ({ ...x,
        _name: _.snakeCase(x.name),
        type: {
        ...x.type,
        name: x.type.kind === "LIST" || x.type.ofType?.kind === 'LIST' ? `List(${x.type.ofType?.ofType?.name || x.type.ofType?.ofType?.ofType?.name})` : x.type.name || x.type.ofType?.name
      }})),
      type: {
        ...x.type,
        name: x.type.kind === "LIST" || x.type.ofType?.kind === 'LIST' ? `List(${x.type.ofType?.ofType?.name || x.type.ofType?.ofType?.ofType?.name})` : x.type.kind === "SCALAR" || x.type.kind === "ENUM" ? x.type.name : x.type.kind === "OBJECT" ? x.type.name : x.type.ofType?.name,
        isObject: x.type.kind === "OBJECT" || x.type.ofType?.kind === "OBJECT",
      },
      ofType: {
        ...x.type.ofType,
        name: x.type.kind === "LIST" || x.type.ofType?.kind === 'LIST' ? `List(${x.type.ofType?.ofType?.name || x.type.ofType?.ofType?.ofType?.name})` : x.type.kind === "SCALAR" || x.type.kind === "ENUM" ? x.type.name : x.type.kind === "OBJECT" ? x.type.name : x.type.ofType?.name,
        _name:  _.snakeCase(x.type.ofType?.name),
        isObject: x.type.kind === "OBJECT" || x.type.ofType?.kind === "OBJECT",
      }
    } 
    )) 
  };
}

function base_client_params(item: typeof schema.default.data.__schema.types[0], name: string) {
  return {
    ...item,
    returnAndArgTypes: _.uniqBy([...item?.fields?.filter(x => (x.type?.ofType?.name && x.type?.ofType?.name.includes("ID")) || x.type?.name === "JSON").map(x => ({
      _name: x.type?.kind === 'SCALAR' ? x.type?.name?.toLowerCase() : _.snakeCase(x.type?.ofType?.name || x.type?.ofType?.ofType?.name),
      name: x.type?.kind === 'SCALAR' ? x.type?.name : x.type?.ofType?.name || x.type?.ofType?.ofType?.name,
    })) || [],
    ...item?.fields?.flatMap(x => x.args?.filter(x => (x.type.name || x.type.ofType?.name)?.includes("ID")).map(x => ({
      _name: x.type?.kind === 'SCALAR' ? x.type?.name?.toLowerCase() : _.snakeCase(x.type?.ofType?.name || x.type?.ofType?.ofType?.name),
      name: x.type?.kind === 'SCALAR' ? x.type?.name : x.type?.ofType?.name || x.type?.ofType?.ofType?.name,
    }))) || [],
  ], "name"),
    fields: item?.fields?.map(x => ({ ...x, 
      _name: _.snakeCase(x.name) === "import" ? "import_container" : _.snakeCase(x.name),
      description: x.description?.replaceAll("\n", "\n/// "),
      args: x.args?.map(x => ({ ...x,
        _name: _.snakeCase(x.name),
        type: {
        ...x.type,
        name: x.type.kind === "LIST" || x.type.ofType?.kind === 'LIST' ? `List(${x.type.ofType?.ofType?.name || x.type.ofType?.ofType?.ofType?.name})` : x.type.name || x.type.ofType?.name
      }})),
      type: {
        ...x.type,
        name: x.type.kind === "LIST" || x.type.ofType?.kind === 'LIST' ? `List(${name})` : x.type.kind === "SCALAR" || x.type.kind === "ENUM" ? x.type.name : x.type.kind === "OBJECT" || x.type.ofType?.kind === 'OBJECT' ? name : x.type.ofType?.name,
        isObject: x.type.kind === "OBJECT" || x.type.ofType?.kind === "OBJECT",
      },
      ofType: {
        ...x.type.ofType,
        name: x.type.kind === "LIST" || x.type.ofType?.kind === 'LIST' ? `List(${name})` : x.type.kind === "SCALAR" || x.type.kind === "ENUM" ? x.type.name : x.type.kind === "OBJECT" || x.type.ofType?.kind === 'OBJECT' ? name : x.type.ofType?.name,
        _name:  _.snakeCase(x.type.ofType?.name),
        isObject: x.type.kind === "OBJECT" || x.type.ofType?.kind === "OBJECT",
      }
    } 
    )) 
  };
}

// Learn more at https://deno.land/manual/examples/module_metadata#concepts
if (import.meta.main) {
  await main();
}
