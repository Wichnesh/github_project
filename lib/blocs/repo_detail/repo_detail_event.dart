abstract class RepoDetailEvent {}

class LoadRepoDetail extends RepoDetailEvent {
  final String owner;
  final String repo;

  LoadRepoDetail({required this.owner, required this.repo});
}
