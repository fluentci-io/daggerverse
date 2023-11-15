import { Client } from "./src/client.ts";

export default Client;
export * from "./src/client.ts";
export {
  DaggerSDKError,
  UnknownDaggerError,
  DockerImageRefValidationError,
  EngineSessionConnectParamsParseError,
  ExecError,
  GraphQLRequestError,
  InitEngineSessionBinaryError,
  TooManyNestedObjectsError,
  EngineSessionError,
  EngineSessionConnectionTimeoutError,
  NotAwaitedRequestError,
  ERROR_CODES,
  gql,
  GraphQLClient,
} from "./deps.ts";
export { connect } from "./src/connect.ts";
export type { CallbackFct } from "./src/connect.ts";
