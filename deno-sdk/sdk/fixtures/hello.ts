import { Container } from "../src/client.ts";

/**
 * @function
 * @description Returns "Hello {name}"
 * @param {string} name name
 * @returns {string}
 */
export function hello(name?: string): string {
  return `Hello ${name}`;
}

/**
 * @function
 * @description Returns x + y
 * @param {number} x first number
 * @param {number} y second number
 * @returns {number}
 */
export function add(x: number, y: number): number {
  return x + y;
}

/**
 * @function
 * @description Returns string joined by ','
 * @param {string[]} a array of strings
 * @returns {string}
 */
export function join(a: string[]): string {
  return a.join(",");
}

/**
 * @function
 * @description function example with Container as parameter
 * @param {Container} _c Container instance
 * @returns {void}
 */
export function container(_c: Container) {}

/**
 * @function
 * @description Returns "Hello {name}"
 * @param {string} name name
 * @returns {string}
 */
export function greet(name = "World"): string {
  return `Hello ${name}`;
}
