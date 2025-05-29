import '../../models/repo_model.dart';

abstract class RepoListState {}

class RepoListInitial extends RepoListState {}

class RepoListLoading extends RepoListState {}

class RepoListLoaded extends RepoListState {
  final List<RepoModel> repos;
  RepoListLoaded(this.repos);
}

class RepoListError extends RepoListState {
  final String message;
  RepoListError(this.message);
}
