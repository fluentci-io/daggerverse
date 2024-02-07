import Client, { Directory } from "../../deps.ts";
import { connect } from "../../sdk/connect.ts";
import { getDirectory } from "./lib.ts";

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
  let result = "";
  await connect(async (client: Client) => {
    const context = await getDirectory(client, src);
    const ctr = client
      .pipeline("hello")
      .container()
      .from("alpine")
      .withDirectory("/app", context)
      .withWorkdir("/app")
      .withExec(["echo", "'Hello, world!'"])
      .withExec(["echo", "'Hello, again!\nhello'"]);

    result = await ctr.stdout();
  });

  return result;
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
