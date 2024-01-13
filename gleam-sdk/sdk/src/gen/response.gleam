import gen/cache_volume_id.{type CacheVolumeId}
import gen/container_id.{type ContainerId}
import gen/file_id.{type FileId}
import gen/directory_id.{type DirectoryId}

pub type CacheVolume {
  CacheVolume(id: CacheVolumeId)
}

pub type CheckVersionCompatibility {
  CheckVersionCompatibility(value: Bool)
}

pub type Container {
  Container(id: ContainerId)
}

pub type File {
  File(id: FileId)
}

pub type Directory {
  Directory(id: DirectoryId)
}

pub type CurrentFunctionCall {
  CurrentFunctionCall(value: String)
}

pub type Function {
  Function(value: String)
}

pub type CurrentModule {
  CurrentModule(value: String)
}

pub type CurrentTypeDefs {
  CurrentTypeDefs(value: String)
}

pub type DefaultPlatform {
  DefaultPlatform(value: String)
}

pub type GeneratedCode {
  GeneratedCode(value: String)
}

pub type GitRepository {
  GitRepository(value: String)
}

pub type Host {
  Host(value: String)
}

pub type Http {
  Http(value: String)
}

pub type LoadCacheVolumeFromID {
  LoadCacheVolume(value: String)
}

pub type LoadContainerFromID {
  LoadContainer(value: String)
}

pub type LoadDirectoryFromID {
  LoadDirectory(value: String)
}

pub type LoadFileFromID {
  LoadFile(value: String)
}
