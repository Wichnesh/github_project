import 'package:flutter_bloc/flutter_bloc.dart';
import 'repo_list_event.dart';
import 'repo_list_state.dart';
import '../../repositories/github_repository.dart';

class RepoListBloc extends Bloc<RepoListEvent, RepoListState> {
  final GitHubRepository repository;

  RepoListBloc(this.repository) : super(RepoListInitial()) {
    on<FetchRepos>(_onFetchRepos);
  }

  void _onFetchRepos(FetchRepos event, Emitter<RepoListState> emit) async {
    emit(RepoListLoading());
    try {
      final repos = await repository.getUserRepos();
      emit(RepoListLoaded(repos));
    } catch (e) {
      emit(RepoListError('Error loading repositories'));
    }
  }
}
