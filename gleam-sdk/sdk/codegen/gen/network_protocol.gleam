/// Transport layer network protocol associated to a port.
///
pub type NetworkProtocol {
  TCP
  UDP
}

/// TCP (Transmission Control Protocol)
///
pub fn tcp() -> NetworkProtocol {
  TCP
}

/// UDP (User Datagram Protocol)
///
pub fn udp() -> NetworkProtocol {
  UDP
}
