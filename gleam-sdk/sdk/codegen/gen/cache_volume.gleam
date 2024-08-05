import gen/types.{type CacheVolume}
import gen/cache_volume_id.{type CacheVolumeID}
import gen/query_tree
import gen/base_client
import utils.{compute_query}
import gleam/list
import gleam/dict
import gleam/dynamic

pub fn id(cache_volume: CacheVolume) -> CacheVolumeID {
  let assert Ok(response) =
    compute_query(
      list.concat([cache_volume.query_tree, [query_tree.new("id", dict.new())]]),
    )
  response
}
