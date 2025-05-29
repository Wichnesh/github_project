import '../../models/branch_model.dart';
import '../../models/commit_model.dart';

class RepoDetailState {}

class RepoDetailInitial extends RepoDetailState {}

class RepoDetailLoading extends RepoDetailState {}

class RepoDetailLoaded extends RepoDetailState {
  final Map<String, List<CommitModel>> commitsPerBranch;

  RepoDetailLoaded(this.commitsPerBranch);
}

class RepoDetailError extends RepoDetailState {
  final String message;
  RepoDetailError(this.message);
}
