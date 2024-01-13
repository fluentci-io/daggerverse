import gen/file_id.{type FileId}

pub type File {
  File(id: FileId)
}

pub fn new(id: FileId) -> File {
  File(id)
}
