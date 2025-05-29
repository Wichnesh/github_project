import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/branch_model.dart';
import '../../models/commit_model.dart';
import '../../repositories/github_repository.dart';
import 'repo_detail_event.dart';
import 'repo_detail_state.dart';

class RepoDetailBloc extends Bloc<RepoDetailEvent, RepoDetailState> {
  final GitHubRepository repository;

  RepoDetailBloc(this.repository) : super(RepoDetailInitial()) {
    on<LoadRepoDetail>(_onLoadRepoDetail);
  }

  void _onLoadRepoDetail(LoadRepoDetail event, Emitter<RepoDetailState> emit) async {
    emit(RepoDetailLoading());
    try {
      final branches = await repository.getBranches(event.owner, event.repo);

      final Map<String, List<CommitModel>> commitsMap = {};

      for (final branch in branches) {
        final commits = await repository.getCommits(event.owner, event.repo, branch.name);
        commitsMap[branch.name] = commits;
      }

      emit(RepoDetailLoaded(commitsMap));
    } catch (e) {
      emit(RepoDetailError('Failed to load repository details'));
    }
  }
}
