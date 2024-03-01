import { Directory } from "../../deps.ts";
import { getDirectory } from "./lib.ts";
import { dag } from "../../sdk/client.gen.ts";

export enum Job {
  hello = "hello",
}

export const exclude = [];

/**
 * @function
 * @description Say hello
 * @param {string | Directory | undefined} src
 * @returns {string}
 */
export async function hello(
  src: string | Directory | undefined = "."
): Promise<string> {
  const context = await getDirectory(src);
  const ctr = dag
    .pipeline("hello")
    .container()
    .from("alpine")
    .withDirectory("/app", context)
    .withWorkdir("/app")
    .withExec(["echo", "'Hello, world!'"])
    .withExec(["echo", "'Hello, again!\nhello'"]);

  return ctr.stdout();
}

export type JobExec = (src?: string) =>
  | Promise<string>
  | ((
      src?: string,
      options?: {
        ignore: string[];
      }
    ) => Promise<string>);

export const runnableJobs: Record<Job, JobExec> = {
  [Job.hello]: hello,
};

export const jobDescriptions: Record<Job, string> = {
  [Job.hello]: "Say hello",
};
