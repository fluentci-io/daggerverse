// deno-lint-ignore-file no-explicit-any

export default function invoke<F extends (...args: any[]) => any>(
  func: F,
  ...args: Parameters<F>
): ReturnType<F> {
  return func(...args);
}
