import gen/container_id.{type ContainerId}

pub type Container {
  Container(id: ContainerId)
}

pub fn id(container: Container) -> ContainerId {
  container.id
}

pub fn from(container: Container, name: String) -> Container {
  container
}

pub fn with_exec(container: Container, exec: List(String)) -> Container {
  container
}

pub fn stdout(container: Container) -> String {
  "stdout"
}
