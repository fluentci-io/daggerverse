import gen/cache_volume_id.{type CacheVolumeID}
import gen/types.{type CacheVolume}
import utils.{compute_query}
import gleam/list
import gleam/dict
import gen/query_tree

pub fn id(cache_volume: CacheVolume) -> CacheVolumeID {
  let assert Ok(response) =
    compute_query(
      list.concat([
        cache_volume.query_tree,
        [query_tree.new("stdout", dict.new())],
      ]),
    )
  response
}
