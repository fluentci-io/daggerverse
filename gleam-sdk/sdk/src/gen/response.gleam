import gen/cache_volume_id.{type CacheVolumeID}
import gen/container_id.{type ContainerID}
import gen/file_id.{type FileID}
import gen/directory_id.{type DirectoryID}

pub type Response {
  CacheVolume(id: CacheVolumeID)
  CheckVersionCompatibility(value: Bool)
  Container(id: ContainerID)
  File(id: FileID)
  Directory(id: DirectoryID)
  CurrentFunctionCall(value: String)
  Function(value: String)
  CurrentModule(value: String)
  CurrentTypeDefs(value: String)
  DefaultPlatform(value: String)
  GeneratedCode(value: String)
  GitRepository(value: String)
  Host(value: String)
  Http(value: String)
  LoadCacheVolumeFromID(value: String)
  LoadContainerFromID(value: String)
  LoadDirectoryFromID(value: String)
  LoadFileFromID(value: String)
  LoadFunctionArgumentFromID(value: String)
  LoadFunctionFromID(value: String)
  LoadGeneratedCodeFromID(value: String)
  LoadGitRefFromID(value: String)
  LoadGitRepositoryFromID(value: String)
  LoadModuleFromID(value: String)
  LoadSecretFromID(value: String)
  LoadServiceFromID(value: String)
  LoadSocketFromID(value: String)
  LoadTypeDefFromID(value: String)
  Module(value: String)
  ModuleConfig(value: String)
  Pipeline(value: String)
  Secret(value: String)
  SetSecret(value: String)
  Socket(value: String)
  TypeDef(value: String)
}
