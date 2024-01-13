import gen/socket_id.{type SocketId}

pub type Socket {
  Socket(id: SocketId)
}

pub fn new(id: SocketId) -> Socket {
  Socket(id)
}
