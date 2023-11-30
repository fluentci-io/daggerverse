import { Container } from "../src/client.ts";

/**
 * @function
 * @description Returns "Hello {name}"
 * @param a {string}
 * @returns {string}
 */
export function hello(name?: string): string {
  return `Hello ${name}`;
}

/**
 * @function
 * @description Returns x + y
 * @param x {number}
 * @param y {number}
 * @returns {number}
 */
export function add(x: number, y: number): number {
  return x + y;
}

/**
 * @function
 * @description Returns string joined by ','
 * @param a {string[]}
 * @returns {string}
 */
export function join(a: string[]): string {
  return a.join(",");
}

/**
 * @function
 * @description function example with Container as parameter
 * @param _c {Container}
 * @returns {void}
 */
export function container(_c: Container) {}

/**
 * @function
 * @description Returns "Hello {name}"
 * @param a {string}
 * @returns {string}
 */
export function greet(name = "World"): string {
  return `Hello ${name}`;
}
