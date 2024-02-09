/// Compression algorithm to use for image layers.
///
pub type ImageLayerCompression {
  EStarGZ
  Gzip
  Uncompressed
  Zstd
}

pub fn e_star_gz() -> ImageLayerCompression {
  EStarGZ
}

pub fn gzip() -> ImageLayerCompression {
  Gzip
}

pub fn uncompressed() -> ImageLayerCompression {
  Uncompressed
}

pub fn zstd() -> ImageLayerCompression {
  Zstd
}
