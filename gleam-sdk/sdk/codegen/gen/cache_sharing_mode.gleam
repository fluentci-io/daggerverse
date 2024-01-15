/// Sharing mode of the cache volume.
///
pub type CacheSharingMode {
  LOCKED
  PRIVATE
  SHARED
}

/// Shares the cache volume amongst many build pipelines,
/// but will serialize the writes
///
pub fn locked() -> CacheSharingMode {
  LOCKED
}

/// Keeps a cache volume for a single build pipeline
///
pub fn private() -> CacheSharingMode {
  PRIVATE
}

/// Shares the cache volume amongst many build pipelines
///
pub fn shared() -> CacheSharingMode {
  SHARED
}
