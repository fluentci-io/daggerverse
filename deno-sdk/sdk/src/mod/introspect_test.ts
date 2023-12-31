import { assertEquals } from "../../deps.ts";
import introspect from "./introspect.ts";

Deno.test("introspect 'fixtures/hello.ts'", () => {
  const metadata = introspect("fixtures/hello.ts");
  assertEquals(metadata.length, 5);
  assertEquals(metadata, [
    {
      functionName: "hello",
      doc: 'Returns "Hello {name}"',
      parameters: [
        { doc: "name", name: "name", type: "string", optional: true },
      ],
      returnType: "string",
    },
    {
      functionName: "add",
      doc: "Returns x + y",
      parameters: [
        { doc: "first number", name: "x", type: "number", optional: false },
        { doc: "second number", name: "y", type: "number", optional: false },
      ],
      returnType: "number",
    },
    {
      functionName: "join",
      doc: "Returns string joined by ','",
      parameters: [
        {
          doc: "array of strings",
          name: "a",
          type: "string[]",
          optional: false,
        },
      ],
      returnType: "string",
    },
    {
      functionName: "container",
      doc: "function example with Container as parameter",
      parameters: [
        {
          doc: "Container instance",
          name: "_c",
          type: "Container",
          optional: false,
        },
      ],
      returnType: "void",
    },
    {
      functionName: "greet",
      doc: 'Returns "Hello {name}"',
      parameters: [
        { doc: "name", name: "name", type: "string", optional: true },
      ],
      returnType: "string",
    },
  ]);
});

Deno.test("introspect 'fixtures/mod.ts'", () => {
  const metadata = introspect("fixtures/mod.ts");
  assertEquals(metadata.length, 5);
  assertEquals(metadata, [
    {
      functionName: "hello",
      doc: 'Returns "Hello {name}"',
      parameters: [
        { doc: "name", name: "name", type: "string", optional: true },
      ],
      returnType: "string",
    },
    {
      functionName: "add",
      doc: "Returns x + y",
      parameters: [
        { doc: "first number", name: "x", type: "number", optional: false },
        { doc: "second number", name: "y", type: "number", optional: false },
      ],
      returnType: "number",
    },
    {
      functionName: "join",
      doc: "Returns string joined by ','",
      parameters: [
        {
          doc: "array of strings",
          name: "a",
          type: "string[]",
          optional: false,
        },
      ],
      returnType: "string",
    },
    {
      functionName: "container",
      doc: "function example with Container as parameter",
      parameters: [
        {
          doc: "Container instance",
          name: "_c",
          type: "Container",
          optional: false,
        },
      ],
      returnType: "void",
    },
    {
      functionName: "greet",
      doc: 'Returns "Hello {name}"',
      parameters: [
        { doc: "name", name: "name", type: "string", optional: true },
      ],
      returnType: "string",
    },
  ]);
});
