/// Mediatypes to use in published or exported image metadata.
///
pub type ImageMediaTypes {
  DockerMediaTypes
  OCIMediaTypes
}

pub fn docker_media_types() -> ImageMediaTypes {
  DockerMediaTypes
}

pub fn oci_media_types() -> ImageMediaTypes {
  OCIMediaTypes
}
