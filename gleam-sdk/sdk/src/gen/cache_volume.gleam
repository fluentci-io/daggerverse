import gen/cache_volume_id.{type CacheVolumeId}

pub type CacheVolume(t) {
  CacheVolume(client: t, id: CacheVolumeId)
}

pub fn id(cache_volume: CacheVolume(t)) -> CacheVolumeId {
  cache_volume.id
}
