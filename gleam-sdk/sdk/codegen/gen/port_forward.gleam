/// Port forwarding rules for tunneling network traffic.
///
pub type PortForward {
  PortForward(backend: Int, frontend: Int, protocol: NetworkProtocol)
}

pub fn new(
  backend: Int,
  frontend: Int,
  protocol: NetworkProtocol,
) -> PortForward {
  PortForward(backend, frontend, protocol)
}
