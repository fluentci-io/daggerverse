import Client from "../../deps.ts";
import { connect } from "../../sdk/connect.ts";

export enum Job {
  hello = "hello",
}

export const exclude = [];

export const hello = async (src = ".") => {
  let result = "";
  await connect(async (client: Client) => {
    const context = client.host().directory(src);
    const answer = await client.base().hello(".");
    const ctr = client
      .pipeline("hello")
      .container()
      .from("alpine")
      .withDirectory("/app", context)
      .withWorkdir("/app")
      .withExec(["echo", `'Hello, world!' ${answer}`]);

    result = await ctr.stdout();
  });

  return result.replace(/(\r\n|\n|\r)/gm, "");
};

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
