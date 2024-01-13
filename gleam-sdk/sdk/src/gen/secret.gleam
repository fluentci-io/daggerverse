import gen/secret_id.{type SecretId}

pub type Secret {
  Secret(id: SecretId)
}

pub fn new(id: SecretId) -> Secret {
  Secret(id)
}
