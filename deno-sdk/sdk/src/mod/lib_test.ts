import { assertEquals } from "../../deps.ts";
import {
  getReturnType,
  getObjectReturnType,
  getArgsType,
  getObjectArgType,
} from "./lib.ts";

Deno.test("getReturnType", () => {
  assertEquals(getReturnType([], "foo"), undefined);
  assertEquals(
    getReturnType(
      [
        {
          functionName: "hello",
          doc: 'Returns "Hello {name}"',
          parameters: [{ name: "name", type: "string", optional: true }],
          returnType: "string",
        },
      ],
      "hello"
    ),
    "string"
  );
  assertEquals(
    getReturnType(
      [
        {
          functionName: "container",
          doc: "function example with Container as parameter",
          parameters: [{ name: "_c", type: "Container", optional: false }],
          returnType: "Container",
        },
      ],
      "container"
    ),
    "Container"
  );
});

Deno.test("getObjectReturnType", () => {
  assertEquals(
    getObjectReturnType(
      [
        {
          functionName: "container",
          doc: "function example with Container as parameter",
          parameters: [{ name: "_c", type: "Container", optional: false }],
          returnType: "Container",
        },
      ],
      "container"
    ),
    "Container"
  );
  assertEquals(
    getObjectReturnType(
      [
        {
          functionName: "container",
          doc: "function example with Container as parameter",
          parameters: [{ name: "_c", type: "Container", optional: false }],
          returnType: "Container | string",
        },
      ],
      "container"
    ),
    "Container"
  );
  assertEquals(
    getObjectReturnType(
      [
        {
          functionName: "container",
          doc: "function example with Container as parameter",
          parameters: [{ name: "_c", type: "Container", optional: false }],
          returnType: "string | Container",
        },
      ],
      "container"
    ),
    "Container"
  );
});

Deno.test("getArgsType", () => {
  assertEquals(
    getArgsType(
      [
        {
          functionName: "hello",
          doc: 'Returns "Hello {name}"',
          parameters: [{ name: "name", type: "string", optional: true }],
          returnType: "string",
        },
      ],
      "hello"
    ),
    [{ name: "name", type: "string", optional: true }]
  );
  assertEquals(
    getObjectArgType(
      [
        {
          functionName: "container",
          doc: "function example with Container as parameter",
          parameters: [{ name: "_c", type: "Container", optional: false }],
          returnType: "Container",
        },
      ],
      "container",
      "_c"
    ),
    "Container"
  );
});

Deno.test("getObjectArgType", () => {
  assertEquals(
    getObjectArgType(
      [
        {
          functionName: "container",
          doc: "function example with Container as parameter",
          parameters: [{ name: "_c", type: "Container", optional: false }],
          returnType: "Container",
        },
      ],
      "container",
      "_c"
    ),
    "Container"
  );
  assertEquals(
    getObjectArgType(
      [
        {
          functionName: "container",
          doc: "function example with Container as parameter",
          parameters: [
            { name: "_c", type: "Container", optional: false },
            {
              name: "src",
              type: "string | Directory | undefined",
              optional: false,
            },
          ],
          returnType: "Container",
        },
      ],
      "container",
      "src"
    ),
    "Directory"
  );
});
