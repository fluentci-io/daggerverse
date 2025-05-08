import gen/container_id.{type ContainerID}
import gen/platform.{type Platform}
import gleam/option.{type Option}

pub type ClientContainerOpts {
  ClientContainerOpts(id: Option(ContainerID), platform: Option(Platform))
}

pub fn new(
  id: Option(ContainerID),
  platform: Option(Platform),
) -> ClientContainerOpts {
  ClientContainerOpts(id, platform)
}
