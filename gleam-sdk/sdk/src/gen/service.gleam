import gen/service_id.{type ServiceId}

pub type Service {
  Service(id: ServiceId)
}

pub fn new(id: ServiceId) -> Service {
  Service(id)
}
