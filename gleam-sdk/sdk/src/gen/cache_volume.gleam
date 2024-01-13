import gen/cache_volume_id.{type CacheVolumeId}
import gen/query_tree.{type QueryTree}

pub type CacheVolume {
  CacheVolume(id: CacheVolumeId, query_tree: List(QueryTree))
}

pub fn new(id: CacheVolumeId, query_tree: List(QueryTree)) -> CacheVolume {
  CacheVolume(id, query_tree)
}

pub fn id(cache_volume: CacheVolume) -> CacheVolumeId {
  cache_volume.id
}
