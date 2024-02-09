import gen/directory_id.{type DirectoryID}

pub type ClientDirectoryOpts {
  ClientDirectoryOpts(id: DirectoryID)
}

pub fn new(id: DirectoryID) -> ClientDirectoryOpts {
  ClientDirectoryOpts(id)
}
