import gen/git_repository_id.{type GitRepositoryId}

pub type ClientGitOpts {
  ClientGitOpts
}

pub type GitRepository {
  GitRepository(id: GitRepositoryId)
}

pub fn new(id: GitRepositoryId) -> GitRepository {
  GitRepository(id)
}
