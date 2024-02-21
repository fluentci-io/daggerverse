import { assertEquals } from "../../deps.ts";
import introspect from "./introspect.ts";

Deno.test("introspect 'fixtures/hello.ts'", () => {
  const metadata = introspect("fixtures/hello.ts");
  assertEquals(metadata.length, 5);
  assertEquals(metadata, [
    {
      functionName: "hello",
      doc: 'Returns "Hello {name}"',
      moduleDescription: "This module contains functions for testing",
      parameters: [
        {
          doc: "name",
          name: "name",
          type: "string",
          optional: true,
          defaultValue: undefined,
        },
      ],
      returnType: "string",
    },
    {
      functionName: "add",
      doc: "Returns x + y",
      moduleDescription: "This module contains functions for testing",
      parameters: [
        {
          doc: "first number",
          name: "x",
          type: "number",
          optional: false,
          defaultValue: undefined,
        },
        {
          doc: "second number",
          name: "y",
          type: "number",
          optional: false,
          defaultValue: undefined,
        },
      ],
      returnType: "number",
    },
    {
      functionName: "join",
      doc: "Returns string joined by ','",
      moduleDescription: "This module contains functions for testing",
      parameters: [
        {
          doc: "array of strings",
          name: "a",
          type: "string[]",
          optional: false,
          defaultValue: undefined,
        },
      ],
      returnType: "string",
    },
    {
      functionName: "container",
      doc: "function example with Container as parameter",
      moduleDescription: "This module contains functions for testing",
      parameters: [
        {
          doc: "Container instance",
          name: "_c",
          type: "Container",
          optional: false,
          defaultValue: undefined,
        },
      ],
      returnType: "void",
    },
    {
      functionName: "greet",
      doc: 'Returns "Hello {name}"',
      moduleDescription: "This module contains functions for testing",
      parameters: [
        {
          doc: "name",
          name: "name",
          type: "string",
          optional: true,
          defaultValue: '"World"',
        },
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
      moduleDescription: "This module contains functions for testing",
      parameters: [
        {
          doc: "name",
          name: "name",
          type: "string",
          optional: true,
          defaultValue: undefined,
        },
      ],
      returnType: "string",
    },
    {
      functionName: "add",
      doc: "Returns x + y",
      moduleDescription: "This module contains functions for testing",
      parameters: [
        {
          doc: "first number",
          name: "x",
          type: "number",
          optional: false,
          defaultValue: undefined,
        },
        {
          doc: "second number",
          name: "y",
          type: "number",
          optional: false,
          defaultValue: undefined,
        },
      ],
      returnType: "number",
    },
    {
      functionName: "join",
      doc: "Returns string joined by ','",
      moduleDescription: "This module contains functions for testing",
      parameters: [
        {
          doc: "array of strings",
          name: "a",
          type: "string[]",
          optional: false,
          defaultValue: undefined,
        },
      ],
      returnType: "string",
    },
    {
      functionName: "container",
      doc: "function example with Container as parameter",
      moduleDescription: "This module contains functions for testing",
      parameters: [
        {
          doc: "Container instance",
          name: "_c",
          type: "Container",
          optional: false,
          defaultValue: undefined,
        },
      ],
      returnType: "void",
    },
    {
      functionName: "greet",
      doc: 'Returns "Hello {name}"',
      moduleDescription: "This module contains functions for testing",
      parameters: [
        {
          doc: "name",
          name: "name",
          type: "string",
          optional: true,
          defaultValue: '"World"',
        },
      ],
      returnType: "string",
    },
  ]);
});
