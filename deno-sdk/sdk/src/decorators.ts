// deno-lint-ignore-file no-unused-vars
export function func(
  // deno-lint-ignore no-explicit-any
  target: any,
  propertyKey: string,
  descriptor: PropertyDescriptor
) {}

export function object<T extends { new (...args: unknown[]): unknown }>(
  constructor: T
) {
  return constructor;
}
