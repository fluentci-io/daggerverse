import gen/directory_id.{type DirectoryId}

pub type Directory {
  Directory(id: DirectoryId)
}

pub fn new(id: DirectoryId) -> Directory {
  Directory(id)
}
