import { Client, DirectoryID } from "../client.ts";
import { Metadata } from "./introspect.ts";

export function getReturnType(metadata: Metadata[], functionName: string) {
  return metadata.find((m) => m.functionName === functionName)?.returnType;
}

export function getArgsType(
  metadata: Metadata[],
  functionName: string
): {
  name: string;
  type: string;
  optional: boolean;
  doc: string;
  defaultValue?: string;
}[] {
  return (
    metadata.find((m) => m.functionName === functionName)?.parameters || []
  );
}

export function getObjectReturnType(
  metadata: Metadata[],
  functionName: string
): string | undefined {
  const returnType = metadata.find(
    (m) => m.functionName === functionName
  )?.returnType;
  if (!returnType) {
    return;
  }
  const containerRegex = /\bContainer\b/;
  const fileRegex = /\bFile\b/;
  const directoryRegex = /\bDirectory\b/;
  const secretRegex = /\bSecret\b/;
  const serviceRegex = /\bService\b/;

  if (containerRegex.test(returnType)) {
    return "Container";
  }

  if (fileRegex.test(returnType)) {
    return "File";
  }

  if (directoryRegex.test(returnType)) {
    return "Directory";
  }

  if (secretRegex.test(returnType)) {
    return "Secret";
  }

  if (serviceRegex.test(returnType)) {
    return "Service";
  }
}

export function getObjectArgType(
  metadata: Metadata[],
  functionName: string,
  argName: string
): string | undefined {
  const args = getArgsType(metadata, functionName);
  const containerRegex = /\bContainer\b/;
  const fileRegex = /\bFile\b/;
  const directoryRegex = /\bDirectory\b/;
  const secretRegex = /\bSecret\b/;
  const serviceRegex = /\bService\b/;

  const arg = args.find((a) => a.name === argName);
  if (!arg) {
    return;
  }

  const argType = arg.type;
  if (containerRegex.test(argType)) {
    return "Container";
  }

  if (fileRegex.test(argType)) {
    return "File";
  }

  if (directoryRegex.test(argType)) {
    return "Directory";
  }

  if (secretRegex.test(argType)) {
    return "Secret";
  }

  if (serviceRegex.test(argType)) {
    return "Service";
  }
}

export const getDirectory = async (
  client: Client,
  src: string | undefined = "."
) => {
  if (src === '"."' || src === ".") {
    return undefined;
  }
  try {
    const directory = client.loadDirectoryFromID(src as DirectoryID);
    const id = await directory.id();
    return `"${id.toString()}"`;
  } catch (_) {
    const id = await client
      .host()
      .directory(src as string)
      .id();
    return `"${id.toString()}"`;
  }
};
