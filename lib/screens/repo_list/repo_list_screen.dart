import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/repo_list/repo_list_bloc.dart';
import '../../blocs/repo_list/repo_list_event.dart';
import '../../blocs/repo_list/repo_list_state.dart';
import '../../repositories/github_repository.dart';
import '../../models/repo_model.dart';
import '../login/login_screen.dart';

class RepoListScreen extends StatelessWidget {
  const RepoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RepoListBloc(GitHubRepository())..add(FetchRepos()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Your GitHub Repositories"),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthBloc>().add(LoggedOut());
                },
              )
            ],
          ),
            body: BlocBuilder<RepoListBloc, RepoListState>(
              builder: (context, state) {
                if (state is RepoListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RepoListLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.repos.length,
                    itemBuilder: (context, index) {
                      final RepoModel repo = state.repos[index];
                      final isPrivate = repo.visibility.toLowerCase() == 'private';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          title: Text(
                            repo.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Default Branch: ${repo.defaultBranch}'),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isPrivate ? Colors.red[100] : Colors.green[100],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isPrivate ? 'Private' : 'Public',
                                    style: TextStyle(
                                      color: isPrivate ? Colors.red[800] : Colors.green[800],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            // TODO: Navigate to detail screen
                          },
                        ),
                      );
                    },
                  );
                } else if (state is RepoListError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            )
        ),
      ),
    );
  }
}
